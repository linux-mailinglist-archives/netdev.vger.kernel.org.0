Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECF033A4B4
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbhCNMU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:20:59 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:33307 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235333AbhCNMUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 08:20:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 67C5F5808B9;
        Sun, 14 Mar 2021 08:20:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 14 Mar 2021 08:20:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=iar19vXGJJ7TThUb8rFo3xOvrkRfvZHkKNmOYyRNCGs=; b=fBnl5kVP
        UAzBp++qaxlJklH6RwD78pdWr7zUOvwH9puYcw6MLFVSEgJyRYUMZmNB3j2QiJdM
        4JnyUAMWVViBCG6ZFKsDDbtup6KyFfjSntTyORwrugpMrMT1D7MDJ1p08kAihEYW
        I4vLLGuJiCa2NOwlDDbK5RbbGsRyiekWeZrxlBKBghkbcfHmFR6arCPtyM84vJo9
        mGDoniDVqvcLPUGm9J2+Mhj2KlLMorpR8/nElNzgEr0S7fcRyf3Ss/Aacp0kTaw4
        rF3mPRwbyz6oPBd93TPihGAcrbnTruZvKaJVQ1X9QMZ8xtX7pdPCypfJoaYLOu8N
        N7wWRIarnRhTHg==
X-ME-Sender: <xms:jv9NYCHIWv9GxIwN0lYmUgksNjKBjvv05o_CmxImsZuc-bbabjvTHg>
    <xme:jv9NYDX41q1aESeB8Xwucil6DRzalH-gbm3zI94H6qoI4ssiz0XUOF00wATgHuqV8
    AYlYT-HmZ7ZGkM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:jv9NYMKkw-XMMCo7QafhaMYptVrH2q8GQRnxjffhWBZZaAJpyq3vWA>
    <xmx:jv9NYMHeDv6W9u6z9MsOvH1ilfSWgRi3XRmVbbTTqNw2dyzh5_KCAw>
    <xmx:jv9NYIUCpnyeWbPFHg774k0lNlmOrVxw93VyKo3887BwHirTmozErQ>
    <xmx:jv9NYMpBjX2OM7_V-HaIy8WRFaxrx8Xi8GCmNm1gJJjA7Ylw17xQCA>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F0A0240054;
        Sun, 14 Mar 2021 08:20:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        yotam.gi@gmail.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/11] mlxsw: pci: Add more metadata fields to CQEv2
Date:   Sun, 14 Mar 2021 14:19:34 +0200
Message-Id: <20210314121940.2807621-6-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210314121940.2807621-1-idosch@idosch.org>
References: <20210314121940.2807621-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The Completion Queue Element version 2 (CQEv2) includes various metadata
fields for packets that are mirrored / sampled to the CPU.

Add these fields so that they could be used by a later patch.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h | 71 ++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index a2c1fbd3e0d1..7b531228d6c0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -173,6 +173,15 @@ MLXSW_ITEM32(pci, cqe, wqe_counter, 0x04, 16, 16);
  */
 MLXSW_ITEM32(pci, cqe, byte_count, 0x04, 0, 14);
 
+#define MLXSW_PCI_CQE2_MIRROR_CONG_INVALID	0xFFFF
+
+/* pci_cqe_mirror_cong_high
+ * Congestion level in units of 8KB of the egress traffic class of the original
+ * packet that does mirroring to the CPU. Value of 0xFFFF means that the
+ * congestion level is invalid.
+ */
+MLXSW_ITEM32(pci, cqe2, mirror_cong_high, 0x08, 16, 4);
+
 /* pci_cqe_trap_id
  * Trap ID that captured the packet.
  */
@@ -208,6 +217,59 @@ MLXSW_ITEM32(pci, cqe0, dqn, 0x0C, 1, 5);
 MLXSW_ITEM32(pci, cqe12, dqn, 0x0C, 1, 6);
 mlxsw_pci_cqe_item_helpers(dqn, 0, 12, 12);
 
+#define MLXSW_PCI_CQE2_MIRROR_TCLASS_INVALID	0x1F
+
+/* pci_cqe_mirror_tclass
+ * The egress traffic class of the original packet that does mirroring to the
+ * CPU. Value of 0x1F means that the traffic class is invalid.
+ */
+MLXSW_ITEM32(pci, cqe2, mirror_tclass, 0x10, 27, 5);
+
+/* pci_cqe_tx_lag
+ * The Tx port of a packet that is mirrored / sampled to the CPU is a LAG.
+ */
+MLXSW_ITEM32(pci, cqe2, tx_lag, 0x10, 24, 1);
+
+/* pci_cqe_tx_lag_subport
+ * The port index within the LAG of a packet that is mirrored / sampled to the
+ * CPU. Reserved when tx_lag is 0.
+ */
+MLXSW_ITEM32(pci, cqe2, tx_lag_subport, 0x10, 16, 8);
+
+#define MLXSW_PCI_CQE2_TX_PORT_MULTI_PORT	0xFFFE
+#define MLXSW_PCI_CQE2_TX_PORT_INVALID		0xFFFF
+
+/* pci_cqe_tx_lag_id
+ * The Tx LAG ID of the original packet that is mirrored / sampled to the CPU.
+ * Value of 0xFFFE means multi-port. Value fo 0xFFFF means that the Tx LAG ID
+ * is invalid. Reserved when tx_lag is 0.
+ */
+MLXSW_ITEM32(pci, cqe2, tx_lag_id, 0x10, 0, 16);
+
+/* pci_cqe_tx_system_port
+ * The Tx port of the original packet that is mirrored / sampled to the CPU.
+ * Value of 0xFFFE means multi-port. Value fo 0xFFFF means that the Tx port is
+ * invalid. Reserved when tx_lag is 1.
+ */
+MLXSW_ITEM32(pci, cqe2, tx_system_port, 0x10, 0, 16);
+
+/* pci_cqe_mirror_cong_low
+ * Congestion level in units of 8KB of the egress traffic class of the original
+ * packet that does mirroring to the CPU. Value of 0xFFFF means that the
+ * congestion level is invalid.
+ */
+MLXSW_ITEM32(pci, cqe2, mirror_cong_low, 0x14, 20, 12);
+
+#define MLXSW_PCI_CQE2_MIRROR_CONG_SHIFT	13	/* Units of 8KB. */
+
+static inline u16 mlxsw_pci_cqe2_mirror_cong_get(const char *cqe)
+{
+	u16 cong_high = mlxsw_pci_cqe2_mirror_cong_high_get(cqe);
+	u16 cong_low = mlxsw_pci_cqe2_mirror_cong_low_get(cqe);
+
+	return cong_high << 12 | cong_low;
+}
+
 /* pci_cqe_user_def_val_orig_pkt_len
  * When trap_id is an ACL: User defined value from policy engine action.
  */
@@ -218,6 +280,15 @@ MLXSW_ITEM32(pci, cqe2, user_def_val_orig_pkt_len, 0x14, 0, 20);
  */
 MLXSW_ITEM32(pci, cqe2, mirror_reason, 0x18, 24, 8);
 
+#define MLXSW_PCI_CQE2_MIRROR_LATENCY_INVALID	0xFFFFFF
+
+/* pci_cqe_mirror_latency
+ * End-to-end latency of the original packet that does mirroring to the CPU.
+ * Value of 0xFFFFFF means that the latency is invalid. Units are according to
+ * MOGCR.mirror_latency_units.
+ */
+MLXSW_ITEM32(pci, cqe2, mirror_latency, 0x1C, 8, 24);
+
 /* pci_cqe_owner
  * Ownership bit.
  */
-- 
2.29.2

