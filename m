Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBE5141DEF
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgASNBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:45 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39511 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728655AbgASNBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:43 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E09BA21E44;
        Sun, 19 Jan 2020 08:01:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=T2L17+cBZ9CAMA/G0R6PEEzcnfiSHpLcVVj1TBBIkfQ=; b=P1+dGQIq
        p6gGAA9typAamKaeWINpIo++LeuZrt8v5aJyFO3PY2d//VKigGPiv85HJcBQqKsj
        ILhevtSIICpOnpM7b09u0qjMk6M+3JcWJ2X4LvsOJFSabf0SHuGswYdraENR31k0
        5PEyKE3J81iiG0DZygtdz4NQ6T8jJTGRmX5h/3VyoNcriSqzhjAh2H5jUkE0096u
        jbOlCxCyMpcgLJH3oKvgYRaBnG9p4m1R16+cvdfwrO24mtPBhY2MvRleAKsGyB3u
        5LdTaSdLu9RpBxqiugt+s7S/yTkuXOJAvYUI4WGZ0lTchqOwOO/3i+6RWoECb4c4
        gw955yciieo3dQ==
X-ME-Sender: <xms:NlMkXt8_x5U0tOShOyJBcKz4ywmWCpPlhZ2Qxflx8uZ4edxf5-4HPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepuddt
X-ME-Proxy: <xmx:NlMkXh6oIcrhP6YjhoVqSdrnLHIlUfNiu-p-s-fpWNNfjuQew2QMcQ>
    <xmx:NlMkXtrt6qAQ0GJ-tpEOvsT2t8Mw1NOnUIhWMi_GcHjFTCELSAAFFg>
    <xmx:NlMkXtAYMT2-Mrjg7C7IRD0gPmSD1_ezqwo4dqxFXT2NCyPmXzjX-A>
    <xmx:NlMkXimhBS78MciEbIFqMbRBiKUXOdxqf19EgCIakEhzoc9wcjUCHQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9925480060;
        Sun, 19 Jan 2020 08:01:41 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 13/15] devlink: Add overlay source MAC is multicast trap
Date:   Sun, 19 Jan 2020 15:00:58 +0200
Message-Id: <20200119130100.3179857-14-idosch@idosch.org>
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

Add packet trap that can report NVE packets that the device decided to
drop because their overlay source MAC is multicast.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 Documentation/networking/devlink/devlink-trap.rst | 4 ++++
 include/net/devlink.h                             | 3 +++
 net/core/devlink.c                                | 1 +
 3 files changed, 8 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 014f0a34c0e4..47a429bb8658 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -234,6 +234,10 @@ be added to the following table:
      - Traps NVE and IPinIP packets that the device decided to drop because of
        failure during decapsulation (e.g., packet being too short, reserved
        bits set in VXLAN header)
+   * - ``overlay_smac_is_mc``
+     - ``drop``
+     - Traps NVE packets that the device decided to drop because their overlay
+       source MAC is multicast
 
 Driver-specific Packet Traps
 ============================
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 455282a4b714..2813fd06ee89 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -593,6 +593,7 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_IPV6_LPM_UNICAST_MISS,
 	DEVLINK_TRAP_GENERIC_ID_NON_ROUTABLE,
 	DEVLINK_TRAP_GENERIC_ID_DECAP_ERROR,
+	DEVLINK_TRAP_GENERIC_ID_OVERLAY_SMAC_MC,
 
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -666,6 +667,8 @@ enum devlink_trap_group_generic_id {
 	"non_routable_packet"
 #define DEVLINK_TRAP_GENERIC_NAME_DECAP_ERROR \
 	"decap_error"
+#define DEVLINK_TRAP_GENERIC_NAME_OVERLAY_SMAC_MC \
+	"overlay_smac_is_mc"
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
diff --git a/net/core/devlink.c b/net/core/devlink.c
index af85fcd9b01e..e5b19bd2cbe2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7708,6 +7708,7 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(IPV6_LPM_UNICAST_MISS, EXCEPTION),
 	DEVLINK_TRAP(NON_ROUTABLE, DROP),
 	DEVLINK_TRAP(DECAP_ERROR, EXCEPTION),
+	DEVLINK_TRAP(OVERLAY_SMAC_MC, DROP),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
-- 
2.24.1

