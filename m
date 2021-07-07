Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB8A3BF07B
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 21:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhGGTti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 15:49:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49084 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232572AbhGGTtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 15:49:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625687215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XyCTtNsvJM23bTJlhCXcXFu90hTwq9G3m+Uc2FcCDhw=;
        b=Bh2OhR4RGO5qS0TiPtEs/I9B2eoNjXVT75srB3ukIvyjB7wLxZTyiS9TrZz/2ErMVwhmDY
        XpZedWmxWGggckrgr1aJ3klx0rVwnDBd2HNWQh26d+mYB1s3dFKvPFTSquAycUR7xElVte
        HJspj/C65LqPbI2lZWRTN/1ewsoQD1Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-I5ltmYEmNTydDuylHFETSA-1; Wed, 07 Jul 2021 15:46:54 -0400
X-MC-Unique: I5ltmYEmNTydDuylHFETSA-1
Received: by mail-wm1-f71.google.com with SMTP id n17-20020a05600c4f91b0290209ebf81aabso1413956wmq.2
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 12:46:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XyCTtNsvJM23bTJlhCXcXFu90hTwq9G3m+Uc2FcCDhw=;
        b=PIIgJ0ldjyJQRr7UrwCfZ7TLxISajM6kceA66+ktSBBTk2Ywc5Ymavy5lBT6VGKQGd
         jwQ4qrArxBiPROFtvy7uMHsHFDDPXG0gyvXdob6Hc2qcKNMT+Qmzd8DQfQCg9E9J5RjG
         5iEgresLFktdAotUvrmMGDSmaCZOiV86eKqz1PegV02WPajfVW9BqsIVrQeJVcnVPWBc
         B6DW+wz5DojSO9dIUSWjcMtnkit0CaqWZHqfLdyxTLmia9yPeqAX5qLrjiS4MdI7YemR
         16Lg7FY/g5AP/RlP/9SeHStaFgE0hkZCfwwnPUxxQRCqfoD4cRKEeF0iEh+njs9AaJJs
         ldXg==
X-Gm-Message-State: AOAM532PtYrAnW4RQSdkOYdDYRSbg9yzhCCsf7fWc5YGfe9Tv0EJDQfQ
        66CCpTGLhGgYE6kZVkVg3n+8Ixm2Wi1tqy7WTLFedWvFksCZjadsJ7L/v+u3DJe1R5VSjzWd/DK
        k8z5Jk9i1cezI9Vqb
X-Received: by 2002:a05:600c:1c8f:: with SMTP id k15mr28858769wms.91.1625687212842;
        Wed, 07 Jul 2021 12:46:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwu7rf02t2v0dKPwUDOi8KjZXmcJxl0X3f27O0ei2he77A+R1yn8AOCE2VQNGl53nogDYsQeA==
X-Received: by 2002:a05:600c:1c8f:: with SMTP id k15mr28858743wms.91.1625687212688;
        Wed, 07 Jul 2021 12:46:52 -0700 (PDT)
Received: from krava.redhat.com ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id t9sm21265548wrq.92.2021.07.07.12.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 12:46:52 -0700 (PDT)
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
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH 4/7] bpf: Add bpf_get_func_ip helper for kprobe programs
Date:   Wed,  7 Jul 2021 21:46:16 +0200
Message-Id: <20210707194619.151676-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707194619.151676-1-jolsa@kernel.org>
References: <20210707194619.151676-1-jolsa@kernel.org>
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

