Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5903E43D4
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbhHIKWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:22:54 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59393 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234409AbhHIKWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:22:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CDFC85C00CE;
        Mon,  9 Aug 2021 06:22:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 09 Aug 2021 06:22:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Ezmm/eovCc3HMKlZrdY3IL0BGI/w4/hT54UfxXc4uvY=; b=smMq1c95
        lYCaiqMim5cFieGhV69Dk1ILLXi7UjAQ6ai3jzAhtdWuN/o4T7ItfSwTjdZvHSQ4
        t/AnO41OukCsrxiZ+bVVf+hI9mceHMUJsfUpfhtc00VGhDdq982cqO+e1rWhEYTZ
        WS2tfWnWFHVj2W/KzLhtZLh7o4AU+nwLbQfLN5A8yP8AAF8MPl9F1RtOoUM/0z1E
        yctelZDEDUOzXewY0KMQ3Jw8DZFz9B8svbez5/DZGxViMkmvqdb6GdVq5J6GCwMA
        b/ZEk2A7Fkvmo8LvgRMBUj3TWuqsmdttjPgX/qGN9ylR0622Hc15ME29gLhanqUw
        Lxizncl6Dvapyw==
X-ME-Sender: <xms:4QERYV4_Bg6_ZVFlviixZWR9oQF186co0ESJouFJ5jGK3O5jgUEtsg>
    <xme:4QERYS6LNcyG0v4YI9--BsFpqkl23f5fhET-pju8TjuJiiz-cyjdMMMB6fsSBTQ7t
    GPnUoJB_jIxofk>
X-ME-Received: <xmr:4QERYcfunzfm6kv7Td78MfNToycuUWoYg5fSaSlxtxWoZytx7myBEm7WjCHy30xYB5KN78YauDHZ5KgVRwX8xiDOEj1hmvhxEyTtvVs7p-5Jkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:4QERYeLg9lUOgahSqMJn_WmYXNE-LXZh01asRZB8lIWcA6nEBq6XzQ>
    <xmx:4QERYZKQxPAere8un8ECPn5VGmub4HC0TEtaRciTEVBpo4TUh7KG8Q>
    <xmx:4QERYXxWE4GVQrR_5TRxKC-y1SnfAWUaQflba2bEmx5IW9V9PLYl_g>
    <xmx:4QERYR84Gj5_kkPv_gc0CePdUypvi3CrXJnJPDriHYXF2ydGPQlmHQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:22:23 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 4/8] mlxsw: Make PMAOS pack function more generic
Date:   Mon,  9 Aug 2021 13:21:48 +0300
Message-Id: <20210809102152.719961-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210809102152.719961-1-idosch@idosch.org>
References: <20210809102152.719961-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The PMAOS register has enable bits (e.g., PMAOS.ee) that allow changing
only a subset of the fields, which is exactly what subsequent patches
will need to do. Instead of passing multiple arguments to its pack
function, only pass the module index and let the rest be set by the
different callers.

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 5 +----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 3713c45cfa1e..32554910506e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -652,8 +652,10 @@ mlxsw_env_module_oper_state_event_enable(struct mlxsw_core *mlxsw_core,
 	for (i = 0; i < module_count; i++) {
 		char pmaos_pl[MLXSW_REG_PMAOS_LEN];
 
-		mlxsw_reg_pmaos_pack(pmaos_pl, i,
-				     MLXSW_REG_PMAOS_E_GENERATE_EVENT);
+		mlxsw_reg_pmaos_pack(pmaos_pl, i);
+		mlxsw_reg_pmaos_e_set(pmaos_pl,
+				      MLXSW_REG_PMAOS_E_GENERATE_EVENT);
+		mlxsw_reg_pmaos_ee_set(pmaos_pl, true);
 		err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(pmaos), pmaos_pl);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index b2c55259f333..d0361f60d70d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5779,13 +5779,10 @@ enum mlxsw_reg_pmaos_e {
  */
 MLXSW_ITEM32(reg, pmaos, e, 0x04, 0, 2);
 
-static inline void mlxsw_reg_pmaos_pack(char *payload, u8 module,
-					enum mlxsw_reg_pmaos_e e)
+static inline void mlxsw_reg_pmaos_pack(char *payload, u8 module)
 {
 	MLXSW_REG_ZERO(pmaos, payload);
 	mlxsw_reg_pmaos_module_set(payload, module);
-	mlxsw_reg_pmaos_e_set(payload, e);
-	mlxsw_reg_pmaos_ee_set(payload, true);
 }
 
 /* PPLR - Port Physical Loopback Register
-- 
2.31.1

