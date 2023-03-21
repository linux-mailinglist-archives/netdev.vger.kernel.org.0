Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0E16C29C3
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 06:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjCUFUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 01:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjCUFUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 01:20:16 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABD739BB4;
        Mon, 20 Mar 2023 22:20:12 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id w4so6833557plg.9;
        Mon, 20 Mar 2023 22:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679376012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N2/BbxURZuhrKG/WKWH04ora8blM9R4u1zRqb6oG8i4=;
        b=V5HCzoo5OlsjaLCMadkcHew3Zw1YqEri3mM2XPpb1EVAhet8blJ9GzhaezxHCCL/um
         yyLkbSyYW8KlzSd/ZLYvmBR2rIB97GePyl/SsOQYnklQ+/udEqGegXMmmFFKzRMzWu6+
         XiAfZSfKZnhvylz71Zg1O42XmbpheRdUtHVBU8zVYHaz6lo1KWaNuOdO+fBD79X/5xfG
         xdq2d0iHh3hgn/8zvIGCPOWz6bUrtbQiiuJDrKStsPenpCpV4QJXQZWZBdp2pOVcpnuu
         Fb2JQ7ZtxCSUV6ySTwqqzlNol8m3c1I1tot8g1wiSuVbK5dcdWB8oab0oMxTt0wgwu0Z
         aK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679376012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N2/BbxURZuhrKG/WKWH04ora8blM9R4u1zRqb6oG8i4=;
        b=iabSQQMqH/AEOlsU+BBIqz0qU5SgVA1r2vPIjGY78JZkmnhu7/lBseR/NEle7u47EC
         WAK6p1TF6/9FwyGU/hxDnQwE9oSe/ApKbcA7vcAbXz0tYSBdxuMDCZff/7jMfEi6o8vH
         TZlMr2BJcnIe4m8o4MkJpcTUQfhM1Ovh28/KOCqrEHdEQXdJPWnl56Lj2itsqr68hUiI
         xVYMoQNi5CMTm3emW/004vtY4Ew3t34dMCbwedKIC7FIT3WYU2C+yjqgaqYInDTNDcH6
         MbJiNrkrTivNU5kQeo5QvNAGImtC0CAfLXpViI8jYggD8YjhxEuN9Pd74bhhBh3PJwB/
         kg+Q==
X-Gm-Message-State: AO0yUKVc6yFwfmWZ9cG/ebPdB/VvxYLnV4VzRjf5CcuB1JN3hyKF3AKn
        6BVqS/FLFJnK7l+JCIslBuE=
X-Google-Smtp-Source: AK7set/BipvYLMOB+yrbFBHjiyfDVVEkV5UuJ38qxAeanQ4KGd5a/NRlng2fHdYouwAtXghhzxGUjg==
X-Received: by 2002:a17:90b:3846:b0:23d:4e0e:cf34 with SMTP id nl6-20020a17090b384600b0023d4e0ecf34mr1408526pjb.34.1679376012207;
        Mon, 20 Mar 2023 22:20:12 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:1606])
        by smtp.gmail.com with ESMTPSA id h14-20020a17090acf0e00b0023fda235bb5sm1042900pju.33.2023.03.20.22.20.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Mar 2023 22:20:11 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 4/4] selftests/bpf: Add light skeleton test for kfunc detection.
Date:   Mon, 20 Mar 2023 22:19:51 -0700
Message-Id: <20230321051951.58223-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230321051951.58223-1-alexei.starovoitov@gmail.com>
References: <20230321051951.58223-1-alexei.starovoitov@gmail.com>
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

Add light skeleton test for kfunc detection.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../testing/selftests/bpf/progs/test_ksyms_weak.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

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

