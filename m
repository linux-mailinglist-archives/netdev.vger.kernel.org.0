Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A523F6AFE26
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCHFO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjCHFNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:13:47 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9975D46D
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 21:13:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSDzQzpYFSWHjJV1zPPnqg5tX0+p35XUZU/Vt56zsm0gQ2HTU3Q+H+bj/XIoo9QdziEn1/qZVHVe9Kf31XhZPG+jSawE9ho05E9azFCjHdLj6AQgLMIx4aa4NJYIhncK39Vzd84aew9UypyC+D0oDY+XR57EdFkQJBbwOiTzjIse9e5zuuyPW17BtJhyZo/jfvG9FBFCf0o4aFAcid8oKf9LQqxCUMw5XWBwyw/ZsZS+X19Qykx/1rMj/WuYFbLzw0phLMZshYfpQ6zU52BZveTEc0BMZwtESrwlLxiqLUu3Ssa4URwCz57LsnhYegLqcKTJnE/u99VGVzl+L4CzVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PKeb3YzsH6hMJy3S81HDviZKlJ8vJ+eZ5CjcBJ+qI2Y=;
 b=oVzKHK7Mez1V7BP9FVM/6th7Jrb8P/hAKIdGoByALvb0x7jKllh1ehmGUMdP+0ZlWHCn4uclUmkDl6SHKsEXftgUv274RxYBd9Yd2ncKGB5OMfeOaLc3rzeFiGn7JEDHToeii34G5Dnyp4IViuQ5FOjgml3FLHGT30CZ/EQj4bhyGIqULyOmneMyESY6Hs7gdUNDNhK8w929uf8+hjnGE7upe+6PjThAjulcQ7BpRC/fOq6Qxj3Z1AZazXVb8/M78APQRjdV3QkJfL9P+HEEj60ostBgqTf/nUg8fDHesON+LF3OoURbshZf8Ga27cHTJgqe1tEB3JI3lm2VYiZ9oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKeb3YzsH6hMJy3S81HDviZKlJ8vJ+eZ5CjcBJ+qI2Y=;
 b=Hhx0eHGpL2jFbP482lxP3I/TZe0pqlF6/gXvV9VYRQGAfUhPKFnDgmBbJlrHyGiL9QejCb9fyM2W2pmLRkJYmlFUi9QMHSMJF4YoEy690ZqD+6XXDe5n104zuUug1Ab/R8Jo31CmSdHPEbdfo7OrrIOxg4+X+/ubJw3z77CTib8=
Received: from BN9PR03CA0708.namprd03.prod.outlook.com (2603:10b6:408:ef::23)
 by PH7PR12MB6441.namprd12.prod.outlook.com (2603:10b6:510:1fb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 05:13:39 +0000
Received: from BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ef:cafe::95) by BN9PR03CA0708.outlook.office365.com
 (2603:10b6:408:ef::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Wed, 8 Mar 2023 05:13:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT075.mail.protection.outlook.com (10.13.176.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.16 via Frontend Transport; Wed, 8 Mar 2023 05:13:38 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 23:13:37 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH RFC v4 net-next 06/13] pds_core: add FW update feature to devlink
Date:   Tue, 7 Mar 2023 21:13:03 -0800
Message-ID: <20230308051310.12544-7-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230308051310.12544-1-shannon.nelson@amd.com>
References: <20230308051310.12544-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT075:EE_|PH7PR12MB6441:EE_
X-MS-Office365-Filtering-Correlation-Id: 18af01e5-7c65-4361-a22f-08db1f93e06b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F+dQy4y68YeBB08oRfJWDHd64b++Hwq4x/1/QH9z5WybjXPEdH4+WnYyw33buVw/6Fjh1DQI8oC3PipUfULIYI3Q0KgRCVWjxgN5RBaqTYvJr7pse/tXRb8og6A2+tJahkRf2p3WVsrMXN3HyOiCnTnjxkAvIMCMGHY5LHj11VVEGLSvcyIeztcWC1nSHKpNI97n8U/LRG2GcwazhtOg+OkCJKlaukjjZg416u2BFjg1h9iJRYzCZEUYv+nRwDfGlsEPNln189WDihkRn4urDxQxnkRd6xaaWMcO8zKesjKliuqqlMzMz81Unb8mXZYz3xdLko/CRwbza3o0I8h1hvL+LSkSVLAKuvle+0eErtIpqmBA4wGCofW0nzA2HVDzHRGA3tWkMGYlg/dLFDIrBckZsyyV1oYS8C8bb2tFcrqDC1xRoM0apq+0htXQbViKCPKlHRwqbVE3mZwRNEaIpUaLgEZNBE0VN1Ip5o7dZAh+CQKZ/6PYJSqJeszAm5dI++kdjteMWTMSgey8WGpc7Oh7oHLRieH1CDCq5VgqAophJO0pfP2aT1ESOMjDRrCDojMN1u1DMzE7Hc5Lg9/HPTfxrVyClIs537D+5MvAASifkvZEEq0a3LBbpP6UjxpdmU6/1XgH9Umuo8ioXJWi3VzTAULCziNZj4LJCzU/GwGpfM0p7WJ7RUNTTyThaXE827MME9IEjUu16poc/GWoPk+N9QqZSDIjQn4j4WRrVOw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199018)(36840700001)(40470700004)(46966006)(36756003)(8936002)(5660300002)(26005)(1076003)(36860700001)(82740400003)(6666004)(81166007)(336012)(82310400005)(426003)(47076005)(83380400001)(16526019)(2616005)(186003)(40480700001)(54906003)(316002)(86362001)(41300700001)(110136005)(8676002)(70206006)(70586007)(4326008)(40460700003)(356005)(478600001)(2906002)(15650500001)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 05:13:38.8236
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18af01e5-7c65-4361-a22f-08db1f93e06b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6441
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add in the support for doing firmware updates.  Of the two
main banks available, 1, and 2, this updates the one not in
use and then selects it for the next boot.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/Makefile  |   3 +-
 drivers/net/ethernet/amd/pds_core/devlink.c |  10 ++
 drivers/net/ethernet/amd/pds_core/fw.c      | 187 ++++++++++++++++++++
 include/linux/pds/pds_core.h                |   3 +
 4 files changed, 202 insertions(+), 1 deletion(-)
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
diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index e4a571f5c5a1..7f2016807e5e 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -8,6 +8,15 @@
 
 #include <linux/pds/pds_core.h>
 
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
@@ -62,6 +71,7 @@ static int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
 static const struct devlink_ops pdsc_dl_ops = {
 	.info_get	= pdsc_dl_info_get,
+	.flash_update	= pdsc_dl_flash_update,
 };
 
 static const struct devlink_ops pdsc_dl_vf_ops = {
diff --git a/drivers/net/ethernet/amd/pds_core/fw.c b/drivers/net/ethernet/amd/pds_core/fw.c
new file mode 100644
index 000000000000..fad50ac3f37b
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/fw.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/pds/pds_core.h>
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
+		dev_err(pdsc->dev, "DEV_CMD firmware wait %s timed out\n", label);
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
+	devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
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
+			devlink_flash_update_status_notify(dl, "Downloading", NULL,
+							   offset, fw->size);
+			next_interval = offset + (fw->size / PDSC_FW_INTERVAL_FRACTION);
+		}
+
+		copy_sz = min_t(unsigned int, buf_sz, fw->size - offset);
+		mutex_lock(&pdsc->devcmd_lock);
+		memcpy_toio(&pdsc->cmd_regs->data, fw->data + offset, copy_sz);
+		err = pdsc_devcmd_fw_download_locked(pdsc, data_addr, offset, copy_sz);
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
+		devlink_flash_update_status_notify(dl, "Flash failed", NULL, 0, 0);
+	else
+		devlink_flash_update_status_notify(dl, "Flash done", NULL, 0, 0);
+	return err;
+}
diff --git a/include/linux/pds/pds_core.h b/include/linux/pds/pds_core.h
index 495cfeea0855..ffed29c7bd16 100644
--- a/include/linux/pds/pds_core.h
+++ b/include/linux/pds/pds_core.h
@@ -283,4 +283,7 @@ void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
 irqreturn_t pdsc_adminq_isr(int irq, void *data);
 
+int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
+			 struct netlink_ext_ack *extack);
+
 #endif /* _PDSC_H_ */
-- 
2.17.1

