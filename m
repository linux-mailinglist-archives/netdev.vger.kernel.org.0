Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4539D60799C
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiJUObI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiJUObH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:31:07 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2045.outbound.protection.outlook.com [40.107.21.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE97186796;
        Fri, 21 Oct 2022 07:31:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EiAvaq8+V+Gc+e/UVqzLDrd00/YYd3qGsnl0cZ751pShfL4/4bmrt3pLho+AdSHxHBBNtr6pycoVOwYNiwd4F5egImy7nOdXWb5bMlptGKDUl0c1Kfs70efvKNGEm2DIXNYHDXiooPE/lltdC7/Jo4OArdVj1/+Cf8ugB1YU/XbX95+jblMec6Hy+abzna4dpeWO1DWjKmrVEFyRHewK6G6aBogfenRKoodpOmrU/l/iZNwRcVQPsnuYvkyCN/3dPVHnllQJ3kxzZsGs8mROY3d02MuJdBnsRmKE7o01FePz4uAt0z0VrvBzYDNCiM8PKmFkeDb3Ss+3pqIkbWewzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMq2cFtffgeAEB7d4sp5cnME/H+CS6UlsvsGk+PLiJQ=;
 b=RdJCoTT0P36MMGdtZhvo3o6y7PGwCBg5t3lDquHUXsURED+ADIwskC0SiZVGKiF3AyTYx3fEV5z/mX+KLy70wUo6M2Rny9sEIGZnDJCb/mHZW+L2Vcj+MOYIuwQN+UHbMikTXWpoApiLLL0KWeH1Jmt9nHX1xajbx5kjCz3yIek6D2P/oyPd4ubQu350zN2gLClPfc7rr+C7lAgO0w+DdXT3WfazJkZDhfNX4cIq/tLAJ3iX+XS7ikUNVD8fHjfSkhfb+DagsJzZvzqf5S0/jSGHgY4xKAPPIDd8Stnu9tReFQLb6Fw65q68kdAKwhzd6EYwZdJvbYasBpl5+440Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMq2cFtffgeAEB7d4sp5cnME/H+CS6UlsvsGk+PLiJQ=;
 b=oTHjRCb0iNi2GQU4UW1VPuxUpy2L7w1QuhGHfuD8ElBdYNC26+mXSpUvgPY7P7RexGA1ptfo/md34wxgBm1J5uWjPeV15l7nEloIax0SLegjCRX3TFxdm/BL4Zfj2Q8nzNgOoMbjHG5QBvGLgwFCWcg9VE1VbxqwL6ygJK0dqEY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8136.eurprd04.prod.outlook.com (2603:10a6:20b:3f7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Fri, 21 Oct
 2022 14:30:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 14:30:59 +0000
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
Subject: Re: [PATCH net-next v5 1/5] net: dt-bindings: Introduce the Qualcomm
 IPQESS Ethernet controller
Thread-Topic: [PATCH net-next v5 1/5] net: dt-bindings: Introduce the Qualcomm
 IPQESS Ethernet controller
Thread-Index: AQHY5UsVP18kioT6hUa4h8fI414WPq4Y6OIA
Date:   Fri, 21 Oct 2022 14:30:59 +0000
Message-ID: <20221021143058.fg5vet5or4qcnet2@skbuf>
References: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
 <20221021124556.100445-2-maxime.chevallier@bootlin.com>
In-Reply-To: <20221021124556.100445-2-maxime.chevallier@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB8136:EE_
x-ms-office365-filtering-correlation-id: 21d747e3-91bf-4d0f-db48-08dab370df7e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1yNpG5YO4swBTrITmQkKLMOA0aYr/NyxAU62lHgqysOEUJS85Ip9kU3z1pSZ7EVqbeU3ZYf0p0uimEmcovlXVd3C8xJt2L6FZYGMI0BFvT2w8ZG4IW9Wyw6iAlXFI/Dh6RKV7mGg1h9mrD3oC9ch0UmEcUe+4TYisk8Mom4yGg3eK81OntB8ZwD5HaGY68flsazWMoEK6h1VaMyuIxHbjkXrEqjyqfPWmTEIjCbxaDrAwFGs+QUbqH/wHpLdF38pshL7P/k3HjxDQYtE7TEqZx/VGvsuhwJXrC83WCNJl2oY/q0cdnrwdgJiXLn1NZeHDVAP7Tqjo5wUY19C/q8MgD7q/PQhaTcwx/HJvXcGNjpJO6HOhHRRBBOJtauB4rpVPwo62F2vfkIZeSWXeejT64HVpipwIBkbCNaWXzIkhSoOl3rvINVsdFoEiMO1FhZhsnGryuzE1EXnvpIwItkaHh2kLhwmOmILY5kQ0blKe8IgWQ94EhRa+hKtghOTbDkhStQe91806ygr648HiWwR8lxmaLYE4E/CO/s50jQZyHPlMI+MxPgcbq+4ayRD5k2mBAkwR4YfzT1Yxv9hdFvUJjMqDf90NxuOhCGStJnE1HjGQSijOeR1gPI2CANK/9pZ79gHWAIbWv4dCjVJM6D3+55ydqG31aim9mINUQkHed37UDN/68l9jpbYgEosnptZCoUE8mNZJTzy1YAz/jgVS+GtmpJiFG9hyu+06cRgox9WdaqqUBzUCCTAeOVKFZI7EK8/YnGQ3U72N/PMp3y/TQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199015)(83380400001)(186003)(1076003)(2906002)(316002)(38100700002)(9686003)(41300700001)(86362001)(54906003)(6916009)(33716001)(4326008)(44832011)(478600001)(122000001)(6512007)(6506007)(66556008)(26005)(38070700005)(66476007)(8936002)(5660300002)(64756008)(66446008)(76116006)(7416002)(8676002)(71200400001)(66946007)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B+Onru/PwlfHLKDHY1vJtc3TaiJSGQLsoxdrN+MNcadmWEaM82gWVDFcmX/5?=
 =?us-ascii?Q?D2OoITJ4G3HD/O+jQtlA9ZRnhzSI4W3P7rkI0Dmz/6TE12obJWrYJJ66rIA7?=
 =?us-ascii?Q?cNnu/U+9wYSVoDiGNzGvBB8y1NdTUKfnvgYfF6GHA8+m6t2Y19gPINef/E2b?=
 =?us-ascii?Q?qOQNc61awIyRsXpLx96C5aWCto+7EdCqVbdrbXdm7nWeCxWdzwt70pmp8po0?=
 =?us-ascii?Q?khyWeEIBZP4NCRy2UT0JUSyQY1Q9ZCnCKuWmfcA0QbrESGPWu0NZU/U9IG4f?=
 =?us-ascii?Q?y135abCxykoLLt0m4hmdz36G823uE0R+JLC5PVuJAkR1P2AxaNp6ObrQcK2M?=
 =?us-ascii?Q?tlmFH2nkxZguxcH5XIrxs5qeM852n4AA3MCvCIkyKIB94fjlyKPoI1+2SRLg?=
 =?us-ascii?Q?R1D/KRViwmLuTIcl4PEWp9+9lBSZL5RZ8YV2dWsyZRRye3ncGFYEM/cmysQK?=
 =?us-ascii?Q?O5YwkUXNJ+Nd3u84wukuKNSajYV7mEUYWaaZGrpTNuXfQ8sy+ox9sAB/U8/+?=
 =?us-ascii?Q?Oq5jqrX1A0NZYgVMnf7GwiYI4BlUQpMNwQ3u82bx0c6Gl25CuxGxutmsaS3M?=
 =?us-ascii?Q?pmjxuhOaFOv/WzmkhCWnIWBoHYH1gPEXRLo/9fvR9HpDCgP8sZB1VvSBvMto?=
 =?us-ascii?Q?qRPr9sA3p8Uhke2FFOmlLroz5AxcBORN71Wyci4MdrACL0yJ+eqdGhvQv4FJ?=
 =?us-ascii?Q?tLfKbpsRWNXCmIWKrIGCSLiBfxeb+kSDfewBNyV/MeQ2rgn6bECOzUDlMo9J?=
 =?us-ascii?Q?gLZz47v1fd8UgA3+1iKnYyuUXEzpQbDxW0aSnSglRgl+ysRQ2hhBMaqv+nIf?=
 =?us-ascii?Q?V2uMEG2yNe2IX62MrdrgPrP9B2r32c3bIqciGtpRoL5imtncYlkeNbgc3T0S?=
 =?us-ascii?Q?sAwZXDXeOBN79WiTRLVOwGfPTba+dqy9x8SL2eryzR689w0G320N7byq0nfi?=
 =?us-ascii?Q?S73MwuCLtUJOpgNNOIghUhpi/r1utVz62H3T3jsCil11re9z1Vs6Zovo1bTS?=
 =?us-ascii?Q?LekQ1CTUl+60iEjF31m8aN/jgwImaP0hRcLASyRdF89LWJeZg2pE/b6iJFtO?=
 =?us-ascii?Q?mdzGHNwYe0Cg5m7ONhuX/HJv9s5bTPfdYwoL4c5NIbxXpovCOzOZz3FkBNHV?=
 =?us-ascii?Q?sS2cRAUktgPXireYQcd2bnMCXDEJaQSsLzq+l0soQLWTUDcTE0knoyClSsoU?=
 =?us-ascii?Q?o0oCRGdOcxXbDJB0RmtJsTu4sfod8Q3Muh7Osp9BeCfZNayBxkcFFVOe6S8T?=
 =?us-ascii?Q?/x7zdewMLemhefcH8xsHLMLSZiGhWrTjEeE4e6V8q8BtNrohDS6EnK6q+ivP?=
 =?us-ascii?Q?38QFPz7s6wONf8oidJmF4rpuuBTnJgjcV0UvaZ/wXYxPKQhyqywf+eVkUV1v?=
 =?us-ascii?Q?DDeDTt9YEbqbV37L0qhK2LML3z0PVLrrjoLOO4+jiGFDHZGYUw6CW4/R4lNn?=
 =?us-ascii?Q?c6TvSghFjvjpzzpe30XBrcqGq22py4fsaZ24DKMCcUgiiDFs/mx/+jyt4DlN?=
 =?us-ascii?Q?8jGraEZ3krIIihyAeiphM/h0Nk7vEIAdF6BplSbDRW8t38GuvrbiUbmNRruA?=
 =?us-ascii?Q?lb824VYgNcz+TWUUoZ3BbEbNCNM+WLQuX/+wADLYVS+sHGnbW8H1wM8aerrM?=
 =?us-ascii?Q?wA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C127843DFBD92141A638F6390BA1EDC8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21d747e3-91bf-4d0f-db48-08dab370df7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 14:30:59.3532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MEY6m0MrPTQo/8da2KR+9tQ0Fci1D7MCXmIIlvFrKSzkU5UDAbujLrHMPU+7nCo+9O9wrfUQGrWXZJtPH+tN5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8136
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 02:45:52PM +0200, Maxime Chevallier wrote:
> +  interrupts:
> +    minItems: 2
> +    maxItems: 32
> +    description: One interrupt per tx and rx queue, with up to 16 queues=
.

What does the binding require in terms of ordering, exactly? Whose
interrupt is the 7th one (GIC_SPI 71 in your example)? RX/TX of which
queue?

> +
> +  clocks:
> +    maxItems: 1
> +
> +  resets:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - resets
> +  - phy-mode
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/qcom,gcc-ipq4019.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    gmac: ethernet@c080000 {
> +        compatible =3D "qcom,ipq4019-ess-edma";
> +        reg =3D <0xc080000 0x8000>;
> +        resets =3D <&gcc ESS_RESET>;
> +        clocks =3D <&gcc GCC_ESS_CLK>;
> +        interrupts =3D <GIC_SPI  65 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  66 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  67 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  68 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  69 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  70 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  71 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  72 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  73 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  74 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  75 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  76 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  77 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  78 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  79 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI  80 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 240 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 241 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 242 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 243 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 244 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 245 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 246 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 247 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 248 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 249 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 250 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 251 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 252 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 253 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 254 IRQ_TYPE_EDGE_RISING>,
> +                     <GIC_SPI 255 IRQ_TYPE_EDGE_RISING>;
> +
> +        phy-mode =3D "internal";

I think empty lines are typically added between properties and nodes
(and between nodes on the same hierarchy), rather than between 2
properties.

> +        fixed-link {
> +            speed =3D <1000>;
> +            full-duplex;
> +            pause;
> +            asym-pause;

Any particular reason for "asym-pause"? Looking at the comment above
linkmode_resolve_pause(), I don't think it makes any difference to the
flow control resolution (link partner AsmDir is "don't care" when we
have MAC_SYM_PAUSE in mac_capabilities and the "fixed-link" node -
effectively the link partner - also has "pause").

> +        };
> +    };
> +
> +...
> --=20
> 2.37.3
>=
