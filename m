Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBE826BD4B
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgIPGg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:36:28 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:43617 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726150AbgIPGgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:36:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id AB1B7779;
        Wed, 16 Sep 2020 02:36:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Ggd1rF8t5c6QqXXsIP6mrPxtV85N4+68lRPd8iKLl8c=; b=rZyTlnZ8
        RJk1FD+3bSeRok5I/+CPegfp9QqfH4bH6u7fCWb2Sy5U+7+4OwHUUQYbIIt+yoO9
        5DypIw+Jq2znTA7t+3YDQbZ0vEGZNm9kGrNnkUCWGpjzd6YYf8vkgsf9jhAHkmos
        ZJxjFguj9IgxXYEBnaVQXhJWf+eB29LPo9oj78oNFWqPgtLVR00+LjWoaRGvRVNN
        SCnyLzHN8t9PSz15UcZYoAKXmR9PrhKA/07O9SSy19TC3MPJb25x76mt623T33kz
        wFw1/MlEfLPTluDueNUrlS1ILqsK3NhbfYICmG14vNezZ37spac/dXUjh5rM19U8
        9JSl2QiJfoWb5g==
X-ME-Sender: <xms:YbJhXyz8HJcixaO9vctmxnamjohgYOzHzndmVpSn5hmcd1mEn_JGHA>
    <xme:YbJhX-QCbUqoSH7PXfC_9pgb8r7RCg9G3eQcHaUF1C6x7Obr2N5GYT-XGgFdEwhVw
    5WbLQVpJHSL5Pk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:YbJhX0Vrk_ofMLyvVHlCf_swdjtpmU2OZA544BaAlTpUv7I56WKbsA>
    <xmx:YbJhX4gWpCEspt1AlU8H8pCbUDYDoVfNrtIquotLRnRsBUMls0617Q>
    <xmx:YbJhX0CMv7BqeVoCc3rVxfmBNKrlizgAl9ojjmGCqupCtOpKEmf2sA>
    <xmx:YbJhX3NZe0nxZFf0HLPEID1Z4ZAOWKqJTMLBWTXJ88M9_eFtZNJQNA>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 75ADC3064680;
        Wed, 16 Sep 2020 02:36:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 15/15] mlxsw: spectrum_buffers: Manage internal buffer in the hdroom code
Date:   Wed, 16 Sep 2020 09:35:28 +0300
Message-Id: <20200916063528.116624-16-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916063528.116624-1-idosch@idosch.org>
References: <20200916063528.116624-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Traffic mirroring modes that are in-chip implemented on egress need an
internal buffer to work. As the only client, the SPAN module was managing
the buffer so far. However logically it belongs to the buffers module. E.g.
buffer size validation needs to take the size of the internal buffer into
account.

Therefore move the related code from SPAN to spectrum_buffers. Move over
the callbacks that determine the minimum buffer size as a function of
maximum speed and MTU. Add a field describing the internal buffer to struct
mlxsw_sp_hdroom. Extend mlxsw_sp_hdroom_bufs_reset_sizes() to take care of
sizing the internal buffer as well. Change the SPAN module to invoke that
function and mlxsw_sp_hdroom_configure() like all the other hdroom clients.
Drop the now-unnecessary mlxsw_sp_span_port_buffer_disable().

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 22 ++---
 .../mellanox/mlxsw/spectrum_buffers.c         | 89 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 65 +++-----------
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  1 -
 4 files changed, 113 insertions(+), 64 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index b402a73acb41..247a6aebd402 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -415,17 +415,6 @@ mlxsw_sp_port_vlan_find_by_vid(const struct mlxsw_sp_port *mlxsw_sp_port,
 	return NULL;
 }
 
-static inline u32
-mlxsw_sp_port_headroom_8x_adjust(const struct mlxsw_sp_port *mlxsw_sp_port,
-				 u32 size_cells)
-{
-	/* Ports with eight lanes use two headroom buffers between which the
-	 * configured headroom size is split. Therefore, multiply the calculated
-	 * headroom size by two.
-	 */
-	return mlxsw_sp_port->mapping.width == 8 ? 2 * size_cells : size_cells;
-}
-
 enum mlxsw_sp_flood_type {
 	MLXSW_SP_FLOOD_TYPE_UC,
 	MLXSW_SP_FLOOD_TYPE_BC,
@@ -463,6 +452,17 @@ struct mlxsw_sp_hdroom {
 	struct {
 		struct mlxsw_sp_hdroom_buf buf[MLXSW_SP_PB_COUNT];
 	} bufs;
+	struct {
+		/* Size actually configured for the internal buffer. Equal to
+		 * reserve when internal buffer is enabled.
+		 */
+		u32 size_cells;
+		/* Space reserved in the headroom for the internal buffer. Port
+		 * buffers are not allowed to grow into this space.
+		 */
+		u32 reserve_cells;
+		bool enable;
+	} int_buf;
 	int delay_bytes;
 	int mtu;
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index cdd0f3dac68b..68286cd70c33 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -122,6 +122,7 @@ struct mlxsw_sp_sb_vals {
 };
 
 struct mlxsw_sp_sb_ops {
+	u32 (*int_buf_size_get)(int mtu, u32 speed);
 };
 
 u32 mlxsw_sp_cells_bytes(const struct mlxsw_sp *mlxsw_sp, u32 cells)
@@ -134,6 +135,16 @@ u32 mlxsw_sp_bytes_cells(const struct mlxsw_sp *mlxsw_sp, u32 bytes)
 	return DIV_ROUND_UP(bytes, mlxsw_sp->sb->cell_size);
 }
 
+static u32 mlxsw_sp_port_headroom_8x_adjust(const struct mlxsw_sp_port *mlxsw_sp_port,
+					    u32 size_cells)
+{
+	/* Ports with eight lanes use two headroom buffers between which the
+	 * configured headroom size is split. Therefore, multiply the calculated
+	 * headroom size by two.
+	 */
+	return mlxsw_sp_port->mapping.width == 8 ? 2 * size_cells : size_cells;
+}
+
 static struct mlxsw_sp_sb_pr *mlxsw_sp_sb_pr_get(struct mlxsw_sp *mlxsw_sp,
 						 u16 pool_index)
 {
@@ -343,6 +354,13 @@ static u16 mlxsw_sp_hdroom_buf_delay_get(const struct mlxsw_sp *mlxsw_sp,
 	return 2 * delay_cells + mlxsw_sp_bytes_cells(mlxsw_sp, hdroom->mtu);
 }
 
+static u32 mlxsw_sp_hdroom_int_buf_size_get(struct mlxsw_sp *mlxsw_sp, int mtu, u32 speed)
+{
+	u32 buffsize = mlxsw_sp->sb_ops->int_buf_size_get(speed, mtu);
+
+	return mlxsw_sp_bytes_cells(mlxsw_sp, buffsize) + 1;
+}
+
 static bool mlxsw_sp_hdroom_buf_is_used(const struct mlxsw_sp_hdroom *hdroom, int buf)
 {
 	int prio;
@@ -358,8 +376,21 @@ void mlxsw_sp_hdroom_bufs_reset_sizes(struct mlxsw_sp_port *mlxsw_sp_port,
 				      struct mlxsw_sp_hdroom *hdroom)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u16 reserve_cells;
 	int i;
 
+	/* Internal buffer. */
+	reserve_cells = mlxsw_sp_hdroom_int_buf_size_get(mlxsw_sp, mlxsw_sp_port->max_speed,
+							 mlxsw_sp_port->max_mtu);
+	reserve_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, reserve_cells);
+	hdroom->int_buf.reserve_cells = reserve_cells;
+
+	if (hdroom->int_buf.enable)
+		hdroom->int_buf.size_cells = reserve_cells;
+	else
+		hdroom->int_buf.size_cells = 0;
+
+	/* PG buffers. */
 	for (i = 0; i < DCBX_MAX_BUFFERS; i++) {
 		struct mlxsw_sp_hdroom_buf *buf = &hdroom->bufs.buf[i];
 		u16 thres_cells;
@@ -442,6 +473,26 @@ static int mlxsw_sp_hdroom_configure_priomap(struct mlxsw_sp_port *mlxsw_sp_port
 	return 0;
 }
 
+static int mlxsw_sp_hdroom_configure_int_buf(struct mlxsw_sp_port *mlxsw_sp_port,
+					     const struct mlxsw_sp_hdroom *hdroom, bool force)
+{
+	char sbib_pl[MLXSW_REG_SBIB_LEN];
+	bool dirty;
+	int err;
+
+	dirty = memcmp(&mlxsw_sp_port->hdroom->int_buf, &hdroom->int_buf, sizeof(hdroom->int_buf));
+	if (!dirty && !force)
+		return 0;
+
+	mlxsw_reg_sbib_pack(sbib_pl, mlxsw_sp_port->local_port, hdroom->int_buf.size_cells);
+	err = mlxsw_reg_write(mlxsw_sp_port->mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
+	if (err)
+		return err;
+
+	mlxsw_sp_port->hdroom->int_buf = hdroom->int_buf;
+	return 0;
+}
+
 static bool mlxsw_sp_hdroom_bufs_fit(struct mlxsw_sp *mlxsw_sp,
 				     const struct mlxsw_sp_hdroom *hdroom)
 {
@@ -451,6 +502,7 @@ static bool mlxsw_sp_hdroom_bufs_fit(struct mlxsw_sp *mlxsw_sp,
 	for (i = 0; i < MLXSW_SP_PB_COUNT; i++)
 		taken_headroom_cells += hdroom->bufs.buf[i].size_cells;
 
+	taken_headroom_cells += hdroom->int_buf.reserve_cells;
 	return taken_headroom_cells <= mlxsw_sp->sb->max_headroom_cells;
 }
 
@@ -493,9 +545,15 @@ static int __mlxsw_sp_hdroom_configure(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (err)
 		goto err_configure_buffers;
 
+	err = mlxsw_sp_hdroom_configure_int_buf(mlxsw_sp_port, hdroom, false);
+	if (err)
+		goto err_configure_int_buf;
+
 	*mlxsw_sp_port->hdroom = *hdroom;
 	return 0;
 
+err_configure_int_buf:
+	mlxsw_sp_hdroom_configure_buffers(mlxsw_sp_port, &tmp_hdroom, false);
 err_configure_buffers:
 	mlxsw_sp_hdroom_configure_priomap(mlxsw_sp_port, &tmp_hdroom, false);
 err_configure_priomap:
@@ -1104,13 +1162,44 @@ const struct mlxsw_sp_sb_vals mlxsw_sp2_sb_vals = {
 	.cms_cpu_count = ARRAY_SIZE(mlxsw_sp_cpu_port_sb_cms),
 };
 
+static u32 mlxsw_sp1_pb_int_buf_size_get(int mtu, u32 speed)
+{
+	return mtu * 5 / 2;
+}
+
+static u32 __mlxsw_sp_pb_int_buf_size_get(int mtu, u32 speed, u32 buffer_factor)
+{
+	return 3 * mtu + buffer_factor * speed / 1000;
+}
+
+#define MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR 38
+
+static u32 mlxsw_sp2_pb_int_buf_size_get(int mtu, u32 speed)
+{
+	int factor = MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR;
+
+	return __mlxsw_sp_pb_int_buf_size_get(mtu, speed, factor);
+}
+
+#define MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR 50
+
+static u32 mlxsw_sp3_pb_int_buf_size_get(int mtu, u32 speed)
+{
+	int factor = MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR;
+
+	return __mlxsw_sp_pb_int_buf_size_get(mtu, speed, factor);
+}
+
 const struct mlxsw_sp_sb_ops mlxsw_sp1_sb_ops = {
+	.int_buf_size_get = mlxsw_sp1_pb_int_buf_size_get,
 };
 
 const struct mlxsw_sp_sb_ops mlxsw_sp2_sb_ops = {
+	.int_buf_size_get = mlxsw_sp2_pb_int_buf_size_get,
 };
 
 const struct mlxsw_sp_sb_ops mlxsw_sp3_sb_ops = {
+	.int_buf_size_get = mlxsw_sp3_pb_int_buf_size_get,
 };
 
 int mlxsw_sp_buffers_init(struct mlxsw_sp *mlxsw_sp)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 38b3131c4027..c6c5826aba41 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -968,35 +968,26 @@ static int mlxsw_sp_span_entry_put(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
-static u32 mlxsw_sp_span_buffsize_get(struct mlxsw_sp *mlxsw_sp, int mtu,
-				      u32 speed)
+static int mlxsw_sp_span_port_buffer_update(struct mlxsw_sp_port *mlxsw_sp_port, bool enable)
 {
-	u32 buffsize = mlxsw_sp->span_ops->buffsize_get(speed, mtu);
+	struct mlxsw_sp_hdroom hdroom;
 
-	return mlxsw_sp_bytes_cells(mlxsw_sp, buffsize) + 1;
+	hdroom = *mlxsw_sp_port->hdroom;
+	hdroom.int_buf.enable = enable;
+	mlxsw_sp_hdroom_bufs_reset_sizes(mlxsw_sp_port, &hdroom);
+
+	return mlxsw_sp_hdroom_configure(mlxsw_sp_port, &hdroom);
 }
 
 static int
 mlxsw_sp_span_port_buffer_enable(struct mlxsw_sp_port *mlxsw_sp_port)
 {
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	char sbib_pl[MLXSW_REG_SBIB_LEN];
-	u32 buffsize;
-
-	buffsize = mlxsw_sp_span_buffsize_get(mlxsw_sp, mlxsw_sp_port->max_speed,
-					      mlxsw_sp_port->max_mtu);
-	buffsize = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, buffsize);
-	mlxsw_reg_sbib_pack(sbib_pl, mlxsw_sp_port->local_port, buffsize);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
+	return mlxsw_sp_span_port_buffer_update(mlxsw_sp_port, true);
 }
 
-static void mlxsw_sp_span_port_buffer_disable(struct mlxsw_sp *mlxsw_sp,
-					      u8 local_port)
+static void mlxsw_sp_span_port_buffer_disable(struct mlxsw_sp_port *mlxsw_sp_port)
 {
-	char sbib_pl[MLXSW_REG_SBIB_LEN];
-
-	mlxsw_reg_sbib_pack(sbib_pl, local_port, 0);
-	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
+	mlxsw_sp_span_port_buffer_update(mlxsw_sp_port, false);
 }
 
 static struct mlxsw_sp_span_analyzed_port *
@@ -1145,18 +1136,15 @@ mlxsw_sp_span_analyzed_port_create(struct mlxsw_sp_span *span,
 }
 
 static void
-mlxsw_sp_span_analyzed_port_destroy(struct mlxsw_sp_span *span,
+mlxsw_sp_span_analyzed_port_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 				    struct mlxsw_sp_span_analyzed_port *
 				    analyzed_port)
 {
-	struct mlxsw_sp *mlxsw_sp = span->mlxsw_sp;
-
 	/* Remove egress mirror buffer now that port is no longer analyzed
 	 * at egress.
 	 */
 	if (!analyzed_port->ingress)
-		mlxsw_sp_span_port_buffer_disable(mlxsw_sp,
-						  analyzed_port->local_port);
+		mlxsw_sp_span_port_buffer_disable(mlxsw_sp_port);
 
 	list_del(&analyzed_port->list);
 	kfree(analyzed_port);
@@ -1207,7 +1195,7 @@ void mlxsw_sp_span_analyzed_port_put(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (!refcount_dec_and_test(&analyzed_port->ref_count))
 		goto out_unlock;
 
-	mlxsw_sp_span_analyzed_port_destroy(mlxsw_sp->span, analyzed_port);
+	mlxsw_sp_span_analyzed_port_destroy(mlxsw_sp_port, analyzed_port);
 
 out_unlock:
 	mutex_unlock(&mlxsw_sp->span->analyzed_ports_lock);
@@ -1661,11 +1649,6 @@ static int mlxsw_sp1_span_init(struct mlxsw_sp *mlxsw_sp)
 	return 0;
 }
 
-static u32 mlxsw_sp1_span_buffsize_get(int mtu, u32 speed)
-{
-	return mtu * 5 / 2;
-}
-
 static int mlxsw_sp1_span_policer_id_base_set(struct mlxsw_sp *mlxsw_sp,
 					      u16 policer_id_base)
 {
@@ -1674,7 +1657,6 @@ static int mlxsw_sp1_span_policer_id_base_set(struct mlxsw_sp *mlxsw_sp,
 
 const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops = {
 	.init = mlxsw_sp1_span_init,
-	.buffsize_get = mlxsw_sp1_span_buffsize_get,
 	.policer_id_base_set = mlxsw_sp1_span_policer_id_base_set,
 };
 
@@ -1699,18 +1681,6 @@ static int mlxsw_sp2_span_init(struct mlxsw_sp *mlxsw_sp)
 #define MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR 38
 #define MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR 50
 
-static u32 __mlxsw_sp_span_buffsize_get(int mtu, u32 speed, u32 buffer_factor)
-{
-	return 3 * mtu + buffer_factor * speed / 1000;
-}
-
-static u32 mlxsw_sp2_span_buffsize_get(int mtu, u32 speed)
-{
-	int factor = MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR;
-
-	return __mlxsw_sp_span_buffsize_get(mtu, speed, factor);
-}
-
 static int mlxsw_sp2_span_policer_id_base_set(struct mlxsw_sp *mlxsw_sp,
 					      u16 policer_id_base)
 {
@@ -1727,19 +1697,10 @@ static int mlxsw_sp2_span_policer_id_base_set(struct mlxsw_sp *mlxsw_sp,
 
 const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops = {
 	.init = mlxsw_sp2_span_init,
-	.buffsize_get = mlxsw_sp2_span_buffsize_get,
 	.policer_id_base_set = mlxsw_sp2_span_policer_id_base_set,
 };
 
-static u32 mlxsw_sp3_span_buffsize_get(int mtu, u32 speed)
-{
-	int factor = MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR;
-
-	return __mlxsw_sp_span_buffsize_get(mtu, speed, factor);
-}
-
 const struct mlxsw_sp_span_ops mlxsw_sp3_span_ops = {
 	.init = mlxsw_sp2_span_init,
-	.buffsize_get = mlxsw_sp3_span_buffsize_get,
 	.policer_id_base_set = mlxsw_sp2_span_policer_id_base_set,
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index 1c746dd3b1bd..d907718bc8c5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -47,7 +47,6 @@ struct mlxsw_sp_span_entry_ops;
 
 struct mlxsw_sp_span_ops {
 	int (*init)(struct mlxsw_sp *mlxsw_sp);
-	u32 (*buffsize_get)(int mtu, u32 speed);
 	int (*policer_id_base_set)(struct mlxsw_sp *mlxsw_sp,
 				   u16 policer_id_base);
 };
-- 
2.26.2

