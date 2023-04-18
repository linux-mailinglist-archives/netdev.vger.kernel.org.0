Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A0B6E55E2
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjDRAdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjDRAdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:33:01 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A282F422C
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 17:32:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZcXHcrUA6uIBcGyxkmqELSbJQ5KIG9Ij6HgHrMfdwgKhnmUUHox/4/RUtl/I1fVYkUUnaZn4JYk8zQ9YXMUgfanVxB2hJsSDGB359fOtKeYFmXvos+TpywIqm3V9Ixzi3PN0a10O5h2MRLAKPTq7c2wZhpu7brZXZGg2YlkHOyuVvAxJs3TDmxkW4yoybVhqLfhAXqGFShXmQUjiepjGZZQLvjMCTdbv1w3D60wzWK02yfVksTZBRdoqxPlIc6UU+lFfQY+YmqbaFfYBUtQXwbS3RhsNmJwPxqXZBZk78RwgpA9yMj9we4aPiG7yTs2VXu00+IS929PvEW4283ZwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDcFHr1Yohqfi/1GIANVH5wT46jZ3+ENTWafNDbPT8I=;
 b=kHYPamhza568BybRZiJMCnX7DWzmCdjnMZouL4EzJtAYJB+t1qIZW+v3WKwEqryZQDyaKJ3YSAxX94UpyKUXySEBq/8XlfHrFoRwrDAXy9C2nZXdcso62N63n1aknCKuDHbpu9vBj9TOkS+hLCxi+Wga6RL9DzLPAZpJEnpW0z+8zXaMzZgjBpOrXnmTvtj6RGisddipPsJisMrdxx0OiZgwZ/8+Z3YNIiRS3RbhQ29AyNdZXl0G6vFYrUVK65vnBmaX+pUpjXPVdwmMIntINRrI8Y8zYl4FDiiWmGkRKyJ0dcxz+eBiwwfKtep2GI1vLPI64Y64QFlnQ14B34FWqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDcFHr1Yohqfi/1GIANVH5wT46jZ3+ENTWafNDbPT8I=;
 b=K6hWJYVoX5ba/Obm/kENIpTwfb/b10Md5g0ZI+ox1pn7uwFAJBiw9zDElgDfGKwvcyoNyNdksQCWXMde4o/mzP59YlDn1xcyWBQ5NtrSgOi6HvW4ILwWH8QeUVQIzqk24G3oEnPs8NpRrJmNBm/hFfIR/6qgEzrvSQmVOYNI+dI=
Received: from BN0PR02CA0037.namprd02.prod.outlook.com (2603:10b6:408:e5::12)
 by BN9PR12MB5274.namprd12.prod.outlook.com (2603:10b6:408:11f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 00:32:57 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::9e) by BN0PR02CA0037.outlook.office365.com
 (2603:10b6:408:e5::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.47 via Frontend
 Transport; Tue, 18 Apr 2023 00:32:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 00:32:56 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 17 Apr
 2023 19:32:55 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v10 net-next 04/14] pds_core: add devlink health facilities
Date:   Mon, 17 Apr 2023 17:32:18 -0700
Message-ID: <20230418003228.28234-5-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230418003228.28234-1-shannon.nelson@amd.com>
References: <20230418003228.28234-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT044:EE_|BN9PR12MB5274:EE_
X-MS-Office365-Filtering-Correlation-Id: 854a7e7c-296c-4fa3-975a-08db3fa474b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8KPT+VEBGrh/Z4h9zdsKawuCqbW5zjD093zRALgW/ipWgj1LNo2HwhJ9HZ0paw/H8FAKXwYvFZRR9Y1HBO31+ruO2buV9YUp+ENj/2uvFd2+16RTAFvNoxf2s1SEb3shczSutjhWKhl4PD8SZw9oiTKFITkOpNb3c8wapWg3g9Gr9Z/7P1AbJerlwR+GDVmTWx+NSoTUensO0xpM2ilZB/4ElVANZ4D8fbaDf6AzEa/Og/IziQg0A2gF0S0Td6oVhQiXhFN/vJB2l3B+/zwDJhVrtYJTNz0jwevhdEhd2P+scqu9LSTUBAv8uZE3MIGky3/TgYEy1o3pWrHwsX/dArPApnixTlBT/qMJQyhkcji3+pOmoFtcAAo0aMFZ0+JQfhPS1kWn+BtOCU3oONgdwq0GPOy3grLMPlblECt0V3SjaWoZq/dRHT+yxt5KvC6rQvVlXjNv8ixn+92zBYykDEB42Jf00v1+GxwKNbCU+1K4XyE7Xry0S7v9RrWYVoHH6cwshl49EFLHD61lxd0Nr9yMnWijeIRB3Cc4nVeRJIaw35EmXRgKEY+i073k+eKfpBiLtusXCV30/gxvOP60a1u9H+MXs9EtXF+iMaL6mc6pk1zwRsJdxfHu+27l+Kw9+RCpA8Mdo8vT9kmBoasvpFD+qTpQV1KnkAwCEKauT8FVHs7CIKsxU5Iv9LeJ/3dNneAv+OTskyY9NH1K/tHK76d29uU/efHQi4tJcb7k30g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199021)(36840700001)(40470700004)(46966006)(36756003)(8936002)(8676002)(40460700003)(44832011)(5660300002)(2906002)(82310400005)(86362001)(40480700001)(478600001)(6666004)(54906003)(110136005)(16526019)(186003)(2616005)(36860700001)(1076003)(70586007)(70206006)(26005)(41300700001)(356005)(82740400003)(316002)(83380400001)(81166007)(4326008)(47076005)(426003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 00:32:56.7898
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 854a7e7c-296c-4fa3-975a-08db3fa474b6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5274
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

