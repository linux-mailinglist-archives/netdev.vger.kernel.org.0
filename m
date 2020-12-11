Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F912D7C67
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405366AbgLKRGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:06:24 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:35043 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394465AbgLKRGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:06:03 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 35FF87D8;
        Fri, 11 Dec 2020 12:05:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 11 Dec 2020 12:05:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=McqYh91XgmZZ0BWv24Mn9JdxcnSB/T1DDO63oNgjnz0=; b=Wg0gUFD7
        gTk2p4UlkDgaiki54Fq4+wvnGOJRXGJeMwb9uGnDDuIi75yK/tnCBVZkhCN78W/G
        aYYHDXE26o/xYeaoks3nrCDhwu1mECODLf5DCptQ390VOa5RZORIEXrgFcWc11ex
        Ud/MxQDRNQWG7QEGyW2ClMMbMf09WWlSw4i1O373wJ5qGR7jP3pP/8VkNOp1oyvP
        gV+ZxXu2ZMOFpOX+CWsTx33PN1N5NP9LYLi9haZ/s5RZdH1hc6KGHyktG2Wc8e49
        nkEvdKRYeQAXc/3iD4yz8z3jWgRwgDUKHPZrOiNh1gPStcHH4F3pjjyvJtlX+G3E
        TfA4i4+y+UJD8g==
X-ME-Sender: <xms:zKbTX47qT9eiyAsTiOr06C5hEVM-j1JKT35qasORE9b8Zxy95UUUjA>
    <xme:zKbTX49tE2dfi8-3FxR_iEhw_-PxoP3Y7YzhrvJ5C2SDETXeTzy61QSbt5nyxtGKV
    hIEcAfvbKJyRZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekvddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:zKbTX9rdFO3zwqhpdAGq4vdzxumHhlxRYGc23O2b-H2BxLiIkDAfrA>
    <xmx:zKbTX5pvFbc4R2nZkf610RNU1klC_DlPtn-IswbTBKV6w_ib19NRMw>
    <xmx:zKbTXw1vm8wbJm6nozZJiVI93eIkK0Hvj23vEweFJLgT6ftkbf56fw>
    <xmx:zKbTX1VhYdXzgWIq4ZlJYoGCSvXOxvkBTqg-2gNvwHU-BLVdKmcnOg>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id B51EE1080066;
        Fri, 11 Dec 2020 12:05:15 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/15] mlxsw: pci: Obtain info about ports used by eXtended mezanine
Date:   Fri, 11 Dec 2020 19:04:02 +0200
Message-Id: <20201211170413.2269479-5-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211170413.2269479-1-idosch@idosch.org>
References: <20201211170413.2269479-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The output of boardinfo command was extended to contain information
about XM. Indicates if is present and in case it is, tells which
localports are used for the connection. So parse this info and store it
in bus_info passed up to the driver.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/cmd.h  | 17 ++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h |  7 +++++-
 drivers/net/ethernet/mellanox/mlxsw/pci.c  | 27 +++++++++++++++++++++-
 3 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/cmd.h b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
index 5ffdfb532cb7..4de15c56542f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -343,6 +343,23 @@ static inline int mlxsw_cmd_boardinfo(struct mlxsw_core *mlxsw_core,
 				  0, 0, false, out_mbox, MLXSW_CMD_MBOX_SIZE);
 }
 
+/* cmd_mbox_xm_num_local_ports
+ * Number of local_ports connected to the xm.
+ * Each local port is a 4x
+ * Spectrum-2/3: 25G
+ * Spectrum-4: 50G
+ */
+MLXSW_ITEM32(cmd_mbox, boardinfo, xm_num_local_ports, 0x00, 4, 3);
+
+/* cmd_mbox_xm_exists
+ * An XM (eXtanded Mezanine, e.g. used for the XLT) is connected on the board.
+ */
+MLXSW_ITEM32(cmd_mbox, boardinfo, xm_exists, 0x00, 0, 1);
+
+/* cmd_mbox_xm_local_port_entry
+ */
+MLXSW_ITEM_BIT_ARRAY(cmd_mbox, boardinfo, xm_local_port_entry, 0x04, 4, 8);
+
 /* cmd_mbox_boardinfo_intapin
  * When PCIe interrupt messages are being used, this value is used for clearing
  * an interrupt. When using MSI-X, this register is not used.
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 92f7398287be..ec424d388ecc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -435,6 +435,8 @@ struct mlxsw_fw_rev {
 	u16 can_reset_minor;
 };
 
+#define MLXSW_BUS_INFO_XM_LOCAL_PORTS_MAX 4
+
 struct mlxsw_bus_info {
 	const char *device_kind;
 	const char *device_name;
@@ -443,7 +445,10 @@ struct mlxsw_bus_info {
 	u8 vsd[MLXSW_CMD_BOARDINFO_VSD_LEN];
 	u8 psid[MLXSW_CMD_BOARDINFO_PSID_LEN];
 	u8 low_frequency:1,
-	   read_frc_capable:1;
+	   read_frc_capable:1,
+	   xm_exists:1;
+	u8 xm_local_ports_count;
+	u8 xm_local_ports[MLXSW_BUS_INFO_XM_LOCAL_PORTS_MAX];
 };
 
 struct mlxsw_hwmon;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 641cdd81882b..aae472f0e62f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1209,6 +1209,30 @@ static int mlxsw_pci_config_profile(struct mlxsw_pci *mlxsw_pci, char *mbox,
 	return mlxsw_cmd_config_profile_set(mlxsw_pci->core, mbox);
 }
 
+static int mlxsw_pci_boardinfo_xm_process(struct mlxsw_pci *mlxsw_pci,
+					  struct mlxsw_bus_info *bus_info,
+					  char *mbox)
+{
+	int count = mlxsw_cmd_mbox_boardinfo_xm_num_local_ports_get(mbox);
+	int i;
+
+	if (!mlxsw_cmd_mbox_boardinfo_xm_exists_get(mbox))
+		return 0;
+
+	bus_info->xm_exists = true;
+
+	if (count > MLXSW_BUS_INFO_XM_LOCAL_PORTS_MAX) {
+		dev_err(&mlxsw_pci->pdev->dev, "Invalid number of XM local ports\n");
+		return -EINVAL;
+	}
+	bus_info->xm_local_ports_count = count;
+	for (i = 0; i < count; i++)
+		bus_info->xm_local_ports[i] =
+			mlxsw_cmd_mbox_boardinfo_xm_local_port_entry_get(mbox,
+									 i);
+	return 0;
+}
+
 static int mlxsw_pci_boardinfo(struct mlxsw_pci *mlxsw_pci, char *mbox)
 {
 	struct mlxsw_bus_info *bus_info = &mlxsw_pci->bus_info;
@@ -1220,7 +1244,8 @@ static int mlxsw_pci_boardinfo(struct mlxsw_pci *mlxsw_pci, char *mbox)
 		return err;
 	mlxsw_cmd_mbox_boardinfo_vsd_memcpy_from(mbox, bus_info->vsd);
 	mlxsw_cmd_mbox_boardinfo_psid_memcpy_from(mbox, bus_info->psid);
-	return 0;
+
+	return mlxsw_pci_boardinfo_xm_process(mlxsw_pci, bus_info, mbox);
 }
 
 static int mlxsw_pci_fw_area_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
-- 
2.29.2

