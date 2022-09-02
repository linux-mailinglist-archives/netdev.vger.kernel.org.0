Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1B45AA5D1
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbiIBCad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbiIBCa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:30:28 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9C6399D0;
        Thu,  1 Sep 2022 19:30:19 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h188so738006pgc.12;
        Thu, 01 Sep 2022 19:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=lQgh1HsLC8Sr1uJR87Ka1cZJSomKx/sCkb/6FvelFCU=;
        b=GNM1otao9St9RcA3yQ2IOmoal2de7Aanqe1/0mcaal6MCxkxyZmTnCpGD/Cr1ARKSw
         yVZEPKD3vM/kyoPXf5rqU1fLzWmSHim+pt0OJWmVkiEksLM2022QbUh/BXPbjW8YXsph
         mhWZQ54ypqiUslBquWro1iXnjY0hHT4KE6fvb661vn6c9dYttYelYz26bQWMzsAjysfu
         dFACgNLHHgI6EeTssgJAGAx8z9hDLdnvG0lR0JA0X6HhbNmY/qMzZq+bHaQoacm8KA5Q
         UYGm9M48RoD1SDpE8qT9irswpe4ZvkSgp/ApaWtl/Ozsks59OCMC+wLvx63d0AZdYbvx
         sJeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=lQgh1HsLC8Sr1uJR87Ka1cZJSomKx/sCkb/6FvelFCU=;
        b=Raugeo56KrKEE9kW7GltNa4bHT9Ln+e2gasRMTrsv4QzAjwxefYrRtal44jLI3/QMB
         Jt6Cy4pVItfgc5/phgdi5zvWoXuvjk33ZF5Y0Rd9bWAClaR6ja3cMZSQfxFvtXuCWjFo
         KP6meISt4BIthqFSoDlP8EwCG2K7kjKf4p8HPdtawnMwoWGRA0Cp5v7qA8Eo/uSB1vmr
         rQLwT2QdISt8OaYXM5uTRLpQqy+O9xBwrHE2vEt91mw8hh5KlyUYqtX3VyRGukKAhtdd
         2HV2aFzcC5HL/qZhl8Qc67omOWpXSV01rkDG5Ca/CzMHf30e5iesfPe4j5+2aJxZQExn
         Q0cQ==
X-Gm-Message-State: ACgBeo2sh7mI7Cs0ecbLxthYeIvPBGXWXtK2OmVrij8PrXJzrPAq6Uuo
        jjkgRX+lIvPcKVfTbTAdOv0=
X-Google-Smtp-Source: AA6agR5HU/rgule0aTc2QEkg4SDD8rHlkky3g0ZAFabRaE2x0c1avsI5e9NALko3T9SBxP9fcdqRZw==
X-Received: by 2002:a63:fb4a:0:b0:429:8605:6ebf with SMTP id w10-20020a63fb4a000000b0042986056ebfmr28474780pgj.225.1662085819281;
        Thu, 01 Sep 2022 19:30:19 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:50ea:5400:4ff:fe1f:fbe2])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902da8400b0017297a6b39dsm269719plx.265.2022.09.01.19.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 19:30:18 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 04/13] bpf: Call bpf_map_init_from_attr() immediately after map creation
Date:   Fri,  2 Sep 2022 02:29:54 +0000
Message-Id: <20220902023003.47124-5-laoar.shao@gmail.com>
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

In order to make all other map related memory allocations been allocated
after memcg is saved in the map, we should save the memcg immediately
after map creation. But the map is created in bpf_map_area_alloc(),
within which we can't get the related bpf_map (except with a pointer
casting which may be error prone), so we can do it in
bpf_map_init_from_attr(), which is used by all bpf maps.

bpf_map_init_from_attr() is executed immediately after
bpf_map_area_alloc() for almost all bpf maps except bpf_struct_ops,
devmap and hashmap, so this patch changes these three maps.

In the future we will change the return type of bpf_map_init_from_attr()
from void to int for error cases, so put it immediately after
bpf_map_area_alloc() will make it eary to handle the error case.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/bpf_struct_ops.c | 2 +-
 kernel/bpf/devmap.c         | 5 ++---
 kernel/bpf/hashtab.c        | 4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 84b2d9d..36f24f8 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -624,6 +624,7 @@ static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 
 	st_map->st_ops = st_ops;
 	map = &st_map->map;
+	bpf_map_init_from_attr(map, attr);
 
 	st_map->uvalue = bpf_map_area_alloc(vt->size, NUMA_NO_NODE);
 	st_map->links =
@@ -637,7 +638,6 @@ static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 
 	mutex_init(&st_map->lock);
 	set_vm_flush_reset_perms(st_map->image);
-	bpf_map_init_from_attr(map, attr);
 
 	return map;
 }
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f9a87dc..20decc7 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -127,9 +127,6 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 	 */
 	attr->map_flags |= BPF_F_RDONLY_PROG;
 
-
-	bpf_map_init_from_attr(&dtab->map, attr);
-
 	if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
 		dtab->n_buckets = roundup_pow_of_two(dtab->map.max_entries);
 
@@ -167,6 +164,8 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 	if (!dtab)
 		return ERR_PTR(-ENOMEM);
 
+	bpf_map_init_from_attr(&dtab->map, attr);
+
 	err = dev_map_init_map(dtab, attr);
 	if (err) {
 		bpf_map_area_free(dtab);
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index eb1263f..fc7242c 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -508,10 +508,10 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
 
-	lockdep_register_key(&htab->lockdep_key);
-
 	bpf_map_init_from_attr(&htab->map, attr);
 
+	lockdep_register_key(&htab->lockdep_key);
+
 	if (percpu_lru) {
 		/* ensure each CPU's lru list has >=1 elements.
 		 * since we are at it, make each lru list has the same
-- 
1.8.3.1

