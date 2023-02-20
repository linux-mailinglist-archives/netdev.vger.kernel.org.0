Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA5D69D5DF
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 22:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbjBTVi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 16:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjBTVi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 16:38:27 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2049.outbound.protection.outlook.com [40.107.95.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2474644A6;
        Mon, 20 Feb 2023 13:38:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ca2vasW2YFlcEcTK8kivHX1LfFQhnFxdaxKOTRWACAGEc5JHhNmtB7V58fgSjov23QnkSYQGiGfEvt7DeQNPDaRpkl2EGRUlizyjgvr5/I71NENtf55A36qzCu94q0jVdgQAeb/UKL0WvQ4Apq9N1EpqDJv6nlBkRQM2br7D1sI2QNooQvBda7K3gDUB30rON9UczwzlZLr7GtLkVO9ZEujoLeMCeKoFCIboZEHHkOq1MknLdnB13cuT4Z7FrWFLwTUyFDwGOsjGK6VOhPpxPDJH6KETORvn75o4xGmBwacFjC98I0/5NNoJREMuhD7kb1g+hYLqL6ALKbgRXtPi6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUkGOzt/+Hbe+de4gZgHZAUJWSh1j4FCkwg3wdLxzlY=;
 b=Aw6vfGrv11mYd1ftbN/BXhLxEPt6Vagxa/PXyIfheRU2ggPcVIo/uAFtKWDn4z1CUvw5DdPzgdp1k5Ry+7PLU1hyXc7+dRhVdV5aOu9A+PczhdzL6Qa+vSwPyEPs9M/9nnK/wLwQ8NiPKLYn6yyP55Wr0IHvNH2nBMhMUhD3ccIb/ZILFAHn/W8+ntzT5pkVlpeqTNV9nzz9AAIwAk4ovGZB9GH1snrbGTm694rOIs+ftzlHxFDYkdFRUhicIUBatfi7bE3HPq/Nu558Oud8zaACPJeWqHFWuNrtr5eLdr8C70jxFGXe5Ko6vIBFpBZ4xISG7yGtpX6gAZGUjxwUMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUkGOzt/+Hbe+de4gZgHZAUJWSh1j4FCkwg3wdLxzlY=;
 b=j4dL361i+XM+eTtOz9DXodc1HpU+ex1UjtrfjK1Igl87nt5CAqlTnOiRiheYB6qI5kg2zANcYtCUINpbAAbpYSigcWIOErsdv5sEYnEftgUYvR6fYq+VumBuEjbojZoZPV75ft2NGacKCHADBfDCBDW5D6NXBOnkFk1EbUJbKPQ=
Received: from DM6PR13CA0062.namprd13.prod.outlook.com (2603:10b6:5:134::39)
 by DM6PR12MB5008.namprd12.prod.outlook.com (2603:10b6:5:1b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 21:38:23 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::e0) by DM6PR13CA0062.outlook.office365.com
 (2603:10b6:5:134::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.16 via Frontend
 Transport; Mon, 20 Feb 2023 21:38:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.18 via Frontend Transport; Mon, 20 Feb 2023 21:38:23 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 15:38:22 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     Kalle Valo <kvalo@kernel.org>
CC:     Mario Limonciello <mario.limonciello@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] wifi: ath11k: Add a warning for wcn6855 spurious wakeup events
Date:   Mon, 20 Feb 2023 15:38:07 -0600
Message-ID: <20230220213807.28523-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT048:EE_|DM6PR12MB5008:EE_
X-MS-Office365-Filtering-Correlation-Id: c87f3562-213b-4d04-c160-08db138acaf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gH7ypasQzs6lFqO3odqCOic+d4gfuDyMZYpbXXJ0yLM7nxnZHbvZ2/DmKiaSnq6M8GW0oG8YOiMxhYrWNvt4wYkfvQ4u0v8UD/s+81r9OKsVSBywc92gpxVvXhVhwWyYKntujzuhQs+1Hghchs/rIrgHFpktiwnuEWJNWNZrjMmgjsv26DKA3VDbUiQO1HpBP9IIFNnQBHK1xCfYSGSKmttWkus8jBGFXiOJzU3pB7BoyBm/fKGRSltpnCjXmZk0760pmVLj5m2sYiGGOKzXlp84MmjrcX7y1o93CYCfXcxMbDUlHuTrX3k2ZZDMLeX7uBJk51NfRTUEeJnHYDhg6jI9hlJkkr6PmA6F1k74uKi4HExiWAaERNiLlpUxb+wI3hdSV9BwpsL8r/FrutPNiDpbU+/fNTmHo3PjWAW8XriDQ7eouh12urVwQiRDrqX2wQq73ZPqyxDxR6CEnMvp9TwAJS1NKpJrbuytmgJXCrT7Qr3bfKn8VOp1cZuH5OeVOFksbp89Ntor+mIFNs+jCJZN0Kn0yRPMGturp123uMnyU5LwSpz3KLXiLDqjOpyI48sAV3+xqgNT2vQoV+vF1PvqhRBaRGLHTsxlR/wy13nmHBKCcdoXhBhwU85lEM0/NYpH8VKlRQD4BQ4vkYnC35Finkd9NvIU087JCHIzD0S/VMULZ/An37Pm5NIYReELs+VCGXohXpRNXxmCXKrzqoXFcp9Z63FQIpGbESnPT1cIVdYGG8gZd8fAHoeTk/6/LxQuafveJeqqVm87cxanFg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199018)(36840700001)(46966006)(40470700004)(5660300002)(36860700001)(8936002)(47076005)(426003)(83380400001)(356005)(40460700003)(86362001)(40480700001)(7696005)(81166007)(336012)(54906003)(316002)(478600001)(82310400005)(82740400003)(4326008)(41300700001)(70586007)(8676002)(6916009)(16526019)(1076003)(2616005)(36756003)(966005)(6666004)(26005)(186003)(70206006)(2906002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 21:38:23.3793
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c87f3562-213b-4d04-c160-08db138acaf5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5008
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When WCN6855 firmware versions less than 0x110B196E are used with
an AMD APU and the user puts the system into s2idle spurious wakeup
events can occur. These are difficult to attribute to the WLAN F/W
so add a warning to the kernel driver to give users a hint where
to look.

This was tested on WCN6855 and a Lenovo Z13 with the following
firmware versions:
WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.9
WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.23

Link: http://lists.infradead.org/pipermail/ath11k/2023-February/004024.html
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2377
Link: https://bugs.launchpad.net/ubuntu/+source/linux-firmware/+bug/2006458
Link: https://lore.kernel.org/linux-gpio/20221012221028.4817-1-mario.limonciello@amd.com/
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/net/wireless/ath/ath11k/pci.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 99cf3357c66e..87536327e214 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -8,6 +8,7 @@
 #include <linux/msi.h>
 #include <linux/pci.h>
 #include <linux/of.h>
+#include <linux/suspend.h>
 
 #include "pci.h"
 #include "core.h"
@@ -27,6 +28,8 @@
 #define QCN9074_DEVICE_ID		0x1104
 #define WCN6855_DEVICE_ID		0x1103
 
+#define WCN6855_S2IDLE_VER		0x110b196e
+
 static const struct pci_device_id ath11k_pci_id_table[] = {
 	{ PCI_VDEVICE(QCOM, QCA6390_DEVICE_ID) },
 	{ PCI_VDEVICE(QCOM, WCN6855_DEVICE_ID) },
@@ -965,6 +968,27 @@ static void ath11k_pci_shutdown(struct pci_dev *pdev)
 	ath11k_pci_power_down(ab);
 }
 
+static void ath11k_check_s2idle_bug(struct ath11k_base *ab)
+{
+	struct pci_dev *rdev;
+
+	if (pm_suspend_target_state != PM_SUSPEND_TO_IDLE)
+		return;
+
+	if (ab->id.device != WCN6855_DEVICE_ID)
+		return;
+
+	if (ab->qmi.target.fw_version >= WCN6855_S2IDLE_VER)
+		return;
+
+	rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
+	if (rdev->vendor == PCI_VENDOR_ID_AMD)
+		ath11k_warn(ab, "fw_version 0x%x may cause spurious wakeups. Upgrade to 0x%x or later.",
+			    ab->qmi.target.fw_version, WCN6855_S2IDLE_VER);
+
+	pci_dev_put(rdev);
+}
+
 static __maybe_unused int ath11k_pci_pm_suspend(struct device *dev)
 {
 	struct ath11k_base *ab = dev_get_drvdata(dev);
@@ -975,6 +999,8 @@ static __maybe_unused int ath11k_pci_pm_suspend(struct device *dev)
 		return 0;
 	}
 
+	ath11k_check_s2idle_bug(ab);
+
 	ret = ath11k_core_suspend(ab);
 	if (ret)
 		ath11k_warn(ab, "failed to suspend core: %d\n", ret);
-- 
2.34.1

