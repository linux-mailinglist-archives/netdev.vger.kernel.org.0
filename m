Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541894A7250
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 14:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344603AbiBBNyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 08:54:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344657AbiBBNyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 08:54:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643810042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jBnKFQ30kOdAO0O49lD07YWI/2GEebyH6rvvven/zqI=;
        b=eMzvODrZA7c8Dm2KBjB8lx68J5wVJneIGfPr/pPvskFQN7sdS9xwNGg4uUiaNMsCCqAyqw
        321hy5MO+bMNEBGtjlv4VVWGcTTe76CaLN9sN7/iViPufDukiddWDQdpQJsEx0R/910p7T
        m1Oh8+BBlAc23ipXrlx0ReHdoTzSGPY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-q_05NFpMNWOyAh7nVC-BXQ-1; Wed, 02 Feb 2022 08:54:01 -0500
X-MC-Unique: q_05NFpMNWOyAh7nVC-BXQ-1
Received: by mail-ed1-f69.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso10415243edt.20
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 05:54:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jBnKFQ30kOdAO0O49lD07YWI/2GEebyH6rvvven/zqI=;
        b=AaVisnFYaFe2FJOV2ujs8JiTxk9o6F2vDNn6mwABzpvefdvSrtfIpZwhVXk5d1S8/F
         r/C+KfrNDQzcLrrjSWPv6fvNyf8dQKO5DB5++nbEVQl3VeApacvbdVzLnqCV/jKPDdHw
         aqROicpPgevAk+aUAXnnRxrlcfgII0ZbuE5iHbqhZN+4jlG4n0+calPO/XNZOXrsN/lk
         cyIiwaknZXOq+LNuVoexbt+6RL9c0Yb3I8kSV/EzaxEVzheOHvtjhi3YbeLg721pzwNa
         xbpoy9IVt2efZNTwQ1/BVV3t2x40eOaNl/WM0LfZFlivUrWTBhycyK4vVOdRwev6Fst7
         w5Rw==
X-Gm-Message-State: AOAM5315p98Nu2HojaBS+CYekvPIHp+9UwkAJGCjhBnlTpCZG4sYa8YG
        8kX9Sm5tca1sfg7H+kOXLdq5PpsJZ65NsIP7CT8ADH/k9MufdoGy7c72Tr3lbxyY7ZglwTD5OmG
        bDuI6YL952Me+NJSy
X-Received: by 2002:a50:bb0a:: with SMTP id y10mr8988221ede.441.1643810039920;
        Wed, 02 Feb 2022 05:53:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwpHD34n0QXTYfKs783CZ7B9M9fR7e6UeoB6pLhcbQSrQnEbVZssHdo7gWyGcK97/TJlR+epw==
X-Received: by 2002:a50:bb0a:: with SMTP id y10mr8988201ede.441.1643810039727;
        Wed, 02 Feb 2022 05:53:59 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id f4sm15819702ejh.93.2022.02.02.05.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 05:53:59 -0800 (PST)
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
        Jiri Olsa <olsajiri@gmail.com>
Subject: [PATCH 4/8] libbpf: Add libbpf__kallsyms_parse function
Date:   Wed,  2 Feb 2022 14:53:29 +0100
Message-Id: <20220202135333.190761-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202135333.190761-1-jolsa@kernel.org>
References: <20220202135333.190761-1-jolsa@kernel.org>
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
index 1b0936b016d9..7d595cfd03bc 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7165,12 +7165,10 @@ static int bpf_object__sanitize_maps(struct bpf_object *obj)
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
 
@@ -7189,35 +7187,51 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
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
index bc86b82e90d1..fb3b07d401df 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -449,6 +449,11 @@ __s32 btf__find_by_name_kind_own(const struct btf *btf, const char *type_name,
 
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
2.34.1

