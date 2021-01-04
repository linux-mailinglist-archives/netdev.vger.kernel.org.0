Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86BC2E97BC
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 15:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbhADOyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 09:54:23 -0500
Received: from mail-eopbgr00064.outbound.protection.outlook.com ([40.107.0.64]:19207
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725840AbhADOyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 09:54:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMtqihwsSt5Qsf8jIaQF+2tGazh94kua09Ao8qNDKyMFSdlGh679TKnm+rlGMsPjX8zWFb2GKDzIjPaZ/Xgyva9kRmiMKBxlN/0WFsCIujfbYU+4ePG3oW9a2lBUeqbdqt3Skn05ejmSGR0Dlgyd468PyGIOw7WLEJT6qGKtwRWlgX9zhMJOWsl68Gs5p7Bb+Zjw4kr9aXk4JqUwKXfe5gO6vy+VDHjmDYH2QFud2kshST9U7KrhjBUDSM6+NVGGllZXpLfanFYgQd6hTP9RUqQWscLIl9wc/1EgA2Qkd/uwAc4LrM7k+njORIf2QfNnZD74k4r/zUaw9tycqS6mbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n12Re3ZLILVXaXUNfb7xQcwcEi+FJu6QAmK1gHq1u/o=;
 b=jtiAADyc1wTVk/jG3vQq0POCicLuzvw5lcB4+8bf3e1pvsj399HOOYw7ZSVswpCETmcCd9+lHA/DkcY1k96Ve2BkeCGHunuF98Wn2lhQU66CSgvlsCg9dY+CayobaE5Wd5jQ5Dq3xwArbMJav1ryKnTEFfvhfs1WPAHL8+efLlSf64aqVGxC6UILbwzCM8LQChuhgOA39nNpeCDDHizowKVD5TZAQDiVvD47iRHXEWdgxhlptsGv8CQIh3FSBAXCtf32Ua0f9solyZLhKDWnhJjsCjmCxnjH55sBPTxmkx76Z26p1mEUMouzuIlt7vsrvpotV1gHpHg4Q9939qU8cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n12Re3ZLILVXaXUNfb7xQcwcEi+FJu6QAmK1gHq1u/o=;
 b=qDHk9c/kpZ3wUkmAMaXAW7qSnj7BJlzGEgC3DjsRv7zUKZiz9HAO8zhsr7e5pkd9ZQGES6ll93gqmwzLdkClBBZ1dC59O8N7Jvpe+uITKthehMVdpWcDumdPAEiEbrKfT9K4BCZ2My+3sJP9MN1w1FAlLIW7fsCWEz2vPH6Wazc=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VE1PR04MB6447.eurprd04.prod.outlook.com
 (2603:10a6:803:11e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Mon, 4 Jan
 2021 14:53:33 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::818e:8d79:99a9:188f]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::818e:8d79:99a9:188f%6]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 14:53:33 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
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
Thread-Index: AQHW4pSHwxyh2hM/e0O6/3UMlPC3maoXjZOA
Date:   Mon, 4 Jan 2021 14:53:33 +0000
Message-ID: <20210104145331.tlwjwbzey5i4vgvp@skbuf>
References: <20210104122415.1263541-1-geert+renesas@glider.be>
In-Reply-To: <20210104122415.1263541-1-geert+renesas@glider.be>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: glider.be; dkim=none (message not signed)
 header.d=none;glider.be; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c4f2302c-fc09-4e51-dbe4-08d8b0c081d1
x-ms-traffictypediagnostic: VE1PR04MB6447:
x-microsoft-antispam-prvs: <VE1PR04MB6447FFF8FE888A6F87BBAA8CE0D20@VE1PR04MB6447.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iGqgvUw945IrUUO5EX+ZLIrnvsCiznOV+ZH451myMgGUTpNBEaYpwiQbNvmm3x5N7ZR/ZbH06avLz9QqiParjlNckDaODwdT6YMd0KXqauG6t12PHvXPybwZ693SVk4SD5N4Yz29JJaSVb5W6s6uoW6MWJQ9hI0oDzPyjZKg/q14b5zS7wyKi9y6PKVhjHPbnUiybiQngDj7P36eFaz7bVOAGhFXSKxf9s2kSKBchdN7teS/UuE6S6oTOCYxUbAWUyT0TFjqgalxECT0RxVxSoMPQREOCpmVdEyu/Dxk99aIrwr0YZO7Ad8Mq/YdpvlDUYaoldrAsX2N2Fn253WrLcMR8Q5Rxpm94R2HKhxw69eqjwxpiGkloswZzkdyfEl0g2dFwkfVnxLa/NwWEQgMIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(136003)(366004)(376002)(346002)(396003)(26005)(2906002)(83380400001)(66446008)(44832011)(8936002)(186003)(66476007)(66946007)(5660300002)(64756008)(91956017)(8676002)(4326008)(66556008)(76116006)(86362001)(71200400001)(33716001)(6486002)(45080400002)(9686003)(6512007)(478600001)(1076003)(6506007)(316002)(7416002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TX7jdMhstxsUd3OkUAL/+AXo0jFGUIlk1HUOMN8cuiHyHLtSwMVkI2C+I8Cc?=
 =?us-ascii?Q?InkN2ppUT/oOf7UFMDGFksU0Rla5zGS+mccvpS1dw6suMlpsXNwJ0COl6YJy?=
 =?us-ascii?Q?CMZ3QoR2j4n51GP8Zz+WgM8/22xiAG94PKWHW1HvM/ZyhJq1gBg4EU2XGM00?=
 =?us-ascii?Q?hMGhZZVsHkk4+m0W64n6fbMz3sTdg59irvs0kg+jxzIsRsMaKjlUWjJoyB0V?=
 =?us-ascii?Q?e3eVJdrWGT4Wk9sgkv3dG7N1X4Eot9PWGa5thOE6gVC4Hf68A39cWnVkEOKU?=
 =?us-ascii?Q?/eijBrJsD/yCDv4MfRMyQhbekGxlL/yGslymaRl9aNhhoY4yL6o1qG8HawHi?=
 =?us-ascii?Q?pNyHHdHuq11QsFJvGMM3vuy+v3MDyRyNAfapUW0atNZZgzkSlz72m3bVZUe1?=
 =?us-ascii?Q?vdnYCgVkvpRj/yq4P0nL/AJWUIfOC/1AOy66CsVFHO5g67RtyuP4rrkTLPQc?=
 =?us-ascii?Q?yLLJ3nnYDFfTa7SqlC7UyA5Twm14shn15hE/z79bHKn0w9pPhtxPiFLmD9HP?=
 =?us-ascii?Q?ja1c4xfafMZ1zAw4h9LgGYCGVgonQjRe28OjqqvFVnE+sHgDYoGTLVoqhmxC?=
 =?us-ascii?Q?aFBn+ISvHXZCCLwAwwH8X8kqBfDx1gNsdG7E06evvRVRMsGFEgEUAqttPqiI?=
 =?us-ascii?Q?Iyv3DXVkJ04bXH9ZwI4WIO23qmvx+I1d3/RXguj4lkfuFtDjxhKgVH5SdQSJ?=
 =?us-ascii?Q?cvRRJSEllDiG4Prd1n1qfUGvyDeBu7DWPGL8DRg0Wahos6WzC5mBXBCPTrX6?=
 =?us-ascii?Q?2iVi9OhHtFxTlMdZdfmApFcBmbl4zLbluREm8rwOmafiLyb8qI4b3P4MKdVx?=
 =?us-ascii?Q?rj8bQc0SJvJNIgtKbZ3bWvqVz/o73k+qokM6BcjhpJ5NOHCh1vWtfVot9Bsw?=
 =?us-ascii?Q?mqXEoI4EPFaoA6uuIr4rGnzdhEP50PYUqjsf+bBLcrzZkQbQ1OYWnPB+qT0m?=
 =?us-ascii?Q?OQkOGtu+QdaqxCw28YRyc77xhJbe6y2MNkHojITP0ZmP7Ba6/3eAJ/rxHNtW?=
 =?us-ascii?Q?C680?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <43E718AEA2C6764BB34BF8CBA8FE58DF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4f2302c-fc09-4e51-dbe4-08d8b0c081d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 14:53:33.0359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YZjsJgX0c228GohQTZx/I8KSlXNpCqUYddCLIDjEu60AJlTBr+8trAfTgInOdr/Hj/mkHQwTr9MD4PcvkD6BKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6447
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Geert,

On Mon, Jan 04, 2021 at 01:24:15PM +0100, Geert Uytterhoeven wrote:
> Wolfram reports that his R-Car H2-based Lager board can no longer be
> rebooted in v5.11-rc1, as it crashes with an imprecise external abort.
> The issue can be reproduced on other boards (e.g. Koelsch with R-Car
> M2-W) too, if CONFIG_IP_PNP is disabled:

What kind of PHYs are used on these boards?

>=20
>     Unhandled fault: imprecise external abort (0x1406) at 0x00000000
>     pgd =3D (ptrval)
>     [00000000] *pgd=3D422b6835, *pte=3D00000000, *ppte=3D00000000
>     Internal error: : 1406 [#1] ARM
>     Modules linked in:
>     CPU: 0 PID: 1105 Comm: init Tainted: G        W         5.10.0-rc1-00=
402-ge2f016cf7751 #1048
>     Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
>     PC is at sh_mdio_ctrl+0x44/0x60
>     LR is at sh_mmd_ctrl+0x20/0x24
>     ...
>     Backtrace:
>     [<c0451f30>] (sh_mdio_ctrl) from [<c0451fd4>] (sh_mmd_ctrl+0x20/0x24)
>      r7:0000001f r6:00000020 r5:00000002 r4:c22a1dc4
>     [<c0451fb4>] (sh_mmd_ctrl) from [<c044fc18>] (mdiobb_cmd+0x38/0xa8)
>     [<c044fbe0>] (mdiobb_cmd) from [<c044feb8>] (mdiobb_read+0x58/0xdc)
>      r9:c229f844 r8:c0c329dc r7:c221e000 r6:00000001 r5:c22a1dc4 r4:00000=
001
>     [<c044fe60>] (mdiobb_read) from [<c044c854>] (__mdiobus_read+0x74/0xe=
0)
>      r7:0000001f r6:00000001 r5:c221e000 r4:c221e000
>     [<c044c7e0>] (__mdiobus_read) from [<c044c9d8>] (mdiobus_read+0x40/0x=
54)
>      r7:0000001f r6:00000001 r5:c221e000 r4:c221e458
>     [<c044c998>] (mdiobus_read) from [<c044d678>] (phy_read+0x1c/0x20)
>      r7:ffffe000 r6:c221e470 r5:00000200 r4:c229f800
>     [<c044d65c>] (phy_read) from [<c044d94c>] (kszphy_config_intr+0x44/0x=
80)
>     [<c044d908>] (kszphy_config_intr) from [<c044694c>] (phy_disable_inte=
rrupts+0x44/0x50)
>      r5:c229f800 r4:c229f800
>     [<c0446908>] (phy_disable_interrupts) from [<c0449370>] (phy_shutdown=
+0x18/0x1c)
>      r5:c229f800 r4:c229f804
>     [<c0449358>] (phy_shutdown) from [<c040066c>] (device_shutdown+0x168/=
0x1f8)
>     [<c0400504>] (device_shutdown) from [<c013de44>] (kernel_restart_prep=
are+0x3c/0x48)
>      r9:c22d2000 r8:c0100264 r7:c0b0d034 r6:00000000 r5:4321fedc r4:00000=
000
>     [<c013de08>] (kernel_restart_prepare) from [<c013dee0>] (kernel_resta=
rt+0x1c/0x60)
>     [<c013dec4>] (kernel_restart) from [<c013e1d8>] (__do_sys_reboot+0x16=
8/0x208)
>      r5:4321fedc r4:01234567
>     [<c013e070>] (__do_sys_reboot) from [<c013e2e8>] (sys_reboot+0x18/0x1=
c)
>      r7:00000058 r6:00000000 r5:00000000 r4:00000000
>     [<c013e2d0>] (sys_reboot) from [<c0100060>] (ret_fast_syscall+0x0/0x5=
4)
>=20
> Calling phy_disable_interrupts() unconditionally means that the PHY
> registers may be accessed while the device is suspended, causing
> undefined behavior, which may crash the system.
>=20
> Fix this by calling phy_disable_interrupts() only when the PHY has been
> started.
>=20
> Reported-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Fixes: e2f016cf775129c0 ("net: phy: add a shutdown procedure")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> Marked RFC as I do not know if this change breaks the use case fixed by
> the faulty commit.

I haven't tested it yet but most probably this change would partially
revert the behavior to how things were before adding the shutdown
procedure.

And this is because the interrupts are enabled at phy_connect and not at
phy_start so we would want to disable any PHY interrupts even though the
PHY has not been started yet.

> Alternatively, the device may have to be started
> explicitly first.

Have you actually tried this out and it worked?

I am asking this because I would much rather expect this to be a problem
with how the sh_eth driver behaves if the netdevice did not connect to
the PHY (this is done in .open() alongside the phy_start()) and it
suddently has to interract with it through the mdiobb_ops callbacks.

Also, I just re-tested this use case in which I do not start the
interface and just issue a reboot, and it behaves as expected.

> ---
>  drivers/net/phy/phy_device.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 80c2e646c0934311..5985061b00128f8a 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -2962,7 +2962,8 @@ static void phy_shutdown(struct device *dev)
>  {
>  	struct phy_device *phydev =3D to_phy_device(dev);
> =20
> -	phy_disable_interrupts(phydev);
> +	if (phy_is_started(phydev))
> +		phy_disable_interrupts(phydev);
>  }
> =20
>  /**
> --=20
> 2.25.1
> =
