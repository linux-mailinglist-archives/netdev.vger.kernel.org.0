Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF267353EC6
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 12:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238526AbhDEJH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 05:07:59 -0400
Received: from mga17.intel.com ([192.55.52.151]:42206 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238441AbhDEJHo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 05:07:44 -0400
IronPort-SDR: LAA0i2o4G4fDNpxFg8KYsZGcfsMrf+TOcbx2xZciN4MZedIu9Uge2l2v0JPqc+FHNF+GJmNYv0
 CcrJqUvLNguQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9944"; a="172877866"
X-IronPort-AV: E=Sophos;i="5.81,306,1610438400"; 
   d="scan'208";a="172877866"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 02:07:37 -0700
IronPort-SDR: fH2ML6emRSpCo+NfikLFPZ/vwKbgwrBbAyhkbiaepJshQDWZlkUel2akqwWPWwqsHCnAUTFGr8
 2CkPQdLkS+dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,306,1610438400"; 
   d="scan'208";a="378906220"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 05 Apr 2021 02:07:36 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 5 Apr 2021 02:07:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 5 Apr 2021 02:07:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 5 Apr 2021 02:07:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjTtubBAj6ZYRXVBZ+WOQL18GDH03EOvVT6amn4UBOw61Uji+gAgGFXt8Ky696DxqmL8QroFONY0+KvVgYyH4LynAvD8HXUaXtitRYdzP52lizrF/+Lot7OQnY+g+klol0a64BM0xePwNZeKuySkI9LCEfZrR2fOJroEWNTftHOnsNLXGMTQ9BcWS7WZqW1amRLca9JHFHtQMi1YVSBEzTBcaglQladiUX2E/UK/Ms0E8pMDIWZoVXGSUbOvlz9Hbk78hq7TVQuArWiXQt3BETcJgKChttUAjxmNyQb0m88BONN73HxoGbxWNH2EYmLbkhn+EuRSSQ1iscjvXKhfyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+3eUH3gHS8ghb7WCU+CxVT8FlqtgDqtPNxI9yBa8+4=;
 b=GbfV4YfL3kNHOA3d9gN+XVwkRbMDuXKufuY/aBF4Q5T75oWWTHCclVJXrMxrvzJ9yfAD0kE/Dt4wcUg+JbBAoXY6PL2n9F0j7Ripp2O5l9wcTPOiHQ3x/lIHkReoYodjWsFOQaBF5kGeue3vbM6tLLjygXasu5zukdH7hDFXAFRaQVaz58FYcJjc+HL7jcJT3Fe809ZIXAaMfd2zXDI/u4T44GVdl/9UjXK3eFNNdAZ/tmOMlPTdHNEUHnZ1WTfVFkrXTgfdMxacJFONcPd+SGvqRvmZlbbL27B5hk4mFco9hFV8h9Zbx4ca051S9PyajEYCiEXd1eju11T39Sn6eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+3eUH3gHS8ghb7WCU+CxVT8FlqtgDqtPNxI9yBa8+4=;
 b=dKqBEs4eEy1zJGr1wTiCbwGVNXPhNgprWqyOaf3X3ebI59ZEDrNfbRFrX+oxRMUCM0WFlPbZ2XDagdpZogPgAxppi5Achw29jXuWPRA3UlUDKlCec/nu3B2aTXXBdTImAsivxIQRUxuw6mCanOPgtORgAYdz1W6TACFbeNO1Ztw=
Received: from SN6PR11MB3136.namprd11.prod.outlook.com (2603:10b6:805:da::30)
 by SA2PR11MB4922.namprd11.prod.outlook.com (2603:10b6:806:111::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Mon, 5 Apr
 2021 09:07:34 +0000
Received: from SN6PR11MB3136.namprd11.prod.outlook.com
 ([fe80::5143:5d07:51b:63a7]) by SN6PR11MB3136.namprd11.prod.outlook.com
 ([fe80::5143:5d07:51b:63a7%5]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 09:07:34 +0000
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "qiangqing.zhang@nxp.com" <qiangqing.zhang@nxp.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
Subject: RE: [PATCH net-next 1/2] net: stmmac: enable 2.5Gbps link speed
Thread-Topic: [PATCH net-next 1/2] net: stmmac: enable 2.5Gbps link speed
Thread-Index: AQHXJwi9OfCjiapOEkC0eUgABv6UiaqfxE4AgAEOrbCAAFgjgIAEcT7w
Date:   Mon, 5 Apr 2021 09:07:34 +0000
Message-ID: <SN6PR11MB3136C4F44116EC909186742C88779@SN6PR11MB3136.namprd11.prod.outlook.com>
References: <20210401150152.22444-1-michael.wei.hong.sit@intel.com>
 <20210401150152.22444-2-michael.wei.hong.sit@intel.com>
 <20210401151044.GZ1463@shell.armlinux.org.uk>
 <SN6PR11MB3136F7A7ACA1A5C324031607887A9@SN6PR11MB3136.namprd11.prod.outlook.com>
 <YGcPc3dan0ocRSG2@lunn.ch>
In-Reply-To: <YGcPc3dan0ocRSG2@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-originating-ip: [202.190.27.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 330aef9b-f3b4-4af5-9d9d-08d8f812406d
x-ms-traffictypediagnostic: SA2PR11MB4922:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB49222ECC505FADDE339CBCD688779@SA2PR11MB4922.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3e1RHtyp9KSZXF8gMZwpEZIG2X2F/qOY6WMfT09BplnoVDCLc4aDBtOsPqmfsvXVJo6qtf7mtE8cqEtTTnwwZ9dfV0nBwCXFfW+0Ha6OUwhfob2spROc+IG+9a5ysyoZ/BeqEvbjwjUQNUK3HDBx0RNtDNhg8Wz6lMhaI6FVdReWx00eYorVz+rK/fn0p8LXQOX6kh39lo88E/AoDk4zeLKnB/6UFpx85LlxAM1fQlZECW7oP3vJVVTgnoOicxrp3MaafojsLZFiJ3V5XV7EY0DFMj9EYESeAkQ0hmgCc88sTzk+rY9Bj2826bjkLsqY7cznpQx7pYOYFVa+rFob1irsSUQuo4OascVCWGsmxxiaUF6znZrnXOKTjh9NyJb57KSP8oE2CnnXGshPBg/lX7/UDz7Dw7mFm6kAX8SYGYLVfcdPvXWf/MhBTjxRMUv1r96oncpCMpwPNiBFMWTFQAjf7ZSQ4sImBGFq1Z0i3ngtR/bqaDz3csRa5ChvhpGautZQy9aOq8EMysk6na8+p9Aakxb/OwRgLjPwo0UHqVy+hDUX5h3X32dECNDkgWFFaAvrOPJPTEu5mFahxeXEAHV3A77lQHSMCcRbYTI8AzkLPlY4Bh/2Z5uaI7q88hO8THuWHTkEOURWIDdt+l4ktH0lizXoOZW/lEo3+cAiJ4c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3136.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(346002)(376002)(366004)(7416002)(2906002)(6916009)(8936002)(26005)(55016002)(66446008)(71200400001)(86362001)(186003)(54906003)(66476007)(316002)(7696005)(478600001)(6506007)(5660300002)(64756008)(66946007)(52536014)(33656002)(76116006)(66556008)(9686003)(8676002)(4326008)(38100700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?J38iB2vcq+pjNiqM9NulN7oTCZErRdrxJ3MObD9hIi/TJwRz1Y5K074pYUde?=
 =?us-ascii?Q?2k8EIwwV2rJ2ioMKffSkIlEMVXHdL8aJICm3GfB8o9SxCZdyReCwDNrZ7X8L?=
 =?us-ascii?Q?BBNunePZ1VjpOt2sgaCKM+uHRPCdLqVw9W5tfdedGI/dGsrMh+9WKPT4fIZS?=
 =?us-ascii?Q?oxsbQyqtkp24RZsa8boM0paIy5HmKnMl0tGeR26rO9p3fh62IbpvIw2tK3pg?=
 =?us-ascii?Q?vvap9Tz3oWADJp0D5032x7BioLdZ9g/8ygaOTEck14Abp9StdHTHyAilWiSB?=
 =?us-ascii?Q?qupxb1WrPmnMIGTCcCM4Tq5pnED3NXhe2ZZ1tuplkPgmETxypRD/umgZHI8R?=
 =?us-ascii?Q?bZ3PncR1Uk5C1VBI6mTiMSqVVsHC+x5plHUmsL5jtPxiwW14pU/Vr586BiPF?=
 =?us-ascii?Q?Yk5TG9u1mibuBH146r5m8MCCGe+Q/AbsYzPnHmLREv3CkpHOLRViWOeDp+rp?=
 =?us-ascii?Q?ls7tV0RmNk7UfURNohDmqM6oSxrdn44hfsZGQDX2x7UZnn3rYkZ/Xeauz8ZO?=
 =?us-ascii?Q?MKSjOeeLhJWbiaJDM7GksUereIhBUtZJ/tAGEABCoHtAd2wkymdaGsoMxqRO?=
 =?us-ascii?Q?L5Sc/A/FznpvMGrRwc7sWVjanZqa6Ojtwyk8Rl9oUu31/oS9wLsN+xCIag4v?=
 =?us-ascii?Q?d4a8uOIK7sOfHDlpqJ0aBH3f2Jrmu+uX0qDEydGGBj/A3MshnFhaPMEcaL37?=
 =?us-ascii?Q?cDf5T+CC4UIpgFMulNf2dyUTiAPSe0wNJzL8eq1r3xIiIpKWBwAdEoC9xX+d?=
 =?us-ascii?Q?pWiCJHeI/uJoEvjlQ4ZxZRHGPYO9p0J64ilal0EvSyUB+28K6+aCdESdzI37?=
 =?us-ascii?Q?9V4VKTR2teuijvxnK2xBaMqgDn3tKFi4HfRymlKSSAj5BJ/YmqoDSqGhtqsy?=
 =?us-ascii?Q?j+3EE/hCBy/qsG0SdID9ybCYQoXS8L60AO9wcuTFYhQVOHPHo8XnmZhGR+AJ?=
 =?us-ascii?Q?GjFNW6WxLJ4XIf9ejX2JMfI7Ch5acBx6IaEqguoHo/iicpWPXueqbpN4g2Ko?=
 =?us-ascii?Q?mEgEd7mt6Mw1X6PI5mNJbc0DSuRebJ+uZISYXhF2hkWdRW4IR3ETRBnRZBsX?=
 =?us-ascii?Q?MCw0YDlAwaCOp+zs2FSBuEtMUvAk7yVh88eLCahwuXtjoZBnHGHXCjivOv8g?=
 =?us-ascii?Q?0+iEuKlhbboSTKO3p8pDQ344UB2Qs28FVhdu9F7YCUmmKQhlMWgv9e/pd+d6?=
 =?us-ascii?Q?7ThhZbmHHxgkyxkpVDbFpQ75W/AL3dmncZgMLaC8EsYf23m3HkLuMOeU5GoP?=
 =?us-ascii?Q?zuRT6FHcKRi085EVVzt8tYp+Mn3ViWLTVLEKxZAZ3VU+WW6QTffrVrYZAk+k?=
 =?us-ascii?Q?3Lc0KjFHQlWR0iMhfArfrS8U?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3136.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 330aef9b-f3b4-4af5-9d9d-08d8f812406d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2021 09:07:34.4931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y5kRjTAYudyjAM+X+oK/2cXe9guYC942S0ccWt+jwJH/wh6O8WRTzE51xfCDmLXf30+dj3/fBp7LZZiGRoNBJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4922
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, Apr 02, 2021 at 07:45:04AM +0000, Voon, Weifeng wrote:
> > > > +	/* 2.5G mode only support 2500baseT full duplex only */
> > > > +	if (priv->plat->has_gmac4 && priv->plat->speed_2500_en) {
> > > > +		phylink_set(mac_supported, 2500baseT_Full);
> > > > +		phylink_set(mask, 10baseT_Half);
> > > > +		phylink_set(mask, 10baseT_Full);
> > > > +		phylink_set(mask, 100baseT_Half);
> > > > +		phylink_set(mask, 100baseT_Full);
> > > > +		phylink_set(mask, 1000baseT_Half);
> > > > +		phylink_set(mask, 1000baseT_Full);
> > > > +		phylink_set(mask, 1000baseKX_Full);
> > >
> > > Why? This seems at odds to the comment above?
> >
> > > What about 2500baseX_Full ?
> >
> > The comments explain that the PCS<->PHY link is in 2500BASE-X and why
> > 10/100/1000 link speed is mutually exclusive with 2500.
> > But the connected external PHY are twisted pair cable which only
> > supports 2500baseT_full.
>=20
> The PHY should indicate what modes its supports. The PHY drivers
> get_features() call should set supported to only 2500baseT_Full, if that =
is
> all it supports.
>=20
> What modes are actually used should then be the intersect of what both th=
e
> MAC and the PHY indicate they can do.

Noted Andrew. Instead of masking the 10/100/1000 mode support in the MAC, w=
e will
set the supported modes in the PCS.
