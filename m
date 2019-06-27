Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74675583E4
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfF0Nxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:53:49 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39855 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727016AbfF0Nxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:53:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CE94121FE2;
        Thu, 27 Jun 2019 09:53:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 27 Jun 2019 09:53:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=cndn4wtA9aE004NfbsQAJh06xHA5GqG5nZurZ1S9rhc=; b=GYD+YMMj
        BO1BaV/lBBH0yZOpzIjgNng+NBpebTPLUwFF8FgJsdTaZSTp+Pj76bwzNRz4hNSu
        a0ZNJmkKMdLyWEA9ZgqJBUT3CKU+mPG6SWIjmM9smuA9TBH0e1IewlQVMqUeakSD
        1mMsw5cojjBEnmezDbS34omKLmedp8MCv7dztkDjWrWPDi2KtjDSYoylA1fNCTbU
        Q5a6+4RGam7DKDfBV8TWNAnlQRU/0rbG0Cb/cUcjL7XXdvqsGgToXjrUcfj5vTNI
        oaWHWkYc1i3QQ2PI5oYtVkCvxnvWVYYZkF3inZVl/P9VdY5a9huAycO4b96URDMa
        dfMaEhtg7vKmgQ==
X-ME-Sender: <xms:asoUXVKdO2idNRyw6G8fsf_hNUmVvMXk5hvLMwi9F8iF29XgDQ-9bQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepud
X-ME-Proxy: <xmx:asoUXdDnDl1Fz_s00JY4p3MDndadT-6Q3nCN4gWd9IpFXw0oslwhwA>
    <xmx:asoUXWikOYlKwQlkZpPpvzQkxuN5WVs4lZ8wlYijw0ELD3jiXX_UAg>
    <xmx:asoUXfPC6MU-D60ZNV9glQHv2tnGnhCteYpxwo-vBzonaJOy9aH8JQ>
    <xmx:asoUXWfD8k1mN17BVMd9pMuJ78rrJ3WouWta5nGZKoBY7F38_fJJ6g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E4AA38005B;
        Thu, 27 Jun 2019 09:53:44 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/16] mlxsw: reg: Add Monitoring Global Configuration Register
Date:   Thu, 27 Jun 2019 16:52:47 +0300
Message-Id: <20190627135259.7292-5-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627135259.7292-1-idosch@idosch.org>
References: <20190627135259.7292-1-idosch@idosch.org>
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

