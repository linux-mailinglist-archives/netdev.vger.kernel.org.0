Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20799483DCF
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiADIKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:10:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33172 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233960AbiADIKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:10:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641283841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k9zmsPfmvqNNuMjvxyy1I9bmPA8hKeQFPYbvFjf3I4A=;
        b=D9cT3aaa/ZVK/+1jLaqFjzdWMsFmDqMpqtG/8sFwVoDUiRTT6HbjYTC+we/GRtKX1Z5GEy
        G/jKy29Y6lcvk5Sa2lqydlGO+QFs7k/OQ8XeB1hw2uqfJ1zgd/JtG8k99FFuT803JstmQ4
        6M7KFPrUb3K5R2gAV9gAQVehSyK9eW8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-WXVBgq84N4OgjgYpxSVWGw-1; Tue, 04 Jan 2022 03:10:40 -0500
X-MC-Unique: WXVBgq84N4OgjgYpxSVWGw-1
Received: by mail-ed1-f69.google.com with SMTP id w6-20020a05640234c600b003f916e1b615so15501775edc.17
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 00:10:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k9zmsPfmvqNNuMjvxyy1I9bmPA8hKeQFPYbvFjf3I4A=;
        b=FIYnat96HPZeWdl4PeToCBwnWG82Yp2lq6mIlgqejacicKl0yUUjHPIqPDMFzo713d
         mitkTqweguVh55HwGt9bAW/7do0WIG8W3a1mArFlnhSWMcGvarJDluO14VUCng0ibyJe
         PpvVYRLu4W/8r9sUsF/imf+8tkUWUHskVgacwks9c33iMOJIZCDsL3HRrF4J1MAa2GO7
         /ZVWePg4bivmSo8uOT+OCQa/yK25KpOsfPjmn9aGTIAH+xEM3p324JF6Er/RB9ns7vSA
         pKKO0UCkPfKaY/78uP8H1G36W2yqTbpuleNgM+jEmqJyR8bJgLtHDKv4K/DgKbeCnpD8
         Xz1w==
X-Gm-Message-State: AOAM532MWsKlm0WeXfsKVkKxJJn1MPaQdgnlrTxFa3tTE4K6HsEjQVlT
        l2+CeLGwsQtyYaptqea+VOYVRVsBgLwuD0jph7ZGe4mFzMNtoifQ/4b95vH6OTRIxi7fUDzixvr
        BDiLMCnfeKwkGGvhr
X-Received: by 2002:a17:906:ced9:: with SMTP id si25mr41488671ejb.77.1641283839575;
        Tue, 04 Jan 2022 00:10:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzi6A/ih8FmZYPaSWBAndlTnAjTuC5CIwYwH/5ES92eoOzDAHcM0nZAphH3RYwfLOv0tUGPwA==
X-Received: by 2002:a17:906:ced9:: with SMTP id si25mr41488662ejb.77.1641283839376;
        Tue, 04 Jan 2022 00:10:39 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id hd43sm1415724ejc.62.2022.01.04.00.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 00:10:39 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 09/13] libbpf: Add libbpf__kallsyms_parse function
Date:   Tue,  4 Jan 2022 09:09:39 +0100
Message-Id: <20220104080943.113249-10-jolsa@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220104080943.113249-1-jolsa@kernel.org>
References: <20220104080943.113249-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the kallsyms parsing in internal libbpf__kallsyms_parse
function, so it can be used from other places.

It will be used in following changes.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/libbpf.c          | 62 ++++++++++++++++++++-------------
 tools/lib/bpf/libbpf_internal.h |  5 +++
 2 files changed, 43 insertions(+), 24 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9cb99d1e2385..25512b4dbc8c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7146,12 +7146,10 @@ static int bpf_object__sanitize_maps(struct bpf_object *obj)
 	return 0;
 }
 
-static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
+int libbpf__kallsyms_parse(void *arg, kallsyms_cb_t cb)
 {
 	char sym_type, sym_name[500];
 	unsigned long long sym_addr;
-	const struct btf_type *t;
-	struct extern_desc *ext;
 	int ret, err = 0;
 	FILE *f;
 
@@ -7170,35 +7168,51 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
 		if (ret != 3) {
 			pr_warn("failed to read kallsyms entry: %d\n", ret);
 			err = -EINVAL;
-			goto out;
+			break;
 		}
 
-		ext = find_extern_by_name(obj, sym_name);
-		if (!ext || ext->type != EXT_KSYM)
-			continue;
-
-		t = btf__type_by_id(obj->btf, ext->btf_id);
-		if (!btf_is_var(t))
-			continue;
-
-		if (ext->is_set && ext->ksym.addr != sym_addr) {
-			pr_warn("extern (ksym) '%s' resolution is ambiguous: 0x%llx or 0x%llx\n",
-				sym_name, ext->ksym.addr, sym_addr);
-			err = -EINVAL;
-			goto out;
-		}
-		if (!ext->is_set) {
-			ext->is_set = true;
-			ext->ksym.addr = sym_addr;
-			pr_debug("extern (ksym) %s=0x%llx\n", sym_name, sym_addr);
-		}
+		err = cb(arg, sym_addr, sym_type, sym_name);
+		if (err)
+			break;
 	}
 
-out:
 	fclose(f);
 	return err;
 }
 
+static int kallsyms_cb(void *arg, unsigned long long sym_addr,
+		       char sym_type, const char *sym_name)
+{
+	struct bpf_object *obj = arg;
+	const struct btf_type *t;
+	struct extern_desc *ext;
+
+	ext = find_extern_by_name(obj, sym_name);
+	if (!ext || ext->type != EXT_KSYM)
+		return 0;
+
+	t = btf__type_by_id(obj->btf, ext->btf_id);
+	if (!btf_is_var(t))
+		return 0;
+
+	if (ext->is_set && ext->ksym.addr != sym_addr) {
+		pr_warn("extern (ksym) '%s' resolution is ambiguous: 0x%llx or 0x%llx\n",
+			sym_name, ext->ksym.addr, sym_addr);
+		return -EINVAL;
+	}
+	if (!ext->is_set) {
+		ext->is_set = true;
+		ext->ksym.addr = sym_addr;
+		pr_debug("extern (ksym) %s=0x%llx\n", sym_name, sym_addr);
+	}
+	return 0;
+}
+
+static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
+{
+	return libbpf__kallsyms_parse(obj, kallsyms_cb);
+}
+
 static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_name,
 			    __u16 kind, struct btf **res_btf,
 			    struct module_btf **res_mod_btf)
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 1565679eb432..dc544d239509 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -446,6 +446,11 @@ __s32 btf__find_by_name_kind_own(const struct btf *btf, const char *type_name,
 
 extern enum libbpf_strict_mode libbpf_mode;
 
+typedef int (*kallsyms_cb_t)(void *arg, unsigned long long sym_addr,
+			     char sym_type, const char *sym_name);
+
+int libbpf__kallsyms_parse(void *arg, kallsyms_cb_t cb);
+
 /* handle direct returned errors */
 static inline int libbpf_err(int ret)
 {
-- 
2.33.1

