Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38E93F8EF7
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243595AbhHZTl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:41:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32665 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243617AbhHZTlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:41:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ISOz03pxm8/IDfssr2+wjRRzJVFbEDf7IJBjDKpD7YI=;
        b=QeQi+A7JHB4dRzn9cpQrf3D7tWB+7QBuXLHoCiWXUAmTxom++o7z6jLl2uzY2G/rhX8rWN
        OHOTRTsvkflTXXN17DIFdYDtMxdxdWhobYSOzkj6FK4f5mFmnS6XhUiWiR1B1gVQNCo0rU
        15QeJ6lVCQM5dmPLX85JP5TNB9D3JlM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-L5yNHOb1NYS4VDIWEh4aIw-1; Thu, 26 Aug 2021 15:41:04 -0400
X-MC-Unique: L5yNHOb1NYS4VDIWEh4aIw-1
Received: by mail-wm1-f71.google.com with SMTP id o3-20020a05600c510300b002e6dd64e896so1907588wms.1
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:41:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ISOz03pxm8/IDfssr2+wjRRzJVFbEDf7IJBjDKpD7YI=;
        b=UA2V2mtsReIVVj2xFnXCUrN2anYCpm8rA8q4VDUSNquqgVauJwmf7JXTwYIHGhg+b2
         SBwYVdP91EwkIYCAixShbI/FU+iCFyxztW7KI+SXbvGIZSZ8lOSVGuvPFD0fMr0F5Ma1
         aLvi9nfRJDlo+je92AZJpX6mROpPH3zYxPAzfd76LztD/mBc6GFl3WyQM9lR3VLx8Dwl
         KJeeYbbRWxAEIkVKNVcUclCiWl5KPA3vCVWpX+iYi+yocaV+Pg2y/EuSA1FBLQg4Rw6c
         sCNZSjb89l8zpMHHma0W/vNbjNVmHAxUT8/xNRrrRPVAPQFeWcrRI5rJ7OL+UI8dOMc0
         RhBg==
X-Gm-Message-State: AOAM530f7OtLXP5ZoXWga5jm4ElM89RQCIOW5zVVu3sdtrtEZHm0BpSA
        t7Zysks2sQLfy/KZcD18iFqHVn6ZBVZMo+wLNM7wMtUN3YyheDyuUdb79e+ZZHzB5J4Uxd5NQ49
        ZJ8QaHyJ1aeA00IQ3
X-Received: by 2002:a5d:6707:: with SMTP id o7mr6103981wru.307.1630006863210;
        Thu, 26 Aug 2021 12:41:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuAcnoH9r3dNMdYGKPXN+YTRJdweWec0LDdFWr33uFOwzn9/YBcxwHxSUU5VsuJnmi3PlETA==
X-Received: by 2002:a5d:6707:: with SMTP id o7mr6103956wru.307.1630006862972;
        Thu, 26 Aug 2021 12:41:02 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id j7sm9112722wmi.37.2021.08.26.12.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:41:02 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 16/27] bpf: Add bpf_trampoline_multi_get/put functions
Date:   Thu, 26 Aug 2021 21:39:11 +0200
Message-Id: <20210826193922.66204-17-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding struct bpf_trampoline_multi object and API to allocate
and free it.

The multi bpf trampoline is defined by BTF ids that represents
functions that the trampoline will be attached to.

By calling bpf_trampoline_multi_get you'll allocate new or get
existing bpf_trampoline_multi object with following rules:

  - multi trampolines BTF ids can't intersect
  - multi trampoline can attach to functions that have standard
    program attached
  - standard programs can't attach to functions that have multi
    trampoline attached

The multi trampoline contains pointers to all 'nested' standard
trampolines and 'main' standard trampoline object (with key == 0)
that represents the rest of the functions.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h     |  15 ++++
 kernel/bpf/trampoline.c | 179 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 194 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a5c3307d49c6..678b9cd2fa21 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -691,6 +691,18 @@ struct bpf_trampoline {
 	struct bpf_tramp_image *cur_image;
 	u64 selector;
 	struct module *mod;
+	struct {
+		struct bpf_trampoline *tr;
+	} multi;
+};
+
+struct bpf_trampoline_multi {
+	struct bpf_trampoline main;
+	struct list_head list;
+	u32 *ids;
+	u32 ids_cnt;
+	int tr_cnt;
+	struct bpf_trampoline *tr[];
 };
 
 struct bpf_attach_target_info {
@@ -732,6 +744,9 @@ int bpf_trampoline_unlink_prog(struct bpf_tramp_node *node, struct bpf_trampolin
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
+struct bpf_trampoline_multi *bpf_trampoline_multi_get(struct bpf_prog *prog, u32 *ids,
+						      u32 ids_cnt);
+void bpf_trampoline_multi_put(struct bpf_trampoline_multi *multi);
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
 	.func = &_name##_func,					\
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index c9794e9f24ee..d66b76c23d74 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -10,6 +10,9 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/rcupdate_wait.h>
 #include <linux/module.h>
+#include <linux/bsearch.h>
+#include <linux/bpf_verifier.h>
+#include <linux/sort.h>
 
 /* dummy _ops. The verifier will operate on target program's ops. */
 const struct bpf_verifier_ops bpf_extension_verifier_ops = {
@@ -22,6 +25,7 @@ const struct bpf_prog_ops bpf_extension_prog_ops = {
 #define TRAMPOLINE_TABLE_SIZE (1 << TRAMPOLINE_HASH_BITS)
 
 static struct hlist_head trampoline_table[TRAMPOLINE_TABLE_SIZE];
+static LIST_HEAD(trampoline_multi);
 
 /* serializes access to trampoline_table */
 static DEFINE_MUTEX(trampoline_mutex);
@@ -85,12 +89,41 @@ static struct bpf_trampoline *__bpf_trampoline_lookup(u64 key)
 	return NULL;
 }
 
+static int btf_ids_cmp(const void *a, const void *b)
+{
+	const u32 *x = a;
+	const u32 *y = b;
+
+	if (*x == *y)
+		return 0;
+	return *x < *y ? -1 : 1;
+}
+
+static bool is_in_multi(u64 key)
+{
+	struct bpf_trampoline_multi *multi;
+	u32 id;
+
+	bpf_trampoline_unpack_key(key, NULL, &id);
+
+	list_for_each_entry(multi, &trampoline_multi, list) {
+		if (bsearch(&id, multi->ids, multi->ids_cnt,
+			    sizeof(u32), btf_ids_cmp))
+			return true;
+	}
+	return false;
+}
+
 static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
 	struct bpf_trampoline *tr;
 	struct hlist_head *head;
 
 	mutex_lock(&trampoline_mutex);
+	if (is_in_multi(key)) {
+		tr = ERR_PTR(-EBUSY);
+		goto out;
+	}
 	tr = __bpf_trampoline_lookup(key);
 	if (tr) {
 		refcount_inc(&tr->refcnt);
@@ -553,6 +586,152 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 	mutex_unlock(&trampoline_mutex);
 }
 
+static void bpf_func_model_nargs(struct btf_func_model *m, int nr_args)
+{
+	int i;
+
+	for (i = 0; i < nr_args; i++)
+		m->arg_size[i] = 8;
+	m->ret_size = 8;
+	m->nr_args = nr_args;
+}
+
+static struct bpf_trampoline *lookup_trampoline(struct bpf_prog *prog, u32 id)
+{
+	u64 key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf, id);
+
+	return __bpf_trampoline_lookup(key);
+}
+
+struct bpf_trampoline_multi *bpf_trampoline_multi_get(struct bpf_prog *prog,
+						      u32 *ids, u32 ids_cnt)
+{
+	int i, j, tr_cnt = 0, err = 0;
+	struct bpf_trampoline_multi *multi;
+	struct bpf_trampoline *tr;
+	u8 nr_args = 0;
+	size_t size;
+
+	/* Sort user provided BTF ids, so we can use memcpy
+	 * and bsearch below.
+	 */
+	sort(ids, ids_cnt, sizeof(u32), btf_ids_cmp, NULL);
+
+	mutex_lock(&trampoline_mutex);
+	/* Check if the requested multi trampoline already exists. */
+	list_for_each_entry(multi, &trampoline_multi, list) {
+		if (ids_cnt == multi->ids_cnt && !memcmp(ids, multi->ids, ids_cnt)) {
+			refcount_inc(&multi->main.refcnt);
+			kfree(ids);
+			goto out;
+		}
+		for (i = 0; i < ids_cnt; i++) {
+			if (bsearch(&ids[i], multi->ids, multi->ids_cnt,
+				    sizeof(u32), btf_ids_cmp)) {
+				multi = ERR_PTR(-EINVAL);
+				goto out;
+			}
+		}
+	}
+
+	/* Check if any of the requested functions have already standard
+	 * trampoline attached.
+	 */
+	for (i = 0; i < ids_cnt; i++) {
+		tr = lookup_trampoline(prog, ids[i]);
+		if (!tr)
+			continue;
+		if (tr->multi.tr) {
+			multi = ERR_PTR(-EBUSY);
+			goto out;
+		}
+		tr_cnt++;
+	}
+
+	/* Create new multi trampoline ... */
+	size = sizeof(*multi) + tr_cnt * sizeof(multi->tr[0]);
+	multi = kzalloc(size, GFP_KERNEL);
+	if (!multi) {
+		multi = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	bpf_trampoline_init(&multi->main, 0);
+	multi->tr_cnt = tr_cnt;
+	multi->ids = ids;
+	multi->ids_cnt = ids_cnt;
+	list_add_tail(&multi->list, &trampoline_multi);
+
+	for (i = 0; i < ids_cnt; i++) {
+		struct bpf_attach_target_info tgt_info = {};
+
+		tr = lookup_trampoline(prog, ids[i]);
+		if (tr)
+			continue;
+
+		err = bpf_check_attach_target(NULL, prog, NULL, ids[i], &tgt_info);
+		if (err)
+			goto out_free;
+
+		err = -EINVAL;
+		if (!is_ftrace_location((void *) tgt_info.tgt_addr))
+			goto out_free;
+
+		if (nr_args < tgt_info.fmodel.nr_args)
+			nr_args = tgt_info.fmodel.nr_args;
+	}
+
+	bpf_func_model_nargs(&multi->main.func.model, nr_args);
+
+	/* ... and attach already existing standard trampolines. */
+	for (i = 0, j = 0; i < ids_cnt && j < tr_cnt; i++) {
+		tr = lookup_trampoline(prog, ids[i]);
+		if (tr) {
+			refcount_inc(&tr->refcnt);
+			tr->multi.tr = &multi->main;
+			multi->tr[j++] = tr;
+		}
+	}
+
+out_free:
+	if (err) {
+		list_del(&multi->list);
+		kfree(multi);
+		multi = ERR_PTR(err);
+	}
+out:
+	mutex_unlock(&trampoline_mutex);
+	return multi;
+}
+
+void bpf_trampoline_multi_put(struct bpf_trampoline_multi *multi)
+{
+	int i;
+
+	if (!multi)
+		return;
+
+	mutex_lock(&trampoline_mutex);
+	if (!refcount_dec_and_test(&multi->main.refcnt))
+		goto out;
+
+	if (WARN_ON_ONCE(!hlist_empty(&multi->main.progs_hlist[BPF_TRAMP_FENTRY])))
+		goto out;
+	if (WARN_ON_ONCE(!hlist_empty(&multi->main.progs_hlist[BPF_TRAMP_FEXIT])))
+		goto out;
+
+	list_del(&multi->list);
+
+	for (i = 0; i < multi->tr_cnt; i++) {
+		multi->tr[i]->multi.tr = NULL;
+		__bpf_trampoline_put(multi->tr[i]);
+	}
+	kfree(multi->ids);
+	kfree(multi);
+out:
+	mutex_unlock(&trampoline_mutex);
+}
+
 #define NO_START_TIME 1
 static u64 notrace bpf_prog_start_time(void)
 {
-- 
2.31.1

