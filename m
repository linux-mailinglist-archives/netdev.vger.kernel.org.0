Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B5C6E8014
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbjDSRFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbjDSRFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:05:32 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2089.outbound.protection.outlook.com [40.107.102.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067B87D82
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:05:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4ZKFEOm6yct1sctDTFrDt+MbK4vK4cbfPmdfVfQDt5y383XiBjlAX9z/zU7UwR49vkJFFOHdLW6xxuKHZ8vJSE/sFFQIr6GpWhOaL3npWSSHJGBoxrtqI17xx82OFsK9Zx+LAgl1T/kaUNDnnq/mVxhE3hUamUrHZAMOQK4XgOIK9D1JkiSsz8YZk1+oZ5WnO/Nv6mLk8bNnKhNSRK82SA/V6iiHE1vjdvE42LzkLcCloRKA+vB9K/E1sHyXfXxYZHyLe0GeUngll4V2gn2YDpM4ZV76q4pkz/X5gXFAXJbAzX+mUiUwFvbAuAN55hGlwHZ0SaExO6nvhpufDCYqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PB4I6xNq1bYGRUFqoX94CcmGyOc2dEzJDhdlHI3y2e4=;
 b=M96oubYp6cvtt4DbGq3sHl6l1oAEiPvm6TLtbo2JKJ07PnYJhM+FRJ12XciifMuh6NJI5Qd5y0/7Lz4EPYB/awg8rz4/CVccz21Tia4TirCHm/FswxpGy2iec9ZEDVjFGXjQziOp4eHgXqNg7L0d9DeCJ7HHrUn0unwqq2aw+20yAKr0r1ZPOePJbMhEVH+/PFb4MAFx3v/scVeu4OWbdx/e1+d5E6kMt4PVw+5YEhwg/nsSY3JTNkrI5pIoEHvEEMPy1mKPeBZf2d0sAXU/txagsLRC5KMSSd35SyANxtaTlMjS3A0V7uyO497U4hRZLgVcerCulMNfGLBA3gbKPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PB4I6xNq1bYGRUFqoX94CcmGyOc2dEzJDhdlHI3y2e4=;
 b=X+di8q0y79juydhTdkb7Z2q5NzmVhaRB5wvtjQFObzaMKaMupIlQgrK/mgumeVZqhhDwh1adUoVFI9WHLIPhn0LJxxb6rRUzeJfadShZy0gzrXILRNG7nUMVzXZlH1uRlQld4LfPKaC0yy6Np9CBAcDz31SkW/jnGwf6nnHr1MQ=
Received: from BN9PR03CA0420.namprd03.prod.outlook.com (2603:10b6:408:111::35)
 by CY8PR12MB7217.namprd12.prod.outlook.com (2603:10b6:930:5b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 17:05:26 +0000
Received: from BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::d1) by BN9PR03CA0420.outlook.office365.com
 (2603:10b6:408:111::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.47 via Frontend
 Transport; Wed, 19 Apr 2023 17:05:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT066.mail.protection.outlook.com (10.13.177.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.23 via Frontend Transport; Wed, 19 Apr 2023 17:05:26 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 19 Apr
 2023 12:05:18 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v11 net-next 07/14] pds_core: add FW update feature to devlink
Date:   Wed, 19 Apr 2023 10:04:20 -0700
Message-ID: <20230419170427.1108-8-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT066:EE_|CY8PR12MB7217:EE_
X-MS-Office365-Filtering-Correlation-Id: a70be3b0-299d-4786-ccaf-08db40f8456c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5+Rdq5O/22xZVUVQc4iF8rVf9Hao6iNwSBV4IgBbzuEHokdR76xFZi9V15sec/fxx7Z1pDJAC/mB+Mlxg9uH0t6xEd3CTjF5UWhYpIdisa0B+BzVE3QxvndQjDc2KVYxnQCSA4+eCgVo9+8mwUPKRWkh6Rko+cd/il1SCny0bcjdw10eEBahhyR2O3X3C0M4ivc0+QWXmJosKjcVYrRGKCYBCJ1Tv7BcD3/8973MFqK+55wbTqE//Bm6aq18XbSTPpm3jnsO1gQgcoY1NVtphfpsjO8OVwG1qHWZQp9K+OXqQtBjhZjgB+oxvQjmaVxVtEL2Y9shxaiIxAhv/GUI3GOAznsn7LUPICKWy0pmUy72w6tgaVdB37LAfAXI7hXNoxLMz51ciR1kzWK2xmqdA+MqIhFRsdu5Wb0ct9twqzfGe6fGMqnIlvFPFWvfYVM0K73oPt5hxNdbagRjzzRdVvKLF0tO/D8uCnXU2grA6OjHjYUlDQkqL3h08ewVEhP6Bn36bqTesr3i0/A+KaeuyyXCOfy4jcLX3zOa3fiPAFbrLpUpQfyi8oehGGPFq60ZNgsOLhDyi+tcjkWtvmZkU5Efu9c7q5ror0VM0ZkxLWouW1XbSPPH5zS9N1Mb/SJx6L/HxZYEE+wiOd2TXssz/TkfHLihgFV9Bnj+2yAGh+0AZ4nDkrc4KIl7T13jv/D+0wRKOmJpt1EN3NgTU/wM2lEGvd+/1BU2qKFCEl590Fc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(39860400002)(376002)(451199021)(40470700004)(36840700001)(46966006)(86362001)(426003)(336012)(47076005)(1076003)(26005)(83380400001)(36756003)(82310400005)(186003)(40460700003)(2906002)(16526019)(15650500001)(44832011)(5660300002)(36860700001)(2616005)(6666004)(8676002)(8936002)(478600001)(110136005)(54906003)(356005)(81166007)(82740400003)(41300700001)(316002)(40480700001)(70586007)(70206006)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 17:05:26.3569
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a70be3b0-299d-4786-ccaf-08db40f8456c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7217
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

