Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9132F4600B2
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 18:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355844AbhK0Rv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 12:51:27 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44587 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237276AbhK0Rt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 12:49:27 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 496A25C00C5;
        Sat, 27 Nov 2021 12:46:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 27 Nov 2021 12:46:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=oHPSlYoBITVbe4ItI8fLHYfpHe0FIbKX50WEXhBIxuA=; b=jpGJvD5Z
        tU8EgU+aUnKkoD4uMXSQlWiIUhINWQrdRrUL1DqY/nrl9Qgq+qAoPyddoHgPbpOw
        KMJoXpBGJZUzULYZukKdnAbP0Ecyew1ISATvv9cYDHrR41bj8E6yvE2W7aO/76NX
        A/QlcGVdTLLpHUDKp+vnYWPf2ezomd7PqnYbLp3PlPq7ed/SQ3+rGfX0fkFPJ7Yx
        +X3DdrErbabFYFufrnpegHMxIIGzlCrm5TcB69K+xHNL3rjMGn+L9eJeXEFdUEe2
        fu6EUqiv8b3381b7rX6zOS99sPI/LNDCBsFOzYBRiluldDxsH+Seb+bd8yplZHUv
        +59RrPfefgTetA==
X-ME-Sender: <xms:5G6iYdNHkyUyzKg5HttWnHL1fJVTTnVfqj7J1gq_3rqFdqR_m-N_fw>
    <xme:5G6iYf9Ct8qWd1ERAT3Lpkb5AvtW5jkyH14S8n0kiyPA2Rb4XOkXCqr47Zy1vk2Fj
    h1GsOrZPJlj-QM>
X-ME-Received: <xmr:5G6iYcT4rNLID13AjbWremJLotkeInS6l5Zwgj8BqEoSAEYy-6sBgyGD-WVWK3RtzTKOk0-BZvuoeVEWJLJt2K0J8v7Y07e_gw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrheeggdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:5G6iYZtvuayRkiqFPdmdkecLyZYP62KdecmIrjhbKd2Vcshi4TnNXA>
    <xmx:5G6iYVeLYa7DHT8dg-440t5IuBma1S3eX-5AE1w3ug1lhclr86u4UQ>
    <xmx:5G6iYV0a00l-yXkxPzSsGk4YRPaw4z7TZCt2BeaXu1AbYZ30XeoYGw>
    <xmx:5G6iYfuKA9WHhsHy_9KS7DUkwc7YAitrRZ9Jw9LccgMUF-okQEMlYA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 27 Nov 2021 12:46:09 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 4/4] netdevsim: Implement support for ethtool_ops::start_fw_flash_module
Date:   Sat, 27 Nov 2021 19:45:30 +0200
Message-Id: <20211127174530.3600237-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211127174530.3600237-1-idosch@idosch.org>
References: <20211127174530.3600237-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

For RFC purposes only, implement support for
ethtool_ops::start_fw_flash_module.

A real implementation is expected to call CMIS common code (WIP) that
can be shared across all MAC drivers.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/netdevsim/ethtool.c   | 129 ++++++++++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  10 +++
 2 files changed, 139 insertions(+)

diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index 690cd12a4245..f126b03bf5b0 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -3,6 +3,8 @@
 
 #include <linux/debugfs.h>
 #include <linux/ethtool.h>
+#include <linux/ethtool_netlink.h>
+#include <linux/firmware.h>
 #include <linux/random.h>
 
 #include "netdevsim.h"
@@ -171,6 +173,127 @@ static int nsim_get_module_fw_info(struct net_device *dev,
 	return 0;
 }
 
+static void nsim_module_fw_flash_download(struct netdevsim *ns)
+{
+	struct ethtool_module_fw_flash_ntf_params params = {};
+
+	params.status = ETHTOOL_MODULE_FW_FLASH_STATUS_IN_PROGRESS;
+	params.status_msg = "Downloading firmware image";
+	params.done = 0;
+	params.total = 1500;
+	ethnl_module_fw_flash_ntf(ns->netdev, &params);
+
+	msleep(5000);
+
+	params.done = 750;
+	ethnl_module_fw_flash_ntf(ns->netdev, &params);
+
+	msleep(5000);
+
+	params.done = 1500;
+	ethnl_module_fw_flash_ntf(ns->netdev, &params);
+
+	msleep(5000);
+}
+
+static void nsim_module_fw_flash_validate(struct netdevsim *ns)
+{
+	struct ethtool_module_fw_flash_ntf_params params = {};
+
+	params.status = ETHTOOL_MODULE_FW_FLASH_STATUS_IN_PROGRESS;
+	params.status_msg = "Validating firmware image download";
+	ethnl_module_fw_flash_ntf(ns->netdev, &params);
+
+	msleep(5000);
+}
+
+static void nsim_module_fw_flash_run(struct netdevsim *ns)
+{
+	struct ethtool_module_fw_flash_ntf_params params = {};
+
+	params.status = ETHTOOL_MODULE_FW_FLASH_STATUS_IN_PROGRESS;
+	params.status_msg = "Running firmware image";
+	ethnl_module_fw_flash_ntf(ns->netdev, &params);
+
+	msleep(5000);
+}
+
+static void nsim_module_fw_flash_commit(struct netdevsim *ns)
+{
+	struct ethtool_module_fw_flash_ntf_params params = {};
+
+	if (!ns->ethtool.module_fw.params.commit)
+		return;
+
+	params.status = ETHTOOL_MODULE_FW_FLASH_STATUS_IN_PROGRESS;
+	params.status_msg = "Committing firmware image";
+	ethnl_module_fw_flash_ntf(ns->netdev, &params);
+
+	msleep(5000);
+}
+
+static void nsim_module_fw_flash(struct work_struct *work)
+{
+	struct ethtool_module_fw_flash_ntf_params params = {};
+	struct netdevsim *ns;
+
+	ns = container_of(work, struct netdevsim, ethtool.module_fw.work);
+
+	params.status = ETHTOOL_MODULE_FW_FLASH_STATUS_STARTED;
+	ethnl_module_fw_flash_ntf(ns->netdev, &params);
+
+	if (!ns->ethtool.module_fw.fw)
+		goto commit;
+
+	nsim_module_fw_flash_download(ns);
+	nsim_module_fw_flash_validate(ns);
+	nsim_module_fw_flash_run(ns);
+commit:
+	nsim_module_fw_flash_commit(ns);
+
+	params.status = ETHTOOL_MODULE_FW_FLASH_STATUS_COMPLETED;
+	ethnl_module_fw_flash_ntf(ns->netdev, &params);
+
+	dev_put(ns->netdev);
+	rtnl_lock();
+	ns->ethtool.module_fw.in_progress = false;
+	rtnl_unlock();
+	release_firmware(ns->ethtool.module_fw.fw);
+}
+
+static int
+nsim_start_fw_flash_module(struct net_device *dev,
+			   const struct ethtool_module_fw_flash_params *params,
+			   struct netlink_ext_ack *extack)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	if (ns->ethtool.module_fw.in_progress) {
+		NL_SET_ERR_MSG(extack, "Module firmware flashing already in progress");
+		return -EBUSY;
+	}
+
+	ns->ethtool.module_fw.fw = NULL;
+	if (params->file_name) {
+		int err;
+
+		err = request_firmware(&ns->ethtool.module_fw.fw,
+				       params->file_name, &dev->dev);
+		if (err) {
+			NL_SET_ERR_MSG(extack,
+				       "Failed to request module firmware image");
+			return err;
+		}
+	}
+
+	ns->ethtool.module_fw.in_progress = true;
+	dev_hold(dev);
+	ns->ethtool.module_fw.params = *params;
+	schedule_work(&ns->ethtool.module_fw.work);
+
+	return 0;
+}
+
 static const struct ethtool_ops nsim_ethtool_ops = {
 	.supported_coalesce_params	= ETHTOOL_COALESCE_ALL_PARAMS,
 	.get_pause_stats	        = nsim_get_pause_stats,
@@ -185,6 +308,7 @@ static const struct ethtool_ops nsim_ethtool_ops = {
 	.get_fecparam			= nsim_get_fecparam,
 	.set_fecparam			= nsim_set_fecparam,
 	.get_module_fw_info		= nsim_get_module_fw_info,
+	.start_fw_flash_module		= nsim_start_fw_flash_module,
 };
 
 static void nsim_ethtool_ring_init(struct netdevsim *ns)
@@ -228,4 +352,9 @@ void nsim_ethtool_init(struct netdevsim *ns)
 			   &ns->ethtool.ring.rx_mini_max_pending);
 	debugfs_create_u32("tx_max_pending", 0600, dir,
 			   &ns->ethtool.ring.tx_max_pending);
+
+	/* The work item holds a reference on the netdev, so its unregistration
+	 * cannot be completed while the work is queued or executing.
+	 */
+	INIT_WORK(&ns->ethtool.module_fw.work, nsim_module_fw_flash);
 }
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index c49771f27f17..afa8f9c7f22c 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -16,6 +16,7 @@
 #include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/ethtool.h>
+#include <linux/firmware.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
@@ -59,14 +60,23 @@ struct nsim_ethtool_pauseparam {
 	bool report_stats_tx;
 };
 
+struct nsim_ethtool_module_fw {
+	struct ethtool_module_fw_flash_params params;
+	struct work_struct work;
+	const struct firmware *fw;
+	bool in_progress;
+};
+
 struct nsim_ethtool {
 	u32 get_err;
 	u32 set_err;
 	u32 channels;
 	struct nsim_ethtool_pauseparam pauseparam;
+	struct nsim_ethtool_module_fw module_fw;
 	struct ethtool_coalesce coalesce;
 	struct ethtool_ringparam ring;
 	struct ethtool_fecparam fec;
+
 };
 
 struct netdevsim {
-- 
2.31.1

