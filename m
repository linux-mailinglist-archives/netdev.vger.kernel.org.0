Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C8A54FF09
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383521AbiFQUjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382924AbiFQUiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:38:17 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150041.outbound.protection.outlook.com [40.107.15.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B234E64D20;
        Fri, 17 Jun 2022 13:35:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwxIJlWsc7+GPnLnk9NKePahwwjgcTFZ1umghXlznXMeg/iRw9XRk4SE5GpQ0AoDepip+GSzxDKBv3D1D0KkgjgMCfpOWjenbmYi8Cl1MxZSQx1nFLwbELvRlA1V5bhvEQuCpLUP3UqrA7nmNj87hW7grmgV1lYq7tLB6Q/LtbEdDso1mEY+sZlF8C1k5mznZZuQUXi7Y3H/6wH2exqadgg5rCUZaazpXtvuq+JM6wO0CsA598QqDXRAiqtZWYAp2EThPmQBKkD5FzCbwA3y5xXfKUoBUh8uSfQXL50JL5/I6CiBLq57e4juLlMp+bm4JF7GiHMrTH/M36Ya5MEu5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U4NrkRaqMwBvFMWtFmoLov7ytXI3OWJKrvNDhIqR2to=;
 b=PFEVUWBjswBfZ6Gcu45qpMnuahW/zGLliBSc9/SeWyxwQwbxQ6HXLhXnktgSyVvyqvzSPoF/4aiEdBrVa0tyTuuoH/sT5QxYc/Skb92rGG1dDncaSYGaISzmlK8d3ansUowKUMIsw7Z/zhVeKP5WKoHBcQm6VUe23k+gbiSmusprO3Ld0k4I1X9qk1BCStlzVm6jBDWWWy7d67USP3dbyMB3XUHa884/b8qmI8aJsSpN5+GCC6ALfY1GCPLU2HPH23XI/ncGFNPqT7lyeeVPMLLiDsbARNZA3Lax5XWgTEw3R8nFXaiShw7xJ0uUEK9OPySbsVJO5kHJIWuzpkkODQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U4NrkRaqMwBvFMWtFmoLov7ytXI3OWJKrvNDhIqR2to=;
 b=qdKf5e2y8thiS5LPXw84BVvY1zoLz3yRmy8oXgZlSf27D2MqFim4+jArPW44oDyudH0+Q8AmRRGJTag6KzJYYZfjoN5v3hq2Y2b1MALMZUxoAzpKdq9xVOEYy/R91gGBv07R31B9ELnXKthXwCxfu+URtLZdpGTRnMqYth6683HS+wHu7/xVLHTXHH0Hdwxbv9KrgyVtyQh4FMjnj9rRuMXiURarqGRzo5l+ZOgJnr80KARGZ/sIFPAnywcEJm4VfWTJq7b4OTu1M6upI5T+igtR0fS1IzTxnThLYWG/ubqJDcOIO38VCg6rBFuBBXkmumLfiZ5xtYBA6awhmq06lQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:31 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:34:31 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next 28/28] arm64: dts: ls1046a: Specify which MACs support RGMII
Date:   Fri, 17 Jun 2022 16:33:12 -0400
Message-Id: <20220617203312.3799646-29-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5442f662-44c2-41fb-5c3d-08da50a0c80f
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB6838812D29C1DB5AA2197D2196AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N2roVqVDVXe6OZz0JNX0zhZc1xXY0Iqu7ZlzwrusDkiQV7zQVvaCBoQUhIjb405UV43YE3QR7zoDC5MGeyws8g1M3b4bsUAuiCPbOYQkfoHelAIcfKNyKzpTLLvmzN27txrzzKt5vzG4E4NIiJrEEmq1prBBeHl5rPWvnNGb6iyQ9pfEoFJMwO0d41LOdY07kfiS3ixZ8l+iYqN8ky0OZepHvDWXGtRS0VIdPIpBVn4Jpm4PuoSH6GnaxxIpQU/lJZdlYq1qkjInsRD7mu9UtBDWGxt8ibqkuWSSc7LTvFA7wU78eTdDthuH0tDwv3GyZD9+BB8c75N6R5mabKH4HQXn/eIyIg7ZwMFB7yd0XxBVNkzX/MPKBhSuf4BH7DMGBz/EYxoKMzwslnxXk6LmmAutmpzHu8kX99LdGfyg2RX8U0JwiJ05RBGjmTZOzLU6z/7syNM0Rv1K+1OeBWaiIfYmeXAOfVZ9GnVYdBwVjSX3JVAsx+joxmwZUAQCaY4Ur2jEcHbL/hHVpRmxuNYI5DCn99Ve7x2n7WnCnAu3Tge1+PdrZTp6hwwUftHGTR44LgimQAOwQ+5wqJ//+SvQU5nVrYS/aFXfOBruhEEafpOKj+osLQMNuuoSJquxjaOFdeQ7nnhTW6F+uz9woV9lEM9Hct/PDXHyH8sDr1ztCTVEsnnTeP8MFKZmvJKfEB0+YpxbXMilrq/KEdGn2xQWuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(7416002)(6512007)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(83380400001)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FyxehabTRoWE2p5BWLFAaXebmFDfO4sMHiy0SmLJHrdcDXFgyCaJZ17k5O6q?=
 =?us-ascii?Q?P0i0Ce+VKZ6uJrr5lrbTv9OTuAqNlqHS5tyXPN0iJOnj5dHfLHdIdFlHLfr3?=
 =?us-ascii?Q?Vftf9uIGEUdNmuifWBow5I1oKumTbwkZgHDxm35l863xO3w4oFp7+xrLTpTb?=
 =?us-ascii?Q?ztsYcDfxH2fxGphUJBejaRSoiNeSgC3jFVwupy8WM5vnxBj7QhSC1Jk5GZEe?=
 =?us-ascii?Q?jrf9Pfzz0DEdPUCf5MkElsyxLF/PNnIIz8D4t1GMk6UUrurZO1aRgxMB7+AL?=
 =?us-ascii?Q?dOKOqq7U9RiyQKo3tmRgqmJO7B3LlLyoZxw7nnp0QYWY0tffjwOC6DZ4nXCO?=
 =?us-ascii?Q?A+YOI3+hcvRyLSPOJ+UHpIn+IX/XpdFWVSK0GkqztjHFVoo5YsCXJbQRJXfD?=
 =?us-ascii?Q?8CJkBcMTrQJmELwffPPeAt2EfsN/hOg+y8vmsbBpUnTW6yqE1xBKrrHYbD7U?=
 =?us-ascii?Q?Zgqg5NOez88Ulr2gy9BNOmjpL9ljHuj/SvYRP9AOVoZd3NuiMy0HfPX5eyXo?=
 =?us-ascii?Q?RlUBQV3EZ5cKL4AXf27MEuoHK7XVriFAWWER8Cydgzxa4yMwlp42BJs30yJw?=
 =?us-ascii?Q?blVRlhVppc4OAqBmehVfPY4oVc/7qHCYfCRpeIp2N6MNt9JfxHTMH4mBRFQ5?=
 =?us-ascii?Q?lO911d5aZuCeZZv5/aQyuqmi/N3krgcgHx/ZEL+eooZAqtZRPbEZn5SOIldI?=
 =?us-ascii?Q?8mw76nHypwzf3yVEYOmAHkc19kHhsyfBm/ivncB4gwhFSrsSrq4cjSGWEzAi?=
 =?us-ascii?Q?bOojx3OzmY4ikVd1J2jmaXDVDol8HjWmYgd8l269kj23I6V11yxxMxsrIsE/?=
 =?us-ascii?Q?i+NhCSEfBlZDWk+1DyTZehBP0o8IedyyMLXcHwOM8rgHK1nojk7tp7qrnuvf?=
 =?us-ascii?Q?nYuoCiwsH9WB1O9H2qLljWB5kISFU+L14PcIIhFvcYoNt+SGld3BHYh85nLs?=
 =?us-ascii?Q?jH1NcCh3Qx0eKlDUKPfBUevxhZVJkVFg2tFU4m0X3+A9wt9LItcdGoa7cpkX?=
 =?us-ascii?Q?SRujeDR9/vSQDRbn+aV2e3xqYHi939aC71RIsFpStTNKSJZcl5WcBd8zLC+w?=
 =?us-ascii?Q?T2j2vHv4eLREq9q+ftLsQYPBN0h5FA3JTi4yjveaWcstri+9zLjjPYukMDrv?=
 =?us-ascii?Q?KCHS8hUFB3VkdTgUq1y9tkpeywafw6Vgz0qOt9gz6FyqLLBiwWJt9ffPIzDx?=
 =?us-ascii?Q?E0+ZeEQp3tm1ZPzj4GXckfcOn86N2TaNNTTNGKnal4PWZ3FN4feMi/NSPGVA?=
 =?us-ascii?Q?JXE8wlj1JdSuCB006e/qy9vF9G90XnfH8yRGU3nDf7oFHZvxZIhd+bs0xT7o?=
 =?us-ascii?Q?+ksM5O3KO8nv4xGhVomZl9957hRzTwDcoG/MYb9X9U7uAWePxd5ZSbkPd79L?=
 =?us-ascii?Q?t4MzOKmcgjgWwUjWYXOgS8jpOsJ4aDq3UQUo/5dBCyQ0vZ0dRjqNzHeKsRv5?=
 =?us-ascii?Q?kXY3jSSuSW8MpKTSXt3/t0BghB6xFkPCOajk95uW3VD7U4Dl0uxAxkmfHtsv?=
 =?us-ascii?Q?hHPmfuwzLZ9cU0v1dkfD/pg6HFcloMBvnYfSU1Df0Cf/QGi34QYYgX8EV1hr?=
 =?us-ascii?Q?RKOOGEBrbK02jlqPc+yTgFZIiAsjLGB34KK2IbxmykfmS8c6So5LRmrZWPXA?=
 =?us-ascii?Q?whFSNngy+gD4vDLZ2NmesiC/nacT8hcpB/tttFT9ZkuWxNCVC4MKktpueC70?=
 =?us-ascii?Q?/ecYf2UcGLO9gtyZCMsneHOAHfA5lEZAJ0yPg4X0Sq9d3wbHIupVGh9HC+QN?=
 =?us-ascii?Q?XvlevYJ0q23DufmwyD2G1w+PL4Yr8Qk=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5442f662-44c2-41fb-5c3d-08da50a0c80f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:31.0285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Y27vk367/RGTN0oEZICEdrJgHRb5Rnbsl883zY1tvohVypKALtV91NiFg+ljKhFF6z9A/kxmaIiDgqPTFMWmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6838
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For more precise link mode support, we can add a property specifying
which MACs support RGMII. This silences the warning

	missing 'rgmii' property; assuming supported

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
index d6caaea57d90..4bb314388a72 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi
@@ -23,26 +23,34 @@ &soc {
 &fman0 {
 	/* these aliases provide the FMan ports mapping */
 	enet0: ethernet@e0000 {
+		rgmii = <0>;
 	};
 
 	enet1: ethernet@e2000 {
+		rgmii = <0>;
 	};
 
 	enet2: ethernet@e4000 {
+		rgmii = <1>;
 	};
 
 	enet3: ethernet@e6000 {
+		rgmii = <1>;
 	};
 
 	enet4: ethernet@e8000 {
+		rgmii = <0>;
 	};
 
 	enet5: ethernet@ea000 {
+		rgmii = <0>;
 	};
 
 	enet6: ethernet@f0000 {
+		rgmii = <0>;
 	};
 
 	enet7: ethernet@f2000 {
+		rgmii = <0>;
 	};
 };
-- 
2.35.1.1320.gc452695387.dirty

