Return-Path: <netdev+bounces-2004-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 661D26FFF0B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 04:44:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83F2828179A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 02:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 666897ED;
	Fri, 12 May 2023 02:44:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C047E9
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 02:44:11 +0000 (UTC)
Received: from mail.nfschina.com (unknown [42.101.60.195])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id CC2CF55A2;
	Thu, 11 May 2023 19:44:09 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
	by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id B0960180028342;
	Fri, 12 May 2023 10:44:05 +0800 (CST)
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
Subject: [PATCH net-next] net: liquidio: lio_main: Remove unnecessary (void*) conversions
Date: Fri, 12 May 2023 10:44:03 +0800
Message-Id: <20230512024403.691018-1-yunchuan@nfschina.com>
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
 .../net/ethernet/cavium/liquidio/lio_main.c    | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 9bd1d2d7027d..100daadbea2a 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -191,8 +191,7 @@ static void octeon_droq_bh(struct tasklet_struct *t)
 
 static int lio_wait_for_oq_pkts(struct octeon_device *oct)
 {
-	struct octeon_device_priv *oct_priv =
-		(struct octeon_device_priv *)oct->priv;
+	struct octeon_device_priv *oct_priv = oct->priv;
 	int retry = 100, pkt_cnt = 0, pending_pkts = 0;
 	int i;
 
@@ -950,8 +949,7 @@ static void octeon_destroy_resources(struct octeon_device *oct)
 {
 	int i, refcount;
 	struct msix_entry *msix_entries;
-	struct octeon_device_priv *oct_priv =
-		(struct octeon_device_priv *)oct->priv;
+	struct octeon_device_priv *oct_priv = oct->priv;
 
 	struct handshake *hs;
 
@@ -1211,8 +1209,7 @@ static int send_rx_ctrl_cmd(struct lio *lio, int start_stop)
 static void liquidio_destroy_nic_device(struct octeon_device *oct, int ifidx)
 {
 	struct net_device *netdev = oct->props[ifidx].netdev;
-	struct octeon_device_priv *oct_priv =
-		(struct octeon_device_priv *)oct->priv;
+	struct octeon_device_priv *oct_priv = oct->priv;
 	struct napi_struct *napi, *n;
 	struct lio *lio;
 
@@ -1774,8 +1771,7 @@ static int liquidio_open(struct net_device *netdev)
 {
 	struct lio *lio = GET_LIO(netdev);
 	struct octeon_device *oct = lio->oct_dev;
-	struct octeon_device_priv *oct_priv =
-		(struct octeon_device_priv *)oct->priv;
+	struct octeon_device_priv *oct_priv = oct->priv;
 	struct napi_struct *napi, *n;
 	int ret = 0;
 
@@ -1855,8 +1851,7 @@ static int liquidio_stop(struct net_device *netdev)
 {
 	struct lio *lio = GET_LIO(netdev);
 	struct octeon_device *oct = lio->oct_dev;
-	struct octeon_device_priv *oct_priv =
-		(struct octeon_device_priv *)oct->priv;
+	struct octeon_device_priv *oct_priv = oct->priv;
 	struct napi_struct *napi, *n;
 	int ret = 0;
 
@@ -4057,8 +4052,7 @@ static int octeon_device_init(struct octeon_device *octeon_dev)
 	char bootcmd[] = "\n";
 	char *dbg_enb = NULL;
 	enum lio_fw_state fw_state;
-	struct octeon_device_priv *oct_priv =
-		(struct octeon_device_priv *)octeon_dev->priv;
+	struct octeon_device_priv *oct_priv = octeon_dev->priv;
 	atomic_set(&octeon_dev->status, OCT_DEV_BEGIN_STATE);
 
 	/* Enable access to the octeon device and make its DMA capability
-- 
2.30.2


