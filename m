Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD2853D171
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347046AbiFCSay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 14:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347804AbiFCSaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 14:30:02 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F8A72220
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 11:13:42 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id j6so7698228pfe.13
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 11:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KMzrP1ZYW7q/TidHk4y7Aa/yx0iJcaya5gROyIWR4BM=;
        b=SIwXH7tnxO54DrmpfWx37Dnzpuo94VKI4hgsLJaP4UwHqx2y2++HlfNfMVE+I2W/OA
         DUcWVfaaS3FYE/N/cVWCzSVDG8dVCzDAgWFJIbqQ1j0VPI0piNoE9hSLj778PbA3UH6C
         6gtRw0QFXRiEqGe1/XrP/ujAJQzyzpXfBnKUpojGztmXaIiEngCdDgiBWLk1xXxzdr0M
         MMJ9NQpVcTv2f2MR5gCqrUzYHtZFH+Vrg6QFG9WvpHcbvevt8i8fho6MC5p+/6paQMc9
         68coNPXUYF9IIDxSI8QlwNpmBrzAhtXGPCCfPUMjDEoKMo5g16cE/n016vt6Pe0PiiJu
         +nrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KMzrP1ZYW7q/TidHk4y7Aa/yx0iJcaya5gROyIWR4BM=;
        b=Z7kooouR+zLSNlAXJ/wKEc3WhN17MQe8ZYcWJ4p3g5L85GMpRv0MRQmpXbrLxqA7aP
         JmHSVLLL3alAZEwetLi/cUJwGtEFeZBZZ4QQy9FvlbiGQ4X/nVGjXQG0xxtSl4BXMBtK
         /9yx0l0Dv1yFPHQwY+GBl9avGxrlXv3/1DOOAimGTwaAfSAKs4i0SkLtCb3xVsDWrZa6
         vzRly1oL12sCvCq/VR45C9zHKsd5SKbNve0SWYsBT0FUw4Rc6lXAYNidZQzPZsIJFlhH
         0LxoauaPNQVRBeTziowHXPSG+yWdq8qb9I0e0MzeyZ+yOCZRAOwW1vcIPaIIpeFSq2+a
         gyWg==
X-Gm-Message-State: AOAM531dCaLuHiS8dUDXguzSDcG7w7CblSyg8U1t8bv/fjEfszfVwGdv
        Uy7tqmLi0JjAiX1sNPvgF9n4OQ==
X-Google-Smtp-Source: ABdhPJx6Fhx/k/G6F3rQ2T+mGOIPbpXrjtVEn/vidFgj5AVDqH7jNxEZNkDQfzwCOOGN+vAN2KhRAQ==
X-Received: by 2002:a05:6a00:2396:b0:51b:de97:7efe with SMTP id f22-20020a056a00239600b0051bde977efemr5437281pfc.8.1654280014264;
        Fri, 03 Jun 2022 11:13:34 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id e8-20020a170902784800b001640ab19773sm5853198pln.58.2022.06.03.11.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:13:33 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     Tejun Heo <tj@kernel.org>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Michal Koutny <mkoutny@suse.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christian Brauner <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com
Subject: [PATCH v2] cgroup: serialize css kill and release paths
Date:   Fri,  3 Jun 2022 11:13:21 -0700
Message-Id: <20220603181321.443716-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173455.441537-1-tadeusz.struk@linaro.org>
References: <20220603173455.441537-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot found a corrupted list bug scenario that can be triggered from
cgroup_subtree_control_write(cgrp). The reproduces writes to
cgroup.subtree_control file, which invokes:
cgroup_apply_control_enable()->css_create()->css_populate_dir(), which
then fails with a fault injected -ENOMEM.
In such scenario the css_killed_work_fn will be en-queued via
cgroup_apply_control_disable(cgrp)->kill_css(css), and bail out to
cgroup_kn_unlock(). Then cgroup_kn_unlock() will call:
cgroup_put(cgrp)->css_put(&cgrp->self), which will try to enqueue
css_release_work_fn for the same css instance, causing a list_add
corruption bug, as can be seen in the syzkaller report [1].

Fix this by synchronizing the css ref_kill and css_release jobs.
css_release() function will check if the css_killed_work_fn() has been
scheduled for the css and only en-queue the css_release_work_fn()
if css_killed_work_fn wasn't already en-queued. Otherwise css_release() will
set the CSS_REL_LATER flag for that css. This will cause the
css_release_work_fn() work to be executed after css_killed_work_fn() is finished.

Two scc flags have been introduced to implement this serialization mechanizm:

 * CSS_KILL_ENQED, which will be set when css_killed_work_fn() is en-queued, and
 * CSS_REL_LATER, which, if set, will cause the css_release_work_fn() to be
   scheduled after the css_killed_work_fn is finished.

There is also a new lock, which will protect the integrity of the css flags.

[1] https://syzkaller.appspot.com/bug?id=e26e54d6eac9d9fb50b221ec3e4627b327465dbd

Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Koutny<mkoutny@suse.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: <cgroups@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Cc: <bpf@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

Reported-and-tested-by: syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com
Fixes: 8f36aaec9c92 ("cgroup: Use rcu_work instead of explicit rcu and work item")
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
v2: Use correct lock in css_killed_work_fn()
---
 include/linux/cgroup-defs.h |  4 ++++
 kernel/cgroup/cgroup.c      | 35 ++++++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 1bfcfb1af352..8dc8b4edb242 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -53,6 +53,8 @@ enum {
 	CSS_RELEASED	= (1 << 2), /* refcnt reached zero, released */
 	CSS_VISIBLE	= (1 << 3), /* css is visible to userland */
 	CSS_DYING	= (1 << 4), /* css is dying */
+	CSS_KILL_ENQED	= (1 << 5), /* kill work enqueued for the css */
+	CSS_REL_LATER	= (1 << 6), /* release needs to be done after kill */
 };
 
 /* bits in struct cgroup flags field */
@@ -162,6 +164,8 @@ struct cgroup_subsys_state {
 	 */
 	int id;
 
+	/* lock to protect flags */
+	spinlock_t lock;
 	unsigned int flags;
 
 	/*
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1779ccddb734..b1bbd438d426 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5210,8 +5210,23 @@ static void css_release(struct percpu_ref *ref)
 	struct cgroup_subsys_state *css =
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
-	INIT_WORK(&css->destroy_work, css_release_work_fn);
-	queue_work(cgroup_destroy_wq, &css->destroy_work);
+	spin_lock_bh(&css->lock);
+
+	/*
+	 * Check if the css_killed_work_fn work has been scheduled for this
+	 * css and enqueue css_release_work_fn only if it wasn't.
+	 * Otherwise set the CSS_REL_LATER flag, which will cause
+	 * release to be enqueued after css_killed_work_fn is finished.
+	 * This is to prevent list corruption by en-queuing two instance
+	 * of the same work struct on the same WQ, namely cgroup_destroy_wq.
+	 */
+	if (!(css->flags & CSS_KILL_ENQED)) {
+		INIT_WORK(&css->destroy_work, css_release_work_fn);
+		queue_work(cgroup_destroy_wq, &css->destroy_work);
+	} else {
+		css->flags |= CSS_REL_LATER;
+	}
+	spin_unlock_bh(&css->lock);
 }
 
 static void init_and_link_css(struct cgroup_subsys_state *css,
@@ -5230,6 +5245,7 @@ static void init_and_link_css(struct cgroup_subsys_state *css,
 	INIT_LIST_HEAD(&css->rstat_css_node);
 	css->serial_nr = css_serial_nr_next++;
 	atomic_set(&css->online_cnt, 0);
+	spin_lock_init(&css->lock);
 
 	if (cgroup_parent(cgrp)) {
 		css->parent = cgroup_css(cgroup_parent(cgrp), ss);
@@ -5545,10 +5561,12 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
  */
 static void css_killed_work_fn(struct work_struct *work)
 {
-	struct cgroup_subsys_state *css =
+	struct cgroup_subsys_state *css_killed, *css =
 		container_of(work, struct cgroup_subsys_state, destroy_work);
 
 	mutex_lock(&cgroup_mutex);
+	css_killed = css;
+	css_killed->flags &= ~CSS_KILL_ENQED;
 
 	do {
 		offline_css(css);
@@ -5557,6 +5575,14 @@ static void css_killed_work_fn(struct work_struct *work)
 		css = css->parent;
 	} while (css && atomic_dec_and_test(&css->online_cnt));
 
+	spin_lock_bh(&css_killed->lock);
+	if (css_killed->flags & CSS_REL_LATER) {
+		/* If css_release work was delayed for the css enqueue it now. */
+		INIT_WORK(&css_killed->destroy_work, css_release_work_fn);
+		queue_work(cgroup_destroy_wq, &css_killed->destroy_work);
+		css_killed->flags &= ~CSS_REL_LATER;
+	}
+	spin_unlock_bh(&css_killed->lock);
 	mutex_unlock(&cgroup_mutex);
 }
 
@@ -5566,10 +5592,13 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
 	struct cgroup_subsys_state *css =
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
+	spin_lock_bh(&css->lock);
 	if (atomic_dec_and_test(&css->online_cnt)) {
+		css->flags |= CSS_KILL_ENQED;
 		INIT_WORK(&css->destroy_work, css_killed_work_fn);
 		queue_work(cgroup_destroy_wq, &css->destroy_work);
 	}
+	spin_unlock_bh(&css->lock);
 }
 
 /**
-- 
2.36.1

