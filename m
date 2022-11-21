Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12D7631DAA
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 11:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiKUKFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 05:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiKUKFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 05:05:32 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD5E1EEFB
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 02:05:31 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id x66so2276482pfx.3
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 02:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DLMic936L+1Pgc9hkq1LkhKXSGmGTY48SaSYNQvk+VM=;
        b=L+6f/hrU1z5P+sLWCo34hi6NqsmMoQKDczpLVwl5sH/t6gyP1vPq2QpGbP1C+GaCSX
         5nQmZTHXDLjz9BHyMWUvxIeseWujVyilfIkaImUTR2gptzY5HjBaEV4WDjnBOirU+TgS
         aFXJZDqdcp97x+0ducTO3IuJneG56ahuSP/GbuLsQv6iKRCs10ZOpb+9cAvGgJ6+jwcr
         Ct/8Nzk+NbomaI845b2ZvSGUhjxrvEqK8lFz28wxi+5XhIIFOxSu9p1SV/JOBy7Q3KLS
         kv/r0sEhE4cv+z4z2Q9caILKB/n1ewKvqmozpbNcrUTKtG/DDMJHfM/yVpmlsdTZdlBg
         oFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DLMic936L+1Pgc9hkq1LkhKXSGmGTY48SaSYNQvk+VM=;
        b=rLQpUe++LdmSUCuHrQ3wxG4bgIPD4coI09IG4+LsK/LTEy8DmV3GLFQZ/wEN+a04td
         g0Ya7pIMJZivTa2CkkDd/Us4AL1KzJzH8mjothnVMtX2ILfwQT+awX9GG8R1OWzAItVT
         MhcT4GBVpypmosTLMceHN9BgONJ2TQMamtTwdy8cD3GDXTz+/IMLgFCEl/QvjDwz9VgH
         IFTG/eLqL9Ei1nrTC0il5YDGSZ7c6WoxkHUK6qCjLs8Xy2khF9f970+eMXqQGhXJh7E8
         c53HVGNRy1Jnech4n98q/1SmBoP8TBH3Ooqs3tltvoqJM6rbF5vyN85WBPPbvyEgo74F
         qHAQ==
X-Gm-Message-State: ANoB5pkF+WTH2O0mzDIndh2mtfwxVT0/4o1t2J3uew7w6FYx5TJWb0pi
        HlGkND7WV4pw08qb2ljDMGZHiBrmnDE=
X-Google-Smtp-Source: AA0mqf7gXYuwW+60fgGv1gQc1MZYwOzMvA6ViuNhz5u5s2d1ThTEmuLg5gU6FGkicVcC+ej8ZjMrCQ==
X-Received: by 2002:a63:5343:0:b0:452:8774:d5ab with SMTP id t3-20020a635343000000b004528774d5abmr2994993pgl.74.1669025130233;
        Mon, 21 Nov 2022 02:05:30 -0800 (PST)
Received: from localhost.localdomain ([111.201.148.85])
        by smtp.gmail.com with ESMTPSA id p29-20020aa79e9d000000b005625ef68eecsm8337264pfq.31.2022.11.21.02.05.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Nov 2022 02:05:29 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [net-next] bpf: avoid the multi checking
Date:   Mon, 21 Nov 2022 18:05:20 +0800
Message-Id: <20221121100521.56601-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

.map_alloc_check checked bpf_attr::max_entries, and if bpf_attr::max_entries
== 0, return -EINVAL. bpf_htab::n_buckets will not be 0, while -E2BIG is not
appropriate.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 kernel/bpf/hashtab.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 50d254cd0709..22855d6ff6d3 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -500,9 +500,10 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 		htab->elem_size += round_up(htab->map.value_size, 8);
 
 	err = -E2BIG;
-	/* prevent zero size kmalloc and check for u32 overflow */
-	if (htab->n_buckets == 0 ||
-	    htab->n_buckets > U32_MAX / sizeof(struct bucket))
+	/* avoid zero size and u32 overflow kmalloc.
+	 * bpf_attr::max_entries checked in .map_alloc_check().
+	 */
+	if (htab->n_buckets > U32_MAX / sizeof(struct bucket))
 		goto free_htab;
 
 	err = -ENOMEM;
-- 
2.27.0

