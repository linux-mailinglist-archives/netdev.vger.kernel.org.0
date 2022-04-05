Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C894F402D
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238804AbiDEO1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239158AbiDEOUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:20:53 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EA258E46;
        Tue,  5 Apr 2022 06:09:22 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so2628464pjm.0;
        Tue, 05 Apr 2022 06:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mdYdVPAM9TjLW7Qxa7yxcAiGGUheU0V9dPD7DbrjxTA=;
        b=ei4Kh822WYlJNzn+z8zEAd5WjpuxNPJi/lb7utgNIyA8xjzaNmTsyh0xa4F2xT9LMa
         8wC9Pb9+4sx43D57skHv9pMBkT1TG6iTdvkFdc6tZxdwNRKjoQOZUmd9HS7EtMmeUvg7
         0BTfygINdzNsElCCrs4DsNhSbCLP1yw3RHZOnsLo1zHMKvIMnbzDuGSqz+KeN08YvrbI
         Izo08xvxJlk/YZvPmV4dAYaX4MiJ+Gtv/MMqZrpdkMnO23GIczdJYty5ZAPhAF/dYfsP
         tuhfdyUMLq4DBrGepvjXdW+jUEIDlZ25uVsZ1vqiTGzz7usVehML2Uzo/8y8HCK52htX
         vhRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mdYdVPAM9TjLW7Qxa7yxcAiGGUheU0V9dPD7DbrjxTA=;
        b=2eIAIHiKZsvJ6DsOwVAxT5Y3e+8CGgxLPhP3HGn8saR7xupKW3SxulWW1ZVRTnrh+W
         zlpqmREcyD0JtvLdlvqyNT3KtmAUYBnC3At5Beeu5YCvfXwpkGfe72qBAc9DWvyxyNO5
         n3VXnaB5tVZ0oC5HYyCTMdb1GLpO2R1g7D3Uya2FaBUwYko0xjJZJesbMl7TYQZq1CB5
         ug8uM6jQvAgiKmJjrYQKYVKpMjJ8KlUxZ8HpTrkjJUJ43ViW5L6OWWHS+d9QFGTklgZu
         d4fdKWWTmb6oydK7AUXPjRuqYiBSEYwf0gZN6VHRx6oZ3Ow0PAksxayllmGnojKJVTyk
         VHhw==
X-Gm-Message-State: AOAM531J8SXObEuiOcTSwBLGa2QTKH1Y2U7bUzQbtzjYzmWsQGf4rQWg
        /iKcZ5uAq85o6TX6sBPC2O8=
X-Google-Smtp-Source: ABdhPJxFOTSUprEHPohGXe61eZTXc4R9Uiz1QOBijsy8FiDFanzFwWP7mqzoFI1NVN1goXLrFKysRw==
X-Received: by 2002:a17:90a:c70f:b0:1bf:3e2d:6cfa with SMTP id o15-20020a17090ac70f00b001bf3e2d6cfamr4051043pjt.70.1649164161570;
        Tue, 05 Apr 2022 06:09:21 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:20 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 05/27] bpf: selftests: Set libbpf 1.0 API mode explicitly in get_cgroup_id_user
Date:   Tue,  5 Apr 2022 13:08:36 +0000
Message-Id: <20220405130858.12165-6-laoar.shao@gmail.com>
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
 tools/testing/selftests/bpf/get_cgroup_id_user.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/get_cgroup_id_user.c b/tools/testing/selftests/bpf/get_cgroup_id_user.c
index 3a7b82bd9e94..e021cc67dc02 100644
--- a/tools/testing/selftests/bpf/get_cgroup_id_user.c
+++ b/tools/testing/selftests/bpf/get_cgroup_id_user.c
@@ -20,7 +20,6 @@
 
 #include "cgroup_helpers.h"
 #include "testing_helpers.h"
-#include "bpf_rlimit.h"
 
 #define CHECK(condition, tag, format...) ({		\
 	int __ret = !!(condition);			\
@@ -67,6 +66,9 @@ int main(int argc, char **argv)
 	if (CHECK(cgroup_fd < 0, "cgroup_setup_and_join", "err %d errno %d\n", cgroup_fd, errno))
 		return 1;
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	err = bpf_prog_test_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj, &prog_fd);
 	if (CHECK(err, "bpf_prog_test_load", "err %d errno %d\n", err, errno))
 		goto cleanup_cgroup_env;
-- 
2.17.1

