Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F254766B521
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 02:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbjAPBBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 20:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbjAPBB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 20:01:29 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2083.outbound.protection.outlook.com [40.107.247.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D284B769;
        Sun, 15 Jan 2023 17:01:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+7khAyvVK+BQv5leBi8d+qX1UGc5Udq2fGx2PawMbnPSsNjx9iSvH8DayXCQBkLQhpJcFRJXdUrVly6xRqLlUMxZCLyIwnso3ztVDCi99ESi5kFk+3/pLP9okRqOobaybonG8AF4paCxWyLay3bppC9agRuAX/PVfjEYixMoBTTSQWTvAKhGA6Bt31MScsDEAhHEAcdy2VSrj1A5Bnj94JLPPZmjlRsildijpl3BVjWoBRjkZeyQ/k0GgGO3MyzMQRTKAAlEFRWG/F5aX5G1a/b6mytns0uZzB+CGACeGFCzkdtoz1lEjrfAJO0IelsQfnEoNGZuu/f4cJZjbf8qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9WMjt+j4IVZyN5da+CqVbt5nbY67edfbkwei4gPUkiE=;
 b=BIJkWx2tUjai4wkylhbq9bAh0hyjmRm2Tdcb7ByM9QLAESMq5xgQQTTjgjZHrIgmA0XmqMuPlYH0Qr0f8i+86UaSxt7Uw0kRTrR+xDS33TjBD6ZJzHqYOMSPFZ2rJnZ2ZA1r7iH9sjcH2hiWquipl1IeUsYGIgcHuRFauXcDxUvSe/C8lRykTw6SqbcAX8Wh5TEGdYtgrihDxPSK1F9bx26lvvSsbx8vJ70EgIs/ikDsizDeVieAsklqowlLWFtVTADz0SBa1pHJhAAkpU/kYGYewMtO++MWg1gqtWFomJmMUb7w4d4rni9zNBWfXMFUHhOoeEXs52jrwBhwXuOU1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9WMjt+j4IVZyN5da+CqVbt5nbY67edfbkwei4gPUkiE=;
 b=IlgrqqaE0Nk2Ffs9L/AD5x3Nlrd4EY+78sK9ErpANnLiy5uDk4QXhqmVjxb5bKIZmug2jtBG/cLMoW/7QB89RDY/UKPFm3tXsm3KNYQ6m6c33Fmb4VRCHbP6wf/41ThNu2DW9B01xs3YMPFFCPuy6v9COamzmbIHHGk2P89XRgc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by AM9PR04MB7489.eurprd04.prod.outlook.com (2603:10a6:20b:281::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 01:01:24 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::e203:47be:36e4:c0c3]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::e203:47be:36e4:c0c3%7]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 01:01:24 +0000
Message-ID: <76716956-3f15-edd0-e9e2-bdba78de54f9@oss.nxp.com>
Date:   Mon, 16 Jan 2023 09:01:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH v1 05/20] ARM: dts: imx6qdl: use enet_clk_ref instead of
 enet_out for the FEC node
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Abel Vesa <abelvesa@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     kernel@pengutronix.de, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
References: <20230113142718.3038265-1-o.rempel@pengutronix.de>
 <20230113142718.3038265-6-o.rempel@pengutronix.de>
From:   Peng Fan <peng.fan@oss.nxp.com>
In-Reply-To: <20230113142718.3038265-6-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0113.apcprd02.prod.outlook.com
 (2603:1096:4:92::29) To DU0PR04MB9417.eurprd04.prod.outlook.com
 (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR04MB9417:EE_|AM9PR04MB7489:EE_
X-MS-Office365-Filtering-Correlation-Id: e9d071e0-fd58-4221-ff7f-08daf75d3066
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w5sZ8w1M+PmgvFGi+muKeKyg+3LNLCSnBuh9tKesJ1LC4pjZRBWDJA8yW9pzCtc0pxrarFfjdtlLxxeGCRxiitlktWxrQnpdIdX8AeiH5IxqTmwf+wy3fDm4NQogaiwVU7dxh0BUcE2qKSLNaToJN/CdBA1PG9pdmDTAUcJK/jIDdySNGow/33oCX91qYvSvRBVON230Kt9LiN8ezhIAzud5eZXGWpuNVCYosZ8bsnR7AYgx/Wzefgzp9z69lu3KsE1ZD7tMm2O7zH/Jz0fkIOvr+PLifH89mvSlM8aQDeGgFdjVkTHnwpoxPfGUSF0eDlvkqpM1s2oW243qIj0zQamKbT78LrhpbOaxnjL1Q1HbT4XYuiVra9QPuuHLf7DMwklo414KdL15RByOkchyPPqn7IH/oJDEY7qmD+GIi8zijl2TFm6vAjR5PRSFkxkAxfx/MJXn5bzgt+NNqtv+TmGmqAmLF1GvNVg77KaexwuOrCqtXhqwniQalZ6PA4rjCZkABKhWf//jrqxl5c+EkCx9yqXtpcpLJtCH4PMRxRpTA9Y41/HUJ3myvfvgxZhvQ9KJJopShc4shNz9dUaw+DCQyGR5D6WeLiy86hcusm/lotQYhu2JYgwAe1BOwiGn1zKxfO6USnlNmCAizUF9SuItLGa2ATXm4g1gHjbdAmevXurUl9n5m1ashj8iMSGTDSWqv6d4qxUKYqkARMEf/xpH22Bwcvz/lVy7AHHlKypksTVmueSeLec+7vS2vQGYP8iK7yhTKbkukuBWcHAmQ2tLNIy0Skn0RS2Wpp0tbEw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(451199015)(31686004)(86362001)(4326008)(44832011)(8936002)(66476007)(66946007)(31696002)(8676002)(66556008)(2906002)(7416002)(83380400001)(38350700002)(38100700002)(5660300002)(478600001)(6486002)(52116002)(110136005)(54906003)(316002)(6666004)(41300700001)(2616005)(53546011)(6512007)(26005)(186003)(6506007)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFNMZjBNYk9iRDBKcGdYMVQwRlJHUXVjZFp2VlV6MEZGaStxSjdHNEhEWTRt?=
 =?utf-8?B?M2xPMVRzWmVIbWV0VlFPQTdRVWI4NXNqdERKQ2FXV2JtcFhydnhOMldNQmpL?=
 =?utf-8?B?eTNvVkhyOTZ4RGdWNzhNTUZYdGtzd1dFOExvc0NUbXZTenVqdlJ6WG40WnZu?=
 =?utf-8?B?NnNWa0ppcWtRMGFaTzduQnVZQktwVHpVRkI1WS9ya3pRUm8rdVZQK2pqam80?=
 =?utf-8?B?QlV0dEhhZDB4eEtZOUtMWnJwbFE5NW5CT1g5cjVEVTFXSTBLVzJGam5ncUJG?=
 =?utf-8?B?Qi9xQksvK2tCZVZoMW9qN1RESUxHRmRJNTVYaDVEVTNheDh0bkxldm9mbUpl?=
 =?utf-8?B?cE5SRE9xVzdhZkp2K1ZlZDUrMHhSRThoK2g5RytvL3N3RlFVZU05RjdMN3pY?=
 =?utf-8?B?VVZoTXdxRDFyN3N6aHNMK0VKeWMvWEdrcnNTVjROVW1GRVNlYlVhQjM1dkNh?=
 =?utf-8?B?L1R4VGdMMitWbmlzdzVjOUtDR2UrWDdscElSUDNpOFlKT01iUmlJMEVpUk5B?=
 =?utf-8?B?THgvbXcxdUI3RitaeXNnMlpGSUZuL2FMUW5qS1RuK3BpTlZFZHl0SXVWUWpv?=
 =?utf-8?B?ckwzcnNCNk9RK3Z0RFo3SWxGcGtWcEJWYXB4M2d3cFF1cThQVUVGeXlKeWdl?=
 =?utf-8?B?d09PZmdib1FmbGNXN0lISHEwRmN0RTRnTks2RnVxQThsZTFWMnAxbGt5TkxP?=
 =?utf-8?B?R0pzTnZEa08wV3MrWkpBZlh6VHVuOHBrNmJSajRYM2ROeDRob0xTckl1MGo1?=
 =?utf-8?B?RW9xM09EajF1M1BFTU84ZTVSNEI1MHkxZDlVeWZHa2ZKUG9KVHE5MmdJNXJq?=
 =?utf-8?B?UnQ4MkRjV1R5UWFXN2NRWEFTWlVUdnAvdWg0c0M5RENINXVoNXlGR3ZyS3Zi?=
 =?utf-8?B?ZFVsK3NOcDR6QTRUVnhTU3M0QSt5SnVkQW0yeitMdnY2MzEvK3VwSmd6MllG?=
 =?utf-8?B?bWZ2NjRkRTZXQXVtbDZuUE45Rm1yeEl4ckNmOW9sUGE0RHdEOUo5QmdoY1ZO?=
 =?utf-8?B?QTUrbE5ieEErMXdoVG5JMHFWeGVJZnNsaTlTUldQZGk5eGpTYUhVcUJET3Y1?=
 =?utf-8?B?R1lVUlpSTzZNSnFLU1Q0aXI0TkpVakYwWWRUb3FNWEM0YWhkRzVsT3JnVDJG?=
 =?utf-8?B?M3NGd0QyU0ovQ2IzRHRjVDQ1enJhMHNENEg3WnIrQlg5NHRaQ3pxdy9sZTdW?=
 =?utf-8?B?UVRzWWw2aFNyUFQ4UnFtYWxjMHZaZCtaYkMrR0M1MnNsVDQ3bzZhVk5vcmxv?=
 =?utf-8?B?MlZ4M05WQlY0U0hhbDhTdDVJZkx4WER1N0VzRWJ4RlV2RncxMS92bnJweDJ2?=
 =?utf-8?B?ZFM2Nmx6Rzkwck4yTm5UalJUY1pzVWlubHVtMnJHazQ1T2RhS09KdlpzYkZS?=
 =?utf-8?B?TlZVRkJSaldnV0JHem5iTHZLZWhXYk1XL0hjZnN4blF5ZWlXaEUwTk5vcTNy?=
 =?utf-8?B?cCtkRWtJZUp4TG5TRXE4VG5HS0F1bWVxaEdDR3g1VWVGVEQ5SXZNbFI4WGdk?=
 =?utf-8?B?N3ROTzN2K0l0cU5TdXJpSGd2aktGbENrRm51K2ZYV2N1YXI5cEQwdWFEcm9j?=
 =?utf-8?B?ek9Sb2JpeFZ4aU1vWUhsdGRLY0poWEgwTklJWXJFaEVlYVR2Yi9JTmU3K2ha?=
 =?utf-8?B?b0ovOWtOcnFTRTdYcUJQL3U5WWpIZCtyczlUcmdvM1JOR29EZkZPMGhFOHcv?=
 =?utf-8?B?MFV6SXZGby9WZG5XTlBwOUMzRU50QUJ2RXdWVFVRalhlU3hSU3phL055RUl2?=
 =?utf-8?B?RW5pNTd4ZHNSMklmbTc0MDNHbWRQYUhoYXBXbm5aYm5wMEo2MDVxTWVGQzhs?=
 =?utf-8?B?ZUZDdVVXNGtMR09QazRDU0ozSVl0cHF3ZzVsRWRRRlFyNnkzS3h6d2Zsdkhw?=
 =?utf-8?B?THRJSDJKRCtFUWhpVUZjWXE4OUZZNzhDbUVQYjZTeHpBTSsrOFREMmFNSjBj?=
 =?utf-8?B?OEhiNjZLZy93dlhoVENzL2tPVGo0ZHdhVnhPK1FxSFZ2WWtZTkxZTll5THJE?=
 =?utf-8?B?YWtFa3pVYVZaTlIwSmtGTEZzNFNWVUlxaGxQT0h1NWlIMTk5UmZrTUtWNFBQ?=
 =?utf-8?B?YW5oQjRsci9XVnRUeGlxK002ZHZtREFHRXU2aGtJQXNKQythK2RpOFFGNjV4?=
 =?utf-8?Q?9TWhUZRDNUV05Df1Yu1Wz6jCT?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d071e0-fd58-4221-ff7f-08daf75d3066
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 01:01:24.5560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TyHMA5gJAHgZVdy+YFet8vAKR4O3aGPCCbSZ1LhnXh/9gLrHEC3f9nptBj56uKbkiT/VFNo6cNiWHF7J9WrWEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7489
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On 1/13/2023 10:27 PM, Oleksij Rempel wrote:
> Old imx6q machine code makes RGMII/RMII clock direction decision based on
> configuration of "ptp" clock. "enet_out" is not used and make no real
> sense, since we can't configure it as output or use it as clock
> provider.
> 
> Instead of "enet_out" use "enet_clk_ref" which is actual selector to
> choose between internal and external clock source:
> 
> FEC MAC <---------- enet_clk_ref <--------- SoC PLL
>                           \
> 			  ^------<-> refclock PAD (bi directional)
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>   arch/arm/boot/dts/imx6qdl.dtsi | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> index ff1e0173b39b..71522263031a 100644
> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> @@ -1050,8 +1050,8 @@ fec: ethernet@2188000 {
>   				clocks = <&clks IMX6QDL_CLK_ENET>,
>   					 <&clks IMX6QDL_CLK_ENET>,
>   					 <&clks IMX6QDL_CLK_ENET_REF>,
> -					 <&clks IMX6QDL_CLK_ENET_REF>;
> -				clock-names = "ipg", "ahb", "ptp", "enet_out";
> +					 <&clks IMX6QDL_CLK_ENET_REF_SEL>;
> +				clock-names = "ipg", "ahb", "ptp", "enet_clk_ref";


Please also update fec binding, otherwise there will be dtbs check error.

Thanks,
Peng.

>   				fsl,stop-mode = <&gpr 0x34 27>;
>   				status = "disabled";
>   			};
