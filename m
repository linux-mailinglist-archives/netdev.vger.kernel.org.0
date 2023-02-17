Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5663B69B5BF
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjBQW50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjBQW5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:57:18 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C169067830
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:56:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3EUGw93siw4HLUbsx+2er9OZWQ3aw8Q4dSH7ZSxiqzR6Of0AEJYLJSHXORUqtHSyp83nf9rWem5KVzrWfWTDgJBVFqrwglVs6UxTFKS1+t4ifl16GF08Jmd/trsq4cTslQgvW9lV2Y66IMSDnjFIR+Zlv/2cW2ocFpTdZEqesgl/9r1zgg3BZnCPSqjam4QLAEOQ85qTxSRR0KK/dW9y4wmhn7+RvkkPbH82StTJu6CcX9tnSR34M5jXXmisjaySYeaAeQ4DEqCKjIFZ9e/s3bSIYHjICTxni1m9P54dc6abgv27EvGkChErUJXNfkfNGUdoPSJokIzyrK5QZvucg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=un+L2CUOsgznNPbYirnhWaoWajjoK///hR0umBX1/3U=;
 b=TLKdEUcBVcuOMmL2R/i4YTu1APIbm8Y6XKkDRM9mYXqY298y3jg7kJb5/JkekbwWgiBhZrahGR96u2wSheISutfDRwESiIQaNDiBsJ1wlaFW1y3JwxJE0CZ7mYwdlYVkBC2YM5OTp7wr1wXOFDo/J1m0c2NHFBBbN0Bk5Ga9SUO9oU4aey4Fc3McVSXtDKL3weQxi4EMG8q9mqBlPoD1zctdiHUCOIvwGMbRN/CBp7Nacwq1mizYum/Q57z/tPM5qSnfXylS3q7+ptDvcI1GlwbUiC1m4MzoRpEIFCYwUiC80DXBBRAFti3pKEIYy+LdfKBeiC+VyELjjIEBOXSiyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=un+L2CUOsgznNPbYirnhWaoWajjoK///hR0umBX1/3U=;
 b=Mv55dfgw0RKOxefSLReiSNAOd+oOc+nLS2GJFyTG2HpnyP+/fgj6Z43upzDSfvJYwFMiQ4rqqzo7ehpVc1f6riQle8KRdABy5WTWoRVxTs8X5icGf4cl4WJvh17w8tGllLHq/wH+7prDZL4RW8ttXDgglbdMiz2RpJWUMkKDImM=
Received: from DS7PR05CA0017.namprd05.prod.outlook.com (2603:10b6:5:3b9::22)
 by BY5PR12MB4129.namprd12.prod.outlook.com (2603:10b6:a03:213::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Fri, 17 Feb
 2023 22:56:44 +0000
Received: from CO1PEPF00001A63.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::91) by DS7PR05CA0017.outlook.office365.com
 (2603:10b6:5:3b9::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.12 via Frontend
 Transport; Fri, 17 Feb 2023 22:56:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A63.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Fri, 17 Feb 2023 22:56:43 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 16:56:41 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <brett.creeley@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v3 net-next 07/14] pds_core: add FW update feature to devlink
Date:   Fri, 17 Feb 2023 14:55:51 -0800
Message-ID: <20230217225558.19837-8-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230217225558.19837-1-shannon.nelson@amd.com>
References: <20230217225558.19837-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A63:EE_|BY5PR12MB4129:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b6f1274-9cae-4c5c-02a0-08db113a3d57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pwlRvv2Ii98IRMLzGZ0TWlzTBaVduF0iu/rv0k+8csNTg/YgvQhXqI4FFw1RTmGL4X6/caHgLLU+guW6UIbhHcj16twHD62id3t356nFRo6EVj4Q6YpEtJ2FdrygMWBoVyTaXofKo1O+yL4kLbl+6KzTWjVIVM4BztpvOP7teYy3br7nY8T+zXbtchZjIXWpowOKbQzbSSIFjKgG1fF8fpq/wvShNEg684zYyFFatc92IBgoG2ltpQzZLzv81FAPbItMo00U8F1GM1YGVmQVaduW7u3tNTCsGG53K8AvEzxFuSGY7n1guVlT20mq5VvwLRyzgtqhYsHpIQ+Z7RO4w8SpXpev0OpsbvV3wnU8VjxXXYdJRZA0HSiVWxWEifwsoPrE25Z5ULgKci7OWgiSLvFhIQFq8lD6Oj2VwB7FmgLbIA60cI19fqCrhNDT8N7kw8GlhotafJfKNvBzYR9glpOWVoxwVEB1SZTxDc0d3nvZTmN4uAiyqs9y1AFuIX8bwmtQdv65cq7bSTQbCC5mGkjTEb9q1qO+elvftPx439SboHZULq8QpCAyBXiE84PKlt4jSkvulzLdQ/2zYoiOFGDZzdCGMREB+Rn6ffycFjoedf6sM89CLcRaKzIzGKbx44QW5X8RGOGmZiA44NNU90eVOegHmFBm04cbM+LUsLL3QIG1vtgkm0pgdMuy7waXMpW/C/OWR3hMjQD4w+oGEULAqZJQ+ODRvGvwXcQqmO0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199018)(40470700004)(46966006)(36840700001)(82310400005)(81166007)(82740400003)(36860700001)(36756003)(54906003)(110136005)(40480700001)(478600001)(356005)(316002)(336012)(40460700003)(83380400001)(426003)(47076005)(2616005)(16526019)(6666004)(26005)(1076003)(86362001)(44832011)(15650500001)(8936002)(186003)(2906002)(5660300002)(41300700001)(4326008)(70586007)(70206006)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:56:43.6382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b6f1274-9cae-4c5c-02a0-08db113a3d57
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A63.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4129
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/amd/pds_core/core.h    |   3 +
 drivers/net/ethernet/amd/pds_core/devlink.c |  10 +
 drivers/net/ethernet/amd/pds_core/fw.c      | 192 ++++++++++++++++++++
 4 files changed, 207 insertions(+), 1 deletion(-)
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
index 1610b7b485d2..d87d6d9e625e 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -284,4 +284,7 @@ void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
 irqreturn_t pdsc_adminq_isr(int irq, void *data);
 
+int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
+			 struct netlink_ext_ack *extack);
+
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index f3706f9109f2..df125ed0aa8c 100644
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
@@ -64,6 +73,7 @@ static int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
 static const struct devlink_ops pdsc_dl_ops = {
 	.info_get	= pdsc_dl_info_get,
+	.flash_update	= pdsc_dl_flash_update,
 };
 
 struct pdsc *pdsc_dl_alloc(struct device *dev)
diff --git a/drivers/net/ethernet/amd/pds_core/fw.c b/drivers/net/ethernet/amd/pds_core/fw.c
new file mode 100644
index 000000000000..3277f549c9a2
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/fw.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/firmware.h>
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
+static int pdsc_devcmd_firmware_download(struct pdsc *pdsc, u64 addr,
+					 u32 offset, u32 length)
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
+static int pdsc_devcmd_firmware_install(struct pdsc *pdsc)
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
+static int pdsc_devcmd_firmware_activate(struct pdsc *pdsc,
+					 enum pds_core_fw_slot slot)
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
+		err = pdsc_devcmd_firmware_download(pdsc, data_addr, offset, copy_sz);
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
+	fw_slot = pdsc_devcmd_firmware_install(pdsc);
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
+	err = pdsc_devcmd_firmware_activate(pdsc, fw_slot);
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
-- 
2.17.1

