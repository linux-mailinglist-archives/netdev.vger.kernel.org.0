Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE0F1B0203
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbfIKQuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:50:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:31967 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729357AbfIKQuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 12:50:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 09:50:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="385759046"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 11 Sep 2019 09:50:15 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 03/13] ixgbe: use skb_get_queue_mapping in tx path
Date:   Wed, 11 Sep 2019 09:50:04 -0700
Message-Id: <20190911165014.10742-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190911165014.10742-1-jeffrey.t.kirsher@intel.com>
References: <20190911165014.10742-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Use the common api, and don't access queue_mapping directly.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 95c0827dfd4c..dc034f4e8cf6 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8748,7 +8748,7 @@ static netdev_tx_t __ixgbe_xmit_frame(struct sk_buff *skb,
 	if (skb_put_padto(skb, 17))
 		return NETDEV_TX_OK;
 
-	tx_ring = ring ? ring : adapter->tx_ring[skb->queue_mapping];
+	tx_ring = ring ? ring : adapter->tx_ring[skb_get_queue_mapping(skb)];
 	if (unlikely(test_bit(__IXGBE_TX_DISABLED, &tx_ring->state)))
 		return NETDEV_TX_BUSY;
 
-- 
2.21.0

