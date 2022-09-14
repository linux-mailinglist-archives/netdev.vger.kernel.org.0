Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56F85B8852
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 14:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiINMer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 08:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiINMek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 08:34:40 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC558A1B1;
        Wed, 14 Sep 2022 05:34:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lu8wbOGRt8mc9kn5swB8N55zLXfUBs2R+EZ88BFS/P50O997LodXDwMjH1sjNTf4zaVurFXCFe9vVBY4psOgBrO0qFtGftdTv9iw1RxFsgceM3rAAjwFCO67tQYd8W1BPRh4w50KuqCNi5G4UrtMGuYZbSBsZg4B6xpBKwxzip6LOb/sb4gaAJHmMCfj27EQaCe3ZlNQM57MAIX3Oy5k8dJnR6cWHxKNiZSDmTw+T2ZoklTFTmLLpGu2THxT8d3XrA7dQg/9E5u8/qB+PpV9IRcIOntmuUJZc3t3oMaHUaRqL3+H0/Sk/ZuZZSqdL03EPAF1vQjjqGTuo/TXvle7Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pzCniLO3JAx728upvtB6wNgUmwkIX1WQYDgGplm1lIY=;
 b=WJA1dlvtkjHARAUFF7wyElgryluDQXR/fkOHqWXQ41DIz5+TtJGUsJAePGLBR6MjigbErerD4ktzSi2Thk3n9piwiuPvXE2PtkEpMOlM/9BeuYuibsz8ZfDGyt2Ni2/jm+9kNBFVy/oKDfAZNbOG4GiaekgkErUCRSPoAHGFEo1rZNZNzB4S5Op/1fRoLwJzPcNWkIcNheT4PlwXaKOCB6QqRE+4SBbyTUg/qFp16hWlTUV5y8qfUn2EijqvOuF4JeA1u5mF5aSG+E9IhZkcD4JH17q8EqeaVbteQez94o/jACauJwQdQ/RL0brYrWpgtTYSVPigVAcDC0iyaeWMSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzCniLO3JAx728upvtB6wNgUmwkIX1WQYDgGplm1lIY=;
 b=C36eYgfQZ8FeGwIzlFdr8HNzNDDICIP+/TBMbOsvrpHgn7zK8Ye2qgq6XuK+Ef3FpKFnPttGu1u5PoPP8Ji+K3mraAIfsGibhkW/4iOzVi9TLyLTnoidnNu6XPX8ULnhYpha8IgOc6a6ktJnyYdr+fV71XzhKjU1HCrCNqHaHpE=
Received: from DS7PR06CA0002.namprd06.prod.outlook.com (2603:10b6:8:2a::16) by
 SA2PR02MB7850.namprd02.prod.outlook.com (2603:10b6:806:14f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Wed, 14 Sep
 2022 12:34:35 +0000
Received: from DM3NAM02FT026.eop-nam02.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::aa) by DS7PR06CA0002.outlook.office365.com
 (2603:10b6:8:2a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15 via Frontend
 Transport; Wed, 14 Sep 2022 12:34:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT026.mail.protection.outlook.com (10.13.5.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 12:34:34 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 14 Sep 2022 05:33:57 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2507.9 via Frontend Transport; Wed, 14 Sep 2022 05:33:57 -0700
Envelope-to: git@amd.com,
 radhey.shyam.pandey@amd.com,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 gregkh@linuxfoundation.org,
 linux-arm-kernel@lists.infradead.org,
 andrew@lunn.ch,
 claudiu.beznea@microchip.com,
 conor.dooley@microchip.com,
 nicolas.ferre@microchip.com,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.3] (port=50640 helo=xhdvnc103.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1oYRaX-0001IL-5g; Wed, 14 Sep 2022 05:33:57 -0700
Received: by xhdvnc103.xilinx.com (Postfix, from userid 13245)
        id 1A5141054CA; Wed, 14 Sep 2022 18:03:30 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <michal.simek@xilinx.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>, <andrew@lunn.ch>,
        <conor.dooley@microchip.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@amd.com>, Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH v3 net-next 2/2] net: macb: Add zynqmp SGMII dynamic configuration support
Date:   Wed, 14 Sep 2022 18:03:16 +0530
Message-ID: <1663158796-14869-3-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1663158796-14869-1-git-send-email-radhey.shyam.pandey@amd.com>
References: <1663158796-14869-1-git-send-email-radhey.shyam.pandey@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3NAM02FT026:EE_|SA2PR02MB7850:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c5a4990-9789-4c71-cb5c-08da964d7b37
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zeNVUn8pqZ3K6zFJNAMsFq0g3QGtgiJcl8zjKnlvtbyCzzHOAco2yobKrwBwamFUSbNQfOuurU7/nMbUvm/hwRijX0uEyK+MoYWYGjccA61P0SUgAAfGL1F8Z/Lc2TlsvPsSFZLkWgL6Oy3k3KmMoRlW3ROIhVN5GSPrMGvk+6gj3AVR0kYlssL+oTpUzDaHZ3k7ZrERotCk3Sc3UnGubFqZzrrJjQrOyPB0jLPBaTzOpg4v5C6qDpncEBM4OMYVZUSzcbnIOuyhgLq3OaBqmKRK2ZHTXKq9gBSdcGBqyhOgF93QmUlfILfzRHxeyVp/IWStRwRrV1RSO6UwpUPVG0YapI2phn/9GfuvFNjWCNu9VFueApjzWNq3TtktpmacdV3scDKlgbCtdKSZlscMxl8FXQpxiJDvRmHsPcvh8hjVC6kvqDNc/1LDltcGZdn5czzslOGBRyvQ9hAzW+u1nTyEHaN6E3A2/jLJKplO34Yiv32JSyghVpcxkuTDu8QS3jlYXiVAcxpPPg6b6xmoqv8OQsRXgSWg5oFCltP0laB0elhHCt4vv5nY66qOhWNzFA1OJMlYcA7TYnBgNkow5GP85agIUqGmlWb5gm56/JkTRiQ5WUNO1++zKsvzM5XrU5q2eTY5HPl0sFnUUcNtCK5N8z7AMAz/B6wW8lZAAMIn9UNs2Gi5rdYymBwtqvxd48L49awgnQG+1OfT416BpD4MBHih12F3m4RtV2iIsZxuKmkmuwSuBEPacUFn9A7JPDLdWYGveLDbcZ8iuVi1gQMl0NmqIfTjV7AJLA6WrwhEgERIxRY5lUzKfxv8Mjxh
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(8676002)(6266002)(2906002)(356005)(82310400005)(7636003)(921005)(40480700001)(41300700001)(316002)(42186006)(186003)(7416002)(47076005)(8936002)(110136005)(2616005)(70586007)(42882007)(26005)(336012)(5660300002)(83170400001)(82740400003)(54906003)(478600001)(36756003)(36860700001)(4326008)(40460700003)(6666004)(70206006)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 12:34:34.9311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c5a4990-9789-4c71-cb5c-08da964d7b37
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT026.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7850
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the dynamic configuration which takes care of
configuring the GEM secure space configuration registers
using EEMI APIs.
High level sequence is to:
- Check for the PM dynamic configuration support, if no error proceed with
  GEM dynamic configurations(next steps) otherwise skip the dynamic
  configuration.
- Configure GEM Fixed configurations.
- Configure GEM_CLK_CTRL (gemX_sgmii_mode).
- Trigger GEM reset.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Conor Dooley <conor.dooley@microchip.com> (for MPFS)
---
Changes for v3:
- Introduce goto for common phy_exit return path.
- Change return check to if(ret) for of_property_read_u32_array
  and zynqmp_pm_set_gem_config APIs.

Changes for v2:
- Add phy_exit() in error return paths.
---
 drivers/net/ethernet/cadence/macb_main.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 66c7d08d376a..4769c8a0c73a 100644
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
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to read power management information\n");
+			goto err_out_phy_exit;
+		}
+		ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_FIXED, 0);
+		if (ret)
+			goto err_out_phy_exit;
+
+		ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_SGMII_MODE, 1);
+		if (ret)
+			goto err_out_phy_exit;
+	}
+
 	/* Fully reset controller at hardware level if mapped in device tree */
 	ret = device_reset_optional(&pdev->dev);
 	if (ret) {
@@ -4629,6 +4649,8 @@ static int init_reset_optional(struct platform_device *pdev)
 	}
 
 	ret = macb_init(pdev);
+
+err_out_phy_exit:
 	if (ret)
 		phy_exit(bp->sgmii_phy);
 
-- 
2.25.1

