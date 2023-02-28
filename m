Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587BF6A522D
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 05:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjB1ECJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 23:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjB1EBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 23:01:43 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537A81E1D1;
        Mon, 27 Feb 2023 20:01:42 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id x34so8452809pjj.0;
        Mon, 27 Feb 2023 20:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vd6BXE5EwemrMSCH/AKnGIUoT0QacaJ1L4SeqU6i2Ys=;
        b=Sn3UzTs3ZmpoLLz8LdO5XPNKtFdvFtzNE1WH8SEELC/Uy4QIfabgifrCfG5wgZO5Ej
         Voq5NXf54U0T91kmKrx74HKgvjkLesq45qFK8GEDyjwS5fP32ztNjYMIt65fGvCGwQwH
         wlzHYP0ojC5idwkNJIzoeFnzWI7kMDNRnuNKw/O2hdz7AgDiZMzCfnwciewxfNn3zCxO
         km5YPjOYoY30L4icHaVD2YhJUz48E2OgFqCGhfgFsGc7/kbXhmDDZUv2TBsWR6vQMiDQ
         uDfLyygU8G4mkNsB/t1P43lWO7bLlHPohzZCtusb5CehqsJN8d4rXcsUGLRa7L/+I5N/
         T2CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vd6BXE5EwemrMSCH/AKnGIUoT0QacaJ1L4SeqU6i2Ys=;
        b=VAzbALynGH1Glcc8MlSUrCH1vvW/ynIJvhcdln8KHM7/YnuxdRxTSKwjYoCQlZr1Ca
         eARpmUaMpjOq4kpWNgQOx33dEptpZj4reLutJ/8MQj7HWQVmugpql3VV3PkpIjwQxerb
         diYSO84IlYDf/QDy4nGeQqfE7ePD+ilG0l5kBlRdYLf1ztJlYIFJz0+hyyoz9j1uWwsm
         X+vuUhBPaUjRhDE3szxcIzXbCdMkTtCddcUujpXUhZdDlN06peioBON3ZKcTyQhtZmeH
         s0DPDsApQeJr9XZWMR9my5AfYRX0C+xvbhlJW7mbP0M8fl1JPO9nIqGlm5RUYl/k5+fa
         aR4Q==
X-Gm-Message-State: AO0yUKXaaFEvrN7Dw39wtGnrr5fmA5Tu8TQBUuwqgTOsGbWV1Ly/7o/M
        Q9rySikUwHlhA5RMQGOkqB8=
X-Google-Smtp-Source: AK7set8tF+gh5OLC79syWPu2IFz49UXO1ieoFyWTDk9H0QLb+7FwcbzUXMuD+qAkRtuhQEmaTig5vg==
X-Received: by 2002:a05:6a20:3d88:b0:cd:1808:87c7 with SMTP id s8-20020a056a203d8800b000cd180887c7mr1962745pzi.15.1677556901757;
        Mon, 27 Feb 2023 20:01:41 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:6245])
        by smtp.gmail.com with ESMTPSA id m26-20020a056a00165a00b0058dbb5c5038sm4943230pfc.182.2023.02.27.20.01.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 27 Feb 2023 20:01:41 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v3 bpf-next 4/5] selftests/bpf: Add a test case for kptr_rcu.
Date:   Mon, 27 Feb 2023 20:01:20 -0800
Message-Id: <20230228040121.94253-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
References: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
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

Tweak existing map_kptr test to check kptr_rcu.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/progs/map_kptr.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/map_kptr.c b/tools/testing/selftests/bpf/progs/map_kptr.c
index 4a7da6cb5800..b041234ec68d 100644
--- a/tools/testing/selftests/bpf/progs/map_kptr.c
+++ b/tools/testing/selftests/bpf/progs/map_kptr.c
@@ -61,6 +61,7 @@ extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp
 extern struct prog_test_ref_kfunc *
 bpf_kfunc_call_test_kptr_get(struct prog_test_ref_kfunc **p, int a, int b) __ksym;
 extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
+void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p) __ksym;
 
 #define WRITE_ONCE(x, val) ((*(volatile typeof(x) *) &(x)) = (val))
 
@@ -90,12 +91,23 @@ static void test_kptr_ref(struct map_value *v)
 	WRITE_ONCE(v->unref_ptr, p);
 	if (!p)
 		return;
+	/*
+	 * p is rcu_ptr_prog_test_ref_kfunc,
+	 * because bpf prog is non-sleepable and runs in RCU CS.
+	 * p can be passed to kfunc that requires KF_RCU.
+	 */
+	bpf_kfunc_call_test_ref(p);
 	if (p->a + p->b > 100)
 		return;
 	/* store NULL */
 	p = bpf_kptr_xchg(&v->ref_ptr, NULL);
 	if (!p)
 		return;
+	/*
+	 * p is trusted_ptr_prog_test_ref_kfunc.
+	 * p can be passed to kfunc that requires KF_RCU.
+	 */
+	bpf_kfunc_call_test_ref(p);
 	if (p->a + p->b > 100) {
 		bpf_kfunc_call_test_release(p);
 		return;
@@ -288,6 +300,8 @@ int test_map_kptr_ref2(struct __sk_buff *ctx)
 	if (p_st->cnt.refs.counter != 2)
 		return 6;
 
+	/* p_st is MEM_RCU, because we're in RCU CS */
+	bpf_kfunc_call_test_ref(p_st);
 	return 0;
 }
 
-- 
2.30.2

