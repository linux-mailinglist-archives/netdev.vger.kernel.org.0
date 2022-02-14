Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0BB4B59C2
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 19:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357371AbiBNSRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 13:17:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiBNSRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 13:17:08 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C0A580D8;
        Mon, 14 Feb 2022 10:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644862620; x=1676398620;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xyIRwY4yPkVY0y5gtiJ949DXW8+dbryeEcI8f+Qh8KE=;
  b=eHDlrOW64pxMer7FOeIpvldV3u0BvO2RzHyK3Cvgsaay0RcD5TW0w2u9
   YiK2k1ZfJrscF+PUbDLnb+/X+lHnZmqFJuQ74q0BYaJnFORcZ4UnIQLBU
   jKqvG8riJKkS51+qDLEbXfm1CR3LkXhKkkfUwkduShTAwCnbR6lokvnQ0
   vIfuKf80M5O2bXhgOcNySiky6giZU1Ewc2FYGFjAOnnbdO0qLdT+Lbt28
   VJJGhTaSfZ+0dAio+xOGvFvExF3NeoPcyYMiN8n9N/Ljh4zUWwtW6gEpD
   5ynpcgfxgjkm2NMba9GhXTg77Cf2tfPnuHRxPzQ7DqOqb/uUBtp/GrlN3
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="247748039"
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="247748039"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 10:16:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="773166945"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga006.fm.intel.com with ESMTP; 14 Feb 2022 10:16:59 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 14 Feb 2022 10:16:59 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 14 Feb 2022 10:16:58 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 14 Feb 2022 10:16:58 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 14 Feb 2022 10:16:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OiErid4a0eMaF3A6wUf9gpmwnk+11eIb4Ro2X/iQL4rzMIL6rJ6epXV2SAfqx/uNtVOjGwbfI1zq1rTTyiotMdbfpbMtlvYT9tNfQNCviJ99RLhvSzSiwSwdSa7Qke74vLKaM1x5ncxg854WRmyVG7wG2Oo4xubA4OwkqPo5hHvqtMQ8d7EH+LS733C2bAfvVUrbD+Q52fRToZhDIgB0sobBafMd+HSRjPBIgggzB9FtbOw7dwAZBhGkg3rUpS8YUGwSBN+uKTh8z1vmJs+PCnml60sc0OwV7esMzfYvOHOSQBUjleeVdU1/EPaDBxBCoWde7HITrb0nuY2ZBKnS8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBEd/a7zjxkEjsmk/nhzaacYG7OsMOSyRA9mMkXl93s=;
 b=jgGPXHYSf5eA/zrfSUJLkSt+mqw5lrMSlqsh9ApM4ngItwoYTzvCzOGzdmq259oLj2+UwKyuPj+RMc54DQZLkrTHNi5ZEE4uQ5+ZPRspPIoNIxngoT1oyf+mk/p9sUq3+N/WkOeajq/d54gIdyi0w+tGGwsnSI76ZSRN6uiRDLzat2JO4mYZP9gG3a8/blABLHEENicmyFJSjbapMh5K28FRtQzMUvn5jmIZc6Oi6w8aYLsQUDGCaTgIg4cv2HDPCbHcZgQ124m4T+2xoJalgkEGnkZFx8gnkWn+xNcLkQ+Krfsa2seh40vZxGxz8tM2SPNGynXBnJHT/0g5dX9ePA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM6PR11MB3737.namprd11.prod.outlook.com (2603:10b6:5:144::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Mon, 14 Feb
 2022 18:16:57 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd9e:6244:4757:615a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd9e:6244:4757:615a%9]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 18:16:57 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "trix@redhat.com" <trix@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>
Subject: RE: [PATCH] ice: check the return of ice_ptp_gettimex64
Thread-Topic: [PATCH] ice: check the return of ice_ptp_gettimex64
Thread-Index: AQHYIa/qAxP3En8yz0ybzx/1UAHuxqyTWojQ
Date:   Mon, 14 Feb 2022 18:16:56 +0000
Message-ID: <CO1PR11MB50898B7C5A2F51A42B9F07D7D6339@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220214143327.2884183-1-trix@redhat.com>
In-Reply-To: <20220214143327.2884183-1-trix@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e1e7496-0385-4a5f-7bf6-08d9efe62fa2
x-ms-traffictypediagnostic: DM6PR11MB3737:EE_
x-microsoft-antispam-prvs: <DM6PR11MB373780073623BDCCF8594D5AD6339@DM6PR11MB3737.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:318;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3oxcUgUHOZ+AUdPU2sj9U0JNxCOYWqwiqg8w4j9jEZZO2+zo0zZ02dMwgqmu3qLYxVj+fRAjMOvA3/r1okP32elS5B651qsbUFb5vsv+UwtQ+pZshpQRLTh+S7UAL+q2hCoocAYKE5lEW7WzMUF72eM4SkzAfFbrjLfDYrRIi1EjVxkKJHj2i6ltIaCq8TLq6+m+l7qu2G3Q7VUqw9L0r2tqct2Fr5Jdx5B1Li9WiM1AOFj4DaznNya4O4ASfPhox9UiYyOrLl8ROHiNAyb0q8hx2uQH4qr5LrANw23ur2ruKmY39cc9XqITYXk0hPqcMOni+g3wZVmRIfPN6WqokaWQAGTA+ztbaka8cKoWObU7RhTqcBERnIxn9+rSS/01ulhMwhreWKMo0qrV9eC6BGjIQwvROEDnrPg3/0hcLfpRtWVp4bHrCqZW2ql2Dk8EcMNRN1H0Lj1fSLzlUHJkSZlaoo9eVicRfd1TaxVG3Hsr0O9bWjDcXTNGYxW6DE5rsQkLNoNLdm8XArdPD1mbpozH88hsGxe8c0nE5nCVN6mNKy9VvPw3JRGF/kICQmJFbdMQSH1x/ypZWq4uFb5SxpqWSBw2YEd6c0WlXuhrvhE6wyxVHyBtkb1hYZOgaRZzAAQrJpBgxUkicy4DQy/rTR4bl5rP+C/beqf8mAfmMKKLx1D7cfxzDWluvN0MhRvOvAdodLyysRefydL/2DiBQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(53546011)(86362001)(52536014)(9686003)(2906002)(55016003)(38070700005)(5660300002)(8936002)(7696005)(8676002)(6506007)(83380400001)(54906003)(110136005)(508600001)(26005)(66556008)(122000001)(66476007)(66446008)(64756008)(4326008)(82960400001)(38100700002)(316002)(66946007)(76116006)(186003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?j+M3qt1HMxT3cMHXiGpmc8deFsLEcxYzqPuEa84TFl+EQuxTj1tCMHu9WfkR?=
 =?us-ascii?Q?8sCmF1yEgTaBjp2P7Qx42xGcHDnzjhGAAieKJh6q81Qsvx006UGt3gSO6FHl?=
 =?us-ascii?Q?MMBMTjCMOZ6lzGuRUUTV3cn3ahPcKtQqoHEyrJrndhLUPr//FuNYH0SeEH9V?=
 =?us-ascii?Q?Pqf6DJK91KAEdRJ3nE2anU28g0IMTul0XRyshS4rqL7cfnf65qEhX+WzKcD+?=
 =?us-ascii?Q?aqnZWL0VxshLrdhnW7CWv2eclxd9uZwTjkQiQTLoJ9qUFK5PQ80PhpZI9Cy8?=
 =?us-ascii?Q?VbPaPM4MFbBIHD3B/zAGEOdGsbi4bCvd3A29BAobO8/P6nwJYahtd+aOwnqk?=
 =?us-ascii?Q?C4Pj1KIw8sADfm8ITGDtOj/Yj3Lv5U0SmniQNx1gahn+0JBBLhQU1Ei/oQqS?=
 =?us-ascii?Q?1p1Thw5A4Lp1HvMWSMpcR+3jIJ1xHD50fOvg4zP+C6ST7lRlrbVs0BMan5UP?=
 =?us-ascii?Q?Hg6ajeBMumh1SFPJXw8QNM/Z5DWjRPtT5QttCh+i2Rq1aS6ZRu/4kEm6z2HK?=
 =?us-ascii?Q?bb9R7YwgxOq0hQeUMsWAVST9gbYwc898WNdgZoSpc6Q2OXgQhSpLhyIl011H?=
 =?us-ascii?Q?N0hjBq/ll9P2VXK0Dqk59bZqGugA04eFedEFa+fPR0VDLt30CjMhpMiVGpo8?=
 =?us-ascii?Q?IBp0mgl8RGj3Y7Yl5mIm1u5cgADcuj1RRqKwv0sF/leqL+XtUqypiW+ccCJO?=
 =?us-ascii?Q?34aQ3ywTQMmY8Q3ez40puJm+OTeltsbJ6270cdgZg+nrCok5YtwuBfDOIiVA?=
 =?us-ascii?Q?oHrFK1r5fieDNcSGQweHbBEzHcHmoRPWUAIUen8fcb4NLtpX7wgGrOjOW7jH?=
 =?us-ascii?Q?gZdUtNzfnuWPfc/JAnhh46uhAUBy3rAEHoZ7Ff91F4cNoN6LC4/H5TcI331Q?=
 =?us-ascii?Q?OTKyk1yd59BQr7suC/IXb39bl0tfcTuMh/rmCNaJ9Np+3HZAtzYa2KPANnNb?=
 =?us-ascii?Q?KPF4idA+AWc7XWd5RmpV50GrykEYU5kWQwa3oII7AvXgt4R7aHIsRsqBLIv7?=
 =?us-ascii?Q?XijBmd8NUMPhCdQEjAOZgqcjXcbijO5O87et4605LI1rqvvXPcS5CXndx3o2?=
 =?us-ascii?Q?T66D82Ijg8O8JckurbLbWxj7vYmh09rYoJ7aAg6nyZeTmxMm/11ryWazhqJ5?=
 =?us-ascii?Q?ogGZYrgmrITiw6tq2vXvJEQ/DfpQ2Mu51Fbk4nSdTXZJXrlhf373P6piWdzt?=
 =?us-ascii?Q?yNO7o5/I7qSswm/T5vyGe1S99QA2nLO6Bp9H0XU7uVtT2qsGdo9BrjL3VTgm?=
 =?us-ascii?Q?AJZ1XwORMPTARerfRbXag/p5456f/3Lqyqn9N96ZOJJVgKUD+aXPavrtAlZ2?=
 =?us-ascii?Q?yBA1mQZIgAEcXDpA5FIHhUk47lzlAK80EvSmtzNTpQNmG6s1bBgLUiJxpARw?=
 =?us-ascii?Q?UQBCGOrWjxvbX+oB+AFwolcpAbgWugfepxKGZKCKSwWap62d4rPjjgT9KApf?=
 =?us-ascii?Q?7iw0euSSj6OsGc7gy8X4VTAAEMBuLRQi7+e4HLRDGr1zKEwtXQhKaJx4w4QS?=
 =?us-ascii?Q?AREY7NOAaY2tt6I/8/ZMHUUqV3HuxObR3kHY6LMg/8xmtsq9QusAEm3hFqXF?=
 =?us-ascii?Q?458S3Fe1jLGw6uwMiffxdXNcCFBWB275tQh13QWj0MYzSomhfF6kfn008jQ7?=
 =?us-ascii?Q?LKZ2jVykvoIZfAjrzUG1VF750kFsPt7OZGRO3JrfjUnJ5JsYENTi70JmcT4j?=
 =?us-ascii?Q?jBk3sg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e1e7496-0385-4a5f-7bf6-08d9efe62fa2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 18:16:56.9548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vRoyFkB948D7FMYSDRnwyAkj/fEG1QQ1SEJz0/X+l84NRmNBhwX0A0jPSmIi+QpK50fJE/FoFNgtm/nVuhzL6ofQ9uAulMWPxWjjJixRdEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3737
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: trix@redhat.com <trix@redhat.com>
> Sent: Monday, February 14, 2022 6:33 AM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org;
> nathan@kernel.org; ndesaulniers@google.com; Keller, Jacob E
> <jacob.e.keller@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; llvm@lists.linux.dev; Tom Rix <trix@redhat.com>
> Subject: [PATCH] ice: check the return of ice_ptp_gettimex64
>=20
> From: Tom Rix <trix@redhat.com>
>=20
> Clang static analysis reports this issue
> time64.h:69:50: warning: The left operand of '+'
>   is a garbage value
>   set_normalized_timespec64(&ts_delta, lhs.tv_sec + rhs.tv_sec,
>                                        ~~~~~~~~~~ ^
> In ice_ptp_adjtime_nonatomic(), the timespec64 variable 'now'
> is set by ice_ptp_gettimex64().  This function can fail
> with -EBUSY, so 'now' can have a gargbage value.
> So check the return.
>=20
> Fixes: 06c16d89d2cb ("ice: register 1588 PTP clock device object for E810=
 devices")
> Signed-off-by: Tom Rix <trix@redhat.com>

Ahhh yep. Good fix. Thanks!

> ---
>  drivers/net/ethernet/intel/ice/ice_ptp.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c
> b/drivers/net/ethernet/intel/ice/ice_ptp.c
> index ae291d442539..000c39d163a2 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ptp.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
> @@ -1533,9 +1533,12 @@ ice_ptp_settime64(struct ptp_clock_info *info, con=
st
> struct timespec64 *ts)
>  static int ice_ptp_adjtime_nonatomic(struct ptp_clock_info *info, s64 de=
lta)
>  {
>  	struct timespec64 now, then;
> +	int ret;
>=20
>  	then =3D ns_to_timespec64(delta);
> -	ice_ptp_gettimex64(info, &now, NULL);
> +	ret =3D ice_ptp_gettimex64(info, &now, NULL);
> +	if (ret)
> +		return ret;
>  	now =3D timespec64_add(now, then);
>=20
>  	return ice_ptp_settime64(info, (const struct timespec64 *)&now);
> --
> 2.26.3

