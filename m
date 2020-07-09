Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320F321A0AF
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgGINTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:19:55 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:48727 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726896AbgGINTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:19:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6784D5804CA;
        Thu,  9 Jul 2020 09:19:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 09 Jul 2020 09:19:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=4L4e8Q5GXyLHFUTbyKr0FQyRvuc7ta5hBEbLM/8T5+A=; b=DWprg8x0
        8MzmYnMUcgnS9DsVVZIU3Xjzo/3u6+Or4ctZp0+5Uia2uaC9j5uZ05DUGnQhTyGn
        jIN35NGxXB3UJppXAkpGh9Gy5yVM/jFAdXcYs5IjkYcU5miTJ3cYHr91vhiZ39wu
        VYXg0SGnnYGoz73ROgRRaz++o4bpxXr8r49IhCGo2b4r905nJ8wntI+I5FmTJZya
        VkOUiKd/90zxep/wQPGOYQJXjLJXJq5lBM3jBEvFpKbrkvKpK13PPYT1NF6wMHOM
        COMnXXjfi4K/vWHwxjLM3A7v6ohNa7IBpp73xnL7NeZdAFNB7uUPA0yOB0EGWqj+
        J5kxmXrPdwyYZQ==
X-ME-Sender: <xms:XBkHX6eSu8BQTYhZLBmjermGP9npGzaR_umgTKsi99vrZdFfNK4naw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudelgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:XBkHX0OXieFqPpDG6O6rJr28S6Wy66w0DlfEuGntjUyo1BFruZmvmQ>
    <xmx:XBkHX7jxnygKYw3BD38CIBE39DRT3T3LFNt1LKK_wVwqs9UGpZCGUA>
    <xmx:XBkHX3-nyKn0hP4B5SKrnb5YwW71P4qY-qwsGYY_b9yXIJV6jesAEg>
    <xmx:XBkHX3lyUBxcWQ33nGVh4U7yB8clDXL9Mb6Ccc2hufV01c-nB4K9BQ>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id EEADB3280066;
        Thu,  9 Jul 2020 09:19:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 7/9] devlink: Add a new devlink port split ability attribute and pass to netlink
Date:   Thu,  9 Jul 2020 16:18:20 +0300
Message-Id: <20200709131822.542252-8-idosch@idosch.org>
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
index 91a9f8770d08..746bed538664 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -68,11 +68,13 @@ struct devlink_port_pci_vf_attrs {
  * struct devlink_port_attrs - devlink port object
  * @flavour: flavour of the port
  * @split: indicates if this is split port
+ * @splittable: indicates if the port can be split.
  * @lanes: maximum number of lanes the port supports. 0 value is not passed to netlink.
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

