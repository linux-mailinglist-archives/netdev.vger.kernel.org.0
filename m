Return-Path: <netdev+bounces-2546-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8424570278C
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:49:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C611E28102E
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 357458470;
	Mon, 15 May 2023 08:49:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD223D6D
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 08:49:24 +0000 (UTC)
Received: from mail.nfschina.com (unknown [42.101.60.195])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id D0C941BC6;
	Mon, 15 May 2023 01:49:20 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
	by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 3986A18011BDB5;
	Mon, 15 May 2023 16:49:08 +0800 (CST)
X-MD-Sfrom: yunchuan@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: wuych <yunchuan@nfschina.com>
To: dchickles@marvell.com,
	sburla@marvell.com,
	fmanlunas@marvell.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	wuych <yunchuan@nfschina.com>
Subject: [PATCH net-next] net: liquidio: lio_core: Remove unnecessary (void*) conversions
Date: Mon, 15 May 2023 16:49:06 +0800
Message-Id: <20230515084906.61491-1-yunchuan@nfschina.com>
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
 drivers/net/ethernet/cavium/liquidio/lio_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
index 882b2be06ea0..10d9dab26c92 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
@@ -904,8 +904,7 @@ static
 int liquidio_schedule_msix_droq_pkt_handler(struct octeon_droq *droq, u64 ret)
 {
 	struct octeon_device *oct = droq->oct_dev;
-	struct octeon_device_priv *oct_priv =
-	    (struct octeon_device_priv *)oct->priv;
+	struct octeon_device_priv *oct_priv = oct->priv;
 
 	if (droq->ops.poll_mode) {
 		droq->ops.napi_fn(droq);
@@ -947,8 +946,7 @@ liquidio_msix_intr_handler(int __maybe_unused irq, void *dev)
  */
 static void liquidio_schedule_droq_pkt_handlers(struct octeon_device *oct)
 {
-	struct octeon_device_priv *oct_priv =
-		(struct octeon_device_priv *)oct->priv;
+	struct octeon_device_priv *oct_priv = oct->priv;
 	struct octeon_droq *droq;
 	u64 oq_no;
 
-- 
2.30.2


