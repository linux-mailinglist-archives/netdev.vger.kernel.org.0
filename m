Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0AA5269E1
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 21:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383552AbiEMTIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 15:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383549AbiEMTIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 15:08:47 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3B056F81
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 12:08:45 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a15-20020a17090ad80f00b001dc2e23ad84so11610323pjv.4
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 12:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EzjGRanVFJwRnOyFB5bsr0UVElbIvg6LgT11yCg+N3M=;
        b=ss5GJYfHPQaNwqrKhr6tbvMUjMLuarNHrQDLGQ8pLgxAb2Nm0f5ncRzjYSI2Jug0pM
         DpqCDF798MF/A1Wwt0HR7db2DjEAZOLoxepKD7ipJeZ3tbn6RPTjFQrfzoErEAEQtVZr
         l/sIDk/ToOD+knR2vC0wKg+GaUqhEMTt8sP2QchJB9K8F/4eWK0reiVtsIpW+sXYyE4o
         K+tiniiA2zDZ16msptDnM2yo2XW3A53IHJiK0f8p+RaaT/RlS5IEoyY2tvpor8AICa0u
         HPjvwJQnx0SFw5LpdCkMmvd3UZsvyRmjwV8FuvEusT+fWljQFcSslNfdoHryonkZzZ50
         brKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EzjGRanVFJwRnOyFB5bsr0UVElbIvg6LgT11yCg+N3M=;
        b=0hjUuQCLsIppS885myMeFqASVHPdTCAEaGk1Vfi+WHEhVEHhih6qAr1PXhwWQNCHn8
         cL9FI15ijzFLRgZGFv4xRrfSbrWUdHENNRsDQ/7XgqUdgduMmXkPEsSZxuhL6m2LZVXv
         IBlAnn1C6t21EaKm8355iiPsB2aizms+nVQ2CjUp/6/xUd3RQGoT0I1HRHYLFqzPcI/P
         zB+NpqxpWp8ukGq6VoMovkej0kz4//1U4AjQPeseLxL9j2Ks7qdo7I342Y+0Bxo0iPnn
         7fEVsPEWYS7aPNWlfhJBUGIATrFKxYNUKK86sS1jX3ofSw9mQGvTsQkD6TGL7NNkpgFV
         a0Ww==
X-Gm-Message-State: AOAM530yKAhb2dqkPHMx5CLrLlzzvo64/FCsGXQKamU1yKqSa3DxkFcr
        ssj/FjVgpCKodj3zNcC9MmcrmQ==
X-Google-Smtp-Source: ABdhPJxjT/S/GGJcrjyiN98cpunUOAk8dmuGyazrbmW7Cv3+M62T06kVWsQdFGqdRn6fRzzpgRc3Wg==
X-Received: by 2002:a17:902:82c7:b0:161:4936:f068 with SMTP id u7-20020a17090282c700b001614936f068mr26519plz.145.1652468925184;
        Fri, 13 May 2022 12:08:45 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902e94500b0015e8d4eb2cfsm2148036pll.281.2022.05.13.12.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 12:08:44 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     andrii.nakryiko@gmail.com
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        "KP Singh" <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com
Subject: [PATCH v3] bpf: Fix KASAN use-after-free Read in compute_effective_progs
Date:   Fri, 13 May 2022 12:08:21 -0700
Message-Id: <20220513190821.431762-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <CAEf4Bzah9K7dEa_7sXE4TnkuMTRHypMU9DxiLezgRvLjcqE_YA@mail.gmail.com>
References: <CAEf4Bzah9K7dEa_7sXE4TnkuMTRHypMU9DxiLezgRvLjcqE_YA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot found a Use After Free bug in compute_effective_progs().
The reproducer creates a number of BPF links, and causes a fault
injected alloc to fail, while calling bpf_link_detach on them.
Link detach triggers the link to be freed by bpf_link_free(),
which calls __cgroup_bpf_detach() and update_effective_progs().
If the memory allocation in this function fails, the function restores
the pointer to the bpf_cgroup_link on the cgroup list, but the memory
gets freed just after it returns. After this, every subsequent call to
update_effective_progs() causes this already deallocated pointer to be
dereferenced in prog_list_length(), and triggers KASAN UAF error.

To fix this issue don't preserve the pointer to the prog or link in the
list, but remove it and replace it with a dummy prog without shrinking
the table. The subsequent call to __cgroup_bpf_detach() or
__cgroup_bpf_detach() will correct it.

Cc: "Alexei Starovoitov" <ast@kernel.org>
Cc: "Daniel Borkmann" <daniel@iogearbox.net>
Cc: "Andrii Nakryiko" <andrii@kernel.org>
Cc: "Martin KaFai Lau" <kafai@fb.com>
Cc: "Song Liu" <songliubraving@fb.com>
Cc: "Yonghong Song" <yhs@fb.com>
Cc: "John Fastabend" <john.fastabend@gmail.com>
Cc: "KP Singh" <kpsingh@kernel.org>
Cc: <netdev@vger.kernel.org>
Cc: <bpf@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

Link: https://syzkaller.appspot.com/bug?id=8ebf179a95c2a2670f7cf1ba62429ec044369db4
Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
Reported-by: <syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
v2: Add a fall back path that removes a prog from the effective progs
    table in case detach fails to allocate memory in compute_effective_progs().

v3: Implement the fallback in a separate function purge_effective_progs
---
 kernel/bpf/cgroup.c | 64 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 56 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 128028efda64..9d3af4d6c055 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -681,6 +681,57 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
 	return ERR_PTR(-ENOENT);
 }
 
+/**
+ * purge_effective_progs() - After compute_effective_progs fails to alloc new
+ *                           cgrp->bpf.inactive table we can recover by
+ *                           recomputing the array in place.
+ *
+ * @cgrp: The cgroup which descendants to traverse
+ * @link: A link to detach
+ * @atype: Type of detach operation
+ */
+static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
+				  enum cgroup_bpf_attach_type atype)
+{
+	struct cgroup_subsys_state *css;
+	struct bpf_prog_array_item *item;
+	struct bpf_prog *tmp;
+	struct bpf_prog_array *array;
+	int index = 0, index_purge = -1;
+
+	if (!prog)
+		return;
+
+	/* recompute effective prog array in place */
+	css_for_each_descendant_pre(css, &cgrp->self) {
+		struct cgroup *desc = container_of(css, struct cgroup, self);
+
+		array = desc->bpf.effective[atype];
+		item = &array->items[0];
+
+		/* Find the index of the prog to purge */
+		while ((tmp = READ_ONCE(item->prog))) {
+			if (tmp == prog) {
+				index_purge = index;
+				break;
+			}
+			item++;
+			index++;
+		}
+
+		/* Check if we found what's needed for removing the prog */
+		if (index_purge == -1 || index_purge == index - 1)
+			continue;
+
+		/* Remove the program from the array */
+		WARN_ONCE(bpf_prog_array_delete_safe_at(array, index_purge),
+			  "Failed to purge a prog from array at index %d", index_purge);
+
+		index = 0;
+		index_purge = -1;
+	}
+}
+
 /**
  * __cgroup_bpf_detach() - Detach the program or link from a cgroup, and
  *                         propagate the change to descendants
@@ -723,8 +774,11 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	pl->link = NULL;
 
 	err = update_effective_progs(cgrp, atype);
-	if (err)
-		goto cleanup;
+	if (err) {
+		struct bpf_prog *prog_purge = prog ? prog : link->link.prog;
+
+		purge_effective_progs(cgrp, prog_purge, atype);
+	}
 
 	/* now can actually delete it from this cgroup list */
 	list_del(&pl->node);
@@ -736,12 +790,6 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 		bpf_prog_put(old_prog);
 	static_branch_dec(&cgroup_bpf_enabled_key[atype]);
 	return 0;
-
-cleanup:
-	/* restore back prog or link */
-	pl->prog = old_prog;
-	pl->link = link;
-	return err;
 }
 
 static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
-- 
2.36.1

