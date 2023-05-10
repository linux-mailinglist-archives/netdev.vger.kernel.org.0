Return-Path: <netdev+bounces-1332-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC0E6FD688
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6BF22813D8
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 06:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B9E95686;
	Wed, 10 May 2023 06:07:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F002D65A
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 06:07:39 +0000 (UTC)
Received: from mail.nfschina.com (unknown [42.101.60.195])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id 21C022715;
	Tue,  9 May 2023 23:07:14 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
	by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 8EFCA1800C81C0;
	Wed, 10 May 2023 14:06:50 +0800 (CST)
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
	wuych <yunchuan@nfschina.com>
Subject: [PATCH net-next] net: liquidio: lio_vf_main: Remove unnecessary (void*) conversions
Date: Wed, 10 May 2023 14:06:49 +0800
Message-Id: <20230510060649.210238-1-yunchuan@nfschina.com>
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
 .../net/ethernet/cavium/liquidio/lio_vf_main.c    | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index e2921aec3da0..62c2eadc33e3 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -72,8 +72,7 @@ static int liquidio_stop(struct net_device *netdev);
 
 static int lio_wait_for_oq_pkts(struct octeon_device *oct)
 {
-	struct octeon_device_priv *oct_priv =
-	    (struct octeon_device_priv *)oct->priv;
+	struct octeon_device_priv *oct_priv = oct->priv;
 	int retry = MAX_IO_PENDING_PKT_COUNT;
 	int pkt_cnt = 0, pending_pkts;
 	int i;
@@ -442,8 +441,7 @@ static void octeon_pci_flr(struct octeon_device *oct)
  */
 static void octeon_destroy_resources(struct octeon_device *oct)
 {
-	struct octeon_device_priv *oct_priv =
-		(struct octeon_device_priv *)oct->priv;
+	struct octeon_device_priv *oct_priv = oct->priv;
 	struct msix_entry *msix_entries;
 	int i;
 
@@ -659,8 +657,7 @@ static int send_rx_ctrl_cmd(struct lio *lio, int start_stop)
 static void liquidio_destroy_nic_device(struct octeon_device *oct, int ifidx)
 {
 	struct net_device *netdev = oct->props[ifidx].netdev;
-	struct octeon_device_priv *oct_priv =
-		(struct octeon_device_priv *)oct->priv;
+	struct octeon_device_priv *oct_priv = oct->priv;
 	struct napi_struct *napi, *n;
 	struct lio *lio;
 
@@ -909,8 +906,7 @@ static int liquidio_open(struct net_device *netdev)
 {
 	struct lio *lio = GET_LIO(netdev);
 	struct octeon_device *oct = lio->oct_dev;
-	struct octeon_device_priv *oct_priv =
-		(struct octeon_device_priv *)oct->priv;
+	struct octeon_device_priv *oct_priv = oct->priv;
 	struct napi_struct *napi, *n;
 	int ret = 0;
 
@@ -956,8 +952,7 @@ static int liquidio_stop(struct net_device *netdev)
 {
 	struct lio *lio = GET_LIO(netdev);
 	struct octeon_device *oct = lio->oct_dev;
-	struct octeon_device_priv *oct_priv =
-		(struct octeon_device_priv *)oct->priv;
+	struct octeon_device_priv *oct_priv = oct->priv;
 	struct napi_struct *napi, *n;
 	int ret = 0;
 
-- 
2.30.2


