Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A834F418C
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387061AbiDEO3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352519AbiDEOVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:21:37 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E7164BD3;
        Tue,  5 Apr 2022 06:09:33 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id p8so12033952pfh.8;
        Tue, 05 Apr 2022 06:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5ey/uwJZwB1xknO1mgxMdntGJAzx6E5xsfBkexDFEcw=;
        b=ntkHK93gMagP5V5Rt4K7tOhCNW9b4QvJUOsYMNlw6eNa/z+zbH8VVgfSTL8zqKtV3Z
         0f8bhVrHvrfyEkOu7pwyV/2ZqC9XT8Y4y/xYGT3VabIhJcToT4E7ouwy9FkKHKA0yB7V
         udk8QSRPR/i2VkNnFfqk10X3ZUla4TLCjMLzhLRYM9sKv7Hxw86dbPIfpV3DY7PHoIUY
         IYKHYSGrCPkYJItp66obo1YSNv5I2NjFl0bWtdlh4nLgq3//AKv7Xg7zMlcsnazJYywX
         znZGYkb+sG9/6ngSEin6MuKI6Xhe662TUuWh0USyZ9p8/8yytoIaqmqrNSyo1ZPwOsod
         WtQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5ey/uwJZwB1xknO1mgxMdntGJAzx6E5xsfBkexDFEcw=;
        b=5XnsZ6JKP3qwkKnZxZXI6EX6BOmoqJn1n18Cr0I8mEoBWdTshP7v2o8zo0h/g1BiVW
         PiGej84f37AtmDwFuOsayqa8lr6ALUHkDSe2PUMUmh1MPurcBXHX0TSzj8A06bmemj0R
         +3Rh/bdTFQQC5n9FV+qPCteQHkbm0oNCwZ4g5vvzaeWrms6o16zpslNOaPRUNNIdQNyG
         Zys/AFgedoB/IWX1uSkec1PGH+SASQGss14KrQevMlsC9jr1ieehRgoUY3yDppc5ofv9
         Lb0ulzyJw1odSS1qualUxFRmw/Lmc6/AcTMhupaZQL6akBUoKAWXh2sPdKH+FX4QGY1q
         4iPw==
X-Gm-Message-State: AOAM5329p8CJ8SymbbEBtOKIypTnd+yexrjpotPjXV0aYxGmF+SDRGyI
        7JguW+eeH65PuHVJN8jkR3Q=
X-Google-Smtp-Source: ABdhPJxiF9mY2oftt14b6FZeHkuXyFNjDpsmKcSbeICL6JsuLIebzWPie1ain1RZwj9mwyrVzQ5HAw==
X-Received: by 2002:a05:6a00:1706:b0:4fd:af77:62a1 with SMTP id h6-20020a056a00170600b004fdaf7762a1mr3519558pfc.16.1649164173063;
        Tue, 05 Apr 2022 06:09:33 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:32 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 14/27] bpf: selftests: Set libbpf 1.0 API mode explicitly in test_sysctl
Date:   Tue,  5 Apr 2022 13:08:45 +0000
Message-Id: <20220405130858.12165-15-laoar.shao@gmail.com>
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
 tools/testing/selftests/bpf/test_sysctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_sysctl.c b/tools/testing/selftests/bpf/test_sysctl.c
index 4f6cf833b522..5bae25ca19fb 100644
--- a/tools/testing/selftests/bpf/test_sysctl.c
+++ b/tools/testing/selftests/bpf/test_sysctl.c
@@ -14,7 +14,6 @@
 #include <bpf/libbpf.h>
 
 #include <bpf/bpf_endian.h>
-#include "bpf_rlimit.h"
 #include "bpf_util.h"
 #include "cgroup_helpers.h"
 #include "testing_helpers.h"
@@ -1618,6 +1617,9 @@ int main(int argc, char **argv)
 	if (cgfd < 0)
 		goto err;
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	if (run_tests(cgfd))
 		goto err;
 
-- 
2.17.1

