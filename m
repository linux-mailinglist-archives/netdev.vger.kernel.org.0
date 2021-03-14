Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4087433A4B9
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbhCNMVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:21:18 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:59113 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235316AbhCNMUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 08:20:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 823365808BB;
        Sun, 14 Mar 2021 08:20:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 14 Mar 2021 08:20:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=VQ7IRp8qPYIe2mooX2gI/F5Fsb59LCT+B42Xj9gi28I=; b=UTeVj1Tj
        3QN3DsYiW8JASnAGjEug1exieVJSw77+jXyXHAOtrA0psQP7ihVm4ZgVy9ky9Kxv
        kmitMc32WemcWwcsYqiojCGDSCbwLO/KxxCY5r6Hn+NKv3yj8ZYXRahl1bBGFdqB
        SBE0eniQETbNLgP81PFTv36maTY94eE8FyLDJGGbFO2v1alTuR+PcclR+NaU2Lix
        N5n+yYEmQRtHnXL74/UUwbPPUVPvaV3rn1mFESW4syDgNDsNZk5EZcenirYjfzIw
        C4SBoeJayhn6fSU4Rq2wTKPdniKhFLEwq57aD1xQVKI8C2AqahZh+bvqPhOUJ1Hc
        pd80oBnGisUmEQ==
X-ME-Sender: <xms:nP9NYHJkjOxXjmSnCIXaqFakqAlAQIPNFC2dWW-xUJGmgBXDSLeWsw>
    <xme:nP9NYLJME5fskG7-WJa3OaRPJ3WWP0ZnXk-WfrBW4fGVn_5-aSQ3tr02LGuBilB2h
    f7pVg6bGps0nuM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:nP9NYPvrl7HCqqDJGxBsjs22xnongdjXERbUgQfuv02rfv9CZYv02Q>
    <xmx:nP9NYAZo-pXAV7unL8KimHbYKeGPchzV9Y9UvjKM8p8yrbeerkt7jw>
    <xmx:nP9NYOZy3yoecFYdH4m8r4TguNfxLF20UABlmm9O2iwNvjuEHk2e5Q>
    <xmx:nP9NYEPJ1Yzy7YbTd-yrlUOdgabUZIFZ-U3E0uOY2bxoqLuvq5_dDA>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 985B224005B;
        Sun, 14 Mar 2021 08:20:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        yotam.gi@gmail.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/11] mlxsw: spectrum: Report extra metadata to psample module
Date:   Sun, 14 Mar 2021 14:19:39 +0200
Message-Id: <20210314121940.2807621-11-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210314121940.2807621-1-idosch@idosch.org>
References: <20210314121940.2807621-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Make use of the previously added metadata and report it to the psample
module. The metadata is read from the skb's control block, which was
initialized by the bus driver (i.e., 'mlxsw_pci') after decoding the
packet's Completion Queue Element (CQE).

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 54 ++++++++++++++++++-
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index ea01047f8f8f..056201029ce5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -204,6 +204,55 @@ static void mlxsw_sp_rx_ptp_listener(struct sk_buff *skb, u8 local_port,
 	mlxsw_sp_ptp_receive(mlxsw_sp, skb, local_port);
 }
 
+static struct mlxsw_sp_port *
+mlxsw_sp_sample_tx_port_get(struct mlxsw_sp *mlxsw_sp,
+			    const struct mlxsw_rx_md_info *rx_md_info)
+{
+	u8 local_port;
+
+	if (!rx_md_info->tx_port_valid)
+		return NULL;
+
+	if (rx_md_info->tx_port_is_lag)
+		local_port = mlxsw_core_lag_mapping_get(mlxsw_sp->core,
+							rx_md_info->tx_lag_id,
+							rx_md_info->tx_lag_port_index);
+	else
+		local_port = rx_md_info->tx_sys_port;
+
+	if (local_port >= mlxsw_core_max_ports(mlxsw_sp->core))
+		return NULL;
+
+	return mlxsw_sp->ports[local_port];
+}
+
+/* The latency units are determined according to MOGCR.mirror_latency_units. It
+ * defaults to 64 nanoseconds.
+ */
+#define MLXSW_SP_MIRROR_LATENCY_SHIFT	6
+
+static void mlxsw_sp_psample_md_init(struct mlxsw_sp *mlxsw_sp,
+				     struct psample_metadata *md,
+				     struct sk_buff *skb, int in_ifindex,
+				     bool truncate, u32 trunc_size)
+{
+	struct mlxsw_rx_md_info *rx_md_info = &mlxsw_skb_cb(skb)->rx_md_info;
+	struct mlxsw_sp_port *mlxsw_sp_port;
+
+	md->trunc_size = truncate ? trunc_size : skb->len;
+	md->in_ifindex = in_ifindex;
+	mlxsw_sp_port = mlxsw_sp_sample_tx_port_get(mlxsw_sp, rx_md_info);
+	md->out_ifindex = mlxsw_sp_port && mlxsw_sp_port->dev ?
+			  mlxsw_sp_port->dev->ifindex : 0;
+	md->out_tc_valid = rx_md_info->tx_tc_valid;
+	md->out_tc = rx_md_info->tx_tc;
+	md->out_tc_occ_valid = rx_md_info->tx_congestion_valid;
+	md->out_tc_occ = rx_md_info->tx_congestion;
+	md->latency_valid = rx_md_info->latency_valid;
+	md->latency = rx_md_info->latency;
+	md->latency <<= MLXSW_SP_MIRROR_LATENCY_SHIFT;
+}
+
 static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
 					void *trap_ctx)
 {
@@ -229,8 +278,9 @@ static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
 	 * Ethernet header.
 	 */
 	skb_push(skb, ETH_HLEN);
-	md.trunc_size = sample->truncate ? sample->trunc_size : skb->len;
-	md.in_ifindex = mlxsw_sp_port->dev->ifindex;
+	mlxsw_sp_psample_md_init(mlxsw_sp, &md, skb,
+				 mlxsw_sp_port->dev->ifindex, sample->truncate,
+				 sample->trunc_size);
 	psample_sample_packet(sample->psample_group, skb, sample->rate, &md);
 out:
 	consume_skb(skb);
-- 
2.29.2

