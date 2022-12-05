Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40AC6423E0
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbiLEHyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiLEHyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:54:43 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2040.outbound.protection.outlook.com [40.107.7.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1925F10FD7;
        Sun,  4 Dec 2022 23:54:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TAx45ndAEZYznqdbicokhnbOW+OD6KKzP0npCom8useOJPKKEfCCaaNsop+s8s9f+yfy14Bd2yrJJOAwp+WKvhabowD4VN88i/q4Q5kbVw60+zsUFaVlpM31NQMNM/hiHo71TKSmslSrrkIGWmzsCImFuXb+KXFFj0Kt0OSHKH7kVePHIFaqcs4hrBJoFf5lSiLJHnflwDksKOYbV9ty8H2e1oknebRKjr14vjC5h9HHeIBd9FydQFWDT32no51vfv/0mR9gasd3I8bHSgkOwAkUaKHa7QmTZ7vpT+TNK7R3+CRm0dCdUjF3ZADukr0u3xSB2jFJMm9RcMl+qf34gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ud4n+04yumSNy52CFgo2Mm0GZMQ81V9ogPJbLvDCznw=;
 b=VhXzWEfxznnppJCGo4JpexFbxUX7GHMkxADde5uvv3RIfGqsAYXsZuCazppwYqCSJvA6m/stZPLn3ZckQVuvjmuhmYSE03JuQC0nM5pUMCF6yx2fHalo0MD4lcSNBAX3A25cKyo/tc6ypIc688WlS7qhQGPxgdJaPKnX42UO2fRKzpZHhnr5H/nzXLIF4yDusNIgl1Tigw0XdORVlFZFaay1tYn1HZ3mbaUn0Jy2hIN7za6Y06bhzk84KkItuX+Gu0oQ4KZUWVjqaPloylMQX8loNRZGxTVb+zVbZ6mtvxwM0+rkuMJRV5+jSyqNXv+s4Qp4kgs1xQ3C78upjY2zPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ud4n+04yumSNy52CFgo2Mm0GZMQ81V9ogPJbLvDCznw=;
 b=gEbPWcRoqziihxrvQzJxxkqmv24gaoFq/MO4Ko/Tj/XRokw67Z01LGbCI9+maVf8p8bIdCjmDFNNiWoOBKXbpuaxi0PB54+3XGSacTvrcvEv23t7zi8yrFNIx9HiQLkt8FHo5xZIGuX7xs9qmzkR/nl0uB26ta8VeA5I7zl9sj5IeWgC85RNGv+zcQ85pyOvtUglcDZBy82vQivGjnAA9c8lwaZBe5HNi3sYcziR/3K06alT0cQrvs9uY7C6dIz8RHE/LJtRGWvRazd15Ozb8kZ1rfZNcGZXmIaFvCWl6TyB0n45qbAIPayAplCZSkWDq8Hlzu4qVJZ2P04XiVdiHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by DU2PR04MB9051.eurprd04.prod.outlook.com (2603:10a6:10:2e6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Mon, 5 Dec
 2022 07:54:39 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::28d6:1b8:94d9:89f5]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::28d6:1b8:94d9:89f5%7]) with mapi id 15.20.5880.011; Mon, 5 Dec 2022
 07:54:39 +0000
Date:   Mon, 5 Dec 2022 15:54:16 +0800
From:   Chester Lin <clin@suse.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>,
        Chester Lin <clin@suse.com>, ghennadi.procopciuc@oss.nxp.com
Subject: Re: [PATCH v2 2/5] dt-bindings: net: add schema for NXP S32CC dwmac
 glue driver
Message-ID: <Y42jqDiiq+rOurV+@linux-8mug>
References: <20221128054920.2113-1-clin@suse.com>
 <20221128054920.2113-3-clin@suse.com>
 <4a7a9bf7-f831-e1c1-0a31-8afcf92ae84c@linaro.org>
 <560c38a5-318a-7a72-dc5f-8b79afb664ca@suse.de>
 <9778695f-f8a9-e361-e28f-f99525c96689@linaro.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9778695f-f8a9-e361-e28f-f99525c96689@linaro.org>
X-ClientProxiedBy: TYCP286CA0096.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b4::12) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|DU2PR04MB9051:EE_
X-MS-Office365-Filtering-Correlation-Id: 14bd3f60-2704-4997-3fcd-08dad695f5d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DrxdRZ7+a0BzqPSVlPh9Nzs4jKBT+kz4oxfx1BWZ8aUVfWIkOj7ASka30LZz29vN/j1dSOYkRQ/y6lTzgR+nnKPowgTRX5ARKvBMESs3GO9wWV2nGVU988uI3e6CRvL1dOwhSdiUQmfQxE9N+IKCaba/4ZKFiA8fr8eZeV+d7OPZVKwikew6efXEfhrUHEAhXn2TaQUuCdyN9JZ3AqKRKrPiDelXJpIQdBICLXLrUcLL2nIBJYsWN0GPEU8qPIDSaaHBeiCMr0El9xIHFz39VDaJIVeH5zyNI7ne+EropMwObW5tR6OGAwjmeOMgPWBsRrwqU2qMifQynu7PYw1J1z7BAElkMXI/9TWS87QPoWSlMybAZI2jUqHhGjjuHA5LAVSCWdpbyO3a1rF988Vc8idg+jWzGglj35qiYENHMZI4oMzdRgKE8zWb+WkHNj0wKL81D4mJeiDF+9dMPLz2oTxKHZj+QIHv3ytStb+NM5KUAL5eJdnXq22gPdK32H0DXcOB0JtW2QaCk/GlaSdTb22kO6Fxm3xmhBsvDGZ0BxnnFpmtMgn5jPcR7QAGR1kOknzuCYC+qg9KcZt5vwJTgiU2DV8c0rStLd9XMmekTRvW8apaWaOjbX8KlFV3JrRJsgkOzRr8im9gn+nqqrYQ8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(9686003)(8936002)(2906002)(4326008)(41300700001)(83380400001)(66574015)(66476007)(6512007)(5660300002)(186003)(6506007)(6666004)(7416002)(53546011)(86362001)(33716001)(66556008)(26005)(66946007)(8676002)(6486002)(38100700002)(316002)(478600001)(54906003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?d0RE69Fhr4i/PTp3HDQ/w8F3N4mwe027hH/4pHSVQGOawAFiHXSqiX78AS?=
 =?iso-8859-1?Q?uzFacTEwTCyjfRnN7txGF0rPspmPXDsfUqip2ihK8WikpWEZBHJDoouCc0?=
 =?iso-8859-1?Q?eOk/qnLZiiouTJ3Dkd6Tw10xG+SQxvAGheJV5xCGW1TUhVe91p2+te+0aQ?=
 =?iso-8859-1?Q?2KsT4EGo7EiqOEgPj5LPFUQZcCxlGw3KzPmuNuLM5sS1lcvj1UbVP+42Tw?=
 =?iso-8859-1?Q?df87N131PfENeb5HuD1ygC/a8+UsVE7mv6yMmsC7X9IPc44BI6PN8/9Fa+?=
 =?iso-8859-1?Q?NqGVWihaWjTN/tWXV2u/raVXDMgNfEQpuSyv6Av0Q8WdGkAwEFLgoXJd9I?=
 =?iso-8859-1?Q?1TV/O9XkjeuqY7GJV7t7kW+7iQ4A/dXbIvxBDKKYTDGDlgwX0fQ4Wxfp/c?=
 =?iso-8859-1?Q?rQ3aPfgHfYU42YJ2duoJw6QV1EQmzoZ3npFBnTiAus0xCVbtoJBqnuFJQR?=
 =?iso-8859-1?Q?PbLGPaFadXPUugfhWZXtw+aYEVze0XajHwXIIbpbHmWxtUnUyJy57Q8Fbh?=
 =?iso-8859-1?Q?uB6svBqwnL8+LxU9fRbOAszcmNMHpidu0J6DJImJ6v3e10L9UFy4ei8Uiz?=
 =?iso-8859-1?Q?5Ve5ldx9DHu4nCMiO8WfwvKUOXjOQFbiKVkrCRraBvYWRmmOKmEs7iXx8h?=
 =?iso-8859-1?Q?+QwFNgAFZhJNLIEf8Ag3XfHF+pesDo7VildQ3BZGL1bzJZ1nZGLe4kZ4s3?=
 =?iso-8859-1?Q?l3L+fzGGUzjJJAp8CcYI47btDD0b6yN67ofmp4/VyrQdIQO7yKULnR9ikS?=
 =?iso-8859-1?Q?4tQl7NWLL0L9b+MTJ5G3TlIEvRXFp3TjL7D1RgNnpSzAUV4VQ2sDBsqOMl?=
 =?iso-8859-1?Q?jTd7uvbG+OtqmRl7XOplbi+LE0FgnDACJV1UmjFkAYRDL8m5pZJwTHSCUc?=
 =?iso-8859-1?Q?IcBtPDSqSgrtNm5+WD6qO/3qlPby0l4h4Lq+CfrmIi6BgNm6cZubBz0MJz?=
 =?iso-8859-1?Q?cqvqod48WOWGL1pS5PuqbxnuC0T66vgc8wSYKw+LCg449ZPCDJ7+soqM+7?=
 =?iso-8859-1?Q?c6avqa7enmYLAuMFjv0M3msixFeR68cwl5yIjdr3PGJWaJDtE7WtlFBEiN?=
 =?iso-8859-1?Q?8L7193vVwYu9sHCAIuv+6lw6nJTsNMPRj7gVS0vjJmSY6Gy54XYwfEHN5D?=
 =?iso-8859-1?Q?7D/5TYwikwaus1QQy5dJL+4YrmrG8Dw92IjLfMh3oO3F4eNEme/ETEUXbh?=
 =?iso-8859-1?Q?d7dVufL/Kc2A7ESmsAzeuY7oLNrR/RzqITQxgmD0RZxXJiaSiXS+HdPlU2?=
 =?iso-8859-1?Q?is5vVQg9MAvtU4l0RcC/VPS8j5PwYfDRHOPpFu7qYuEZDL7cjBtPiEvY2x?=
 =?iso-8859-1?Q?FMdbSFJKgcwfYK+xbs5dSxgcb9iEb/PLbvJOv+NgihXgPGMR5O93I9OjBG?=
 =?iso-8859-1?Q?5xE1dB/V5aCiNWphVtR0LzlLA2szG7ICV7kl+efrBVbEv6atttXtlOjy5j?=
 =?iso-8859-1?Q?g7ahRCbQrKFTf3FxAuoBvA/GVeiVnjVhsr3bZbtkFbzXk/s9zAmVtH8pc+?=
 =?iso-8859-1?Q?uGKgyRdWjqodjfK6/OZxpGQWO9hzUPS7Ec8r0KcJA79t7hXGJBANyjuDhA?=
 =?iso-8859-1?Q?VKVPFP4MtDAo4BHtUjAUORJdoZzc3xcdFgoEn62F7qqQ+jubncvim2c9Jr?=
 =?iso-8859-1?Q?0+VPWTvwOb9CI=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14bd3f60-2704-4997-3fcd-08dad695f5d3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 07:54:39.2517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RV4XrC+RfNzaRTOrlB8KXcZt0XPi2HHm0gBY8oFjqzFdqyrOtl1mpjcaFPS0zjme
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9051
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On Thu, Dec 01, 2022 at 11:18:57AM +0100, Krzysztof Kozlowski wrote:
> On 30/11/2022 18:33, Andreas Färber wrote:
> > Hi Krysztof,
> > 
> > Am 30.11.22 um 16:51 schrieb Krzysztof Kozlowski:
> >> On 28/11/2022 06:49, Chester Lin wrote:
> >>> Add the DT schema for the DWMAC Ethernet controller on NXP S32 Common
> >>> Chassis.
> >>>
> >>> Signed-off-by: Jan Petrous <jan.petrous@nxp.com>
> >>> Signed-off-by: Chester Lin <clin@suse.com>
> >>
> >> Thank you for your patch. There is something to discuss/improve.
> >>

Thanks for taking time to review this patch!

> >>> ---
> >>>
> >>> Changes in v2:
> >>>    - Fix schema issues.
> >>>    - Add minItems to clocks & clock-names.
> >>>    - Replace all sgmii/SGMII terms with pcs/PCS.
> >>>
> >>>   .../bindings/net/nxp,s32cc-dwmac.yaml         | 135 ++++++++++++++++++
> >>>   1 file changed, 135 insertions(+)
> >>>   create mode 100644 Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> >>> new file mode 100644
> >>> index 000000000000..c6839fd3df40
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> > [...]
> >>> +properties:
> >>> +  compatible:
> >>> +    enum:
> >>> +      - nxp,s32cc-dwmac
> >>> +
> >>> +  reg:
> >>> +    items:
> >>> +      - description: Main GMAC registers
> >>> +      - description: S32 MAC control registers
> >>> +
> >>> +  dma-coherent: true
> >>> +
> >>> +  clocks:
> >>> +    minItems: 5
> >>
> >> Why only 5 clocks are required? Receive clocks don't have to be there?
> >> Is such system - only with clocks for transmit - usable?
> 
> Any comments here? If not, drop minItems.
> 
> >>
> >>> +    items:
> >>> +      - description: Main GMAC clock
> >>> +      - description: Peripheral registers clock
> >>> +      - description: Transmit PCS clock
> >>> +      - description: Transmit RGMII clock
> >>> +      - description: Transmit RMII clock
> >>> +      - description: Transmit MII clock
> >>> +      - description: Receive PCS clock
> >>> +      - description: Receive RGMII clock
> >>> +      - description: Receive RMII clock
> >>> +      - description: Receive MII clock
> >>> +      - description:
> >>> +          PTP reference clock. This clock is used for programming the
> >>> +          Timestamp Addend Register. If not passed then the system
> >>> +          clock will be used.
> >>> +
> >>> +  clock-names:
> >>> +    minItems: 5
> >>> +    items:
> >>> +      - const: stmmaceth
> >>> +      - const: pclk
> >>> +      - const: tx_pcs
> >>> +      - const: tx_rgmii
> >>> +      - const: tx_rmii
> >>> +      - const: tx_mii
> >>> +      - const: rx_pcs
> >>> +      - const: rx_rgmii
> >>> +      - const: rx_rmii
> >>> +      - const: rx_mii
> >>> +      - const: ptp_ref
> >>> +
> >>> +  tx-fifo-depth:
> >>> +    const: 20480
> >>> +
> >>> +  rx-fifo-depth:
> >>> +    const: 20480
> >>> +
> >>> +required:
> >>> +  - compatible
> >>> +  - reg
> >>> +  - tx-fifo-depth
> >>> +  - rx-fifo-depth
> >>> +  - clocks
> >>> +  - clock-names
> >>> +
> >>> +unevaluatedProperties: false
> >>> +
> >>> +examples:
> >>> +  - |
> >>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> >>> +    #include <dt-bindings/interrupt-controller/irq.h>
> >>> +
> >>> +    #define S32GEN1_SCMI_CLK_GMAC0_AXI
> >>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_PCS
> >>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RGMII
> >>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RMII
> >>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_MII
> >>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_PCS
> >>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RGMII
> >>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RMII
> >>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_MII
> >>> +    #define S32GEN1_SCMI_CLK_GMAC0_TS
> >>
> >> Why defines? Your clock controller is not ready? If so, just use raw
> >> numbers.
> > 
> > Please compare v1: There is no Linux-driven clock controller here but 
> > rather a fluid SCMI firmware interface. Work towards getting clocks into 
> > a kernel-hosted .dtsi was halted in favor of (downstream) TF-A, which 
> > also explains the ugly examples here and for pinctrl.
> 
> This does not explain to me why you added defines in the example. Are
> you saying these can change any moment?
> 

Actually these GMAC-related SCMI clock IDs changed once in NXP's downstream TF-A,
some redundant TS clock IDs were removed and the rest of clock IDs were all moved
forward. Apart from GMAC-related IDs, some other clock IDs were also appended
in both base-clock IDs and platform-specific clock IDs [The first plat ID =
The last base ID + 1]. Due to the current design of the clk-scmi driver and the
SCMI clock protocol, IIUC, it's better to keep all clock IDs in sequence without
a blank in order to avoid query miss, which could affect the probe speed.

> > 
> > Logically there are only 5 input clocks; however due to SCMI not 
> > supporting re-parenting today, some clocks got duplicated at SCMI level. 
> > Andrew appeared to approve of that approach. I still dislike it but 
> > don't have a better proposal that would work today. So the two values 
> > above indeed seem wrong and should be 11 rather than 5.
> 
> You should rather fix firmware then create some incorrect bindings as a
> workaround...
> 
> Best regards,
> Krzysztof
> 
