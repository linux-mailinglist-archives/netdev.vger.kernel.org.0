Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 591B6141DE6
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgASNB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:29 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49977 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726894AbgASNB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:27 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C7A0B21D2B;
        Sun, 19 Jan 2020 08:01:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=F8Mrxhn/Nl5UfX3CloXbvpHWcT+fqnJrXWFFeQsxPqk=; b=Kje69Nii
        SPv8pHXuZeSLUGL25L7OvnY9zX8wym9nSN+vnlM5gIqLRyhuwOZcoGIXDZB0neEP
        nqLUiBNZ4EceOk/vjCTp7xHacJnYTCcWLzLL/o7Bnwlp3YXEKxNAdL9yr/o5Y9G+
        /iLo7CcE8VkMwNVmpZv1+AW90UmGBKH37BCJY2bP9mx9N30Jsy+a8X4wJXL+QbeX
        I0u0ziJHmP5X9eR7F7C59VJHXh0uMwev6Jn4VEVEyo2OB3r0gK8HUnOs+3tm+tpP
        S8TpOxAr83Uk6ksX09EonipZAqgDhf7ElJLRIm/75WNKjBd+gU7sM/fcY6/fHn4R
        5UBh6eXi1mRwYg==
X-ME-Sender: <xms:JlMkXl9qoq0uYSzSCZe6x_ofZylfnI2VsD8VvSDcMZ2owJK0huTiiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:JlMkXtHObmTlRBkbUwmMaaQo5ZMygsgHBMk7ntyJ_h1OtLwroW2DWA>
    <xmx:JlMkXjd-wy7ZRtL2E8h2LH14RgBeD5l4Izrd19_YOSE6vXByal9Iww>
    <xmx:JlMkXiPgyAAJW7AtqJop7oq2SeyGdqNCST4xPxHJv_PHkdsEz2jRnQ>
    <xmx:JlMkXr7FOJ3xg4_-_WWlz7Wh6A1nXghKKIcqgGr4BR5P86IkNzNF0Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77D6E80062;
        Sun, 19 Jan 2020 08:01:25 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/15] mlxsw: Add irif and erif disabled traps
Date:   Sun, 19 Jan 2020 15:00:46 +0200
Message-Id: <20200119130100.3179857-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200119130100.3179857-1-idosch@idosch.org>
References: <20200119130100.3179857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

IRIF_DISABLED and ERIF_DISABLED are driver specific traps. Packets are
dropped for these reasons when they need to be routed through/from
existing router interfaces (RIF) which are disabled.

Add devlink driver-specific traps and mlxsw trap IDs used to report
these traps.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../networking/devlink/devlink-trap.rst       |  1 +
 Documentation/networking/devlink/mlxsw.rst    | 22 ++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 26 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |  2 ++
 4 files changed, 51 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index cbaa750de37d..68245ea387ad 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -234,6 +234,7 @@ links to the description of driver-specific traps registered by various device
 drivers:
 
   * :doc:`netdevsim`
+  * :doc:`mlxsw`
 
 Generic Packet Trap Groups
 ==========================
diff --git a/Documentation/networking/devlink/mlxsw.rst b/Documentation/networking/devlink/mlxsw.rst
index 5f9bb0a0616a..cf857cb4ba8f 100644
--- a/Documentation/networking/devlink/mlxsw.rst
+++ b/Documentation/networking/devlink/mlxsw.rst
@@ -57,3 +57,25 @@ The ``mlxsw`` driver reports the following versions
    * - ``fw.version``
      - running
      - Three digit firmware version
+
+Driver-specific Traps
+=====================
+
+.. list-table:: List of Driver-specific Traps Registered by ``mlxsw``
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``irif_disabled``
+     - ``drop``
+     - Traps packets that the device decided to drop because they need to be
+       routed from a disabled router interface (RIF). This can happen during
+       RIF dismantle, when the RIF is first disabled before being removed
+       completely
+   * - ``erif_disabled``
+     - ``drop``
+     - Traps packets that the device decided to drop because they need to be
+       routed through a disabled router interface (RIF). This can happen during
+       RIF dismantle, when the RIF is first disabled before being removed
+       completely
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index e0d7c49ffae0..42013fe11131 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -9,6 +9,20 @@
 #include "reg.h"
 #include "spectrum.h"
 
+/* All driver-specific traps must be documented in
+ * Documentation/networking/devlink/mlxsw.rst
+ */
+enum {
+	DEVLINK_MLXSW_TRAP_ID_BASE = DEVLINK_TRAP_GENERIC_ID_MAX,
+	DEVLINK_MLXSW_TRAP_ID_IRIF_DISABLED,
+	DEVLINK_MLXSW_TRAP_ID_ERIF_DISABLED,
+};
+
+#define DEVLINK_MLXSW_TRAP_NAME_IRIF_DISABLED \
+	"irif_disabled"
+#define DEVLINK_MLXSW_TRAP_NAME_ERIF_DISABLED \
+	"erif_disabled"
+
 #define MLXSW_SP_TRAP_METADATA DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT
 
 static void mlxsw_sp_rx_drop_listener(struct sk_buff *skb, u8 local_port,
@@ -21,6 +35,12 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
 			     MLXSW_SP_TRAP_METADATA)
 
+#define MLXSW_SP_TRAP_DRIVER_DROP(_id, _group_id)			      \
+	DEVLINK_TRAP_DRIVER(DROP, DROP, DEVLINK_MLXSW_TRAP_ID_##_id,	      \
+			    DEVLINK_MLXSW_TRAP_NAME_##_id,		      \
+			    DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			    MLXSW_SP_TRAP_METADATA)
+
 #define MLXSW_SP_TRAP_EXCEPTION(_id, _group_id)		      \
 	DEVLINK_TRAP_GENERIC(EXCEPTION, TRAP, _id,			      \
 			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
@@ -58,6 +78,8 @@ static struct devlink_trap mlxsw_sp_traps_arr[] = {
 	MLXSW_SP_TRAP_EXCEPTION(UNRESOLVED_NEIGH, L3_DROPS),
 	MLXSW_SP_TRAP_EXCEPTION(IPV4_LPM_UNICAST_MISS, L3_DROPS),
 	MLXSW_SP_TRAP_EXCEPTION(IPV6_LPM_UNICAST_MISS, L3_DROPS),
+	MLXSW_SP_TRAP_DRIVER_DROP(IRIF_DISABLED, L3_DROPS),
+	MLXSW_SP_TRAP_DRIVER_DROP(ERIF_DISABLED, L3_DROPS),
 };
 
 static struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
@@ -90,6 +112,8 @@ static struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
 			       TRAP_EXCEPTION_TO_CPU),
 	MLXSW_SP_RXL_EXCEPTION(DISCARD_ROUTER_LPM6, ROUTER_EXP,
 			       TRAP_EXCEPTION_TO_CPU),
+	MLXSW_SP_RXL_DISCARD(ROUTER_IRIF_EN, L3_DISCARDS),
+	MLXSW_SP_RXL_DISCARD(ROUTER_ERIF_EN, L3_DISCARDS),
 };
 
 /* Mapping between hardware trap and devlink trap. Multiple hardware traps can
@@ -123,6 +147,8 @@ static u16 mlxsw_sp_listener_devlink_map[] = {
 	DEVLINK_TRAP_GENERIC_ID_UNRESOLVED_NEIGH,
 	DEVLINK_TRAP_GENERIC_ID_IPV4_LPM_UNICAST_MISS,
 	DEVLINK_TRAP_GENERIC_ID_IPV6_LPM_UNICAST_MISS,
+	DEVLINK_MLXSW_TRAP_ID_IRIF_DISABLED,
+	DEVLINK_MLXSW_TRAP_ID_ERIF_DISABLED,
 };
 
 static int mlxsw_sp_rx_listener(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 3d2331be05d8..8573cc3a0010 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -88,6 +88,8 @@ enum {
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_IPV4_SIP_BC = 0x16A,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_IPV4_DIP_LOCAL_NET = 0x16B,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_DIP_LINK_LOCAL = 0x16C,
+	MLXSW_TRAP_ID_DISCARD_ROUTER_IRIF_EN = 0x178,
+	MLXSW_TRAP_ID_DISCARD_ROUTER_ERIF_EN = 0x179,
 	MLXSW_TRAP_ID_DISCARD_ROUTER_LPM4 = 0x17B,
 	MLXSW_TRAP_ID_DISCARD_ROUTER_LPM6 = 0x17C,
 	MLXSW_TRAP_ID_DISCARD_IPV6_MC_DIP_RESERVED_SCOPE = 0x1B0,
-- 
2.24.1

