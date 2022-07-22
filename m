Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9D257DBEB
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbiGVIN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbiGVINK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:13:10 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2D49CE04;
        Fri, 22 Jul 2022 01:13:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/liZVdXbede2CKt5CSTTraEH7z76SfTmU1UpyfJ9Dezy2YD4KVQl+zuZNmIK+0a+rt4bLvjzwk75ebAA+vtpeUjUlMx1jPB8LVNzvpvEJe2SJQyM5hofZlQ4JBS/+RCocDF3goU1hEpptRyWm1pf0poDCx80VVk5/F+xmsidfHOw7fH8YzN7t4xyb7mTGX0f/kzOsoYSf470N37D9OXbJ+OpF+UoYlza6IFKwsfe4gp0wraQgf314RsY/YKGRt8y1VKI9TcTUsqPNGQaCyhjjwZP26O5WoBg5UyMyTFHm/1sgpy/bbgS2/5GVoGFFVaLlV/e7blwrnk9x+suQypaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xosIAfeVU8fEwpAxLw1I+46j0eB3BdWMLs+ElNpZzUM=;
 b=CkAXAD9UuMAoH11017xUjiyvnwinyESNp2KGd5pLDV0WzbINlnt1oIngCNBfsnptWUbI1hqBo4aizDonTRfAXmNuKqnAITF5nYxw8+FRcW4dtxMNrxutmnZzgQ/Gu3nqoVCene5sx2jivbSJNDDuf9PcSJyj0sP33ni8aGoEnufWGXiQrNy7C6Y0fjqn5V2QtFhUdVLbnpT7mXTva3rA6ZCT5mjHunylLZKZAzaxVEVve44wV2bMV2pFZfr8zZiIAleECoKSBGiVxfrIKsDeZyCIWzDZPWRlys09OhR5HhsgIqOTJglHQtGfRLW+zjsckewUqYgohr6hT+Irmu/22w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xosIAfeVU8fEwpAxLw1I+46j0eB3BdWMLs+ElNpZzUM=;
 b=UCbxPu41EhqX205u769MDRPhnwIRtVJ2EIwsBC8W+00nT+WBIA8Vp+eY8MA8CgLrnuB64xeNsnbMYBJFJZojmw/izUftLnu+q3I7R+ieo+HL1KVtlaOoGE6DVg5fOP1SDMLzKPbME1X75f214/q4stsfNoUIRQ8odxb+bWv+V4I=
Received: from SA9PR03CA0019.namprd03.prod.outlook.com (2603:10b6:806:20::24)
 by CH2PR02MB6743.namprd02.prod.outlook.com (2603:10b6:610:7d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Fri, 22 Jul
 2022 08:13:07 +0000
Received: from SN1NAM02FT0052.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:20:cafe::72) by SA9PR03CA0019.outlook.office365.com
 (2603:10b6:806:20::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Fri, 22 Jul 2022 08:13:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0052.mail.protection.outlook.com (10.97.5.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 08:13:07 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 22 Jul 2022 01:13:02 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 22 Jul 2022 01:13:02 -0700
Envelope-to: git@xilinx.com,
 git@amd.com,
 radhey.shyam.pandey@amd.com,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 gregkh@linuxfoundation.org,
 linux-arm-kernel@lists.infradead.org,
 claudiu.beznea@microchip.com,
 nicolas.ferre@microchip.com,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.2] (port=60638 helo=xhdvnc102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1oEnmP-0005RS-Jv; Fri, 22 Jul 2022 01:13:01 -0700
Received: by xhdvnc102.xilinx.com (Postfix, from userid 13245)
        id 7513510456D; Fri, 22 Jul 2022 13:42:34 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <michal.simek@xilinx.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>, <ronak.jain@xilinx.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@xilinx.com>, <git@amd.com>,
        "Radhey Shyam Pandey" <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic configuration support
Date:   Fri, 22 Jul 2022 13:42:00 +0530
Message-ID: <1658477520-13551-3-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
References: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2239edba-14a4-43b5-8032-08da6bba024c
X-MS-TrafficTypeDiagnostic: CH2PR02MB6743:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YJwcN+GKh52Kcb7gPb569sZAsnoBAHZ5XZzYpwoqXBEFLrslvz8R5ING7TBOEMm9pjioS78qYx8FWSfjILNiVtPgyiP/Vas7mkKHi0x5u10D1mdKEcMwOJlLMu5axs1UxquVo8rIyKdl5DAKjpjJWiRM06AZ4fKk8qXysWdVbW/iDRr9V3Ps8duKiAQhfFeYgnm1VSfaXZ4XtvvxC8yhwj7HiOc8Ow/L3fOQSDNJluunp4lL0fwpUDFFT9t4JetTN/fFupJhYaOlfqFB5AUwvoYcV87K0MLm9sSeO872LgNwSGortDedKeuy31sDlHfEmhIRyEiNGcXac5Jk90DI+AJ6fCqlr5VNPc8vUW/ffknAbdTmqHBa84Q7ky+SsjaqYwYrKqlh9f8NOcSeoPM5X7F6xkMRFT0mwSCsrtJJPTxWqtUle6UJDelq2dpyNT2SXpMYmGEw9GNy91Vu6TCQzFYKmDKjVGbtJhGQJZzLgdgQWbLQhB4crx81S0kNTmJIuAe8bxvKDXYxYvL/hyUuMz2JLkEvmyB/6ky42BuK9NiBFxb9s9PG9FOzn41QNBRGCnRUG+ymy1xt/K1qYxANuspLjgW9jLJdUhlwnTxo//3u/37oVq+iZ25UKMW/WFvLxzbw5jHpBLyq4wf06EscbBqtFDDX/haueA+PUrJBgOkusYcuwfaxeeU4F/zxG+KxozgCVPUEOxNI1nx8X4Q//A7//EbbjSaOmjZL3SEMHs04gH87HekSOt5SV8VcPUJ2SaEL7agL66x2sFMAIAxlXdZ+YoZRJVASr260vkjJqjZX/SJFZDSMceWbyJ36W1FGTmjt6dyHC9ciF5OAf5IjnQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(396003)(39860400002)(36840700001)(40470700004)(46966006)(36756003)(40460700003)(54906003)(8676002)(4326008)(70586007)(70206006)(7416002)(356005)(7636003)(83170400001)(478600001)(110136005)(42186006)(316002)(5660300002)(82740400003)(8936002)(41300700001)(2616005)(82310400005)(6666004)(2906002)(36860700001)(26005)(6266002)(40480700001)(47076005)(186003)(42882007)(336012)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 08:13:07.2222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2239edba-14a4-43b5-8032-08da6bba024c
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0052.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6743
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the dynamic configuration which takes care of configuring
the GEM secure space configuration registers using EEMI APIs. High level
sequence is to:
- Check for the PM dynamic configuration support, if no error proceed with
  GEM dynamic configurations(next steps) otherwise skip the dynamic
  configuration.
- Configure GEM Fixed configurations.
- Configure GEM_CLK_CTRL (gemX_sgmii_mode).
- Trigger GEM reset.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 7eb7822cd184..97f77fa9e165 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -38,6 +38,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/ptp_classify.h>
 #include <linux/reset.h>
+#include <linux/firmware/xlnx-zynqmp.h>
 #include "macb.h"
 
 /* This structure is only used for MACB on SiFive FU540 devices */
@@ -4621,6 +4622,25 @@ static int init_reset_optional(struct platform_device *pdev)
 					     "failed to init SGMII PHY\n");
 	}
 
+	ret = zynqmp_pm_is_function_supported(PM_IOCTL, IOCTL_SET_GEM_CONFIG);
+	if (!ret) {
+		u32 pm_info[2];
+
+		ret = of_property_read_u32_array(pdev->dev.of_node, "power-domains",
+						 pm_info, ARRAY_SIZE(pm_info));
+		if (ret < 0) {
+			dev_err(&pdev->dev, "Failed to read power management information\n");
+			return ret;
+		}
+		ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_FIXED, 0);
+		if (ret < 0)
+			return ret;
+
+		ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_SGMII_MODE, 1);
+		if (ret < 0)
+			return ret;
+	}
+
 	/* Fully reset controller at hardware level if mapped in device tree */
 	ret = device_reset_optional(&pdev->dev);
 	if (ret) {
-- 
2.25.1

