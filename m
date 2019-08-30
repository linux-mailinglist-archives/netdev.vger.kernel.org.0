Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC4B5A33CA
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 11:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbfH3J0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 05:26:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:41778 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728236AbfH3JZ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 05:25:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BB163B0B6;
        Fri, 30 Aug 2019 09:25:57 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 net-next 13/15] net: sgi: ioc3-eth: Fix IPG settings
Date:   Fri, 30 Aug 2019 11:25:36 +0200
Message-Id: <20190830092539.24550-14-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190830092539.24550-1-tbogendoerfer@suse.de>
References: <20190830092539.24550-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The half/full duplex settings for inter packet gap counters/timer were
reversed.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 05f4b598114c..971986433d4c 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -79,8 +79,8 @@
 #define RX_OFFSET		(sizeof(struct ioc3_erxbuf) + NET_IP_ALIGN)
 #define RX_BUF_SIZE		(13 * IOC3_DMA_XFER_LEN)
 
-#define ETCSR_FD   ((17 << ETCSR_IPGR2_SHIFT) | (11 << ETCSR_IPGR1_SHIFT) | 21)
-#define ETCSR_HD   ((21 << ETCSR_IPGR2_SHIFT) | (21 << ETCSR_IPGR1_SHIFT) | 21)
+#define ETCSR_FD   ((21 << ETCSR_IPGR2_SHIFT) | (21 << ETCSR_IPGR1_SHIFT) | 21)
+#define ETCSR_HD   ((17 << ETCSR_IPGR2_SHIFT) | (11 << ETCSR_IPGR1_SHIFT) | 21)
 
 /* Private per NIC data of the driver.  */
 struct ioc3_private {
-- 
2.13.7

