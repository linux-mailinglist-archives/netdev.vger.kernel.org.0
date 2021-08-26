Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1F53F8EDC
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243518AbhHZTkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:40:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29156 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243505AbhHZTkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:40:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jJQ/tMNBXaGFHSvueMGSUoswOun/bpw7UK/P+WAvXSI=;
        b=PL1uj/IWgW//pSF5kqXhi/BMwAhdtI1x5kzxMDN0iMush73/DVAqhw7OPOXOfmu7Gfrym/
        b6hallJSDKEGDj5YuvAPaAjg90rjRhLrx2HJNLjj2eviz+1wVsx+gwp5EXrU7vEtsP0WuV
        Zv1gHqhNpLKz2U8mFAtuq6SopiHog6M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-s4geqkAkMtqQ9lYhUaVVqw-1; Thu, 26 Aug 2021 15:40:03 -0400
X-MC-Unique: s4geqkAkMtqQ9lYhUaVVqw-1
Received: by mail-wm1-f69.google.com with SMTP id 8-20020a05600c228800b002e886e15768so1128687wmf.5
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:40:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jJQ/tMNBXaGFHSvueMGSUoswOun/bpw7UK/P+WAvXSI=;
        b=hk9BxsuFlQtlhZnIk9OhI2B/WTJhhubQJh9dEoULf7pP6M50jwxPwYn0gdp8tCy7sN
         8irBVo0UAR+rvsuBPt7a3PWGYhb/0W4c6Lw3cQJ8TDA8SDQLI0ys97bDGkVgDZQKpgGh
         0mlJldVbDxoZv9eRNeqKeWj/Voy1TeMMxIcFf2CcBFvxXQNFqgMztB9DMepPqjN16iwG
         n4HFaGnXsHeDRMJ8R9uSAuBj+4NfnDiW3kaXCv8IrdPljG8+t7lxxXnQ8uosUQdN7hR9
         6idjGcGH8WcSdUvUin01ysOWlxnP+w3NmYXkow1VGNjRbT5vFZH1mtxklY92jrl3qJ++
         2UXg==
X-Gm-Message-State: AOAM530xziFlLlPCX13pW7SH/di1A/xSgQcZu6gNHq/bHqwhIQiWiDfU
        44eGUtEwIRkr8YE0cc/U1owKOuj1ZhFgbYAv8LLrtkomi0Exbr6rJ8hxP/LUQoPgAZrQHKBWTaU
        qe+EyxLEoTrGw1EDx
X-Received: by 2002:a05:6000:259:: with SMTP id m25mr6083243wrz.53.1630006800787;
        Thu, 26 Aug 2021 12:40:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkPTBgsURejuxJTIjuestEHFAy+9/r3Y8oB2z0Dt6mIxe7/DOx/+W3andgX1YyrhGriFbOQw==
X-Received: by 2002:a05:6000:259:: with SMTP id m25mr6083221wrz.53.1630006800591;
        Thu, 26 Aug 2021 12:40:00 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id t5sm2944929wra.95.2021.08.26.12.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:40:00 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 06/27] ftrace: Add multi direct register/unregister interface
Date:   Thu, 26 Aug 2021 21:39:01 +0200
Message-Id: <20210826193922.66204-7-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding interface to register multiple direct functions
within single call. Adding following functions:

  register_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
  unregister_ftrace_direct_multi(struct ftrace_ops *ops)

The register_ftrace_direct_multi registers direct function (addr)
with all functions in ops filter. The ops filter can be updated
before with ftrace_set_filter_ip calls.

All requested functions must not have direct function currently
registered, otherwise register_ftrace_direct_multi will fail.

The unregister_ftrace_direct_multi unregisters ops related direct
functions.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/ftrace.h |  10 ++++
 kernel/trace/ftrace.c  | 111 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9b218e59a608..93d8f12e70b3 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -316,6 +316,8 @@ int ftrace_modify_direct_caller(struct ftrace_func_entry *entry,
 				unsigned long old_addr,
 				unsigned long new_addr);
 unsigned long ftrace_find_rec_direct(unsigned long ip);
+int register_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr);
+int unregister_ftrace_direct_multi(struct ftrace_ops *ops);
 #else
 # define ftrace_direct_func_count 0
 static inline int register_ftrace_direct(unsigned long ip, unsigned long addr)
@@ -346,6 +348,14 @@ static inline unsigned long ftrace_find_rec_direct(unsigned long ip)
 {
 	return 0;
 }
+int register_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
+{
+	return -ENODEV;
+}
+int unregister_ftrace_direct_multi(struct ftrace_ops *ops)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
 
 #ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c60217d81040..7243769493c9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5407,6 +5407,117 @@ int modify_ftrace_direct(unsigned long ip,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(modify_ftrace_direct);
+
+#define MULTI_FLAGS (FTRACE_OPS_FL_IPMODIFY | FTRACE_OPS_FL_DIRECT | \
+		     FTRACE_OPS_FL_SAVE_REGS)
+
+static int check_direct_multi(struct ftrace_ops *ops)
+{
+	if (!(ops->flags & FTRACE_OPS_FL_INITIALIZED))
+		return -EINVAL;
+	if ((ops->flags & MULTI_FLAGS) != MULTI_FLAGS)
+		return -EINVAL;
+	return 0;
+}
+
+int register_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
+{
+	struct ftrace_hash *hash, *free_hash = NULL;
+	struct ftrace_func_entry *entry, *new;
+	int err = -EBUSY, size, i;
+
+	if (ops->func || ops->trampoline)
+		return -EINVAL;
+	if (!(ops->flags & FTRACE_OPS_FL_INITIALIZED))
+		return -EINVAL;
+	if (ops->flags & FTRACE_OPS_FL_ENABLED)
+		return -EINVAL;
+
+	hash = ops->func_hash->filter_hash;
+	if (ftrace_hash_empty(hash))
+		return -EINVAL;
+
+	mutex_lock(&direct_mutex);
+
+	/* Make sure requested entries are not already registered.. */
+	size = 1 << hash->size_bits;
+	for (i = 0; i < size; i++) {
+		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
+			if (ftrace_find_rec_direct(entry->ip))
+				goto out_unlock;
+		}
+	}
+
+	/* ... and insert them to direct_functions hash. */
+	err = -ENOMEM;
+	for (i = 0; i < size; i++) {
+		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
+			new = ftrace_add_rec_direct(entry->ip, addr, &free_hash);
+			if (!new)
+				goto out_remove;
+			entry->direct = addr;
+		}
+	}
+
+	ops->func = call_direct_funcs;
+	ops->flags = MULTI_FLAGS;
+	ops->trampoline = FTRACE_REGS_ADDR;
+
+	err = register_ftrace_function(ops);
+
+ out_remove:
+	if (err) {
+		for (i = 0; i < size; i++) {
+			hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
+				new = __ftrace_lookup_ip(direct_functions, entry->ip);
+				if (new) {
+					remove_hash_entry(direct_functions, new);
+					kfree(new);
+				}
+			}
+		}
+	}
+
+ out_unlock:
+	mutex_unlock(&direct_mutex);
+
+	if (free_hash) {
+		synchronize_rcu_tasks();
+		free_ftrace_hash(free_hash);
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(register_ftrace_direct_multi);
+
+int unregister_ftrace_direct_multi(struct ftrace_ops *ops)
+{
+	struct ftrace_hash *hash = ops->func_hash->filter_hash;
+	struct ftrace_func_entry *entry, *new;
+	int err, size, i;
+
+	if (check_direct_multi(ops))
+		return -EINVAL;
+	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
+		return -EINVAL;
+
+	mutex_lock(&direct_mutex);
+	err = unregister_ftrace_function(ops);
+
+	size = 1 << hash->size_bits;
+	for (i = 0; i < size; i++) {
+		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
+			new = __ftrace_lookup_ip(direct_functions, entry->ip);
+			if (new) {
+				remove_hash_entry(direct_functions, new);
+				kfree(new);
+			}
+		}
+	}
+
+	mutex_unlock(&direct_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(unregister_ftrace_direct_multi);
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
 
 /**
-- 
2.31.1

