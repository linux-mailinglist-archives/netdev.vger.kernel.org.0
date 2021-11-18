Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36998455A2C
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343972AbhKRL3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:29:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343906AbhKRL2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:28:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lWJS1A2VobZl6UHVtIe8xy1WCp4+zjRZoPdV1CZlw20=;
        b=AvfrDfO/LtkL/vo6oW4XST7VHyAmSPdQRNuk/Y7XLcMVhoxwp9JNJUrCRNvDSyCMv3dAha
        l58/iQxsLRdktRXFQYaEBXamZDDMnHWU9gaBZuzdcpkE+n89BKEFoTLE9rNpwgYA0aZwvH
        fWIvloaV04XPmctlSr7wnTITJ4e3qdU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-l65cDXg5P5--3zNtYzZiQg-1; Thu, 18 Nov 2021 06:25:22 -0500
X-MC-Unique: l65cDXg5P5--3zNtYzZiQg-1
Received: by mail-ed1-f69.google.com with SMTP id f4-20020a50e084000000b003db585bc274so4958471edl.17
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:25:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lWJS1A2VobZl6UHVtIe8xy1WCp4+zjRZoPdV1CZlw20=;
        b=PYrcpWt3oUQi+sBz5rJB6YoklxYqQqs6qIyYnlLCrYZucrsk0R6sVh8YIadEHAjCo2
         BXvQZFZk53VARYcv+jDYO1DKCkG8Il3sOsVKyWnArXIowuAFGaodYs+7s8ING2lIogsT
         yMvCjDGk6/4JAHrqa/DQzoc7/cPjDeJ9drnIvTDHXe9yxJqJpHbKgcpyM0CiI0cYltQx
         tUU2UJIxOz4L93C6JW9D+J219iN6YieoasiF8ONKw9j2eVtDrXrBkPoBl731wHk1frTk
         IVAotKBlvJF5tRXIPI68Q7oSGE4WuvGL1dqdma+T4VTLFo9kcPqWCCtvtqCWLgI+Sfgu
         nK8Q==
X-Gm-Message-State: AOAM530URv6zaT6l5QkjLZn4lJ6Uq+TnivFPIpSOtFFo/R33OCrnXc7z
        UqhHZiZfxYF0g3l3KKEzUK63VliImXgW1ksQE9fcScZ90sEqGTsNJO/R3lE0lsEyFxe+mKxcriA
        RLx7BvD9J56MRSnba
X-Received: by 2002:a17:907:868e:: with SMTP id qa14mr33652129ejc.564.1637234721268;
        Thu, 18 Nov 2021 03:25:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz/teIMbtVpauVKwlK8uwMZzmXtH92/ajUedOTRqBR2Kz0Du+ywf6IJq9LdpyGserDhW7HpIQ==
X-Received: by 2002:a17:907:868e:: with SMTP id qa14mr33652095ejc.564.1637234721109;
        Thu, 18 Nov 2021 03:25:21 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id x14sm1140515ejs.124.2021.11.18.03.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:25:20 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 04/29] bpf: Factor bpf_check_attach_target function
Date:   Thu, 18 Nov 2021 12:24:30 +0100
Message-Id: <20211118112455.475349-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separating the check itself from model distilling and
address search into __bpf_check_attach_target function.

This way we can easily add function in following patch
that gets only function model without the address search,
while using the same code as bpf_check_attach_target.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/verifier.c | 79 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 59 insertions(+), 20 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0763cca139a7..cbbbf47e1832 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13568,20 +13568,26 @@ static int check_non_sleepable_error_inject(u32 btf_id)
 	return btf_id_set_contains(&btf_non_sleepable_error_inject, btf_id);
 }
 
-int bpf_check_attach_target(struct bpf_verifier_log *log,
-			    const struct bpf_prog *prog,
-			    const struct bpf_prog *tgt_prog,
-			    u32 btf_id,
-			    struct bpf_attach_target_info *tgt_info)
+struct attach_target {
+	const struct btf_type *t;
+	const char *tname;
+	int subprog;
+	struct btf *btf;
+};
+
+static int __bpf_check_attach_target(struct bpf_verifier_log *log,
+				     const struct bpf_prog *prog,
+				     const struct bpf_prog *tgt_prog,
+				     u32 btf_id,
+				     struct attach_target *target)
 {
 	bool prog_extension = prog->type == BPF_PROG_TYPE_EXT;
 	const char prefix[] = "btf_trace_";
-	int ret = 0, subprog = -1, i;
+	int subprog = -1, i;
 	const struct btf_type *t;
 	bool conservative = true;
 	const char *tname;
 	struct btf *btf;
-	long addr = 0;
 
 	if (!btf_id) {
 		bpf_log(log, "Tracing programs must provide btf_id\n");
@@ -13706,9 +13712,6 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 		t = btf_type_by_id(btf, t->type);
 		if (!btf_type_is_func_proto(t))
 			return -EINVAL;
-		ret = btf_distill_func_proto(log, btf, t, tname, &tgt_info->fmodel);
-		if (ret)
-			return ret;
 		break;
 	default:
 		if (!prog_extension)
@@ -13737,22 +13740,57 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 
 		if (tgt_prog && conservative)
 			t = NULL;
+	}
+
+	target->t = t;
+	target->tname = tname;
+	target->subprog = subprog;
+	target->btf = btf;
+	return 0;
+}
+
+int bpf_check_attach_target(struct bpf_verifier_log *log,
+			    const struct bpf_prog *prog,
+			    const struct bpf_prog *tgt_prog,
+			    u32 btf_id,
+			    struct bpf_attach_target_info *tgt_info)
+{
+	struct attach_target target = { };
+	long addr = 0;
+	int ret;
 
-		ret = btf_distill_func_proto(log, btf, t, tname, &tgt_info->fmodel);
+	ret = __bpf_check_attach_target(log, prog, tgt_prog, btf_id, &target);
+	if (ret)
+		return ret;
+
+	switch (prog->expected_attach_type) {
+	case BPF_TRACE_RAW_TP:
+		break;
+	case BPF_TRACE_ITER:
+		ret = btf_distill_func_proto(log, target.btf, target.t, target.tname, &tgt_info->fmodel);
+		if (ret)
+			return ret;
+		break;
+	default:
+	case BPF_MODIFY_RETURN:
+	case BPF_LSM_MAC:
+	case BPF_TRACE_FENTRY:
+	case BPF_TRACE_FEXIT:
+		ret = btf_distill_func_proto(log, target.btf, target.t, target.tname, &tgt_info->fmodel);
 		if (ret < 0)
 			return ret;
 
 		if (tgt_prog) {
-			if (subprog == 0)
+			if (target.subprog == 0)
 				addr = (long) tgt_prog->bpf_func;
 			else
-				addr = (long) tgt_prog->aux->func[subprog]->bpf_func;
+				addr = (long) tgt_prog->aux->func[target.subprog]->bpf_func;
 		} else {
-			addr = kallsyms_lookup_name(tname);
+			addr = kallsyms_lookup_name(target.tname);
 			if (!addr) {
 				bpf_log(log,
 					"The address of function %s cannot be found\n",
-					tname);
+					target.tname);
 				return -ENOENT;
 			}
 		}
@@ -13779,7 +13817,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 				break;
 			}
 			if (ret) {
-				bpf_log(log, "%s is not sleepable\n", tname);
+				bpf_log(log, "%s is not sleepable\n", target.tname);
 				return ret;
 			}
 		} else if (prog->expected_attach_type == BPF_MODIFY_RETURN) {
@@ -13787,18 +13825,19 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 				bpf_log(log, "can't modify return codes of BPF programs\n");
 				return -EINVAL;
 			}
-			ret = check_attach_modify_return(addr, tname);
+			ret = check_attach_modify_return(addr, target.tname);
 			if (ret) {
-				bpf_log(log, "%s() is not modifiable\n", tname);
+				bpf_log(log, "%s() is not modifiable\n", target.tname);
 				return ret;
 			}
 		}
 
 		break;
 	}
+
 	tgt_info->tgt_addr = addr;
-	tgt_info->tgt_name = tname;
-	tgt_info->tgt_type = t;
+	tgt_info->tgt_name = target.tname;
+	tgt_info->tgt_type = target.t;
 	return 0;
 }
 
-- 
2.31.1

