Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B941ED299
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 09:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfKCIgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 03:36:35 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34527 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726546AbfKCIge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 03:36:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5033E213BD;
        Sun,  3 Nov 2019 03:36:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 03 Nov 2019 03:36:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=FB0fTK/T9GRxtbZmXSS0NY5VpeiR6WvBeobytd1Z+LQ=; b=GHQYit0m
        nCCWBlJ2orkT66MDxxucPnSpW9NzuOvOF7KNNr7jm331yWc8aEF8PmhhW3kNk9rW
        O1/chP2DiDe6pIXcfh5rrkZe/6zPA7m9yfilkLeX1JOAAKtKcVqcqUKfPK5wS1hA
        C+6Z8t923F8cToJhxY+c2aDXOUbD0iNGfmBhP8qV1ZY7ZxRkuiGVdByfQjJy4lvl
        v4iYMlZx5UVEbpTPpDq/CmjAwz4jazFjKVx9imVtuls8E3HItHpiyYtBKDz+8aEu
        2VpS4xdbyj7X7DLTufkv97ChGo2RHBmx5IXMiWFdLpeVN/ZuVkMq15lNMpze3uYr
        JmIuFWq8AnPnMw==
X-ME-Sender: <xms:kZG-XYbiJ46ONVu7lUxrtc9Ifoz60Rud07zTULYGdZPR2BExHYO0IQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddutddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:kZG-XQkMuDfG348c82b_djiR5ks9PkWlAvt0VSy_G_fYqDWM2tIGTg>
    <xmx:kZG-XbiDfI88jFqnyZMxEQLxLX2eoP5zkLn90n7SQM14yOOtYiKBXg>
    <xmx:kZG-XSQDN65r_kN85ZHFUkQxc6vDj-hjEWJJREfbtqWEIVq8xDOFVw>
    <xmx:kZG-XRmumKI8gXA2NysEsWvqNqBDdLTQnxZj3LR0AItGCE--qtlP7g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E996F306005B;
        Sun,  3 Nov 2019 03:36:31 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/6] mlxsw: core: Add support for using EMAD string TLV
Date:   Sun,  3 Nov 2019 10:35:53 +0200
Message-Id: <20191103083554.6317-6-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191103083554.6317-1-idosch@idosch.org>
References: <20191103083554.6317-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

In case the firmware had an error while processing EMADs, it can send back
an ASCII string with the reason using EMAD string TLV.

This patch adds the support for using EMAD string TLV and prints the string
reason in case of an error.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 67 ++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/core.h |  2 +
 2 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index e166ce745150..96b2657789d2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -71,6 +71,7 @@ struct mlxsw_core {
 		struct list_head trans_list;
 		spinlock_t trans_list_lock; /* protects trans_list writes */
 		bool use_emad;
+		bool enable_string_tlv;
 	} emad;
 	struct {
 		u8 *mapping; /* lag_id+port_index to local_port mapping */
@@ -323,6 +324,12 @@ static void mlxsw_emad_pack_reg_tlv(char *reg_tlv,
 	memcpy(reg_tlv + sizeof(u32), payload, reg->len);
 }
 
+static void mlxsw_emad_pack_string_tlv(char *string_tlv)
+{
+	mlxsw_emad_string_tlv_type_set(string_tlv, MLXSW_EMAD_TLV_TYPE_STRING);
+	mlxsw_emad_string_tlv_len_set(string_tlv, MLXSW_EMAD_STRING_TLV_LEN);
+}
+
 static void mlxsw_emad_pack_op_tlv(char *op_tlv,
 				   const struct mlxsw_reg_info *reg,
 				   enum mlxsw_core_reg_access_type type,
@@ -364,7 +371,7 @@ static void mlxsw_emad_construct(struct sk_buff *skb,
 				 const struct mlxsw_reg_info *reg,
 				 char *payload,
 				 enum mlxsw_core_reg_access_type type,
-				 u64 tid)
+				 u64 tid, bool enable_string_tlv)
 {
 	char *buf;
 
@@ -374,6 +381,11 @@ static void mlxsw_emad_construct(struct sk_buff *skb,
 	buf = skb_push(skb, reg->len + sizeof(u32));
 	mlxsw_emad_pack_reg_tlv(buf, reg, payload);
 
+	if (enable_string_tlv) {
+		buf = skb_push(skb, MLXSW_EMAD_STRING_TLV_LEN * sizeof(u32));
+		mlxsw_emad_pack_string_tlv(buf);
+	}
+
 	buf = skb_push(skb, MLXSW_EMAD_OP_TLV_LEN * sizeof(u32));
 	mlxsw_emad_pack_op_tlv(buf, reg, type, tid);
 
@@ -418,6 +430,17 @@ static char *mlxsw_emad_op_tlv(const struct sk_buff *skb)
 	return ((char *) (skb->data + offsets->op_tlv));
 }
 
+static char *mlxsw_emad_string_tlv(const struct sk_buff *skb)
+{
+	struct mlxsw_emad_tlv_offsets *offsets =
+		(struct mlxsw_emad_tlv_offsets *) skb->cb;
+
+	if (!offsets->string_tlv)
+		return NULL;
+
+	return ((char *) (skb->data + offsets->string_tlv));
+}
+
 static char *mlxsw_emad_reg_tlv(const struct sk_buff *skb)
 {
 	struct mlxsw_emad_tlv_offsets *offsets =
@@ -499,10 +522,26 @@ struct mlxsw_reg_trans {
 	const struct mlxsw_reg_info *reg;
 	enum mlxsw_core_reg_access_type type;
 	int err;
+	char emad_err_string[MLXSW_EMAD_STRING_TLV_STRING_LEN];
 	enum mlxsw_emad_op_tlv_status emad_status;
 	struct rcu_head rcu;
 };
 
+static void mlxsw_emad_process_string_tlv(const struct sk_buff *skb,
+					  struct mlxsw_reg_trans *trans)
+{
+	char *string_tlv;
+	char *string;
+
+	string_tlv = mlxsw_emad_string_tlv(skb);
+	if (!string_tlv)
+		return;
+
+	string = mlxsw_emad_string_tlv_string_data(string_tlv);
+	strlcpy(trans->emad_err_string, string,
+		MLXSW_EMAD_STRING_TLV_STRING_LEN);
+}
+
 #define MLXSW_EMAD_TIMEOUT_DURING_FW_FLASH_MS	3000
 #define MLXSW_EMAD_TIMEOUT_MS			200
 
@@ -600,6 +639,8 @@ static void mlxsw_emad_process_response(struct mlxsw_core *mlxsw_core,
 				trans->cb(mlxsw_core,
 					  mlxsw_emad_reg_payload(reg_tlv),
 					  trans->reg->len, trans->cb_priv);
+		} else {
+			mlxsw_emad_process_string_tlv(skb, trans);
 		}
 		mlxsw_emad_trans_finish(trans, err);
 	}
@@ -692,7 +733,7 @@ static void mlxsw_emad_fini(struct mlxsw_core *mlxsw_core)
 }
 
 static struct sk_buff *mlxsw_emad_alloc(const struct mlxsw_core *mlxsw_core,
-					u16 reg_len)
+					u16 reg_len, bool enable_string_tlv)
 {
 	struct sk_buff *skb;
 	u16 emad_len;
@@ -700,6 +741,8 @@ static struct sk_buff *mlxsw_emad_alloc(const struct mlxsw_core *mlxsw_core,
 	emad_len = (reg_len + sizeof(u32) + MLXSW_EMAD_ETH_HDR_LEN +
 		    (MLXSW_EMAD_OP_TLV_LEN + MLXSW_EMAD_END_TLV_LEN) *
 		    sizeof(u32) + mlxsw_core->driver->txhdr_len);
+	if (enable_string_tlv)
+		emad_len += MLXSW_EMAD_STRING_TLV_LEN * sizeof(u32);
 	if (emad_len > MLXSW_EMAD_MAX_FRAME_LEN)
 		return NULL;
 
@@ -721,6 +764,7 @@ static int mlxsw_emad_reg_access(struct mlxsw_core *mlxsw_core,
 				 mlxsw_reg_trans_cb_t *cb,
 				 unsigned long cb_priv, u64 tid)
 {
+	bool enable_string_tlv;
 	struct sk_buff *skb;
 	int err;
 
@@ -728,7 +772,12 @@ static int mlxsw_emad_reg_access(struct mlxsw_core *mlxsw_core,
 		tid, reg->id, mlxsw_reg_id_str(reg->id),
 		mlxsw_core_reg_access_type_str(type));
 
-	skb = mlxsw_emad_alloc(mlxsw_core, reg->len);
+	/* Since this can be changed during emad_reg_access, read it once and
+	 * use the value all the way.
+	 */
+	enable_string_tlv = mlxsw_core->emad.enable_string_tlv;
+
+	skb = mlxsw_emad_alloc(mlxsw_core, reg->len, enable_string_tlv);
 	if (!skb)
 		return -ENOMEM;
 
@@ -745,7 +794,8 @@ static int mlxsw_emad_reg_access(struct mlxsw_core *mlxsw_core,
 	trans->reg = reg;
 	trans->type = type;
 
-	mlxsw_emad_construct(skb, reg, payload, type, trans->tid);
+	mlxsw_emad_construct(skb, reg, payload, type, trans->tid,
+			     enable_string_tlv);
 	mlxsw_core->driver->txhdr_construct(skb, &trans->tx_info);
 
 	spin_lock_bh(&mlxsw_core->emad.trans_list_lock);
@@ -1697,6 +1747,9 @@ static int mlxsw_reg_trans_wait(struct mlxsw_reg_trans *trans)
 			mlxsw_core_reg_access_type_str(trans->type),
 			trans->emad_status,
 			mlxsw_emad_op_tlv_status_str(trans->emad_status));
+		if (strlen(trans->emad_err_string))
+			dev_err(mlxsw_core->bus_info->dev, "Firmware error (tid=%llx,emad_err_string=%s)\n",
+				trans->tid, trans->emad_err_string);
 		trace_devlink_hwerr(priv_to_devlink(mlxsw_core),
 				    trans->emad_status,
 				    mlxsw_emad_op_tlv_status_str(trans->emad_status));
@@ -2270,6 +2323,12 @@ u32 mlxsw_core_read_frc_l(struct mlxsw_core *mlxsw_core)
 }
 EXPORT_SYMBOL(mlxsw_core_read_frc_l);
 
+void mlxsw_core_emad_string_tlv_enable(struct mlxsw_core *mlxsw_core)
+{
+	mlxsw_core->emad.enable_string_tlv = true;
+}
+EXPORT_SYMBOL(mlxsw_core_emad_string_tlv_enable);
+
 static int __init mlxsw_core_module_init(void)
 {
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 0d18bee6d140..543476a2e503 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -347,6 +347,8 @@ void mlxsw_core_fw_flash_end(struct mlxsw_core *mlxsw_core);
 u32 mlxsw_core_read_frc_h(struct mlxsw_core *mlxsw_core);
 u32 mlxsw_core_read_frc_l(struct mlxsw_core *mlxsw_core);
 
+void mlxsw_core_emad_string_tlv_enable(struct mlxsw_core *mlxsw_core);
+
 bool mlxsw_core_res_valid(struct mlxsw_core *mlxsw_core,
 			  enum mlxsw_res_id res_id);
 
-- 
2.21.0

