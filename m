Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885A721B756
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgGJN6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:58:14 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:56311 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727978AbgGJN6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:58:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id DE3EA58058B;
        Fri, 10 Jul 2020 09:58:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:58:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=jypGJqlTwa6i2+3TSVNnr/M4gVm8qopOLYOV+XniFMk=; b=pbPUGjV5
        f2DTmxmQMPs1+xj3bJuEIYix/E61hSM2EJ0cJlUabBGXCSml5VBrFSEEpNIlbQGl
        St16Qs0926Rr7ZWRQpHrvxEvbCEFV760J3TG7RUXMJkFYhKo7szGk6CpGCXyT3Rt
        ztYTK67ayio+PrmRZq80wTQaI/rwKSylgwWFWFUO1kcRPhs/+MmCssR071GAk3dh
        TrNUhOZ6E74GbAwjbEfGTCBPQKXFcchLdUxx7wF0bjF/1ZSbp0YaC4r/XewaSoc6
        H89jtIUOKRz26fs6dytcctHWCqd6NIr76c8mVqnSyKMo1/gPFfGLNRjRyQQtcgEY
        sntzaMjSdP4JIg==
X-ME-Sender: <xms:8nMIXxzuJ5hCdNi5iXGuCoxN_xE2s1UnDK_kZTI-Cj85zAkavM_-jg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:8nMIXxSms7rUc8PdygNgYv96fW0Y8y7pxmLYV8LMh_ldvGNTQookrg>
    <xmx:8nMIX7UGhE8DX1GvroCJi791BxQObr_o6NoTcDdulc-6bZ9cJhl10g>
    <xmx:8nMIXzjl_OLUFFT763R30V8oPe9sBfKgjySsy0G7TSRVsg2gjntgjA>
    <xmx:8nMIXwKBBgJUkIqaBSpbHyk6t3cb9Kfv2bwZeIALdpX6B0QEw6tm4Q>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5D977328005D;
        Fri, 10 Jul 2020 09:58:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/13] mlxsw: spectrum_span: Move SPAN operations out of global file
Date:   Fri, 10 Jul 2020 16:56:57 +0300
Message-Id: <20200710135706.601409-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710135706.601409-1-idosch@idosch.org>
References: <20200710135706.601409-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The per-ASIC SPAN operations are relevant to the SPAN module and
therefore should be implemented there and not in the main driver file.
Move them.

These operations will be extended later on.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 50 -------------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 -
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 47 +++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  8 +++
 4 files changed, 55 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index eeeafd1d82ce..636dd09cbbbc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -175,10 +175,6 @@ struct mlxsw_sp_mlxfw_dev {
 	struct mlxsw_sp *mlxsw_sp;
 };
 
-struct mlxsw_sp_span_ops {
-	u32 (*buffsize_get)(int mtu, u32 speed);
-};
-
 static int mlxsw_sp_component_query(struct mlxfw_dev *mlxfw_dev,
 				    u16 component_index, u32 *p_max_size,
 				    u8 *p_align_bits, u16 *p_max_write_size)
@@ -2812,52 +2808,6 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
 	.get_stats	= mlxsw_sp2_get_stats,
 };
 
-static u32 mlxsw_sp1_span_buffsize_get(int mtu, u32 speed)
-{
-	return mtu * 5 / 2;
-}
-
-static const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops = {
-	.buffsize_get = mlxsw_sp1_span_buffsize_get,
-};
-
-#define MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR 38
-#define MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR 50
-
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
-static const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops = {
-	.buffsize_get = mlxsw_sp2_span_buffsize_get,
-};
-
-static u32 mlxsw_sp3_span_buffsize_get(int mtu, u32 speed)
-{
-	int factor = MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR;
-
-	return __mlxsw_sp_span_buffsize_get(mtu, speed, factor);
-}
-
-static const struct mlxsw_sp_span_ops mlxsw_sp3_span_ops = {
-	.buffsize_get = mlxsw_sp3_span_buffsize_get,
-};
-
-u32 mlxsw_sp_span_buffsize_get(struct mlxsw_sp *mlxsw_sp, int mtu, u32 speed)
-{
-	u32 buffsize = mlxsw_sp->span_ops->buffsize_get(speed, mtu);
-
-	return mlxsw_sp_bytes_cells(mlxsw_sp, buffsize) + 1;
-}
-
 static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
 				    unsigned long event, void *ptr);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 1d6b2bc2774c..18c64f7b265d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -539,7 +539,6 @@ int mlxsw_sp_flow_counter_alloc(struct mlxsw_sp *mlxsw_sp,
 				unsigned int *p_counter_index);
 void mlxsw_sp_flow_counter_free(struct mlxsw_sp *mlxsw_sp,
 				unsigned int counter_index);
-u32 mlxsw_sp_span_buffsize_get(struct mlxsw_sp *mlxsw_sp, int mtu, u32 speed);
 bool mlxsw_sp_port_dev_check(const struct net_device *dev);
 struct mlxsw_sp *mlxsw_sp_lower_get(struct net_device *dev);
 struct mlxsw_sp_port *mlxsw_sp_port_dev_lower_find(struct net_device *dev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 92351a79addc..49e2a417ec0e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -766,6 +766,14 @@ static int mlxsw_sp_span_entry_put(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
+static u32 mlxsw_sp_span_buffsize_get(struct mlxsw_sp *mlxsw_sp, int mtu,
+				      u32 speed)
+{
+	u32 buffsize = mlxsw_sp->span_ops->buffsize_get(speed, mtu);
+
+	return mlxsw_sp_bytes_cells(mlxsw_sp, buffsize) + 1;
+}
+
 static int
 mlxsw_sp_span_port_buffer_update(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
 {
@@ -1207,3 +1215,42 @@ void mlxsw_sp_span_agent_unbind(struct mlxsw_sp *mlxsw_sp,
 
 	mlxsw_sp_span_trigger_entry_destroy(mlxsw_sp->span, trigger_entry);
 }
+
+static u32 mlxsw_sp1_span_buffsize_get(int mtu, u32 speed)
+{
+	return mtu * 5 / 2;
+}
+
+const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops = {
+	.buffsize_get = mlxsw_sp1_span_buffsize_get,
+};
+
+#define MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR 38
+#define MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR 50
+
+static u32 __mlxsw_sp_span_buffsize_get(int mtu, u32 speed, u32 buffer_factor)
+{
+	return 3 * mtu + buffer_factor * speed / 1000;
+}
+
+static u32 mlxsw_sp2_span_buffsize_get(int mtu, u32 speed)
+{
+	int factor = MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR;
+
+	return __mlxsw_sp_span_buffsize_get(mtu, speed, factor);
+}
+
+const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops = {
+	.buffsize_get = mlxsw_sp2_span_buffsize_get,
+};
+
+static u32 mlxsw_sp3_span_buffsize_get(int mtu, u32 speed)
+{
+	int factor = MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR;
+
+	return __mlxsw_sp_span_buffsize_get(mtu, speed, factor);
+}
+
+const struct mlxsw_sp_span_ops mlxsw_sp3_span_ops = {
+	.buffsize_get = mlxsw_sp3_span_buffsize_get,
+};
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index 9f6dd2d0f4e6..440551ec0dba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -34,6 +34,10 @@ struct mlxsw_sp_span_trigger_parms {
 
 struct mlxsw_sp_span_entry_ops;
 
+struct mlxsw_sp_span_ops {
+	u32 (*buffsize_get)(int mtu, u32 speed);
+};
+
 struct mlxsw_sp_span_entry {
 	const struct net_device *to_dev;
 	const struct mlxsw_sp_span_entry_ops *ops;
@@ -82,4 +86,8 @@ mlxsw_sp_span_agent_unbind(struct mlxsw_sp *mlxsw_sp,
 			   struct mlxsw_sp_port *mlxsw_sp_port,
 			   const struct mlxsw_sp_span_trigger_parms *parms);
 
+extern const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops;
+extern const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops;
+extern const struct mlxsw_sp_span_ops mlxsw_sp3_span_ops;
+
 #endif
-- 
2.26.2

