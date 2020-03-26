Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6491939C7
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 08:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgCZHqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 03:46:05 -0400
Received: from mail-eopbgr40085.outbound.protection.outlook.com ([40.107.4.85]:50247
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726332AbgCZHqE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 03:46:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AX+jshcdCSD2IJ+rhnO0etWlLs9hqhp2akxPUX2DwQg/fR8tVjc6wxmxCT33vfMCI/HmqRJ7EIjXeVVEtTwJ1IqgiQxa3VDQCj3SJRI5USOmM0YVLK2XTCY8rX5GsbI78dOfUsWkrOERITK8OI4gUCrlEujvYSmeud4mSt45UDQ4xlMCuhsyqegbjUCNvhBEB2HWuhCiMooMlXiIH2Jzcsvz6QLy86m6TGsugfcPSHOpQjkJJ9Y7YeZDH+vGjBgkDv7FO7/jzC8NFa7OweS1eVd/+RX859KMxmY5QP/9MwXMt/3BEYa1bReMQzbAvwsavItFfn+BJGYaYWQONhnFoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EMjrK9UFhQVSjhYxZGhvZdlmfvRc0mC/4oWX6ubN9C8=;
 b=YOGSEMSKwcGdrxdt5OSXkieshDYQ/nFUpoiqC1ZktSUroGYWX0cKnHi5o26va9Q2kKL5d/C+uSGlOW2rdh7BYb8v4NdJmRkNWEuLksfeaXxnnRwKQtC2zKfDVKNpvzTs+ov/Mp3PJN6CH/hPH//MKOmaWDgfnDqkmgUzQZfn7eejrew+jB/MfGEPAyaKJSPyCSQ9ge1V6++TKnu8cJMILrzzj2Rl7OFMNZe0gQ5ZJU7AUwqpgVNAKpQzJXB7H42GBCsft6v0n6WcNMbsxiIU7oj8SK8BN3EEYwSTX0GexVP5ERBo8KfikPc4l52iWPPy2IAQ4rtZABJOd42YA/Uo7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EMjrK9UFhQVSjhYxZGhvZdlmfvRc0mC/4oWX6ubN9C8=;
 b=ad3152GHh3zV3i8DuYA8hxWerNKTJ/0zZ8h1Ei+60Q6BAjzVjJ1IB7VDJZnzNbigMXOXzxewJDHth6lF/pzrzQXe9cDJS28PzEtMGZuLF1yvVFS5u0c10/5cD5sw1tOBQRkQ3JY48YTE7CgrYltp8wWY+DGVaDdnxK0MU9Y1Z/4=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3951.eurprd04.prod.outlook.com (52.134.13.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Thu, 26 Mar 2020 07:45:59 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 07:45:59 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: RE: [EXT] [PATCH v2 2/4] ARM: dts: imx6: Use gpc for FEC interrupt
 controller to fix wake on LAN.
Thread-Topic: [EXT] [PATCH v2 2/4] ARM: dts: imx6: Use gpc for FEC interrupt
 controller to fix wake on LAN.
Thread-Index: AQHWAtDhpmxkSeO+/UmkFKR+dBRcD6hafyPg
Date:   Thu, 26 Mar 2020 07:45:59 +0000
Message-ID: <VI1PR0402MB3600534A60ACE5E658196053FFCF0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1585159919-11491-1-git-send-email-martin.fuzzey@flowbird.group>
 <1585159919-11491-3-git-send-email-martin.fuzzey@flowbird.group>
In-Reply-To: <1585159919-11491-3-git-send-email-martin.fuzzey@flowbird.group>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c83a7b9e-c645-46c2-65f4-08d7d159b9fc
x-ms-traffictypediagnostic: VI1PR0402MB3951:|VI1PR0402MB3951:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB39517EC7BAF7FEF47F42A081FFCF0@VI1PR0402MB3951.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(346002)(376002)(366004)(71200400001)(33656002)(8936002)(55016002)(186003)(4326008)(54906003)(86362001)(478600001)(2906002)(316002)(66476007)(7696005)(110136005)(6506007)(26005)(9686003)(52536014)(64756008)(66946007)(81166006)(66446008)(66556008)(5660300002)(81156014)(7416002)(76116006)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3951;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IP60BTJLrfe+V5hZ4+EIrAUZWblz/OXbqBmC3hxSd7UOdCPx/t4tjNX694da42NmhueEDzlgrtm3We+unKtK2IggZSok1FVsiIW+q/fhiI4azglBGtsfTbCdV/TDumdp36b9xEKgQpvHRCanjTPjvWyVKRb5MVaS46vtbs5lAtvaGfUjNht0chDpgcuMZX7rv1iNVgPPRhtNXekeulw5VP4y1YK76+p/NO0GbV9sfuPWL9KIdMxvJYIS5WNJV8omaVVRTUZoSTcYNU9qVQKVEyYDe9TFhRNOXgCMZkhLvGvvS7iqFWe8/paWxAV/EVGDs/yuI6FCGoLDVvdB1GoVgdXLWH+h03fojesIqEXwlEboBh2XOU4MN2Y2/bONL8uqEOryGYNuhAYrmcUO1pAqPPO7vy7ektCJQriVUh9EcY3a0HWqySJM23WUSS5LtpxS
x-ms-exchange-antispam-messagedata: aL43OZnK7o8aTfFjf1TGvEhbFlyRpMowyB21zZOmY2krk4YtoU6tS1JNQ0n2ldgXiLm0A/aoE0djkL+KP3FzDoqRpQCu0s2ytxtZdU19Zs8mU+g2S44agwbVOrvQ9VdDIFB48n+x90N2ZTCAyHOT/A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c83a7b9e-c645-46c2-65f4-08d7d159b9fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2020 07:45:59.7436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /56BnJRIj5hJl99zzXNoSVdG+I9D2makTcz+7QZkmIVhCcIa3UJpmJS4/Z3a6iGlTtk/9afcUmLJguo7kZ3jjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3951
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group> Sent: Thursday, March 26=
, 2020 2:12 AM
> In order to wake from suspend by ethernet magic packets the GPC must be
> used as intc does not have wakeup functionality.
>=20
> But the FEC DT node currently uses interrupt-extended, specificying intc,=
 thus
> breaking WoL.
>=20
> This problem is probably fallout from the stacked domain conversion as in=
tc
> used to chain to GPC.
>=20
> So replace "interrupts-extended" by "interrupts" to use the default paren=
t
> which is GPC.
>=20
> Fixes: b923ff6af0d5 ("ARM: imx6: convert GPC to stacked domains")
>=20
> Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
> ---
>  arch/arm/boot/dts/imx6qdl.dtsi | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.d=
tsi
> index e6b4b85..bc488df 100644
> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> @@ -1039,9 +1039,8 @@
>                                 compatible =3D "fsl,imx6q-fec";
>                                 reg =3D <0x02188000 0x4000>;
>                                 interrupt-names =3D "int0", "pps";
> -                               interrupts-extended =3D
> -                                       <&intc 0 118
> IRQ_TYPE_LEVEL_HIGH>,
> -                                       <&intc 0 119
> IRQ_TYPE_LEVEL_HIGH>;
> +                               interrupts =3D <0 118
> IRQ_TYPE_LEVEL_HIGH>,
> +                                            <0 119
> + IRQ_TYPE_LEVEL_HIGH>;

Please remove the property "/delete-property/interrupts-extended;" in below=
 file:
arch/arm/boot/dts/imx6qp.dtsi
>                                 clocks =3D <&clks
> IMX6QDL_CLK_ENET>,
>                                          <&clks
> IMX6QDL_CLK_ENET>,
>                                          <&clks
> IMX6QDL_CLK_ENET_REF>;
> --
> 1.9.1

