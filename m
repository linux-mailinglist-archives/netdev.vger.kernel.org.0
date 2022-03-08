Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23BA24D18D7
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346651AbiCHNMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiCHNM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:12:28 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F1C488A0;
        Tue,  8 Mar 2022 05:11:28 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 132so16430349pga.5;
        Tue, 08 Mar 2022 05:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bgJJlFnbXaRCIAYL5SQZwRZJIW6MmhaiowbOp4O3M1Y=;
        b=BTNwJVlZtiizxAYf1GqUM418mm4KpUgPRAZTqG8USzvhC/zyC+HUN65jCkTRLcPE2y
         HC/PH3SHk9dp5WMPyxiDG5XVzxxSlmltP5UJbf0EkQf2S+Fe/dbRT+enxXvZFxiN82Ow
         wtRn7eF5edcKUjmFS8ZTggAfNGUZIjzpxJkhs9p29fupdSUaEbpaDnj9IFnIf9Oxvwsh
         ZyaZyxh5UI7oo1CvxNcIyaVnuS8Z/p8OJadCY6UL6fhmjwrhb0OmPoQ35tw6WiG7nTCm
         KzeezESmY6izJJ+jz5rSydmReEB289qVpYWBJ6imgVnyOlsLHG0l1gGjNvR2wWVYoxix
         t9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bgJJlFnbXaRCIAYL5SQZwRZJIW6MmhaiowbOp4O3M1Y=;
        b=aTSeHa5vF2f8fiPxIRCqR9TnMXjw89rUEr3C0uXg9XT93uiEEnRz2u5J2K+mAM6U/G
         Or5DpH4djKBCMP8rKEmSHOH2qbDmw319x3gUY8WQXJ6TroTMXMDLJeA1bIjO0j+tCgT+
         T4bW3Yex8Si8amxY1DMib5ETk/3rj1kmzek5jopqQKNJctN/VFSndsaJrsL/+EU5MQnX
         ceEpXyQj67GnpWa1RzxjlAVOPlNR4AUYxD08quxck07RuSELCrflZJBbCWaOhOzf8jgz
         NffOF2/8YlTZlKoi7IxMF7yiSdId/DLiQSeh6QM3pFlJhiTowsYhO/HGde+MQvOPnko1
         3xYA==
X-Gm-Message-State: AOAM530AJTtoqkpPGBHYzWlEBiAQUQp4kgO16BKC49jLcCFceOXEXjiZ
        qT/MGI6+6iFucbuoOz7v48E=
X-Google-Smtp-Source: ABdhPJxcfF7dzcGyqjiKeRaKXA6W9nGPA0uFJq/5jcaGXg7/O7wJRtUT++VsWLtNLmrzXp07AhJYEg==
X-Received: by 2002:aa7:8882:0:b0:4df:7b9e:1ccb with SMTP id z2-20020aa78882000000b004df7b9e1ccbmr18056424pfe.41.1646745087617;
        Tue, 08 Mar 2022 05:11:27 -0800 (PST)
Received: from vultr.guest ([149.248.19.67])
        by smtp.gmail.com with ESMTPSA id s20-20020a056a00179400b004f709998d13sm7378598pfg.10.2022.03.08.05.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:11:27 -0800 (PST)
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
Subject: [PATCH RFC 9/9] bpf: support recharge for hash map
Date:   Tue,  8 Mar 2022 13:10:56 +0000
Message-Id: <20220308131056.6732-10-laoar.shao@gmail.com>
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

This patch supports recharge for hash map. We have already known how the
hash map is allocated and freed, we can also know how to charge and
uncharge the hash map. Firstly, we need to uncharge it from the old
memcg, then charge it to the current memcg. The old memcg must be an
offline memcg.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/hashtab.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 6587796..4d103f1 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -10,6 +10,7 @@
 #include <linux/random.h>
 #include <uapi/linux/btf.h>
 #include <linux/rcupdate_trace.h>
+#include <linux/memcontrol.h>
 #include "percpu_freelist.h"
 #include "bpf_lru_list.h"
 #include "map_in_map.h"
@@ -1466,6 +1467,36 @@ static void htab_map_free(struct bpf_map *map)
 	kfree(htab);
 }
 
+static bool htab_map_recharge_memcg(struct bpf_map *map)
+{
+	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+	struct mem_cgroup *old = map->memcg;
+	int i;
+
+	if (!old)
+		return false;
+
+	/* Only process offline memcg */
+	if (old == root_mem_cgroup || old->kmemcg_id >= 0)
+		return false;
+
+	bpf_map_release_memcg(map);
+	kcharge(htab, false);
+	kvcharge(htab->buckets, false);
+	charge_percpu(htab->extra_elems, false);
+	for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
+		charge_percpu(htab->map_locked[i], false);
+
+	kcharge(htab, true);
+	kvcharge(htab->buckets, true);
+	charge_percpu(htab->extra_elems, true);
+	for (i = 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
+		charge_percpu(htab->map_locked[i], true);
+	bpf_map_save_memcg(map);
+
+	return true;
+}
+
 static void htab_map_seq_show_elem(struct bpf_map *map, void *key,
 				   struct seq_file *m)
 {
@@ -2111,6 +2142,7 @@ static int bpf_for_each_hash_elem(struct bpf_map *map, bpf_callback_t callback_f
 	.map_alloc_check = htab_map_alloc_check,
 	.map_alloc = htab_map_alloc,
 	.map_free = htab_map_free,
+	.map_recharge_memcg = htab_map_recharge_memcg,
 	.map_get_next_key = htab_map_get_next_key,
 	.map_release_uref = htab_map_free_timers,
 	.map_lookup_elem = htab_map_lookup_elem,
@@ -2133,6 +2165,7 @@ static int bpf_for_each_hash_elem(struct bpf_map *map, bpf_callback_t callback_f
 	.map_alloc_check = htab_map_alloc_check,
 	.map_alloc = htab_map_alloc,
 	.map_free = htab_map_free,
+	.map_recharge_memcg = htab_map_recharge_memcg,
 	.map_get_next_key = htab_map_get_next_key,
 	.map_release_uref = htab_map_free_timers,
 	.map_lookup_elem = htab_lru_map_lookup_elem,
@@ -2258,6 +2291,7 @@ static void htab_percpu_map_seq_show_elem(struct bpf_map *map, void *key,
 	.map_alloc_check = htab_map_alloc_check,
 	.map_alloc = htab_map_alloc,
 	.map_free = htab_map_free,
+	.map_recharge_memcg = htab_map_recharge_memcg,
 	.map_get_next_key = htab_map_get_next_key,
 	.map_lookup_elem = htab_percpu_map_lookup_elem,
 	.map_lookup_and_delete_elem = htab_percpu_map_lookup_and_delete_elem,
@@ -2278,6 +2312,7 @@ static void htab_percpu_map_seq_show_elem(struct bpf_map *map, void *key,
 	.map_alloc_check = htab_map_alloc_check,
 	.map_alloc = htab_map_alloc,
 	.map_free = htab_map_free,
+	.map_recharge_memcg = htab_map_recharge_memcg,
 	.map_get_next_key = htab_map_get_next_key,
 	.map_lookup_elem = htab_lru_percpu_map_lookup_elem,
 	.map_lookup_and_delete_elem = htab_lru_percpu_map_lookup_and_delete_elem,
-- 
1.8.3.1

