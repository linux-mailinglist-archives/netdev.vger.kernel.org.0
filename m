Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358552D019E
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 09:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgLFIY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 03:24:27 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:49069 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgLFIY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 03:24:27 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 4A8E5C8F;
        Sun,  6 Dec 2020 03:22:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 06 Dec 2020 03:22:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=iqbmy0HCdMiqMsFTZt0DTNFevrQClO0sELqFng0qO3E=; b=n0keT0Fi
        tnNb5UiGA1KR22+wx9mXoOOq9riudoPlr+4yXghSw4/z3BeFvM4LlJfCEbYLtDOq
        W5bgbxjm0VQBAj9JjZPZk4CBlinI/pI2XA9xb+kjSNEP+kOuha/R1T1QuDa/FM9d
        s+aiBo+DKyLP/FUk/RC2ED//6XCgkfx0n7BD1kcCVSb1/712TzHpgInh0G8qYLmb
        T5v6Qr0iRBNbPX3CIrIQBWfxmZsWXXK8biyaPwr/I0Mto72wgtFlT7pc2yLIZar6
        fLQDa0p7mITa9F5bn1wjT+0KXgFjT5V/Sk+rknkdXaB0O67i0O/zKOUtlIfAUO+9
        Nemwkq+UfC6CXQ==
X-ME-Sender: <xms:4pTMX2oNr2tVIK1jsSwYGz4Jmfi1-68NAe972zh9JG57kabHYUZ5YQ>
    <xme:4pTMX0oORLG5Tbd0nv-ZhBc6wAW_XSnVdULTBNd8E9xbBktVT8kjY91gFNiJoAQud
    O_O7LJWnT_V4lQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejuddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddv
    feegnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:4pTMX7PpaO61SKjdSH2warO2ELbG-wfit8KtxEuuKvVu5dkdejb71A>
    <xmx:4pTMX16_ibTdYidoM61jyK7k8vtWEClYvIfdyNeHz_R1eDtlskZx7w>
    <xmx:4pTMX16zgMu8kJU5WGO_F1sQd_QW3cmK6oUHwDDkDqKSE8226SxVPw>
    <xmx:4pTMX_lnN4A5fbEWZNAjVUNnQxmj5sbaHAFsbcI3_vZ1HhFDSkyVsA>
Received: from shredder.lan (igld-84-229-154-234.inter.net.il [84.229.154.234])
        by mail.messagingengine.com (Postfix) with ESMTPA id 92426108005C;
        Sun,  6 Dec 2020 03:22:57 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/7] mlxsw: core_acl: Use an array instead of a struct with a zero-length array
Date:   Sun,  6 Dec 2020 10:22:25 +0200
Message-Id: <20201206082227.1857042-6-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201206082227.1857042-1-idosch@idosch.org>
References: <20201206082227.1857042-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Suppresses the following coccinelle warning:

drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c:139:3-7:
WARNING use flexible-array member instead

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../mellanox/mlxsw/core_acl_flex_keys.c       | 26 ++++++++-----------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
index 9f6905fa6b47..f1b09c2f9eda 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
@@ -133,10 +133,8 @@ mlxsw_afk_key_info_find(struct mlxsw_afk *mlxsw_afk,
 }
 
 struct mlxsw_afk_picker {
-	struct {
-		DECLARE_BITMAP(element, MLXSW_AFK_ELEMENT_MAX);
-		unsigned int total;
-	} hits[0];
+	DECLARE_BITMAP(element, MLXSW_AFK_ELEMENT_MAX);
+	unsigned int total;
 };
 
 static void mlxsw_afk_picker_count_hits(struct mlxsw_afk *mlxsw_afk,
@@ -154,8 +152,8 @@ static void mlxsw_afk_picker_count_hits(struct mlxsw_afk *mlxsw_afk,
 
 			elinst = &block->instances[j];
 			if (elinst->element == element) {
-				__set_bit(element, picker->hits[i].element);
-				picker->hits[i].total++;
+				__set_bit(element, picker[i].element);
+				picker[i].total++;
 			}
 		}
 	}
@@ -169,13 +167,13 @@ static void mlxsw_afk_picker_subtract_hits(struct mlxsw_afk *mlxsw_afk,
 	int i;
 	int j;
 
-	memcpy(&hits_element, &picker->hits[block_index].element,
+	memcpy(&hits_element, &picker[block_index].element,
 	       sizeof(hits_element));
 
 	for (i = 0; i < mlxsw_afk->blocks_count; i++) {
 		for_each_set_bit(j, hits_element, MLXSW_AFK_ELEMENT_MAX) {
-			if (__test_and_clear_bit(j, picker->hits[i].element))
-				picker->hits[i].total--;
+			if (__test_and_clear_bit(j, picker[i].element))
+				picker[i].total--;
 		}
 	}
 }
@@ -188,8 +186,8 @@ static int mlxsw_afk_picker_most_hits_get(struct mlxsw_afk *mlxsw_afk,
 	int i;
 
 	for (i = 0; i < mlxsw_afk->blocks_count; i++) {
-		if (picker->hits[i].total > most_hits) {
-			most_hits = picker->hits[i].total;
+		if (picker[i].total > most_hits) {
+			most_hits = picker[i].total;
 			most_index = i;
 		}
 	}
@@ -206,7 +204,7 @@ static int mlxsw_afk_picker_key_info_add(struct mlxsw_afk *mlxsw_afk,
 	if (key_info->blocks_count == mlxsw_afk->max_blocks)
 		return -EINVAL;
 
-	for_each_set_bit(element, picker->hits[block_index].element,
+	for_each_set_bit(element, picker[block_index].element,
 			 MLXSW_AFK_ELEMENT_MAX) {
 		key_info->element_to_block[element] = key_info->blocks_count;
 		mlxsw_afk_element_usage_add(&key_info->elusage, element);
@@ -224,11 +222,9 @@ static int mlxsw_afk_picker(struct mlxsw_afk *mlxsw_afk,
 {
 	struct mlxsw_afk_picker *picker;
 	enum mlxsw_afk_element element;
-	size_t alloc_size;
 	int err;
 
-	alloc_size = sizeof(picker->hits[0]) * mlxsw_afk->blocks_count;
-	picker = kzalloc(alloc_size, GFP_KERNEL);
+	picker = kcalloc(mlxsw_afk->blocks_count, sizeof(*picker), GFP_KERNEL);
 	if (!picker)
 		return -ENOMEM;
 
-- 
2.28.0

