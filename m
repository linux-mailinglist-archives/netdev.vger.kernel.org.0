Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4DF199B3C
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 18:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731097AbgCaQTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 12:19:12 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:7590 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731032AbgCaQTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 12:19:12 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02VGIjNE030616;
        Tue, 31 Mar 2020 09:18:46 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     borisp@mellanox.com, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net-next v2] cxgb4/chcr: nic-tls stats in ethtool
Date:   Tue, 31 Mar 2020 21:48:42 +0530
Message-Id: <20200331161842.8165-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Included nic tls statistics in ethtool stats.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 398ade42476c..9fd496732b2c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -106,6 +106,15 @@ static char adapter_stats_strings[][ETH_GSTRING_LEN] = {
 	"db_empty               ",
 	"write_coal_success     ",
 	"write_coal_fail        ",
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+	"tx_tls_encrypted_packets",
+	"tx_tls_encrypted_bytes  ",
+	"tx_tls_ctx              ",
+	"tx_tls_ooo              ",
+	"tx_tls_skip_no_sync_data",
+	"tx_tls_drop_no_sync_data",
+	"tx_tls_drop_bypass_req  ",
+#endif
 };
 
 static char loopback_stats_strings[][ETH_GSTRING_LEN] = {
@@ -232,6 +241,15 @@ struct adapter_stats {
 	u64 db_empty;
 	u64 wc_success;
 	u64 wc_fail;
+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+	u64 tx_tls_encrypted_packets;
+	u64 tx_tls_encrypted_bytes;
+	u64 tx_tls_ctx;
+	u64 tx_tls_ooo;
+	u64 tx_tls_skip_no_sync_data;
+	u64 tx_tls_drop_no_sync_data;
+	u64 tx_tls_drop_bypass_req;
+#endif
 };
 
 static void collect_sge_port_stats(const struct adapter *adap,
-- 
2.18.1

