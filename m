Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFE74702A7
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242033AbhLJOYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:24:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241881AbhLJOY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:24:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639146051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ds6QTVDpGNxBUDXmv5+fit0E/Kglxb7++rnaRLkBHbc=;
        b=RVDaTG6h1MvQ9iNo1qQBOI3SLbT/RxhFH5o3X16Xc13PMWKlZfxrr3YyuaReTcp1DlCqwA
        Q16Wk93mE/NZP3R+dT1bVgB9+ox1L25ZxYWZP0w7IC5xPgJ1usCw9nEz4L9Ma1brxGJ2ky
        H68h+4y4zO4N4JX36t9S6b1FcXgLges=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-nFn5vnGhNBW7GQf5mWPuug-1; Fri, 10 Dec 2021 09:20:50 -0500
X-MC-Unique: nFn5vnGhNBW7GQf5mWPuug-1
Received: by mail-ed1-f69.google.com with SMTP id i19-20020a05640242d300b003e7d13ebeedso8323066edc.7
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 06:20:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ds6QTVDpGNxBUDXmv5+fit0E/Kglxb7++rnaRLkBHbc=;
        b=CTbXx5jy3UGTpJSaTx25RBWOEqwjH4fnPUYsjmLoW2y8HfAlBO9EpqO+EzIPIvjyPl
         rvXBb8t3aZ+GDUCi7OO1gvvauFwBRKEBE4UQ2Iy3T2WcpqwCknTrQMz4DYtLkEvoPQ8R
         PLEVsiGWCAHCI8SQMYQiLXK719wwS0pLHKe1ztEI1njY2I08j3MCiBazDGu5B0I14CY9
         LXS+5H3iuc08N/UJyH0R1ghKTVpA9lyb2INjZXyKi1F8zkLVH9urxrIUBi0cMwGlQ4ON
         /3iWS9pHoDaxCa47/nBOgL0ueFt9/Ut5x9Wm5TBSgVelLK//UBDnh7h+E4aUVuCmoeFE
         bAiA==
X-Gm-Message-State: AOAM531CDWZxyztJh+Vs9AyjGOwUxkzcmFp5LE3Xdr5uX8Uj/U+SuJI0
        L0AjCYaRIGMYN6xcRWz9R9LX/EfJ6tpT6f2THzPEEUIgCmhPm7aSiP0MoIkNfmdEWDcJTyDPa1I
        X6uvTuduuBXX2U4UJ
X-Received: by 2002:a05:6402:5206:: with SMTP id s6mr38974928edd.113.1639146048416;
        Fri, 10 Dec 2021 06:20:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQPNrwxoHeJ1zBX5rusBPXaetulvlR989nHBOFQocmTs6DRCihkQMrxhf/jAXHz/ufPxjaLg==
X-Received: by 2002:a05:6402:5206:: with SMTP id s6mr38974881edd.113.1639146048057;
        Fri, 10 Dec 2021 06:20:48 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id qw27sm1690236ejc.101.2021.12.10.06.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 06:20:46 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 23013180496; Fri, 10 Dec 2021 15:20:46 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 2/8] page_pool: Store the XDP mem id
Date:   Fri, 10 Dec 2021 15:20:02 +0100
Message-Id: <20211210142008.76981-3-toke@redhat.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211210142008.76981-1-toke@redhat.com>
References: <20211210142008.76981-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Store the XDP mem ID inside the page_pool struct so it can be retrieved
later for use in bpf_prog_run().

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/page_pool.h | 9 +++++++--
 net/core/page_pool.c    | 4 +++-
 net/core/xdp.c          | 2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index a71201854c41..6bc0409c4ffd 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -96,6 +96,7 @@ struct page_pool {
 	unsigned int frag_offset;
 	struct page *frag_page;
 	long frag_users;
+	u32 xdp_mem_id;
 
 	/*
 	 * Data structure for allocation side
@@ -170,9 +171,12 @@ bool page_pool_return_skb_page(struct page *page);
 
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
+struct xdp_mem_info;
+
 #ifdef CONFIG_PAGE_POOL
 void page_pool_destroy(struct page_pool *pool);
-void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *));
+void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
+			   struct xdp_mem_info *mem);
 void page_pool_release_page(struct page_pool *pool, struct page *page);
 void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 			     int count);
@@ -182,7 +186,8 @@ static inline void page_pool_destroy(struct page_pool *pool)
 }
 
 static inline void page_pool_use_xdp_mem(struct page_pool *pool,
-					 void (*disconnect)(void *))
+					 void (*disconnect)(void *),
+					 struct xdp_mem_info *mem)
 {
 }
 static inline void page_pool_release_page(struct page_pool *pool,
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index fb5a90b9d574..2605467251f1 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -695,10 +695,12 @@ static void page_pool_release_retry(struct work_struct *wq)
 	schedule_delayed_work(&pool->release_dw, DEFER_TIME);
 }
 
-void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *))
+void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
+			   struct xdp_mem_info *mem)
 {
 	refcount_inc(&pool->user_cnt);
 	pool->disconnect = disconnect;
+	pool->xdp_mem_id = mem->id;
 }
 
 void page_pool_destroy(struct page_pool *pool)
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 5ddc29f29bad..143388c6d9dd 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -318,7 +318,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 	}
 
 	if (type == MEM_TYPE_PAGE_POOL)
-		page_pool_use_xdp_mem(allocator, mem_allocator_disconnect);
+		page_pool_use_xdp_mem(allocator, mem_allocator_disconnect, mem);
 
 	mutex_unlock(&mem_id_lock);
 
-- 
2.34.0

