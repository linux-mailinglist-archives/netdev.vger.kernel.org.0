Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B69E4D18D9
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347067AbiCHNMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347040AbiCHNM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:12:27 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADF148884;
        Tue,  8 Mar 2022 05:11:26 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id c11so4023354pgu.11;
        Tue, 08 Mar 2022 05:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lr/CFIp00pEF/BEp0dXxqdNW/AI45azIAndxyHO9fEc=;
        b=JB0q4IHcXTozLToE7J/d1F6oTslE6YdOVpdWGhqprivSKxigjke87oe7Q/SAuyYUeH
         WGJhQaBuZ3HVQClkwYFjPKSRzgp4emV2L1P9SSaiybKpW76EN96/bTPE61IvacYCCbPu
         2tnyx9h8AlAdJPTWgHaw0h6UrUPrZ543f9QNEfkMR0fTECuDmx4tQ3zxfQqOJsCk8sVk
         DYKKS+Xgd/h2MU2mxDUrjhR88QnzZGpZMmDwkqIWWmQrDT1ib7gRT6txscX8hGM0D7a6
         uqP4aOAJ9FLNxpLxK1WiRTAVv86fU6Cfs15ePd+M+iOUp7u+I0QzoTVPdqbLiMfI4jIW
         wpSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lr/CFIp00pEF/BEp0dXxqdNW/AI45azIAndxyHO9fEc=;
        b=DEKs1ZUQhBacW2MSbjDCwWwcwbyLZ5gH21aaIHH9LKqa+cXaHnCtK4Oi2MiYbGcSe4
         1PANkP6q7k2F47ixA7tl53z+xVt3NAtQkj208q0r/ufh1sDi8ri7uQEDF8dkC73sHN6o
         N/stkV4lgxqNND9fQFhnqZ/FORIsFo2iAeJZoh9UrXZYJDCFnBJ0Ru3FL79m6J07eVbZ
         ZHgfwbZcgdjacpsBFvkDtmhY9bYs8xgItBJQltPwVIWxbmluibGtZOEDafcSK2LvrpU/
         Bxs14dfZpfsyPFevVoxdDP3oagF+Sg7DYdI8a7yGdOEsWXoeVduBU1H1vfWBq5vxdfjH
         SFtg==
X-Gm-Message-State: AOAM5323NzjLIKGrKJ6ak/c1HBvw85zRKNn4HICA2L6dqD7CXuxgXyih
        IdFr4F8BjLfz7qifptcexKsMvwF96pJNXzVUZxg=
X-Google-Smtp-Source: ABdhPJyOlCtmyFx3M63Qe/Lo+ROqOvjtLMDDMPcSoi5Quoxet+iI8DibJx/wB3rOKVChv0jQxhwF4w==
X-Received: by 2002:a05:6a00:198f:b0:4f6:c0e4:207d with SMTP id d15-20020a056a00198f00b004f6c0e4207dmr17968238pfl.82.1646745086059;
        Tue, 08 Mar 2022 05:11:26 -0800 (PST)
Received: from vultr.guest ([149.248.19.67])
        by smtp.gmail.com with ESMTPSA id s20-20020a056a00179400b004f709998d13sm7378598pfg.10.2022.03.08.05.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:11:25 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        guro@fb.com
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH RFC 8/9] bpf: make bpf_map_{save, release}_memcg public
Date:   Tue,  8 Mar 2022 13:10:55 +0000
Message-Id: <20220308131056.6732-9-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220308131056.6732-1-laoar.shao@gmail.com>
References: <20220308131056.6732-1-laoar.shao@gmail.com>
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

These two helpers will be used in map specific files later.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h  | 21 +++++++++++++++++++++
 kernel/bpf/syscall.c | 19 -------------------
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fca274e..2f3f092 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/percpu-refcount.h>
 #include <linux/bpfptr.h>
+#include <linux/memcontrol.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -209,6 +210,26 @@ struct bpf_map {
 	} owner;
 };
 
+#ifdef CONFIG_MEMCG_KMEM
+static inline void bpf_map_save_memcg(struct bpf_map *map)
+{
+	map->memcg = get_mem_cgroup_from_mm(current->mm);
+}
+
+static inline void bpf_map_release_memcg(struct bpf_map *map)
+{
+	mem_cgroup_put(map->memcg);
+}
+#else
+static inline void bpf_map_save_memcg(struct bpf_map *map)
+{
+}
+
+static inline void bpf_map_release_memcg(struct bpf_map *map)
+{
+}
+#endif
+
 static inline bool map_value_has_spin_lock(const struct bpf_map *map)
 {
 	return map->spin_lock_off >= 0;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 85456f1..7b4cbe7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -414,16 +414,6 @@ void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock)
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static void bpf_map_save_memcg(struct bpf_map *map)
-{
-	map->memcg = get_mem_cgroup_from_mm(current->mm);
-}
-
-static void bpf_map_release_memcg(struct bpf_map *map)
-{
-	mem_cgroup_put(map->memcg);
-}
-
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node)
 {
@@ -461,15 +451,6 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 
 	return ptr;
 }
-
-#else
-static void bpf_map_save_memcg(struct bpf_map *map)
-{
-}
-
-static void bpf_map_release_memcg(struct bpf_map *map)
-{
-}
 #endif
 
 /* called from workqueue */
-- 
1.8.3.1

