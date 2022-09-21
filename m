Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61C05C04E8
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 19:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiIURAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 13:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiIURAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 13:00:12 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E90F2A439;
        Wed, 21 Sep 2022 10:00:11 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id j12so6511053pfi.11;
        Wed, 21 Sep 2022 10:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Uc034YbXLe4uSOJi2Giv7PoxUQGtDra34gKYHPXI91g=;
        b=YH4e0M93/zwgxts/4p2PWviNzWQigMOF4qZN4QnqPvGBdnj4aBKylgRGfgksaqFVt3
         uXgL1W+nJvpKKKY4mhvcnJPNc05aAwCwBr6okJ/N55sz0zmm80oMEtJF2tqJ41VaRqLl
         OJmVR11MfPb0vTYFi1XU2wURqMcoAp/H6cLE6AF6ZBy41JeBoV15yrUyLR61fgysl6Wu
         WiIyzXyERFPVOgV1APZL4yirViwmqoPokXppwYFwLQu/EwhUO9GPtQYORtPwYHMNvKZA
         dfM4yOYAXYE0nSs1KEzaZckLVHVolUTeu3vpNCp9pwBHspL12xGT21zHdj46zM2RVdW4
         znfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Uc034YbXLe4uSOJi2Giv7PoxUQGtDra34gKYHPXI91g=;
        b=xKLWi8ITv/0Ii7GajQ9PCw2p61yZ4SQyhjSv5XI2cfel7uKSuFzqV5LbWxHHzk7lbr
         fWlP6DCW+/WRX5NRuEszk/tffsaP2z3/TLNmyZOksdbr6wvAKFJwyT+YtOgeipCxhJiy
         6jlOHZOyiHOpvKX8qNs5pAW8yadpWSOaQ4LbWA1W1sgm/sF1qIqwECLzhcOTFy/2+Ut/
         5DSKRleNs7WiDLWSk+GvTXSSBbK1QI1c/IBwk4rstHwZYCiJl17ZuClIpCNTHozlbIQf
         y/aun0LYSmK15Pp4dy1XF963fMZAFmeoddUb7a2h9+gEhCIb6sgdjzlgEVAIwwWt1e6K
         7sXQ==
X-Gm-Message-State: ACrzQf3dFIjQgnxC1w9eeErp8DrYR2P5A2UgmF15sZsM2XtAyX/qPTiY
        V19mFzCm6MxMf/DqdIapSpM=
X-Google-Smtp-Source: AMsMyM4uy0dKCw/P2UdR/ehiaNLiN9bDGO5ET+mXRA6NW2qjr04hx9bZzdjbgfNvCsKVHP2VALThGg==
X-Received: by 2002:a63:4705:0:b0:43b:fc70:2464 with SMTP id u5-20020a634705000000b0043bfc702464mr1534798pga.540.1663779610654;
        Wed, 21 Sep 2022 10:00:10 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:488e:5400:4ff:fe25:7db8])
        by smtp.gmail.com with ESMTPSA id mp4-20020a17090b190400b002006f8e7688sm2102495pjb.32.2022.09.21.10.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 10:00:09 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next 01/10] bpf: Introduce new helper bpf_map_put_memcg()
Date:   Wed, 21 Sep 2022 16:59:53 +0000
Message-Id: <20220921170002.29557-2-laoar.shao@gmail.com>
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

Replace the open-coded mem_cgroup_put() with a new helper
bpf_map_put_memcg(). That could make it more clear.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/syscall.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index dab156f..70d5f70 100644
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

