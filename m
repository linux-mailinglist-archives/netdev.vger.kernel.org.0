Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B4F4D622C
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 14:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348810AbiCKNOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 08:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239953AbiCKNOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 08:14:32 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70051.outbound.protection.outlook.com [40.107.7.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78967184B69;
        Fri, 11 Mar 2022 05:13:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyS1VI/wfMvR1jR5Y9s5Z6mqwhtrgGOob1RW5gMgvN0yBE7rnY0WDFqB+zFyfOkE7FoxCaAqtzUdkHyV/TdcYo9pF49OHvIUgstuNYS/A2FbpPvLeIuTk6B2YDe/+Xu9NYG7rCEm8sKOm5Jp862afOn1UFPDTKSpOHm66FHZ9Sl2ypsUMvwJHAXcMXuWmt8sRXesFqJINaKa63Bfw2gRem3IgXFDGdAJkn4l8mbbrRQWfITbVuC1O0ASLcwxbfp9yLmDj5MD5v/PyBOkgelpEnfrCcMg6g7UXCNdrAwWWgn95PT66HDW6oWpsPfqfAmR78XPAcQhFPi6WkL9f4WaYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0sP9XBO4IAU6pCWD4ocaOc19/JnZ01PTIAnwae67ex0=;
 b=gqXmJHvmeGR6OS47h77hkFMKAA8osFXvRttvJ+m03Vm+yXNrUcg6LtQMQrMtraiErwg0VfGszqP9tAvXUJxhi5lpPhukNEfzDw1VI6uBrI0BtcvP3HPLfuOCG3zmrCLOhGWt1swq3apHNALOowmfQo28MfF61TrzrB3R+QrCbu7E178dFG4Xvde2SP6D6XQFbWkQO118JyFC78TZqT3AuRxVQmncm0kbz4eVFca71qWo/FezQLQL5OIVLSUgtauWuZjmwy2MtSBxbC1LxX7hXdpZ2qkncUL59VHmPL9ahwe5E6ogk9RMhBDL725d6yJEh0x6HZv8ziHte4UaTGfJtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0sP9XBO4IAU6pCWD4ocaOc19/JnZ01PTIAnwae67ex0=;
 b=h12X5xEw/GQMN+65Bm6z3QT+t4h4GIqvbBSC3xaUgpV4EWNF7RYAJr4378KHJ/l8O5SnqcCgBBgu3wtge7BA2GrKg9+JptVnldb/ucb/AQRaBxamKQn/joifn4aE/h5CIM0rcMsmqlp8Z6EwQd1octtngeHQWin4Lt9CuHVA9gQ=
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR04MB5456.eurprd04.prod.outlook.com (2603:10a6:803:cf::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 13:13:25 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 13:13:25 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Hongxing Zhu <hongxing.zhu@nxp.com>
Subject: Re: [PATCH net-next v4 2/8] dt-bindings: phy: add the "fsl,lynx-28g"
 compatible
Thread-Topic: [PATCH net-next v4 2/8] dt-bindings: phy: add the "fsl,lynx-28g"
 compatible
Thread-Index: AQHYNUc5a/gMz68mFkSKe8yZSjQcZ6y6J9CAgAABNAA=
Date:   Fri, 11 Mar 2022 13:13:25 +0000
Message-ID: <20220311131324.uzayrpnp2mifox23@skbuf>
References: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
 <20220311125437.3854483-3-ioana.ciornei@nxp.com>
 <f782bf45-3a69-18b4-de0b-f53669aec546@canonical.com>
In-Reply-To: <f782bf45-3a69-18b4-de0b-f53669aec546@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd549c6b-fd4b-4ca3-b009-08da0360ecec
x-ms-traffictypediagnostic: VI1PR04MB5456:EE_
x-microsoft-antispam-prvs: <VI1PR04MB5456FB1CFEAA578EEA7F3B91E00C9@VI1PR04MB5456.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9GJJWRQavfteZTMPVFl2FgbZSGjQGLb6qwYLhCR9tc3Y1DHOMG5hl2LGLIIS5fKGDFAPmlbs6+ae/E5u/rm7R9nj3QZBgm+H2M61L1DfgK4xYsKSAyCn9nJ1yugnjtrhdw7od+nxbCg0AnZbtXJPHVz0LpKfpCVfm8lAdoodiOfw6ZOqG1UX5JU2T3MYzHp/TwpmDzugv/oIihMFb+mlVU7aWwHDbZ1+8rIH/sDaVKIx6wmlelTlFmWCk9EGpAq3qaGoTl+9UZe1Ctc455LQGe/HolYKnISjVVBmPo5YMy2TrwVzGZmsKdX9YKks1WcorK2F2Ps08HW+Z+q5TAN52sNN+JIWpj3wHOEEuHRxWZJbzT14vFYnSVaJLDgQyX6SZnU0VqKTfo5pYGtbOixJiABfvMGznao7rlBOXtgPBC/jXneigsrtW+MYhCcFLIKzs+Gu4Co/RxMbCfCF/ZWEQfMvi/P/CfFHo3nwEUMKz82JNJ827jXpRqZkXjonUaQElmqpukRsN+JyEyy0NyS3bsQAhr+b0tRPxM2spV6tGlbV9S7GdO4+xfpd8IWpELZF4ZKl1EXmFKRm4YT8DoqtqWbT5LL3nHQtRe31JSI2MkjX4NoYFCpexd6tcBObiuJhJ5rM1DLMzPcCPQoq68B0w21OxLxsz3DMHsHS3sMVBNGDBUnftexjY/QrZzR9oCuhhnkCK9fQgs8KbBmpySSc/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6506007)(1076003)(186003)(53546011)(5660300002)(4744005)(26005)(8936002)(6486002)(7416002)(2906002)(83380400001)(9686003)(33716001)(6512007)(54906003)(71200400001)(38100700002)(38070700005)(6916009)(44832011)(122000001)(66946007)(76116006)(66476007)(4326008)(8676002)(66556008)(64756008)(66446008)(91956017)(508600001)(86362001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OeFCrJX472ZemQ9dlBIxRDZ2uI0H1cBZnscC7Bcfupxgl0YG+wl5iwoMV9OB?=
 =?us-ascii?Q?AtaL84bBTofT51Mgril7t4AS2BZeDvRd53oUER+7gRY+CRidRtt9f64zuWI2?=
 =?us-ascii?Q?q4tPcnkHrZYWQEYHFymO3Ovf0GQAdLiiZAF3GAgWl9HcKoSgYV1/BYMe0ySt?=
 =?us-ascii?Q?IsVMxNmVEHWXRJNnq3Sm5g4RYS6OtT1BmhILFpZMTUPmbDXhPCDAKMUeS8E9?=
 =?us-ascii?Q?hcJc8Isy2nZsfJZtzJwu/B8hj6biNcj09B91cQO650mDK0+l/YffpSNKGimt?=
 =?us-ascii?Q?KbDtYHAVe0nLrTuX4WKMht4SW6hJWiPIoBlYdqsG1C8AmBuePJwXqnEYxsur?=
 =?us-ascii?Q?HD4lA7lfnbpd433c/vigCXk+jAhJYg113UuY0XVbg8y1WZGlXfz7Iqdnz/mL?=
 =?us-ascii?Q?CgGhBh643DS+CgUz1phMJ5qSCWtTlSNiHUwVpIZXPyp9mh17MUDyzTiipDz8?=
 =?us-ascii?Q?RueLhJzZYdYKb9aMBtLzeVaYVPZ/niCARTetOGUNCxLXFpxpv6hgguKw7QQl?=
 =?us-ascii?Q?w6N6rCIu3MKwenXW1lgYlQICYbMELzUn9ASgH9ZXCtKm0j2faMXi3CF8A3Pe?=
 =?us-ascii?Q?J6+6eJXqjJrlT4kRFGv4v/YJHkxCP/cDVzJrcmPZYwQAWErUFLDIc5FFNNRg?=
 =?us-ascii?Q?Shpy/q/jBuztcklZAFkBIRgNmEagTiG1yyhiOYuReo70E8CDbwRBQUDCqXj9?=
 =?us-ascii?Q?N5nRaInGaCKOEvtJF2ELL8SnmljIJ9EIrFqssxTxPo75/EmPBlc+Rtuv3Nl4?=
 =?us-ascii?Q?9ZNWuMt/pMAus0De0Inm1Z3D7QBegxdUbGaHdD1XYmkN2m7foFETdgjMTv0H?=
 =?us-ascii?Q?eqZt4vtuhUKkmYE3+xWfcRnxyjRvqEQQezUu80F5+yuGPO3m09JnL4YL9ERL?=
 =?us-ascii?Q?ZA/W8rvb8ffjav9z3War3aK5AM37ZuJ4nkjsure1KEP6UN7bCCXGxNHjVJmy?=
 =?us-ascii?Q?GNfq786VmHOQ01FTcougfygEUfRO4FJfhwymHmB9mltNBXxHpx0fRT1tIpT9?=
 =?us-ascii?Q?e6Q2sVe2PqU8HzCDC5Mpm2Aj1XFReaAzW2vUzQcrd3+9WJUhHIT0SJs1RIY5?=
 =?us-ascii?Q?wItrNpTm7DsiDn1N53bQtZ4SMz7eHfXfLYZ2CW8F8Ef0oSF4a4/2/d7ZHizB?=
 =?us-ascii?Q?vB5xblYPvECtwjOCCl87KKF9Yq+IGpr7cMbo7bZ23RC3HnNqiaihrDgJ3+GD?=
 =?us-ascii?Q?ksUCVscMDRnb4rZn1PpMRKg/b8XO+f7Zjn1vFmJM1jDsjDBSOTAe2NqMuhqO?=
 =?us-ascii?Q?DRRE2LZ2de8wR/6ieLwkGHI+WQXTr0+JdEaCxGKEBHujc0Qe/4Qnf+wjIydu?=
 =?us-ascii?Q?IUStoMfsELsPHUjaQbshosL2D5VZjdIuq8y+32K943K39zMF2RB7mWUfXysQ?=
 =?us-ascii?Q?w38a2Lq/Ka2kBhX1k/X9ami0jmxjOqbXzpTc/VdokwRSvThJ7ejI1tdtfx9R?=
 =?us-ascii?Q?2nISeVSebJX/SiyM8BrPwVOF6LoBnPnnD8PdHX+7t86tlSzV73U/FQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2C49984C5E6D2B4498DE2D4D926C1989@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd549c6b-fd4b-4ca3-b009-08da0360ecec
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2022 13:13:25.2087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TwKNurfWLzMhBNRyZdsC6gs+sN7iR5uS7HRoKLDu7t6Y4ruv6x+CQN9VYtYqVTjp0dyGWPLNWvn62mosJh3pYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5456
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 02:09:05PM +0100, Krzysztof Kozlowski wrote:
> On 11/03/2022 13:54, Ioana Ciornei wrote:
> > +examples:
> > +  - |
> > +    soc {
> > +      #address-cells =3D <2>;
> > +      #size-cells =3D <2>;
> > +      serdes_1: serdes_phy@1ea0000 {
>=20
> Comment from v3 still unresolved. Rest looks good.

Uhhh, I forgot to change the name. Sorry.

Do you have in plan to look at any other patch? I am asking just so I
know when to send a v4.

Thanks,
Ioana=
