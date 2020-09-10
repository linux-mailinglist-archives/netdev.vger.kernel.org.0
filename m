Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791CB264E1E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgIJStj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbgIJQMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:12:43 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3997BC0617AB;
        Thu, 10 Sep 2020 09:12:18 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id c10so6889404edk.6;
        Thu, 10 Sep 2020 09:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wptBGDLLzX2MKQextGuJpdWgYcfBlbPlr/5rrFvg6GU=;
        b=VSFNbSRp5k7mwk/c36aGECKNN6PMnQGCqsO9kuzQxlK7BDqXGdgz19Qgcu0Pzmkw+c
         8/TkkXSna2cvvMUUNFaEoHYnPkbzEU/aGHeyUtrMhoaXWjZRM2PRf6grh67oYkEFYcew
         BRF4ErR7pbcJSJZZZq6ycqh+/ixSpWxasMVZH9D2+fNLrC8Eql75kvqY+ZIo19TStcg9
         svjJbaNmdGovDlme3y77eQTFETN5cZ7JWKUQKc6JQA5E279YLNGeZoQl8jAE1u+PUkuz
         AGQf/diNVIb9QxEGrLpfuAaYBZYr9DCZz6S/K10XSQjHm4J9uOFpzsLFU+EMXGYkk9P5
         iLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wptBGDLLzX2MKQextGuJpdWgYcfBlbPlr/5rrFvg6GU=;
        b=kMhKmaRBOIkrbYgr0sVROFh5B6Cc+DkaIR0FcvQc7MRNrPn0BoOk/9C2mW8dibmZ6s
         KX0gQFTI7ItzyCYRUZJeOdLgh7215U/f2CvcljvJQGggJSO9gDpmdWO6hidS6qg7bUUL
         q+niHQVFkQ/jTxQa5XLl54ZgGDHDKO9QFKPhuUxPYmef9FYCihyXU8AXDawEGIVGkI8r
         cHaOElj4iI3/5oTWI2xrAhhyrVNmqSMCOqBoo4dBvkPPDDJbjvsoL1Yurgsv12fv70ra
         KTa9RuElCvENA6hsm62msr6Pj/Oxtm0xog2jJ47T+aJReIXiG7j5HP9UQ75/A4pf0I+J
         216g==
X-Gm-Message-State: AOAM530kZdDkOaLe0Ey8P9+6OaXASKw1LETqBXhrA66Y2TqbXU1gyG7T
        WP73gBxuiFjMho1W22RG16edHQ27KDE=
X-Google-Smtp-Source: ABdhPJyYyXhGqmNfqGiO6bS6kWE/UNIwLOvhuITAfFuP5VtrOTOZEmUG4+3QUjGHPwDANkVVm28Qtw==
X-Received: by 2002:a05:6402:44e:: with SMTP id p14mr10323911edw.1.1599754335923;
        Thu, 10 Sep 2020 09:12:15 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id k8sm7282911ejz.60.2020.09.10.09.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:12:14 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org,
        Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH 12/15] habanalabs/gaudi: add debugfs entries for the NIC
Date:   Thu, 10 Sep 2020 19:11:23 +0300
Message-Id: <20200910161126.30948-13-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910161126.30948-1-oded.gabbay@gmail.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

Add several debugfs entries to help us debug the NIC engines and ports and
also the communication layer of the DL training application that use them.

There are eight new entries. Detailed description is in the documentation
file but here is a summary:

- nic_mac_loopback: enable mac loopback mode per port
- nic_ports_status: print physical connection status per port
- nic_pcs_fail_time_frame: configure windows size for measuring pcs
                           failures
- nic_pcs_fail_threshold: configure pcs failures threshold for
                          reconfiguring the link
- nic_pam4_tx_taps: configure PAM4 TX taps
- nic_polarity: configure polarity for NIC port lanes
- nic_check_link: configure whether to check the PCS link periodically
- nic_phy_auto_neg_lpbk: enable PHY auto-negotiation loopback

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
 .../ABI/testing/debugfs-driver-habanalabs     |  69 +++
 drivers/misc/habanalabs/gaudi/Makefile        |   3 +-
 drivers/misc/habanalabs/gaudi/gaudi_nic.c     |   2 +
 .../misc/habanalabs/gaudi/gaudi_nic_debugfs.c | 402 ++++++++++++++++++
 4 files changed, 475 insertions(+), 1 deletion(-)
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_debugfs.c

diff --git a/Documentation/ABI/testing/debugfs-driver-habanalabs b/Documentation/ABI/testing/debugfs-driver-habanalabs
index 2e9ae311e02d..8fca02b92a80 100644
--- a/Documentation/ABI/testing/debugfs-driver-habanalabs
+++ b/Documentation/ABI/testing/debugfs-driver-habanalabs
@@ -176,3 +176,72 @@ KernelVersion:  5.6
 Contact:        oded.gabbay@gmail.com
 Description:    Sets the stop-on_error option for the device engines. Value of
                 "0" is for disable, otherwise enable.
+
+What:           /sys/kernel/debug/habanalabs/hl<n>/nic_mac_loopback
+Date:           Nov 2020
+KernelVersion:  5.10
+Contact:        oshpigelman@habana.ai
+Description:    Allows the root user to disable/enable MAC loopback for Gaudi
+                NIC ports. The ports will function as if a physical loopback
+                transceiver was connected. A bitmask should be provided where
+                each bit represents a port, up to 20 bits.
+                Known issues for this mode:
+                1. Odd ports PHY is not stopped so the peer's odd ports will get
+                PCS link.
+                2. Might cause an interrupt storm due to high B/W.
+
+What:           /sys/kernel/debug/habanalabs/hl<n>/nic_ports_status
+Date:           Nov 2020
+KernelVersion:  5.10
+Contact:        oshpigelman@habana.ai
+Description:    Displays a summary the PC link state of all Gaudi NIC ports.
+
+What:           /sys/kernel/debug/habanalabs/hl<n>/nic_pcs_fail_time_frame
+Date:           Nov 2020
+KernelVersion:  5.10
+Contact:        oshpigelman@habana.ai
+Description:    Allows the root user to set the used time frame in seconds for
+                detecting a loose PCS link of a Gaudi NIC port. We count how
+                many PCS link failures occurred in a time frame up to a
+                threshold which will cause PHY reconfiguration for getting a new
+                PCS link.
+
+What:           /sys/kernel/debug/habanalabs/hl<n>/nic_pcs_fail_threshold
+Date:           Nov 2020
+KernelVersion:  5.10
+Contact:        oshpigelman@habana.ai
+Description:    Allows the root user to set the used threshold for detecting a
+                loose PCS link of a Gaudi NIC port. We count how many PCS link
+                failures occurred in a time frame up to the threshold which will
+                cause PHY reconfiguration for getting a new PCS link.
+
+What:           /sys/kernel/debug/habanalabs/hl<n>/nic_pam4_tx_taps
+Date:           Nov 2020
+KernelVersion:  5.10
+Contact:        oshpigelman@habana.ai
+Description:    Allows the root user to set the PAM4 Tx taps for Gaudi NIC port
+                lanes. The lanes indices are 0-39.
+                Acceptable input string form:
+                <lane> <tx_pre2> <tx_pre1> <tx_main> <tx_post1> <tx_post2>.
+
+What:           /sys/kernel/debug/habanalabs/hl<n>/nic_polarity
+Date:           Nov 2020
+KernelVersion:  5.10
+Contact:        oshpigelman@habana.ai
+Description:    Allows the root user to set the polarity for Gaudi NIC port
+                lanes. The lanes indices are 0-39.
+                Acceptable input string form: <lane> <pol_tx> <pol_rx>.
+
+What:           /sys/kernel/debug/habanalabs/hl<n>/nic_check_link
+Date:           Nov 2020
+KernelVersion:  5.10
+Contact:        oshpigelman@habana.ai
+Description:    Sets the PCS link periodic check for all Gaudi NIC ports. Value
+                of "0" is for disable, otherwise enable.
+
+What:           /sys/kernel/debug/habanalabs/hl<n>/nic_phy_auto_neg_lpbk
+Date:           Nov 2020
+KernelVersion:  5.10
+Contact:        oshpigelman@habana.ai
+Description:    Sets the PHY Autoneg loopback support for all Gaudi NIC ports.
+                Value of "0" is for disable, otherwise enable.
diff --git a/drivers/misc/habanalabs/gaudi/Makefile b/drivers/misc/habanalabs/gaudi/Makefile
index c5143cf6f025..437b21e54c95 100644
--- a/drivers/misc/habanalabs/gaudi/Makefile
+++ b/drivers/misc/habanalabs/gaudi/Makefile
@@ -2,4 +2,5 @@
 HL_GAUDI_FILES := gaudi/gaudi.o gaudi/gaudi_hwmgr.o gaudi/gaudi_security.o \
 	gaudi/gaudi_coresight.o
 
-HL_GAUDI_FILES += gaudi/gaudi_nic.o gaudi/gaudi_phy.o
+HL_GAUDI_FILES += gaudi/gaudi_nic.o gaudi/gaudi_phy.o \
+	gaudi/gaudi_nic_debugfs.o
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic.c b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
index 41789f7ed32e..a73635a4c44b 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_nic.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
@@ -3025,6 +3025,8 @@ int gaudi_nic_ports_init(struct hl_device *hdev)
 			}
 		}
 
+	gaudi_nic_debugfs_init(hdev);
+
 	gaudi->hw_cap_initialized |= HW_CAP_NIC_DRV;
 
 	return 0;
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic_debugfs.c b/drivers/misc/habanalabs/gaudi/gaudi_nic_debugfs.c
new file mode 100644
index 000000000000..2e99d2683512
--- /dev/null
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic_debugfs.c
@@ -0,0 +1,402 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright 2018-2020 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ */
+
+#include "gaudi_nic.h"
+#include <linux/debugfs.h>
+#include <linux/nospec.h>
+
+#ifdef CONFIG_DEBUG_FS
+
+#define POLARITY_KBUF_SIZE	8
+#define TX_TAPS_KBUF_SIZE	25
+
+static ssize_t debugfs_pam4_tx_taps_write(struct file *f,
+						const char __user *buf,
+						size_t count, loff_t *ppos)
+{
+	struct hl_device *hdev = file_inode(f)->i_private;
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	char kbuf[TX_TAPS_KBUF_SIZE];
+	char *c1, *c2;
+	ssize_t rc;
+	u32 lane;
+	s32 tx_pre2, tx_pre1, tx_main, tx_post1, tx_post2;
+	s32 *taps;
+
+	if (count > sizeof(kbuf) - 1)
+		goto err;
+	if (copy_from_user(kbuf, buf, count))
+		goto err;
+	kbuf[count] = '\0';
+
+	c1 = kbuf;
+	c2 = strchr(c1, ' ');
+	if (!c2)
+		goto err;
+	*c2 = '\0';
+
+	rc = kstrtou32(c1, 10, &lane);
+	if (rc)
+		goto err;
+
+	if (lane >= NIC_MAX_NUM_OF_LANES) {
+		dev_err(hdev->dev, "lane max value is %d\n",
+			NIC_MAX_NUM_OF_LANES - 1);
+		return -EINVAL;
+	}
+
+	/* Turn off speculation due to Spectre vulnerability */
+	lane = array_index_nospec(lane, NIC_MAX_NUM_OF_LANES);
+
+	c1 = c2 + 1;
+
+	c2 = strchr(c1, ' ');
+	if (!c2)
+		goto err;
+	*c2 = '\0';
+
+	rc = kstrtos32(c1, 10, &tx_pre2);
+	if (rc)
+		goto err;
+
+	c1 = c2 + 1;
+
+	c2 = strchr(c1, ' ');
+	if (!c2)
+		goto err;
+	*c2 = '\0';
+
+	rc = kstrtos32(c1, 10, &tx_pre1);
+	if (rc)
+		goto err;
+
+	c1 = c2 + 1;
+
+	c2 = strchr(c1, ' ');
+	if (!c2)
+		goto err;
+	*c2 = '\0';
+
+	rc = kstrtos32(c1, 10, &tx_main);
+	if (rc)
+		goto err;
+
+	c1 = c2 + 1;
+
+	c2 = strchr(c1, ' ');
+	if (!c2)
+		goto err;
+	*c2 = '\0';
+
+	rc = kstrtos32(c1, 10, &tx_post1);
+	if (rc)
+		goto err;
+
+	c1 = c2 + 1;
+
+	rc = kstrtos32(c1, 10, &tx_post2);
+	if (rc)
+		goto err;
+
+	taps = gaudi->nic_pam4_tx_taps[lane].taps;
+	taps[0] = tx_pre2;
+	taps[1] = tx_pre1;
+	taps[2] = tx_main;
+	taps[3] = tx_post1;
+	taps[4] = tx_post2;
+
+	return count;
+err:
+	dev_err(hdev->dev,
+		"usage: echo <lane> <tx_pre2> <tx_pre1> <tx_main> <tx_post1> <tx_post2> > nic_pam4_tx_taps\n");
+
+	return -EINVAL;
+}
+
+static const struct file_operations debugfs_pam4_tx_taps_fops = {
+	.owner = THIS_MODULE,
+	.write = debugfs_pam4_tx_taps_write,
+};
+
+static ssize_t debugfs_polarity_write(struct file *f, const char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	struct hl_device *hdev = file_inode(f)->i_private;
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	struct cpucp_nic_info *nic_info = &hdev->asic_prop.cpucp_nic_info;
+	char kbuf[POLARITY_KBUF_SIZE];
+	char *c1, *c2;
+	ssize_t rc;
+	u64 val;
+	u32 lane;
+	u8 pol_tx, pol_rx;
+
+	if (count > sizeof(kbuf) - 1)
+		goto err;
+	if (copy_from_user(kbuf, buf, count))
+		goto err;
+	kbuf[count] = '\0';
+
+	c1 = kbuf;
+	c2 = strchr(c1, ' ');
+	if (!c2)
+		goto err;
+	*c2 = '\0';
+
+	rc = kstrtou32(c1, 10, &lane);
+	if (rc)
+		goto err;
+
+	if (lane >= NIC_MAX_NUM_OF_LANES) {
+		dev_err(hdev->dev, "lane max value is %d\n",
+			NIC_MAX_NUM_OF_LANES - 1);
+		return -EINVAL;
+	}
+
+	c1 = c2 + 1;
+
+	c2 = strchr(c1, ' ');
+	if (!c2)
+		goto err;
+	*c2 = '\0';
+
+	rc = kstrtou8(c1, 10, &pol_tx);
+	if (rc)
+		goto err;
+
+	c1 = c2 + 1;
+
+	rc = kstrtou8(c1, 10, &pol_rx);
+	if (rc)
+		goto err;
+
+	if ((pol_tx & ~1) || (pol_rx & ~1)) {
+		dev_err(hdev->dev, "pol_tx and pol_rx should be 0 or 1\n");
+		goto err;
+	}
+
+	val = le64_to_cpu(nic_info->pol_tx_mask[0]);
+	val &= ~BIT_ULL(lane);
+	val |= ((u64) pol_tx) << lane;
+	nic_info->pol_tx_mask[0] = cpu_to_le64(val);
+
+	val = le64_to_cpu(nic_info->pol_rx_mask[0]);
+	val &= ~BIT_ULL(lane);
+	val |= ((u64) pol_rx) << lane;
+	nic_info->pol_rx_mask[0] = cpu_to_le64(val);
+
+	gaudi->nic_use_fw_polarity = true;
+
+	return count;
+err:
+	dev_err(hdev->dev,
+		"usage: echo <lane> <pol_tx> <pol_rx> > nic_polarity\n");
+
+	return -EINVAL;
+}
+
+static const struct file_operations debugfs_polarity_fops = {
+	.owner = THIS_MODULE,
+	.write = debugfs_polarity_write,
+};
+
+static ssize_t debugfs_ports_status_read(struct file *f, char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	struct hl_device *hdev = file_inode(f)->i_private;
+	struct gaudi_device *gaudi = hdev->asic_specific;
+	char tmp_buf[512] = {0};
+	ssize_t rc;
+	int i, up_cnt = 0, down_cnt = 0;
+
+	if (*ppos)
+		return 0;
+
+	for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++)
+		if ((hdev->nic_ports_mask & BIT(i))) {
+			if (gaudi->nic_devices[i].active)
+				up_cnt++;
+			else
+				down_cnt++;
+		}
+
+	if (up_cnt) {
+		sprintf(tmp_buf, "%d ports up (", up_cnt);
+
+		for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++)
+			if ((hdev->nic_ports_mask & BIT(i)) &&
+				gaudi->nic_devices[i].active)
+				sprintf(tmp_buf + strlen(tmp_buf), "%d, ", i);
+
+		sprintf(tmp_buf + strlen(tmp_buf) - 2, ")");
+	}
+
+	if (down_cnt) {
+		if (up_cnt)
+			sprintf(tmp_buf + strlen(tmp_buf), "\n");
+
+		sprintf(tmp_buf + strlen(tmp_buf), "%d ports down (", down_cnt);
+
+		for (i = 0 ; i < NIC_NUMBER_OF_PORTS ; i++)
+			if ((hdev->nic_ports_mask & BIT(i)) &&
+				!gaudi->nic_devices[i].active)
+				sprintf(tmp_buf + strlen(tmp_buf), "%d, ", i);
+
+		sprintf(tmp_buf + strlen(tmp_buf) - 2, ")");
+	}
+
+	sprintf(tmp_buf + strlen(tmp_buf), "\n");
+
+	rc = simple_read_from_buffer(buf, strlen(tmp_buf) + 1, ppos, tmp_buf,
+					strlen(tmp_buf) + 1);
+
+	return rc;
+}
+
+static const struct file_operations debugfs_ports_status_fops = {
+	.owner = THIS_MODULE,
+	.read = debugfs_ports_status_read,
+};
+
+#define NIC_DEBUGFS(X, fmt, do_reset) \
+static ssize_t debugfs_##X##_read(struct file *f, \
+					char __user *buf, \
+					size_t count, \
+					loff_t *ppos) \
+{ \
+	struct hl_device *hdev = file_inode(f)->i_private; \
+	struct gaudi_device *gaudi = hdev->asic_specific; \
+	char tmp_buf[32]; \
+	ssize_t rc; \
+\
+	if (*ppos) \
+		return 0; \
+\
+	sprintf(tmp_buf, fmt "\n", gaudi->nic_##X); \
+	rc = simple_read_from_buffer(buf, strlen(tmp_buf) + 1, ppos, tmp_buf, \
+			strlen(tmp_buf) + 1); \
+\
+	return rc; \
+} \
+\
+static ssize_t debugfs_##X##_write(struct file *f, \
+					const char __user *buf, \
+					size_t count, \
+					loff_t *ppos) \
+{ \
+	struct hl_device *hdev = file_inode(f)->i_private; \
+	struct gaudi_device *gaudi = hdev->asic_specific; \
+	u64 val, base; \
+	ssize_t rc; \
+\
+	if (!strcmp(fmt, "%d")) \
+		base = 10; \
+	else \
+		base = 16; \
+\
+	rc = kstrtoull_from_user(buf, count, base, &val); \
+	if (rc) \
+		return rc; \
+\
+	if (val == gaudi->nic_##X) \
+		return count; \
+\
+	if (do_reset && gaudi->nic_debugfs_reset) { \
+		gaudi->nic_##X = val; \
+		hl_device_reset(hdev, true, false); \
+		ssleep(HL_PENDING_RESET_PER_SEC); \
+		return count; \
+	} \
+\
+	dev_info(hdev->dev, "NIC reset for %s started\n", __stringify(X)); \
+\
+	rc = gaudi_nic_hard_reset_prepare(hdev); \
+	if (rc) \
+		return rc; \
+\
+	gaudi_nic_stop(hdev); \
+\
+	/* must do this so the ports will be reopened */ \
+	gaudi->hw_cap_initialized &= ~HW_CAP_NIC_DRV; \
+\
+	gaudi->nic_##X = val; \
+\
+	gaudi_nic_ports_reopen(hdev); \
+\
+	dev_info(hdev->dev, "NIC reset for %s finished\n", __stringify(X)); \
+\
+	return count; \
+} \
+\
+static const struct file_operations debugfs_##X##_fops = { \
+	.owner = THIS_MODULE, \
+	.read = debugfs_##X##_read, \
+	.write = debugfs_##X##_write, \
+}
+
+NIC_DEBUGFS(mac_loopback, "0x%llx", true);
+NIC_DEBUGFS(pcs_fail_time_frame, "%d", false);
+NIC_DEBUGFS(pcs_fail_threshold, "%d", false);
+
+void gaudi_nic_debugfs_init(struct hl_device *hdev)
+{
+	struct gaudi_device *gaudi = hdev->asic_specific;
+
+	debugfs_create_file("nic_mac_loopback",
+				0644,
+				hdev->hl_debugfs.root,
+				hdev,
+				&debugfs_mac_loopback_fops);
+
+	debugfs_create_file("nic_ports_status",
+				0444,
+				hdev->hl_debugfs.root,
+				hdev,
+				&debugfs_ports_status_fops);
+
+	debugfs_create_file("nic_pcs_fail_time_frame",
+				0644,
+				hdev->hl_debugfs.root,
+				hdev,
+				&debugfs_pcs_fail_time_frame_fops);
+
+	debugfs_create_file("nic_pcs_fail_threshold",
+				0644,
+				hdev->hl_debugfs.root,
+				hdev,
+				&debugfs_pcs_fail_threshold_fops);
+
+	debugfs_create_file("nic_pam4_tx_taps",
+				0444,
+				hdev->hl_debugfs.root,
+				hdev,
+				&debugfs_pam4_tx_taps_fops);
+
+	debugfs_create_file("nic_polarity",
+				0444,
+				hdev->hl_debugfs.root,
+				hdev,
+				&debugfs_polarity_fops);
+
+	debugfs_create_u8("nic_check_link",
+				0644,
+				hdev->hl_debugfs.root,
+				&gaudi->nic_check_link);
+
+	debugfs_create_u8("nic_phy_auto_neg_lpbk",
+				0644,
+				hdev->hl_debugfs.root,
+				&gaudi->nic_phy_auto_neg_lpbk);
+}
+
+#else
+
+void gaudi_nic_debugfs_init(struct hl_device *hdev)
+{
+}
+
+#endif /* CONFIG_DEBUG_FS */
-- 
2.17.1

