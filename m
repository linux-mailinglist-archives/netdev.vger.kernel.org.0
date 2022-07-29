Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CC558526F
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbiG2PYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237474AbiG2PYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:24:00 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B458985FAB;
        Fri, 29 Jul 2022 08:23:40 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t2so4911741ply.2;
        Fri, 29 Jul 2022 08:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/QlHQZkaHYaQUqr8wiHtqQx5hHw1sh9z9adPB7Jsz2k=;
        b=lvJP+1FG/ePBYe0WKUD8cI1RjJ3OLvTLP05nfMyRIXF9Cn5hW4SsClBM2ZTxhdhyfB
         VS+tbTDnauOxdE9A1b+U/wKrsxMm0JUSfjMQ4OA7ReBBgDPNlXNXM/4Exj46MrO6U2Qq
         eY+YxM/Dme8BG0xRfuw5ibtuq5M3bLSS6EQpip4wui5yyZk7p9sdOIa1gMhLu3jthyIV
         EE4K9ni/8hThPsbrOO+blVLo2ShKZpLSqE2i7c0Irm39kaiXJudhoRJRkOEQUBD8FCsU
         qKmoWH6ZmEaZWXbCwGh/RmnkYwg38/zFJ9PX38EE1F0XpJrJc9vnUIPcHcCtJZoBWkos
         VIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/QlHQZkaHYaQUqr8wiHtqQx5hHw1sh9z9adPB7Jsz2k=;
        b=GS1yO6zR6ZBvLmyrcWBF+tfWb78+tYYaHlPRqVrSG9AJQj9yz/R3dUvb+HyPdy42SZ
         evv0nuO3miYY5HhOYkZ3LhyuflbnoY2nJB9DEDfja8CqylEe/fPJNQl9j1H67lXS+seU
         eYglEdBd2KQn36WBkAiI7BCQrdDfsx4QUvoEs9uAivUJ24Zmh4hZA8KkrWfmp2mcFCYW
         rKPIyZ0KmGtfhGZWvtf4DzKbXCMTKgo3TwN3o+7s5t7KgJtKSK13I/HuhMRtnkS/PjCM
         BKQ7ZuONfO30RKrOCiMqumZSISykqyS0PiSO28YV8sQSaNM7jAVQ6B8Sla0aPlPLjRGT
         7A7Q==
X-Gm-Message-State: ACgBeo0+jvNmb209ZJnGxYSYOkGTMXhr9piqLGGolPE7s+L4kjcLIIXg
        0CZD4wECHiRA/qd9ngrJ9XM=
X-Google-Smtp-Source: AA6agR5CclJJZ7kgrC33kQLUVREUZ4UgNBzC2JWzJideJc20Jf2HFETAMi58PCicfJv3XCN7cAM58g==
X-Received: by 2002:a17:903:2343:b0:16c:1efe:1fe0 with SMTP id c3-20020a170903234300b0016c1efe1fe0mr4542669plh.106.1659108220144;
        Fri, 29 Jul 2022 08:23:40 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:39 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 09/15] bpf: Use bpf_map_kzalloc in arraymap
Date:   Fri, 29 Jul 2022 15:23:10 +0000
Message-Id: <20220729152316.58205-10-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220729152316.58205-1-laoar.shao@gmail.com>
References: <20220729152316.58205-1-laoar.shao@gmail.com>
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
index 9517619dbe8d..bfcfc5df9983 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -1093,20 +1093,20 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
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
2.17.1

