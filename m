Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A3E3BF18E
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 23:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbhGGVvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 17:51:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232732AbhGGVvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 17:51:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625694499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jm5cd0zOZ7Itm+FjlMPQhsBe4LoJlMQjbASHrTs/ggA=;
        b=JfPvXLah9ma06orCRN/m6//y9eFiarHSrL/UZbWevl3/+fBORGTRW50wR5rT5ZrZtYzqfk
        bFWXWAi0dgi+NgBzMbpexx8Tx4XWW61IqBxPhuhsSWFO75TQDgz/6kNSe8KlrBzVTa1j82
        0fuCuH1uM32sZwSIK/x5TEemamYeOd0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-4-lO2mZ0PvGq6BR49grfyQ-1; Wed, 07 Jul 2021 17:48:18 -0400
X-MC-Unique: 4-lO2mZ0PvGq6BR49grfyQ-1
Received: by mail-wr1-f69.google.com with SMTP id t12-20020adff04c0000b029013253c3389dso1174981wro.7
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 14:48:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jm5cd0zOZ7Itm+FjlMPQhsBe4LoJlMQjbASHrTs/ggA=;
        b=bJ27BmOHybWS1ue67iW1y2E7Y/U55E/sj5wqahRNGjZj2n8/cc3e29ctN1Calubmxq
         cjftyq4D/8h8H+t9cl2/IIXfR4QiC0A5ZzF+HDYpzuFqlJiH3d5H+NwziUgCmTGUdhjb
         jmAtc6AvMTedDyK4PQtKttDYxymq1rtku1PNxX97rF12to2jjUwo0ApNFka4xtG1zLm9
         bT75DOkMiPG0t1NjS4G9bqjnoqUV09DCXzAHIr7FzQR+5La3EYxLo5rFAKJz4c1kEqh1
         RcghqvPkUy41TfvlGl1GJZolW84wIMjMAUuVdx0lLITE856zyrHIM0qIhBk7cgk1iK9f
         1gWw==
X-Gm-Message-State: AOAM533x+hOInSFYmsmmXmILDwpJ/xw+JZrH7+wGjEAFt4M2pzVcXFSW
        pNxDsE/fkkQyWZWr/N357hHlZ8t5vDqzij05ld1PKouDfuJP6b3QShqs0qTjysyYKHVqmSM76zd
        SzIXrcRM/ATboEVuS
X-Received: by 2002:a05:600c:4f15:: with SMTP id l21mr28700400wmq.72.1625694497182;
        Wed, 07 Jul 2021 14:48:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxM7lGZp/iD4L9G5xqaYUuQfm/4DcRAzM24ezG7RuatVD8l4V3ER8Jf4oCp6GSduKGjyxhVSA==
X-Received: by 2002:a05:600c:4f15:: with SMTP id l21mr28700380wmq.72.1625694497005;
        Wed, 07 Jul 2021 14:48:17 -0700 (PDT)
Received: from krava.redhat.com ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id u15sm7265281wmq.1.2021.07.07.14.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 14:48:16 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCHv3 bpf-next 2/7] bpf: Enable BPF_TRAMP_F_IP_ARG for trampolines with call_get_func_ip
Date:   Wed,  7 Jul 2021 23:47:46 +0200
Message-Id: <20210707214751.159713-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707214751.159713-1-jolsa@kernel.org>
References: <20210707214751.159713-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enabling BPF_TRAMP_F_IP_ARG for trampolines that actually need it.

The BPF_TRAMP_F_IP_ARG adds extra 3 instructions to trampoline code
and is used only by programs with bpf_get_func_ip helper, which is
added in following patch and sets call_get_func_ip bit.

This patch ensures that BPF_TRAMP_F_IP_ARG flag is used only for
trampolines that have programs with call_get_func_ip set.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/filter.h  |  3 ++-
 kernel/bpf/trampoline.c | 12 +++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 472f97074da0..ba36989f711a 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -559,7 +559,8 @@ struct bpf_prog {
 				kprobe_override:1, /* Do we override a kprobe? */
 				has_callchain_buf:1, /* callchain buffer allocated? */
 				enforce_expected_attach_type:1, /* Enforce expected_attach_type checking at attach time */
-				call_get_stack:1; /* Do we call bpf_get_stack() or bpf_get_stackid() */
+				call_get_stack:1, /* Do we call bpf_get_stack() or bpf_get_stackid() */
+				call_get_func_ip:1; /* Do we call get_func_ip() */
 	enum bpf_prog_type	type;		/* Type of BPF program */
 	enum bpf_attach_type	expected_attach_type; /* For some prog types */
 	u32			len;		/* Number of filter blocks */
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 28a3630c48ee..b2535acfe9db 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -172,7 +172,7 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 }
 
 static struct bpf_tramp_progs *
-bpf_trampoline_get_progs(const struct bpf_trampoline *tr, int *total)
+bpf_trampoline_get_progs(const struct bpf_trampoline *tr, int *total, bool *ip_arg)
 {
 	const struct bpf_prog_aux *aux;
 	struct bpf_tramp_progs *tprogs;
@@ -189,8 +189,10 @@ bpf_trampoline_get_progs(const struct bpf_trampoline *tr, int *total)
 		*total += tr->progs_cnt[kind];
 		progs = tprogs[kind].progs;
 
-		hlist_for_each_entry(aux, &tr->progs_hlist[kind], tramp_hlist)
+		hlist_for_each_entry(aux, &tr->progs_hlist[kind], tramp_hlist) {
+			*ip_arg |= aux->prog->call_get_func_ip;
 			*progs++ = aux->prog;
+		}
 	}
 	return tprogs;
 }
@@ -333,9 +335,10 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	struct bpf_tramp_image *im;
 	struct bpf_tramp_progs *tprogs;
 	u32 flags = BPF_TRAMP_F_RESTORE_REGS;
+	bool ip_arg = false;
 	int err, total;
 
-	tprogs = bpf_trampoline_get_progs(tr, &total);
+	tprogs = bpf_trampoline_get_progs(tr, &total, &ip_arg);
 	if (IS_ERR(tprogs))
 		return PTR_ERR(tprogs);
 
@@ -357,6 +360,9 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	    tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs)
 		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
 
+	if (ip_arg)
+		flags |= BPF_TRAMP_F_IP_ARG;
+
 	err = arch_prepare_bpf_trampoline(im, im->image, im->image + PAGE_SIZE,
 					  &tr->func.model, flags, tprogs,
 					  tr->func.addr);
-- 
2.31.1

