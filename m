Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4355AA5DC
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbiIBCbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbiIBCbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:31:07 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF91C4BD36;
        Thu,  1 Sep 2022 19:30:33 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id t129so584239pfb.6;
        Thu, 01 Sep 2022 19:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=oTzSf85iWJHNEVVdQJQawTYzDnCEuMbWuvl4YMwFJHo=;
        b=HpH5nbR7f38apaxWi0KaD3SeNAKzaoXicey2rg/miPioqCgeCWVOK43hCtIftBuo1N
         QbqGHEF6XUCu0BCMIRlFwsthhpD00GqnpDf3e3iIVAx6t7zqW0H7lguDqeHmf9F9kjxZ
         S6VeDMuodddj2nFJ9QdZANE0ynOkPTs8CSWtXQtVPUlS/WeUrrRH8JcbisME3QJuXhjN
         PBriHpMPWSoNwoECmcNJcBgaMUza/8shHez4l6SJ+A6QdqVQeyaccN2u0IE0CWhjJnBn
         +56WGiPw4jZ5f7N+AU/OOQCp50Ok1xUJm48Hr0097jDlSOabNoWqfp7K4Ct7NsN5+B+u
         K5ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=oTzSf85iWJHNEVVdQJQawTYzDnCEuMbWuvl4YMwFJHo=;
        b=TRUOcWBahLiX88DjyyWvbplmYcdq4CUKftUmFX4SYSNC8fliQgLjsVsB/0nXg4FVGU
         yWiWluowTWYUcbOOKm4a89NVZ5Hcew89fpZz27FayWPlPQItCgu5N46UwwXDT2u8mZJ+
         Mk0urEvmYRhR3jLWUpPNKY6w6zY3497ObZSO1/U3xGtvH/nMnIU11ZUkLiLUP80pMGCX
         h3jG91R34dIed2qFRcZNZCFOdTeI9PRcKBJYhmO4GoA0Erie1kQ67/Gi6RfEnpihTs7I
         rQKZwtWraclWujizCV0NE8EjeDDT6+P+1hp+x6klxh+mCYCUiue713gPpoqFKxs6QRCj
         eIOQ==
X-Gm-Message-State: ACgBeo28ZiACNcbZE6uHIa2+ldSw/++nUDnIb3W3jNqcJGHf3qkEtjf/
        k4IprLn47LJSMXr75/f8j10=
X-Google-Smtp-Source: AA6agR7Ygx377TAYolYTUSgnk0C2dXozijEaoUr+0SdI+Cp29mIWbr48/yrAJDnYVJ/ugfGgDTLCgQ==
X-Received: by 2002:a65:6047:0:b0:42b:313e:d331 with SMTP id a7-20020a656047000000b0042b313ed331mr29312059pgp.179.1662085832022;
        Thu, 01 Sep 2022 19:30:32 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:50ea:5400:4ff:fe1f:fbe2])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902da8400b0017297a6b39dsm269719plx.265.2022.09.01.19.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 19:30:31 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 10/13] mm, memcg: Add new helper get_obj_cgroup_from_cgroup
Date:   Fri,  2 Sep 2022 02:30:00 +0000
Message-Id: <20220902023003.47124-11-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220902023003.47124-1-laoar.shao@gmail.com>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
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

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6040b5c..7a7f252 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1734,6 +1734,7 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
 void __memcg_kmem_uncharge_page(struct page *page, int order);
 
+struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp);
 struct obj_cgroup *get_obj_cgroup_from_current(void);
 struct obj_cgroup *get_obj_cgroup_from_page(struct page *page);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b69979c..4e3b51e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2940,6 +2940,7 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg = NULL;
 
+	WARN_ON_ONCE(!rcu_read_lock_held());
 	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg)) {
 		objcg = rcu_dereference(memcg->objcg);
 		if (objcg && obj_cgroup_tryget(objcg))
@@ -2949,6 +2950,53 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
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
+/**
+ * get_obj_cgroup_from_cgroup: Obtain a reference on given cgroup's objcg.
+ * @cgrp: cgroup from which objcg should be extracted. It can't be NULL.
+ *        The memory subsystem of this cgroup must be enabled, otherwise
+ *        -EINVAL will be returned.
+ * On success, the objcg will be returned.
+ * On failure, -EINVAL will be returned.
+ */
+struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp)
+{
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
+
+	rcu_read_lock();
+	css = rcu_dereference(cgrp->subsys[memory_cgrp_id]);
+	if (!css || !css_tryget(css)) {
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

