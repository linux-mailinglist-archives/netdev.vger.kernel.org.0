Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351DE507E22
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 03:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358726AbiDTBaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 21:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358727AbiDTBai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 21:30:38 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13EC24F0E;
        Tue, 19 Apr 2022 18:27:54 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-e5ca5c580fso486552fac.3;
        Tue, 19 Apr 2022 18:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sLw0H6R3WlK1bcOpwRAGg46brAmczPbRTJQlw64+BQ8=;
        b=ignMrrjTawt+RSJ85pYU7pXLiyjs3Ks/hQyy+Go6XWmeKMgb/NaIB461stfVcxPrP4
         cdZvnpkvayzPNy+rlxYER67Xx+obKhbVtiGtE2izGTJtB5EJmCjVQABAtaAB0srcu/ry
         drprU5w2y0gyfR8HOGUsxKIG1X/0qf99a4hH0YGqeyEYT/g04lNZ8bA7oYvx8jPU7V8l
         0x63eDNKr1euZoW6py3M/o63QlfaCqNmZTDajJ5xHKMh+KMyQBYYsAImc+K2+Y5nIAJS
         wahqAuPRHf+UYJGyFINaUf+mutvjhiR3t8ysGopcxDS+QZLxnKgbdeAFmqkXrkJUVVee
         ni9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sLw0H6R3WlK1bcOpwRAGg46brAmczPbRTJQlw64+BQ8=;
        b=cw8bHzs28sUw+9FfJpN37AnvXBNZ9HqV71RFFUJv1mHDntmn29/IsiPgzhbV1WYrDK
         DGNdbpZAbqnw60Olbm7dn+SucGeefb0bWInbbC4L3H0vddEEJdA7wWpW8iSNJnIGti6K
         xIeSKr3sLKqxCF2KCRAskrtv4KLTvCBwpDl6Ar7UnDtfMLDm/qbtj4wrXQg9rygsQTzX
         VcxSXfKl+WwzUGi0+z2YTJRHIk1Zy0Vvw3cCJ/vd/BIwBQBSJ4iotv7xlH5iWBq5lwWk
         ZIonLRvvOkXUGcKehnN0sj7RA0mKa1wKeeBWodpgqqq3RrtWO0lxBI8/WZk+N4f6IyUU
         lpmw==
X-Gm-Message-State: AOAM530rq9+k38cRToMLKPVCXUzWRELD9sJtpxhGF3m7ULtKxDiDAC83
        G2ebor25vYqaOXHxptvDTjs=
X-Google-Smtp-Source: ABdhPJyWXSgaXneeXdK00kRCm4zrorvjleC1IZX7daIwNfz00gwfZryMocgkAbGgY7JP06Gy/3n8vg==
X-Received: by 2002:a05:6870:f624:b0:e1:c071:121b with SMTP id ek36-20020a056870f62400b000e1c071121bmr594369oab.182.1650418073912;
        Tue, 19 Apr 2022 18:27:53 -0700 (PDT)
Received: from toe.qscaudio.com ([65.113.122.35])
        by smtp.gmail.com with ESMTPSA id i26-20020a4a929a000000b0033a29c8d564sm4284530ooh.3.2022.04.19.18.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 18:27:53 -0700 (PDT)
From:   jeff.evanson@gmail.com
X-Google-Original-From: jeff.evanson@qsc.com
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vedang Patel <vedang.patel@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc:     Jeff Evanson <jeff.evanson@qsc.com>
Subject: [PATCH v2 2/2] igc: Trigger proper interrupts in igc_xsk_wakeup
Date:   Tue, 19 Apr 2022 19:26:35 -0600
Message-Id: <20220420012635.13733-3-jeff.evanson@qsc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220420012635.13733-1-jeff.evanson@qsc.com>
References: <20220420012635.13733-1-jeff.evanson@qsc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Evanson <jeff.evanson@qsc.com>

In igc_xsk_wakeup, trigger the proper interrupt based on whether flags
contains XDP_WAKEUP_RX and/or XDP_WAKEUP_TX.

Consider a scenario where the transmit queue interrupt is mapped to a
different irq from the receive queue. If XDP_WAKEUP_TX is set in the
flags argument, the interrupt for transmit queue must be triggered,
otherwise the transmit queue's napi_struct will never be scheduled.

In the case where both XDP_WAKEUP_TX and XDP_WAKEUP_RX are both set,
the receive interrupt should always be triggered, but the transmit
interrupt should only be triggered if its q_vector differs from the
receive queue's interrupt.

Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
---
 drivers/net/ethernet/intel/igc/igc_main.c | 40 ++++++++++++++++++-----
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index a36a18c84aeb..41b5d1ac8bc1 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6072,8 +6072,8 @@ static void igc_trigger_rxtxq_interrupt(struct igc_adapter *adapter,
 
 int igc_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 {
+	struct igc_q_vector *txq_vector = NULL, *rxq_vector = NULL;
 	struct igc_adapter *adapter = netdev_priv(dev);
-	struct igc_q_vector *q_vector;
 	struct igc_ring *ring;
 
 	if (test_bit(__IGC_DOWN, &adapter->state))
@@ -6082,17 +6082,39 @@ int igc_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 	if (!igc_xdp_is_enabled(adapter))
 		return -ENXIO;
 
-	if (queue_id >= adapter->num_rx_queues)
-		return -EINVAL;
+	if (flags & XDP_WAKEUP_RX) {
+		if (queue_id >= adapter->num_rx_queues)
+			return -EINVAL;
 
-	ring = adapter->rx_ring[queue_id];
+		ring = adapter->rx_ring[queue_id];
+		if (!ring->xsk_pool)
+			return -ENXIO;
 
-	if (!ring->xsk_pool)
-		return -ENXIO;
+		rxq_vector = ring->q_vector;
+	}
+
+	if (flags & XDP_WAKEUP_TX) {
+		if (queue_id >= adapter->num_tx_queues)
+			return -EINVAL;
+
+		ring = adapter->tx_ring[queue_id];
+		if (!ring->xsk_pool)
+			return -ENXIO;
+
+		txq_vector = ring->q_vector;
+	}
+
+	if (rxq_vector != NULL &&
+	    !napi_if_scheduled_mark_missed(&rxq_vector->napi))
+		igc_trigger_rxtxq_interrupt(adapter, rxq_vector);
 
-	q_vector = adapter->q_vector[queue_id];
-	if (!napi_if_scheduled_mark_missed(&q_vector->napi))
-		igc_trigger_rxtxq_interrupt(adapter, q_vector);
+	/* only trigger tx interrupt if the receive interrupt was not
+	 * triggered or if its irq differs from the receive queue's irq
+	 */
+	if (txq_vector != NULL &&
+            txq_vector != rxq_vector &&
+	    !napi_if_scheduled_mark_missed(&txq_vector->napi))
+		igc_trigger_rxtxq_interrupt(adapter, txq_vector);
 
 	return 0;
 }
-- 
2.17.1

