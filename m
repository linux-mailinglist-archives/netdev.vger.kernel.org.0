Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BF84F40A4
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377627AbiDEUEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457758AbiDEQlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:41:11 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F221E43AD6;
        Tue,  5 Apr 2022 09:39:12 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u14so15895pjj.0;
        Tue, 05 Apr 2022 09:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h0Ezkowr2vA+TSkiAQHrFqf3CTenq1qGRwHjwra0sLA=;
        b=N4YLCezFpaFlp26K2sW2ESPajZSoXYWOnj+h1n8qRp3nR6g6MBUfk1pfub5qP8x+lK
         rd2p9fxCOawPf2OKJjyz1ET2rwsJmp6GkRVkU6VUmrw6DjqTTNZH4BK3IY/Xs67uAAS/
         Gx6QlAomXXDTJFKvsk53YrF6klSeprkImsmgPaiXY0iH6tBgVgoK17p9g/2XR7hG2wdm
         5zr5q91q4xpKpSid2G5/RCt2mKwS0C9LbpovyzkPC7omWhzHMFEyk2cgy1jBj05JPMor
         yb8AGuP29MFNS5ZE9nTuPfRd+wzl/VXQvszFIfAN4tFXA3sIwqfgASaGq77CGR6tzV+D
         10gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h0Ezkowr2vA+TSkiAQHrFqf3CTenq1qGRwHjwra0sLA=;
        b=lHb+ZHljAjuOCyKniELAiAm+cPIK8v0bVne4XzyBZQxjtSinoesnOi/tut9KtiYBXW
         DDQINbhYMgZED2rQ5VJrY7wTiDy7l5WTbrsK6ZrODFgK9q4QqWH431qxPL0sGPJrdBP4
         wlRZFUP3T+KLT+wihA2wETuH4NG0NnBLfsTxTb30ddFckxp1v1ZI2ev5Ty/fBpEC7iEM
         RBSvKykhlR4nKCuRL/ZSQaEh6prPrfKN9pfi/Z8k6iQpjp7fRRixxF0vpP4GUt4iVczl
         NqYuHWHHsII5sdHjfL1SxkGPQ9DarEj37rppqSwq10SyG42vMc6a7NxaLqmU+7NJgibq
         lq9A==
X-Gm-Message-State: AOAM530R37wQ54MjJxNyyb54Zu/StMOveLmSZE/dwI9rbR8Rns29vDTs
        qaTBCGFVMlHThEHzU+CoIdc=
X-Google-Smtp-Source: ABdhPJxnTEGJd3Tj4Dvmdh+v7GzN2T87vgpt31Bse4ScpzbbZRyF/5EVLbAhrn40PriKpj4xSVy/4g==
X-Received: by 2002:a17:902:728f:b0:156:24d3:ae1a with SMTP id d15-20020a170902728f00b0015624d3ae1amr4336617pll.9.1649176752483;
        Tue, 05 Apr 2022 09:39:12 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6664d26eesm17079538pfk.88.2022.04.05.09.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 09:39:11 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] selftests/bpf: Remove redundant checks in get_stack_print_output()
Date:   Wed,  6 Apr 2022 00:37:28 +0800
Message-Id: <20220405163728.56471-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
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

The checks preceding CHECK macro are redundant, remove them.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
index 16048978a1ef..5f2ab720dabd 100644
--- a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
+++ b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
@@ -76,10 +76,8 @@ static void get_stack_print_output(void *ctx, int cpu, void *data, __u32 size)
 			good_user_stack = true;
 	}
 
-	if (!good_kern_stack)
-	    CHECK(!good_kern_stack, "kern_stack", "corrupted kernel stack\n");
-	if (!good_user_stack)
-	    CHECK(!good_user_stack, "user_stack", "corrupted user stack\n");
+	CHECK(!good_kern_stack, "kern_stack", "corrupted kernel stack\n");
+	CHECK(!good_user_stack, "user_stack", "corrupted user stack\n");
 }
 
 void test_get_stack_raw_tp(void)
-- 
2.35.1

