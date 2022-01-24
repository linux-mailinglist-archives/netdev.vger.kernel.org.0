Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BE5499E78
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 00:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1588957AbiAXWej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 17:34:39 -0500
Received: from mga12.intel.com ([192.55.52.136]:46514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1586960AbiAXW1f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 17:27:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643063254; x=1674599254;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SkhGlcXZ/KhFY3zlftA3IK5kXFtOH5avpPxNlI3o3as=;
  b=JeA95MVSZ234ffZhBQ8xojxztsdOHGqp/NRNDIoOtfsp8jnm0lgbDlis
   wuEczMPLB9F4kbLV6bGkjm/195wouzq1yseCKILRizKvIW2Op4sQ2emoO
   BogW2u/Ckt94AbSj+J/3PaIr7ryJLyqZh9jFgJqmNarI44PQPxwyzBqrE
   DAHGze3y0yoNScT0cgkZKBOoVYMuL1CU2gZMLPdHen9giGWYjo4AwtPnT
   XA0D09grc4TFTnWaMaifuq+Wj2NbDesDLzmk6HeqrSee3dWpT6ienqSrF
   Or22z/gweudhaeJyqM7vPsRS5ZK5JR9hSBX0T/GjUgUOUlGCNx2SJYig3
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="226140352"
X-IronPort-AV: E=Sophos;i="5.88,313,1635231600"; 
   d="scan'208";a="226140352"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 14:19:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,313,1635231600"; 
   d="scan'208";a="520124475"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 24 Jan 2022 14:19:25 -0800
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 24 Jan 2022 14:19:24 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 24 Jan 2022 14:19:24 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 24 Jan 2022 14:19:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzdKnlDzDOBfYBlOwoY/gp1t/fMYpSDLwoL+OzIIu4JD1+UlIQxWVOZqxto6PndMtYN/c2/ZrA/bvvK4aVhAPp3rzbekv8GHg8tLB424Pe9HqU/3xkqFhSl+dp/nvRXjF12eykzWAgs+uXAWUs1thXeMMA56lf26OcJehP4WMBdafQ3q9cJLHiVo7Ce/SJpcIGzfG2dN7gUq8b+QLmac+cx/n8W7bYpumbca7Ev3ZUDb4uNeIlRtqEjYiWM9MPVw0tWPCUnsp8frY7WV0wS/BwBoehaJ+MFXcHIh8li3jNOyFzz6pOzCIUnhBb0apDkhAeZ+bpsy7o5w5ZC3nkrasw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GmqvccmV2IPT5mqBtdY21u/GYlyexpNGmFe3nm5Y8k4=;
 b=PQyMmSOAqwCxduDrRj6awXyvFfPesDnW/+7XeT3UXlLReR16XzWMx9tnWYjizxcCJ59+LdQ0NHk4RiSUI6C1j9k9+DNlz6dqh07M0xHw1j0mCAjROgpbI/r3lsi+KBNN03f+RSYdLbYksP/YL6uatNxxVcBL75JwL0hPIMGHUt1bYs3KAnGEeIRWy1e5WcSRT7W0UJEzXUYx3PiqbMrdbpcd0IgWr2XcfuCU7D4JWOEFXChqTTYKZnifRZEbRELw+ssN4VasQTNgYj0KfuQKABKi7KyjJ/aLu5s6uHlraFo1JI97u1KDGtNIWch91saVUGPk5OIUy0vD3t5Ah/1GIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by DM8PR11MB5703.namprd11.prod.outlook.com (2603:10b6:8:22::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.10; Mon, 24 Jan 2022 22:19:22 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::4843:15c6:62c1:d088]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::4843:15c6:62c1:d088%3]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 22:19:22 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 2/2] net: stmmac: skip only stmmac_ptp_register when
 resume from suspend
Thread-Topic: [PATCH net 2/2] net: stmmac: skip only stmmac_ptp_register when
 resume from suspend
Thread-Index: AQHYEQlKejz1LyD95Uq5S5Mw/hCt1KxyJtCAgACV8/A=
Date:   Mon, 24 Jan 2022 22:19:22 +0000
Message-ID: <CO1PR11MB47716D7115E85AC4649CD3A5D55E9@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220124095951.23845-1-mohammad.athari.ismail@intel.com>
 <20220124095951.23845-3-mohammad.athari.ismail@intel.com>
 <Ye6maxMtt68JlZ9l@lunn.ch>
In-Reply-To: <Ye6maxMtt68JlZ9l@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37533dcd-13a4-4cc4-07fd-08d9df8792ec
x-ms-traffictypediagnostic: DM8PR11MB5703:EE_
x-microsoft-antispam-prvs: <DM8PR11MB5703E46FFD3865E7017B946CD55E9@DM8PR11MB5703.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KkW2Wo1w5lyuv1RkleavmKVgTCrPWahakwy1bzhc2lZTXwBPFESNTXk3KQHDosKg620rR++BZwGO4PAn8lQwlvbH9gheAuHoeWjwVBqwfuS+KgdDAkXSYyrDlX0VvMcjQf2LAQLqpfORfFHLqiY3J/s9bODnGM0L1dIZ/GlJg6OrUCdRd6Vodx0iFtPNoKUBbHrVLYQf0p+3o+5QnNkw7PwXrE6HVCiZmG2SfammO1MXotoe5mTeQAcaRvJTclyE2racVwQAXCaPju10WzpecBfcfvoDxiGq06tsY/amjT7Y3HE3MCXh+7ZQ4POrzC3qQ96+/O0ZTlbS2B4qhCqKQy+9dCevi5q5T9FtPy1u7KAaC94N/LwAWc56LgIc5uhJq+8vL7Cqc1tbB26d4AbLwYWXkAxgVhVKDIIcriyQtnYU+iMw7K9VQhW2xDSc2nhKG7Gp8MhhhfC0LOA7thD+li5ecJY7O4Nz12XNDhbi0ttVLJYNi9nuE2WbWOQ6RrdVtucrUUkqKIUUmyGIaypY9q9rjxyq66jXTZaEbq2cdLDcUoky3+7LGesuK/ptRGTRjEHca6LYhLN/p/9WC1iXtsdApTWE1vL/yZjtDGfSeBcHVF6saEDGR5t8U0K2ExnbVHpsA8yOxEeANCuBqjg6EHp+2r6dEEMwBjEL6AT5SPVX+i2ecF8wjuusbrz7c7To8jD5XVujN1Veg1wyYzht9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(82960400001)(8936002)(7416002)(52536014)(8676002)(122000001)(55016003)(15650500001)(26005)(5660300002)(6916009)(33656002)(6506007)(76116006)(66946007)(66476007)(66446008)(66556008)(64756008)(508600001)(83380400001)(53546011)(86362001)(38070700005)(38100700002)(7696005)(2906002)(9686003)(186003)(316002)(4326008)(54906003)(71200400001)(55236004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5/bVobfpoPl29sCON0oLrfFq8JkCpWM6q+fcuHQWgWizTgdMUQlrLKrP9ODE?=
 =?us-ascii?Q?xqUncH3UL5olLFJWwPx3cKfp6g6GfEaX4KY8SGNrP5oOiPGcrdybvbo/zIee?=
 =?us-ascii?Q?UZNWzVWUef4/HoJ0WoZApFe+Cw7m5CmqU3qkmE67akaay2I6rUt5BF29/CEi?=
 =?us-ascii?Q?0w3E2l2+3GcKGbppLrRE67cG+dPbovmuUtdpyKblqQNbs8ESWN2ZhfAQDwN+?=
 =?us-ascii?Q?tnR89Z4rbxOpiys0yHTIYmSmQOcYGktVxuiZy7y45hI2NzFlPEIeZQnZsSyd?=
 =?us-ascii?Q?/6VvYgXwBy4AdOPrdK5B933dmRz7gMSFsRetLf1JsWt9PXMRjDq1UyBaBPVG?=
 =?us-ascii?Q?CRI/z4DXDM7p7YLrRm0XjvyUc+NrC0FRlzjMquY4lh73tN5p7eFbhjAhSGP5?=
 =?us-ascii?Q?xSBCBN9jq828HjTOWbNB2KGA6oZemi9dWK7HDWLEggmRDSug0+ogNOfDCJz8?=
 =?us-ascii?Q?Kg0TWz2NzjvjxCdwfznFZCR1ez41CgtTtQZpqRqxvW49A8S43o9FtmUrrwPo?=
 =?us-ascii?Q?DwneogHS6oqOvR5NqIn1u4IfhAgnD/C4b/k//iCX8o9OH9IobfG52TeDZeUD?=
 =?us-ascii?Q?16XSXrGtTDZ7Fz2P010MbOD1Qw+l8eonxJqh3PF4u8KQKPhLUyndiDP1+MJ0?=
 =?us-ascii?Q?O5R8O61yzKG4WAqUDxAM4XjSP5k0QTBveFiMcLG6ijMCYc8yPvdeLpku4fgO?=
 =?us-ascii?Q?bOUAI6wejOTSgM1rO7jAybzwSaJAv3MzgtI/vlSq/h7wxvdiLSMI8ksGOM+q?=
 =?us-ascii?Q?xEqzOSFvTUnBT9hvx/qGvipDB9N0o1u5dGzNM653wuNIU/akgQo2HNgYShHW?=
 =?us-ascii?Q?x/RHaqIMyZwZlinNj7b3rM90H/MmOP4UfsqBXIM4lLPLKm1vlBX8nX1Z4nqD?=
 =?us-ascii?Q?c9K1WCicIuqR+dJpp0Vxzz0MvI/TJ7N9e4yQbH3j2tzvhG+0zbACfM6tooNu?=
 =?us-ascii?Q?dL8+kZXdLTH3Q1iLnYgjsic0r57k18zKTmRnxCBFgGL17rGxJqKyDz5GQiHP?=
 =?us-ascii?Q?SYr8Zj6YzB6+pz9FTrCQE0O9QlexGLtcI4JqC8YNP8Gjwd9zCRi2Mj9DjMUm?=
 =?us-ascii?Q?C+RP1LJKqBbRhKPOfldxhlcCDO0vDfEz8GArBJzfWQ5jxpAwea8g0BrT7zMK?=
 =?us-ascii?Q?ou6STh8IsL6qS+A6sPIH5jto7i9HUBKY9L6UBZm40lk75nSnL1awR8nQXX/H?=
 =?us-ascii?Q?qztDQaQpWQsVTpNWoG5DuFxDk7ea/Cs36sdhHCYhoDMynDG7ZMxGRQaM07Wv?=
 =?us-ascii?Q?0+cAGZMZhisfELGDDcFdtk960zCNNOeZ3li2QWm2gL/jukbXnBSERYcZV68A?=
 =?us-ascii?Q?DX/2g8CInkazWTAaY2VsJBAB757bBZCIKndBksT7fqYVf+9wJ2eKX/tnN7hI?=
 =?us-ascii?Q?t6lfNUCrFxKbgNRMvqWCkujiZlToXqTujSezQelP6AWRvfbekYOVcePk/OnJ?=
 =?us-ascii?Q?kkMyUhIcoBH6iTrMYdw75+73BhSadoyobZhxEUEnkW+iBIychc/1ZBiH5CrW?=
 =?us-ascii?Q?D/pueu/QZQC822amX4tXBsyBx/f8kwHLhOxwGfCXo7t26Y7JioDh9VeyPygO?=
 =?us-ascii?Q?Lz2Kpn++rOb23kBuNj1LIGpMa1L/zg1qnaRYCyQDtfc5e+5EZxhDqpBqP4qT?=
 =?us-ascii?Q?M428r/s6HC+raSyX49EC7GZiDA6SjCCdjOU8FXLvbxxfWGTwxLuuUkyMJ6FJ?=
 =?us-ascii?Q?g3LK5qNeost7NO51sabDCMOksrbDSd047FRb4zJINswxj7zYLGPG6I3ya53K?=
 =?us-ascii?Q?76OAwGThSA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37533dcd-13a4-4cc4-07fd-08d9df8792ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2022 22:19:22.6907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KFT4GxVG7WpRinjXOXeojP00ITTRBkB5nKJYVwMeIqAcZUJfnLAM/7UfgOLiZdWOqbUVhbHVIcOiHoiXFd+U3J+20kxz+9GCiA1eztySz441CCMz2XJtMZWUKBmUgEPU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5703
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, January 24, 2022 9:15 PM
> To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre Torgue
> <alexandre.torgue@st.com>; Jose Abreu <joabreu@synopsys.com>; David
> S . Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> Maxime Coquelin <mcoquelin.stm32@gmail.com>; Ong, Boon Leong
> <boon.leong.ong@intel.com>; Voon, Weifeng <weifeng.voon@intel.com>;
> Wong, Vee Khee <vee.khee.wong@intel.com>; Huacai Chen
> <chenhuacai@kernel.org>; netdev@vger.kernel.org; linux-stm32@st-md-
> mailman.stormreply.com; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net 2/2] net: stmmac: skip only stmmac_ptp_register
> when resume from suspend
>=20
> > @@ -3308,13 +3309,11 @@ static int stmmac_hw_setup(struct net_device
> *dev, bool init_ptp)
> >
> >  	stmmac_mmc_setup(priv);
> >
> > -	if (init_ptp) {
> > -		ret =3D stmmac_init_ptp(priv);
> > -		if (ret =3D=3D -EOPNOTSUPP)
> > -			netdev_warn(priv->dev, "PTP not supported by
> HW\n");
> > -		else if (ret)
> > -			netdev_warn(priv->dev, "PTP init failed\n");
> > -	}
> > +	ret =3D stmmac_init_ptp(priv, ptp_register);
> > +	if (ret =3D=3D -EOPNOTSUPP)
> > +		netdev_warn(priv->dev, "PTP not supported by HW\n");
> > +	else if (ret)
> > +		netdev_warn(priv->dev, "PTP init failed\n");
>=20
> The init_ptp parameter now seems unused? If so, please remove it.

I believe you miss below diff. It is renamed to ptp_register.

-static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
+static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 {
 	struct stmmac_priv *priv =3D netdev_priv(dev);


There are build warnings as below. I'll fix it in v2.

../drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:888: warning: Function=
 parameter or member 'ptp_register' not described in 'stmmac_init_ptp'
../drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:3256: warning: Excess =
function parameter 'init_ptp' description in 'stmmac_hw_setup

Thanks

-Athari-

>=20
>     Andrew
