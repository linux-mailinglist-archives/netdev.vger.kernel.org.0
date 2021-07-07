Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7763BF193
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 23:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhGGVvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 17:51:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232065AbhGGVvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 17:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625694516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XyCTtNsvJM23bTJlhCXcXFu90hTwq9G3m+Uc2FcCDhw=;
        b=Se9zk1X8A3xV3LpnfZm66kVx8CDKosItrTUc5YEKUDGr8igVt18wHgL0zljSHbBQxSq1a/
        dCSn7LeVJiEya86nYLzWUSU2CqWTSQUtYVkesjEggeKMtEKE9ofbrgtLF6v5697Qq2GYpN
        J2mQwptqLNCqa/4KGlheUD79kdq3cKw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-w5169GrlO_6gZzmPDhhECA-1; Wed, 07 Jul 2021 17:48:35 -0400
X-MC-Unique: w5169GrlO_6gZzmPDhhECA-1
Received: by mail-wm1-f69.google.com with SMTP id z127-20020a1c7e850000b02901e46e4d52c0so3004333wmc.6
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 14:48:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XyCTtNsvJM23bTJlhCXcXFu90hTwq9G3m+Uc2FcCDhw=;
        b=QKmCFM3Mo0mr7H7cMSkNkuZdKw2Bs3bh9ipatu3mcOfBG1dviT//CeMSTJ37LsjQs+
         SgX6kuz8M+50QTvud9porFw/B+Q3Bs17K93en2tl5cZMDQh2NkwcveW9MBQgJmQiOrfS
         LA5As6LJbunY7wgP4v1LixTDlrj/ISp9HdNgcCg+63Paj9zaQ86fYR9+aUT5so8xL3Sq
         43PaLBTkS0QhDgWRPxhlY5ArjEUvTKwq97Fth3k5ruzD4XUeXJRT02CQ6g6nFq7w+xCR
         eg5+K//wbt3Fcp1ChGLYwj3ao1OH0FW7mcqFfHY4o+UsrSZyc4g3EO+KQjnMRqOnQjll
         i2DQ==
X-Gm-Message-State: AOAM531rndfpfmCDpd4gszem3MzORQFXkdhnM+/gszt5huW6ywbYNwOc
        O6cyDVUKzf9fRILTFs2EgMMquKoURr4X9lbEQEs3jTdCXKOhpkKkBkRxs4MWdLWNCgWQ4nO7r4O
        zIaxxFD6laqJhLXi1
X-Received: by 2002:adf:a2db:: with SMTP id t27mr29810077wra.272.1625694514665;
        Wed, 07 Jul 2021 14:48:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1NKGIS5pSSuMCbb3wlNDchZjdi7A4xHRDEuiUKRnEl86QJ3yOKStzcLekLUeKf1S8O2RVww==
X-Received: by 2002:adf:a2db:: with SMTP id t27mr29810063wra.272.1625694514514;
        Wed, 07 Jul 2021 14:48:34 -0700 (PDT)
Received: from krava.redhat.com ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id p9sm150545wrx.59.2021.07.07.14.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 14:48:34 -0700 (PDT)
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
Subject: [PATCHv3 bpf-next 4/7] bpf: Add bpf_get_func_ip helper for kprobe programs
Date:   Wed,  7 Jul 2021 23:47:48 +0200
Message-Id: <20210707214751.159713-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707214751.159713-1-jolsa@kernel.org>
References: <20210707214751.159713-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding bpf_get_func_ip helper for BPF_PROG_TYPE_KPROBE programs,
so it's now possible to call bpf_get_func_ip from both kprobe and
kretprobe programs.

Taking the caller's address from 'struct kprobe::addr', which is
defined for both kprobe and kretprobe.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/uapi/linux/bpf.h       |  2 +-
 kernel/bpf/verifier.c          |  2 ++
 kernel/trace/bpf_trace.c       | 17 +++++++++++++++++
 tools/include/uapi/linux/bpf.h |  2 +-
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 83e87ffdbb6e..4894f99a1993 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4783,7 +4783,7 @@ union bpf_attr {
  *
  * u64 bpf_get_func_ip(void *ctx)
  * 	Description
- * 		Get address of the traced function (for tracing programs).
+ * 		Get address of the traced function (for tracing and kprobe programs).
  * 	Return
  * 		Address of the traced function.
  */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f975a3aa9368..79eb9d81a198 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5979,6 +5979,8 @@ static int has_get_func_ip(struct bpf_verifier_env *env)
 			return -ENOTSUPP;
 		}
 		return 0;
+	} else if (type == BPF_PROG_TYPE_KPROBE) {
+		return 0;
 	}
 
 	verbose(env, "func %s#%d not supported for program type %d\n",
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 9edd3b1a00ad..55acf56b0c3a 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -17,6 +17,7 @@
 #include <linux/error-injection.h>
 #include <linux/btf_ids.h>
 #include <linux/bpf_lsm.h>
+#include <linux/kprobes.h>
 
 #include <net/bpf_sk_storage.h>
 
@@ -961,6 +962,20 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
+{
+	struct kprobe *kp = kprobe_running();
+
+	return kp ? (u64) kp->addr : 0;
+}
+
+static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
+	.func		= bpf_get_func_ip_kprobe,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 const struct bpf_func_proto *
 bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -1092,6 +1107,8 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_override_return:
 		return &bpf_override_return_proto;
 #endif
+	case BPF_FUNC_get_func_ip:
+		return &bpf_get_func_ip_proto_kprobe;
 	default:
 		return bpf_tracing_func_proto(func_id, prog);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 83e87ffdbb6e..4894f99a1993 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4783,7 +4783,7 @@ union bpf_attr {
  *
  * u64 bpf_get_func_ip(void *ctx)
  * 	Description
- * 		Get address of the traced function (for tracing programs).
+ * 		Get address of the traced function (for tracing and kprobe programs).
  * 	Return
  * 		Address of the traced function.
  */
-- 
2.31.1

