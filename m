Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9582C5AA5D5
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiIBCaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbiIBCaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:30:17 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5207B13F47;
        Thu,  1 Sep 2022 19:30:15 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id x80so816257pgx.0;
        Thu, 01 Sep 2022 19:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Ia4obLCjxStcu+ICWYF8jUpLC+DBctMa/v2GHxl/gGU=;
        b=mGoieldFRW2ZsDHdEN4SGCykyr50uN6imE/RwcMpTgP+UImu3qxKPcjshQFMbcPCH0
         uYa4R3RNELwqch3SIr0C74TTS/jL857Xy8RcS9/k21JMyxJJUf2YNaFFVlcjqcqfB+yw
         /Oe8BEVARTMeYoQ3hPeJvdKL3YSyxw/d0xpdKh1Zngx9QJIJ82ylFj4vVhnLCIQzPjcC
         DlDpvggQJ9jWbT5zHIXw4sJqpNqrnagdYX8K6LbXA8oO+uLEspmkDZS/yf3+UxDeUQi3
         YNWr/PkVUiPiWmBkX+/KeXFXBAEVgHn2Ex8HMJ5uO9B1PmrOuU68MCDIg8ElFlywwvOx
         Ovkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Ia4obLCjxStcu+ICWYF8jUpLC+DBctMa/v2GHxl/gGU=;
        b=1zm2O9RjaUW8v7I0e8LsDrJ/YlFm7ftRLhzsDP8sNpGF2gNF3kzqcxle52/6MzLssx
         J9ECTPOTH5yjeiJN9EmffVEJN8+8TI0tSN0L5clV0aWn8v5sT6n0NGSXQUL+h8Gs/dwB
         M8yGlhPVklse9wkRGMs81hlDP0QtJVoXxFQQNdvsDUvP3ybtJjDLx2I6zK/zQTfbN9y+
         lfDwLBOW5FrALkj1jf4/hM5tfv/CoatVKL61ZK8+rJYlEhiYbLePMZptAvK6sX7kx+qX
         kBu3tsLjqhz/6uCsvDOSyVkrTKPRm0qrD5jxmPCa+PnkscGJPWNHFT/3GEQTcEXN+9aL
         p0eg==
X-Gm-Message-State: ACgBeo2sG6BxTkQUkvEUD1THogrKdod4uZowWHBKnA19KLexYsnYxE/y
        VgqrFNQiVRptiCwNHDCVZPg=
X-Google-Smtp-Source: AA6agR5zZ7j+yw+Nu++fMWh4vrCtPC8eJ/5esneE7CzVfU+r/WXj/ixS9SxXhktPvUmgl1TQfxfquA==
X-Received: by 2002:a63:a516:0:b0:42b:8bb2:7036 with SMTP id n22-20020a63a516000000b0042b8bb27036mr24798037pgf.389.1662085814905;
        Thu, 01 Sep 2022 19:30:14 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:50ea:5400:4ff:fe1f:fbe2])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902da8400b0017297a6b39dsm269719plx.265.2022.09.01.19.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 19:30:14 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 02/13] bpf: Introduce new helper bpf_map_put_memcg()
Date:   Fri,  2 Sep 2022 02:29:52 +0000
Message-Id: <20220902023003.47124-3-laoar.shao@gmail.com>
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

Replace the open-coded mem_cgroup_put() with a new helper
bpf_map_put_memcg(). That could make it more clear.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/syscall.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e9d462..7ce024c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -441,6 +441,11 @@ static struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
 	return root_mem_cgroup;
 }
 
+static void bpf_map_put_memcg(struct mem_cgroup *memcg)
+{
+	mem_cgroup_put(memcg);
+}
+
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node)
 {
@@ -451,7 +456,7 @@ void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 	old_memcg = set_active_memcg(memcg);
 	ptr = kmalloc_node(size, flags | __GFP_ACCOUNT, node);
 	set_active_memcg(old_memcg);
-	mem_cgroup_put(memcg);
+	bpf_map_put_memcg(memcg);
 
 	return ptr;
 }
@@ -465,7 +470,7 @@ void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags)
 	old_memcg = set_active_memcg(memcg);
 	ptr = kzalloc(size, flags | __GFP_ACCOUNT);
 	set_active_memcg(old_memcg);
-	mem_cgroup_put(memcg);
+	bpf_map_put_memcg(memcg);
 
 	return ptr;
 }
@@ -480,7 +485,7 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 	old_memcg = set_active_memcg(memcg);
 	ptr = __alloc_percpu_gfp(size, align, flags | __GFP_ACCOUNT);
 	set_active_memcg(old_memcg);
-	mem_cgroup_put(memcg);
+	bpf_map_put_memcg(memcg);
 
 	return ptr;
 }
-- 
1.8.3.1

