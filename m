Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8135985FE
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245345AbiHROcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245474AbiHROcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:32:08 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC81FBA159;
        Thu, 18 Aug 2022 07:32:02 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d10so1655704plr.6;
        Thu, 18 Aug 2022 07:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=6MxaJVkVqzqq1Kknlzxc81EzIkRTYeOwRhc2SFg8N/c=;
        b=UwVG/VSP0500nvEMvFgAFhuzl7jOoNgmsUjHA03AL7Loq4gte3g3tEw92bhEq4R3/I
         9BO87zC4T+n1Isqcj6XWQaRGJh9dVeNMeVJHqNXReWmH1FFppfSnTUWTSsii0f4j8Mrf
         fGspLs9apHqZWT6hmOW66VERvD64fONYTuCqCPRfLJttOt8GaR/XXzexgSDul6/v8Qzc
         1s22qNFwBX3yTFKyIH6vIVN7bV7rvuxaShBZH4Xkp/O0XDbckHuH/goksJJndgMlSnA/
         0RjflanMCjl9/cLUXSUkd7M15JXVuotakDNoBl5I76iaQJTxRzCgDXb1/eXTG13AGKqP
         3ThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=6MxaJVkVqzqq1Kknlzxc81EzIkRTYeOwRhc2SFg8N/c=;
        b=xkRObyv/gn7UTGXxmVbiLEFwegModuHx+s2s9HvHyZtrptBekNPp64SuWgFxsJaG+1
         dTyWUmbXS60SS/XMhk6eTuxEXtb2Syd6QwmUlfYuM6pxycvExchzu+75+PImv8gf7RUt
         YKnGo0iCxqcRCtWASdm+yTuI9mzQhPjpWQ+6LuT779cZEnljn9WZTZTTV5NFB2edZZUH
         v/Uk8ZgNOBTL3UfjhepuahdYdCG+OE76B6bqL8u00wpq7JhA9d69w2r+m+ebHH66+rb3
         B+dI0kTX3xZs2qSemk3XO6n0RB0KOWZ4EwQYx9YCxEyyIbA15mwS05tijwplA/LoBWbD
         uE4A==
X-Gm-Message-State: ACgBeo3MZ8YwBItAM7qdcRAQ9FUhDEGbpIgtoPjqZX1nq+HSMow/1jQ/
        itfj2KZfePuYbpmmEb8jowEPp6ea4VgOBWbp
X-Google-Smtp-Source: AA6agR72M8P6pJtUCoBgO4ikpegsRLjp2RJjn9maPzCVOcuC6aNzZXvVy3iAP3lFIy0mTaP+56rrqQ==
X-Received: by 2002:a17:902:8e8c:b0:171:2a36:e390 with SMTP id bg12-20020a1709028e8c00b001712a36e390mr3080551plb.77.1660833122298;
        Thu, 18 Aug 2022 07:32:02 -0700 (PDT)
Received: from vultr.guest ([45.32.72.237])
        by smtp.gmail.com with ESMTPSA id h5-20020a63f905000000b003fdc16f5de2sm1379124pgi.15.2022.08.18.07.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 07:32:01 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 08/12] bpf: Use bpf_map_kzalloc in arraymap
Date:   Thu, 18 Aug 2022 14:31:14 +0000
Message-Id: <20220818143118.17733-9-laoar.shao@gmail.com>
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

