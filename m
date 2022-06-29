Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A773560465
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbiF2PT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbiF2PT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:19:26 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5529022BC1;
        Wed, 29 Jun 2022 08:19:25 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c4so14413381plc.8;
        Wed, 29 Jun 2022 08:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G6qukGK7dTCAThbsePIio/EYDyzyRZYWAFR5AC42Gik=;
        b=SBEdYXGyAFISzPwcwvlY8UCwWwi3HskIcjS8brtdanZwQV9Vj1WF6/hfUnuW1u9Y+n
         jjVQOkic7GgZipHvOtonXeuTgKwHyxgqAi5ccrJXPB7z8OhFcM0KmV7atyT8wJcpkwHz
         3loukM2tEMSlJAsQOHLhISTQR4hc8+iB9I4MWZwD9B5pbtx3Y3DnqYqgAipvR7gpMN7p
         YHpT9Tb6YiB1fszVDNx/PxPLcD/NtCIRVtJ32vLGofjiKyQw9GmCsGKoRbBTy19WQopw
         pyXI9p2oGP5+sFo3dy1/LZGKPMEiIgmdyzA7U2i4ZvrmoZNn0382NMhD2PmnrsSyRFfG
         E/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G6qukGK7dTCAThbsePIio/EYDyzyRZYWAFR5AC42Gik=;
        b=RmNswNkBv6PGz4P0pBGkOPINhU/URiVMbA7h0VafBuDykIb0bsr2zgRerCXg+IsJWl
         UQNoc28ODHyfdSAbdN9p4n8JXzg0SeXDzzHFY8/iQfaLaxFB96al02M8E4y8wbn5WCAa
         dGi9gzHsP1yofwGd6NhdPlz02F4TBCdvSpTehf8XC29eHcxu9QlCm+QFGyAf+hhNnATR
         xjPoRnEgZ7gLzS7v2pANe3CZ1QwKlnpmiHdjGOBerDToSR65LYp5l5S0kdhew+61qh1u
         URYHvwZQDdFhbqx6CgVgzMXwu2C0YHECsUP8cF/qCcx3Th5oHVrRTTmSqdKqUvCOtd5g
         +yNA==
X-Gm-Message-State: AJIora/SljJnxDJDD67MJAO8hAQTjpNVvuW1Foq1KT+/paX2uWy8zn+D
        lt0+nAa3sfRB/hqggnDEWtU=
X-Google-Smtp-Source: AGRyM1sCZM5mr7Mv2EmyKBOBA3zMLJDnAcyd7TStwlSNHDb8XVX5quu7OboHpWSZ8D1oOKFUyusErA==
X-Received: by 2002:a17:90a:f314:b0:1ec:91a9:3256 with SMTP id ca20-20020a17090af31400b001ec91a93256mr4493905pjb.155.1656515964888;
        Wed, 29 Jun 2022 08:19:24 -0700 (PDT)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id x20-20020a170902b41400b001676dac529asm11522657plr.146.2022.06.29.08.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 08:19:24 -0700 (PDT)
From:   Chuang Wang <nashuiliang@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>,
        Jingren Zhou <zhoujingren@didiglobal.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/3] libbpf: cleanup the legacy kprobe_event on failed add/attach_event()
Date:   Wed, 29 Jun 2022 23:18:45 +0800
Message-Id: <20220629151848.65587-2-nashuiliang@gmail.com>
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
bpf_program__attach_kprobe_opts() that should need to call
remove_kprobe_event_legacy().

With this patch, whenever an error is returned after
add_kprobe_event_legacy() or bpf_program__attach_perf_event_opts(), this
ensures that the created kprobe_event is cleaned.

Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
Signed-off-by: Jingren Zhou <zhoujingren@didiglobal.com>
---
 tools/lib/bpf/libbpf.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e994797bcd48..8a33a52e01a5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9868,10 +9868,11 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
 	}
 	type = determine_kprobe_perf_type_legacy(probe_name, retprobe);
 	if (type < 0) {
+		err = type;
 		pr_warn("failed to determine legacy kprobe event id for '%s+0x%zx': %s\n",
 			kfunc_name, offset,
-			libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
-		return type;
+			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		goto err_clean_legacy;
 	}
 	attr.size = sizeof(attr);
 	attr.config = type;
@@ -9885,9 +9886,14 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
 		err = -errno;
 		pr_warn("legacy kprobe perf_event_open() failed: %s\n",
 			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
-		return err;
+		goto err_clean_legacy;
 	}
 	return pfd;
+
+err_clean_legacy:
+	/* Clear the newly added legacy kprobe_event */
+	remove_kprobe_event_legacy(probe_name, retprobe);
+	return err;
 }
 
 struct bpf_link *
@@ -9944,7 +9950,7 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
 			prog->name, retprobe ? "kretprobe" : "kprobe",
 			func_name, offset,
 			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
-		goto err_out;
+		goto err_clean_legacy;
 	}
 	if (legacy) {
 		struct bpf_link_perf *perf_link = container_of(link, struct bpf_link_perf, link);
@@ -9955,6 +9961,11 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
 	}
 
 	return link;
+
+err_clean_legacy:
+	if (legacy)
+		remove_kprobe_event_legacy(legacy_probe, retprobe);
+
 err_out:
 	free(legacy_probe);
 	return libbpf_err_ptr(err);
-- 
2.34.1

