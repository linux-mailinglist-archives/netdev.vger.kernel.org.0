Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F6D333C5D
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhCJMPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhCJMPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:30 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D77C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:30 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id bm21so38249617ejb.4
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sAY2dnpd67XSTDCEBHYBxFeSiTVnRIpfswARonGRgPo=;
        b=jooIUgJlm19tOKzdNwsE/z6b471Nh+TYWmwLNyhpJVhAIg1GHgBTs3m18j5nj9GTH4
         OMbxhwS0OkMVZy2CGzimKFND/XFHB8ezDpx9pYgIx33WzVeyT8HlLdDcKC+iG6kwFb2L
         e/qsOYivkOM7dolcLRbNbaCc8vPXS6Q9XfRwU2n8gpvyOi0Vf4tZdE4Vc9/uaPZnQDxp
         94Z/NuEzXd6w2ZlsMmFvRYIgfmebAr7hmM8UA7Cr1yP2td8xt9Qs77/icYzUVdJzBgDJ
         mg/fWa8Q4C9dv6qpA2GT3H/DflYrKbH001DE6Z4x7Cps8zy0l6zCidZ26Xau1+HiSy8o
         0h1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sAY2dnpd67XSTDCEBHYBxFeSiTVnRIpfswARonGRgPo=;
        b=cQ0khDaDrbG4ywTfdjxFYU6wd10LvacqvWQ4wycOy/yTuDhp/OhYPPoXFP0yITFpXf
         n9I1ewyrhLLO4qvK2i0ObXfesduGXtI6KKEg10mkdXw+Q8vuKprBQRfAQ+oRDaEFJ15l
         lMDESo5FuPiNdLho9WIArBIObZvR4zpwrO4gH19qAfcDlySQFhz2Zf9Boby2SpU1rY4F
         JrHtR3lxHzjonCs9ofRgzBiS4zBwonF50pW7I+IVIO0aTwzFxt2eVWUmZAqRSNWkCSzR
         3nz1tCh5A8I8nDGSO1dYaxM0h8WR1PGjkIn5sxAYye/mljzhPmMTa2hVdplPIp6q8CFG
         Aulw==
X-Gm-Message-State: AOAM530WHSFm0eZ3TaxdEmZEd4u0yQR+ldDYgriwY2NvLq1+0v76H26n
        KNzufz2cxTW/5EQdX/nxGrs=
X-Google-Smtp-Source: ABdhPJxNK0DQIpPymJsTB2ztg3dQDNkVsuUO2isYiXwPx+qR76eMWynUjlpvndCRSfnJNE76JzEW7w==
X-Received: by 2002:a17:906:32d1:: with SMTP id k17mr3370687ejk.94.1615378528765;
        Wed, 10 Mar 2021 04:15:28 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:28 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 01/15] staging: dpaa2-switch: remove broken learning and flooding support
Date:   Wed, 10 Mar 2021 14:14:38 +0200
Message-Id: <20210310121452.552070-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

This patch is removing the current configuration of learning and
flooding states per switch port because they are essentially broken in
terms of integration with the switchdev APIs and the bridge
understanding of these states.

First of all, the learning state is a per switch port configuration
while the dpaa2-switch driver was using it to configure the entire
bridging domain. This is broken since the software learning state could
be out of sync with the hardware state when ports from the same bridging
domain are configured by the user with different learning parameters.

The BR_FLOOD flag has been misinterpreted as well. Instead of denoting
whether unicast traffic for which there is no FDB entry will be flooded
towards a given port, the dpaa2-switch used the flag to configure
whether or not a frame with an unknown destination received on a given
port should be flooded or not. In summary, it was used as ingress
setting instead of a egress one.

Also, remove the unnecessary call to dpsw_if_set_broadcast() and the API
definition. The HW default is to let all switch ports to be able to
flood broadcast traffic thus there is no need to call the API again.

Instead of trying to patch things up, just remove the support for the
moment so that we'll add it back cleanly once the driver is out of
staging.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h |  24 ----
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     |  93 ----------------
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     |  18 ---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    | 123 ---------------------
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h    |   1 -
 5 files changed, 259 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
index 450841cc6ca8..2a921ed9594d 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
@@ -48,8 +48,6 @@
 #define DPSW_CMDID_IF_SET_MAX_FRAME_LENGTH  DPSW_CMD_ID(0x044)
 
 #define DPSW_CMDID_IF_GET_LINK_STATE        DPSW_CMD_ID(0x046)
-#define DPSW_CMDID_IF_SET_FLOODING          DPSW_CMD_ID(0x047)
-#define DPSW_CMDID_IF_SET_BROADCAST         DPSW_CMD_ID(0x048)
 
 #define DPSW_CMDID_IF_GET_TCI               DPSW_CMD_ID(0x04A)
 
@@ -68,7 +66,6 @@
 #define DPSW_CMDID_FDB_REMOVE_UNICAST       DPSW_CMD_ID(0x085)
 #define DPSW_CMDID_FDB_ADD_MULTICAST        DPSW_CMD_ID(0x086)
 #define DPSW_CMDID_FDB_REMOVE_MULTICAST     DPSW_CMD_ID(0x087)
-#define DPSW_CMDID_FDB_SET_LEARNING_MODE    DPSW_CMD_ID(0x088)
 #define DPSW_CMDID_FDB_DUMP                 DPSW_CMD_ID(0x08A)
 
 #define DPSW_CMDID_IF_GET_PORT_MAC_ADDR     DPSW_CMD_ID(0x0A7)
@@ -191,18 +188,6 @@ struct dpsw_rsp_get_attr {
 	__le64 options;
 };
 
-struct dpsw_cmd_if_set_flooding {
-	__le16 if_id;
-	/* from LSB: enable:1 */
-	u8 enable;
-};
-
-struct dpsw_cmd_if_set_broadcast {
-	__le16 if_id;
-	/* from LSB: enable:1 */
-	u8 enable;
-};
-
 #define DPSW_VLAN_ID_SHIFT	0
 #define DPSW_VLAN_ID_SIZE	12
 #define DPSW_DEI_SHIFT		12
@@ -350,15 +335,6 @@ struct dpsw_cmd_fdb_multicast_op {
 	__le64 if_id[4];
 };
 
-#define DPSW_LEARNING_MODE_SHIFT	0
-#define DPSW_LEARNING_MODE_SIZE		4
-
-struct dpsw_cmd_fdb_set_learning_mode {
-	__le16 fdb_id;
-	/* only the first 4 bits from LSB */
-	u8 mode;
-};
-
 struct dpsw_cmd_fdb_dump {
 	__le16 fdb_id;
 	__le16 pad0;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
index f8bfe779bd30..f7013d71dc84 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
@@ -431,68 +431,6 @@ int dpsw_if_get_link_state(struct fsl_mc_io *mc_io,
 	return 0;
 }
 
-/**
- * dpsw_if_set_flooding() - Enable Disable flooding for particular interface
- * @mc_io:	Pointer to MC portal's I/O object
- * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
- * @token:	Token of DPSW object
- * @if_id:	Interface Identifier
- * @en:		1 - enable, 0 - disable
- *
- * Return:	Completion status. '0' on Success; Error code otherwise.
- */
-int dpsw_if_set_flooding(struct fsl_mc_io *mc_io,
-			 u32 cmd_flags,
-			 u16 token,
-			 u16 if_id,
-			 u8 en)
-{
-	struct fsl_mc_command cmd = { 0 };
-	struct dpsw_cmd_if_set_flooding *cmd_params;
-
-	/* prepare command */
-	cmd.header = mc_encode_cmd_header(DPSW_CMDID_IF_SET_FLOODING,
-					  cmd_flags,
-					  token);
-	cmd_params = (struct dpsw_cmd_if_set_flooding *)cmd.params;
-	cmd_params->if_id = cpu_to_le16(if_id);
-	dpsw_set_field(cmd_params->enable, ENABLE, en);
-
-	/* send command to mc*/
-	return mc_send_command(mc_io, &cmd);
-}
-
-/**
- * dpsw_if_set_broadcast() - Enable/disable broadcast for particular interface
- * @mc_io:	Pointer to MC portal's I/O object
- * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
- * @token:	Token of DPSW object
- * @if_id:	Interface Identifier
- * @en:		1 - enable, 0 - disable
- *
- * Return:	Completion status. '0' on Success; Error code otherwise.
- */
-int dpsw_if_set_broadcast(struct fsl_mc_io *mc_io,
-			  u32 cmd_flags,
-			  u16 token,
-			  u16 if_id,
-			  u8 en)
-{
-	struct fsl_mc_command cmd = { 0 };
-	struct dpsw_cmd_if_set_broadcast *cmd_params;
-
-	/* prepare command */
-	cmd.header = mc_encode_cmd_header(DPSW_CMDID_IF_SET_BROADCAST,
-					  cmd_flags,
-					  token);
-	cmd_params = (struct dpsw_cmd_if_set_broadcast *)cmd.params;
-	cmd_params->if_id = cpu_to_le16(if_id);
-	dpsw_set_field(cmd_params->enable, ENABLE, en);
-
-	/* send command to mc*/
-	return mc_send_command(mc_io, &cmd);
-}
-
 /**
  * dpsw_if_set_tci() - Set default VLAN Tag Control Information (TCI)
  * @mc_io:	Pointer to MC portal's I/O object
@@ -1151,37 +1089,6 @@ int dpsw_fdb_remove_multicast(struct fsl_mc_io *mc_io,
 	return mc_send_command(mc_io, &cmd);
 }
 
-/**
- * dpsw_fdb_set_learning_mode() - Define FDB learning mode
- * @mc_io:	Pointer to MC portal's I/O object
- * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
- * @token:	Token of DPSW object
- * @fdb_id:	Forwarding Database Identifier
- * @mode:	Learning mode
- *
- * Return:	Completion status. '0' on Success; Error code otherwise.
- */
-int dpsw_fdb_set_learning_mode(struct fsl_mc_io *mc_io,
-			       u32 cmd_flags,
-			       u16 token,
-			       u16 fdb_id,
-			       enum dpsw_fdb_learning_mode mode)
-{
-	struct fsl_mc_command cmd = { 0 };
-	struct dpsw_cmd_fdb_set_learning_mode *cmd_params;
-
-	/* prepare command */
-	cmd.header = mc_encode_cmd_header(DPSW_CMDID_FDB_SET_LEARNING_MODE,
-					  cmd_flags,
-					  token);
-	cmd_params = (struct dpsw_cmd_fdb_set_learning_mode *)cmd.params;
-	cmd_params->fdb_id = cpu_to_le16(fdb_id);
-	dpsw_set_field(cmd_params->mode, LEARNING_MODE, mode);
-
-	/* send command to mc*/
-	return mc_send_command(mc_io, &cmd);
-}
-
 /**
  * dpsw_get_api_version() - Get Data Path Switch API version
  * @mc_io:	Pointer to MC portal's I/O object
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
index 9cfd8a8e0197..bc6bcfb6893d 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
@@ -235,18 +235,6 @@ int dpsw_if_get_link_state(struct fsl_mc_io *mc_io,
 			   u16 if_id,
 			   struct dpsw_link_state *state);
 
-int dpsw_if_set_flooding(struct fsl_mc_io *mc_io,
-			 u32 cmd_flags,
-			 u16 token,
-			 u16 if_id,
-			 u8 en);
-
-int dpsw_if_set_broadcast(struct fsl_mc_io *mc_io,
-			  u32 cmd_flags,
-			  u16 token,
-			  u16 if_id,
-			  u8 en);
-
 /**
  * struct dpsw_tci_cfg - Tag Control Information (TCI) configuration
  * @pcp: Priority Code Point (PCP): a 3-bit field which refers
@@ -555,12 +543,6 @@ enum dpsw_fdb_learning_mode {
 	DPSW_FDB_LEARNING_MODE_SECURE = 3
 };
 
-int dpsw_fdb_set_learning_mode(struct fsl_mc_io *mc_io,
-			       u32 cmd_flags,
-			       u16 token,
-			       u16 fdb_id,
-			       enum dpsw_fdb_learning_mode mode);
-
 /**
  * struct dpsw_fdb_attr - FDB Attributes
  * @max_fdb_entries: Number of FDB entries
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 703055e063ff..edcaf99c24fc 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -161,44 +161,6 @@ static int dpaa2_switch_port_add_vlan(struct ethsw_port_priv *port_priv,
 	return 0;
 }
 
-static int dpaa2_switch_set_learning(struct ethsw_core *ethsw, bool enable)
-{
-	enum dpsw_fdb_learning_mode learn_mode;
-	int err;
-
-	if (enable)
-		learn_mode = DPSW_FDB_LEARNING_MODE_HW;
-	else
-		learn_mode = DPSW_FDB_LEARNING_MODE_DIS;
-
-	err = dpsw_fdb_set_learning_mode(ethsw->mc_io, 0, ethsw->dpsw_handle, 0,
-					 learn_mode);
-	if (err) {
-		dev_err(ethsw->dev, "dpsw_fdb_set_learning_mode err %d\n", err);
-		return err;
-	}
-	ethsw->learning = enable;
-
-	return 0;
-}
-
-static int dpaa2_switch_port_set_flood(struct ethsw_port_priv *port_priv, bool enable)
-{
-	int err;
-
-	err = dpsw_if_set_flooding(port_priv->ethsw_data->mc_io, 0,
-				   port_priv->ethsw_data->dpsw_handle,
-				   port_priv->idx, enable);
-	if (err) {
-		netdev_err(port_priv->netdev,
-			   "dpsw_if_set_flooding err %d\n", err);
-		return err;
-	}
-	port_priv->flood = enable;
-
-	return 0;
-}
-
 static int dpaa2_switch_port_set_stp_state(struct ethsw_port_priv *port_priv, u8 state)
 {
 	struct dpsw_stp_cfg stp_cfg = {
@@ -908,41 +870,6 @@ static int dpaa2_switch_port_attr_stp_state_set(struct net_device *netdev,
 	return dpaa2_switch_port_set_stp_state(port_priv, state);
 }
 
-static int
-dpaa2_switch_port_attr_br_flags_pre_set(struct net_device *netdev,
-					struct switchdev_brport_flags flags)
-{
-	if (flags.mask & ~(BR_LEARNING | BR_FLOOD))
-		return -EINVAL;
-
-	return 0;
-}
-
-static int
-dpaa2_switch_port_attr_br_flags_set(struct net_device *netdev,
-				    struct switchdev_brport_flags flags)
-{
-	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
-	int err = 0;
-
-	if (flags.mask & BR_LEARNING) {
-		/* Learning is enabled per switch */
-		err = dpaa2_switch_set_learning(port_priv->ethsw_data,
-						!!(flags.val & BR_LEARNING));
-		if (err)
-			return err;
-	}
-
-	if (flags.mask & BR_FLOOD) {
-		err = dpaa2_switch_port_set_flood(port_priv,
-						  !!(flags.val & BR_FLOOD));
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
 static int dpaa2_switch_port_attr_set(struct net_device *netdev,
 				      const struct switchdev_attr *attr)
 {
@@ -953,14 +880,6 @@ static int dpaa2_switch_port_attr_set(struct net_device *netdev,
 		err = dpaa2_switch_port_attr_stp_state_set(netdev,
 							   attr->u.stp_state);
 		break;
-	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
-		err = dpaa2_switch_port_attr_br_flags_pre_set(netdev,
-							      attr->u.brport_flags);
-		break;
-	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
-		err = dpaa2_switch_port_attr_br_flags_set(netdev,
-							  attr->u.brport_flags);
-		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
 		/* VLANs are supported by default  */
 		break;
@@ -1232,24 +1151,6 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 		}
 	}
 
-	/* Enable flooding */
-	err = dpaa2_switch_port_set_flood(port_priv, 1);
-	if (!err)
-		port_priv->bridge_dev = upper_dev;
-
-	return err;
-}
-
-static int dpaa2_switch_port_bridge_leave(struct net_device *netdev)
-{
-	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
-	int err;
-
-	/* Disable flooding */
-	err = dpaa2_switch_port_set_flood(port_priv, 0);
-	if (!err)
-		port_priv->bridge_dev = NULL;
-
 	return err;
 }
 
@@ -1270,8 +1171,6 @@ static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 		if (netif_is_bridge_master(upper_dev)) {
 			if (info->linking)
 				err = dpaa2_switch_port_bridge_join(netdev, upper_dev);
-			else
-				err = dpaa2_switch_port_bridge_leave(netdev);
 		}
 	}
 
@@ -1513,13 +1412,6 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 		goto err_close;
 	}
 
-	err = dpsw_fdb_set_learning_mode(ethsw->mc_io, 0, ethsw->dpsw_handle, 0,
-					 DPSW_FDB_LEARNING_MODE_HW);
-	if (err) {
-		dev_err(dev, "dpsw_fdb_set_learning_mode err %d\n", err);
-		goto err_close;
-	}
-
 	stp_cfg.vlan_id = DEFAULT_VLAN_ID;
 	stp_cfg.state = DPSW_STP_STATE_FORWARDING;
 
@@ -1531,15 +1423,6 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 				err, i);
 			goto err_close;
 		}
-
-		err = dpsw_if_set_broadcast(ethsw->mc_io, 0,
-					    ethsw->dpsw_handle, i, 1);
-		if (err) {
-			dev_err(dev,
-				"dpsw_if_set_broadcast err %d for port %d\n",
-				err, i);
-			goto err_close;
-		}
 	}
 
 	ethsw->workqueue = alloc_ordered_workqueue("%s_%d_ordered",
@@ -1689,9 +1572,6 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	port_priv->idx = port_idx;
 	port_priv->stp_state = BR_STATE_FORWARDING;
 
-	/* Flooding is implicitly enabled */
-	port_priv->flood = true;
-
 	SET_NETDEV_DEV(port_netdev, dev);
 	port_netdev->netdev_ops = &dpaa2_switch_port_ops;
 	port_netdev->ethtool_ops = &dpaa2_switch_port_ethtool_ops;
@@ -1756,9 +1636,6 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 	/* DEFAULT_VLAN_ID is implicitly configured on the switch */
 	ethsw->vlans[DEFAULT_VLAN_ID] = ETHSW_VLAN_MEMBER;
 
-	/* Learning is implicitly enabled */
-	ethsw->learning = true;
-
 	ethsw->ports = kcalloc(ethsw->sw_attr.num_ifs, sizeof(*ethsw->ports),
 			       GFP_KERNEL);
 	if (!(ethsw->ports)) {
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index 5f9211ccb1ef..448f60755eea 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -69,7 +69,6 @@ struct ethsw_core {
 	struct ethsw_port_priv		**ports;
 
 	u8				vlans[VLAN_VID_MASK + 1];
-	bool				learning;
 
 	struct notifier_block		port_nb;
 	struct notifier_block		port_switchdev_nb;
-- 
2.30.0

