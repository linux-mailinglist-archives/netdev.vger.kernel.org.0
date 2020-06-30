Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D24D20F437
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387495AbgF3MNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:13:04 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:59984 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387472AbgF3MNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:13:04 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 37913200A8;
        Tue, 30 Jun 2020 12:13:03 +0000 (UTC)
Received: from us4-mdac16-17.at1.mdlocal (unknown [10.110.49.199])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 35B396009B;
        Tue, 30 Jun 2020 12:13:03 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.109])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D213F220077;
        Tue, 30 Jun 2020 12:13:02 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9BB39B4005A;
        Tue, 30 Jun 2020 12:13:02 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 13:12:57 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 08/14] sfc: remove duplicate declaration of
 efx_enqueue_skb_tso()
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Message-ID: <f8dc9590-011c-9d58-3e90-277bd3b08f10@solarflare.com>
Date:   Tue, 30 Jun 2020 13:12:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25512.003
X-TM-AS-Result: No-4.560200-8.000000-10
X-TMASE-MatchedRID: +HsYoNQ5ohGtZmE9gjMaXXpRh12Siy9rYu1jAfiXSs5jLp8Cm8vwFwoe
        RRhCZWIBnvBWG5GT8Jdw5T4Iaj538mJZXQNDzktSZMvt2w+qNhxcaNB/u5yQqxzSdtho/k/DnXp
        +NEmZ8z/B/FpgAkWwrhq1aUT0O7mY0g5YalgM8WkaPMGCcVm9DuBefETzWLKxhMZOnOKs8fLfCe
        KimhOjPMuoqQoR7Txlqff6w+7y1nupu3/CQpLHDBtJ4+dR6yzjZ/rAPfrtWC0HBnQgwI04wXSxt
        BjURPJIJkTkP3kjv4iRk6XtYogiau9c69BWUTGwC24oEZ6SpSmb4wHqRpnaDpNthepbmTfBWzL2
        1q9BWI2VUbvkWhFX7rzC0oRP/MN5yjVZbMt/D4GihIiSsN+E5pCZSJ9zwGMERCxHJoV+8HWB5ZX
        dWplz++19DVI++epMmpVdReMayPPYX68FmWzgr7JqpzuBzRvlw2tMTSg0x74=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.560200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25512.003
X-MDID: 1593519183-nGEuDeuA906d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define it in nic_common.h, even though the ef100 driver will have a
 different implementation backing it (actually a WARN_ON_ONCE as it
 should never get called by ef100.  But it needs to still exist because
 common TX path code references it).

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/nic.h        | 3 ---
 drivers/net/ethernet/sfc/nic_common.h | 3 +++
 drivers/net/ethernet/sfc/tx.h         | 3 ---
 drivers/net/ethernet/sfc/tx_common.c  | 2 +-
 4 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index c24dc55532c2..724e2776b585 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -306,9 +306,6 @@ extern const struct efx_nic_type efx_hunt_a0_vf_nic_type;
 
 int falcon_probe_board(struct efx_nic *efx, u16 revision_info);
 
-int efx_enqueue_skb_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
-			bool *data_mapped);
-
 /* Falcon/Siena queue operations */
 int efx_farch_tx_probe(struct efx_tx_queue *tx_queue);
 void efx_farch_tx_init(struct efx_tx_queue *tx_queue);
diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet/sfc/nic_common.h
index e90ce85359cb..8d0d163afc0d 100644
--- a/drivers/net/ethernet/sfc/nic_common.h
+++ b/drivers/net/ethernet/sfc/nic_common.h
@@ -110,6 +110,9 @@ static inline bool efx_nic_may_tx_pio(struct efx_tx_queue *tx_queue)
 	       efx_nic_tx_is_empty(partner);
 }
 
+int efx_enqueue_skb_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
+			bool *data_mapped);
+
 /* Decide whether to push a TX descriptor to the NIC vs merely writing
  * the doorbell.  This can reduce latency when we are adding a single
  * descriptor to an empty queue, but is otherwise pointless.  Further,
diff --git a/drivers/net/ethernet/sfc/tx.h b/drivers/net/ethernet/sfc/tx.h
index e04d5ddeb32c..a3cf06c5570d 100644
--- a/drivers/net/ethernet/sfc/tx.h
+++ b/drivers/net/ethernet/sfc/tx.h
@@ -18,7 +18,4 @@ unsigned int efx_tx_limit_len(struct efx_tx_queue *tx_queue,
 u8 *efx_tx_get_copy_buffer_limited(struct efx_tx_queue *tx_queue,
 				   struct efx_tx_buffer *buffer, size_t len);
 
-int efx_enqueue_skb_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
-			bool *data_mapped);
-
 #endif /* EFX_TX_H */
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 9a005e7c2c68..6ac19daa891a 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -10,7 +10,7 @@
 
 #include "net_driver.h"
 #include "efx.h"
-#include "nic.h"
+#include "nic_common.h"
 #include "tx_common.h"
 
 static unsigned int efx_tx_cb_page_count(struct efx_tx_queue *tx_queue)

