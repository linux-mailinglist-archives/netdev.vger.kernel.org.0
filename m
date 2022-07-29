Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F24F58525F
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237261AbiG2PX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237118AbiG2PX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:23:26 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8824D6546;
        Fri, 29 Jul 2022 08:23:25 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id w10so4936254plq.0;
        Fri, 29 Jul 2022 08:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MuUKdiJi+CqUOLmeMIpojQqKJ/GoLF/CYoe+aiGCvRU=;
        b=BcPEkIG2uX/BG29TRtU20AZAJAcDHBvd7n8X2orpJ1VK7LyYrV54t3WLCKQtHI3Lq3
         he6YOMBpMHRqkIk0VFAYSrNUC4idcIZ9FJ/g2LfJ1l+V57Ayoz+Q1kfCtu+hxLHd7Sgx
         bTDpv7nWAe1KvZ0UiIDZ5lWiH+9117MVCBHE4KhQWbqocrYrQReb0elE1OY7Q/BjVrOe
         d2qBc1+2L96iDBwFDEcGJCPqm/WgDBiwOEEKwApxPHrv5VpJV3Zbey/78X+QzmY8UbbY
         tV8j+LKwavkpJ3pfbUdjDsXDGb56sQAR2wh7Z5G9tG7rvqXPJZw72i83w/rqFIrXXzUk
         PktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MuUKdiJi+CqUOLmeMIpojQqKJ/GoLF/CYoe+aiGCvRU=;
        b=X3AouWhOGsEPunFF3sFznNsxlqBOlFrD2uUylrQm+ym9I0Tb5Dq1eL6m6mMUBeKYUW
         ybBQhqFQ6iYs91RzONhSGM6nsPPWtn+gPqg4TcKbznbPe1513ezCgofaosAuRz0zFi/q
         Le+0sv7Ah22H4/uatAwjEiIWjbyDHReSoh+ZRI0TFP8Cw2B5M6s8wvrjDehcdmeUFJAy
         nm5ZBezyyoomlshQGcH8x3scd13w+GGJSt/a2Gd94nFpIGgeo8mnWfwR/6crUa9rmOCz
         pZXxjj+dYgZ/7MOFsUt/gHnlEgwx8dfXRQEQacyw/ucRcDalVWJzV5+W1pnl5H+0/Rio
         Qg3w==
X-Gm-Message-State: ACgBeo1D0lDweLp7AU79ydCWvpANE/xWeqD4N9m8pf6h22zztQEDnXgN
        tBwiSqtz92W21tM9pb+ewjg=
X-Google-Smtp-Source: AA6agR7YfoIlbxo8CLs9bnehGJow8QNgQ5mui++Ey30il7CQd0i1TJbbeANlW79BbP8P9qo95ZBFWw==
X-Received: by 2002:a17:903:28c:b0:16d:cf30:3b71 with SMTP id j12-20020a170903028c00b0016dcf303b71mr4384084plr.165.1659108205120;
        Fri, 29 Jul 2022 08:23:25 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:24 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 02/15] bpf: Use bpf_map_area_free instread of kvfree
Date:   Fri, 29 Jul 2022 15:23:03 +0000
Message-Id: <20220729152316.58205-3-laoar.shao@gmail.com>
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

bpf_map_area_alloc() should be paired with bpf_map_area_free().

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/ringbuf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index ded4faeca192..3fb54feb39d4 100644
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
2.17.1

