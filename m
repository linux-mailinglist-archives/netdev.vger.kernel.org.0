Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54F16C3BF8
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjCUUjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjCUUjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:39:14 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088813B862;
        Tue, 21 Mar 2023 13:39:13 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j13so16678645pjd.1;
        Tue, 21 Mar 2023 13:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679431152;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1UEIRhnXHb5g1AwuHId/YJ7osLPnIlxJC7wYc0DN78=;
        b=SqvILDyJMaoeQZMtIUL+M1zZ4+UaJ6VmtycUIW9HrrFmmWiwcME6LMIrgx6WnUmcbG
         wYB6Ddl0mXexPUPFbDfouKg3sHPW7yZpnNRTupUiGV74hwTJvhrIYtnQS8xnwpab3M0q
         k0esZv4FRUZ4zok8u6879a0ik+6weLBvLs0ie8hhsh50roALisldRT3vNjW29wCBWbPH
         Zn3oyQliMgFQtDfuCM7LWr3qtrTukiicohdyDwWPygt9HH4UEcSXNWm7iKT3Xc/2W9jj
         NnsLuIRo3SduGSkAn8XcelQ/6pRtRm3JGelFn62cF22gt4ymN/fgoZfv3Cb9fNKtCQgY
         vh7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679431152;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k1UEIRhnXHb5g1AwuHId/YJ7osLPnIlxJC7wYc0DN78=;
        b=FTiMOnNwNeCnWmGBnufDYjHeMKmwz9rr0xf7LTahaLn8tVWiintvrnprgF9Gx/1TGU
         WsAmGRweg7XuJDaZqvEOe18W8Qm8UgQ3YNvjQPOGh17dE5rbnpLiMvnASurBiziYxZH8
         WYJF+0T/5WZDdEitsDggbLpY1UAbC4ObPTeEIT6sCMsMzsJM0omC8GLeKI+SWXpFcrUc
         wFYr2BR2TxzOPCD54b66fOhT39W+CRpig2JKak9HMcssjxhcyUIzAW/M/fXZMooKgzer
         xJUv25vUv0y01S91Y24B3KYl1aFWQme9koemdDfcghvxF4nzSUS7rJd04XmcLIQ8n5r+
         as5A==
X-Gm-Message-State: AO0yUKVmlnIHoTYwTnBrV61gu+g+tlHNpgvJWB1FbtyMJ4m464kmi8m7
        PhPJS59bhH+lqrTH98GR6bE=
X-Google-Smtp-Source: AK7set9y+yJop18BlaFCOuiU0uYJQfTZiK4zvMp80+kXaYDccneTX1VjW/r34M4KP+V8aWM/1ybSww==
X-Received: by 2002:a17:902:fb87:b0:1a1:ee8c:eef8 with SMTP id lg7-20020a170902fb8700b001a1ee8ceef8mr352674plb.2.1679431152426;
        Tue, 21 Mar 2023 13:39:12 -0700 (PDT)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:500::5:34cf])
        by smtp.gmail.com with ESMTPSA id n20-20020a170902d0d400b0019e8915b1b5sm9163786pln.105.2023.03.21.13.39.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Mar 2023 13:39:12 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 4/4] selftests/bpf: Add light skeleton test for kfunc detection.
Date:   Tue, 21 Mar 2023 13:38:54 -0700
Message-Id: <20230321203854.3035-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230321203854.3035-1-alexei.starovoitov@gmail.com>
References: <20230321203854.3035-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add light skeleton test for kfunc detection and denylist it for s390.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/DENYLIST.s390x        |  1 +
 .../testing/selftests/bpf/progs/test_ksyms_weak.c | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/tools/testing/selftests/bpf/DENYLIST.s390x b/tools/testing/selftests/bpf/DENYLIST.s390x
index 34cb8b2de8ca..c7463f3ec3c0 100644
--- a/tools/testing/selftests/bpf/DENYLIST.s390x
+++ b/tools/testing/selftests/bpf/DENYLIST.s390x
@@ -11,6 +11,7 @@ get_stack_raw_tp                         # user_stack corrupted user stack
 iters/testmod_seq*                       # s390x doesn't support kfuncs in modules yet
 kprobe_multi_bench_attach                # bpf_program__attach_kprobe_multi_opts unexpected error: -95
 kprobe_multi_test                        # relies on fentry
+ksyms_btf/weak_ksyms*                    # test_ksyms_weak__open_and_load unexpected error: -22                        (kfunc)
 ksyms_module                             # test_ksyms_module__open_and_load unexpected error: -9                       (?)
 ksyms_module_libbpf                      # JIT does not support calling kernel function                                (kfunc)
 ksyms_module_lskel                       # test_ksyms_module_lskel__open_and_load unexpected error: -9                 (?)
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
index 7003eef0c192..d00268c91e19 100644
--- a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
@@ -20,6 +20,8 @@ __u64 out__non_existent_typed = -1;
 /* test existing weak symbols can be resolved. */
 extern const struct rq runqueues __ksym __weak; /* typed */
 extern const void bpf_prog_active __ksym __weak; /* typeless */
+struct task_struct *bpf_task_acquire(struct task_struct *p) __ksym __weak;
+void bpf_testmod_test_mod_kfunc(int i) __ksym __weak;
 
 
 /* non-existent weak symbols. */
@@ -29,6 +31,7 @@ extern const void bpf_link_fops1 __ksym __weak;
 
 /* typed symbols, default to zero. */
 extern const int bpf_link_fops2 __ksym __weak;
+void invalid_kfunc(void) __ksym __weak;
 
 SEC("raw_tp/sys_enter")
 int pass_handler(const void *ctx)
@@ -50,6 +53,18 @@ int pass_handler(const void *ctx)
 	if (&bpf_link_fops2) /* can't happen */
 		out__non_existent_typed = (__u64)bpf_per_cpu_ptr(&bpf_link_fops2, 0);
 
+	if (!bpf_ksym_exists(bpf_task_acquire))
+		/* dead code won't be seen by the verifier */
+		bpf_task_acquire(0);
+
+	if (!bpf_ksym_exists(bpf_testmod_test_mod_kfunc))
+		/* dead code won't be seen by the verifier */
+		bpf_testmod_test_mod_kfunc(0);
+
+	if (bpf_ksym_exists(invalid_kfunc))
+		/* dead code won't be seen by the verifier */
+		invalid_kfunc();
+
 	return 0;
 }
 
-- 
2.34.1

