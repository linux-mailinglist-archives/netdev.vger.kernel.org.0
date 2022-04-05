Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1F74F401B
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387070AbiDEO3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351048AbiDEOVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:21:34 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FE9633BD;
        Tue,  5 Apr 2022 06:09:31 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id n6-20020a17090a670600b001caa71a9c4aso2596498pjj.1;
        Tue, 05 Apr 2022 06:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L2Y09Fm29d5V0kooRPYIrgnrM+dN9Kb0W+QMB0HxDog=;
        b=K23t6+RuKE6Vtx/HECQ+PtH02ni9Cx5JzbLS4IIl5J/7REkhS9PlSHaPNF2+KjIrD9
         VhHqZqeTxoMBpwTXMKexW9/rXsbq3L9NE/DooxqburW148ZN1tnjjt1u7vb29hPzJTna
         22OjPWmaKvIv6DldBonyYW1Oj7/qwx4Oj3Fw4NdQm0be1Af2kd/8HvUoWWeQas0jGpIi
         3WtK4qgKtGaK/O1QjPp+NcMdE0Ba58gL+eNDw0enHFTqAq9QcXpOrQlAC5xEvCFTs4Sg
         cWbATxmCj6hceB9SX+spsD12ngF7sy6ZapRjMxaL0pL6fcHP5uMc1V7R6OLf2L/QlPFk
         dPXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L2Y09Fm29d5V0kooRPYIrgnrM+dN9Kb0W+QMB0HxDog=;
        b=LBJnJ5YG7ZC3duG9hsNWW4yCLYD5OjL5n/a+gn4/gG0ZhA1LcwpjJb/KVuq42m1mI3
         jkUUytr91DfN+EGJCufGwfgkuQCTZjtkpi0XRKfBdsz70ManNGEn4Ra4kEm223Ziqqzt
         t6Hp8Ep7MDHgBONCEentSoZYt/EiaDijYYVU4esFms5HheVwVuIiu8dE541CJgFK7h3d
         VnoAQ+8HrkRtmHHA76lR6PrbKuxg6pAq7hREXoZ+FEoSFFlGlVFQOADLHVBomkEtBe8R
         tXUeyQfccbYTyxmIeMrqGounBibzCWcIP8xZ3KlHrtV8kQfPrebuW9RK8ag9qgnPiYkd
         SVww==
X-Gm-Message-State: AOAM5334kamcCwTXXArH4IiCHag6reb6KFRyi86D31MPvlHMvLahVRVq
        3lB+xEEciRrkd0mscYsJtGkPrxzuURuErzJwYYY=
X-Google-Smtp-Source: ABdhPJwKrHuWQtQ5QiMjq8t9byz9ksElkwK5NKETyMFwAs7XhLbmdyasFJktF8YmuqrlPlqBcTToFg==
X-Received: by 2002:a17:903:18d:b0:156:1262:9714 with SMTP id z13-20020a170903018d00b0015612629714mr3550447plg.20.1649164170678;
        Tue, 05 Apr 2022 06:09:30 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:30 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 12/27] bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sock
Date:   Tue,  5 Apr 2022 13:08:43 +0000
Message-Id: <20220405130858.12165-13-laoar.shao@gmail.com>
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
 tools/testing/selftests/bpf/test_sock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_sock.c b/tools/testing/selftests/bpf/test_sock.c
index fe10f8134278..6c4494076bbf 100644
--- a/tools/testing/selftests/bpf/test_sock.c
+++ b/tools/testing/selftests/bpf/test_sock.c
@@ -14,7 +14,6 @@
 
 #include "cgroup_helpers.h"
 #include <bpf/bpf_endian.h>
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 
 #define CG_PATH		"/foo"
@@ -541,6 +540,9 @@ int main(int argc, char **argv)
 	if (cgfd < 0)
 		goto err;
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	if (run_tests(cgfd))
 		goto err;
 
-- 
2.17.1

