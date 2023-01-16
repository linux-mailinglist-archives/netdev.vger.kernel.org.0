Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1322166B513
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 01:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbjAPAxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 19:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbjAPAxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 19:53:25 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2069.outbound.protection.outlook.com [40.107.22.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAA01554A;
        Sun, 15 Jan 2023 16:53:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrLhCwhJKtrvF/hh2PWQQG2RjcTYreYbPAqipPjq4+JsP2mbSEa62XpYV22e62mtKHvwghzCERGzvEo1adUZcc8pP8J0JkXUxLdKDrOY3U1M5Rdhqbo8d8cT1khY8+FFltML1/nTNx6qD8ymz1sxi1wbFbPlmazFNRjDgVQkiDS6+hgPkzhYGNouO2IkeoJq6/lgJo7oZVzymAdmmx/VsNRXz/DaPVadl/p6UinKsY6O2AOv/FT5VZhXD2EVLO97zD78fGba1g2L4k1K/4LngW8YcPyD0Gw5tNNAaWSxdVYBbmgS4PS34nNq956kpXcadJkSFUbxsEv08aAeXjPF2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M0meuWK2Rr9tdTsfihMNx5t0428oN8Wk5VQzvyrS7Y0=;
 b=mu8nBhPj2c77gqiEp1+OqEAktQFKRSW0sF/Xe9fD8ZdxAnoluVTdChT2lOXxb2ZY6/pQdLvCJ7xiEdK0Ox8lwsQeuk30ipV80Rs2/1iEV5f/Sq0A1IXJBbH1qgTnvfVY0xt/xF6VOTT+lf13V5y1Z0e8n4NCjYm2QaGCGssMK4wmrEWwl/gK0KW4LG5GhRte31XaHRRnwS8s41Ze+kdIL4Jsx4neFyIqLxpt9BL5QS6Y6FNA4EJ4OjOEAmwMb7daa/HnYwgqjiytEu6nsjf0gZ77IgbBgDqTz+/OQEE9Hkd94D3DQ508G+4oNNtfMvBJFYazCYN0b9ExgsNJyKn6tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0meuWK2Rr9tdTsfihMNx5t0428oN8Wk5VQzvyrS7Y0=;
 b=ASC1H8/WqXygibLFeRL3Tb360bhq+483TpHSlL1L/QM92ndpVfdc1+WPxtTX1zrJrgmJ3W1g3RENx8zxWxAhY5KSnmwcV8VsaKmosr69oVBFssOJy9m8P4hFmXAHP2pC+7WlNljK8vlS1nGMUbc1aWhyKdQjJRzHoJA6MuKl3g8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by AM8PR04MB7297.eurprd04.prod.outlook.com (2603:10a6:20b:1c5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Mon, 16 Jan
 2023 00:53:20 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::e203:47be:36e4:c0c3]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::e203:47be:36e4:c0c3%7]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 00:53:20 +0000
Message-ID: <871bd24f-173e-9a32-2830-83eeace1cc39@oss.nxp.com>
Date:   Mon, 16 Jan 2023 08:53:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH V2 7/7] arm64: dts: imx93-11x11-evk: enable fec function
Content-Language: en-US
To:     Clark Wang <xiaoning.wang@nxp.com>, wei.fang@nxp.com,
        shenwei.wang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, festevam@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com
Cc:     linux-imx@nxp.com, kernel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
References: <20230113033347.264135-1-xiaoning.wang@nxp.com>
 <20230113033347.264135-8-xiaoning.wang@nxp.com>
From:   Peng Fan <peng.fan@oss.nxp.com>
In-Reply-To: <20230113033347.264135-8-xiaoning.wang@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::28)
 To DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR04MB9417:EE_|AM8PR04MB7297:EE_
X-MS-Office365-Filtering-Correlation-Id: 4658ff53-40d1-4eea-cfc2-08daf75c0f9e
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ZXNrLDvVI0kgPOeTgK7iSAzhhf0Tv/PINBxkejNkGteXw8Iy3olK0fnfkleT4D0CyPKUTAxzrGbf2GgDJ14hROR/jAqOG5jnTk0UGHe6NiCRJS4apdjbgPHvV+a9co1rf6XK44F9H0H8y8Tod4vOR6quH+SQ84nj8pXYFQqKPp7gKhFSOmyIyZYtt5n6oGCvWOXVVn1TGrJXM3OeD4OABd2zakM2UdVVSTnDvfz+aE8u3cyJlRBUGj8DnWBQORH4zrDYkbRC5GBeu+SZfFOddss28e1GeNO4wYo08j5mAeyJVCNYapvTk1iqGKWVAofmTE+a8k5UU+Jrp5G6iRkx4cimQVT6vL4vT7ELHpRhqbzPs5sit4wFRCWCZ1dnE4GLaFl7sffpqKPWcqbqPgC7Iw0xu95ylzrIuDg8bOQSxNuCIKLTOiBDZsslUbV13NlRRTVXpY9Z2aMtxhbLpIeNBuDrW0QSQUeQj2cETWpdSbFiDJa6WBf2DNX4e6/VKxwCrY0vEPP4UJfs1oSB/biEjAix4IzgJ1mlW52hJ2ep5XMj8AFp4ffOKc/tqT4ftdUlx92cB4G0Jl5I0Qfq0mN1W29/R16TeHrTyH0uwfMf/9szaIsX1dcZvhLkT0DjDNE+6HbbSpUO3iiDWXeVGSH6Yz830+fOQTW0b1lVcUSxolirD+TDfRYXDtaXEaIWZpIfaOmzqABtj/VSpwQ1kbKS+AOIuC2m6u/pTs+NjiOmkFPXcK5RjVHmHcALEmFcbDytJxfNq+/jE4dU6Weo5RiWmkk5G6UTqswJxU9nr/Zk1VLL/bWrXttI5dKvzZaLGHE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199015)(921005)(2616005)(31696002)(86362001)(31686004)(316002)(8676002)(6486002)(66946007)(66556008)(66476007)(478600001)(186003)(26005)(6512007)(53546011)(52116002)(6666004)(6506007)(38350700002)(38100700002)(44832011)(83380400001)(2906002)(4326008)(41300700001)(7416002)(5660300002)(8936002)(45980500001)(43740500002)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVhsVGZRVEJ0Lzk0dVVOSjdlOGZrRkFGaVdpOURJZHJ0VWRJZ1RVZ2lFVnZ0?=
 =?utf-8?B?eVNHamNoeWhjcE80MTI5MEZTVE1Eb24wS2NtZ05MVXlxRFVLODFIc3VCRzRa?=
 =?utf-8?B?SXgyNFc2ZU1TZXkzTzV2OXgvcUtBMWNGT0x3cCtOUGsvY1NmZlRYd3g1aHhV?=
 =?utf-8?B?RzZrazlLK0R5d1NuK0JVbkNTOWxia2ZML3g2bUJRcDFDT1hKQjNrUUhwVUlE?=
 =?utf-8?B?WGlybmwzbjJBZmU0TFBQVnJqcENacHlwQzl5QStEU3BCb0JNQ1c3OTBIQlo5?=
 =?utf-8?B?TnRCQmJZVDZIM1BoNFlSbEVGMjlZYUFlSHFEZjUzVmhYQjc2dWhVNDRCaDdp?=
 =?utf-8?B?S0xzVHk1bmNZd3JMSk5hR1o0aWdFV2c0WnVsaWpOU215VFpkR2phU3NPMWV1?=
 =?utf-8?B?QktUY0tHZmgzSFY5ZWpaZ1RJK1BjSkJjbXpSZ1hldEY0NDU3RWFRNWtqRytL?=
 =?utf-8?B?QkZIMmhTbE94WjVIZ1JMOURtZnpwQlc4T013bjkyTWZGdjdMUVkrR3lDWTZY?=
 =?utf-8?B?ZjFWVVZTUnFFNEJZQURiZEpieVJXS3VXYTY2QjBJbXI5azkxQ3JHNDU1aENC?=
 =?utf-8?B?cGZwdXRRQ3ZmdENUQ2U0eU1kTHV0QnlTZjlROWU3Z0hmQUVNRlQySnlyQWZY?=
 =?utf-8?B?SzB5S3dpWE9lNFRDK1RFVUZVdGUrMDY3S3N0NThhR0t1QmluQTQvbktNL1FJ?=
 =?utf-8?B?d3ZacFh4SjNlNFA1RGJGQ2swWjd5cHhMWFBxa1FZMlAyUkFMdW93L2g0Z1dD?=
 =?utf-8?B?UXBtRk5xeWVVN1hGRnlETlo3U2liVVUzT2JOVFNob0ZFV0M2ejN1V2pSTVBr?=
 =?utf-8?B?M1hOUlBlMGwwVkJCdk1RU0JrOCtnZlhWV3lVZjBjMFViVGRnSlBDN3pEeDBT?=
 =?utf-8?B?aDlsdGRjNm9NeWpaeTd2bHZSUVVpNmZRUnVCTTcvYjB6VkdUTCsxWmhSNnFz?=
 =?utf-8?B?MjRCaEhyOFFuZm1zS2orR0VhcTVBK2NpRjZvc0tMdG1LaTVXOElaYkhMUm1S?=
 =?utf-8?B?aWRVYUxHVHdxWUpNR2pvMlh2a3FkV21ERVZjRU9sMlI0THNjQllLZ3gybHRU?=
 =?utf-8?B?TnBWMnlONGV3dGVUSnNpSHNPYnlrTXhUdHVWZ1hKWmJzTy9uZHppaXhBblB6?=
 =?utf-8?B?QjRhNU1uUmpnM2NUc09MVzI2bGdXOGQ2UjJCemVoVFZEK2hZaG1BYkc2V2JO?=
 =?utf-8?B?RU5PRkJQeUsrNEVWZ1BxRCtlY1hsTDUxSnpXWkRxeG5YMkNNMHlQdjFBRUlH?=
 =?utf-8?B?T0Z6NmJic3I0MGQwK1Q3cHk1aTNadS9rOWhPSEVCWlkyUlIxK2lNNDZHRHFx?=
 =?utf-8?B?emc1THdDZTE3YmhDNXRhS2FVVm9LdC8xMmpobDhybHBCeDBrak5BVm02TTVp?=
 =?utf-8?B?SnNlN1B4blRMOE1vQ3hHRDVtSFU0ZjV0Sndod0hXaVB3akNSTGZBaGU1b0Fa?=
 =?utf-8?B?S2ZZdjlQZks3OEI4T1pGcXE3eGtLTG0wdmVvL1dwZWxING5scVUvRnliT0M1?=
 =?utf-8?B?aG4raElFZGoxWWQ3SS9VWlBjNXpVVmYvNExkT0xnSzluSUZNVDRrS1JBcjg2?=
 =?utf-8?B?ajM2TmtDZmM2Y0lJaThRekRmZTFyeWJZUEhDMVFQZHJhaGZFdU9XOG04Vjgv?=
 =?utf-8?B?K09ZL2ZTcG8zU01SMjE2eE1PbHdZS0tnNFBFUVRQRTFHWUcrSVBPTlRnVzd1?=
 =?utf-8?B?MUJRUG45b3hDdFQvc0RLVUc4QmpPL3ZFcURvbmRFZ3o1anZpZVRCQW5SY2Rk?=
 =?utf-8?B?aWlacUswTmZGa0N0dGZPVFo0K0pTanhCRzRHNmN0ZTI3ZWIvMGlqYklpbEVD?=
 =?utf-8?B?emRheXRtTDJRNExsOVdjazVhaWRrUVgyb0ZWSGZIQlVCdkJKRy9Eem1TR2N0?=
 =?utf-8?B?TlVxYVBDWGowazJvT0RNa21BV2RJUWZzZTJJQzcvZWRQRkNTdERlTEZHU3Nl?=
 =?utf-8?B?a0dlNCswZmpuVkJlY2wxSFIxMC93dHhUNGFodWc1VFVxUEh4RGdjWnBsV2Qy?=
 =?utf-8?B?OFBoWDRzL29vK0FnLy9PRytLN0U2d0hEdFJ0ZkJvRk8yRk1BOVBNTzl0NnE3?=
 =?utf-8?B?Q3AvL3BJWVdWZllYaElyUVdQekdtQWRHK0NHNU92RWVNY25ydUhyZDZkMzRo?=
 =?utf-8?Q?4oO2yYR1uRmzXSmJ09QZLball?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4658ff53-40d1-4eea-cfc2-08daf75c0f9e
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 00:53:20.0432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5b737eKG/9BY6q+f41iASh/pnQ0/2H/a/yLqkFLky5/7XKzCEo8W2zIveH6X3v4n1b8i8f4+Djk35Vfdn61Qeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7297
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/2023 11:33 AM, Clark Wang wrote:
> Enable FEC function for imx93-11x11-evk board.
> 
> Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>

Reviewed-by: Peng Fan <peng.fan@nxp.com>

> ---
> New patch added in V2 for FEC
> ---
>   .../boot/dts/freescale/imx93-11x11-evk.dts    | 39 +++++++++++++++++++
>   1 file changed, 39 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
> index 6f7f1974cbb7..cdcc5093c763 100644
> --- a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
> +++ b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
> @@ -55,6 +55,26 @@ ethphy1: ethernet-phy@1 {
>   	};
>   };
>   
> +&fec {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_fec>;
> +	phy-mode = "rgmii-id";
> +	phy-handle = <&ethphy2>;
> +	fsl,magic-packet;
> +	status = "okay";
> +
> +	mdio {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		clock-frequency = <5000000>;
> +
> +		ethphy2: ethernet-phy@2 {
> +			reg = <2>;
> +			eee-broken-1000t;
> +		};
> +	};
> +};
> +
>   &lpuart1 { /* console */
>   	pinctrl-names = "default";
>   	pinctrl-0 = <&pinctrl_uart1>;
> @@ -104,6 +124,25 @@ MX93_PAD_ENET1_TX_CTL__ENET_QOS_RGMII_TX_CTL		0x57e
>   		>;
>   	};
>   
> +	pinctrl_fec: fecgrp {
> +		fsl,pins = <
> +			MX93_PAD_ENET2_MDC__ENET1_MDC			0x57e
> +			MX93_PAD_ENET2_MDIO__ENET1_MDIO			0x57e
> +			MX93_PAD_ENET2_RD0__ENET1_RGMII_RD0		0x57e
> +			MX93_PAD_ENET2_RD1__ENET1_RGMII_RD1		0x57e
> +			MX93_PAD_ENET2_RD2__ENET1_RGMII_RD2		0x57e
> +			MX93_PAD_ENET2_RD3__ENET1_RGMII_RD3		0x57e
> +			MX93_PAD_ENET2_RXC__ENET1_RGMII_RXC		0x5fe
> +			MX93_PAD_ENET2_RX_CTL__ENET1_RGMII_RX_CTL	0x57e
> +			MX93_PAD_ENET2_TD0__ENET1_RGMII_TD0		0x57e
> +			MX93_PAD_ENET2_TD1__ENET1_RGMII_TD1		0x57e
> +			MX93_PAD_ENET2_TD2__ENET1_RGMII_TD2		0x57e
> +			MX93_PAD_ENET2_TD3__ENET1_RGMII_TD3		0x57e
> +			MX93_PAD_ENET2_TXC__ENET1_RGMII_TXC		0x5fe
> +			MX93_PAD_ENET2_TX_CTL__ENET1_RGMII_TX_CTL	0x57e
> +		>;
> +	};
> +
>   	pinctrl_uart1: uart1grp {
>   		fsl,pins = <
>   			MX93_PAD_UART1_RXD__LPUART1_RX			0x31e
