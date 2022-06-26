Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B24C55AE69
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 05:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbiFZDNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 23:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiFZDNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 23:13:22 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1DEA459;
        Sat, 25 Jun 2022 20:13:20 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id l6so5338025plg.11;
        Sat, 25 Jun 2022 20:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SgbVSj7uwsLnvEUbZN3GbnRrDYKXQqdcuWn4sqFZbNg=;
        b=iB/S/QAzCdI/g68PoramR6Mb+h4Ws1VqmlViROnz2he1H/oDuPwxBxpg/huDmxrIT0
         LU2ZfiKSl+9snTtgUhkgEwliW/p1M0u4m+V8VhbGA60++/wOkmQ+RPNixycJl1o0X8En
         omrRBRfy5taE4pp8adIjzbfMBJwW2dHMFaSGrKIifxROgor8FmJfWCz8ouUdVrX8NmTE
         TVow5tT5P3fxnJztRXhjzmiMKXNpSBwPubHud6Eo4lozVgS9/tdBXZF4089cn6QhW7X6
         nypcsCBhKZxN0n5LzRN9lqftJOrZk3jzGe74M6iLoFbbV55wWiPdpal6alAqtcOwNXeP
         0xyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SgbVSj7uwsLnvEUbZN3GbnRrDYKXQqdcuWn4sqFZbNg=;
        b=czlaj5KANe7T2gZcyW4sjMBNrjrfwT23gORugF2CdSF4lEfZyB/I49tIqaXPByKPBn
         obM0imRPK2EzshfJdFUqxOmo7ukZMi1ENgbh9ES4u46pNK9HjxDJCdnwJeH4agOL39wn
         ZYrsvREpcoZM4e/O+iAS1UaRp0rqkLMvvA1uGvRXLE5XRQkuwJZ1LBuzaVYcHUjxBykJ
         GZA0uuFWefrI6uxW2cOwaXu2i66r1pzyl3+NeeCRCYpoyYnjYJhWYXLpsoddWz3Fso6p
         hQFE7vN3dU6AXTy2b92LxiIRlddzJfFP3ezrI2omFAQOpn08/uZZgJBVipT45oSV5Vfu
         AIfQ==
X-Gm-Message-State: AJIora9l3Os00m7/ySkMY77zm8Lc6PDPF+6mRRcwwWh+usNdUq69QNUy
        9lblMkuQxWvTw4M3qM59EO8=
X-Google-Smtp-Source: AGRyM1stAWGoo0bxh88Zdi6Q4DRIQGkWuqyjqvmBVE9AZu+PgPasDI6mXiAa9YTxhVomXojubSDOjw==
X-Received: by 2002:a17:902:da87:b0:16a:2158:9a11 with SMTP id j7-20020a170902da8700b0016a21589a11mr7268381plx.71.1656213200211;
        Sat, 25 Jun 2022 20:13:20 -0700 (PDT)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id q16-20020a17090311d000b001636c0b98a7sm4366652plh.226.2022.06.25.20.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 20:13:19 -0700 (PDT)
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
Subject: [PATCH v3] libbpf: Cleanup the legacy kprobe_event on failed add/attach_event()
Date:   Sun, 26 Jun 2022 11:13:01 +0800
Message-Id: <20220626031301.60390-1-nashuiliang@gmail.com>
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
trace event (e.g. /debugfs/tracing/events/kprobe/XXX) will exist, but
perf_event_open() will return an error because both livepatch and kprobe
use FTRACE_OPS_FL_IPMODIFY. As follows:

1) add a livepatch

$ insmod livepatch-XXX.ko

2) add a kprobe using tracefs API (i.e. add_kprobe_event_legacy)

$ echo 'p:mykprobe XXX' > /sys/kernel/debug/tracing/kprobe_events

3) enable this kprobe (i.e. sys_perf_event_open)

This will return an error, -EBUSY.

On Andrii Nakryiko's comment, few error paths in
bpf_program__attach_kprobe_opts() which should need to call
remove_kprobe_event_legacy().

With this patch, whenever an error is returned after
add_kprobe_event_legacy() or bpf_program__attach_perf_event_opts(), this
ensures that the created kprobe_event is cleaned.

Signed-off-by: Chuang W <nashuiliang@gmail.com>
Signed-off-by: Jingren Zhou <zhoujingren@didiglobal.com>
---
V2->v3:
- add detail commits
- call remove_kprobe_event_legacy() on failed bpf_program__attach_perf_event_opts()

 tools/lib/bpf/libbpf.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 49e359cd34df..038b0cb3313f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10811,10 +10811,11 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
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
@@ -10828,9 +10829,14 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
 		err = -errno;
 		pr_warn("legacy kprobe perf_event_open() failed: %s\n",
 			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
-		return err;
+		goto clear_kprobe_event;
 	}
 	return pfd;
+
+clear_kprobe_event:
+	/* Clear the newly added legacy kprobe_event */
+	remove_kprobe_event_legacy(probe_name, retprobe);
+	return err;
 }
 
 struct bpf_link *
@@ -10899,6 +10905,9 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
 
 	return link;
 err_out:
+	/* Clear the newly added legacy kprobe_event */
+	if (legacy)
+		remove_kprobe_event_legacy(legacy_probe, retprobe);
 	free(legacy_probe);
 	return libbpf_err_ptr(err);
 }
-- 
2.34.1

