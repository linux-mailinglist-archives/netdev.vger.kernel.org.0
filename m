Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F6139A282
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFCNvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 09:51:50 -0400
Received: from mga17.intel.com ([192.55.52.151]:12093 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230507AbhFCNvt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 09:51:49 -0400
IronPort-SDR: Mv5hu8sMuEWEcJeaitfLuGrnKGcERJEJPim22xm7eOG2S2+ehq4WAne+a/v/OGEYVBQLBfHEd/
 lMIvGzP4HG7g==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="184421283"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="184421283"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 06:50:03 -0700
IronPort-SDR: XIEmuJD8E1NuLNOvLTjgR7Bj9+otrY9PoEUs+WqR6mQGjTZ7Tj1gKVfoLQN4MQTH1NRtzkB1YO
 lkGZpiPyO/oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="467964709"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 03 Jun 2021 06:50:03 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 06:50:02 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 06:50:02 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 3 Jun 2021 06:50:02 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 3 Jun 2021 06:49:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Objw2GF0bGDcc3NivlpigYovqz1yW/NjNmOpmmCedgbvCJ5ld+g/7SPrIkIlT7CpEUNMGi7Qb3yOQKdlbPCDTFMwt4eyfokxzkbcnjOsqEtM+TxsNhE14QGoihUL5PMNiQZDBTduUrUBHW8Y1LX1QMUnpl6zF1FstDedBzHpOUHXlUqGr1SqJYoVSRGm2iyzJpTnYus6DVZBKtg4cloNzsbyY8UhRFyMBp0boFjFtcaw1wyvl7me9z3+4QKKeS34clnCCe6lcWwTnzc0NY72Pazh9rRDXkzoQCjmRvBLC5jM0bit/GPc3qsTIYv8tKBX2TpxN+shfNxKq6I3aFrKAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rGH9GEbRvBl1ME3FcmrBf3qyR1tOTdqMW066lyDh7Y=;
 b=Z7493TEPH5r0/B+440PVqEu7cPIWLcFU9y5UBVBSGs1nZ4AHOwbYZu0gLWwJSGkuT5wvfdD2ts8uuWI/cu8Rdvxbx6pEkhY9piwGPtPONL25UEn85J8Y+4vWH7XS3skGKYlS8qzYvYxfuWNmS3KzmkKXRmB8Grr4Ytt1NgbbqpUJUTxLvTtgAL/ZZ8kyvFrdeLIh4lm7hCuZtW4E7Xl3LOTxT2dkgIP2yfk1Kz04Tcf7b3rKK17TTUyU0/7dkXvI5k+K0v6L6RqONZDPbWD/Tuv0f1TJeJ7XCUJzg+zJcUd8UoheyJDYUQdkALJnGmjnVGIfZEwFKfTVd5QBpIxzIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rGH9GEbRvBl1ME3FcmrBf3qyR1tOTdqMW066lyDh7Y=;
 b=Zt21katDrMcRISQ5UjblBQVHnEaEerlBtMJl8qKPPzB+W+w0yRIqujzgbpThi75+zmMiDe9PZ7YK95YkASO1ru9h8EkZ4wgn//Fy6vlJTlY99IK1py3u9LqvwjrqCnF/KWM9qAhzB3Ibwwc33siwgdZF2WI2JYq0aSlZSGmNXkc=
Received: from SA2PR11MB5051.namprd11.prod.outlook.com (2603:10b6:806:11f::9)
 by SA2PR11MB5178.namprd11.prod.outlook.com (2603:10b6:806:fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 3 Jun
 2021 13:49:21 +0000
Received: from SA2PR11MB5051.namprd11.prod.outlook.com
 ([fe80::c9d1:585:b56b:b3ce]) by SA2PR11MB5051.namprd11.prod.outlook.com
 ([fe80::c9d1:585:b56b:b3ce%3]) with mapi id 15.20.4195.024; Thu, 3 Jun 2021
 13:49:20 +0000
From:   "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RESEND PATCH net-next v4 1/3] net: stmmac: split xPCS setup from
 mdio register
Thread-Topic: [RESEND PATCH net-next v4 1/3] net: stmmac: split xPCS setup
 from mdio register
Thread-Index: AQHXWG9Vf0H4HqJeQ0WhvEJpntXirqsCRbMAgAAGNvA=
Date:   Thu, 3 Jun 2021 13:49:20 +0000
Message-ID: <SA2PR11MB50513D751429D3D456A5A9409D3C9@SA2PR11MB5051.namprd11.prod.outlook.com>
References: <20210603115032.2470-1-michael.wei.hong.sit@intel.com>
 <20210603115032.2470-2-michael.wei.hong.sit@intel.com>
 <20210603132056.zklgtbsslbkgqtsn@skbuf>
In-Reply-To: <20210603132056.zklgtbsslbkgqtsn@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [58.71.211.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4b25cc3-3796-44b6-7898-08d9269663a9
x-ms-traffictypediagnostic: SA2PR11MB5178:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB517864BE7BC3333DCC74B78D9D3C9@SA2PR11MB5178.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AfU4i8tVM1reNHpYzUbf2abcB0XPmc2WibJlcA8ZJnXTiXklZYDYE927xJg79id3roldfNtWhSI5aQJxW0lLrwrDkvxYCdo7y00yv9L3Y9t2CkVYlJmECC5BYf6m+D6wIcQBf7es7DVPJSk+LT+qJoQqgCeh/84Hki234pXGlBZQtlYog8MMzcIbDBG5WpFzyZTuvu9wHlQCZzwLjQ0z9MnXCZF9AB0RNPkfXDe94TEQO9qmSVEvIU8xrVo6ylUQXBtolpqLBzcSAwckYVtQUflQV82fMTLduu9aHjO4jzz8TiKA1nQrH66v/FDEFTOVTwLG/AjT1SWQSlQOLEDHwLkpThHKTvoHjouk3KOf39nDyUTb0RNoSUer4B29ZrDtfm/NN4Ax5yAfcMcYM1wWoudkH4/nEPcXL5syWdkkS8nfnEWkPiG36ibZ4GRc7AUQwA2wESv80z5gxTWVlWOVtHrYvqu3pX6c30+T0gFiFIC8FUhSwzitT2Pt8rEHCkFWh/CsjlgeV6z6lkEl2R7RsPV6aonR7oouzDAZsyqbvoEGMebR7ReoQc0kO7+UqW00m+/pH69GwZkZPUTnr+0LIv+yEvyuUlbGRD2oGu27ZVo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5051.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(396003)(39860400002)(366004)(478600001)(33656002)(76116006)(8936002)(66476007)(186003)(7416002)(66556008)(4326008)(66946007)(7696005)(86362001)(66446008)(83380400001)(52536014)(6916009)(53546011)(9686003)(55016002)(316002)(8676002)(122000001)(71200400001)(38100700002)(54906003)(6506007)(2906002)(64756008)(5660300002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?zxI2g/bR6vVYzkNk9diGTSb3eOQhC86qKrbBa3DHo96K1YSqcTb5w0A4uap5?=
 =?us-ascii?Q?gQGQ8tdZSMMlrJCQfoCf/E+0/k46QeAn7hZt+8eihIaovnCQatGyrwOj32Az?=
 =?us-ascii?Q?FUleV34nTrfx+WAWZMxjWc1kUFHOgVzsu2BGHdPzo6u4yqRJigd63aU1NOfX?=
 =?us-ascii?Q?OukAfgmzTrbbZu5nxjaYUMksfDw7s+DvNQfM5ROX0b78yfteuvI8bVQCK7Rn?=
 =?us-ascii?Q?gASkSAxb3MO2akstS9f2AscOfDvbYKauYW0XbQmiDIB24TFeBYYroefyeRae?=
 =?us-ascii?Q?W9NJTPV8Ck/zlmifPTAJSNuyEFXIm9n8NMwJLgWXUJqNHskEIjMC8Xogkfyq?=
 =?us-ascii?Q?qR4u9yT4au4o0H+uX0izZFxhpkk6r7NKAwx5ioR68Tj/rk6AYTeowAsEpruo?=
 =?us-ascii?Q?7zw5k8Wu8RFDrs1FyEu2gsVQichOZOZaMNKvwlJTpoqiE3D9gAyujwxmPICX?=
 =?us-ascii?Q?WSAciCU2q8PY+lY2nSa7yFamkT5t4h08YRPsG101kOVyqqqjZyrd21Gb5CIo?=
 =?us-ascii?Q?xHgBymAve2h3W1p12vRXz/fTR6+QC1AkRCWC+UBNNFVAtp2n4H5sNJ20uOOD?=
 =?us-ascii?Q?OCLAsHCdggLZldUO0tyBJjV7+E+TFnlKfP4J3b1VHOLVoiaad4zcjvia0eIi?=
 =?us-ascii?Q?z3Ip1rq1W6DfnBEBPzLk31uDs4KIhjU+m25rxjnjqQ+sqtSp5KBQkHrGegB8?=
 =?us-ascii?Q?x+KFhUIq9JPLQYnWWzzA7c5K6MnzE3pJ7P0/lJwdnof4aWp/Uf850D5abfDH?=
 =?us-ascii?Q?/1FbZtLWdy5HCJvf054dC6SjIsHWmZJYn0/dYYwG9af/nZncUNf3Pp16u8KF?=
 =?us-ascii?Q?fm0sdpumAXNqWgC3SH6xyNkahRlQrht58A6skLrbr0prgbZdlSQj5QsDywpw?=
 =?us-ascii?Q?BFUGjxxwoxWmmQv6C/Y14GFsNP8q6ER/ZqZ1Npv/4PqhkVgoeRQOLUWCamWT?=
 =?us-ascii?Q?mLBa5ii+gria2fFuBweaHcZQGUZviVlhmP+q6UlQwYGD26ubFkVnWWu+5uKU?=
 =?us-ascii?Q?HbBDlvxjUTkve83Mtq4VbiRtipPKNSi1AlHVkKMW1wIFMRSu06GBcedQ/Wuz?=
 =?us-ascii?Q?AAFqM6mpZKUl3MO4BsMQRoEkExwz/mR504cqjiuI6qPir7f0ER0UL2RjNVcF?=
 =?us-ascii?Q?ciCNZfUR9ZdP3oIACXunI2ifDvLWR4VO+V3xSxVhQ3gQQ3cVJHYivY4mROS2?=
 =?us-ascii?Q?dTOU8qbYfEwIyHUgcfkQr5wk5T9p2H3qLSwzsfzZ5BF7biIAEoqKs30Ah/b5?=
 =?us-ascii?Q?odgfdDwMo3apq1g/ar4+bKeW9E0JaV5sojhrbVWhsWS4G6GPd7dA9UWolby9?=
 =?us-ascii?Q?ZzM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5051.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b25cc3-3796-44b6-7898-08d9269663a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 13:49:20.6296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +/H3y9DIF7dKY727/ZJF21ZI8CvjH/JDFJfV/ccKSc0GR+IiZfXlQ2b7CX6WXYDFP4rlHbSnl47QMZh88ujNVy02GPxSfwU910NRg5F/tes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5178
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: Thursday, June 3, 2021 9:21 PM
> To: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>
> Cc: Jose.Abreu@synopsys.com; andrew@lunn.ch;
> hkallweit1@gmail.com; linux@armlinux.org.uk; kuba@kernel.org;
> netdev@vger.kernel.org; peppe.cavallaro@st.com;
> alexandre.torgue@foss.st.com; davem@davemloft.net;
> mcoquelin.stm32@gmail.com; Voon, Weifeng
> <weifeng.voon@intel.com>; Ong, Boon Leong
> <boon.leong.ong@intel.com>; Tan, Tee Min
> <tee.min.tan@intel.com>; vee.khee.wong@linux.intel.com;
> Wong, Vee Khee <vee.khee.wong@intel.com>; linux-stm32@st-
> md-mailman.stormreply.com; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [RESEND PATCH net-next v4 1/3] net: stmmac: split
> xPCS setup from mdio register
>=20
> Hi Michael,
>=20
> On Thu, Jun 03, 2021 at 07:50:30PM +0800, Michael Sit Wei Hong
> wrote:
> > From: Voon Weifeng <weifeng.voon@intel.com>
> >
> > This patch is a preparation patch for the enabling of Intel mGbE
> > 2.5Gbps link speed. The Intel mGbR link speed configuration
> (1G/2.5G)
> > is depends on a mdio ADHOC register which can be configured
> in the bios menu.
> > As PHY interface might be different for 1G and 2.5G, the mdio
> bus need
> > be ready to check the link speed and select the PHY interface
> before
> > probing the xPCS.
> >
> > Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> > Signed-off-by: Michael Sit Wei Hong
> <michael.wei.hong.sit@intel.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
> > .../net/ethernet/stmicro/stmmac/stmmac_main.c |  7 ++
> > .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 73
> ++++++++++---------
> >  3 files changed, 46 insertions(+), 35 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> > b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> > index b6cd43eda7ac..fd7212afc543 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> > @@ -311,6 +311,7 @@ enum stmmac_state {  int
> > stmmac_mdio_unregister(struct net_device *ndev);  int
> > stmmac_mdio_register(struct net_device *ndev);  int
> > stmmac_mdio_reset(struct mii_bus *mii);
> > +int stmmac_xpcs_setup(struct mii_bus *mii);
> >  void stmmac_set_ethtool_ops(struct net_device *netdev);
> >
> >  void stmmac_ptp_register(struct stmmac_priv *priv); diff --git
> > a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 13720bf6f6ff..eb81baeb13b0 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -7002,6 +7002,12 @@ int stmmac_dvr_probe(struct device
> *device,
> >  		}
> >  	}
> >
> > +	if (priv->plat->mdio_bus_data->has_xpcs) {
> > +		ret =3D stmmac_xpcs_setup(priv->mii);
> > +		if (ret)
> > +			goto error_xpcs_setup;
> > +	}
> > +
>=20
> I don't understand why this change is necessary?
>=20
> The XPCS probing code was at the end of
> stmmac_mdio_register().
> You moved the code right _after_ stmmac_mdio_register().
> So the code flow is exactly the same.
>=20
Yes, the code flow may look the same, but for intel platforms,
we need to read the mdio ADHOC register to determine the link speed
that is set in the BIOS, after reading the mdio ADHOC register value,
we can determine the link speed and set the appropriate phy_interface
for 1G/2.5G, where 2.5G uses the PHY_INTERFACE_MODE_2500BASEX
and 1G uses the PHY_INTERFACE_MODE_SGMII.

The register reading function is added in between the mdio_register and
xpcs_setup in patch 3 of the series

> >  	ret =3D stmmac_phy_setup(priv);
> >  	if (ret) {
> >  		netdev_err(ndev, "failed to setup phy (%d)\n",
> ret); @@ -7038,6
> > +7044,7 @@ int stmmac_dvr_probe(struct device *device,
> >  	unregister_netdev(ndev);
> >  error_netdev_register:
> >  	phylink_destroy(priv->phylink);
> > +error_xpcs_setup:
> >  error_phy_setup:
> >  	if (priv->hw->pcs !=3D STMMAC_PCS_TBI &&
> >  	    priv->hw->pcs !=3D STMMAC_PCS_RTBI) diff --git
> > a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> > b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> > index e293bf1ce9f3..3bb0a787f136 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> > @@ -397,6 +397,44 @@ int stmmac_mdio_reset(struct mii_bus
> *bus)
> >  	return 0;
> >  }
> >
> > +int stmmac_xpcs_setup(struct mii_bus *bus) {
> > +	int mode, max_addr, addr, found, ret;
> > +	struct net_device *ndev =3D bus->priv;
> > +	struct mdio_xpcs_args *xpcs;
> > +	struct stmmac_priv *priv;
> > +
> > +	priv =3D netdev_priv(ndev);
> > +	xpcs =3D &priv->hw->xpcs_args;
> > +	mode =3D priv->plat->phy_interface;
> > +	max_addr =3D PHY_MAX_ADDR;
> > +
> > +	priv->hw->xpcs =3D mdio_xpcs_get_ops();
> > +	if (!priv->hw->xpcs)
> > +		return -ENODEV;
> > +
> > +	/* Try to probe the XPCS by scanning all addresses. */
> > +	xpcs->bus =3D bus;
> > +	found =3D 0;
> > +
> > +	for (addr =3D 0; addr < max_addr; addr++) {
> > +		xpcs->addr =3D addr;
> > +
> > +		ret =3D stmmac_xpcs_probe(priv, xpcs, mode);
> > +		if (!ret) {
> > +			found =3D 1;
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (!found) {
> > +		dev_warn(priv->device, "No xPCS found\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> >  /**
> >   * stmmac_mdio_register
> >   * @ndev: net device structure
> > @@ -444,14 +482,6 @@ int stmmac_mdio_register(struct
> net_device *ndev)
> >  		max_addr =3D PHY_MAX_ADDR;
> >  	}
> >
> > -	if (mdio_bus_data->has_xpcs) {
> > -		priv->hw->xpcs =3D mdio_xpcs_get_ops();
> > -		if (!priv->hw->xpcs) {
> > -			err =3D -ENODEV;
> > -			goto bus_register_fail;
> > -		}
> > -	}
> > -
> >  	if (mdio_bus_data->needs_reset)
> >  		new_bus->reset =3D &stmmac_mdio_reset;
> >
> > @@ -509,38 +539,11 @@ int stmmac_mdio_register(struct
> net_device *ndev)
> >  		goto no_phy_found;
> >  	}
> >
> > -	/* Try to probe the XPCS by scanning all addresses. */
> > -	if (priv->hw->xpcs) {
> > -		struct mdio_xpcs_args *xpcs =3D &priv->hw-
> >xpcs_args;
> > -		int ret, mode =3D priv->plat->phy_interface;
> > -		max_addr =3D PHY_MAX_ADDR;
> > -
> > -		xpcs->bus =3D new_bus;
> > -
> > -		found =3D 0;
> > -		for (addr =3D 0; addr < max_addr; addr++) {
> > -			xpcs->addr =3D addr;
> > -
> > -			ret =3D stmmac_xpcs_probe(priv, xpcs,
> mode);
> > -			if (!ret) {
> > -				found =3D 1;
> > -				break;
> > -			}
> > -		}
> > -
> > -		if (!found && !mdio_node) {
> > -			dev_warn(dev, "No XPCS found\n");
> > -			err =3D -ENODEV;
> > -			goto no_xpcs_found;
> > -		}
> > -	}
> > -
> >  bus_register_done:
> >  	priv->mii =3D new_bus;
> >
> >  	return 0;
> >
> > -no_xpcs_found:
> >  no_phy_found:
> >  	mdiobus_unregister(new_bus);
> >  bus_register_fail:
> > --
> > 2.17.1
> >
