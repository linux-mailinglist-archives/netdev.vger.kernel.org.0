Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4DA5636BE
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 17:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiGAPO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 11:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbiGAPMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 11:12:25 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615C73F303
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 08:12:22 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id r9so2967003ljp.9
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 08:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j3JH4pKNrGtnMgZRKEvSiQHteuS1mmuigNZWQ3Oqn08=;
        b=4uwG6v0AQHR4D1gzzZIw3AOzmhWDI4BkF8vKgSuhEGpnNgkXu247DbgQRCFrLaZW7U
         GhaVzMHo6IHVMOOw1Sbp2kf+rqNezxqhTr4GPJknafYvxbl1L6j8opdLluTNuTs4WrNG
         uJx6cQO+IcyOj1kIshx+67Xbi9Vek/aztRz7iItzJKLFIo8JJdkMto/Jn1JGwVypWu40
         sN6Aab6yQnUzCjLPJX2xw9uS5ArVzKj1tqPb2NC/Lm5gqtHACutmFdQMW/w3q/Hjh+1/
         0H+LZaktJQQzRtoWpL8geEmOxQcu4P0eEPSXoFRfV/esuKchKXF4FweABHm2UE5iOeYc
         AnTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j3JH4pKNrGtnMgZRKEvSiQHteuS1mmuigNZWQ3Oqn08=;
        b=3EXl0N84GonVcvnR4AY+L5+khz/qcVabC3KkM3NopjpDzajTFWDJ2Jzgm1bvGoN9tk
         SnIHV3adyh1rHqsUpU3yHEKR4LgXZdRaNYiXg73H8Y+IF2EEHIuitZwBoHgqjU/iYdwU
         0WNR/VGMFLlNkPdpDvxqtyGjZoznDVFUiOblWEe3Rt+9NgHKwksFDcN0WXnClJPCrO1d
         Y7+csEJGQZzXIgg5wOi/g/pRdJTbcy/kHDBBtag8/xZ/uxL/mnr3fbR+5tdbeL25GBNA
         BrSt3Ls3kXy9Hbwttl/jBuZD4YKbdMH/SVMMjSSl6hAH6/PQ6a1d3QtfGCR+fo8L/8FS
         1IGA==
X-Gm-Message-State: AJIora+8lweYYfxzuLlVriKXr3hNxdBLf4dKqLZd62FhCEgHWYlnV5y6
        3PdRZlft7ysJdnmxt7LqXYDzRA==
X-Google-Smtp-Source: AGRyM1tS7F69x6Dfw0B3DZ3fGSunFgO3JCe/PLKe4uRHdHZFNSdUHfIP2lRuYA5UR3n9n3M6d4aivw==
X-Received: by 2002:a05:651c:895:b0:250:c5ec:bc89 with SMTP id d21-20020a05651c089500b00250c5ecbc89mr8270940ljq.251.1656688340510;
        Fri, 01 Jul 2022 08:12:20 -0700 (PDT)
Received: from anpc2.lan ([62.119.107.74])
        by smtp.gmail.com with ESMTPSA id b22-20020a056512305600b0047da6e495b1sm3664351lfb.4.2022.07.01.08.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 08:12:19 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hawk@kernel.org, john.fastabend@gmail.com
Cc:     song@kernel.org, martin.lau@linux.dev, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, Freysteinn.Alfredsson@kau.se, toke@redhat.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf v2] xdp: Fix spurious packet loss in generic XDP TX path
Date:   Fri,  1 Jul 2022 17:12:00 +0200
Message-Id: <20220701151200.2033129-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220701094256.1970076-1-johan.almbladh@anyfinetworks.com>
References: <20220701094256.1970076-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The byte queue limits (BQL) mechanism is intended to move queuing from
the driver to the network stack in order to reduce latency caused by
excessive queuing in hardware. However, when transmitting or redirecting
a packet using generic XDP, the qdisc layer is bypassed and there are no
additional queues. Since netif_xmit_stopped() also takes BQL limits into
account, but without having any alternative queuing, packets are
silently dropped.

This patch modifies the drop condition to only consider cases when the
driver itself cannot accept any more packets. This is analogous to the
condition in __dev_direct_xmit(). Dropped packets are also counted on
the device.

Bypassing the qdisc layer in the generic XDP TX path means that XDP
packets are able to starve other packets going through a qdisc, and
DDOS attacks will be more effective. In-driver-XDP use dedicated TX
queues, so they do not have this starvation issue.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 net/core/dev.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8e6f22961206..00fb9249357f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4863,7 +4863,10 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 }
 
 /* When doing generic XDP we have to bypass the qdisc layer and the
- * network taps in order to match in-driver-XDP behavior.
+ * network taps in order to match in-driver-XDP behavior. This also means
+ * that XDP packets are able to starve other packets going through a qdisc,
+ * and DDOS attacks will be more effective. In-driver-XDP use dedicated TX
+ * queues, so they do not have this starvation issue.
  */
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
 {
@@ -4875,10 +4878,12 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
 	txq = netdev_core_pick_tx(dev, skb, NULL);
 	cpu = smp_processor_id();
 	HARD_TX_LOCK(dev, txq, cpu);
-	if (!netif_xmit_stopped(txq)) {
+	if (!netif_xmit_frozen_or_drv_stopped(txq)) {
 		rc = netdev_start_xmit(skb, dev, txq, 0);
 		if (dev_xmit_complete(rc))
 			free_skb = false;
+	} else {
+		dev_core_stats_tx_dropped_inc(dev);
 	}
 	HARD_TX_UNLOCK(dev, txq);
 	if (free_skb) {
-- 
2.30.2

