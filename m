Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C8D3F8EED
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243568AbhHZTlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:41:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22924 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243561AbhHZTlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:41:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PSIDNuxSNboWGja6JJJ//OQqFnAgGxrRV3fj8oXduYs=;
        b=JAZ2tTRDSxMLX26HYqGRw7tJDdH6QN0amlb2gbT2+79JIPbkxUtd2SIZ64dsYsy3gOEf4E
        8dJyDHC9XOW5tLASQ15rMxq0brZl79Fo0Ex/N3J9cNJe3MQprvUhGzeBz+yL8/NghBMOL9
        6X/bfdBg1KL5t2wBmz9bsVV3ot0tZU8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542--qtjpH4tNIadqKuXAcrDfQ-1; Thu, 26 Aug 2021 15:40:33 -0400
X-MC-Unique: -qtjpH4tNIadqKuXAcrDfQ-1
Received: by mail-wm1-f69.google.com with SMTP id m22-20020a7bca56000000b002e7508f3faeso1273952wml.2
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:40:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PSIDNuxSNboWGja6JJJ//OQqFnAgGxrRV3fj8oXduYs=;
        b=qKBJpTaZtB3iXVxAqoXs2jUHTCvmQg+G/+c7ofITeEW6AUcjsfomj8h3FONUTfD1yZ
         ruiI6TRA6WVPmjc1eJpPmWXxIjZpc+ivO/TCXoif65hvUFQaIpNKWrJoek4jCzYWc3QR
         qheYdesXteh5dKFU9JNb3Hu0Pi+7TlyegociIV425IzTa0W0gwR9UF5nEVUaoDRN6Xem
         mpWLCnhWSGNIvGHKcGB8BaZKYHJ5NC3C46XIyrmQur552/wJafIyQBY+OiTxOzU1o797
         QlqIsAR9tzjUXGJYkmAG2JDm7onCm1iVrUekaBRbIeGg+cbNOMvc8pOyCF3N5Q5lCpxx
         a5dg==
X-Gm-Message-State: AOAM5303WOM+DfowhYcjcNwHYeGTEKDjzek7YM0u5BynOuPUOVM3v5G6
        dDpHPusf+7fApRdj6HMcswMtfZfbwqKOvMQKO6qoUGJodoqVB9Jtwl3SXl8UQBo6jH3z7MNkgl+
        ll/M2wyoft9S4Z26E
X-Received: by 2002:a5d:4d03:: with SMTP id z3mr6008082wrt.229.1630006832019;
        Thu, 26 Aug 2021 12:40:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuQjRMB3r13599nxIcsa8dPQw9RicOFY+s2ocnwBE1cxvcGUhEESYSLd5EulO1V4gbP89M8g==
X-Received: by 2002:a5d:4d03:: with SMTP id z3mr6008069wrt.229.1630006831880;
        Thu, 26 Aug 2021 12:40:31 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id g11sm4016811wrx.30.2021.08.26.12.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:40:31 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH bpf-next v4 11/27] bpf: Factor out bpf_trampoline_init function
Date:   Thu, 26 Aug 2021 21:39:06 +0200
Message-Id: <20210826193922.66204-12-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separating out bpf_trampoline_init function, so it can
be used from other places in following patches.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/trampoline.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 525fa74c2f62..f44899c9698a 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -58,11 +58,22 @@ void bpf_image_ksym_del(struct bpf_ksym *ksym)
 			   PAGE_SIZE, true, ksym->name);
 }
 
+static void bpf_trampoline_init(struct bpf_trampoline *tr, u64 key)
+{
+	int i;
+
+	tr->key = key;
+	INIT_HLIST_NODE(&tr->hlist);
+	refcount_set(&tr->refcnt, 1);
+	mutex_init(&tr->mutex);
+	for (i = 0; i < BPF_TRAMP_MAX; i++)
+		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
+}
+
 static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
 	struct bpf_trampoline *tr;
 	struct hlist_head *head;
-	int i;
 
 	mutex_lock(&trampoline_mutex);
 	head = &trampoline_table[hash_64(key, TRAMPOLINE_HASH_BITS)];
@@ -75,14 +86,8 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
 	if (!tr)
 		goto out;
-
-	tr->key = key;
-	INIT_HLIST_NODE(&tr->hlist);
+	bpf_trampoline_init(tr, key);
 	hlist_add_head(&tr->hlist, head);
-	refcount_set(&tr->refcnt, 1);
-	mutex_init(&tr->mutex);
-	for (i = 0; i < BPF_TRAMP_MAX; i++)
-		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
 out:
 	mutex_unlock(&trampoline_mutex);
 	return tr;
-- 
2.31.1

