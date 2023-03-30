Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4259C6D0EA5
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 21:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjC3TX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 15:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbjC3TXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 15:23:40 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD95EE046
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 12:23:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwubIfqygh2SnmFuY5EAGDvhwc6zbgVpWHDiQCT5CiMpyWMfDLx7cPfEsNnHtE0ACsrxQKVJaeC6w0CyNq+/6sRI91i4MA6ne2dWTQURksIvp4jJDFhvBuWKZc1x/04BLvm8Keo9EFuMyCwrtdgAMaoy6Fg5L9IxOHX1sF4XEuZcikX6GcKhKKuNmzkZslLEIHxSKhx5acY6hgdfHBaXv5tpe2seGZ8bBR6cMlz5f0CyKQ66b8O84x1CQYMalfj/WPKzcEsfQOYS8kNJhk3O1lfBdmnVXlUsWur6VB6/fJpkBWCWRG9ou37JIfwkrnjVClnKVXbei3SrQTVybp4IGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nc1kVQJlBRcXcBa2hkxcG0V6V1GgNS6/mESaHdfsPg8=;
 b=SbsBGNkXy0nEg1gGoI3yW/7+Vkk1+NqoBrL6DyQNcabyUzhQsWh94Rhrkz4ux3B24jupeug3VaFPDY89xyo6wnszyaIy8g6NrxSFmbNVwViWVKjzM1721HB1AN5adxxiYFg08BTs9zft9skyJDftVyjwjFszRKEGIFusYS71hj3H2yx3N7gwy/mOSA+hKuHdVooIUz8E/49lW2B/xCiH+Rdaej4GcYP78rhiLXH4YRIiNlIfO1LXukS/BHUWXHF1BORsVRrJ7Hzmat3hRiOvjD/LiZfcFwGLdoE9Tq0nRfrZHcXalbEJ2SJpHed2PtSIhiT4uuqnAWVI4tuG9WaqYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nc1kVQJlBRcXcBa2hkxcG0V6V1GgNS6/mESaHdfsPg8=;
 b=LnWhWveWi49+rIYZ9Jjz6/ruFSyvG80iZ7AGglG/mobgiftIYNmF4PnPlRXVF6MLA4ztmA/OimO5lx9DS3Ag6tHR13uStVSgueGjTEfgqdhQw+D4L2Fnkj6oueeN/jxTYD19kvNTNo8msjTpCZMDkrJPUWfXacszq0xHebkCAGU=
Received: from MW4PR03CA0052.namprd03.prod.outlook.com (2603:10b6:303:8e::27)
 by SN7PR12MB8102.namprd12.prod.outlook.com (2603:10b6:806:359::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Thu, 30 Mar
 2023 19:23:35 +0000
Received: from CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::64) by MW4PR03CA0052.outlook.office365.com
 (2603:10b6:303:8e::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 19:23:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT114.mail.protection.outlook.com (10.13.174.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.22 via Frontend Transport; Thu, 30 Mar 2023 19:23:35 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 14:23:32 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v7 net-next 04/14] pds_core: add devlink health facilities
Date:   Thu, 30 Mar 2023 12:23:02 -0700
Message-ID: <20230330192313.62018-5-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330192313.62018-1-shannon.nelson@amd.com>
References: <20230330192313.62018-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT114:EE_|SN7PR12MB8102:EE_
X-MS-Office365-Filtering-Correlation-Id: c3546876-4d28-4e27-8bd4-08db315441e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WsLu8sgtsQxoajOox0lcjAkv75F6TFq1jHB/HB3LUx/4IbPGqh8mSxN72wGg3jfC0eFWQXdPHhz1JkVUGtd7eQGz5Tej55UC/1SX98lc9rm9PdPM9SZq7PbetD3NojGFHHof2qW2CIBUKuLimMCMS5tezKlwALrdvcG/uZe8Qse06IeZ+LIAtOpxF9LywG1DDdRPEq2RzlCCfbzDe0pALe0xmFUzdGFKrHk3/DLSRKMaKK7fS86ETPpUG3kWWK+REwzudeIY2BbGsJV+1OsIZmK9v2idAA1FkQCHVjYH8CUTKExwcpFzX1d4e7BXhFQ0sjldfr6bVBFwvJh/CPysy5/yr42qk13OM1AAK9xBr2QwyQSMpGo+EgFkzHoNMSQ0C3ittufA8CasYxHTrD7jVTHPUb9OUPefnvgccBpDRQc4RM2ryNzE0jgOlVVMYheRoiLVIh8YZRJO1AH35Mp6YGRebzMUmqPiqv3sEGSeiBbhMivFXJEK7jVCNb+fVnwWkzN5Xw9cmF74tkAbJh1RPmag6BfHY5GbKnAMcSvBlNNXqsTSENmm5Jccu9blpH02dOyhXlo9dAGVSruD5yPP5woCnCNDZK/AD0xKKJRcsILgX4qyQT09FwfwOCH6w1l2zogo98xclvwUcDUGJvtwetj2lkzG8uMhAfJ8XvTVCBVHDD2FSbJasMEWkrkAD1gSXECVbpJY5NuTarU7bL81/V2oBqkuB93cbn1VKhZyWFo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199021)(40470700004)(46966006)(36840700001)(4326008)(36860700001)(40480700001)(70586007)(70206006)(40460700003)(54906003)(316002)(478600001)(8676002)(2906002)(47076005)(110136005)(6666004)(5660300002)(1076003)(26005)(44832011)(2616005)(83380400001)(426003)(82310400005)(81166007)(336012)(16526019)(86362001)(36756003)(41300700001)(186003)(356005)(82740400003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 19:23:35.3874
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3546876-4d28-4e27-8bd4-08db315441e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8102
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
index c73862898fb9..45ed9e9ecc6b 100644
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
+		devlink_health_reporter_destroy(pdsc->fw_reporter);
+		pdsc->fw_reporter = NULL;
+	}
 	devl_unlock(dl);
 
 	if (!pdev->is_virtfn) {
-- 
2.17.1

