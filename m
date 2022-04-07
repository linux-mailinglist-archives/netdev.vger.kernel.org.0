Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112984F83A8
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 17:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343713AbiDGPk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 11:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbiDGPkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 11:40:24 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB64140DA;
        Thu,  7 Apr 2022 08:38:23 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id b2-20020a17090a010200b001cb0c78db57so3415391pjb.2;
        Thu, 07 Apr 2022 08:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zzTG5MA6feUhS90mwYwqW7MNwzm4RaqJqp0A1NIGFwE=;
        b=Hei5w4bIjpEhUh/49pqCy9LJB/75Zbi/vj6XqL+jCjj5f2nLrSqLgdtx/m9jtWyhfL
         irS8XRkaP7aGBNrtBFX+A5P7gSv1p7l8yKxC1CwJjVYXTXktt41WnxVPY8kr41vHYjgv
         eRuzccgeKClRCUC1aLsAY438bqn2c7RCDuTr64hg8zA04WmLvkjmRnN65yuf+GHA2+fZ
         js7nMe610p17kDowokKjN25FUjN10ZMQ2+AuqkK6cw4gNx0nW0yfWwbvr4e2ODhJ1RCK
         6OwPDUIiYqNzemr9KSsHac4FUqNAOHx5gt2Yda+4gJFPYxT46b5slwhL80trQVbQOFs1
         EaKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zzTG5MA6feUhS90mwYwqW7MNwzm4RaqJqp0A1NIGFwE=;
        b=iIiWBBaFnEHZNXQzWgMl6uWCnSm7Ydfbxkv26yh7UWzf5mruktnR9hStTR7E9raAWQ
         OBMpG0cPF/gY+LsVRgjx8/Q6DO9eB46jD2LYxw+PwHy9uHqopraco7EVnn2BV5jhAzaK
         XalEp8GHLf/EEwMx0GcCtjoLnw5cy/lm7WIFJnxVPEfviJtXrPLcHjxWN+JEpLK1evFT
         2stsh/0ciUmeC1A4KUqaOhbmxiFEup72jcOyFUvcLUcvcIy4bK/XpMH+Ld77xy758p47
         xH8RZBW1F4BO64pR/JTdh/koNZvmP4cUIxP2fou3oxEZKe9oUbY/xEKoHVtRmAI1V2hE
         HIRw==
X-Gm-Message-State: AOAM532Q5TImbmwuRF+Rf7zw11SgqvQc/Azkf5h0KIDvzeF5cM0dD9h/
        p2UJ/7+ANuarvUZT/QYGY34=
X-Google-Smtp-Source: ABdhPJy8fWprY4sfgTns16cefNiyWAHEe0UJ/zhCWUr3vx3ZlT8++ew5nxLZqq1Sl8zH7gQmPWG9LA==
X-Received: by 2002:a17:902:ec88:b0:156:b24a:40f with SMTP id x8-20020a170902ec8800b00156b24a040fmr14615682plg.67.1649345902594;
        Thu, 07 Apr 2022 08:38:22 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id p64-20020a622943000000b004fdd5c07d0bsm21094797pfp.63.2022.04.07.08.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 08:38:21 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Hengqi Chen <hengqi.chen@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] selftests/bpf: Fix return value checks in perf_event_stackmap.c
Date:   Thu,  7 Apr 2022 23:38:14 +0800
Message-Id: <20220407153814.104914-1-ytcoode@gmail.com>
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

The bpf_get_stackid() function may also return 0 on success.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 tools/testing/selftests/bpf/progs/perf_event_stackmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/perf_event_stackmap.c b/tools/testing/selftests/bpf/progs/perf_event_stackmap.c
index b3fcb5274ee0..f793280a3238 100644
--- a/tools/testing/selftests/bpf/progs/perf_event_stackmap.c
+++ b/tools/testing/selftests/bpf/progs/perf_event_stackmap.c
@@ -35,10 +35,10 @@ int oncpu(void *ctx)
 	long val;
 
 	val = bpf_get_stackid(ctx, &stackmap, 0);
-	if (val > 0)
+	if (val >= 0)
 		stackid_kernel = 2;
 	val = bpf_get_stackid(ctx, &stackmap, BPF_F_USER_STACK);
-	if (val > 0)
+	if (val >= 0)
 		stackid_user = 2;
 
 	trace = bpf_map_lookup_elem(&stackdata_map, &key);
-- 
2.35.1

