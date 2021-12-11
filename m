Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD0E471565
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 19:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhLKSnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 13:43:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42527 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231734AbhLKSn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 13:43:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639248208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/1Kcx3yx+iUNoYMcXpH7nt4oIAaYFOwsIruWeNBlL4w=;
        b=aJzvY+Cfs5seMDQgIKW7QSajVS6Il5rP9R/sbT1b9MsPteRodFqAE41D6RnWNW7xgdP+qL
        SjeLAdvDZBqQkXE0+4IACePkp6JFGVs7dCNr3ZEB/YlVZcztRytZuqgK3z6dkp+wLidN1s
        8NybY0UB7VIO/phjjf68TZHA6KvEc6c=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-TmmI9DtbO3WcL1eSD4lPHw-1; Sat, 11 Dec 2021 13:43:27 -0500
X-MC-Unique: TmmI9DtbO3WcL1eSD4lPHw-1
Received: by mail-ed1-f70.google.com with SMTP id 30-20020a508e5e000000b003f02e458b17so10773137edx.17
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 10:43:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/1Kcx3yx+iUNoYMcXpH7nt4oIAaYFOwsIruWeNBlL4w=;
        b=ab/khYxo3qkYgVzF4fVCCx+nhgBgN3C4ecwvOQ3n6uMm2IXfuH93ystCVM6UWMgR0v
         D+muX6q7hWNz1VpE08lCK5jIRfu+kHZkrdaCGg+9kr5j7R7hA4SjXjNYVI6oNU5NxGGJ
         Uekcb2zq1mcKbCQX5UYyJ/FJHJjfm+jM4HdJ5uVfk94EQxfXoAqiR49vls1iMVW63GgN
         eNOSyD3+vjSgooE/0qFHTpC85a0et+zBkM3qpBhLXKlq+n9YTzT7e541+pPIdEwHfz7D
         cPXcAbrNBRFw0853ScF9p0Syp6wDw481tVXLNK1APRxhoIeI1jSayX8qYtPfBNWumIx2
         htyA==
X-Gm-Message-State: AOAM533kK9BWiy1Z1KWfOhRWP5Y0vTQaRMfb8zBBD8CKJm51BVugnAu2
        +7tgPQzXhtJSgH+9w5W21uuL7PhKeZlz+al7WhAYfnS/2CNanKkR7AYDhftMBtvrU9nRk0z8OjG
        gIVoTuWaQjJZ7/Ulf
X-Received: by 2002:a05:6402:b82:: with SMTP id cf2mr48683242edb.40.1639248205432;
        Sat, 11 Dec 2021 10:43:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJziiTNngzeUwvGURwzsfQfpho1FvjUGAGv8pxNn5G/VB7EfGxex4wjIj8XiLI98vqgQS/ctWQ==
X-Received: by 2002:a05:6402:b82:: with SMTP id cf2mr48683133edb.40.1639248204481;
        Sat, 11 Dec 2021 10:43:24 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id ar4sm3354904ejc.52.2021.12.11.10.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 10:43:24 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 60C3C180499; Sat, 11 Dec 2021 19:43:23 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 2/8] page_pool: Add callback to init pages when they are allocated
Date:   Sat, 11 Dec 2021 19:41:36 +0100
Message-Id: <20211211184143.142003-3-toke@redhat.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211211184143.142003-1-toke@redhat.com>
References: <20211211184143.142003-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new callback function to page_pool that, if set, will be called every
time a new page is allocated. This will be used from bpf_test_run() to
initialise the page data with the data provided by userspace when running
XDP programs with redirect turned on.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/page_pool.h | 2 ++
 net/core/page_pool.c    | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 3855f069627f..a71201854c41 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -80,6 +80,8 @@ struct page_pool_params {
 	enum dma_data_direction dma_dir; /* DMA mapping direction */
 	unsigned int	max_len; /* max DMA sync memory size */
 	unsigned int	offset;  /* DMA addr offset */
+	void (*init_callback)(struct page *page, void *arg);
+	void *init_arg;
 };
 
 struct page_pool {
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9b60e4301a44..c3b134a86ec9 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -219,6 +219,8 @@ static void page_pool_set_pp_info(struct page_pool *pool,
 {
 	page->pp = pool;
 	page->pp_magic |= PP_SIGNATURE;
+	if (pool->p.init_callback)
+		pool->p.init_callback(page, pool->p.init_arg);
 }
 
 static void page_pool_clear_pp_info(struct page *page)
-- 
2.34.0

