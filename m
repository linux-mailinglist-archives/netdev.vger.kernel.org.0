Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9F76C8581
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjCXTD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjCXTDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:03:17 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147741A669
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:03:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/ORlt4/HM9GLhWGzNhqdM2j1N2JTOV4Urho2X/Rp5B5HHdKvr4PtK6rpn9+/oG23KKtKRiem2xHZligqj48ESHNFTTn1eNBhXzmN9O7+PMkWHtKZGbB7YLieDza8hvnh1BEizd8KOP9x1KHTaxVBYSfDe90exO3rYRYyrbZsEpLIms+d8NKsVjtT6sBhXVPiZ/OPXcl2ZfK3uyIFmswdOsvHWcwcKWHJLClVfhqDIQN3k8Gpw0gPu1Wjcn952+9miGfn4Ppf1A6yRZCN/mNPubcGcHjjPMUBMGFi7O+3K4xkF7Ca1qql34u0yT2JODkiiOI8+2W6FDOTQctlo0GJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+o5oeA7wHU3r+FUj1/2tzhnd/KHyzc9yvoEz2E78gQ=;
 b=EJyyXtjKZYP3pDc8f4H4anaPevr6Q81WYHwgBoXocJCuioUUrrWW9ykj5fvSs3AA6r502P8jWDnzAFrXPPWFv5UAM99hdNPthyLtg708u4Otj6FRm6XNeSAd7QdMFMvwgI2BN6eHRxcMDk4IJ8tmjPoZruIlzshKL5OH2GcKyaR06uvHbHm4u3KzsQZeXgdRQAeFWxxpywTG9TjSNgcGOtnv/YANfbVopS1zOxiFd2bfHNzZoqgYf0l8Edkg/sI8Yhp+o3uRNLFp1mChY/YtTGmvaBUhy1/4rV7ExVuSYxZP1AM2jvnojEp5rkq3wQSxqVmcZXU5wnTsTMkFKL4VYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+o5oeA7wHU3r+FUj1/2tzhnd/KHyzc9yvoEz2E78gQ=;
 b=QEbJQFL7f5DhwK7L2mLxtArj3N2HYCw5gB4dx0DB/CeXO2+98Gg33guU2/5fj5JU+YcX3c6ikMmZrtQDzseg2zVbVLuNNnWbc6O5DzRi0YFhEdaCA1wAPJF4E4QRX/RpGPyYoe/1WKkM0EDZ4l0lXAMs6+ruwp8C93CsBahSilE=
Received: from DM6PR02CA0150.namprd02.prod.outlook.com (2603:10b6:5:332::17)
 by SJ0PR12MB6711.namprd12.prod.outlook.com (2603:10b6:a03:44d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Fri, 24 Mar
 2023 19:03:12 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::3) by DM6PR02CA0150.outlook.office365.com
 (2603:10b6:5:332::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.40 via Frontend
 Transport; Fri, 24 Mar 2023 19:03:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Fri, 24 Mar 2023 19:03:12 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 24 Mar
 2023 14:03:11 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v6 net-next 07/14] pds_core: add FW update feature to devlink
Date:   Fri, 24 Mar 2023 12:02:36 -0700
Message-ID: <20230324190243.27722-8-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230324190243.27722-1-shannon.nelson@amd.com>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT051:EE_|SJ0PR12MB6711:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c513aea-59e6-4340-c3ea-08db2c9a6a5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aqmWLfLQb+4L+yJIBGixtpu+Dx+cbmRg4E5H+k2R/a+Rmq3dWuzyGlUNsLu54srpgp+XfBna3GqNYaabhI0g7BEdfq1z9KbUQ9GHXeTzHDb/bTXK/UsMDw6c4jHOQFv7ZuYfzzMoHE8E0x701JgLyTZq5MEWvD62nkeErczInbRLDmog7e2aBxO7J2+qx15Ex1te1KUutXzBZcky4bhqGfgHU4wpZzJ34oMwhASZg3wJ9fVdaiBCLZpEBRVcoDrvZzmHDfeGC3QnWUcdxG0qhCSsYp1fDSEvIc1FekvEsejaJVg0LodJD7IgQcYr31fL6yBfo4GMmCGK864snXRi6rWUzvj6qdFFTa/LETcUKyZsvbaD+lttRpwiifSagcpzyC/WT8z65YQsHY8RD2nzG1U+sAL3l6+lF3RuM14WgNx4KszNBpU9wqJxpCKs0PNSVgf8RmRfQDoqVJdH+333mkdJH3ms4AIIokT4Wm3eOZ0+eTO2XKQxiOyYFDGBs+YauApQeO4XHtBK9NUfSkoNdB6td34ThGI+TpaoVg06uEhIoBWq7zZ1rqnAGygmtX5aWV+uybS8h5hlZiDoBfwyvdAfO6Zx+OhVnENinL79HmDm00jgIfRK7ddT8FdPvxLzZiaCJTd8hLDRzrMMuh4hCrZoGC0nBnY82yqmLz6XB+0KKgOUMwEm8OllPa6lRt+3hKK9A7Wxvv+UWVX4b3YXMLQv26rzp8OUdrkjyUjSLg8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(346002)(376002)(451199021)(46966006)(36840700001)(40470700004)(36756003)(8676002)(356005)(40480700001)(70206006)(54906003)(2906002)(47076005)(36860700001)(41300700001)(5660300002)(316002)(44832011)(70586007)(81166007)(15650500001)(82740400003)(336012)(6666004)(110136005)(1076003)(26005)(8936002)(2616005)(83380400001)(426003)(4326008)(40460700003)(82310400005)(86362001)(478600001)(186003)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 19:03:12.3457
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c513aea-59e6-4340-c3ea-08db2c9a6a5e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6711
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add in the support for doing firmware updates.  Of the two
main banks available, a and b, this updates the one not in
use and then selects it for the next boot.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/Makefile  |   3 +-
 drivers/net/ethernet/amd/pds_core/core.h    |   3 +
 drivers/net/ethernet/amd/pds_core/devlink.c |  10 +
 drivers/net/ethernet/amd/pds_core/fw.c      | 194 ++++++++++++++++++++
 4 files changed, 209 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/amd/pds_core/fw.c

diff --git a/drivers/net/ethernet/amd/pds_core/Makefile b/drivers/net/ethernet/amd/pds_core/Makefile
index ef76dcd7fccd..6d1d6c58a1fa 100644
--- a/drivers/net/ethernet/amd/pds_core/Makefile
+++ b/drivers/net/ethernet/amd/pds_core/Makefile
@@ -7,6 +7,7 @@ pds_core-y := main.o \
 	      devlink.o \
 	      dev.o \
 	      adminq.o \
-	      core.o
+	      core.o \
+	      fw.o
 
 pds_core-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index fef23abf9b5b..ba2e23ba8ce5 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -280,4 +280,7 @@ void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
 irqreturn_t pdsc_adminq_isr(int irq, void *data);
 
+int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
+			 struct netlink_ext_ack *extack);
+
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index 5751ce20479d..17464b063009 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -8,6 +8,15 @@
 
 #include "core.h"
 
+static int pdsc_dl_flash_update(struct devlink *dl,
+				struct devlink_flash_update_params *params,
+				struct netlink_ext_ack *extack)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+
+	return pdsc_firmware_update(pdsc, params->fw, extack);
+}
+
 static int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			    struct netlink_ext_ack *extack)
 {
@@ -63,6 +72,7 @@ static int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
 static const struct devlink_ops pdsc_dl_ops = {
 	.info_get	= pdsc_dl_info_get,
+	.flash_update	= pdsc_dl_flash_update,
 };
 
 static const struct devlink_ops pdsc_dl_vf_ops = {
diff --git a/drivers/net/ethernet/amd/pds_core/fw.c b/drivers/net/ethernet/amd/pds_core/fw.c
new file mode 100644
index 000000000000..518e48c4ef20
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/fw.c
@@ -0,0 +1,194 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include "core.h"
+
+/* The worst case wait for the install activity is about 25 minutes when
+ * installing a new CPLD, which is very seldom.  Normal is about 30-35
+ * seconds.  Since the driver can't tell if a CPLD update will happen we
+ * set the timeout for the ugly case.
+ */
+#define PDSC_FW_INSTALL_TIMEOUT	(25 * 60)
+#define PDSC_FW_SELECT_TIMEOUT	30
+
+/* Number of periodic log updates during fw file download */
+#define PDSC_FW_INTERVAL_FRACTION	32
+
+static int pdsc_devcmd_fw_download_locked(struct pdsc *pdsc, u64 addr,
+					  u32 offset, u32 length)
+{
+	union pds_core_dev_cmd cmd = {
+		.fw_download.opcode = PDS_CORE_CMD_FW_DOWNLOAD,
+		.fw_download.offset = cpu_to_le32(offset),
+		.fw_download.addr = cpu_to_le64(addr),
+		.fw_download.length = cpu_to_le32(length),
+	};
+	union pds_core_dev_comp comp;
+
+	return pdsc_devcmd_locked(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+}
+
+static int pdsc_devcmd_fw_install(struct pdsc *pdsc)
+{
+	union pds_core_dev_cmd cmd = {
+		.fw_control.opcode = PDS_CORE_CMD_FW_CONTROL,
+		.fw_control.oper = PDS_CORE_FW_INSTALL_ASYNC
+	};
+	union pds_core_dev_comp comp;
+	int err;
+
+	err = pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+	if (err < 0)
+		return err;
+
+	return comp.fw_control.slot;
+}
+
+static int pdsc_devcmd_fw_activate(struct pdsc *pdsc,
+				   enum pds_core_fw_slot slot)
+{
+	union pds_core_dev_cmd cmd = {
+		.fw_control.opcode = PDS_CORE_CMD_FW_CONTROL,
+		.fw_control.oper = PDS_CORE_FW_ACTIVATE_ASYNC,
+		.fw_control.slot = slot
+	};
+	union pds_core_dev_comp comp;
+
+	return pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+}
+
+static int pdsc_fw_status_long_wait(struct pdsc *pdsc,
+				    const char *label,
+				    unsigned long timeout,
+				    u8 fw_cmd,
+				    struct netlink_ext_ack *extack)
+{
+	union pds_core_dev_cmd cmd = {
+		.fw_control.opcode = PDS_CORE_CMD_FW_CONTROL,
+		.fw_control.oper = fw_cmd,
+	};
+	union pds_core_dev_comp comp;
+	unsigned long start_time;
+	unsigned long end_time;
+	int err;
+
+	/* Ping on the status of the long running async install
+	 * command.  We get EAGAIN while the command is still
+	 * running, else we get the final command status.
+	 */
+	start_time = jiffies;
+	end_time = start_time + (timeout * HZ);
+	do {
+		err = pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+		msleep(20);
+	} while (time_before(jiffies, end_time) &&
+		 (err == -EAGAIN || err == -ETIMEDOUT));
+
+	if (err == -EAGAIN || err == -ETIMEDOUT) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware wait timed out");
+		dev_err(pdsc->dev, "DEV_CMD firmware wait %s timed out\n",
+			label);
+	} else if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Firmware wait failed");
+	}
+
+	return err;
+}
+
+int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
+			 struct netlink_ext_ack *extack)
+{
+	u32 buf_sz, copy_sz, offset;
+	struct devlink *dl;
+	int next_interval;
+	u64 data_addr;
+	int err = 0;
+	u8 fw_slot;
+
+	dev_info(pdsc->dev, "Installing firmware\n");
+
+	dl = priv_to_devlink(pdsc);
+	devlink_flash_update_status_notify(dl, "Preparing to flash",
+					   NULL, 0, 0);
+
+	buf_sz = sizeof(pdsc->cmd_regs->data);
+
+	dev_dbg(pdsc->dev,
+		"downloading firmware - size %d part_sz %d nparts %lu\n",
+		(int)fw->size, buf_sz, DIV_ROUND_UP(fw->size, buf_sz));
+
+	offset = 0;
+	next_interval = 0;
+	data_addr = offsetof(struct pds_core_dev_cmd_regs, data);
+	while (offset < fw->size) {
+		if (offset >= next_interval) {
+			devlink_flash_update_status_notify(dl, "Downloading",
+							   NULL, offset,
+							   fw->size);
+			next_interval = offset +
+					(fw->size / PDSC_FW_INTERVAL_FRACTION);
+		}
+
+		copy_sz = min_t(unsigned int, buf_sz, fw->size - offset);
+		mutex_lock(&pdsc->devcmd_lock);
+		memcpy_toio(&pdsc->cmd_regs->data, fw->data + offset, copy_sz);
+		err = pdsc_devcmd_fw_download_locked(pdsc, data_addr,
+						     offset, copy_sz);
+		mutex_unlock(&pdsc->devcmd_lock);
+		if (err) {
+			dev_err(pdsc->dev,
+				"download failed offset 0x%x addr 0x%llx len 0x%x: %pe\n",
+				offset, data_addr, copy_sz, ERR_PTR(err));
+			NL_SET_ERR_MSG_MOD(extack, "Segment download failed");
+			goto err_out;
+		}
+		offset += copy_sz;
+	}
+	devlink_flash_update_status_notify(dl, "Downloading", NULL,
+					   fw->size, fw->size);
+
+	devlink_flash_update_timeout_notify(dl, "Installing", NULL,
+					    PDSC_FW_INSTALL_TIMEOUT);
+
+	fw_slot = pdsc_devcmd_fw_install(pdsc);
+	if (fw_slot < 0) {
+		err = fw_slot;
+		dev_err(pdsc->dev, "install failed: %pe\n", ERR_PTR(err));
+		NL_SET_ERR_MSG_MOD(extack, "Failed to start firmware install");
+		goto err_out;
+	}
+
+	err = pdsc_fw_status_long_wait(pdsc, "Installing",
+				       PDSC_FW_INSTALL_TIMEOUT,
+				       PDS_CORE_FW_INSTALL_STATUS,
+				       extack);
+	if (err)
+		goto err_out;
+
+	devlink_flash_update_timeout_notify(dl, "Selecting", NULL,
+					    PDSC_FW_SELECT_TIMEOUT);
+
+	err = pdsc_devcmd_fw_activate(pdsc, fw_slot);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to start firmware select");
+		goto err_out;
+	}
+
+	err = pdsc_fw_status_long_wait(pdsc, "Selecting",
+				       PDSC_FW_SELECT_TIMEOUT,
+				       PDS_CORE_FW_ACTIVATE_STATUS,
+				       extack);
+	if (err)
+		goto err_out;
+
+	dev_info(pdsc->dev, "Firmware update completed, slot %d\n", fw_slot);
+
+err_out:
+	if (err)
+		devlink_flash_update_status_notify(dl, "Flash failed",
+						   NULL, 0, 0);
+	else
+		devlink_flash_update_status_notify(dl, "Flash done",
+						   NULL, 0, 0);
+	return err;
+}
-- 
2.17.1

