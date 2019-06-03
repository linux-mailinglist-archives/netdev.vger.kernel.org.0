Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17D8432F47
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 14:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfFCMNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 08:13:53 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55759 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727427AbfFCMNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 08:13:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4E6D02229C;
        Mon,  3 Jun 2019 08:13:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 03 Jun 2019 08:13:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Nf9yLXH7/mgFgchLEh8P05j0SzXu8iIreKrjDSxjo6U=; b=mTa1jS4w
        KMeOpJPE5ERHzpEmFQdFbv3N7v2ssJDJy9CVAnxgzkolwOSr4IVDJqI8YJXLH3wc
        opFtW7vI1Hsq17iLhAokrN7FzkvP7dUVvm26hdGPWOkqOpbUSR3ynLUwjQzucFFb
        Lhp83qbBM3HUMYij7fAqsG16AWbaLsBThF/SpwBeR5eairp930ZhQZq6K6hcmDXJ
        aAX+RFxb9QRVBLHjOjKDGPGXwUU3icgpKH1oTDXeJlt58ZAyjKyFl/2Y7rXhJtCO
        e5mpMloy2zijFj7zOMZnZtxeJebMhpGF+83q6HlIFUq7xWf6eQnKDeeTE5O9o35/
        8x8BUiQ7k+LnWg==
X-ME-Sender: <xms:_w71XMkS-otiW_XsrJoEo7-geZ90Y2iC8yS_FwT8gvJFg9ecig3CFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefjedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedv
X-ME-Proxy: <xmx:_w71XAFizrfi8F4jojuCUE4Rs_ftGkUXRNIo3ms8jlecTwyBu4ltLg>
    <xmx:_w71XHlYwO8yx7-fZlVJjh0zo-gNtQ6BaSQq_1ciwvCx0knZgAb88g>
    <xmx:_w71XHTifUVCSCdd3-cXWkz7AAZO7Zh69RakM93SAs69Hq7NuaXypg>
    <xmx:_w71XK8m1xCLxeIsIpp-zdcv9ydjeg77rxvVDbPIjI2JE7nx-vTGrA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64FB0380083;
        Mon,  3 Jun 2019 08:13:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        shalomt@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/9] mlxsw: pci: Query free running clock PCI BAR and offsets
Date:   Mon,  3 Jun 2019 15:12:38 +0300
Message-Id: <20190603121244.3398-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190603121244.3398-1-idosch@idosch.org>
References: <20190603121244.3398-1-idosch@idosch.org>
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

