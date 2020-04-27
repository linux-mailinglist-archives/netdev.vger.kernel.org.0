Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470681BAE96
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgD0UAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:00:33 -0400
Received: from mail-db8eur05on2059.outbound.protection.outlook.com ([40.107.20.59]:24117
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726205AbgD0UAd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 16:00:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLNy+4WO0u54zlxjmGXKF0pq+cL1smSavccb1gurxFHTG5TobLbJPMs/1c2NjE0Zctu2MqV1SZAsE5OnYFNX0ekMjXuZyuD5KckJg1gC9qN0RE31IUhRAe7mx1wwOzAqwW0Qu128k1oj6BUx5x/nnRGFCzN7Mx1OcVpp3aU7bOqF7rpXS4s4nG6eDdHy32VX3hTOEQ+Zrwjl59EHQXupTXO74Nl3wfaRcL2OfXvdLUM4SqxsawVjBqLM0KSiM09fTUwyc/+GOh1vytIP/KxWyJeduNbNaObglvV2cZrW8KidyIXKBdggK2yCB+8aduMRWZPVhFypnPuX8GkJA2uOBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiljFlBVyv5GNDsTR2yBZA+uCipE4NqXOQfbcRjQt48=;
 b=RA9yXeb2zo3ohKrKevJg9coLDgewHZchESGbRGgT3IpAw2Z2IKu2exgtBBG47hsOyK7g+NKDZJQWW2711enu+UXto/3iCS66UAZINLT7eXph/iK9cmHB/zbo2PD7Ah2BzY0pz/RYGYiJ0Jwy3zHw4iCch7XIXGilU44X77oe8UsmTXNhW7CPg++FE9JqCn/2tp/Do6Leti0jgBI93EPSj3Dg8b/cdTAF8t9lZIUHKS6JNthBvDsEVGCmfPAeJcvknWIk0PzSvnuYnWkbXu1d3iHZjsjzFwwG4LAa0sMb3Hjpng8T3J8j3htQwjB24v0gOIf84ZzWUmUFJpVTjG6IIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiljFlBVyv5GNDsTR2yBZA+uCipE4NqXOQfbcRjQt48=;
 b=Ounu7F1KBMwrSCX2qYx7qkhXnHn+3p52dyPULUsA/OSmD4tAqixMLHGCM0vFAhz+6yf6ie4qvxUO/4YJy+/eysXGvRhp4v3CH5iuyRxoxPltnjqDrULrjMzupR1pMGl1Yr6IWBCo7SV2zhS0M1hGfEWV1Mp3K2+i84yxFHoV6WQ=
Received: from VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23)
 by VI1PR04MB5421.eurprd04.prod.outlook.com (2603:10a6:803:d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 20:00:28 +0000
Received: from VI1PR04MB6941.eurprd04.prod.outlook.com
 ([fe80::8de5:8c61:6e4d:9fe9]) by VI1PR04MB6941.eurprd04.prod.outlook.com
 ([fe80::8de5:8c61:6e4d:9fe9%9]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 20:00:28 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Andy Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        dl-linux-imx <linux-imx@nxp.com>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
Thread-Topic: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
Thread-Index: AQHWHKdNoF5XViOCcUynDB14nwI/WQ==
Date:   Mon, 27 Apr 2020 20:00:28 +0000
Message-ID: <VI1PR04MB6941C603529307039AF7F4ABEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
References: <20200414004551.607503-1-andrew@lunn.ch>
 <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
 <20200427164620.GD1250287@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [95.76.3.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0c7be0e1-f152-4a65-c6fc-08d7eae5a25b
x-ms-traffictypediagnostic: VI1PR04MB5421:|VI1PR04MB5421:|VI1PR04MB5421:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB542123011D2FE9CC0DAADE90EEAF0@VI1PR04MB5421.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 0386B406AA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6941.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(346002)(39860400002)(376002)(81156014)(54906003)(478600001)(316002)(8936002)(5660300002)(26005)(4326008)(71200400001)(966005)(2906002)(86362001)(6506007)(53546011)(6916009)(186003)(76116006)(66476007)(33656002)(64756008)(44832011)(9686003)(7696005)(52536014)(45080400002)(8676002)(55016002)(66946007)(91956017)(66556008)(66446008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n5o0sqQm0Xh2i/8gVlIm6njphRP47m2YjP5Oc0bSkrX0XZriuWSUvE2ZgeUgOReeTiQ6tT22IAXOlzMpzgifoZCR350Nvj1v0h3kOi3xQZKGpzlUalNOWNyHLgg984PmeQ9g7yRe5GBIFu9tbG5D/9HG5yUf64D8JhWZmLMR+YyEJVEwfF+TkYdqLgro4GlIE/GzC+guCbtV0WPX73e+UspE+vIeF7xz5Qq6F1AgdM7IR7sTaZcI5EFL6e8xafDm/iz+aQ/TO52s8MjkSiWzeFeO378txckL2BRH45M2XQZQfIC3N8bEdKh9n2fUjEURsRCYRFr0gP7AH+qbquKcs3IQ6XS2IE/siv4acCQ1hBaBP3DmZUIIpubILCHoXDl8HoOlV8hXD6eIky7KanUpV1J6Fhmta1KAu12Bo8qxSqAe1kp5WEM2NBZiqOIE2XXIMtK2eaqeGeyXeLWL8n1DaBOfyy0GkmpKrsh8q7y2BPI=
x-ms-exchange-antispam-messagedata: priL9z9ouf1J8SnUB0ZWXH/M2eJIpVcdIES9ANXlu03nZ5XfdtnSfnMuFLb4OuBAk2IA0dSjuN489pTYc3CJfZ1tpPccWKE+0FOk56PDxK4kxHwkZwxBhkC+Tm4bgrrfBlt1HpEn+Vi7mXBeZnbUfwvim1Ga0dJ/YIo19PqdYnoT1DLZj6rNdbpq4Lr0cgomt5obx/0x3nhGMlAx0nm3KVizZ9XkSwIp3okG1S/8NKD9IpeGY+cCxIbNIgFSkKdj6TlW7LQfAItebLJkSv5xkFs2p8qruOMKdbkqBXMr45E8D0lgO0vGDF7Tt9oi8e9/K5EhgJ5lAfdFMt6iHuNgpp8NUmEH08T296ACGQF9McZacNsUYRM74HPG7xychb2TLYwNvzcaZol5n3u1UOwraDEkfOC4JW1PpgxgbeOSq415qAYqtQQ6icGGqPGrvx+y2zAn6X44HCNBxAhgEH/K5Dxcj96t2TwxQJ//hJ1uOILOH2EvnpAqoWglgwOK5XG1u+Cjh7IBcHhv3PsOl5GRJWUFNeDt9kad45lN9sJIM6YODy6Gxg58wSpmxhDrZ0eX0u7InYOH10unOi63hruk/ErYAhmSBTXbjSnvBIWB9p6Qnu0y73bDN5kPuXW2RgiGrYpz0O0pnAkjLRdnWW+m+BPUXVvrLyaJ3PEut/pFNOhnRMmkJh5PXHHj7OYHxEgKuax1xoqekNGFp5T9xCB/64bz3rFkUEzQ5z9/lzXifgqGBz0tcnxXf0dBLdPZUBEZ37Z21H17Mub9OZamk0TWXOgpbZ7Aes0s/2SQOvOJfso=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c7be0e1-f152-4a65-c6fc-08d7eae5a25b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2020 20:00:28.7662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nzOOBeEFOg3DiPx4Ryg/m9PGKne//Vr9ELL2Xh7Iv+YWQCDU3dDKqaiUY4N52TverD1lajIo6/jMFSj1YinonQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5421
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-27 7:46 PM, Andrew Lunn wrote:=0A=
> On Mon, Apr 27, 2020 at 03:19:54PM +0000, Leonard Crestez wrote:=0A=
>> Hello,=0A=
>>=0A=
>> This patch breaks network boot on at least imx8mm-evk. Boot works if I=
=0A=
>> revert just commit 29ae6bd1b0d8 ("net: ethernet: fec: Replace interrupt=
=0A=
>> driven MDIO with polled IO") on top of next-20200424.=0A=
> =0A=
> Hi Leonard=0A=
> =0A=
> Please could you try this:=0A=
> =0A=
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-evk.dts b/arch/arm64/bo=
ot/dts/freescale/imx8mm-evk.dts=0A=
> index 951e14a3de0e..3c1adaf7affa 100644=0A=
> --- a/arch/arm64/boot/dts/freescale/imx8mm-evk.dts=0A=
> +++ b/arch/arm64/boot/dts/freescale/imx8mm-evk.dts=0A=
> @@ -109,6 +109,7 @@ &fec1 {=0A=
>          phy-handle =3D <&ethphy0>;=0A=
>          phy-reset-gpios =3D <&gpio4 22 GPIO_ACTIVE_LOW>;=0A=
>          phy-reset-duration =3D <10>;=0A=
> +       phy-reset-post-delay =3D <100>;=0A=
>          fsl,magic-packet;=0A=
>          status =3D "okay";=0A=
> =0A=
> =0A=
> There is an interesting post from Fabio Estevam=0A=
> =0A=
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fu-boo=
t.denx.narkive.com%2FPlutD3Rg%2Fpatch-1-3-phy-atheros-use-ar8035-config-for=
-ar8031&amp;data=3D02%7C01%7Cleonard.crestez%40nxp.com%7C6e84d8adeb644c51a8=
6408d7eaca858d%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637236027867051=
637&amp;sdata=3Ds7825L%2BHQV%2FmPR2saYHcoSAgVTlZDr5gYT62kVgdeJA%3D&amp;rese=
rved=3D0=0A=
> =0A=
> Thanks=0A=
> 	Andrew=0A=
> =0A=
=0A=
Does not help. What does seem to help is inserting prints after the =0A=
FEC_ENET_MII check but that's probably because it inject a long delay =0A=
equivalent to the long udelay Andy has mentioned.=0A=
=0A=
I found that in my case FEC_ENET_MII is already set on entry to =0A=
fec_enet_mdio_read, doesn't this make fec_enet_mdio_wait pointless?=0A=
=0A=
Perhaps the problem is that the MII Interrupt pending bit is not =0A=
cleared. I can fix the problem like this:=0A=
=0A=
diff --git drivers/net/ethernet/freescale/fec_main.c =0A=
drivers/net/ethernet/freescale/fec_main.c=0A=
index 1ae075a246a3..f1330071647c 100644=0A=
--- drivers/net/ethernet/freescale/fec_main.c=0A=
+++ drivers/net/ethernet/freescale/fec_main.c=0A=
@@ -1841,10 +1841,19 @@ static int fec_enet_mdio_read(struct mii_bus =0A=
*bus, int mii_id, int regnum)=0A=
=0A=
         ret =3D pm_runtime_get_sync(dev);=0A=
         if (ret < 0)=0A=
                 return ret;=0A=
=0A=
+       if (1) {=0A=
+               u32 ievent;=0A=
+               ievent =3D readl(fep->hwp + FEC_IEVENT);=0A=
+               if (ievent & FEC_ENET_MII) {=0A=
+                       dev_warn(dev, "found FEC_ENET_MII pending\n");=0A=
+                       writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);=0A=
+               }=0A=
+       }=0A=
+=0A=
         if (is_c45) {=0A=
                 frame_start =3D FEC_MMFR_ST_C45;=0A=
=0A=
                 /* write address */=0A=
                 frame_addr =3D (regnum >> 16);=0A=
=0A=
=0A=
--=0A=
Regards,=0A=
Leonard=0A=
