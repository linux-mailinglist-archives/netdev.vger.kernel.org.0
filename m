Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF4A585279
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237668AbiG2PY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237498AbiG2PYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:24:02 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B5D85FAD;
        Fri, 29 Jul 2022 08:23:46 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a7-20020a17090a008700b001f325db8b90so4154589pja.0;
        Fri, 29 Jul 2022 08:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pNoGfDj1V1TnWI6qBdBSp31pmoo67RNKkb0LUb2vNLg=;
        b=L5yhSIt8gjsSmoj1o/cBW9AzyQHq5mIC+9at26SQ6hcp6bPNjtuU8B409uMpIMZulG
         QPxCn+2t9lkamdw4jzEf0G7zH9NHRcpwqv16qIJXXhJYDy5yKOj47BUrDDSVxTl9UkwT
         v9/v1FmerqehsorOy6r6RTfjjTPHyTpxQIEeQPNzVU2JKPvYvoBgpEtGQZpUiAJ1nqLi
         3wkIv92UxZWulnBVltosq9eXBkLyzfnsQMRY6U+plLOjEM5r9evSaEkkJ1O4Vvl56u0l
         znIJhCMahnLYJnPpQcR8ECUaR1SL/ePMj83pAVrBVaC8Der/7J67vC6fQmZFhSNf1Wn4
         c3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pNoGfDj1V1TnWI6qBdBSp31pmoo67RNKkb0LUb2vNLg=;
        b=iBxNyiEoY8QVupmrde/cYDyY7mfn6SY+z3AVNpEALFCP3kG850lr4s+kq2PqMrTYOg
         4IODF0wxEFIIROuQQLmEvv+hRzPjJrHnjTD+FRdnfzE7Nv0tgvdls4IKgbHUX0yPxPCL
         kKXgXdrwlr/nOYhuEa6qUtFn65BMHHQ+l8oMcmm4f8Z3SoFRP/+0DDg+w5wquBS98UjZ
         O5HNZ3tNkDQPv77NZ9mxabNfVcsM7wokdQZxaM8LBK1BSPtvmPn3290aTnpJsB+n3b9e
         iysR1UpKupnblli8ZninfQ0BciA0yVJeW9vAkOkbsWCzE+FzQluQNU40nHqBLizXLj/q
         qLHg==
X-Gm-Message-State: ACgBeo3XNBbZR3j/JKK839d2yjZAHvbyNI+jJUjWKfcf+iGYtIUFaXZb
        LMIVUa/dl4X4AVtkBe4tJGA=
X-Google-Smtp-Source: AA6agR6NHf7CpfGmFU7zV1EhZPCbkoe+KGvzl+qrAN+Jzzpvjgr18XBqTeZdgzhLr65Hfxz2R6a99Q==
X-Received: by 2002:a17:902:e5cd:b0:16d:b92c:6848 with SMTP id u13-20020a170902e5cd00b0016db92c6848mr4335575plf.56.1659108226544;
        Fri, 29 Jul 2022 08:23:46 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:45 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 12/15] mm, memcg: Add new helper get_obj_cgroup_from_cgroup
Date:   Fri, 29 Jul 2022 15:23:13 +0000
Message-Id: <20220729152316.58205-13-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220729152316.58205-1-laoar.shao@gmail.com>
References: <20220729152316.58205-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new helper get_obj_cgroup_from_cgroup() to get obj_cgroup from
a specific cgroup.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 41 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 2f0a611f12e5..901a9219fe9a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1713,6 +1713,7 @@ bool mem_cgroup_kmem_disabled(void);
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
 void __memcg_kmem_uncharge_page(struct page *page, int order);
 
+struct obj_cgroup *get_obj_cgroup_from_cgroup(struct cgroup *cgrp);
 struct obj_cgroup *get_obj_cgroup_from_current(void);
 struct obj_cgroup *get_obj_cgroup_from_page(struct page *page);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 618c366a2f07..762cffae0320 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2908,6 +2908,47 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
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
+		cgroup_put(cgrp);
+		return ERR_PTR(-EINVAL);
+	}
+	rcu_read_unlock();
+	cgroup_put(cgrp);
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
2.17.1

