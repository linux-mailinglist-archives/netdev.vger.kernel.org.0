Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201C158EF3C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbiHJPTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbiHJPTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:19:16 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC73D792C9;
        Wed, 10 Aug 2022 08:19:10 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id h132so14618222pgc.10;
        Wed, 10 Aug 2022 08:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Clyu36Jre2FnqWFd0IUB464wOplrravQ4IfQGIbyf7A=;
        b=YEil+EOUwJvQIvFBvsL8BPyBTpmCr/QRfJvhndnQRuC2ZQ0+oQiSl9+jCjuJsBhbCT
         t9ZCx1gUCzZYRJYYHoPNdbmW/+0irKUw1pjI7jNKTtBINlmPaSWFy91p5RHjUFl6XNgM
         G1xgYpU4pkXPTphUNnsdL/jS18recBewUX0nzUnJ39ufiGnGv3a8FxQFoEMVMyp3kgSa
         8T/+jAcFoP51aFusdVra1eIzo7qi0alJ1JstrFTAj/ESY+9O6OVrVAGYqLnrtB4TLz0C
         DfbqqKV2N0K862CAJDiK+bNn0Q5z9kegp3Ck5xrlgC3xb4U2WxfDoDWCvmvJf39os0HE
         xeww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Clyu36Jre2FnqWFd0IUB464wOplrravQ4IfQGIbyf7A=;
        b=4ck/lZJOMC8dOka4SlCfb0KOwfMtE7F8JxNvk/d/wOBsmVyiCYze2bxLgnfGD/6uYo
         fLsphTOj7FOswxF+4JsEXYwslj29RAeFP4vfmgwP7zo9J0LuIcbwz1adwYMzaZ5Izdb/
         cVbkoXaJytTpiHGEqdAzQW8on1JZfLFyhGRnaadjz6tTDLaNmLHJ9brYJMORLLXIbYu0
         4XHKF6aoOgjnrnLm/98FXyCqC1d/Uu1qUBkkctA6eq0r8T6DC/mcbaNaiHAcBs8vV2sS
         cnq+Y5QJnf5QtQSrmj1f0L4VGBCXGY2780/MVBOexme4VHW5A5gbI7HmFCW7PkuFl7qd
         godw==
X-Gm-Message-State: ACgBeo17QJzVYSrZUhARw8PYDciqJ+FmUYm07jj5VBIbuSbofD95sHQn
        6wzlqP4QEYZ+z9rY7hjpxag=
X-Google-Smtp-Source: AA6agR7Xkytp2XXN8I2Qcu6v3KLTmoDxQ3RCtj8xr4Gi8KDkaVZMWgLR+utyFISJ9K3PkHwewHU68g==
X-Received: by 2002:a05:6a00:21c8:b0:52b:ffc0:15e7 with SMTP id t8-20020a056a0021c800b0052bffc015e7mr28079599pfj.29.1660144749771;
        Wed, 10 Aug 2022 08:19:09 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id 85-20020a621558000000b0052b6ed5ca40sm2071935pfv.192.2022.08.10.08.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:19:08 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 13/15] mm, memcg: Add new helper get_obj_cgroup_from_cgroup
Date:   Wed, 10 Aug 2022 15:18:38 +0000
Message-Id: <20220810151840.16394-14-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220810151840.16394-1-laoar.shao@gmail.com>
References: <20220810151840.16394-1-laoar.shao@gmail.com>
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

Introduce new helper get_obj_cgroup_from_cgroup() to get obj_cgroup from
a specific cgroup.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

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
index 618c366..762cffa 100644
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
1.8.3.1

