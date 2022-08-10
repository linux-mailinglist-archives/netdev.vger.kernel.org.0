Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96E558EF26
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbiHJPSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiHJPSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:18:50 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1107858D;
        Wed, 10 Aug 2022 08:18:48 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ha11so15083404pjb.2;
        Wed, 10 Aug 2022 08:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=0qneriZlJB8MgUasF3oViKnlhzvyQw+rN/9EeLAKF4M=;
        b=TgGNLJw+BG2sALPoudkYDLIisbvrlTy7Epjw7sJucu8XOeUAww+Zrw5V/QbGPxzlU7
         6vC7+2w+TOmeVTZFe11FTHUd6TscOL6cLwB9twxvsid65cnQwY8QMvDPU5RlAs5w5HG/
         LDWjih8myCE17+PiotdM4circp79KSLTaDGRicB+ncaRWmUNgnvxzFIj6Omvt/VulW+O
         5GrPcLdp1iuxBHPNCMPXiquLzESc2ppKZzn+UGYo0S2ZK2dwURl1qiO6jYgKilJZCn0r
         bu5f1sV2rCaGn6uVYMsZMOdgjocRuH/r+Cvd4ueX2q8A67notVve/t7FCBdKT6pXOk5s
         t7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=0qneriZlJB8MgUasF3oViKnlhzvyQw+rN/9EeLAKF4M=;
        b=B34/a2qpmWEml27Fa1Qw7RF9+skxXkdqGgBJrm3nVK/jJTUVZecQ0vCcP1lfK1hDsw
         8E7fio1FZ5uUUCt9wSMNaAVBFVIxhoCbaaCshYT9VtQgNw7LSCqwUhbaFjTxy41oU0+E
         EVLMbWA3XxMdCoZXtn5hcSuK/KWFg4mzJHVa4/OXNRQSYkwCGlv12u1bXmSwJQEmv5+U
         lGU7WRAobfHv2gZcXo8c7t1o5Aj01Mzx3ppW+fzEF0SroPt7IPAhKoEpTggoQQH6OG2f
         Tjv2qO8kEcsDIV0GkbYeLx7PRdI0ix72el+NHqAa4sVEZkokOCi/OVC4f00NoqziN/4C
         F1gQ==
X-Gm-Message-State: ACgBeo0GUrr+uMo6CRlZw4jNngEriFqX6MEUIm2maeNA5Z2b1q/t+/2f
        r2nQ9AaOg6z94rQiFfQ8oXg=
X-Google-Smtp-Source: AA6agR4d1Bxd/15ISidjIj+TY1Sb3aM1iWdWnxazQxG6tDo5K9JirOOAXyUItlqAGwtIQ5VXLWdDRg==
X-Received: by 2002:a17:902:7d89:b0:16e:f604:31b8 with SMTP id a9-20020a1709027d8900b0016ef60431b8mr28284781plm.0.1660144727674;
        Wed, 10 Aug 2022 08:18:47 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id 85-20020a621558000000b0052b6ed5ca40sm2071935pfv.192.2022.08.10.08.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:18:46 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 02/15] bpf: Use bpf_map_area_free instread of kvfree
Date:   Wed, 10 Aug 2022 15:18:27 +0000
Message-Id: <20220810151840.16394-3-laoar.shao@gmail.com>
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

bpf_map_area_alloc() should be paired with bpf_map_area_free().

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/ringbuf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index ded4fae..3fb54fe 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -116,7 +116,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
 err_free_pages:
 	for (i = 0; i < nr_pages; i++)
 		__free_page(pages[i]);
-	kvfree(pages);
+	bpf_map_area_free(pages);
 	return NULL;
 }
 
@@ -190,7 +190,7 @@ static void bpf_ringbuf_free(struct bpf_ringbuf *rb)
 	vunmap(rb);
 	for (i = 0; i < nr_pages; i++)
 		__free_page(pages[i]);
-	kvfree(pages);
+	bpf_map_area_free(pages);
 }
 
 static void ringbuf_map_free(struct bpf_map *map)
-- 
1.8.3.1

