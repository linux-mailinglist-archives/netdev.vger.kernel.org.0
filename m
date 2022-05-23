Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD89531DC5
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 23:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiEWVaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 17:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbiEWV2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 17:28:17 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818FAA2056
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 14:28:16 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id v9so14679943oie.5
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 14:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LZD/Zppu+JV4corcLquFb+tJaC7Y9GLTkq/38/brrSc=;
        b=iZgYT+c5BVBpgsBQojxO1uEkOvetRImr9YQwwlimnqF43B53R3q4SxlOZUXAtOV3Pn
         BHwv3wW8FmtlD2Wndm0AGXrw5MMb+awWvf/PvsYx+56x/p3CZUfBABYJbiIc+cRO/LHE
         MyiPApQQsEjLIUT7PUdeE8s8raT4FE+L4vw8AW+L0iXOUN5ot1U6K267KN8QXfyETDAx
         Zt2q1sluLeChulHZHvJQzEwz0NDNBn4DjkuZtJceiryK3NG9iygpyvbbiKP/ijtbXitp
         mH29eWYrA26O4uC2pbOl7KNCbYW1umKr+dI1m2y7b73AtYOZeKt9F6j3LAcZqDEG94Nt
         jGhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LZD/Zppu+JV4corcLquFb+tJaC7Y9GLTkq/38/brrSc=;
        b=Rx6r92HXmNj6Kw/LhBwNcBKFBNireddJZ4uTIaiCB75pAv68ZAwNTPt4W6cOdTOq11
         Za7HaJWlitDveWTMtaehvTuGUN+5oE8/CNjUfljG5Wu21q29ECM+AJx/IvK8mDX/DRG5
         LoIqE0VHM4K6gHZbTyvVjruZFiNcCcH4ewjse5zkImiXDR+4+W8ePEwbExaIpY8yRe5w
         ekkURtrJsfOKFN2H8PM71Tp16prqXQERXSDpxExjqXxMVhwVbT7r/I/Jjz0XBs7SBxIk
         TXyuJJNXwXV4p4aTAKmTNxjLg0ODe9ABRlMsQDFVDL/JUhcrVyaxj6G1933L49JFlVK5
         D4ug==
X-Gm-Message-State: AOAM533i3ZtCgnWRHrJh+5qO2qc7Eufs1wY3bh7JtE6frEaRGDm2cgxO
        suEO2MZ8xmDCZW0wwxfVim/6yZMwjcQb/A==
X-Google-Smtp-Source: ABdhPJxdbYpNotodQL2bHtqTswSrQDWZO8uC9pio8AkGMlFCNEsqfHD9V3mItvnwn4tVwaUPm6+5cQ==
X-Received: by 2002:a17:90b:4b50:b0:1df:7b60:f0b3 with SMTP id mi16-20020a17090b4b5000b001df7b60f0b3mr956373pjb.237.1653341285148;
        Mon, 23 May 2022 14:28:05 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902edc700b0016168e90f37sm5587413plk.152.2022.05.23.14.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 14:28:04 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     Tejun Heo <tj@kernel.org>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
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
Subject: [PATCH v2] cgroups: separate destroy_work into two separate wq
Date:   Mon, 23 May 2022 14:27:24 -0700
Message-Id: <20220523212724.233314-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220412192459.227740-1-tadeusz.struk@linaro.org>
References: <20220412192459.227740-1-tadeusz.struk@linaro.org>
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
cgroup css_create(). The reproduces writes to cgroup.subtree_control
file, which invokes cgroup_apply_control_enable(), css_create(), and
css_populate_dir(), which then randomly fails with a fault injected -ENOMEM.
In such scenario the css_create() error path rcu enqueues css_free_rwork_fn
work for an css->refcnt initialized with css_release() destructor,
and there is a chance that the css_release() function will be invoked
for a cgroup_subsys_state, for which a destroy_work has already been
queued via css_create() error path. This causes a list_add corruption
as can be seen in the syzkaller report [1].
This can be fixed by separating the css_release and ref_kill paths
to work with two separate work_structs.

[1] https://syzkaller.appspot.com/bug?id=e26e54d6eac9d9fb50b221ec3e4627b327465dbd

Cc: Tejun Heo <tj@kernel.org>
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
v2: Add a separate work_struct for the css_ref_kill path instead of
    checking if a work has already been enqueued.
---
 include/linux/cgroup-defs.h |  5 +++--
 kernel/cgroup/cgroup.c      | 14 +++++++-------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 1bfcfb1af352..92b0c5e8c472 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -178,8 +178,9 @@ struct cgroup_subsys_state {
 	 */
 	atomic_t online_cnt;
 
-	/* percpu_ref killing and RCU release */
-	struct work_struct destroy_work;
+	/* percpu_ref killing, css release, and RCU release work structs */
+	struct work_struct release_work;
+	struct work_struct killed_ref_work;
 	struct rcu_work destroy_rwork;
 
 	/*
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index adb820e98f24..3e00a793e15d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5099,7 +5099,7 @@ static struct cftype cgroup_base_files[] = {
  *    css_free_work_fn().
  *
  * It is actually hairier because both step 2 and 4 require process context
- * and thus involve punting to css->destroy_work adding two additional
+ * and thus involve punting to css->release_work adding two additional
  * steps to the already complex sequence.
  */
 static void css_free_rwork_fn(struct work_struct *work)
@@ -5154,7 +5154,7 @@ static void css_free_rwork_fn(struct work_struct *work)
 static void css_release_work_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
-		container_of(work, struct cgroup_subsys_state, destroy_work);
+		container_of(work, struct cgroup_subsys_state, release_work);
 	struct cgroup_subsys *ss = css->ss;
 	struct cgroup *cgrp = css->cgroup;
 
@@ -5210,8 +5210,8 @@ static void css_release(struct percpu_ref *ref)
 	struct cgroup_subsys_state *css =
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
-	INIT_WORK(&css->destroy_work, css_release_work_fn);
-	queue_work(cgroup_destroy_wq, &css->destroy_work);
+	INIT_WORK(&css->release_work, css_release_work_fn);
+	queue_work(cgroup_destroy_wq, &css->release_work);
 }
 
 static void init_and_link_css(struct cgroup_subsys_state *css,
@@ -5546,7 +5546,7 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
 static void css_killed_work_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
-		container_of(work, struct cgroup_subsys_state, destroy_work);
+		container_of(work, struct cgroup_subsys_state, killed_ref_work);
 
 	mutex_lock(&cgroup_mutex);
 
@@ -5567,8 +5567,8 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
 	if (atomic_dec_and_test(&css->online_cnt)) {
-		INIT_WORK(&css->destroy_work, css_killed_work_fn);
-		queue_work(cgroup_destroy_wq, &css->destroy_work);
+		INIT_WORK(&css->killed_ref_work, css_killed_work_fn);
+		queue_work(cgroup_destroy_wq, &css->killed_ref_work);
 	}
 }
 
-- 
2.36.1
