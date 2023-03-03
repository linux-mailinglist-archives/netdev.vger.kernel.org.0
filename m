Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD036A901F
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 05:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjCCEPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 23:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjCCEPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 23:15:13 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48417231DC;
        Thu,  2 Mar 2023 20:15:07 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id n6so1484165plf.5;
        Thu, 02 Mar 2023 20:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fx3EVGRIn/TYMB1BkVY39eL0Wqyn+diJZShBhQ0x0Ws=;
        b=i9w1wPHrW+qKMkfEXCv3JdWK0UviLYgj5FdNuQRPiw0YuQ1U9WTiO9YAuDblkV8EJ6
         hxp/OIsqCS8hh+uzp2HsR/qKIZ9I/gKRrdp29F87oaw0XDzWRH/i2eTxVt0/WJ5e8B+A
         j6RoX0J6FDiDBOaEpiqK3uP/eYz4kWEP+TlcR5YA0uuVl/rFZVSc8ItY3vUsABLNFq0q
         Kf4lFQ62aCkDDuTBuO5jNHRxFjGdfiU2YaN41Hpp1oTyDuJqmW9W3byBzhzuQ+V6OVvH
         4RI4PEBhlOOgahQWfNOsBnxwnnfmodgjN/xuMeQopA9uu6I5Lj2OZ0fdul92zSPqB/NX
         TV7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fx3EVGRIn/TYMB1BkVY39eL0Wqyn+diJZShBhQ0x0Ws=;
        b=hPg1cOI646h+J5KE21t5Kkd8f85SpCwO/h6oZvHX8yb0pvcFmgeUv8KX0dudJ2hH2S
         1Rog3QsCUny8GX8myYnDo13VzrOidoHNrgaO/+F9zoPh3UbGon/b9H1HvsOx0RIkHTFY
         wCLkXHa9XNBGu7sCDk4K0RAVG8zWv3A3eC0RjVYg84NwGx9+luITt9wPPufixxplRBL0
         q3eo9JCJtd/hwaqyZaWvowePyN9OC682AsW3prJzLlgi7S8OzW8ajfyukqOx6hPONm8z
         nnKzMq9ZuVhRFzeQu/yE7K1nwcP2cNkLcJP5+DMt/5Syt5ZAMyeJBn+Jm+YVU17ixKpB
         ENUw==
X-Gm-Message-State: AO0yUKUM+YRYnAaU8aSIYLxLaH2lgf+FYrNgnTTLvXsaY3HPf9ZyqGho
        hH8AxesAaemY/I9D1zOZ1dM=
X-Google-Smtp-Source: AK7set/26oV16OYRBtCH9hMyIYfpQ0gF5sC1zpE0fdQahk4c8/oQdUPXJTvh4/KkMrLrjPWhkaY4+g==
X-Received: by 2002:a17:90b:224f:b0:237:b121:6711 with SMTP id hk15-20020a17090b224f00b00237b1216711mr297983pjb.3.1677816906700;
        Thu, 02 Mar 2023 20:15:06 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:5ad7])
        by smtp.gmail.com with ESMTPSA id q1-20020a17090a1b0100b0022c0a05229fsm500392pjq.41.2023.03.02.20.15.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Mar 2023 20:15:06 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v5 bpf-next 4/6] selftests/bpf: Add a test case for kptr_rcu.
Date:   Thu,  2 Mar 2023 20:14:44 -0800
Message-Id: <20230303041446.3630-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230303041446.3630-1-alexei.starovoitov@gmail.com>
References: <20230303041446.3630-1-alexei.starovoitov@gmail.com>
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
Acked-by: David Vernet <void@manifault.com>
---
 tools/testing/selftests/bpf/progs/map_kptr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/map_kptr.c b/tools/testing/selftests/bpf/progs/map_kptr.c
index 3fe7cde4cbfd..3903d30217b8 100644
--- a/tools/testing/selftests/bpf/progs/map_kptr.c
+++ b/tools/testing/selftests/bpf/progs/map_kptr.c
@@ -118,6 +118,7 @@ extern struct prog_test_ref_kfunc *bpf_kfunc_call_test_acquire(unsigned long *sp
 extern struct prog_test_ref_kfunc *
 bpf_kfunc_call_test_kptr_get(struct prog_test_ref_kfunc **p, int a, int b) __ksym;
 extern void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p) __ksym;
+void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p) __ksym;
 
 #define WRITE_ONCE(x, val) ((*(volatile typeof(x) *) &(x)) = (val))
 
@@ -147,12 +148,23 @@ static void test_kptr_ref(struct map_value *v)
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
-- 
2.30.2

