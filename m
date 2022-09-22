Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E54A5E5C95
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiIVHjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiIVHjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:39:37 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2121.outbound.protection.outlook.com [40.107.113.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3058720B;
        Thu, 22 Sep 2022 00:39:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ItnbgQ/KM1J1MDShUsaMrkV/xSd+9lZcoVSf9IDkpUacimCVG7+FmVVV+WQpbgVV/0izzN/aSpmsMvnwiy+HKEgpWjCZYuSslQqYQudpmDh1VppVClILYjJ+WrIvKXoY/d1UxLBlwmFzyf1oyo+MJVYu6IILS0nv+fSKfDtini7VC0aoCxL62VSIZ+vbIvy+YsBEzdwku4ECO5yx7Yl8sbzkSfLHOwrRGk5V9OVxNEBs0z4o27tQi9KbfmksLFLDySY1LBuS7rd6bVueS+BDQwo1KkQhrTNJPlnP4e3qpWBUQlzuaze1GcFdlO1uxf4K7Cnb8FiGSyPzV2pQWnGzrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=js2sla19w1wDgwHBxjUXN3zd3prvpELw3Dip1hHpIH0=;
 b=StrZGf0hJgkRBpJOeK7Ra3jMhVq5nj7z9v3FYGMeP4zuWcj/9VHAJJERTEteM2QzX9+s0evZzLHNTZIwmhD64Hu9VotRGe9AgOW29EW++RKzMOhQ1Aj0SjishlfnfuYrTjL2Xp0Nby1Wfc/rQeg+gYEA8a9/vOSfP9EtfccpXoYx2t3rVw6wvdJgyDyfo7h5yGj2UCwvN/5SHot3gDhA5VsMa/S1NEpB6UVvVgHriUWNJRpG3yyChz6CXHYPjWxIFdHaBGE4YMwrbj2h6BN9P8us8rrtAB6Q7/aAIPJc2eBGYEw99DKqq7VcOYZwD/y9qu6FK41FiAgufhPJRMmVbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=js2sla19w1wDgwHBxjUXN3zd3prvpELw3Dip1hHpIH0=;
 b=iZnzu8z01YXSz/aT38Qn5HOUjpsC0Gc19w/KGrsjpaTeVCS4PJt7OvPWA+RVdASndPRxCXGIfrrB1bUAK4RyAgdVAyhUcc/SREadR7ZWgUELu8jkrF4q4tjGzhzgLIf7sPXOhuetyyeoYJ8imuEI0DQ4Nk4IqBVJ6rdxl2sviTM=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS3PR01MB7802.jpnprd01.prod.outlook.com
 (2603:1096:604:179::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 07:39:27 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5654.018; Thu, 22 Sep 2022
 07:39:27 +0000
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
Subject: RE: [PATCH v2 2/8] dt-bindings: phy: renesas: Document Renesas
 Ethernet SERDES
Thread-Topic: [PATCH v2 2/8] dt-bindings: phy: renesas: Document Renesas
 Ethernet SERDES
Thread-Index: AQHYzZbyAdB5zxMt9EG9rj3m+K4rGq3rDseAgAAB7gA=
Date:   Thu, 22 Sep 2022 07:39:27 +0000
Message-ID: <TYBPR01MB534100D42EC0202CA8BEF04CD84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921084745.3355107-3-yoshihiro.shimoda.uh@renesas.com>
 <9b29ee3f-ed48-9d95-a262-7d9e23a20528@linaro.org>
In-Reply-To: <9b29ee3f-ed48-9d95-a262-7d9e23a20528@linaro.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS3PR01MB7802:EE_
x-ms-office365-filtering-correlation-id: 08ee554a-9dfd-4b27-8a5e-08da9c6d93fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SaAhdZnPv+JsCKeUi6tIK2xKA+8YlUsnssPE0BNhYS6tdihZWoSB9nwNhRNeiplazcpPqVQmgORJXhlM0ke6WPyWatmQkMs/oaw1xjIvJWlbcg2B/fBYEG5nGcLiQG6jOTZuwz3v4C8yDfACbQ5zwDJPoUvbhuWDTk9Rf69B7+Tz49q8wY5CA/Z0UdCnc9XPa9fNHgp6bDr88a2h1VB2NQKG1JZPz+p5iAkTBRcaW2y32bZHtd7vYDhskcj6JbePiSBD/0SNMvfVHEYFYwgsMmg0boIYACARnScyAKVEtqrnMkafHxjIPks+kJuFOSlHh+ISzJc0DPeKPvla20ynVrUO0n6+7kCjI1zQLS7u8QHYEsF9Nuc2HDA2oRnkHr/7SqRyWAHmJZIfXQ2K7Ndq1ogWAqgM8vTH/CUDAwFIUTvPou+AyCosQ6maQXbQ7/d0vRjRDMG72T/QWYGRjB+SRBMIA/axs+gd9jypSMFhN9psG5OlK4F6qVLU2spqPEW5CnYZ3MKdx+GLxS2bqDBDxgS3h1KyXTD7VFiXfQYdzs3yeX7G/CKQWTlJ8Ykq4KzoyzVn+dsU1tUaF+6SiJ2HTLn6eGSFK8hwNcYUFnskttgQYkM+Y/SF75BgizHPvMDNkB3J7o/T8TpL7HVSXVFrDdOzVI+2kqd1hnjNu//DEy6d/1+gsuyfxMtj38Znhvlx08trMqCXzV3HFLMtck8kYqopT4JPg2c34PWYXoBA7/RigZ9WAFxMps/swUqtvHYzwpDOKw2Df2o7JvJkuqBDmNr6v9T6TcMEKFfJ4kpW54k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(451199015)(316002)(186003)(7416002)(33656002)(2906002)(53546011)(6506007)(7696005)(9686003)(8936002)(52536014)(5660300002)(26005)(41300700001)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(4326008)(55016003)(38100700002)(122000001)(38070700005)(921005)(83380400001)(86362001)(71200400001)(478600001)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?01Ku3njvoItVsCH73zelLHvNB4DrhZz4M7ux/ZnSbHBD1C2zyx0dJhJMbeOr?=
 =?us-ascii?Q?KBUkGBrfQ81sYTrnAZT9T1Gxz6frAEdxolTDIKRfbUgJAbCPIKQm1m7eQIUE?=
 =?us-ascii?Q?aJsMreaKhldcuPf4AO8F/hnbimx4zky51Ivjoh0JaA/njlD/MIB4CTDN36ow?=
 =?us-ascii?Q?P9+hLUO/UUrUDgFD+pMPXlUwbMuhhu/PdnvZ4+H6Idli7HOS8ZbecZTONvOe?=
 =?us-ascii?Q?y7Y6Ddg9L8JzARYq+SHbWjz5Be3KbZq0S0cQ2Bs3c01NZeILT2RGubMhD3UL?=
 =?us-ascii?Q?rO5UVO4BlNjnskB/znvb/GtY0vL8ZOQMRcFNl+KGreRTJxLSTqVaYfJwzlrb?=
 =?us-ascii?Q?GxTCtzb5p4ZbzDPX+ZiVgZmKq59DqQ+pPdOSYlRpM5R7Svvp77yRhaLtkCPZ?=
 =?us-ascii?Q?DYCQonQfvgeMJp2gYH3tg3VMTh2YykUPjmt3jhjPeg55ez0lJKFkHYQ+4YHA?=
 =?us-ascii?Q?Q3T/3h9KH6VCS1J1qbvFVcPsIhX6LFDqwnpmrjsKWt3FBqPFm3CvSBk6R4sM?=
 =?us-ascii?Q?32tnKA8eFTxuLY3e9Vv+EWSYd2b4nVXRr+xzILRbV+PRdWKZzJPBXP4Vodr3?=
 =?us-ascii?Q?NCfMTLHllFnEXaj6dhEycS3ds9Vrn0CKTLSxNufsds91pNVIaKrjKU3Ol6Yq?=
 =?us-ascii?Q?BZl4hrUbu7AP5EOaNnOZnaXCDtIWDMhE2a0kWccwwfzfgC8+BGhKsnU0NhdR?=
 =?us-ascii?Q?yH/qwoDFn/b2o4VhfEYERK8tTVTfJTUjG6zja/bHLBtUCa1zcRgyCr5G/Szl?=
 =?us-ascii?Q?rOtEac7NxxwynzH3fyNizOxUkFAPfgptG6aNwgPQyT5gWFrV0OQSzq/7MJJz?=
 =?us-ascii?Q?ckEqfKV78vpczsN2YrwcyKA3d3AVAVT3tOpVSegOFQLHHa7Vejq9UclwWJ9h?=
 =?us-ascii?Q?umYxpJjz5rwb8ex8Go/NX4N8nLAC4Bbfh7VvG0XabFEPbQ+Fk4oHlfoO2NPj?=
 =?us-ascii?Q?EjR2kcegGE7Q2cWpdryfjb9EyvnuiPZ09GtwgestKaGa0OlRpsTxYomfPDvI?=
 =?us-ascii?Q?Hv9Ko5/FRCQt5tPDKJ5ecGPBqxrCuVYJ02f5F+/HUwS3eSbyHLanSYwbu0Jf?=
 =?us-ascii?Q?78DvCpzIzI/5u37heeFAIcgR8cfvsIEtJyNEVVDAXZ9C3sSd0IO9Yt7464Xe?=
 =?us-ascii?Q?e2aU7Etz62A6bcUUdIuG/ZM2vQLXAc7vle1mR8oucBPnNilTCRhTzZiYTqyz?=
 =?us-ascii?Q?kCZKdp+j7unUW7PEaYqfFx8Oe8A0xhImouCPoYuQKSOo2PKs7QAbFgkMDhGP?=
 =?us-ascii?Q?HEIDue7DWmllF1XbskY6zTiYhLnFyEdzKO3hcAe4vXwsqLH9H1E52sKw1p8L?=
 =?us-ascii?Q?dn62g6Yn9nUerS2YXSYnsq99UacE6c3jiURkxD1nIKH8j7RxaFKMu+3as4dy?=
 =?us-ascii?Q?6cM+gCFU69tZnj0VdUuP5XAm2Z3btsENvWeTAYTGNZMVAcOmKfuCbgA6B0dL?=
 =?us-ascii?Q?Uf8/F1x/3hYdvyMXx6Gs71BvytkTUqUKE0DX+EStBihVDwdGGKMPMyIiNJ8I?=
 =?us-ascii?Q?DA/wWJxmUlPXRDk84tnc51bkYO3EmzVUY7+cADz8M1yhBfulHkMFA6XABaGE?=
 =?us-ascii?Q?KG5/Bm+DsiGd1FO/jHYOw429InP3MxFa3LDLPUMCm+F3iObC4+3+mEosSDZi?=
 =?us-ascii?Q?eQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08ee554a-9dfd-4b27-8a5e-08da9c6d93fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 07:39:27.3955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4T/UBPgdMO/1pWu1YW5UvccDwRKWAi0tiy0ee8IlhO4kK/5LbHMYSa2HOg3JsQHPTlpze1HQhgNLyniiPN9Y4yO9btvFa+e3YYsanWycoN828Tsent4fHavUElX7q227
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB7802
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

Thank you for your review!

> From: Krzysztof Kozlowski, Sent: Thursday, September 22, 2022 4:29 PM
>=20
> On 21/09/2022 10:47, Yoshihiro Shimoda wrote:
> > Document Renesas Etherent SERDES for R-Car S4-8 (r8a779f0).
> >
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  .../bindings/phy/renesas,ether-serdes.yaml    | 54 +++++++++++++++++++
> >  1 file changed, 54 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/phy/renesas,ether=
-serdes.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/phy/renesas,ether-serdes=
.yaml
> b/Documentation/devicetree/bindings/phy/renesas,ether-serdes.yaml
> > new file mode 100644
> > index 000000000000..04d650244a6a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/phy/renesas,ether-serdes.yaml
>=20
> Filename based on compatible, so renesas,r8a779f0-ether-serdes.yaml

I got it. I'll rename the file.

> > @@ -0,0 +1,54 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id:
<snip>
> > +
> > +title: Renesas Ethernet SERDES
> > +
> > +maintainers:
> > +  - Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > +
> > +properties:
> > +  compatible:
> > +    const: renesas,r8a779f0-ether-serdes
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  clocks:
> > +    maxItems: 1
> > +
> > +  resets:
> > +    maxItems: 1
> > +
> > +  power-domains:
> > +    maxItems: 1
> > +
> > +  '#phy-cells':
> > +    description: Port number of SERDES.
> > +    const: 1
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - clocks
> > +  - resets
> > +  - power-domains
> > +  - '#phy-cells'
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/clock/r8a779f0-cpg-mssr.h>
> > +    #include <dt-bindings/power/r8a779f0-sysc.h>
> > +
> > +    ethernet@e6880000 {
>=20
> Hm, isn't this a phy?

Oops. I copied and pasted this from other patch...
I'll fix this as "serdes@e6444000".

Best regards,
Yoshihiro Shimoda

> > +            compatible =3D "renesas,r8a779f0-ether-serdes";
> > +            reg =3D <0xe6444000 0xc00>;
> > +            clocks =3D <&cpg CPG_MOD 1506>;
> > +            power-domains =3D <&sysc R8A779F0_PD_ALWAYS_ON>;
> > +            resets =3D <&cpg 1506>;
> > +            #phy-cells =3D <1>;
> > +    };
>=20
> Best regards,
> Krzysztof

