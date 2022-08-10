Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1970258EF2C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbiHJPTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbiHJPSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:18:55 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B93785AA;
        Wed, 10 Aug 2022 08:18:54 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id h21-20020a17090aa89500b001f31a61b91dso2489711pjq.4;
        Wed, 10 Aug 2022 08:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=bZ/Wn/pmwYaPcD9cZLDVbMlygpn2TOkNAIPIYOEl18Y=;
        b=UZqCbeSc22sRQWZd+RhChsE4dWDPqNKHL76pEEfMY+wqnZlJvi6cRD7ua3Gaa60Hx2
         CAe+jsbYkYFPiO2urZ+gNwzPkswhX8P0vMpj8kKJGHPQ+3whiPae54/J0ZRSQ/HUIw4B
         GITX56ZlyJ5jtzQDQa12XN0EVx46NDz6G7X3il4CfvEWFw0pzGMhzGX0FQfo2O4I5fl0
         6vwdFXlgkQtZdunmCOOYvrWeJucbUnlSiHYu5+Qqa+6oExySt+Nbsc0oR8SefojbHSD9
         iIEse4WYr2CbqGdES+DpvJs+NgjMIojCwVyx/xCV9KBNBYjgwRrPd6c0jRxVHhGKeHt+
         M59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=bZ/Wn/pmwYaPcD9cZLDVbMlygpn2TOkNAIPIYOEl18Y=;
        b=xgmB8hCCjUwrjZ2xUt9QYROpZ5I7w2AufTIU7Va1zYTAnbvqUPItn6vGqupiRUQkWY
         uJDCKR9YEbLSq3cnYUNwoq2KqkeurkdQ7gJ0Ne4UxygEac+zAfrAizKo0ptPusyqHZMc
         Zc1ox3nWOZmXZCAtvTzHP1xi2e4Wm5POir9nWQgHktUFxLUz6zkGr/VnOJpKNr3nTOvn
         bOVHqVhchctJB5Ex6F9E0+2ofw1TjJd4DJYeJcxfrLBwov/iQojizQadfoy1V5jPO1ig
         3DOX5NOzojoZd2pvVxGwX4RmGLZBJfZls2ommYnaQ68LupZ0dR/Gi7aS2nLR0drfpFJF
         tnNg==
X-Gm-Message-State: ACgBeo1UhccFjfPuK2V+O9d6cZjFZ2ROXiZRawIkP+yOVAFoZ5B8iT03
        dlp0Jx+y5ZSqPl8LukVFCdU=
X-Google-Smtp-Source: AA6agR7zMPKqwoHrBCMJ/QFxg4BZHomKAMIsFVdSEpWqsvP46BAFZwZnz8InOPJ0E3RrAROE/EQdgA==
X-Received: by 2002:a17:902:ccd0:b0:16c:5d4f:99f3 with SMTP id z16-20020a170902ccd000b0016c5d4f99f3mr27988073ple.139.1660144733978;
        Wed, 10 Aug 2022 08:18:53 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id 85-20020a621558000000b0052b6ed5ca40sm2071935pfv.192.2022.08.10.08.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:18:53 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 05/15] bpf: Fix incorrect mem_cgroup_put
Date:   Wed, 10 Aug 2022 15:18:30 +0000
Message-Id: <20220810151840.16394-6-laoar.shao@gmail.com>
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

The memcg may be the root_mem_cgroup, in which case we shouldn't put it.
So a new helper bpf_map_put_memcg() is introduced to pair with
bpf_map_get_memcg().

Fixes: 4201d9ab3e42 ("bpf: reparent bpf maps on memcg offlining")
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/syscall.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 83c7136..51ab8b1 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -441,6 +441,14 @@ static struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
 	return root_mem_cgroup;
 }
 
+static void bpf_map_put_memcg(struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_is_root(memcg))
+		return;
+
+	mem_cgroup_put(memcg);
+}
+
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node)
 {
@@ -451,7 +459,7 @@ void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 	old_memcg = set_active_memcg(memcg);
 	ptr = kmalloc_node(size, flags | __GFP_ACCOUNT, node);
 	set_active_memcg(old_memcg);
-	mem_cgroup_put(memcg);
+	bpf_map_put_memcg(memcg);
 
 	return ptr;
 }
@@ -465,7 +473,7 @@ void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags)
 	old_memcg = set_active_memcg(memcg);
 	ptr = kzalloc(size, flags | __GFP_ACCOUNT);
 	set_active_memcg(old_memcg);
-	mem_cgroup_put(memcg);
+	bpf_map_put_memcg(memcg);
 
 	return ptr;
 }
@@ -480,7 +488,7 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 	old_memcg = set_active_memcg(memcg);
 	ptr = __alloc_percpu_gfp(size, align, flags | __GFP_ACCOUNT);
 	set_active_memcg(old_memcg);
-	mem_cgroup_put(memcg);
+	bpf_map_put_memcg(memcg);
 
 	return ptr;
 }
-- 
1.8.3.1

