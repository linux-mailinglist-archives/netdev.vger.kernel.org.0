Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A918B6236D7
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 23:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbiKIWz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 17:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiKIWzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 17:55:25 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80073.outbound.protection.outlook.com [40.107.8.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4E525C43;
        Wed,  9 Nov 2022 14:55:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6K0kTxNCVvvEclnWzQvxBXXNW7PjYdN6Ed+pPEzxcfet1HoHzEVwP0AlmEa9Sjzjg21hKwr+kKnW5C6+4EoVrZZOzZEMeQmG5KA5ZerZDx3jQkgkXmbjvf4jQZob7rO8q60uT1zCHoNemekwESN0Nur1iLdr94oJ/FaczNu7x4ILQ+2d27udvbH9rc8cYmmOoR1lMxFPAbQGVQg7R+HoPQlHnyn/lOYRAOpLl7tfzEcaSFMO5wqbG/c0jY1ZJsDdKnb3e7dDyAWfNTsPnbo6YbQ2jWmcgAvPsQwldMHuHOoNpxDuNK8SMVBOPLt4epLaG0Z1diLvMBcmPs23sQZDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gg17j2DUhKCk7TjXWMtdHx8YXiYYpu0yMxi8nRfLLb8=;
 b=XSUhff7G57vbMJ9/IcT58VbrfMZAZ15+MIeSg7kMnNSa0S7wPULU+oUxdhkJkcFdmWJGJunS3iDa7TVTHZg+yw8Wc16SLCqo0r9dRmcmonWpAfJYboGcwNA0OWUdlrDZZKcqVcZdKnMIccdzsgLharhEFEPbA0t6eZyOo2prwhW0GTInbluvkt8D5pJx29rVE5Ba9+HbShFOBKa2ZUFPrsXOmXgqg19f9qj+0HuCNwxxCCxphLr1Vi0vtmkbGDRfPsbtIOuPj40ADU6zLn1l1MoVzY5HzPitN8aG5Pvx1JI8EFZNWTveP6smZAqEeN847Q+ANQJ+34MNsWOEX3RwvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gg17j2DUhKCk7TjXWMtdHx8YXiYYpu0yMxi8nRfLLb8=;
 b=P/cqaQRGWlMSeEXHSjqFWKZCu8XT15+KeUH6+EkoebbY84hZbccGKSuuYlClqoHaHlvES3Ia0B/3NhGsY3DIZ+0wMVSF1UFTlkXuuL5x2XorqQVD8nRc74rL4V5AguUhg/IwsGzaLjWPj+klTkbgXqe2k4maVYeGc+ibYgSLsF8=
Received: from AM9PR04MB8506.eurprd04.prod.outlook.com (2603:10a6:20b:431::16)
 by AS8PR04MB7861.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Wed, 9 Nov
 2022 22:55:19 +0000
Received: from AM9PR04MB8506.eurprd04.prod.outlook.com
 ([fe80::5ff6:2440:a56:6b45]) by AM9PR04MB8506.eurprd04.prod.outlook.com
 ([fe80::5ff6:2440:a56:6b45%5]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 22:55:19 +0000
From:   Jan Petrous <jan.petrous@nxp.com>
To:     =?iso-8859-1?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Rob Herring <robh@kernel.org>, Chester Lin <clin@suse.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-S32 <S32@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Matthias Brugger <mbrugger@suse.com>
Subject: RE: [EXT] Re: [PATCH 2/5] dt-bindings: net: add schema for NXP S32CC
 dwmac glue driver
Thread-Topic: [EXT] Re: [PATCH 2/5] dt-bindings: net: add schema for NXP S32CC
 dwmac glue driver
Thread-Index: AQHY7tOAA/zZjStEYkyi6JcYkhk32q4r3zqAgAtUk2A=
Date:   Wed, 9 Nov 2022 22:55:19 +0000
Message-ID: <AM9PR04MB85064E7C90938308B9C69015E23E9@AM9PR04MB8506.eurprd04.prod.outlook.com>
References: <20221031101052.14956-1-clin@suse.com>
 <20221031101052.14956-3-clin@suse.com>
 <20221102155515.GA3959603-robh@kernel.org>
 <2a7ebef4-77cc-1c26-ec6d-86db5ee5a94b@suse.de>
In-Reply-To: <2a7ebef4-77cc-1c26-ec6d-86db5ee5a94b@suse.de>
Accept-Language: cs-CZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8506:EE_|AS8PR04MB7861:EE_
x-ms-office365-filtering-correlation-id: 0291badb-e20f-4649-c63d-08dac2a579f7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BfaOem9HgP6jQUZjsunPEWdPIWQgscTWXGmx3ai4be+yfbSsmYt1hz9U3IvS9fkkgdwyaE3XmB5jXbCCDTfLs7EYpOgtIK0unCA0TrXjXvaCS/EInBAwlZ05TO3U37j1RjzFnAe7dAIit4CTX0Rocfg8DcIWABfzfxc3NQNNxNvXaa5/R+fiAs1ATNaI2oARJ2jltEwshoJ32zvy4idrnlQnjczJx96fn3cUTWORyhDojP62K644ZOS61GvDlSlk8qmF/aP7Hi1NoW6NU2N2AZgOLKeMOWrEKdcgxy6vS/3GdIRQv+w3KI3btl7zVF0cSPN9IrkXQ1wGoHBh6OUQG2XeaNO/waKukLEtlZI6Ber1SeC/8MBVbeEOfWoGEsinRtdJPr8YDlZd5K6OLoBNxZUgVFBvvfwGaumy4yVRUYB0jKOttEsArqbQW2sKMgTwdiZUM7cV2wEKHfpBMcF9B/jfbRLNhtvDLY9GLkNDpDXihldDVWTkUv7sKQXyNhkXdpMVazAAPO/6buXTfaf7ovATQmB7E3/sCGWk3i/nQkuzKQjNy7ysAxrbuksz8u+2cWD+zzDNB9JVAGuYJDANW/Kuhbo+o/r+uVl2IkITd+3Ixb2WokOJe418IJb7ICenA1BctanaE3nWbsHKLjAcS8xkahlH5nLEukwymrflp2t2XH0sHuYY5s6QqhnUHRKwGqyQ9KCjpSy0XIcaYkuoCBzP3lzqXCVxcyihZR5SJlNRu/0XbIZCESfbC1eHf6vjopKZUC3PowdXtQArvygD6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8506.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199015)(8936002)(41300700001)(7416002)(38100700002)(86362001)(186003)(2906002)(55016003)(44832011)(122000001)(83380400001)(38070700005)(33656002)(52536014)(9686003)(66446008)(66476007)(66556008)(71200400001)(64756008)(8676002)(26005)(110136005)(316002)(54906003)(53546011)(76116006)(7696005)(5660300002)(66946007)(478600001)(4326008)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?7qe1/37toW11HN9O97BehGplHvSH/QyMIj7B6XI1ynnJwBDWizf1UbtqeX?=
 =?iso-8859-1?Q?l42Nfyxo87vt0AK647C4Tv+XLflAfw/f8yrn516aIam2Dx7lzGFYuaN1P4?=
 =?iso-8859-1?Q?DOtm407zgSTdhR/tVY24Nia0s28vaj6j4wq8SRoqjrDBL6h2LcC97DaCTL?=
 =?iso-8859-1?Q?KOXfeKhcXFviXGWLN7Wuiu0wfwLhvR3EtNzsxs05YsnoQojCwuXW4rg19g?=
 =?iso-8859-1?Q?36yLoOeyRbzNDPXjfRtv2Rg2WTTtvyzkKqWjZGyWKwNodtyb5eMSc3AAt6?=
 =?iso-8859-1?Q?SLWwxdIvFpF1/KYiiaUq/Tg4zf7v8K8++hUPBUyK3zvDHqG5xUbKwpk3zv?=
 =?iso-8859-1?Q?Jdo0Oo0KnRr4AhAaMkNeh9jMHoHuDpjhV/pnCdUS/mJbYdppQwsS3roptz?=
 =?iso-8859-1?Q?9OTqK8+smePFxXPkYf4LKuOv8qvyCbDFGmMvI3yNGXHEg5pUMjWmwJKp2h?=
 =?iso-8859-1?Q?wno/h5k0/aIGuueQnb0h5sFFh9NN0Q3+6Zb8iyXCJ4QeA1NvJtqWAekedB?=
 =?iso-8859-1?Q?vr8rnV3wSz0Jur5Cy1Elsv7H2k2JhXGV3iFp5k/N5O3p32I3AXw7jFfBdm?=
 =?iso-8859-1?Q?IjpAJ8D+xUVNn8FzXl4SlPgMb81VS6YZX+Ngxt7jZgvumhpezjxqrZoXyi?=
 =?iso-8859-1?Q?mOQGgKktn991VM939wAt4Xq9Z5dRhdBT/+8eg+KXMD8Oq/53VNCteLQcHG?=
 =?iso-8859-1?Q?iS0fFEFauAPkB5WZLMq7+J+ihjDqjVsJwd1pjrEjaY7ye4RRGa7eZgHYsr?=
 =?iso-8859-1?Q?zTw2vlZdq5FxE7ClEn3OHs/cqXMSYbuesgnP0wGNqkftcVgruHGrFB1d5i?=
 =?iso-8859-1?Q?7+yU2VWdRghno/TsbDEaLJSPM21vnnXmx5g07PUwKzBENgZF2cizgZINDv?=
 =?iso-8859-1?Q?FHC2MyuMPl80/qQiZAjmI1u8Y2NY7MhFQvAFrgG3Q8ttgat1Ognwf+T8lu?=
 =?iso-8859-1?Q?T6JzjtAfsr8nnQYlLUiLpWVGmtC0zn97vKTt2dITngmfbzQBV/xaY8H8Sq?=
 =?iso-8859-1?Q?s0AHupWQA9qj0j/vcC/CxOUb0AdpPSafXQccU384Tezzzc7cB6M+OjcfH1?=
 =?iso-8859-1?Q?3qHvDKuRhJjeqea1lWc9a/jJUv6fza+Nqxjlxoxdoq26a83J8iV/bqTNoj?=
 =?iso-8859-1?Q?PHcXPhINhKn2t42uMYCiKJwC0r9zynZmvhABWqsIYft40P049F1EPVVBAT?=
 =?iso-8859-1?Q?N8w42uUINbpbEUYew7homy96Hbj3mnCAimiakMo3mNYTS+0+mAlUYNjHmM?=
 =?iso-8859-1?Q?1w9pHU8Kt4N52RAOeAmJ+VuOzNMPP8NApe2rqQrvUVETWrfZkmCjEO96pu?=
 =?iso-8859-1?Q?pp0OMlPhvo6xFFkIMFitCbXrvyj3WcAkNxq4ndfEk71jXe/jmUdheC68Ou?=
 =?iso-8859-1?Q?cXcgGVvE6qaKq5z3CGUIlSl8bvbF3Cr6CRVuIO5+V9E51rMuFTEIVhLXiQ?=
 =?iso-8859-1?Q?9/Wyrrjgznm13lg12kPiZOa5NOfGQhlCz6DdWNuZjpSEHluNCQ3B1wZ7mE?=
 =?iso-8859-1?Q?WfX6YfSpyYBZzagCIgk1cRucN6VL48ERn66RldC4W1zQ7DRWvHJrIA4wgv?=
 =?iso-8859-1?Q?0RM4RYhWWPZyr9q6PbFA1ENnu71sX+9FPKoBkruhnDzZ7GJIqZHCD81akL?=
 =?iso-8859-1?Q?9qL9xnpdRJLNja3ScvaeMCzHyiOAQJrwxi?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8506.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0291badb-e20f-4649-c63d-08dac2a579f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 22:55:19.7863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nEXqPkyGflsAO4XDjM+PpguY0p/YeW59Gm/DeLPDQYx9eSf9ohB2fMBw69JLgLvji59Lg7hW3C1RcuAGHAla1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7861
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andreas,

> Hi Rob,
>=20
> On 02.11.22 16:55, Rob Herring wrote:
> > On Mon, Oct 31, 2022 at 06:10:49PM +0800, Chester Lin wrote:
> >> Add the DT schema for the DWMAC Ethernet controller on NXP S32
> Common
> >> Chassis.
> >>
> >> Signed-off-by: Jan Petrous <jan.petrous@nxp.com>
> >> Signed-off-by: Chester Lin <clin@suse.com>
> >> ---
> >>   .../bindings/net/nxp,s32cc-dwmac.yaml         | 145 ++++++++++++++++=
++
> >>   1 file changed, 145 insertions(+)
> >>   create mode 100644 Documentation/devicetree/bindings/net/nxp,s32cc-
> dwmac.yaml
> >>
> >> diff --git a/Documentation/devicetree/bindings/net/nxp,s32cc-
> dwmac.yaml b/Documentation/devicetree/bindings/net/nxp,s32cc-
> dwmac.yaml
> >> new file mode 100644
> >> index 000000000000..f6b8486f9d42
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> >> @@ -0,0 +1,145 @@
> >> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> >> +# Copyright 2021-2022 NXP
> >> +%YAML 1.2
> >> +---
> >> +$id:
[...]
> >> +title: NXP S32CC DWMAC Ethernet controller
> >> +
> >> +maintainers:
> >> +  - Jan Petrous <jan.petrous@nxp.com>
> >> +  - Chester Lin <clin@suse.com>
> [...]
> >> +properties:
> >> +  compatible:
> >> +    contains:
> >
> > Drop 'contains'.
> >
> >> +      enum:
> >> +        - nxp,s32cc-dwmac
>=20
> In the past you were adamant that we use concrete SoC-specific strings.
> Here that would mean s32g2 or s32g274 instead of s32cc (which aims to
> share with S32G3 IIUC).
>=20
> [...]
> >> +  clocks:
> >> +    items:
> >> +      - description: Main GMAC clock
> >> +      - description: Peripheral registers clock
> >> +      - description: Transmit SGMII clock
> >> +      - description: Transmit RGMII clock
> >> +      - description: Transmit RMII clock
> >> +      - description: Transmit MII clock
> >> +      - description: Receive SGMII clock
> >> +      - description: Receive RGMII clock
> >> +      - description: Receive RMII clock
> >> +      - description: Receive MII clock
> >> +      - description:
> >> +          PTP reference clock. This clock is used for programming the
> >> +          Timestamp Addend Register. If not passed then the system
> >> +          clock will be used.
> >
> > If optional, then you need 'minItems'.
> [snip]
>=20
> Do we have any precedence of bindings with *MII clocks like these?
>=20
> AFAIU the reason there are so many here is that there are in fact
> physically just five, but different parent clock configurations that
> SCMI does not currently expose to Linux. Thus I was raising that we may

Correct. The different clock names represent different configs of the same
clocks.

> want to extend the SCMI protocol with some SET_PARENT operation that
> could allow us to use less input clocks here, but obviously such a
> standardization process will take time...
>=20
> What are your thoughts on how to best handle this here?
>=20
> Not clear to me has been whether the PHY mode can be switched at runtime
> (like DPAA2 on Layerscape allows for SFPs) or whether this is fixed by
> board design. If the latter, the two out of six SCMI IDs could get
> selected in TF-A, to have only physical clocks here in the binding.

The eval board allows to use different PHYs/switches connected by RGMII
or SGMII to the GMAC. Some combinations require change of board's
hw switches, but not all of them. Anyway, until we get a board with SFP,
the connection type can be treated as fixed (declared in DT).=20

/Jan

--
NXP Czechia, AP Ethernet

