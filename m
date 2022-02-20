Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DF74BD0B9
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 19:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244540AbiBTSld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 13:41:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiBTSlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 13:41:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4640545502
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 10:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645382469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u9wFN1OhvJJ9qPyhnyKnWvWSIZB4hNTwLidVvqGcOC4=;
        b=eITwxGzUa7N63oi9xpetWntPo4Coj7XLz4bZduKWTudk3DLjBwFx48qF+RytGkAne8Ll+a
        e35ka408lCUo/XH7C2eWqgHfe/MBXoN4VxPCYThWNlzx7Rq3MVzeKW6pgAl+LjlWjb0oYH
        gVEgz8fF0X97dqdnJFzBrFevP9rqQ4E=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-0xxpyQhsNuqrdhOw8RDTGQ-1; Sun, 20 Feb 2022 13:41:08 -0500
X-MC-Unique: 0xxpyQhsNuqrdhOw8RDTGQ-1
Received: by mail-qk1-f197.google.com with SMTP id u12-20020a05620a0c4c00b00475a9324977so12309177qki.13
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 10:41:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u9wFN1OhvJJ9qPyhnyKnWvWSIZB4hNTwLidVvqGcOC4=;
        b=OMT02qBImK2xDzfyobFvonTmBPNLREqLTMeO1/7dbp4cBame22rz4ur4nB8/5YLwdl
         hmHvQp3w5Hq3/Vqa9ukpZJbZk0rmBvET/Mvlh1FbEi+vn5DjO6/zGHRr8HyPWtAPTb5g
         HLGSrtjnTV8/WFBKQLCi/WVyOugL0Yb/VzUlXxLP9T0c6xjRQMtqfn+ZwyT7mG42YpNU
         6VVYdTZyDmZKTamnmV2asdK8m15YdjFASSdSu8ZiOad0W0nl1VnkMvhg5XhEH12akVN1
         ydPFYcw9XqVSvUDsqyUN3UrdA6qdzEv6uK0+O02tHMuj2IHaCsA53GXoS4KT4vvcQnXq
         742g==
X-Gm-Message-State: AOAM532B1qcWk2I/eOxd628EMckEETWaw2GeVbEnQlMxvW8IFeGnsEYq
        J5ELY8+hEYVxyLYDnRYFbfwRwIvrBRlvTJR21u9PkvtIrmXK9J3J41brvgXpa+fS/MrPE0EHJRY
        bnP+jO4Y255oPF/hQ
X-Received: by 2002:a05:6214:9c1:b0:42d:b2b8:f760 with SMTP id dp1-20020a05621409c100b0042db2b8f760mr12658530qvb.123.1645382467166;
        Sun, 20 Feb 2022 10:41:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyfFh4O9qEGBB5lVN/I3Jx8V98UFE5oOeE2pUaPVreaUf4ZjLEZzVAcJak7tC+yUs4w/JErdg==
X-Received: by 2002:a05:6214:9c1:b0:42d:b2b8:f760 with SMTP id dp1-20020a05621409c100b0042db2b8f760mr12658513qvb.123.1645382466857;
        Sun, 20 Feb 2022 10:41:06 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id 16sm29631702qty.86.2022.02.20.10.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 10:41:06 -0800 (PST)
From:   trix@redhat.com
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] bpf: cleanup comments
Date:   Sun, 20 Feb 2022 10:40:55 -0800
Message-Id: <20220220184055.3608317-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Add leading space to spdx tag
Use // for spdx c file comment

Replacements
resereved to reserved
inbetween to in between
everytime to every time
intutivie to intuitive
currenct to current
encontered to encountered
referenceing to referencing
upto to up to
exectuted to executed

Signed-off-by: Tom Rix <trix@redhat.com>
---
 kernel/bpf/bpf_local_storage.c | 2 +-
 kernel/bpf/btf.c               | 6 +++---
 kernel/bpf/cgroup.c            | 8 ++++----
 kernel/bpf/hashtab.c           | 2 +-
 kernel/bpf/helpers.c           | 2 +-
 kernel/bpf/local_storage.c     | 2 +-
 kernel/bpf/reuseport_array.c   | 2 +-
 kernel/bpf/syscall.c           | 2 +-
 kernel/bpf/trampoline.c        | 2 +-
 9 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 71de2a89869c..092a1ac772d7 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -136,7 +136,7 @@ bool bpf_selem_unlink_storage_nolock(struct bpf_local_storage *local_storage,
 		 * will be done by the caller.
 		 *
 		 * Although the unlock will be done under
-		 * rcu_read_lock(),  it is more intutivie to
+		 * rcu_read_lock(),  it is more intuitive to
 		 * read if the freeing of the storage is done
 		 * after the raw_spin_unlock_bh(&local_storage->lock).
 		 *
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 02d7014417a0..8b11d1a9bee1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+// SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2018 Facebook */
 
 #include <uapi/linux/btf.h>
@@ -2547,7 +2547,7 @@ static int btf_ptr_resolve(struct btf_verifier_env *env,
 	 *
 	 * We now need to continue from the last-resolved-ptr to
 	 * ensure the last-resolved-ptr will not referring back to
-	 * the currenct ptr (t).
+	 * the current ptr (t).
 	 */
 	if (btf_type_is_modifier(next_type)) {
 		const struct btf_type *resolved_type;
@@ -6148,7 +6148,7 @@ int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
 
 	btf_type_show(btf, type_id, obj, (struct btf_show *)&ssnprintf);
 
-	/* If we encontered an error, return it. */
+	/* If we encountered an error, return it. */
 	if (ssnprintf.show.state.status)
 		return ssnprintf.show.state.status;
 
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 098632fdbc45..128028efda64 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1031,7 +1031,7 @@ int cgroup_bpf_prog_query(const union bpf_attr *attr,
  * __cgroup_bpf_run_filter_skb() - Run a program for packet filtering
  * @sk: The socket sending or receiving traffic
  * @skb: The skb that is being sent or received
- * @type: The type of program to be exectuted
+ * @type: The type of program to be executed
  *
  * If no socket is passed, or the socket is not of type INET or INET6,
  * this function does nothing and returns 0.
@@ -1094,7 +1094,7 @@ EXPORT_SYMBOL(__cgroup_bpf_run_filter_skb);
 /**
  * __cgroup_bpf_run_filter_sk() - Run a program on a sock
  * @sk: sock structure to manipulate
- * @type: The type of program to be exectuted
+ * @type: The type of program to be executed
  *
  * socket is passed is expected to be of type INET or INET6.
  *
@@ -1119,7 +1119,7 @@ EXPORT_SYMBOL(__cgroup_bpf_run_filter_sk);
  *                                       provided by user sockaddr
  * @sk: sock struct that will use sockaddr
  * @uaddr: sockaddr struct provided by user
- * @type: The type of program to be exectuted
+ * @type: The type of program to be executed
  * @t_ctx: Pointer to attach type specific context
  * @flags: Pointer to u32 which contains higher bits of BPF program
  *         return value (OR'ed together).
@@ -1166,7 +1166,7 @@ EXPORT_SYMBOL(__cgroup_bpf_run_filter_sock_addr);
  * @sock_ops: bpf_sock_ops_kern struct to pass to program. Contains
  * sk with connection information (IP addresses, etc.) May not contain
  * cgroup info if it is a req sock.
- * @type: The type of program to be exectuted
+ * @type: The type of program to be executed
  *
  * socket passed is expected to be of type INET or INET6.
  *
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index d29af9988f37..65877967f414 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1636,7 +1636,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 		value_size = size * num_possible_cpus();
 	total = 0;
 	/* while experimenting with hash tables with sizes ranging from 10 to
-	 * 1000, it was observed that a bucket can have upto 5 entries.
+	 * 1000, it was observed that a bucket can have up to 5 entries.
 	 */
 	bucket_size = 5;
 
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 49817755b8c3..ae64110a98b5 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1093,7 +1093,7 @@ struct bpf_hrtimer {
 struct bpf_timer_kern {
 	struct bpf_hrtimer *timer;
 	/* bpf_spin_lock is used here instead of spinlock_t to make
-	 * sure that it always fits into space resereved by struct bpf_timer
+	 * sure that it always fits into space reserved by struct bpf_timer
 	 * regardless of LOCKDEP and spinlock debug flags.
 	 */
 	struct bpf_spin_lock lock;
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 23f7f9d08a62..497916060ac7 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -1,4 +1,4 @@
-//SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/bpf-cgroup.h>
 #include <linux/bpf.h>
 #include <linux/bpf_local_storage.h>
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 556a769b5b80..962556917c4d 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -143,7 +143,7 @@ static void reuseport_array_free(struct bpf_map *map)
 
 	/*
 	 * Once reaching here, all sk->sk_user_data is not
-	 * referenceing this "array".  "array" can be freed now.
+	 * referencing this "array".  "array" can be freed now.
 	 */
 	bpf_map_area_free(array);
 }
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 35646db3d950..ce4657a00dae 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2562,7 +2562,7 @@ static int bpf_link_alloc_id(struct bpf_link *link)
  * pre-allocated resources are to be freed with bpf_cleanup() call. All the
  * transient state is passed around in struct bpf_link_primer.
  * This is preferred way to create and initialize bpf_link, especially when
- * there are complicated and expensive operations inbetween creating bpf_link
+ * there are complicated and expensive operations in between creating bpf_link
  * itself and attaching it to BPF hook. By using bpf_link_prime() and
  * bpf_link_settle() kernel code using bpf_link doesn't have to perform
  * expensive (and potentially failing) roll back operations in a rare case
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 7224691df2ec..0b41fa993825 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -45,7 +45,7 @@ void *bpf_jit_alloc_exec_page(void)
 
 	set_vm_flush_reset_perms(image);
 	/* Keep image as writeable. The alternative is to keep flipping ro/rw
-	 * everytime new program is attached or detached.
+	 * every time new program is attached or detached.
 	 */
 	set_memory_x((long)image, 1);
 	return image;
-- 
2.26.3

