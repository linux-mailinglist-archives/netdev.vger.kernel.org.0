Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447E326656C
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgIKRCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgIKPEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:04:12 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8FCC061368
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 07:31:21 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id i26so14060203ejb.12
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 07:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AifmCwlGQkYNJWlBnZAsy/4oYCtlJh2CI6z+GloOpvw=;
        b=mq0+Z2otTHI4q6BWKiid1j5pubgJEivA198+nK7hLJEC/gmULm+cPFKIChKQ1QIXXT
         VfP69f6jo2c/djHc4Ptm9Vmz9NLArYKToVGHHKzKzYpLIT6v1Xlcfr+zEpNWLebmfasV
         A1V1xIpjsS+9MtmrnQcWeJJTNfPtm44TjzXo2ZmNM94e9OpmE1JnuWO/kAEO1itG+EO/
         r8Nd2bYlLPI2BzGI9BuQpL9OhAx9rOgDDVlQ5Fgp2tNYKo9cR2b5tqHGBIoX54XR1lpH
         Y5aoqaILSDiOPn7a7zj9IB6LIepvIcStRyCkLZRoiqiLpI11U+VfTGIaWKzHgPd/YgT2
         d2Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AifmCwlGQkYNJWlBnZAsy/4oYCtlJh2CI6z+GloOpvw=;
        b=PNv0hacPaXZw67/5d06Z66DoTb1NGRTGQW3XZddnFMHIyzvwpzRcIj85MDJS6GFgx8
         vLMAIqcq4sXx4xIVl7Mw6RHIW62szjFkbmR9tFGPuSyeDwOKH5j3C9sX2+3ZdejTMlT/
         NC4p34Tk1OwN9GRjM7ckNqGaVXcdQzpsY1H2tw8y9uOmphWqH8pM4JQeBE0pz1hsB3aa
         IyYUgUdj2ScZR5j19ngs2wKpZ/MOxAuBbIaxVNwbV6JrtbI6eBTEGUtH4zOGk9FRzF1R
         GWcr1CZOXLGpjX/5q7YU5nHVsZC8h7xvqV5nZCd9jozWo6gzZGrkJFTrtIpBix/ip4Sc
         e8/w==
X-Gm-Message-State: AOAM533KR7Oo0sZ6sosGK+A2277GKQrninn3qrygaIz6P94haeFmZCWG
        pIFx8SEcJVGXjT+3AeyaBeJ5Ag==
X-Google-Smtp-Source: ABdhPJzugQqj4flmudtLUAs/WO1IQQCcBDyfUkw8ekBI2jy8c9MqX9LqDLSC4uGs7wvGyrfUUU2uUA==
X-Received: by 2002:a17:906:4951:: with SMTP id f17mr2295162ejt.29.1599834680288;
        Fri, 11 Sep 2020 07:31:20 -0700 (PDT)
Received: from localhost.localdomain ([87.66.33.240])
        by smtp.gmail.com with ESMTPSA id y21sm1716261eju.46.2020.09.11.07.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 07:31:19 -0700 (PDT)
From:   Nicolas Rybowski <nicolas.rybowski@tessares.net>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Cc:     Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 5/5] bpf: selftests: add bpf_mptcp_sock() verifier tests
Date:   Fri, 11 Sep 2020 16:30:20 +0200
Message-Id: <20200911143022.414783-5-nicolas.rybowski@tessares.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911143022.414783-1-nicolas.rybowski@tessares.net>
References: <20200911143022.414783-1-nicolas.rybowski@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds verifier side tests for the new bpf_mptcp_sock() helper.

Here are the new tests :
- NULL bpf_sock is correctly handled
- We cannot access a field from bpf_mptcp_sock if the latter is NULL
- We can access a field from bpf_mptcp_sock if the latter is not NULL
- We cannot modify a field from bpf_mptcp_sock.

Note that "token" is currently the only field in bpf_mptcp_sock.

Currently, there is no easy way to test the token field since we cannot
get back the mptcp_sock in userspace, this could be a future amelioration.

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
---

Notes:
    v1 -> v2:
    - new patch: mandatory selftests (Alexei)

 tools/testing/selftests/bpf/verifier/sock.c | 63 +++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/sock.c b/tools/testing/selftests/bpf/verifier/sock.c
index b1aac2641498..9ce7c7ec3b5e 100644
--- a/tools/testing/selftests/bpf/verifier/sock.c
+++ b/tools/testing/selftests/bpf/verifier/sock.c
@@ -631,3 +631,66 @@
 	.prog_type = BPF_PROG_TYPE_SK_REUSEPORT,
 	.result = ACCEPT,
 },
+{
+	"bpf_mptcp_sock(skops->sk): no !skops->sk check",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct bpf_sock_ops, sk)),
+	BPF_EMIT_CALL(BPF_FUNC_mptcp_sock),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
+	.result = REJECT,
+	.errstr = "type=sock_or_null expected=sock_common",
+},
+{
+	"bpf_mptcp_sock(skops->sk): no NULL check on ret",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct bpf_sock_ops, sk)),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_EMIT_CALL(BPF_FUNC_mptcp_sock),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_mptcp_sock, token)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
+	.result = REJECT,
+	.errstr = "invalid mem access 'mptcp_sock_or_null'",
+},
+{
+	"bpf_mptcp_sock(skops->sk): msk->token",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct bpf_sock_ops, sk)),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_EMIT_CALL(BPF_FUNC_mptcp_sock),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, offsetof(struct bpf_mptcp_sock, token)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
+	.result = ACCEPT,
+},
+{
+	"bpf_mptcp_sock(skops->sk): msk->token cannot be modified",
+	.insns = {
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_1, offsetof(struct bpf_sock_ops, sk)),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	BPF_EMIT_CALL(BPF_FUNC_mptcp_sock),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_ST_MEM(BPF_W, BPF_REG_0, offsetof(struct bpf_mptcp_sock, token), 0x2a),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
+	.result = REJECT,
+	.errstr = "cannot write into mptcp_sock",
+},
-- 
2.28.0

