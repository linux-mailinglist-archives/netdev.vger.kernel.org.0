Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E705BFECF
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiIUNRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiIUNRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:17:10 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE74C89CE4;
        Wed, 21 Sep 2022 06:17:09 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r133-20020a1c448b000000b003b494ffc00bso8522906wma.0;
        Wed, 21 Sep 2022 06:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date;
        bh=q3YuTWNeJ5V53+QAPS3mdAfc+O8icEhJa5RM3K6ShEo=;
        b=Jkl3nISiWDGyLlOQL0e9gqcOHTMqtSHF/DZqJJiNwZxnMIuxU0dlsYOSDOG+n5PTGa
         coc1iimk5rxdbEmHxzPzkcbsJXQcekGNd4YKD7HlDzMwxWjETv9u7ZkyU8fO9E39CC5i
         Ng789mjmXRAovoZpPUnfsRU7iUcL3AgcsYObN8UWg8mXXJ9x1K8u60VznlGREVI9u42w
         kI0JLRzqCMAtQV8L0Tc7Idz5TKVvw+8ZDa1FwZ+jI2zipj5W6ftQIiTG8kzgrYIHpmDz
         CEGl8znSNIL/5kigfz4vA+uBCRhPfIWXOokM3osHaucM6idSGpgaPNnCeIDl8tZJyBKt
         sK+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=q3YuTWNeJ5V53+QAPS3mdAfc+O8icEhJa5RM3K6ShEo=;
        b=zdTIInUOHKbfxj6g6wTRhbV/9gu05x4mPsDhYQ4IT5/1YNnhSGNye3NjGDs2IgGXUi
         n9L73YEkcSWTFzYCma9Ko17P/8UX7ojjFUeu306SAledRFLHEB3Muy74xxKMMxJlyfnB
         ZXC/dPdVY9qMtpbDyN089tzivQBFOK302GN1nCfJo++HmQBaHhRZ1218inXINP1S0Swe
         d1qMBoj2yDs0QhIJbjNaTaamP/YKsMxc0YdTO13M6U6RbYWUzfCwqokawWhB/qAHCbgx
         SIzN9+FFb3iuswOP1VLYPCHdOMZfBvnK1j8nIIMUU+43uyEVDoIHp1Adk9mTQpQf3oyx
         xngA==
X-Gm-Message-State: ACrzQf14L33LY/zvqY1xO5PGoBDgicPu4c/6X4C84JCN5dMadGrdnoOr
        gxRVgm/c1SgwHCotY1sZPBA=
X-Google-Smtp-Source: AMsMyM7d4JMhEzdd/OG4Sf7n6l1qjqqV6WqIm4PrPOLv6puF5rGooxtVwpaWFDuYudt7StImPRCQ6A==
X-Received: by 2002:a05:600c:2043:b0:3b3:c84c:ca33 with SMTP id p3-20020a05600c204300b003b3c84cca33mr5875258wmg.15.1663766228183;
        Wed, 21 Sep 2022 06:17:08 -0700 (PDT)
Received: from ipe420-102 ([2a00:1398:4:ac00:ec4:7aff:fe32:721b])
        by smtp.gmail.com with ESMTPSA id p25-20020a7bcc99000000b003b476bb2624sm2849112wma.6.2022.09.21.06.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 06:17:07 -0700 (PDT)
Date:   Wed, 21 Sep 2022 13:17:07 +0000
From:   Jalal Mostafa <jalal.a.mostapha@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        hawk@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org,
        jalal.mostafa@kit.edu, jalal.a.mostapha@gmail.com
Subject: [PATCH v3] xsk: inherit need_wakeup flag for shared sockets
Message-ID: <YysO03uVFwGO8dHf@ipe420-102>
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

