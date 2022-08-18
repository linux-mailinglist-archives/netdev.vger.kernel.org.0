Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5E45985F0
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245305AbiHRObz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245180AbiHRObw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:31:52 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7945B9F89;
        Thu, 18 Aug 2022 07:31:51 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u22so1642189plq.12;
        Thu, 18 Aug 2022 07:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ZuUr0Lmb/ZOxk9PY5AfEZVtv5LOeYubF7wGlzoETmHE=;
        b=d1Dmx23BuvVjJGEdABIJqux0UqGU7kR857GG+nUy3p5Gl+JFQRPnacYR5C1E11Ofv+
         VQzRJXyagtlUyX2PsvUhvwbBEGI5jCo8K1MXP9YC9jrYwQ1ql3E23yGsomtt3aLtLkyG
         6jlsslfX7hAUQnLnftrWYWKn1ckbPQdwKng7PSX/hzD0DU1ebls3NA0vJ28f+kCAbJzx
         Dnbnw+RjYZUrzVphtx6OF+YrhmHnSp3Z5NGEX6Pky5rHNvrD7tahg66442kAz7OJTR+Q
         Xfox1U4JtTXiJmuNH/IzeI1IAXmH9WYKpr67CkHaEi1FWvYNxiP6kgVw4yJMKC3uCG38
         /OMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ZuUr0Lmb/ZOxk9PY5AfEZVtv5LOeYubF7wGlzoETmHE=;
        b=kg4D9J16c5QEOT3Cm1UbAFfKFtAmBiXruh3108X1k4fa3g45cew7SVxAX2FwP/K61A
         sK3s8xh0h95mjfTt2phwcBDxtXOwi2BKx2FjdxJxg0dsDteWfgohkd25lVDjn4MfuPDL
         e1pYE92YEAtL1zPtt+dkCuS/lN7Z0FxkpzZ2gcMkjAdvp+o72J9cWN42Sp/9ykUBrmrQ
         gQiM1NPSJ9Xo9IEWKvjPDB5Zu6gbuBbYuNr6rjO69oAp7khx9+wQhasM7jM2auxufSiF
         A9SWV8iFpxbLC5f8CbasUbZUDNW6H9xq9U/2X8aU5eBOV4dUY2sldtushRvCMzDy/gAZ
         SArA==
X-Gm-Message-State: ACgBeo0/hB8EKaaEkczfh4+5sezxvfFlcuVDHMR61FA36vgIwdqGAF2n
        UcBoupMU1pv3aufZc/DQFDM=
X-Google-Smtp-Source: AA6agR7c8t/UNHEBNrrIWCnH4P2UoAcPiCKseHMm/BYgU8xvPNvxWD6o9PWbAC1k+VmB22rXaSPvww==
X-Received: by 2002:a17:902:a5c5:b0:16f:1e31:daab with SMTP id t5-20020a170902a5c500b0016f1e31daabmr2876148plq.82.1660833111438;
        Thu, 18 Aug 2022 07:31:51 -0700 (PDT)
Received: from vultr.guest ([45.32.72.237])
        by smtp.gmail.com with ESMTPSA id h5-20020a63f905000000b003fdc16f5de2sm1379124pgi.15.2022.08.18.07.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 07:31:50 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 04/12] bpf: Call bpf_map_init_from_attr() immediately after map creation
Date:   Thu, 18 Aug 2022 14:31:10 +0000
Message-Id: <20220818143118.17733-5-laoar.shao@gmail.com>
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
index 8392f7f..48dc04c 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -499,10 +499,10 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
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

