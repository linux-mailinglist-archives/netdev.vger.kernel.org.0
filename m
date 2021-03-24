Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658DF3473DB
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 09:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbhCXIoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 04:44:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:40371 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234314AbhCXInu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 04:43:50 -0400
IronPort-SDR: i675sr7hMHy3cUZz0FT1vrdipM40tIYLO9slcZbCENHhjs80L2Im53qlb3pA0p1XEXkhVFiA2z
 DNaSFCXQBAFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="177776929"
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="177776929"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 01:43:50 -0700
IronPort-SDR: 36JgTRJwl2Yyj+cX8VPZjfw8611F8CvLMMOfNmWES6dH1JZlFUMddiytBycFK9R8L/Lf2WFYTg
 MeNtGYDzV43A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="452508533"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 24 Mar 2021 01:43:50 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 24 Mar 2021 01:43:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 24 Mar 2021 01:43:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 24 Mar 2021 01:43:49 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 24 Mar 2021 01:43:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KR83Iu6bIjFVVr3gXHn02dnJbG5KCCOCR+4soiUmyH1rX3+Z+AZV9XwjjZh0hwO1wSnFWEyGxid9gFvHeGWp7/lfw8AXb+huwbuIEgVrkXOSKrDLMYUhh9dJKg58lY7O5CI/dXscIkoveBUl3xF20dR/B08Cs960HPcXc1/QHZtGRkIttp1cFaAPghcwDBjjuSGQhXYOHBfflHFMDiysiZhEvH9gDZy60iN20yIYMP8CFNxUxyQmm1zvH5mWIXfrPTe+FiXR+0Sh0e9abRuvRaqeGikrVH4Oe61XQPR7v4yOfwE0TRU64SULEet7MmZ9NpSuWSOeeEsIeKaZwzfWsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoJee1lQqhzW1ojkJsLcTlstl9PKkhsmdwxGcuLrS/Q=;
 b=mNDF+72FpsEDIzUiZiuAu/NUbVEqp7pdikZQULzWvaQIHsIqzR7YHQYBUEw2jhnP7/oPuWS1eSPjX4EvamQxfNPPL0AoFYTV3RDoYr13RLcou3AT2FPovUmhkUJj1WaaiR0txVjnjYyn+lXmVoC0NV27XbKou/AvX4F7Qal7aTx/MObtb9XESWtCyDbe/J/a7CZ2M6RdjZfMOX8eLnsaS3Oyrrx+az2kvh44Adzg8e27rG1WuNlfyw+U8XaMUTgYzlevPGhHkfeH92UGIfYHKiztrx2b7AZuugyzGMJn2gPYnr0kKaiaUy/3hYqPzSHeiRW0sRGeutWwbJPcdbieqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoJee1lQqhzW1ojkJsLcTlstl9PKkhsmdwxGcuLrS/Q=;
 b=EcR1dhSZiAWIk+ZHsFsVmsmq3Kf82J/T0o5b+HYJX6mBgkYNSs7ABTSBI7biBxdjryi+bZpEMbuFR64/2kQid98/fRU47fMGvOiwG1AvF4WVAsPF6kklig9Lk3jxO97OzfFSOZwaAUFeKe1MItjBqpKeLx7pMC5UuLOOLtIc2TI=
Received: from SN6PR11MB3136.namprd11.prod.outlook.com (2603:10b6:805:da::30)
 by SA0PR11MB4606.namprd11.prod.outlook.com (2603:10b6:806:71::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.23; Wed, 24 Mar
 2021 08:43:47 +0000
Received: from SN6PR11MB3136.namprd11.prod.outlook.com
 ([fe80::5567:bb0:fc06:911c]) by SN6PR11MB3136.namprd11.prod.outlook.com
 ([fe80::5567:bb0:fc06:911c%7]) with mapi id 15.20.3955.025; Wed, 24 Mar 2021
 08:43:46 +0000
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Alexandre Torgue" <alexandre.torgue@st.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>
Subject: RE: [RESEND v1 net-next 3/5] net: stmmac: introduce MSI Interrupt
 routines for mac, safety, RX & TX
Thread-Topic: [RESEND v1 net-next 3/5] net: stmmac: introduce MSI Interrupt
 routines for mac, safety, RX & TX
Thread-Index: AQHXGl6D5u7FcW5YjU+hoGa8akSEOaqHIjWAgAuf1uA=
Date:   Wed, 24 Mar 2021 08:43:46 +0000
Message-ID: <SN6PR11MB3136CE39DA28B20378A25D6988639@SN6PR11MB3136.namprd11.prod.outlook.com>
References: <20210316121823.18659-1-weifeng.voon@intel.com>
        <20210316121823.18659-4-weifeng.voon@intel.com>
 <20210316142941.3ea1e24d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316142941.3ea1e24d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [161.142.179.154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8ebd7e8-eabf-45f8-70cc-08d8eea0f07c
x-ms-traffictypediagnostic: SA0PR11MB4606:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB46068B9F41F63106ACCFAD3F88639@SA0PR11MB4606.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /tSoNk4qPgHJHtOoBb9OMujPVbCF1RCUfzAfMxS9QVmSDSz/TqOP7BhLGtkarKaMBUfjaoYRN8ccJmPxbR9XUkN8nz3nhkeU9fK9YxtgOu+BX7IO2qCxuDbTHyzKt5V4Mx7uozkimVASCs3wLPhYkRP/4t0avC1jvKLBGVS5kGqxHV1XZF2jakzBZtOn3J/bVDgbfh4KJdM+Qz0PszVaPhf+xnz88xrSn0PopMCkRDol7znssuIO29kDNVda7An7xaX+2VGzJiet33b1AXmu6q7uovASyMTbzQ/SvlJyQLF9CEEhqEzgwXeilEJx9vgr86gp3TnosG/n0pXyxZnCuBUa9PdOaeVateQym8ZF4Dtk3otFN/k8a+zxxmMUray6N7mr2v9Bx4W53l5yZ0csX0ig079kpkGXDZIh2K8/LBW2muPGfI7hdaJGOgx/bH0HvZlO0pSkNbNrMTxXMX5jrNgeSuzI2mCarB/Iy+Xkbx7K0Mlrxe35sayU2EmW6qo3IpWKNw4XywjMGg4S6zlkNtFu+su44TGgBPClL7Dr1vXL1XrjN4GQReH1vKbu9NRSJOw9vgENCH78lNn2x+O+wY490sHIqRcW0Bqfob90vJO9Ba7Lue85QoLdYdN2UXekU4zuuyiCNwEZ1VgOyad69Lnf1yQsRrtZ41D0jefjodbIuioJdntwMvHp0colixNhvv8CEw0n4A14SpR+ijXNFDsRMi5Q2ZH0VQ/JNPJNxOv9NYR3O7okXdnyL3rRGGz0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3136.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(346002)(366004)(396003)(66946007)(316002)(76116006)(66446008)(54906003)(86362001)(107886003)(33656002)(478600001)(64756008)(8936002)(5660300002)(71200400001)(966005)(6506007)(38100700001)(7416002)(83380400001)(66556008)(66476007)(9686003)(8676002)(52536014)(4326008)(7696005)(186003)(26005)(55016002)(2906002)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?FCIJg9ivUZv2BPVVrDERBznC0OBkabfTBJTi0RXfQ5yGkMboNKDa1TppiwRG?=
 =?us-ascii?Q?kn2v5TcKoN1mhnTlHWqj+D104SzsoSKtgyXl4mhV1+KFdpPmd3TPuD39BXXf?=
 =?us-ascii?Q?d989kIhiRBGMM++OxU/O+e/SPuiDrBiBQsU9mkaZbhOETtFpophF3BVzXqGS?=
 =?us-ascii?Q?EKsiJsvo0nVP2DqoKOJcf8Y/VspdyPFRAThiICHRvkQk0gv97NBvEGSUfhUR?=
 =?us-ascii?Q?NGA9ieSc1NtS9OXD5XSi+BGXYYs8P/JkLz5pCDvoJmxXlbp9DC9X3BBUuujp?=
 =?us-ascii?Q?FoiAN9Qh6rpm6usQt85Xm+n0q9mks9gm3L4Ic1FHmft8+F4vdC4fq/XTgOm3?=
 =?us-ascii?Q?gYkmQ6fvUfQMTGepU0/Ke57l2fZ50MuPOdTQ9BmX4Oa7D7ZHbsXsRelOqTbn?=
 =?us-ascii?Q?E4DMpXPH/kb6wSojhJxcg3CE16gPR5coTFSoL7nr+/iraQGIH86aGVVWsE27?=
 =?us-ascii?Q?+ZMXn6wT8mikAitsKt8nWTEEm0vKaqy9yYSQ3mb1w3guju0fCyW5SFcy54Co?=
 =?us-ascii?Q?mGjIKjvUwKUHReJueXz4YmaK/sq379SvP7idbcumrqVLCfWiC9cdUGfxuKV0?=
 =?us-ascii?Q?9cFjBJ6gtceKeVeBhaglVYJW85/1wzMU6D8SWCBoSt3dTl+S5jteUZUJX72f?=
 =?us-ascii?Q?7zUY+vozmkLPxItjXBc2nZ/59H5TIKMVYKuOMYaL4nNJFMzDIjxGQJF154BE?=
 =?us-ascii?Q?oEt5UArTmfbMY/s5BqT/iX13vl1Cjrb+FbWnOJeqZDIZ+JAABDUk1EYS69KD?=
 =?us-ascii?Q?KRd96hCwNX/8Tgw7HZBpdM9iQzThiWuraWW1JEjgDJQG+IrnguAILYIhztYd?=
 =?us-ascii?Q?7RwaCi7xcJw6tmWL/OJDWpv1LCwilUzaC/U/bhaX/Qf9GOk9fE1pPfdvqjMe?=
 =?us-ascii?Q?jyYa7rL7O1rMB2C1nhpBF1UKf/fBAXBl8nH2qHZv6XyDhk4s8Jb6XsxI4wVs?=
 =?us-ascii?Q?t3xVI8m1lhkHIvGI+pejsisCpWIRp1xdVEmGyeEJ0lBDPPfNPoUyT5MxPA4U?=
 =?us-ascii?Q?K7aH2ISH7PAW7LR4Yd3/TyuT/wguzsCBiYU2L7Rs/fSN7LBmM0yzsED7d/lW?=
 =?us-ascii?Q?amOoMssxuo6LRZUdD3vHQFJ89yu1o4KktjVVPoE5MJfDurB4bz/JG2iNuyu2?=
 =?us-ascii?Q?snmwdCh+UXcS9/Y/8bk+5pZDR92Ae8QXXNzeLhdaTAuHiOm+DSiTQ7CwiRZo?=
 =?us-ascii?Q?oE2ed4OKVgoKwXAECYH+GNi11J6LHg+SY+fMcJtUB/A9szIBHrjgvsghfcFu?=
 =?us-ascii?Q?Mqjy97tr8jKyeuk/wxdsL10QuCnMcHtjksuRSVq3BLoaitwcEDG41I1u+8nN?=
 =?us-ascii?Q?VHoyoNERrqwPvOIuFJSgfU/Q?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3136.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ebd7e8-eabf-45f8-70cc-08d8eea0f07c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 08:43:46.8231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UvehGvEKgPuwRc1JDBNu+n+SyVhIXFSWf/7+wO3lQpCJPOEcOmCpmmtem2jt9WKJwAbRzoK/NUikeTGc4cONCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4606
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, 16 Mar 2021 20:18:21 +0800 Voon Weifeng wrote:
> > From: Ong Boon Leong <boon.leong.ong@intel.com>
> >
> > Now we introduce MSI interrupt service routines and hook these
> > routines up if stmmac_open() sees valid irq line being requested:-
> >
> > stmmac_mac_interrupt()    :- MAC (dev->irq), WOL (wol_irq), LPI (lpi_ir=
q)
> > stmmac_safety_interrupt() :- Safety Feat Correctible Error (sfty_ce_irq=
)
> >                              & Uncorrectible Error (sfty_ue_irq)
> > stmmac_msi_intr_rx()      :- For all RX MSI irq (rx_irq)
> > stmmac_msi_intr_tx()      :- For all TX MSI irq (tx_irq)
>=20
> Do you split RX and TX irqs out on purpose? Most commonly one queue pair
> maps to one CPU, so using single IRQ for Rx and Tx results in fewer IRQs
> being triggered and better system performance.

Yes, the RX and TX irqs are split out on purpose as the hardware is designe=
d
to have independent MSI vector. You can refer the 4th patch in the this pat=
chset.
https://patchwork.kernel.org/project/netdevbpf/patch/20210316121823.18659-5=
-weifeng.voon@intel.com/ =20
This design also gives us the flexibility to group RX/TX MSI vectors to spe=
cific CPU freely.

Weifeng


> > Each of IRQs will have its unique name so that we can differentiate
> > them easily under /proc/interrupts.
> >
> > Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> > Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
>=20
> > +static int stmmac_request_irq(struct net_device *dev)
>=20
> This function is a one huge if statement, please factor out both sides in=
to
> separate subfunctions.

Noted. Will do.

>=20
> > +	netdev_info(priv->dev, "PASS: requesting IRQs\n");
>=20
> Does the user really need to know interrupts were requested on every prob=
e?

Will remove.

>=20
> > +	return ret;
>=20
> return 0; ?

Good catch, will fix.

>=20
> > +irq_error:
> > +	stmmac_free_irq(dev, irq_err, irq_idx);
> > +	return ret;
> > +}
