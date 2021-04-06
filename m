Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB6D354F65
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 11:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240836AbhDFJF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 05:05:59 -0400
Received: from mga04.intel.com ([192.55.52.120]:58347 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233114AbhDFJF7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 05:05:59 -0400
IronPort-SDR: T6FYeaz4Ch0PK72/KJZsCo1ja9EdLymbJPePX7fK5ekcX1DzwbH+DoIKSah4X2lrxN9auflAWX
 qKdJN9Sajr4g==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="190855606"
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="190855606"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 02:05:51 -0700
IronPort-SDR: g/f80FV0Vaf1V6xTG+2xjY1WH8Z0wmUkLcn0G/qQi/QwEZQ2SPUMqnzBYrEussa8mQpAxgHbP8
 uC4Vt8+5igZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="414687036"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 06 Apr 2021 02:05:51 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 6 Apr 2021 02:05:51 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 6 Apr 2021 02:05:50 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 6 Apr 2021 02:05:50 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.56) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 6 Apr 2021 02:05:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqQ7ZreDtghPEDkZD8WR1r5/4NSuJhywQjTjwZGXjhzML1fRtks4fCYg70iW4gZZTYiM5Q3Pr8PnSiAN4YNtja01XiNuhmx8MqIs2+As85TTB1oL/kHyL463G1wmW49n+Z2yr0cuL2d7tIb0yMYxDZ5rCaM2ElC3+2kLdweOsKT/DFHkJ308CEUUdxI4AYElR0+os1mqBUYSCQEF4ZhAwGaB9HgtEZC1qN2Hwb5EM5VQFA5i2azYkA/4Udzr3krcMa55R8b83J728YjthDllgfByDrJeddFdNzQ8BTbB4Kl1KwUt7Uei6T/qBYwdW7JL6JzcMJ3/NL9Z7rakFfcc9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNPFudpmvNKDTQQvzgHYXbva+ws2nWqa+/h6wdLs1lE=;
 b=cRdl4l3zMYR7BhVM+3oHqJZf6c9G7nCDOWK7F+azA9saI7B4IEUgs5SO7JTmsrhu77MnVTIfgmNO3ZDkgOgyAWebhgfAA/mATYRX8RxCMa2rRQ5cOhtgdAo59E77+G/PL+tppkZbc/MDclMJ8FCHtlDFJDv5UF+TBy5kJ9rYf9TYHTFEpzcrHL00XyOeB6kua3Gn57r1RWhyoB3A7N+ykxHWQ2s8+pureHmV37HuKmjw//z6lj3fnlxbUo6DYuSgGXq/wSC6cmYYDaRVhIr/t0VtnI72uCKded46L+TkPwrqgk9a0FKWQU2Ia4IuceZXjvpi8cIZ2c/xI3oNlK6Usg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNPFudpmvNKDTQQvzgHYXbva+ws2nWqa+/h6wdLs1lE=;
 b=LXAr+iD0lOMKoNhCxEhfZxlPY2MYnwms/LLnlVhAakKGwvZBPadLNN6CcjKiKVhnzRhmqlG20vvU/KlhH/rr4qdWZnOx/XXc3n2oGKpcYXKTxckQ7jOWEvjRgtUTe70m4V02kYkmV1FxCMAKekxwjfkJ2uRiIDJeZxORW8S/9Do=
Received: from SN6PR11MB3136.namprd11.prod.outlook.com (2603:10b6:805:da::30)
 by SN6PR11MB2797.namprd11.prod.outlook.com (2603:10b6:805:5a::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Tue, 6 Apr
 2021 09:05:34 +0000
Received: from SN6PR11MB3136.namprd11.prod.outlook.com
 ([fe80::5143:5d07:51b:63a7]) by SN6PR11MB3136.namprd11.prod.outlook.com
 ([fe80::5143:5d07:51b:63a7%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 09:05:34 +0000
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
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
Subject: RE: [PATCH net-next v2 0/2] Enable 2.5Gbps speed for stmmac
Thread-Topic: [PATCH net-next v2 0/2] Enable 2.5Gbps speed for stmmac
Thread-Index: AQHXKg/Os9IaztXPaUy24X7Nc4wW6qql5igAgAAULACAAANOgIABLtjg
Date:   Tue, 6 Apr 2021 09:05:33 +0000
Message-ID: <SN6PR11MB313690E7953BF715A8F488D688769@SN6PR11MB3136.namprd11.prod.outlook.com>
References: <20210405112953.26008-1-michael.wei.hong.sit@intel.com>
 <YGsMbBW9h4H1y/T8@lunn.ch>
 <CO1PR11MB5044B1F80C412E6F0CAFD5509D779@CO1PR11MB5044.namprd11.prod.outlook.com>
 <YGsgHWItHcLFV9Kg@lunn.ch>
In-Reply-To: <YGsgHWItHcLFV9Kg@lunn.ch>
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
x-ms-office365-filtering-correlation-id: f410b4b4-0825-4269-50cc-08d8f8db22ff
x-ms-traffictypediagnostic: SN6PR11MB2797:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB27974192655A107BB20ECDA488769@SN6PR11MB2797.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GttzPCH/F2zVsBHr6iUtdGJrtoBmmgB8bMLX4JJJ7rVnVBrGwly41qID75IO7QheuKgVKaYHGr/wcRn4AfUVN96rjq3dHJ2vNOrPucsWFZ+giMTmsrxL2/q5oHJgLQmXpxHXa/Xr74JRIg35CjQDQdmgtasbPF+gG8mwLQBRTOdp+VR9xVfwAXAkIauQ7x84ftN2A8MkeOhRlRFuPrBLOp119iUPlVyWc7Vt2X2gRedXgJgVNXz9c7Aj4HV3/vvvBdU9gG5ZpvQERsZ3ZiGbHszCqaiFb777RBR52V64pXEm28WyGdQ4UffnP7Z1LO9dpKhZvhEHlK7d495I8uv43xNoODhpdnYzGtKlqJNXqs4w+9hWtMLr3JZxYUbkijc0B5pMVkNr0j0mYr5koVHzgfJsZldPI2uKPsNJyM3GEfjmdwzw1HHEFCSfpg6V5uEX6f5XmVdSzS9hTtFY3AHYQUk6JrOn4jimG/f2fzjP/OQ2j7I7RHqxwRJ1kCgMZIuZB5Zw4IuX86AaSjVIJXgUKwzZErbtUpDwt7VKkW5iaNIqxoz+8d/8VSDZrtnhyyxS2qlxC4bLS5+tlGFRaUKLbVjtcoZ1bPrtGLPxAiipTv2X30k0K1Wo3U3yaNEvGlr0S8IZAygtZeivsB8MsaL6yoE+/E1tYCeyDs1+GvMg+no=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3136.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(346002)(136003)(71200400001)(2906002)(83380400001)(33656002)(26005)(6636002)(4326008)(7696005)(478600001)(6506007)(8936002)(8676002)(54906003)(316002)(186003)(110136005)(66476007)(55016002)(9686003)(66946007)(66446008)(86362001)(66556008)(64756008)(38100700001)(52536014)(76116006)(5660300002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ppsRaYqIrANJgbDZMGqOM2R5Z8rI4l3klMZSxO5W0cEp8fnt16fPETJ7afY5?=
 =?us-ascii?Q?1zh0JDkLCoOvqiovPOQJZBubl/y94FmuP0U/Y/EPDnp+51dHWSZJvL3ZaYqU?=
 =?us-ascii?Q?DgmNpxplMXHk6tmusiQwyCAhWi6fKGCZCpkWIee1fnTg5jHIAWJaqEDqyPGq?=
 =?us-ascii?Q?0Ffn7p6e4LOt0XITyIY7/V6MiITVEIzWFE8SVkDPOeLQP/G5yZU9PqfhQO3J?=
 =?us-ascii?Q?iA059mOvUZo8YH9anl5BtatZd5P8rdI7+fB8XPEkc1Rh+asUSKmP2HwgnxDW?=
 =?us-ascii?Q?ntj9h5q/JcUg8KDvl82fGOflm/z/RrgR5q43647H++oo4LYoSlOwbHeiV7ip?=
 =?us-ascii?Q?QhcBn7sDPzppLtP/HFcBdxs/fRtJY8zNQ8FBqxvMjXwx9Ypvpu5FzKou++RM?=
 =?us-ascii?Q?czfV8402KZzKz4XTpw75hESOdgCFP7EE1mHtowVSkPWJ7iVhmIkR3Uz1PMrX?=
 =?us-ascii?Q?10n45+v8neRi+blidejtNGrT2ksuk1nsofqNZCUjjeS4DORl7E6fpUObW/k5?=
 =?us-ascii?Q?tGC9xJBUV/moUn32PA0K7hmw6lVLsGJSfAEJppYTZfszPEQxH91g5aJ4MhBr?=
 =?us-ascii?Q?KnsvIeNltOxUnDPSd8vFLuer730CEYzV1PtGKLK2wj1XEd98nK9PBRLL3ZRf?=
 =?us-ascii?Q?PeBy0m3iwSnor76JoRB9dJdwAeXF5vK8cSei3ry1YU+6Oj7GVemKMoSgBtSL?=
 =?us-ascii?Q?mf6tISxbcxeDDvt+dDcPOmhWYgjeBzzjZK/+Gj7uaeAMH64Y3ZqzpI1JUhuY?=
 =?us-ascii?Q?KvTu/iF9Ot4fvRFqCsl8orsfw8vCF3i3dJmf+bVSBtpnWxRlmMBo410Qx34f?=
 =?us-ascii?Q?jz1kSSc7d5yiubdW4ju51/mRI4n26ZXXHPIbj9prMEFbp8eP6omGCuyI6WUa?=
 =?us-ascii?Q?u00/JbXFa5vo3AECmz1v+X+nd4fPLnaJ7AuBV8kj1q24Qrjgua2JD6iHziEd?=
 =?us-ascii?Q?FC9AFhGxBptvYrdKJ7n9Ob9X86W6RPfhyL0joYabMCD4CeV++JJ+a6sMMQx1?=
 =?us-ascii?Q?h6z4HNtSmeRdr6Sg8n+Xq8PpiIS8hWHG5CltlrhBPqG+OW4VPeGGJI5yUUfk?=
 =?us-ascii?Q?wbRKgliyTOymtRRvy9Mjr8ZZBkT4LESgNby/Xz0OcRXCq7VjwVEql1oEB3B8?=
 =?us-ascii?Q?WYw1vPwaqoZoq0y+a2GouUnIkAOauTaTxpxeT7Z4YdkmyWsg6cBOyDaE9fsL?=
 =?us-ascii?Q?9AXudBWwXBJCWsFQY/fvtdjbwzMV2m2IpwqbbltsPFGFsp71wSN4KYUWP23c?=
 =?us-ascii?Q?/pbfiQXgBC1p2Q1eU6uKzLVoujiR9t0ngzRH09Erb6LReTITA+WaLKMvM4kq?=
 =?us-ascii?Q?9oKApc/GOb1+bbOU+HfOxEaK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3136.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f410b4b4-0825-4269-50cc-08d8f8db22ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2021 09:05:34.0110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1wma9xz5LscLKuHvqklmya86gxvmK1J/7JBMeMkvzR2OcRaU5TYmBx9XohkdOIsNmaNZQajrUW0JFR3ktmYbtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2797
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > You have a MAC and an PCS in the stmmac IP block. That then has some
> > > sort of SERDES interface, running 1000BaseX, SGMII, SGMII
> > > overclocked at 2.5G or 25000BaseX. Connected to the SERDES you have
> > > a PHY which converts to copper, giving you 2500BaseT.
> > >
> > > You said earlier, that the PHY can only do 2500BaseT. So it should
> > > be the PHY driver which sets supported to 2500BaseT and no other
> > > speeds.
> > >
> > > You should think about when somebody uses this MAC with a different
> > > PHY, one that can do the full range of 10/half through to 2.5G full.
> > > What generally happens is that the PHY performs auto-neg to
> > > determine the link speed. For 10M-1G speeds the PHY will configure
> > > its SERDES interface to SGMII and phylink will ask the PCS to also
> > > be configured to SGMII. If the PHY negotiates 2500BaseT, it will
> > > configure its side of the SERDES to 2500BaseX or SGMII overclocked
> > > at 2.5G. Again, phylink will ask the PCS to match what the PHY is
> > > doing.
> > >
> > > So, where exactly is the limitation in your hardware? PCS or PHY?
> > The limitation in the hardware is at the PCS side where it is either
> > running in SGMII 2.5G or SGMII 1G speeds.
> > When running on SGMII 2.5G speeds, we disable the in-band AN and use
> > 2.5G speed only
>=20
> So there is no actual limitation! The MAC should indicate it can do 10Hal=
f
> through to 2500BaseT. And you need to listen to PHYLINK and swap the PCS
> between SGMII to overclocked SGMII when it requests.
>=20
> PHYLINK will call stmmac_mac_config() and use state->interface to decide
> how to configure the PCS to match what the PHY is doing.
>=20
>      Andrew

The limitation is not on the MAC, PCS or the PHY. For Intel mgbe, the
overclocking of 2.5 times clock rate to support 2.5G is only able to be
configured in the BIOS during boot time. Kernel driver has no access to=20
modify the clock rate for 1Gbps/2.5G mode. The way to determined the=20
current 1G/2.5G mode is by reading a dedicated adhoc register through mdio =
bus.
In short, after the system boot up, it is either in 1G mode or 2.5G mode=20
which not able to be changed on the fly.=20

Since the stmmac MAC can pair with any PCS and PHY, I still prefer that we =
tie
this platform specific limitation with the of MAC. As stmmac does handle pl=
atform
specific config/limitation.=20

What is your thoughts?=20

Weifeng
