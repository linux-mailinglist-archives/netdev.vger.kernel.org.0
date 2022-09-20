Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3BE45BE50E
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 13:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiITL6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 07:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiITL6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 07:58:22 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C671F74BBB;
        Tue, 20 Sep 2022 04:58:19 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n10so3820508wrw.12;
        Tue, 20 Sep 2022 04:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date;
        bh=GC5RU51Ak8cJeLOThQsMJPgw9hTTEOLSP/su3PGldTg=;
        b=DIJCoa4UP2Dn7PgIsILkS3kbSh8mynQ3X6pDFnr9YNyLMyAyg3ss8Sv0Yc/IRMPYyA
         /HiyZHUXIswCQLnbdf3CsmGLHN+bdR6C/15qwF+UyDfPCiIQFxc0m2ASWPzMGdtx/nKX
         CyWC0N4CHha9fyzg2jk8XvG9wfhVOHlQNgG3Wwzmg+XsAHcOI+LNJgrVcvPzNqQuvDEF
         AW109sYRHUTxELL4EzQo+OIM0CqLv9QFuEPmi1For/n9xeAUJSAAjJn8OSjOHu66+r+k
         JiuX2E/Sm7jZEEZyQlT2DCAGoZOLnBueocanqDbnrEuuPU9ewu0DEQVqlzeTlGDS9MNp
         lhnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=GC5RU51Ak8cJeLOThQsMJPgw9hTTEOLSP/su3PGldTg=;
        b=7HMt6pcg+L71LdxsHkI/FsRTxB4REAgIGTEt9k8W+207haCVHcKkWzA47OWP7rtpdK
         O2JHY88Ibt39K3CB7ybCLKHwiuxN+3uCj3XK3nTTI5QCCtes1owgU69AotXRF6W0mVLu
         L6G+3LuQ31iW3E8YUjOULUQInQICpSOKmw0r//pdd6Fbpgt5mdDoM0W4uz4wJ71D/sjd
         F3jI6YT+z7SUhmOK6UPbhLkdUqNDl+r0sRgc9X2u00bh+yUlHktoRldusNyQX5cEgztp
         adcskzTbOzfArDtX6cn8q26siy/aj/lELEm26VIuGstKqwAE9Mcs838/mbyuL1JBSC5a
         HxgQ==
X-Gm-Message-State: ACrzQf3v3Tcan5fVeb97TtYK3E6AgIVerRgSOvJxKM1iADg1JVKGb6LN
        h2Le0qz6ZsCs/+2aY9pFhfs=
X-Google-Smtp-Source: AMsMyM7jtOyFocnPys/g1fpYMz25Ytgi3iurM/IczBroFuHekEMQb0NAgNChfTzn/Ntwm+M3iuXPvA==
X-Received: by 2002:adf:ffc3:0:b0:228:65be:6fff with SMTP id x3-20020adfffc3000000b0022865be6fffmr13598988wrs.387.1663675098347;
        Tue, 20 Sep 2022 04:58:18 -0700 (PDT)
Received: from ipe420-102 ([2a00:1398:4:ac00:ec4:7aff:fe32:721b])
        by smtp.gmail.com with ESMTPSA id v16-20020adfa1d0000000b00228dc1c7063sm1582003wrv.85.2022.09.20.04.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 04:58:17 -0700 (PDT)
Date:   Tue, 20 Sep 2022 11:58:17 +0000
From:   Jalal Mostafa <jalal.a.mostapha@gmail.com>
To:     magnus.karlsson@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, daniel@iogearbox.net,
        linux-kernel@vger.kernel.org, jalal.mostafa@kit.edu
Subject: [PATCH bpf v2] xsk: inherit need_wakeup flag for shared sockets
Message-ID: <Yymq2WLA6q6TxnNq@ipe420-102>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flag for need_wakeup is not set for xsks with `XDP_SHARED_UMEM`
flag and of different queue ids and/or devices. They should inherit
the flag from the first socket buffer pool since no flags can be
specified once `XDP_SHARED_UMEM` is specified. The issue is fixed
by creating a new function `xp_create_and_assign_umem_shared` to
create xsk_buff_pool for xsks with the shared umem flag set.

Fixes: b5aea28dca134 ("xsk: Add shared umem support between queue ids")
Signed-off-by: Jalal Mostafa <jalal.a.mostapha@gmail.com>
---
 include/net/xsk_buff_pool.h | 2 +-
 net/xdp/xsk.c               | 4 ++--
 net/xdp/xsk_buff_pool.c     | 5 +++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 647722e847b4..f787c3f524b0 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -95,7 +95,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 						struct xdp_umem *umem);
 int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
 		  u16 queue_id, u16 flags);
-int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
+int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
 			 struct net_device *dev, u16 queue_id);
 int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs);
 void xp_destroy(struct xsk_buff_pool *pool);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 5b4ce6ba1bc7..7bada4e8460b 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -954,8 +954,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 				goto out_unlock;
 			}
 
-			err = xp_assign_dev_shared(xs->pool, umem_xs->umem,
-						   dev, qid);
+			err = xp_assign_dev_shared(xs->pool, umem_xs, dev,
+						   qid);
 			if (err) {
 				xp_destroy(xs->pool);
 				xs->pool = NULL;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index a71a8c6edf55..ed6c71826d31 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -212,17 +212,18 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 	return err;
 }
 
-int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
+int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
 			 struct net_device *dev, u16 queue_id)
 {
 	u16 flags;
+	struct xdp_umem *umem = umem_xs->umem;
 
 	/* One fill and completion ring required for each queue id. */
 	if (!pool->fq || !pool->cq)
 		return -EINVAL;
 
 	flags = umem->zc ? XDP_ZEROCOPY : XDP_COPY;
-	if (pool->uses_need_wakeup)
+	if (umem_xs->pool->uses_need_wakeup)
 		flags |= XDP_USE_NEED_WAKEUP;
 
 	return xp_assign_dev(pool, dev, queue_id, flags);
-- 
2.34.1

