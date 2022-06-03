Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D45C53CE23
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 19:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344529AbiFCRfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 13:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344511AbiFCRfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 13:35:18 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610C252E57
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 10:35:16 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id e24so7887036pjt.0
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 10:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wsGkporiWQeNHg4v1skX8MmfnPHmZ0ni6U0Bq1ri7HA=;
        b=a1sktZ6PwTtJdZaiQGYWK4MxHPhEr3vs5B0FyLaZOmVggg3/BzW2lFLLjb4vdmZ2CM
         5tdYsRV4Tl1/efkLpIahk9F3SmrQ5a9wS/pdsPXgydC6nU6Aq+3QE1TAZjfLTiGszZJP
         wWHnm8d+dE53knPFb08NqEB0r1WGlH+WTqimSxLxIUH9Co088ymYV3G03+rGClHdUdLD
         1VUHbZUkzEzNAdMDaY7zwRX0M1bCniqdHONnnQn3TCRwa/eTtQrTEPFkfZZ3Vb+9u42t
         Jnt6wzCrwFif404LEePDQmE5XXMq3Ly9WbIA1zCToHxYzdXKwCXsPqlzpQPM+YkmOoWQ
         fAEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wsGkporiWQeNHg4v1skX8MmfnPHmZ0ni6U0Bq1ri7HA=;
        b=CVIg49w6zpNTQYFUKaCGirsh3ANhGbK9x/ZI60YYMpcuLvmkwHG63xPx5kc7I4BuGT
         va/IHHfxMgke1r1BNyvf8O9Pgh47Ww3LRueO1s2+tk6MuMG34hksV0wwfDLmLZNddPnl
         GY26qsI6OZlIc8eBkMYC66YC/bNTVEYH1Pa/M1b60l/xxFoH+rSkxSCeDYxekAaFIpPb
         OMXRUDlRlo8ZqvaQcXggBFQQZrjQaLLA362qzCH3nJihf6Dj3KbvXuIlYbfVSXQEi5VV
         4vxnc/bjp78t8C4+tNzRXYE3fgawbuNuHQJrtz9DDRc29gDoLC4HpVdv+GmPcbWdi7ep
         z7LA==
X-Gm-Message-State: AOAM5335epLUh4zSWLJN1+FLQJfxjL65RHopxnsYd/mZNwrwX15qXRwj
        QjVF633/8FDGJ0fPeSHu5ebI0zIDijB4F7iu
X-Google-Smtp-Source: ABdhPJx88jfqJGvlh85IKtdIkpIo1pu4gJb5NXPiJ/0S9jrCIk/XxyxIGjdKNFq7q+cF1hUVJ66yCQ==
X-Received: by 2002:a17:902:d2d1:b0:167:4c33:d5d3 with SMTP id n17-20020a170902d2d100b001674c33d5d3mr3799752plc.81.1654277715866;
        Fri, 03 Jun 2022 10:35:15 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id x17-20020a056a000bd100b0051be1b4cfb5sm1730265pfu.5.2022.06.03.10.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 10:35:15 -0700 (PDT)
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
Subject: [PATCH] cgroup: serialize css kill and release paths
Date:   Fri,  3 Jun 2022 10:34:55 -0700
Message-Id: <20220603173455.441537-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.36.1
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
set the CSS_REL_LATER flag for that css. This will cause the css_release_work_fn()
work to be executed after css_killed_work_fn() is finished.

Two scc flags have been introduced to implement this serialization mechanizm:

 * CSS_KILL_ENQED, which will be set when css_killed_work_fn() is en-queued, and
 * CSS_REL_LATER, which, if set, will cause the css_release_work_fn() to be
   scheduled after the css_killed_work_fn is finished.

There is also a new lock, which will protect the integrity of the css flags.

[1] https://syzkaller.appspot.com/bug?id=e26e54d6eac9d9fb50b221ec3e4627b327465dbd

Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
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
index 1779ccddb734..a0ceead4b390 100644
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
 
+	spin_lock_bh(&css->lock);
+	if (css_killed->flags & CSS_REL_LATER) {
+		/* If css_release work was delayed for the css enqueue it now. */
+		INIT_WORK(&css_killed->destroy_work, css_release_work_fn);
+		queue_work(cgroup_destroy_wq, &css_killed->destroy_work);
+		css_killed->flags &= ~CSS_REL_LATER;
+	}
+	spin_unlock_bh(&css->lock);
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
