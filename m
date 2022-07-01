Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3826556307B
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 11:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbiGAJnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 05:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234024AbiGAJnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 05:43:16 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F97E018
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 02:43:14 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id z13so2846004lfj.13
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 02:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/+XxQ4vatEZZpJZsZxX9NxljTvF/ngx1W22gCHd1Jc=;
        b=bdVcdhLRy2zjNqSMJRaOvBxK7OIzbU1lmVn/1wK8Ix7rZpIzhUBnxvUCqDuyPD59yD
         zpzCK3HQPs/4U2KHXl0mUMkRv4BbM0LktzYT0/o9f5PDi1MDxOEz5Ly4b8sMOO0p1Vbz
         w2q9B1aSDVouRt4+OXZXVxniM7jppOQUZWRHPkBX+zCKa1YiiOGs3G44uD/medym8/yF
         A4l6Krh33Ba/qDYdT9E0uCZ6z4Hni0uAqKpcner2P/AwBmXu3t5ZY0sokPphY9n8gGgO
         0d1miCyWws431IyznAf2odHAl/QAXiiRuPEWTLpC5jHogs4Ytd1AYEteybQ5pF94Lsfq
         I3eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/+XxQ4vatEZZpJZsZxX9NxljTvF/ngx1W22gCHd1Jc=;
        b=clbQrEMxDvJHE0bmJMGoAjn0Wm+0b1gDBXazaTKHFd/MKYE8SbULLGskStUtoCSdt6
         DCuwkVyD3Jo52hgaOumytDYeG2v306KVFXi14D8WUmelW7GHJGXHlDf362567R6n/Td8
         13cq/af1TyjR+kGSu1BDL6z5PiaaE+6/TUdEaclRCaQ5YDRy5nAsu9+87Um4WsKEk18r
         GmRG/44roXaQXsYAWjteXKNeLDdG3g9kOw+zIlD1Q26+USBcjtu3DMAcCBE1xEYGxTlP
         ekeJfiHJCU4yt1QzeQuvw7Fdav4GcYCdYmAwXiSS9T7wROTZK4/MY1JVM2IYScxZgDFN
         sJ0g==
X-Gm-Message-State: AJIora8Brc8GETu1GK4390hxjbtr1usfWprEMBMKyITb21lb3tc+rVMA
        Ca2Pk0y8zXMmHGcE7wuuj/Iqlw==
X-Google-Smtp-Source: AGRyM1s0Lff+ETBavwJNI/8R90n74RfqV2eupQe1iFU7cuRhYDVU/RVppevB4C7VFYBCv5NrgBSP0g==
X-Received: by 2002:a05:6512:3b27:b0:47f:771f:30de with SMTP id f39-20020a0565123b2700b0047f771f30demr8653017lfv.9.1656668592887;
        Fri, 01 Jul 2022 02:43:12 -0700 (PDT)
Received: from anpc2.lan ([62.119.107.74])
        by smtp.gmail.com with ESMTPSA id bx38-20020a05651c19a600b0025a6d563c57sm3072845ljb.134.2022.07.01.02.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 02:43:12 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hawk@kernel.org, john.fastabend@gmail.com
Cc:     song@kernel.org, martin.lau@linux.dev, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf] xdp: Fix spurious packet loss in generic XDP TX path
Date:   Fri,  1 Jul 2022 11:42:56 +0200
Message-Id: <20220701094256.1970076-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The byte queue limits (BQL) mechanism is intended to move queuing from
the driver to the network stack in order to reduce latency caused by
excessive queuing in hardware. However, when transmitting or redirecting
a packet with XDP, the qdisc layer is bypassed and there are no
additional queues. Since netif_xmit_stopped() also takes BQL limits into
account, but without having any alternative queuing, packets are
silently dropped.

This patch modifies the drop condition to only consider cases when the
driver itself cannot accept any more packets. This is analogous to the
condition in __dev_direct_xmit(). Dropped packets are also counted on
the device.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8e6f22961206..41b5d7ac5ec5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4875,10 +4875,12 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
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

