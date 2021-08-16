Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502103ED3C4
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 14:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhHPMR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 08:17:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:2780 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229836AbhHPMR5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 08:17:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="203048794"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="203048794"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 05:17:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="470764841"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga008.jf.intel.com with ESMTP; 16 Aug 2021 05:17:25 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 16 Aug 2021 05:17:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 16 Aug 2021 05:17:23 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 16 Aug 2021 05:17:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZaTywQKCmIqoPIh9wnbcS85ptl/uTJoYc2WYpX+PiZoQ+8AHPGLaxV/eV8+TuW/+wsdsPZTkKjq0PDR0u418gHaXrwVQSWOlEswawXF+8e+Xx2GaP9g4eSP5yZPzySQXFQ3VM/nobGOBO9CplDoK7NmmquDaD1ih6ivyZdsNYt2NSKVuPcMOqgIsd6oYm7FGLCzl3WXNmgKlOTgguNg1pKDnTe5gPrf+W1pTV2Xdk+c3cLarCKMBcfKd1PxktbPe89hmRYNobtwHFIDl4VsmUQAY/J+UeC+82qQAKpl3ZN5Wae5f7J0x7WlxP2ZPix/pPdezxk2iNw+7hwn2DXDaig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9n5q91WI8k9ycDmFp2Ro+jEGQhzx09hXZIR5usrHGU=;
 b=AHzeIfp9tiijQWCN4RvpOn/ArCQhUt8jhtCeFJblENLYNx+2HlwWpopRboRmizzIE4X0vn9w+HgkLwPOafVqBT3zZSPxUM8vv7mtjSt3Qm1eTLBhtBSkFnU/zuBzXEOTiBpI8hl36iQRS1u4xOHBZcZ7Lux8a4HSVfh4kRRwnxgAxpn9qTFHib10x/EmmL7t1ex0kBpwUow02Q+5rXhRSC3xmuzQkyDi4O6lXbNFy49X9PMK4iHfKhDFIAx/rowi+meoDBhlinZUdvqB0xODJJ7SAHJWL//pfXORJwx7j5+xSm1LbqvbYCx/EJ+jgqdY5/XoazM2siY312+tsMxiIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9n5q91WI8k9ycDmFp2Ro+jEGQhzx09hXZIR5usrHGU=;
 b=W7dMBCQMbRK7VUlsDIb5sRV4qPVLIhrHOOoffAWQ+CVBcgl92M+eUU+s71S8zbYXmH/4VHxQTVx/JMtG7x+ZFM2Yc1/VdMQEWp7aVzKqx8Fs0EfKbdcIDUJ/BNs9SyVVB9ZipfH8FfqI+WsgEzE/HekoQS1ueGSlj1iMUDpFWXA=
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by BYAPR11MB3399.namprd11.prod.outlook.com (2603:10b6:a03:79::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Mon, 16 Aug
 2021 12:17:19 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3dfb:de6c:94bf:8149]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3dfb:de6c:94bf:8149%5]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 12:17:19 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Solomon Ucko <solly.ucko@gmail.com>
CC:     linuxwwan <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "security@kernel.org" <security@kernel.org>
Subject: RE: [PATCH v2 net] net: iosm: Prevent underflow in ipc_chnl_cfg_get()
Thread-Topic: [PATCH v2 net] net: iosm: Prevent underflow in
 ipc_chnl_cfg_get()
Thread-Index: AQHXko/XnqNmOxwGO0yFuE5lhZpPhKt2Cicw
Date:   Mon, 16 Aug 2021 12:17:19 +0000
Message-ID: <SJ0PR11MB50083A086BDACD9B169F40A8D7FD9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <SJ0PR11MB5008D7714F0D224A0778857ED7FD9@SJ0PR11MB5008.namprd11.prod.outlook.com>
 <20210816111333.GE7722@kadam>
In-Reply-To: <20210816111333.GE7722@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a38a15c8-6b74-4065-c94f-08d960afcb20
x-ms-traffictypediagnostic: BYAPR11MB3399:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3399585D9E747C42D4F3DC9BD7FD9@BYAPR11MB3399.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tl4HKNvkHSggrpB6l1P/dVYd7k+QNEKeTvKx/igJx1l/zwP5ChXTOWP5VJrJAFNhK8mSvi/SDj7GpKi53Se/WvqY34RMuM0IVTp21lL/AkfPgkjE2vmmUl64YV+9+jg6TT/Nd64ulolWO9wJqF44wYfMDyLq83/37JEQu15FARJ69m3o11hTMC5d6wZ+W1542QK7aspuRoGvLmOdUyAhrO+D200s/U6kSzUELGCupSd82me9/F6ti2yDa+ByO6WwaMvIYgOYBU0Qq3AwY1GDbfdyBjik2oWptKHhC8BhEgUbJ14KGrj3rnqHiHcNg8gWgN5CwgRxxmv0MREbTQU57Qj2dwVQRukPLs3l8+yDFju4SDt/FkaPLRb7skIx1MkDYm6AzKW3k2KUj+yoI8OEqft0/56t31liycSuq8L0hMMa/hq33+nEb1Eq6fUlK4BwMArjhat6LzEYfegUSUiIUWdnpY069NT4bYWYxqsfpOa/98cIqx1aNHmSBwEmkz/ratfOwHiic6Uwh3hnS9xc9maGtjYjToVv6Re1V7av/N6f3to1+3UOEgGir3ZidXPtkkAwUnQpNg68osmx2Dbk+mlOcjvG4vt9iHqmuocA5tSiYU/4wa5t2cxUsqhQn1PSq5alqLQDRTqw20O97fFRHoraFGQKg6baDGAa7jfbmLpkB1efAv+saw9zyB0wlh1b3p095iZ2UpjwiBCXiYg48w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(55016002)(316002)(478600001)(52536014)(9686003)(4326008)(71200400001)(110136005)(54906003)(33656002)(122000001)(83380400001)(38100700002)(5660300002)(66476007)(6506007)(76116006)(53546011)(2906002)(66446008)(186003)(38070700005)(7696005)(86362001)(4744005)(8936002)(66946007)(8676002)(64756008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nzcA5PmOCQku9H5/M51ZwJQ3TBxyTATnUuTi347uTIFma+Jwa4TdjeoJiOT6?=
 =?us-ascii?Q?XXUxnqvmMklQ3SJ0wK5BnV9igkzGMrBHyXmldmkkyOXNc4FJOxoAKupcQ8rx?=
 =?us-ascii?Q?qlOdAi8BqvfhLQuISUKIR5dDM0x3gNzh6WENsPETbrX3gSYW7Bueqx40Sc40?=
 =?us-ascii?Q?7CuEUoXsRUl5O7d+j3U51eqUZwEHyT25n9BMY6TgEoI9CsLSOq5Pe/GfjfR2?=
 =?us-ascii?Q?aamm6XIeyDczE5sBa7Z3vZQoDEwJVy9UYvBMWU7ILVSZsXRXrpi6GaUAeqW7?=
 =?us-ascii?Q?hjN81XUIOankKGniTL2BSz4OvgNdeGgNctGitgJRJlpJNeretG8JFoq3GeGq?=
 =?us-ascii?Q?FgekMmFHaLYCul4D8FfmFWDYWWMKThhHNQFz6ApuXHwRuUxxBX1Q1Y1of7Hl?=
 =?us-ascii?Q?YC1RvxcXYE1WsCRlAUwY4UQUvaeV96xMsfqeNFVNG7K013Y0no+nxCe74wpg?=
 =?us-ascii?Q?QMSMi5KyebJ6WJrUe6FmEhbUqFiAne27kVxOnRtCKmrkogG2XHgzqi+5ynzP?=
 =?us-ascii?Q?YY//O5TCmCwfqbvKz3I4iOZzcvZwdHku3jnOE8P4ZvWuzWYRfxUJzXs5x2bi?=
 =?us-ascii?Q?lE2NToHLXMvaNFW/6ZOqmFxArWCFNR1X9a3YsmnK5lIzOfVpLX5kFB81/J0d?=
 =?us-ascii?Q?+uu2tO1OgNel2GJBjOmpe+uaWlLv4w+av+epGJjzjsL/xai3RZ6dpzAnP+mZ?=
 =?us-ascii?Q?aQfhXC79TScGedZ2mA8OQP6G3GBdgrGNLmUAxhI+ja1DI6FST/Z3zT688KGb?=
 =?us-ascii?Q?S8hsGCl6BP5GB48FVD0HkmTphv42/GRPBXY/5YVmAsZ4qFfzsaz/SBal0GEz?=
 =?us-ascii?Q?CepH+Mm2p/Zp3xWRFwDae6Ykz8I0VAE2rQNWFNuMqpgbrbSYt2qgjWV1dioN?=
 =?us-ascii?Q?hexGb3xARPsmcGjsfyMwGmtd1c133Vlot+oGe2M/hMof1DfbHGtRiCKK5pOq?=
 =?us-ascii?Q?vgvzvqVJb/No0hq87kpKYnA0+lViW1BsDUs/sRFBdT7apbDAE7FgeI3uVAeO?=
 =?us-ascii?Q?dEKBenRoTqkbZbeoUlwKH+sYO1TbtkW14CwwE7ouRXNizbhKT8/+7+EJmf3M?=
 =?us-ascii?Q?G2DfPXYNh8S9WHptuTs0Wa9sc43xYrJX3JuAKa1EW1g+wo+75PJm+utm1jYU?=
 =?us-ascii?Q?KdNhw6c3xZZNC0kt2ELrQfRShPRo6qMXzoN4LajjJsW4G5aJwhlvRvEUsGcu?=
 =?us-ascii?Q?lkWkIvnxDG0jBPeh/cy8y+Y2eXwzJ9aT1xzt4OIE1usLOe5yYpn2dw95G7rb?=
 =?us-ascii?Q?J0CMyR+4YvDQdw+y87exox3I0BZZ+6aR7JKyx8ssVsRIDNmlR3QK32iaIqUr?=
 =?us-ascii?Q?BKdKwjxJz7KzZ5PphSuBh3nwOPgYGXpW+CWiah1Dfbb7oW6aoHdFCvM0wSrp?=
 =?us-ascii?Q?acekuBksSkTWAe6BRjOSj4apCjZj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a38a15c8-6b74-4065-c94f-08d960afcb20
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 12:17:19.2465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KLyg+gVSRPUm8gjXFhdnCd2ENnvCCMKzFcVnObz32wjV4MIOQOpBrM3g6rCugT3zE0Fyw2AABal4AP2lVpawrtt6t78rBrtOQDC/5s6isXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3399
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Sent: Monday, August 16, 2021 4:44 PM
> To: Kumar, M Chetan <m.chetan.kumar@intel.com>; Solomon Ucko
> <solly.ucko@gmail.com>
> Cc: linuxwwan <linuxwwan@intel.com>; Loic Poulain
> <loic.poulain@linaro.org>; Sergey Ryazanov <ryazanov.s.a@gmail.com>;
> Johannes Berg <johannes@sipsolutions.net>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> netdev@vger.kernel.org; security@kernel.org
> Subject: [PATCH v2 net] net: iosm: Prevent underflow in ipc_chnl_cfg_get(=
)
>=20
> The bounds check on "index" doesn't catch negative values.  Using
> ARRAY_SIZE() directly is more readable and more robust because it prevent=
s
> negative values for "index".  Fortunately we only pass valid values to
> ipc_chnl_cfg_get() so this patch does not affect runtime.
>=20
>=20
> Reported-by: Solomon Ucko <solly.ucko@gmail.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Remove underscore between "array" and "size".
>     Use %zu print format specifier to fix a compile warning on 32 bit.
>=20
>  drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>
