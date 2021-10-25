Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F85439736
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhJYNK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:10:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233412AbhJYNK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 09:10:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635167314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QxJG4ClCwysLwMBZ0+vM6Qh/czcxiPTdVQDytoS0Hdk=;
        b=FSfaWT/JtILkead1QxN2ZZS0s2zUqiXw2sFiiU6l+52W+/2Ad93oAKshJj/8dB21+yuN8v
        H5clEQd0lC2vXmAfKy2+1+lRQiH8Mp3u97x6atxO9gl8Ku5MRzPbi66X+eFUSn4mvJ6h4u
        1P47gJ0ieXQB9znfp698VIvxYfqwG48=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-bPV9ODj2M9ehD6mCWYF9Ow-1; Mon, 25 Oct 2021 09:08:25 -0400
X-MC-Unique: bPV9ODj2M9ehD6mCWYF9Ow-1
Received: by mail-ed1-f72.google.com with SMTP id m16-20020a056402431000b003dd2005af01so8181852edc.5
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 06:08:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QxJG4ClCwysLwMBZ0+vM6Qh/czcxiPTdVQDytoS0Hdk=;
        b=uePf9Cydx8daMKcUKTP0ut2/Rg38C8NgiJ5b9Tu5tSS0J5ATA77Jh/74mrQZGDpxtg
         FAdP+dE92w87SaHwzQ4sOZ/vQ7hy/3WjHbuHbJEdXkvvLKvh4yogKHuGrGu/UR6OIHga
         GiHiGZHkmkfKB0zOnpeuGrWhE11t92scj36THRCBm8IP2U2AXY5i/Yj1EKmeshXcqrkB
         3uLKzsVMKeF3p0FsBKRDhpfI8AbjhCaVOzwLfDzyHPl/oG3il8RPxOsOJducwdzMFXZs
         /2xw5hlW2wJ8TrnZFvr4zQUonmd7SIPIM4PAUvH7G/Q4ZA/nvldi5f+2h+Rho70ecNLD
         HvhQ==
X-Gm-Message-State: AOAM530xSn53nuHAyJn9uE3R6mgX/asa/duBiVlr1dvVpZOLPVZRUnLZ
        BgBTnAvUQfeTDEkqcwqo1Yt5zEPNbclya7Ywzhgdid/xQ3Jx4ExD1W1Vtsju2ROJJfYNhMgoR5e
        DL1RwferN9rebzqS/
X-Received: by 2002:a05:6402:11d1:: with SMTP id j17mr4812591edw.139.1635167304362;
        Mon, 25 Oct 2021 06:08:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBdByXnC92Gd5IMtq7QJaG68HvprP7ci0Jxti+XWvUIDZE4vUAsErjPF6qKzXSOq3yrqMSrg==
X-Received: by 2002:a05:6402:11d1:: with SMTP id j17mr4812542edw.139.1635167303931;
        Mon, 25 Oct 2021 06:08:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s16sm9443327edd.32.2021.10.25.06.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 06:08:23 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1FFCA180262; Mon, 25 Oct 2021 15:08:21 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH bpf v2] bpf: fix potential race in tail call compatibility check
Date:   Mon, 25 Oct 2021 15:08:09 +0200
Message-Id: <20211025130809.314707-1-toke@redhat.com>
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
different type. So let's get rid of it by protecting the update with a
spinlock. The commit in the Fixes tag is the last commit that touches the
code in question.

v2:
- Use a spinlock instead of an atomic variable and cmpxchg() (Alexei)

Fixes: 3324b584b6f6 ("ebpf: misc core cleanup")
Reported-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h   |  1 +
 kernel/bpf/arraymap.c |  1 +
 kernel/bpf/core.c     | 14 ++++++++++----
 kernel/bpf/syscall.c  |  2 ++
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 020a7d5bf470..98d906176d89 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -929,6 +929,7 @@ struct bpf_array_aux {
 	 * stored in the map to make sure that all callers and callees have
 	 * the same prog type and JITed flag.
 	 */
+	spinlock_t type_check_lock;
 	enum bpf_prog_type type;
 	bool jited;
 	/* Programs with direct jumps into programs part of this array. */
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index cebd4fb06d19..da9b1e96cadc 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -1072,6 +1072,7 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
 	INIT_WORK(&aux->work, prog_array_map_clear_deferred);
 	INIT_LIST_HEAD(&aux->poke_progs);
 	mutex_init(&aux->poke_mutex);
+	spin_lock_init(&aux->type_check_lock);
 
 	map = array_map_alloc(attr);
 	if (IS_ERR(map)) {
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c1e7eb3f1876..9439c839d279 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1823,20 +1823,26 @@ static unsigned int __bpf_prog_ret0_warn(const void *ctx,
 bool bpf_prog_array_compatible(struct bpf_array *array,
 			       const struct bpf_prog *fp)
 {
+	bool ret;
+
 	if (fp->kprobe_override)
 		return false;
 
+	spin_lock(&array->aux->type_check_lock);
+
 	if (!array->aux->type) {
 		/* There's no owner yet where we could check for
 		 * compatibility.
 		 */
 		array->aux->type  = fp->type;
 		array->aux->jited = fp->jited;
-		return true;
+		ret = true;
+	} else {
+		ret = array->aux->type  == fp->type &&
+		      array->aux->jited == fp->jited;
 	}
-
-	return array->aux->type  == fp->type &&
-	       array->aux->jited == fp->jited;
+	spin_unlock(&array->aux->type_check_lock);
+	return ret;
 }
 
 static int bpf_check_tail_call(const struct bpf_prog *fp)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e50c0bfdb7d..955011c7df29 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -543,8 +543,10 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
 
 	if (map->map_type == BPF_MAP_TYPE_PROG_ARRAY) {
 		array = container_of(map, struct bpf_array, map);
+		spin_lock(&array->aux->type_check_lock);
 		type  = array->aux->type;
 		jited = array->aux->jited;
+		spin_unlock(&array->aux->type_check_lock);
 	}
 
 	seq_printf(m,
-- 
2.33.0

