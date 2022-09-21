Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6935E5C04FA
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 19:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiIURAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 13:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiIURA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 13:00:29 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB089642E3;
        Wed, 21 Sep 2022 10:00:23 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so14944604pjm.1;
        Wed, 21 Sep 2022 10:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=gqCnXF6pL1DkeQyk82Z43CJDm8euemRLx+k6VOog8Uc=;
        b=UGRZwVaZmlJMU25ZsQipxPfiqXs+wsllhJ+tOSSDcAUjFGAX7DQpWyoztud6+XklKC
         nu8mtVQhAabPURghaZx7jg8BVskiJM/UYMNF3dkH8+cvzz/onhdgh3QlOUj/uLvR9tcc
         2H31ALd6zzINn3zaoG/SK9MPdeYtU7JXkF7VliyTYP/e66MQ/ut7KGcJQZeoJUkXcYcH
         js+Cz02F2TZtIl25SDE8O4d9j6s9E8shiwIAPCn/yl46O+Envod6GqXKimJU0wpKiFxq
         HbAdN9rj34msRsmvaFGVBspvNxRmwm3ZAnxbroDnhMw2M3KrHWP120R2b3iMAiyReA34
         93Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=gqCnXF6pL1DkeQyk82Z43CJDm8euemRLx+k6VOog8Uc=;
        b=RUATKfYOm1A5DyOm/ip/kVDdt4oUGbmq9qSw8i9N9xGw1j0uqGpWlC7mCLyNOAoeGQ
         0kFNtZz3y9iio48xWZRc40Ifu52BIPbRle3sFMhKKbUQd7+8i67POKjfhqIe+lVbZgVR
         d5K6NzuwCSuJ64y62AH6X74FXXPkXVxBzls9A9oOq11cc4SDlzAKTSd9c6MOPZuEFefM
         nFJ2g+Vq+Uckhw7pTkO3xvRYmxfF8ow+DG6XKZuZ4hTINhMbg1IoFU/ApxzxRzK9k2c6
         GKf/rZwwgzQubyDuftE2SbBopHuyhxrvZFrTrCfPpTdeLdz5yiN6GUGzvsQVb5kGSVJT
         Jp3g==
X-Gm-Message-State: ACrzQf2Yt9nqyghqCjQfNpxzjILYXpv77jrWOg2GRgND+u+hp3hMJ8hR
        MMc9w7jxDUYcUAfYZnnHUek=
X-Google-Smtp-Source: AMsMyM6HRw/Vr5zpNcVZxiuAc86cjAkLvMMsOYZ0frkrsI/RI9RosxyjVSCqGe6nLjJt+N6Ie7/jvQ==
X-Received: by 2002:a17:902:d40c:b0:178:4439:69f9 with SMTP id b12-20020a170902d40c00b00178443969f9mr5780706ple.118.1663779623293;
        Wed, 21 Sep 2022 10:00:23 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:488e:5400:4ff:fe25:7db8])
        by smtp.gmail.com with ESMTPSA id mp4-20020a17090b190400b002006f8e7688sm2102495pjb.32.2022.09.21.10.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 10:00:22 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next 07/10] bpf: Use bpf_map_kzalloc in arraymap
Date:   Wed, 21 Sep 2022 16:59:59 +0000
Message-Id: <20220921170002.29557-8-laoar.shao@gmail.com>
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

Allocates memory after map creation, then we can use the generic helper
bpf_map_kzalloc() instead of the open-coded kzalloc().

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/arraymap.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index dd79d0d..7f1766c 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -1111,20 +1111,20 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
 	struct bpf_array_aux *aux;
 	struct bpf_map *map;
 
-	aux = kzalloc(sizeof(*aux), GFP_KERNEL_ACCOUNT);
-	if (!aux)
+	map = array_map_alloc(attr);
+	if (IS_ERR(map))
 		return ERR_PTR(-ENOMEM);
 
+	aux = bpf_map_kzalloc(map, sizeof(*aux), GFP_KERNEL);
+	if (!aux) {
+		array_map_free(map);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	INIT_WORK(&aux->work, prog_array_map_clear_deferred);
 	INIT_LIST_HEAD(&aux->poke_progs);
 	mutex_init(&aux->poke_mutex);
 
-	map = array_map_alloc(attr);
-	if (IS_ERR(map)) {
-		kfree(aux);
-		return map;
-	}
-
 	container_of(map, struct bpf_array, map)->aux = aux;
 	aux->map = map;
 
-- 
1.8.3.1

