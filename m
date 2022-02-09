Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF7D4AEE71
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbiBIJvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237568AbiBIJvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:51:00 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B541EE0CF94A;
        Wed,  9 Feb 2022 01:50:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7ifGWeBb2UJzuzFaPO4psZBU9Dc8im1sU4XCCBvU4WjDMMhJR4erMNtQ79FOvd9N8126v53vxmJ3gSYYKO1nPTYEBzl4rSVOoZx55JyY0BVw2MKWX195Ojb54Gf8kaV8RBObbt/ajXc72nwQZVFx49zTedNtVkwwgZmbzVL0w/FUJeUoKxug7cxEPZAbHGCulmsd5svGzVUIH9NWdOkBDJBn0KSajz3cZGkG/OEwKvoE2JnaHMQkGkXKn+Wbm4Z5DN3iHHZ/Qw4xdTgk6HJzeGKq6GPKzjxYxNldWo8xTnPuRtCGQxrq1bF+5orXAbboeTahajLgRVn7XZ1MZXpgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ExGhn9ejubFmqZrjmlQCjA7WGkEk8pQtW7NR/pHEG8Q=;
 b=gxwnPvYbFWwfyCR5Pwdw+XHqCkJOOLB5E9uuu3jqbPGVAjkcW2y50GUiCWbNrKF+jNVaOTZUWeZ2GTOFY10kPd716Zea51et2uxGuagv10QefPswC7UsIhdlUujaWnmLJAhb5mdpxSQ4CF29fCbXfGttqVZOsksMN7+HYfB9AfqX7ukOoU3VwSCAwlV5ckg6IEsj8FQdD/WoeokfW+czZLhKdh5M86R7136I9QNbPr+pNoJzIjsVU2NjYzFN0bXJqwSaoxcihmDOop+XDWcCyOCf5bSXkvp4Cs2Cj0A4aIOM0O92yrgsbdeWHcZHwaSsjcfSRuW0sfE14dP0OM3LrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ExGhn9ejubFmqZrjmlQCjA7WGkEk8pQtW7NR/pHEG8Q=;
 b=jufPbmX5IBsdrVrAag0FkAl3b9NMkgpcZZjWX2quM5+o5CadcBXbZYOem4hodBZ/hlvuI3FxNCThyLJuSFPQwzXItvl7cn29ypXQihzD1fAzllTtIYfP2yAWNOSEMOR5ocF04c6SOmre2/V2LuT0uqrXJ+3V9nNcCZl5oBy5SnA=
Received: from SN7PR04CA0212.namprd04.prod.outlook.com (2603:10b6:806:127::7)
 by MW4PR02MB7218.namprd02.prod.outlook.com (2603:10b6:303:65::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 09:43:30 +0000
Received: from SN1NAM02FT0054.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:127:cafe::64) by SN7PR04CA0212.outlook.office365.com
 (2603:10b6:806:127::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Wed, 9 Feb 2022 09:43:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0054.mail.protection.outlook.com (10.97.4.242) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4975.11 via Frontend Transport; Wed, 9 Feb 2022 09:43:29 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 9 Feb 2022 01:43:29 -0800
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 9 Feb 2022 01:43:29 -0800
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 claudiu.beznea@microchip.com,
 andrei.pistirica@microchip.com,
 kuba@kernel.org,
 Conor.Dooley@microchip.com,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com,
 mstamand@ciena.com
Received: from [10.140.6.13] (port=39646 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1nHjVY-0006bl-OZ; Wed, 09 Feb 2022 01:43:29 -0800
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <andrei.pistirica@microchip.com>,
        <kuba@kernel.org>, <Conor.Dooley@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <mstamand@ciena.com>
Subject: [PATCH] net: macb: Align the dma and coherent dma masks
Date:   Wed, 9 Feb 2022 15:13:25 +0530
Message-ID: <20220209094325.8525-1-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a0b8ad5-b985-4f85-3529-08d9ebb0a108
X-MS-TrafficTypeDiagnostic: MW4PR02MB7218:EE_
X-Microsoft-Antispam-PRVS: <MW4PR02MB7218EBE8585016DE1CC00103C92E9@MW4PR02MB7218.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gzjUkbqUqFXM1DFeDyvWwyt8b1inuzyoQFwp48LlvfyYU72OR3wEpQ1iSQtXRhG68/Z2FxCoKt2MA4QLl2i/PdOwW+AIag6GqPbcnib4lXVrKmLAB+Xd9RJbflPGBgBkyJt7KIcyjRp927ruCAGf9g4JuZFbGe1VrXelBOJvN98jJpa00YmegTXDAL8zXehdo2uUjUpx8mL0gQbAYiUEUGrWh8/Uq9ZKYd/zUNRHoD9Ca+Wr0Ihfz7l+bRvBHvYk/FLVDBuF5v4jwONmXUje6yfuCY+vpGMcgaxIDOeCrYM2hleLZJQlRRKxLev5IILeiNT8DIZ0yDXMEHCw+BylbPsbZxjArXyk5C7PTM1xHuIy6naVrXzdq2faDdWvMvCzmenaz4VqGkFaH+jn2RPuOSvcdbqcKwDar7x7MCVX1EtUcR7lxfuqTDwdOwzGhjkpjzFpMMqpEM3I/5eo+grKkhpdAkjDFUr/1xWZgFFeW3msX++VFFewlrA54/tAgLplWUXMpYk14W5BcIiLthYzLgogX0YiSyicFp2DpnZSL8YfWX6CvkElAJhLUPlRRkWxZe0zlAN1TTM16wx1WEiSG4mPxwuv33CWvDd0uef5kMDgj+vZKDN2TBh7peCXbia5hQFe+4Xw/ET8jddt03GEUaFrDvU31ke5orxvl3BAD11wx9kjxjm/feCNUfu5KIO/wRrMTVHz86O3aqjKPk0mtw==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(70206006)(8676002)(4326008)(70586007)(47076005)(7636003)(5660300002)(9786002)(8936002)(54906003)(110136005)(316002)(36756003)(44832011)(2906002)(7416002)(82310400004)(336012)(7696005)(508600001)(26005)(186003)(2616005)(1076003)(356005)(83380400001)(40460700003)(36860700001)(6666004)(426003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 09:43:29.7295
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0b8ad5-b985-4f85-3529-08d9ebb0a108
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0054.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7218
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc St-Amand <mstamand@ciena.com>

Single page and coherent memory blocks can use different DMA masks
when the macb accesses physical memory directly. The kernel is clever
enough to allocate pages that fit into the requested address width.

When using the ARM SMMU, the DMA mask must be the same for single
pages and big coherent memory blocks. Otherwise the translation
tables turn into one big mess.

  [   74.959909] macb ff0e0000.ethernet eth0: DMA bus error: HRESP not OK
  [   74.959989] arm-smmu fd800000.smmu: Unhandled context fault: fsr=0x402, iova=0x3165687460, fsynr=0x20001, cbfrsynra=0x877, cb=1
  [   75.173939] macb ff0e0000.ethernet eth0: DMA bus error: HRESP not OK
  [   75.173955] arm-smmu fd800000.smmu: Unhandled context fault: fsr=0x402, iova=0x3165687460, fsynr=0x20001, cbfrsynra=0x877, cb=1

Since using the same DMA mask does not hurt direct 1:1 physical
memory mappings, this commit always aligns DMA and coherent masks.

Signed-off-by: Marc St-Amand <mstamand@ciena.com>
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 1ce20bf52f72..4c231159b562 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4765,7 +4765,7 @@ static int macb_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	if (GEM_BFEXT(DAW64, gem_readl(bp, DCFG6))) {
-		dma_set_mask(&pdev->dev, DMA_BIT_MASK(44));
+		dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
 		bp->hw_dma_cap |= HW_DMA_CAP_64B;
 	}
 #endif
-- 
2.17.1

