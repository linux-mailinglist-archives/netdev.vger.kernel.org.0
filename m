Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF00F129
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 09:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfD3HSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 03:18:31 -0400
Received: from first.geanix.com ([116.203.34.67]:43698 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfD3HS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 03:18:29 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 98FB7308E99;
        Tue, 30 Apr 2019 07:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556608701; bh=pjOz5DOCt3U+7Kse+9zthfTgeUxy/f8iFmNu5nYhzIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=BjJ+lCQ+5EHozGQyEPFFiUVcH/edQjp4dR4KSAwTLB0lQbXn9q68qxspHX4HFWM1E
         cFvoEgVEg6ExVxPO0qc03aL+VsC7DSSAM4wQ3US2+O/J4IzmDZMxV/h+IB3siOBlud
         DgbR6OCHc4+4UuGXyvHIm++G6woLyZSJiy1y6FHu2UEOgrXgFInArG2lQEp83uEObI
         45mFsWzN+O2CpWMnzKCf9u0y4Sw5/GCnMFZN1SXsmI9GfVLNmDZGMYUhTraX+eAVBR
         vRZdQs1EfdSlA4V5CyKuTRhD1ylAc0FFz/defi0QtHAsCV5xnSA9Vrdcv1HRn4sa6x
         m/82zqT9tBxsg==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 06/12] net: ll_temac: Allow use on x86 platforms
Date:   Tue, 30 Apr 2019 09:17:53 +0200
Message-Id: <20190430071759.2481-7-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430071759.2481-1-esben@geanix.com>
References: <20190429083422.4356-1-esben@geanix.com>
 <20190430071759.2481-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b7bf6291adac
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With little-endian and 64-bit support in place, the ll_temac driver can
now be used on x86 and x86_64 platforms.

And while at it, enable COMPILE_TEST also.

Signed-off-by: Esben Haabendal <esben@geanix.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

