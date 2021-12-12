Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B0B471A87
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 14:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhLLN4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 08:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbhLLN4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 08:56:22 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D946C061714;
        Sun, 12 Dec 2021 05:56:22 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id o14so9404296plg.5;
        Sun, 12 Dec 2021 05:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=/gQUbvHkAhzPpWEAlaFTz49oyVa8obtsdC7ymHL+Scc=;
        b=QlcyK7p51i6cmH6vldrRHaYWe/7z/wdWLBZ31Y6Fnfs2U+g7rKBJgvZDV7r4pH/J5+
         b4EGprAxZxSsbkUf81T/azTYLP1Cr9n33WYqi56aU+ojpBIGxc5UgVFF7gDXKHkkavMp
         YmEwhywR4wCchfpsfwh+OQ0Z0mE4dZphlJ7Wq1aKGVyrs8b70bjuEtd2DgrNWrmObW6U
         tnJncEeaZNV6FsI7ZOTyP1z3FEAyeDTTAFbnHJqZoClRBowNeBjKHV8Xf2ownmm8yC/M
         hG+iPS7Jn5nMIpNMcDumlw5OFAqn2mZuSY3rNPNVndouSTdBPNbVf/QMj5P9ZGxsOS+B
         9mjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/gQUbvHkAhzPpWEAlaFTz49oyVa8obtsdC7ymHL+Scc=;
        b=hcCnnmx34vOfUwZJta96fdWXR1AOBTaL32BtBgYJjS51RqLzWU5cWI5o4a3AAlkrxT
         zh5xqdw0ikz85Aajs9rge973lgXPpo1/qrBVIaOM3DoOH1sxOYwdNqhkklM35Vmy8PGY
         msXgJakRRpSU++jw9YuRq2E6BwpuO7dsUuWYhbL6eFkUtIzrBdNUTOiXkz9LYWrA5jkA
         I6gux5LL/kx6eIy0rklL3LRFLDwHu4l3RIhrIspsFAUE8ZBQNOrepnCgPVmp3+UxUIw5
         3CzJ/Y5z1GLXpVwJ9iwzbWrdVK6oBV5ybOKiR9O2M3+Q5eP1ZsRwbUOLIhijpkYd8UGO
         I9mw==
X-Gm-Message-State: AOAM533/uqYs0y1fAxGR6hoi12DuG3lQlS8AC2297W7j0xIT34dAQrhc
        4Dqx0ICoOAhExFZmYNEj6PU=
X-Google-Smtp-Source: ABdhPJwxH8RyIrWI0KeErRauDZVF7CcEaF9YzaKd84AS8nxZoJUUm/P41yvVHXzW4W41ZR3V6gHroQ==
X-Received: by 2002:a17:902:9b95:b0:143:b899:5b12 with SMTP id y21-20020a1709029b9500b00143b8995b12mr87877211plp.13.1639317381565;
        Sun, 12 Dec 2021 05:56:21 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id m24sm7572001pgk.39.2021.12.12.05.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 05:56:21 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
Cc:     linmq006@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] perf tools: Use IS_ERR_OR_NULL() to clean code and fix check
Date:   Sun, 12 Dec 2021 13:56:09 +0000
Message-Id: <20211212135613.20000-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use IS_ERR_OR_NULL() to make the code cleaner.
Also if the priv is NULL, it's improper to call PTR_ERR(priv).

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 tools/perf/util/bpf-loader.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
index fbb3c4057c30..22662fc85cc9 100644
--- a/tools/perf/util/bpf-loader.c
+++ b/tools/perf/util/bpf-loader.c
@@ -421,7 +421,7 @@ preproc_gen_prologue(struct bpf_program *prog, int n,
 	size_t prologue_cnt = 0;
 	int i, err;
 
-	if (IS_ERR(priv) || !priv || priv->is_tp)
+	if (IS_ERR_OR_NULL(priv) || priv->is_tp)
 		goto errout;
 
 	pev = &priv->pev;
@@ -570,7 +570,7 @@ static int hook_load_preprocessor(struct bpf_program *prog)
 	bool need_prologue = false;
 	int err, i;
 
-	if (IS_ERR(priv) || !priv) {
+	if (IS_ERR_OR_NULL(priv)) {
 		pr_debug("Internal error when hook preprocessor\n");
 		return -BPF_LOADER_ERRNO__INTERNAL;
 	}
@@ -642,8 +642,11 @@ int bpf__probe(struct bpf_object *obj)
 			goto out;
 
 		priv = bpf_program__priv(prog);
-		if (IS_ERR(priv) || !priv) {
-			err = PTR_ERR(priv);
+		if (IS_ERR_OR_NULL(priv)) {
+			if (!priv)
+				err = -BPF_LOADER_ERRNO__INTERNAL;
+			else
+				err = PTR_ERR(priv);
 			goto out;
 		}
 
@@ -693,7 +696,7 @@ int bpf__unprobe(struct bpf_object *obj)
 		struct bpf_prog_priv *priv = bpf_program__priv(prog);
 		int i;
 
-		if (IS_ERR(priv) || !priv || priv->is_tp)
+		if (IS_ERR_OR_NULL(priv) || priv->is_tp)
 			continue;
 
 		for (i = 0; i < priv->pev.ntevs; i++) {
@@ -751,7 +754,7 @@ int bpf__foreach_event(struct bpf_object *obj,
 		struct perf_probe_event *pev;
 		int i, fd;
 
-		if (IS_ERR(priv) || !priv) {
+		if (IS_ERR_OR_NULL(priv)) {
 			pr_debug("bpf: failed to get private field\n");
 			return -BPF_LOADER_ERRNO__INTERNAL;
 		}
-- 
2.17.1

