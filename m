Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197E758EF14
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbiHJPN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbiHJPNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:13:40 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A038C7647D;
        Wed, 10 Aug 2022 08:13:39 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id w14so14491785plp.9;
        Wed, 10 Aug 2022 08:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=0qneriZlJB8MgUasF3oViKnlhzvyQw+rN/9EeLAKF4M=;
        b=R7MppX/LJp8q0RKutvpSAAyEnnZfDb/hNLpNOu4qcHHLHj3gw8OL83s+M3Rkqt3UG6
         d3OWZ1El3DWSp7LpFOhkqLZ9HSdTkozYp//LR4Gprh2vOVCVrZy1g+bhuBqvksU7hfWT
         WTnP6F/W9d+8wIefTbDFI7FSHePZpN9Kr0YqlInyWXwFXgRCX/cEg/El/s+1dsCjOaLg
         eRYj/tAF7cud45vceu2yUBp6whspLzHGO/kIeeYNVEn5Jdb8KL0i+gsmNeqpDa6Ix5tz
         MExvZtaOY+AXp6jsYsXPWCXlnMg6Dtz+jGt98z8Gejg9mz/UbIethqH0OuhDi+demmSs
         tatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=0qneriZlJB8MgUasF3oViKnlhzvyQw+rN/9EeLAKF4M=;
        b=NPXQZAmRBpE3niv+uiXw8lPvhmlCggUOmgi7cF9+NumnNXg29H8h9uEjAJifJSpb9Q
         1Ti8taM6ockgZsNqq/g72Z3uzwhmohmyWZ6QeS8BIExfnrh0LvDvD6hWZMevi/PnO9CQ
         INh4/sWJT7z1LjbvtYe/p3+nuFGO0yGhaPY7W1XLGMoFdFWZPaonmHtMgb7+GBV5srMC
         I7oRbp83AfnjtitoKfq/Ya8iwNVfhduGuZPRGqKgLbXEfEXI3VtW/ICQ69U0qAZnlla5
         GGn3+Nf0uJkTA8sKxWw6ERLptIHm6B0yvj/F+QE/TN0OXGg0D/uLD4AUa8+5b80jutQi
         0O7Q==
X-Gm-Message-State: ACgBeo2HBalAj6EiM2On444w/MsWEClsiMiJgAHPGquSml3KWbhIkI/t
        dvQuwAsoqd8tYMN2ukRn8i0=
X-Google-Smtp-Source: AA6agR7+Tqvw4GXolynW6mNnDZmfLbkdWXVkZ0+qHlhaNA4u95o9WJMrZ+tYgo7lEet1uyaSfnGkow==
X-Received: by 2002:a17:902:f7c6:b0:16d:c795:d43e with SMTP id h6-20020a170902f7c600b0016dc795d43emr28633657plw.162.1660144419219;
        Wed, 10 Aug 2022 08:13:39 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id n129-20020a622787000000b0052dcbd87ae8sm2118339pfn.25.2022.08.10.08.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:13:38 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 02/15] bpf: Use bpf_map_area_free instread of kvfree
Date:   Wed, 10 Aug 2022 15:13:09 +0000
Message-Id: <20220810151322.16163-3-laoar.shao@gmail.com>
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

