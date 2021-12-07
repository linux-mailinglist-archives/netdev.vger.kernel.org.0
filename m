Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A23646C7E1
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242418AbhLGXCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 18:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhLGXCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 18:02:15 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07A5C061574;
        Tue,  7 Dec 2021 14:58:43 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id o20so1836009eds.10;
        Tue, 07 Dec 2021 14:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c1VlJ5BaDFLU6GKPs+r88gkGEdFhDAcYdlu1RVMEMz8=;
        b=XI2ynPMjMM0f2U7399Q0vhv9PZ9TEyHlYRk8jY4vaJgx/+YF53Hw3q8exx7zqiWB1w
         WvcIMJRZ/QYdEspjx6mGb2t88nQHx51x3ZhagvuI6Ty/3nF2zEGYh77q88p3QPslfDof
         dTt74VriftHwuT4lX6iVMqsx8kl2YMlwDXCfIJXihcnUldVseMh4GtyaarVph2Fhm54I
         olB5LriIRourw7XnaM03X3MiHWGMo4mMg+rKpJXTkykKVLRuAbimH7YdIVrjn5rt2rYy
         QNdTZxHLRxdvfqdjXISFy2j/oBjU1PyI15gjagDO8nm99dteLQ5rgdveU0sIfOJXhYE7
         /U7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c1VlJ5BaDFLU6GKPs+r88gkGEdFhDAcYdlu1RVMEMz8=;
        b=ek6KSuaMjhN3QZJ8LjIYOieD6pY+GhucSd/0NAIgyl3eQX0yodoy4xVHNCN9/7mTGy
         Anqxh6nn/sSG6I80+g4rP3ybG2v8SEbWuASqbCQTLQVy802Kk+xgfBrlLvo6cE26djM3
         QAbtFMWkZkFVIhM+9r9lZlRBjMxfXcFbQEc+PiMgYQKGMCiBMUKZs60OzfVDv6hrjrzj
         aNWpa3lDngfyUCuItyvTI2Y9i4N9Cy6Hh9ZBsxN1N6STc6OVzeCeuJgVjTe2KZkI69O6
         O3m/yxQMJ+2n9n7A2mqDgjEdwpUBc8cVEINTqgt7IqZJZTUokeLV61E7wrVA0jx6wqdE
         kQsw==
X-Gm-Message-State: AOAM533HfMG7ONZ6BDMOx6stZq8gSmyCTY5c7nxm6ohc7oux8hOjrbay
        RAk07R7zMdtGdY6LYkpP9IgSTb2+DC8c/Q==
X-Google-Smtp-Source: ABdhPJzXGZrdiaJsNC6byKR2vVcBfh1OBOmO4o1bCVZA52ygD6Bf/61L5QRNcFao2phZKjrPpv1iVQ==
X-Received: by 2002:a17:907:86a1:: with SMTP id qa33mr2939017ejc.142.1638917922514;
        Tue, 07 Dec 2021 14:58:42 -0800 (PST)
Received: from localhost.localdomain ([2a02:a03f:c062:a800:5f01:482d:95e2:b968])
        by smtp.gmail.com with ESMTPSA id q17sm763554edd.10.2021.12.07.14.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 14:58:42 -0800 (PST)
From:   Mathieu Jadin <mathjadin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Mathieu Jadin <mathjadin@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        linux-kselftest@vger.kernel.org,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Shuah Khan <shuah@kernel.org>, KP Singh <kpsingh@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH bpf-next v2 3/3] selftests/bpf: Improve test tcpbpf_user robustness
Date:   Tue,  7 Dec 2021 23:56:35 +0100
Message-Id: <20211207225635.113904-3-mathjadin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211207225635.113904-1-mathjadin@gmail.com>
References: <20211207225635.113904-1-mathjadin@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1638916174; l=2873; s=20211207; h=from:subject; bh=csM/GdsvGydicVSVF6qxAhH0+IFTIB78Rql0r4MDOVA=; b=oiqiDbULuFbeCim9q1j6+8fPagIfe5GRYXxiFVhg8d39aHWT/9EDXXrssTHkp6coxgxt7aXT+WeR 1uzIsw3/DzYlKuqaq2wavCoXoI8y+FoeXRjGlwOTIqng/af4+ALW
X-Developer-Key: i=mathjadin@gmail.com; a=ed25519; pk=LX0wKHMKZralQziQacrPu4w5BceQsC7CocWV714TPRU=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the test to support any number of supported callback flags.
Provided that BPF_SOCK_OPS_ALL_CB_FLAGS is correctly updated when new
flags are added, left shifting it always leads to a non existing flag.

Signed-off-by: Mathieu Jadin <mathjadin@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c | 4 +++-
 tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c | 9 +++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
index 87923d2865b7..56d007bf4011 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
@@ -12,6 +12,8 @@ static __u32 duration;
 
 static void verify_result(struct tcpbpf_globals *result)
 {
+	__u32 non_existing_flag = (BPF_SOCK_OPS_ALL_CB_FLAGS << 1) &
+				  ~BPF_SOCK_OPS_ALL_CB_FLAGS;
 	__u32 expected_events = ((1 << BPF_SOCK_OPS_TIMEOUT_INIT) |
 				 (1 << BPF_SOCK_OPS_RWND_INIT) |
 				 (1 << BPF_SOCK_OPS_TCP_CONNECT_CB) |
@@ -30,7 +32,7 @@ static void verify_result(struct tcpbpf_globals *result)
 	ASSERT_EQ(result->bytes_acked, 1002, "bytes_acked");
 	ASSERT_EQ(result->data_segs_in, 1, "data_segs_in");
 	ASSERT_EQ(result->data_segs_out, 1, "data_segs_out");
-	ASSERT_EQ(result->bad_cb_test_rv, 0x80, "bad_cb_test_rv");
+	ASSERT_EQ(result->bad_cb_test_rv, non_existing_flag, "bad_cb_test_rv");
 	ASSERT_EQ(result->good_cb_test_rv, 0, "good_cb_test_rv");
 	ASSERT_EQ(result->num_listen, 1, "num_listen");
 
diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
index 3ded05280757..c37ba5940e3d 100644
--- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
@@ -43,6 +43,8 @@ SEC("sockops")
 int bpf_testcb(struct bpf_sock_ops *skops)
 {
 	char header[sizeof(struct ipv6hdr) + sizeof(struct tcphdr)];
+	__u32 non_existing_flag = (BPF_SOCK_OPS_ALL_CB_FLAGS << 1) &
+				  ~BPF_SOCK_OPS_ALL_CB_FLAGS;
 	struct bpf_sock_ops *reuse = skops;
 	struct tcphdr *thdr;
 	int window_clamp = 9216;
@@ -104,8 +106,11 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 		global.window_clamp_client = get_tp_window_clamp(skops);
 		break;
 	case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
-		/* Test failure to set largest cb flag (assumes not defined) */
-		global.bad_cb_test_rv = bpf_sock_ops_cb_flags_set(skops, 0x80);
+		/* Test failure to set largest cb flag
+		 * (assumes that BPF_SOCK_OPS_ALL_CB_FLAGS masks all cb flags)
+		 */
+		global.bad_cb_test_rv = bpf_sock_ops_cb_flags_set(skops,
+							  non_existing_flag);
 		/* Set callback */
 		global.good_cb_test_rv = bpf_sock_ops_cb_flags_set(skops,
 						 BPF_SOCK_OPS_STATE_CB_FLAG);
-- 
2.32.0

