Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF614B0510
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 06:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbiBJFaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 00:30:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiBJFaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 00:30:21 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CBD10A1;
        Wed,  9 Feb 2022 21:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644471023; x=1676007023;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oGbEvg1aMnrNswkZgez4Y5yikBdZfnle+KS/F+LNsaw=;
  b=c9X9lOOtSSt55/1vrq3hzKjjoL+cObf/iF16OcJiztsVHmVXH5rMSj3f
   c91NF+DkM1oNlUTNNoW7XJWa9qA4+qoEr5c8KCDnFqpXsvtxp9e78NOKk
   PezoU7Ftrv7Jy+yy3ajp1htgHsIl0deOhEv4tYWjUZYxuGLH8z8+gf4Vy
   XtQjGxCyfwmGMlJPscI+vOpE3Cl2c77CWqjL7noYQYT4L0OGJtsKEhUXX
   lnKoJhiL9HO7CUxrbrk/FQBlZpxiqZthdYcRMM7m9V3ELNODg0tCUT7XT
   NfAb+b53tEQpwsZsT9LeCagHi8xZpj+3RiTSD2816wTRGf+XTm/0NJQZE
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249623650"
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="249623650"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 21:30:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="629565762"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 09 Feb 2022 21:30:22 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 9 Feb 2022 21:30:21 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 9 Feb 2022 21:30:21 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 9 Feb 2022 21:29:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VxooxZJgV++Rvi6ZjhFjxjwWrHZXydOnsCWRoxpkQYm6eNLWB22VIhopRame4osIGIXghx4s3arV4LwZFegLpD9gLYfySmUcwzaqhgk0klDY36u3EA6YjTy3mQkgpPmsVPHxbQDQDgT4ODXtSX9RB9q7dkOTYjHsDC5WAhg17oPz1DS8+kjJ87aRkbUcegrNmfgWGJAlxIXO6ouAcz80Vszyuu8ZQ23DfRCctynFENpG2uwg5qXYvCo3/J40DHfHh2+0av2Tiog5QpUrMz3Ppvc/0Ov7H0qHoSJuyWTmjUPr5t6RdvMG7EaTCsUG1JH7xvjwnCvMFVxfsWvQUThwtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J2tlsJLm3fGC9G/nI1ezpy4crqvIplKB24GTQ9rwycA=;
 b=CxVM7jAPowLWK9vk/nyUIya8Oczg8/jeKSu2iS9oTlHcFGkmv9WEap3Ibm4WqkUMjPTtLlndFu7AwQKSlkeqgat8mhlP6yFrNtOXfLVdzzbE1mxxc4OOdajB24YK19izUHPyzDBEPiekg+J/ZYPAFpDN0LNoFCysnHuzOtSgD8OkxBXFSCNqb0hAzeokjvLITvpwiLEpDTh7xZpT7ZmdZ3fOwus162oQA2JXp9ffr8hDmTSoVu4pYd9+ndNTJhUo1QxRhnz+fn63bxfrF90sKNuhAKU2VbCJyzZUIKsVIJoY8yFOtVzZ+6uH64kouw4wXzA5a/3w+yqGpekWveVT7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by MWHPR11MB1870.namprd11.prod.outlook.com (2603:10b6:300:10f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 05:29:54 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 05:29:54 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Jonathan Toppins <jtoppins@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH v2] ice: change "can't set link" message
 to dbg level
Thread-Topic: [Intel-wired-lan] [PATCH v2] ice: change "can't set link"
 message to dbg level
Thread-Index: AQHYGSX4f1yBEjaVTU2GO55MmC32ZqyMTBHA
Date:   Thu, 10 Feb 2022 05:29:53 +0000
Message-ID: <BYAPR11MB336795B622887929554E63B0FC2F9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <b25f9e524c404820b310c73012507c8e65a2ef97.1643834329.git.jtoppins@redhat.com>
 <cfb30f5c84364c8eff96c0a3ea0231e5dfda17e4.1643910316.git.jtoppins@redhat.com>
In-Reply-To: <cfb30f5c84364c8eff96c0a3ea0231e5dfda17e4.1643910316.git.jtoppins@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 222ed90d-2662-4320-4ee0-08d9ec565e34
x-ms-traffictypediagnostic: MWHPR11MB1870:EE_
x-microsoft-antispam-prvs: <MWHPR11MB1870A4A6B39DB61097930E85FC2F9@MWHPR11MB1870.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qDdVlFVMDyOjqRwfSareTTZuSrxn/QivH1xL5kdXSUY5HV0qKvV2pu3HxZfxFnHi6ZH4wKPpOneBm3fgwV07twT4TF7uth8B/7sPV9MjIn7AOrGL7fGnWWjDKBnRWzOmOzt4HA6ygz9z5Kfa5vEhI9CfWeZ+aGRT08oq4n51cMKHPG/lLAfc5glcvTWdFfByUYwd67gy3wfSxAWwNBbEYR8v5K3Eis183ozpzWPq+qIZMhWUeDHw8APx/EQtbGt2ghGsBdlYJrIkMOY2mTh9PZg3UvrAb9uRhLbauhco8PeipP9AsKIW0xH9LtSUK3gnhIinDf6gnvshLq2T9hTqw2lvovAvgHxiSxWGrISkmfomRy0nxWIsLHv03THoo+n9lqRfTFVgokg/mq6J44c8BeTNmX4pFMDXxcFV8PgniJ2Q79yAau3DaT7v9tTIiE2IOm7uOW0/YQaofh9daXMi/35a9iGRf27E2NZJ5ezvnYa6ivQy1Xzvx8F3t3SybpX/4rYmEj6yyZEfdJ/ENSDtd7d/QabJU8mcNzy1y6NkbHWmAf0OmJtMeu++DlxLymg4u6KcnN9qZyCRwzaLDrVfR8yFT6OX0hydRB/oZxHjMQ20YSa/rFIgA6OuOCJpOoBMIkj/skLel6vkq2hssRKzBYIMF0SDugTeia92obxPlkSxaGRztG7uKuPgXmEXn1dCebGnWbFVkoHAcNXQCvD3YA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(82960400001)(8676002)(4326008)(8936002)(55016003)(55236004)(66446008)(66476007)(66556008)(76116006)(64756008)(110136005)(66946007)(53546011)(38070700005)(122000001)(2906002)(15650500001)(83380400001)(316002)(52536014)(5660300002)(4744005)(54906003)(33656002)(7696005)(71200400001)(6506007)(9686003)(508600001)(86362001)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u+qP2373O3c1eF55FOIcXBu6XjTUex+/PLxv4QLSwoWvW6QNAvGOZmVcFmvu?=
 =?us-ascii?Q?KbEvPQHIbiz2AxTjIVwQ24UYEcRKiZ//H2iW5nCnC4hu/ErUEJ4qTYoQNpRj?=
 =?us-ascii?Q?l/j16odQgC22ecN/SnZKBqLN6edBOA4yXyy+SddA+//Pij/gscZjh93aFkqq?=
 =?us-ascii?Q?GB1vFUBuWhpubZJqyExcr5M726En3d5Ve20voAskVWhFu59W4kmrdka13xrn?=
 =?us-ascii?Q?hPj4xLBDbBKme2LkrYrInK9jEiKNxq+Z3C00Km3PlP2MMHotwHhZnrx3VVlN?=
 =?us-ascii?Q?Krm9Uo2cZQG0wgJNlMstH+6GL5vRjivtZOAuMVf4MBHGTXokEF4Wg4ywMan7?=
 =?us-ascii?Q?KCcXAol3nKE7nowBneIbjeUpkvtahg+0NRqzfb8Y92QYsrMv9KcqrW3gVx2F?=
 =?us-ascii?Q?/IJyow5gnnGWNotHZRDqsj7x5lPW4tTcbpWPWaTaqii6A8frc+5PCkBC+yey?=
 =?us-ascii?Q?z1WfYBRKRBsb375IDRO5+q4wb01w8UmeFnPZ76ZtJ7QNkeR8+UxIJLRb0Q/J?=
 =?us-ascii?Q?uG5Xwm8LJjOF/m6bUQBiU7jOs9r/16uH/Btbnx7PbyAcaNWs8lG7M8/6D5XX?=
 =?us-ascii?Q?UI+dR3F4Mzoh5wQXGI4jb7Sxnig9eXzA9xWjXtiuUtu0rbXH2T1hLAcSjb4c?=
 =?us-ascii?Q?LM9CnVVe4H3azpl5ggrhnQj3Y2i3RjBtb5SKusDM/du2aYAboGcbKVECz/m8?=
 =?us-ascii?Q?4YewVGLc4t3HcV/e7PKKiVd69Klt25Nw62wB0+E5SCZnDHfg7ggCm+ax7YcA?=
 =?us-ascii?Q?16VnV0zUvS1xim2QNY+E1kx/fJxQwCGuNqUd5KyTG+2QbRVCzUWEUhR4UoJu?=
 =?us-ascii?Q?PbuFCRekR6L1ZWgL1bk+Izy6aifHt5uby3zcsylbQrsrfyFfpkeXpFl5crH+?=
 =?us-ascii?Q?Zda3bTUT5b2VEKHADAry0dxzC+PM5KBR5VZTMlHUiino7ML9wFd6B+Xvngzx?=
 =?us-ascii?Q?lzszPhGuQfjYEjGw+VlIeOCD94MvAugvlPNxa6WEC2TyGZP9gnn/qSrNyomH?=
 =?us-ascii?Q?TXj8tg7qteT6lcbsTAh9cc4l7qqjOXKHqyz8cu+vaHH7K1DqjZ5pJRm6wVNI?=
 =?us-ascii?Q?vVOJsskWdWyjWvoOa0bYmm7CFMoY442GUHq7JoDTt+/htiBl6KYxcZSxa5sH?=
 =?us-ascii?Q?KqZNIhcibw8kuzs9JJOSCMFAc58BKm2jHdOW/jppeEDq+Gx4+LHZtdSdD5xh?=
 =?us-ascii?Q?5DrWGkwM3tqvja9dxy2T7eJVgM0cJFpwAeb6SwllDaLLbwjKnTxbThFdow0P?=
 =?us-ascii?Q?ijL89Oryhu/0Zpy94UoduWQDj8WFwxmzWgGEoOpS9PFFuGrxMLi9FeKP3av2?=
 =?us-ascii?Q?Ic83eN62Xf2C/zYtaesnWzvBgkXLufd+n8RQ+slh8Q8trJBYJHyz1q19AcM2?=
 =?us-ascii?Q?GusDgJyjwQljDVbIvTZRAU9Nb+qUaVpVUUmu9U5PGZDIGt7+z72Yh1/8ep9j?=
 =?us-ascii?Q?5HyLYiTf036OvTeAEsPUiakILNgD/ybr5yfoJ1+m7IrfasbioNFfUSRJBGg7?=
 =?us-ascii?Q?QJtkN119/6Mw4/aDduI3eGbAkgJzqHNlGoT5/1lazbuiJzBgpsguP8LUoBKM?=
 =?us-ascii?Q?OE956jiRe/5yQS8yyyQ6mTugK/aSsvSAYQpfW7EiaSbA3EhiBEBYiJjJj1AW?=
 =?us-ascii?Q?Sw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 222ed90d-2662-4320-4ee0-08d9ec565e34
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 05:29:54.0683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eg+TPVRO1vr4/T9fwduzumhZqm6B/37O+9zeqc+NSAScunP/ott0rQ0qap9Pl2Co3ZhDy9VFHmHcqAAE8986+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1870
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Jonathan Toppins
> Sent: Thursday, February 3, 2022 11:15 PM
> To: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; intel=
-
> wired-lan@lists.osuosl.org; David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH v2] ice: change "can't set link" messag=
e to
> dbg level
>=20
> In the case where the link is owned by manageability, the firmware is not
> allowed to set the link state, so an error code is returned.
> This however is non-fatal and there is nothing the operator can do, so
> instead of confusing the operator with messages they can do nothing about
> hide this message behind the debug log level.
>=20
> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
