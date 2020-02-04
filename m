Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C893151BB6
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 14:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgBDN6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 08:58:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:60312 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727190AbgBDN63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 08:58:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E891BAE06;
        Tue,  4 Feb 2020 13:58:27 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net] net: sgi: ioc3-eth: Remove leftover free_irq()
Date:   Tue,  4 Feb 2020 14:58:20 +0100
Message-Id: <20200204135820.21931-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 0ce5ebd24d25 ("mfd: ioc3: Add driver for SGI IOC3 chip") moved
request_irq() from ioc3_open into probe function, but forgot to remove
free_irq() from ioc3_close.

Fixes: 0ce5ebd24d25 ("mfd: ioc3: Add driver for SGI IOC3 chip")
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index e61eb891c0f7..db6b2988e632 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -823,7 +823,6 @@ static int ioc3_close(struct net_device *dev)
 	netif_stop_queue(dev);
 
 	ioc3_stop(ip);
-	free_irq(dev->irq, dev);
 
 	ioc3_free_rx_bufs(ip);
 	ioc3_clean_tx_ring(ip);
-- 
2.24.1

