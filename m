Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5C52E9BA1
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 18:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbhADRCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 12:02:05 -0500
Received: from mail-eopbgr60086.outbound.protection.outlook.com ([40.107.6.86]:1301
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728150AbhADRCE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 12:02:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrMnfE5scnyYa51NCWtsK+NYusMuUwxJwv7QFJ48gIK4IYJIL4DHDaMDaJ7i0G7r+aGkKFteB+TIn4+pZNPWrPBeVjoEgO362+psZ0olUl+Pnizd//jpYbonWvtBJFU40/Z2jmxwGWxMXkfRnJwGfkgNn5q6XNuCnEvjBXhoJQ06mPj5VgGFhCFzMewkmDNUth22lOOkwgC3sHSkDWl3YildYJoOph+a3Ttgnttt/S22+zJfvBeITa6TT5nfRIX1tJLhdDnGhmaX8KXuNQWJVRr036aWGbOk0XC1s/gQXSteKNzRZBtIcuzRID1RG5aTYZMcBnWhm87ku2oLhH6KfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2D8FOhgqPP0MrttYtPfznpFdodWsy8Y+oe6JX+b5II=;
 b=FB0xXHxfK5357mEqzOYC5K+UGu2ArwDOl6MZKI4obkPqpDX4BVMQPCeuylx5pL5uRZvO9QNywELq8bjvbgJBt0eN3Nw0h9+cyFGefuy57OHB7QphtzMcT2/aFRWetzwZBGs69aHZiUXGrr/7JFtEiqyOK2Dw9Bo29vwDmjeeB/CDu+L7zYnBR5jTCkai7Vl2Vs/hSBVpw558fTRbMRW0ZORRrMjB7IA/aabLxanhADVlD1YDTQAlIz1F4uvxgmyY73itNQjCHtk61OnB3j5WUPDl48QdsrYQQ62Jru2cogh+Sgy3O17jtADc6qV0zAYNxMwmNKkRRCjfAPs9ckz5bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2D8FOhgqPP0MrttYtPfznpFdodWsy8Y+oe6JX+b5II=;
 b=O8QOcf7Yyb+Ow7yKKTKyVzdLzZ9f73lgwvS1wNhNIUFcFGEqj67dUADMmG2wXFCnaZq2ZXWFHvneI7cxKhVDPQgimixitUYJlaja/5vT68jc57zNDkkQmTV5dSh7uCMXXe5er3J8JCkmM7ZRrsSzEsJDdj6xAn+uauZzc4VJtLY=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3471.eurprd04.prod.outlook.com
 (2603:10a6:803:7::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23; Mon, 4 Jan
 2021 17:01:14 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::818e:8d79:99a9:188f]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::818e:8d79:99a9:188f%6]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 17:01:13 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] net: phy: Fix reboot crash if CONFIG_IP_PNP is not
 set
Thread-Topic: [PATCH] [RFC] net: phy: Fix reboot crash if CONFIG_IP_PNP is not
 set
Thread-Index: AQHW4pSHwxyh2hM/e0O6/3UMlPC3maoXjZOAgAAE5QCAAB7HAA==
Date:   Mon, 4 Jan 2021 17:01:13 +0000
Message-ID: <20210104170112.hn6t3kojhifyuaf6@skbuf>
References: <20210104122415.1263541-1-geert+renesas@glider.be>
 <20210104145331.tlwjwbzey5i4vgvp@skbuf>
 <CAMuHMdUVsSuAur1wWkjs7FW5N-36XV9iXA6wmvst59eKoUFDHQ@mail.gmail.com>
In-Reply-To: <CAMuHMdUVsSuAur1wWkjs7FW5N-36XV9iXA6wmvst59eKoUFDHQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 009e2b53-c62e-47f6-7d72-08d8b0d25809
x-ms-traffictypediagnostic: VI1PR0402MB3471:
x-microsoft-antispam-prvs: <VI1PR0402MB3471925B9802F1E4DE81FC91E0D20@VI1PR0402MB3471.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sjnnh/tIj9NH+zfTiyuTU9PFDdv7pjY5JpNzb+IPA6HtKAOdsxnXV+ulT1oXPFKLiFMzgc4BZbzxecyIOtfgOL0lebq+9UL2hKcJCwgjN7VEO7NHX8/GfKlVxhBD/6V69XzeHKySosSf5fABM8WHxhrPjZd7AkCiUFoYi+IU6MnArNeH18gCqFHoUY5nLKLaK1ITpScwAJRwC0jaQK0B3lhdp0qTe5H4mG7M1K16FXeChYeAvJh7iurZZEfc1ZKEwRbWrVb3oWOM8IuWpot1IzuhZQfX1+CVkK+/4I+T5+mxfoxxiO8IRG9e7y8BqxKpF67c+xfNJy/ugydRBB9QtoAKYakMQ9hIB8DjVFmlJAUGaW/eo5xIp1v52nNp94h032odc2ppnPZCNUpuncWWpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(136003)(396003)(39860400002)(366004)(346002)(4326008)(8936002)(71200400001)(44832011)(6486002)(45080400002)(54906003)(1076003)(478600001)(2906002)(7416002)(316002)(8676002)(186003)(5660300002)(64756008)(66946007)(66476007)(6506007)(76116006)(86362001)(91956017)(66556008)(83380400001)(9686003)(26005)(6916009)(33716001)(53546011)(6512007)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?b1zJxBM/r863tYwKeU5nWbiDl05FUrS1EFsD52uNshzT9G08lPJ6VA+fNMjp?=
 =?us-ascii?Q?RtH54SocDzvo3EIx8h5ialQq3xxm6qMWba31+lio3ijajg6tqMPJo1La6bh3?=
 =?us-ascii?Q?CdHX8ukY12FdFPxH3nmoGhc2dcm2oTZBcAnkvP6GnrXUEUhEJGyNzZL6Nn2f?=
 =?us-ascii?Q?FeR0l+HqvTiXViXl3+oDzI2ocma+eX/Y9XuBdIKa1jJWIrAB3B9Rg3pfr+DO?=
 =?us-ascii?Q?YKvbC+2OVQIsafvhYSKnY/uq2ivKjlMruP5KJfoulNxzOHerFxwgfUCxBkzR?=
 =?us-ascii?Q?ePiwDJedjfTkkc6h2QLceoIVoNeq+Z+sUtJoNLzydUbzIds5Dj3hI45TIt4k?=
 =?us-ascii?Q?U1gFefHMF4o1yePDFFjCdU5jRPxD83OvBhIOCkD3oXllJGuHh6SVN1ylpX+F?=
 =?us-ascii?Q?NX/azHJRk5KhXrVb1cXV7/pvJnsRniae3y2oowdYwPcYr+9mdUaP+rQCZHdy?=
 =?us-ascii?Q?7L6kaCw8YWyyxd83uHXyo2fDJOSG3O1M9UYeh7lryI8GYqHKWmMoRATRyihf?=
 =?us-ascii?Q?3uaNtj6n/4sJ3c46XM8usk0krj2nJ44YyBF9b49EjNhSLuccd+i5FOdpc22v?=
 =?us-ascii?Q?y5lzXmLS7ecxCP3G51jRt3HpLd/R+Og3nwuygklmNsJ6EvRWpMOLchF9DHYZ?=
 =?us-ascii?Q?mMtPxdT7LiDimcyuTjtogaXYEdewfUNQuUXVzNQib8UHvidRXTn38+kEz99Q?=
 =?us-ascii?Q?msGAaP5sBgZzdc9VspyG/ZAKX3BHhIvMrpe2OCzb/OC6mu83b1ncslKMdGUA?=
 =?us-ascii?Q?VunXyzEBrBNRQBrKMndN9nyCYudOyLZx8DZ4/AuDQdjO3b1/JUxCMErbE1Ay?=
 =?us-ascii?Q?UZovsspOSo+dOVgnD3KycwzuLTrwDSvxFykMtqlUufWTb8dcJEyKJ8AG2czQ?=
 =?us-ascii?Q?DR+ZxrylFN/AH3DWvWlBFOs4GENzxZMb/OEvmrw2EjIkzzpVdawxoFUXuqZl?=
 =?us-ascii?Q?/v9t4DcvEVioPXFGpiy2e0PyIsrxQMy0NIAam8pXt1lKvYKrUnn7kkwE3dIf?=
 =?us-ascii?Q?GFoi?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E90DEA3B79733A4C9BDAC12066F7321B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 009e2b53-c62e-47f6-7d72-08d8b0d25809
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 17:01:13.8533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HmsTkG8yBweq4ilFscQ/PKWYvft1AvgTHLGImb9H/hth2dFAlaVW1MrJzfFjzC9Fm9oIqDTX71wAi1++s10nBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 04:11:02PM +0100, Geert Uytterhoeven wrote:
> Hi Ioana,
>=20
> On Mon, Jan 4, 2021 at 3:53 PM Ioana Ciornei <ioana.ciornei@nxp.com> wrot=
e:
> > On Mon, Jan 04, 2021 at 01:24:15PM +0100, Geert Uytterhoeven wrote:
> > > Wolfram reports that his R-Car H2-based Lager board can no longer be
> > > rebooted in v5.11-rc1, as it crashes with an imprecise external abort=
.
> > > The issue can be reproduced on other boards (e.g. Koelsch with R-Car
> > > M2-W) too, if CONFIG_IP_PNP is disabled:
> >
> > What kind of PHYs are used on these boards?
>=20
> Micrel KSZ8041RNLI
>=20
> > >     Unhandled fault: imprecise external abort (0x1406) at 0x00000000
> > >     pgd =3D (ptrval)
> > >     [00000000] *pgd=3D422b6835, *pte=3D00000000, *ppte=3D00000000
> > >     Internal error: : 1406 [#1] ARM
> > >     Modules linked in:
> > >     CPU: 0 PID: 1105 Comm: init Tainted: G        W         5.10.0-rc=
1-00402-ge2f016cf7751 #1048
> > >     Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
> > >     PC is at sh_mdio_ctrl+0x44/0x60
> > >     LR is at sh_mmd_ctrl+0x20/0x24
> > >     ...
> > >     Backtrace:
> > >     [<c0451f30>] (sh_mdio_ctrl) from [<c0451fd4>] (sh_mmd_ctrl+0x20/0=
x24)
> > >      r7:0000001f r6:00000020 r5:00000002 r4:c22a1dc4
> > >     [<c0451fb4>] (sh_mmd_ctrl) from [<c044fc18>] (mdiobb_cmd+0x38/0xa=
8)
> > >     [<c044fbe0>] (mdiobb_cmd) from [<c044feb8>] (mdiobb_read+0x58/0xd=
c)
> > >      r9:c229f844 r8:c0c329dc r7:c221e000 r6:00000001 r5:c22a1dc4 r4:0=
0000001
> > >     [<c044fe60>] (mdiobb_read) from [<c044c854>] (__mdiobus_read+0x74=
/0xe0)
> > >      r7:0000001f r6:00000001 r5:c221e000 r4:c221e000
> > >     [<c044c7e0>] (__mdiobus_read) from [<c044c9d8>] (mdiobus_read+0x4=
0/0x54)
> > >      r7:0000001f r6:00000001 r5:c221e000 r4:c221e458
> > >     [<c044c998>] (mdiobus_read) from [<c044d678>] (phy_read+0x1c/0x20=
)
> > >      r7:ffffe000 r6:c221e470 r5:00000200 r4:c229f800
> > >     [<c044d65c>] (phy_read) from [<c044d94c>] (kszphy_config_intr+0x4=
4/0x80)
> > >     [<c044d908>] (kszphy_config_intr) from [<c044694c>] (phy_disable_=
interrupts+0x44/0x50)
> > >      r5:c229f800 r4:c229f800
> > >     [<c0446908>] (phy_disable_interrupts) from [<c0449370>] (phy_shut=
down+0x18/0x1c)
> > >      r5:c229f800 r4:c229f804
> > >     [<c0449358>] (phy_shutdown) from [<c040066c>] (device_shutdown+0x=
168/0x1f8)
> > >     [<c0400504>] (device_shutdown) from [<c013de44>] (kernel_restart_=
prepare+0x3c/0x48)
> > >      r9:c22d2000 r8:c0100264 r7:c0b0d034 r6:00000000 r5:4321fedc r4:0=
0000000
> > >     [<c013de08>] (kernel_restart_prepare) from [<c013dee0>] (kernel_r=
estart+0x1c/0x60)
> > >     [<c013dec4>] (kernel_restart) from [<c013e1d8>] (__do_sys_reboot+=
0x168/0x208)
> > >      r5:4321fedc r4:01234567
> > >     [<c013e070>] (__do_sys_reboot) from [<c013e2e8>] (sys_reboot+0x18=
/0x1c)
> > >      r7:00000058 r6:00000000 r5:00000000 r4:00000000
> > >     [<c013e2d0>] (sys_reboot) from [<c0100060>] (ret_fast_syscall+0x0=
/0x54)
> > >
> > > Calling phy_disable_interrupts() unconditionally means that the PHY
> > > registers may be accessed while the device is suspended, causing
> > > undefined behavior, which may crash the system.
> > >
> > > Fix this by calling phy_disable_interrupts() only when the PHY has be=
en
> > > started.
> > >
> > > Reported-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> > > Fixes: e2f016cf775129c0 ("net: phy: add a shutdown procedure")
> > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > ---
> > > Marked RFC as I do not know if this change breaks the use case fixed =
by
> > > the faulty commit.
> >
> > I haven't tested it yet but most probably this change would partially
> > revert the behavior to how things were before adding the shutdown
> > procedure.
> >
> > And this is because the interrupts are enabled at phy_connect and not a=
t
> > phy_start so we would want to disable any PHY interrupts even though th=
e
> > PHY has not been started yet.
>=20
> Makes sense.
>=20
> > > Alternatively, the device may have to be started
> > > explicitly first.
> >
> > Have you actually tried this out and it worked?
>=20
> No, I haven't tested restarting the device first.
> I would like to avoid starting the device during shutdown, unless it is
> absolutely necessary.

I was talking about starting the PHY device but in light of the new
information, this would lead to the exact same crash since it's just
another PHY register access.

Now I understand that you were referring to the sh_eth device itself.

>=20
> > I am asking this because I would much rather expect this to be a proble=
m
> > with how the sh_eth driver behaves if the netdevice did not connect to
> > the PHY (this is done in .open() alongside the phy_start()) and it
> > suddently has to interract with it through the mdiobb_ops callbacks.
> >
> > Also, I just re-tested this use case in which I do not start the
> > interface and just issue a reboot, and it behaves as expected.
>=20
> It depends on the hardware: the sh_eth device is powered down when its
> module clock is stopped. When powered down, any access to the sh_eth
> registers or to the PHY connected to it will cause a crash.
>=20
> On most other hardware, you can access the PHY regardless, and no crash
> will happen.

Ok, so this does not have anything to do with interrupts explicitly but
rather with the fact that any PHY access will cause a crash when the
sh_eth device is powered down.

If the device is powered-down before the actual .ndo_open() how is the
probe actually setting up the device? Or is the device returned to the
powered-down state after the probe and only powered-up at a subsequent
.ndo_open()?

Instead of the phy_is_started() call we could check if we had previously
enabled the interrupts on the PHY but this would mean that a basic
assumption of the PHY library is violated in that a registered PHY
device cannot access its regiters because the MDIO controller just
decided so.

Can't the MDIO bitbang driver callbacks just check if the device is
powered-down and if it is just power it back up temporarily?=
