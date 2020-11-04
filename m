Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4C32A6B27
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731435AbgKDQ5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731341AbgKDQ5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:57:31 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265BFC0613D4;
        Wed,  4 Nov 2020 08:57:31 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id k9so23188785edo.5;
        Wed, 04 Nov 2020 08:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Wl8VQ83sJ0McXNO1lN782gGN4ABhecaZy/JTrLJ6Zw=;
        b=hWjW+68UB57IORwvWiTy0JQFHigoafHVyV6oAweE67n8AR8Tx6WqdD8ZxYClssmERG
         IbiIhb1gXk4K7+aMXtCSCO46/X/NWByPyU1pZqti9mCT06CnFjf5bqEZfnIOzL8MCaKo
         A4BaHX/8YN2MdD5dImYl7H3oOIpIzT/PjyfmrwiiJbrTp03/F87oFomOnrJwuVsrtQOl
         hMeUjMkYZcWrvjQKb07zXgCHy4K3f5zSICC2iZb4tdQ49OKYp2eR16bT1awYK6MpelmC
         /NvT0BX26ARZm4KJqwYqsm+fEFxZGvhG9c6JYiA7CjJTEsOi+/Gjl2Oncmy27lEO6cZq
         fgBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Wl8VQ83sJ0McXNO1lN782gGN4ABhecaZy/JTrLJ6Zw=;
        b=pCEclfK6FCdfEuYRmxvxgC7OS++EiPDUbRyfxBtG/Tvmu4Cm/XPBCYxePcROmdUlKe
         zVQ8EbWCoRRm0FZYY1stykDWZnWy6gQDu2i12a85H8AQS0hxrQIPAcbRIMqAN3QvjkSQ
         5LtiTYl2jq72i7kdSrJg08pXuGgLJVC827nSBSiwi8iVBnZDdjggjVMFBgaewVfP8pYz
         IN1J7D7PvguOA8SIjzs6t2NNN0Zrz42MECMX3O+x5Lf3VHlvAjdAAHorH2Tlz/Z2BjrW
         AOhXYsCkfdfC3lrSASiAkwlGM77Rf/sN66YRAbBchGxYvnt8OlpvwGe58xKXG9zQBVt3
         d43Q==
X-Gm-Message-State: AOAM530hJpoFTxyLiyGUfDdAinnGdm/TzzDtlTtkXPZBAD3ZgSu3W8Pk
        WSRtuj65wH1t/5FJvC2RRFI=
X-Google-Smtp-Source: ABdhPJyCzO5WR//qs3JScPUHjiBMjmy1AV90OfWcdBoEG7YQK9Y3haKEh5mOh3E5dYjlQEA9gJ4ctQ==
X-Received: by 2002:a05:6402:1d82:: with SMTP id dk2mr27218475edb.299.1604509049745;
        Wed, 04 Nov 2020 08:57:29 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l12sm1354748edt.46.2020.11.04.08.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 08:57:29 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC 1/9] staging: dpaa2-switch: get control interface attributes
Date:   Wed,  4 Nov 2020 18:57:12 +0200
Message-Id: <20201104165720.2566399-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104165720.2566399-1-ciorneiioana@gmail.com>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
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

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h |  9 +++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     | 31 ++++++++++++++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     | 21 +++++++++++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    | 43 ++++++++++++++++++++++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h    | 15 ++++++++
 5 files changed, 119 insertions(+)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
index f100d503bd17..24c902eb63e3 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
@@ -73,6 +73,8 @@
 #define DPSW_CMDID_IF_GET_PRIMARY_MAC_ADDR  DPSW_CMD_ID(0x0A8)
 #define DPSW_CMDID_IF_SET_PRIMARY_MAC_ADDR  DPSW_CMD_ID(0x0A9)
 
+#define DPSW_CMDID_CTRL_IF_GET_ATTR         DPSW_CMD_ID(0x0A0)
+
 /* Macros for accessing command fields smaller than 1byte */
 #define DPSW_MASK(field)        \
 	GENMASK(DPSW_##field##_SHIFT + DPSW_##field##_SIZE - 1, \
@@ -368,6 +370,13 @@ struct dpsw_rsp_fdb_dump {
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
index f8bfe779bd30..996f13abfb1b 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
@@ -1182,6 +1182,37 @@ int dpsw_fdb_set_learning_mode(struct fsl_mc_io *mc_io,
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
index ab63ee4f5cb7..fcc07991119d 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
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
index 20c6326e5dee..c22b9ad558c8 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -1478,6 +1478,43 @@ static void dpaa2_switch_detect_features(struct ethsw_core *ethsw)
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
@@ -1566,6 +1603,12 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 		goto err_close;
 	}
 
+	if (dpaa2_switch_has_ctrl_if(ethsw)) {
+		err = dpaa2_switch_ctrl_if_setup(ethsw);
+		if (err)
+			goto err_destroy_ordered_workqueue;
+	}
+
 	err = dpaa2_switch_register_notifier(dev);
 	if (err)
 		goto err_destroy_ordered_workqueue;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index 5f9211ccb1ef..3189dd72a51b 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
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
@@ -75,6 +84,12 @@ struct ethsw_core {
 	struct notifier_block		port_switchdev_nb;
 	struct notifier_block		port_switchdevb_nb;
 	struct workqueue_struct		*workqueue;
+
+	struct dpaa2_switch_fq		fq[DPAA2_SWITCH_RX_NUM_FQS];
 };
 
+static inline bool dpaa2_switch_has_ctrl_if(struct ethsw_core *ethsw)
+{
+	return !(ethsw->sw_attr.options & DPSW_OPT_CTRL_IF_DIS);
+}
 #endif	/* __ETHSW_H */
-- 
2.28.0

