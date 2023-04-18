Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F50B6E55E9
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjDRAdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjDRAdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:33:08 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20604.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::604])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716604EC0
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 17:33:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKhQ7YXDHfLPqDWni11r6ysmPTfM6ehOc9X0DWWqqIQ3hCHTSLPtB2jOPbxLUCCZblpFHJIYxafJ70ND/cnCKJQaZDTBlO2xApQJlauQad8kTxzZShdz1Oi0jYHLYHfM9HcoZ+iARgp1Kc5tmsyTpwYqNm/FoHZJNOnSpaBRXhydtUjEzLRnpZACasPu61Yv/N5B0PU4ZhHV3x6RnmGkGFEhHizXK8WA+sjfu3DKqWBjXrCrFa0RqyBOzvM3F9xXbtpv5wunM8pa+uCNYduSI2Bw0hcrsPRIPrClahg6rnnVwkAdCGoIvEY+3Xt85IKtjZII629J+2ClEINQ0oL/SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PB4I6xNq1bYGRUFqoX94CcmGyOc2dEzJDhdlHI3y2e4=;
 b=GPwYDiRBWfzEkVo7xn45aL1IoygxlhGKIii9coQwL/QrDpQCxKVKW7XRpoPAoiNjYwZg8pApXfnRZ9N49lrYumLwAjW4FXKZo/TO+y/Yv/cRbkDmnBriqfAZKbATC+u9/RiNz+f4w10ElWIeQK+qY8M04SwCcO8A6AMa5IeMHIF4jC4f2HQ6Wv7gtl9wQzg8jfDY6VOwaqsP25lQ7pQxWXApl8XojmkvBgC942wiI+yXarLCYANnbNp+Do3jklDk7FKJkGTAUw3PLcyfXTbsFbHT83r2+SrWp3xotXwlPhSdPd3dmGR7npc5JESETveHUeOeGDa5oBprqtTCaVht4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PB4I6xNq1bYGRUFqoX94CcmGyOc2dEzJDhdlHI3y2e4=;
 b=U7EEZC+EyB/61PqVN6287KTeCsOEERdKgMfeoDT8yBl8HHayICcIsPkfTm/1PzekfYe3Mx4OY9chch1kMcxWmQ+f0diS+f5UIz35ckLPOCKjSsOKNA2e/6+BP/NJABv44e3OSFYl8hwS8VgoJDbPEDAJ+Q7FLRVhdU56amg0IsA=
Received: from BN9PR03CA0599.namprd03.prod.outlook.com (2603:10b6:408:10d::34)
 by SA1PR12MB6895.namprd12.prod.outlook.com (2603:10b6:806:24e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 00:33:01 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::d4) by BN9PR03CA0599.outlook.office365.com
 (2603:10b6:408:10d::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.47 via Frontend
 Transport; Tue, 18 Apr 2023 00:33:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 00:33:01 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 17 Apr
 2023 19:32:59 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v10 net-next 07/14] pds_core: add FW update feature to devlink
Date:   Mon, 17 Apr 2023 17:32:21 -0700
Message-ID: <20230418003228.28234-8-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|SA1PR12MB6895:EE_
X-MS-Office365-Filtering-Correlation-Id: 756ff395-1656-4914-96ca-08db3fa4777f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ti9QH66CsOywLiMsQzXGHH3ATOIJ+uqptuuFIUfImhKO8JC0NS6e0osszToxwlqBagIhSpACDaGFdt3anTHirooNHf0BfdNSJykqGsZ+WAtjFcC4QO92prokSuWLc7WxVqBr4BCPBRAbCYXXG2FvohhZMF/JiGOtVgcr6RguW9yyBduISR1ct/HYI/LfsBGA8cG78COmJvPtvp3OqhsyjB+3Rrg8jV7DRt3oOqGa2UiuWwd3qtpC3sIY3Tf9j+GGZyXMCCOHJjifUoW3PzbBuFVFnPzCKRcvODuHonqTgfchVmeBUCOHNDJ038SSF15ozyZG5rveXK7d0c9JwtEZrlpBR363BffIxZsxBMeedVIhxmjzvuhEWiluxkfH0akn5rnJZzdQ8yR5NZP05P4uDBtInTTl/kaKlRFN9DZnTG6Srse/LyN5Mu4e0K+dysMzhfPIaXHZTOuiGkHCew8G61sbF4lDoEJ6q3jYZbssI4nftmHUbjQ3sV/VYAyKpk8E/b27djBMtzfyfFFDagNKBcvZbR8OyZcNoHzwNqwaLXBOyBgx9ZjjXkZCEsmy51hjIFabzeG8z6INfrLoBS5E45J3+Hd2YBO5CNEeL8y5965Px1A71ORf9Q8hwe+JDdCMApPyxftRC7C1i1Hbf1o/DOo87rslP0DwEmqBEgXSTPDEwGcMkHD5mt/pyofSEdDrlhEI7cM6vtB3wJEYTciyhEmueAe954AlBCsX0fOHLTs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199021)(46966006)(36840700001)(40470700004)(36756003)(4326008)(110136005)(54906003)(316002)(70586007)(70206006)(478600001)(6666004)(41300700001)(5660300002)(82310400005)(8676002)(8936002)(15650500001)(40480700001)(2906002)(44832011)(82740400003)(86362001)(81166007)(356005)(426003)(2616005)(336012)(40460700003)(1076003)(26005)(186003)(36860700001)(16526019)(47076005)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 00:33:01.4625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 756ff395-1656-4914-96ca-08db3fa4777f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6895
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add in the support for doing firmware updates.  Of the two
main banks available, a and b, this updates the one not in
use and then selects it for the next boot.

Example:
    devlink dev flash pci/0000:b2:00.0 \
	    file pensando/dsc_fw_1.63.0-22.tar

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 .../device_drivers/ethernet/amd/pds_core.rst  |  10 +
 drivers/net/ethernet/amd/pds_core/Makefile    |   3 +-
 drivers/net/ethernet/amd/pds_core/core.h      |   5 +
 drivers/net/ethernet/amd/pds_core/devlink.c   |   9 +
 drivers/net/ethernet/amd/pds_core/fw.c        | 194 ++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/main.c      |   1 +
 6 files changed, 221 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/amd/pds_core/fw.c

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
index a48eafb3d0d3..932ac03a3359 100644
--- a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
+++ b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
@@ -73,6 +73,16 @@ The ``pds_core`` driver reports the following versions
      - fixed
      - The revision of the ASIC for this device
 
+Firmware Management
+===================
+
+The ``flash`` command can update a the DSC firmware.  The downloaded firmware
+will be saved into either of firmware bank 1 or bank 2, whichever is not
+currently in use, and that bank will used for the next boot::
+
+  # devlink dev flash pci/0000:b5:00.0 \
+            file pensando/dsc_fw_1.63.0-22.tar
+
 Health Reporters
 ================
 
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
index 7adbd10cb6d9..7eb02b359f3a 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -226,6 +226,9 @@ int pdsc_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
 			      struct netlink_ext_ack *extack);
 int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 		     struct netlink_ext_ack *extack);
+int pdsc_dl_flash_update(struct devlink *dl,
+			 struct devlink_flash_update_params *params,
+			 struct netlink_ext_ack *extack);
 
 void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num);
 
@@ -268,4 +271,6 @@ void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
 irqreturn_t pdsc_adminq_isr(int irq, void *data);
 
+int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
+			 struct netlink_ext_ack *extack);
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index 89f23d620d1d..f91d65cc78b5 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -3,6 +3,15 @@
 
 #include "core.h"
 
+int pdsc_dl_flash_update(struct devlink *dl,
+			 struct devlink_flash_update_params *params,
+			 struct netlink_ext_ack *extack)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+
+	return pdsc_firmware_update(pdsc, params->fw, extack);
+}
+
 static char *fw_slotnames[] = {
 	"fw.goldfw",
 	"fw.mainfwa",
diff --git a/drivers/net/ethernet/amd/pds_core/fw.c b/drivers/net/ethernet/amd/pds_core/fw.c
new file mode 100644
index 000000000000..90a811f3878a
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
+	int fw_slot;
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
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index eaff311d4a10..54aaf213679f 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -228,6 +228,7 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
 static const struct devlink_ops pdsc_dl_ops = {
 	.info_get	= pdsc_dl_info_get,
+	.flash_update	= pdsc_dl_flash_update,
 };
 
 static const struct devlink_ops pdsc_dl_vf_ops = {
-- 
2.17.1

