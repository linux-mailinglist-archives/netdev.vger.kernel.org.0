Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E694F440D
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382063AbiDEO15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349766AbiDEOV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:21:28 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED455E166;
        Tue,  5 Apr 2022 06:09:29 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso2483076pju.1;
        Tue, 05 Apr 2022 06:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OPrHB+ul5cjXOBXXxlRLC+/NJsyFs7dnp8ZXR8kklU8=;
        b=HS9fU9bmAMuprPxLFCp9p/nRkUYSheUJiWlaC1YBzUkBG3gtt/sjuDpGQcPKunhY5B
         6pvmKAZnTuYh69wPwNk5UNYZvXSjnSbFqUVYI8GUqZEXHZUKvB9HYcVd9+sSoUKUev8b
         abbFbhQz3EZfY5cpwWhDZ0XuDQu22SNddt2QGGo5cB+Mfm1ecXCtYAaD2VD9PEJioLnt
         TGA7ZJrc/74XZ9JhwiZLodxz7zwVuBco6fJ0LWPeewb/f+oO5snBitrq5tUUwYh0U87n
         BLyHpPADmBmbsh2+/8LYZpMcqofjhzK6sAEQ5u2SSSfusiLLbv9cjhwsaonox8yTfH2D
         Q8HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OPrHB+ul5cjXOBXXxlRLC+/NJsyFs7dnp8ZXR8kklU8=;
        b=GZ69WhymEFOC7N+wGqOor1e5fU/woGpJvxxbJyBW7vusrUrAyh5ktra/6hDqKeMTPp
         jwL8kkbQo/v/cyXZrYZKVeIesrFVAIjsdSfh1kyXk8ob+iJfJogTBZNpTZOuxNWNlB3w
         4qbbd4Ke4MG6h9St3EX+SBJ0/Ih0CM3iovnnpFtWjNFCpWnsWf7UhZCc7do+tu7Hojr4
         oiDXZJaNVOY3Mef3N4Iu72ibZ/MA71XxYk2Da0wyDkuuhX1FzfUiNrLZotD1Z9qgVDlj
         mJtegR5PkFKXIJfA+2XxmnAncti7YReBrq4ry1RyA5JdFNd4CGUG6HuJ9VRIqvLjq4/D
         3N4g==
X-Gm-Message-State: AOAM533qAk8pV+2luTzdkx0j9w+rHUZI9KVPBy5IREUgpXU80hltDUvN
        n2+W5d4ixKU4/uyqh8ab06I=
X-Google-Smtp-Source: ABdhPJxPJyrsrCLrL4pVQh9Kroy8fyVk2agrxliG/YO6+wZrwZ0ijCMaMeQyi0HojEkZl7pBT1+DIw==
X-Received: by 2002:a17:903:1cb:b0:156:c35f:7f3c with SMTP id e11-20020a17090301cb00b00156c35f7f3cmr3555209plh.114.1649164169285;
        Tue, 05 Apr 2022 06:09:29 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:28 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 11/27] bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sock_addr
Date:   Tue,  5 Apr 2022 13:08:42 +0000
Message-Id: <20220405130858.12165-12-laoar.shao@gmail.com>
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
 tools/testing/selftests/bpf/test_sock_addr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_sock_addr.c b/tools/testing/selftests/bpf/test_sock_addr.c
index f3d5d7ac6505..458564fcfc82 100644
--- a/tools/testing/selftests/bpf/test_sock_addr.c
+++ b/tools/testing/selftests/bpf/test_sock_addr.c
@@ -19,7 +19,6 @@
 #include <bpf/libbpf.h>
 
 #include "cgroup_helpers.h"
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 
 #ifndef ENOTSUPP
@@ -1418,6 +1417,9 @@ int main(int argc, char **argv)
 	if (cgfd < 0)
 		goto err;
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	if (run_tests(cgfd))
 		goto err;
 
-- 
2.17.1

