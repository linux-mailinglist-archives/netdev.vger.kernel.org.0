Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5677A20E097
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389578AbgF2Urm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:47:42 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:39405 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388219AbgF2Url (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:47:41 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4DDA35800BF;
        Mon, 29 Jun 2020 16:47:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Jun 2020 16:47:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=G6Pf0WxnFk+WoJumYzsQOLJ9/kvJfVokDUIu2L+83w4=; b=bFsQ7TLf
        JbbWTUYNVkI+04X0l3aGAMpl7cjsADC9ThG1xzr9mAhCbBBMSJThRn27ZQCoC1Z4
        yG/A/U1DyTg5uc2Z20keqGBatRvFoLLJRygKBOo71DCIQh5/ZQc6I3oCwa6Yss0P
        7Q0rP3yEkpqyOjAfuszvcxvYSBPJLMqLCK28mGC3d6GDtPZw4W/VTLMf8hpzWOFM
        LJNw1EWbeiwO6o9yxp6WjDSlD54dFOLguMwC0ywXIePQiXNPlPR21ua6Sja4uTBx
        iK+tljnMoqqZU1yp0a6jxMD6QJINAtlH8rrrgfxL8a5jNNgI7nQi6K1B31LY23Hq
        kr1LstgmWrHGfA==
X-ME-Sender: <xms:a1P6XmjsJQ9vfFI6_WIArSS9oyB8hMQ3o-H_R_a9YkJKFv0-d5o4NA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelledgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppedutdelrdeiiedrudelrddufeef
    necuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:a1P6XnA0Ye0yZuc8xQS1uqqiD3di5iLGig-U_t29Oq5D3cz3O8XEiw>
    <xmx:a1P6XuFLINZLoYvmgpPYPZsHmzbB5qtyr7q0JyzaA2bkqSLBkRA1UQ>
    <xmx:a1P6XvTgO4aCfVXOhdJli0_Z2HE_lqgn6yVA5BObb7gFfBFpw7m1Ww>
    <xmx:a1P6XqnubZh7pn3R_drYK2aA3wNeGjlbYXgWydUqlWLOqQX6brkRRQ>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 74696328005A;
        Mon, 29 Jun 2020 16:47:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 07/10] mlxsw: spectrum_ethtool: Add link extended state
Date:   Mon, 29 Jun 2020 23:46:18 +0300
Message-Id: <20200629204621.377239-8-idosch@idosch.org>
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

Implement .get_down_ext_state() as part of ethtool_ops.
Query link down reason from PDDR register and convert it to ethtool
link_ext_state.

In case that more information than common link_ext_state is provided,
fill link_ext_substate also with the appropriate value.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/spectrum_ethtool.c         | 145 ++++++++++++++++++
 1 file changed, 145 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 04e1db604c69..14c78f73bb65 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -26,6 +26,150 @@ static void mlxsw_sp_port_get_drvinfo(struct net_device *dev,
 		sizeof(drvinfo->bus_info));
 }
 
+struct mlxsw_sp_ethtool_link_ext_state_opcode_mapping {
+	u32 status_opcode;
+	enum ethtool_link_ext_state link_ext_state;
+	u8 link_ext_substate;
+};
+
+static const struct mlxsw_sp_ethtool_link_ext_state_opcode_mapping
+mlxsw_sp_link_ext_state_opcode_map[] = {
+	{2, ETHTOOL_LINK_EXT_STATE_AUTONEG,
+		ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED},
+	{3, ETHTOOL_LINK_EXT_STATE_AUTONEG,
+		ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED},
+	{4, ETHTOOL_LINK_EXT_STATE_AUTONEG,
+		ETHTOOL_LINK_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED},
+	{36, ETHTOOL_LINK_EXT_STATE_AUTONEG,
+		ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE},
+	{38, ETHTOOL_LINK_EXT_STATE_AUTONEG,
+		ETHTOOL_LINK_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE},
+	{39, ETHTOOL_LINK_EXT_STATE_AUTONEG,
+		ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD},
+
+	{5, ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+		ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED},
+	{6, ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+		ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT},
+	{7, ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+		ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY},
+	{8, ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE, 0},
+	{14, ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+		ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT},
+
+	{9, ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK},
+	{10, ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_AM_LOCK},
+	{11, ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_GET_ALIGN_STATUS},
+	{12, ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_LINK_EXT_SUBSTATE_LLM_FC_FEC_IS_NOT_LOCKED},
+	{13, ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED},
+
+	{15, ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY, 0},
+	{17, ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY,
+		ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS},
+	{42, ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY,
+		ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE},
+
+	{1024, ETHTOOL_LINK_EXT_STATE_NO_CABLE, 0},
+
+	{16, ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE},
+	{20, ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE},
+	{29, ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE},
+	{1025, ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE},
+	{1029, ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE},
+	{1031, ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE, 0},
+
+	{1027, ETHTOOL_LINK_EXT_STATE_EEPROM_ISSUE, 0},
+
+	{23, ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE, 0},
+
+	{1032, ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED, 0},
+
+	{1030, ETHTOOL_LINK_EXT_STATE_OVERHEAT, 0},
+};
+
+static void
+mlxsw_sp_port_set_link_ext_state(struct mlxsw_sp_ethtool_link_ext_state_opcode_mapping
+				 link_ext_state_mapping,
+				 struct ethtool_link_ext_state_info *link_ext_state_info)
+{
+	switch (link_ext_state_mapping.link_ext_state) {
+	case ETHTOOL_LINK_EXT_STATE_AUTONEG:
+		link_ext_state_info->autoneg =
+			link_ext_state_mapping.link_ext_substate;
+		break;
+	case ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE:
+		link_ext_state_info->link_training =
+			link_ext_state_mapping.link_ext_substate;
+		break;
+	case ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH:
+		link_ext_state_info->link_logical_mismatch =
+			link_ext_state_mapping.link_ext_substate;
+		break;
+	case ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY:
+		link_ext_state_info->bad_signal_integrity =
+			link_ext_state_mapping.link_ext_substate;
+		break;
+	case ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE:
+		link_ext_state_info->cable_issue =
+			link_ext_state_mapping.link_ext_substate;
+		break;
+	default:
+		break;
+	}
+
+	link_ext_state_info->link_ext_state = link_ext_state_mapping.link_ext_state;
+}
+
+static int
+mlxsw_sp_port_get_link_ext_state(struct net_device *dev,
+				 struct ethtool_link_ext_state_info *link_ext_state_info)
+{
+	struct mlxsw_sp_ethtool_link_ext_state_opcode_mapping link_ext_state_mapping;
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	char pddr_pl[MLXSW_REG_PDDR_LEN];
+	int opcode, err, i;
+	u32 status_opcode;
+
+	if (netif_carrier_ok(dev))
+		return -ENODATA;
+
+	mlxsw_reg_pddr_pack(pddr_pl, mlxsw_sp_port->local_port,
+			    MLXSW_REG_PDDR_PAGE_SELECT_TROUBLESHOOTING_INFO);
+
+	opcode = MLXSW_REG_PDDR_TRBLSH_GROUP_OPCODE_MONITOR;
+	mlxsw_reg_pddr_trblsh_group_opcode_set(pddr_pl, opcode);
+
+	err = mlxsw_reg_query(mlxsw_sp_port->mlxsw_sp->core, MLXSW_REG(pddr),
+			      pddr_pl);
+	if (err)
+		return err;
+
+	status_opcode = mlxsw_reg_pddr_trblsh_status_opcode_get(pddr_pl);
+	if (!status_opcode)
+		return -ENODATA;
+
+	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_link_ext_state_opcode_map); i++) {
+		link_ext_state_mapping = mlxsw_sp_link_ext_state_opcode_map[i];
+		if (link_ext_state_mapping.status_opcode == status_opcode) {
+			mlxsw_sp_port_set_link_ext_state(link_ext_state_mapping,
+							 link_ext_state_info);
+			return 0;
+		}
+	}
+
+	return -ENODATA;
+}
+
 static void mlxsw_sp_port_get_pauseparam(struct net_device *dev,
 					 struct ethtool_pauseparam *pause)
 {
@@ -827,6 +971,7 @@ mlxsw_sp_get_ts_info(struct net_device *netdev, struct ethtool_ts_info *info)
 const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.get_drvinfo		= mlxsw_sp_port_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
+	.get_link_ext_state	= mlxsw_sp_port_get_link_ext_state,
 	.get_pauseparam		= mlxsw_sp_port_get_pauseparam,
 	.set_pauseparam		= mlxsw_sp_port_set_pauseparam,
 	.get_strings		= mlxsw_sp_port_get_strings,
-- 
2.26.2

