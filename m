Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A559233D66C
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237740AbhCPPEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:04:51 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33331 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237695AbhCPPEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:04:14 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 183665C012C;
        Tue, 16 Mar 2021 11:04:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 16 Mar 2021 11:04:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=xxQLj6tk7zTm/Ou1Z8xXQddmXEjL9QctQe/KXv9s1lo=; b=oUYjl++/
        glZqoGsGgPAaAqs7HrWXpMhaqKP5NcBoK+tuJEiNCCOu99mTDig3Ycihtk1CnpLk
        Uujui81H5jqNZY0HXvIASgRVhasfK+3gLpx20lF503utxrJX5qcgM3HBFcSjVKuw
        2l3D7ANVfAlqH84z/ZC71rLxtVzm/me+nZS4/s9JtkeRvzNvojUrTnHLBuJBb4SQ
        WVscHHl7HqaHGiH3AJm2gK3fjhmfdGkbrfkpfrn+1d4MxjbWbhPZFkIuN1qPS112
        Zp6+sxiOOiMMUebBbZ30scaQeSDdvSPDFRI5gzAeZzzBUTQSfWUmZ6ADyh2V2zZV
        5l3QCKURoFxp7Q==
X-ME-Sender: <xms:7chQYNxtCxk9IV3ooptx1NhiqAIUiJHujU4vtB8nUzkjeWgmAci6XQ>
    <xme:7chQYNSKV0UdCAYjmv0H6x1fZwcKyJ7wBXbR2SuW_h0dMo3dcumv4xgir3HUfK0ZQ
    aB01HlKR0w7tYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:7chQYHXs0Pc8WdyShP4qzf2Sl0Jkxai5QAFY0rjmtINxt3moec_WEA>
    <xmx:7chQYPg3Je9h_OZhk1ep43gGph5o8E2_7bZrETVQonAzftSYXd9a3g>
    <xmx:7chQYPBoBSjofgJ3FoCxAly3bf5_UEf3T1UlHxsg0vQ_e1RhT0dkNQ>
    <xmx:7shQYK6ncHtCIJuuq3DwXFDDoRG0owi3RWI_lWFT9-0Ixsq7t3Vppg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id D15C11080057;
        Tue, 16 Mar 2021 11:04:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/10] mlxsw: spectrum_matchall: Add support for egress sampling
Date:   Tue, 16 Mar 2021 17:02:59 +0200
Message-Id: <20210316150303.2868588-7-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316150303.2868588-1-idosch@idosch.org>
References: <20210316150303.2868588-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Allow user space to install a matchall classifier with sample action on
egress. This is only supported on Spectrum-2 onwards, so Spectrum-1 will
continue to return an error.

Programming the hardware to sample on egress is identical to ingress
sampling with the sole change of using a different sampling trigger.

Upon receiving a sampled packet, the sampling trigger (ingress vs.
egress) will be encoded in the mirroring reason in the Completion Queue
Element (CQE). The mirroring reason is used to lookup the sampling
parameters (e.g., psample group) which are passed to the psample module.

Note that locally generated packets that are sampled are simply
consumed. This is done for several reasons.

First, such packets do not have an ingress netdev given that their Rx
local port is the CPU port. This breaks several basic assumptions.

Second, sampling using the same interface (tc), but with flower
classifier will not result in locally generated packets being sampled
given that such packets are not subject to the policy engine.

Third, realistically, this is not a big deal given that the vast
majority of the packets being transmitted through the port are not
locally generated packets.

Fourth, if such packets do need to be sampled, they can be sampled with
a 'skip_hw' filter and reported to the same sampling group as the data
path packets. The software sampling rate can also be adjusted to fit the
rate of the locally generated packets which is much lower than the rate
of the data path traffic.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_matchall.c        | 26 +++++----
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 55 +++++++++++++++++++
 2 files changed, 69 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index 459c452b60ba..ce58a795c6fc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -417,13 +417,9 @@ static int mlxsw_sp2_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 		.session_id = MLXSW_SP_SPAN_SESSION_ID_SAMPLING,
 	};
 	u32 rate = mall_entry->sample.params.rate;
+	enum mlxsw_sp_span_trigger span_trigger;
 	int err;
 
-	if (!mall_entry->ingress) {
-		NL_SET_ERR_MSG(extack, "Sampling is not supported on egress");
-		return -EOPNOTSUPP;
-	}
-
 	err = mlxsw_sp_span_agent_get(mlxsw_sp, &mall_entry->sample.span_id,
 				      &agent_parms);
 	if (err) {
@@ -431,16 +427,19 @@ static int mlxsw_sp2_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 		return err;
 	}
 
-	err = mlxsw_sp_span_analyzed_port_get(mlxsw_sp_port, true);
+	err = mlxsw_sp_span_analyzed_port_get(mlxsw_sp_port,
+					      mall_entry->ingress);
 	if (err) {
 		NL_SET_ERR_MSG(extack, "Failed to get analyzed port");
 		goto err_analyzed_port_get;
 	}
 
+	span_trigger = mall_entry->ingress ? MLXSW_SP_SPAN_TRIGGER_INGRESS :
+					     MLXSW_SP_SPAN_TRIGGER_EGRESS;
 	trigger_parms.span_id = mall_entry->sample.span_id;
 	trigger_parms.probability_rate = rate;
-	err = mlxsw_sp_span_agent_bind(mlxsw_sp, MLXSW_SP_SPAN_TRIGGER_INGRESS,
-				       mlxsw_sp_port, &trigger_parms);
+	err = mlxsw_sp_span_agent_bind(mlxsw_sp, span_trigger, mlxsw_sp_port,
+				       &trigger_parms);
 	if (err) {
 		NL_SET_ERR_MSG(extack, "Failed to bind SPAN agent");
 		goto err_agent_bind;
@@ -449,7 +448,7 @@ static int mlxsw_sp2_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_agent_bind:
-	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, true);
+	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, mall_entry->ingress);
 err_analyzed_port_get:
 	mlxsw_sp_span_agent_put(mlxsw_sp, mall_entry->sample.span_id);
 	return err;
@@ -460,11 +459,14 @@ static void mlxsw_sp2_mall_sample_del(struct mlxsw_sp *mlxsw_sp,
 				      struct mlxsw_sp_mall_entry *mall_entry)
 {
 	struct mlxsw_sp_span_trigger_parms trigger_parms = {};
+	enum mlxsw_sp_span_trigger span_trigger;
 
+	span_trigger = mall_entry->ingress ? MLXSW_SP_SPAN_TRIGGER_INGRESS :
+					     MLXSW_SP_SPAN_TRIGGER_EGRESS;
 	trigger_parms.span_id = mall_entry->sample.span_id;
-	mlxsw_sp_span_agent_unbind(mlxsw_sp, MLXSW_SP_SPAN_TRIGGER_INGRESS,
-				   mlxsw_sp_port, &trigger_parms);
-	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, true);
+	mlxsw_sp_span_agent_unbind(mlxsw_sp, span_trigger, mlxsw_sp_port,
+				   &trigger_parms);
+	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, mall_entry->ingress);
 	mlxsw_sp_span_agent_put(mlxsw_sp, mall_entry->sample.span_id);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index db3c561ac3ea..3dbf5e53e9ff 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -53,6 +53,8 @@ enum {
 	MLXSW_SP_MIRROR_REASON_INGRESS = 1,
 	/* Packet was early dropped. */
 	MLXSW_SP_MIRROR_REASON_INGRESS_WRED = 9,
+	/* Packet was mirrored from egress. */
+	MLXSW_SP_MIRROR_REASON_EGRESS = 14,
 };
 
 static int mlxsw_sp_rx_listener(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
@@ -289,6 +291,56 @@ static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
 	consume_skb(skb);
 }
 
+static void mlxsw_sp_rx_sample_tx_listener(struct sk_buff *skb, u8 local_port,
+					   void *trap_ctx)
+{
+	struct mlxsw_rx_md_info *rx_md_info = &mlxsw_skb_cb(skb)->rx_md_info;
+	struct mlxsw_sp *mlxsw_sp = devlink_trap_ctx_priv(trap_ctx);
+	struct mlxsw_sp_port *mlxsw_sp_port, *mlxsw_sp_port_tx;
+	struct mlxsw_sp_sample_trigger trigger;
+	struct mlxsw_sp_sample_params *params;
+	struct psample_metadata md = {};
+	int err;
+
+	/* Locally generated packets are not reported from the policy engine
+	 * trigger, so do not report them from the egress trigger as well.
+	 */
+	if (local_port == MLXSW_PORT_CPU_PORT)
+		goto out;
+
+	err = __mlxsw_sp_rx_no_mark_listener(skb, local_port, trap_ctx);
+	if (err)
+		return;
+
+	mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	if (!mlxsw_sp_port)
+		goto out;
+
+	/* Packet was sampled from Tx, so we need to retrieve the sample
+	 * parameters based on the Tx port and not the Rx port.
+	 */
+	mlxsw_sp_port_tx = mlxsw_sp_sample_tx_port_get(mlxsw_sp, rx_md_info);
+	if (!mlxsw_sp_port_tx)
+		goto out;
+
+	trigger.type = MLXSW_SP_SAMPLE_TRIGGER_TYPE_EGRESS;
+	trigger.local_port = mlxsw_sp_port_tx->local_port;
+	params = mlxsw_sp_sample_trigger_params_lookup(mlxsw_sp, &trigger);
+	if (!params)
+		goto out;
+
+	/* The psample module expects skb->data to point to the start of the
+	 * Ethernet header.
+	 */
+	skb_push(skb, ETH_HLEN);
+	mlxsw_sp_psample_md_init(mlxsw_sp, &md, skb,
+				 mlxsw_sp_port->dev->ifindex, params->truncate,
+				 params->trunc_size);
+	psample_sample_packet(params->psample_group, skb, params->rate, &md);
+out:
+	consume_skb(skb);
+}
+
 #define MLXSW_SP_TRAP_DROP(_id, _group_id)				      \
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
 			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id,	      \
@@ -1843,6 +1895,9 @@ mlxsw_sp2_trap_items_arr[] = {
 			MLXSW_RXL_MIRROR(mlxsw_sp_rx_sample_listener, 1,
 					 SP_PKT_SAMPLE,
 					 MLXSW_SP_MIRROR_REASON_INGRESS),
+			MLXSW_RXL_MIRROR(mlxsw_sp_rx_sample_tx_listener, 1,
+					 SP_PKT_SAMPLE,
+					 MLXSW_SP_MIRROR_REASON_EGRESS),
 		},
 	},
 };
-- 
2.29.2

