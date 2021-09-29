Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143D041D03F
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347437AbhI3ABQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347392AbhI3ABP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:01:15 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F917C06161C;
        Wed, 29 Sep 2021 16:59:34 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id me3-20020a17090b17c300b0019f44d2e401so1248136pjb.5;
        Wed, 29 Sep 2021 16:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=avrktJRNNMnCM7OhV3vckQVnvHq2euVA9+QR/6aN7bU=;
        b=TVQCfgV6sRaULvZgo7q0IYQgFt8Ula7I2zeAHfPZLq0LGetGRFdXUIE+Um+xzQlMzI
         AxsUQEpK6PnDns/NvmSotnxFuh3xgfMFvWwS8ok3d1u+ye3qQ+50IAF70CNs3sbv6CLu
         RV+OmDNn7Ksnf1H4GxFbQDFLKOF29p26aeRVTxEo1Ovx1D67SayJ1ln2R3khCjmWjhLJ
         vQy7zJkyapeTyx+/rLTNO8u03psTD/HRS5SGfbXrYKqqW9O8oTpglUGtba+Ve1cSsbRn
         OdAtXy7lJ7Crtnz8trkDFjQh7th3kgtBb0U6tNbJ87wBXQa0fNhSbWz/VBcK+l0Cyhet
         89GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=avrktJRNNMnCM7OhV3vckQVnvHq2euVA9+QR/6aN7bU=;
        b=aj3zRw3n1D8kjoYNqNTii5Hh064YQjCn21Uh/+OaYktUiIfivKucf7D7P2SwYTaKJR
         en7+wvDvmiHnp9TFN2+5PO525rdrMwFhz+bQoIE9FQJScOQvawuh9vzTBJlJqSE3kLWA
         MORkhAaKgM0pmOMiSBkFiQfZN4LY6pgDQKgQf8V8eXKpGievlMUTmPO2p+vSIAv5Odjq
         z2jIO/CBWz4e8fO4CNTHcA/Pp1l0WbullwqofYtmJRsGt+GSSF2Lu0sW4lCWGggquCU4
         8DB1vQMa1bzp8TnMceOwElzs7OwNqZtTurE3me3Iwhou3y6vDFxMEp1ahIAjQVGOgac0
         79vQ==
X-Gm-Message-State: AOAM533LRTzCXZM0R4CxztztD+xrYBAlAB9CcP8PUcEiUemjDAvZNyHX
        SLQe1DcqtzQuovC5EmCRtA==
X-Google-Smtp-Source: ABdhPJwVVO4gkRjVZzp/94Mguit4DSfK3tUtMTnFkIJA9/wt5JJBMsvXwiyzNMN//ZWroNTfhOZ1mg==
X-Received: by 2002:a17:90b:1a90:: with SMTP id ng16mr9482351pjb.130.1632959973715;
        Wed, 29 Sep 2021 16:59:33 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mr18sm681907pjb.17.2021.09.29.16.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 16:59:33 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Joe Burton <jevburton@google.com>
Subject: [RFC PATCH v2 02/13] bpf: Allow loading BPF_TRACE_MAP programs
Date:   Wed, 29 Sep 2021 23:58:59 +0000
Message-Id: <20210929235910.1765396-3-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

Add new attach type, BPF_TRACE_MAP. Tracing programs may specify this
type when loading. The verifier then checks that the traced function
has been registered for map tracing.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 include/linux/bpf.h      |  1 +
 include/uapi/linux/bpf.h |  1 +
 kernel/bpf/map_trace.c   | 25 +++++++++++++++++++++++++
 kernel/bpf/verifier.c    |  6 ++++++
 4 files changed, 33 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index dad62d5571c9..272f0ac49285 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1539,6 +1539,7 @@ void bpf_iter_unreg_target(const struct bpf_iter_reg *reg_info);
 bool bpf_iter_prog_supported(struct bpf_prog *prog);
 const struct bpf_func_proto *
 bpf_iter_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog);
+bool bpf_map_trace_prog_supported(struct bpf_prog *prog);
 int bpf_map_trace_reg_target(const struct bpf_map_trace_reg *reg_info);
 int bpf_iter_link_attach(const union bpf_attr *attr, bpfptr_t uattr, struct bpf_prog *prog);
 int bpf_iter_new_fd(struct bpf_link *link);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 17e8f4113369..0883c5dfb5d8 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1003,6 +1003,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_TRACE_MAP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/map_trace.c b/kernel/bpf/map_trace.c
index d8f829535f7e..d2c6df20f55c 100644
--- a/kernel/bpf/map_trace.c
+++ b/kernel/bpf/map_trace.c
@@ -31,3 +31,28 @@ int bpf_map_trace_reg_target(const struct bpf_map_trace_reg *reg_info)
 
 	return 0;
 }
+
+bool bpf_map_trace_prog_supported(struct bpf_prog *prog)
+{
+	const char *attach_fname = prog->aux->attach_func_name;
+	u32 prog_btf_id = prog->aux->attach_btf_id;
+	struct bpf_map_trace_target_info *tinfo;
+	bool supported = false;
+
+	mutex_lock(&targets_mutex);
+	list_for_each_entry(tinfo, &targets, list) {
+		if (tinfo->btf_id && tinfo->btf_id == prog_btf_id) {
+			supported = true;
+			break;
+		}
+		if (!strcmp(attach_fname, tinfo->reg_info->target)) {
+			tinfo->btf_id = prog->aux->attach_btf_id;
+			supported = true;
+			break;
+		}
+	}
+	mutex_unlock(&targets_mutex);
+
+	return supported;
+}
+
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1433752db740..babcb135dc0d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9464,6 +9464,7 @@ static int check_return_code(struct bpf_verifier_env *env)
 			break;
 		case BPF_TRACE_RAW_TP:
 		case BPF_MODIFY_RETURN:
+		case BPF_TRACE_MAP:
 			return 0;
 		case BPF_TRACE_ITER:
 			break;
@@ -13496,6 +13497,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 
 		break;
 	case BPF_TRACE_ITER:
+	case BPF_TRACE_MAP:
 		if (!btf_type_is_func(t)) {
 			bpf_log(log, "attach_btf_id %u is not a function\n",
 				btf_id);
@@ -13672,6 +13674,10 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		if (!bpf_iter_prog_supported(prog))
 			return -EINVAL;
 		return 0;
+	} else if (prog->expected_attach_type == BPF_TRACE_MAP) {
+		if (!bpf_map_trace_prog_supported(prog))
+			return -EINVAL;
+		return 0;
 	}
 
 	if (prog->type == BPF_PROG_TYPE_LSM) {
-- 
2.33.0.685.g46640cef36-goog

