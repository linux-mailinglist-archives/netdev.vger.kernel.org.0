Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EE12FA6E0
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405500AbhARQ6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:58:42 -0500
Received: from mail.eaton.com ([192.104.67.6]:10400 "EHLO mail.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405961AbhARQ6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 11:58:15 -0500
Received: from mail.eaton.com (loutcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD3F78C163;
        Mon, 18 Jan 2021 11:57:24 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1610989044;
        bh=tudSffqi+DEpkH2dRu6jDhwaPwHeAVQ+5cZ8x2pjlv4=; h=From:To:Date;
        b=pOm00GjC9frejoE8NEeC8HdXZstiyXKNTCgiI1mz9W9QpLjjwCzJ2Pptji2K/5vny
         +h7w0r1QxylxxQkzbtqCzyVT+TlBYgDeE/RXBojMclZ74idZCFIQIuy90J9Ea73kTA
         PAKaR/UvbYWEaH0ctQgHxubbbo8F/hWCwu/jJP3KhgMhuXHgPXCCcV+Assi6HOHICi
         1cXaArPFebCQrdD93vMTVdPnvNEkYW1y9X/kr9RtDHfAvUsEvDC7At8HWcwgkKlGzI
         L0Bj3NbWg0h0ZAh2s7cxM+G/uYnFh6joLkt4YWEM/ld11GCK+oa08kWsgvbjbDO3vF
         lZlE5WiYyp9yw==
Received: from mail.eaton.com (loutcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9215B8C162;
        Mon, 18 Jan 2021 11:57:24 -0500 (EST)
Received: from SIMTCSGWY01.napa.ad.etn.com (simtcsgwy01.napa.ad.etn.com [151.110.126.183])
        by mail.eaton.com (Postfix) with ESMTPS;
        Mon, 18 Jan 2021 11:57:24 -0500 (EST)
Received: from LOUTCSHUB05.napa.ad.etn.com (151.110.40.78) by
 SIMTCSGWY01.napa.ad.etn.com (151.110.126.183) with Microsoft SMTP Server
 (TLS) id 14.3.487.0; Mon, 18 Jan 2021 11:57:24 -0500
Received: from USSTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.154) by
 LOUTCSHUB05.napa.ad.etn.com (151.110.40.78) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 18 Jan 2021 11:57:23 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 hybridmail.eaton.com (151.110.240.154) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Mon, 18 Jan 2021 11:57:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F7s+S/Nkp3plsyxipq1yAUMVtV5mQcUnAYjrrcamJL8fBuTUGAwTwlWT30eAGn1z/rrpAhSdYHuPLU0H4IbE1SMG4hbghpxz0bqceLy8TihvDu0TKYaoe1rrzIwk00Hfnz9kG6QQO3j9LgqqM6DeE8T1fSUHE725tvvEgnF56S3ptkd3Z/lvkpc95G4tm9Zzb4exwMMz2dSTeUSOQZNK4eA6yRpnQJdKmgguEbczfPU10Oi8Q3nuOn9NX53JYU4lMvDCnnXItZNQJrQs429hrGZ+IHKyaKbSPkgSnl/LK6wxsJyLMj64WcpXqfS74HG18fDLSwsXDcOm9FEM4tC+HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSHJ5ScGLwxUVoW65yZIj0bEuR0WgISHW2bf7fD6j0c=;
 b=EszyloeJEMmFrNkQFgCcxVkM627/r8I4QWCjso1k+JjK5qqS75SnApdpD1IV9/qH2waFb+LrWt/8NPV5AxUbnMS0JPiUXnBxZNWgkHiVX59nDgwfUiGsOyglrFEET10Q6FKQ9F7rkh7qJ4PsJd4wzgoDYtNcCfvoXLYVwViY/FYIACgQ2hdBGIB26b3Fptg/xqa6JTaQ/jOhoTGhKAcmmqB5XiBJLSk0ySk/TfbfbD1aUQxlu0zHU+tQtqSKskNZlhEawwl84lmCEaCWDjk6vADpuzMFC5eQuQfHecJ7kLc3pyXTuZTzrev/Lxzz8BZ2hfVvufPwNIpkhjX8+Zctaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSHJ5ScGLwxUVoW65yZIj0bEuR0WgISHW2bf7fD6j0c=;
 b=UmsXHaRlIsAnr6UXpdSod8g5ypAHCo4TLZMLSmdQtDVZI7gE5YJXhIAeLh9W64KJLfxnO99sLJyAkpRw+uwvmaFuEyjNf38EhnV4+Qifc7WAiyy2oLB2+HeGlsMW2iMCwFhBU+P0gzZBwFQ30AyXALP2VyvdBgTjyPuxVUM7UxQ=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MWHPR1701MB1743.namprd17.prod.outlook.com (2603:10b6:301:1b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Mon, 18 Jan
 2021 16:57:21 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 16:57:21 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     "Badel, Laurent" <LaurentBadel@eaton.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "marex@denx.de" <marex@denx.de>
Subject: [PATCH v4 net-next 0/5] net: phy: Fix SMSC LAN87xx external reset
Thread-Topic: [PATCH v4 net-next 0/5] net: phy: Fix SMSC LAN87xx external
 reset
Thread-Index: Adbtun6FqUuZJJF1QZurTznkrBttxA==
Date:   Mon, 18 Jan 2021 16:57:21 +0000
Message-ID: <MW4PR17MB42439280269409B3094724CCDFA40@MW4PR17MB4243.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: eaton.com; dkim=none (message not signed)
 header.d=none;eaton.com; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3984bbc5-8338-4916-e676-08d8bbd21f83
x-ms-traffictypediagnostic: MWHPR1701MB1743:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1701MB1743A3732175B2F818EAFC25DFA40@MWHPR1701MB1743.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WDIq4QAmmfLHVukAjUuxmWowpFoGHQ0MDkpXI8wcrav2AkNpaJT8Uw2ewWrAMdlgBcIC5lBKoaZw2AR2vfAfYGeZlE3ntAbsdu1EMhB8a4RZMyFslHDQYl3YB7gTxXPOEOndTAixHJaBhwc+281T/6LGYe6D40FxhkLErsu1YmOL+ODpVsT1k3un5NIsrAJiDYU/BhZIadUbhBykRfMTrM7so7cXsNpIahbBu1kf79mxRaPCkrY84GVVpsmyZ9mO+0elbI7582bw08LeXcZTamoBWS029+OwV25bpIrLlnYuVxkRS7Vo7t9k3ZGB0W7Cwus0uiFm4yxtdIXtE4jqJFMgJk8JiTk/g1V42PK00EnkRBamfZ6aKQJMQUcMq2SuGs/qPKCqZFpueUulsrFfrnJjEpSG+VFW0z4CVM3RYICLngIr9r/qyF4nVOEN0gfAo8xO7TYo+3PlO3nnTlm8iATlRAiGxS/zgfHltl2kL8GMAYZM2/FkEL6yGMtZWG1EMZZPONyXeL+zG5MLws6VtIhJhnWZqbu6c6u+jjjMao8//z0X0Y1uekXF7fZ9UgWd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(376002)(346002)(396003)(52536014)(478600001)(26005)(83380400001)(76116006)(316002)(6506007)(7416002)(66946007)(8936002)(64756008)(66446008)(86362001)(110136005)(7696005)(66556008)(2906002)(33656002)(55016002)(8676002)(5660300002)(71200400001)(921005)(186003)(66476007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2sK/p8D9E8o1zH62eB5MOvKxaWSvXV7J+Z8k2pCQMJayS9navUYxWuSkkB0/?=
 =?us-ascii?Q?C9eZANpy/H+Q0e7LlaP/aj0W6fuYoJ4hmyeXQL22/r0hXnoiHAkffqspTYQt?=
 =?us-ascii?Q?KwXmdIE6Fs7syi32txkod+oPwBWKLGJsvR9cJ4s8dgvkk8kuMKAi4X8KicYo?=
 =?us-ascii?Q?ruDV96pzXubhV5h7AdFn90/OF0kOcMmef0YTGusiommLoeWOzpZWdvVnDitN?=
 =?us-ascii?Q?qYYYGQRmpCH5PEXgtIIY5ZsnC6PcGUVeX7Q6/onnq+QTylEiLmBfJWUNM4hJ?=
 =?us-ascii?Q?/mplJcRDN5eJPWQy4gMoEWqxg37XvshvtsEKQ8sTHhNKJ7NzDB50kHxZhXP8?=
 =?us-ascii?Q?VHVBWlGEXtz4RQWPivafInH7QyXVPC5Uiw01zjzg8mwmijrpwVtCatjFClnm?=
 =?us-ascii?Q?IlF+vUtg9ufPkL5MmLHBe4VejuAWKDmTfyQjVUHTaJTVfomcYjemgXWiZ8+V?=
 =?us-ascii?Q?dI5KPFnq5lMPhSyhxjerRnvqygeN6Px5e6wrTb8iqOvd50ofNi9NeLUoawjF?=
 =?us-ascii?Q?vHN9fmz88BIvd6HFlvjJpPjAe/mx5+8PXIQi7q2VCDqrDqMeAytDJ/E3LRFN?=
 =?us-ascii?Q?RrOKVl1twqG8PsFc3yoNSX5nUke1TkXupV+VPA2U8tpjlFmSXawrR5P5BPW3?=
 =?us-ascii?Q?GpZHHnUYcuqnEVhb6LI6mHXRvHu6/SoKVhiRlTCM4OR/750kt4HYvvxdv2wZ?=
 =?us-ascii?Q?0AM5DK2LQh5lmHBDcbiaonjh9XC7zwVHlf/mjLa3E7atSe8GMJZx0wnd1b71?=
 =?us-ascii?Q?jewPvHDZI44LHunkKvsy3vB2vgpv+mi7P6DlafgQvJt2y+4vXVGIIUC3eAxh?=
 =?us-ascii?Q?PlwrKMdnPNFMcfxS1up7dKPL7H9+y22BJOxPCtzqOYXely8jz9Q2/oqrLHlP?=
 =?us-ascii?Q?2/5SQ4CsVLbuCd8U0HJ/+V2i1/xvUdttWqQ6M5vuwMpydoAOPK+9d90duzYW?=
 =?us-ascii?Q?1x+k1pO0RBakjFz3HFUUYcVfChnGAYpxFdjnn/N6lkQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3984bbc5-8338-4916-e676-08d8bbd21f83
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2021 16:57:21.8134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4R8OD2FyxdsF+7/YaegfGh62E+aqJMhs48FQstwO7+c62/dBUU3qB7q4OlHEyRG3bHWognEARlonNGvS1eiVrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1701MB1743
X-TM-SNTS-SMTP: 005D0DAC5FE5A4C0A98FC8811A77FBD3E9640073105B0AAAD9C3CAB0586FFB832002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25920.001
X-TM-AS-Result: No-2.181-7.0-31-10
X-imss-scan-details: No-2.181-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25920.001
X-TMASE-Result: 10-2.180700-10.000000
X-TMASE-MatchedRID: Wp5ILcJd6aE1tD9Y6M1xN44uBIdoKfjuQ8iUCoDj8MSHX0cDZiY+DXjB
        aILWVRlCChQX+ZU7xKHuDoHhYktM5cTrvy/DX1MPCUSmQfXiEyKwqLgRdvwAikoMqYzZgxDr4/J
        VtFSKGxo5JYx6kBB0YTq+dNqcVismv3Pg+VibUGYqkSeDPauzr1xo0H+7nJCrrnSumZGjnwRl19
        ssPpcKpbSEKFKlxrhE4nPtqVBfrH6rofp7IohGw5RUn//0eq2KNeDk89E8KlwDAA5uRHailgdxj
        hIcU3KP08mc+pi4mIikCWeG8QcdPYGSwZS6fgOCIAjxomarSPABBWeDxe1K0FJxdAzF6l77kSMw
        PmntMVwLxRMEgN2MJvS2W6FtvTIt1ciskbTiNrC9lRuzXboNpQRsBMbTTgAPEt/W/Pt5w8clR9W
        ilL3XD0Ir/OXnA2Du9oKPsly32EV4Q1e4T0Vnx4KvnFrZK2Uhay49w8WASDdbaAXdSd2xLUNJF2
        8Lc7EuLBl4TxXAfQwkGOHOtlxFmkg0mLY3BPyHhL9NX2TqmkBXjjsM2/DfxkTqq9Xa45y5s5RKZ
        XC7ZP7Cfvo3UgFFJH9tFKGpNjWqgdwLsphgB0QTF1LtYW9la1lszaF8fhheF1kkzxom0ggvDt41
        DffF/1bPOVISu9a4m4Ea5RQQ/vrmg5/Pezso5JN65fjGjYMQ3WFaxVW7M2gqAZlo5C3Li+E39pq
        mW3zYHvT1o/hDOZaa1mJ2ovspJwykr4jwNojKQ1Q0pbURNcExXH/dlhvLv1cn81OBopCmA3TpBF
        oGpnirRqARCiRCRPZRAv723Ffbu9QzWW8MxDqeAiCmPx4NwFGugZ8/ii0q+gtHj7OwNO2FR9Hau
        8GO7jnzVA4qB3UNnvohTAAFamh9qIts96kW/h0K0GzxfRxVqormFe2v31Kpo5U24I2YBIRwEZuY
        BYA/7PnvPszkxkOfQvp0xr8QHrDEuACF2WCz29C53AlrVQRuJYx0umsz+ZuM/nltZ21BMyDPc6J
        NAGjvdCUIFuasqw==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFDescription:
External PHY reset from the FEC driver was introduced in commit [1] to=20
mitigate an issue with iMX SoCs and LAN87xx PHYs. The issue occurs=20
because the FEC driver turns off the reference clock for power saving=20
reasons [2], which doesn't work out well with LAN87xx PHYs which require=20
a running REF_CLK during the power-up sequence. As a result, the PHYs=20
occasionally (and unpredictably) fail to establish a stable link and=20
require a hardware reset to work reliably.

As previously noted [3], the solution in [1] integrates poorly with the
PHY abstraction layer, and it also performs many unnecessary resets. This
patch series suggests a simpler solution to this problem, namely to hold
the PHY in reset during the time between the PHY driver probe and the first
opening of the FEC driver.

To illustrate why this is sufficient, below is a representation of the PHY
RST and REF_CLK status at relevant time points (note that RST signal is
active-low for LAN87xx):

 1. During system boot when the PHY is probed:
 RST    111111111111111111111000001111111111111
 CLK    000011111111111111111111111111111000000
 REF_CLK is enabled during fec_probe(), and there is a short reset pulse
 due to mdiobus_register_gpiod() which calls gpiod_get_optional() with
 the GPIOD_OUT_LOW flag, which sets the initial value to 0. The reset is
 deasserted by phy_device_register() shortly after.  After that, the PHY
 runs without clock until the FEC is opened, which causes the unstable=20
 link issue.

 2. At first opening of the FEC:
 RST    111111111111111111111111111100000111111
 CLK    000000000011111111111111111111111111111
 After REF_CLK is enabled, phy_reset_after_clk_enable() causes a
 short reset pulse. Reset is needed here because the PHY was running=20
 without clock before.=20
  =20
 3. At closing of the FEC driver:
 RST    111110000000000000000000000000000000000                =20
 CLK    111111111111000000000000000000000000000
 FEC first disconnects the PHY, which asserts the reset, and then=20
 disables the clock.
  =20
 4. At subsequent openings of the FEC:
 RST    000000000000000011111111111110000011111                 =20
 CLK    000000000011111111111111111111111111111
 FEC first enables the clock, then connects to the PHY which releases=20
 the reset. Here the second reset pulse (phy_reset_after_clk_enable())=20
 is unnecessary, because REF_CLK is already running when the reset is=20
 first deasserted.=20
 =20
This illustrates that the only place where the extra reset pulse is=20
actually needed, is at the first opening of the FEC driver, and the reason
it is needed in the first place, is because the PHY has been running=20
without clock after it was probed.=20

Extensive testing with LAN8720 confirmed that the REF_CLK can be disabled
without problems as long as the PHY is either in reset or in power-down=20
mode (which is relevant for suspend-to-ram as well). Therefore, instead=20
of relying on extra calls to phy_reset_after_clk_enable(), the issue=20
addressed by commit [1] can be simply fixed by keeping the PHY in reset=20
when exiting from phy_probe(). In this way the PHY will always be in reset
or power-down whenever the REF_CLK is turned off.

This should not cause issues, since as per the PAL documentation any=20
driver that has business with the PHY should at least call phy_attach(),=20
which will deassert the reset in due time. Therefore this fix probably=20
works equally well for any PHY, but out of caution the patch uses the=20
existing PHY_RST_AFTER_CLK_EN driver flag (which it renames), to implement
the fix only for LAN87xx PHYs.

Previous versions:
This is the 4th version of the series;  below is a short description of
the previous versions.

v1:=20
The solution in [1] has the unfortunate side-effect of breaking the PHY=20
interrupt system due to the hardware reset erasing the interrupt mask of
the PHY. Patch series v1 suggested performing the extra reset before the=20
PHY is configured, by moving the call to phy_reset_after_clk_enable() from
the FEC into phy_init_hw() instead. The patch was re-examined after=20
finding an issue during resume from suspend, where the PHY also seemed to
require a hardware reset to work properly.=20
Further investigation showed that this is in fact due to another
peculiarity of the LAN87xx, which also erase their interrupt mask upon=20
software reset (which is done by phy_init_hw() on resuming from=20
suspend-to-ram), and is thus a separate issue that will be addressed in=20
a separate patch.=20

v2:
During this time the kernel had moved on and 2 new commits rendered the v1
fix unnecessary:=20
  [3] allows the extra PHY reset to still be performed from the FEC, but=20
  before the interrupt mask is configured, thereby fixing the above=20
  interrupt mask issue.
  [4] allows LAN87xx to take control of the REF_CLK directly, preventing
  the FEC from disabling it and thus circumventing the entire REF_CLK=20
  issue.
Patch v2 proposed to fix 2 potential issues with the solution from [4],=20
namely that (i) failing to set the PHY "clocks" DT property would silently=
=20
break the system (because FEC succeeds in disabling the REF_CLK, yet the=20
extra reset has been removed), and (ii) keeping the REF_CLK enabled
defeated the power-saving purpose of commit [2].
The present patch fixes (i), and leaves it up to the user to use the=20
power-friendly clock management of [2] (leave the DT clocks property=20
unset), or keep the REF_CLK always enabled (set the clocks property).=20
It also simplifies the code by removing all calls to=20
phy_reset_after_clk_enable() and related code, and the function
phy_reset_after_clk_enable() altogether. =20

v3:
The same content as v4, except that splitting of the patches has been=20
amended to make sure that the PHY works correctly after every successive
patch.=20

Tests: against net-next (5.11-rc3) with LAN8720 and LAN8742 and iMX283=20
SoC. Unfortunately unable to test LAN8740 which has a different form=20
factor.

References:
[1] commit 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable()
    support")
[2] commit e8fcfcd5684a ("net: fec: optimize the clock management to save
    power")
[3] commit 64a632da538a ("net: fec: Fix phy_device lookup for=20
    phy_reset_after_clk_enable()")
[4] commit bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in
    support")


Laurent Badel (5):
  net: phy: Add PHY_RST_AFTER_PROBE flag
  net: phy: net: phy: Hold SMSC LAN87xx in reset after probe
  net: fec: Remove PHY reset in fec_main.c
  net: phy: Remove phy_reset_after_clk_enable()
  net: phy: Remove PHY_RST_AFTER_CLK_EN flag

 drivers/net/ethernet/freescale/fec_main.c | 40 -----------------------
 drivers/net/phy/phy_device.c              | 26 +--------------
 drivers/net/phy/smsc.c                    |  4 +--
 include/linux/phy.h                       |  3 +-
 4 files changed, 4 insertions(+), 69 deletions(-)

--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

