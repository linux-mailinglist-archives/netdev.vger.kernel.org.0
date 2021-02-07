Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7213122BC
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhBGIbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:31:43 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:47851 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230183AbhBGI1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:27:50 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id B45E25801E4;
        Sun,  7 Feb 2021 03:23:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Feb 2021 03:23:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=CBISyTe1Zub/yUTLGj3lYAi0JyzPCpjZBhfK4lgEmRA=; b=ZiH9EOFw
        EOY+MD2ONEUre2Je75fTZEsHAsr0ESUOnBVMi2KvYsyivhM637/8NLaYmhAYi1Cn
        FYJPtUiyx3gNYNmq6FZ3BLbAuGxDwgfp/0jTn/9n/+GMSn+kZ61CK1rOdP8ev0M4
        +eCV+9215R0ReiOmFF9M98rHA2dezGiI0ZELrmpDNPneA+kkPfHq9CZluypNde/+
        mM4x8RyeFc3UbuYJUpmFH4V650+EeFN+6gi+ABwaK4DWd7h64ULNbWqzkjaj4S6M
        5qMrddbhXa2/GejcXk2JhjLCsm9sk4WCYCAzgg9nSwxLE8gPCJZtDatIgFBzS3fz
        OOKjkJ1u52tWAw==
X-ME-Sender: <xms:mqMfYIAmmW9DFfIRAD1bSDqi4SU6-kQmWJPbQ-i_vVwHuYe6S4fo1Q>
    <xme:mqMfYKiAwuLCBRIH6ktgMXIsJJvqFxEB8sQ2QPKL0Tb-aFG7Qjq6Oosk7FYJ43Wa0
    3OM2cslfJFXz4Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedtgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:mqMfYLkPqI5wrH_O3gGPAM3qNGBxZFH0nJJ5dM9ZtnqiGZkiqTpqPw>
    <xmx:mqMfYOxTHu3V6Sr8tF2kUZEl89x34_hv16BAstQRpqAbgqPofoIGAg>
    <xmx:mqMfYNSHI3eQKnh11ib3yrVmLOaqNbdA1HChftHbbGFUq3AYTuJiIw>
    <xmx:mqMfYIFYTkBT65orx1KKWT8XqKzUdq18lA-daTOQTMkpObTJtUoq1A>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id B87F81080057;
        Sun,  7 Feb 2021 03:23:52 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, yoshfuji@linux-ipv6.org, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/10] mlxsw: spectrum_router: Set offload_failed flag
Date:   Sun,  7 Feb 2021 10:22:57 +0200
Message-Id: <20210207082258.3872086-10-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210207082258.3872086-1-idosch@idosch.org>
References: <20210207082258.3872086-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

When FIB_EVENT_ENTRY_{REPLACE, APPEND} are triggered and route insertion
fails, FIB abort is triggered.

After aborting, set the appropriate hardware flag to make the kernel emit
RTM_NEWROUTE notification with RTM_F_OFFLOAD_FAILED flag.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index a5f980b6940e..9ce90841f92d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4942,6 +4942,25 @@ mlxsw_sp_rt6_nexthop(struct mlxsw_sp_nexthop_group *nh_grp,
 	return NULL;
 }
 
+static void
+mlxsw_sp_fib4_offload_failed_flag_set(struct mlxsw_sp *mlxsw_sp,
+				      struct fib_entry_notifier_info *fen_info)
+{
+	u32 *p_dst = (u32 *) &fen_info->dst;
+	struct fib_rt_info fri;
+
+	fri.fi = fen_info->fi;
+	fri.tb_id = fen_info->tb_id;
+	fri.dst = cpu_to_be32(*p_dst);
+	fri.dst_len = fen_info->dst_len;
+	fri.tos = fen_info->tos;
+	fri.type = fen_info->type;
+	fri.offload = false;
+	fri.trap = false;
+	fri.offload_failed = true;
+	fib_alias_hw_flags_set(mlxsw_sp_net(mlxsw_sp), &fri);
+}
+
 static void
 mlxsw_sp_fib4_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_fib_entry *fib_entry)
@@ -4990,6 +5009,30 @@ mlxsw_sp_fib4_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 	fib_alias_hw_flags_set(mlxsw_sp_net(mlxsw_sp), &fri);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static void
+mlxsw_sp_fib6_offload_failed_flag_set(struct mlxsw_sp *mlxsw_sp,
+				      struct fib6_info **rt_arr,
+				      unsigned int nrt6)
+{
+	int i;
+
+	/* In IPv6 a multipath route is represented using multiple routes, so
+	 * we need to set the flags on all of them.
+	 */
+	for (i = 0; i < nrt6; i++)
+		fib6_info_hw_flags_set(mlxsw_sp_net(mlxsw_sp), rt_arr[i],
+				       false, false, true);
+}
+#else
+static void
+mlxsw_sp_fib6_offload_failed_flag_set(struct mlxsw_sp *mlxsw_sp,
+				      struct fib6_info **rt_arr,
+				      unsigned int nrt6)
+{
+}
+#endif
+
 #if IS_ENABLED(CONFIG_IPV6)
 static void
 mlxsw_sp_fib6_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
@@ -7023,6 +7066,8 @@ static void mlxsw_sp_router_fib4_event_process(struct mlxsw_sp *mlxsw_sp,
 		if (err) {
 			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
+			mlxsw_sp_fib4_offload_failed_flag_set(mlxsw_sp,
+							      &fib_event->fen_info);
 		}
 		fib_info_put(fib_event->fen_info.fi);
 		break;
@@ -7044,6 +7089,7 @@ static void mlxsw_sp_router_fib6_event_process(struct mlxsw_sp *mlxsw_sp,
 					       struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					       struct mlxsw_sp_fib_event *fib_event)
 {
+	struct mlxsw_sp_fib6_event *fib6_event = &fib_event->fib6_event;
 	int err;
 
 	mlxsw_sp_span_respin(mlxsw_sp);
@@ -7055,6 +7101,9 @@ static void mlxsw_sp_router_fib6_event_process(struct mlxsw_sp *mlxsw_sp,
 		if (err) {
 			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
+			mlxsw_sp_fib6_offload_failed_flag_set(mlxsw_sp,
+							      fib6_event->rt_arr,
+							      fib6_event->nrt6);
 		}
 		mlxsw_sp_router_fib6_event_fini(&fib_event->fib6_event);
 		break;
@@ -7064,6 +7113,9 @@ static void mlxsw_sp_router_fib6_event_process(struct mlxsw_sp *mlxsw_sp,
 		if (err) {
 			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
+			mlxsw_sp_fib6_offload_failed_flag_set(mlxsw_sp,
+							      fib6_event->rt_arr,
+							      fib6_event->nrt6);
 		}
 		mlxsw_sp_router_fib6_event_fini(&fib_event->fib6_event);
 		break;
-- 
2.29.2

