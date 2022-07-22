Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B2257E06E
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 13:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbiGVLEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 07:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbiGVLDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 07:03:53 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8646ABB8D3;
        Fri, 22 Jul 2022 04:03:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZEEmFbfLCro5UWB/NEJvVE3bcrZMHPi9kUN1OPeAoWE2vbS5JhGEVdF8OcWkgHDkQGoSQYkbrWSjKw3tsQ8S/WwYj83TJhAIa1ZeYZxSMfteObZ/fYiZ3KjROW42EflHRTHUOMEVIRok30EXfNRTXJ35ctF0hjXyW1xkDvu8Xcl+UZTlBCWBLm/YxPy5qJ1asXcI6kQvkNV1zcgcMDanytajyM1B/HECJJDEfxE8tSoDNz+U3/RhvLu+SO9MGrkIme6NbR2MqgU2ugDKvZBnfJz0wwXF3+hVDdfltxZCEU4uX0mef73uUfdm0W31WUoksldioqLCnkV7XsHxUdNAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WIWWoIwailG6ca6zaM4I/I/bVR16n+R2ns9qrvPspFg=;
 b=NJXb/CxvhBgs6nb7W14UbeGzIhyLxlLlItLyXqps3/ijMfY9vpwQHxOhaIsUn8xpo9FxUBUlCjuB0M4S5Aa/V7Zs0jSY+/cThtW9tEJS/rylaDaxLHQyQnXIP/gCYcxYZZtdgU1wXBxxVL1TYuQU1e7inE4RDRETRI41ELvYwKaGd3geCc8XFyp9YtKAkJhdf9XcPg96zscr2VmUFOe6U9XpT2lXSPxweL3n2hhEBvG6YVr98fVNORWnKwIy61H/bsKnN0Zn6sdZNRa/pn03gCkC1r3XZ47AB827myHm4UH6oGw/9Ttcixqv+bI2Q6rWgdmmLwAx/gJcxY64Anwcfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIWWoIwailG6ca6zaM4I/I/bVR16n+R2ns9qrvPspFg=;
 b=BZ4JODzZNHofN6+I285aFNB2594U2mMs7gWuh7a8EtJUmH8JmwwOGlyCFmHzPOx1/Lgek/UFNhyJQxyzjF+HcTL+fvJa8a24Kf+qu8FQI/VP8XBVJfCKn4NPtLN10h4t1Lym8QBKsMuIymlmALqV1387NAU/52zNXuzwLudDwXc=
Received: from SA0PR11CA0017.namprd11.prod.outlook.com (2603:10b6:806:d3::22)
 by DM5PR02MB2666.namprd02.prod.outlook.com (2603:10b6:3:106::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 11:03:49 +0000
Received: from SN1NAM02FT0004.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:d3:cafe::4e) by SA0PR11CA0017.outlook.office365.com
 (2603:10b6:806:d3::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Fri, 22 Jul 2022 11:03:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0004.mail.protection.outlook.com (10.97.4.226) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 11:03:49 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 22 Jul 2022 04:03:48 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 22 Jul 2022 04:03:48 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 edumazet@google.com,
 pabeni@redhat.com,
 robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com,
 harini.katakam@amd.com,
 devicetree@vger.kernel.org
Received: from [10.140.6.13] (port=33588 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1oEqRf-0001lP-Qw; Fri, 22 Jul 2022 04:03:48 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <harini.katakam@amd.com>,
        <devicetree@vger.kernel.org>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH v2 3/3] net: macb: Update tsu clk usage in runtime suspend/resume for Versal
Date:   Fri, 22 Jul 2022 16:33:30 +0530
Message-ID: <20220722110330.13257-4-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220722110330.13257-1-harini.katakam@xilinx.com>
References: <20220722110330.13257-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52c2f3f5-bdd0-4f97-24ba-08da6bd1dae8
X-MS-TrafficTypeDiagnostic: DM5PR02MB2666:EE_
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6mjx8P60Byc8Aj3LCE6qSZsI6ADLQH+j8xGo2Mht0ke5q12UYPRdtEl57SAfDOzNGWy7BhIQ2QWuvbhZCnzC47zcVVMADj5hr4MplUldPcf5qVZKd9SOmLbxQgK7/4IWvKVXIIJQ7aMEZYDfZi1RbIilUic/7Hf2ophitFjsMftDjmroZhTHwN4wRuma9KAB6V+yi2i4M4xAi+icGjQCrLSdm9IeyTqXsxRmMN7zSSMcgOtEz41qsVFtiG+eipO8lMOV6GsmhSBrTja/9lJ5527No8jvhn5MibiTvUHYOOw9P3M8YfOK5X5J6NMWfkTPcXMdxZ3QMuZCWC3tHA/kL3vkNAQuUZ3zJOmcjbv5g7U1RWkmu7JmGll8D/gDQc1PoFS1NVXcLyBa4rRd/E+bukndDPu2MGcOcxxbEEiX41nJljvaH0HFRGdqvdsf9aJuueDv+cVPmvl6itWJubNA1RC72VliSXZqqVVg5ahQd5D+1AwCksgZ9kiINlRJjPpeZW9zohEyPQzN97/yF7hFjdkawAxkSe+Hb6+/6GZHL/OqyeXnRmn7rSLk+skGo9hKtpN9VoLU0TmYbOr6qwdzym6ttdXmZa1QwzSTTIjF1FIcUp5na0ICAAoSCAgmzRUXM/bsR7DB1mju4ssFEcJcKPvvpcwglxJOBqvchfa8tYDAzInBPJ9EMjz5ROzf+OI8IbVWv+1OvbN/NvEYwfhUrSjlU7THJEe8l217GhWN6GkTebTt0mWdYL3/0TvS4opjK6gLBtOJ+FjVaYQNqRPQEpyWddIYC2Ajs8PjeaKhOYgoK4gmlhP6WtDedVwwHu2TihjqNLS+XYMyC+dfz/d4aA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(346002)(396003)(46966006)(36840700001)(40470700004)(336012)(36756003)(7636003)(82740400003)(478600001)(1076003)(2616005)(107886003)(41300700001)(6666004)(7696005)(316002)(54906003)(26005)(186003)(82310400005)(40480700001)(110136005)(40460700003)(5660300002)(9786002)(7416002)(8936002)(44832011)(70586007)(4326008)(8676002)(70206006)(47076005)(426003)(356005)(83380400001)(2906002)(36860700001)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 11:03:49.0549
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c2f3f5-bdd0-4f97-24ba-08da6bd1dae8
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0004.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB2666
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Versal TSU clock cannot be disabled irrespective of whether PTP is
used. Hence introduce a new Versal config structure with a "need tsu"
caps flag and check the same in runtime_suspend/resume before cutting
off clocks.

More information on this for future reference:
This is an IP limitation on versions 1p11 and 1p12 when Qbv is enabled
(See designcfg1, bit 3). However it is better to rely on an SoC specific
check rather than the IP version because tsu clk property itself may not
represent actual HW tsu clock on some chip designs.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
v2:
- Add TSUCLK CAPS flag in correct sorted postion and use 0x400 instead
as that is available.
- Move config structure to the end, aligning with order in macb_dt_ids.

 drivers/net/ethernet/cadence/macb.h      |  1 +
 drivers/net/ethernet/cadence/macb_main.c | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 583e860fdca8..9c410f93a103 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -717,6 +717,7 @@
 #define MACB_CAPS_BD_RD_PREFETCH		0x00000080
 #define MACB_CAPS_NEEDS_RSTONUBR		0x00000100
 #define MACB_CAPS_MIIONRGMII			0x00000200
+#define MACB_CAPS_NEED_TSUCLK			0x00000400
 #define MACB_CAPS_PCS				0x01000000
 #define MACB_CAPS_HIGH_SPEED			0x02000000
 #define MACB_CAPS_CLK_HW_CHG			0x04000000
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 7eb7822cd184..4cd4f57ca2aa 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4773,6 +4773,16 @@ static const struct macb_config sama7g5_emac_config = {
 	.usrio = &sama7g5_usrio,
 };
 
+static const struct macb_config versal_config = {
+	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_JUMBO |
+		MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH | MACB_CAPS_NEED_TSUCLK,
+	.dma_burst_length = 16,
+	.clk_init = macb_clk_init,
+	.init = init_reset_optional,
+	.jumbo_max_len = 10240,
+	.usrio = &macb_default_usrio,
+};
+
 static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "cdns,at32ap7000-macb" },
 	{ .compatible = "cdns,at91sam9260-macb", .data = &at91sam9260_config },
@@ -4794,6 +4804,7 @@ static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "microchip,mpfs-macb", .data = &mpfs_config },
 	{ .compatible = "microchip,sama7g5-gem", .data = &sama7g5_gem_config },
 	{ .compatible = "microchip,sama7g5-emac", .data = &sama7g5_emac_config },
+	{ .compatible = "cdns,versal-gem", .data = &versal_config},
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, macb_dt_ids);
@@ -5203,7 +5214,7 @@ static int __maybe_unused macb_runtime_suspend(struct device *dev)
 
 	if (!(device_may_wakeup(dev)))
 		macb_clks_disable(bp->pclk, bp->hclk, bp->tx_clk, bp->rx_clk, bp->tsu_clk);
-	else
+	else if (!(bp->caps & MACB_CAPS_NEED_TSUCLK))
 		macb_clks_disable(NULL, NULL, NULL, NULL, bp->tsu_clk);
 
 	return 0;
@@ -5219,8 +5230,10 @@ static int __maybe_unused macb_runtime_resume(struct device *dev)
 		clk_prepare_enable(bp->hclk);
 		clk_prepare_enable(bp->tx_clk);
 		clk_prepare_enable(bp->rx_clk);
+		clk_prepare_enable(bp->tsu_clk);
+	} else if (!(bp->caps & MACB_CAPS_NEED_TSUCLK)) {
+		clk_prepare_enable(bp->tsu_clk);
 	}
-	clk_prepare_enable(bp->tsu_clk);
 
 	return 0;
 }
-- 
2.17.1

