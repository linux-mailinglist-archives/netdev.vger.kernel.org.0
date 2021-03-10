Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBDA333C63
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhCJMQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbhCJMPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:35 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D996DC061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:34 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id t1so27711878eds.7
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J5bH24nbCnqQ9uR5j8B2xFG4PtJMJ8mHyETriZocZvk=;
        b=o9q4Mep3WbzPXsqsygfbu6lhmnZKW0buF88zvwiePeHtJTaLXIXnPHZvjfq4wQixl2
         OuvtmRVVAMB6VcFuM7mkd7IWnLTM9d8HJPUXVuSSwvd2BJM9skvfP5UJ50FYK/CfNnpl
         oSrFWnXJJXQWS3RLhT3Qj8ZEoGOD5Q8lL1xQxK4mq54h6KFKcTTMMglKlyJEumBWBkL+
         TnRE9e/BtRl6rMMWg1d60QF0gGFnIdQfbdcvX9z6CAU2na+OSUE9HTuceBdMWeYsEe1c
         8kAfYxkIHFPnP7Kw7SIPt4LOJXig/+wgXH/8QmotR0dsdl59aq9wjvcAtHZC/OkPRJrz
         +ohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J5bH24nbCnqQ9uR5j8B2xFG4PtJMJ8mHyETriZocZvk=;
        b=IZX6br9FW75AyvjOrwwztwtU0WXxRu3xmuug4C//dnUpjJ/l1xlu+QsIh68h2dgEbo
         6h9ub1eXI6syeagtMoDjWZDT4mqOxFtlt8KESUEAbB1YtfI/Oih0gh0uWflV4z5pLhqT
         9FV5iO+n2ZpGVVq2oM7BGVoyFk3lx3wVNIQDrfxxYx1y4bI+WUOsIRQthhsumv2VRl91
         zlZu0tzzSS1mI1BAGd58dZF2fMHOG4K15jWkI8zWtbua+KeUwGckwytqH3ZdvwzqZHOl
         CRoNPw8XvDhS4R9SU/576dmOG0lg+wwetRjuri0JNdNNhCzM8GicwB/EnSGxj3Y9K1pX
         aH/w==
X-Gm-Message-State: AOAM532vOYGYZfrymBYveoNnHTzZUj2MCE5tqRkRUn0tCX4aibbbN9QB
        QFTlqO8lrzZYnIVBCn89CP8QW1yscM1EAMXn
X-Google-Smtp-Source: ABdhPJzGayhnTeTpzYU8Y1aS6t82XDzUZUTpOu97CDaTmFxMJmtqr5lGGGdx1rxt4mVzep8Am1Y7Tw==
X-Received: by 2002:a05:6402:2070:: with SMTP id bd16mr2876465edb.133.1615378533515;
        Wed, 10 Mar 2021 04:15:33 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:33 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 04/15] staging: dpaa2-switch: get control interface attributes
Date:   Wed, 10 Mar 2021 14:14:41 +0200
Message-Id: <20210310121452.552070-5-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Introduce a new structure to hold all necessary info related to an RX
queue for the control interface and populate the FQ IDs.
We only have one Rx queue and one Tx confirmation queue on the control
interface, both shared by all the switch ports.

Also, increase the minimum version of the object supported by the driver
since for a basic switch driver support we'll be in need for some ABIs
added in the latest version of firmware.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h | 13 ++++-
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     | 33 ++++++++++++-
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     | 23 ++++++++-
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    | 56 +++++++++++++++++++---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h    | 22 ++++++++-
 5 files changed, 136 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
index 2a921ed9594d..fc1ba45f8a3f 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright 2014-2016 Freescale Semiconductor Inc.
- * Copyright 2017-2020 NXP
+ * Copyright 2017-2021 NXP
  *
  */
 
@@ -10,7 +10,7 @@
 
 /* DPSW Version */
 #define DPSW_VER_MAJOR		8
-#define DPSW_VER_MINOR		5
+#define DPSW_VER_MINOR		9
 
 #define DPSW_CMD_BASE_VERSION	1
 #define DPSW_CMD_VERSION_2	2
@@ -72,6 +72,8 @@
 #define DPSW_CMDID_IF_GET_PRIMARY_MAC_ADDR  DPSW_CMD_ID(0x0A8)
 #define DPSW_CMDID_IF_SET_PRIMARY_MAC_ADDR  DPSW_CMD_ID(0x0A9)
 
+#define DPSW_CMDID_CTRL_IF_GET_ATTR         DPSW_CMD_ID(0x0A0)
+
 /* Macros for accessing command fields smaller than 1byte */
 #define DPSW_MASK(field)        \
 	GENMASK(DPSW_##field##_SHIFT + DPSW_##field##_SIZE - 1, \
@@ -347,6 +349,13 @@ struct dpsw_rsp_fdb_dump {
 	__le16 num_entries;
 };
 
+struct dpsw_rsp_ctrl_if_get_attr {
+	__le64 pad;
+	__le32 rx_fqid;
+	__le32 rx_err_fqid;
+	__le32 tx_err_conf_fqid;
+};
+
 struct dpsw_rsp_get_api_version {
 	__le16 version_major;
 	__le16 version_minor;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
index f7013d71dc84..a7794f012e78 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright 2014-2016 Freescale Semiconductor Inc.
- * Copyright 2017-2018 NXP
+ * Copyright 2017-2021 NXP
  *
  */
 
@@ -1089,6 +1089,37 @@ int dpsw_fdb_remove_multicast(struct fsl_mc_io *mc_io,
 	return mc_send_command(mc_io, &cmd);
 }
 
+/**
+ * dpsw_ctrl_if_get_attributes() - Obtain control interface attributes
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @attr:	Returned control interface attributes
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpsw_ctrl_if_get_attributes(struct fsl_mc_io *mc_io, u32 cmd_flags,
+				u16 token, struct dpsw_ctrl_if_attr *attr)
+{
+	struct dpsw_rsp_ctrl_if_get_attr *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_CTRL_IF_GET_ATTR,
+					  cmd_flags, token);
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	rsp_params = (struct dpsw_rsp_ctrl_if_get_attr *)cmd.params;
+	attr->rx_fqid = le32_to_cpu(rsp_params->rx_fqid);
+	attr->rx_err_fqid = le32_to_cpu(rsp_params->rx_err_fqid);
+	attr->tx_err_conf_fqid = le32_to_cpu(rsp_params->tx_err_conf_fqid);
+
+	return 0;
+}
+
 /**
  * dpsw_get_api_version() - Get Data Path Switch API version
  * @mc_io:	Pointer to MC portal's I/O object
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
index bc6bcfb6893d..8c8cc9600e8d 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright 2014-2016 Freescale Semiconductor Inc.
- * Copyright 2017-2018 NXP
+ * Copyright 2017-2021 NXP
  *
  */
 
@@ -175,6 +175,27 @@ int dpsw_get_attributes(struct fsl_mc_io *mc_io,
 			u16 token,
 			struct dpsw_attr *attr);
 
+/**
+ * struct dpsw_ctrl_if_attr - Control interface attributes
+ * @rx_fqid:		Receive FQID
+ * @rx_err_fqid:	Receive error FQID
+ * @tx_err_conf_fqid:	Transmit error and confirmation FQID
+ */
+struct dpsw_ctrl_if_attr {
+	u32 rx_fqid;
+	u32 rx_err_fqid;
+	u32 tx_err_conf_fqid;
+};
+
+int dpsw_ctrl_if_get_attributes(struct fsl_mc_io *mc_io, u32 cmd_flags,
+				u16 token, struct dpsw_ctrl_if_attr *attr);
+
+enum dpsw_queue_type {
+	DPSW_QUEUE_RX,
+	DPSW_QUEUE_TX_ERR_CONF,
+	DPSW_QUEUE_RX_ERR,
+};
+
 /**
  * enum dpsw_action - Action selection for special/control frames
  * @DPSW_ACTION_DROP: Drop frame
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 3067289a15a1..b03211fb6fc9 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -20,7 +20,7 @@
 
 /* Minimal supported DPSW version */
 #define DPSW_MIN_VER_MAJOR		8
-#define DPSW_MIN_VER_MINOR		1
+#define DPSW_MIN_VER_MINOR		9
 
 #define DEFAULT_VLAN_ID			1
 
@@ -1334,6 +1334,43 @@ static void dpaa2_switch_detect_features(struct ethsw_core *ethsw)
 		ethsw->features |= ETHSW_FEATURE_MAC_ADDR;
 }
 
+static int dpaa2_switch_setup_fqs(struct ethsw_core *ethsw)
+{
+	struct dpsw_ctrl_if_attr ctrl_if_attr;
+	struct device *dev = ethsw->dev;
+	int i = 0;
+	int err;
+
+	err = dpsw_ctrl_if_get_attributes(ethsw->mc_io, 0, ethsw->dpsw_handle,
+					  &ctrl_if_attr);
+	if (err) {
+		dev_err(dev, "dpsw_ctrl_if_get_attributes() = %d\n", err);
+		return err;
+	}
+
+	ethsw->fq[i].fqid = ctrl_if_attr.rx_fqid;
+	ethsw->fq[i].ethsw = ethsw;
+	ethsw->fq[i++].type = DPSW_QUEUE_RX;
+
+	ethsw->fq[i].fqid = ctrl_if_attr.tx_err_conf_fqid;
+	ethsw->fq[i].ethsw = ethsw;
+	ethsw->fq[i++].type = DPSW_QUEUE_TX_ERR_CONF;
+
+	return 0;
+}
+
+static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
+{
+	int err;
+
+	/* setup FQs for Rx and Tx Conf */
+	err = dpaa2_switch_setup_fqs(ethsw);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 {
 	struct device *dev = &sw_dev->dev;
@@ -1371,11 +1408,14 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 	if (ethsw->major < DPSW_MIN_VER_MAJOR ||
 	    (ethsw->major == DPSW_MIN_VER_MAJOR &&
 	     ethsw->minor < DPSW_MIN_VER_MINOR)) {
-		dev_err(dev, "DPSW version %d:%d not supported. Use %d.%d or greater.\n",
-			ethsw->major,
-			ethsw->minor,
-			DPSW_MIN_VER_MAJOR, DPSW_MIN_VER_MINOR);
-		err = -ENOTSUPP;
+		dev_err(dev, "DPSW version %d:%d not supported. Use firmware 10.28.0 or greater.\n",
+			ethsw->major, ethsw->minor);
+		err = -EOPNOTSUPP;
+		goto err_close;
+	}
+
+	if (!dpaa2_switch_supports_cpu_traffic(ethsw)) {
+		err = -EOPNOTSUPP;
 		goto err_close;
 	}
 
@@ -1447,6 +1487,10 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 		goto err_close;
 	}
 
+	err = dpaa2_switch_ctrl_if_setup(ethsw);
+	if (err)
+		goto err_destroy_ordered_workqueue;
+
 	err = dpaa2_switch_register_notifier(dev);
 	if (err)
 		goto err_destroy_ordered_workqueue;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index 448f60755eea..24a203c42f5f 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -3,7 +3,7 @@
  * DPAA2 Ethernet Switch declarations
  *
  * Copyright 2014-2016 Freescale Semiconductor Inc.
- * Copyright 2017-2018 NXP
+ * Copyright 2017-2021 NXP
  *
  */
 
@@ -39,10 +39,19 @@
 
 #define ETHSW_FEATURE_MAC_ADDR	BIT(0)
 
+/* Number of receive queues (one RX and one TX_CONF) */
+#define DPAA2_SWITCH_RX_NUM_FQS	2
+
 extern const struct ethtool_ops dpaa2_switch_port_ethtool_ops;
 
 struct ethsw_core;
 
+struct dpaa2_switch_fq {
+	struct ethsw_core *ethsw;
+	enum dpsw_queue_type type;
+	u32 fqid;
+};
+
 /* Per port private data */
 struct ethsw_port_priv {
 	struct net_device	*netdev;
@@ -74,6 +83,17 @@ struct ethsw_core {
 	struct notifier_block		port_switchdev_nb;
 	struct notifier_block		port_switchdevb_nb;
 	struct workqueue_struct		*workqueue;
+
+	struct dpaa2_switch_fq		fq[DPAA2_SWITCH_RX_NUM_FQS];
 };
 
+static inline bool dpaa2_switch_supports_cpu_traffic(struct ethsw_core *ethsw)
+{
+	if (ethsw->sw_attr.options & DPSW_OPT_CTRL_IF_DIS) {
+		dev_err(ethsw->dev, "Control Interface is disabled, cannot probe\n");
+		return false;
+	}
+
+	return true;
+}
 #endif	/* __ETHSW_H */
-- 
2.30.0

