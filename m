Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C094F16EC
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 16:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377148AbiDDO14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 10:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377120AbiDDO1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 10:27:51 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597DC3A1A0;
        Mon,  4 Apr 2022 07:25:55 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id p8so9110422pfh.8;
        Mon, 04 Apr 2022 07:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vmv5bxS5EWoc91g75Vzau8g0vSoXhGCuFE3qsoGJOPg=;
        b=iLoswEs+5gduzsNqGbxzYOyUkRa1X0c3WNYv/u/uht/PCXO/BiXTGor+UATG1GTo6y
         OGELiV1powqWayUslDrEskMHNAl8PdUCe3zrYMGuEpjb0SG651wSIW5wM/UIDfb1PZgG
         2rCDyu3AADU/NXP0STTiWOZLLWHV7uRWxj+y4sOtv8PjerEPhadRF4w7GqVI3QXUtwqF
         bT+ra2vKQE0gYitrlGR5MiR6O1XfsTD3MI/2xGVGgnZj5a6qadtKTICBPaJnRhNLfB6/
         KUa4yk9AVOzRKckxcSezhAXhgEsJxuzfcI//tqd5HH0z8FsYQsPKw3YQbEIvpxmwDwOP
         JVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vmv5bxS5EWoc91g75Vzau8g0vSoXhGCuFE3qsoGJOPg=;
        b=h3kDDe+C0tfmZY9ZeOBQ1wNVWZcrh+JlZp51Lhyclbwoy42iGep3mvKQWu7wycIOdS
         i7CyrS6jDXEc+v5EesJwawznVeXrMqaGLG4GqQvxIVQxIH2YuucVGt/f+PVbDK6Xwy+z
         0aHYBVl5EDsOmfBiKKZWL1UwSMaTYge7uQKJyp5yeuH5TAuxM519uFNPihqaUTiI3utd
         X1slxyEVB6gELKer13AykGZKBpX//Uyn3KaBbt/R9hFFhSHu6M368F9vUj5DkFkVCRS2
         BuIqt8xMwhu864jFSyS7wjbgExk6wkdVTn0HTfY9DBWOSisxbJdHld4lCstrmaF5j4W7
         o1/A==
X-Gm-Message-State: AOAM532an8Oqzu+OEq71kQRIfW1fv9it8a1sxQ4eHYyMdswQEXSg0hqR
        8L31s2JAlVIEPjau0FGfcI+iENF6NSlsmOi9
X-Google-Smtp-Source: ABdhPJwafKw9Rd90yVwt4IwWyyjMnWg7+ojtxRE2EoMZ3MPJVS4w/Y1rqKQlSraUbOO5P0FoxajaCg==
X-Received: by 2002:a05:6a00:10c2:b0:4fd:a140:d5a9 with SMTP id d2-20020a056a0010c200b004fda140d5a9mr238623pfu.77.1649082354570;
        Mon, 04 Apr 2022 07:25:54 -0700 (PDT)
Received: from localhost.localdomain ([113.173.105.8])
        by smtp.googlemail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm12731625pfo.155.2022.04.04.07.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 07:25:54 -0700 (PDT)
From:   Bui Quang Minh <minhquangbui99@gmail.com>
To:     cgroups@vger.kernel.org
Cc:     Bui Quang Minh <minhquangbui99@gmail.com>,
        kernel test robot <lkp@intel.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v2] cgroup: Kill the parent controller when its last child is killed
Date:   Mon,  4 Apr 2022 21:25:34 +0700
Message-Id: <20220404142535.145975-1-minhquangbui99@gmail.com>
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

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
---
v2: Fix compilation error when CONFIG_CGROUP_BPF is not set

 kernel/cgroup/cgroup.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f01ff231a484..1916070f0d59 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5152,12 +5152,27 @@ static void css_release_work_fn(struct work_struct *work)
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
+#ifdef CONFIG_CGROUP_BPF
+		if (!percpu_ref_is_dying(&cgrp->bpf.refcnt))
+			cgroup_bpf_offline(parent);
+#endif
+		percpu_ref_kill(&parent->self.refcnt);
+	}
+
 	if (ss) {
 		/* css release path */
 		if (!list_empty(&css->rstat_css_node)) {

base-commit: 1be9b7206b7dbff54b223eee7ef3bc91b80433aa
-- 
2.25.1

