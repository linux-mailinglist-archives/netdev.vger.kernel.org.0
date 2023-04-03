Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D999A6D4944
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 16:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbjDCOgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 10:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbjDCOgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 10:36:22 -0400
Received: from mail-ed1-x562.google.com (mail-ed1-x562.google.com [IPv6:2a00:1450:4864:20::562])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A367317670
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 07:36:13 -0700 (PDT)
Received: by mail-ed1-x562.google.com with SMTP id i5so118426703eda.0
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 07:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680532572;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U5r7YRW0ZNQYQAUWUSjjSl8/aBINAbtHL/3e+twmpks=;
        b=r9QrjT90BPkxKRltjojacHRrzBGVAyjMvPlwDhL7hO3+MhZunGBQH16KYfsoQWb8UT
         Nndx/n9S8RG17b8ls9oB7tYUKQIHRSQng5VaC9NU2wfOrLjI06fONzYAMLCY+UAv0/0q
         df9M4hXqP+nHHYYLwkoLfc31ZkdgVrE7/RY+8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680532572;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U5r7YRW0ZNQYQAUWUSjjSl8/aBINAbtHL/3e+twmpks=;
        b=eaX5gDtMzaUfvoy2tvHgvqJN0s5Ml6XXaAH+XDrFvz3g0IC1OLYu1bWh+AC4f8jXx2
         VawIWa52e6KmdaiFroNKS4mVqVMGrOH1A2k2v2YkmcCVuBCD5Yo32RWlYisjHEL/9A71
         ThD8F4ax0QucPqYikp6ashgXEfYerqxWfLiYiBRcYFp9DSE8W4v5og2DE0FwD0ip87Rv
         Am21O7oisJ+KSTQV3zDtDm2Vg/LivlBawuG8KSh8zee168stkIzx4mEv1w4P8ScxBXuP
         kBMsZPis5iARZwGlPKVuuRK2nrnsNMmxnBAZKVbQaUIF6ygSYCIPICC+1Haec6eX3QtR
         3Wbg==
X-Gm-Message-State: AAQBX9eWuhUiIAKc9JHdFdTXC7KIL0qv3oBl+iJlz+IC88KwKsikGOdK
        wMG7+JzthDcK/iwYVJWBwgCtkrG+/1HsSf6pvbDyjIuAehX1
X-Google-Smtp-Source: AKy350Y8nj7Dmf0M2lIbht8Tt1l0YyX9VpNsVwlG4YnyGlwJGE6ARk5FVdaHVaOvwOjGn9wi3uLrSq5aEun0
X-Received: by 2002:a17:906:4990:b0:932:20a5:5b with SMTP id p16-20020a170906499000b0093220a5005bmr17548153eju.23.1680532572026;
        Mon, 03 Apr 2023 07:36:12 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id r6-20020a1709064d0600b008b25260a59dsm3079775eju.290.2023.04.03.07.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 07:36:12 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
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
Subject: [PATCH bpf] xsk: Fix unaligned descriptor validation
Date:   Mon,  3 Apr 2023 16:36:01 +0200
Message-Id: <20230403143601.32168-1-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
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
Descriptors that cross the end of the UMEM but not a page boundary may
be therefore incorrectly considered valid. The check needs to happen
before the page boundary and contiguity checks in
xp_desc_crosses_non_contig_pg. Do this check in
xp_unaligned_validate_desc instead like xp_check_unaligned already does.

Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
Signed-off-by: Kal Conley <kal.conley@dectris.com>
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

