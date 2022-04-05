Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9154F4227
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386961AbiDEO2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348156AbiDEOV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:21:28 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD4F5E140;
        Tue,  5 Apr 2022 06:09:28 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so2457745pjn.3;
        Tue, 05 Apr 2022 06:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ojdq5hCe+Ff89I9gzCCUuEsGhOpt1Z2owUKFgeBBDOY=;
        b=MsExKOlsvFLx+nq1kH9kbpTWOWS7TDvo/9pkoV0AYgXnRNbH5zKC/q5k17K2LVW4Xu
         hjesXtGCVzruZEc4Hy0kH0FueS4Ywb4F2xma38555JMEI7S30E/S2HdVcEDXHyUKiT+d
         r/bN1XTZakzdUGtaaxqpZLGOcqqeIMRf5tuDnozL7VfEuPl+dxs/BDCq366qxbZh/Rz/
         YwwF04UrMrSUgk27aK+uzYVI0n9vj4HlvGmBP5FILX1furAhmS0Tkz6ie6kKOuK4H4I9
         Iaj4I+Y4qgPMWXvuv/TuPUiMCVH61sd9Z7ijDQx8EF81druuXnQf1s56Ktu2CBHhbtaa
         Q7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ojdq5hCe+Ff89I9gzCCUuEsGhOpt1Z2owUKFgeBBDOY=;
        b=TPppcKqvLrkzLu8wqke25CFo7SzHvjL9D95gEW1jVULNOOfzDpMwD06hgtwiyHn09r
         3orkTMI0ZyLDHpL/dxqmNDTO42Z2JdDt3qNpwdgkTDRgzD7TZwJG0+8faTWrwQzvYFIu
         /QDHAUvxXJz8ETbv4VzLxPjIH5X63xBjnayG1e6vSlsY6zVmG9OXrnHrleoZELaIMZAG
         z/7xfFs/U0YLm9mhLHXAfb6+K/USEcWYVTpCuqHViWS5vVjx8nfugkiuaInThk5CAOXB
         yLRiHYmLFTcImS3vvBu/3BLjSoN7f245eVSHEhDfnlglRcaYaB1PBcMj1LBnEg8Lqzx2
         ASHA==
X-Gm-Message-State: AOAM5309ks0w6Ks6/0ePrnm6z56JhIOA8p5HhdYK+d0OjhhUwtuB4pGw
        BgE4RPM/QmFTTZHjkNVqHAE=
X-Google-Smtp-Source: ABdhPJwgRST9eWbOh3Ad7gmxuooCNLLgAmaIn7kKUhKt3Abfk4Hch41CBFxlIVJCgTS534TbfmbPiQ==
X-Received: by 2002:a17:902:ce85:b0:156:bf3d:55e8 with SMTP id f5-20020a170902ce8500b00156bf3d55e8mr3462705plg.22.1649164168119;
        Tue, 05 Apr 2022 06:09:28 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:27 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 10/27] bpf: selftests: Set libbpf 1.0 API mode explicitly in test_skb_cgroup_id_user
Date:   Tue,  5 Apr 2022 13:08:41 +0000
Message-Id: <20220405130858.12165-11-laoar.shao@gmail.com>
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
 tools/testing/selftests/bpf/test_skb_cgroup_id_user.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_skb_cgroup_id_user.c b/tools/testing/selftests/bpf/test_skb_cgroup_id_user.c
index 4a64306728ab..3256de30f563 100644
--- a/tools/testing/selftests/bpf/test_skb_cgroup_id_user.c
+++ b/tools/testing/selftests/bpf/test_skb_cgroup_id_user.c
@@ -15,7 +15,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 
 #define CGROUP_PATH		"/skb_cgroup_test"
@@ -160,6 +159,9 @@ int main(int argc, char **argv)
 		exit(EXIT_FAILURE);
 	}
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	cgfd = cgroup_setup_and_join(CGROUP_PATH);
 	if (cgfd < 0)
 		goto err;
-- 
2.17.1

