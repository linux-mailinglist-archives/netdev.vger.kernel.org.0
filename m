Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B908DE00
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbfD2Ie5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:34:57 -0400
Received: from first.geanix.com ([116.203.34.67]:49924 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727711AbfD2Iex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:34:53 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 28C85308E88;
        Mon, 29 Apr 2019 08:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556526809; bh=fhshELUhhkrPeKmTBAt7yFU6om8d3xcX3FEX3YhXIkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=CU6K5SqV4gFD3nSc3SjwWWPfYdkH3IFbrx5gvNFbJhNtimHiGqsyhI6vVHMR7ayg+
         k/t2zZtTWmMTOwJqhCeIwbU/5mlc7scKEXtVSaXJF01zopDftXOgpeN4Og13w19kEp
         RFK34jcVxTP8AKygjsVx4L1z3XUL72EmyhuNR6OjLOIAQZDkBFlGyvWjT/UN6Zxoxc
         0I0rSwNIjaM0UyYa5y1CEXJudggGBBvZ3W0LqSP0P+YsyR1hIytifk1YVEH5npSoK6
         PyQadILgK7yk447das3G9OG+JlOzjtRu47xdrbl94CdNHT5OqssLIhvBo26hhe9hD9
         v+qKmBYJbYwqA==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] net: ll_temac: Allow use on x86 platforms
Date:   Mon, 29 Apr 2019 10:34:16 +0200
Message-Id: <20190429083422.4356-7-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190429083422.4356-1-esben@geanix.com>
References: <20190426073231.4008-1-esben@geanix.com>
 <20190429083422.4356-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 3e0c63300934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With little-endian and 64-bit support in place, the ll_temac driver can
now be used on x86 and x86_64 platforms.

And while at it, enable COMPILE_TEST also.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index 6d68c8a..db448fa 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -5,7 +5,7 @@
 config NET_VENDOR_XILINX
 	bool "Xilinx devices"
 	default y
-	depends on PPC || PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS
+	depends on PPC || PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS || X86 || COMPILE_TEST
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
@@ -33,7 +33,7 @@ config XILINX_AXI_EMAC
 
 config XILINX_LL_TEMAC
 	tristate "Xilinx LL TEMAC (LocalLink Tri-mode Ethernet MAC) driver"
-	depends on (PPC || MICROBLAZE)
+	depends on PPC || MICROBLAZE || X86 || COMPILE_TEST
 	select PHYLIB
 	---help---
 	  This driver supports the Xilinx 10/100/1000 LocalLink TEMAC
-- 
2.4.11

