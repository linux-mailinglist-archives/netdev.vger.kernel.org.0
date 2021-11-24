Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC445B6C2
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241533AbhKXIqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:46:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241542AbhKXIov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:44:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637743302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VUpNCIf6I4xx/xoebeS2tiWidAHCtrV6dZkFUmxD4cc=;
        b=FgoVu18gtjma/DGnyax3NdOfNuUcsnEIs3pT65b9wgdTNw5I1QIW8uZesEQtCb8MFUEg3r
        xR+iWGT7iZEbcwqQuqXq8UsepfcVcSSTolbs5mRVNyGYpBLVJ+KZ40G0ELE2o1pFTJWfQJ
        foCezp3zf4yzFTe4PwF5KDNmicv7B9E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-326-w1Z5Lz-lMkiQGiMGHlifEg-1; Wed, 24 Nov 2021 03:41:40 -0500
X-MC-Unique: w1Z5Lz-lMkiQGiMGHlifEg-1
Received: by mail-wm1-f69.google.com with SMTP id p12-20020a05600c1d8c00b0033a22e48203so1017736wms.6
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 00:41:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VUpNCIf6I4xx/xoebeS2tiWidAHCtrV6dZkFUmxD4cc=;
        b=yYCh59fcp58jF0ewpjrRM/LxlzLbbuEvsh1u4KVoUmeUR/mybAUogqPUmUnDhHe+RR
         OymLrAm5achPB9uWOchWvso3U/o5fsyIqDEpy7biSUnFYoUIcP0gSzZTnL9K6uEURosj
         kR7LOJdeQuUwaVy8fh/ykpmwkeqwTQWdgchL/HJjb7aV2OtjnqfEHU5sJZIyAxRdAl0L
         WduqPOG3Q61HnhcSVWZZeBPl1EbnPCtiPUik+QkZu8nPr3vZxvk0SsfY48gcTQ+FRxOM
         XKh0KiiqYDUS2EIKbi1otPkC4AWUyZ9xRJOG1NCOp8/1pUuCUyf16NJ6IUQCIyFxJmmW
         OupQ==
X-Gm-Message-State: AOAM533yJ4ZW7RPHCRE815WukcXmVsrmdUAk9lJIUSIASGFg8ROLNPgb
        C9GlT3BaHXmPg2OeNitqMnSG7FXCeD4dDSPJYT/oBSCDP+aFeVQMi36K8hJrH4z0/FtPzxRUxA8
        czBeTCRCbzbVwfI1t
X-Received: by 2002:a5d:548f:: with SMTP id h15mr16213863wrv.99.1637743299421;
        Wed, 24 Nov 2021 00:41:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyz1415SFxfiE43cMAnbGJQqe7kyuGSNL3YexfDBsTFRpB49fmucVAQmngtlVjsFf5uIYlC/A==
X-Received: by 2002:a5d:548f:: with SMTP id h15mr16213828wrv.99.1637743299253;
        Wed, 24 Nov 2021 00:41:39 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id x4sm3649097wmi.3.2021.11.24.00.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 00:41:38 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: [PATCH 3/8] libbpf: Add libbpf__kallsyms_parse function
Date:   Wed, 24 Nov 2021 09:41:14 +0100
Message-Id: <20211124084119.260239-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124084119.260239-1-jolsa@kernel.org>
References: <20211124084119.260239-1-jolsa@kernel.org>
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
index af405c38aadc..b55c0fbfcc03 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6950,12 +6950,10 @@ static int bpf_object__sanitize_maps(struct bpf_object *obj)
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
 
@@ -6974,35 +6972,51 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
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
index f7ac349650a1..511cb09f593f 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -406,6 +406,11 @@ __s32 btf__find_by_name_kind_own(const struct btf *btf, const char *type_name,
 
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

