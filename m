Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA0469932
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 18:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbfGOQkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 12:40:07 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:57122 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731220AbfGOQkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 12:40:07 -0400
Received: by mail-pf1-f202.google.com with SMTP id x10so10547678pfa.23
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 09:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=H6bBORuIj1kwmH7SjoC1Blq9UOe9iWIewERgafBpFPc=;
        b=qFRhqqQ880p78GtplFEeCJD3yOl85Jw7KwuLUaO4Lgr1rRCHYkSagnvCNQ0wkveeca
         sG8/CWhqJnznA2QKGVUlEyH2xSFPPLS9p/AIhIUiHYwEXKB85rAgtDeU/AzYSDy6f+i3
         jHuv4Cwp3enrZvYC0KlqGfQ1QqCkZEvnTppHGY8YdgvjdnQlHK0uF17mpzzC0adhMaSx
         HbxN/JrZYE1FdL3/rwSGhaxOv0Idtgri5Ruwv/2OIfNmTMTKMcQSCsBmbhc5SeGSo3ry
         JbL0MIjYoqcQW7z21gWE/dLEHJFBM9LzOo6vfKbWnhMLsHzFesQhXUPF22R0nz7j5tfK
         Z4ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=H6bBORuIj1kwmH7SjoC1Blq9UOe9iWIewERgafBpFPc=;
        b=J2llgF88L/lUn/nY+zhg1DjT0r1p3gRBb9lQ6TMdC8qiQXajp7Dk71hhzTVA4bjTSk
         MGb0ibov4fQB8JlGNV2zX0A1zp2Ijx0wQ71vzjIZLvw2FSo6Sr4Qj1CCSm8M3+5ePvG1
         9/TYTgvEy2Y+bTXTqNysRpzYn3ueWCDlFfCDb3rM2SL7D1kRTemZ39UKJkzJavHeeISn
         k00oyXtHLAETeNwhM8qNb3aOK1iJAAiL/o3OO8rVg5KTynOcZ+zUatbfmEbBrjpwFF9v
         su8vgmSH4pjRXrnlnTRgqHU5dGrN6SjzcdpIK+Hsq1bwiJ49YSL45xvJoJ2kGsMDnVzO
         p7FA==
X-Gm-Message-State: APjAAAVZwfGr30AEVmfaxGZjvnDhz2H8Ob907O410GrZR4PDfiNXH4Dz
        y1JLU90GXq5p8Aer5UJ79c8fC4Gl1DJTmldAhLoRAPDHqADOVevvrG0Vfpcbul5gUg20tMC+/+M
        bi3NVBF959dI9IsYA/NwsttNSFuTLLHdBNtBli425QNh6fk/qbvQASQ==
X-Google-Smtp-Source: APXvYqwNGsaC9/c0WXyo61C2WueGhPBhTSKVR1juCwEjc/xyhHoQknfJ+wVY6js5XcG7JQZRgNwiPuc=
X-Received: by 2002:a63:7d49:: with SMTP id m9mr16491132pgn.161.1563208806059;
 Mon, 15 Jul 2019 09:40:06 -0700 (PDT)
Date:   Mon, 15 Jul 2019 09:39:54 -0700
In-Reply-To: <20190715163956.204061-1-sdf@google.com>
Message-Id: <20190715163956.204061-4-sdf@google.com>
Mime-Version: 1.0
References: <20190715163956.204061-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
Subject: [PATCH bpf 3/5] selftests/bpf: rename verifier/wide_store.c to verifier/wide_access.c
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the file and rename internal BPF_SOCK_ADDR define to
BPF_SOCK_ADDR_STORE. This selftest will be extended in the next commit
with the wide loads.

Cc: Yonghong Song <yhs@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/verifier/wide_access.c      | 36 +++++++++++++++++++
 .../selftests/bpf/verifier/wide_store.c       | 36 -------------------
 2 files changed, 36 insertions(+), 36 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/wide_access.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/wide_store.c

diff --git a/tools/testing/selftests/bpf/verifier/wide_access.c b/tools/testing/selftests/bpf/verifier/wide_access.c
new file mode 100644
index 000000000000..3ac97328432f
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/wide_access.c
@@ -0,0 +1,36 @@
+#define BPF_SOCK_ADDR_STORE(field, off, res, err) \
+{ \
+	"wide store to bpf_sock_addr." #field "[" #off "]", \
+	.insns = { \
+	BPF_MOV64_IMM(BPF_REG_0, 1), \
+	BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, \
+		    offsetof(struct bpf_sock_addr, field[off])), \
+	BPF_EXIT_INSN(), \
+	}, \
+	.result = res, \
+	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR, \
+	.expected_attach_type = BPF_CGROUP_UDP6_SENDMSG, \
+	.errstr = err, \
+}
+
+/* user_ip6[0] is u64 aligned */
+BPF_SOCK_ADDR_STORE(user_ip6, 0, ACCEPT,
+		    NULL),
+BPF_SOCK_ADDR_STORE(user_ip6, 1, REJECT,
+		    "invalid bpf_context access off=12 size=8"),
+BPF_SOCK_ADDR_STORE(user_ip6, 2, ACCEPT,
+		    NULL),
+BPF_SOCK_ADDR_STORE(user_ip6, 3, REJECT,
+		    "invalid bpf_context access off=20 size=8"),
+
+/* msg_src_ip6[0] is _not_ u64 aligned */
+BPF_SOCK_ADDR_STORE(msg_src_ip6, 0, REJECT,
+		    "invalid bpf_context access off=44 size=8"),
+BPF_SOCK_ADDR_STORE(msg_src_ip6, 1, ACCEPT,
+		    NULL),
+BPF_SOCK_ADDR_STORE(msg_src_ip6, 2, REJECT,
+		    "invalid bpf_context access off=52 size=8"),
+BPF_SOCK_ADDR_STORE(msg_src_ip6, 3, REJECT,
+		    "invalid bpf_context access off=56 size=8"),
+
+#undef BPF_SOCK_ADDR_STORE
diff --git a/tools/testing/selftests/bpf/verifier/wide_store.c b/tools/testing/selftests/bpf/verifier/wide_store.c
deleted file mode 100644
index 8fe99602ded4..000000000000
--- a/tools/testing/selftests/bpf/verifier/wide_store.c
+++ /dev/null
@@ -1,36 +0,0 @@
-#define BPF_SOCK_ADDR(field, off, res, err) \
-{ \
-	"wide store to bpf_sock_addr." #field "[" #off "]", \
-	.insns = { \
-	BPF_MOV64_IMM(BPF_REG_0, 1), \
-	BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, \
-		    offsetof(struct bpf_sock_addr, field[off])), \
-	BPF_EXIT_INSN(), \
-	}, \
-	.result = res, \
-	.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR, \
-	.expected_attach_type = BPF_CGROUP_UDP6_SENDMSG, \
-	.errstr = err, \
-}
-
-/* user_ip6[0] is u64 aligned */
-BPF_SOCK_ADDR(user_ip6, 0, ACCEPT,
-	      NULL),
-BPF_SOCK_ADDR(user_ip6, 1, REJECT,
-	      "invalid bpf_context access off=12 size=8"),
-BPF_SOCK_ADDR(user_ip6, 2, ACCEPT,
-	      NULL),
-BPF_SOCK_ADDR(user_ip6, 3, REJECT,
-	      "invalid bpf_context access off=20 size=8"),
-
-/* msg_src_ip6[0] is _not_ u64 aligned */
-BPF_SOCK_ADDR(msg_src_ip6, 0, REJECT,
-	      "invalid bpf_context access off=44 size=8"),
-BPF_SOCK_ADDR(msg_src_ip6, 1, ACCEPT,
-	      NULL),
-BPF_SOCK_ADDR(msg_src_ip6, 2, REJECT,
-	      "invalid bpf_context access off=52 size=8"),
-BPF_SOCK_ADDR(msg_src_ip6, 3, REJECT,
-	      "invalid bpf_context access off=56 size=8"),
-
-#undef BPF_SOCK_ADDR
-- 
2.22.0.510.g264f2c817a-goog

