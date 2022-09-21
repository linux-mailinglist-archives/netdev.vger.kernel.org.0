Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B54D5C04F1
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 19:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiIURAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 13:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiIURAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 13:00:17 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341C22A27E;
        Wed, 21 Sep 2022 10:00:16 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v1so6265254plo.9;
        Wed, 21 Sep 2022 10:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=f1B/fJ7c1U504s6DGE1MVFIz1uDuaG3uKK0ASZv0FxM=;
        b=fpZ8/1xkHoMLB2UOFwFpVvw7tWvX9cslgyitt4vRPFpO7zuQCu0xCkIlaFhSFsUZby
         E27igllfmnZEinieJr5J8Zqo/4xpWdKJGEM0w4+79gE/Pm/NlVMiIHZ9lyb2iX+2j/RU
         kwVc5mQgrWuSCJ9JazP3ZTgS/62djsGR1UNSnbWAQtMjaIRjFTl0u3UotwgdhToA1xnf
         0Uf8aqByrex8ypDCikKf+UFNtLy2moByEgFvDDrLgEqp2muM4iW3TJdOMJlqhkAjZZ9w
         /8msZT9MUh7fip1qYOz7NV/YZxjb5+2aPXavfQQx/hgAHqQ8ld+k4ByuDNIYSvPe5+JG
         jvSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=f1B/fJ7c1U504s6DGE1MVFIz1uDuaG3uKK0ASZv0FxM=;
        b=YZf9mRzLG8eggGzZ6Ir4qUr79coTwTFCzOysxY/VVqdlePIzZpmwsPvQCC80pGiTF5
         KfFCthyVE6n/jhU7Yga6HARk96SnlC6BpwTDGzI3xvQ96h6OAsH1SGFUnJqJGtZ/Gnyc
         SXJwb5IQ0PKRePK0rqP7Hn1DJGJv706b38MDchhZFiGGn+snDeWJpigb0wDkekpGMSfY
         6v+DI/nHyIqCITMdW9aFaTFcx0fA5RKGbFKrik3d5w3HqTvkk6vSkkuH9PByBE9CItbS
         6RAYlHq+fQCy4mGjVAusOM8rS+aS71v1NsiCAsvGoyFF77Zk+3NOb4HJG80xUAoIPFLU
         4lKw==
X-Gm-Message-State: ACrzQf2lfcRCC9PHjy7omcJvPyLwi/J8BC843+R7dQ2dgarslUYnB9Ok
        OOAomYVptm+CJTT4WjiCJbM=
X-Google-Smtp-Source: AMsMyM5gR2T0wg64OZlwIN8ArMexApKA+n2Y8QDh3pERtSakiNDYZEYZXhf/fS+0+8sOQ10SEuZYrg==
X-Received: by 2002:a17:90b:4a0c:b0:202:b4ed:1a2b with SMTP id kk12-20020a17090b4a0c00b00202b4ed1a2bmr10449138pjb.67.1663779614994;
        Wed, 21 Sep 2022 10:00:14 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:488e:5400:4ff:fe25:7db8])
        by smtp.gmail.com with ESMTPSA id mp4-20020a17090b190400b002006f8e7688sm2102495pjb.32.2022.09.21.10.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 10:00:14 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next 03/10] bpf: Call bpf_map_init_from_attr() immediately after map creation
Date:   Wed, 21 Sep 2022 16:59:55 +0000
Message-Id: <20220921170002.29557-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220921170002.29557-1-laoar.shao@gmail.com>
References: <20220921170002.29557-1-laoar.shao@gmail.com>
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
index 86aec20..6c0e4eb 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -514,10 +514,10 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
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

