Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D536C04D0
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 21:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjCSUac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 16:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjCSUaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 16:30:24 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8871CBC6;
        Sun, 19 Mar 2023 13:30:23 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id h8so10490446plf.10;
        Sun, 19 Mar 2023 13:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679257822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJqxQzStRe3eiUPVrMilfL0RrxY8CZqHpiCfQIgW2D4=;
        b=EIOzqNFGh9MMcdVBJ5qJlYy+qrlbCqAqEJi2abHafrVWjRoWM3Fuz5zwUmkC0BVlWX
         bQdsSWpDTWMLIWpYwBpJW20qnhJzg3gyMyLuIhFjQmF/3jA2yykQ85qtz5ulMOveepBs
         nitkzci1YtgoTKNzU67LDCqEsYUGFz8hTq1ws5/LzqxwkFj2XnwO9v5VQFhbsnWppsFE
         BFw9IarI8+hDwSGUWVBA5s9tTo2PMLSRO3LGHTRDnv/IdteUMepzNw++1MUEGPfHOL27
         DuiWzSGKx6rzBs+VqHi0jRfAuLA8UMHG+8hL0BLN4MyNp/UdSXEIZqV6Uc+dxDRmlfNs
         pAxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679257822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJqxQzStRe3eiUPVrMilfL0RrxY8CZqHpiCfQIgW2D4=;
        b=dSevS98oK+nS/YY5kHgruHBTJKV2SsYkhpEDIZyFgqkx2QLR7YpcdfymbVGmei6l3o
         mmGVX25hsuCv8FPeVjLJDbNs2H0dqux7GmOxrv5AeLaS0uEp1TuQ9YkL8elHwX1MqpY7
         Q90E5ayQchDqQnAi9JDz06f/Jm1QMMhOdWU05Iv5XbutvAmkJdD0rY3Q472UMp2AB3oV
         7Yb04PnRXQpIE3b4xsZSV78vi/U8k7Hvs9co5Q9u44QzLfdMnVIFoEFIOKQcjm8xrqn4
         2Tif3KRKNW04SSLCYefxHEPPEnUxsf2UwhOgo4yw1Ax9U6h3KcupsOTsffkbdeRRf9Ms
         wAxg==
X-Gm-Message-State: AO0yUKVK7C6vPEV8dvwbgC4QDbYvF3akGwULhJZWVAF7UBu5532m/IuH
        Irj7DKQhjeR+pQj/T5yYkj4=
X-Google-Smtp-Source: AK7set/IIfwMXJwwbzbZhkdGmkRhe3ATJwNhUmvD97+L+VYluFbREuxspBdUoHgrkaaL4pQnwwg4IQ==
X-Received: by 2002:a17:902:db08:b0:1a0:6bd4:ea79 with SMTP id m8-20020a170902db0800b001a06bd4ea79mr17287840plx.58.1679257822459;
        Sun, 19 Mar 2023 13:30:22 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:2bcf])
        by smtp.gmail.com with ESMTPSA id ay9-20020a1709028b8900b0019682e27995sm5108993plb.223.2023.03.19.13.30.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Mar 2023 13:30:22 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 2/2] selftest/bpf: Add a test case for ld_imm64 copy logic.
Date:   Sun, 19 Mar 2023 13:30:14 -0700
Message-Id: <20230319203014.55866-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230319203014.55866-1-alexei.starovoitov@gmail.com>
References: <20230319203014.55866-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add a test case to exercise {btf_id, btf_obj_fd} copy logic between ld_imm64 insns.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/progs/test_ksyms_weak.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
index 5f8379aadb29..7003eef0c192 100644
--- a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
@@ -37,7 +37,7 @@ int pass_handler(const void *ctx)
 
 	/* tests existing symbols. */
 	rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, 0);
-	if (rq)
+	if (rq && bpf_ksym_exists(&runqueues))
 		out__existing_typed = rq->cpu;
 	out__existing_typeless = (__u64)&bpf_prog_active;
 
-- 
2.34.1

