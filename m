Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A263C483DB2
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbiADIJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:09:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233811AbiADIJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:09:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641283793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=deFFbtnYM3i/92CnuiUzL3EKyDWx93Ga+Yj6cLk2tzA=;
        b=XlJcEmcpeM5rR+erGWRS+dgNm1uW6n6+l0kNlRZPvaK5TxPUnKVqEhyuqT9yKMloexlvcq
        6xCW4B6xdJzMgjYvvTsncgx1DwAqB7NSW+ZrPOrGVxcfgQypWgtVqWzjhRd9PcljIGLr5E
        NbbHabSQ2Y/ZmmowaK/D3eaaKbLKkUc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-H0NB9X_vMaODOHpYMtySsA-1; Tue, 04 Jan 2022 03:09:52 -0500
X-MC-Unique: H0NB9X_vMaODOHpYMtySsA-1
Received: by mail-ed1-f72.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso24622212edt.20
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 00:09:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=deFFbtnYM3i/92CnuiUzL3EKyDWx93Ga+Yj6cLk2tzA=;
        b=2Xjg1MpfCsFalJEIP3s+W5IlwVdxb2oXF5RWaHLVg6ppDmoRKeQWierH4k4jgts4cl
         xfrtVrjJ3l3NF1eT/HR2jJeXvrGXoHKOITcXrXjML9rsKPtT4kyz7W03KB+ob6q1Tzjy
         hLGJBVuKgsO7nUTccaV7BA4p8mQYDifqBhSebg9fXw6y8hPb03yU++ZGwmK02m5oti7I
         CX0lpZhSeq4JXCIWXpYGAFEjXeJ4Da/IUHKRs/ZtCwJefgvwDBeOhlTlzmYBjGPWtPBB
         UeUS/YJJpWq3/Ffd2Dg/kOCVPl7f0RzJiaYvkeMAa1ViUNgNChxmwpyjPUsI7g1GekxP
         qK8g==
X-Gm-Message-State: AOAM5335DzkdISK0N42zKzMJrFz1wx3/dvivBtjjt4XdzojSSI34HpUd
        S4thld6JCsDBoE6g7zSJSCVBvbct8Fuq1GHBV/5IWT9TJmOpJlsbEgAZVr1rJe+QHFAvERJ8aLd
        32JvMMzt2OF6yHNpk
X-Received: by 2002:a17:906:8a43:: with SMTP id gx3mr37707284ejc.185.1641283790861;
        Tue, 04 Jan 2022 00:09:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxyNUpljah6tzm7i53XGrcK3Z5LHujpoocm6FeZnksRU3h8LpWhIH/IXYbvH/5LaWEcQ2c4dQ==
X-Received: by 2002:a17:906:8a43:: with SMTP id gx3mr37707268ejc.185.1641283790690;
        Tue, 04 Jan 2022 00:09:50 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id go10sm11251843ejc.100.2022.01.04.00.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 00:09:50 -0800 (PST)
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
Subject: [PATCH 01/13] ftrace: Add ftrace_set_filter_ips function
Date:   Tue,  4 Jan 2022 09:09:31 +0100
Message-Id: <20220104080943.113249-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220104080943.113249-1-jolsa@kernel.org>
References: <20220104080943.113249-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding ftrace_set_filter_ips function to be able to set filter on
multiple ip addresses at once.

With the kprobe multi attach interface we have cases where we need to
initialize ftrace_ops object with thousands of functions, so having
single function diving into ftrace_hash_move_and_update_ops with
ftrace_lock is faster.

The functions ips are passed as unsigned long array with count.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/ftrace.h |  3 +++
 kernel/trace/ftrace.c  | 53 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9999e29187de..60847cbce0da 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -512,6 +512,8 @@ struct dyn_ftrace {
 
 int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
 			 int remove, int reset);
+int ftrace_set_filter_ips(struct ftrace_ops *ops, unsigned long *ips,
+			  unsigned int cnt, int remove, int reset);
 int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset);
 int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
@@ -802,6 +804,7 @@ static inline unsigned long ftrace_location(unsigned long ip)
 #define ftrace_regex_open(ops, flag, inod, file) ({ -ENODEV; })
 #define ftrace_set_early_filter(ops, buf, enable) do { } while (0)
 #define ftrace_set_filter_ip(ops, ip, remove, reset) ({ -ENODEV; })
+#define ftrace_set_filter_ips(ops, ips, cnt, remove, reset) ({ -ENODEV; })
 #define ftrace_set_filter(ops, buf, len, reset) ({ -ENODEV; })
 #define ftrace_set_notrace(ops, buf, len, reset) ({ -ENODEV; })
 #define ftrace_free_filter(ops) do { } while (0)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index be5f6b32a012..39350aa38649 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4958,7 +4958,7 @@ ftrace_notrace_write(struct file *file, const char __user *ubuf,
 }
 
 static int
-ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
+__ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
 {
 	struct ftrace_func_entry *entry;
 
@@ -4976,9 +4976,25 @@ ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
 	return add_hash_entry(hash, ip);
 }
 
+static int
+ftrace_match_addr(struct ftrace_hash *hash, unsigned long *ips,
+		  unsigned int cnt, int remove)
+{
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < cnt; i++) {
+		err = __ftrace_match_addr(hash, ips[i], remove);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 static int
 ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
-		unsigned long ip, int remove, int reset, int enable)
+		unsigned long *ips, unsigned int cnt,
+		int remove, int reset, int enable)
 {
 	struct ftrace_hash **orig_hash;
 	struct ftrace_hash *hash;
@@ -5008,8 +5024,8 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 		ret = -EINVAL;
 		goto out_regex_unlock;
 	}
-	if (ip) {
-		ret = ftrace_match_addr(hash, ip, remove);
+	if (ips) {
+		ret = ftrace_match_addr(hash, ips, cnt, remove);
 		if (ret < 0)
 			goto out_regex_unlock;
 	}
@@ -5026,10 +5042,10 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 }
 
 static int
-ftrace_set_addr(struct ftrace_ops *ops, unsigned long ip, int remove,
-		int reset, int enable)
+ftrace_set_addr(struct ftrace_ops *ops, unsigned long *ips, unsigned int cnt,
+		int remove, int reset, int enable)
 {
-	return ftrace_set_hash(ops, NULL, 0, ip, remove, reset, enable);
+	return ftrace_set_hash(ops, NULL, 0, ips, cnt, remove, reset, enable);
 }
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
@@ -5634,10 +5650,29 @@ int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
 			 int remove, int reset)
 {
 	ftrace_ops_init(ops);
-	return ftrace_set_addr(ops, ip, remove, reset, 1);
+	return ftrace_set_addr(ops, &ip, 1, remove, reset, 1);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_filter_ip);
 
+/**
+ * ftrace_set_filter_ips - set a functions to filter on in ftrace by addresses
+ * @ops - the ops to set the filter with
+ * @ips - the array of addresses to add to or remove from the filter.
+ * @cnt - the number of addresses in @ips
+ * @remove - non zero to remove ips from the filter
+ * @reset - non zero to reset all filters before applying this filter.
+ *
+ * Filters denote which functions should be enabled when tracing is enabled
+ * If @ips array or any ip specified within is NULL , it fails to update filter.
+ */
+int ftrace_set_filter_ips(struct ftrace_ops *ops, unsigned long *ips,
+			  unsigned int cnt, int remove, int reset)
+{
+	ftrace_ops_init(ops);
+	return ftrace_set_addr(ops, ips, cnt, remove, reset, 1);
+}
+EXPORT_SYMBOL_GPL(ftrace_set_filter_ips);
+
 /**
  * ftrace_ops_set_global_filter - setup ops to use global filters
  * @ops - the ops which will use the global filters
@@ -5659,7 +5694,7 @@ static int
 ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 		 int reset, int enable)
 {
-	return ftrace_set_hash(ops, buf, len, 0, 0, reset, enable);
+	return ftrace_set_hash(ops, buf, len, NULL, 0, 0, reset, enable);
 }
 
 /**
-- 
2.33.1

