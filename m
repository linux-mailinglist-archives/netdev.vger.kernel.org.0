Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04DE6E8011
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbjDSRFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbjDSRF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:05:26 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2071.outbound.protection.outlook.com [40.107.96.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAF27EE4
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:05:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcAKmYSmaqbOA1HJpnjPDIuUTWRswSZ/bXiORqx5115Dp7UmpQkRfWC0kexrPuvHivA1AZ8IO+TjAba85aTfd0UHj8/CgIe4XHsLYpf/LslNzWmwxuOgWgwsv603B/k/doQ+oTpWM721gjrWsNgQo+B+DzIfEcSgw0E9CDgWIAsACQGtHZXW70wD0uIN3LFkyDQZehTyBNiDwOROTvanU9CrL4iL6NHvbBXZa4lPJeOnZKMxufyxhWM4UhJGN2+HniLReUWh4vLKQklaCyXVHfiDWl+GuWRNiWkgEWtxrhMRzte4DQZ/5YAo1XDwYqXNHHTA3nRGtZFS4ZYk0XiLGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDcFHr1Yohqfi/1GIANVH5wT46jZ3+ENTWafNDbPT8I=;
 b=CfN0MvYxx3AVR9VcS/kJWgox0Z9wvSeOQzUWVb+S992JbYKZLprmhpuL6ZEA3z5VfddfeQiKjNYj5hnEBbJm8Fmd8JoeCKoVAOWhld5RpobHos84qNKepSp5gNWs3ABDPbLF4OMkTIk12tBBolPvXizlcXe8ReVIlwLx3uPyRVxTkgxuqL1GVU2n7psX0RzinuT5GEWVWLmVSkaf60lQJqcxdQt2gbbSCervbslP+W+bhfLZX++6sORyXGEVMaCFsi8tWejw+4kxuyju96rdisef3Hg40Gk6AtlFFV3s6yVDEn7BNl1Q1tuu+s/012ghRqI60DdFqToWlm9yPn7SyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDcFHr1Yohqfi/1GIANVH5wT46jZ3+ENTWafNDbPT8I=;
 b=q2rSIb8b6XLycWZXdt1zCGgWQp0JRvHwOJIkLrlESYMt3Pa9WO3W+dlSo4BtqcGh88T4qTG6gsHf1k1piToh48aLg+rlIVJ7pPjgcI2FsGoeDA5bqXzcTwytCv81OmEgaNZkJzh73btmwBE5YLhG7Zy9Fqm+dBJLNG+V6kiI25g=
Received: from MW4PR04CA0277.namprd04.prod.outlook.com (2603:10b6:303:89::12)
 by CH3PR12MB8852.namprd12.prod.outlook.com (2603:10b6:610:17d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.21; Wed, 19 Apr
 2023 17:05:17 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::de) by MW4PR04CA0277.outlook.office365.com
 (2603:10b6:303:89::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22 via Frontend
 Transport; Wed, 19 Apr 2023 17:05:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.30 via Frontend Transport; Wed, 19 Apr 2023 17:05:16 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 19 Apr
 2023 12:05:00 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v11 net-next 04/14] pds_core: add devlink health facilities
Date:   Wed, 19 Apr 2023 10:04:17 -0700
Message-ID: <20230419170427.1108-5-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230419170427.1108-1-shannon.nelson@amd.com>
References: <20230419170427.1108-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT030:EE_|CH3PR12MB8852:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dd002e1-c3fa-49a6-6b56-08db40f83fe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VEkByzayLfPvNtGhf9m9Jm2jpx5/RP0LBUlLU7v7fIkeg8CQKnCWN4Qi+y/bm7y/ldXz6mafGS5DkLRKAbHZ2ekgOprVjgpdhh1SVryqgwrgZhAtAtsJNgpdqYY+c9Wd5YP+gs+6Z3MoKpy3Mw/TyHoXSChW5Ay6eEZ26vHnYYRfZcJFd2HWhntNtZWe60wJdScBlovLYjbpDig/j8JPXrVH1KPYjp0+U9z8f5UQSBWz0Gf0r+pYy6y07a6AmztTz3ibiTq9blYWF1mbQED6edHfx0dqD4gvdPSCXchphtHMgo4rllWdugPec0uKIPYvoTfO9h4AnbtspztQZ7Eli4XfS+ClzhJ4JlTGPJVyOqXdMOizWaC1zPrb4O4sipx37D9kgXuUZce/aHvJd6N2PCpgcUYoRSoKZHKD3nqU9qTcLrElY0fMgTo1bM6ii0V2+hu53bDkIoWkZkDvAXGrnvrVkQq8wsp/RLjE+SchvfI918HNVHoU5ZySR62RY38O1lEE9N8RgG9jivvVtunIRFWrOcRR32mTomGMIPOBm5h9gyKGLUSDqJX6d2hxDjS/j/12cdECAUQ+O2yIjzxUyYmSd3+EKmb0FigNp01XYFdwYk/XjdPQcCt/n7Dfg2VWUvu8OPWDMDPqPxzfHd1UEQDfOXRsWvqK6SJaj6yWwkLxLAZgjPdl56EH0OXM1gMFbinQdta5QZUHxmNNGgJmpuJRhvYFNptuJg8AO+ikhQM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(396003)(376002)(451199021)(46966006)(36840700001)(40470700004)(356005)(82310400005)(81166007)(82740400003)(40460700003)(40480700001)(6666004)(86362001)(16526019)(186003)(2616005)(54906003)(316002)(426003)(478600001)(336012)(110136005)(83380400001)(26005)(1076003)(4326008)(41300700001)(47076005)(70206006)(70586007)(36860700001)(44832011)(5660300002)(36756003)(2906002)(8676002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 17:05:16.9143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dd002e1-c3fa-49a6-6b56-08db40f83fe1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8852
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink health reporting on top of our fw watchdog.

Example:
  # devlink health show pci/0000:2b:00.0 reporter fw
  pci/0000:2b:00.0:
    reporter fw
      state healthy error 0 recover 0
  # devlink health diagnose pci/0000:2b:00.0 reporter fw
   Status: healthy State: 1 Generation: 0 Recoveries: 0

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 .../device_drivers/ethernet/amd/pds_core.rst  | 12 ++++++
 drivers/net/ethernet/amd/pds_core/Makefile    |  1 +
 drivers/net/ethernet/amd/pds_core/core.c      |  8 +++-
 drivers/net/ethernet/amd/pds_core/core.h      |  6 +++
 drivers/net/ethernet/amd/pds_core/devlink.c   | 40 +++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/main.c      | 22 ++++++++++
 6 files changed, 88 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/amd/pds_core/devlink.c

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
index 99a70026f1bc..5b88173a20ff 100644
--- a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
+++ b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
@@ -26,6 +26,18 @@ messages such as these::
   pds_core 0000:b6:00.0: 252.048 Gb/s available PCIe bandwidth (16.0 GT/s PCIe x16 link)
   pds_core 0000:b6:00.0: FW: 1.60.0-73
 
+Health Reporters
+================
+
+The driver supports a devlink health reporter for FW status::
+
+  # devlink health show pci/0000:2b:00.0 reporter fw
+  pci/0000:2b:00.0:
+    reporter fw
+      state healthy error 0 recover 0
+  # devlink health diagnose pci/0000:2b:00.0 reporter fw
+   Status: healthy State: 1 Generation: 0 Recoveries: 0
+
 Support
 =======
 
diff --git a/drivers/net/ethernet/amd/pds_core/Makefile b/drivers/net/ethernet/amd/pds_core/Makefile
index 95a6c31e92d2..eaca8557ba66 100644
--- a/drivers/net/ethernet/amd/pds_core/Makefile
+++ b/drivers/net/ethernet/amd/pds_core/Makefile
@@ -4,6 +4,7 @@
 obj-$(CONFIG_PDS_CORE) := pds_core.o
 
 pds_core-y := main.o \
+	      devlink.o \
 	      dev.o \
 	      core.o
 
diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 701d27471858..ab8531386226 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -5,7 +5,7 @@
 
 int pdsc_setup(struct pdsc *pdsc, bool init)
 {
-	int err = 0;
+	int err;
 
 	if (init)
 		err = pdsc_dev_init(pdsc);
@@ -42,6 +42,8 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 		return;
 	}
 
+	devlink_health_report(pdsc->fw_reporter, "FW down reported", pdsc);
+
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
 }
 
@@ -58,6 +60,10 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 	if (err)
 		goto err_out;
 
+	pdsc->fw_recoveries++;
+	devlink_health_reporter_state_update(pdsc->fw_reporter,
+					     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+
 	return;
 
 err_out:
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 83c528a2a131..32aa38c40024 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -68,6 +68,8 @@ struct pdsc {
 	struct timer_list wdtimer;
 	unsigned int wdtimer_period;
 	struct work_struct health_work;
+	struct devlink_health_reporter *fw_reporter;
+	u32 fw_recoveries;
 
 	struct pdsc_devinfo dev_info;
 	struct pds_core_dev_identity dev_ident;
@@ -88,6 +90,10 @@ struct pdsc {
 	u64 __iomem *kern_dbpage;
 };
 
+int pdsc_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
+			      struct devlink_fmsg *fmsg,
+			      struct netlink_ext_ack *extack);
+
 void pdsc_debugfs_create(void);
 void pdsc_debugfs_destroy(void);
 void pdsc_debugfs_add_dev(struct pdsc *pdsc);
diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
new file mode 100644
index 000000000000..3b05b1af65d1
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include "core.h"
+
+int pdsc_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
+			      struct devlink_fmsg *fmsg,
+			      struct netlink_ext_ack *extack)
+{
+	struct pdsc *pdsc = devlink_health_reporter_priv(reporter);
+	int err;
+
+	mutex_lock(&pdsc->config_lock);
+
+	if (test_bit(PDSC_S_FW_DEAD, &pdsc->state))
+		err = devlink_fmsg_string_pair_put(fmsg, "Status", "dead");
+	else if (!pdsc_is_fw_good(pdsc))
+		err = devlink_fmsg_string_pair_put(fmsg, "Status", "unhealthy");
+	else
+		err = devlink_fmsg_string_pair_put(fmsg, "Status", "healthy");
+
+	mutex_unlock(&pdsc->config_lock);
+
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "State",
+					pdsc->fw_status &
+						~PDS_CORE_FW_STS_F_GENERATION);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "Generation",
+					pdsc->fw_generation >> 4);
+	if (err)
+		return err;
+
+	return devlink_fmsg_u32_pair_put(fmsg, "Recoveries",
+					 pdsc->fw_recoveries);
+}
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index c9fbf1d374a7..54f3aed7adb1 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -130,10 +130,16 @@ static int pdsc_init_vf(struct pdsc *vf)
 	return -1;
 }
 
+static const struct devlink_health_reporter_ops pdsc_fw_reporter_ops = {
+	.name = "fw",
+	.diagnose = pdsc_fw_reporter_diagnose,
+};
+
 #define PDSC_WQ_NAME_LEN 24
 
 static int pdsc_init_pf(struct pdsc *pdsc)
 {
+	struct devlink_health_reporter *hr;
 	char wq_name[PDSC_WQ_NAME_LEN];
 	struct devlink *dl;
 	int err;
@@ -172,6 +178,16 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
 	dl = priv_to_devlink(pdsc);
 	devl_lock(dl);
+
+	hr = devl_health_reporter_create(dl, &pdsc_fw_reporter_ops, 0, pdsc);
+	if (IS_ERR(hr)) {
+		dev_warn(pdsc->dev, "Failed to create fw reporter: %pe\n", hr);
+		err = PTR_ERR(hr);
+		devl_unlock(dl);
+		goto err_out_teardown;
+	}
+	pdsc->fw_reporter = hr;
+
 	devl_register(dl);
 	devl_unlock(dl);
 
@@ -180,6 +196,8 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
 	return 0;
 
+err_out_teardown:
+	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 err_out_unmap_bars:
 	mutex_unlock(&pdsc->config_lock);
 	del_timer_sync(&pdsc->wdtimer);
@@ -283,6 +301,10 @@ static void pdsc_remove(struct pci_dev *pdev)
 	dl = priv_to_devlink(pdsc);
 	devl_lock(dl);
 	devl_unregister(dl);
+	if (pdsc->fw_reporter) {
+		devl_health_reporter_destroy(pdsc->fw_reporter);
+		pdsc->fw_reporter = NULL;
+	}
 	devl_unlock(dl);
 
 	if (!pdev->is_virtfn) {
-- 
2.17.1

