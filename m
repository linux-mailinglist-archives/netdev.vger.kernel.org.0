Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86380E683D
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 22:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731643AbfJ0VXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 17:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732282AbfJ0VXJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 17:23:09 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D3702064A;
        Sun, 27 Oct 2019 21:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211388;
        bh=qZbmyqNoqqWSNldczzl40r7M2ckjjBMdmgyd9fPtQOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsYwpYxxAnqI3Lawo4vDD0SSoiz17vziIc3xJbtjMGfIBpgtdNagEQiW+Evu/3+R0
         2o2Iy9We+hN7p0sQeCv6/eLOj6ktl0lkmQKgAZInxmqDacRvPM8x0PaBqFc/anvtIi
         S5E/zxstM87KBP+7lQHrYk3iwJZCce9w6pPWUtO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        Tal Gilboa <talgi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.3 090/197] net: ethernet: broadcom: have drivers select DIMLIB as needed
Date:   Sun, 27 Oct 2019 22:00:08 +0100
Message-Id: <20191027203356.604595451@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit ddc790e92b3afa4e366ffb41818cfcd19015031e ]

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
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/Kconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
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


