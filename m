Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A16B552C22
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 09:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344413AbiFUHdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 03:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347576AbiFUHcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 03:32:55 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC8E6472;
        Tue, 21 Jun 2022 00:32:54 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id p5so6475069pjt.2;
        Tue, 21 Jun 2022 00:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b/lnUx0hJ7HqJOINayp9iAYgQI8WL9Iz9w2/x6bwfX4=;
        b=RnUTro16AXZ0eBQ3b6jODrf2FLbY6MWXm+1M8J3korWvN95fVWDrOvROe4RGaXa6ZV
         ywmLOOWMirDtDb4x2TSxc2kGKU4h+Fl4dOnwkSWhi05CXKMJjyzP1MuukEDeSXvSUeQq
         EoeBXRjqLYLI2oMab3Cg5Eqgl/Hu/DQgsFFpTPG6nABHA7LQSAphe7pF3Sm33Qor/Dby
         MEfCNMfqmwa0Fj0DhglTSDPYZq+dzphCcOPvFCZv69dlyIkuUKdJCWLHc8N/PeSKKgU3
         R6wxIYP9NiBxI2E1Xg1m1ByTLrfSveOFXuzcQAMM5gLo56lfVGynDan1QC4NWpk8rYae
         awsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b/lnUx0hJ7HqJOINayp9iAYgQI8WL9Iz9w2/x6bwfX4=;
        b=5Lh3M/3qRTnJ5P2WOe+GxsxxYO8sjx5sKIivxDqyKJljzYArAgLkUY5boWVNRBF640
         ighKFhKsCOjXOjauABh69+3D1bb1tia78cRmg/oha/eEw7NGJsuynACNNXzotOYztWl+
         6uNChbiMRksBIg/ZXGKtSKNZ5TtZBYx6wf+sSugMgeTx3YmdjsOpZE8VhsDtMCGGbhCO
         imhab/KqH0iSELG9TftVizUbuxBNNyTrI7COppCKRUHBYiEAUxgPbe5B3ZwnKeUnvoJq
         Gc7QPMXcTlyumFtVsPzu2w6SlwJ3QlNCNcAeGDU56lb5Bq6bQJTFrSLpUAoisV9c+6vw
         lbIA==
X-Gm-Message-State: AJIora+8Sj/0GG9lyWAi73Xz4Uzh+sD+unUJMZmo6QAU7D8NRGXbp92A
        ar4tb/tn2cT7mqPYt5xmXw4=
X-Google-Smtp-Source: AGRyM1u7kuN98EazRnRgzVwwdQ0H23jAruWbOed9O8/IYVCI1vHt1AHRq1XiCb3ltxIfkRLSlXh74g==
X-Received: by 2002:a17:902:d50b:b0:16a:2cb3:74f7 with SMTP id b11-20020a170902d50b00b0016a2cb374f7mr6357042plg.6.1655796773424;
        Tue, 21 Jun 2022 00:32:53 -0700 (PDT)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id jj4-20020a170903048400b001678898ad06sm3944394plb.47.2022.06.21.00.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 00:32:52 -0700 (PDT)
From:   Chuang W <nashuiliang@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Chuang W <nashuiliang@gmail.com>,
        Jingren Zhou <zhoujingren@didiglobal.com>
Subject: [PATCH v2] libbpf: Cleanup the kprobe_event on failed add_kprobe_event_legacy()
Date:   Tue, 21 Jun 2022 15:32:33 +0800
Message-Id: <20220621073233.53776-1-nashuiliang@gmail.com>
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

Before the 0bc11ed5ab60 commit ("kprobes: Allow kprobes coexist with
livepatch"), in a scenario where livepatch and kprobe coexist on the
same function entry, the creation of kprobe_event using
add_kprobe_event_legacy() will be successful, at the same time as a
trace event (e.g. /debugfs/tracing/events/kprobe/XX) will exist, but
perf_event_open() will return an error because both livepatch and kprobe
use FTRACE_OPS_FL_IPMODIFY.

With this patch, whenever an error is returned after
add_kprobe_event_legacy(), this ensures that the created kprobe_event is
cleaned.

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

