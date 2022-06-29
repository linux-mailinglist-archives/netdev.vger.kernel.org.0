Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA2156045D
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbiF2PTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233884AbiF2PTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:19:41 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DFA252BE;
        Wed, 29 Jun 2022 08:19:40 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id b12-20020a17090a6acc00b001ec2b181c98so19768510pjm.4;
        Wed, 29 Jun 2022 08:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NCR65AgEN7e8ge6gFaeYgLnI/aL4mIVTifuImi+nxuU=;
        b=qMfCbq33d4ryv+VK2N01vtFa72jjYz0nYz2EAE3ETlJJxWeYplC5Yv/k7ZMwfNXdam
         6O0SP3ZF5j0U6qzqCsqJjnFpJTbUUYn7IYHZlIi5A00e4GfeCdCLXdeU8kGpF5dTMpWX
         2D3POY0dLQ5PrdNZqt369mxc+U/VV4j0MIKyvs2LV1OFFRsQ2tKILcfrGtMIzkahkHu0
         4+laIdJd2IfgCgVA7a/9kmpu48Ixmz3hRhPZP2W6kyr0EDR+3Nrviv/q/TNTpR5hT2ca
         bulkofz0F49kSujm4DeWEWVYMWKfdpGr3KWANwT2cGprEMBh4y8yLQYbs5DEHyOY/U+4
         eCJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NCR65AgEN7e8ge6gFaeYgLnI/aL4mIVTifuImi+nxuU=;
        b=7SAAIjVJ+RT0dC6x8Z3BUuXIEgzn/OZ/GhlO2evEsbSCAW0BZ+18VqksElQ44Rx582
         A/GHySEK+NjOeGF2YWHFSUWnGkMvw/JrpqaXGpJgtXFWlo5Na375ibeGcEmEMVDVDRGH
         0oBjASTFCuct+hDEKb/VueiXh82OCyJfMML1TBLC8kp24+WW6zehgjwj+KkKTaqAKd2J
         ssWLYxIFcyTywQsy9Amt6esboDW0lFLByE44bEigbyx8PRLxAphY8fEgBt6MDAMC5mIN
         eLSHtupfDzp9RCy3UBV/J+HQLdTDUpHhfwiUE5a0q//Ljf63tPONg6AVfUXD/32Fs+Nw
         6Rng==
X-Gm-Message-State: AJIora8iNkbJxGPs0vpInq0tel7co7e4JJ1HLc2M6uDWsCFudF+quM/z
        T94Rmu/hgznPIl3eABfAM8Xk5/cytOPx7A==
X-Google-Smtp-Source: AGRyM1ua3RPK72bxy2NoNyrj6KWzRCCDDeOXPITO7g4kSTv2G1YxGM4YumrKM4dtu5lXu2gNN/Dd1w==
X-Received: by 2002:a17:90a:31c1:b0:1ec:729f:36b7 with SMTP id j1-20020a17090a31c100b001ec729f36b7mr6179995pjf.123.1656515980491;
        Wed, 29 Jun 2022 08:19:40 -0700 (PDT)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id x20-20020a170902b41400b001676dac529asm11522657plr.146.2022.06.29.08.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 08:19:39 -0700 (PDT)
From:   Chuang Wang <nashuiliang@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/3] libbpf: cleanup the legacy uprobe_event on failed add/attach_event()
Date:   Wed, 29 Jun 2022 23:18:47 +0800
Message-Id: <20220629151848.65587-4-nashuiliang@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629151848.65587-1-nashuiliang@gmail.com>
References: <20220629151848.65587-1-nashuiliang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A potential scenario, when an error is returned after
add_uprobe_event_legacy() in perf_event_uprobe_open_legacy(), or
bpf_program__attach_perf_event_opts() in
bpf_program__attach_uprobe_opts() returns an error, the uprobe_event
that was previously created is not cleaned.

So, with this patch, when an error is returned, fix this by adding
remove_uprobe_event_legacy()

Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
---
 tools/lib/bpf/libbpf.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 159b69d8b941..5aa6033a0284 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10240,9 +10240,10 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	}
 	type = determine_uprobe_perf_type_legacy(probe_name, retprobe);
 	if (type < 0) {
+		err = type;
 		pr_warn("failed to determine legacy uprobe event id for %s:0x%zx: %d\n",
-			binary_path, offset, type);
-		return type;
+			binary_path, offset, err);
+		goto err_clean_legacy;
 	}
 
 	memset(&attr, 0, sizeof(attr));
@@ -10257,9 +10258,14 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	if (pfd < 0) {
 		err = -errno;
 		pr_warn("legacy uprobe perf_event_open() failed: %d\n", err);
-		return err;
+		goto err_clean_legacy;
 	}
 	return pfd;
+
+err_clean_legacy:
+	/* Clear the newly added legacy uprobe_event */
+	remove_uprobe_event_legacy(probe_name, retprobe);
+	return err;
 }
 
 /* Return next ELF section of sh_type after scn, or first of that type if scn is NULL. */
@@ -10593,7 +10599,7 @@ bpf_program__attach_uprobe_opts(const struct bpf_program *prog, pid_t pid,
 			prog->name, retprobe ? "uretprobe" : "uprobe",
 			binary_path, func_offset,
 			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
-		goto err_out;
+		goto err_clean_legacy;
 	}
 	if (legacy) {
 		struct bpf_link_perf *perf_link = container_of(link, struct bpf_link_perf, link);
@@ -10603,10 +10609,14 @@ bpf_program__attach_uprobe_opts(const struct bpf_program *prog, pid_t pid,
 		perf_link->legacy_is_retprobe = retprobe;
 	}
 	return link;
+
+err_clean_legacy:
+	if (legacy)
+		remove_uprobe_event_legacy(legacy_probe, retprobe);
+
 err_out:
 	free(legacy_probe);
 	return libbpf_err_ptr(err);
-
 }
 
 /* Format of u[ret]probe section definition supporting auto-attach:
-- 
2.34.1

