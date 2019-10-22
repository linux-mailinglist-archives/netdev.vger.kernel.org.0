Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09826E072F
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbfJVPWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:22:12 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:60572 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731053AbfJVPWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 11:22:12 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iMvz4-0006E1-NU; Tue, 22 Oct 2019 16:22:06 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.3)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iMvz4-00035O-CL; Tue, 22 Oct 2019 16:22:06 +0100
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     linux-kernel@lists.codethink.co.uk
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: mvneta: make stub functions static inline
Date:   Tue, 22 Oct 2019 16:22:05 +0100
Message-Id: <20191022152205.11815-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the CONFIG_MVNET_BA is not set, then make the stub functions
static inline to avoid trying to export them, and remove hte
following sparse warnings:

drivers/net/ethernet/marvell/mvneta_bm.h:163:6: warning: symbol 'mvneta_bm_pool_destroy' was not declared. Should it be static?
drivers/net/ethernet/marvell/mvneta_bm.h:165:6: warning: symbol 'mvneta_bm_bufs_free' was not declared. Should it be static?
drivers/net/ethernet/marvell/mvneta_bm.h:167:5: warning: symbol 'mvneta_bm_construct' was not declared. Should it be static?
drivers/net/ethernet/marvell/mvneta_bm.h:168:5: warning: symbol 'mvneta_bm_pool_refill' was not declared. Should it be static?
drivers/net/ethernet/marvell/mvneta_bm.h:170:23: warning: symbol 'mvneta_bm_pool_use' was not declared. Should it be static?
drivers/net/ethernet/marvell/mvneta_bm.h:181:18: warning: symbol 'mvneta_bm_get' was not declared. Should it be static?
drivers/net/ethernet/marvell/mvneta_bm.h:182:6: warning: symbol 'mvneta_bm_put' was not declared. Should it be static?

Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
---
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/marvell/mvneta_bm.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta_bm.h b/drivers/net/ethernet/marvell/mvneta_bm.h
index c8425d35c049..9c0c6e20cf80 100644
--- a/drivers/net/ethernet/marvell/mvneta_bm.h
+++ b/drivers/net/ethernet/marvell/mvneta_bm.h
@@ -160,14 +160,14 @@ static inline u32 mvneta_bm_pool_get_bp(struct mvneta_bm *priv,
 			     (bm_pool->id << MVNETA_BM_POOL_ACCESS_OFFS));
 }
 #else
-void mvneta_bm_pool_destroy(struct mvneta_bm *priv,
-			    struct mvneta_bm_pool *bm_pool, u8 port_map) {}
-void mvneta_bm_bufs_free(struct mvneta_bm *priv, struct mvneta_bm_pool *bm_pool,
-			 u8 port_map) {}
-int mvneta_bm_construct(struct hwbm_pool *hwbm_pool, void *buf) { return 0; }
-int mvneta_bm_pool_refill(struct mvneta_bm *priv,
-			  struct mvneta_bm_pool *bm_pool) {return 0; }
-struct mvneta_bm_pool *mvneta_bm_pool_use(struct mvneta_bm *priv, u8 pool_id,
+static inline void mvneta_bm_pool_destroy(struct mvneta_bm *priv,
+					  struct mvneta_bm_pool *bm_pool, u8 port_map) {}
+static inline void mvneta_bm_bufs_free(struct mvneta_bm *priv, struct mvneta_bm_pool *bm_pool,
+				       u8 port_map) {}
+static inline int mvneta_bm_construct(struct hwbm_pool *hwbm_pool, void *buf) { return 0; }
+static inline int mvneta_bm_pool_refill(struct mvneta_bm *priv,
+					struct mvneta_bm_pool *bm_pool) {return 0; }
+static inline struct mvneta_bm_pool *mvneta_bm_pool_use(struct mvneta_bm *priv, u8 pool_id,
 					  enum mvneta_bm_type type, u8 port_id,
 					  int pkt_size) { return NULL; }
 
@@ -178,7 +178,7 @@ static inline void mvneta_bm_pool_put_bp(struct mvneta_bm *priv,
 static inline u32 mvneta_bm_pool_get_bp(struct mvneta_bm *priv,
 					struct mvneta_bm_pool *bm_pool)
 { return 0; }
-struct mvneta_bm *mvneta_bm_get(struct device_node *node) { return NULL; }
-void mvneta_bm_put(struct mvneta_bm *priv) {}
+static inline struct mvneta_bm *mvneta_bm_get(struct device_node *node) { return NULL; }
+static inline void mvneta_bm_put(struct mvneta_bm *priv) {}
 #endif /* CONFIG_MVNETA_BM */
 #endif
-- 
2.23.0

