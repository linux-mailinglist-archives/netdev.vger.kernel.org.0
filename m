Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36B666B50D
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 01:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbjAPAwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 19:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbjAPAws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 19:52:48 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCAC6E98;
        Sun, 15 Jan 2023 16:52:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LYe6GtejFUjVKK9CcZrKGdxiWbCmKUefabMvdMQBQ0oC3YczTKbmQgyCfqeNtgRKsDqZGNOnCCfSVWznHGFY7V7PcDUT6kOaJR/c9inDk4FIvFPg/6RxwO7QtWvZerqEWHnVbIBZedQUMd7WWwOFgzbfBNPDX9rkJiK5cmKBRE4bEa12v+hh5rfoIMN9J6kJrvrCUk4jRkfL+hrDoEy2V3fZm3u+D5vBlSmgqUONYDT0JZ01RXG5Qv59FsB7UrYV6AqRzXwgbQhDFsRuxUwcOAG2iXCLm6iP133QJ7xsrWlx4DfoFtPvLye/jjQnCBoMpOKB0bt4SwrW2HhjgutemQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3VwmOClwi9D+bnaPcGDHxbn2Jtfz2c22kqGyzEb0Mc=;
 b=kIVqad3EzoaK87wq15dULzqBAdMyfjhU+EDL3QSKAyO+UUs/k10ozru3VRmKyBy3sm2Izdayjs7dYSbZJh0X+2Kf6P7L8HY9pJbpNdQVpTuYYVNfRBIK7G4G6o4S7/L5vcmiO8iMBbEpTX/jS7SpmT7YVrpdmORvT9Ulbd1wSmJAloOnTJJwKpFlmyZHy4N70vZUhkxxaxJVZMGe5GSIBC1NZtpvrjfRqbzK0/NxzjVOz9f2iXB30E+lA3JvC9qIPQJ060pznA9AUyjanLNkh/ITBtbPuxNqdnGaRzxJZ3vEm1yYtlaL0O/e7oeR/xyOIPDJgTq/jc9dFqRSNnc4Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3VwmOClwi9D+bnaPcGDHxbn2Jtfz2c22kqGyzEb0Mc=;
 b=ez0nGjfYkIcXOCFKdzLgWN8jxVyyRv5zFLBY05jzvN7r2avPuCCYU48S4Yl2id7PTej5RGpvewm81Og532JbjpLkJJry5G9nkolN8gNZNxNfHM8MjzmAe9Mdka8IeGFYJe6b4TnHj8q0vLIpfkURxQCU+wHe06ovb+U96VykByc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by AM8PR04MB7297.eurprd04.prod.outlook.com (2603:10a6:20b:1c5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Mon, 16 Jan
 2023 00:52:41 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::e203:47be:36e4:c0c3]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::e203:47be:36e4:c0c3%7]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 00:52:41 +0000
Message-ID: <5c413e1c-b0de-3f8b-d66f-eaf61ba647b5@oss.nxp.com>
Date:   Mon, 16 Jan 2023 08:52:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH V2 5/7] arm64: dts: imx93: add FEC support
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
 <20230113033347.264135-6-xiaoning.wang@nxp.com>
From:   Peng Fan <peng.fan@oss.nxp.com>
In-Reply-To: <20230113033347.264135-6-xiaoning.wang@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0019.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::6)
 To DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR04MB9417:EE_|AM8PR04MB7297:EE_
X-MS-Office365-Filtering-Correlation-Id: 000260e3-658e-4f18-ed3c-08daf75bf8ba
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FMk+p5KKF4uBOGkQOTR1uyD8K04Xn3BgldTwwX6GVLUcEJfTXlpZPPXDwhXu4B9mzsqZs7O3Ehuv73OwDIgDAkInkAXcozEvZLUiD/MA2b+qPN7vummMhAHUIg6ZZXTSvPrYMyzSPE5veiGPUkyh7wKFeRWuDpT+r5VjAC0QQEkRri+zZa4IvUD2/xFCNvQtaXcgXqzz6LlsXJnPcpoXrCED3cyBVWFy34SuX8pybEEj9vOsOqG3c+vGIl4mbP75RT2MwGunUZ6SoltuMn53W11XZ0Kz2RIgwklv9V0S7eUxPSKKfGcA/3mZx7YJHAYl9oVzBoKCG6EtOp8NueJDVy2fWKuJdgFU30ocd/5qSwPzK+GARig+HZ/RJARW8NbMXf9TSzMa7srQEDAF/1zvW3b1g9A+V9DrvlA96BnD1FLedVxtNg3fSC0MSG+S58vlGYPcUqYBPCQi+0dHpVft4DTlVBQc6Fh1RSU9wZ2mufF+PWzLDMLE/bLnwbtwAmNAB6AVYbHGYG9jAzkGP/H0Sme6uI/l1l+CKmkDAI9F3Y3dUvvquP6lEKgooikj0cNSEq0q+FTyelOlNoLU4cVghtt1/BJKInga0mjMw/JUMriNgXMAbJOs5ejjfdCtH4XYbUj//MEPdCWyDrK/f83JDt5yCMpIwclgqXqaO9Od/AgsAIVIf3bg9gqwGfY05SnoJFmHvsuK43J5C+YFv9VkU8KTaBtZHjT7pNFz0f6iT0MN7hdx87sEvVtUMQbysCi5KTwqtA7HXvCIfC60bqSNqffZ3JBfVSAs1SqArwq598U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199015)(921005)(2616005)(31696002)(86362001)(31686004)(316002)(8676002)(6486002)(66946007)(66556008)(66476007)(478600001)(186003)(26005)(6512007)(53546011)(52116002)(6666004)(6506007)(38350700002)(38100700002)(44832011)(83380400001)(2906002)(4326008)(41300700001)(7416002)(5660300002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aE1sVU5wSUxqSDkwTERBR25obEJUVFN4MTBhSTkxWWloYUtYQnBwTi9mU0Vz?=
 =?utf-8?B?cEtVdktWN3B5WlJjdWF5ZXpwTzdYSnQ4dUFWcEwwcjVrNTdSVFRwcXRGRUVU?=
 =?utf-8?B?SDd4eHI4WUtNMTV4ckJTNXFQekxyeUI1c1Zva2ZNVEJkVlBkbTVuOUVoZkNO?=
 =?utf-8?B?MUM5UkNYVFdZZ1JHdVdKNndMRGFySVhpczF1b2MrQXM3OWg3U3VTOFQrNUxL?=
 =?utf-8?B?bGhCZHlDZWdJd2x2dEwycklUbGx1a3BlRDUzbmQrNWl6S0gxeGYranNPQVFV?=
 =?utf-8?B?aHIyTC9zMEkrNUlEaTN1dm9PUzd6VUJuSXlVY0FJTmdsN0UrbEhCSDEyY3Ex?=
 =?utf-8?B?QjFHdHJsMVhRNFNwaStNbitteW9zWnJLaEVVc1ppTFFqcVQ0VVAzWVFYRUJv?=
 =?utf-8?B?VnJaU0VVL3VlRUxWZ2tXV09wNFNOTGNMTDFJeVFoSVYxN0hrYnc4S1IrWGhN?=
 =?utf-8?B?bklJU1hSZ3dmVmtJbzNPdmkvUkRENU9QQjVLUnpKSXlxbHRLZDF6V0RFUVdJ?=
 =?utf-8?B?UkcybU1aYW01aXFyWndNNkNnSVEvN3JRcXhmNlBZM1ErdGtKbi80ZEViSitU?=
 =?utf-8?B?blByajlBdi9LNitOaDdBeVVLM3NXMWo4TG1KcXkveENONkhPWnNmTE1lN2d1?=
 =?utf-8?B?ZEs0dmh3Y2tSSlZlQmE1a0VwaHFXbmphSEk4Yks4U0dZRk1YR2NTQ1ZPTVgx?=
 =?utf-8?B?UWwzaUgwQW85U0l4dkFrTzN3TTRSOFZWQnJLOGhpNkdlVTNXWWNjSkZZaEcw?=
 =?utf-8?B?K2xkR1o3WWp5dmFwNXZvaGNJZjk2d1FMcm01UDE2bjRna1ZhWmZYYlN2aUpk?=
 =?utf-8?B?eU1SOENqUCswSDV2SUFuOFRHalUybmJUTFVxNWg2NzNSdHd0KzhCMUdrY05k?=
 =?utf-8?B?SDdEK0R6K0tNdVV5TWdIV3dTZnJkWkFMYjRuSU5ZbDZXVEY1THNabC81RmUr?=
 =?utf-8?B?c3RKK24vbmZLK2R1Q3ZNWGR5cTFwZGZ6RG9OdGJ4a0dMTmxOSXl4TVp4azR1?=
 =?utf-8?B?UHNCTndLNXUwdmJwMXR3RWVBQXQveDErcWlHRUtKOUw2RGJXNlpEZnRXbnpI?=
 =?utf-8?B?MG1leTh1UUFMZUhjR2Fyd1BGeTlsYmFSckZXdGpDekw1SWlhanBvVExqcE45?=
 =?utf-8?B?Z1MreHZ1b2FCcHdvTnF3eXFiRjVlQms4MzQrNjM0REdMUXg0MFdJdTQ0T0RB?=
 =?utf-8?B?Qy8vYW9BQUlaR2J5THNDZXpJd1pSUjlwOWRZOW5vOUZmNTFmdytNbWExblVK?=
 =?utf-8?B?b0RpbUF6TE85d2orc1RhcHFyKytDYnZ2V3BqUU9rTWsxQW1CQ25INEd5eG9W?=
 =?utf-8?B?TjRUWm9pSGhnM1VsVVdVOFJlVDBKeW1nUWtJVXBNTDZWUmljbVN0TG1IVkFX?=
 =?utf-8?B?aEFHYVBBSFVPcHZxa0lWbWlYWTM1bzhCQ0NJOC9GYnorUHQ0UDgrY0piTndJ?=
 =?utf-8?B?YmR3Smd4c0ZPWFJTRkRVYllSMGxlcHBLMVVWQm5DV3FmaU15SW8wbyt1VlBB?=
 =?utf-8?B?c2xzekY5eklxQllSNGQwSTg3NG9FNXgyUVN4ZFRFeGtVa1ZZeTlMaGdXWTli?=
 =?utf-8?B?US9PUk1lbGNHUTdGUkRWTGtjc2JlVWg1aDZEL1pRUHhKM2kzOHVGNHFQY3My?=
 =?utf-8?B?QStjSTdjUzlVMndpODBhZmJmRDR2Nkg0Tit0N1BxYWNWd3orTE8zNHhCZklh?=
 =?utf-8?B?NElITCtXMjNuUXd6SlUrbk9NdzhiNHJsQW9ScTRuU3dKQnNYVm1pMWI5M0g2?=
 =?utf-8?B?MmpvUXI5MjRkNENIKzdoYzFMUlVPUnU1MzdJbDJSV04vcCs2RkhMak1sSkta?=
 =?utf-8?B?M3BSaUNDVllLSGRKR3I1SFMxaWRjQUNsREM3VGhQM2JUOXNGVmhKZm9jWGZ2?=
 =?utf-8?B?b2N2ZHQ2Q2RrMUNMQ2drTzFTelNzakk3VWF4WG5haDJMZDBZZ0tKVmEwaHNw?=
 =?utf-8?B?MEhRTDdpSGllcDN1aHhrQTNuRTlsdG1tWU1GeDVQcitjUCt1YmREWEZpZWY0?=
 =?utf-8?B?eEdjbzZzcXd3VXNZUWJZR0hpb0ZHWlRYdFhUeEk1RHZUdjlQVy9KVGpZcG16?=
 =?utf-8?B?ZE84cWl2UEFvUG9zMzBBbVkyVXI1V0NxNmh0SkFkTlFhL2UvK3VwLzIrZ1VK?=
 =?utf-8?Q?92MFw6xHMsUWcnx+StEKi34Cd?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 000260e3-658e-4f18-ed3c-08daf75bf8ba
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 00:52:41.6424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G5XrhE/v1Ii+0ByL7dWZolMgN4d0JaK44CgT9XZutCxIqMT2voG7tVljIxddjM5Sa811mMNJQ5z8zeXpzCdatg==
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
> Add FEC node for imx93 platform.
> 
> Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>

Reviewed-by: Peng Fan <peng.fan@nxp.com>

> ---
> New patch added in V2 for FEC
> ---
>   arch/arm64/boot/dts/freescale/imx93.dtsi | 26 ++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
> index ff2253cb7d4a..12e0350ad35a 100644
> --- a/arch/arm64/boot/dts/freescale/imx93.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
> @@ -586,6 +586,32 @@ eqos: ethernet@428a0000 {
>   				status = "disabled";
>   			};
>   
> +			fec: ethernet@42890000 {
> +				compatible = "fsl,imx93-fec", "fsl,imx8mq-fec", "fsl,imx6sx-fec";
> +				reg = <0x42890000 0x10000>;
> +				interrupts = <GIC_SPI 179 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 180 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 181 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 182 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clk IMX93_CLK_ENET1_GATE>,
> +					 <&clk IMX93_CLK_ENET1_GATE>,
> +					 <&clk IMX93_CLK_ENET_TIMER1>,
> +					 <&clk IMX93_CLK_ENET_REF>,
> +					 <&clk IMX93_CLK_ENET_REF_PHY>;
> +				clock-names = "ipg", "ahb", "ptp",
> +					      "enet_clk_ref", "enet_out";
> +				assigned-clocks = <&clk IMX93_CLK_ENET_TIMER1>,
> +						  <&clk IMX93_CLK_ENET_REF>,
> +						  <&clk IMX93_CLK_ENET_REF_PHY>;
> +				assigned-clock-parents = <&clk IMX93_CLK_SYS_PLL_PFD1_DIV2>,
> +							 <&clk IMX93_CLK_SYS_PLL_PFD0_DIV2>,
> +							 <&clk IMX93_CLK_SYS_PLL_PFD1_DIV2>;
> +				assigned-clock-rates = <100000000>, <250000000>, <50000000>;
> +				fsl,num-tx-queues = <3>;
> +				fsl,num-rx-queues = <3>;
> +				status = "disabled";
> +			};
> +
>   			usdhc3: mmc@428b0000 {
>   				compatible = "fsl,imx93-usdhc", "fsl,imx8mm-usdhc";
>   				reg = <0x428b0000 0x10000>;
