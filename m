Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52319583EF
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfF0NyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:54:11 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48451 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727099AbfF0NyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:54:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 054D521BBE;
        Thu, 27 Jun 2019 09:54:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 27 Jun 2019 09:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=oAJnTMXUAda5dGth7XSF3T80Pr2xh5knXx610QNFOhs=; b=VlQNoXyP
        sIAtjTBo0LwZWn6VlbftD2d5U1aG2VGLyn0JkBhhnyk5xu4EH3LkGx2BYDqQ1eR4
        gCi7oe/nuj8K9qA+z/Ju0JZhzozRb5xfbOWAHf7OCnNnJ5GwN2+sboT+LrqqI8nE
        rhR/Dfjomsjmp4aY0s3BBhrp9iUvEILnqgElsnjPcO/vvEKxHT3SUWRQKrvA6twq
        yXDYKpwUxIMDgfBESH+gb6UHSCzf1MoaOYmtv0mTH0Jr/nPgYoqp2/sbrIhsuaCy
        hbIV0DZLZVbmLYggqhXyB7dh3wAn+pfxK/RM1QghMGH8SQENWY1E36EjEYd64m+u
        gYCYJCuU6Gjc5g==
X-ME-Sender: <xms:f8oUXbvgwTsKiRJjpqEJ9q0OEkRBUBgc_kxhTjrbRg7vFucqOsg7-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepudeg
X-ME-Proxy: <xmx:f8oUXVzeiyoUyzRArKSk9zYO03R77U2ZoIKCeHHz43kXQZ5aVcJiOg>
    <xmx:f8oUXdifofqj-YtIirjIn-LBTrWmV7xC35XogEkqGAWylwFlFAVDTg>
    <xmx:f8oUXVNvapUOWYMEvKucZmQpYivaGHzvXSMzFrH4W32zYJcvJmEYWQ>
    <xmx:f8oUXdTUTKq1uF9ZcIvvTXUWXORq_ESyVJVLWqh2CoRLlrdbzMo6Dg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1566080065;
        Thu, 27 Jun 2019 09:54:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 16/16] mlxsw: spectrum: PTP: Support ethtool get_ts_info
Date:   Thu, 27 Jun 2019 16:52:59 +0300
Message-Id: <20190627135259.7292-17-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627135259.7292-1-idosch@idosch.org>
References: <20190627135259.7292-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The get_ts_info callback is used for obtaining information about
timestamping capabilities of a network device. On Spectrum-1, implement
it to advertise the PHC and the capability to do HW timestamping, and
the supported RX and TX filters.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 14 +++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 18 +++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    | 23 +++++++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index f1df3c63af3e..9a76a0faaa95 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -171,6 +171,8 @@ struct mlxsw_sp_ptp_ops {
 			    struct hwtstamp_config *config);
 	int (*hwtstamp_set)(struct mlxsw_sp_port *mlxsw_sp_port,
 			    struct hwtstamp_config *config);
+	int (*get_ts_info)(struct mlxsw_sp *mlxsw_sp,
+			   struct ethtool_ts_info *info);
 };
 
 static int mlxsw_sp_component_query(struct mlxfw_dev *mlxfw_dev,
@@ -3316,6 +3318,15 @@ static int mlxsw_sp_get_module_eeprom(struct net_device *netdev,
 	return err;
 }
 
+static int
+mlxsw_sp_get_ts_info(struct net_device *netdev, struct ethtool_ts_info *info)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(netdev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+
+	return mlxsw_sp->ptp_ops->get_ts_info(mlxsw_sp, info);
+}
+
 static const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.get_drvinfo		= mlxsw_sp_port_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
@@ -3329,6 +3340,7 @@ static const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.set_link_ksettings	= mlxsw_sp_port_set_link_ksettings,
 	.get_module_info	= mlxsw_sp_get_module_info,
 	.get_module_eeprom	= mlxsw_sp_get_module_eeprom,
+	.get_ts_info		= mlxsw_sp_get_ts_info,
 };
 
 static int
@@ -4547,6 +4559,7 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp1_ptp_ops = {
 	.transmitted	= mlxsw_sp1_ptp_transmitted,
 	.hwtstamp_get	= mlxsw_sp1_ptp_hwtstamp_get,
 	.hwtstamp_set	= mlxsw_sp1_ptp_hwtstamp_set,
+	.get_ts_info	= mlxsw_sp1_ptp_get_ts_info,
 };
 
 static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
@@ -4558,6 +4571,7 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
 	.transmitted	= mlxsw_sp2_ptp_transmitted,
 	.hwtstamp_get	= mlxsw_sp2_ptp_hwtstamp_get,
 	.hwtstamp_set	= mlxsw_sp2_ptp_hwtstamp_set,
+	.get_ts_info	= mlxsw_sp2_ptp_get_ts_info,
 };
 
 static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index e8df674cd514..c83cc4df5ea8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -933,3 +933,21 @@ int mlxsw_sp1_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	return 0;
 }
+
+int mlxsw_sp1_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
+			      struct ethtool_ts_info *info)
+{
+	info->phc_index = ptp_clock_index(mlxsw_sp->clock->ptp);
+
+	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	info->tx_types = BIT(HWTSTAMP_TX_OFF) |
+			 BIT(HWTSTAMP_TX_ON);
+
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			   BIT(HWTSTAMP_FILTER_ALL);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index 14505bcceeb7..c9e6d9c9a058 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -18,6 +18,14 @@ enum {
 	MLXSW_PTP_MESSAGE_TYPE_PDELAY_RESP,
 };
 
+static inline int mlxsw_sp_ptp_get_ts_info_noptp(struct ethtool_ts_info *info)
+{
+	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE;
+	info->phc_index = -1;
+	return 0;
+}
+
 #if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
 
 struct mlxsw_sp_ptp_clock *
@@ -46,6 +54,9 @@ int mlxsw_sp1_ptp_hwtstamp_get(struct mlxsw_sp_port *mlxsw_sp_port,
 int mlxsw_sp1_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			       struct hwtstamp_config *config);
 
+int mlxsw_sp1_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
+			      struct ethtool_ts_info *info);
+
 #else
 
 static inline struct mlxsw_sp_ptp_clock *
@@ -102,6 +113,12 @@ mlxsw_sp1_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return -EOPNOTSUPP;
 }
 
+static inline int mlxsw_sp1_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
+					    struct ethtool_ts_info *info)
+{
+	return mlxsw_sp_ptp_get_ts_info_noptp(info);
+}
+
 #endif
 
 static inline struct mlxsw_sp_ptp_clock *
@@ -150,4 +167,10 @@ mlxsw_sp2_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return -EOPNOTSUPP;
 }
 
+static inline int mlxsw_sp2_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
+					    struct ethtool_ts_info *info)
+{
+	return mlxsw_sp_ptp_get_ts_info_noptp(info);
+}
+
 #endif
-- 
2.20.1

