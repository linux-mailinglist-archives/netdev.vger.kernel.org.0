Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC5F5E9949
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 08:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiIZGKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 02:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiIZGKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 02:10:30 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2122.outbound.protection.outlook.com [40.107.113.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C761827B1F;
        Sun, 25 Sep 2022 23:10:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVEOUFsHvLCTro0KkSg9pRD9OIh8uYTbwtAolSddQ7OZ28uUpBiW9P2YXpYxVF3qR6e4XxOLV8GZ4rEZa6n0vcF1117krETjwiyiycsAiFRxGXjnYd4rdcPRLBHygh7MFXeoPeUeVF6dHZdnTiGwlNLOpZ5tk3XghSIxtd1URRtUg2De0GZA3wTMdn386EzkemgzIC4MaP7eKdGwi4AULCZAe0JM1hL2iE6g/FiKK9qoXS8Ko9p9dyhxlMiMZAhvAHtbQmxh0C+rKuU6lOy95Q/dRxvKb7Pc3a12QDHQ/AKCZ4T0EkQ6ImkbhomSOsl615lWx+m6XLy0SluWS4We/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B7oXsLhONk+1hXvapN9zxFsrIZY0nUNfaRD1KbmY5Uk=;
 b=X/nJnq6q0yWD31Gg1CA4C5LdnVzpPwGo7msaJDuGJDKu2EiZT+SRf4Deere5rboI/LPeQB1v6gUAliJQ5gvcmBD+iPcsuFOpURkjIXhL4ixhi1MkBG3N30snh3/lqv+IoDW6bXeGe3Koa5Z9ha3mr5pXEmzAU4S1y/5zIxsIsJm01qc72sOXu20+IioqkD8i0kBE7tednYq1/pM1RuSbD2k2NegcHV1cY9eRg7P0IP6ZUPC5zAoatJM1YFD06g2m85m2PneCx+y1XygSo+ZHX7G+OXNbsgS9ZPNq6iCqzHdkmNSee7IYIKRXxeUM8V/QhStKpHJcMKlqBQU2mbmk2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7oXsLhONk+1hXvapN9zxFsrIZY0nUNfaRD1KbmY5Uk=;
 b=hmmrDuF8rKPEy+cemwqwHUF/DjLH1DSG3ICCv+s32/YB4dHz6txmolxuJYVgcH34Q5N0TGUBL7nnFjdmT/2xuv0F5c7xIyjVUNRXwgBfevz85ntOfY+xRZ5fuNJaa1gw3bAlam5C9xp4r8A5m0SLqoEQcPew48KPlhygK8E4eMg=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS3PR01MB5591.jpnprd01.prod.outlook.com
 (2603:1096:604:b5::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 06:10:25 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 06:10:25 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2 4/8] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Thread-Topic: [PATCH v2 4/8] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Thread-Index: AQHYzZbyqNqCKbNV30+Ykc0QZw/71q3rESYAgAYuSTA=
Date:   Mon, 26 Sep 2022 06:10:25 +0000
Message-ID: <TYBPR01MB5341514CD57AB080454749F2D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921084745.3355107-5-yoshihiro.shimoda.uh@renesas.com>
 <1aebd827-3ff4-8d13-ca85-acf4d3a82592@linaro.org>
In-Reply-To: <1aebd827-3ff4-8d13-ca85-acf4d3a82592@linaro.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS3PR01MB5591:EE_
x-ms-office365-filtering-correlation-id: e764f207-9bfb-4fc6-b2eb-08da9f85cd8f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o89/qJbynsGADLBc8AbM3ndtSl9u5JPAbegN8zEfmRw8U5pWLp0ar09YMR9a2uRzF7N73EdrCFPpv8n/IzEkADdV1YXwwRvbl88KgWtLirsiEI5qEvjRS+Xowpk35yk2MyvhrXezCBpe8/hzhUd3v7U/n/WHysT/P5etmjINAl9ZAMSRa4lUyuILGR6xiG2So2anec92Jw7/KGUi/KVdHxTc1EwowphkjM4fEfbZbCuxavVh8Xb7nFEtCW49gLAKzagsKB3U7u7lua8ETUchdsaZEzC/Z6WFJNP33Qkxv2zsov8kisE4JlUQufsYEhtub2BxPDr/E3L+XJ7BV5ZjGAPRq8BZ+uLD4pP3tqRdC4E5ZoAcVhvmND4fnsoOU9sIwayN8f5dJw9hRv7BcUmpiC60G7uuXdn/IzIE3jYLxkoqPSwq3iMALh9Whzc5Q5N9Lp/kKSm5lOEPBs4HYxWjhPO72BYQDGbJj6RZaG2hYhosX0gP4RCpLpeAfifAh59lr3eAvFUziunLhQJrbV2GzYbAlMnCnbtsgRdK8jA0PTKnOEb5UfrJr6mRM1PVF373IMaYUf860z0vVHPQm/MJqi+6ncR4uAo6pBZBJLgdwrZHNSS9wqSgV92P41/s2ViTN2s7Y1dbFD2NYGinVq9upoBaqisQctRzJlHT4UyVL/qCeetS9GxjtlYhxT9NRgF65iY+pINymLGSw8gs3bD8HPEXcxYf2fX0xe4EFOBlmWJplxllE2voAViKbSByA4A/pC3XXOehQX/d1D7RZqjZTC8Fj2TziN03/JuirbHn6IARSyNtSQOJd5zHYC9dawWO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(451199015)(66946007)(7416002)(64756008)(66446008)(66556008)(66476007)(8936002)(52536014)(5660300002)(33656002)(921005)(122000001)(2906002)(38100700002)(86362001)(38070700005)(55016003)(186003)(6506007)(53546011)(478600001)(41300700001)(71200400001)(9686003)(83380400001)(8676002)(4326008)(76116006)(54906003)(316002)(966005)(110136005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O3KWOtgsYxKUqsXa5mb6IVnBmKafoDmezkFNk0x41QhcgZRJiiI761sNVJpU?=
 =?us-ascii?Q?nyhLc/MctN9CsnePSsw6+5ldZgKqJzV055cSbnAnSedcT8EdPCieuY/NIgio?=
 =?us-ascii?Q?dP5zSARASq6ucAYs3DOzJBYJIIQYXI+ttaFX1RyK+r668GBYiE6XkYPHlJAQ?=
 =?us-ascii?Q?w2mkJmuA7FMWgjx/jPfdA/YI5YS68+jg2SSk6/VPpkbaJFvIRwKgij2E8CFu?=
 =?us-ascii?Q?iympyz+fljsclew1g7aum1qAYic8mS2MgiFH2GGGeDZbB187HKGskOvWa67q?=
 =?us-ascii?Q?t04gjGPDw06bMgkmr1gf2GabXfJYT5DL1KAD0fBsCWVUc15PqQMIou3rbsty?=
 =?us-ascii?Q?FMPJk1DjUpOf5mqRCR4XsiN3bLfqjRC5/xL6mxEsge0ilL1yRJaV5ZozIQkq?=
 =?us-ascii?Q?CL24we7G0cuZ1mgUn766Df47K1j0RfX9JP0SyFsZgJmB8wrmsHDHkMqxiZAO?=
 =?us-ascii?Q?iyTU0CmeYeB5iJpCePSu+Y3uDRc4ZLv3iElnuoddH8KalB5vXHOEkqtWunym?=
 =?us-ascii?Q?A+Kbuv7n5YpMqI8lZid86F7EZtpnGUSKDZq9QRAv0MqxR4SOAQ/G6k5OGK64?=
 =?us-ascii?Q?KPRWzelxf3HqbD3dm1F+FhZVyUDeMHLQFwTxWaOfXgO31KkTOqt7o+aSkQrJ?=
 =?us-ascii?Q?JBUV4MU8PGpRoaq2LWtzAtmPpppIXvqanQO0pqWbDRCgyPdmmIDmKZ37RPdy?=
 =?us-ascii?Q?1qP0l/b6gpBBHQ4Daph97ch4yGFS2Oo6uMr50dNkDCWkpjh9N37UjAtGtyjG?=
 =?us-ascii?Q?rbzsBtp6Kntu8jSNcIZvSM1QAmKspHAKEwRllymZSJuBQpQPf5N0cMXOfctg?=
 =?us-ascii?Q?TL4oHBDTecI5L1ke5FRg9OZpGp0/C7svBRwdGxfuGbuXNQpnhAUJV0gwg0Et?=
 =?us-ascii?Q?3OcoaKBDWY7Ei/p/O+FGo3PIj4tT9eEpmtNL9+EJqGgwg/jAwi3UCyvtmqHe?=
 =?us-ascii?Q?E4Q6fIoGmNROi7mD2U8EgGkemL6ygkzJdsvCKPMOsUFfzUC0LjIZOUDtSdv5?=
 =?us-ascii?Q?o/JmTzqyYDhLARrkGy4LC2W+LJuoVDde3WgVOqzGtv8g6erpwqHMRPlZF9Wm?=
 =?us-ascii?Q?J1HVifdzvhpHkAhUJQf4QDPQR8txGnrxUbiXVLVj4TH8U66c/6KvEWnO0AdD?=
 =?us-ascii?Q?WCUyvjcwJSoXFejdsScQx4eCpDdgVgJnSDmi1BrhS1euMJ5jQ4iC0T2qTcta?=
 =?us-ascii?Q?GvqXj2oaJYsBAjDCB/oJAF+6wsTql7GCyIxLuBlQ5jA2HzeXT6iL5IH278KG?=
 =?us-ascii?Q?Dw+E1WjmcruLI0j8g6EKsd+a8oSVe6RqXQdEEZu8mPgcTiWFFbLXQKQzR/WJ?=
 =?us-ascii?Q?TfLdk22VI3M3iFG2VURfNWCGHPSxjH6wwhnbr57iKLlynpub7BVEIpyfJQTy?=
 =?us-ascii?Q?XuQXVpckVx7gco8LYv49flKJK334lLn9a2GLhhna6I6QVaJhGAqoa8/UHbff?=
 =?us-ascii?Q?H7uMl9VysjELLKnKOGCzh//i/5oSJf8TetCzdv88X7AakCJT4UteY8uu3cpH?=
 =?us-ascii?Q?q5ypqrIkXokCj15NdpfShqtlwil04nHIL7uT1yDYPlslEoiQXcZ3LZW56rIh?=
 =?us-ascii?Q?ogXp7oUh3+f915etOM1qJO68a5UWCs4A40os2rBRFA+cBWsM7wlIFx1/ob7o?=
 =?us-ascii?Q?cq/pEfgQ82RJuaRhx7E9u0a50J781bLe8zFik00UFFJmXvwF2M2dvteB1GVN?=
 =?us-ascii?Q?GLl9mw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e764f207-9bfb-4fc6-b2eb-08da9f85cd8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 06:10:25.3935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AK4kqEUUw1DjZAXDAxuFwDJLn/Wa7ZvsKGPf0IhKwkbMiKtognXRwp7PUfxg8PCcunkBaC5vo2DcuZZbLD9Q0wmXy8r6oO2xMXvX96FFtlRdRGipVI9DzNekfcfLIS6d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5591
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

> From: Krzysztof Kozlowski, Sent: Thursday, September 22, 2022 4:37 PM
>=20
> On 21/09/2022 10:47, Yoshihiro Shimoda wrote:
> > Document Renesas Etherent Switch for R-Car S4-8 (r8a779f0).
> >
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  .../bindings/net/renesas,etherswitch.yaml     | 286 ++++++++++++++++++
> >  1 file changed, 286 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/renesas,ether=
switch.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/renesas,etherswitch.=
yaml
> b/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
> > new file mode 100644
> > index 000000000000..988d14f5c54e
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
>=20
> Isn't dsa directory for this?

As Andrew mentioned, this is not a DSA driver.

> > @@ -0,0 +1,286 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/renesas,etherswitch.yaml#
>=20
> Filename: renesas,r8a779f0-ether-switch.yaml

I'll rename this file.

> > +$schema:
<snip>
> > +
> > +title: Renesas Ethernet Switch
> > +
> > +maintainers:
> > +  - Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > +
> > +properties:
> > +  compatible:
> > +    const: renesas,r8a779f0-ether-switch
> > +
> > +  reg:
> > +    maxItems: 2
> > +
> > +  reg-names:
> > +    items:
> > +      - const: base
> > +      - const: secure_base
> > +
> > +  interrupts:
> > +    maxItems: 47
> > +
> > +  interrupt-names:
> > +    items:
> > +      - const: mfwd_error
> > +      - const: race_error
> > +      - const: coma_error
> > +      - const: gwca0_error
> > +      - const: gwca1_error
> > +      - const: etha0_error
> > +      - const: etha1_error
> > +      - const: etha2_error
> > +      - const: gptp0_status
> > +      - const: gptp1_status
> > +      - const: mfwd_status
> > +      - const: race_status
> > +      - const: coma_status
> > +      - const: gwca0_status
> > +      - const: gwca1_status
> > +      - const: etha0_status
> > +      - const: etha1_status
> > +      - const: etha2_status
> > +      - const: rmac0_status
> > +      - const: rmac1_status
> > +      - const: rmac2_status
> > +      - const: gwca0_rxtx0
> > +      - const: gwca0_rxtx1
> > +      - const: gwca0_rxtx2
> > +      - const: gwca0_rxtx3
> > +      - const: gwca0_rxtx4
> > +      - const: gwca0_rxtx5
> > +      - const: gwca0_rxtx6
> > +      - const: gwca0_rxtx7
> > +      - const: gwca1_rxtx0
> > +      - const: gwca1_rxtx1
> > +      - const: gwca1_rxtx2
> > +      - const: gwca1_rxtx3
> > +      - const: gwca1_rxtx4
> > +      - const: gwca1_rxtx5
> > +      - const: gwca1_rxtx6
> > +      - const: gwca1_rxtx7
> > +      - const: gwca0_rxts0
> > +      - const: gwca0_rxts1
> > +      - const: gwca1_rxts0
> > +      - const: gwca1_rxts1
> > +      - const: rmac0_mdio
> > +      - const: rmac1_mdio
> > +      - const: rmac2_mdio
> > +      - const: rmac0_phy
> > +      - const: rmac1_phy
> > +      - const: rmac2_phy
> > +
> > +  clocks:
> > +    maxItems: 2
> > +
> > +  clock-names:
> > +    items:
> > +      - const: fck
> > +      - const: tsn
> > +
> > +  resets:
> > +    maxItems: 2
> > +
> > +  reset-names:
> > +    items:
> > +      - const: rswitch2
> > +      - const: tsn
> > +
> > +  iommus:
> > +    maxItems: 16
> > +
> > +  power-domains:
> > +    maxItems: 1
> > +
> > +  ethernet-ports:
> > +    type: object
> > +
> > +    properties:
> > +      '#address-cells':
> > +        description: Port number of ETHA (TSNA).
> > +        const: 1
>=20
> Blank line

I'll add a blank line here.

> > +      '#size-cells':
> > +        const: 0
> > +
> > +    additionalProperties: false
>=20
> Don't put it between properties. For nested object usually this is
> before properties:

I'll drop it.

> > +
> > +    patternProperties:
> > +      "^port@[0-9a-f]+$":
> > +        type: object
> > +
>=20
> Skip blank line.

I got it.

> > +        $ref: "/schemas/net/ethernet-controller.yaml#"
>=20
> No need for quotes.

I'll drop the quotes.

> > +        unevaluatedProperties: false
> > +
> > +        properties:
> > +          reg:
> > +            description:
> > +              Port number of ETHA (TSNA).
> > +
> > +          phy-handle:
> > +            description:
> > +              Phandle of an Ethernet PHY.
>=20
> Why do you need to mention this property? Isn't it coming from
> ethernet-controller.yaml?

Indeed. I'll drop the description.

> > +
> > +          phy-mode:
> > +            description:
> > +              This specifies the interface used by the Ethernet PHY.
> > +            enum:
> > +              - mii
> > +              - sgmii
> > +              - usxgmii
> > +
> > +          phys:
> > +            maxItems: 1
> > +            description:
> > +              Phandle of an Ethernet SERDES.
>=20
> This is getting confusing. You have now:
> - phy-handle
> - phy
> - phy-device
> - phys
> in one schema... although lan966x serdes seems to do the same. :/

Yes... I found the following documents have "phy" and "phy-handle" by using
git grep -l -w "phys" `git grep -l phy-handle Documentation/devicetree/bind=
ings/`:
Documentation/devicetree/bindings/net/cdns,macb.yaml
Documentation/devicetree/bindings/net/cpsw.txt
Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
Documentation/devicetree/bindings/phy/phy-bindings.txt

And I'm interesting that the phy-bindings.txt said the following:
-----
phys : the phandle for the PHY device (used by the PHY subsystem; not to be
       confused with the Ethernet specific 'phy' and 'phy-handle' propertie=
s,
       see Documentation/devicetree/bindings/net/ethernet.txt for these)
-----

> > +
> > +          mdio:
> > +            $ref: "/schemas/net/mdio.yaml#"
>=20
> No need for quotes.

I got it.

> Are you sure this is property of each port? I don't
> know the net/ethernet bindings that good, so I need to ask sometimes
> basic questions. Other bindings seem to do it differently a bit.

Yes, each port has mdio bus.

> > +            unevaluatedProperties: false
> > +
> > +        required:
> > +          - phy-handle
> > +          - phy-mode
> > +          - phys
> > +          - mdio
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - reg-names
> > +  - interrupts
> > +  - interrupt-names
> > +  - clocks
> > +  - clock-names
> > +  - resets
> > +  - power-domains
> > +  - ethernet-ports
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/clock/r8a779f0-cpg-mssr.h>
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +    #include <dt-bindings/power/r8a779f0-sysc.h>
> > +
> > +    ethernet@e6880000 {
> > +            compatible =3D "renesas,r8a779f0-ether-switch";
>=20
> Wrong indentation. Use 4 spaces.

I'll fix it.

Best regards,
Yoshihiro Shimoda

> > +            reg =3D <0xe6880000 0x20000>, <0xe68c0000 0x20000>;
> > +            reg-names =3D "base", "secure_base";
> > +            interrupts =3D <GIC_SPI 256 IRQ_TYPE_LEVEL_HIGH>,
> > +                         <GIC_SPI 257 IRQ_TYPE_LEVEL_HIGH>,
> Best regards,
> Krzysztof

