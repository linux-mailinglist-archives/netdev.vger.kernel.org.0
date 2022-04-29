Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D911515287
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 19:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379777AbiD2Rqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 13:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379775AbiD2Rqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 13:46:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B849FD3DA4
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 10:43:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AB6E623F3
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 17:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020D4C385A4;
        Fri, 29 Apr 2022 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651254212;
        bh=BUz47CqJSHJTNboLaJZKL+SHFQzlgQ98Apxu2+OWxHI=;
        h=From:To:Cc:Subject:Date:From;
        b=JyeAKxebWZBhtNFaTYMrMd4WIjMnN+Ff4LGwfAK/Z2XIcEzxlhHgkI/j8XC4jUkpj
         K4pm2WE2EGRt9ys4B7N0Ep8ed8RxTDj3JGmmaqq13lxyS0pTMiP+6yqUCzwzdtSyXx
         l/irrZykubeMGdmjiX2M1Lj+bvm3yXzyUKnnhFkx/JOZ4r9pSQ3rOIR+zxc0keUVSw
         UuYH9cIT+chWW3N4fyG5bmmu264hRg4MtZ8AVDT1Xx2nzUKSP7RR4imGlWmZX133BN
         3IEmlDh9ToWNzsLNzkkhkJMhIPXbjQG77Zw7jLZ419sesns0SF+TI+NrDivucGcK/n
         aM29htAxsNbDw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, shayagr@amazon.com,
        akiyano@amazon.com, darinzon@amazon.com, ndagan@amazon.com,
        saeedb@amazon.com, rmody@marvell.com, skalluru@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, rain.1986.08.12@gmail.com,
        zyjzyj2000@gmail.com
Subject: [PATCH net-next] eth: remove remaining copies of the NAPI_POLL_WEIGHT define
Date:   Fri, 29 Apr 2022 10:43:30 -0700
Message-Id: <20220429174330.196459-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Defining local versions of NAPI_POLL_WEIGHT with the same
values in the drivers just makes refactoring harder.

This patch covers three more drivers which I missed in
commit 5f012b40ef63 ("eth: remove copies of the NAPI_POLL_WEIGHT define").

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: shayagr@amazon.com
CC: akiyano@amazon.com
CC: darinzon@amazon.com
CC: ndagan@amazon.com
CC: saeedb@amazon.com
CC: rmody@marvell.com
CC: skalluru@marvell.com
CC: GR-Linux-NIC-Dev@marvell.com
CC: rain.1986.08.12@gmail.com
CC: zyjzyj2000@gmail.com
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 4 +---
 drivers/net/ethernet/brocade/bna/bnad.c      | 3 +--
 drivers/net/ethernet/nvidia/forcedeth.c      | 6 +++---
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 07444aead3fd..6a356a6cee15 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -31,8 +31,6 @@ MODULE_LICENSE("GPL");
 
 #define ENA_MAX_RINGS min_t(unsigned int, ENA_MAX_NUM_IO_QUEUES, num_possible_cpus())
 
-#define ENA_NAPI_BUDGET 64
-
 #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | \
 		NETIF_MSG_TX_DONE | NETIF_MSG_TX_ERR | NETIF_MSG_RX_ERR)
 
@@ -2270,7 +2268,7 @@ static void ena_init_napi_in_range(struct ena_adapter *adapter,
 		netif_napi_add(adapter->netdev,
 			       &napi->napi,
 			       ENA_IS_XDP_INDEX(adapter, i) ? ena_xdp_io_poll : ena_io_poll,
-			       ENA_NAPI_BUDGET);
+			       NAPI_POLL_WEIGHT);
 
 		if (!ENA_IS_XDP_INDEX(adapter, i)) {
 			napi->rx_ring = &adapter->rx_ring[i];
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index f1d2c4cd5da2..f6fe08df568b 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -1881,7 +1881,6 @@ bnad_napi_poll_rx(struct napi_struct *napi, int budget)
 	return rcvd;
 }
 
-#define BNAD_NAPI_POLL_QUOTA		64
 static void
 bnad_napi_add(struct bnad *bnad, u32 rx_id)
 {
@@ -1892,7 +1891,7 @@ bnad_napi_add(struct bnad *bnad, u32 rx_id)
 	for (i = 0; i <	bnad->num_rxp_per_rx; i++) {
 		rx_ctrl = &bnad->rx_info[rx_id].rx_ctrl[i];
 		netif_napi_add(bnad->netdev, &rx_ctrl->napi,
-			       bnad_napi_poll_rx, BNAD_NAPI_POLL_QUOTA);
+			       bnad_napi_poll_rx, NAPI_POLL_WEIGHT);
 	}
 }
 
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 660013f716d4..5116badaf091 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -56,8 +56,8 @@
 
 #include <asm/irq.h>
 
-#define TX_WORK_PER_LOOP  64
-#define RX_WORK_PER_LOOP  64
+#define TX_WORK_PER_LOOP  NAPI_POLL_WEIGHT
+#define RX_WORK_PER_LOOP  NAPI_POLL_WEIGHT
 
 /*
  * Hardware access:
@@ -5876,7 +5876,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	else
 		dev->netdev_ops = &nv_netdev_ops_optimized;
 
-	netif_napi_add(dev, &np->napi, nv_napi_poll, RX_WORK_PER_LOOP);
+	netif_napi_add(dev, &np->napi, nv_napi_poll, NAPI_POLL_WEIGHT);
 	dev->ethtool_ops = &ops;
 	dev->watchdog_timeo = NV_WATCHDOG_TIMEO;
 
-- 
2.34.1

