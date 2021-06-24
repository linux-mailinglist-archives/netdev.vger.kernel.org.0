Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEE73B2C1F
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 12:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhFXKKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 06:10:07 -0400
Received: from mga06.intel.com ([134.134.136.31]:38090 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231501AbhFXKKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 06:10:06 -0400
IronPort-SDR: JnBDOllJaagMqwjMcFCU/i8apQ/2ApxHTzGvUkCrZfdyHUqq0MXxTP3jE5GICZrt+omVti7vpo
 /Efg5b4MoDZg==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="268573065"
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="268573065"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 03:07:46 -0700
IronPort-SDR: hxGimYrNOVFnAVYS5aiFz35SY4Vcr2F1fYWKInQ+WQsKeQggLJyhs3w26bYdmF8uj7sWDSwPrI
 DHGfY4IsWbwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,296,1616482800"; 
   d="scan'208";a="406595499"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 24 Jun 2021 03:07:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 24 Jun 2021 03:07:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 24 Jun 2021 03:07:46 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 24 Jun 2021 03:07:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZ9E6nry9gDjD777in/EAExzICxrskTb/C1c1cb1X5GdrSfFifC0u7OiJcbzuXEQpIOJvjXBjEu6BkcnSPN4C6THRGj3Dv0cGPh7dMY8Nrmsknfi2Io2JnYyGBFUPz0uZqA0B32wlGIFg4HBOXlI3O0yse94oEwALWWIlBQmHf/S/45FMFXaZ8fqXDZWdfZ1R458BDyDzC55RPxIWJghRhU1KkHBXGyV4UTI3FHmED0VP/hnlcoTl2vlek+vQ/Hz0v1lRK8JdPQ0E9ZiVknMFHFj+ePdb1LJIbPKFL8hSv0L/UYV18LQ4VqgRoJkhRMK3GCaXr8vNTbY9mzWn1QnYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJufsYpJxF00DikROC5+5CtBfBu+tz7fawY4shda8ac=;
 b=FR1xUCEtpAkHIhV7CvpOYwPOfdJQJPQiYcyctRfirszvVIdzxToTPNHd7OJPVevGNRT1hibrcG4t5cnE+rstEuVtiCVe1ULxFQebxVN4GkW/n26WMUOolTcW2fTSrbuecMrJJa3R8kf54wz+L/5c+Y241bWuNdCTkr3mEjrvOKh/YTNRRxHqNvmfJaCNgt/7jLnU8oOEeygT/1OCo0P3V2BNkYoTpT+bgO5BgoNuufacx0TCa4OFDTL1I8LBCC00SMXFhLW5CBsc1sI5VcOd2CekiTk7CGRcUO5zyuYwpDAulF4Gdrj0byxS73lypZ2SyccXiHbQvNpxPzYqi2nVUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJufsYpJxF00DikROC5+5CtBfBu+tz7fawY4shda8ac=;
 b=PaM3bxfsX9PANmSpg9yguTovOuTzgEukUFFRjtX66cqmVv5PPXv2iY4sj6NPw4ixv7giSWo/ulEfW5c9V6q3P3vj4EksYPqj8ago5NmiYkTnJOhCKLk2pGfUZZUvokndkJ6DgaF4UGxPyG8y11xldoQIQIc6IGO0YNrVQlgE7dc=
Received: from CH0PR11MB5380.namprd11.prod.outlook.com (2603:10b6:610:bb::5)
 by CH0PR11MB5314.namprd11.prod.outlook.com (2603:10b6:610:bd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Thu, 24 Jun
 2021 10:07:44 +0000
Received: from CH0PR11MB5380.namprd11.prod.outlook.com
 ([fe80::d52:3043:fef4:ebcd]) by CH0PR11MB5380.namprd11.prod.outlook.com
 ([fe80::d52:3043:fef4:ebcd%4]) with mapi id 15.20.4264.020; Thu, 24 Jun 2021
 10:07:44 +0000
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "Ling, Pei Lee" <pei.lee.ling@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Jose Abreu" <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next V1 3/4] net: stmmac: Reconfigure the PHY WOL
 settings in stmmac_resume()
Thread-Topic: [PATCH net-next V1 3/4] net: stmmac: Reconfigure the PHY WOL
 settings in stmmac_resume()
Thread-Index: AQHXZoJFBtZ0uXgSn0S7qboFjm+Joqseb0UAgALh+bCAAK/dgIAA5rbA
Date:   Thu, 24 Jun 2021 10:07:44 +0000
Message-ID: <CH0PR11MB538084AFEA548F4B453C624F88079@CH0PR11MB5380.namprd11.prod.outlook.com>
References: <20210621094536.387442-1-pei.lee.ling@intel.com>
 <20210621094536.387442-4-pei.lee.ling@intel.com> <YNCOqGCDgSOy/yTP@lunn.ch>
 <CH0PR11MB53806E2DC74B2B9BE8F84D7088089@CH0PR11MB5380.namprd11.prod.outlook.com>
 <YNONPZAfmdyBMoL5@lunn.ch>
In-Reply-To: <YNONPZAfmdyBMoL5@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-originating-ip: [161.142.208.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1133637e-b8ad-4a98-33c7-08d936f7e953
x-ms-traffictypediagnostic: CH0PR11MB5314:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH0PR11MB5314FAFE4FC6A54363609D8388079@CH0PR11MB5314.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AvizZX7iySO088m26/GPGibArZb6RbbCYId0QFNkpsPoek554ZedlzSlW7Km9PE56YoIffJGZR1MQJXeoU+Dk5fNdbBA/s78hrp9/r487leLGGGyrV20cPRO/OcdxlqdpkMYzZOd2Cxzodj2rnKQK3m/rdQJB9CoqkXsiOCBP8OHL8bPBXLeAEFVrSLmRmTe8gg07ZZFym/pCPExTEMpoHWsw+JyofT8Qw9dhWuW/C7KnVDX5jJyzrDKrqhw/Bnrk4sH845BIIGCesf+2VtjaeEEouKvvQ4QslhcSh5D3ZhW6F6C/OGfBFj5hr/Q73gN7P1qlLh1cxHCE7tdf39foKCW9IwS5FYYGoPbXN7inhkn7wpyiLmgoyNoIj1MCNq4aS1ZCtxGUVCohVUk1y0ZHNIvP5rD7f8S4XQJj6IBLnxPf7FJYDBXFAaNZdhKixj4Udxyo81LWDoJ23vuJmj+nsZ0wJEYMjAjjdmjwu2YUovnSteaArFG0PLXgTrI2CMUtjJ+5OkfmXbW46f8NWuLIcQGQKJbaGjC1px4Bvc0fhXTg99ec6dEuJ0S3wpoAj4PpbKn9K5QHy3nKDZOSPXAqgfwjiuQU3r4hV8XBUgk7ds=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5380.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(39860400002)(136003)(346002)(8936002)(26005)(122000001)(9686003)(7416002)(38100700002)(55016002)(86362001)(8676002)(2906002)(66556008)(66476007)(71200400001)(4326008)(83380400001)(6506007)(54906003)(316002)(7696005)(64756008)(66446008)(76116006)(33656002)(66946007)(6916009)(5660300002)(52536014)(186003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3XVR+j8EspbckidKEfzrArgZKzgk0xj/FVvclqYDPJ8sPfFMbcFQ69rTMOqC?=
 =?us-ascii?Q?zCgMjteO5bPmk1bNhNAABaHDp8xC2Ho4zVmn8hM5S0do413FHUbrZmcQ7ESy?=
 =?us-ascii?Q?XLaKHoB/xoC+NeF0pQv7RQ/2lPDXPL2Zb90MOVkMR0pFIplWC3BQ01B6UtUk?=
 =?us-ascii?Q?4tJLUQA17i3rX1txYe2fxTVr46mOvae69ZGCZRhXrV/FJP35g9/qd6rgYofJ?=
 =?us-ascii?Q?w4vE9/qVRnjMxD8HTiI0UMhxqXxh8aZ8IEUGlX6WXpwUEo8Yz96Q/QxMuyRF?=
 =?us-ascii?Q?2D08H/xiLHp55xvpuClTeBjHZjDO1LCWCQf9PJbXgCNKD931Pdgcm5wT88um?=
 =?us-ascii?Q?yoEjHmI8eWNW4QuIfc0W51VKtpVmL1NHGD/354Geh//eIyHwwjvf77/Ugbje?=
 =?us-ascii?Q?sJ4u4Th7m8dimgcSK1vp3sSpZ8illQNolzUf/78etXjPRp/5jE7QwsWQvAx2?=
 =?us-ascii?Q?q/zlPDgVGdzXlRSujvYWoLWuyWX3E9E9dG7cbvdeczdhqVnHZLsEOOov1oR3?=
 =?us-ascii?Q?WpLAhBoiu8Dm67bqx75ucQaGiGPpTbQkYztj0QLaclwImb3G63P+rSxccCQ1?=
 =?us-ascii?Q?M9GBex+nCfdwwwzyl9OwNusC20HcRO18EuIaudmcavlleNO5rXRUVvHtd3Hj?=
 =?us-ascii?Q?hmQKztUIGf5k9uMlEOkSG8wvjBT8oSqF0/Tp5ZuRjS7XdS6H3TVL+76wtnPv?=
 =?us-ascii?Q?vwzhAqfBkkZ7A9UGXprI1djOEh9u94oY22IaeokAkQiHc82XRlgiIxoLjR3x?=
 =?us-ascii?Q?PtGvAbL2RTgoW1W8tAOiqZFVUOIC1CKrjMZCrnLaAmPr8lvanNBEBMC3xUpw?=
 =?us-ascii?Q?T/0Ct9vrb80Or+XYuLQiLo6bbLRBB6mP5DiWq+kKP/i86ItBQ2c10es9G7ju?=
 =?us-ascii?Q?FDUHDvfgRGKlIdD9u7IsrUOj4Fgz+jHMXVilG20VNAf5zP5wKq1Kau7X3eam?=
 =?us-ascii?Q?vs9PZoMs36OnB7rw+MT23q2Xq7ptYdZilPJNT8h+jPWQS99AJVopV1G7LEwH?=
 =?us-ascii?Q?Vxiddxql3mqO3C7k7ro+4kGVBe5mHoP86DEMYGLiWIc31mRjgtuWjEUy2Vk9?=
 =?us-ascii?Q?gaeS1v5tiXsGkT//gqxCt886P9LR0CRB7DGITCRgGEaZGlFC9CL9BRTkC1hJ?=
 =?us-ascii?Q?02BCo1r0rnMPAbbWtCxoQXvueyUUCqcvs1vufeo/G25oLYmeGDv2YV08DV72?=
 =?us-ascii?Q?iUPlg2KVhtcugAUTJU6JI8OObXJrEdI609LjdVbykgbrcBSwR5gehkoCFVEr?=
 =?us-ascii?Q?rFGF6J0e3bwjuK87Zba6GwbrYw8R2I0tnZAvfvurNsA2Q72R9E8d+k67pe+X?=
 =?us-ascii?Q?HCxPG6aFF9Xkx1kCUPFOCGa3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5380.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1133637e-b8ad-4a98-33c7-08d936f7e953
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2021 10:07:44.7528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oqXFlF9ycoYLsfvRIETYvkT9E4ccneasLfvkVSphgZ/rQvVy1R8YuLylOBrdy9j1nU+4eWtyHG9be1UrJMKPqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5314
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > After PHY received a magic packet, the PHY WOL event will be
> > > > triggered then PHY WOL event interrupt will be disarmed.
> > > > Ethtool settings will remain with WOL enabled after a S3/S4
> > > > suspend resume cycle as expected. Hence,the driver should
> > > > reconfigure the PHY settings to reenable/disable WOL depending on
> > > > the ethtool WOL settings in the resume flow.
> > >
> > > Please could you explain this a bit more? I'm wondering if you have
> > > a PHY driver bug. PHY WOL should remain enabled until it is
> > > explicitly disabled.
> > >
> > > 	Andrew
> >
> > Let's take Marvell 1510 as example.
> >
> > As explained in driver/net/phy/marvell.c
> > 1773 >------->-------/* If WOL event happened once, the LED[2]
> > interrupt pin
> > 1774 >------->------- * will not be cleared unless we reading the
> > interrupt status
> > 1775 >------->------- * register.
> >
> > The WOL event will not able trigger again if the driver does not clear
> > the interrupt status.
> > Are we expecting PHY driver will automatically clears the interrupt
> > status rather than trigger from the MAC driver?
>=20
> So you are saying the interrupt it getting discarded? I would of though i=
t
> is this interrupt which brings to system out of suspend, and it should
> trigger the usual action, i.e. call the interrupt handler. That should th=
en
> clear the interrupt.
>=20
> 	 Andrew

No, the interrupt will not be discarded. If the PHY is in interrupt mode, t=
he
interrupt handler will triggers and ISR will clear the WOL status bit.=20
The condition here is when the PHY is in polling mode, the PHY driver does =
not
have any other mechanism to clear the WOL interrupt status bit.
Hence, we need to go through the PHY set_wol() again.=20

Weifeng
