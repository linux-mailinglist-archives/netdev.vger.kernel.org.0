Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C35607962
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbiJUOVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiJUOVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:21:01 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A8A265C69;
        Fri, 21 Oct 2022 07:21:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfRAbdvUutVKD/nb8SpZrUHC+KTkEm5Q2zBtYcqmoaVUdEZPjN0e6wq1+0bXsuf5aHAFVqc6zkT39eP50oKGyv6ov/Xxkbnxdj8GocCkbF5M2i5bH6yKvqZVsIRaAHbrrfzMzYtjC33Bf+hV33kngnFESui14iwCSh0NMLOF5BInBtX/a0YAnoP188TeB7MFMDP8aNsJd7Y88ERXBiSBvuh2ovFeHSjsLBRvsDAXCfmUPNZWrmqq4C5RSSGq0E3GMUgF3reLnL2vGwNysrMv2pCGmYexV3vozcaeS8BZTs9tYa+QTBSMq68AXp3HNnDfTbJoKLdiV+v86ARGxXr6Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jXaFyJIQS2DJD6eoMegLZnDjvisITtqz741sMDc/3Qo=;
 b=DlUkAg4g92O2g7fZugRRuWh280uQN6hHBAoDFZfcEoBwim0lV2br7LT1drq48jZgD7dEv5eL8BT8TBaeLuV/MomwzdLPh9m4i9K9SQXKvRt8GyT2++L4wSEAP7LX6At494B2I5N7B3of3KBrivI96KPLkLxP6dKbNfjtPdE0yWna/cvmKcrmzL7M6YN79hXZo+6qMKQJd71XUrL02AXmAfNNxddbgqHcjuDcatz4qBZWoL469qyJwlgI1sTb73VD9qP55BpVCNRPdp5i6LAOwXukoV3MEsnJlSi53A8k5tW2theQ65RHybsFkYQrIOd6YuNLyvFkfR5oTX7PcxTyxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXaFyJIQS2DJD6eoMegLZnDjvisITtqz741sMDc/3Qo=;
 b=M/p5TPBgKuWsHlLs3nCnf7vNi55cMrNBVSP3MnXAfCvrwS6SzsDpE5/Q+FzYlrRynbpe3ApcHWDPYEttKmOsZC0LXyg46rq55YRj7L8NpAs2ZxxW/Ec/i/tBKrOQj1qidqK2pHXkrz1EdqcHLULW25eJmN4docymavNQLGOP/QU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9488.eurprd04.prod.outlook.com (2603:10a6:102:2af::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Fri, 21 Oct
 2022 14:20:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 14:20:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v5 5/5] ARM: dts: qcom: ipq4019: Add description
 for the IPQESS Ethernet controller
Thread-Topic: [PATCH net-next v5 5/5] ARM: dts: qcom: ipq4019: Add description
 for the IPQESS Ethernet controller
Thread-Index: AQHY5UsZufLiXBWDx0irerpeDpuMhw==
Date:   Fri, 21 Oct 2022 14:20:58 +0000
Message-ID: <20221021142057.zbc3xfny4hfdshei@skbuf>
References: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
 <20221021124556.100445-1-maxime.chevallier@bootlin.com>
 <20221021124556.100445-6-maxime.chevallier@bootlin.com>
 <20221021124556.100445-6-maxime.chevallier@bootlin.com>
In-Reply-To: <20221021124556.100445-6-maxime.chevallier@bootlin.com>
 <20221021124556.100445-6-maxime.chevallier@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PA4PR04MB9488:EE_
x-ms-office365-filtering-correlation-id: 0ff54a62-3b2d-40a1-1a2e-08dab36f792d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mh4X/tVOIpNiEmIafNDs9j2jBJD4T1Lu5Yh6Podb0bX4kH/6tX7E2BMWMZR4iD0fcHSBorwY2CUnuHoB80y5SCEgEV3IPzevbA1rTY4hKGME8TeEY3RCRqcbyrpjTOIgfNTSbYrZ4UcQN7aCdrKqxhXy8tHo1iLRm72di8sUcj24BtwuUdpEJziVfIbOIJ9C8pQR5+oshpwR+PNDS5J9JDSb0VbvxA7ppJXsWw2B/P0K2UepgShAmeVFxKhzpHBvq28sCj1ejRvdxCJHr53OlrhXRXaxNjGX0EIQbP+q7k4HkRJmF5y9IR4CRi+03ulZy8ZCQP2rwwj9fWolpz64CS9Aydfv1DxqxQHE/qFKJZj6JRAVS+ANpf1A5P4vS/DK14uDoVzI36zGITXFqJmoPzeEIRHW0GDVsYQDQzWjXXqOGLBdCCb7lro8JSP6DZhasIF8KPnh1ld/ctb8xY2pZOwqXBIdBx3Xw1utZqC46nJp1p5r0llDq7zfsG6tD+KhTomxT72I7yzl8gw1ul8vNfS+c/o+5FGlAG7AnenwbddeR+eHRf1KZWrPimfGmFFz2/IaqhLQ7ISldNUHlU6E0zbwwk1FgAsnj5KinPs8IqiEXzbUerDSP+pDNYIvBUCIdEx3PMog1Tqr2ZlksRiP7s1v/flXCKIPP4wA977g3XdiggP76gAYK4I89SyVNvWSuTz5Kla8LnAR6NSdPVZ/F2qe8hNjMUFTHzYkp2AY8TYBXSTTYgeD/WqAraALJPvq1qISjKbiTfMr1D/rfdc6Mg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(346002)(39860400002)(366004)(136003)(396003)(451199015)(122000001)(86362001)(38070700005)(38100700002)(2906002)(5660300002)(4744005)(6506007)(7416002)(26005)(6916009)(44832011)(1076003)(186003)(316002)(9686003)(6512007)(6486002)(54906003)(83380400001)(66476007)(478600001)(64756008)(66946007)(66556008)(66446008)(4326008)(8676002)(41300700001)(71200400001)(8936002)(33716001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yD803O0s5jAfnU+BWQQWWP3Xjwx6MAOEpuGlMbuS8pzBENl147Kd7K4cAyXK?=
 =?us-ascii?Q?M8o0TT+tAH+fR/VQv9iMhNuggrzpwj433+n/VUqV6Kxov5lyTQ+vXGYTmW4k?=
 =?us-ascii?Q?NjEysgIJod8XwF5Yf1ZUizIqNxNPjSZBqKoV+/+5Tq5BpJphygu9n7t/eEfq?=
 =?us-ascii?Q?dfwydo+t/mYofBFK29Zl8HVNNfVAXVbMpz9NIzX006YfouEF48ptT7rfFYED?=
 =?us-ascii?Q?Makwr7aHZ3DJa5lx1gbImHUAB9xWEkUxRM+mf9DY2dJYXQLFBN4aSanC+fCl?=
 =?us-ascii?Q?BYaTrVME+C6IvYY2+skrBt7wK2L2C6twt5P92mBzAjcKARch1UAR9RoRRXUm?=
 =?us-ascii?Q?FSpTLen6luuLqBx/7Dk3f5C4BB6FazCvGMEgCObEVqOGLKGw47JupoMM3ZfW?=
 =?us-ascii?Q?bINZDjgxi/dBZr6RCQdmicU9BFaHM6qGEIJt06vMxuoWFOmUTT94tK0JMa5F?=
 =?us-ascii?Q?SHT5Hwn1QxWHLKjKGsKjzSCzo4z33jjs8wLbKTdnwqbzfbeZ8w++x1xGdYYj?=
 =?us-ascii?Q?O62uZzZoG9JeaKAGAVcCDzIEsqiXOux4rCAvPBLTXm0SGfEwRlzYbgzaT+WB?=
 =?us-ascii?Q?Xakvnwyd3wOugv/YcHQoXIY/G4P9HvJ2N0OOq63E+7Wvr/XJLxSi7RFq85SX?=
 =?us-ascii?Q?VVItx1kG2YfMu1foHtXjTa+/00xiDP3Jmnvi7oXrgZnOTUT2rDYggaw1WZ1m?=
 =?us-ascii?Q?qSATIK3vpcbkDgIDCI0FvWL7HkxGxQfzuExGxJY+h2g9xjuCVRDv8O9zkx0y?=
 =?us-ascii?Q?yNRPMw3TZuSBG9405Ta57f4anY7cx6ziPAqMshYEcHmben5Y19QmGzhPWUjQ?=
 =?us-ascii?Q?EfjMNZXrRO027lPliL4zrAn9izoy0Tfjy/UBdAlNB6aiVaAabHfTR7MlJ5hU?=
 =?us-ascii?Q?i84XK9e/oOzgyiDFYQCt7wprlsOoHfiv2IQ6hxusEpn8oVqLjHmhvfBnspJB?=
 =?us-ascii?Q?fBGAbxbkO5yewpkZqCPQvSNC3MF/+svg8G+U2Ao26h1G7Zo3LhkOjH9QQPqL?=
 =?us-ascii?Q?5jUFhnFz8JDz0KXxIXz2MeZ+Pn7+TmBW/Kil13QgGh+WPdsE5zx2ocDRn78E?=
 =?us-ascii?Q?pvmqNII+iipCqHU/+EkdQogk9yOMhY+KEqxG6dwWXqFfKDfsVMS8NnZnAmKy?=
 =?us-ascii?Q?4TUE9THfm2wKnYXzLjjIGLTghiLrqIOZbw8uDy4IMjbOnQXbpzmRia2lUlMZ?=
 =?us-ascii?Q?Nuk3TlwBe+02Fc0ikMsKxLv8837/P7Gbjcd6F7NUnOmYH6yCUTrq26Ir8ZC0?=
 =?us-ascii?Q?VXJxgl8+4ccFcDUS5Frn7MgmG1FNfCCd9hi6VJ7Nj+zw3omiG7kCt6bSaXdD?=
 =?us-ascii?Q?V5i7FQdtoZpdV1Pae+JRuesla2G1HFDNXuT8sgIyKF+XlmHTNuQjGVFY0E1x?=
 =?us-ascii?Q?P9J0anp1pYNd0tt5IMAs5YV0VC4Yr5RBTZTlSvwqouYT26B+KJFuhDhxrjh1?=
 =?us-ascii?Q?EikXG/6d293B3zkRB+V7Q2yGzbZ4uk5xEOpLJ3hGk7W0t45qvEpqhrZKBfJx?=
 =?us-ascii?Q?8nweUfovFvntv38/xJOpcxyOhJZaY9Op20sVarMc5aM5Gv8IhEjv1Lbwly3/?=
 =?us-ascii?Q?Wmen4i1qzaEaGo3hq2jGYHMZGEYgwHaAp1rjYH/20zDeEtadTrBar41ipVkw?=
 =?us-ascii?Q?lg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27A1C4204E45554489665B36E3A728DF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff54a62-3b2d-40a1-1a2e-08dab36f792d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 14:20:58.1462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wZYeO7SwvSInKt6HieYA5tAxgdwn5swOv9PUDelARpOttu9Y5EzsgDJR15aGvsweyHjF9Sje5v7ki9t3+sspLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9488
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 02:45:56PM +0200, Maxime Chevallier wrote:
> @@ -591,6 +592,51 @@ wifi1: wifi@a800000 {
>  			status =3D "disabled";
>  		};
> =20
> +		gmac: ethernet@c080000 {

Pretty random ordering in this dts, you'd expect nodes are sorted by
address...

> +			compatible =3D "qcom,ipq4019-ess-edma";
> +			reg =3D <0xc080000 0x8000>;
> +			resets =3D <&gcc ESS_RESET>;
> +			reset-names =3D "ess";
> +			clocks =3D <&gcc GCC_ESS_CLK>;
> +			clock-names =3D "ess";
> +			interrupts =3D <GIC_SPI  65 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI  66 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI  67 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI  68 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI  69 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI  70 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI  71 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI  72 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI  73 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI  74 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI  75 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI  76 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI  77 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI  78 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI  79 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI  80 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 240 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 241 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 242 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 243 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 244 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 245 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 246 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 247 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 248 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 249 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 250 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 251 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 252 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 253 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 254 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 255 IRQ_TYPE_EDGE_RISING>;

32 interrupts, and no interrupt-names? :)

> +
> +			status =3D "disabled";
> +

Could you drop these 2 blank lines? They aren't generally added between
properties.

> +			phy-mode =3D "internal";

And the fixed-link from the schema example no?

> +		};
> +
>  		mdio: mdio@90000 {
>  			#address-cells =3D <1>;
>  			#size-cells =3D <0>;
> --=20
> 2.37.3
>=
