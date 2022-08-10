Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8552358EF38
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbiHJPTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbiHJPTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:19:08 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F1778230;
        Wed, 10 Aug 2022 08:19:06 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id q19so13993775pfg.8;
        Wed, 10 Aug 2022 08:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=6MxaJVkVqzqq1Kknlzxc81EzIkRTYeOwRhc2SFg8N/c=;
        b=UHSEQt3XIXfznt3a+ubZbeDFz66AINIJwJOLhdv8iQaZ/pSRMV7wThITwBmxC05Fi0
         KKI8ViRUZnWN2KuTrILsThD1VM2522RlvqfVJELqcRjRUicVfOQfC1eBlnF0HgmxorHD
         vl95KCLj2Ar0+XkoQAI+ZGTub8AgH9LzsfIrnQXZnnNWR03KVxsc6Hv+RdwxpxYSByBy
         +dY3DLa7rRuktr93pPg1qRZKRoti9NSbEe6MJ1ahuzweyNR1JyoBmJ2qb3GgDosw2Rui
         mYhGhRIMsnPH3pvNlWCsv3Ohr+xNk7HyIOInDG8mzySuN1pRyzsK15T19wUk14N/rvsi
         Y4NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=6MxaJVkVqzqq1Kknlzxc81EzIkRTYeOwRhc2SFg8N/c=;
        b=sC+tW21JQBPzROLehaHWrXLqIGCKHUMq6H1LkVnWe6lZdzBmNAHRN5u+VHwwlLtWiU
         p431+1EWvUaCUx59iwywGLNzLbixLP5YIUl0qAsAHmuFJoATg+bs81A/vOgKcMXfQYpF
         rC3i1pNOQkXOFBslwLF0u6BRq1/KaXGMNuoKESPJsK0t4ujUZcBHHKvSX6437U/vD6My
         XZg/uiJKTiSM4VqmOZQbXIIvgfMdYywv+/IPxrg4iESbxVm82yB9ER1Momyg/IQfKViX
         l6Cg92Kd44zulHTggigMmdSWALc/stIGwO8z0flW6QHTxC7IQ6WW3mWkqI3opUAuSAQW
         s3Zg==
X-Gm-Message-State: ACgBeo2ODipvAY/v2S/sv/By3cVvt9W+zg5unD9YfiJZa1B0Db5NiDm3
        /4qsFwSsxtEM4scjW2WOYoI=
X-Google-Smtp-Source: AA6agR5ytZN6hdOuMqFW2+9K97jQ/CcpaM1qMww3s46sJZmj8BHJWlMkVC0swgs0Kd2CpWegMFqhmA==
X-Received: by 2002:aa7:88d1:0:b0:52f:8fb8:5ec6 with SMTP id k17-20020aa788d1000000b0052f8fb85ec6mr10316333pff.34.1660144745882;
        Wed, 10 Aug 2022 08:19:05 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id 85-20020a621558000000b0052b6ed5ca40sm2071935pfv.192.2022.08.10.08.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:19:05 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 11/15] bpf: Use bpf_map_kzalloc in arraymap
Date:   Wed, 10 Aug 2022 15:18:36 +0000
Message-Id: <20220810151840.16394-12-laoar.shao@gmail.com>
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

Allocates memory after map creation, then we can use the generic helper
bpf_map_kzalloc() instead of the open-coded kzalloc().

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/arraymap.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 80974c5..3039832 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -1090,20 +1090,20 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
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

