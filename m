Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A016E41E34A
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 23:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344091AbhI3VYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 17:24:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:17226 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229701AbhI3VYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 17:24:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="212550050"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="212550050"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 14:23:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="555963036"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Sep 2021 14:23:05 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 14:23:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 30 Sep 2021 14:23:04 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 30 Sep 2021 14:23:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmLQFE4ISZ+hhxTUl/84t5bBcJEVum0Gn88ZX1fdWX/CT/XQHzV/d1UJh9cicGGsvE8bD2xXp+bPxDuft7PEAfAl93RlB7k7W2NeU75OGjRdkq6WgfTOJm1xd/NlEoVlYSXbLC9hB1hKNshmmmKrlZ9ETeNWGC+15StMgalTXW7i8QHocjdReQq/vWVh+H36cXFthCG5ggnl5J2LJznBKNbQvS/vZIZG59wE0a59NSsBWgd3uS5eLFULva0EzReSP1JpxTutAa8PR7GezlmpCn/0hkmOtwFxIXYxrVoDXzTkwCzr0fvVLvhH2CQIyE/BC55vWnOSVQ8HjOEaZcCHeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kYoNCT+5CzbjBhu/PG+bteWAqptN8xo55+iJ1tOKM4g=;
 b=TeJg86LbHGEIaLU1AVi+7fq/MkEvJl5CKSW7fBSZeYvBxMqs7CGvARQ+qx/08w5hV83DkSCcYm11sA7/RWbpXoEjSNk8ew0W6/JWv5kvBGz/L9A5UUI9t+/HmrIUIuYrCnB1U08nrzReEE4akdVV0uR1fERNVy71iaG075itRqWkDhuwPEb+e8rq4J+jPWeaxP+mk4a1e+qsN0+m+7fOi2lWWwArcX8KHon0ukEPfwPnZ8FY+15RrdmuXtLuDGZ35WYTb0+OUjB6hMFtFV9HaF9HU1ZLIqWVrgH1sr6oqoi4Gp52w0ADJc16H9XAwTtkJz78wn6jLD9tQ+3eCMYFBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYoNCT+5CzbjBhu/PG+bteWAqptN8xo55+iJ1tOKM4g=;
 b=UkhoJfpz2Qms/3ZIiGBUBmusryqnVyOMoj0ohbvAhJUcVjRP87GGV3u0YYPVAQpOwRauxEiDsrgizdcd5w8h2bkLmexUchsUXZIgyHLVnFWYmB5Ls4oAkpqBC37uhmbtxbBXtCWUwniNPAN24c5d15o9roOByNiScd+zoQPm4u8=
Received: from PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14)
 by PH0PR11MB4840.namprd11.prod.outlook.com (2603:10b6:510:43::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 30 Sep
 2021 21:23:03 +0000
Received: from PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::21ee:3ed8:d6c2:29b2]) by PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::21ee:3ed8:d6c2:29b2%9]) with mapi id 15.20.4566.014; Thu, 30 Sep 2021
 21:23:02 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Benc <jbenc@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH net v2] i40e: fix endless loop under
 rtnl
Thread-Topic: [Intel-wired-lan] [PATCH net v2] i40e: fix endless loop under
 rtnl
Thread-Index: AQHXqUZWGtY/N9egjUCevcX6BkSdk6u9MBCw
Date:   Thu, 30 Sep 2021 21:23:02 +0000
Message-ID: <PH0PR11MB50959F0358EEED7AB520D4C5D6AA9@PH0PR11MB5095.namprd11.prod.outlook.com>
References: <452ff4ddfef7fc8f558a8c8eb7a8050688760e11.1631609537.git.jbenc@redhat.com>
In-Reply-To: <452ff4ddfef7fc8f558a8c8eb7a8050688760e11.1631609537.git.jbenc@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ce10040-99d2-4db8-ff9b-08d984587c74
x-ms-traffictypediagnostic: PH0PR11MB4840:
x-microsoft-antispam-prvs: <PH0PR11MB4840EB37FAB72667FDC96268D6AA9@PH0PR11MB4840.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LgAdSl5+GpMqmEzpZkJW1YHM5WTGzaKgcszuvUhURGyr6QN0m01qZjS58ncwN7QmhvaE5NfCLNakfvZRdS3/Bqf9+nL3gDqFkPki1MhWUoEXwkRqd6qmqjw27vpSl3CwJh/kobDjr18rRP2Y0M2ZmDWyiTCoqwPQCMV+m9VU9cgDbkBfp+/qyWxavLp3KDipUGsOCcxPPmQu3FphlRMVhTafkMcdbEele/s3baYE4V7oMQlwSAY4dk0xfakJuKjYlSw4mPsrZQqk8Rc51H8rDPLGnkaauwmroD5PB8+YBuoeKvBu1zLoXrxHsR+wHPd2zwPIpaHkWicZGkjMERBWdzsnd4G9IOl7ZzAJQKoo2RmIJPKQSfvblfibK3J2HvdRkYy24/XlBTY6xY1PEdYN2vGUC8tMGqpPee92feLPdgLCQIAvDVv3FiNi0Aw3ypqazKhhaWs/IoA69lEB/InAmMyN5Kz4BOw/1tiAsX/MuSml6MB93m8C/f3WUpDKWtc7dqM8vOndDLksez2w6n+tIPvnFTeUwCDr5HSJq2F3jJBGH+0LPr3svuprsdTLF0yitWg6A+bvCbo/quhduI5HTaOHI6gajbUb1FkzaWXZ8r6kXMuZLExQyFaj2bvYkJdTxKUndZxHFKOZr1pbbfULoZi3/N8eVCgyeocx2O69SsxzV4WjALX0XOFVm0Pg3nRjXseKOkeIvvnLhN4ircWSfJePqYhak05gMV31LSZBgiR3sAMG50ExV29KTswjj6AQmUGVH3iWRPpb7k1CEuly7Snd9YGnyABrs6OMDTMe0PE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(33656002)(66946007)(38100700002)(76116006)(316002)(7696005)(2906002)(4326008)(5660300002)(6506007)(966005)(55016002)(110136005)(9686003)(64756008)(38070700005)(26005)(8676002)(508600001)(86362001)(66556008)(71200400001)(66446008)(122000001)(52536014)(8936002)(186003)(53546011)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T78wFYIcBAvBJNX6ttWw4RT8jdBGb5M8ULk18o11Erwox8zfUPXplcNDLeyL?=
 =?us-ascii?Q?kxAngZsxy6fvifFd1Iwa90n/E2UuaNavQS0zJwxPXeN9PpvXksbr/zO+fg/D?=
 =?us-ascii?Q?pEBrRaH35CXDhXZw2aItyoQgnvhliWfsQeEf4FRGHWPTJNOyvrEXUpA8hLHp?=
 =?us-ascii?Q?qXd1p9/wlAwlct8Gf6bjUnYDca/0ZOuGTGK2fKgAfii6og4XnyWRSmOPBys0?=
 =?us-ascii?Q?yDqpiQDD8lI6iiljcouMXBdQb9sohWyy0lcvF4XFLpQWG55ee/4TC1mUqlDJ?=
 =?us-ascii?Q?NfEo/6b63Fp1zIP1jPpDGdeahgjV+R+DrtSKwJJlm1Giajpr8zXVJ3xG27Df?=
 =?us-ascii?Q?JBVyQbdvMZgEPjIXIBMELML/GuhupRgJJKfrSZQ9iVwVgcTV7EReMX9AHvq5?=
 =?us-ascii?Q?4eOUGt5SKn8SQhflJjb/BHZt7GfafpdSmQgTBszAk2R8VnJgy6tTMJOIoQDk?=
 =?us-ascii?Q?48sSK41qoaxv/307AyLdYB/8//WwHMc6Ig6a1HPeI73OOyz9dq6vSCmx/zZj?=
 =?us-ascii?Q?ziBGqevMkG590cOlwxNTwKDFuPI9qeE2hRIdIR2i/DoGypsAkt/c9WZ2U3JA?=
 =?us-ascii?Q?vPRjkXinSD6dtZ+35GDCQNktdarvNOlnecUxR/SuEgTynMROsDSHbBlWu0wa?=
 =?us-ascii?Q?dzWPIeaG6DV8TjuF1zEcMVKHQwaLvtaBX52f8rhWNzlGl3LJwIDiszC1joYf?=
 =?us-ascii?Q?xmsRiWjVEei2mG3xPKuNKGEfaP3DPkU2otYNuaQ2X6Z0HI0tjdpQfsDEdA+X?=
 =?us-ascii?Q?1D6p+zfLx8L1qIJbjSwLyMb5o0B4O3Us5D8Be2rcLYnX9nXQ+ERvUPzSrkSt?=
 =?us-ascii?Q?2t/UeMxZeyRE4gpLqLrF5UwUzZA1ebUScMehYlb7pCCKM5i3kuFyzu2LScS3?=
 =?us-ascii?Q?415It1MMa0CFaqKuCG8S3oqMTpYpQIMMsy8aponJG03Lbwau1Bg9Vqp53qH+?=
 =?us-ascii?Q?U0LUU01QhVnFw9q7Mvo5Gi3qY72U6BojEqqWsZntmw5zK+7FETT6gUvY4akD?=
 =?us-ascii?Q?s9jvlr5kAJtfSsKD5owYaZoKbBZCHdDufp7yCv4BqOs2JAWsscxRbHYffpWt?=
 =?us-ascii?Q?nOOzrroaxCTjjd4WnFsjTTjlXo0nAfvfgS1KPMEVHDV0XPtAJByc595EC0TU?=
 =?us-ascii?Q?2EitldI4b2b82w81Jh95BK4PDVMkgIVaWVjvVp+yzs/fbQt3IM2agQm+NwYP?=
 =?us-ascii?Q?DZzKLi06gHRrkS7d1JOW853XdEC/BEbAwNFPjQphtV2wnWVNHQxLlr3YKFaa?=
 =?us-ascii?Q?Xwz3YXkrIpST5u/VXsub4HSmyg6XYSH1j6/yaDLLcztosbV69cmV+zN5N0Hd?=
 =?us-ascii?Q?UTU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ce10040-99d2-4db8-ff9b-08d984587c74
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 21:23:02.8521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7dSL6nYSEAiwQrthwtekDfec9MGGnfIJJi3HLhu0KOU8ZRp/u+lTrC06UiUrCHCGnOMFn/rb66f79+XvgRgTzZiF82nzn0LIyRXLckSxNMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4840
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of J=
iri
> Benc
> Sent: Tuesday, September 14, 2021 1:55 AM
> To: netdev@vger.kernel.org
> Cc: intel-wired-lan@lists.osuosl.org
> Subject: [Intel-wired-lan] [PATCH net v2] i40e: fix endless loop under rt=
nl
>=20
> The loop in i40e_get_capabilities can never end. The problem is that
> although i40e_aq_discover_capabilities returns with an error if there's
> a firmware problem, the returned error is not checked. There is a check f=
or
> pf->hw.aq.asq_last_status but that value is set to I40E_AQ_RC_OK on most
> firmware problems.
>=20
> When i40e_aq_discover_capabilities encounters a firmware problem, it will
> enocunter the same problem on its next invocation. As the result, the loo=
p
> becomes endless. We hit this with I40E_ERR_ADMIN_QUEUE_TIMEOUT but
> looking
> at the code, it can happen with a range of other firmware errors.
>=20
> I don't know what the correct behavior should be: whether the firmware
> should be retried a few times, or whether pf->hw.aq.asq_last_status shoul=
d
> be always set to the encountered firmware error (but then it would be
> pointless and can be just replaced by the i40e_aq_discover_capabilities
> return value). However, the current behavior with an endless loop under t=
he
> rtnl mutex(!) is unacceptable and Intel has not submitted a fix, although=
 we
> explained the bug to them 7 months ago.
>=20
> This may not be the best possible fix but it's better than hanging the wh=
ole
> system on a firmware bug.

Yea this is a strict improvement.

>=20
> Fixes: 56a62fc86895 ("i40e: init code and hardware support")
> Tested-by: Stefan Assmann <sassmann@redhat.com>
> Signed-off-by: Jiri Benc <jbenc@redhat.com>
> ---
> v2: added the Fixes tag, no code changes
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c
> b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 2f20980dd9a5..b5b984754ec9 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -10113,7 +10113,7 @@ static int i40e_get_capabilities(struct i40e_pf *=
pf,
>  		if (pf->hw.aq.asq_last_status =3D=3D I40E_AQ_RC_ENOMEM) {
>  			/* retry with a larger buffer */
>  			buf_len =3D data_size;
> -		} else if (pf->hw.aq.asq_last_status !=3D I40E_AQ_RC_OK) {
> +		} else if (pf->hw.aq.asq_last_status !=3D I40E_AQ_RC_OK || err) {
>  			dev_info(&pf->pdev->dev,
>  				 "capability discovery failed, err %s aq_err %s\n",
>  				 i40e_stat_str(&pf->hw, err),
> --
> 2.18.1
>=20
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
