Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680DD141DEA
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgASNBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:39 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49213 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727465AbgASNBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:38 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8F7CF210ED;
        Sun, 19 Jan 2020 08:01:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=wD5EZuvA6Mrs8UDfRFh4HgqGKKHt4T+BEobNY1WVWAw=; b=xvb5CkNO
        Iqtp7H4Lka9VZTPKJW2UoDUvzUDMcV6Nm8ZuIj9eq7ef4OT0UneVJ/01nlu+ZsDX
        BhMjIDFX2km9Sr1eYuc7+AgtQRjAA0cMxTvRNFwcQwxhP7j3ustvtce/ZgzB4YS3
        OU/UUQlJkxAH6xjK++T74ASiknHV3/IPI40jRuzxg6rD1p7laOXsOonSxQD8+8Q7
        ufqjUj2I9sjcSWbWLelPiXu8tx9u+w1jrgXuDz2Gd9Pr1C0kdhbA9ryzx+cKIE4G
        07IDfCZWxu0vuW3JGjrLEcTdfpReIyYHFkanE+9L/uyBWvOsXrVp6gTTGW273/0f
        oDLN9dj1joJChQ==
X-ME-Sender: <xms:MVMkXgsS0yRoXuL79GGRZpYS4S_GhMz5RTVqLrhLkulB17QTzCLbbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgephe
X-ME-Proxy: <xmx:MVMkXj6ToIuptv663totGNX2Z4LaJQsnEWhUB5eOb4L31JwADrGIvQ>
    <xmx:MVMkXkmc_wZpNuMRpiFXM739o_V1ewcEQ7App0tgErg67g1bn1USKQ>
    <xmx:MVMkXicVO3MEFvmTSgku22Mts3lbV8qlR8UbESIqVgZ0LgqS8tZ60w>
    <xmx:MVMkXpMIAZI-3oaD83yz8nsHJbvuSfs0sQiw09SfkmvqZ1T-ZDIhJg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 41ED580061;
        Sun, 19 Jan 2020 08:01:36 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/15] devlink: Add tunnel generic packet traps
Date:   Sun, 19 Jan 2020 15:00:54 +0200
Message-Id: <20200119130100.3179857-10-idosch@idosch.org>
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

Add packet traps that can report packets that were dropped during tunnel
decapsulation.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 Documentation/networking/devlink/devlink-trap.rst | 8 ++++++++
 include/net/devlink.h                             | 6 ++++++
 net/core/devlink.c                                | 2 ++
 3 files changed, 16 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index a62e1d6eb3e4..014f0a34c0e4 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -229,6 +229,11 @@ be added to the following table:
        supposed to be routed. For example, IGMP queries can be flooded by the
        device in layer 2 and reach the router. Such packets should not be
        routed and instead dropped
+   * - ``decap_error``
+     - ``exception``
+     - Traps NVE and IPinIP packets that the device decided to drop because of
+       failure during decapsulation (e.g., packet being too short, reserved
+       bits set in VXLAN header)
 
 Driver-specific Packet Traps
 ============================
@@ -265,6 +270,9 @@ narrow. The description of these groups must be added to the following table:
    * - ``buffer_drops``
      - Contains packet traps for packets that were dropped by the device due to
        an enqueue decision
+   * - ``tunnel_drops``
+     - Contains packet traps for packets that were dropped by the device during
+       tunnel encapsulation / decapsulation
 
 Testing
 =======
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 08b757753e1c..455282a4b714 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -592,6 +592,7 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_IPV4_LPM_UNICAST_MISS,
 	DEVLINK_TRAP_GENERIC_ID_IPV6_LPM_UNICAST_MISS,
 	DEVLINK_TRAP_GENERIC_ID_NON_ROUTABLE,
+	DEVLINK_TRAP_GENERIC_ID_DECAP_ERROR,
 
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -605,6 +606,7 @@ enum devlink_trap_group_generic_id {
 	DEVLINK_TRAP_GROUP_GENERIC_ID_L2_DROPS,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_L3_DROPS,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_BUFFER_DROPS,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_TUNNEL_DROPS,
 
 	/* Add new generic trap group IDs above */
 	__DEVLINK_TRAP_GROUP_GENERIC_ID_MAX,
@@ -662,6 +664,8 @@ enum devlink_trap_group_generic_id {
 	"ipv6_lpm_miss"
 #define DEVLINK_TRAP_GENERIC_NAME_NON_ROUTABLE \
 	"non_routable_packet"
+#define DEVLINK_TRAP_GENERIC_NAME_DECAP_ERROR \
+	"decap_error"
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
@@ -669,6 +673,8 @@ enum devlink_trap_group_generic_id {
 	"l3_drops"
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_BUFFER_DROPS \
 	"buffer_drops"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_TUNNEL_DROPS \
+	"tunnel_drops"
 
 #define DEVLINK_TRAP_GENERIC(_type, _init_action, _id, _group, _metadata_cap) \
 	{								      \
diff --git a/net/core/devlink.c b/net/core/devlink.c
index c10e38d724bc..af85fcd9b01e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7707,6 +7707,7 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(IPV4_LPM_UNICAST_MISS, EXCEPTION),
 	DEVLINK_TRAP(IPV6_LPM_UNICAST_MISS, EXCEPTION),
 	DEVLINK_TRAP(NON_ROUTABLE, DROP),
+	DEVLINK_TRAP(DECAP_ERROR, EXCEPTION),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
@@ -7719,6 +7720,7 @@ static const struct devlink_trap_group devlink_trap_group_generic[] = {
 	DEVLINK_TRAP_GROUP(L2_DROPS),
 	DEVLINK_TRAP_GROUP(L3_DROPS),
 	DEVLINK_TRAP_GROUP(BUFFER_DROPS),
+	DEVLINK_TRAP_GROUP(TUNNEL_DROPS),
 };
 
 static int devlink_trap_generic_verify(const struct devlink_trap *trap)
-- 
2.24.1

