Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BE754AC7D
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 10:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355725AbiFNIuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 04:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355486AbiFNIuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 04:50:04 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD3643EFB;
        Tue, 14 Jun 2022 01:50:00 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g10-20020a17090a708a00b001ea8aadd42bso8489139pjk.0;
        Tue, 14 Jun 2022 01:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8Ddvsni7SZUlV7IwHtn1fL03u3KMw5Zi9EmHvYFfjdo=;
        b=dZzPMmBVxZPixpOfUVjpJSD2S0j74d0VGTJ1I3QkGLHkWaarrHVNY/YhDFiJVb7x9v
         OaiCZKpx/mCxUQceQhnYpF1KDZud+Y+KMxi3/TgDpl+YxYq91jWwUorzMpUJc5LfwfxL
         G6ykl5xhD3iMs31e9GghGZt0IpSSyuK5tZ3SakPkOlC3i1VJQWr+OLa4w7Q7l9Zf8lx7
         cAimDLwgolLaUJzeYrWFacuGGWWRjpOZPlNooRcUygOVLFMjsgPFLwJNOTQ82Z3yHJep
         k1NrIT2TfbQbSThhSBTlBGRTR5bsYr2TqXxTSmjvAE4cjGQl/aePFcu7aCxDYQgG9WVj
         2Bsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8Ddvsni7SZUlV7IwHtn1fL03u3KMw5Zi9EmHvYFfjdo=;
        b=FzeOAH2Lpnpru9t07iNLgR0Hgkyp6Q7RgEBY00uo1+BzyK9gV7FVOBzBqX5ZarCU1I
         ptB2xUF2qLgope7PlJWRvL+nfHGdkm9dh1O3edxNL8Ill7uuSk0MnsDBxUK1eMjE6g4L
         9OYSips6tyI1VNFIP48wqMjbMS4b9+aa51Eb34+KtaXxmU5DKmRDqzauqR+c65qsY9bS
         s0/7ap+9qpB2fkFAdcpp8WPiZnD2I6cyWCU9LYMWbN58Xao1847cigqMkj0l8lWfKGaF
         DmnAbEQTCxOsy8aTW6odIjOpMq9Xf6uy1s5j/VCu7SO5saygzwA76UsKFQ+aRm5Dpt/W
         Snkw==
X-Gm-Message-State: AOAM530EsqEJG4tVeR3+GiNWrLOfT84+cdmn04uvRpBjbeStEEcUbJKL
        vAIrAv5xAblYDR6/StEMmbqCKEvwBnfS6g==
X-Google-Smtp-Source: AGRyM1vw+SPWJ82YEoJ0AFk0NArNWxwueMYF2jKq/fwa6elGx0eEnoarMHhQGf1E42D4OPwtRBM0IA==
X-Received: by 2002:a17:903:28c:b0:167:6127:ed99 with SMTP id j12-20020a170903028c00b001676127ed99mr3361504plr.94.1655196599581;
        Tue, 14 Jun 2022 01:49:59 -0700 (PDT)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902f78200b001617541c94fsm6659913pln.60.2022.06.14.01.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 01:49:58 -0700 (PDT)
From:   Chuang W <nashuiliang@gmail.com>
Cc:     Chuang W <nashuiliang@gmail.com>,
        Jingren Zhou <zhoujingren@didiglobal.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libbpf: Remove kprobe_event on failed kprobe_open_legacy
Date:   Tue, 14 Jun 2022 16:49:30 +0800
Message-Id: <20220614084930.43276-1-nashuiliang@gmail.com>
X-Mailer: git-send-email 2.25.1
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

In a scenario where livepatch and aggrprobe coexist, the creating
kprobe_event using tracefs API will succeed, a trace event (e.g.
/debugfs/tracing/events/kprobe/XX) will exist, but perf_event_open()
will return an error.

Signed-off-by: Chuang W <nashuiliang@gmail.com>
Signed-off-by: Jingren Zhou <zhoujingren@didiglobal.com>
---
 tools/lib/bpf/libbpf.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0781fae58a06..d0a36350e22a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10809,10 +10809,11 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
 	}
 	type = determine_kprobe_perf_type_legacy(probe_name, retprobe);
 	if (type < 0) {
+		err = type;
 		pr_warn("failed to determine legacy kprobe event id for '%s+0x%zx': %s\n",
 			kfunc_name, offset,
-			libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
-		return type;
+			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		goto clear_kprobe_event;
 	}
 	attr.size = sizeof(attr);
 	attr.config = type;
@@ -10826,9 +10827,14 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
 		err = -errno;
 		pr_warn("legacy kprobe perf_event_open() failed: %s\n",
 			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
-		return err;
+		goto clear_kprobe_event;
 	}
 	return pfd;
+
+clear_kprobe_event:
+	/* Clear the newly added kprobe_event */
+	remove_kprobe_event_legacy(probe_name, retprobe);
+	return err;
 }
 
 struct bpf_link *
-- 
2.34.1

