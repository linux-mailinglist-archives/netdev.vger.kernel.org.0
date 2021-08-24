Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095083F5EA1
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbhHXNFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:05:40 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:36499 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237478AbhHXNFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 09:05:39 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id BF1B0580B13;
        Tue, 24 Aug 2021 09:04:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 24 Aug 2021 09:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=uaWVRiEJDoCfsGTA2texSthENKExvF9bu5gTpN+dcBc=; b=XzXxTvEl
        wy+kY32F19ues24y8Jt5r88ay7D19gJDqou3xn0+KGPQntn0xFPBRfNKSJn+MNJC
        oXbT/pS2keXkxgymeW8eUUUpdEwOawyPa1eNK0aNHlYrwWtSSWCLgOcWOI7/I3oe
        Oz1X5mQeXxoXpF4gQYiwB0p00qDYBuYwEXD/PNs15loken1ugw3f63S0caNiF2rN
        tRyFBVtK9+oJWzazZjPZoH158q6uE1+DbydXnaV5gE5H2zT1AVq2OXurZWg+RduT
        zOlQad8SGcIo6hUsycNlkausHJC7/uDdsTj0qr6i1Wz/du2tXgT74lLXtlDziPKl
        pkOxKHZu+wsbcA==
X-ME-Sender: <xms:dO4kYVcVOARSTd4to8tvWhnraL704klyK7UboDz9XDFcIAvfWvWbAg>
    <xme:dO4kYTNcN5XjBnaFeAQYy5OJGKkrxwrD2EWnEZD98KA-Kt4DyiA8X2syxDO7wX35l
    5vcstvsVYuHRV8>
X-ME-Received: <xmr:dO4kYehrzHVMXmoN_IYv1XabJSYRtmv_lzHmv7wwAgle_8TtQHHTKMFnynTlo1t6RS3dGahH3sxfOZkEGucR_vaAl-QQLlGkDtT2GmoR73vwxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtjedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:dO4kYe_Nv7-SS3q1EwBc1YS0iO4glwMHwpg-KNx1F8JFDrNh2cCrog>
    <xmx:dO4kYRstR07mWWyIZVnGxDLNJ7F9jf5Bht_cErIAiseTSfJi1lwdtw>
    <xmx:dO4kYdESn8ac-02fJgnJDRn3YoNSQvtXIt0qrYmRUbKURPlr6-pxhQ>
    <xmx:du4kYXAejp6A3yQ6pvO-FAcWpQpvCVNRNMEwEjolGg-V-iOBFcweHw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Aug 2021 09:04:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v3 6/6] mlxsw: Add support for transceiver module extended states
Date:   Tue, 24 Aug 2021 16:03:44 +0300
Message-Id: <20210824130344.1828076-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210824130344.1828076-1-idosch@idosch.org>
References: <20210824130344.1828076-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add support for the two transceiver module extended sub-states added in
previous patch. The two extended sub-states are meant to describe link
issues related to transceiver modules.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_ethtool.c         | 45 ++++++++++++++++++-
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 7329bc84a8ee..337fa0053de9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -96,6 +96,11 @@ mlxsw_sp_link_ext_state_opcode_map[] = {
 	{1032, ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED, 0},
 
 	{1030, ETHTOOL_LINK_EXT_STATE_OVERHEAT, 0},
+
+	{1042, ETHTOOL_LINK_EXT_STATE_MODULE,
+	 ETHTOOL_LINK_EXT_SUBSTATE_MODULE_CMIS_NOT_READY},
+	{2048, ETHTOOL_LINK_EXT_STATE_MODULE,
+	 ETHTOOL_LINK_EXT_SUBSTATE_MODULE_LOW_POWER_MODE},
 };
 
 static void
@@ -124,6 +129,10 @@ mlxsw_sp_port_set_link_ext_state(struct mlxsw_sp_ethtool_link_ext_state_opcode_m
 		link_ext_state_info->cable_issue =
 			link_ext_state_mapping.link_ext_substate;
 		break;
+	case ETHTOOL_LINK_EXT_STATE_MODULE:
+		link_ext_state_info->module =
+			link_ext_state_mapping.link_ext_substate;
+		break;
 	default:
 		break;
 	}
@@ -131,19 +140,46 @@ mlxsw_sp_port_set_link_ext_state(struct mlxsw_sp_ethtool_link_ext_state_opcode_m
 	link_ext_state_info->link_ext_state = link_ext_state_mapping.link_ext_state;
 }
 
+static int
+mlxsw_sp_port_status_opcode_drv_get(struct mlxsw_sp_port *mlxsw_sp_port,
+				    u32 *p_status_opcode)
+{
+	struct ethtool_module_power_mode_params params = {};
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 module = mlxsw_sp_port->mapping.module;
+	int err;
+
+	*p_status_opcode = 0;
+
+	err = mlxsw_env_get_module_power_mode(mlxsw_sp->core, module, &params,
+					      NULL);
+	if (err)
+		return err;
+	if (params.mode_valid && params.mode == ETHTOOL_MODULE_POWER_MODE_LOW)
+		*p_status_opcode = 2048;
+
+	return 0;
+}
+
 static int
 mlxsw_sp_port_get_link_ext_state(struct net_device *dev,
 				 struct ethtool_link_ext_state_info *link_ext_state_info)
 {
 	struct mlxsw_sp_ethtool_link_ext_state_opcode_mapping link_ext_state_mapping;
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	u32 status_opcode, status_opcode_drv;
 	char pddr_pl[MLXSW_REG_PDDR_LEN];
 	int opcode, err, i;
-	u32 status_opcode;
 
 	if (netif_carrier_ok(dev))
 		return -ENODATA;
 
+	/* Opcodes 2048-3072 are reserved for driver use. */
+	err = mlxsw_sp_port_status_opcode_drv_get(mlxsw_sp_port,
+						  &status_opcode_drv);
+	if (err)
+		return err;
+
 	mlxsw_reg_pddr_pack(pddr_pl, mlxsw_sp_port->local_port,
 			    MLXSW_REG_PDDR_PAGE_SELECT_TROUBLESHOOTING_INFO);
 
@@ -156,9 +192,14 @@ mlxsw_sp_port_get_link_ext_state(struct net_device *dev,
 		return err;
 
 	status_opcode = mlxsw_reg_pddr_trblsh_status_opcode_get(pddr_pl);
-	if (!status_opcode)
+	if (!status_opcode && !status_opcode_drv)
 		return -ENODATA;
 
+	/* Allow driver-detected issues to take precedence, as it is likely
+	 * that they are more meaningful to user space.
+	 */
+	status_opcode = status_opcode_drv ? status_opcode_drv : status_opcode;
+
 	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_link_ext_state_opcode_map); i++) {
 		link_ext_state_mapping = mlxsw_sp_link_ext_state_opcode_map[i];
 		if (link_ext_state_mapping.status_opcode == status_opcode) {
-- 
2.31.1

