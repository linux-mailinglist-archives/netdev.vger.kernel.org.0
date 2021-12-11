Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2AF471567
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 19:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhLKSnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 13:43:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43056 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231759AbhLKSna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 13:43:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639248209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qcwg+nWK33eezODa4kU9dVrDqx3dQGYFOytiCKq/aAc=;
        b=iAEZ9HmjIOBozEI2+CmEwSeTbYtB9bRor0nagkcOYPIP0oNngh4nE4yJMPc3CsXIKVNQsI
        YTRVKIdOau04teJg/rPRLq2lKeLxqmq3gOSxlGVpZVsY7j4vR0Or6O5XiGMEE8+AE1fU+z
        4xpwztQ/4qqTNWyy1GlKSVtBvAlLs88=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-2X8Twy9vMfGXhxELZ5k0rg-1; Sat, 11 Dec 2021 13:43:28 -0500
X-MC-Unique: 2X8Twy9vMfGXhxELZ5k0rg-1
Received: by mail-ed1-f71.google.com with SMTP id a3-20020a05640213c300b003e7d12bb925so10842611edx.9
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 10:43:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qcwg+nWK33eezODa4kU9dVrDqx3dQGYFOytiCKq/aAc=;
        b=vqKWwRkCsRT7VhnpXFfWPbJZ4n6xFadwhjxREuxOmvOQoxnfzMNIYnYMBgfQAocSCs
         DN1sH9OlRtxbmWCrBl9mcuEKDySspmaNmwLeZN1a89nX0oUbfwLdZO50gqvGcmJ+Ul03
         CBnBXMUWqlIUtwxSlCF3vQJAALAYHfmCqus6cL7fzlXC8BLyxPFlM1I5uan3+46Sv1AO
         2+8TlT+0kx8Klb0WQuO6mjQ3v0mOKBcKU+KLLikqecQLD3G6W3A1JUgAHASr6MX3R8zm
         39PuPD/J4xfONyuBVnFTtbOiTcVYR/b2AmRBA57rmDtaDhY4hfMPv1IzX6ZbZnj136FN
         Ot/g==
X-Gm-Message-State: AOAM533b3uNQw44GgyF6RUSMkDFNlwmHpo0wfN1Ab2HGuLRSwCqze7GE
        FzoeoCzCM4vnsiHpwnj82J9noTnwbqAsIzgukgMA+j2N934s+DI6rRaHO8VXcyts2m77E5ddEYk
        hHKStbVJZ0tHXhXfs
X-Received: by 2002:aa7:c78f:: with SMTP id n15mr48033419eds.344.1639248206069;
        Sat, 11 Dec 2021 10:43:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwWRuiBUX4M5Ep+VigFUEs7adY4I00LONshztoYorReVzl4HiamOizhk1fAsU/tLwm9Y8++sw==
X-Received: by 2002:aa7:c78f:: with SMTP id n15mr48033336eds.344.1639248205162;
        Sat, 11 Dec 2021 10:43:25 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id cw20sm3391613ejc.90.2021.12.11.10.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 10:43:24 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DCACF1804A1; Sat, 11 Dec 2021 19:43:23 +0100 (CET)
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
Subject: [PATCH bpf-next v3 3/8] page_pool: Store the XDP mem id
Date:   Sat, 11 Dec 2021 19:41:37 +0100
Message-Id: <20211211184143.142003-4-toke@redhat.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211211184143.142003-1-toke@redhat.com>
References: <20211211184143.142003-1-toke@redhat.com>
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
index c3b134a86ec9..8442a7965602 100644
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
index ac476c84a986..2901bb7004cc 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -320,7 +320,7 @@ static struct xdp_mem_allocator *__xdp_reg_mem_model(struct xdp_mem_info *mem,
 	}
 
 	if (type == MEM_TYPE_PAGE_POOL)
-		page_pool_use_xdp_mem(allocator, mem_allocator_disconnect);
+		page_pool_use_xdp_mem(allocator, mem_allocator_disconnect, mem);
 
 	mutex_unlock(&mem_id_lock);
 
-- 
2.34.0

