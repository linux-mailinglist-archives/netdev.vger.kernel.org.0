Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEC42D277A
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgLHJY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:24:59 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49059 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727260AbgLHJY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:24:59 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 9558B5C01EF;
        Tue,  8 Dec 2020 04:23:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 08 Dec 2020 04:23:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=WqUJ7bmLa21iZhu0DaF/i7E2uFGRPpNKFWDY3OR1Du8=; b=EIcEgVqB
        yOL5drZJbBI9rmBZ81EMZm7BOzAqgaz5/+B/OTbhWhtPiobQwsW5cxGsRxtdtERe
        GPi7evMgLfIYOYu5BnUbTXv3Y/2JQGx4cPYkqa2QeQwJGwX5FW8GuDqcPFDq8Wv3
        mQD4aqbYZFFru2E16PpmmKhMP/hdw61SLUUCtlsBmMfHWqcfykjyZwLCGEK6SJdS
        XBfn+mrYlFPPF8R2Fw6GUomLtskp+VfSkzGbsvA0Yo7OlbVj+0mkbUtXEJSTPw69
        goNpVbG9h3lgEUzW3PTdy1sZ6rY6JgPedjebiqCxSvF1e6gw+Bqca6ca7kd4RqJ7
        GBlEYQyUzCSYZw==
X-ME-Sender: <xms:KEbPX-3URlMgAmv9I_6XZbwH6ShrXqtSxHVaLuLlYsKvrOJQ_y4xEw>
    <xme:KEbPX4cN-vZVkf_NJzZ0SfU_-7MCeN_GOIUHtk7qsjSrIglJdGE0Wy63y-yF-63kk
    l2FNCzzYu1Y4HQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:KEbPX8cQ4VnPnPD7GVYJrY7WI71YyNVmc-lBcDP60P-QuwgJ10ULvg>
    <xmx:KEbPX7zKnm5WYRRrrx-z6JpuN_HRlv4Lho5Kvswglf8XWQ-L9PaUiw>
    <xmx:KEbPXz-owD-EI7OU1ILvJ8NxRPot49Z0Qde64fDH79wlW3dqogj1_Q>
    <xmx:KEbPX9M8habJjU0EVg4DUfnihkV94__VDpd18gTfJN_RpgIDEWy6qw>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 199281080067;
        Tue,  8 Dec 2020 04:23:50 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/13] mlxsw: reg: Add Switch Port VLAN Stacking Register
Date:   Tue,  8 Dec 2020 11:22:42 +0200
Message-Id: <20201208092253.1996011-3-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208092253.1996011-1-idosch@idosch.org>
References: <20201208092253.1996011-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

SPVTR register configures the VLAN mode of the port to enable VLAN
stacking.

It will be used to configure VxLAN to push VLAN to the decapsulated packet.
Without this setting, Spectrum-2 overtakes the VLAN tag of decapsulated
packet for bridging.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 104 ++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 0a3c5f89268c..ad6798c2169d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1693,6 +1693,109 @@ static inline void mlxsw_reg_svfa_pack(char *payload, u8 local_port,
 	mlxsw_reg_svfa_vid_set(payload, vid);
 }
 
+/*  SPVTR - Switch Port VLAN Stacking Register
+ *  ------------------------------------------
+ *  The Switch Port VLAN Stacking register configures the VLAN mode of the port
+ *  to enable VLAN stacking.
+ */
+#define MLXSW_REG_SPVTR_ID 0x201D
+#define MLXSW_REG_SPVTR_LEN 0x10
+
+MLXSW_REG_DEFINE(spvtr, MLXSW_REG_SPVTR_ID, MLXSW_REG_SPVTR_LEN);
+
+/* reg_spvtr_tport
+ * Port is tunnel port.
+ * Access: Index
+ *
+ * Note: Reserved when SwitchX/-2 or Spectrum-1.
+ */
+MLXSW_ITEM32(reg, spvtr, tport, 0x00, 24, 1);
+
+/* reg_spvtr_local_port
+ * When tport = 0: local port number (Not supported from/to CPU).
+ * When tport = 1: tunnel port.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, spvtr, local_port, 0x00, 16, 8);
+
+/* reg_spvtr_ippe
+ * Ingress Port Prio Mode Update Enable.
+ * When set, the Port Prio Mode is updated with the provided ipprio_mode field.
+ * Reserved on Get operations.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, spvtr, ippe, 0x04, 31, 1);
+
+/* reg_spvtr_ipve
+ * Ingress Port VID Mode Update Enable.
+ * When set, the Ingress Port VID Mode is updated with the provided ipvid_mode
+ * field.
+ * Reserved on Get operations.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, spvtr, ipve, 0x04, 30, 1);
+
+/* reg_spvtr_epve
+ * Egress Port VID Mode Update Enable.
+ * When set, the Egress Port VID Mode is updated with the provided epvid_mode
+ * field.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, spvtr, epve, 0x04, 29, 1);
+
+/* reg_spvtr_ipprio_mode
+ * Ingress Port Priority Mode.
+ * This controls the PCP and DEI of the new outer VLAN
+ * Note: for SwitchX/-2 the DEI is not affected.
+ * 0: use port default PCP and DEI (configured by QPDPC).
+ * 1: use C-VLAN PCP and DEI.
+ * Has no effect when ipvid_mode = 0.
+ * Reserved when tport = 1.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, spvtr, ipprio_mode, 0x04, 20, 4);
+
+enum mlxsw_reg_spvtr_ipvid_mode {
+	/* IEEE Compliant PVID (default) */
+	MLXSW_REG_SPVTR_IPVID_MODE_IEEE_COMPLIANT_PVID,
+	/* Push VLAN (for VLAN stacking, except prio tagged packets) */
+	MLXSW_REG_SPVTR_IPVID_MODE_PUSH_VLAN_FOR_UNTAGGED_PACKET,
+	/* Always push VLAN (also for prio tagged packets) */
+	MLXSW_REG_SPVTR_IPVID_MODE_ALWAYS_PUSH_VLAN,
+};
+
+/* reg_spvtr_ipvid_mode
+ * Ingress Port VLAN-ID Mode.
+ * For Spectrum family, this affects the values of SPVM.i
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, spvtr, ipvid_mode, 0x04, 16, 4);
+
+enum mlxsw_reg_spvtr_epvid_mode {
+	/* IEEE Compliant VLAN membership */
+	MLXSW_REG_SPVTR_EPVID_MODE_IEEE_COMPLIANT_VLAN_MEMBERSHIP,
+	/* Pop VLAN (for VLAN stacking) */
+	MLXSW_REG_SPVTR_EPVID_MODE_POP_VLAN,
+};
+
+/* reg_spvtr_epvid_mode
+ * Egress Port VLAN-ID Mode.
+ * For Spectrum family, this affects the values of SPVM.e,u,pt.
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, spvtr, epvid_mode, 0x04, 0, 4);
+
+static inline void mlxsw_reg_spvtr_pack(char *payload, bool tport,
+					u8 local_port,
+					enum mlxsw_reg_spvtr_ipvid_mode ipvid_mode)
+{
+	MLXSW_REG_ZERO(spvtr, payload);
+	mlxsw_reg_spvtr_tport_set(payload, tport);
+	mlxsw_reg_spvtr_local_port_set(payload, local_port);
+	mlxsw_reg_spvtr_ipvid_mode_set(payload, ipvid_mode);
+	mlxsw_reg_spvtr_ipve_set(payload, true);
+}
+
 /* SVPE - Switch Virtual-Port Enabling Register
  * --------------------------------------------
  * Enables port virtualization.
@@ -11306,6 +11409,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(slcor),
 	MLXSW_REG(spmlr),
 	MLXSW_REG(svfa),
+	MLXSW_REG(spvtr),
 	MLXSW_REG(svpe),
 	MLXSW_REG(sfmr),
 	MLXSW_REG(spvmlr),
-- 
2.28.0

