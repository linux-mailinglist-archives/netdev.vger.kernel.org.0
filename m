Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226BB5985F6
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245361AbiHROcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245640AbiHROcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:32:20 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA16BA17A;
        Thu, 18 Aug 2022 07:32:08 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d20so1703987pfq.5;
        Thu, 18 Aug 2022 07:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=SdEsGdLtUTnGTQlmpkcqbLnnsMN1enZs7HVXG4Feokc=;
        b=iM7+xYE3ZpaZKh2j/9NZNfU6WfXX1qnhHz90ontLLo/0kh1EMI2GgT3hsaLXjYuqB+
         Bc+3EgV3QlYwmbQSgP6DF4xyLZM3XeV8u8WuYlvq9gCHoYixiOEju6GCoB9t8bIaV/h0
         8FIPglxdIU0iKsIttK5lqBYDQPvSCT6m7EJ3UB3fKymtdyT2oCkbs3nW8AuR5HmU6c4U
         plqqyHQwuiSWQJN/q+zwHtXRUvp4HuPyDXIB+i0qM1xVXS6Uwz7nDD7ePd9S4T3uG5Lr
         XMmyq9x38HyRsbixPhyelgKdWfrTLNyNj+YPuYZOVsEtiDUSthZTWGolXni2ZmEiLLAD
         tSiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=SdEsGdLtUTnGTQlmpkcqbLnnsMN1enZs7HVXG4Feokc=;
        b=yfKNhrgagrzCJh3dGy1bNc0pN9jxD2yTyLaMehgiw9sbzBPUynJyQuhPJNpt38fRVu
         okuMA0bHXICbhR6DQJcjUtbS2FILEUqYGawydG8RLGPR1mk6jaypsJo3ZTp7NZklwXhw
         +9QC262kpvNQQFSLdh9eH7sEaK4od9pPXwy/2gox8XkIaK686Kk6hGSNw2A6Swn6NkKe
         gaesMl2fSXNYpx3zIycrbcYECVLFAjCgjAo033UYRRy2na/5RCjofskXVjPqi7n+DOpk
         J4BY9nWJ6s2pwcYeKW4h3xJgokhGKpwVn4uEiQD5SdHyTeRE5e4BckcsgJXdO5SaLYv0
         3Qwg==
X-Gm-Message-State: ACgBeo2YZi2hIy9wc/sLrK07umZdbSU0gGRXLN9MyxmmvfavNPgUuvCn
        0dFDxMN2kYi6CbEWVLYnBnk=
X-Google-Smtp-Source: AA6agR6tGbyVsMQyI/lXKdwbyTP8XOf52SpT7zfV868FB9HDcvT6Z5ZuEY1X02mmUFcf4qavA1RCrg==
X-Received: by 2002:a63:2208:0:b0:429:9444:85be with SMTP id i8-20020a632208000000b00429944485bemr2660287pgi.236.1660833128367;
        Thu, 18 Aug 2022 07:32:08 -0700 (PDT)
Received: from vultr.guest ([45.32.72.237])
        by smtp.gmail.com with ESMTPSA id h5-20020a63f905000000b003fdc16f5de2sm1379124pgi.15.2022.08.18.07.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 07:32:07 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org,
        lizefan.x@bytedance.com
Cc:     cgroups@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2 10/12] mm, memcg: Add new helper get_obj_cgroup_from_cgroup
Date:   Thu, 18 Aug 2022 14:31:16 +0000
Message-Id: <20220818143118.17733-11-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220818143118.17733-1-laoar.shao@gmail.com>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to open a cgroup directory and pass the fd into kernel, and then
in the kernel we can charge the allocated memory into the open cgroup if it
has valid memory subsystem. In the bpf subsystem, the opened cgroup will
be store as a struct obj_cgroup pointer, so a new helper
get_obj_cgroup_from_cgroup() is introduced.

It also add a comment on why the helper  __get_obj_cgroup_from_memcg()
must be protected by rcu read lock.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 2f0a611..901a921 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1713,6 +1713,7 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
 void __memcg_kmem_uncharge_page(struct page *page, int order);
 
+struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp);
 struct obj_cgroup *get_obj_cgroup_from_current(void);
 struct obj_cgroup *get_obj_cgroup_from_page(struct page *page);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 618c366..0409cc4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2895,6 +2895,14 @@ struct mem_cgroup *mem_cgroup_from_obj(void *p)
 	return page_memcg_check(folio_page(folio, 0));
 }
 
+/*
+ * Pls. note that the memg->objcg can be freed after it is deferenced,
+ * that can happen when the memcg is changed from online to offline.
+ * So this helper must be protected by read rcu lock.
+ *
+ * After obj_cgroup_tryget(), it is safe to use the objcg outside of the rcu
+ * read-side critical section.
+ */
 static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg = NULL;
@@ -2908,6 +2916,45 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 	return objcg;
 }
 
+static struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
+{
+	struct obj_cgroup *objcg;
+
+	if (memcg_kmem_bypass())
+		return NULL;
+
+	rcu_read_lock();
+	objcg = __get_obj_cgroup_from_memcg(memcg);
+	rcu_read_unlock();
+	return objcg;
+}
+
+struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp)
+{
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
+
+	rcu_read_lock();
+	css = rcu_dereference(cgrp->subsys[memory_cgrp_id]);
+	if (!css || !css_tryget_online(css)) {
+		rcu_read_unlock();
+		return ERR_PTR(-EINVAL);
+	}
+	rcu_read_unlock();
+
+	memcg = mem_cgroup_from_css(css);
+	if (!memcg) {
+		css_put(css);
+		return ERR_PTR(-EINVAL);
+	}
+
+	objcg = get_obj_cgroup_from_memcg(memcg);
+	css_put(css);
+
+	return objcg;
+}
+
 __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 {
 	struct obj_cgroup *objcg = NULL;
-- 
1.8.3.1

