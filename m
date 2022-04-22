Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6E850BAFA
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449087AbiDVPD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449130AbiDVPCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:02:36 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDEC45C84C
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 07:59:42 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 20D93320133;
        Fri, 22 Apr 2022 15:59:42 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhul3-0007AW-Dh; Fri, 22 Apr 2022 15:59:41 +0100
Subject: [PATCH net-next 12/28] sfc/siena: Rename functions in selftest.h to
 avoid conflicts with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 15:59:40 +0100
Message-ID: <165063958084.27138.9761996324462456979.stgit@palantir17.mph.net>
In-Reply-To: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For siena use efx_siena_ as the function prefix.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx.c            |    2 +-
 drivers/net/ethernet/sfc/siena/efx_common.c     |    4 ++--
 drivers/net/ethernet/sfc/siena/ethtool_common.c |    2 +-
 drivers/net/ethernet/sfc/siena/rx.c             |    2 +-
 drivers/net/ethernet/sfc/siena/selftest.c       |   24 ++++++++++++-----------
 drivers/net/ethernet/sfc/siena/selftest.h       |   14 +++++++------
 6 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index 70da9d7afbc5..ddd9dda1779e 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -536,7 +536,7 @@ static int efx_net_open(struct net_device *net_dev)
 	efx_siena_start_all(efx);
 	if (efx->state == STATE_DISABLED || efx->reset_pending)
 		netif_device_detach(efx->net_dev);
-	efx_selftest_async_start(efx);
+	efx_siena_selftest_async_start(efx);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index f245d03c4caa..fc2677e9020a 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -514,7 +514,7 @@ static void efx_stop_port(struct efx_nic *efx)
 	netif_addr_unlock_bh(efx->net_dev);
 
 	cancel_delayed_work_sync(&efx->monitor_work);
-	efx_selftest_async_cancel(efx);
+	efx_siena_selftest_async_cancel(efx);
 	cancel_work_sync(&efx->mac_work);
 }
 
@@ -994,7 +994,7 @@ int efx_siena_init_struct(struct efx_nic *efx,
 #endif
 	INIT_WORK(&efx->reset_work, efx_reset_work);
 	INIT_DELAYED_WORK(&efx->monitor_work, efx_monitor);
-	efx_selftest_async_init(efx);
+	efx_siena_selftest_async_init(efx);
 	efx->pci_dev = pci_dev;
 	efx->msg_enable = debug;
 	efx->state = STATE_UNINIT;
diff --git a/drivers/net/ethernet/sfc/siena/ethtool_common.c b/drivers/net/ethernet/sfc/siena/ethtool_common.c
index f54510cf4e72..0c19d26e1872 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool_common.c
@@ -156,7 +156,7 @@ void efx_ethtool_self_test(struct net_device *net_dev,
 		}
 	}
 
-	rc = efx_selftest(efx, efx_tests, test->flags);
+	rc = efx_siena_selftest(efx, efx_tests, test->flags);
 
 	if (!already_up)
 		dev_close(efx->net_dev);
diff --git a/drivers/net/ethernet/sfc/siena/rx.c b/drivers/net/ethernet/sfc/siena/rx.c
index 47c09b93f7c4..98d3c0743c0f 100644
--- a/drivers/net/ethernet/sfc/siena/rx.c
+++ b/drivers/net/ethernet/sfc/siena/rx.c
@@ -377,7 +377,7 @@ void __efx_siena_rx_packet(struct efx_channel *channel)
 	if (unlikely(efx->loopback_selftest)) {
 		struct efx_rx_queue *rx_queue;
 
-		efx_loopback_rx_packet(efx, eh, rx_buf->len);
+		efx_siena_loopback_rx_packet(efx, eh, rx_buf->len);
 		rx_queue = efx_channel_get_rx_queue(channel);
 		efx_siena_free_rx_buffers(rx_queue, rx_buf,
 					  channel->rx_pkt_n_frags);
diff --git a/drivers/net/ethernet/sfc/siena/selftest.c b/drivers/net/ethernet/sfc/siena/selftest.c
index 7e24329bc005..83bd27df30d4 100644
--- a/drivers/net/ethernet/sfc/siena/selftest.c
+++ b/drivers/net/ethernet/sfc/siena/selftest.c
@@ -69,7 +69,7 @@ static const char *const efx_siena_interrupt_mode_names[] = {
 
 /**
  * struct efx_loopback_state - persistent state during a loopback selftest
- * @flush:		Drop all packets in efx_loopback_rx_packet
+ * @flush:		Drop all packets in efx_siena_loopback_rx_packet
  * @packet_count:	Number of packets being used in this test
  * @skbs:		An array of skbs transmitted
  * @offload_csum:	Checksums are being offloaded
@@ -278,8 +278,8 @@ static int efx_test_phy(struct efx_nic *efx, struct efx_self_tests *tests,
 /* Loopback test RX callback
  * This is called for each received packet during loopback testing.
  */
-void efx_loopback_rx_packet(struct efx_nic *efx,
-			    const char *buf_ptr, int pkt_len)
+void efx_siena_loopback_rx_packet(struct efx_nic *efx,
+				  const char *buf_ptr, int pkt_len)
 {
 	struct efx_loopback_state *state = efx->loopback_selftest;
 	struct efx_loopback_payload *received;
@@ -369,7 +369,7 @@ void efx_loopback_rx_packet(struct efx_nic *efx,
 	atomic_inc(&state->rx_bad);
 }
 
-/* Initialise an efx_selftest_state for a new iteration */
+/* Initialise an efx_siena_selftest_state for a new iteration */
 static void efx_iterate_state(struct efx_nic *efx)
 {
 	struct efx_loopback_state *state = efx->loopback_selftest;
@@ -684,14 +684,14 @@ static int efx_test_loopbacks(struct efx_nic *efx, struct efx_self_tests *tests,
  *
  *************************************************************************/
 
-int efx_selftest(struct efx_nic *efx, struct efx_self_tests *tests,
-		 unsigned flags)
+int efx_siena_selftest(struct efx_nic *efx, struct efx_self_tests *tests,
+		       unsigned int flags)
 {
 	enum efx_loopback_mode loopback_mode = efx->loopback_mode;
 	int phy_mode = efx->phy_mode;
 	int rc_test = 0, rc_reset, rc;
 
-	efx_selftest_async_cancel(efx);
+	efx_siena_selftest_async_cancel(efx);
 
 	/* Online (i.e. non-disruptive) testing
 	 * This checks interrupt generation, event delivery and PHY presence. */
@@ -767,7 +767,7 @@ int efx_selftest(struct efx_nic *efx, struct efx_self_tests *tests,
 	return rc_test;
 }
 
-void efx_selftest_async_start(struct efx_nic *efx)
+void efx_siena_selftest_async_start(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 
@@ -776,12 +776,12 @@ void efx_selftest_async_start(struct efx_nic *efx)
 	schedule_delayed_work(&efx->selftest_work, IRQ_TIMEOUT);
 }
 
-void efx_selftest_async_cancel(struct efx_nic *efx)
+void efx_siena_selftest_async_cancel(struct efx_nic *efx)
 {
 	cancel_delayed_work_sync(&efx->selftest_work);
 }
 
-static void efx_selftest_async_work(struct work_struct *data)
+static void efx_siena_selftest_async_work(struct work_struct *data)
 {
 	struct efx_nic *efx = container_of(data, struct efx_nic,
 					   selftest_work.work);
@@ -801,7 +801,7 @@ static void efx_selftest_async_work(struct work_struct *data)
 	}
 }
 
-void efx_selftest_async_init(struct efx_nic *efx)
+void efx_siena_selftest_async_init(struct efx_nic *efx)
 {
-	INIT_DELAYED_WORK(&efx->selftest_work, efx_selftest_async_work);
+	INIT_DELAYED_WORK(&efx->selftest_work, efx_siena_selftest_async_work);
 }
diff --git a/drivers/net/ethernet/sfc/siena/selftest.h b/drivers/net/ethernet/sfc/siena/selftest.h
index a23f085bf298..6af6e7fbfcee 100644
--- a/drivers/net/ethernet/sfc/siena/selftest.h
+++ b/drivers/net/ethernet/sfc/siena/selftest.h
@@ -41,12 +41,12 @@ struct efx_self_tests {
 	struct efx_loopback_self_tests loopback[LOOPBACK_TEST_MAX + 1];
 };
 
-void efx_loopback_rx_packet(struct efx_nic *efx, const char *buf_ptr,
-			    int pkt_len);
-int efx_selftest(struct efx_nic *efx, struct efx_self_tests *tests,
-		 unsigned flags);
-void efx_selftest_async_init(struct efx_nic *efx);
-void efx_selftest_async_start(struct efx_nic *efx);
-void efx_selftest_async_cancel(struct efx_nic *efx);
+void efx_siena_loopback_rx_packet(struct efx_nic *efx, const char *buf_ptr,
+				  int pkt_len);
+int efx_siena_selftest(struct efx_nic *efx, struct efx_self_tests *tests,
+		       unsigned int flags);
+void efx_siena_selftest_async_init(struct efx_nic *efx);
+void efx_siena_selftest_async_start(struct efx_nic *efx);
+void efx_siena_selftest_async_cancel(struct efx_nic *efx);
 
 #endif /* EFX_SELFTEST_H */

