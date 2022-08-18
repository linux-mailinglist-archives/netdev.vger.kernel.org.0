Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B825985F3
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245262AbiHRObs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241464AbiHRObo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:31:44 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9663FB9FA2;
        Thu, 18 Aug 2022 07:31:43 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so2043891pjl.0;
        Thu, 18 Aug 2022 07:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=wg2OeZwYg3Kz1nqXHwyNkbleHxYXQ5NXoZNmpCP8Llk=;
        b=R/So91AyylEMxXSEpTKpKv01qBGi6xOrsO4noHScLMrE+YO98wrVs063FgNuxiln9E
         dEOV2CN+RE5tNE1z5ZmERPvt6JN3yJolI3nO4D7eoOwHzHR3S3GwYf8gAP+Zp3dVkc1h
         Z6OgTgdGTt8p3N2cLkdNOMMqY7MRDmGpFg/mZ7MdHtfXixdsajHvr/B5hsZe4b+cNEpC
         c55C3O6Uh+Yd6+uu0O6olhxAZYTjxgcFlVzx7dW+WaNGl7QbddUZQSwdmV01ba77Jhdd
         HJ0cHxk3jJ7BaszZQWwQXr5U4CksixminXvUIPa/uoHfx9aVA/VbkVu91OGPozK0RZSh
         u7rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=wg2OeZwYg3Kz1nqXHwyNkbleHxYXQ5NXoZNmpCP8Llk=;
        b=3HEamK6PZVg3s39Jk7DOc/aQVzQuXE6jv7ySLf+XOhQsctm9vP0DTTVj4YQajJnpqX
         QY2MikNTHPMvllH3fXaihNKYksLjgzxWyf59jGY5z5x/na2fcH8+uKSkZOIGH2OuX/jg
         c8PyzsrynEgYG7ewRh4IHulQ2gjm1UEPtNjjRyWyvYF7PAO785qVIgBLjKa2ylIBcG1W
         Kz6rCyulKR5Nj0gLhQrfpNRJaTFxPNs0BjraPgfL+WX7841i439ETAnhNec07+2WemAK
         qCCqDvXGHgyRAnzhqh7C4116Of6AQafI91Co8ETmJZbKGssEGDQQw4tpwU0zuS82YE/p
         fhPw==
X-Gm-Message-State: ACgBeo35kglwL0oQJNU7SwzGq/L9+XYYB3Ibrq0IrBri0hJcPzsEnhMW
        8cp0qO6QGSQy8DhBls6sY7M=
X-Google-Smtp-Source: AA6agR7OEELPz4uROPaJyiezq+3PyARpNOx7by3N5XsqNh2UAUDM9ERvl5GthWrBFRaYDeIe9ZSj0Q==
X-Received: by 2002:a17:90b:3889:b0:1f5:88cd:350d with SMTP id mu9-20020a17090b388900b001f588cd350dmr9116900pjb.9.1660833102811;
        Thu, 18 Aug 2022 07:31:42 -0700 (PDT)
Received: from vultr.guest ([45.32.72.237])
        by smtp.gmail.com with ESMTPSA id h5-20020a63f905000000b003fdc16f5de2sm1379124pgi.15.2022.08.18.07.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 07:31:41 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 02/12] bpf: Introduce new helper bpf_map_put_memcg()
Date:   Thu, 18 Aug 2022 14:31:08 +0000
Message-Id: <20220818143118.17733-3-laoar.shao@gmail.com>
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

Replace the open-coded mem_cgroup_put() with a new helper
bpf_map_put_memcg(). That could make it more clear.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/syscall.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 83c7136..2f18ae2 100644
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

