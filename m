Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E372C0086
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 08:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgKWHOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 02:14:19 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:38453 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727852AbgKWHOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 02:14:19 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id D7A0BF5A;
        Mon, 23 Nov 2020 02:14:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 23 Nov 2020 02:14:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=MC3yhjWySVLJjDMo6OSWTe8aq7Y2rVccojQcGLIxpjc=; b=D/Hi6x+K
        rPA5T0xufcPzyZHQUxsAY3wnAOdCE/855oMqRLbZ2DxFNDNKlOL44Xp71m3C5kno
        HMFo64vuyRLUPAtA/FHJJcv5T/GwhFxiQVEj2w+MWXqB82DR/CGapiBCBPzzoETt
        p80kSg48rPQbKJYIr6zVvvnCZLspGld5qQ+LFNNaAkknsnEb0rU9MGSalmP4cpd5
        gtId/SorkqBhmnWQeyj31XeZUfIGZXwbPJ87BYozXLJw9vPCBcJq7uAo/RAjR67j
        KCaTpthC+5LYZDCFrITfN115qlsBognt8S7b2cbHxkAeB0XhTQ9nHoWkdedr0UGV
        EpMaVpUCULqUwA==
X-ME-Sender: <xms:SWG7X4ZMLrWrvisEk4FmJdFhw313iGf4hkrFvCqZhWpKg6qvehV1xA>
    <xme:SWG7XzYV9cT1rWnLmMhwcoSg5-N8ZKtuwup7B7cGDczkTU_05e-6U_yHhR_b5MLdT
    DNSfYeeYjZy2zA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:SWG7Xy_kkGZ4xTQfcHYLGhutPXTYpQFwyoF7e7PzGk52oAkW8EXSUQ>
    <xmx:SWG7XyrO6jrdQKljyVfkblqPdBQpxsjTJ0xy2O1M-Efj4CrN6PAFyw>
    <xmx:SWG7XzpIL8KPYnzzVyt7vs3sum76Z-VoxEasXGSzsWRQta6x9vfwsA>
    <xmx:SWG7XyV7WT7y_cSp1eaVh17vk_SepYHC1Yl9O2nvXqmr3rAyVZSoRg>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1B1103280063;
        Mon, 23 Nov 2020 02:14:15 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/10] devlink: Add blackhole_nexthop trap
Date:   Mon, 23 Nov 2020 09:12:28 +0200
Message-Id: <20201123071230.676469-9-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123071230.676469-1-idosch@idosch.org>
References: <20201123071230.676469-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add a packet trap to report packets that were dropped due to a
blackhole nexthop.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 Documentation/networking/devlink/devlink-trap.rst | 4 ++++
 include/net/devlink.h                             | 4 +++-
 net/core/devlink.c                                | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index ef719ceac299..d875f3e1e9cf 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -476,6 +476,10 @@ be added to the following table:
    * - ``esp_parsing``
      - ``drop``
      - Traps packets dropped due to an error in the ESP header parsing
+   * - ``blackhole_nexthop``
+     - ``drop``
+     - Traps packets that the device decided to drop in case they hit a
+       blackhole nexthop
 
 Driver-specific Packet Traps
 ============================
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 457c537d0ef2..f466819cc477 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -835,6 +835,7 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_DCCP_PARSING,
 	DEVLINK_TRAP_GENERIC_ID_GTP_PARSING,
 	DEVLINK_TRAP_GENERIC_ID_ESP_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_BLACKHOLE_NEXTHOP,
 
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -1058,7 +1059,8 @@ enum devlink_trap_group_generic_id {
 	"gtp_parsing"
 #define DEVLINK_TRAP_GENERIC_NAME_ESP_PARSING \
 	"esp_parsing"
-
+#define DEVLINK_TRAP_GENERIC_NAME_BLACKHOLE_NEXTHOP \
+	"blackhole_nexthop"
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e6fb1fdedded..7c05e8603bff 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9490,6 +9490,7 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(DCCP_PARSING, DROP),
 	DEVLINK_TRAP(GTP_PARSING, DROP),
 	DEVLINK_TRAP(ESP_PARSING, DROP),
+	DEVLINK_TRAP(BLACKHOLE_NEXTHOP, DROP),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
-- 
2.28.0

