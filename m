Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5D76D1390
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 01:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjC3XrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 19:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjC3Xqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 19:46:54 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A94AB74C
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 16:46:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+PUYbhZIYmNhh5TVYMP8HrzVKz8BqBvY5OFrlPeCM88/Xj7oaxaA2FMiaQyKCx0230Plkps0hxRlfQbDjYMXruMmPgPbIM7eDYQSPbY8SfhqnXeaTKAxx5z7Pst3cWR/nmwHvC8iWylHzC3jCvCCZ6o/TMX4ADQ2lQo+M4jJF4jcFXj8ZEZG909TmexFPFTR8F4eanIJftHuETTe6BEdZGZLsHA5V9pLAG9dp8KnqDcmfzIW4Ylqws+58zHSsU3YdtFvLkQkv1rzdKoJzFXqpvTWX2zaFqFLUgKcHVMNJqSdvyuzy4wzL4ib/3vAQjYLoo0EdGon8gWbgH7RP1EZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PbH9kCee4Pjs7BXtChidDe/GqSFDHf/pVWrAV8IbMig=;
 b=jhJynZddV/5ZIp/RrsBcZQUHzHlhPtZA98KsDTAOe8/Z5qmYvrdFB7sX9aCJwXbyytiwJnW/F9irbvEEjB1imdLnZirnSABirQ50l13cMqiZmzLe0FkaGQ1djD8CvQCwv3HE9rijBOoNab2IWOPMz8gnoFbIXWIU3ec5EhnOs+ZiXv7uoCg5VGJYwdlv7HC/Kj9dKpN1NXOeXA2YjwRGiKvrTaiWsk4rN0f9YgfIHy4LZgmvklErZIKPRGX3r6WtEWDKdNczZ7yVGJDwjVerhwlwbV5Umd4ProTmG8UXGXDs3taS3Hc0830xqB3y7LDjJ1fgE8+zmvarDjVhpu6xkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PbH9kCee4Pjs7BXtChidDe/GqSFDHf/pVWrAV8IbMig=;
 b=Sin8cTFfA5W4MeAOjzEZFib3yDk35AURIg7zjuhjaO7ktXTzbFeGOT0VeR08zs5xgt3GXREZVu/dY7rsBnA/FIRuf9/yatajiY2OFnP/Pz0WX/Vc7MrdU5AyrKAGoKdZ6rCC9RLo3zDbqZAENHS/hzKniOBrDCFfcoDM+LuPUF8=
Received: from BLAPR03CA0096.namprd03.prod.outlook.com (2603:10b6:208:32a::11)
 by PH7PR12MB5687.namprd12.prod.outlook.com (2603:10b6:510:13e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 23:46:49 +0000
Received: from BL02EPF000100D0.namprd05.prod.outlook.com
 (2603:10b6:208:32a:cafe::e1) by BLAPR03CA0096.outlook.office365.com
 (2603:10b6:208:32a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 23:46:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000100D0.mail.protection.outlook.com (10.167.241.204) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Thu, 30 Mar 2023 23:46:49 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 18:46:48 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v8 net-next 04/14] pds_core: add devlink health facilities
Date:   Thu, 30 Mar 2023 16:46:18 -0700
Message-ID: <20230330234628.14627-5-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330234628.14627-1-shannon.nelson@amd.com>
References: <20230330234628.14627-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000100D0:EE_|PH7PR12MB5687:EE_
X-MS-Office365-Filtering-Correlation-Id: c0002b0a-cbf9-43ed-3d64-08db317907c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QjNpij8am2tF2tLEDTzD7xQr9h0BpCillkXpthlOe4p9EOqRw/zgDrTVBylWTdPTP75XNrkOvPVbMrUIkSoCMyNDrVgZaPMEXJjNGk5u4fdrd6GL4fWYcU4KD4mEjP7OLSfCpT0QP975ro8mhYXTLfRtaC9nCOO/Yz6SMSF2RhLPP3LGE1IpHnWdHGCYXDAZN3x9h+lO+3fODL+T1IABDAj8U2W9DcTnptfJ0LLmQyxJyjYxD++VX/SZD7K4BrETpJRE0usQ9kfQyt4JRGhRk/OUEPVQKJqNfVVIBjT/ec3OuHWLxePLV3AFsa9xQ2KtArCTdQcn10QeA1E8ZJHRmdsZTNKflA5ATWrbC4t95VgEC+WrcArSkLgtUUQazMlVuLYhVhO43r7EVelDy83FHwnTlkf3Y1/fRGK7MNffMBUh1hFTpFk/d8bRJFjLdVSc0xrduVD5burKWaauvWk3MlPZPHLRb1VuOETKBAVzLrafPI7LPXjM5wKi6SuGJTEJnOXgPozA/QV6m3SGcSHy870RoOS4PR0rRAgeO7R9ESWl/Vw4W5BgIGh8lPCydL4oLZjoBmMGMifF0CQ6Xt3R2NQqASv/MItRDitUqqpQmE5p4DqXaJmgj+DRjtJJYB3Zcr4iVOMTmwjm8sPLCaz27fcPNi5eLs6mSLTgIAW4B1ZC6JFjSeaxbZ1Fyo6A/xoEQjDSBcGVYzz0AL/jlNgjsjdCRo4Uj4aLIiaQSFYJi0E=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199021)(46966006)(36840700001)(40470700004)(2906002)(83380400001)(2616005)(426003)(5660300002)(44832011)(6666004)(40460700003)(36756003)(336012)(41300700001)(316002)(186003)(54906003)(110136005)(4326008)(8676002)(36860700001)(8936002)(70586007)(70206006)(478600001)(86362001)(16526019)(47076005)(1076003)(81166007)(26005)(40480700001)(356005)(82310400005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:46:49.3627
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0002b0a-cbf9-43ed-3d64-08db317907c3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000100D0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5687
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
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


Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/Makefile  |  1 +
 drivers/net/ethernet/amd/pds_core/core.c    |  6 ++++
 drivers/net/ethernet/amd/pds_core/core.h    |  5 +++
 drivers/net/ethernet/amd/pds_core/devlink.c | 37 +++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/main.c    | 22 ++++++++++++
 5 files changed, 71 insertions(+)
 create mode 100644 drivers/net/ethernet/amd/pds_core/devlink.c

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
index 39e9a215f638..a9918c34018f 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -45,6 +45,8 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 		return;
 	}
 
+	devlink_health_report(pdsc->fw_reporter, "FW down reported", pdsc);
+
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
 
 	mutex_unlock(&pdsc->config_lock);
@@ -68,6 +70,10 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 
 	mutex_unlock(&pdsc->config_lock);
 
+	pdsc->fw_recoveries++;
+	devlink_health_reporter_state_update(pdsc->fw_reporter,
+					     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+
 	return;
 
 err_out:
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 8ff65f2aa7f0..d111354234fa 100644
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
@@ -89,6 +91,9 @@ struct pdsc {
 };
 
 void pdsc_queue_health_check(struct pdsc *pdsc);
+int pdsc_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
+			      struct devlink_fmsg *fmsg,
+			      struct netlink_ext_ack *extack);
 
 #ifdef CONFIG_DEBUG_FS
 void pdsc_debugfs_create(void);
diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
new file mode 100644
index 000000000000..717fcbf91aee
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -0,0 +1,37 @@
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
+	int err = 0;
+
+	if (test_bit(PDSC_S_FW_DEAD, &pdsc->state))
+		err = devlink_fmsg_string_pair_put(fmsg, "Status", "dead");
+	else if (!pdsc_is_fw_good(pdsc))
+		err = devlink_fmsg_string_pair_put(fmsg, "Status", "unhealthy");
+	else
+		err = devlink_fmsg_string_pair_put(fmsg, "Status", "healthy");
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "State",
+					pdsc->fw_status &
+						~PDS_CORE_FW_STS_F_GENERATION);
+	if (err)
+		return err;
+	err = devlink_fmsg_u32_pair_put(fmsg, "Generation",
+					pdsc->fw_generation >> 4);
+	if (err)
+		return err;
+	err = devlink_fmsg_u32_pair_put(fmsg, "Recoveries",
+					pdsc->fw_recoveries);
+	if (err)
+		return err;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index c73862898fb9..4920f3a2fbfb 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -162,10 +162,16 @@ static int pdsc_init_vf(struct pdsc *vf)
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
@@ -204,6 +210,16 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
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
 
@@ -212,6 +228,8 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
 	return 0;
 
+err_out_teardown:
+	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 err_out_unmap_bars:
 	mutex_unlock(&pdsc->config_lock);
 	del_timer_sync(&pdsc->wdtimer);
@@ -318,6 +336,10 @@ static void pdsc_remove(struct pci_dev *pdev)
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

