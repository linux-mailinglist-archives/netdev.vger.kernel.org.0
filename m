Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EDC21A0AB
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgGINTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:19:44 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:43905 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726856AbgGINTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:19:18 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id D88A35804D0;
        Thu,  9 Jul 2020 09:19:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 09 Jul 2020 09:19:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Ipdx41fePWNROcwXnB5d9JWlEOEeWZnqKnIpboQGDY8=; b=FYU9oEhS
        B2hAdz104QGlrNsYtWOV1UglKJ6vcO5+bLhQMq4aRhCDuCSFFWWim3e9CkUUOI7a
        v+kjYzbgf46EItZX058kEJBzuNJ2xUftoa2RNE6IQM1EMUsW+vct4yShpUBIVL+X
        94jB3Qcw0x+EPYKD96M3oyUtu+qB018A8Ex8XC+ZOhyKxWkzJbFuOg5sRWuu/AgK
        RRhxlYtqgsZbMvXf3w3vClJ6No/2/if7XonJH7tPzIbUjL5zzaYWGwmivGq2emt3
        MmdPHP4i9Q36/9pYiahTVRy+syFjEbRwW6FjHsj7APzpaBsSm5J5n71IMlJqw+qS
        v+trvZblX4EgYA==
X-ME-Sender: <xms:VRkHXy8Iprey7n7Vic5LdyE94UjY2wzChghGTmlbsqlJB8ofONPotA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudelgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:VRkHXyvSVfIRv-Jei_QTBeatrzW89PSWPEYiK82KFwjP8kpIUgi6MA>
    <xmx:VRkHX4B2YUqnuYEWfG2Z3oxYbvNBh81l8CAFKFEKj7Csbk1PgS8a_Q>
    <xmx:VRkHX6fg2b5JDdhv1hIAb8KdoHt215uIjSN03hc0A7l5AY_0O5TpUg>
    <xmx:VRkHX4FK3WyLiCrGQ02sDBt-nMw4bdktiNKVHb4mEU2cJkzF6p_38Q>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1A3EF3280067;
        Thu,  9 Jul 2020 09:19:14 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 5/9] devlink: Add a new devlink port lanes attribute and pass to netlink
Date:   Thu,  9 Jul 2020 16:18:18 +0300
Message-Id: <20200709131822.542252-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709131822.542252-1-idosch@idosch.org>
References: <20200709131822.542252-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Add a new devlink port attribute that indicates the port's number of lanes.

Drivers are expected to set it via devlink_port_attrs_set(), before
registering the port.

The attribute is not passed to user space in case the number of lanes is
invalid (0).

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 1 +
 include/net/devlink.h                      | 2 ++
 include/uapi/linux/devlink.h               | 2 ++
 net/core/devlink.c                         | 4 ++++
 4 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index f44cb1a537f3..6cde196f6b70 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2134,6 +2134,7 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 	int err;
 
 	attrs.split = split;
+	attrs.lanes = lanes;
 	attrs.flavour = flavour;
 	attrs.phys.port_number = port_number;
 	attrs.phys.split_subport_number = split_port_subnumber;
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8f9db991192d..91a9f8770d08 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -68,10 +68,12 @@ struct devlink_port_pci_vf_attrs {
  * struct devlink_port_attrs - devlink port object
  * @flavour: flavour of the port
  * @split: indicates if this is split port
+ * @lanes: maximum number of lanes the port supports. 0 value is not passed to netlink.
  * @switch_id: if the port is part of switch, this is buffer with ID, otherwise this is NULL
  */
 struct devlink_port_attrs {
 	u8 split:1;
+	u32 lanes;
 	enum devlink_port_flavour flavour;
 	struct netdev_phys_item_id switch_id;
 	union {
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 87c83a82991b..f741ab8d9cf0 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -455,6 +455,8 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER,	/* string */
 
+	DEVLINK_ATTR_PORT_LANES,			/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 266936c38357..7f26d1054974 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -530,6 +530,10 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 
 	if (!devlink_port->attrs_set)
 		return 0;
+	if (attrs->lanes) {
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_LANES, attrs->lanes))
+			return -EMSGSIZE;
+	}
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
 		return -EMSGSIZE;
 	switch (devlink_port->attrs.flavour) {
-- 
2.26.2

