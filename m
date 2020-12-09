Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD97D2D4E14
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 23:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389009AbgLIWhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 17:37:50 -0500
Received: from mga12.intel.com ([192.55.52.136]:14818 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388779AbgLIWha (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 17:37:30 -0500
IronPort-SDR: eeWAmNQrEcjMzbzmB01+W9YAMBN2ap/K+++gnrS3lDT2ruv0Wbiu8tSTS2jnMWkbzDeqcPM+np
 WgqxOLF0hbMA==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="153398152"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="153398152"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 14:36:45 -0800
IronPort-SDR: vJ/l+pPM9IFmjK8VOige/gN0vTME8uNsObGeBwdVyMFb2t7EiqXXLn/UggkeuJLCgoCdbee2v6
 sXP1qI2RUwiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="376700204"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Dec 2020 14:36:45 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 9 Dec 2020 14:36:45 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 9 Dec 2020 14:36:44 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 9 Dec 2020 14:36:44 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 9 Dec 2020 14:36:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/pYiQ2y8s89kq+9sx0UCCpSvBJJmm5XtxYtbR9656BYLYOL5bvWc/+jv+KOyrL7BIC7WAeQmbCxeVHLVg5AgYQuYguEFOeyq/BAkircFahTMfIii4a2wfPCb2sP7Kc64Lfck7Xhd3KakjTlAyKOvwM0hEK/CaUSgzCmJz17WVkpSBFVu5erl/nziMFrydADWDT7u2lgMErnmEFwutk1jy5gdnt8Nh1FITnWDDTjdBqjjPF4feB/Za5zR+JcsHp8rpKCITOFbomegUWwN84FeyHpzmAzlcR9y7ycpqUz9R1OR8Dkf0pmvAA5G2YPvmfV/ab9hCPtkB1kHCWSFaIHDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biW4fK7CBDeeEhn3Qf/7rgQPpaQZsV7zX/r1j0cX8GI=;
 b=ibPUnleLIWwnlDuwMLHJHworC1bFobqkN0nNxmESmpjQO1WT1RrzoASmhhs7BnQFIpwTbG7M3W5Etvu7cOUGrebevKGulGlMZmn09vl7cGSwDxqTavQhdFZjZLAM5+U0tqGIZVtBhZn6e2prD8sAm/fwogS8DSTYcmS4FJrkySKGxK3PuBr7WEtZGpovOiomMp8Z0mcnm/ALNz3XzekZM+gJhgPk7TgFZ9/LmkzgiQDbgTaCIUqhmBVaY3H0M+ExaesozgHKBgqNf7sSC6tXvJCJRYBDbcX2yOoIeQ0E5diAyQR6ZCrPldB+ZUYsQXwH6hGaXu8TH+tExP88P5H1cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biW4fK7CBDeeEhn3Qf/7rgQPpaQZsV7zX/r1j0cX8GI=;
 b=WBme19eKDcEARjya5j9yZrU3V823r8y7XvXpAoXFx2u7qpI3TPTfA+95sNN5vucSQKxSn0ReaYRBnrxUjksscxNoQ3SeYWZcsXmr0UVHEA/quXVB7VUYhul4CONDJFjSTxmdFBaura2tNOF5V9Y9r9mU4GWWk+OcQK2rt9RFYwY=
Received: from BYAPR11MB2870.namprd11.prod.outlook.com (2603:10b6:a02:cb::12)
 by BYAPR11MB3285.namprd11.prod.outlook.com (2603:10b6:a03:7b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Wed, 9 Dec
 2020 22:36:43 +0000
Received: from BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::b4ae:9931:73ba:c55]) by BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::b4ae:9931:73ba:c55%5]) with mapi id 15.20.3632.023; Wed, 9 Dec 2020
 22:36:43 +0000
From:   "Wong, Vee Khee" <vee.khee.wong@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next 1/1] net: stmmac: allow stmmac to probe for C45
 PHY devices
Thread-Topic: [PATCH net-next 1/1] net: stmmac: allow stmmac to probe for C45
 PHY devices
Thread-Index: AQHWzhy9kED+u7UURU6fsJ4HgthDb6nu7xyAgABriKA=
Date:   Wed, 9 Dec 2020 22:36:43 +0000
Message-ID: <BYAPR11MB28704A7CCBAB9DF38E26EFC4ABCC0@BYAPR11MB2870.namprd11.prod.outlook.com>
References: <20201209111933.16121-1-vee.khee.wong@intel.com>
 <20201209160927.GC2602479@lunn.ch>
In-Reply-To: <20201209160927.GC2602479@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-originating-ip: [210.195.177.111]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3a43aeb-e21f-4782-d308-08d89c92e756
x-ms-traffictypediagnostic: BYAPR11MB3285:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3285A4F3309A4D00751A171FABCC0@BYAPR11MB3285.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: trFneI1tODtAXneQ31BF6/hXAf93DWv5VtyVCEBCZVu6f6STp82E/+xB37CivUVCgeTXsXcv8vjF2FTCLk4a5bIRoiGyjNrwdZs9VHM8gdsEz1qswJx+HEqTCmJryPSOCHqttg6NWFYAsUC3GWqhBJsfBQwUDaVCEqP6EMdUrOkRSftWwbUHmxbG3EWK0MpLulnBoXZ96CDdFdvA7OSMqjWgqpVK9h4W/g3PQSEA2ouf8hLUQblSmkwFpfJ4AM6GBiDzzZwGo95Orhtacp0XKr0BmpNjNq5WCYQ9mF1WH0EhXc9L6LLtaCmgjyqHzGv8cN5UId0pv5NCIwUbP8/ZAw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2870.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(66446008)(9686003)(76116006)(86362001)(71200400001)(4326008)(66476007)(2906002)(66946007)(64756008)(8936002)(7696005)(26005)(6506007)(55016002)(53546011)(33656002)(52536014)(8676002)(54906003)(66556008)(186003)(6916009)(7416002)(55236004)(83380400001)(508600001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fpCzj2umZqCkOD2COR7llM5o2IoZUdXWDqUvockVnRgMegLERb8ERNxxXjFu?=
 =?us-ascii?Q?rpkcmnaC9qiGiLNYSA4DgghAhxFa7n/7Csr93l+wdKBtzMWHu+LuPUz6jSdG?=
 =?us-ascii?Q?wbqmLCVxYv3/n5rjhd5F2hVYfjEnHamcCXwN/R+bbykMxPD3CZRhGWa22GB9?=
 =?us-ascii?Q?eJyFG7J59IavyJxX5CbF+i2LfA7RdzuHkAQDWgN81HjlKExX4XUAeZ42jUbu?=
 =?us-ascii?Q?Q4H/nRdQHAADAhijIS5asg9C0DxbCx6FajnkuoxqPCMUNtis4TD3RgRuEZwz?=
 =?us-ascii?Q?+XnmvkIvh29/UJil6xHOfjGDfHl/WmIo6eGkXss68tPyC/mvMp7lB+L8zDTj?=
 =?us-ascii?Q?uaEN+U6PfnxxdA0XOM0IbfTssze24EQ7leZE5/scHH2YVEUeYZJcmHsSotR/?=
 =?us-ascii?Q?WzSaj5eI4S7zkikOoyfVgt+AvWRjwPNppAUO5112ny52Ci4thl9ya48YB1ZX?=
 =?us-ascii?Q?Ig0xVcJ4ZDjXzJbjgLkUw1ZhF152B/nJPOgMomIBx+a29+c0RGD1s2dnhbsj?=
 =?us-ascii?Q?f11Sgq61HWAp7vyTPBCxo/AxEdKIDrG9c7F/5gRH00qKNav+/0uwccE4k4Tr?=
 =?us-ascii?Q?6nlRH5uBDz8rKbWiV2YGGst5J1SsN/Yy5E595ZwkLt3NtRqEPBDqsZNB3Qix?=
 =?us-ascii?Q?YO7siENO7x7rqH/AvFnXSAq37gZTZ8a1B4ykDjx3bUkfr5Q/7N3V2KCiigOR?=
 =?us-ascii?Q?n8l58IJwDmP1ZlSRAqgOPPtkZ2Y5diN6IpG/PGheALOo2BmIbE1dPgvXnojn?=
 =?us-ascii?Q?Tm6fWARCwfNVrEg2OzTP6VYjnTBi7o6cuqAoYE2jDGNZ2KmX8syEGGdyxUKW?=
 =?us-ascii?Q?pcuwFfXVBH+/DvQawTNH60YP5u7Qp/PSpdq1NqkZuTQDLOhGmvRoOnX64ugM?=
 =?us-ascii?Q?VtLvzw3M1fJQHeB7W8o1cbGR46V2IqFLejZLfmXbqcWaKeTGGHToQhtphKOR?=
 =?us-ascii?Q?zlLjxGqUkxr8MT1/Iy+0J06UXMUF02zNanAe0DlUN+A=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2870.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3a43aeb-e21f-4782-d308-08d89c92e756
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 22:36:43.2271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z0oKShV8SVWZx6R9l9UHeq1CNfVgWgF1KnkpUBAfe5S0wNrrlc4ANhHz9kXuNEKSgY04pAOhxpaXtEzKxg/asQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3285
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, December 10, 2020 12:09 AM
> To: Wong, Vee Khee <vee.khee.wong@intel.com>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre Torgue
> <alexandre.torgue@st.com>; Jose Abreu <joabreu@synopsys.com>; David
> S . Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> Maxime Coquelin <mcoquelin.stm32@gmail.com>; Voon, Weifeng
> <weifeng.voon@intel.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Ong, Boon Leong <boon.leong.ong@intel.com>;
> linux-stm32@st-md-mailman.stormreply.com; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH net-next 1/1] net: stmmac: allow stmmac to probe for
> C45 PHY devices
>=20
> On Wed, Dec 09, 2020 at 07:19:33PM +0800, Wong Vee Khee wrote:
> > Assign stmmac's mdio_bus probe capabilities to MDIOBUS_C22_C45.
> > This extends the probing of C45 PHY devices on the MDIO bus.
> >
> > Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> > index b2a707e2ef43..9f96bb7d27db 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> > @@ -364,6 +364,7 @@ int stmmac_mdio_register(struct net_device *ndev)
> >  		memcpy(new_bus->irq, mdio_bus_data->irqs,
> sizeof(new_bus->irq));
> >
> >  	new_bus->name =3D "stmmac";
> > +	new_bus->probe_capabilities =3D MDIOBUS_C22_C45;
>=20
> It looks like this needs to be conditional on the version. xgmax2
> supports C45. And gmac4. But other versions don't.
>=20
> 	 Andrew

I will send a v2 with conditional checking for gmac4.
I do not have a xgmac2 hardware setup to test this.
