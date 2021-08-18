Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258613F087F
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240260AbhHRPxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:53:53 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:45599 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240251AbhHRPxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:53:32 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 205F4582FDE;
        Wed, 18 Aug 2021 11:52:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 18 Aug 2021 11:52:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=uaWVRiEJDoCfsGTA2texSthENKExvF9bu5gTpN+dcBc=; b=EfUE9ilX
        JQT/4B2FvveyFZTkdWe9gtpRg2QUACAvui3ZmKLN9NxFoYYeL95P3UrcZgJkU5yr
        cfI/skfl2slUPyYeTBLjPpOvydJaUy4e+X4LzOefeKE+aTqOWjZc2EgmYZVRtvJs
        80J94VO9v5KvGVqWLlJLKfKQCuXUQAO0vUxgiPsYO/OQWjHqlDTqOhyaEANn+Tp1
        QLWVluL3FVAExIPeOp4p+vcqdbv4ngribXoZkxeDvoOEJGoP77OmOXJLrvkAuws/
        UF+QzZfMFzZipOcAoajxBl+MpymPndKvuN82h9HoL+fH5/1H+rGeLZRMza5WJ1uT
        RFPCngx23SGdpQ==
X-ME-Sender: <xms:2SwdYS2wHXY_27pQKSpFhca9urkEdE5ne2rszQ0Oy_PPCie__43nXw>
    <xme:2SwdYVGNXq4Igmarr6_HcmmFQVsMmI4cOtEO5Z_8zZukbFg9ZBlcTCPIiBDx2SjLM
    60V8J6w_JjLiW0>
X-ME-Received: <xmr:2SwdYa5JRa3KisF1i-r3LJeerJd6Wr5PhuoF-HLP-Kbe1dgiNB5fcjTMTCJJdEu4-cjBKZPbSh7DmqS-qxBphtkr7rGe3bz_1xYgRKT3WUdiLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleehgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedvnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2SwdYT0f_htBQA-lFusXFNxZglvgVE4mIZ1wyhOckLuPE1D-lwJVcQ>
    <xmx:2SwdYVHfwynIcTbV-hgoCrASrGd8wKhUvTIB9JwQX63MvdVAmdjYRg>
    <xmx:2SwdYc93m2CPBjPQItIVH07RfKv7R8pqvi6hMzjLkkmT1kdtR5ADnw>
    <xmx:2SwdYbb5sWPqOweIax31Ec3YLSTR4lDX4-hC3vw4HsPZRZhXhI-xwQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Aug 2021 11:52:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v2 6/6] mlxsw: Add support for transceiver module extended states
Date:   Wed, 18 Aug 2021 18:52:02 +0300
Message-Id: <20210818155202.1278177-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818155202.1278177-1-idosch@idosch.org>
References: <20210818155202.1278177-1-idosch@idosch.org>
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

