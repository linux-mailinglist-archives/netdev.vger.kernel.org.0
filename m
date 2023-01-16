Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387D666B50A
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 01:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjAPAwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 19:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbjAPAwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 19:52:30 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2042.outbound.protection.outlook.com [40.107.22.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507996A7A;
        Sun, 15 Jan 2023 16:52:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brkX2kHV2ZLEPfxvzzjB9EAXgQp7B4QK3wFgFa/+zLQtTZmfh4C3QJMUIhLGg6XJMZxHpc26SFIWaqzZiKD5MYqk7VVrxG+1pAleyoajHkxDQM9uYi5myuDFbhsOvxeHHGnWhBfFIrxcUE2Hix/sBXGTUXnhskbb4qsVuyYwDPX041x4T6N95lB3S3Ge3Fjdx2hpKWez+DYshH2VZmjFKZKPwTtqcIgnCg5x0xysoEFqm+Kk9CA6BU7GFtDNkvNCak6QEdKu4Djt6CNBA04ZXBFddkUhJGFm8kBQPzvYyloL+ZP1fb41hoYoSukoah0Coh8DID5LFnqokT2/zRrZ+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h9HGRpwPZ4Xs//rM2G6XdW3EJGAvY6jI0bZQ5z6ogNs=;
 b=Jn2tLNbWny6O8kHKCbgwN8S5qhimzirROLIo5ZuMzK3balyNjwKSGOzn+e6C1V0+vyVrc8JvCutvih0nGmUW+t/NQ0cdGMbFdL45H5Frot6dPk/zB2aW6VvI22H3uKN4e7RBjEi74AESbTH7wraurGEpoX4m5bmHxrP3kTzRSg0yzI2gEaI4aGBrX5r/l4W5P2L+qLDrsI8ni33UMG5ysMUKHfTGC7DwxOdtNfko2UQ+aW/r0A2VUzQfc/F4qdHK3TxvPcQSNTpvNedL6+p1gGiBLZPxwVh3y4B/ljav49O9/+GYo7lxAzWPDC2UIHP2yXCHsB1exUZ+OC0a4biN9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9HGRpwPZ4Xs//rM2G6XdW3EJGAvY6jI0bZQ5z6ogNs=;
 b=Nw/PqnPm0QzUoYrce9MVkvx3uM34yJj/SZx1iNMZF/02MHA1wMtqC7bT4LTIQp/liVvFcqCmgmMUHuLhOYzYTB+CXTrvIiGtKAYCYKRGHZTPPqxv7d8IWTE4FMLakWSxXyxX2chD9Avsk6nKKU7+miTmaiYoh37k+qnAQHW9xSQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by AM8PR04MB7297.eurprd04.prod.outlook.com (2603:10a6:20b:1c5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Mon, 16 Jan
 2023 00:52:26 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::e203:47be:36e4:c0c3]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::e203:47be:36e4:c0c3%7]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 00:52:26 +0000
Message-ID: <8c08e078-8ec8-b4b4-7f86-b82bcb79fedd@oss.nxp.com>
Date:   Mon, 16 Jan 2023 08:52:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH V2 4/7] arm64: dts: imx93: add eqos support
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
 <20230113033347.264135-5-xiaoning.wang@nxp.com>
From:   Peng Fan <peng.fan@oss.nxp.com>
In-Reply-To: <20230113033347.264135-5-xiaoning.wang@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:196::20) To DU0PR04MB9417.eurprd04.prod.outlook.com
 (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR04MB9417:EE_|AM8PR04MB7297:EE_
X-MS-Office365-Filtering-Correlation-Id: 26044e05-2090-4f85-0739-08daf75bef85
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d038GW/LlhFRydNVtB85Y4w+xtSJuBHLZLB7mZm14tjjZAcpIGVBVAoUQFMCbXjEY9LW4frtbGwiJLFIyFvY9Gj7UENs5D5pxIM1H9Fs3pWY+riAIf/13LNiJDyozFUVvLVqpUAiZXE6RGhwwaa6cA/3ZWzbfme/loPr/QolF2BALkrNQMnEgHX+FSx2pzB9wkU1CVi1CHRaSZHDwFcfQ+3yXzyIWCAVaY/XODRlPZ/y2oCc6jrlzELl7gDUHU2nEiF3sHKRNJON5//KkyPJlIdykcigbw7WBDzVuEZ5rXCwa+dyJ7a8/Hp8bH07jVE+ZIgoQ8/mqPHolup8v4gMg/O8hndzgN9RxhQLo7SGivyO6W7zxvQ9PHhW2TTaznmiI4OS0NbvEE7v4+hlu2dE2QcGwQmeS38qKBTtHNcoXsSVWsnQKGeOSUuUdFx7M3EP3MnU2MWXa9VCC+6pdn5gnBvS/mHl4b9dmIFWm+8NlQaeUx8gG6fp0lmxiTqH0tbZf5yLHp2xPh4Uz5pxLLjDwZa7R62rAXQ4OpzHFxJsX8eE8hwknIJBOb9oqcY+RC65n2wkn106lPv3dH8XihbUUN+VkaNlQBupH6jnVfh3hUhxGHkC/+sBakRiAdGcXDQvse6wfI9Jb3GRPgUnuBf4kcTj4hkpz79ndvTFynRhevafbjRv9LG9AZSov/qnzBbaUezKqCR1W3HHBZKNbXpliYKJUmZHDh/dFlTE6ZTA0No3a21XSTvsowhs17KJvI08YxCh88mmgK9FKWIytidn7HjPVpWa+61/MDOSeIIHR4Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199015)(921005)(2616005)(31696002)(86362001)(31686004)(316002)(8676002)(6486002)(66946007)(66556008)(66476007)(478600001)(186003)(26005)(6512007)(53546011)(52116002)(6666004)(6506007)(38350700002)(38100700002)(44832011)(83380400001)(2906002)(4326008)(41300700001)(7416002)(5660300002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3BQUVFrZ3E5bXhscWxFZFFZdnBRaHBMRTJCK0o2eUI0WGh2aXJTM0FRNFlq?=
 =?utf-8?B?Yzl5Z1BzamVHM0ZlcVlOaUM1azRiQ0UvRGdkV3RCYVRDZkl4Z0VuOGw2Zm1K?=
 =?utf-8?B?VVpncmJhc2RkZmYrZUhhYjBNRmt4ZFk0QjhXQjRPMmNuSU5BYnlLaSt2Y1BB?=
 =?utf-8?B?Qml1TElmUE1zYTZFblY5aXFKVnFXRlRueTlTaXlpUFpxZnlRRTNGZ1hlck1B?=
 =?utf-8?B?ZXYybXNEcHJCdHhTaGdaa0ROZ0dHeGo2MmhmKzlTdVNXQlZYTmZBR2k4eDF5?=
 =?utf-8?B?alIvelNaSHZjb1pZV0NSNytkMVBhcHVZWE9CR05pNmNSK3hCbmhFWG5BWGdo?=
 =?utf-8?B?WkpUUzkyVnBuUGowL0swNjVaTUp0ZSs2aFp0WXU1eGE5eWJwN3h2aEFIN0c3?=
 =?utf-8?B?dWJDeWZkMitycFp0clptNnZpa0ljcWNibFJHUmRyL2poNHlRRDMxZUJTd0FP?=
 =?utf-8?B?ZzBRNjQxVnc5b0FSR2M1WmM1T25ZQm04clpZMk4wZW4wUllMMGxiVUR4VzZY?=
 =?utf-8?B?V0VQRis2eUZGTGlFM2FCSmd1UGhZTjdzdUw4azlrY0x5c3RsTXFuL3lqVXVt?=
 =?utf-8?B?TW9qc3E2V1lGYkp0Y0V0RzUyWXJTVXBTdDRHTEVuY2swRm5Ca2lQaWJVVXlU?=
 =?utf-8?B?NXMzRFd0cUVtM0h6UHZLd01YWXZCR3hlOURvYUNTb1Z3bk41bFh1a1ZmWk14?=
 =?utf-8?B?ZTdHRkVoK0QrMFl5SlNJZUdpdGYvUmw4RlhROEF3Y0NmRURna3RseXlORGtu?=
 =?utf-8?B?bWFOZW1ObURjbnQ1VUpCb3J4dTlxS1lwaHBYcHdTY1VjWnkzZVpGc1lEMDZw?=
 =?utf-8?B?Z013QnFjQnZnZzNXaVNXQnF1bmZNbmk3UUtBd1FIVFdPUWgrOW9JUDhrdFRq?=
 =?utf-8?B?ZXBIdGVmNWJxUFUwZDhnS0FrOEx6LzRRczBtdjkwYkRncElJbk9RaWR3OWJD?=
 =?utf-8?B?ajhzcXJCVloxYmVzNjM0YXkwRnNsc1ZNQXRpNEJTdjJDWllCVlFudmZGRHpw?=
 =?utf-8?B?eG5sREdoaFk4OTRLN2FWcFpDSDQrbHpmeGg3RmhodFl1V052bENxaDZnMU1j?=
 =?utf-8?B?OTM1dUdPcUJ1UjE3alF4UHZnOFp1dVZGQTMzVHFsYW8rZU41Q3oxNHFBZS9z?=
 =?utf-8?B?UW92YXJpTnBOZ2tvd0RhV3dOMEdDZHBmQ045QzJveG9jWkZvaVljN0lUeGNu?=
 =?utf-8?B?aDlhS01GSjVMR2EyNURhYThmU0QrREY0bzYvcHhPdzBRUlhBeW5ScEVjdnpS?=
 =?utf-8?B?M0hGaEtZZGJtYjVxZXhkek9mazd1QVdJck8xd1BVWTBXaTJkT3F2T2tOZFF3?=
 =?utf-8?B?MTcrK1JiU1JoOXM1TkowMkFFdjJHTHIxOUI3c0lNSEI5b3BoTy95ejI1N3dj?=
 =?utf-8?B?WHQzZ2kvRDRzbTc3M21XUkdITkVGWDlyUGlKb1RTaU4vL2xLdTFTWWVkRnBK?=
 =?utf-8?B?ZW5mNkNyT2dzV3NtNHBlTU9oeWRHZUhkR21ROXlTMnJGc0JqVkJ2MmtBVWdR?=
 =?utf-8?B?Y0kzQkgwM3VhbzBRMnh0Rlc0bHN6YU1XRWxnQWh5MlpRd1FIejQxd2hsS0NB?=
 =?utf-8?B?UWtNRE5iZTBxZWViaFA0eUdIS1l2TXpmaVo0TlJDUDVwOGxxa1VKcFM0aTBx?=
 =?utf-8?B?b3owTDhaRzBDYi9BN1B5YzdGd1E2NVBlR0JPS2ZveEwvWmVKRDdBK3RmbDZW?=
 =?utf-8?B?MGVjcU5qd1RWaVJoVzJBd0JSOEV1RTF5dWdvYTNsYUljUTFPRzhxdWNUaERt?=
 =?utf-8?B?cmw0MU04Mjk3WUpOQWlMWm5QWXd5WVpWNXVwMUN2Q3p4UnFwN3FmQ1htTFUx?=
 =?utf-8?B?SVEyc2VsdWZiMjFLQ3E0bWFuL21zNFhFOWloOVJrcUlhTWM2dER5dndvSE5K?=
 =?utf-8?B?TGRJNFNEYm1EVTBKaS9JWEhGRXdBYU1rZTJDWkhxdlB5dzg0Z0hEb0lFLzZn?=
 =?utf-8?B?NUxPWCtITlN3SWNrbWx1Q3ZLWVBpdW92T1IyOHVodVBtdWQyNGxTMTJFRWtz?=
 =?utf-8?B?WWdFUExCcWV2eUVLRTNDNzVnQkIvTXE2OFdtbm96QUlEWVBPczFWQ2xyRyt5?=
 =?utf-8?B?YTRYZGFOSzVxWDhTNzZDcU9QSDZDdW5jQkVsZ21melRQYWZuaWQvT1VyaWZo?=
 =?utf-8?Q?BmJhhSQ5U/7rcms2geIkboU/D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26044e05-2090-4f85-0739-08daf75bef85
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 00:52:26.2164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UluKYo/FqtrTzakuiNyuNeA7cJMyJkJaRdKQXbywqSdeiy7Prh/6Lp6fg4HlIiDajpZUg6fRid5JknaSd54N9g==
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
> Add EQoS node for imx93 platform.
> 
> Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>

Reviewed-by: Peng Fan <peng.fan@nxp.com>

> ---
> New patch added in V2, split dtsi and dts changes into separate patches
> ---
>   arch/arm64/boot/dts/freescale/imx93.dtsi | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
> index 6808321ed809..ff2253cb7d4a 100644
> --- a/arch/arm64/boot/dts/freescale/imx93.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
> @@ -564,6 +564,28 @@ usdhc2: mmc@42860000 {
>   				status = "disabled";
>   			};
>   
> +			eqos: ethernet@428a0000 {
> +				compatible = "nxp,imx93-dwmac-eqos", "snps,dwmac-5.10a";
> +				reg = <0x428a0000 0x10000>;
> +				interrupts = <GIC_SPI 183 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 184 IRQ_TYPE_LEVEL_HIGH>;
> +				interrupt-names = "eth_wake_irq", "macirq";
> +				clocks = <&clk IMX93_CLK_ENET_QOS_GATE>,
> +					 <&clk IMX93_CLK_ENET_QOS_GATE>,
> +					 <&clk IMX93_CLK_ENET_TIMER2>,
> +					 <&clk IMX93_CLK_ENET>,
> +					 <&clk IMX93_CLK_ENET_QOS_GATE>;
> +				clock-names = "stmmaceth", "pclk", "ptp_ref", "tx", "mem";
> +				assigned-clocks = <&clk IMX93_CLK_ENET_TIMER2>,
> +						  <&clk IMX93_CLK_ENET>;
> +				assigned-clock-parents = <&clk IMX93_CLK_SYS_PLL_PFD1_DIV2>,
> +							 <&clk IMX93_CLK_SYS_PLL_PFD0_DIV2>;
> +				assigned-clock-rates = <100000000>, <250000000>;
> +				intf_mode = <&wakeupmix_gpr 0x28>;
> +				clk_csr = <0>;
> +				status = "disabled";
> +			};
> +
>   			usdhc3: mmc@428b0000 {
>   				compatible = "fsl,imx93-usdhc", "fsl,imx8mm-usdhc";
>   				reg = <0x428b0000 0x10000>;
