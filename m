Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51CCF33A4B6
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbhCNMVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:21:04 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:45411 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235337AbhCNMUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 08:20:36 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2811B5808BA;
        Sun, 14 Mar 2021 08:20:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 14 Mar 2021 08:20:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=bSyGpH3xegcA2rNiCejlEsiwHm1PVJh4xvsr4U2wmYk=; b=c8t4Ux1h
        UnNT30PA7imwWM7JE3UYoEI4Dtv+WAxdXmnx5bfLBsmTzzV4tvIEF02f+UtA0YLR
        FEcBNvlDva4XZvbrO730RN4tZIwz3i920BWbo39TY8QYO/3/dcytCvOeZd3uYgUo
        rrmwNjA1I00md5rdlsnRJKDy4MVYV7O10Myt6k3gdRpB2LjFOG7rHlbeL0GjIBLe
        WluI6nq+4mkB4XoXPwPJh3+VkF9NBYMtWbHvhz2+OpgS4wT/NAX6aP30JU5yTAjy
        jnIgdJyXH3uFelzAhfR8MKMJxTtH3VovqRj+bPrP8FQ9E9wVyQRNkCCaSTdECFkn
        ekpQCkFt5wlZKg==
X-ME-Sender: <xms:lP9NYHM2N1CqKxUFN4oQZU9WXWDWh8a0jyC9caw4xA1pJrZ3a6XAjg>
    <xme:lP9NYB-dZ_Y-q1C0HFaiNxtVNUfO-RCa_UQhURsu6wSU1DC5jJOH7jZvs8VM6Zv0Y
    8k2WSzA-c5Mj_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:lP9NYGQYPLOP3yCIHo40yEYuAnSTj33UkmpmHXGyXp6RWJ7vgwqJ3A>
    <xmx:lP9NYLumk8f9APHYbKnr9_ZRp2zBvOnchTSFg6Q4xLFKhUe02aItvg>
    <xmx:lP9NYPfDUbxW8wPOj145Kiw6xCrqETEppkrrFbfxgEGscKm9UgTyNA>
    <xmx:lP9NYOzhcb8E6CqhJdZTMLjFYdxoWl_ylemTFnhVWt5EkMjdjaGc3Q>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 69A8A240054;
        Sun, 14 Mar 2021 08:20:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        yotam.gi@gmail.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/11] mlxsw: pci: Set extra metadata in skb control block
Date:   Sun, 14 Mar 2021 14:19:36 +0200
Message-Id: <20210314121940.2807621-8-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210314121940.2807621-1-idosch@idosch.org>
References: <20210314121940.2807621-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Packets that are mirrored / sampled to the CPU have extra metadata
encoded in their corresponding Completion Queue Element (CQE). Retrieve
this metadata from the CQE and set it in the skb control block so that
it could be accessed by the switch driver (i.e., 'mlxsw_spectrum').

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h | 15 ++++++
 drivers/net/ethernet/mellanox/mlxsw/pci.c  | 53 ++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 86adc17c8901..80712dc803d0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -60,6 +60,21 @@ struct mlxsw_tx_info {
 
 struct mlxsw_rx_md_info {
 	u32 cookie_index;
+	u32 latency;
+	u32 tx_congestion;
+	union {
+		/* Valid when 'tx_port_valid' is set. */
+		u16 tx_sys_port;
+		u16 tx_lag_id;
+	};
+	u8 tx_lag_port_index; /* Valid when 'tx_port_is_lag' is set. */
+	u8 tx_tc;
+	u8 latency_valid:1,
+	   tx_congestion_valid:1,
+	   tx_tc_valid:1,
+	   tx_port_valid:1,
+	   tx_port_is_lag:1,
+	   unused:3;
 };
 
 bool mlxsw_core_skb_transmit_busy(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 8eee8b3c675e..8e8456811384 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -540,6 +540,55 @@ static void mlxsw_pci_cqe_sdq_handle(struct mlxsw_pci *mlxsw_pci,
 	spin_unlock(&q->lock);
 }
 
+static void mlxsw_pci_cqe_rdq_md_tx_port_init(struct sk_buff *skb,
+					      const char *cqe)
+{
+	struct mlxsw_skb_cb *cb = mlxsw_skb_cb(skb);
+
+	if (mlxsw_pci_cqe2_tx_lag_get(cqe)) {
+		cb->rx_md_info.tx_port_is_lag = true;
+		cb->rx_md_info.tx_lag_id = mlxsw_pci_cqe2_tx_lag_id_get(cqe);
+		cb->rx_md_info.tx_lag_port_index =
+			mlxsw_pci_cqe2_tx_lag_subport_get(cqe);
+	} else {
+		cb->rx_md_info.tx_port_is_lag = false;
+		cb->rx_md_info.tx_sys_port =
+			mlxsw_pci_cqe2_tx_system_port_get(cqe);
+	}
+
+	if (cb->rx_md_info.tx_sys_port != MLXSW_PCI_CQE2_TX_PORT_MULTI_PORT &&
+	    cb->rx_md_info.tx_sys_port != MLXSW_PCI_CQE2_TX_PORT_INVALID)
+		cb->rx_md_info.tx_port_valid = 1;
+	else
+		cb->rx_md_info.tx_port_valid = 0;
+}
+
+static void mlxsw_pci_cqe_rdq_md_init(struct sk_buff *skb, const char *cqe)
+{
+	struct mlxsw_skb_cb *cb = mlxsw_skb_cb(skb);
+
+	cb->rx_md_info.tx_congestion = mlxsw_pci_cqe2_mirror_cong_get(cqe);
+	if (cb->rx_md_info.tx_congestion != MLXSW_PCI_CQE2_MIRROR_CONG_INVALID)
+		cb->rx_md_info.tx_congestion_valid = 1;
+	else
+		cb->rx_md_info.tx_congestion_valid = 0;
+	cb->rx_md_info.tx_congestion <<= MLXSW_PCI_CQE2_MIRROR_CONG_SHIFT;
+
+	cb->rx_md_info.latency = mlxsw_pci_cqe2_mirror_latency_get(cqe);
+	if (cb->rx_md_info.latency != MLXSW_PCI_CQE2_MIRROR_LATENCY_INVALID)
+		cb->rx_md_info.latency_valid = 1;
+	else
+		cb->rx_md_info.latency_valid = 0;
+
+	cb->rx_md_info.tx_tc = mlxsw_pci_cqe2_mirror_tclass_get(cqe);
+	if (cb->rx_md_info.tx_tc != MLXSW_PCI_CQE2_MIRROR_TCLASS_INVALID)
+		cb->rx_md_info.tx_tc_valid = 1;
+	else
+		cb->rx_md_info.tx_tc_valid = 0;
+
+	mlxsw_pci_cqe_rdq_md_tx_port_init(skb, cqe);
+}
+
 static void mlxsw_pci_cqe_rdq_handle(struct mlxsw_pci *mlxsw_pci,
 				     struct mlxsw_pci_queue *q,
 				     u16 consumer_counter_limit,
@@ -586,6 +635,10 @@ static void mlxsw_pci_cqe_rdq_handle(struct mlxsw_pci *mlxsw_pci,
 		   rx_info.trap_id <= MLXSW_TRAP_ID_MIRROR_SESSION7 &&
 		   mlxsw_pci->max_cqe_ver >= MLXSW_PCI_CQE_V2) {
 		rx_info.mirror_reason = mlxsw_pci_cqe2_mirror_reason_get(cqe);
+		mlxsw_pci_cqe_rdq_md_init(skb, cqe);
+	} else if (rx_info.trap_id == MLXSW_TRAP_ID_PKT_SAMPLE &&
+		   mlxsw_pci->max_cqe_ver >= MLXSW_PCI_CQE_V2) {
+		mlxsw_pci_cqe_rdq_md_tx_port_init(skb, cqe);
 	}
 
 	byte_count = mlxsw_pci_cqe_byte_count_get(cqe);
-- 
2.29.2

