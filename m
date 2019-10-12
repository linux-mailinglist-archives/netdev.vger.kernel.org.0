Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E97D4C92
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 06:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfJLEDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 00:03:54 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59356 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfJLEDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 00:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=APeT5AaLXeswMWlb3tP/PsbHyjxr0vkPncnt4qDerko=; b=Zb/L7iLFqV8TtC3501JZIQkTc
        6DRWodoCOnx6ycC8HFdbzWSQCo30pG7gjqWO6Esri69LdrZ+3lW/MNdu4E494WqQUwa7bvmKi+3L2
        BPP1dzzb5Yx3eb8WI7h2W7//zyKR3QeKDe7fkeTTimrpHGFgcfmXReYvr4vBWgDfVAfpbMG2GAm9t
        +GOWlUg9QAfd9MsJ35RFQpFqAzWXIrPcLFp6nJftaJL60fmaif9zr0izuRAXMu2aNQlJ5x0Hx9S20
        SxOrHAswCiPacdB3Td9SgGmWI1yoH63aNAjDjeZIr1Jrj1PWFCILj5RAe07cYoaP8rgERaTP9m9bu
        vDcaynE4A==;
Received: from [2601:1c0:6280:3f0::9ef4]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iJ8cw-00045P-Si; Sat, 12 Oct 2019 04:03:34 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <uwe@kleine-koenig.org>,
        Tal Gilboa <talgi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] net: ethernet: broadcom: have drivers select DIMLIB as needed
Message-ID: <610f9277-adff-2f4b-1f44-8f41b6c3ccb5@infradead.org>
Date:   Fri, 11 Oct 2019 21:03:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

NET_VENDOR_BROADCOM is intended to control a kconfig menu only.
It should not have anything to do with code generation.
As such, it should not select DIMLIB for all drivers under
NET_VENDOR_BROADCOM.  Instead each driver that needs DIMLIB should
select it (being the symbols SYSTEMPORT, BNXT, and BCMGENET).

Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1907021810220.13058@ramsan.of.borg/

Fixes: 4f75da3666c0 ("linux/dim: Move implementation to .c files")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Uwe Kleine-König <uwe@kleine-koenig.org>
Cc: Tal Gilboa <talgi@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/net/ethernet/broadcom/Kconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-next-20191011.orig/drivers/net/ethernet/broadcom/Kconfig
+++ linux-next-20191011/drivers/net/ethernet/broadcom/Kconfig
@@ -8,7 +8,6 @@ config NET_VENDOR_BROADCOM
 	default y
 	depends on (SSB_POSSIBLE && HAS_DMA) || PCI || BCM63XX || \
 		   SIBYTE_SB1xxx_SOC
-	select DIMLIB
 	---help---
 	  If you have a network (Ethernet) chipset belonging to this class,
 	  say Y.
@@ -69,6 +68,7 @@ config BCMGENET
 	select FIXED_PHY
 	select BCM7XXX_PHY
 	select MDIO_BCM_UNIMAC
+	select DIMLIB
 	help
 	  This driver supports the built-in Ethernet MACs found in the
 	  Broadcom BCM7xxx Set Top Box family chipset.
@@ -188,6 +188,7 @@ config SYSTEMPORT
 	select MII
 	select PHYLIB
 	select FIXED_PHY
+	select DIMLIB
 	help
 	  This driver supports the built-in Ethernet MACs found in the
 	  Broadcom BCM7xxx Set Top Box family chipset using an internal
@@ -200,6 +201,7 @@ config BNXT
 	select LIBCRC32C
 	select NET_DEVLINK
 	select PAGE_POOL
+	select DIMLIB
 	---help---
 	  This driver supports Broadcom NetXtreme-C/E 10/25/40/50 gigabit
 	  Ethernet cards.  To compile this driver as a module, choose M here:
