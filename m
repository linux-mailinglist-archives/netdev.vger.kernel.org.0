Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145EC4F4503
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387037AbiDEO3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357698AbiDEOVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:21:41 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729B765829;
        Tue,  5 Apr 2022 06:09:37 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 66so3469197pga.12;
        Tue, 05 Apr 2022 06:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HwfAmtlVeNYd7QbsYC6nROtylv9YSVQYwmwmdUZZ8Rs=;
        b=j+QytNFqV4vq4d2/XSNBOq/JJuFOSkeK1WQMynhK244DrfgEYwVY+T7oT5sbuFn1hV
         6vChEcoZJe5Cwc6JgEXIdb48zVLFffU74j6fQmIrE0md9lfk+a8SyYR/YZ371Z58Gtna
         qanNzYmrFBfPAajSZl4qOB1ds7kPk6JZ/3EXPktTy9/5I1JgFYZLKBRDjTEWteQoTRe6
         Ddl+CS3/fsA85mFaPqxUSXUj+YPtaAx+Ncs1G2u7x6jYFhQ6GMipr/r4bBzy0d8JJh0/
         YxrmlIOUwPv5PluU4np4jvWVN4vOtrZT2Yp1/QW0UVh8a2+jbzGYiTXVZqrAR+3N1rfc
         yrxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HwfAmtlVeNYd7QbsYC6nROtylv9YSVQYwmwmdUZZ8Rs=;
        b=0dsNkKqdDIJbjkPCam5XEU/WBV20egvbxZhAXhbfr/9ADSaStyA99TvoB5K8WNDLQD
         lbFg9xihSRmpA840sID/0qlKJOl3g4/oNpw7raMDYANCxEeq8b3jznsfQ6CCKnldtPyd
         jyfmhn6vwgGdqINiQjAQYxFxdMQXo2q5eY525f2P4DiN4LtwgtHTtPHSaGIm0mmyld7S
         mNDXivZNSjRj935c3tLyJCcWx11zEyk1GqOGPR/Y17pWEgFXobF3nvlkENC7cMjv0rrC
         g9deYFbMEX9fxutaDhCZdkhbZO4HEjhCACq90IweA7JBXBSANMqwq2qtCZOu6w3g8m+X
         UyOw==
X-Gm-Message-State: AOAM533J5RH9JaICbGlBQDaYvLvxCew5QeVv2zVlpbpNrloG+ee1SB6C
        ZtQtDiPhOUaR4VLcsZuNxbQ=
X-Google-Smtp-Source: ABdhPJzuHF4VRlwLbhNo7qxMxYx526dQ8lsh4I6fo9aSsXX0js1F3aQ1wqUu1OcvnCklXWUyY36CrA==
X-Received: by 2002:a63:4c24:0:b0:382:29dc:3345 with SMTP id z36-20020a634c24000000b0038229dc3345mr2841926pga.296.1649164176935;
        Tue, 05 Apr 2022 06:09:36 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:36 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 17/27] bpf: selftests: Set libbpf 1.0 API mode explicitly in test_verifier_log
Date:   Tue,  5 Apr 2022 13:08:48 +0000
Message-Id: <20220405130858.12165-18-laoar.shao@gmail.com>
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
 tools/testing/selftests/bpf/test_verifier_log.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier_log.c b/tools/testing/selftests/bpf/test_verifier_log.c
index 8d6918c3b4a2..70feda97cee5 100644
--- a/tools/testing/selftests/bpf/test_verifier_log.c
+++ b/tools/testing/selftests/bpf/test_verifier_log.c
@@ -11,8 +11,6 @@
 
 #include <bpf/bpf.h>
 
-#include "bpf_rlimit.h"
-
 #define LOG_SIZE (1 << 20)
 
 #define err(str...)	printf("ERROR: " str)
@@ -141,6 +139,9 @@ int main(int argc, char **argv)
 
 	memset(log, 1, LOG_SIZE);
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	/* Test incorrect attr */
 	printf("Test log_level 0...\n");
 	test_log_bad(log, LOG_SIZE, 0);
-- 
2.17.1

