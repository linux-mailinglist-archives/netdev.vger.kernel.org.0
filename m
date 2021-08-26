Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4AA3F8EF0
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243584AbhHZTlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:41:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243587AbhHZTl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:41:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gXpJHZO1cihtLBArG/eE/Ics75WBgBQPWIW5tbtMZsM=;
        b=Zmid3RIHz2Jxmur7Linz/Ppuo/7yLy+HZyfvRUsAHfvWcq8XBtPH0zM+YyOYE2V05oMDYx
        +MFIx9nwlTcF4CFA6xH9AZ5QPMnAk+zOnmvE4hVmhB53FPU9k1afAcqS5gm37FfkgrLlHQ
        F28a36+j7hhg1GPtWgCkwPBZvQrQoGs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-KqGCBQ7IPJ-uWUyoh4ReDQ-1; Thu, 26 Aug 2021 15:40:39 -0400
X-MC-Unique: KqGCBQ7IPJ-uWUyoh4ReDQ-1
Received: by mail-wr1-f70.google.com with SMTP id h14-20020a056000000e00b001575b00eb08so1184438wrx.13
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:40:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gXpJHZO1cihtLBArG/eE/Ics75WBgBQPWIW5tbtMZsM=;
        b=H6fvcw6dn1HyZ055I4yRRpfXzdn6VbvXrKujoD23Pmowd7jXo3KBCNhPKfhXPFBIBO
         n++8v8t0Ax+7RxVGJCgE+838TFH1x6nLKD2VTWyH7nQIWN6UPKh2eQKxUj4uDP6rJa0y
         idby2Pd77MYdLY85oLUKVzWfzlZsC846aPkhrbLlqJLJn7rQfvawlEPdxC/glE45YuVI
         sWAZt1lkQ32sm70eOitk92uTMybUUUxOzor4aLz/ZXS+s+CIs2ogZI2oLZhOz/YERhlW
         xm7vfQ4C9GmfsWUA4tOI5MKciPiXwWA27xBgq1w14cyw8DwkkaIVEKEXUbYOSzn0qnO4
         VPUg==
X-Gm-Message-State: AOAM531IxCVtHQTidQHPKRqdbO4cRh50hpmN7DvBKcnQgIEFLGuCQZ8H
        HEG5qtMx0fDoONwqrtVGlmYznFIoRXUZm/tIZir2YVuLJ/XS1insXT6RFhC6Kljme17N8isFW4g
        2OGjD2EU4dQXptiRN
X-Received: by 2002:adf:d0cf:: with SMTP id z15mr6017470wrh.356.1630006838126;
        Thu, 26 Aug 2021 12:40:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx03/eQ8lgmsE2bT+LDzqvydNywb8x2w37h8HYfEYEsVbKsve6VGBDJGD7R+bXh6oEAsZ3oyg==
X-Received: by 2002:adf:d0cf:: with SMTP id z15mr6017455wrh.356.1630006837992;
        Thu, 26 Aug 2021 12:40:37 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id r12sm4234429wrv.96.2021.08.26.12.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:40:37 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 12/27] bpf: Factor out __bpf_trampoline_lookup function
Date:   Thu, 26 Aug 2021 21:39:07 +0200
Message-Id: <20210826193922.66204-13-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separating out __bpf_trampoline_lookup function, so it can
be used from other places in following patches.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/trampoline.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index f44899c9698a..6dba43266e0b 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -70,23 +70,37 @@ static void bpf_trampoline_init(struct bpf_trampoline *tr, u64 key)
 		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
 }
 
-static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
+static struct bpf_trampoline *__bpf_trampoline_lookup(u64 key)
 {
 	struct bpf_trampoline *tr;
 	struct hlist_head *head;
 
-	mutex_lock(&trampoline_mutex);
+	lockdep_assert_held(&trampoline_mutex);
+
 	head = &trampoline_table[hash_64(key, TRAMPOLINE_HASH_BITS)];
 	hlist_for_each_entry(tr, head, hlist) {
-		if (tr->key == key) {
-			refcount_inc(&tr->refcnt);
-			goto out;
-		}
+		if (tr->key == key)
+			return tr;
+	}
+	return NULL;
+}
+
+static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
+{
+	struct bpf_trampoline *tr;
+	struct hlist_head *head;
+
+	mutex_lock(&trampoline_mutex);
+	tr = __bpf_trampoline_lookup(key);
+	if (tr) {
+		refcount_inc(&tr->refcnt);
+		goto out;
 	}
 	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
 	if (!tr)
 		goto out;
 	bpf_trampoline_init(tr, key);
+	head = &trampoline_table[hash_64(key, TRAMPOLINE_HASH_BITS)];
 	hlist_add_head(&tr->hlist, head);
 out:
 	mutex_unlock(&trampoline_mutex);
-- 
2.31.1

