Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D423D13A
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391778AbfFKPpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:45:44 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42833 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388046AbfFKPpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:45:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9B1DB22304;
        Tue, 11 Jun 2019 11:45:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 11:45:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=ynR97kCyesDWGW2TFhK4zTvP9CeiVT4Fo+8agqms4eU=; b=y7JAWlG0
        CJ/Ig3GrVNO7Mx8JJay4dr1lNCPT02AKSuJbDmm4w/YMPTh24Ln4XvMFqV0jwE8a
        UsScHCsopQk9Zb4n/PtBY9rwHkcJSbonkvyaALoCJO+brunwLUH21zycHtqonGWu
        DGqrnvUIwkV7UCK8M7yE86kyr0uPZs1q/uFiUo5DTVMkTUT0Esbm4+0ApbAUp7bm
        VaRiN1OjuCKnk9XmdBdnvNHYYPMFNO4+5i6h1alfbHT2C93VRejHOF2nB9F0T9CI
        BSbIICsSzxE0DAnIglbO5Hv9vyuV5v112RP+rYPJiyoXhmuQxoblN7s9xHOG27oZ
        xevPN84ZidsW2g==
X-ME-Sender: <xms:psz_XMRK8giT5HO2BHeY9SyPxPlfaq4GykTRe6jp22YFUK9_77VJUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehhedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:psz_XJ_jTpdxnIDIZcMcSFadlUNf9bny_KXe5-XePOiWfFm_9G9DYw>
    <xmx:psz_XLoNhi2STm2oRSrY5kzzmzZxaSxT57MhwNdJHbXYkUAf4W6P9Q>
    <xmx:psz_XOlxp68KU-x9NeYbgbAc5mKrBi9w2FKdiKUSiRTw0clUcYx1Hw>
    <xmx:psz_XIs7FXT7Ty0tiRAGR4MKVFAj2cXANciJjJ8qAzBOcgCJPeZliQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id CA793380090;
        Tue, 11 Jun 2019 11:45:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        petrm@mellanox.com, richardcochran@gmail.com, olteanv@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 1/9] mlxsw: cmd: Free running clock PCI BAR and offsets via query firmware
Date:   Tue, 11 Jun 2019 18:45:04 +0300
Message-Id: <20190611154512.17650-2-idosch@idosch.org>
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

