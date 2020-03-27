Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641D819536A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgC0I5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:57:02 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41015 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726937AbgC0I5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 04:57:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C0F585C046D;
        Fri, 27 Mar 2020 04:56:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 27 Mar 2020 04:56:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=+KSYk8JOkjmiZAnBHvWyvu7ALX6lZFqvqfyQWXXKt
        f8=; b=JPtaju6wK1eG4PeeHAn1TBmsYv0jELNQbxD7KiNgdOOyLR3fafnWepDV2
        BKQwhJoFwAHo28+i8tDM2SPMjoQrITD1OQjLXdkN/DCQ5Os9Uh0pcL1SqRzAGGON
        PSKplwCVWJR5mujOQWMIA2SjL2lmgnRDrHILUlKJt8dzW8FPfOnHKnA2uGK8C+Zn
        Y5wHP80sj7iqm7ZhaV7R0JFDNJQ8Ni8LJ0hhkAMjmf2/EfOhftkW4dAAldUL2aJt
        Pqydz5xploQza5SzPgdqE6O34mIzqxMS0Vl/wqUxCuSGHjrNM/PipIjHFYaicRrH
        7IBC2ZWhyoQUzqu0iHzz00pJZx3ng==
X-ME-Sender: <xms:2r99XiB6x6DANjHtbUBtTUXX-ixeUl_tSAqQsqWVkOMm5zYCbfFKdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhggtgfgsehtke
    ertdertdejnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:2r99XhGLKRrFJQQNbyzsuiEgd6uukHHQblx3L5EwnZHtM6OK0b24Yg>
    <xmx:2r99XrD__YdnSQlxo-KoVqsE-Vq_lYW4y0BN-oeDpifd78wVkB9Bbg>
    <xmx:2r99XjZmDNQqTaA8Dw3vkJGg7XzQJiIZujYNhgXZ5zNIFcdtbNxo8w>
    <xmx:2r99XgbvKsDoxZJ_CsSvw_l6qDiXLEom_ma3FpIuyQjgq-TxU7hL9w>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 80260306C157;
        Fri, 27 Mar 2020 04:56:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/6] mlxsw: core_acl: Avoid defining static variable in header file
Date:   Fri, 27 Mar 2020 11:55:23 +0300
Message-Id: <20200327085525.1906170-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200327085525.1906170-1-idosch@idosch.org>
References: <20200327085525.1906170-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The static array 'mlxsw_afk_element_infos' in 'core_acl_flex_keys.h' is
copied to each file that includes the header, but not all use it. This
results in the following warnings when compiling with W=1:

drivers/net/ethernet/mellanox/mlxsw//core_acl_flex_keys.h:76:44:
warning: ‘mlxsw_afk_element_infos’ defined but not used
[-Wunused-const-variable=]

One way to suppress the warning is to mark the array with
'__maybe_unused', but another option is to remove it from the header
file entirely.

Change 'struct mlxsw_afk_element_inst' to store the key to the array
('element') instead of the array value keyed by 'element'. Adjust the
different users accordingly.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../mellanox/mlxsw/core_acl_flex_keys.c       | 50 +++++++++++++++++--
 .../mellanox/mlxsw/core_acl_flex_keys.h       | 36 +------------
 2 files changed, 47 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
index bd2207f60722..9f6905fa6b47 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
@@ -9,6 +9,41 @@
 #include "item.h"
 #include "core_acl_flex_keys.h"
 
+/* For the purpose of the driver, define an internal storage scratchpad
+ * that will be used to store key/mask values. For each defined element type
+ * define an internal storage geometry.
+ *
+ * When adding new elements, MLXSW_AFK_ELEMENT_STORAGE_SIZE must be increased
+ * accordingly.
+ */
+static const struct mlxsw_afk_element_info mlxsw_afk_element_infos[] = {
+	MLXSW_AFK_ELEMENT_INFO_U32(SRC_SYS_PORT, 0x00, 16, 16),
+	MLXSW_AFK_ELEMENT_INFO_BUF(DMAC_32_47, 0x04, 2),
+	MLXSW_AFK_ELEMENT_INFO_BUF(DMAC_0_31, 0x06, 4),
+	MLXSW_AFK_ELEMENT_INFO_BUF(SMAC_32_47, 0x0A, 2),
+	MLXSW_AFK_ELEMENT_INFO_BUF(SMAC_0_31, 0x0C, 4),
+	MLXSW_AFK_ELEMENT_INFO_U32(ETHERTYPE, 0x00, 0, 16),
+	MLXSW_AFK_ELEMENT_INFO_U32(IP_PROTO, 0x10, 0, 8),
+	MLXSW_AFK_ELEMENT_INFO_U32(VID, 0x10, 8, 12),
+	MLXSW_AFK_ELEMENT_INFO_U32(PCP, 0x10, 20, 3),
+	MLXSW_AFK_ELEMENT_INFO_U32(TCP_FLAGS, 0x10, 23, 9),
+	MLXSW_AFK_ELEMENT_INFO_U32(DST_L4_PORT, 0x14, 0, 16),
+	MLXSW_AFK_ELEMENT_INFO_U32(SRC_L4_PORT, 0x14, 16, 16),
+	MLXSW_AFK_ELEMENT_INFO_U32(IP_TTL_, 0x18, 0, 8),
+	MLXSW_AFK_ELEMENT_INFO_U32(IP_ECN, 0x18, 9, 2),
+	MLXSW_AFK_ELEMENT_INFO_U32(IP_DSCP, 0x18, 11, 6),
+	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_8_10, 0x18, 17, 3),
+	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_0_7, 0x18, 20, 8),
+	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_96_127, 0x20, 4),
+	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_64_95, 0x24, 4),
+	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_32_63, 0x28, 4),
+	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_0_31, 0x2C, 4),
+	MLXSW_AFK_ELEMENT_INFO_BUF(DST_IP_96_127, 0x30, 4),
+	MLXSW_AFK_ELEMENT_INFO_BUF(DST_IP_64_95, 0x34, 4),
+	MLXSW_AFK_ELEMENT_INFO_BUF(DST_IP_32_63, 0x38, 4),
+	MLXSW_AFK_ELEMENT_INFO_BUF(DST_IP_0_31, 0x3C, 4),
+};
+
 struct mlxsw_afk {
 	struct list_head key_info_list;
 	unsigned int max_blocks;
@@ -26,13 +61,15 @@ static bool mlxsw_afk_blocks_check(struct mlxsw_afk *mlxsw_afk)
 		const struct mlxsw_afk_block *block = &mlxsw_afk->blocks[i];
 
 		for (j = 0; j < block->instances_count; j++) {
+			const struct mlxsw_afk_element_info *elinfo;
 			struct mlxsw_afk_element_inst *elinst;
 
 			elinst = &block->instances[j];
-			if (elinst->type != elinst->info->type ||
+			elinfo = &mlxsw_afk_element_infos[elinst->element];
+			if (elinst->type != elinfo->type ||
 			    (!elinst->avoid_size_check &&
 			     elinst->item.size.bits !=
-			     elinst->info->item.size.bits))
+			     elinfo->item.size.bits))
 				return false;
 		}
 	}
@@ -116,7 +153,7 @@ static void mlxsw_afk_picker_count_hits(struct mlxsw_afk *mlxsw_afk,
 			struct mlxsw_afk_element_inst *elinst;
 
 			elinst = &block->instances[j];
-			if (elinst->info->element == element) {
+			if (elinst->element == element) {
 				__set_bit(element, picker->hits[i].element);
 				picker->hits[i].total++;
 			}
@@ -301,7 +338,7 @@ mlxsw_afk_block_elinst_get(const struct mlxsw_afk_block *block,
 		struct mlxsw_afk_element_inst *elinst;
 
 		elinst = &block->instances[i];
-		if (elinst->info->element == element)
+		if (elinst->element == element)
 			return elinst;
 	}
 	return NULL;
@@ -409,9 +446,12 @@ static void
 mlxsw_sp_afk_encode_one(const struct mlxsw_afk_element_inst *elinst,
 			char *output, char *storage, int u32_diff)
 {
-	const struct mlxsw_item *storage_item = &elinst->info->item;
 	const struct mlxsw_item *output_item = &elinst->item;
+	const struct mlxsw_afk_element_info *elinfo;
+	const struct mlxsw_item *storage_item;
 
+	elinfo = &mlxsw_afk_element_infos[elinst->element];
+	storage_item = &elinfo->item;
 	if (elinst->type == MLXSW_AFK_ELEMENT_TYPE_U32)
 		mlxsw_sp_afk_encode_u32(storage_item, output_item,
 					storage, output, u32_diff);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
index cb229b55ecc4..a47a17c04c62 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
@@ -69,42 +69,10 @@ struct mlxsw_afk_element_info {
 	MLXSW_AFK_ELEMENT_INFO(MLXSW_AFK_ELEMENT_TYPE_BUF,			\
 			       _element, _offset, 0, _size)
 
-/* For the purpose of the driver, define an internal storage scratchpad
- * that will be used to store key/mask values. For each defined element type
- * define an internal storage geometry.
- */
-static const struct mlxsw_afk_element_info mlxsw_afk_element_infos[] = {
-	MLXSW_AFK_ELEMENT_INFO_U32(SRC_SYS_PORT, 0x00, 16, 16),
-	MLXSW_AFK_ELEMENT_INFO_BUF(DMAC_32_47, 0x04, 2),
-	MLXSW_AFK_ELEMENT_INFO_BUF(DMAC_0_31, 0x06, 4),
-	MLXSW_AFK_ELEMENT_INFO_BUF(SMAC_32_47, 0x0A, 2),
-	MLXSW_AFK_ELEMENT_INFO_BUF(SMAC_0_31, 0x0C, 4),
-	MLXSW_AFK_ELEMENT_INFO_U32(ETHERTYPE, 0x00, 0, 16),
-	MLXSW_AFK_ELEMENT_INFO_U32(IP_PROTO, 0x10, 0, 8),
-	MLXSW_AFK_ELEMENT_INFO_U32(VID, 0x10, 8, 12),
-	MLXSW_AFK_ELEMENT_INFO_U32(PCP, 0x10, 20, 3),
-	MLXSW_AFK_ELEMENT_INFO_U32(TCP_FLAGS, 0x10, 23, 9),
-	MLXSW_AFK_ELEMENT_INFO_U32(DST_L4_PORT, 0x14, 0, 16),
-	MLXSW_AFK_ELEMENT_INFO_U32(SRC_L4_PORT, 0x14, 16, 16),
-	MLXSW_AFK_ELEMENT_INFO_U32(IP_TTL_, 0x18, 0, 8),
-	MLXSW_AFK_ELEMENT_INFO_U32(IP_ECN, 0x18, 9, 2),
-	MLXSW_AFK_ELEMENT_INFO_U32(IP_DSCP, 0x18, 11, 6),
-	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_8_10, 0x18, 17, 3),
-	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_0_7, 0x18, 20, 8),
-	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_96_127, 0x20, 4),
-	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_64_95, 0x24, 4),
-	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_32_63, 0x28, 4),
-	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_0_31, 0x2C, 4),
-	MLXSW_AFK_ELEMENT_INFO_BUF(DST_IP_96_127, 0x30, 4),
-	MLXSW_AFK_ELEMENT_INFO_BUF(DST_IP_64_95, 0x34, 4),
-	MLXSW_AFK_ELEMENT_INFO_BUF(DST_IP_32_63, 0x38, 4),
-	MLXSW_AFK_ELEMENT_INFO_BUF(DST_IP_0_31, 0x3C, 4),
-};
-
 #define MLXSW_AFK_ELEMENT_STORAGE_SIZE 0x40
 
 struct mlxsw_afk_element_inst { /* element instance in actual block */
-	const struct mlxsw_afk_element_info *info;
+	enum mlxsw_afk_element element;
 	enum mlxsw_afk_element_type type;
 	struct mlxsw_item item; /* element geometry in block */
 	int u32_key_diff; /* in case value needs to be adjusted before write
@@ -116,7 +84,7 @@ struct mlxsw_afk_element_inst { /* element instance in actual block */
 #define MLXSW_AFK_ELEMENT_INST(_type, _element, _offset,			\
 			       _shift, _size, _u32_key_diff, _avoid_size_check)	\
 	{									\
-		.info = &mlxsw_afk_element_infos[MLXSW_AFK_ELEMENT_##_element],	\
+		.element = MLXSW_AFK_ELEMENT_##_element,			\
 		.type = _type,							\
 		.item = {							\
 			.offset = _offset,					\
-- 
2.24.1

