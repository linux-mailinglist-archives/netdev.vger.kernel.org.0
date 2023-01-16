Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBCA66B510
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 01:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjAPAxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 19:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbjAPAxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 19:53:07 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2083.outbound.protection.outlook.com [40.107.22.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DDFBB94;
        Sun, 15 Jan 2023 16:53:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gp9AVTI2ID1un+1+lo9kt4djNQw4gZBtByp07SWa/tjIWZZ8lYH/mXXRLdw4x32U0M2WaMukPsabOYLDj71olRzwsYeLmacCLMkA8L/GcOtBAXBhAv2YIMRsAkeLFmhdULvfOEXTpjHB0lRjd6xmzaEJ7q44yAUHiaPqW9y9qpBkFy2Ke/1UU2l02RS8FtvGImqpI6gBU43mw/MXKRlzcxMqBXZ0cO2ChzuiK0qivr/bLwpgkE820zVXwMrcCuTG/W/jxOwTM3aKlF0aWPUegDnClchSbEG81IJ90HS4PZqorUIKsCzKUeA3BcTWr3nt1mYbk3UwkP3Ee0pudQ3XAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acRjCzVe/1DcTF8+eI/6R5b0b+81eBLJ2+LETFcBkWM=;
 b=asynNkf+rZFtABY0lUplM7jlbe+KN4KQHdrUu7R6Cyk9um3PZ5EhLSuvbe3AE8a3af9osI8r3R7e/FNLZFJAwnVlZkD2gFCwXWqP0IilSHe6VQb386+cTh+IWurWCeY1g9kfcdsZexM+TDC52T0Xqs9Uia6zmN9w7Fnik3nlhMMkl2uYJnWFRmMIGfngf6P/b/RYZix2qzweY/CMyvM+j9yk4hVrVMLjepNRNwKxGhd47p3AE71QtyF965qxo5a5kwdxoW2mVzNhb+qbhK++0wdILi8Gn4BNYQrJd5NxYLFFy9F3XtHOMAtcl1VJDNcMerhyPTLVBP/cTNuaI7GmTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acRjCzVe/1DcTF8+eI/6R5b0b+81eBLJ2+LETFcBkWM=;
 b=JkzDUIO0oCtETQtpLY+xfckiw3LXwe+dweJkBmA+MD5rHyzof/9IfEikCcvl1OZpMRGYJRL+9oVhNqz2ybEhRv4Op9HLU8CFoI7p/CxR7zzAdMk0wqjdCSpO+nDQmJ0tQKV29WH+2R9CNqiFFq8mG70I+XDmj+ICo7o0TansY5s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by AM8PR04MB7297.eurprd04.prod.outlook.com (2603:10a6:20b:1c5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Mon, 16 Jan
 2023 00:53:00 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::e203:47be:36e4:c0c3]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::e203:47be:36e4:c0c3%7]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 00:53:00 +0000
Message-ID: <9e5da8c9-9d82-b281-f086-2b0586891c35@oss.nxp.com>
Date:   Mon, 16 Jan 2023 08:52:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH V2 6/7] arm64: dts: imx93-11x11-evk: enable eqos
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
 <20230113033347.264135-7-xiaoning.wang@nxp.com>
From:   Peng Fan <peng.fan@oss.nxp.com>
In-Reply-To: <20230113033347.264135-7-xiaoning.wang@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0193.apcprd06.prod.outlook.com (2603:1096:4:1::25)
 To DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR04MB9417:EE_|AM8PR04MB7297:EE_
X-MS-Office365-Filtering-Correlation-Id: 177842e2-5e10-4d29-c406-08daf75c03e1
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZIJIk38nA4VtbvTq/NmC+6W7BqAvlelazHmcxNpksKyd9XhGktajdLCL0Qg5NAyJ32fkfr6hvm0oBoFjWxLCWmcYtfw32p5cY1jXMiY6Pt1E5u/8c2isg34wc72rhdFiaC+gnKnnd04yJjOO+xb0/YaKuqHNMBET0CP13mxF33V+BRzNyBwIW5wdBVEwMJdcVQ4HP99/fgTwCOy5JcI+fiLRUOIExJEhnt7UC+Q7ElhE8rfIoQqa1uzNaiwX1Qbw9OQBImdVj3VP/dBi/xfJ7yORuxMbA+nki2W0OgOMi/Bm9tFvv9Mkx2vBUDwvHhjY4vw2cyPtS1/P00sqlYtzAVZnwKBg7wzxyGEjtfgTy+omJcRqEAk29ScgM4MK97J/7lTEOVNFWQEF3Z8UMgSJZykMVFIS86xe5UshDxurPX7CotlMUtW1poTg9tqyJvS0DyIbFWGbHaawiH7O69SHs8t+Vml4lmwoQduCMF0VF+vSu81+3Vl2R4rVg/gBfWi1y6Uo5vmBhwCyF/ZhRVRT/zurYFlIti+3Q2rbjjQj0ZgALacnxA67jhSRUL5UW05Pgo32+htRW0gnjfRSVHd8JjcT4AZO0NJ8Q9VS6WKn/iasyPJ/vVF4QAs1b8SAGceCa+yNsElaDthS7sy4/KhV958WHkeQCVcLjKR4GEfCJQ7g1BjLzDyKGzRUZOZWyaX6u+klCBfGue9CCPdXZLisMeKW75FV+utWYOQEg2DTbzM92bKLpXE7n47+qnVcP1qSQ2zemFQCkQIxzuR75YgE6n+auBYVHTyU2Dgkq8lAj+4iXFZpjaJ/wPozU7Y4rW36
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199015)(921005)(2616005)(31696002)(86362001)(31686004)(316002)(8676002)(6486002)(66946007)(66556008)(66476007)(478600001)(186003)(26005)(6512007)(53546011)(52116002)(6666004)(6506007)(38350700002)(38100700002)(44832011)(83380400001)(2906002)(4326008)(41300700001)(7416002)(5660300002)(8936002)(45980500001)(43740500002)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTIxbTd3SWNpWWVoZmMzSFBkYkpTYjRtcDhKNjE2SjdjRFc3VkNxdUtCbEZK?=
 =?utf-8?B?QVlEaHlRZDVvNGgyUnljUTdyM3pvZit2Y2V6Rk5IeWZ6MDRxdnhIZ3NGWmh2?=
 =?utf-8?B?NmxTb1RJSnlrbS9LSE5LV3ZOUktSelN5Z1BsZkxzdHJtYkRsaHRzeXB6VDg1?=
 =?utf-8?B?bUtZMVl0ODVFOG1kaDkyM0Z0NU0zcUdQMjdnNk5IQ1Fyc2ZmbHh5U1UvRWhz?=
 =?utf-8?B?U0xRZm5ldU5wamliSUdWMkg0ODdXdTdNZXBVb0h3TTZCWGJVNGZLY2FoQzNS?=
 =?utf-8?B?RDBvZ3R4Wno5TnFuQmpxZGE5aGdyVk45NGY4QUlBM2VjSHlpQ3hXQkV1ZjZj?=
 =?utf-8?B?SW1SSUpKbXBBWXZZK1FWUDhaYkpCTE5Kd0tYTklGTGhwSkhsQzVFTm1UUmxM?=
 =?utf-8?B?UEZpNGtnNzBVLzZxaWdkU0dMSDA1THFLMEtIQUFqc1c5ZENxZVN4UVAvb0Nz?=
 =?utf-8?B?cUZ0TTliTUZXdkdqbkFlWHBIWHZWVGpkTUQ2WHhMY3YzSWlyOVZPS1QwQTVr?=
 =?utf-8?B?TDVQdnljOXRVa0pZaFVQdkp5RllrU1ZNY3ZrT3Nsdng1eDJCWDhPaWtJdDhh?=
 =?utf-8?B?NmhISlJKclhoQ213dU53Z25hd2ZQNytQQ04xVjl6N21TT2ZzL3FGSUMzOHhj?=
 =?utf-8?B?ckQ2T3RjbXFNRmlPN2QvZnZ6clVjNTlVYnhsKzh0bWxVd3hScWNFNUV6OWVR?=
 =?utf-8?B?Vm0yY3djTXRtTkxTZy85Y1FDREZyRkJOc21Wak95dTJGc0Z2MU9pYXIzTmQy?=
 =?utf-8?B?dkx6RndPVGVmb1VMbEVaUWdSV0JobVdoQTJtVnVmNVlWYXNrdzYrRmdFVXNR?=
 =?utf-8?B?RW9nVTZsTk1GMml2dlhLaEkxZXYzem5sZW1rNjBFUnc1c2lpRjJuS0NFR0c3?=
 =?utf-8?B?c2FKME1uaEt3QWhOVkw3RWU5Z1M3azUwK2NmUlNlMHJPZmJqWUZSZCtybUcx?=
 =?utf-8?B?cG5STWpFNHlkaDV2Y3dFN1ljRTc3RUVGc3JSaE5kU2tZZUdNampIU2czRWk2?=
 =?utf-8?B?bUdocEZoc3kyaGoxUmM0Q1hVTjBHV1RQTFJqZEgrdlYyQ2dOSFdFTmNoemND?=
 =?utf-8?B?eWYrYW9KY0FoMUR3YVRvMnNvVjBWTVBiRjBhamcxTnVMUHNESGg0NE9GRm1p?=
 =?utf-8?B?UldtQldkZi84bWJZYWI3RFYyZWt5d0JQdE9wbGZ0bnNoODBjMThpWWc0cXpQ?=
 =?utf-8?B?Z3RDK3NmTzg5WXE5aHFobU1JL2xQSWpuaWtFU0x3MXJGWVQrYktKNkZnTkhG?=
 =?utf-8?B?OWVNV29GL1FxN2hMMmxQRVVZVllLTUFVeXNPMnBnbnpySGJkZUhvTjBnSm5T?=
 =?utf-8?B?YTI1SDdQN2hPekVlRFdRd0traG9vUWV6Ylk3MVVuNVNEVndYa2UrMENVOVR1?=
 =?utf-8?B?aXo4YmJYTGFtTVkzdlZqbE40VWhkUmo5RFl2aVZDY3NMM0ZhUUloLzNzUG8z?=
 =?utf-8?B?MXJwenFIQkN6bnVZZm5rQ09FMHpNYURUNlk5aitGRWJ2bmpTcTJaQ0VhemZE?=
 =?utf-8?B?bDViUUFsQnduS3BoelV2eE5Uemd2WU9kVUllZXhQeDM3L2wyanlGN005Y1FJ?=
 =?utf-8?B?OWNGazg2NWtDd1BaWnVIS1BoTE5Bb0RWcGNhbzRONDV0dDNNNmxoVFNUSzl4?=
 =?utf-8?B?M3gzbXduU3RuT2h0c2xCN081N3dKZk5GZm95aTRjbFVTOWxkZGtLbVZ3VWtk?=
 =?utf-8?B?TGRSYVVuT1NQSysxcTV0QTkvcGdCSkovTHdKYndjL2VPOHhjdE43TEFPbDFY?=
 =?utf-8?B?VlFQYzcyNlgvRElUVFJwaUZBSC9jKzhPRkIzS2I4bWNEeXZ0b0lXVERhMENT?=
 =?utf-8?B?QlpmQ0xxa05zZC8zdGdvMFUxRGpiR1JXMzBzamtCUk5QNEFBQkg5K2tnVXVS?=
 =?utf-8?B?dVhiSW1nMkI3VElJd2pJNlhTNDlIdGFyR0xxTU1rZ2ZWRVVuZFZIOGhJZUVN?=
 =?utf-8?B?SFpwRnpOUGpjVVZjbjBGaWhMLzdUQ0pGNmhuQzdVSHlzRDNqL3c2V3UzbVVB?=
 =?utf-8?B?bHVvN0RIaWlPVkh4RzN1b01GYk9DYWtUbU5FT25Wcm9SMExjQXc2VHN5T2pa?=
 =?utf-8?B?SGZJVHBHbEh1Wnp0ZC8wL2VUNXJEdGw1THRnSVh6WU1YNTZxa0JGZ1luK3RY?=
 =?utf-8?Q?IBHF11rAx4eJRkcLB8ijtf3Ck?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 177842e2-5e10-4d29-c406-08daf75c03e1
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 00:53:00.6149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gtDmdjioJOgSxMLSfuQgySQ+ctIthjKVb2UBmjIKqusPCWjRYlEXNsieJHG98E+8vKL57xHJc6l+bGmcjjz3NQ==
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
> Enable EQoS function for imx93-11x11-evk board.
> 
> Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>

Reviewed-by: Peng Fan <peng.fan@nxp.com>

> ---
> New patch added in V2, split dtsi and dts changes into separate patches
> ---
>   .../boot/dts/freescale/imx93-11x11-evk.dts    | 39 +++++++++++++++++++
>   1 file changed, 39 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
> index 27f9a9f33134..6f7f1974cbb7 100644
> --- a/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
> +++ b/arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts
> @@ -35,6 +35,26 @@ &mu2 {
>   	status = "okay";
>   };
>   
> +&eqos {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_eqos>;
> +	phy-mode = "rgmii-id";
> +	phy-handle = <&ethphy1>;
> +	status = "okay";
> +
> +	mdio {
> +		compatible = "snps,dwmac-mdio";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		clock-frequency = <5000000>;
> +
> +		ethphy1: ethernet-phy@1 {
> +			reg = <1>;
> +			eee-broken-1000t;
> +		};
> +	};
> +};
> +
>   &lpuart1 { /* console */
>   	pinctrl-names = "default";
>   	pinctrl-0 = <&pinctrl_uart1>;
> @@ -65,6 +85,25 @@ &usdhc2 {
>   };
>   
>   &iomuxc {
> +	pinctrl_eqos: eqosgrp {
> +		fsl,pins = <
> +			MX93_PAD_ENET1_MDC__ENET_QOS_MDC			0x57e
> +			MX93_PAD_ENET1_MDIO__ENET_QOS_MDIO			0x57e
> +			MX93_PAD_ENET1_RD0__ENET_QOS_RGMII_RD0			0x57e
> +			MX93_PAD_ENET1_RD1__ENET_QOS_RGMII_RD1			0x57e
> +			MX93_PAD_ENET1_RD2__ENET_QOS_RGMII_RD2			0x57e
> +			MX93_PAD_ENET1_RD3__ENET_QOS_RGMII_RD3			0x57e
> +			MX93_PAD_ENET1_RXC__CCM_ENET_QOS_CLOCK_GENERATE_RX_CLK	0x5fe
> +			MX93_PAD_ENET1_RX_CTL__ENET_QOS_RGMII_RX_CTL		0x57e
> +			MX93_PAD_ENET1_TD0__ENET_QOS_RGMII_TD0			0x57e
> +			MX93_PAD_ENET1_TD1__ENET_QOS_RGMII_TD1			0x57e
> +			MX93_PAD_ENET1_TD2__ENET_QOS_RGMII_TD2			0x57e
> +			MX93_PAD_ENET1_TD3__ENET_QOS_RGMII_TD3			0x57e
> +			MX93_PAD_ENET1_TXC__CCM_ENET_QOS_CLOCK_GENERATE_TX_CLK	0x5fe
> +			MX93_PAD_ENET1_TX_CTL__ENET_QOS_RGMII_TX_CTL		0x57e
> +		>;
> +	};
> +
>   	pinctrl_uart1: uart1grp {
>   		fsl,pins = <
>   			MX93_PAD_UART1_RXD__LPUART1_RX			0x31e
