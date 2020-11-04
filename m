Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B3B2A6B2A
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbgKDQ5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731582AbgKDQ5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:57:35 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72D2C0613D3;
        Wed,  4 Nov 2020 08:57:34 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id o9so28662292ejg.1;
        Wed, 04 Nov 2020 08:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fr/iPQRvNxRJm2g0WILZ2LzfertETsXzFRq5jPgkOKc=;
        b=mfGDfomz0+KlPCBedNoSVGdwh+IjH7Hs2I2pdjP3WdF3LyhtCs/onTTeYDIK+HxQTt
         kfEvJK98dpE/29tBYrJL1VlgTp/L7InTm5hj9/efsjBs6ixeaEeTFEpI0mhQbEvOZ9Dp
         hdJpBdfDB/mLK+FQlHXEODeG4rcIVg77cIpqJ+M26NsnVo1w2I7VMzERNkA4udds/78v
         BL9LkCFsx88DyyKFOqTTEdnQg29m+L5LiCuUAb1N8etU7aBSM5BVqfx1oDI30/xgvatl
         bQMj8YtsW/eXeNs/HsiPJ9WHrAoMt0ABAumcJNVsOOP1e1qSS7RvN/g++P051vOf25Rx
         wDEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fr/iPQRvNxRJm2g0WILZ2LzfertETsXzFRq5jPgkOKc=;
        b=EOQSbF1KcRZ6gz92Q1WRjh7ILY1R+wLVnwFojw+IjafUkkBVXjSX7mPglJ0izaVn30
         UZB/OPLsHd4HbqtuDrU/c54hDBrz+tHeZe+ZCBkptlVNaYhAyIqoVEq16DOgBnwaMqY9
         bquZCbJGVt26Exb9eRIIsZfYaMC2BMNe0nL6ExCswzzXkYvx4HWSdxFp6jPs8zXdva7n
         twcgUjzyJCIxYa4m9QcKSWZCDS+CpvhUPtblR5UShiMoT/LfGRJrRBhVn7L1wKX7SmmJ
         6TcUi1jyhXp+RyKAPnqH7SqPWYlaOUpOVZO0tD4kZSUbRQN2J1lm2pRPMDHtWChr8ANG
         jxtw==
X-Gm-Message-State: AOAM532nEDf+oLMvMEKfV6xwTF7dTmLr/DkqXF1uPdbYHI0URPmTG79U
        IGUJM+oPSSTflnIf1QF0wOo=
X-Google-Smtp-Source: ABdhPJz2yCjvV3FMG8+SDxmdWZ58z1jo4u9toEzb6F0rNvbc4VaJ2zsKf5j2j1tjWD1bMWMbvFt22g==
X-Received: by 2002:a17:906:1e45:: with SMTP id i5mr25434388ejj.203.1604509053524;
        Wed, 04 Nov 2020 08:57:33 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l12sm1354748edt.46.2020.11.04.08.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 08:57:32 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC 4/9] staging: dpaa2-switch: setup dpio
Date:   Wed,  4 Nov 2020 18:57:15 +0200
Message-Id: <20201104165720.2566399-5-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104165720.2566399-1-ciorneiioana@gmail.com>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Setup interrupts on the control interface queues. We do not force an
exact affinity between the interrupts received from a specific queue and
a cpu.

Also, the DPSW object version is incremented since the
dpsw_ctrl_if_set_queue() API is introduced in the v8.4 object
(first seen in the MC 10.19.0 firmware).

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h | 17 +++++-
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     | 33 +++++++++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     | 23 ++++++++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    | 65 ++++++++++++++++++++++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h    |  1 +
 5 files changed, 138 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
index e27e86d5d4fb..9caff864ae3e 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
@@ -12,7 +12,7 @@
 
 /* DPSW Version */
 #define DPSW_VER_MAJOR		8
-#define DPSW_VER_MINOR		1
+#define DPSW_VER_MINOR		4
 
 #define DPSW_CMD_BASE_VERSION	1
 #define DPSW_CMD_ID_OFFSET	4
@@ -77,6 +77,7 @@
 
 #define DPSW_CMDID_CTRL_IF_GET_ATTR         DPSW_CMD_ID(0x0A0)
 #define DPSW_CMDID_CTRL_IF_SET_POOLS        DPSW_CMD_ID(0x0A1)
+#define DPSW_CMDID_CTRL_IF_SET_QUEUE        DPSW_CMD_ID(0x0A6)
 
 /* Macros for accessing command fields smaller than 1byte */
 #define DPSW_MASK(field)        \
@@ -389,6 +390,20 @@ struct dpsw_cmd_ctrl_if_set_pools {
 	__le16 buffer_size[DPSW_MAX_DPBP];
 };
 
+#define DPSW_DEST_TYPE_SHIFT	0
+#define DPSW_DEST_TYPE_SIZE	4
+
+struct dpsw_cmd_ctrl_if_set_queue {
+	__le32 dest_id;
+	u8 dest_priority;
+	u8 pad;
+	/* from LSB: dest_type:4 */
+	u8 dest_type;
+	u8 qtype;
+	__le64 user_ctx;
+	__le32 options;
+};
+
 struct dpsw_rsp_get_api_version {
 	__le16 version_major;
 	__le16 version_minor;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
index 01ebdb12adec..785140d4652c 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
@@ -1244,6 +1244,39 @@ int dpsw_ctrl_if_set_pools(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 	return mc_send_command(mc_io, &cmd);
 }
 
+/**
+ * dpsw_ctrl_if_set_queue() - Set Rx queue configuration
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of dpsw object
+ * @qtype:	dpsw_queue_type of the targeted queue
+ * @cfg:	Rx queue configuration
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpsw_ctrl_if_set_queue(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   enum dpsw_queue_type qtype,
+			   const struct dpsw_ctrl_if_queue_cfg *cfg)
+{
+	struct dpsw_cmd_ctrl_if_set_queue *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_CTRL_IF_SET_QUEUE,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_ctrl_if_set_queue *)cmd.params;
+	cmd_params->dest_id = cpu_to_le32(cfg->dest_cfg.dest_id);
+	cmd_params->dest_priority = cfg->dest_cfg.priority;
+	cmd_params->qtype = qtype;
+	cmd_params->user_ctx = cpu_to_le64(cfg->user_ctx);
+	cmd_params->options = cpu_to_le32(cfg->options);
+	dpsw_set_field(cmd_params->dest_type,
+		       DEST_TYPE,
+		       cfg->dest_cfg.dest_type);
+
+	return mc_send_command(mc_io, &cmd);
+}
+
 /**
  * dpsw_get_api_version() - Get Data Path Switch API version
  * @mc_io:	Pointer to MC portal's I/O object
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
index 5ad7c0634992..718242ea7d87 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
@@ -222,6 +222,29 @@ struct dpsw_ctrl_if_pools_cfg {
 int dpsw_ctrl_if_set_pools(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 			   const struct dpsw_ctrl_if_pools_cfg *cfg);
 
+#define DPSW_CTRL_IF_QUEUE_OPT_USER_CTX		0x00000001
+#define DPSW_CTRL_IF_QUEUE_OPT_DEST		0x00000002
+
+enum dpsw_ctrl_if_dest {
+	DPSW_CTRL_IF_DEST_NONE = 0,
+	DPSW_CTRL_IF_DEST_DPIO = 1,
+};
+
+struct dpsw_ctrl_if_dest_cfg {
+	enum dpsw_ctrl_if_dest dest_type;
+	int dest_id;
+	u8 priority;
+};
+
+struct dpsw_ctrl_if_queue_cfg {
+	u32 options;
+	u64 user_ctx;
+	struct dpsw_ctrl_if_dest_cfg dest_cfg;
+};
+
+int dpsw_ctrl_if_set_queue(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			   enum dpsw_queue_type qtype,
+			   const struct dpsw_ctrl_if_queue_cfg *cfg);
 /**
  * enum dpsw_action - Action selection for special/control frames
  * @DPSW_ACTION_DROP: Drop frame
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index d81961d36821..f8f972421fea 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -1607,6 +1607,64 @@ static void dpaa2_switch_destroy_rings(struct ethsw_core *ethsw)
 		dpaa2_io_store_destroy(ethsw->fq[i].store);
 }
 
+static int dpaa2_switch_setup_dpio(struct ethsw_core *ethsw)
+{
+	struct dpsw_ctrl_if_queue_cfg queue_cfg;
+	struct dpaa2_io_notification_ctx *nctx;
+	int err, i, j;
+
+	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++) {
+		nctx = &ethsw->fq[i].nctx;
+
+		/* Register a new software context for the FQID.
+		 * By using NULL as the first parameter, we specify that we do
+		 * not care on which cpu are interrupts received for this queue
+		 */
+		nctx->is_cdan = 0;
+		nctx->id = ethsw->fq[i].fqid;
+		nctx->desired_cpu = DPAA2_IO_ANY_CPU;
+		err = dpaa2_io_service_register(NULL, nctx, ethsw->dev);
+		if (err) {
+			err = -EPROBE_DEFER;
+			goto err_register;
+		}
+
+		queue_cfg.options = DPSW_CTRL_IF_QUEUE_OPT_DEST |
+				    DPSW_CTRL_IF_QUEUE_OPT_USER_CTX;
+		queue_cfg.dest_cfg.dest_type = DPSW_CTRL_IF_DEST_DPIO;
+		queue_cfg.dest_cfg.dest_id = nctx->dpio_id;
+		queue_cfg.dest_cfg.priority = 0;
+		queue_cfg.user_ctx = nctx->qman64;
+
+		err = dpsw_ctrl_if_set_queue(ethsw->mc_io, 0,
+					     ethsw->dpsw_handle,
+					     ethsw->fq[i].type,
+					     &queue_cfg);
+		if (err)
+			goto err_set_queue;
+	}
+
+	return 0;
+
+err_set_queue:
+	dpaa2_io_service_deregister(NULL, nctx, ethsw->dev);
+err_register:
+	for (j = 0; j < i; j++)
+		dpaa2_io_service_deregister(NULL, &ethsw->fq[j].nctx,
+					    ethsw->dev);
+
+	return err;
+}
+
+static void dpaa2_switch_free_dpio(struct ethsw_core *ethsw)
+{
+	int i;
+
+	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++)
+		dpaa2_io_service_deregister(NULL, &ethsw->fq[i].nctx,
+					    ethsw->dev);
+}
+
 static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 {
 	int err;
@@ -1625,8 +1683,14 @@ static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 	if (err)
 		goto err_free_dpbp;
 
+	err = dpaa2_switch_setup_dpio(ethsw);
+	if (err)
+		goto err_destroy_rings;
+
 	return 0;
 
+err_destroy_rings:
+	dpaa2_switch_destroy_rings(ethsw);
 err_free_dpbp:
 	dpaa2_switch_free_dpbp(ethsw);
 
@@ -1813,6 +1877,7 @@ static void dpaa2_switch_takedown(struct fsl_mc_device *sw_dev)
 
 static void dpaa2_switch_ctrl_if_teardown(struct ethsw_core *ethsw)
 {
+	dpaa2_switch_free_dpio(ethsw);
 	dpaa2_switch_destroy_rings(ethsw);
 	dpaa2_switch_free_dpbp(ethsw);
 }
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index b476f9ac4c55..c78ee5409b8a 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -61,6 +61,7 @@ struct dpaa2_switch_fq {
 	struct ethsw_core *ethsw;
 	enum dpsw_queue_type type;
 	struct dpaa2_io_store *store;
+	struct dpaa2_io_notification_ctx nctx;
 	u32 fqid;
 };
 
-- 
2.28.0

