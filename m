Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88284455A2A
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343961AbhKRL32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:29:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46223 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343901AbhKRL2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:28:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aOPx437JJnxykUVvS3fHDcXPxIroZ8aiAi9DUKmIWiE=;
        b=KNx5KDLyYIGiP+MOQvgs6dkCbFY+hJO2+ua1T3r8nfzmdzkKMlS/OzIf0lQ9I0iVGEPpA+
        pJFYijDQ1zNn5eOrMQy5TNa37+9KTqhXpc8MR75KvszabSWjlV/soOMPF82mJgHCSIaEYZ
        TRM9AGJ7HRiSWEEY8Qpwywms59RyG0I=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-QGtM66PXNEO5_l7X59iV_g-1; Thu, 18 Nov 2021 06:25:16 -0500
X-MC-Unique: QGtM66PXNEO5_l7X59iV_g-1
Received: by mail-ed1-f70.google.com with SMTP id v10-20020aa7d9ca000000b003e7bed57968so4954517eds.23
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:25:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aOPx437JJnxykUVvS3fHDcXPxIroZ8aiAi9DUKmIWiE=;
        b=bEeEN/1E0ZO1J3hxFTSHZLuoR5uH6v6upJGD8Ou6tfT1aG9mtH33VHQZlCpzwigYYk
         1AJrr0f/nNj6V39XgsyUeBnXzlaPuDvs4Q3dW34L+BfVL3rXDyk9k5SuzQsjS+07g2MD
         ynCMlTm9sYLCQ2SN89RI1RSoB0yU3anLG1AaMqNUcrtjd6gWamC8vjo+Vhut76CvAFK1
         qPRXZYtuXHYE/+DfJyrdogeQoHLCOD1cGsC/ZD/jcJ8fuzSUxIfPUtk8WXu0WF0II8QL
         V3HOfGHzgxyQuVM3YRQZD57+LOS2k0P49EvclTyXTrVhp6eRmaIDmWp2EpKdAN4E3abt
         Bb0A==
X-Gm-Message-State: AOAM533PeSsAYq0bRwCZbc95O34umtKLbCTEHFElqvFKPfVLaBUQeLOC
        8DemzVnVTOBknwUe4ndIjm4KwY4izwh5XZSvVFWLughQJ+eQwB+EGzihvTJgBbcGvPWBfGiwJsD
        po5QNKg/nFrDQL26M
X-Received: by 2002:a17:906:974f:: with SMTP id o15mr32691472ejy.229.1637234715309;
        Thu, 18 Nov 2021 03:25:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxOov2hZwwKPIGKlNsoDOMYKKO4GIWaL19bfPkqeSwudPArCIhLayqKvZSWhhQ/ORkx5MW3Q==
X-Received: by 2002:a17:906:974f:: with SMTP id o15mr32691447ejy.229.1637234715148;
        Thu, 18 Nov 2021 03:25:15 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id ho17sm1140971ejc.111.2021.11.18.03.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:25:14 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Steven Rostedt <srostedt@vmware.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 03/29] ftrace: Add ftrace_set_filter_ips function
Date:   Thu, 18 Nov 2021 12:24:29 +0100
Message-Id: <20211118112455.475349-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding ftrace_set_filter_ips function to be able to set filter on
multiple ip addresses at once.

With the *direct_multi interface we have cases where we need to
initialize ftrace_ops object with thousands of functions, so having
single function diving into ftrace_hash_move_and_update_ops with
ftrace_lock is better.

The functions ips are passed as unsigned ong array with count.

Cc: Steven Rostedt <srostedt@vmware.com>
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
2.31.1

