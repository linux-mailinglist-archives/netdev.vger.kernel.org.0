Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0D820E095
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731722AbgF2Urh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:47:37 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:53787 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389807AbgF2Ure (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:47:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5330A5801D2;
        Mon, 29 Jun 2020 16:47:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Jun 2020 16:47:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=waj1V6HSOe49LPQPQhFaPhqwZH0hEPum+w73OVypVdE=; b=MDHxRwJw
        gW3rBmtSBpqGyKsMwJXEksDV9pkCcamFCum5KmQOO/KmQP0ThFAcNEibSI29nvjg
        qqhT4AbC0yotMuz3ZZhnEAntgFZwXb7mn9ZiWOWR9wLlHkGEYqX8pZ1Tns9107CO
        TtReYPdeudMEVtj/AUYFYFjkpxq9kkKa1YKPdPtUSBb8gD3dISlngrD20suUHfph
        0UNMjj0SvtvYK7Via7IdEgBsI1WwtSNMHLtCpUYlhqsRd2OTNeS/E/CeIRQIQzWl
        tg0XORV9tzPmmCLM+MLy/+/xEs3IbRfN7yCiOVjpqGlxM3ah1twefyx79wgNTdXT
        yezsWPuRp9WIFQ==
X-ME-Sender: <xms:ZVP6XqK5e8qcj8Qm8XC0_TXgg-fF2UjnyvQMDIQ9Tz3f6W5aNxo6hQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelledgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppedutdelrdeiiedrudelrddufeef
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ZVP6XiKyw0RG_BE8guU32w7LxJjvebBoE9ohCKE-rn-TBDTHp1qERw>
    <xmx:ZVP6Xqu8FcQuuD8P-KOuFVpTkFk8LbdklpG0-k8JlLjyjkxBjuKCjA>
    <xmx:ZVP6XvZiSoH3fgRC4M-HIjEyehZ1vliVH59H9aosAQ48fjrox8fXtg>
    <xmx:ZVP6XvMlKcqgCkjSQBXGMfRBgZfZVJzV3y4_TP8sOLAPg4lCmZaFtw>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 132F0328005A;
        Mon, 29 Jun 2020 16:47:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 05/10] ethtool: Add link extended state
Date:   Mon, 29 Jun 2020 23:46:16 +0300
Message-Id: <20200629204621.377239-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629204621.377239-1-idosch@idosch.org>
References: <20200629204621.377239-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Currently, drivers can only tell whether the link is up/down using
LINKSTATE_GET, but no additional information is given.

Add attributes to LINKSTATE_GET command in order to allow drivers
to expose the user more information in addition to link state to ease
the debug process, for example, reason for link down state.

Extended state consists of two attributes - link_ext_state and
link_ext_substate. The idea is to avoid 'vendor specific' states in order
to prevent drivers to use specific link_ext_state that can be in the future
common link_ext_state.

The substates allows drivers to add more information to the common
link_ext_state. For example, vendor can expose 'Autoneg' as link_ext_state
and add 'No partner detected during force mode' as link_ext_substate.

If a driver cannot pinpoint the extended state with the substate
accuracy, it is free to expose only the extended state and omit the
substate attribute.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/linux/ethtool.h              | 23 +++++++++
 include/uapi/linux/ethtool.h         | 70 ++++++++++++++++++++++++++++
 include/uapi/linux/ethtool_netlink.h |  2 +
 net/ethtool/linkstate.c              | 52 +++++++++++++++++++--
 4 files changed, 143 insertions(+), 4 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index a23b26eab479..48ad3b6a0150 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -86,6 +86,22 @@ struct net_device;
 u32 ethtool_op_get_link(struct net_device *dev);
 int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *eti);
 
+
+/**
+ * struct ethtool_link_ext_state_info - link extended state and substate.
+ */
+struct ethtool_link_ext_state_info {
+	enum ethtool_link_ext_state link_ext_state;
+	union {
+		enum ethtool_link_ext_substate_autoneg autoneg;
+		enum ethtool_link_ext_substate_link_training link_training;
+		enum ethtool_link_ext_substate_link_logical_mismatch link_logical_mismatch;
+		enum ethtool_link_ext_substate_bad_signal_integrity bad_signal_integrity;
+		enum ethtool_link_ext_substate_cable_issue cable_issue;
+		u8 __link_ext_substate;
+	};
+};
+
 /**
  * ethtool_rxfh_indir_default - get default value for RX flow hash indirection
  * @index: Index in RX flow hash indirection table
@@ -245,6 +261,11 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
  * @get_link: Report whether physical link is up.  Will only be called if
  *	the netdev is up.  Should usually be set to ethtool_op_get_link(),
  *	which uses netif_carrier_ok().
+ * @get_link_ext_state: Report link extended state. Should set link_ext_state and
+ *	link_ext_substate (link_ext_substate of 0 means link_ext_substate is unknown,
+ *	do not attach ext_substate attribute to netlink message). If link_ext_state
+ *	and link_ext_substate are unknown, return -ENODATA. If not implemented,
+ *	link_ext_state and link_ext_substate will not be sent to userspace.
  * @get_eeprom: Read data from the device EEPROM.
  *	Should fill in the magic field.  Don't need to check len for zero
  *	or wraparound.  Fill in the data argument with the eeprom values
@@ -384,6 +405,8 @@ struct ethtool_ops {
 	void	(*set_msglevel)(struct net_device *, u32);
 	int	(*nway_reset)(struct net_device *);
 	u32	(*get_link)(struct net_device *);
+	int	(*get_link_ext_state)(struct net_device *,
+				      struct ethtool_link_ext_state_info *);
 	int	(*get_eeprom_len)(struct net_device *);
 	int	(*get_eeprom)(struct net_device *,
 			      struct ethtool_eeprom *, u8 *);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index f4662b3a9e1e..d1413538ef30 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -579,6 +579,76 @@ struct ethtool_pauseparam {
 	__u32	tx_pause;
 };
 
+/**
+ * enum ethtool_link_ext_state - link extended state
+ */
+enum ethtool_link_ext_state {
+	ETHTOOL_LINK_EXT_STATE_AUTONEG,
+	ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+	ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+	ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY,
+	ETHTOOL_LINK_EXT_STATE_NO_CABLE,
+	ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+	ETHTOOL_LINK_EXT_STATE_EEPROM_ISSUE,
+	ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE,
+	ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED,
+	ETHTOOL_LINK_EXT_STATE_OVERHEAT,
+};
+
+/**
+ * enum ethtool_link_ext_substate_autoneg - more information in addition to
+ * ETHTOOL_LINK_EXT_STATE_AUTONEG.
+ */
+enum ethtool_link_ext_substate_autoneg {
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD,
+};
+
+/**
+ * enum ethtool_link_ext_substate_link_training - more information in addition to
+ * ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE.
+ */
+enum ethtool_link_ext_substate_link_training {
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT,
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY,
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT,
+};
+
+/**
+ * enum ethtool_link_ext_substate_logical_mismatch - more information in addition
+ * to ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH.
+ */
+enum ethtool_link_ext_substate_link_logical_mismatch {
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_AM_LOCK,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_GET_ALIGN_STATUS,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_FC_FEC_IS_NOT_LOCKED,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED,
+};
+
+/**
+ * enum ethtool_link_ext_substate_bad_signal_integrity - more information in
+ * addition to ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY.
+ */
+enum ethtool_link_ext_substate_bad_signal_integrity {
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
+};
+
+/**
+ * enum ethtool_link_ext_substate_cable_issue - more information in
+ * addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE.
+ */
+enum ethtool_link_ext_substate_cable_issue {
+	ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE,
+};
+
 #define ETH_GSTRING_LEN		32
 
 /**
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 4dda5e4244a7..c12ce4df4b6b 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -236,6 +236,8 @@ enum {
 	ETHTOOL_A_LINKSTATE_LINK,		/* u8 */
 	ETHTOOL_A_LINKSTATE_SQI,		/* u32 */
 	ETHTOOL_A_LINKSTATE_SQI_MAX,		/* u32 */
+	ETHTOOL_A_LINKSTATE_EXT_STATE,		/* u8 */
+	ETHTOOL_A_LINKSTATE_EXT_SUBSTATE,	/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKSTATE_CNT,
diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index afe5ac8a0f00..4834091ec24c 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -9,10 +9,12 @@ struct linkstate_req_info {
 };
 
 struct linkstate_reply_data {
-	struct ethnl_reply_data		base;
-	int				link;
-	int				sqi;
-	int				sqi_max;
+	struct ethnl_reply_data			base;
+	int					link;
+	int					sqi;
+	int					sqi_max;
+	bool					link_ext_state_provided;
+	struct ethtool_link_ext_state_info	ethtool_link_ext_state_info;
 };
 
 #define LINKSTATE_REPDATA(__reply_base) \
@@ -25,6 +27,8 @@ linkstate_get_policy[ETHTOOL_A_LINKSTATE_MAX + 1] = {
 	[ETHTOOL_A_LINKSTATE_LINK]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKSTATE_SQI]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_LINKSTATE_SQI_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKSTATE_EXT_STATE]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKSTATE_EXT_SUBSTATE]	= { .type = NLA_REJECT },
 };
 
 static int linkstate_get_sqi(struct net_device *dev)
@@ -61,6 +65,23 @@ static int linkstate_get_sqi_max(struct net_device *dev)
 	mutex_unlock(&phydev->lock);
 
 	return ret;
+};
+
+static int linkstate_get_link_ext_state(struct net_device *dev,
+					struct linkstate_reply_data *data)
+{
+	int err;
+
+	if (!dev->ethtool_ops->get_link_ext_state)
+		return -EOPNOTSUPP;
+
+	err = dev->ethtool_ops->get_link_ext_state(dev, &data->ethtool_link_ext_state_info);
+	if (err)
+		return err;
+
+	data->link_ext_state_provided = true;
+
+	return 0;
 }
 
 static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
@@ -86,6 +107,12 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
 		goto out;
 	data->sqi_max = ret;
 
+	if (dev->flags & IFF_UP) {
+		ret = linkstate_get_link_ext_state(dev, data);
+		if (ret < 0 && ret != -EOPNOTSUPP && ret != -ENODATA)
+			goto out;
+	}
+
 	ret = 0;
 out:
 	ethnl_ops_complete(dev);
@@ -107,6 +134,12 @@ static int linkstate_reply_size(const struct ethnl_req_info *req_base,
 	if (data->sqi_max != -EOPNOTSUPP)
 		len += nla_total_size(sizeof(u32));
 
+	if (data->link_ext_state_provided)
+		len += nla_total_size(sizeof(u8)); /* LINKSTATE_EXT_STATE */
+
+	if (data->ethtool_link_ext_state_info.__link_ext_substate)
+		len += nla_total_size(sizeof(u8)); /* LINKSTATE_EXT_SUBSTATE */
+
 	return len;
 }
 
@@ -128,6 +161,17 @@ static int linkstate_fill_reply(struct sk_buff *skb,
 	    nla_put_u32(skb, ETHTOOL_A_LINKSTATE_SQI_MAX, data->sqi_max))
 		return -EMSGSIZE;
 
+	if (data->link_ext_state_provided) {
+		if (nla_put_u8(skb, ETHTOOL_A_LINKSTATE_EXT_STATE,
+			       data->ethtool_link_ext_state_info.link_ext_state))
+			return -EMSGSIZE;
+
+		if (data->ethtool_link_ext_state_info.__link_ext_substate &&
+		    nla_put_u8(skb, ETHTOOL_A_LINKSTATE_EXT_SUBSTATE,
+			       data->ethtool_link_ext_state_info.__link_ext_substate))
+			return -EMSGSIZE;
+	}
+
 	return 0;
 }
 
-- 
2.26.2

