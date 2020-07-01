Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5578210DCD
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731555AbgGAOdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:33:40 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:45505 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730852AbgGAOdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:33:39 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id A0C0B5801C9;
        Wed,  1 Jul 2020 10:33:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 01 Jul 2020 10:33:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=CKB81sVn7LVGi7YGxvPZPTqi/QZ8f8g/H8KfzgWFx7Q=; b=obx9Kft9
        hH95zHE4yFa9pXbPLtIOvUj9fDgwueP4cKp7U593Nk0+ey8Du9k71ge6IaMUu7yI
        ZlCHKN0wDB72nqTen9KJNRvtvhKt2UKIYtWsvfQSyVCqx7OnMGhXI9uus5tQwaB2
        k20d2hWMDyOlXN0zc4g1GjWNt29VedQV+3EqjDFNk/NvP8mOv4iAdyhRfBPCcm/o
        QUzjda2KQiFKTEoKZOqYMaIl5vL3S92GbtqsL+ohM92qVyx1urVRmmc+uXBS3Lq6
        QCj77vvoUgM2z2aTFHSpz/igVNUEakhq62SB370BAlQwrhJKKHT3/BIZxA9I4Sdd
        uf9A8DD1kP1gxQ==
X-ME-Sender: <xms:wp78Xr3xOAd4-Mv_kPQiVpe55I_l1QxNtk_pVR_RgSuCNm5TDbUAVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtddvgdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepudelfedrgeejrdduieehrddvhedu
    necuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:wp78XqHXoERwnZ1NqqObtsaQ4VSyRvtC7wudC8Emfhif6kKm2SzDPw>
    <xmx:wp78Xr7NAhiDUio41008q-Brs-vT1lE782D9ZgZ2ovd5f3aEp3ximw>
    <xmx:wp78Xg26FXIH0vislDy3Ay2DVqNUZ-7kgG6G9oDqu6pHLPN7AgwJFQ>
    <xmx:wp78Xm92QALeV8sbDEn2qs-9F1Vum5VJcnpV80Mp30A5G3uim5A0Zw>
Received: from shredder.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A59F3280067;
        Wed,  1 Jul 2020 10:33:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 7/9] devlink: Add a new devlink port split ability attribute and pass to netlink
Date:   Wed,  1 Jul 2020 17:32:49 +0300
Message-Id: <20200701143251.456693-8-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701143251.456693-1-idosch@idosch.org>
References: <20200701143251.456693-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Add a new attribute that indicates the split ability of devlink port.

Drivers are expected to set it via devlink_port_attrs_set(), before
registering the port.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c       | 1 +
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c | 1 +
 include/net/devlink.h                            | 4 +++-
 include/uapi/linux/devlink.h                     | 1 +
 net/core/devlink.c                               | 3 +++
 5 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index f85f5d88d331..8b3791d73c99 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2135,6 +2135,7 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 
 	attrs.split = split;
 	attrs.lanes = lanes;
+	attrs.splittable = splittable;
 	attrs.flavour = flavour;
 	attrs.phys.port_number = port_number;
 	attrs.phys.split_subport_number = split_port_subnumber;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 71f4e624b3db..b6a10565309a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -367,6 +367,7 @@ int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 		return ret;
 
 	attrs.split = eth_port.is_split;
+	attrs.splittable = !attrs.split;
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = eth_port.label_port;
 	attrs.phys.split_subport_number = eth_port.label_subport;
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 91752b79bb29..59e4103e2a91 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -68,12 +68,14 @@ struct devlink_port_pci_vf_attrs {
  * struct devlink_port_attrs - devlink port object
  * @flavour: flavour of the port
  * @split: indicates if this is split port
+ * @splittable: indicates if the port can be split.
  * @lanes: maximum number of lanes the port supports.
  *	   0 value is not passed to netlink and valid number is a power of 2.
  * @switch_id: if the port is part of switch, this is buffer with ID, otherwise this is NULL
  */
 struct devlink_port_attrs {
-	u8 split:1;
+	u8 split:1,
+	   splittable:1;
 	u32 lanes;
 	enum devlink_port_flavour flavour;
 	struct netdev_phys_item_id switch_id;
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index f741ab8d9cf0..cfef4245ea5a 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -456,6 +456,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER,	/* string */
 
 	DEVLINK_ATTR_PORT_LANES,			/* u32 */
+	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7f26d1054974..94c797b74378 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -534,6 +534,8 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_LANES, attrs->lanes))
 			return -EMSGSIZE;
 	}
+	if (nla_put_u8(msg, DEVLINK_ATTR_PORT_SPLITTABLE, attrs->splittable))
+		return -EMSGSIZE;
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
 		return -EMSGSIZE;
 	switch (devlink_port->attrs.flavour) {
@@ -7547,6 +7549,7 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
 	ret = __devlink_port_attrs_set(devlink_port, attrs->flavour);
 	if (ret)
 		return;
+	WARN_ON(attrs->splittable && attrs->split);
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_set);
 
-- 
2.26.2

