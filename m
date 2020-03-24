Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD10191A0A
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbgCXTel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:34:41 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:50305 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727103AbgCXTel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:34:41 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0A282580061;
        Tue, 24 Mar 2020 15:34:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 24 Mar 2020 15:34:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=5sROIFoYkVg+nsgg8I0lgV6vFG+e4iTQfGXWpUeNrN8=; b=v8444Haq
        hEdsop2LpECMXt3ch5Lv8dk8rLMj1eAbb7L5RWV2WPh+72b3UFlcZv4aLSiiQJhE
        fpCIwN7LXqN74Qq66S7effg7dZpZ7mqXAJ98p1/1msVvB9xhxrN3zlH9a0ZGtM1M
        jN4GRr2Hu77cguxnr0JjU56CBVonFzGVbIgxOlWzf4szxXhRO1WHb8LR7uVyhg/q
        +oNZfTl978A6WaA1veXd665hWzta2PXcQAC5CXj7LuKix9vRKvFt+ycrJUrfREgy
        wNijvS7doiwffxAGKTa5QnlUqdElKRLucbAeqpCw8DSGhTdOZbKDLIa+jfcaY+H1
        OdPzcuKfahJZJA==
X-ME-Sender: <xms:z2B6XlDb_peXruQF7ymAh7-BZHWxwEb52utFSqnzDTMoltSoKo3TMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehuddgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudektddrleegrddvvdehnecuvehluhhsthgvrh
    fuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:z2B6Xnw2ct-6Q0kVFnA25wrYyidOSEoCOM5-fpWtaHkdgDIIxj2Kgw>
    <xmx:z2B6XrmHj0QhfkPkCWY0y60EvOF0wgJQFRh4v-9Xbo3QjrPYY2iQyw>
    <xmx:z2B6XkEJmMBQPYvfrJFX3Mb_4WSVHuvixS-oJnotEB9ubIcXTM04Ag>
    <xmx:0GB6XsKeoFe95ydHVrjf_Z6sF--df4r0BzwPn-yQIj6533eYfxSKkQ>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id CC7A43065930;
        Tue, 24 Mar 2020 15:34:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/15] mlxsw: reg: Extend QPCR register
Date:   Tue, 24 Mar 2020 21:32:43 +0200
Message-Id: <20200324193250.1322038-9-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324193250.1322038-1-idosch@idosch.org>
References: <20200324193250.1322038-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The QoS Policer Configuration Register (QPCR) is used to configure
hardware policers. Extend this register with following fields and
defines which will be used by subsequent patches:

1. Violate counter: reads number of packets dropped by the policer
2. Clear counter: to ensure we start counting from 0
3. Rate and burst size limits

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 1bc65e597de0..192578632657 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3296,6 +3296,12 @@ MLXSW_ITEM32(reg, qpcr, g, 0x00, 14, 2);
  */
 MLXSW_ITEM32(reg, qpcr, pid, 0x00, 0, 14);
 
+/* reg_qpcr_clear_counter
+ * Clear counters.
+ * Access: OP
+ */
+MLXSW_ITEM32(reg, qpcr, clear_counter, 0x04, 31, 1);
+
 /* reg_qpcr_color_aware
  * Is the policer aware of colors.
  * Must be 0 (unaware) for cpu port.
@@ -3393,6 +3399,17 @@ enum mlxsw_reg_qpcr_action {
  */
 MLXSW_ITEM32(reg, qpcr, violate_action, 0x18, 0, 4);
 
+/* reg_qpcr_violate_count
+ * Counts the number of times violate_action happened on this PID.
+ * Access: RW
+ */
+MLXSW_ITEM64(reg, qpcr, violate_count, 0x20, 0, 64);
+
+#define MLXSW_REG_QPCR_LOWEST_CIR	1
+#define MLXSW_REG_QPCR_HIGHEST_CIR	(2 * 1000 * 1000 * 1000) /* 2Gpps */
+#define MLXSW_REG_QPCR_LOWEST_CBS	4
+#define MLXSW_REG_QPCR_HIGHEST_CBS	24
+
 static inline void mlxsw_reg_qpcr_pack(char *payload, u16 pid,
 				       enum mlxsw_reg_qpcr_ir_units ir_units,
 				       bool bytes, u32 cir, u16 cbs)
-- 
2.24.1

