Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DDA52F694
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354184AbiEUAJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbiEUAJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:09:46 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43087185CBA;
        Fri, 20 May 2022 17:09:45 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id b5so1528178plx.10;
        Fri, 20 May 2022 17:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=151EddftrZhDh/91EEBfNEmgh9HiWO/wmSjB/1IWmjE=;
        b=ig3G1TzM6niiGVY07X0kHudPr79o1wawS3OA/WLkBYr0EsIn/SDBQXrJ7/JpLiq5FR
         8USOXfzloV+gyi18NFVqxGo881D6v4hgPiF9PMK2/PR3uAu1iFlvoD4qhgxRkILWkyTO
         hzi2JqSWgJZAULroVYLlhtjVrWA9skKuY5lCK7e5t0YtjBDKoX91Aq4NPNRccJPGVTMm
         ia4IX0cmw82iHhKxuIoSm0KzqCahYhL2Aate0Ur6TXdfyYy+d7jyI1fZzuU/lRx5l/72
         i57snCE9AcY4zI8hvQC92lbOM9HjCDJxVT0lFxnC75W95e/Q/PzbFXjHN15WT/E0MLBv
         U1eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=151EddftrZhDh/91EEBfNEmgh9HiWO/wmSjB/1IWmjE=;
        b=sZrQqMckMNgTa1eXP6KXVhsRXypgmoblEQ1jol/3U1oaX1IPTCSLS1f0giyfv+lGGT
         dlcF1jx/NU8bUPzDGuL+X0P3tKPJmA6jTIZiR/Jr00/vEaumNT++09MGZuvD/kqX8/le
         pKLY42xAPJEltWPLKhRRazKDRcGEOr8/sYXNquveJNh1wbW4sGDqyOS1pn4ma1n5noFW
         btuL+GkYpZcIS/C0J/fX5kpymbAtTK0bNVyCjR1UkRx07r362fmg6SwMVeE4yWsQdQ54
         mNkIL3uUrFJiHM9OWtyhW4Eq9rTMyOq9kASyINsTTaF8tPNUtQzQqJUm3mbsm8L7tTMW
         Sqyg==
X-Gm-Message-State: AOAM531EiGCjMCMN5XAX2Hq9N499BQ+gdr5HiwZqOT1ytXOAdqSe58st
        exWZ9VA0UNG0D9YuRMPyB/Q=
X-Google-Smtp-Source: ABdhPJzZJ3PXUYOpDYTH6V6GmF0cwwSxNlLIOFvnW/QjRfyKPcOXubaaKYKiFlU1lyQwakZgPiZgag==
X-Received: by 2002:a17:90b:4c0f:b0:1e0:237:d3f6 with SMTP id na15-20020a17090b4c0f00b001e00237d3f6mr4308905pjb.166.1653091784723;
        Fri, 20 May 2022 17:09:44 -0700 (PDT)
Received: from ubuntu.localdomain ([116.21.69.15])
        by smtp.gmail.com with ESMTPSA id nm11-20020a17090b19cb00b001df40d766e9sm2475956pjb.21.2022.05.20.17.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 17:09:44 -0700 (PDT)
From:   Ruijian Li <ruijian63@gmail.com>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, 798073189@qq.com,
        Ruijian Li <ruijian63@gmail.com>
Subject: [PATCH] samples: fix compile failure error
Date:   Sat, 21 May 2022 08:09:21 +0800
Message-Id: <20220521000921.8337-1-ruijian63@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because compile samples/bpf/test_lru_dist failure, I remove the
declaration of the struct list_head.

Signed-off-by: Ruijian Li <ruijian63@gmail.com>
---
 samples/bpf/test_lru_dist.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/samples/bpf/test_lru_dist.c b/samples/bpf/test_lru_dist.c
index 75e877853596..dd7eb470653b 100644
--- a/samples/bpf/test_lru_dist.c
+++ b/samples/bpf/test_lru_dist.c
@@ -33,10 +33,6 @@ static int nr_cpus;
 static unsigned long long *dist_keys;
 static unsigned int dist_key_counts;
 
-struct list_head {
-	struct list_head *next, *prev;
-};
-
 static inline void INIT_LIST_HEAD(struct list_head *list)
 {
 	list->next = list;
-- 
2.32.0

