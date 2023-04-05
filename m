Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D7D6D8B4C
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 01:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbjDEX7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 19:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbjDEX7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 19:59:44 -0400
Received: from mail-ed1-x562.google.com (mail-ed1-x562.google.com [IPv6:2a00:1450:4864:20::562])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF0672A6
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 16:59:39 -0700 (PDT)
Received: by mail-ed1-x562.google.com with SMTP id b20so145268366edd.1
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 16:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680739178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ks4G1hHrmLTNXZAOT0ue/jCDhDMHdqAw9Getw5UZWqk=;
        b=Iigyc5eP7nB4AKoLMRSQ89c4kVZ3UDYb+X3siip6Z86X9K4KHhr0TnUjZI/LGEbSaR
         0Hmk9vJyPWqLxUYsN+bq921/s/M5RENTMYnm3XLgdl5mQl5gMMiuezNHAePUZi+SNO6C
         EnZ4Gd5593Nx869z1eNuEq2SeGXd9I8YEZbMs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680739178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ks4G1hHrmLTNXZAOT0ue/jCDhDMHdqAw9Getw5UZWqk=;
        b=rshdF/vLW9aqQx3/AY35fCcQo1QR6jNrSOe7+Gz4t5vU5hW9EkTOzOytJA5uKOdZFE
         IHBtHuan3a8VEDiJCew+e1gNBQXlEcnczRYI+pPx6+uMKbuHQ50hK9tMhvfrBCZDV9tM
         UQ/cb+F+gM4qBWIU9/KciSPNoM+PafoUkpFCSWtFc3PYaI++itrroLvsM/6rWTnDTXS5
         1EdqarmGcAP+WhNlyFDigixbV++bo2WzfnWtVe5q95MBSobNnnwkTqzCZSqbjYiByg/j
         SleTUK5qTR8AYHvhCQ6C+tBEZwXETlEHQOfkrnw/01E0WdsZ0ab3gq87RcUmrrBhndaI
         BSlw==
X-Gm-Message-State: AAQBX9eH7EkXz47pop0lxBVzpHVRqWzJgNM1/0NTNYiYh7EpzjY8lrNS
        gHz2oV5wZpGxA+XyOvlJYKKRv+JhWYyKI6TWcGGk6mQTijkB
X-Google-Smtp-Source: AKy350btrICbcmDgkQJedJGt0hgzeBaSP9SrDlYz8zzJmH6kwVvNwTFgMi+Y7lLBQg+qbKCf3S6Lt29F2gI6
X-Received: by 2002:a17:906:3c4d:b0:8af:2107:6ce5 with SMTP id i13-20020a1709063c4d00b008af21076ce5mr4815117ejg.35.1680739178039;
        Wed, 05 Apr 2023 16:59:38 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id hd33-20020a17090796a100b00949174b747bsm8548ejc.96.2023.04.05.16.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 16:59:38 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 1/2] xsk: Fix unaligned descriptor validation
Date:   Thu,  6 Apr 2023 01:59:18 +0200
Message-Id: <20230405235920.7305-2-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405235920.7305-1-kal.conley@dectris.com>
References: <20230405235920.7305-1-kal.conley@dectris.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure unaligned descriptors that straddle the end of the UMEM are
considered invalid. Currently, descriptor validation is broken for
zero-copy mode which only checks descriptors at page granularity.
For example, descriptors in zero-copy mode that overrun the end of the
UMEM but not a page boundary are (incorrectly) considered valid. The
UMEM boundary check needs to happen before the page boundary and
contiguity checks in xp_desc_crosses_non_contig_pg(). Do this check in
xp_unaligned_validate_desc() instead like xp_check_unaligned() already
does.

Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
Signed-off-by: Kal Conley <kal.conley@dectris.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xsk_buff_pool.h | 9 ++-------
 net/xdp/xsk_queue.h         | 1 +
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 3e952e569418..d318c769b445 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -180,13 +180,8 @@ static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
 	if (likely(!cross_pg))
 		return false;
 
-	if (pool->dma_pages_cnt) {
-		return !(pool->dma_pages[addr >> PAGE_SHIFT] &
-			 XSK_NEXT_PG_CONTIG_MASK);
-	}
-
-	/* skb path */
-	return addr + len > pool->addrs_cnt;
+	return pool->dma_pages_cnt &&
+	       !(pool->dma_pages[addr >> PAGE_SHIFT] & XSK_NEXT_PG_CONTIG_MASK);
 }
 
 static inline u64 xp_aligned_extract_addr(struct xsk_buff_pool *pool, u64 addr)
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index bfb2a7e50c26..66c6f57c9c44 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -162,6 +162,7 @@ static inline bool xp_unaligned_validate_desc(struct xsk_buff_pool *pool,
 		return false;
 
 	if (base_addr >= pool->addrs_cnt || addr >= pool->addrs_cnt ||
+	    addr + desc->len > pool->addrs_cnt ||
 	    xp_desc_crosses_non_contig_pg(pool, addr, desc->len))
 		return false;
 
-- 
2.39.2

