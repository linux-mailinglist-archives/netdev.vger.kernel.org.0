Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14F261943F
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiKDKLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiKDKLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:11:48 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140073.outbound.protection.outlook.com [40.107.14.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9772982F;
        Fri,  4 Nov 2022 03:11:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kCti75yP1txWYQ1hqWN7QqUf0c4E9OPfTm9zrHpoNtbSOiZT34UPbvtVVjQuTui+Ow7eisChFs0L8lIDz0OBiZMjVbaplxNNVBIr4zrdWCSU+2bzSLoJ1Y06tQRxfklocLNud/4TMmADiIwU4nZ5GuxYN25+LqfRX3r+KMKD+2aUdtQ3nt72Hu0qFIciWmgbux1rpwIaYFMskx6bo42amt/RUn7fBh+HLRdEmUoTXRDuZqJPOC3LShes5eY8+67fdjfNhAUqAIrmUqvGfF6zxG5bXek/PGUsWqF/d87ANT5B07mcw5EqhaipJWLkOnAtTyLqk2p3MtT4zxUGFGl8Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=87XNRLXrygPfx5Q6plODbfH2YH6NZ/UotO+1yIz6Bps=;
 b=YUZo+K87CIdSNPqBxyotJzGC8jCd+bDmHT98EYhzt7KW8xwqjCmq2E030Zshyb5hCOgz3DtWUCROdiBmfg+cigbPriI+P8MU68vgGqPr2rs/du5YH13DO+ee+AaAW9+vn+ErCF+lGuSPL12blhpXy3cCSnCkRi0zeMAwxgIdF+l/Tepu47SLaI4BXCci9AjnzlmFPbPSztmEv0Ei7bL/cxJGVcvIW46ysf8+SlDP55HrnoT1V4zc56bk8Ed9zCKzI6cq94R9MbQLM+xuukQha2PeEqKh/ng0L7xIJwD7cwjWSTJWpztOucSEm8wzIsbOA5SYYVvD7/9tJvh1gHXlsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87XNRLXrygPfx5Q6plODbfH2YH6NZ/UotO+1yIz6Bps=;
 b=2kq8Ex22Xjg3MgRkMK4GLFs1r4vnuarkUCZj7PHL4io9qGU982vdzO3EIsTTPGQFJO5yIh3hIfq5mZUCdZtwll/JI0F9VXU9NZgI8cq+O2Cs56aUE9rffUSxB5Gqwk21yrt556ydset15Tdk7AeaPDO6tIjECiIR7SJRem8sLB93CU5sFY57hLD7XkRRWBm/R/xX93aad9no/chu4sz5OxcHpC6f8pnPZospTjTgX+XF8DtU1NtOL0UmRDprEQdxC2e45ogdKv3Kf/ZgiByDrwr0bChQFrE7KfXb5sgOgGjPnp1tTXQT6IGbPZFRtMGjgMNxLgcKy8uZS5VHTXjDUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by AS8PR04MB7814.eurprd04.prod.outlook.com (2603:10a6:20b:2a1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 4 Nov
 2022 10:11:42 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::2120:d5b6:79db:16a5]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::2120:d5b6:79db:16a5%6]) with mapi id 15.20.5769.021; Fri, 4 Nov 2022
 10:11:42 +0000
Date:   Fri, 4 Nov 2022 18:11:28 +0800
From:   Chester Lin <clin@suse.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>,
        Chester Lin <clin@suse.com>
Subject: Re: [PATCH 2/5] dt-bindings: net: add schema for NXP S32CC dwmac
 glue driver
Message-ID: <Y2TlUEwbtV0C4Lfg@linux-8mug>
References: <20221031101052.14956-1-clin@suse.com>
 <20221031101052.14956-3-clin@suse.com>
 <20221102155515.GA3959603-robh@kernel.org>
 <2a7ebef4-77cc-1c26-ec6d-86db5ee5a94b@suse.de>
 <20221102214456.GB459441-robh@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221102214456.GB459441-robh@kernel.org>
X-ClientProxiedBy: FR3P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::7) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|AS8PR04MB7814:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f6de8fa-588b-4ac2-df16-08dabe4cf820
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i97+Tiq9ZTmqMHiE7JnUU2BZhdZfnpxXpzV0k1WOk1Gb5YplPTcnGIrCknRQGSa908Rv7JdluvKV1kQLmZUvyxrUE3wZQ92oDr+l3GdEekOuPxrrHbyq7/AZ2U2oAjMcCpsp0DrlYknidvl35jvQgCpTkmrBE30uQZWNL3ys+D1xjlxkCX8jFj21SNL2B4Xw3fPj5NzZ8LUf+9d7j7QvsR9hzyZtjJ+2MSXKzAp/h8fOLOb9CD3pVDjqsSMRwqf16LmCsBV68PYudmXXGJlcyi+KiZY/x+K39cqDCH5EetU3UMP3kAXaRUZlyj7ZODMF1SzfVr3c7l6a/k3Wen3bKjeSOTYPiR58cyZXTLgDW+OzNRk195QV2yU8tm/6qJwGjecVbmY4pByUnO6TY82Y31rpv/3Loz2KHeezmX853d6OzVHju2bw2yXJ/PMpX41OATz+y2c8Vdh1lURkwlTXjjnepp0ML3vs5V1HN2pf6t/hzbw5wa/zAUAD/7gS6GwRlq9q4A/0jqnYnwPZ2Kft6Kirq5pE2+8urN2G3iHOpPrET81mwvanx4S7yHFCEyoUZ14PkETRzk9R57QH7Bsox+e0LGguoQAawqmuEEoQsIDPX6tsa6vH6VMVwpcHxmHCbvM2JHuZTyBjsbGex4Bk9hsO1CeCUfOetujjSzuTF4mmfuUCUZEChXeT5GE2lBTzd+GMY2nc/PeyO+Ji57X3ygsBhWvCT4TaXl2jILzTq54=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199015)(66574015)(33716001)(66946007)(6916009)(26005)(41300700001)(6512007)(66476007)(4326008)(9686003)(66556008)(8676002)(53546011)(7416002)(8936002)(5660300002)(478600001)(6486002)(6506007)(54906003)(6666004)(107886003)(186003)(316002)(83380400001)(86362001)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?CaFOEIkKBpaFNlEfa6vbjZSrTB881vw8UyxeLr3iQgxxsZV4nGRc97V6Mv?=
 =?iso-8859-1?Q?IjSSc66IBcanblSDaCFbTRRv2tmqdk2XhMgguAe/sL20wRwrkYo8BYedft?=
 =?iso-8859-1?Q?Zl8I/xV77R503iO2PE1ymBqPEu2vV68IooOWDD8o7/yQ6NmlyM/DW4jBHJ?=
 =?iso-8859-1?Q?TcgRmduJhygiB1cy1gDHWx3ZewL7eElhPntyDksIsARUR/tKxX1oeXPLNX?=
 =?iso-8859-1?Q?b40AJWbKfjpo3szJJWYpuC9NHe1OQ+faV/y8LGWyW5g+OQgA09trX5jU+I?=
 =?iso-8859-1?Q?17TBasTyWPyvI5Q7L+abNK0u+SicNcgMPNa8atIqsM6ZFYOQvOCjCYmO8Y?=
 =?iso-8859-1?Q?K/zL62AYbNciJ5y0MkVMyzrBFBQPLATvDwkg6iLmm2dXQGjbDeDWmviARu?=
 =?iso-8859-1?Q?v5aZJbbzru6++t28nFQcPZQ8F4PIasWorgJ1treQhhDG8S8NGH8nFY5x0p?=
 =?iso-8859-1?Q?Hu2WBWPrrCBfyOzfyaELzwLGFWdL/RVL3ONwBxaspNgpfKr6bM+rHpzWts?=
 =?iso-8859-1?Q?aDGwoSYQdzyvisxtPhxC9qJ2ZSRI0/8v3uxGH0MQtFdfAkWvyKEsFtyIlu?=
 =?iso-8859-1?Q?6wCrfr5x+6VFCBuTsOResb+sUuPotxaeiU+hzKVlfdMQPO/w3K/CjUwOSz?=
 =?iso-8859-1?Q?2gJHeVmc0TLs7ovbrDN8Kv1QdKlkLQC620Nn+pSI9ZIFCzUDUWGgUcPTdi?=
 =?iso-8859-1?Q?Pyg/QAYVnFv+PiSggf8YCi05aaCqDq/gyDChwppoJFC3sHR82HfZd0T6IU?=
 =?iso-8859-1?Q?95i6zo8RAEcqz+EUgLd0lrmnDq/KHu2lGZoQy4AH7OZrq/qT8b6C3RgKCu?=
 =?iso-8859-1?Q?I3x++tbDCaQOkLPWqQqzyowpJyLOVjCduq0p/XIwI13lXaPM/796lmWXqN?=
 =?iso-8859-1?Q?ON7z9iv1uXxYDN9yNLgdYGhctrfIvidizKIkCn2peK1Vga+StT2xRwjWw2?=
 =?iso-8859-1?Q?segH7sRo3Eq3LWkb/tEGsPyw5XdBxb9tHS/qtWlj4+S/n7vWEd7ppEV1SF?=
 =?iso-8859-1?Q?Dtajj04UBsX26Ldx/50Ivz8AsEPFPfDIy27jP7KshaG9nQhezK+e43OxPK?=
 =?iso-8859-1?Q?NAEhViWRRl4qH6VYBwhTNie6Z9ldXgOXlr4817b10ZWzh7E2sSlJKMIcnq?=
 =?iso-8859-1?Q?MrPZqG0rGSXUgdTyUcrhc/gpxdaIdZGJZhm8NZTpACn1lJBSZvGnt3b4Eg?=
 =?iso-8859-1?Q?WOkeYW45kngkMvTF/BnagYQ9ZPJH0mBDHManH8xeVQNhrfn/HVdCSJ5LN5?=
 =?iso-8859-1?Q?78YsIcTxh3UW7FQCPSoc23XjgEUMDYmPTIOHivkFrB7kGjdhvdTQIXsykK?=
 =?iso-8859-1?Q?8eor6r4New9IyVtX66Xj9KnJLmOsgvLSys8dwfJjcdldoQrqZQxCgqBaHf?=
 =?iso-8859-1?Q?qi4gMDqWIDhwYa63mevjl2uJWmS2cnjiCBJ9HmPaB+AX1fwcPjhDBTkd1V?=
 =?iso-8859-1?Q?yRD/ZKq3jKnNUdsP4DGrM1wCdEw+Xrz9SveEIAV/r9TyVoNv2LQ13/tali?=
 =?iso-8859-1?Q?ttKaZiEOmrr2uLt+2sdO0xTBf4RXL5VmisENOfT0o97rYB+HQYbzvlf7L5?=
 =?iso-8859-1?Q?iUy0tw22xzJa6MhXBQw2xfBTP0xJQY1QjvQ9EvdYBKa6f1WBBlp4fQYw1P?=
 =?iso-8859-1?Q?AIEmiQzmbbfD0=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f6de8fa-588b-4ac2-df16-08dabe4cf820
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 10:11:41.9635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AzaRfLHEqO9rMd5bPG3hEPu3eFpgkm8BPDQxhBA1RaddfTku1L86Ny+cc6fNbShk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7814
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob and Andreas,

On Wed, Nov 02, 2022 at 04:44:56PM -0500, Rob Herring wrote:
> On Wed, Nov 02, 2022 at 06:13:35PM +0100, Andreas Färber wrote:
> > Hi Rob,
> > 
> > On 02.11.22 16:55, Rob Herring wrote:
> > > On Mon, Oct 31, 2022 at 06:10:49PM +0800, Chester Lin wrote:
> > > > Add the DT schema for the DWMAC Ethernet controller on NXP S32 Common
> > > > Chassis.
> > > > 
> > > > Signed-off-by: Jan Petrous <jan.petrous@nxp.com>
> > > > Signed-off-by: Chester Lin <clin@suse.com>
> > > > ---
> > > >   .../bindings/net/nxp,s32cc-dwmac.yaml         | 145 ++++++++++++++++++
> > > >   1 file changed, 145 insertions(+)
> > > >   create mode 100644 Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> > > > 
> > > > diff --git a/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> > > > new file mode 100644
> > > > index 000000000000..f6b8486f9d42
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> > > > @@ -0,0 +1,145 @@
> > > > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > > > +# Copyright 2021-2022 NXP
> > > > +%YAML 1.2
> > > > +---
> > > > +$id: "http://devicetree.org/schemas/net/nxp,s32cc-dwmac.yaml#"
> > > > +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> > > > +
> > > > +title: NXP S32CC DWMAC Ethernet controller
> > > > +
> > > > +maintainers:
> > > > +  - Jan Petrous <jan.petrous@nxp.com>
> > > > +  - Chester Lin <clin@suse.com>
> > [...]
> > > > +properties:
> > > > +  compatible:
> > > > +    contains:
> > > 
> > > Drop 'contains'.
> > > 
> > > > +      enum:
> > > > +        - nxp,s32cc-dwmac
> > 
> > In the past you were adamant that we use concrete SoC-specific strings. Here
> > that would mean s32g2 or s32g274 instead of s32cc (which aims to share with
> > S32G3 IIUC).
> 
> Yes they should be SoC specific. Really, 1 per maskset or die is fine if 
> that level of detail is known. No need for different compatibles for 
> different part numbers created by fused off features or package pinout 
> differences.
> 

If I understand correctly from NXP, the GMAC0 belongs to a common hardware
sub-architecture called "S32 Common Chassis", which is a common IP set applied
in many S32 SoC series, such as S32G2/G3 and S32R45. Therefore this binding is
not specifically for S32G2 but it supports all S32 SoC series who adopt S32CC
sub-arch if they could all be upstreamed in the future.

Logically S32G2 and S32R45 have the same subset *S32CC* but it doesn't mean that
S32G2 and S32R45 are derived from each other.

Regards,
Chester

> > [...]
> > > > +  clocks:
> > > > +    items:
> > > > +      - description: Main GMAC clock
> > > > +      - description: Peripheral registers clock
> > > > +      - description: Transmit SGMII clock
> > > > +      - description: Transmit RGMII clock
> > > > +      - description: Transmit RMII clock
> > > > +      - description: Transmit MII clock
> > > > +      - description: Receive SGMII clock
> > > > +      - description: Receive RGMII clock
> > > > +      - description: Receive RMII clock
> > > > +      - description: Receive MII clock
> > > > +      - description:
> > > > +          PTP reference clock. This clock is used for programming the
> > > > +          Timestamp Addend Register. If not passed then the system
> > > > +          clock will be used.
> > > 
> > > If optional, then you need 'minItems'.
> > [snip]
> > 
> > Do we have any precedence of bindings with *MII clocks like these?
> 
> Don't know...
> 
> > AFAIU the reason there are so many here is that there are in fact physically
> > just five, but different parent clock configurations that SCMI does not
> > currently expose to Linux. Thus I was raising that we may want to extend the
> > SCMI protocol with some SET_PARENT operation that could allow us to use less
> > input clocks here, but obviously such a standardization process will take
> > time...
> > 
> > What are your thoughts on how to best handle this here?
> 
> Perhaps use assigned-clocks if it is static for a board.
> 
> > Not clear to me has been whether the PHY mode can be switched at runtime
> > (like DPAA2 on Layerscape allows for SFPs) or whether this is fixed by board
> > design. If the latter, the two out of six SCMI IDs could get selected in
> > TF-A, to have only physical clocks here in the binding.
> > 
> > Regards,
> > Andreas
