Return-Path: <netdev+bounces-3161-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97248705D45
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 04:28:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C25DB28137B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 02:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FFE311C89;
	Wed, 17 May 2023 02:28:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1514B23DB
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 02:28:02 +0000 (UTC)
Received: from mail.nfschina.com (unknown [42.101.60.195])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id 34CF5469E;
	Tue, 16 May 2023 19:27:46 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
	by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 9CD0B180120CAB;
	Wed, 17 May 2023 10:27:06 +0800 (CST)
X-MD-Sfrom: yunchuan@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: wuych <yunchuan@nfschina.com>
To: rmody@marvell.com,
	skalluru@marvell.com,
	GR-Linux-NIC-Dev@marvell.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	wuych <yunchuan@nfschina.com>
Subject: [PATCH net-next] net: bna: bnad:  Remove unnecessary (void*) conversions
Date: Wed, 17 May 2023 10:27:05 +0800
Message-Id: <20230517022705.112448-1-yunchuan@nfschina.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Pointer variables of void * type do not require type cast.

Signed-off-by: wuych <yunchuan@nfschina.com>
---
 drivers/net/ethernet/brocade/bna/bnad.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index d6d90f9722a7..31191b520b58 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -1037,8 +1037,7 @@ bnad_cb_ccb_destroy(struct bnad *bnad, struct bna_ccb *ccb)
 static void
 bnad_cb_tx_stall(struct bnad *bnad, struct bna_tx *tx)
 {
-	struct bnad_tx_info *tx_info =
-			(struct bnad_tx_info *)tx->priv;
+	struct bnad_tx_info *tx_info = tx->priv;
 	struct bna_tcb *tcb;
 	u32 txq_id;
 	int i;
@@ -1056,7 +1055,7 @@ bnad_cb_tx_stall(struct bnad *bnad, struct bna_tx *tx)
 static void
 bnad_cb_tx_resume(struct bnad *bnad, struct bna_tx *tx)
 {
-	struct bnad_tx_info *tx_info = (struct bnad_tx_info *)tx->priv;
+	struct bnad_tx_info *tx_info = tx->priv;
 	struct bna_tcb *tcb;
 	u32 txq_id;
 	int i;
@@ -1133,7 +1132,7 @@ bnad_tx_cleanup(struct delayed_work *work)
 static void
 bnad_cb_tx_cleanup(struct bnad *bnad, struct bna_tx *tx)
 {
-	struct bnad_tx_info *tx_info = (struct bnad_tx_info *)tx->priv;
+	struct bnad_tx_info *tx_info = tx->priv;
 	struct bna_tcb *tcb;
 	int i;
 
@@ -1149,7 +1148,7 @@ bnad_cb_tx_cleanup(struct bnad *bnad, struct bna_tx *tx)
 static void
 bnad_cb_rx_stall(struct bnad *bnad, struct bna_rx *rx)
 {
-	struct bnad_rx_info *rx_info = (struct bnad_rx_info *)rx->priv;
+	struct bnad_rx_info *rx_info = rx->priv;
 	struct bna_ccb *ccb;
 	struct bnad_rx_ctrl *rx_ctrl;
 	int i;
@@ -1208,7 +1207,7 @@ bnad_rx_cleanup(void *work)
 static void
 bnad_cb_rx_cleanup(struct bnad *bnad, struct bna_rx *rx)
 {
-	struct bnad_rx_info *rx_info = (struct bnad_rx_info *)rx->priv;
+	struct bnad_rx_info *rx_info = rx->priv;
 	struct bna_ccb *ccb;
 	struct bnad_rx_ctrl *rx_ctrl;
 	int i;
@@ -1231,7 +1230,7 @@ bnad_cb_rx_cleanup(struct bnad *bnad, struct bna_rx *rx)
 static void
 bnad_cb_rx_post(struct bnad *bnad, struct bna_rx *rx)
 {
-	struct bnad_rx_info *rx_info = (struct bnad_rx_info *)rx->priv;
+	struct bnad_rx_info *rx_info = rx->priv;
 	struct bna_ccb *ccb;
 	struct bna_rcb *rcb;
 	struct bnad_rx_ctrl *rx_ctrl;
-- 
2.30.2


