Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B0B6DA632
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 01:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238863AbjDFXmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 19:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238420AbjDFXmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 19:42:31 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A890A5EF
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 16:42:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfEfq4h3CBlJUM3xJUOTBaC4Qv+FNLJeso/4dX7PhWm5hClVnByOObH4qtjCaAV1SJEZAh9BU7orq8POSIXpuP3Z57euAK2Ev+59/9SXgP+CpjpqbuI4hUVb2iEf2rqHlksj3DLyTCwuiu1P5Wc07K9Q6LtWNNcoAo8xf0mRRiRA5kfpVJwsZZIiA2yEO3MgFbdWS6yO/AN7MdcCd8SJJDPP1VK8gp404z1B0kxZ5b0aaFHIxiArVwadVilubuwC2H8CegFrVY66K79KKCRpYZkauFZwnjfNe3Sw4DHAoHdEIr0h9lZ21gDYvU65GDsdkoNro46Xf8VP/nKtOjgB/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a4DVCwWZcN1JxxcSFUW7wsghGFs/4oQNYsFoOeqgP3g=;
 b=TZZ4sbk1/EslsSw/4XoekJjDy0YQnvnx4gExWdpXS2+t49hMtHjU3fX06RyLiavXM6B8onRo16BKWHy4jtprngjKKzxeJ7oG6Ty5w2mLctdHaHRGqYh8AzD9k7XFpWhNG+iMqsYiHEty7TvjSFTvNNSN+grdErT3XftS51Hk08fULOSV1Yk4w+0vapPZqO+6W0v3VB+UPM0Yq/QjNSpUcAimzpQT6/E86dh5FXkTMi1vQZEVRzr+6TcU6FQ2nYsA0aD0wIVwxxLT6KYY0TTz7/F/6mcdjy80KqdgAzB1rCY9QQQXoAlpUZdhV9PcVRfNllUrfCiteIpzBrw7JVHJiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4DVCwWZcN1JxxcSFUW7wsghGFs/4oQNYsFoOeqgP3g=;
 b=gCPf/PJNTz2hOVhJRwVz1UvVmx6O68xzOdtCKbqG9XeQeBULDD1VJtxwWjioHkE4kuv6dgRMPnB14DeM2uqzRpq8ZmBFGjB4YjzUaLK2cIyCDdbwwYiNWXYVsELKcpEdOGPCXgTEC9i1FlwvR831e0kVJ4FylAFgOJ/dQIZRQII=
Received: from DM6PR12CA0028.namprd12.prod.outlook.com (2603:10b6:5:1c0::41)
 by SN7PR12MB6768.namprd12.prod.outlook.com (2603:10b6:806:268::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Thu, 6 Apr
 2023 23:42:23 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::d) by DM6PR12CA0028.outlook.office365.com
 (2603:10b6:5:1c0::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.33 via Frontend
 Transport; Thu, 6 Apr 2023 23:42:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.31 via Frontend Transport; Thu, 6 Apr 2023 23:42:23 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 18:42:22 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v9 net-next 07/14] pds_core: add FW update feature to devlink
Date:   Thu, 6 Apr 2023 16:41:36 -0700
Message-ID: <20230406234143.11318-8-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT014:EE_|SN7PR12MB6768:EE_
X-MS-Office365-Filtering-Correlation-Id: d6acab16-e432-4d37-899a-08db36f8922b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5caqjJo+B9+MI7o5vecuP+kHlqq7r2tMhKh6ZXoJZce0ihSvh/aoD/bApICdNZ5EnNhy5fxEcbyW64xAOlAszfAxJtI/I6FQLY4hMIxviBr/6KMcMWAckIVvMTOFIeBNF9tm77wkeZOq2CJUDY8pRRSHxTywpjtAzAMspr0pVHDP/Yygue70xT4MyvwXpD7o4tw5gJ2T2ypGSGuWFeKiqn351liQsoyA0+3jwwWXPfuVuc+Vsq3f5aPnF9qtne880UX+W4HhMi1wTIchrgbfuR7PGlXJh6BXX5KtNhAON1CF2ENUVF4VI2wIyDpe8aNvYCfkYBkYmDNwGeb8ZaYXQAmMuYHrx/brf+AmzHt9T4lGL8Ki/lJYRAjCFW5TvlnTZdc7GKzWZ/r8CbEqVml8GajL02F49YqR2qUEoF2RRcXNqnzoRSKIOsO6aSaTb+CF7IzXQM1l2dUFu0U0W+GAb7fmeiiBaohn0Fl6OyMOCjUR7UyMIFG+ZhRddiI/fdve5obqVEbAPsS5lRTQJvKTNke0uZMHpY6CxCV9nnnAb6WmHKSMSfNrY0iOcBvyOYIOyvLLAjiOTPzzs074LJVXhPn+ZYS4w/3a2Lc2qvIR5bbb8YPPUIVxbnkTtuvTGJ491fNqJuCY9tdidSxEGU2++flMatSc/KrFnU92Nt2onEFlJpYyLBhJcZxQPYf9pE/xfBNz/MYY5NgmnB/CIP8QdI9PJInvjDBUnsmB6pKsrKE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199021)(36840700001)(40470700004)(46966006)(70206006)(16526019)(186003)(40480700001)(26005)(44832011)(40460700003)(1076003)(6666004)(36860700001)(426003)(15650500001)(110136005)(54906003)(478600001)(82310400005)(336012)(36756003)(86362001)(82740400003)(83380400001)(47076005)(8676002)(356005)(2906002)(41300700001)(81166007)(316002)(70586007)(4326008)(5660300002)(8936002)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 23:42:23.3610
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6acab16-e432-4d37-899a-08db36f8922b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6768
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
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
index 265d948a8c02..6faf46390f5f 100644
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
+currrently in use, and that bank will used for the next boot::
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
index ee24833ed7ee..b0818b55e516 100644
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
 
@@ -280,4 +283,6 @@ void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
 irqreturn_t pdsc_adminq_isr(int irq, void *data);
 
+int pdsc_firmware_update(struct pdsc *pdsc, const struct firmware *fw,
+			 struct netlink_ext_ack *extack);
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index beea606c3b8d..0e98137cf69b 100644
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
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index c349f44b01c1..d5edce8480d7 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -242,6 +242,7 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
 static const struct devlink_ops pdsc_dl_ops = {
 	.info_get	= pdsc_dl_info_get,
+	.flash_update	= pdsc_dl_flash_update,
 };
 
 static const struct devlink_ops pdsc_dl_vf_ops = {
-- 
2.17.1

