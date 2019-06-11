Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE5223D136
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404124AbfFKPps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:45:48 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38113 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391803AbfFKPpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:45:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 31FCD222B8;
        Tue, 11 Jun 2019 11:45:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 11:45:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Nf9yLXH7/mgFgchLEh8P05j0SzXu8iIreKrjDSxjo6U=; b=C8jtj3er
        OMiYBcoHlqpjUfm6/mtWVMJS6BRhHNqCUr6dnMx2ZgUe65/u1rdBQ16LfS+GlwfI
        6Mq7wNnl6pSGqxaj+AhZ/GgnAnk5zXbt+1C1lQaAxzzZAAlm1g+nQkS48hDo/SHQ
        +xbu7Wa3effBFjbHbaRwksTJ70W2WsTKP5GEKMkls8rSdkx2zVrFuohByc5i/fEO
        y6w6oLyHy5KyFWnvGra8mi1lvMNm/yfZPycw9rraoZNrRkypyXKxRROPfkviyM73
        7xUuNvd/YjwrskQ6obUWAS7DD60w6S00Gh4a7L24C+EYODC7i3UuTZF9eIRWNU0c
        aLROJCbgtVs44A==
X-ME-Sender: <xms:qsz_XGiNIz6z6V__BWbFHk-aa2ylcdHOLLeh1FoMj-Q9FxyxwlZWDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehhedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:qsz_XPO5R84L07gC-NPNEV3T9dfavU8rlG_rQ-9SjNt4btPQTs2XuQ>
    <xmx:qsz_XGIqQ05hdkYu77LatGxERi08fzg_N2c6h0KeoilNhF0o-eNAsA>
    <xmx:qsz_XFZ-1b251tj08VTiHyuBEMO8hH_kw_BFk703RPvJ3JM79k98xw>
    <xmx:qsz_XPyPv5d-YoXWGd7QwftJTIjQcQkQbUtpg1f3Dkme0sjcTBKQQg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 57F1B38008A;
        Tue, 11 Jun 2019 11:45:44 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        petrm@mellanox.com, richardcochran@gmail.com, olteanv@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 3/9] mlxsw: pci: Query free running clock PCI BAR and offsets
Date:   Tue, 11 Jun 2019 18:45:06 +0300
Message-Id: <20190611154512.17650-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611154512.17650-1-idosch@idosch.org>
References: <20190611154512.17650-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Query free running clock PCI BAR and offsets during the pci_init.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c    | 32 ++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h |  3 ++
 2 files changed, 35 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index b40455f8293d..6acb9bbfdf89 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -102,6 +102,7 @@ struct mlxsw_pci_queue_type_group {
 struct mlxsw_pci {
 	struct pci_dev *pdev;
 	u8 __iomem *hw_addr;
+	u64 free_running_clock_offset;
 	struct mlxsw_pci_queue_type_group queues[MLXSW_PCI_QUEUE_TYPE_COUNT];
 	u32 doorbell_offset;
 	struct mlxsw_core *core;
@@ -1414,6 +1415,15 @@ static int mlxsw_pci_init(void *bus_priv, struct mlxsw_core *mlxsw_core,
 	mlxsw_pci->doorbell_offset =
 		mlxsw_cmd_mbox_query_fw_doorbell_page_offset_get(mbox);
 
+	if (mlxsw_cmd_mbox_query_fw_fr_rn_clk_bar_get(mbox) != 0) {
+		dev_err(&pdev->dev, "Unsupported free running clock BAR queried from hw\n");
+		err = -EINVAL;
+		goto err_fr_rn_clk_bar;
+	}
+
+	mlxsw_pci->free_running_clock_offset =
+		mlxsw_cmd_mbox_query_fw_free_running_clock_offset_get(mbox);
+
 	num_pages = mlxsw_cmd_mbox_query_fw_fw_pages_get(mbox);
 	err = mlxsw_pci_fw_area_init(mlxsw_pci, mbox, num_pages);
 	if (err)
@@ -1469,6 +1479,7 @@ static int mlxsw_pci_init(void *bus_priv, struct mlxsw_core *mlxsw_core,
 err_boardinfo:
 	mlxsw_pci_fw_area_fini(mlxsw_pci);
 err_fw_area_init:
+err_fr_rn_clk_bar:
 err_doorbell_page_bar:
 err_iface_rev:
 err_query_fw:
@@ -1672,6 +1683,24 @@ static int mlxsw_pci_cmd_exec(void *bus_priv, u16 opcode, u8 opcode_mod,
 	return err;
 }
 
+static u32 mlxsw_pci_read_frc_h(void *bus_priv)
+{
+	struct mlxsw_pci *mlxsw_pci = bus_priv;
+	u64 frc_offset;
+
+	frc_offset = mlxsw_pci->free_running_clock_offset;
+	return mlxsw_pci_read32(mlxsw_pci, FREE_RUNNING_CLOCK_H(frc_offset));
+}
+
+static u32 mlxsw_pci_read_frc_l(void *bus_priv)
+{
+	struct mlxsw_pci *mlxsw_pci = bus_priv;
+	u64 frc_offset;
+
+	frc_offset = mlxsw_pci->free_running_clock_offset;
+	return mlxsw_pci_read32(mlxsw_pci, FREE_RUNNING_CLOCK_L(frc_offset));
+}
+
 static const struct mlxsw_bus mlxsw_pci_bus = {
 	.kind			= "pci",
 	.init			= mlxsw_pci_init,
@@ -1679,6 +1708,8 @@ static const struct mlxsw_bus mlxsw_pci_bus = {
 	.skb_transmit_busy	= mlxsw_pci_skb_transmit_busy,
 	.skb_transmit		= mlxsw_pci_skb_transmit,
 	.cmd_exec		= mlxsw_pci_cmd_exec,
+	.read_frc_h		= mlxsw_pci_read_frc_h,
+	.read_frc_l		= mlxsw_pci_read_frc_l,
 	.features		= MLXSW_BUS_F_TXRX | MLXSW_BUS_F_RESET,
 };
 
@@ -1740,6 +1771,7 @@ static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mlxsw_pci->bus_info.device_kind = driver_name;
 	mlxsw_pci->bus_info.device_name = pci_name(mlxsw_pci->pdev);
 	mlxsw_pci->bus_info.dev = &pdev->dev;
+	mlxsw_pci->bus_info.read_frc_capable = true;
 	mlxsw_pci->id = id;
 
 	err = mlxsw_core_bus_device_register(&mlxsw_pci->bus_info,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index 8648ca171254..e57e42e2d2b2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -43,6 +43,9 @@
 #define MLXSW_PCI_DOORBELL(offset, type_offset, num)	\
 	((offset) + (type_offset) + (num) * 4)
 
+#define MLXSW_PCI_FREE_RUNNING_CLOCK_H(offset)	(offset)
+#define MLXSW_PCI_FREE_RUNNING_CLOCK_L(offset)	((offset) + 4)
+
 #define MLXSW_PCI_CQS_MAX	96
 #define MLXSW_PCI_EQS_COUNT	2
 #define MLXSW_PCI_EQ_ASYNC_NUM	0
-- 
2.20.1

