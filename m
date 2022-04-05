Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7B04F3DED
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 22:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386931AbiDEO2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348517AbiDEOV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:21:28 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ACD5B3F3;
        Tue,  5 Apr 2022 06:09:27 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i11so10826478plg.12;
        Tue, 05 Apr 2022 06:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0QWMaI7ktwqgQ1b499WIyw00i54AjU4DzzhQoij8TdI=;
        b=JAzDvU1SuUx7Ba+7M2mroxMU1D6kuD21qFm4hWCXwOIx8PTullbdXmfJ0qoI/JqB8s
         2Ckijg1R5gCUv0sGRlSBBNHasgYr+GQy1FGhanTOEdw79fyw+6n4AE++F5S6JEn+NmFz
         +Md0fyE830qm8HnrN/p8An2D8Gq+DHiJ2JKufm4v8ncYK94+8Pd9D9yghZf8FpOSKawo
         aCcBFpgCu0iYh1SvPuY8w9RQl96kJh+NKziBx1E7yr5prcvAWv57CZimWvJt2pOFbhaL
         SrX31kV/Y2Qp0y5eZPu+sIcb9Wg+IMWgiye1WgoYRjP2WY1+KfziCNTZaodoJFTSwyDh
         qEqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0QWMaI7ktwqgQ1b499WIyw00i54AjU4DzzhQoij8TdI=;
        b=0OHWK+NkQao+SEHMYXdhN8ZcO8OYgDcZ7gt7Ov3mh0JLlCSbutZNSOKwd10r5MmNZV
         GcFFPb5gayWLsh9jPEPrqRi1wivadc0ZMXmpZtT/6oFa5LOdwwYLM5LJ8G+FQwuX6TFq
         FZHQRBo42mWaSLD9ME9l6kSmH+FXEGt1cUfvOHA3iPBnQU6HHtBLVl0NcLfC14T3W20I
         LqFahryE1OF8l9JU9yjrsXT2jjBMInbZq+rch0s/ORJjUjb51PP1lKXr7USg0Q4fAaSj
         PTfKBuR8j+sKgtmMWlwkd0VE8KIwU7FxKO5tEPTsJMBTtKNPmRyJl4wGvHYg6UDCN+w3
         4few==
X-Gm-Message-State: AOAM533fudWFQ4n+16dS6fhdB5NaMpbZ+ARKITVAy38rTm8iVbbGkEpb
        IT+pRPU3fF6UygIzlrWLWsQ=
X-Google-Smtp-Source: ABdhPJwDFY5iXB+uk99Hao2I9M70rbX8/JFQb6RVxPzIR9h5GuCKSibwwZOano0NEoZtRrQTHIfVjA==
X-Received: by 2002:a17:902:70cc:b0:154:1cc8:9df8 with SMTP id l12-20020a17090270cc00b001541cc89df8mr3395036plt.32.1649164166857;
        Tue, 05 Apr 2022 06:09:26 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:26 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 09/27] bpf: selftests: Set libbpf 1.0 API mode explicitly in test_lru_map
Date:   Tue,  5 Apr 2022 13:08:40 +0000
Message-Id: <20220405130858.12165-10-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220405130858.12165-1-laoar.shao@gmail.com>
References: <20220405130858.12165-1-laoar.shao@gmail.com>
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

Let's set libbpf 1.0 API mode explicitly, then we can get rid of the
included bpf_rlimit.h.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/test_lru_map.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_lru_map.c b/tools/testing/selftests/bpf/test_lru_map.c
index 563bbe18c172..a6aa2d121955 100644
--- a/tools/testing/selftests/bpf/test_lru_map.c
+++ b/tools/testing/selftests/bpf/test_lru_map.c
@@ -18,7 +18,6 @@
 #include <bpf/libbpf.h>
 
 #include "bpf_util.h"
-#include "bpf_rlimit.h"
 #include "../../../include/linux/filter.h"
 
 #define LOCAL_FREE_TARGET	(128)
@@ -878,6 +877,9 @@ int main(int argc, char **argv)
 	assert(nr_cpus != -1);
 	printf("nr_cpus:%d\n\n", nr_cpus);
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	for (f = 0; f < ARRAY_SIZE(map_flags); f++) {
 		unsigned int tgt_free = (map_flags[f] & BPF_F_NO_COMMON_LRU) ?
 			PERCPU_FREE_TARGET : LOCAL_FREE_TARGET;
-- 
2.17.1

