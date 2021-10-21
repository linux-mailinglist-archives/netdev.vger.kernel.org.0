Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4515436AB8
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 20:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbhJUSmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 14:42:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30941 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231933AbhJUSmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 14:42:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634841637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qVE0Ytn7Y2ouLBpfQvkdhLaASgDe1lZJIOjynHvZyQY=;
        b=DzIfw9GxSMIn4qWswjJROHnKGG4OT29sLKvhy5uPZEPQ8+th34nfVIIPks1ETuXbyGBjIJ
        9ytW3zfCq5ckIlYV+yBd7GNm99e4S43GRxc44ZwVItOKk2juiDzJPe8rrlrZ6xVdVlknNI
        9CvP35pAx9LoKnqBBzISojtZGUwdqns=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-68JUK795NI2olEQYPGXj1g-1; Thu, 21 Oct 2021 14:40:35 -0400
X-MC-Unique: 68JUK795NI2olEQYPGXj1g-1
Received: by mail-ed1-f69.google.com with SMTP id u10-20020a50d94a000000b003dc51565894so1234236edj.21
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 11:40:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qVE0Ytn7Y2ouLBpfQvkdhLaASgDe1lZJIOjynHvZyQY=;
        b=uN2QZrWO5k+jP1KRzz7X6Tko/139ZU5gPsRUfp0Qg8gs7ZtRCybZEanvT7mzhwdO5f
         UzM01NqrX+BoD1zBelISfb4fg2WwtHqzwTnKM/BarC7gyKmtWO7X/TslR4CU/+10UWXS
         QDDYi5kzgcl2YleUNB5WjhlfFybIT4LHAHmq6f5a3jbBmuzoBBhD+IzIF1+Q+YyoZhX6
         dCnSOlRyNaXYiviw46cGIHriNsuPFAIJmdsDiWEj0ELn5l2srCvd4vq+nriH7BxGvASQ
         BYDLRo5lBqcRTi25FkJrAs1sv6QtlyfdesWQCRaf7Z36sa5I0Eia1CtXyDKhBmw16yFl
         vvnw==
X-Gm-Message-State: AOAM530zKyp22pqMw9skEYS4IymfWYaQi1MEJzXru0D8hZVWov9QRm9N
        IWueIO1aJPTXkIDUfDDUT4PlBm4ycsfsX5YWpNFuhheJzYpLkwu6yzuqMii24ur2DaUev6bUFvT
        MVSERhYsL+8ughaBT
X-Received: by 2002:a05:6402:5207:: with SMTP id s7mr9865147edd.260.1634841633590;
        Thu, 21 Oct 2021 11:40:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyU5R5Ydtj9Ba9txK2TumatLu6oHxWMWahoCyS67aGP/SR1yPiNl74m2wOHqEaT0esGLeIF3g==
X-Received: by 2002:a05:6402:5207:: with SMTP id s7mr9865019edd.260.1634841632536;
        Thu, 21 Oct 2021 11:40:32 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o10sm3229360edj.79.2021.10.21.11.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 11:40:31 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 37902180262; Thu, 21 Oct 2021 20:40:31 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH bpf] bpf: fix potential race in tail call compatibility check
Date:   Thu, 21 Oct 2021 20:39:51 +0200
Message-Id: <20211021183951.169905-1-toke@redhat.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo noticed that the code testing for program type compatibility of
tail call maps is potentially racy in that two threads could encounter a
map with an unset type simultaneously and both return true even though they
are inserting incompatible programs.

The race window is quite small, but artificially enlarging it by adding a
usleep_range() inside the check in bpf_prog_array_compatible() makes it
trivial to trigger from userspace with a program that does, essentially:

        map_fd = bpf_create_map(BPF_MAP_TYPE_PROG_ARRAY, 4, 4, 2, 0);
        pid = fork();
        if (pid) {
                key = 0;
                value = xdp_fd;
        } else {
                key = 1;
                value = tc_fd;
        }
        err = bpf_map_update_elem(map_fd, &key, &value, 0);

While the race window is small, it has potentially serious ramifications in
that triggering it would allow a BPF program to tail call to a program of a
different type. So let's get rid of it by changing to an atomic update of
the array map aux->type. To do this, move the aux->jited boolean to be
encoded in the top-most bit of the aux->type field, so we can cmpxchg() the
whole thing in one go. The commit in the Fixes tag is the last commit that
touches the code in question.

Fixes: 3324b584b6f6 ("ebpf: misc core cleanup")
Reported-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
We noticed this while reworking the code in question to also deal with XDP
multi-buffer compatibility. We figured we'd send this fix separately, but
we'd like to base some code on it in bpf-next. What's the right procedure
here, should we wait until bpf gets merged into bpf-next, or can we include
this patch in the multibuf series as well?

-Toke

 include/linux/bpf.h  |  9 +++++++--
 kernel/bpf/core.c    | 23 ++++++++++++++++-------
 kernel/bpf/syscall.c |  4 ++--
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 020a7d5bf470..48cc42063a86 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -923,14 +923,19 @@ struct bpf_prog_aux {
 	};
 };
 
+#define BPF_MAP_JITED_FLAG (1 << 31)
+
 struct bpf_array_aux {
 	/* 'Ownership' of prog array is claimed by the first program that
 	 * is going to use this map or by the first program which FD is
 	 * stored in the map to make sure that all callers and callees have
 	 * the same prog type and JITed flag.
+	 *
+	 * We store the type as a u32 and encode the jited state in the
+	 * most-significant bit (BPF_MAP_JITED_FLAG). This allows setting the
+	 * type atomically without locking.
 	 */
-	enum bpf_prog_type type;
-	bool jited;
+	u32 type;
 	/* Programs with direct jumps into programs part of this array. */
 	struct list_head poke_progs;
 	struct bpf_map *map;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c1e7eb3f1876..2811e7723886 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1823,20 +1823,29 @@ static unsigned int __bpf_prog_ret0_warn(const void *ctx,
 bool bpf_prog_array_compatible(struct bpf_array *array,
 			       const struct bpf_prog *fp)
 {
+	u32 map_type, prog_type = fp->type;
+
 	if (fp->kprobe_override)
 		return false;
 
-	if (!array->aux->type) {
-		/* There's no owner yet where we could check for
-		 * compatibility.
+	/* Encode the jited status in the top-most bit of the aux->type field so
+	 * we have a single value we can atomically swap in below
+	 */
+	if (fp->jited)
+		prog_type |= BPF_MAP_JITED_FLAG;
+
+	map_type = READ_ONCE(array->aux->type);
+	if (!map_type) {
+		/* There's no owner yet where we could check for compatibility.
+		 * Do an atomic swap to prevent racing with another invocation
+		 * of this branch (via simultaneous map_update syscalls).
 		 */
-		array->aux->type  = fp->type;
-		array->aux->jited = fp->jited;
+		if (cmpxchg(&array->aux->type, 0, prog_type))
+			return false;
 		return true;
 	}
 
-	return array->aux->type  == fp->type &&
-	       array->aux->jited == fp->jited;
+	return map_type == prog_type;
 }
 
 static int bpf_check_tail_call(const struct bpf_prog *fp)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e50c0bfdb7d..45485ebdfb2b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -543,8 +543,8 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
 
 	if (map->map_type == BPF_MAP_TYPE_PROG_ARRAY) {
 		array = container_of(map, struct bpf_array, map);
-		type  = array->aux->type;
-		jited = array->aux->jited;
+		type  = array->aux->type & ~BPF_MAP_JITED_FLAG;
+		jited = !!(array->aux->type & BPF_MAP_JITED_FLAG);
 	}
 
 	seq_printf(m,
-- 
2.33.0

