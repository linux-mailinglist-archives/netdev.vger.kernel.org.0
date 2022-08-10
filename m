Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7560A58EF32
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbiHJPTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbiHJPTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:19:04 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7FB78BE5;
        Wed, 10 Aug 2022 08:18:58 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id l64so14678256pge.0;
        Wed, 10 Aug 2022 08:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ZuUr0Lmb/ZOxk9PY5AfEZVtv5LOeYubF7wGlzoETmHE=;
        b=OHEQuhGa2E+9meTBDvo4R2MaXiYLv46EQQrHAGQ3JbFSFXuMFRDQWOZD23mUAky4KU
         OdJtLuJZjuzRxOu088twYy4nJQYluaHRMZjvhG9loN/vIeefkKoHQU2tcLgaFdnStZzO
         R6v480SZuZVpcD9ZCiG9YqtXNbWy/GenPH0Ngh4lznaoOhClBYV13p7DV3XBf36nhrjx
         N4tXmzGujKFH87N9VHq7kDTXRcyBcicH1oNBbzayC8dGYYh5E2Ay8a9MmCxQJcwAA70S
         tpQosUDU+WzgHIpv/YGR4TygyIZnYDWpks/QOSEm5L3D8BKwmyqxQYdESo8Pq/KKJr7e
         qb9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ZuUr0Lmb/ZOxk9PY5AfEZVtv5LOeYubF7wGlzoETmHE=;
        b=EtPsxznPaTS7wmkYHu8ZFk1XtS+zupDRzNO+13zpUPVt3707a4hx+5+KzNaFlt3CoR
         gr7/2g00l2CICV60FP9ELX+KAOcPG6MiurT7BBWZO2af2QQZr8mh3UW5Cm2cuRfBs6KI
         q5FpYas3WIxRPVyFpZlrD3LTUTfbtaaYPtppJC9J7qvIrmAzhgCKKalstoeW0r/hy+Xq
         mVRF5PzriFMuyK4GYxBZyIq2Xu5waxRGLLVce91vxXZFtC/MGxsVIcx/TqExmSTXfBRl
         pSIgDw6OpAbySH3HhmH9dg6SkgRPrzR2XHgvFDY/PG5kaFmbLco0MBtAuQ92PSd3vPQr
         wtpQ==
X-Gm-Message-State: ACgBeo3jTierBLJvNKu/0fbhzQIEO82Zf7Wkx3kg+19TmEfF8cF+byRL
        VXlNiu9asQS8RnMHX9Vcmko=
X-Google-Smtp-Source: AA6agR6ilBNkZuPCRzWfdrpskFMZWXABEGPKHGKS0BRmL0vru/PZc53aw592+RCpI5B3o2SiI/u8mA==
X-Received: by 2002:a63:1624:0:b0:41a:9dea:1c80 with SMTP id w36-20020a631624000000b0041a9dea1c80mr23479619pgl.400.1660144737875;
        Wed, 10 Aug 2022 08:18:57 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id 85-20020a621558000000b0052b6ed5ca40sm2071935pfv.192.2022.08.10.08.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:18:57 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 07/15] bpf: Call bpf_map_init_from_attr() immediately after map creation
Date:   Wed, 10 Aug 2022 15:18:32 +0000
Message-Id: <20220810151840.16394-8-laoar.shao@gmail.com>
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

