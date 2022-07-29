Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E7358525E
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbiG2PX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236096AbiG2PXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:23:24 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4A26546;
        Fri, 29 Jul 2022 08:23:23 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id w10so4936154plq.0;
        Fri, 29 Jul 2022 08:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N3x5RniCtfbU9X4ilWg0wCJ6uR/I379+KNtOUGQRQWk=;
        b=MR6BnmL0+/AkdUIl6s2D0Mxj44Qh3mJnK0QhajxPtZyXDzIXOP8IgodIkHLOh5vW6k
         SuFnhXmgAn+NpmxydQlF2a5pCWk8FIX8YEU6Y+G/fLC1y9eUrXvK4FpC11fyEag0y9yj
         4CTFiOMwH/ZcDg0B7spmm3TY3jM0WQG/2GJQVfu5kGbTfSDayJ7G7S62l0lrpHxoAAeL
         v7AujGGF+n4rnR258DMNk7ITHeA9SxF2rVm6UETeCFHXKFIkGunItcwab3EE5t7t1UyL
         93YK/uSh8T5UUYpYYy3f8mynhtlzyPgDz9njO6jiby40lR2jT9ZWCnFNBVw1ZBokfAQC
         eJNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N3x5RniCtfbU9X4ilWg0wCJ6uR/I379+KNtOUGQRQWk=;
        b=OeBJZcqC+Ur5ktFMIwleYOLCYd61hacyIEQWGjrBZkJ8G8rPVMtQJOTa8A3wtnU+Vi
         zWH/n2+L/8GW+K9uXl3arR3Ga7OA+s422HzfKWUy9nbL6xAvlsCUp9/f2iJaDu2GDYvB
         cUvGCRgosWzJf9+f56Fsdyx2+FRiPAgwJ7XYHxmk16uMWB2ZDjdnGyrOBixna+qpS6Uy
         2Q+M7Fz0uEUqcakCuEXCaSEDvaDWJfCNcb+Lf5NhEcNmTzSKF985R9JOuoB8sw0alOI3
         9+iGHG7TrIzVFDO2nEHSw6deNsS1Qq2D8HamOGyW2H5ILhikNrY3gkgTY9LuiDV3eJEs
         rW9g==
X-Gm-Message-State: ACgBeo0MpCU93mNrCaILNhVE5DG97AjxYOiXOkAy8iEPfUZGHcQ7VYxf
        4J+kvuNcS7rUezMwCXdI7GE=
X-Google-Smtp-Source: AA6agR6PxNVeqQc1c9TRKFUa0+QWSa9MU7oMGsj7LktTOarVwJpRJ/ZDTOGpZctMMv5u6/+XFxhhZQ==
X-Received: by 2002:a17:90b:3555:b0:1f3:259b:b8b3 with SMTP id lt21-20020a17090b355500b001f3259bb8b3mr4635942pjb.91.1659108202921;
        Fri, 29 Jul 2022 08:23:22 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:21 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 01/15] bpf: Remove unneeded memset in queue_stack_map creation
Date:   Fri, 29 Jul 2022 15:23:02 +0000
Message-Id: <20220729152316.58205-2-laoar.shao@gmail.com>
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

__GFP_ZERO will clear the memory, so we don't need to memset it.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/queue_stack_maps.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index a1c0794ae49d..8a5e060de63b 100644
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
2.17.1

