Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7A252A9EE
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 20:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241974AbiEQSGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 14:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352133AbiEQSGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 14:06:13 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC1050B08
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 11:06:11 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id fw21-20020a17090b129500b001df9f62edd6so739091pjb.0
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 11:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uIitL07LK0k850ajz6+8lfu5spWDwMgSk+A3BueQxNA=;
        b=KHtt2vWHU6kZ9pH1SCH86CyKfw1zEp0NmXtgICisUwjK8zr7Insg5zZB4aeYbN4HAp
         gcdRPVte0tTh9wp0OpzcFMKYxe9ecm+31v6RkScxkpx5mabf5tu33sSIBNLRVwFJqqfm
         lzCQ0/ML22EDn8YkDrXIzskqt8JD7NWAJuTjOMCY8IVGllaaSKIQjH/ekiBxRZFkSYoX
         lg5/FbF+pC9AgaqNNlW+nAUUv63Vj+GASvIK+PLE1qBLZ/HUe6qTs2G2WponrjNZewjI
         +Q7oh5W0zk77vqryRwr3zbOmZhwPkawTikWYWdzD21/5MOO0dTU03aOGvsnEzfy1759e
         RiyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uIitL07LK0k850ajz6+8lfu5spWDwMgSk+A3BueQxNA=;
        b=wIc83cWOe1nGFirgtZ4LmlDhUxj1XC6+pwWjVmBFrqWKchoH8qbOZPB2VbfvVxBzwd
         MiKa8JxFCm5QJPaAeRLTCSFHO2dzHMP3lfcvw0JeCE6wOyQAOVZX5qA9GYIdLldegumi
         xbNJpRo6IJKTl2GetgnDnyShYA5822BR/0EJYQwXVugblERdJ7ZYE5WlEz+km2A5ZVvW
         bkAHpwZrqWTFJrF0w4AkJxHvhKpmmqkN4O/mbj5bO3HuuPg5MlVX/l1y9xYPRsoYVhBq
         up+vlnzjO0RK3wJjuikIJsKoMaTrA4kZokWLa4nYdappwuNYk7/HOAW79I5TtsRG/mdz
         IiMg==
X-Gm-Message-State: AOAM530IJSVEVW6+zMZdd/ulMey58G2TkNmrXJhgNCGobnT/CHGc1ZGw
        qNcdUARyolYReMefuecFmNHEYA==
X-Google-Smtp-Source: ABdhPJyxTDE3qUWOdndVfYN9Y9POy917sjTZcXNmsHowuoVHsWMdu/gc3rF8V92A3Xa6ojAGOrEJTQ==
X-Received: by 2002:a17:902:b413:b0:15e:e6a8:b3e with SMTP id x19-20020a170902b41300b0015ee6a80b3emr23390640plr.24.1652810770573;
        Tue, 17 May 2022 11:06:10 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id g11-20020a17090a7d0b00b001ded0506655sm1952086pjl.51.2022.05.17.11.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:06:10 -0700 (PDT)
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
Subject: [PATCH v4] bpf: Fix KASAN use-after-free Read in compute_effective_progs
Date:   Tue, 17 May 2022 11:04:20 -0700
Message-Id: <20220517180420.87954-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <CAEf4BzY-p13huoqo6N7LJRVVj8rcjPeP3Cp=KDX4N2x9BkC9Zw@mail.gmail.com>
References: <CAEf4BzY-p13huoqo6N7LJRVVj8rcjPeP3Cp=KDX4N2x9BkC9Zw@mail.gmail.com>
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

v4: Changed purge_effective_progs() to manipulate the array in a similar way
    how replace_effective_prog() does it.
---
 kernel/bpf/cgroup.c | 68 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 60 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 128028efda64..6f1a6160c99e 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -681,6 +681,60 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
 	return ERR_PTR(-ENOENT);
 }
 
+/**
+ * purge_effective_progs() - After compute_effective_progs fails to alloc new
+ *                           cgrp->bpf.inactive table we can recover by
+ *                           recomputing the array in place.
+ *
+ * @cgrp: The cgroup which descendants to travers
+ * @prog: A program to detach or NULL
+ * @link: A link to detach or NULL
+ * @atype: Type of detach operation
+ */
+static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
+				  struct bpf_cgroup_link *link,
+				  enum cgroup_bpf_attach_type atype)
+{
+	struct cgroup_subsys_state *css;
+	struct bpf_prog_array *progs;
+	struct bpf_prog_list *pl;
+	struct list_head *head;
+	struct cgroup *cg;
+	int pos;
+
+	/* recompute effective prog array in place */
+	css_for_each_descendant_pre(css, &cgrp->self) {
+		struct cgroup *desc = container_of(css, struct cgroup, self);
+
+		if (percpu_ref_is_zero(&desc->bpf.refcnt))
+			continue;
+
+		/* find position of link or prog in effective progs array */
+		for (pos = 0, cg = desc; cg; cg = cgroup_parent(cg)) {
+			if (pos && !(cg->bpf.flags[atype] & BPF_F_ALLOW_MULTI))
+				continue;
+
+			head = &cg->bpf.progs[atype];
+			list_for_each_entry(pl, head, node) {
+				if (!prog_list_prog(pl))
+					continue;
+				if (pl->prog == prog && pl->link == link)
+					goto found;
+				pos++;
+			}
+		}
+found:
+		BUG_ON(!cg);
+		progs = rcu_dereference_protected(
+				desc->bpf.effective[atype],
+				lockdep_is_held(&cgroup_mutex));
+
+		/* Remove the program from the array */
+		WARN_ONCE(bpf_prog_array_delete_safe_at(progs, pos),
+			  "Failed to purge a prog from array at index %d", pos);
+	}
+}
+
 /**
  * __cgroup_bpf_detach() - Detach the program or link from a cgroup, and
  *                         propagate the change to descendants
@@ -723,8 +777,12 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	pl->link = NULL;
 
 	err = update_effective_progs(cgrp, atype);
-	if (err)
-		goto cleanup;
+	if (err) {
+		/* If update affective array failed replace the prog with a dummy prog*/
+		pl->prog = old_prog;
+		pl->link = link;
+		purge_effective_progs(cgrp, old_prog, link, atype);
+	}
 
 	/* now can actually delete it from this cgroup list */
 	list_del(&pl->node);
@@ -736,12 +794,6 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
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

