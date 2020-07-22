Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28E62296C4
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgGVK7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:59:21 -0400
Received: from mail-am6eur05on2110.outbound.protection.outlook.com ([40.107.22.110]:34591
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726161AbgGVK7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 06:59:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQj5mYlEzdQJ4EHPJmb60MALkhJkyBkl3B+r3CJCG2ue8bldkwQzWkDgOjFwcPCGKXnoxIHhOJjnHIxBL059iuqbI84EfRdA7RhKuOCVxjAvv5y4YisIQQU0JwI0lL0xkh9WJcT1GLmuqkGw7CxhPw4AAwWpGExKtCvCB+yfDGX2XJXeXq5u9d5bXDsaSGVNm5c9Ip+lwFBAYqVBVmGX0pNOA5DdlinZhLw28ZS5wn09JaI8FDZ7oCq2+8jGxGQGPiJIwqjDVb5LEZph3nK7LeajfEwBFst6r8RDUCZGjWKxvmxQaF6UkrELBPKYINjoL/7pEfmZwyJ1mAsaQap9OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSnm1IJtF0cQx7qECx+fUFWCzoE0oN8WQl61SMyuPxs=;
 b=Gblts7X7xPjOzx6cx54rOLmEznolZK87pFrDt8+DQOKdwyTC/KuqgxSp7g8BiaBk0DWLXjwq/g59u1OlKDhp7/ddBwcLYQPYs9riCjFhcHkfMJcPeICF41YodJGyxv3QKXf1UZHJW4kbOXifwHlBsnMufi4PYmIg1mDmWtEk9Rde+filf/VoomCuUjW0ySzkbWRyX2SanIDmRWgClcvYaV04Amt/V9saSAlcPPtuvARqvAO6ANxCOSyxjmhwCEctDsaPGO4DY3dMXtiMNbfBsPnVhQGyimy0BsQfFQGEBjFMuuEBBpiFtvApmpBjxZSN5CVPqhQYUUy5bX0eNPDQ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kamstrup.com; dmarc=pass action=none header.from=kamstrup.com;
 dkim=pass header.d=kamstrup.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=kamstrup.onmicrosoft.com; s=selector2-kamstrup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSnm1IJtF0cQx7qECx+fUFWCzoE0oN8WQl61SMyuPxs=;
 b=FZX3V5qpShSQfj6L8lmldBMrmpAiuzVie0Qx1McHCrbiXX7q3Vk61JopLZaHipNUzIGtpHjsGy0WvXjGi7CCwmvYvq+lrmAsuWMNTGavfK+InO2buQhNwymG8NOJpmcn3u1Gzr6zUsQ7SPw8f7MIyTrZ0wZzVupvfMR2tGgSEGM=
Received: from AM0PR04MB6977.eurprd04.prod.outlook.com (2603:10a6:208:189::23)
 by AM0PR04MB5329.eurprd04.prod.outlook.com (2603:10a6:208:63::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Wed, 22 Jul
 2020 10:59:14 +0000
Received: from AM0PR04MB6977.eurprd04.prod.outlook.com
 ([fe80::c22:89a5:e536:a0b9]) by AM0PR04MB6977.eurprd04.prod.outlook.com
 ([fe80::c22:89a5:e536:a0b9%2]) with mapi id 15.20.3216.020; Wed, 22 Jul 2020
 10:59:14 +0000
From:   Bruno Thomsen <bth@kamstrup.com>
To:     Andrew Lunn <andrew@lunn.ch>, Fabio Estevam <festevam@gmail.com>
CC:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>,
        "bruno.thomsen@gmail.com" <bruno.thomsen@gmail.com>
Subject: Re: fec: micrel: Ethernet PHY type ID auto-detection issue
Thread-Topic: fec: micrel: Ethernet PHY type ID auto-detection issue
Thread-Index: AQHWXFGywb8nFDllYUmkeeF75n8YnakL69AAgAAL44CABgcesA==
Date:   Wed, 22 Jul 2020 10:59:14 +0000
Message-ID: <AM0PR04MB697747DD5CFED332E6729122DC780@AM0PR04MB6977.eurprd04.prod.outlook.com>
References: <CAH+2xPCzrBgngz5cY9DDDjnFUBNa=NSH3VMchFcnoVbjSm3rEw@mail.gmail.com>
 <CAOMZO5DtYDomD8FDCZDwYCSr2AwNT81Ay4==aDxXyBxtyvPiJA@mail.gmail.com>,<20200717163441.GA1339445@lunn.ch>
In-Reply-To: <20200717163441.GA1339445@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=kamstrup.com;
x-originating-ip: [185.181.22.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c47a1ce4-4206-4699-7293-08d82e2e45ae
x-ms-traffictypediagnostic: AM0PR04MB5329:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB5329DBF108FC594F809DD01DDC790@AM0PR04MB5329.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YJjupswtRgy0NdEX3UZ3/lsYN2ufgE9z03crEd6Pavwm4WB9xb7mdlrecYrRi1R+rGOTw242oCtJU6mxZWhkEN6jkVtxRFm+KqGWAAYtnDTZWqnXu7PM9lt/YC1kK+cBigzafUJbwsk2ZpFruZq8z9QF6UYmd1wzjKL9LP5kb8m1VlxJCf3xEDg+BmCj8QOOxfbfNTTu5NtrKTaUD/2385HGwX+vNPDoT1h5s0CuYVO5cN8xH3q8pbjV7Y4HyOFKxdCJF/rr+z61yIx4J5E3aWYAnYSlwdZLLC5H5DZMafGCUjdy2v6fY4t+DlOx6gNHJpzluJApXeJ7bdgL3V0/XKAcj01bWcFUtM23nfHOmYiVO48SHPqu6dxo+SE1kgfp6wj1CSoxM+3DgyK8t+eRmCde0fEIuWUJOBmxITwbxT3zvsYxGgw0aI/6Q/A5WNRXSiQ4+kkY3H2qUGp2Ts5pcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6977.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(366004)(39850400004)(396003)(136003)(376002)(52536014)(76116006)(8676002)(110136005)(66946007)(66446008)(66556008)(66476007)(64756008)(316002)(966005)(2906002)(9686003)(33656002)(54906003)(5660300002)(478600001)(30864003)(186003)(71200400001)(83380400001)(7696005)(6506007)(86362001)(4326008)(26005)(55016002)(8936002)(505234006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 1rnda/JPSNY4EerhXBgncQIPHncBbH/DiE9AfwcXdwTq0/38tgqB37SWwzpXNtvdjG9mSjLVAA8wrDFc6iNfR1jp3vEiHPBZGJ8/j4WSetILrRbPXPjrjOWGhS2PwyXcYpxvsOY+7AoEOLkxJK5aEi9ckj/KOAX8eK9rh/j7mr2dx7ppvAokaM1OpaUUAgP652VPNM2MkNhrOJOgj0y72YKNwVm6qylwwhTfzDyY5/UvEVVhKjsCxac3ILFczSkvG1Bwzm1I7AhKjVYf1IUmaTDPoUC/Q6RjuOan8Dxfl6YmUDX7Is1/agdZWNrpij58rz1q6d0Sydo3Fs3jxs+SUckjS96lB+L+3SUxqgYn2vUQIw1dyXBlC81ggVtSajG0yBKyZjmIwF1bAoiLyf0OD0+nNfpEx+YWKaNzZhWWPIWB90oNYWZW2FEGLHGRHSvtcpUQ6ekjPgMktBGv9fwouDLO56nsGqVd8sZVcu3/CvQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: kamstrup.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6977.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c47a1ce4-4206-4699-7293-08d82e2e45ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 10:59:14.3845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 90a8229b-1514-47f2-93a9-6b8b3cf3e0c3
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fah4+F8O272/nu2hFgdI32tUTF3nHWH+9wLF0B1HQi/pADxKClLG+60bSbTSYEm/uG3XkzdTRBJ/kXhrHvuJtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5329
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,=A0=0A=
=0A=
> > > I have been having issues with Ethernet PHY type ID=0A=
> > > auto-detection when changing from the deprecated fec=0A=
> > > phy-reset-{gpios,duration,post-delay} properties to the=0A=
> > > modern mdio reset-{assert-us,deassert-us,gpios}=0A=
> > > properties in the device tree.=0A=
>=0A=
> > > Kernel error messages (modem mdio reset):=0A=
> > > mdio_bus 30be0000.ethernet-1: MDIO device at address 1 is missing.=0A=
> > > fec 30be0000.ethernet eth0: Unable to connect to phy=0A=
>=0A=
> It sounds like the PHY is not responding during scanning of the bus.=0A=
=0A=
Yes, that is correct.=0A=
=0A=
> If the ID is mostly 0xff there is no device there.=0A=
>=0A=
> So check the initial reset state of the PHY, and when is it taken out=0A=
> of reset, and is the delay long enough for it to get itself together=0A=
> and start answering requests.=0A=
=0A=
When capturing traces with a logic analyzer, I do the following:=0A=
- break the target in the bootloader=0A=
- start trigger on reset or mdio signal (had to use mdio as reset wasn't us=
ed)=0A=
- boot linux=0A=
=0A=
I monitor 4 signals: MDIO, MDC, 3V3, reset.=0A=
=0A=
The new mdio code path does not reset the PHY before reading=0A=
of PHY type ID and for some reason this result in no responce,=0A=
e.g. high (0xFFFF) and missing MDIO turnaround.=0A=
=0A=
MDC is 2.5MHz, and I can decode the 2 read requests with a logic=0A=
analyzer:=0A=
=0A=
START C22=0A=
OPCODE [Read]=0A=
PHY Address ['1' (0x01)]=0A=
Register Address ['2' (0x02)]=0A=
!Turnaround=0A=
Data ['65535' (0xFFFF)]=0A=
=0A=
START C22=0A=
OPCODE [Read]=0A=
PHY Address ['1' (0x01)]=0A=
Register Address ['3' (0x03)]=0A=
!Turnaround=0A=
Data ['65535' (0xFFFF)]=0A=
=0A=
When using the deprecated fec phy reset code path, the PHY=0A=
chip is reset just before reading of register 0x02 and 0x03.=0A=
In this case the PHY respond correct with 0x0022 and 0x1561.=0A=
=0A=
When looking at the mdio code I don't understand how the=0A=
reset code should even work in the first place.=0A=
=0A=
> static int mdio_probe(struct device *dev)=0A=
> {=0A=
> 	struct mdio_device *mdiodev =3D to_mdio_device(dev);=0A=
> 	struct device_driver *drv =3D mdiodev->dev.driver;=0A=
> 	struct mdio_driver *mdiodrv =3D to_mdio_driver(drv);=0A=
> 	int err =3D 0;=0A=
>=0A=
> 	if (mdiodrv->probe) {=0A=
> 		/* Deassert the reset signal */=0A=
> 		mdio_device_reset(mdiodev, 0);=0A=
=0A=
This assumes that the reset signal is asserted already.=0A=
Not my case and it seems very flaky.=0A=
=0A=
Deprecated fec code assert reset signal before reset assert delay,=0A=
following deassert reset and deassert delay.=0A=
https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/freesca=
le/fec_main.c#L3373=0A=
=0A=
> =0A=
> 		err =3D mdiodrv->probe(mdiodev);=0A=
> 		if (err) {=0A=
> 			/* Assert the reset signal */=0A=
> 			mdio_device_reset(mdiodev, 1);=0A=
=0A=
Reset signal is asserted in error path but there are no=0A=
retry on probe.=0A=
=0A=
=0A=
> void mdio_device_reset(struct mdio_device *mdiodev, int value)=0A=
> {=0A=
> 	unsigned int d;=0A=
> =0A=
> 	......=0A=
> =0A=
> 	d =3D value ? mdiodev->reset_assert_delay : mdiodev->reset_deassert_dela=
y;=0A=
> 	if (d)=0A=
> 		usleep_range(d, d + max_t(unsigned int, d / 10, 100));=0A=
=0A=
This is not the recommended way of sleeping if d > 20ms.=0A=
=0A=
https://www.kernel.org/doc/Documentation/timers/timers-howto.txt=0A=
=0A=
The deprecated fec code handles this correctly.=0A=
https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/freesca=
le/fec_main.c#L3381=0A=
=0A=
if (d)=0A=
	if (d > 20000)=0A=
		msleep(d / 1000);=0A=
	else=0A=
		usleep_range(d, d + max_t(unsigned int, d / 10, 100));=0A=
=0A=
=0A=
Micrel recommended reset circuit has a deassert tau of 100ms, e.g. 10k * 10=
uF.=0A=
So to be sure the signal is deasserted 5 * tau or more, and this brings the=
 value=0A=
up in the 500-1000ms range depending on component tolerances and design=0A=
margin.=0A=
=0A=
See figure 22 in pdf for reset circuit.=0A=
http://ww1.microchip.com/downloads/en/devicedoc/ksz8081mnx-rnb.pdf=0A=
=0A=
So my current conclusion is that using generic mdio phy handling does=0A=
not work with Micrel PHYs unless 3 issues has been resolved.=0A=
- Reset PHY before auto type detection.=0A=
- Add initial assert reset signal + delay when resetting phy.=0A=
- Handle >20ms reset delays.=0A=
=0A=
/Bruno=0A=
=0A=
----=0A=
When using the 5.8.0-rc6 kernel (dirty due to device tree changes),=0A=
I sometimes hit this kernel issue (never seen it with 5.7.8 or earlier),=0A=
but don't think it's related:=0A=
=0A=
kernel: =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=0A=
kernel: BUG task_struct(119:NetworkManager-dispatcher.service) (Not tainted=
): Poison overwritten=0A=
kernel: -------------------------------------------------------------------=
----------=0A=
kernel: Disabling lock debugging due to kernel taint=0A=
kernel: INFO: 0xe05e9b3f-0x9b36c418 @offset=3D30464. First byte 0xff instea=
d of 0x6b=0A=
kernel: INFO: Slab 0xaa165da6 objects=3D18 used=3D0 fp=3D0x37e5d9c3 flags=
=3D0x10200=0A=
kernel: INFO: Object 0xf19b9dd9 @offset=3D29440 fp=3D0x00000000=0A=
kernel: Redzone cb135af3: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  =
................=0A=
kernel: Redzone a0061a8a: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  =
................=0A=
kernel: Redzone f2917653: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  =
................=0A=
kernel: Redzone aeb00bb5: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  =
................=0A=
kernel: Object f19b9dd9: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object cadb3eab: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object a51c2cd1: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 6b25d1e5: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 1e35e7e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object aea2a999: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object e160fc75: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object c1c29834: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 17ff6205: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object a6781094: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object ce2fd05e: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 7daa8dfb: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 4c0e09e9: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object b23b73b7: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 698ecfeb: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object c0437471: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object a9236eff: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 4a6eac62: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 7fda2c51: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 8f143bf4: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object aaa2bfdd: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 22d54b92: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 8fcef107: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object d2a1c8a9: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object b25c8021: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 1bed0f85: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object a6c9ddc2: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 306f6960: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 478e89fc: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 90f8a983: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 0d8a4733: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 254b16da: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 409e6dac: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object d043695a: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object abee8a24: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 18715fa9: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object fb3630b3: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 3aaedaf7: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 32565782: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 26869f35: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 789a34f9: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 8865b386: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object a0d7868e: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 9cd04fce: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 4214b445: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 9d69b597: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 845ea8c4: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 2c937a0b: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object eb5293e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object dab824c2: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object bfa6c2fa: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object a2c4a8be: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 5e1f207c: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object a974428f: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 91af2a44: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 6f71ee6f: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object d4abc42d: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 3737f8db: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 65bd39e9: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object cd12758c: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 212096ca: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 8462745b: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object a430d1b2: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 7a0d1289: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object e05e9b3f: ff 4d ff ff ff ff ff ff 10 e7 c6 77 3e 38 08 00  .=
M.........w>8..=0A=
kernel: Object 8c5945af: 45 00 00 48 42 05 00 00 80 11 75 5c ac 14 15 1c  E=
..HB.....u\....=0A=
kernel: Object de1b76ee: ac 14 15 ff e1 15 e1 15 00 34 8a 61 53 70 6f 74  .=
........4.aSpot=0A=
kernel: Object a54d91d1: 55 64 70 30 94 e4 06 54 2b ed 49 66 00 01 00 04  U=
dp0...T+.If....=0A=
kernel: Object 08ebc3be: 48 95 c2 03 94 eb 5d 89 b7 b5 0c 41 d7 12 76 ea  H=
.....]....A..v.=0A=
kernel: Object ff29f54f: b1 7e 4d ed bb 74 cc c7 62 3d 2f 10 bb 74 cc c7  .=
~M..t..b=3D/..t..=0A=
kernel: Object 9678dfaa: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .=
...............=0A=
kernel: Object 426da6d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .=
...............=0A=
kernel: Object 7fab2713: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 60862a98: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 0810ad40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 1f0aa745: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 19944bf2: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 4ce341aa: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 9607ec6d: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object a5915de7: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object d686baa6: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 1df19b0d: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 0bbe9a96: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 6f1e7700: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 824ce600: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 790d4580: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object f8a184dd: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object f65d9e18: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object b52e601b: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 82bf9d2e: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object bf8060fe: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object e90100be: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object ea74812b: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object e6403677: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object faf222d4: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object dca677d2: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 1c2391f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object fb8b9c6d: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object 967ee7ed: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  k=
kkkkkkkkkkkkkkk=0A=
kernel: Object f597fef4: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  k=
kkkkkkkkkkkkkk.=0A=
kernel: Redzone 13b0f2f9: bb bb bb bb                                      =
....=0A=
kernel: Padding 372127fe: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  =
ZZZZZZZZZZZZZZZZ=0A=
kernel: Padding 6d5fbace: 5a 5a 5a 5a 5a 5a 5a 5a                          =
ZZZZZZZZ=0A=
kernel: CPU: 0 PID: 127 Comm: kworker/0:3 Tainted: G    B             5.8.0=
-rc6-00008-g87d248347e60-dirty #1=0A=
kernel: Hardware name: Freescale i.MX7 Dual (Device Tree)=0A=
kernel: Workqueue: memcg_kmem_cache kmemcg_workfn=0A=
kernel: [<8010ed20>] (unwind_backtrace) from [<8010b734>] (show_stack+0x10/=
0x14)=0A=
kernel: [<8010b734>] (show_stack) from [<8047caf4>] (dump_stack+0x8c/0xa0)=
=0A=
kernel: [<8047caf4>] (dump_stack) from [<8027351c>] (check_bytes_and_report=
+0xcc/0xe8)=0A=
kernel: [<8027351c>] (check_bytes_and_report) from [<80274e0c>] (check_obje=
ct+0x248/0x2ac)=0A=
kernel: [<80274e0c>] (check_object) from [<80274edc>] (__free_slab+0x6c/0x2=
bc)=0A=
kernel: [<80274edc>] (__free_slab) from [<80279a1c>] (__kmem_cache_shrink+0=
x1f4/0x248)=0A=
kernel: [<80279a1c>] (__kmem_cache_shrink) from [<80279a7c>] (__kmemcg_cach=
e_deactivate_after_rcu+0xc/0x4c)=0A=
kernel: [<80279a7c>] (__kmemcg_cache_deactivate_after_rcu) from [<80249bb8>=
] (kmemcg_cache_deactivate_after_rcu+0xc/0x1c)=0A=
kernel: [<80249bb8>] (kmemcg_cache_deactivate_after_rcu) from [<80249b98>] =
(kmemcg_workfn+0x24/0x38)=0A=
kernel: [<80249b98>] (kmemcg_workfn) from [<80140000>] (process_one_work+0x=
19c/0x3e4)=0A=
kernel: [<80140000>] (process_one_work) from [<8014028c>] (worker_thread+0x=
44/0x4dc)=0A=
kernel: [<8014028c>] (worker_thread) from [<80146a2c>] (kthread+0x144/0x180=
)=0A=
kernel: [<80146a2c>] (kthread) from [<80100148>] (ret_from_fork+0x14/0x2c)=
=0A=
kernel: Exception stack(0xbb1d5fb0 to 0xbb1d5ff8)=0A=
kernel: 5fa0:                                     00000000 00000000 0000000=
0 00000000=0A=
kernel: 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 0000000=
0 00000000=0A=
kernel: 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000=0A=
kernel: FIX task_struct(119:NetworkManager-dispatcher.service): Restoring 0=
xe05e9b3f-0x9b36c418=3D0x6b=0A=
