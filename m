Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3394519107D
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbgCXN26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:28:58 -0400
Received: from foss.arm.com ([217.140.110.172]:34610 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729565AbgCXNYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 09:24:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26B3F1063;
        Tue, 24 Mar 2020 06:24:08 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CBF853F52E;
        Tue, 24 Mar 2020 06:24:06 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 09/14] net: axienet: Drop MDIO interrupt registers from ethtools dump
Date:   Tue, 24 Mar 2020 13:23:42 +0000
Message-Id: <20200324132347.23709-10-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324132347.23709-1-andre.przywara@arm.com>
References: <20200324132347.23709-1-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newer revisions of the IP don't have these registers. Since we don't
really use them, just drop them from the ethtools dump.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      | 7 -------
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ----
 2 files changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 04e51af32178..fb7450ca5c53 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -165,13 +165,6 @@
 #define XAE_MDIO_MCR_OFFSET	0x00000504 /* MII Management Control */
 #define XAE_MDIO_MWD_OFFSET	0x00000508 /* MII Management Write Data */
 #define XAE_MDIO_MRD_OFFSET	0x0000050C /* MII Management Read Data */
-#define XAE_MDIO_MIS_OFFSET	0x00000600 /* MII Management Interrupt Status */
-/* MII Mgmt Interrupt Pending register offset */
-#define XAE_MDIO_MIP_OFFSET	0x00000620
-/* MII Management Interrupt Enable register offset */
-#define XAE_MDIO_MIE_OFFSET	0x00000640
-/* MII Management Interrupt Clear register offset. */
-#define XAE_MDIO_MIC_OFFSET	0x00000660
 #define XAE_UAW0_OFFSET		0x00000700 /* Unicast address word 0 */
 #define XAE_UAW1_OFFSET		0x00000704 /* Unicast address word 1 */
 #define XAE_FMI_OFFSET		0x00000708 /* Filter Mask Index */
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 60c8cde365f8..217f58bed2c5 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1258,10 +1258,6 @@ static void axienet_ethtools_get_regs(struct net_device *ndev,
 	data[20] = axienet_ior(lp, XAE_MDIO_MCR_OFFSET);
 	data[21] = axienet_ior(lp, XAE_MDIO_MWD_OFFSET);
 	data[22] = axienet_ior(lp, XAE_MDIO_MRD_OFFSET);
-	data[23] = axienet_ior(lp, XAE_MDIO_MIS_OFFSET);
-	data[24] = axienet_ior(lp, XAE_MDIO_MIP_OFFSET);
-	data[25] = axienet_ior(lp, XAE_MDIO_MIE_OFFSET);
-	data[26] = axienet_ior(lp, XAE_MDIO_MIC_OFFSET);
 	data[27] = axienet_ior(lp, XAE_UAW0_OFFSET);
 	data[28] = axienet_ior(lp, XAE_UAW1_OFFSET);
 	data[29] = axienet_ior(lp, XAE_FMI_OFFSET);
-- 
2.17.1

