Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A67EA715D9
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 12:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388943AbfGWKPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 06:15:51 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:50923 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388924AbfGWKPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 06:15:51 -0400
Received: by mail-pl1-f202.google.com with SMTP id d6so21674066pls.17
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 03:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=h7dsUuY4XgkJrRpU//tPdbDW3VQMrwX3cEPK49aoW3k=;
        b=A6zgmMm9WbUycg22ml8plJHz5SO7tE5NzLs68G+UB7ZBg8EEC6XfiQ8P8xB9wnOYVm
         RlpA7V9i8lJv+cLpVgCe4fC/h1Q/gr50/RTnLWyfs7a872TsHqE4JXFpSy/iem7u2O76
         utYfJjJbXuFbYB45hgszstotN3ptHtRIhHd7vDy63kqb7FTk3bFUU5Vy9fpHGWdGq22l
         /AeySlzvSSBd0AR9D+8zidJK4Lsr4lADoYNKZ5VRxq9Y6K1GYNB/n8sxkHQOJZQ3sMif
         em6H1Ia98Uv/5RjfZcreyhdDwLv+bO1a8MVG593Di2QXNdV1n1PMoevvdLP9ExhiY3Vg
         jDVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=h7dsUuY4XgkJrRpU//tPdbDW3VQMrwX3cEPK49aoW3k=;
        b=dDFjg3c9GW8MonhgY3Wjk+mxV6dg87+rJfFo1txR4iQtzrIVkNMVlKWtZ1lV3Hb7lI
         ys3dzEOl/zPK9ZfhCcOOL1ENJ2PL0gY6CxetPYmXZCb6Rvfe3eDp0zyybwAUu8MNKhpz
         aFQdtUqUXIZD7FJdzK5tRFVHWcPRZJRSoEebgaFbUMQiU6R3xfquOMrr2H6oGKhgnQ6f
         yLh8csw6YQGxWEFSoBWPlMI8E8+FwhGWZGB0YaoJpxQ2nUZy/DrOQldkPbexE3EJtyE8
         FqYTa0bKVUHRfRBQ+8NUaCaBFneNGtPHhCfWaLIX2g3dCYY/4K+qbEM7SixRPUysDHUL
         7Yvg==
X-Gm-Message-State: APjAAAWYod5gC4HCVdkpMYiLFgldO0gemiMijes0KjBMDUNhOAt88VV/
        g3RE2D8EBF5sHWsPP29LKYsXSOczhJy5iQ==
X-Google-Smtp-Source: APXvYqwvjeWio7ylwSxyvRjLzjXom8IC9uRyVyoj/Wm7PsJSHz4Kg6ZGjXpcFwuZrM+qkvTQWaIV8V4sbongvA==
X-Received: by 2002:a63:b555:: with SMTP id u21mr77094873pgo.222.1563876950294;
 Tue, 23 Jul 2019 03:15:50 -0700 (PDT)
Date:   Tue, 23 Jul 2019 03:15:38 -0700
In-Reply-To: <20190723101538.136328-1-edumazet@google.com>
Message-Id: <20190723101538.136328-3-edumazet@google.com>
Mime-Version: 1.0
References: <20190723101538.136328-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf 2/2] selftests/bpf: add another gso_segs access
From:   Eric Dumazet <edumazet@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stanislav Fomichev <sdf@google.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use BPF_REG_1 for source and destination of gso_segs read,
to exercise "bpf: fix access to skb_shared_info->gso_segs" fix.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Suggested-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/verifier/ctx_skb.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/ctx_skb.c b/tools/testing/selftests/bpf/verifier/ctx_skb.c
index b0fda2877119c4af08277bd0f329f238c193313c..d438193804b212ffa80c94be47e8c1aca392181e 100644
--- a/tools/testing/selftests/bpf/verifier/ctx_skb.c
+++ b/tools/testing/selftests/bpf/verifier/ctx_skb.c
@@ -974,6 +974,17 @@
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
 },
+{
+	"read gso_segs from CGROUP_SKB",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1,
+		    offsetof(struct __sk_buff, gso_segs)),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+},
 {
 	"write gso_segs from CGROUP_SKB",
 	.insns = {
-- 
2.22.0.657.g960e92d24f-goog

