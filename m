Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC5E58559D
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 21:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238844AbiG2ThS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 15:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238745AbiG2ThR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 15:37:17 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D8087C20;
        Fri, 29 Jul 2022 12:37:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ty+6yc8lpFwJYMvqSUr2Nza57ySRJKofNkpuCBtgDmQw0LZVuRhZYqjJfDJOTwvgGIwIkkfFWlEXsvHrDif2hRzToPZNddMhuY6xMu62HR24CoIAkAsMT6ZUXVjlhNei2rQhOc+GWguOujUqll+ZaG4AjiWNA0MuxVEmKPzMoR5BUZ3i2h9cSGTnrTTM0t12+iahT8/4ZdcbwtQcraamNiQxtHTYThF/7kKXb4ONxQYaZzyqFScfVl0/AY+kvf36z86aBV5B4PQX5kA/BloZBV8uYLqqaOTxg+hQgeL+ZouEIbNDWvQrbNXETxKfCs5nVsyRNqgxGFXwORgBBywLNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yu7IQxFIGve9bKAtpfiF43uh1bouRkixqOEp3eisZIw=;
 b=fUlDK8TdMU4pZVvmK5A5x5yhfj6OdRXlYEHRzwWsa+LAqTzF0M7nXXy8aW1beits9llbJ3jowVQ7aYNmRdgXmJ0BGhCCgl1R34EyUTkg0ofkcyZNrb3eTc7ueD1MPl4iX1dUno3tZLw5GuIP3G7VRS+VhofDmeEQYRJ6r7c7xvT0b4IDGtESIwUrqIqx8f2O8I4v9MQtSPEoPS1VEIx4dXkguk4G4snOpetC/mCnJz8MaXJNqk8lUQ2gdzf8CoESMcljH1H0XLjr1pFqJt3MMIiwmgftjNSgoxzDp8QbHwPK0gWxP5O8EJpUi6kWfWpfCtZYQ4tGgesuaXSdvs+kcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yu7IQxFIGve9bKAtpfiF43uh1bouRkixqOEp3eisZIw=;
 b=iyeygUBANFbJWcksc25fTvFFtSJLO4bLlaRhUjhyP8pulqjlDuHJ3i2UOT0Nis+hB09UIqB0j2vYWg4+cDgsreNrjNnUYLZfYM6Yn3bCZLHO9J6jWkJ6qzUA3Ao0CNU2MmiJ0WSefzx73kG5Bvbfr32PhFR1iwbq/V6sMzEnPPQ=
Received: from DS7PR05CA0021.namprd05.prod.outlook.com (2603:10b6:5:3b9::26)
 by DM5PR02MB3752.namprd02.prod.outlook.com (2603:10b6:4:b0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Fri, 29 Jul
 2022 19:37:13 +0000
Received: from DM3NAM02FT048.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::d2) by DS7PR05CA0021.outlook.office365.com
 (2603:10b6:5:3b9::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.8 via Frontend
 Transport; Fri, 29 Jul 2022 19:37:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT048.mail.protection.outlook.com (10.13.4.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Fri, 29 Jul 2022 19:37:13 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 29 Jul 2022 12:37:12 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 29 Jul 2022 12:37:12 -0700
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
Received: from [172.23.64.3] (port=58456 helo=xhdvnc103.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1oHVnL-000GzJ-TD; Fri, 29 Jul 2022 12:37:12 -0700
Received: by xhdvnc103.xilinx.com (Postfix, from userid 13245)
        id 3D16D1054B2; Sat, 30 Jul 2022 01:06:43 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <michal.simek@xilinx.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@amd.com>, <git@xilinx.com>,
        "Radhey Shyam Pandey" <radhey.shyam.pandey@amd.com>
Subject: [PATCH v2 net-next 2/2] net: macb: Add zynqmp SGMII dynamic configuration support
Date:   Sat, 30 Jul 2022 01:05:50 +0530
Message-ID: <1659123350-10638-3-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1659123350-10638-1-git-send-email-radhey.shyam.pandey@amd.com>
References: <1659123350-10638-1-git-send-email-radhey.shyam.pandey@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11984e9e-8143-4202-be28-08da7199bcbf
X-MS-TrafficTypeDiagnostic: DM5PR02MB3752:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cckMJcQvLxcrUDrKr60BTF1N5t3/LhTwpApS4qmlipTozDegnDGPQyUhUZiNW2mLx3ZUsZrxDWQFJ3n/Mhc4Swx87tEV/glHDCWBW7RDnmWmkYOErsER6kIOh/Gc/E199u1LVCoEkTttrgG0glCvgu83wRRot7PMinbiYAdgX9yLywAoqWH9C1WmB65ASyqQMpsjfjdqWDKaPo7hGaFnGvkgopmozDf37X9AhmunK/9+EhEQBwpIbbs2WGcJP+EbZYYvz+vzqfZoi3RF+GY5s+D47snyptO+pglyP6bsJPR5uTM6UAXIaN0lOPCKgabnWQLaEx9153fimSztaDmHK8Jdd1xGZImcz5HrTpRPFJUCcMSTd5EQqGT0JwSmOtgMPKk5DomjM5zGNUdvYiCgqC/iGEvA5k3TgoREgAp1ki2ePVrSQupocOq4ZQOA4jZE7K57qYl5CjiwmbBKuOLpc0QWe9xq+MIEZ0Mkw8OiPZ7cmAZQlzHrJQmtF9ftw1laYXezwIPOsAB9aWLBGdVBRFxFs0H/R45KVWmBTjnGm/HkvMbHqqu1RSj7NOGTQKoghmbebeAmzS1lVq5/3geDSElDvwNfmInYd+QgkJo7lE9ZEowBRdSBXM0YgQ6+WqUjSQuuzp4HIptLwtrHyrjAdRy+8EVHol8LtG1ACcAIJPKUl1tKQb0WVFaCqeRnYFMsi2C8BpE3FoVzisr2r/DaRr1hGBBLznTFdrywbL5edj9ApgVClVtECcxUrZk3Fxw+EothN8fdutDhK98UgYaW0mWygx1jRXm4D3Iv4XCHnDai/T9MP6rWLjOGujvjpRsgy2yUmMNOL3czGtsi7cpG6A==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(396003)(136003)(40470700004)(46966006)(36840700001)(47076005)(7636003)(6266002)(26005)(82740400003)(83170400001)(336012)(2616005)(40460700003)(41300700001)(356005)(186003)(6666004)(36860700001)(42882007)(40480700001)(70206006)(5660300002)(4326008)(70586007)(82310400005)(8936002)(36756003)(316002)(2906002)(110136005)(478600001)(7416002)(54906003)(8676002)(42186006)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 19:37:13.6026
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11984e9e-8143-4202-be28-08da7199bcbf
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT048.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB3752
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Conor Dooley <conor.dooley@microchip.com> (for MPFS)
---
Changes for v2:
- Add phy_exit() in error return paths.
---
 drivers/net/ethernet/cadence/macb_main.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 4cd4f57ca2aa..517b40ff098b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -38,6 +38,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/ptp_classify.h>
 #include <linux/reset.h>
+#include <linux/firmware/xlnx-zynqmp.h>
 #include "macb.h"
 
 /* This structure is only used for MACB on SiFive FU540 devices */
@@ -4621,6 +4622,30 @@ static int init_reset_optional(struct platform_device *pdev)
 					     "failed to init SGMII PHY\n");
 	}
 
+	ret = zynqmp_pm_is_function_supported(PM_IOCTL, IOCTL_SET_GEM_CONFIG);
+	if (!ret) {
+		u32 pm_info[2];
+
+		ret = of_property_read_u32_array(pdev->dev.of_node, "power-domains",
+						 pm_info, ARRAY_SIZE(pm_info));
+		if (ret < 0) {
+			phy_exit(bp->sgmii_phy);
+			dev_err(&pdev->dev, "Failed to read power management information\n");
+			return ret;
+		}
+		ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_FIXED, 0);
+		if (ret < 0) {
+			phy_exit(bp->sgmii_phy);
+			return ret;
+		}
+
+		ret = zynqmp_pm_set_gem_config(pm_info[1], GEM_CONFIG_SGMII_MODE, 1);
+		if (ret < 0) {
+			phy_exit(bp->sgmii_phy);
+			return ret;
+		}
+	}
+
 	/* Fully reset controller at hardware level if mapped in device tree */
 	ret = device_reset_optional(&pdev->dev);
 	if (ret) {
-- 
2.1.1

