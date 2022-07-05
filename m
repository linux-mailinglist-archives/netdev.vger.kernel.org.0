Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBB75664F6
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 10:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiGEIX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 04:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiGEIXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 04:23:55 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5F5C70
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 01:23:54 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id o10so2911899ljj.13
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 01:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nm4GWncx/H7UbY0657xwuVdYq5JG1QruNhlsI4qkLAs=;
        b=YS4a5WDDY6+mYy03sUjXRRWvWYQiFv7DWe888KPRMUPvweym264/F30f9Esq98+G0Z
         bDDq05ZFNHMRRsPVYGcJSnEVvJBf56ulA7bnfa2W2u8R4fZl/Xhn2Ep5sue9GevdAmbY
         r2ErBcEjLVMvCzoA35c94A3/UHJ/aELEoBYolXv+3EFVD7d9Fk6KVYStZIm+BdauupYE
         XF9y54XB0np9K/HiFGC/DAMGSxhjSUvOTZvOnDikPAk23BefF5nA/UaMSuVkVOFrEEN3
         FyDOACkLh9b9JTrT3vT0JiLPXAD1ClnnmgK8l3FDM7oKcpeZPT3plBRv15v66LaWyLXj
         GYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nm4GWncx/H7UbY0657xwuVdYq5JG1QruNhlsI4qkLAs=;
        b=0AGtmp49lWAPn15iua3PDN1bhkdyffLXWi48M8TP2hhnoAOdZ2bjkrby5c1Hq7dj3T
         2Tjj2yZ9V/CBMF0/+THhoHjXmFjDL0FiY3p2R0DTSAquO9cGmJuE6X/6sNsp3C0rz5Qo
         eKDIhqR5FDQriji2LhIhWyNH7un1PBxt8LkmjJOe0fbX4gnE6MMwewapetvfBRI0y1Xn
         GCuXU9/jVhaF+hMs0xRe4elaT8k6SiPxISbTeEJTy4ug7Fox+C/dDzP6sWIzqE9KNBmO
         NkCjCyTIYPiCcO9PQX4hU1/l3dWrHYyCuX3hBicDRG8wgyzbiRjv9VuU1Piajyl5XhDM
         eAYw==
X-Gm-Message-State: AJIora9df40kaXMVt+fyj/zbefogtXl+EhwhFdQj+TJJdr2gK34YBp4U
        FB+8+70DF9tTXFMnpwGfHCj9aw==
X-Google-Smtp-Source: AGRyM1soPHci+b7CH9FJb3u37LBINSfpUxKsSDyGYFvOI1twDP1j1eyteRfnHe4JSLb10OmwP5E2TQ==
X-Received: by 2002:a2e:918f:0:b0:25a:7164:f408 with SMTP id f15-20020a2e918f000000b0025a7164f408mr19004646ljg.523.1657009432615;
        Tue, 05 Jul 2022 01:23:52 -0700 (PDT)
Received: from anpc2.lan ([62.119.107.74])
        by smtp.gmail.com with ESMTPSA id a12-20020ac25e6c000000b0047f878aba7fsm5514733lfr.110.2022.07.05.01.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 01:23:52 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hawk@kernel.org, john.fastabend@gmail.com
Cc:     song@kernel.org, martin.lau@linux.dev, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, Freysteinn.Alfredsson@kau.se, toke@redhat.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf v3] xdp: Fix spurious packet loss in generic XDP TX path
Date:   Tue,  5 Jul 2022 10:23:45 +0200
Message-Id: <20220705082345.2494312-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220701151200.2033129-1-johan.almbladh@anyfinetworks.com>
References: <20220701151200.2033129-1-johan.almbladh@anyfinetworks.com>
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
 net/core/dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8e6f22961206..30a1603a7225 100644
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
@@ -4875,7 +4878,7 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
 	txq = netdev_core_pick_tx(dev, skb, NULL);
 	cpu = smp_processor_id();
 	HARD_TX_LOCK(dev, txq, cpu);
-	if (!netif_xmit_stopped(txq)) {
+	if (!netif_xmit_frozen_or_drv_stopped(txq)) {
 		rc = netdev_start_xmit(skb, dev, txq, 0);
 		if (dev_xmit_complete(rc))
 			free_skb = false;
@@ -4883,6 +4886,7 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
 	HARD_TX_UNLOCK(dev, txq);
 	if (free_skb) {
 		trace_xdp_exception(dev, xdp_prog, XDP_TX);
+		dev_core_stats_tx_dropped_inc(dev);
 		kfree_skb(skb);
 	}
 }
-- 
2.30.2

