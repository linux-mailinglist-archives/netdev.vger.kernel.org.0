Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0C31F1EF6
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 20:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgFHS14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 14:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgFHS1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 14:27:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA4FC08C5C3
        for <netdev@vger.kernel.org>; Mon,  8 Jun 2020 11:27:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z7so22245599ybn.21
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 11:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fWMhfsU1kpXcRspHEW05AJsH85CBbMas3Sflgg/1rK4=;
        b=WNyNUHdUBzmrvLqCnPSfeWSMk3wOZ7w46VOXGlCosdgePbx29dykt18yWhUOUlsCe7
         6c01ZnNu036dS6UrGDTVMC40XnxX/+TpHdYWkWjlvmvcMsA68QkRmTfNQps5G7GjsCTW
         Lyn/t/HVje04wIRZeDoIbpPAbLzJf3XKWXxX9nePYZ8wCp/obTcT6YGIUXhWxGtfwOmD
         XfJzpl6DFq5SHPj3elyeoj6OlBCzNhRdrFbyOI3lwJIxlrjjqGpWEYCB4dsIEalutl0o
         miS3t+wYkKQMgDmlPazsYswLgLpiczof6W0gTRrPX5iBMu9pPwwRPTMEw3st5hsLVJy6
         BhXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fWMhfsU1kpXcRspHEW05AJsH85CBbMas3Sflgg/1rK4=;
        b=PJ3DdiPVKE06gPgYFxX6qKrv9u86Z9xVeSV/A/LBGJqwglkg+RHHl6Bjcd7dLHi0Cb
         rCI1CqwXyyFvAaS1vYCPon6rFCw4CaDM9ERVXwXD07EQ4WMs1O3duHOHBd2v7qvnIPkl
         1vn2H9d9LM7BJKI0zmmWqqLawLxFfqjLYsrs+fKC0jkoXn9N6yy/S1bQdOW/vyXZ8i5M
         3GiWF3FxVd/DGF/zL/hDNCjAXH0OWifcRMnanzS7z5IclHIQKwdDLVoffWAOve0nuza5
         2M5po6kzSBN/H1/uXE6NJIEudPjxZGS0qFp5cA85myQv8TxnLYP6VVIz7DHn9X+WsY1F
         RgSA==
X-Gm-Message-State: AOAM531EauLwQEic9HrReUST3f3tBPA0u52ERkGRPe1LwznocMjJz1eS
        u3k7HebAVXA/u8I69FkafaoXD2pVQcJMPgi14zkDQJV5eKsqSP2SqwM7W/aHAETt464PpoMbTup
        GyOLHBEM+EQZaUX976MaVclbR7B+w0S/3GjG1r/6IyiQcXQWSiP8HtQ==
X-Google-Smtp-Source: ABdhPJyWpX7e0/irpxfjOj7CUst/B5B69J1pIOPZaSBL8PK0U2fa/cRLDLWGlVQ9RpAtmVTuAvP3TdY=
X-Received: by 2002:a25:eb05:: with SMTP id d5mr132497ybs.12.1591640872209;
 Mon, 08 Jun 2020 11:27:52 -0700 (PDT)
Date:   Mon,  8 Jun 2020 11:27:48 -0700
In-Reply-To: <20200608182748.6998-1-sdf@google.com>
Message-Id: <20200608182748.6998-2-sdf@google.com>
Mime-Version: 1.0
References: <20200608182748.6998-1-sdf@google.com>
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
Subject: [PATCH bpf v3 2/2] selftests/bpf: make sure optvals > PAGE_SIZE are bypassed
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are relying on the fact, that we can pass > sizeof(int) optvals
to the SOL_IP+IP_FREEBIND option (the kernel will take first 4 bytes).
In the BPF program, we return EPERM if optval is greater than optval_end
(implemented via PTR_TO_PACKET/PTR_TO_PACKET_END) and rely on the verifier
to enforce the fact that this data can not be touched.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/sockopt_sk.c     | 26 +++++++++++++++++++
 .../testing/selftests/bpf/progs/sockopt_sk.c  | 20 ++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
index 2061a6beac0f..eae1c8a1fee0 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
@@ -13,6 +13,7 @@ static int getsetsockopt(void)
 		char cc[16]; /* TCP_CA_NAME_MAX */
 	} buf = {};
 	socklen_t optlen;
+	char *big_buf;
 
 	fd = socket(AF_INET, SOCK_STREAM, 0);
 	if (fd < 0) {
@@ -78,6 +79,31 @@ static int getsetsockopt(void)
 		goto err;
 	}
 
+	/* IP_FREEBIND - BPF can't access optval when optlen > PAGE_SIZE */
+
+	optlen = getpagesize() * 2;
+	big_buf = calloc(1, optlen);
+	if (!big_buf) {
+		log_err("Couldn't allocate two pages");
+		goto err;
+	}
+
+	err = setsockopt(fd, SOL_IP, IP_FREEBIND, big_buf, optlen);
+	if (err != 0) {
+		log_err("Failed to call setsockopt, ret=%d", err);
+		free(big_buf);
+		goto err;
+	}
+
+	err = getsockopt(fd, SOL_IP, IP_FREEBIND, big_buf, &optlen);
+	if (err != 0) {
+		log_err("Failed to call getsockopt, ret=%d", err);
+		free(big_buf);
+		goto err;
+	}
+
+	free(big_buf);
+
 	/* SO_SNDBUF is overwritten */
 
 	buf.u32 = 0x01010101;
diff --git a/tools/testing/selftests/bpf/progs/sockopt_sk.c b/tools/testing/selftests/bpf/progs/sockopt_sk.c
index d5a5eeb5fb52..933a2ef9c930 100644
--- a/tools/testing/selftests/bpf/progs/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/progs/sockopt_sk.c
@@ -51,6 +51,16 @@ int _getsockopt(struct bpf_sockopt *ctx)
 		return 1;
 	}
 
+	if (ctx->level == SOL_IP && ctx->optname == IP_FREEBIND) {
+		if (optval > optval_end) {
+			/* For optval > PAGE_SIZE, the actual data
+			 * is not provided.
+			 */
+			return 0; /* EPERM, unexpected data size */
+		}
+		return 1;
+	}
+
 	if (ctx->level != SOL_CUSTOM)
 		return 0; /* EPERM, deny everything except custom level */
 
@@ -112,6 +122,16 @@ int _setsockopt(struct bpf_sockopt *ctx)
 		return 1;
 	}
 
+	if (ctx->level == SOL_IP && ctx->optname == IP_FREEBIND) {
+		if (optval > optval_end) {
+			/* For optval > PAGE_SIZE, the actual data
+			 * is not provided.
+			 */
+			return 0; /* EPERM, unexpected data size */
+		}
+		return 1;
+	}
+
 	if (ctx->level != SOL_CUSTOM)
 		return 0; /* EPERM, deny everything except custom level */
 
-- 
2.27.0.278.ge193c7cf3a9-goog

