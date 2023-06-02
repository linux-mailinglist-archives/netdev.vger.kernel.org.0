Return-Path: <netdev+bounces-7318-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EB3F71FA7D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:01:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F3462815B9
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A53246AA;
	Fri,  2 Jun 2023 07:01:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2053D6D;
	Fri,  2 Jun 2023 07:01:26 +0000 (UTC)
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC2C18D;
	Fri,  2 Jun 2023 00:01:09 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 41be03b00d2f7-53f9a376f3eso1558164a12.0;
        Fri, 02 Jun 2023 00:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685689269; x=1688281269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZnG52d2Dc9v7SzDlLP9SHsRobLYh/Fr6zYq50STRQGE=;
        b=I+xCs901C/zEpAM2hx4qv5g3BCXtFOxN/KhotSi7GKPxdlyKQgmDGMoJPqDgSEmufL
         8C5/wuewZpjMI+8sadDOjVVMxxB/tugR9dzs6rQYdLN1bq/7kuXt5VUjJz7xni/VyuEz
         jVgNSbKs7e5i1Jg4iFAwm1rPoP2mAPoH17mcvjaTZqAftdzv6aZ3bjUcuLSON4yNjUpx
         JifOW/fzMZhFnQ0bWCd4tkkv5KnyeCMiJ3P4lxWw4QmRkFeI94dVxdZ4r3JrnaYO2K1e
         oG+9bdnKUBct1IWHXisqiiO6MTXEzS30p+EOMdjgbfr+Fz8WFc8eJLjY641VF7PZojjg
         WxTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685689269; x=1688281269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZnG52d2Dc9v7SzDlLP9SHsRobLYh/Fr6zYq50STRQGE=;
        b=Nwv20pJSI43HXKXhltOhfqHcukMYgMTyENL+fmaX0jtIjUTE4jbfscGtopP4BNfyJ/
         UFJ869zkwUPG8qMxVqQHDj+rUtjf72bs8dLxmQ43fsrbYdmh0+oWJeTn8HVZRgZ+dL1t
         Shd+CGI7Z8PtaeQIAG0CpEJfEA5xr5J3UTW+u7lrbC8qPwJQVQtwdj5rvivHQU5hb0mZ
         jKOszVfQGzqNcYfNwmDbB3T8693mb0mZD3zztyQ0PwqZyTQm/BB0WPa5MBd/7GRO9JNr
         1rPr36UB6YLuHudlr2LUzlBbwDtxsHbPNX0Irj7Rd/g85ZMgxu5B7/G8DJbyaf+vIuFT
         KgFQ==
X-Gm-Message-State: AC+VfDyZWFkuGrBMHI1Hczwgn7GkbohDtY3wMpWmvTlYaLJIw8s0RxcO
	VRzBU6efp02CF0647HbCNig=
X-Google-Smtp-Source: ACHHUZ6jTUPbQ8booJg0HcNCVWgN0R74kwYWjIkCH9W7pLwScUj7HdcQpJCgkgA3sCxUlp7PqE545A==
X-Received: by 2002:a17:902:d485:b0:1b1:8e8b:7f6a with SMTP id c5-20020a170902d48500b001b18e8b7f6amr1661443plg.27.1685689269110;
        Fri, 02 Jun 2023 00:01:09 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id jk11-20020a170903330b00b001ac7c725c1asm572716plb.6.2023.06.02.00.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 00:01:08 -0700 (PDT)
From: menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To: olsajiri@gmail.com
Cc: davem@davemloft.net,
	dsahern@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	song@kernel.org,
	yhs@fb.com,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	jolsa@kernel.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	mykolal@fb.com,
	shuah@kernel.org,
	benbjiang@tencent.com,
	iii@linux.ibm.com,
	imagedong@tencent.com,
	xukuohai@huawei.com,
	chantr4@gmail.com,
	zwisler@google.com,
	eddyz87@gmail.com,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v2 1/5] bpf: make MAX_BPF_FUNC_ARGS 14
Date: Fri,  2 Jun 2023 14:59:54 +0800
Message-Id: <20230602065958.2869555-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230602065958.2869555-1-imagedong@tencent.com>
References: <20230602065958.2869555-1-imagedong@tencent.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Menglong Dong <imagedong@tencent.com>

According to the current kernel version, below is a statistics of the
function arguments count:

argument count | FUNC_PROTO count
7              | 367
8              | 196
9              | 71
10             | 43
11             | 22
12             | 10
13             | 15
14             | 4
15             | 0
16             | 1

It's hard to statisics the function count, so I use FUNC_PROTO in the btf
of vmlinux instead. The function with 16 arguments is ZSTD_buildCTable(),
which I think can be ignored.

Therefore, let's make the maximum of function arguments count 14. It used
to be 12, but it seems that there is no harm to make it big enough.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/bpf.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f58895830ada..8b997779faf7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -961,10 +961,10 @@ enum bpf_cgroup_storage_type {
 
 #define MAX_BPF_CGROUP_STORAGE_TYPE __BPF_CGROUP_STORAGE_MAX
 
-/* The longest tracepoint has 12 args.
- * See include/trace/bpf_probe.h
+/* The maximun number of the kernel function arguments.
+ * Let's make it 14, for now.
  */
-#define MAX_BPF_FUNC_ARGS 12
+#define MAX_BPF_FUNC_ARGS 14
 
 /* The maximum number of arguments passed through registers
  * a single function may have.
@@ -2273,7 +2273,8 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 static inline bool bpf_tracing_ctx_access(int off, int size,
 					  enum bpf_access_type type)
 {
-	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
+	/* "+1" here is for FEXIT return value. */
+	if (off < 0 || off >= sizeof(__u64) * (MAX_BPF_FUNC_ARGS + 1))
 		return false;
 	if (type != BPF_READ)
 		return false;
-- 
2.40.1


