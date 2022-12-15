Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA4C64DE3E
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiLOQMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiLOQMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:12:07 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2055.outbound.protection.outlook.com [40.107.22.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981CE31DEA;
        Thu, 15 Dec 2022 08:12:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTob3zltP8dUCsx5fWvAlkZsHPA4JU+LEwcoDkYdMGNi+YDGtxfIC/IJ1yHo5tj8/xTZr17tGMTsMqKXhTiQnA9OdMb+QR6Q/GbiHk9JuV3yyNLf2r9Jm1X3IGsITNqtZd2MLsvlwflYNdThiQWJpvSJz/luTB+X4rhgT5ZF3w+0aZepA9jKOCwxwEQlTbb/KBgNtxBUj2T65x5U0W5xLf8ftPVtL8emBRmcR8ibPWsjoSdFz3QzwAqeQBU04vuXf3cQlrJdeh6uDOv5dlszPA1ihBogiRi3zt8bjLap2+a8Q4m3YRAr/FxKwJr+z6Pe+7lceMV7eA8HXAetOzQcgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Os/nQh+1dYYG28NTCM5kDDxxlafv/aashhIy2PwIlM=;
 b=T4PTKL/FE0WfzL2QNTLq3DwuFU5jZeGb/GzXgy5qcvgq11uPzbm+cQcqgFLjyYEno/6X+uCccrdmSzRTM1nbme+JEw0hEdB2tTA+tf3/PU7DuulhefEmrDsB/DJ0gEebs/rmXc2HIug1XNgJFWqRyfznt/kTA4NHxdGJgvnrolReItNIYG4+Si446v8Dc5LvZc1Up7Cr1ZqJLPQKs0ppOsOdMH0Y0ifJsU8NeY5MiUHFIRkY58wbRIRH6dkkLJfbi8sZkyaTytNV7aEF5079UXi14VUe3l/ezFVyLIPXrze1I66ZWz25F0OlpysIalUP1gzMP73INJSv2Uyey1HvyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Os/nQh+1dYYG28NTCM5kDDxxlafv/aashhIy2PwIlM=;
 b=fQfR+8JGPW7UsLRwUtbME1Fkbka1dU1eURap1WPHl0U0nSf+fR+H7kkOP+pqxJPy61AKlZQpxdKLTCS0vZMML3ePfpe+5efoOQhbUH1DtUqqGhDVVp45t+MyQaLyketHKMArd951MpkQF0MSCm+CTnOD/vnPwoZr89CS1TjZEZk=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by AS8PR04MB7591.eurprd04.prod.outlook.com (2603:10a6:20b:297::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 16:12:03 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::75ca:4956:79f9:6d69]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::75ca:4956:79f9:6d69%7]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 16:12:02 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH net-next] powerpc: dts: t208x: Disable 10G on MAC1 and
 MAC2
Thread-Topic: [PATCH net-next] powerpc: dts: t208x: Disable 10G on MAC1 and
 MAC2
Thread-Index: AQHY78tRL3+xanEU+0uYmQH01S5oE65vWKRg
Date:   Thu, 15 Dec 2022 16:12:02 +0000
Message-ID: <VI1PR04MB5807CB6B0A348FD680AC420FF2E19@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20221103212854.2334393-1-sean.anderson@seco.com>
In-Reply-To: <20221103212854.2334393-1-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5807:EE_|AS8PR04MB7591:EE_
x-ms-office365-filtering-correlation-id: 2aa8c7e4-a143-4655-9f18-08dadeb71a58
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3suUI9iVU2xaN5VrLsVw6F6p3GwrFP8UyX689GvRuUzhW6QzhnZGcCYrv4jXIwN76droEOc2JbSoMFJjm4lkuPUC7mAeJKbcPBPYuGMLge0/Pi8ZkYoni9uWd8y43kYkeb4SZs8VKtDmlsph73UnimHzCRSMAxszfWXHJzFO/mlSzMjIXqJx/zK3vv1HEE3BKPWb5+/24obi/lO/NWF0UbcfQKCp+oTcDPdlb+I4NfGdA2Xn/4wW6lX+DzJwTDjBGNhWNntsz/Dcj91DcFadk+0t22j+1EuL1zDe9kinLafBbTojHg92S1rvbSEc82oxKNHfuqGHM5J/qNPRgkwwwarjdeE3j6C6eqsNWHrTt/Fe4kfMLFB5qhWhZbInWGcqzvwGVIkvOcHd75r0EIcNlzGRvM5E93XqUZjOy/1E4cMhJ8ULlYQ9I1naZphZBYAJWldw9Duy30K+0eAzONM7n66KVYxQAPWQIzgUdIab5AMG+sFDLwJppBhg3zfaEKwcX7bOI5a5CiEr3h8FZ8covTaTCIIuPVEGBVXVce5nwh9HBShC9gbuyYH/1GKytUVB/oiwQoFDN/2BWn2V7jBCXTRTi/UOCH9oCjVghyVfCYHgTrBBu7T4oTVGN/NQma2ypXytpYxuh52SeQo7LeZYpstaseE/loHTzS/L6ZixVlLD3zyryjvs+l/JigJ1Sdu1rHELUgJAalBPjLiVsl668g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(451199015)(86362001)(66476007)(66556008)(4326008)(66946007)(64756008)(8676002)(66446008)(33656002)(316002)(54906003)(6916009)(38100700002)(76116006)(38070700005)(122000001)(2906002)(83380400001)(71200400001)(55236004)(26005)(186003)(53546011)(9686003)(478600001)(55016003)(41300700001)(6506007)(7696005)(7416002)(5660300002)(52536014)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/LPs1nha30L38pvrriR7OTBro8iylcC6eSIMX7dxEQQWeSsAH6kfnPVrxPfP?=
 =?us-ascii?Q?kb0dH4xZTkirwlx9+wMO6KnPGrNsnsEYr2FmsToqJ9/cIF+4WRCHOPhwUlWk?=
 =?us-ascii?Q?TNGhlwjMK8a/ccjEqpmMNEBhM34HXo9FN/WU8VV4V0Z9zG5ExLMxJ5m7QEqL?=
 =?us-ascii?Q?fyZSOpFvylPPeleXNTdb/R1j5weF2JWuW3St8GRIHubacDLaK648ZLZmN+YU?=
 =?us-ascii?Q?bcmoOqZCNEJlKzOpba4/EODFFKGzEX+h3gTz7kFL6GlpJHFgta0ngYQ8Lg29?=
 =?us-ascii?Q?qH46sZA2IvUhP4JH7DSbP/Vg8bmhRmd/Zg28FRlG9nzFlw4f5M7I/Bivj3AT?=
 =?us-ascii?Q?Nuu+P2p7f+IZm7qhqv2nP68u8gQJie4+WFgjFxSS+qFKhgFg9icQaCvSH0ZU?=
 =?us-ascii?Q?xIlsaBn22cvcmt+DUUHel6sOrr6l6g3X0UtuiaF1DdyeO9zT2mWPhVrDSQ5+?=
 =?us-ascii?Q?5bCw2RpB6tH6D+NyEmy7viPVjgwjuPK6bsxhurYiRRnIqIeeWlljAFG7k24O?=
 =?us-ascii?Q?T0g1QYfYmbqqgRpnAk1plMJ/TDNVIzUQr6vKW5uMd8PD81cI/Yp5bsNcsy0K?=
 =?us-ascii?Q?mWOQCSjFcJoP4O51AhOls8DWIJRkYjXPw0gkKyttIC3gEkdgQbbzgfFyhWQh?=
 =?us-ascii?Q?lq+pHmyXzmB44SaBMYRfNNb/JyyR5c0IijDrsxNRr03V4q1ZamEeYGtMZqti?=
 =?us-ascii?Q?3OBTAHLRRFk3tHTICiBQ7cLQ1Y/P/o+lj1RBj4B0019z4jcNeLc2h3JtizYe?=
 =?us-ascii?Q?UCv1EhsBJXi/ARsqdJ1yUnrk9E09+j7ginCSPHFC2dd8yr8U2lugMOgY5UCN?=
 =?us-ascii?Q?DyiIeRHUj3ytUxxYEvEWeFQtLfNhGv0cFoNvNFhcdEyRhmo3qezUU+jGpVCW?=
 =?us-ascii?Q?OIbx02chZgPYLxExsdkFeM5Mxzd/Un9Nc9bD9kI/FFhPCJ5E+lYSpJyST5PQ?=
 =?us-ascii?Q?2/zRrkF9QJ2pJ+XQfKBPKwhL2rjx8Z74MpfVqeIV7oUeGmo7C9Q76AuQ7oS3?=
 =?us-ascii?Q?vlWGN8Kkz5euF7xO4xbNq9A7K3Dm+yvtSeRPS+lWh2ZWyB51vZCTXltQ/+S/?=
 =?us-ascii?Q?rZ3TcRZs7s8vgzgRVH/o/Fl40qLn5lNoNSgUztLnqCdsCT2uNw2qA+/80/c2?=
 =?us-ascii?Q?g1lu7P0jPxEgGk/4l/vujyx4ldrEwrWTWnzwYhFhMnuYZg36ehGTQaNOAezt?=
 =?us-ascii?Q?hTJvmV2Tb2h2PdwSFJ0lrtGVBGUCG62oIHpN3I5KzS2CHR7K+D4MNZ4uU2E7?=
 =?us-ascii?Q?hiuOO1nQ5pvRMJIzDdwCDYwxgt8Vry2AgIEhN+MyxGlhP0PSEyyeEgUg7JJ/?=
 =?us-ascii?Q?7ITZeH2ncO8Aq5ReMjcdoeUPIspZUloxGB1BuoGxuEPqjJzt4oy5feNG4O9n?=
 =?us-ascii?Q?MiyxHBhrszpynhU78T9SAX1QUoMecpwBEHsWitAOSCAcqBaWeSHfGY7Nu9wq?=
 =?us-ascii?Q?YNEH3N/19rVLw9cffZitPqe7m3Rh53bPdalH18+pdwoaZKevJO4DpaD/RLEI?=
 =?us-ascii?Q?tuStD9ePMgl3YzijWs3mX28A3s5gnpA2KUsReAqq7DeiVC8hspB2YdflBwyE?=
 =?us-ascii?Q?uWFz2N8HMw179dnk4cpwfEwWaUbqPY/HLdHQ/lVQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa8c7e4-a143-4655-9f18-08dadeb71a58
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 16:12:02.8118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Z8KyQedM1x5/I4lU/628ancn9geBqOjDcrfkjVQxJ63hqktFEVmSU5a1xA4QzqejPG4BvMVo6C1hzBSQbdQpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7591
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Thursday, November 3, 2022 23:29
> To: David S . Miller <davem@davemloft.net>; netdev@vger.kernel.org
> Cc: devicetree@vger.kernel.org; Michael Ellerman <mpe@ellerman.id.au>;
> linux-kernel@vger.kernel.org; Rob Herring <robh+dt@kernel.org>;
> Christophe Leroy <christophe.leroy@csgroup.eu>; linuxppc-
> dev@lists.ozlabs.org; Nicholas Piggin <npiggin@gmail.com>; Krzysztof
> Kozlowski <krzysztof.kozlowski+dt@linaro.org>; Sean Anderson
> <sean.anderson@seco.com>; Camelia Alexandra Groza
> <camelia.groza@nxp.com>
> Subject: [PATCH net-next] powerpc: dts: t208x: Disable 10G on MAC1 and
> MAC2
>=20
> There aren't enough resources to run these ports at 10G speeds. Just
> keep the pcs changes, and revert the rest. This is not really correct,
> since the hardware could support 10g in some other configuration...
>=20
> Fixes: 36926a7d70c2 ("powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G")
> Reported-by: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
>=20

Hi Sean,

I know I'm late, but there are a couple of issues with this patch. Do you i=
ntend
on sending a v2 or should I pick it up?

>  .../boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     | 45 -------------------
>  .../boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     | 45 -------------------
>  arch/powerpc/boot/dts/fsl/t2081si-post.dtsi   |  6 ++-
>  3 files changed, 4 insertions(+), 92 deletions(-)
>  delete mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>  delete mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
>=20
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
> deleted file mode 100644
> index 6b3609574b0f..000000000000
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
> +++ /dev/null
> @@ -1,45 +0,0 @@
> -// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
> -/*
> - * QorIQ FMan v3 10g port #2 device tree stub [ controller @ offset
> 0x400000 ]
> - *
> - * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
> - * Copyright 2012 - 2015 Freescale Semiconductor Inc.
> - */
> -
> -fman@400000 {
> -	fman0_rx_0x08: port@88000 {
> -		cell-index =3D <0x8>;
> -		compatible =3D "fsl,fman-v3-port-rx";
> -		reg =3D <0x88000 0x1000>;
> -		fsl,fman-10g-port;
> -	};
> -
> -	fman0_tx_0x28: port@a8000 {
> -		cell-index =3D <0x28>;
> -		compatible =3D "fsl,fman-v3-port-tx";
> -		reg =3D <0xa8000 0x1000>;
> -		fsl,fman-10g-port;
> -	};
> -
> -	ethernet@e0000 {
> -		cell-index =3D <0>;
> -		compatible =3D "fsl,fman-memac";
> -		reg =3D <0xe0000 0x1000>;
> -		fsl,fman-ports =3D <&fman0_rx_0x08 &fman0_tx_0x28>;
> -		ptp-timer =3D <&ptp_timer0>;
> -		pcsphy-handle =3D <&pcsphy0>, <&pcsphy0>;
> -		pcs-handle-names =3D "sgmii", "xfi";
> -	};
> -
> -	mdio@e1000 {
> -		#address-cells =3D <1>;
> -		#size-cells =3D <0>;
> -		compatible =3D "fsl,fman-memac-mdio", "fsl,fman-xmdio";
> -		reg =3D <0xe1000 0x1000>;
> -		fsl,erratum-a011043; /* must ignore read errors */
> -
> -		pcsphy0: ethernet-phy@0 {
> -			reg =3D <0x0>;
> -		};
> -	};
> -};
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
> deleted file mode 100644
> index 28ed1a85a436..000000000000
> --- a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
> +++ /dev/null
> @@ -1,45 +0,0 @@
> -// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
> -/*
> - * QorIQ FMan v3 10g port #3 device tree stub [ controller @ offset
> 0x400000 ]
> - *
> - * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
> - * Copyright 2012 - 2015 Freescale Semiconductor Inc.
> - */
> -
> -fman@400000 {
> -	fman0_rx_0x09: port@89000 {
> -		cell-index =3D <0x9>;
> -		compatible =3D "fsl,fman-v3-port-rx";
> -		reg =3D <0x89000 0x1000>;
> -		fsl,fman-10g-port;
> -	};
> -
> -	fman0_tx_0x29: port@a9000 {
> -		cell-index =3D <0x29>;
> -		compatible =3D "fsl,fman-v3-port-tx";
> -		reg =3D <0xa9000 0x1000>;
> -		fsl,fman-10g-port;
> -	};
> -
> -	ethernet@e2000 {
> -		cell-index =3D <1>;
> -		compatible =3D "fsl,fman-memac";
> -		reg =3D <0xe2000 0x1000>;
> -		fsl,fman-ports =3D <&fman0_rx_0x09 &fman0_tx_0x29>;
> -		ptp-timer =3D <&ptp_timer0>;
> -		pcsphy-handle =3D <&pcsphy1>, <&pcsphy1>;
> -		pcs-handle-names =3D "sgmii", "xfi";
> -	};
> -
> -	mdio@e3000 {
> -		#address-cells =3D <1>;
> -		#size-cells =3D <0>;
> -		compatible =3D "fsl,fman-memac-mdio", "fsl,fman-xmdio";
> -		reg =3D <0xe3000 0x1000>;
> -		fsl,erratum-a011043; /* must ignore read errors */
> -
> -		pcsphy1: ethernet-phy@0 {
> -			reg =3D <0x0>;
> -		};
> -	};
> -};
> diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
> b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
> index 74e17e134387..fed3879fa0aa 100644
> --- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
> @@ -609,8 +609,8 @@ usb1: usb@211000 {
>  /include/ "qoriq-bman1.dtsi"
>=20
>  /include/ "qoriq-fman3-0.dtsi"
> -/include/ "qoriq-fman3-0-10g-2.dtsi"
> -/include/ "qoriq-fman3-0-10g-3.dtsi"
> +/include/ "qoriq-fman3-0-1g-2.dtsi"
> +/include/ "qoriq-fman3-0-1g-3.dtsi"

These two should be qoriq-fman3-0-1g-0.dtsi and qoriq-fman3-0-1g-1.dtsi.
You are including 1g-2.dtsi and 1g-3.dtsi twice.

>  /include/ "qoriq-fman3-0-1g-2.dtsi"
>  /include/ "qoriq-fman3-0-1g-3.dtsi"
>  /include/ "qoriq-fman3-0-1g-4.dtsi"
> @@ -619,9 +619,11 @@ usb1: usb@211000 {
>  /include/ "qoriq-fman3-0-10g-1.dtsi"
>  	fman@400000 {
>  		enet0: ethernet@e0000 {
> +			pcs-handle-names =3D "sgmii", "xfi";
>  		};
>=20
>  		enet1: ethernet@e2000 {
> +			pcs-handle-names =3D "sgmii", "xfi";

The second pcsphy for this port is still qsgmiia_pcs1 as described in
qoriq-fman3-0-1g-1.dtsi. It should also be overwritten, not only the name
property:
	pcsphy-handle =3D <&pcsphy1>, <&pcsphy1>;

>  		};
>=20
>  		enet2: ethernet@e4000 {
> --
> 2.35.1.1320.gc452695387.dirty

