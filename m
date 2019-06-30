Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9676E5AECB
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 08:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfF3GFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 02:05:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46779 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbfF3GFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 02:05:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 18E42210AF;
        Sun, 30 Jun 2019 02:05:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 Jun 2019 02:05:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=cndn4wtA9aE004NfbsQAJh06xHA5GqG5nZurZ1S9rhc=; b=dbGI4MJl
        fq8QKa/KvXyAxWFccBsaez6MJkj7SoQXdrqyQ/DWQqify61Yvqof0kz860TilCge
        M8ZhBlM0jNh4Y6wxojbC75rqe60C5iM3+yFisk8+hUKK+l4fuCqaTEOxtNm2FWiI
        vFFylc8BT3oO37C5VUcORAs38T3PZen6WpqleV0QC/+eDgcLxi88B9JAuLTIkcX5
        Io8SYz1Z+XoFAyinfB2nDFlvDMdtJ9lsCcf/eJh4xVpNcVVND5Bs7QuoMy4LxQjI
        lp+XqaO42GjrXZd4toWQOqV6/8hbk4xMZart5oRnGfdJ+h/RghE5Qywd9ylFcZEK
        L/tO3m/3z389bQ==
X-ME-Sender: <xms:P1EYXcBkSDMonmTd7SKxCWHSxts5huFDvXZdRVa0s8KLgaY9KjqI-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdefgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:P1EYXebkOWLSHEOCPXvYSFlDLNVVxHbjDosiGU675UnrOmKDVIQ02w>
    <xmx:P1EYXc4gLaVKK1Q1aX8LGkxXt0SMWcG73XcwFBmLSqu7CbRhISgVaw>
    <xmx:P1EYXe_CSKk6-uoT1V3uhW1-eOIvxgHzSG-ISdVN_lgAnLO69ly6Kg>
    <xmx:QFEYXT9WobUP0UcWMwU8tGFMbYLlHQtO11j73TRhtZve1pJ3KDe7mw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 79A868005B;
        Sun, 30 Jun 2019 02:05:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 04/16] mlxsw: reg: Add Monitoring Global Configuration Register
Date:   Sun, 30 Jun 2019 09:04:48 +0300
Message-Id: <20190630060500.7882-5-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190630060500.7882-1-idosch@idosch.org>
References: <20190630060500.7882-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

This register serves to configure global parameters of certain
monitoring operations. The following patches will use it to configure
that when PTP timestamps are delivered through the PTP FIFO traps, the
FIFO in question is cleared as well.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 27 +++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 197599890bdf..8de9333e6eb1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9148,6 +9148,32 @@ static inline void mlxsw_reg_mprs_pack(char *payload, u16 parsing_depth,
 	mlxsw_reg_mprs_vxlan_udp_dport_set(payload, vxlan_udp_dport);
 }
 
+/* MOGCR - Monitoring Global Configuration Register
+ * ------------------------------------------------
+ */
+#define MLXSW_REG_MOGCR_ID 0x9086
+#define MLXSW_REG_MOGCR_LEN 0x20
+
+MLXSW_REG_DEFINE(mogcr, MLXSW_REG_MOGCR_ID, MLXSW_REG_MOGCR_LEN);
+
+/* reg_mogcr_ptp_iftc
+ * PTP Ingress FIFO Trap Clear
+ * The PTP_ING_FIFO trap provides MTPPTR with clr according
+ * to this value. Default 0.
+ * Reserved when IB switches and when SwitchX/-2, Spectrum-2
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mogcr, ptp_iftc, 0x00, 1, 1);
+
+/* reg_mogcr_ptp_eftc
+ * PTP Egress FIFO Trap Clear
+ * The PTP_EGR_FIFO trap provides MTPPTR with clr according
+ * to this value. Default 0.
+ * Reserved when IB switches and when SwitchX/-2, Spectrum-2
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mogcr, ptp_eftc, 0x00, 0, 1);
+
 /* MTPPPC - Time Precision Packet Port Configuration
  * -------------------------------------------------
  * This register serves for configuration of which PTP messages should be
@@ -10400,6 +10426,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mcda),
 	MLXSW_REG(mgpc),
 	MLXSW_REG(mprs),
+	MLXSW_REG(mogcr),
 	MLXSW_REG(mtpppc),
 	MLXSW_REG(mtpptr),
 	MLXSW_REG(mtptpt),
-- 
2.20.1

