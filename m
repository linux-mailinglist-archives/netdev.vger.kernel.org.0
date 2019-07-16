Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A61496A071
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 04:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbfGPCCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 22:02:52 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:38532
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730722AbfGPCCv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 22:02:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMyMgqhKtzlLBALZMeeDhdxUGxxajjTxfxV3TY0R38JMwxmZzOcFWFwjS4WYQJk0NUYQp9aaEdvsjL97AI4K2Fotpyc8qphq4e6oSzhoF4bOH4EEo1XOX/IWgoHwxZ+IPWZMuvDf3f2Pgj252wkern8t6RpjKmyvXaoW+SaqkdjqmVbDEqlQq9ikEnHoWRvtCL5mb9sNUGYYOVv82aXXRa79KgaCh7JKk2YUjeq8KMd58qiNICvaVfg6Z7fs08wQt+V6G3CGoy5IaqXdacjU2/dlkBnhPAZtAAP9dgvYGdrRf5EJy+Nkcx4ZAhmfkb+UMwxKFf1mm0mba9ZzK1qmAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ricfyqwxnwq1b9jDxbRp7JTjRDewCZcetL7SLAZTbg4=;
 b=bDN3ypT76494EIsgBG4UvraC05Z30535RjZNXfiefcTPceeOhEbxdipgSEj8kzFOA9XRhKW1WqsxmRna0KnY8GIxFTK9jtMdPOOS3sLkHSQsPECo0VZaC+rGo5peoibn6tTfJmu7F1n+Tr7oZ2VfMQhs3YRJC2r4JD9FVkNZyr8ak/aOu1XQzntNvOYgShDPMmHoanV+hVMJOiQ+s7FBtcbcr6KZWFu0aoZX1TVTnT1lEt4ltbsOY8wuYlu89CkWaKROzDsFNQ3aov5U7Fu4gRc+x21uhbCByBdJTJfNXP7NfTW8zXScFagK9ShB9HRkX2pN8djeAU5c72XvYUvhHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ricfyqwxnwq1b9jDxbRp7JTjRDewCZcetL7SLAZTbg4=;
 b=oD9BP+0MhFBxcaDkMAzWTNRcIEaSlPof5i2uKlpaxLU5Zk6fhn44kyUefHOqzVhORS5s/phi38OQhTseTTDpgfKEc2Izb8suR20fqUgo2X5lzLbU4CttH06w2cQUSRn14KsxbGgO8pEnkAwXhlbDJLq+Wl5SJTY1Cq20I5K4r64=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB3406.eurprd04.prod.outlook.com (52.134.2.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Tue, 16 Jul 2019 02:02:06 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c539:7bdc:7eea:2a52]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c539:7bdc:7eea:2a52%7]) with mapi id 15.20.2073.012; Tue, 16 Jul 2019
 02:02:06 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Sven Van Asbroeck <thesven73@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v1] net: fec: optionally reset PHY via a
 reset-controller
Thread-Topic: [EXT] [PATCH v1] net: fec: optionally reset PHY via a
 reset-controller
Thread-Index: AQHVO1EEL3ng1jsYe0KS/0rCZTBO1KbMdjtA
Date:   Tue, 16 Jul 2019 02:02:05 +0000
Message-ID: <VI1PR0402MB36009E99D7361583702B84DDFFCE0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20190715210512.15823-1-TheSven73@gmail.com>
In-Reply-To: <20190715210512.15823-1-TheSven73@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb4a3104-dcca-4405-fce2-08d709919a51
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3406;
x-ms-traffictypediagnostic: VI1PR0402MB3406:
x-microsoft-antispam-prvs: <VI1PR0402MB3406B43016FC74F33DC66CB8FFCE0@VI1PR0402MB3406.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0100732B76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(199004)(189003)(6116002)(6916009)(229853002)(74316002)(3846002)(2906002)(305945005)(8936002)(478600001)(7736002)(33656002)(14454004)(25786009)(4326008)(14444005)(26005)(5660300002)(71190400001)(186003)(52536014)(81156014)(256004)(71200400001)(76116006)(99286004)(68736007)(66946007)(66446008)(53936002)(66476007)(64756008)(66556008)(9686003)(102836004)(66066001)(6506007)(55016002)(7696005)(76176011)(86362001)(486006)(446003)(476003)(1411001)(81166006)(11346002)(6436002)(316002)(8676002)(6246003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3406;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mt/jmtv7FbUi5jePcTakpMeu2YVtEYL2uqT5Ww3jWULkOoZf3x1p1tad2A/1HWd5rKZo/lokuLSZQFf28EZpiEQn/ooLWxmsE8l0PpFFo2JxcDipS/uugc+L8R+QXpQeez+bu9ZuHj09dk8qbnCFJC+BsNYQb7c/GGiSe5ne1cbodhGAfKSc4LZdA0piP9NfzLv8r/u9mmLLFclbPTxN7YOmXTvQ0nbKPLjNkO+WguLWuMg7AsTS7g85o1e95gpCugXQbtz191DyqC5g0Zse0k30AYqjK5X+U/x9uNxUWGpSYk+3eK+Ar6ohCzBcoPrzrPBc/nQbVuUeXs7b8gWfHOAy3x80VVOYhtgXy2RFoUsj1R8JQ+cJJJrQzIQEwC19rJ04JC1nahz5o6CZrpjsZsjhjppBhlnGQ9cO7XG/4sg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb4a3104-dcca-4405-fce2-08d709919a51
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2019 02:02:05.9157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fugang.duan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3406
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com> Sent: Tuesday, July 16, 2019 =
5:05 AM
> The current fec driver allows the PHY to be reset via a gpio, specified i=
n the
> devicetree. However, some PHYs need to be reset in a more complex way.
>=20
> To accommodate such PHYs, allow an optional reset controller in the fec
> devicetree. If no reset controller is found, the fec will fall back to th=
e legacy
> reset behaviour.
>=20
> Example:
> &fec {
>         phy-mode =3D "rgmii";
>         resets =3D <&phy_reset>;
>         reset-names =3D "phy";
>         status =3D "okay";
> };
>=20
> Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
> ---
>=20
> Will send a Documentation patch if this receives a positive review.
>=20
>  drivers/net/ethernet/freescale/fec_main.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index 38f10f7dcbc3..5a5f3ed6f16d 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -61,6 +61,7 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/if_vlan.h>
>  #include <linux/pinctrl/consumer.h>
> +#include <linux/reset.h>
>  #include <linux/prefetch.h>
>  #include <soc/imx/cpuidle.h>
>=20
> @@ -3335,6 +3336,7 @@ static int fec_enet_get_irq_cnt(struct
> platform_device *pdev)  static int  fec_probe(struct platform_device *pde=
v)
> {
> +       struct reset_control *phy_reset;
>         struct fec_enet_private *fep;
>         struct fec_platform_data *pdata;
>         struct net_device *ndev;
> @@ -3490,7 +3492,9 @@ fec_probe(struct platform_device *pdev)
>         pm_runtime_set_active(&pdev->dev);
>         pm_runtime_enable(&pdev->dev);
>=20
> -       ret =3D fec_reset_phy(pdev);
> +       phy_reset =3D devm_reset_control_get_exclusive(&pdev->dev,
> "phy");
> +       ret =3D IS_ERR(phy_reset) ? fec_reset_phy(pdev) :
> +                       reset_control_reset(phy_reset);
>         if (ret)
>                 goto failed_reset;

The patch looks fine.
But the reset mechanism in the driver should be abandoned since
the phylib already can handle mii bus reset and phy device reset like
below piece code:

of_mdiobus_register()
    of_mdiobus_register_phy()
        phy_device_register()
            mdiobus_register_device()
                /* Assert the reset signal */
                mdio_device_reset(mdiodev, 1);
            /* Deassert the reset signal */
            mdio_device_reset(&phydev->mdio, 0);

dts:
        ethernet-phy@0 {
            compatible =3D "ethernet-phy-id0141.0e90", "ethernet-phy-ieee80=
2.3-c45";
            interrupt-parent =3D <&PIC>;
            interrupts =3D <35 1>;
            reg =3D <0>;

            resets =3D <&rst 8>;
            reset-names =3D "phy";
            reset-gpios =3D <&gpio1 4 1>;
            reset-assert-us =3D <1000>;
            reset-deassert-us =3D <2000>;
        };
    };
           =20
Please refer to doc:
Documentation/devicetree/bindings/net/ethernet-phy.yaml
>=20
> --
> 2.17.1

