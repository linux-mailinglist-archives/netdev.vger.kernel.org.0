Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA756DA62E
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 01:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238587AbjDFXmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 19:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237519AbjDFXmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 19:42:25 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5761A7ED2
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 16:42:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dA1zuWerRCiQxLrgbK/1+wMjvFdZCgOCa13ykHf0qao6C3LInew80QBCM0rL8otY/F3t9pomIx26cBPC0U3Rli1+7LHIK4EeTJX+XKr+PTj/HoT3iVWE1prjZ9uQ1u2+vi6sRfUD3JLY0ZVInutFHSptAsuYj1y45XVbXNXCwDUacE2Zjwz1EQT2/1ppgMovPUzQgVksl+GDKuz98OnEi/qpSOgHh1iwFFA1VsesR1rY2iMo4SRUnWV8c/ClFEVUnxS3l/ad0J0GBk20Bn9/E10ua/rO7vv8oV/yjvQ3KYc45e7l9gCcDG8Rn1zqJD5rEbnG8I/oGGn0gOnLx0T8EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rkcx4pfo9ACYBvSE+qk60UsEWChF6m5RVB5TcmvS1A0=;
 b=LOAcCr6zGX2TEib3Pif51RM8oUumQSpMMDP7Ve9f+oFfTt7WV5q8I3iMeYRW5JsbWXXmJ2lsTw67RZNtE029ckAt2TvlxR19ZalNV/whNfhDmii/qyJg90/siMeebMx5ncpxq50j3YsFkFkCSQb1UoB1JcQEREbk9YH15QFIyPz8LQOY6F1afcTritO0ot7/46b9udxlW5MICqdlpDyjAGXo3tRtq1Uu7X2NiZlOpHDM3lUoz02+P8FXrPmP5wL90aVrcO40o+qkTXaE/RguO3KJj8yafD5FHq0e26QUJcmmpYbEasZL4YuCSzglJr/3Idcjysn/zbelepP6WY+Buw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rkcx4pfo9ACYBvSE+qk60UsEWChF6m5RVB5TcmvS1A0=;
 b=UDHBN+mZ5ejewZZImYn3cvZM4gDUHC00dRgyXNS8G/IJp9Gsl/PIuNL//aT6/t6UXsSqdWmwCWANChjZhzmpvsc9Tzep9H+Mdj1NtRvNeUmhb1E8HQh840xugdu/yJUlROQBKv7n/tghHzhQhl0EGIaoDbDAXdZuJOy+sgdVDnQ=
Received: from DM6PR08CA0016.namprd08.prod.outlook.com (2603:10b6:5:80::29) by
 SJ0PR12MB5422.namprd12.prod.outlook.com (2603:10b6:a03:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 23:42:21 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::45) by DM6PR08CA0016.outlook.office365.com
 (2603:10b6:5:80::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Thu, 6 Apr 2023 23:42:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.14 via Frontend Transport; Thu, 6 Apr 2023 23:42:20 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 18:42:19 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v9 net-next 04/14] pds_core: add devlink health facilities
Date:   Thu, 6 Apr 2023 16:41:33 -0700
Message-ID: <20230406234143.11318-5-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230406234143.11318-1-shannon.nelson@amd.com>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|SJ0PR12MB5422:EE_
X-MS-Office365-Filtering-Correlation-Id: c97c0cd0-617f-4e68-ec35-08db36f8909e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xulNhjMQwf8SpWZWmVtSVV0xOfUwanaVawnuReNT/gOQuZc7Z1D+cVowO+Rk8zRSmeiVfxGxKtmjGYSzxI6nIsBA8zNQv0fy5I5I767kaILd9TWMTGX5HHJLOfqw+t5HVXX+oL7w+X/KM461FW+3HS74xxaJPErMEhEiONO3huMQIamgEXXuSwPUMaBZoLKXhdfvj2lozZFDez89tv0KFLNHGi2477oD814DW2UL4J87mPe7DMlX5l4knfCGpiKkIMJxruG4ulz522n4OlZNv/RRfkOzmpLij5Gbz5PVKxdtPL3Vv69AKj55tMefG6odyG7aqARLkuOqeb9nAzzNn+uLrYXkPqEjCwaRa/WlX6Zy7zneKRbyyalPok+FMyVI+OofYf1G+t+/115HmrUZHrSYsd4a/TnCFUy6JiRoKtPsHWmVWFBJ3WNr4uWGEVZT2fZu8ja/dN3tcUati5SILl+U0tom9u4g0DVhXqiOApeJwfe6hKV7/i1Xq8Qh2SQfTdEH6GIaU56VYG8OW3Tzpk5h6sN4MM+SJHh3ikLo8MkzCbQGQbbcLk9MlhgZiBfMZnxT/ZLuTkLaAZw7tE31rcxsgpnWKNNCKX1gnJp0YepFZjGV5WN9RPAv8dgKmwjadgmJTW5AHh5chS1wV7QeNghd8ISfr+pIKCWyjFpfKjP8sbJ1zRStFzNB7vsSgheCUdiRSBZe+vCvLzIhqtznJzMbVXo0YoS/nW9CkX4j1SQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(36840700001)(40470700004)(46966006)(5660300002)(82740400003)(82310400005)(478600001)(81166007)(110136005)(36860700001)(70586007)(40480700001)(36756003)(356005)(4326008)(70206006)(86362001)(54906003)(316002)(41300700001)(8936002)(40460700003)(44832011)(336012)(426003)(2616005)(186003)(16526019)(8676002)(2906002)(1076003)(26005)(6666004)(47076005)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 23:42:20.8399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c97c0cd0-617f-4e68-ec35-08db36f8909e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5422
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
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
  # devlink health diagnose pci/0000:2b:00.0 reporter fw
   Status: healthy State: 1 Generation: 0 Recoveries: 0

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../device_drivers/ethernet/amd/pds_core.rst  | 12 ++++++
 drivers/net/ethernet/amd/pds_core/Makefile    |  1 +
 drivers/net/ethernet/amd/pds_core/core.c      |  6 +++
 drivers/net/ethernet/amd/pds_core/core.h      |  6 +++
 drivers/net/ethernet/amd/pds_core/devlink.c   | 37 +++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/main.c      | 22 +++++++++++
 6 files changed, 84 insertions(+)
 create mode 100644 drivers/net/ethernet/amd/pds_core/devlink.c

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
index 58a28b255d37..90b473559bac 100644
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
index 701d27471858..52236af6b0e0 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
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
index ffc9e01dec31..3758071c94da 100644
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
 #ifdef CONFIG_DEBUG_FS
 void pdsc_debugfs_create(void);
 void pdsc_debugfs_destroy(void);
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
index 5032fc199603..82ce180d7b48 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -141,10 +141,16 @@ static int pdsc_init_vf(struct pdsc *vf)
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
@@ -183,6 +189,16 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
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
 
@@ -191,6 +207,8 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
 	return 0;
 
+err_out_teardown:
+	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 err_out_unmap_bars:
 	mutex_unlock(&pdsc->config_lock);
 	del_timer_sync(&pdsc->wdtimer);
@@ -297,6 +315,10 @@ static void pdsc_remove(struct pci_dev *pdev)
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

