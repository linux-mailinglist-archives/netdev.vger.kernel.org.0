Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650DF5BFF55
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiIUN5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiIUN5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:57:44 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3184D7B1C0;
        Wed, 21 Sep 2022 06:57:43 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id e10-20020a05600c4e4a00b003b4eff4ab2cso3479344wmq.4;
        Wed, 21 Sep 2022 06:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=q3YuTWNeJ5V53+QAPS3mdAfc+O8icEhJa5RM3K6ShEo=;
        b=gAZIahSfDNJkKJKwdJaz2NBkb9+tuO7Wy18NzxGinte2r5STvaiHBFSyMfkHEZBdU9
         Dqsz6swLhfr8D9Tl+VF4Re9bIcXkyX/y8OWZQlBQ1p8vVfhHUXdZ8eJquJlontgICkM6
         YRRKhJXZJ1ggcUNnpUKOysif2t64DJyL0/5DE6fiGWoPVJdzYMT5/IOSV3+4WdIynO1+
         xiZYdh0iUlrX+AuMwUtrJsBxEnf406EwfVJ6jtvVvzaI3OOo9TrBuZjW9C0UnDjEA0Zm
         E520WHVp+QfGSy8FgkSMcEPVmvmpD4RmwTg7Q9kisTH8UbOMgmXQ7K7RYcMKQclWteXk
         5AZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=q3YuTWNeJ5V53+QAPS3mdAfc+O8icEhJa5RM3K6ShEo=;
        b=WL7H9zBEMFGvOE244GJz0ILuLKcMjHRlfwoVI5CdZx3AnGFUsQC+yZ9U+rq/Z5+xp9
         vuskBjR/GjjFC9flG1h6Jh9TZkFjClQQx1Z1vAs9cXldEIbwb2LP3x8/j7ZEOiL5iryI
         euy/L9RdtAatiOQoIp7i+hWGExAFFrQihhWRjpgabRT1Z1u+UHe6BiWCaYdJ3TRFX/+Z
         EgzUayn3UQJ7/ZMOZ7ZQud8BTlmytSaMg7OHcr1YFY7iTpInW8JfK22qfhkxMHcHT3lw
         D5S+iE6FmsD3ITOMQMlTDvu/SR2r50E7JmR9QGzZDcv1iuvKgxWAOPThJesL5IfDd8TM
         jFrQ==
X-Gm-Message-State: ACrzQf13M8B+GBHEKO6l8szrW9eIzh+6XhdGwCNoH3oriHJueUkw/Uvh
        admozJTGYHCOUYRDkV7oWKI=
X-Google-Smtp-Source: AMsMyM4AQQH++LbiQAXOC8PLrRqbzi3zXVVXUZFyUw8511UJr87GRu2J3/g/gBVqsqD0Yv4iHXC/qg==
X-Received: by 2002:a1c:4b05:0:b0:3b4:90c1:e249 with SMTP id y5-20020a1c4b05000000b003b490c1e249mr6144609wma.201.1663768661560;
        Wed, 21 Sep 2022 06:57:41 -0700 (PDT)
Received: from ipe420-102 ([2a00:1398:4:ac00:ec4:7aff:fe32:721b])
        by smtp.gmail.com with ESMTPSA id f11-20020a05600c4e8b00b003b340f00f10sm3611129wmq.31.2022.09.21.06.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 06:57:41 -0700 (PDT)
From:   Jalal Mostafa <jalal.a.mostapha@gmail.com>
To:     maciej.fijalkowski@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, hawk@kernel.org, ast@kernel.org,
        linux-kernel@vger.kernel.org, jalal.mostafa@kit.edu,
        jalal.a.mostapha@gmail.com
Subject: [PATCH bpf v3] xsk: inherit need_wakeup flag for shared sockets
Date:   Wed, 21 Sep 2022 13:57:01 +0000
Message-Id: <20220921135701.10199-1-jalal.a.mostapha@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <YysApyiP4S3xdT8H@boxer>
References: <YysApyiP4S3xdT8H@boxer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
specified once `XDP_SHARED_UMEM` is specified.

Fixes: b5aea28dca134 ("xsk: Add shared umem support between queue ids")

Signed-off-by: Jalal Mostafa <jalal.a.mostapha@gmail.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
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

