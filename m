Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79F0732F45
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 14:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfFCMNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 08:13:49 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45577 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726989AbfFCMNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 08:13:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D1E4022221;
        Mon,  3 Jun 2019 08:13:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 03 Jun 2019 08:13:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ynR97kCyesDWGW2TFhK4zTvP9CeiVT4Fo+8agqms4eU=; b=34iDtHap
        3hN+nq/ppkAfPUFP66r8SNDQ/nSIR4YOGJCSCLgDoXNAPfEwm9a2gaa9+P4uEv8D
        CVas4ZHrULKdleyNqJORF+r8mw5SA1kZjM1BjYqwhmsbi4X7KkSpjccvS2Kq9pTD
        ZE1ZIOJ6zWAAb6DV7gJ5oC5qUrExMojQaz1igHNbQR68bjhHk9/vX6M6PxHepQEK
        r1N2rsnQzk8OipIHYdiv8uc85gQf9q1g/cdBcDGoyM9hV/FVfMMJDl9WBDbskm6n
        +sxknoTaUmiroYDuUrsepJH0ozgDrOQ5z0xfDoTKuLsY6a8TAJ2sHOrd5xzfrtXw
        e/epeXogZcqMgg==
X-ME-Sender: <xms:-w71XP8a4kRJDxKulLvBNJIpyLEUlkvNe4wLUplTBWUThOwUbfZZDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefjedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:-w71XH5EP2DOPbaxGgVCVAQbi0_zoSR7zBFpw-gtWrPI3DLJ_68ZuQ>
    <xmx:-w71XELEcT_48bS8gP2pOt_kHfRLECIrk-jWn-mMcpEOLEoh8wN9og>
    <xmx:-w71XHA-J1HhpiBJAKotlF9df4qrYYZCiF7ZYm5W0RdyEw8Pq2pkWA>
    <xmx:-w71XFhPV7QKqWnOW42RbxX8iQQ3vEtiWL1B0cKLuG_EtcsqHVXkOA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2CFDB38008E;
        Mon,  3 Jun 2019 08:13:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        shalomt@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/9] mlxsw: cmd: Free running clock PCI BAR and offsets via query firmware
Date:   Mon,  3 Jun 2019 15:12:36 +0300
Message-Id: <20190603121244.3398-2-idosch@idosch.org>
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

Add free running clock PCI BAR and offset to query firmware command.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/cmd.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/cmd.h b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
index 0772e4339b33..5ffdfb532cb7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -317,6 +317,18 @@ MLXSW_ITEM64(cmd_mbox, query_fw, doorbell_page_offset, 0x40, 0, 64);
  */
 MLXSW_ITEM32(cmd_mbox, query_fw, doorbell_page_bar, 0x48, 30, 2);
 
+/* cmd_mbox_query_fw_free_running_clock_offset
+ * The offset of the free running clock page
+ */
+MLXSW_ITEM64(cmd_mbox, query_fw, free_running_clock_offset, 0x50, 0, 64);
+
+/* cmd_mbox_query_fw_fr_rn_clk_bar
+ * PCI base address register (BAR) of the free running clock page
+ * 0: BAR 0
+ * 1: 64 bit BAR
+ */
+MLXSW_ITEM32(cmd_mbox, query_fw, fr_rn_clk_bar, 0x58, 30, 2);
+
 /* QUERY_BOARDINFO - Query Board Information
  * -----------------------------------------
  * OpMod == 0 (N/A), INMmod == 0 (N/A)
-- 
2.20.1

