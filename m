Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5636F104D
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 04:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344335AbjD1C0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 22:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjD1C0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 22:26:22 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414ED268D
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 19:26:21 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-64115eef620so9385193b3a.1
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 19:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1682648781; x=1685240781;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UsGPjHUd/JAVdo+0tuStqIz7Tm1YkeItSZg+vCTmFL0=;
        b=OuOomwVr1+BUVgODDImCVU1rjVLtKKlmWxZM2hn3gGiQ6R13Fs7p78CSCDw4t19Bnf
         3S16IDwx9H1vG4cwiX0lIFiTpnvDJN08bLXCXZZlTlyDiSdHyfgp+BVkdmsrcd8beHuD
         jwd0ZOaH2Y/NDAyYWJ9RZYR5ZQawfxTk7Xna+rpQJ9ZhZgtX+eXkx+F/VTfFgqMDB17e
         nnwO25mrKnxnagZenkBVknBa54zPvGz5m2YuXPiAhzvNLASIPoj/YHGWs5En/CUessYQ
         oY0AddnJ9ZGxdjROwv1NXna6QIklo5DJVEcKS0/Jl33MN7QiQ37BApALD+XHIP2TqMzT
         3THw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682648781; x=1685240781;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UsGPjHUd/JAVdo+0tuStqIz7Tm1YkeItSZg+vCTmFL0=;
        b=dlyLNjkP3/Xc+3WFxK3UBAbA9qTc5AeYazxI0NYWtCWnO6/uGIdG91Nn/Dy8jZttKH
         iKCCAophiWI6fvSWO7tqS62W6Pih93sLONDqpqOH/yAAB6LB1ii82NV/VQlMH6fyBddH
         1+kG/PkbOxdZMfap35/Di3fY00nzCSTU912RxMk72WpkE0wt41Yyayy2dEIi0MsjvaNB
         g7Ln7fst6SzXdegJCVn0C6aeCYKD5q/bsW1TlhMEVxhRkneKSHh4o/F0gePnzXPsTenn
         jKSFr7bc1saJnf9qa8BMeVng5eaMFkqgB6PxJBsRQ8XRBHtsCmh6IKqSzcnql8V1czHv
         E7EA==
X-Gm-Message-State: AC+VfDz4H1INC5THMd0zy/SLnc6VRPU7QmWjB7rru4Td15NsPgpHr1qC
        b2I3QIFdfMjPnsBaGRnNuYzk5g==
X-Google-Smtp-Source: ACHHUZ531xLfekC2Gkb7D+QY5buqY1RaQcHoeTNm9zkbDctNzACX40QAJaq7DXmtlYWYWKIEOE2MuA==
X-Received: by 2002:a05:6a00:a16:b0:63d:3c39:ecc2 with SMTP id p22-20020a056a000a1600b0063d3c39ecc2mr4864383pfh.12.1682648780674;
        Thu, 27 Apr 2023 19:26:20 -0700 (PDT)
Received: from n137-048-144.byted.org ([121.30.179.80])
        by smtp.gmail.com with ESMTPSA id h125-20020a628383000000b0063b87717661sm13936511pfe.85.2023.04.27.19.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 19:26:20 -0700 (PDT)
From:   Wenliang Wang <wangwenliang.1995@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wenliang Wang <wangwenliang.1995@bytedance.com>
Subject: [PATCH v2] virtio_net: suppress cpu stall when free_unused_bufs
Date:   Fri, 28 Apr 2023 10:26:13 +0800
Message-Id: <20230428022613.863298-1-wangwenliang.1995@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For multi-queue and large ring-size use case, the following error
occurred when free_unused_bufs:
rcu: INFO: rcu_sched self-detected stall on CPU.

Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
---
v2:
-add need_resched check.
-apply same logic to sq.
---
 drivers/net/virtio_net.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ea1bd4bb326d..573558b69a60 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3559,12 +3559,16 @@ static void free_unused_bufs(struct virtnet_info *vi)
 		struct virtqueue *vq = vi->sq[i].vq;
 		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
 			virtnet_sq_free_unused_buf(vq, buf);
+		if (need_resched())
+			schedule();
 	}
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		struct virtqueue *vq = vi->rq[i].vq;
 		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
 			virtnet_rq_free_unused_buf(vq, buf);
+		if (need_resched())
+			schedule();
 	}
 }
 
-- 
2.20.1

