Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC8C66D3EB
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 02:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbjAQBqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 20:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234512AbjAQBqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 20:46:22 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2079.outbound.protection.outlook.com [40.107.15.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5EE1E5FD;
        Mon, 16 Jan 2023 17:46:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlMaqVSYLpReGCSYuXDHI25I3nq6SymFHVNe33LSQKv3rNMTev4Lmhu+RndyE0VNaQSKBUBQdA9sGfOJz0tSZC4KssavzghcrkvVxSGIr6+fLUURoBVy8+s/BhTzZeIDCCfBHXXcnGaFWKp5c8VtTNuTbSixLZkbiAJPBi1rs6WRtL92BK67PxBCP5zO5Fct/I45VP4bKDKTNpw4OXlxNavdGcgMkdcqr4/6J8tQ1ZZQrlzzWR5cqEu1DwhyfoTCBp4eNjJsDYLkCk3ivm3Cq9eXVawxTAL8Vj/SID5gmcyzxe/niWL+s9wDe5hxbq0XH4fHwDl9Np96+1kfsHhE2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=di7vQrJbnMYg26LKt2XIkDL95oRq6ul2wzEnUcDnWmY=;
 b=hl+pWAcHV9FlXW2FrXrKhKiKN8khGNPGLCtGFMxXeNfoMes34ISY+gVYD5oi8ek922JKlQwHbWF7RUKFjn2VOna3y71J6A/kDbU4XTtx+6qnmO6wJBdPj6jBg/X8ejBK8pv9j0w/KgnKUlZBX3aGilAy54tLZjH7/g5cKDSnog4+a0wedL+HvTvXMkDfQR5Pshz1jwsuJG2OVA+/QvkBoB2gGrU31rv36wbdXUhOu4Er5KKuA0T0eT0p5aUgVJVY9lFp/d9S8I7+TXsUwVldH+AMup0sBFUYHejwGKzqTN9JmtPXol0LlIBOWIP7HtUR3moDSWqcq9+CeuhLhImOrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=di7vQrJbnMYg26LKt2XIkDL95oRq6ul2wzEnUcDnWmY=;
 b=SR9d207BE++9NRXtpOHrr9a1sO3pRsPRbeBLYzj8EWH79sFMcE9A6J2p48hNRFjyuNQ3LGXdZRFqpnZpyKoTP/jezeqwj17aFxB7ljJLLpWlrjwdfR3lRZ2rVYkCNcBFk/Mgnv6RrY+Uj1m5axa4kUdWrKaeBgbdH7U5z785D2U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by AM8PR04MB7411.eurprd04.prod.outlook.com (2603:10a6:20b:1d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Tue, 17 Jan
 2023 01:46:16 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::e203:47be:36e4:c0c3]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::e203:47be:36e4:c0c3%7]) with mapi id 15.20.6002.012; Tue, 17 Jan 2023
 01:46:16 +0000
Message-ID: <279205f3-0e89-a66b-7446-5acbfe18e8d6@oss.nxp.com>
Date:   Tue, 17 Jan 2023 09:45:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH v1 05/20] ARM: dts: imx6qdl: use enet_clk_ref instead of
 enet_out for the FEC node
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Abel Vesa <abelvesa@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        kernel@pengutronix.de, Fabio Estevam <festevam@gmail.com>,
        linux-clk@vger.kernel.org
References: <20230113142718.3038265-1-o.rempel@pengutronix.de>
 <20230113142718.3038265-6-o.rempel@pengutronix.de>
 <76716956-3f15-edd0-e9e2-bdba78de54f9@oss.nxp.com>
 <20230116052622.GA980@pengutronix.de>
From:   Peng Fan <peng.fan@oss.nxp.com>
In-Reply-To: <20230116052622.GA980@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR04MB9417:EE_|AM8PR04MB7411:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e3cfe8f-254d-4967-9886-08daf82c9e69
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GXbpM6Vy1Hj2i2SThHIAEEiub/pOi4rpqRwmuQvqobvOR2C/9t2bUCKCleJ8e12JdFElYpe5/8GNE1mIpX2DbZNSWCXjf0jSbuAsFatraWqoKAvGVZ2BjWPRVpkYe5QjzlGt0Zx4ikAHkNiHCf5YfGJ06oTN8xk0eTzKao6Gfs7+OJ8voO5nVp7/voWeHGobPeq+dw+vPenwy1ImVxfNWpwHDB7ygHSnkJ1zEZA2npwpwynWq2wq2vjNIKSUOUrwo8oZkUiOqXZ2RJhi+TjjpItVlnuAH/PEg9JwRlvFZLrC7wV3Pc5+7OueHLjx8+EZWx0tk3V47ISlJkJ6uO4FHk/sNjh63uP4W2fgCxT8RF2nNqttBlcN0fjQengSbhjGcEROCE0uQMf7amdrLDMBm9s2NFrUNlCQY9Uekoc4Zx/+98eB2bQos7uf39JXIHzmjQ5wY9yJejE3/lmOz4TRvda7LuyFETfModRYTAY7AbnimwGU37MZUieNjzgyOfZJ4kCNzx10PxQ8sG4O9tw/xsptd/h9nNhkG5YxP/63b2xpa4woaAwnO2PFoG2wa77eOXugg4BAEpXEjiVu9czbt/jtvj8uC99TKYP9PDn67a1l4HeTLcxbGuQGf1Kl0aGX0nWShsnGHj9V39GZRs71WLowDu10cfMO14G9+35her8wFVoxTToEoV77EsiPKC++hzQ6tslm4Ww3gWAgwPGgK1h2bB+N44FGLuZZffkN1bm9pORY6bel606PvFMzIFWGYn6h+2UmL9sqmBZYIVghUVIS+oLHWYoXQVi/ohsvG98=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199015)(6486002)(478600001)(52116002)(38350700002)(2906002)(38100700002)(86362001)(6512007)(2616005)(83380400001)(31696002)(53546011)(6666004)(6506007)(26005)(186003)(66946007)(5660300002)(4326008)(66476007)(7416002)(31686004)(66556008)(41300700001)(8676002)(316002)(8936002)(6916009)(54906003)(44832011)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0RiTmRQdUpranI5Zms0UFBUMmdzYWdLZGV6RmkvQWdySVBTeGFSeE9UYzdG?=
 =?utf-8?B?Uk9TR3g4aXE1TlI4eVFLZWUvNGFVWVNhNmZQL1VGWjlRTGVIQm5rZjRONmw5?=
 =?utf-8?B?M2o5OFNPZHhJenF5UDZwd1M4TlBZMXBIRDJ2cHk2ZTBsWHFxSktFbzB2M1dG?=
 =?utf-8?B?MEJRVUpWb1dsL0RjTHdlTE9HbjNmSVM2SUxtSnJHbmorUkJxYnp3OExic1dE?=
 =?utf-8?B?VU9BRUlsZHBuQmhJRjZ4VE9INGdQNE1ZcU5NNmpRSzk2SDZrbEpHMXFtNmpX?=
 =?utf-8?B?QWpIa0QydmNZSEhMZUMvL3B1U1NIZXVmT2lNdmo2V0NySlIxQnZZVUtMZmNn?=
 =?utf-8?B?ZmgxcVRiMG5oc00xRHhQQjJoVmNMZEw3czhMVEp5dzNkbEEvdDVZbFpqYVoy?=
 =?utf-8?B?UFQwTlo3NlFTWWxhNWw0ZzYwTmh0dTRmMkpTeUJEMXNOVTRGZStCaXVybEdm?=
 =?utf-8?B?U2t6eGsvV1ZtbVpkd1pHQjlmUWJsOExtdTlTUk44RTBtUmNSVmZYS1R5M0cy?=
 =?utf-8?B?K1QwNkFHcWFzRWNFSHhBdE1oOU5ZQUVObWVxOWdyQ0NHcURtenVvMTNkSVBF?=
 =?utf-8?B?SmZ2Q3h3ZWZrTTlBalp2bWJ5UjBvYXdjTUhLTjhHb0JLWS9PdTk5VWo3KzlN?=
 =?utf-8?B?L1FkUlZXbmZSVjlyUnVhVzlQcnJwakJ5YnZKaUNtdjh1Sm1TN3hNeFdxTkJh?=
 =?utf-8?B?YmR0ejRGcjhXaVp4emRKR3YySlZ2UzZxUUV3OENNSGVSZHZkODVXdVlucUVl?=
 =?utf-8?B?TUYvNDcvNXdabkFmMWRidzM5WWt4VW16dnAzTmdSc3MzRTd5enRyVXZKWSs3?=
 =?utf-8?B?Z2NWbWpLOXA2S0h5djBHVTBUSGwxTzFNWWpWOHZ6cGdrOU1PbDdLZzFaSnFs?=
 =?utf-8?B?QXJoeDBvUml1VTdZNkh0ckg1NHJKS1huRVh5OVRxa2ZTRVE0anhQNTZRK0g0?=
 =?utf-8?B?blozYlNsRTY2V2YzanRXNHIxYzRRc21rYUJNb3pzMGN2QWtGZjZMWHJLTjg2?=
 =?utf-8?B?K3JTenJ6Z0cveThPRFpTaHpoVnpMNGN6UFIxUW9Rb2FNUXMwMFZaWXNnQjU2?=
 =?utf-8?B?NExCYzVrUTBrVWVvNUNmZXZNamQxRU92TnJhQ0FoMktlaVBWa1R5MlEvMHZu?=
 =?utf-8?B?NzRTUnJGTm5WUE1qMHpzUGtBMUxTaXh6azBnTHo0VFNpZjhjMWNvR1dESEtU?=
 =?utf-8?B?NWRyRkNvdHdSRzlpcXVaZGVyTjhBTW8rQkd2ZTZyQ0VlTFczMS9MTmhXTTJ3?=
 =?utf-8?B?cm9WbVFleVVpZU9WSDhNdCtGTFNad0xFWkppdHREUDdKZUMzT1BmaUJPSjc5?=
 =?utf-8?B?MUk2OWdJbWRFczk1NDgybkVYUDgwNlNiYmZneGVTOVBNZXc0SzVPTWVZRXdX?=
 =?utf-8?B?L3Y2WW5yUGZBTCtlS2R3NTJESWtGNXNUU0dTNG9FT3Vaa2RVbVp3RjVONEtv?=
 =?utf-8?B?Z3cyeTFFQks2bXZXNHJRZTJWVVp0WkJHZDRXZDVBREwzdFRQVW1zckk5VEdY?=
 =?utf-8?B?c2k1b2NSWFlrWEJFMFpmV0Q4K1NSLzF2Qkk0YVU4QTFYaWV2WTZMcUxSeUFE?=
 =?utf-8?B?Q3BHNUlVR1loa0QxOGVlQUROaFhmd3VkNTE1L0FnaGJ4SmVscTNLT29YTFNC?=
 =?utf-8?B?MWRFR2ZUNkZHc2VuQUNPbFJxeGJPTVVVeDF6blhnZFJINnA1NjU0a24wVGxN?=
 =?utf-8?B?QTY0ajFYS0ViSEdIbElzdGlENzVWTU02U0FieHRPcnhodHE2SnJPUUpOTTlq?=
 =?utf-8?B?Z05YR2RpWGpGUUVpd2VwMHVLakgzVHRIcTJUdnE4Mzk2c2o2cTZXZWNNcTc2?=
 =?utf-8?B?Z2pyd1V1Vk5RSjB3cEhHQUtxMndFT2FYMDJibkE3UXp2dGFDdHBZbGpGbm9m?=
 =?utf-8?B?S2twY1NTUlF4eEYzVC9JQ3Mrak1zdDFXMmtSa2E3TEtFaDY5VmY1WGhWcTRt?=
 =?utf-8?B?S25lKzE3RWpRSHg4WG9KZUlCMlhpSkFINkxWRmtmQlIvRStONWxxOEJacHBy?=
 =?utf-8?B?QTVPRlJ2SXI1NmRubVpVMVVPWHJmbXlXT2gzems5WkxscHBRRXV5UFRLNlQx?=
 =?utf-8?B?T0pHa2thVzRqWlJtRWtqVmh2eXB2VGRsUTdyWUdnSVYwblNHZE5rYjk0RU5S?=
 =?utf-8?Q?3mM77Ujef4Ko8JHTWKzL/AmfR?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e3cfe8f-254d-4967-9886-08daf82c9e69
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 01:46:16.7263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Li7QN4M0Wvl2l/u6ujtcMYZOJi+rjCSkrUCVtOyVwhUy/J5EnXUbWmttWMDLv+GDtkArJZLhO8+QPA1VSrknMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7411
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/16/2023 1:26 PM, Oleksij Rempel wrote:
> On Mon, Jan 16, 2023 at 09:01:08AM +0800, Peng Fan wrote:
>> Hi Oleksij,
>>
>> On 1/13/2023 10:27 PM, Oleksij Rempel wrote:
>>> Old imx6q machine code makes RGMII/RMII clock direction decision based on
>>> configuration of "ptp" clock. "enet_out" is not used and make no real
>>> sense, since we can't configure it as output or use it as clock
>>> provider.
>>>
>>> Instead of "enet_out" use "enet_clk_ref" which is actual selector to
>>> choose between internal and external clock source:
>>>
>>> FEC MAC <---------- enet_clk_ref <--------- SoC PLL
>>>                            \
>>> 			  ^------<-> refclock PAD (bi directional)
>>>
>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>>> ---
>>>    arch/arm/boot/dts/imx6qdl.dtsi | 4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
>>> index ff1e0173b39b..71522263031a 100644
>>> --- a/arch/arm/boot/dts/imx6qdl.dtsi
>>> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
>>> @@ -1050,8 +1050,8 @@ fec: ethernet@2188000 {
>>>    				clocks = <&clks IMX6QDL_CLK_ENET>,
>>>    					 <&clks IMX6QDL_CLK_ENET>,
>>>    					 <&clks IMX6QDL_CLK_ENET_REF>,
>>> -					 <&clks IMX6QDL_CLK_ENET_REF>;
>>> -				clock-names = "ipg", "ahb", "ptp", "enet_out";
>>> +					 <&clks IMX6QDL_CLK_ENET_REF_SEL>;
>>> +				clock-names = "ipg", "ahb", "ptp", "enet_clk_ref";
>>
>>
>> Please also update fec binding, otherwise there will be dtbs check error.
> 
> Hm, there is no restriction on enet_clk_ref use or requirements to use
> enet_out in Documentation/devicetree/bindings/net/fsl,fec.yaml
> 
> Do I missing something?

After check, seems using enet_out would trigger dtbs_check error, using
enet_clk_ref would not as what you did in this patch. So your patch is fine.

   clock-names:
     minItems: 2
     maxItems: 5
     items:
       enum:
         - ipg
         - ahb
         - ptp
         - enet_clk_ref
         - enet_out
         - enet_2x_txclk

Regards,
Peng.


> 
> Regards,
> Oleksij
