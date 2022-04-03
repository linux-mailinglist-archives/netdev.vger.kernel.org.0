Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731884F0A0E
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237623AbiDCOAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 10:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbiDCOAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 10:00:00 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC50366BB;
        Sun,  3 Apr 2022 06:58:07 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id x14so3160784pjf.2;
        Sun, 03 Apr 2022 06:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J5mbcZTsiDy3mrNkZULEao/0esdA8VeRyfo3ZqOjIFQ=;
        b=GVcAdkoyMokXfTR2LLDHuHD1vCyTv/CL4Mr0zcmD71hYcQLNx4trRtToCqpmglZ6p2
         PfyrVY4bjMJXXryJlFSZQ/inrpyn7w0puiD1GGEY/XC92cwwNU1SxUYrW9IZcp7i+jIG
         rr5TENhHGiX+LNgYDXHa6AVCI/VsyUXghylGxj7jMkpLT2FqRqavlgYBDmPuRHB89kl8
         LftNF2g36cg6yha8KtSQVaDjIdftf5xi+Cxgar9wFbNJrCDeMY8KnnM9bq3P4Ey3m9Nh
         /DgblGo29ZvOgCxzDuGnjFXgYqF5WmFRf1nyTgxTlrFEjhoJR6cvszzuclZGerOi/1Vw
         FlQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J5mbcZTsiDy3mrNkZULEao/0esdA8VeRyfo3ZqOjIFQ=;
        b=0IkI+0ar28nCn5CxBcm/ptSk5yQnF9T60D2D/kXQ4uHXa75hDnC5u3ZlPTIiVQkK9D
         pVyTFQkeiqw9npq84sTty+1FAE7SeOSGj5qDU0nuKyZ49Lh68JLeFqZd5xQWcQ6m+okN
         cAROWkGtEiT0iMt93o2ybq8C2Y3NXfsUAD+rXLzJJzPihH9bjyPICELLwjp4xszd4Eck
         E9eG4WcDmZ63pBp3ExXtWfT3dQHxTvx7bvqvBfH8gLlj65R5D/yDFQ5y7GzdFKKH1bsN
         tEFD9e8ctoG7E8lJ6F3jR6cX9wyZrVnKM4qefONMVUPA/lGVh5JKwxXgHVgnqGYnQtKs
         +48A==
X-Gm-Message-State: AOAM532PM5xX8J/cu1frS74CE/xDxCYduwDcm8IgAfOBN7/H0ACXylBc
        xdTvfZTW2V8qhCE5tDJrQ2DoAU7IOyi0VA==
X-Google-Smtp-Source: ABdhPJxsYMJ1kd5jIPYZmDRQk0lc+8cUe2U8iJtJpbX8SKgWG1rYaUEfmU/2/0CM6VmLyS0ME+dgHQ==
X-Received: by 2002:a17:902:ce0a:b0:156:72e2:f191 with SMTP id k10-20020a170902ce0a00b0015672e2f191mr7726674plg.76.1648994286114;
        Sun, 03 Apr 2022 06:58:06 -0700 (PDT)
Received: from localhost.localdomain ([113.173.105.8])
        by smtp.googlemail.com with ESMTPSA id v13-20020a17090a088d00b001c64d30fa8bsm17110441pjc.1.2022.04.03.06.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:58:05 -0700 (PDT)
From:   Bui Quang Minh <minhquangbui99@gmail.com>
To:     cgroups@vger.kernel.org
Cc:     Bui Quang Minh <minhquangbui99@gmail.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] cgroup: Kill the parent controller when its last child is killed
Date:   Sun,  3 Apr 2022 20:57:17 +0700
Message-Id: <20220403135717.8294-1-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When umounting a cgroup controller, in case the controller has no children,
the initial ref will be dropped in cgroup_kill_sb. In cgroup_rmdir path,
the controller is deleted from the parent's children list in
css_release_work_fn, which is run on a kernel worker.

With this simple script

	#!/bin/sh

	mount -t cgroup -o none,name=test test ./tmp
	mkdir -p ./tmp/abc

	rmdir ./tmp/abc
	umount ./tmp

	sleep 5
	cat /proc/self/cgroup

The rmdir will remove the last child and umount is expected to kill the
parent controller. However, when running the above script, we may get

	1:name=test:/

This shows that the parent controller has not been killed. The reason is
after rmdir is completed, it is not guaranteed that the parent's children
list is empty as css_release_work_fn is deferred to run on a worker. In
case cgroup_kill_sb is run before that work, it does not drop the initial
ref. Later in the worker, it just removes the child from the list without
checking the list is empty to kill the parent controller. As a result, the
parent controller still has the initial ref but without any logical refs
(children ref, mount ref).

This commit adds a free parent controller path into the worker function to
free up the parent controller when the last child is killed.

Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
---
 kernel/cgroup/cgroup.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a557eea7166f..220eb1742961 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5157,12 +5157,25 @@ static void css_release_work_fn(struct work_struct *work)
 		container_of(work, struct cgroup_subsys_state, destroy_work);
 	struct cgroup_subsys *ss = css->ss;
 	struct cgroup *cgrp = css->cgroup;
+	struct cgroup *parent = cgroup_parent(cgrp);
 
 	mutex_lock(&cgroup_mutex);
 
 	css->flags |= CSS_RELEASED;
 	list_del_rcu(&css->sibling);
 
+	/*
+	 * If parent doesn't have any children, start killing it.
+	 * And don't kill the default root.
+	 */
+	if (parent && list_empty(&parent->self.children) &&
+	    parent != &cgrp_dfl_root.cgrp &&
+	    !percpu_ref_is_dying(&parent->self.refcnt)) {
+		if (!percpu_ref_is_dying(&cgrp->bpf.refcnt))
+			cgroup_bpf_offline(parent);
+		percpu_ref_kill(&parent->self.refcnt);
+	}
+
 	if (ss) {
 		/* css release path */
 		if (!list_empty(&css->rstat_css_node)) {
-- 
2.25.1

