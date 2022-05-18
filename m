Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1DAE52BFA2
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239732AbiERPvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 11:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239593AbiERPvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 11:51:41 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2073.outbound.protection.outlook.com [40.107.100.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D716D1BE11C;
        Wed, 18 May 2022 08:51:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNK4EStW9zZ4m1gYAtuHAmq4OcONA9LExasdaBNDrpr1DNa8D5ZMmnK8PXJHTl39P2cSWX9FtjvA1il3lxl5IgLCDe+ijlHL46/tbfkVagW8vqb2RFrSV2Iryl7S9LBXzRKqH+eO/FWNO0JUUB63+zWMybOWHFYgWBHcO3HV2FpEaYTKX1AMqN0DdNoMfDJ3CXwec13ROtwaz4WCuhIebSETQ1jsI3OqXRsZuXVN+UpOtGQYKxA1zwkvuGyJBfPHeCK+3kMZG5foK6tGDmYH9WG+oeGyzfPSgQaRlYXbFdd3HKpUtS8onPDuMnOZmnVXp47BM1x5bhXtd0yTwnxg8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YMgK8aQjXqU3M4XHbxlduLXqQLhIXMpQDr/DIkwNNfU=;
 b=SFel1T1MRfJhl8PYgQINxZfwXsPjrHhpYgUIjO67ixRpH48pqAa4tAgEES4WzbmhqTW/tTPzhVnxIIUZ7+OfdeastOv/XQpH8m+zfK17mn2w4KMGn0AmJz9K/p7UbcGbxgas6HHMDLqglX1bUsiqEEJ7onkbMSEGKocOZJ8nlD2uim3WmUTcb4VYt5gqdYA9kJOtC/xl93V3Kn/JMtbPjuyNja7L29jIHdjnQVcF0A2LT/0QwXfdVl0XZGuwc60pAImctdlBAPLPRAtkMi0YDFqEgVG11/57d4ghNv6U7pCY5DXA/MaifUehBN0Gv1Tw3xVg1KAJfndLo0K9Y2LWoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YMgK8aQjXqU3M4XHbxlduLXqQLhIXMpQDr/DIkwNNfU=;
 b=kz7gzG8gqfUDT+IfPbNtCB+znNuxJvduPK+K5M1Xtzlkvp8WVM/17Pa74WT5wX0NG0tfh14MO0W/Tr/FVni7uYHYGn3CRijH9GdIuEFVmBO/+4JibTKSuY9kFEhAOxGDH/4SohUghW7AnFNrKeVl9AMGt/DYWooekrsai9i2Bcs=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by DM6PR02MB4219.namprd02.prod.outlook.com (2603:10b6:5:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 15:51:37 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::94f0:32be:367b:1798]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::94f0:32be:367b:1798%7]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 15:51:37 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Rob Herring <robh@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        Harini Katakam <harinik@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        git <git@xilinx.com>
Subject: RE: [RFC net-next] dt-bindings: net: xilinx: document xilinx emaclite
 driver binding
Thread-Topic: [RFC net-next] dt-bindings: net: xilinx: document xilinx
 emaclite driver binding
Thread-Index: AQHYZh7/W5aBkbqlHkqbu5HcsW4/mq0j0VEAgAD/x+A=
Date:   Wed, 18 May 2022 15:51:37 +0000
Message-ID: <SA1PR02MB85603BDDF6DD3D8182A74915C7D19@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <1652373596-5994-1-git-send-email-radhey.shyam.pandey@xilinx.com>
 <20220518003240.GA1942137-robh@kernel.org>
In-Reply-To: <20220518003240.GA1942137-robh@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5555ac54-b326-4d32-02c1-08da38e64a8b
x-ms-traffictypediagnostic: DM6PR02MB4219:EE_
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-microsoft-antispam-prvs: <DM6PR02MB42193BB995F51525B2BCD363C7D19@DM6PR02MB4219.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yM4bKUUiYsZlixHSB7/0ID7YRnlnf5qrG6Mx1uAzk15Mwre+THW+5f3ygUMae04O0ReWnTkQ52JC2ofUlCAG8p2v/VCRn2Q79wgOc+BhvDnSjYMjtiosthtRmvpLzDqu3qQwfSxui+gMMghwNRv2cJswgIPJGdg6KjQ1gCLVHU2HVdJ+PeqJ5bSWVLVstuWNk179U+JE2i41AX29FkCQxFeuj2N3JcEeN77jQTVxlVoyIkNdQQfco7wIIMrAcBXN8z3JGtoGY4Rz25qua0B/2Wt9SuoZ5InPrBlzROTSn056YBR3/Mv7/puSxEySA9WAowHqdxMaVRbQIhTXXl0CRPzRk3UyQLC/tpJLN4gG2aNc2AmK5atjw/zOefDTQ3SmsGS3yk+1ua5exmoSo/lsy4J2OrpvgqZbfZS71iN99c+MxvML4dEgFZljTSifhJpAh9WpjXnsKIjYnAPzV+NALEgRlr3PceMFld6mohULjUtsO6GbXpAUaNg8iIYTVjsfD0HFVzsNQu8Zwfkfja7o8WwqNUDTkq5VGn1CoP7/2cL6kjjBfEPGz5AbYEal2bbzv+TNIPpPzbCFyy0K2xTI8HSsUMTSK0IAId6Sqa6kF2uXmasxM6OuFACRuPvAAy3JVS4bxvFzpqUgUjyKe/uujmRbsNtltN7bH48No2Q9RKFnybmOwm/0H/frQiMV6ophvYlX0R/vbnPhdKTWYLeMm8FhtdsF48OUbEur3J6XQKQoVleVdyHOWdMUTym3+zURHmvh5L0i4dFNTCd8PbWJQnTyVWcqnzuJZZFbfu1EkG9YVAZVR4FL/FJz0Q4mt/2jxSSae0CCpgZmkQXCWG98NA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66476007)(5660300002)(7416002)(86362001)(9686003)(8676002)(66446008)(76116006)(4326008)(52536014)(64756008)(66556008)(122000001)(38100700002)(6916009)(54906003)(33656002)(8936002)(38070700005)(316002)(55016003)(53546011)(508600001)(6506007)(966005)(83380400001)(186003)(71200400001)(107886003)(7696005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?153MjGMb+jXK6Xk95kPrU3gzeZMYQSG2XyJNT9QToZULkGmfLyORr+td3Lax?=
 =?us-ascii?Q?EYQY9OpiW3s648CKWjKOWQQ9s2PIJlpo/OhOV3WhtXL+R9hvZl0He4fYd7tZ?=
 =?us-ascii?Q?gY2RaxPhcv34cMubbVdlK4xSF0A4F/rWsdyZYyx2ka0JTNkcQDRXMiMtrVSX?=
 =?us-ascii?Q?TjrsenYfSyOAgFfC7J3m0ebaiDHhcrp0DYeZKf20FX16WD52Rh4kpuFOdGNw?=
 =?us-ascii?Q?ep64O7VtZ4bdLhIibKQbBZHdOVxCV6QOCpHVylUmxDVmCwrLrYldYSoMUCzh?=
 =?us-ascii?Q?GuNUs3XYN6tV71M7o8nq5ImSXJ3f71ugxJGH+a38QR5Z37Qt66x3GN53njER?=
 =?us-ascii?Q?/65h5r0FOXCVWEyzP81so1GsSC8Wcvjb20OF71j0udOVWNjr7RAmDzztXrX9?=
 =?us-ascii?Q?O0cVVW+cy45W89tmF5Fm13Jt5Dwdk7bE/MTXZj4zTpUq+F3l/eWiy+iQRsH7?=
 =?us-ascii?Q?kfA6JeFvS060YagZywUviYlUSobzrKhWGGLxgEvBpBOFzcNPbgvqsN9sq2RC?=
 =?us-ascii?Q?h817F+ShNA6bIsvqjSmwa+PILlciWmYJeRxABSf9LOoIca6924dXJ7HtkmEW?=
 =?us-ascii?Q?A+U2fWT41CxmmZa7mM1ZMBlFmuOQzDsb3J2zh6K9tLPD45zB3kG4F5GANEc/?=
 =?us-ascii?Q?Zh4DTO2F9kOveWDib4p6ZxwcBm3lbXLV6626xwYP+pXI/vH/GhhjQMx1DZ0X?=
 =?us-ascii?Q?u6SEPIhcng19pkwWBaF9mIC8P1Owim/p6sBoRHJ1T53cN5+spxqfPt6XAIw0?=
 =?us-ascii?Q?nTzIGoLoqSmOT/hAJF60bRVbxBimRiNv6ayI6bBpZka0RUuS/c42LaQZQaJO?=
 =?us-ascii?Q?z68rSYMotcjLSwfIQ3OjpgRqVB5dQTaq/lVDIBvGrB5gGO17nEgs2qMYXz3i?=
 =?us-ascii?Q?uGrlCwvFnuvWYAwi4lNqc9q07NlZa+b62XIX3TlLw6U1rMSoPRi0iWPy70Ez?=
 =?us-ascii?Q?FKNq4OgHpFKNAuQr9+XFvzCY8Nbc/JQnjp9NSF3o5h5NsGmik8kO9Z80QHl5?=
 =?us-ascii?Q?nAFntjZulHSr3w7pW3oQuZpcVumTX6wvweS8krWmYH9CRgIU3Qodg/axbuK9?=
 =?us-ascii?Q?CZgZoTi4BB7xFiuZ0Zb3njVlzbZp35mN3l1hVjf0fEC/8ML7oVM6zCA3tKDV?=
 =?us-ascii?Q?kU1505F1kM5mD8cuARP/VEKgCwF5UkitHGG2mZB0qfhX1L3T2o1spEEY7Q/Y?=
 =?us-ascii?Q?NIlPptgjinPpNPLgKeHkqD7sjW/IYt5F3RBfu9Iw/Wwj5BJC8lfme+sV6WHX?=
 =?us-ascii?Q?zGdzxrwOjZe4FW2P82RlaBdhCz6aJeXAD/8US+33aSPV5grkeHaA49tTmEKI?=
 =?us-ascii?Q?eZ1PZ3w9sCtnaGsVgv0PWs0Z3k7//nNBwAI1GjFtH7mLKnI3NDeIz5SCptyO?=
 =?us-ascii?Q?N1yo8ADWrfxxIw2HaOL7wXZX7Bo0fXPVJOGpBw757YIf+oTXuvO0BDldPlTh?=
 =?us-ascii?Q?0n6ipNzMrZ0xzJKroJqA0PiT8/gKeMIt/ShP0l3tq+uyZT1/ahzZBQRSe7bz?=
 =?us-ascii?Q?mWRW8O9IawZU6zllmlnlKBD07T5YIb9Odd/9HOsI5cy6Svk5H0Sf0d8HOgYH?=
 =?us-ascii?Q?DKPEmGkZodVJa8SEsuQ2iPy/rU4gi11iz60P8Ugv8UEHHFHMq/vBJTauVpBl?=
 =?us-ascii?Q?bhuttwpLTFsVjQ2dIFLViQxSP7DIzKPoIA6UZges8xx30AS5XVgYOrovb4Ey?=
 =?us-ascii?Q?Gxr5SYeCPlP1E2z5xijv0ookdhiK92qhRfD93u5VzS/I+yS+54AxL0PzRFXg?=
 =?us-ascii?Q?xOOz6LvQ4VCSyGkX4nPHjc+s90lt/TR8642JQ7pRq4r260PbIOywTELkI7mL?=
x-ms-exchange-antispam-messagedata-1: 78zCmErWNsYeDQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5555ac54-b326-4d32-02c1-08da38e64a8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 15:51:37.0448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maZ6mv4U0gVmhC5RKB3/UoF0wndwo4IWWOlST+iLEHtmJXMt8vDOIqcGYtxnFNibPGJeDJXxj57rm5/eQrul0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4219
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Rob Herring <robh@kernel.org>
> Sent: Wednesday, May 18, 2022 6:03 AM
> To: Radhey Shyam Pandey <radheys@xilinx.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; krzysztof.kozlowski+dt@linaro.org; Harini Katakam
> <harinik@xilinx.com>; netdev@vger.kernel.org; devicetree@vger.kernel.org;
> linux-kernel@vger.kernel.org; git <git@xilinx.com>
> Subject: Re: [RFC net-next] dt-bindings: net: xilinx: document xilinx ema=
clite
> driver binding
>=20
> On Thu, May 12, 2022 at 10:09:56PM +0530, Radhey Shyam Pandey wrote:
> > Add basic description for the xilinx emaclite driver DT bindings.
> >
> > Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> > ---
> >  .../bindings/net/xlnx,emaclite.yaml           | 60 +++++++++++++++++++
> >  1 file changed, 60 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
> > b/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
> > new file mode 100644
> > index 000000000000..a3e2a0e89b24
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
> > @@ -0,0 +1,60 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) %YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/xlnx,emaclite.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Xilinx Emaclite Ethernet controller
> > +
> > +maintainers:
> > +  - Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> > +  - Harini Katakam <harini.katakam@xilinx.com>
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - xlnx,opb-ethernetlite-1.01.a
> > +      - xlnx,opb-ethernetlite-1.01.b
> > +      - xlnx,xps-ethernetlite-1.00.a
> > +      - xlnx,xps-ethernetlite-2.00.a
> > +      - xlnx,xps-ethernetlite-2.01.a
> > +      - xlnx,xps-ethernetlite-3.00.a
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +  phy-handle: true
> > +
> > +  local-mac-address: true
> > +
> > +  xlnx,tx-ping-pong:
> > +    type: boolean
> > +    description: hardware supports tx ping pong buffer.
> > +
> > +  xlnx,rx-ping-pong:
> > +    type: boolean
> > +    description: hardware supports rx ping pong buffer.
>=20
> Are these based on IP version or configuration of IP?

These properties doesn't depend on IP version and are=20
related to IP configuration.
=20
>=20
> Rob
