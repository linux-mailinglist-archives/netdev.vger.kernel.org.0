Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51332D7C68
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbgLKRH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:07:26 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:52783 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394119AbgLKRGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:06:19 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id A32B8A3C;
        Fri, 11 Dec 2020 12:05:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 11 Dec 2020 12:05:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=RGp6eRt34lFUPZ17q89vql+2rA6rOLN7XU8rAY2Xv/o=; b=DAVrmG7R
        vsEkemR7UYIkODHq4IGFHiXgMgJyL2xkp+R2J4HxbBTKQS2ykkaTUh0b0I2Rn0CW
        NYSD3W6kMpkN0XIwOPh/dpoErZo/gBJP6N4wWTOg6JZndjsUoM9yjrWnWfipokc2
        BE2rVcN4i6H8yZ3IeG2OTpyxLY0TbEfHdIyEBfFco32DPVR0QW6cpWaSswK9rmwj
        oUhPO3IKorzQX/J6pNrP3AF0NVwlJccVaqB8dX8YaNg6h32midAIk3k20jMFyH0R
        rZ/zQKK3NJ9MvR7i3Ssi2WpKqIJR2FW+pJFbq+9v43m+AQH+Vw8suATrLF9dWGak
        MvSnnKrgs1yXqA==
X-ME-Sender: <xms:yKbTXyF_7S9EZzvmjGFFlL_YGT0vBYe2VURy4lvVTIqm_rX-1pZTgQ>
    <xme:yKbTXzRIOAETOt4bcQ4dDioo7qpJSUcVQ8tj0Oe6uKT73M95PcjRI2oGg-67PPjfr
    SjA-LOhEpDHeOc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekvddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:yKbTX5Br6l6FzwZXbU-0P9H5DChtyOjZU0I3J0v1pZgB0B9f9cSMsw>
    <xmx:yKbTXz0Z3tDFmT7VDGMLAtE-kgnZVFOVtimuUuNzcyxBzDaP1_NfhQ>
    <xmx:yKbTX3WWeLJQa5DjZrSQYB1l0FfbnLPzRa_5SPj8iOAvaQq-NNEolQ>
    <xmx:yabTXxQKZK56h4_IGxYIS7JLmZHbZTfqqsFJYyrCtB2ZXYVNeoU6Gw>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id C841F1080057;
        Fri, 11 Dec 2020 12:05:11 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/15] mlxsw: reg: Add XM Direct Register
Date:   Fri, 11 Dec 2020 19:03:59 +0200
Message-Id: <20201211170413.2269479-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211170413.2269479-1-idosch@idosch.org>
References: <20201211170413.2269479-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The XMDR allows direct access to the XM device via the switch.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 274 +++++++++++++++++++++-
 1 file changed, 271 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 2a89b3261f00..e7979edadf4c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8469,11 +8469,278 @@ mlxsw_reg_rmft2_ipv6_pack(char *payload, bool v, u16 offset, u16 virtual_router,
 	mlxsw_reg_rmft2_sip6_mask_memcpy_to(payload, (void *)&sip6_mask);
 }
 
-/* Note that XRALXX register position violates the rule of ordering register
- * definition by the ID. However, XRALXX pack helpers are using RALXX pack
- * helpers, RALXX registers have higher IDs.
+/* Note that XMDR and XRALXX register positions violate the rule of ordering
+ * register definitions by the ID. However, XRALXX pack helpers are
+ * using RALXX pack helpers, RALXX registers have higher IDs.
+ * Also XMDR is using RALUE enums.
  */
 
+/* XMDR - XM Direct Register
+ * -------------------------
+ * The XMDR allows direct access to the XM device via the switch.
+ * Working in synchronous mode. FW waits for response from the XLT
+ * for each command. FW acks the XMDR accordingly.
+ */
+#define MLXSW_REG_XMDR_ID 0x7803
+#define MLXSW_REG_XMDR_BASE_LEN 0x20
+#define MLXSW_REG_XMDR_TRANS_LEN 0x80
+#define MLXSW_REG_XMDR_LEN (MLXSW_REG_XMDR_BASE_LEN + \
+			    MLXSW_REG_XMDR_TRANS_LEN)
+
+MLXSW_REG_DEFINE(xmdr, MLXSW_REG_XMDR_ID, MLXSW_REG_XMDR_LEN);
+
+/* reg_xmdr_bulk_entry
+ * Bulk_entry
+ * 0: Last entry - immediate flush of XRT-cache
+ * 1: Bulk entry - do not flush the XRT-cache
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, xmdr, bulk_entry, 0x04, 8, 1);
+
+/* reg_xmdr_num_rec
+ * Number of records for Direct access to XM
+ * Supported: 0..4 commands (except NOP which is a filler)
+ * 0 commands is reserved when bulk_entry = 1.
+ * 0 commands is allowed when bulk_entry = 0 for immediate XRT-cache flush.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, xmdr, num_rec, 0x04, 0, 4);
+
+/* reg_xmdr_reply_vect
+ * Reply Vector
+ * Bit i for command index i+1
+ * values per bit:
+ * 0: failed
+ * 1: succeeded
+ * e.g. if commands 1, 2, 4 succeeded and command 3 failed then binary
+ * value will be 0b1011
+ * Access: RO
+ */
+MLXSW_ITEM_BIT_ARRAY(reg, xmdr, reply_vect, 0x08, 4, 1);
+
+static inline void mlxsw_reg_xmdr_pack(char *payload, bool bulk_entry)
+{
+	MLXSW_REG_ZERO(xmdr, payload);
+	mlxsw_reg_xmdr_bulk_entry_set(payload, bulk_entry);
+}
+
+enum mlxsw_reg_xmdr_c_cmd_id {
+	MLXSW_REG_XMDR_C_CMD_ID_LT_ROUTE_V4 = 0x30,
+	MLXSW_REG_XMDR_C_CMD_ID_LT_ROUTE_V6 = 0x31,
+};
+
+#define MLXSW_REG_XMDR_C_LT_ROUTE_V4_LEN 32
+#define MLXSW_REG_XMDR_C_LT_ROUTE_V6_LEN 48
+
+/* reg_xmdr_c_cmd_id
+ */
+MLXSW_ITEM32(reg, xmdr_c, cmd_id, 0x00, 24, 8);
+
+/* reg_xmdr_c_seq_number
+ */
+MLXSW_ITEM32(reg, xmdr_c, seq_number, 0x00, 12, 12);
+
+enum mlxsw_reg_xmdr_c_ltr_op {
+	/* Activity is set */
+	MLXSW_REG_XMDR_C_LTR_OP_WRITE = 0,
+	/* There is no update mask. All fields are updated. */
+	MLXSW_REG_XMDR_C_LTR_OP_UPDATE = 1,
+	MLXSW_REG_XMDR_C_LTR_OP_DELETE = 2,
+};
+
+/* reg_xmdr_c_ltr_op
+ * Operation.
+ */
+MLXSW_ITEM32(reg, xmdr_c, ltr_op, 0x04, 24, 8);
+
+/* reg_xmdr_c_ltr_trap_action
+ * Trap action.
+ * Values are defined in enum mlxsw_reg_ralue_trap_action.
+ */
+MLXSW_ITEM32(reg, xmdr_c, ltr_trap_action, 0x04, 20, 4);
+
+enum mlxsw_reg_xmdr_c_ltr_trap_id_num {
+	MLXSW_REG_XMDR_C_LTR_TRAP_ID_NUM_RTR_INGRESS0,
+	MLXSW_REG_XMDR_C_LTR_TRAP_ID_NUM_RTR_INGRESS1,
+	MLXSW_REG_XMDR_C_LTR_TRAP_ID_NUM_RTR_INGRESS2,
+	MLXSW_REG_XMDR_C_LTR_TRAP_ID_NUM_RTR_INGRESS3,
+};
+
+/* reg_xmdr_c_ltr_trap_id_num
+ * Trap-ID number.
+ */
+MLXSW_ITEM32(reg, xmdr_c, ltr_trap_id_num, 0x04, 16, 4);
+
+/* reg_xmdr_c_ltr_virtual_router
+ * Virtual Router ID.
+ * Range is 0..cap_max_virtual_routers-1
+ */
+MLXSW_ITEM32(reg, xmdr_c, ltr_virtual_router, 0x04, 0, 16);
+
+/* reg_xmdr_c_ltr_prefix_len
+ * Number of bits in the prefix of the LPM route.
+ */
+MLXSW_ITEM32(reg, xmdr_c, ltr_prefix_len, 0x08, 24, 8);
+
+/* reg_xmdr_c_ltr_bmp_len
+ * The best match prefix length in the case that there is no match for
+ * longer prefixes.
+ * If (entry_type != MARKER_ENTRY), bmp_len must be equal to prefix_len
+ */
+MLXSW_ITEM32(reg, xmdr_c, ltr_bmp_len, 0x08, 16, 8);
+
+/* reg_xmdr_c_ltr_entry_type
+ * Entry type.
+ * Values are defined in enum mlxsw_reg_ralue_entry_type.
+ */
+MLXSW_ITEM32(reg, xmdr_c, ltr_entry_type, 0x08, 4, 4);
+
+enum mlxsw_reg_xmdr_c_ltr_action_type {
+	MLXSW_REG_XMDR_C_LTR_ACTION_TYPE_LOCAL,
+	MLXSW_REG_XMDR_C_LTR_ACTION_TYPE_REMOTE,
+	MLXSW_REG_XMDR_C_LTR_ACTION_TYPE_IP2ME,
+};
+
+/* reg_xmdr_c_ltr_action_type
+ * Action Type.
+ */
+MLXSW_ITEM32(reg, xmdr_c, ltr_action_type, 0x08, 0, 4);
+
+/* reg_xmdr_c_ltr_erif
+ * Egress Router Interface.
+ * Only relevant in case of LOCAL action.
+ */
+MLXSW_ITEM32(reg, xmdr_c, ltr_erif, 0x10, 0, 16);
+
+/* reg_xmdr_c_ltr_adjacency_index
+ * Points to the first entry of the group-based ECMP.
+ * Only relevant in case of REMOTE action.
+ */
+MLXSW_ITEM32(reg, xmdr_c, ltr_adjacency_index, 0x10, 0, 24);
+
+#define MLXSW_REG_XMDR_C_LTR_POINTER_TO_TUNNEL_DISABLED_MAGIC 0xFFFFFF
+
+/* reg_xmdr_c_ltr_pointer_to_tunnel
+ * Only relevant in case of IP2ME action.
+ */
+MLXSW_ITEM32(reg, xmdr_c, ltr_pointer_to_tunnel, 0x10, 0, 24);
+
+/* reg_xmdr_c_ltr_ecmp_size
+ * Amount of sequential entries starting
+ * from the adjacency_index (the number of ECMPs).
+ * The valid range is 1-64, 512, 1024, 2048 and 4096.
+ * Only relevant in case of REMOTE action.
+ */
+MLXSW_ITEM32(reg, xmdr_c, ltr_ecmp_size, 0x14, 0, 32);
+
+/* reg_xmdr_c_ltr_dip*
+ * The prefix of the route or of the marker that the object of the LPM
+ * is compared with. The most significant bits of the dip are the prefix.
+ * The least significant bits must be '0' if the prefix_len is smaller
+ * than 128 for IPv6 or smaller than 32 for IPv4.
+ */
+MLXSW_ITEM32(reg, xmdr_c, ltr_dip4, 0x1C, 0, 32);
+MLXSW_ITEM_BUF(reg, xmdr_c, ltr_dip6, 0x1C, 16);
+
+static inline void
+mlxsw_reg_xmdr_c_ltr_pack(char *xmdr_payload, unsigned int trans_offset,
+			  enum mlxsw_reg_xmdr_c_cmd_id cmd_id, u16 seq_number,
+			  enum mlxsw_reg_xmdr_c_ltr_op op, u16 virtual_router,
+			  u8 prefix_len)
+{
+	char *payload = xmdr_payload + MLXSW_REG_XMDR_BASE_LEN + trans_offset;
+	u8 num_rec = mlxsw_reg_xmdr_num_rec_get(xmdr_payload);
+
+	mlxsw_reg_xmdr_num_rec_set(xmdr_payload, num_rec + 1);
+
+	mlxsw_reg_xmdr_c_cmd_id_set(payload, cmd_id);
+	mlxsw_reg_xmdr_c_seq_number_set(payload, seq_number);
+	mlxsw_reg_xmdr_c_ltr_op_set(payload, op);
+	mlxsw_reg_xmdr_c_ltr_virtual_router_set(payload, virtual_router);
+	mlxsw_reg_xmdr_c_ltr_prefix_len_set(payload, prefix_len);
+	mlxsw_reg_xmdr_c_ltr_entry_type_set(payload,
+					    MLXSW_REG_RALUE_ENTRY_TYPE_ROUTE_ENTRY);
+	mlxsw_reg_xmdr_c_ltr_bmp_len_set(payload, prefix_len);
+}
+
+static inline unsigned int
+mlxsw_reg_xmdr_c_ltr_pack4(char *xmdr_payload, unsigned int trans_offset,
+			   u16 seq_number, enum mlxsw_reg_xmdr_c_ltr_op op,
+			   u16 virtual_router, u8 prefix_len, u32 *dip)
+{
+	char *payload = xmdr_payload + MLXSW_REG_XMDR_BASE_LEN + trans_offset;
+
+	mlxsw_reg_xmdr_c_ltr_pack(xmdr_payload, trans_offset,
+				  MLXSW_REG_XMDR_C_CMD_ID_LT_ROUTE_V4,
+				  seq_number, op, virtual_router, prefix_len);
+	if (dip)
+		mlxsw_reg_xmdr_c_ltr_dip4_set(payload, *dip);
+	return MLXSW_REG_XMDR_C_LT_ROUTE_V4_LEN;
+}
+
+static inline unsigned int
+mlxsw_reg_xmdr_c_ltr_pack6(char *xmdr_payload, unsigned int trans_offset,
+			   u16 seq_number, enum mlxsw_reg_xmdr_c_ltr_op op,
+			   u16 virtual_router, u8 prefix_len, const void *dip)
+{
+	char *payload = xmdr_payload + MLXSW_REG_XMDR_BASE_LEN + trans_offset;
+
+	mlxsw_reg_xmdr_c_ltr_pack(xmdr_payload, trans_offset,
+				  MLXSW_REG_XMDR_C_CMD_ID_LT_ROUTE_V6,
+				  seq_number, op, virtual_router, prefix_len);
+	if (dip)
+		mlxsw_reg_xmdr_c_ltr_dip6_memcpy_to(payload, dip);
+	return MLXSW_REG_XMDR_C_LT_ROUTE_V6_LEN;
+}
+
+static inline void
+mlxsw_reg_xmdr_c_ltr_act_remote_pack(char *xmdr_payload, unsigned int trans_offset,
+				     enum mlxsw_reg_ralue_trap_action trap_action,
+				     enum mlxsw_reg_xmdr_c_ltr_trap_id_num trap_id_num,
+				     u32 adjacency_index, u16 ecmp_size)
+{
+	char *payload = xmdr_payload + MLXSW_REG_XMDR_BASE_LEN + trans_offset;
+
+	mlxsw_reg_xmdr_c_ltr_action_type_set(payload, MLXSW_REG_XMDR_C_LTR_ACTION_TYPE_REMOTE);
+	mlxsw_reg_xmdr_c_ltr_trap_action_set(payload, trap_action);
+	mlxsw_reg_xmdr_c_ltr_trap_id_num_set(payload, trap_id_num);
+	mlxsw_reg_xmdr_c_ltr_adjacency_index_set(payload, adjacency_index);
+	mlxsw_reg_xmdr_c_ltr_ecmp_size_set(payload, ecmp_size);
+}
+
+static inline void
+mlxsw_reg_xmdr_c_ltr_act_local_pack(char *xmdr_payload, unsigned int trans_offset,
+				    enum mlxsw_reg_ralue_trap_action trap_action,
+				    enum mlxsw_reg_xmdr_c_ltr_trap_id_num trap_id_num, u16 erif)
+{
+	char *payload = xmdr_payload + MLXSW_REG_XMDR_BASE_LEN + trans_offset;
+
+	mlxsw_reg_xmdr_c_ltr_action_type_set(payload, MLXSW_REG_XMDR_C_LTR_ACTION_TYPE_LOCAL);
+	mlxsw_reg_xmdr_c_ltr_trap_action_set(payload, trap_action);
+	mlxsw_reg_xmdr_c_ltr_trap_id_num_set(payload, trap_id_num);
+	mlxsw_reg_xmdr_c_ltr_erif_set(payload, erif);
+}
+
+static inline void mlxsw_reg_xmdr_c_ltr_act_ip2me_pack(char *xmdr_payload,
+						       unsigned int trans_offset)
+{
+	char *payload = xmdr_payload + MLXSW_REG_XMDR_BASE_LEN + trans_offset;
+
+	mlxsw_reg_xmdr_c_ltr_action_type_set(payload, MLXSW_REG_XMDR_C_LTR_ACTION_TYPE_IP2ME);
+	mlxsw_reg_xmdr_c_ltr_pointer_to_tunnel_set(payload,
+						   MLXSW_REG_XMDR_C_LTR_POINTER_TO_TUNNEL_DISABLED_MAGIC);
+}
+
+static inline void mlxsw_reg_xmdr_c_ltr_act_ip2me_tun_pack(char *xmdr_payload,
+							   unsigned int trans_offset,
+							   u32 pointer_to_tunnel)
+{
+	char *payload = xmdr_payload + MLXSW_REG_XMDR_BASE_LEN + trans_offset;
+
+	mlxsw_reg_xmdr_c_ltr_action_type_set(payload, MLXSW_REG_XMDR_C_LTR_ACTION_TYPE_IP2ME);
+	mlxsw_reg_xmdr_c_ltr_pointer_to_tunnel_set(payload, pointer_to_tunnel);
+}
+
 /* XRALTA - XM Router Algorithmic LPM Tree Allocation Register
  * -----------------------------------------------------------
  * The XRALTA is used to allocate the XLT LPM trees.
@@ -11487,6 +11754,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(rigr2),
 	MLXSW_REG(recr2),
 	MLXSW_REG(rmft2),
+	MLXSW_REG(xmdr),
 	MLXSW_REG(xralta),
 	MLXSW_REG(xralst),
 	MLXSW_REG(xraltb),
-- 
2.29.2

