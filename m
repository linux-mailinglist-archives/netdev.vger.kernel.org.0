Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF57758EF12
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiHJPN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbiHJPNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:13:39 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DD47697C;
        Wed, 10 Aug 2022 08:13:37 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id m2so14522368pls.4;
        Wed, 10 Aug 2022 08:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=iWaAjku+9DHBSIX7N6Ue4B+MVNq84IC+6QjMUqI3TB0=;
        b=Z/lxRlLLd8aSOe7UrBVwtoZHysAGXWomvjXyaFiZjFlvg93dIiptrkIXqv7ZwATWu0
         qmjE8r7cc/WvmiTKV+QUmKKhDeZBxCQImUyh6qwf024lOWsEmiD1tW6FuaqxYYp+xzK6
         kTiufGpumO4QQfOIiLh5ufB04SP5x8A1yXYEkUDyvDt3Bbly58OvgpZLhHQMSsZRK+QT
         n43tXwQyR1Lqrc5tp0nA+txpiYYEJqZX/++kbwD6RoUwxLpbAspZf9G0FVsLtgKID2PL
         nOVBKuClxVqbojihSI6uXE8Z8bDAhvPWm2TuwGiLhLqSVzaFHhfj3zVQc8Su3JkZtfvX
         PcUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=iWaAjku+9DHBSIX7N6Ue4B+MVNq84IC+6QjMUqI3TB0=;
        b=g5GocI94GwGBwtmZGtSKjPpCg14ZkD2TzY2c265ZdT45ZyPygiYhr5ZomWLbdO2EKm
         z8NVQPTfNo3mqpxRKUYhzkHX7gL1RAC6TgFDid+fRybD0aGokv91zcimDt3sj3FbtElW
         faJKnFzzWuVobLy272wM6EhlLaDaxHS+1CPolJ2tYKN5+8xnN0D3SR3JyFI9Df6H6o8j
         jdQGJBUXXlB6EdrMWXD/rSlP3Rhs0vUGqA6NLVeHXHHrOCKGMdWg2B/2FeoWEDO4v1Vg
         b7de/1+HdgAKiWoJEvd5sY0O+k/himJufSIc3Zh0jUbUcDJcTy4ro+eW2/NoJo1CR/l4
         fzfw==
X-Gm-Message-State: ACgBeo3BRkjBWOTO8JguYeah+gXnB8RaMWn8UEEdzWW/BtVb/8QSyw4s
        6+Nn5VnMud4eNFoDZRROzPg=
X-Google-Smtp-Source: AA6agR7n6vB1/D/uiMiv2j4fpjbh4qX+3s9kpMgqeuuspi0f2HG/KHRnTeGlLwIId1ZR6ew82E87sA==
X-Received: by 2002:a17:902:c7c4:b0:16e:d968:6343 with SMTP id r4-20020a170902c7c400b0016ed9686343mr28264299pla.133.1660144417101;
        Wed, 10 Aug 2022 08:13:37 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id n129-20020a622787000000b0052dcbd87ae8sm2118339pfn.25.2022.08.10.08.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:13:36 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 01/15] bpf: Remove unneeded memset in queue_stack_map creation
Date:   Wed, 10 Aug 2022 15:13:08 +0000
Message-Id: <20220810151322.16163-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220810151322.16163-1-laoar.shao@gmail.com>
References: <20220810151322.16163-1-laoar.shao@gmail.com>
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

__GFP_ZERO will clear the memory, so we don't need to memset it.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/queue_stack_maps.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index a1c0794..8a5e060 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -78,8 +78,6 @@ static struct bpf_map *queue_stack_map_alloc(union bpf_attr *attr)
 	if (!qs)
 		return ERR_PTR(-ENOMEM);
 
-	memset(qs, 0, sizeof(*qs));
-
 	bpf_map_init_from_attr(&qs->map, attr);
 
 	qs->size = size;
-- 
1.8.3.1

