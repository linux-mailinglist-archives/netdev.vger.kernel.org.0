Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE92471569
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 19:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhLKSnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 13:43:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58167 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231766AbhLKSnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 13:43:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639248211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YKGdcsrGGsfL9IqUuswtI/8NYS6Yd2LQe5Uj78i7ME8=;
        b=d1JQNDUZiNl3If0OSQDSN6OkZGQzcrko7Urs9j/VnelhAxUuC8nxhrOZS4Te/8WLymXArd
        YKfzF3IB103Q7MZlSbHepc2mWa/M8z1apWN04HnNMIONw1B1OxYgA+ZGDufdVbLdHkZFbl
        BI3u0BOsxMQjGPADCOTi7aCXKHiSn7A=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-X162xFQmMeOlUtHYHp-X6Q-1; Sat, 11 Dec 2021 13:43:30 -0500
X-MC-Unique: X162xFQmMeOlUtHYHp-X6Q-1
Received: by mail-ed1-f72.google.com with SMTP id t9-20020aa7d709000000b003e83403a5cbso10808698edq.19
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 10:43:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YKGdcsrGGsfL9IqUuswtI/8NYS6Yd2LQe5Uj78i7ME8=;
        b=P1qF0GWp2ESbMxRU9rMRTRtHWRBkD1v+1WXvAISPPIh+VSnWPFIGPLoapirl8S/I3n
         iolZfBCkp37hkMruvh3RjLE2EJjPAqgpi8hWERPG4Tg3d2gQ4OWskighXPNL1Px87/Oq
         AaVwz2pgpUY4LWNNqZw+tT1n2N3Aw1m4XAb4a8PncJJvjdZc0GXbX1+254/qlIxOvpXw
         WSq+Ym3meAPX7OCPA+F/8USyoD0/j2ueaOTQJ3wi14vrw7UYy5DjyR7APQaze72pUsOF
         RzlFInF0gZUBL2D6zlJOtFT34tGjamcj2tvch2FVV1XN2wECOLn1R/Hgbt1qiolQ2192
         bfHA==
X-Gm-Message-State: AOAM5331BuNAMjUdwqsQpJaJ5A008EuVY6BmMvKeGMwQ9tBzy5FTvE9B
        UuG86j/0j6KVt9Qj+M9t1JavFQKxE4WQzWxs3JA+SA9tpr6QqKCCzZ7kSiw0KIw7XswfVEdlp79
        aA3uYYJjlHTk7actP
X-Received: by 2002:a50:e0c9:: with SMTP id j9mr49332380edl.336.1639248206731;
        Sat, 11 Dec 2021 10:43:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy155dYLxcn2rzl6A/QgkXsI2OS7AM7FGp8XniIzyJK2b1r2oVHcBKBMayKv3jM/vXeuhpMdg==
X-Received: by 2002:a50:e0c9:: with SMTP id j9mr49332244edl.336.1639248205437;
        Sat, 11 Dec 2021 10:43:25 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m16sm3484473edd.61.2021.12.11.10.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 10:43:24 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F3CAF180496; Sat, 11 Dec 2021 19:43:22 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 1/8] xdp: Allow registering memory model without rxq reference
Date:   Sat, 11 Dec 2021 19:41:35 +0100
Message-Id: <20211211184143.142003-2-toke@redhat.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211211184143.142003-1-toke@redhat.com>
References: <20211211184143.142003-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions that register an XDP memory model take a struct xdp_rxq as
parameter, but the RXQ is not actually used for anything other than pulling
out the struct xdp_mem_info that it embeds. So refactor the register
functions and export variants that just take a pointer to the xdp_mem_info.

This is in preparation for enabling XDP_REDIRECT in bpf_prog_run(), using a
page_pool instance that is not connected to any network device.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/xdp.h |  3 ++
 net/core/xdp.c    | 92 +++++++++++++++++++++++++++++++----------------
 2 files changed, 65 insertions(+), 30 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 447f9b1578f3..8f0812e4996d 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -260,6 +260,9 @@ bool xdp_rxq_info_is_reg(struct xdp_rxq_info *xdp_rxq);
 int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 			       enum xdp_mem_type type, void *allocator);
 void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq);
+int xdp_reg_mem_model(struct xdp_mem_info *mem,
+		      enum xdp_mem_type type, void *allocator);
+void xdp_unreg_mem_model(struct xdp_mem_info *mem);
 
 /* Drivers not supporting XDP metadata can use this helper, which
  * rejects any room expansion for metadata as a result.
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 5ddc29f29bad..ac476c84a986 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -110,20 +110,15 @@ static void mem_allocator_disconnect(void *allocator)
 	mutex_unlock(&mem_id_lock);
 }
 
-void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
+void xdp_unreg_mem_model(struct xdp_mem_info *mem)
 {
 	struct xdp_mem_allocator *xa;
-	int type = xdp_rxq->mem.type;
-	int id = xdp_rxq->mem.id;
+	int type = mem->type;
+	int id = mem->id;
 
 	/* Reset mem info to defaults */
-	xdp_rxq->mem.id = 0;
-	xdp_rxq->mem.type = 0;
-
-	if (xdp_rxq->reg_state != REG_STATE_REGISTERED) {
-		WARN(1, "Missing register, driver bug");
-		return;
-	}
+	mem->id = 0;
+	mem->type = 0;
 
 	if (id == 0)
 		return;
@@ -135,6 +130,17 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
 		rcu_read_unlock();
 	}
 }
+EXPORT_SYMBOL_GPL(xdp_unreg_mem_model);
+
+void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
+{
+	if (xdp_rxq->reg_state != REG_STATE_REGISTERED) {
+		WARN(1, "Missing register, driver bug");
+		return;
+	}
+
+	xdp_unreg_mem_model(&xdp_rxq->mem);
+}
 EXPORT_SYMBOL_GPL(xdp_rxq_info_unreg_mem_model);
 
 void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq)
@@ -259,28 +265,24 @@ static bool __is_supported_mem_type(enum xdp_mem_type type)
 	return true;
 }
 
-int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
-			       enum xdp_mem_type type, void *allocator)
+static struct xdp_mem_allocator *__xdp_reg_mem_model(struct xdp_mem_info *mem,
+						     enum xdp_mem_type type,
+						     void *allocator)
 {
 	struct xdp_mem_allocator *xdp_alloc;
 	gfp_t gfp = GFP_KERNEL;
 	int id, errno, ret;
 	void *ptr;
 
-	if (xdp_rxq->reg_state != REG_STATE_REGISTERED) {
-		WARN(1, "Missing register, driver bug");
-		return -EFAULT;
-	}
-
 	if (!__is_supported_mem_type(type))
-		return -EOPNOTSUPP;
+		return ERR_PTR(-EOPNOTSUPP);
 
-	xdp_rxq->mem.type = type;
+	mem->type = type;
 
 	if (!allocator) {
 		if (type == MEM_TYPE_PAGE_POOL)
-			return -EINVAL; /* Setup time check page_pool req */
-		return 0;
+			return ERR_PTR(-EINVAL); /* Setup time check page_pool req */
+		return NULL;
 	}
 
 	/* Delay init of rhashtable to save memory if feature isn't used */
@@ -290,13 +292,13 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 		mutex_unlock(&mem_id_lock);
 		if (ret < 0) {
 			WARN_ON(1);
-			return ret;
+			return ERR_PTR(ret);
 		}
 	}
 
 	xdp_alloc = kzalloc(sizeof(*xdp_alloc), gfp);
 	if (!xdp_alloc)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	mutex_lock(&mem_id_lock);
 	id = __mem_id_cyclic_get(gfp);
@@ -304,15 +306,15 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 		errno = id;
 		goto err;
 	}
-	xdp_rxq->mem.id = id;
-	xdp_alloc->mem  = xdp_rxq->mem;
+	mem->id = id;
+	xdp_alloc->mem = *mem;
 	xdp_alloc->allocator = allocator;
 
 	/* Insert allocator into ID lookup table */
 	ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);
 	if (IS_ERR(ptr)) {
-		ida_simple_remove(&mem_id_pool, xdp_rxq->mem.id);
-		xdp_rxq->mem.id = 0;
+		ida_simple_remove(&mem_id_pool, mem->id);
+		mem->id = 0;
 		errno = PTR_ERR(ptr);
 		goto err;
 	}
@@ -322,13 +324,43 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 
 	mutex_unlock(&mem_id_lock);
 
-	trace_mem_connect(xdp_alloc, xdp_rxq);
-	return 0;
+	return xdp_alloc;
 err:
 	mutex_unlock(&mem_id_lock);
 	kfree(xdp_alloc);
-	return errno;
+	return ERR_PTR(errno);
+}
+
+int xdp_reg_mem_model(struct xdp_mem_info *mem,
+		      enum xdp_mem_type type, void *allocator)
+{
+	struct xdp_mem_allocator *xdp_alloc;
+
+	xdp_alloc = __xdp_reg_mem_model(mem, type, allocator);
+	if (IS_ERR(xdp_alloc))
+		return PTR_ERR(xdp_alloc);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xdp_reg_mem_model);
+
+int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
+			       enum xdp_mem_type type, void *allocator)
+{
+	struct xdp_mem_allocator *xdp_alloc;
+
+	if (xdp_rxq->reg_state != REG_STATE_REGISTERED) {
+		WARN(1, "Missing register, driver bug");
+		return -EFAULT;
+	}
+
+	xdp_alloc = __xdp_reg_mem_model(&xdp_rxq->mem, type, allocator);
+	if (IS_ERR(xdp_alloc))
+		return PTR_ERR(xdp_alloc);
+
+	trace_mem_connect(xdp_alloc, xdp_rxq);
+	return 0;
 }
+
 EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
 
 /* XDP RX runs under NAPI protection, and in different delivery error
-- 
2.34.0

