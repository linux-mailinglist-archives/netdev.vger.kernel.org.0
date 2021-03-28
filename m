Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471F734BD2B
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 18:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhC1QMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 12:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhC1QLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 12:11:45 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07484C061756;
        Sun, 28 Mar 2021 09:11:44 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id y2so7713878qtw.13;
        Sun, 28 Mar 2021 09:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qOxAbSv4oQR9JvPLWkGdDrb5Rd9zNV4UzWv0/jjmUno=;
        b=vQGqzyd20GvHr3nnyZat2RTZqfN8sUABi3dJ60KzUkIomALMK3ZFQOHMXLKi5T9jis
         ln80tZh3vuEqjbiGQO7mrteoF1FAQEmPOSsxCWVVZthbbUNECCXCuqIB/R9bD9ce12de
         4Fac8B2aAo4Zeahz8kuEvBMIGzr+r8q9FhglOH+ifgbMVBVA1ymNb2CxbrmqJDoouMFp
         yLRYda6Ln4wNHStvVr3DstzUKvkGWaJKf2MSU2wrh0abStQl1rAsGSjmjCdPra0lv3OY
         rLe+7cUTuiUAPrYY7FGxTdyrXrzkiAZ0Lq7k7gq5OciC6DuVNUP4LxFjNL/8kuIbYh9Y
         M6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qOxAbSv4oQR9JvPLWkGdDrb5Rd9zNV4UzWv0/jjmUno=;
        b=nqOehuzTUYDeyFRU2R9wJcFzRLE75/UCz8EZtoL6udBABp9QACdXM9adJycoc2Q3Et
         nr/Wfgcv41c3VaGQcpafrcwTBP8PCwu7jbDnISMJKumcD8DXfKuz2EjTGC4ZM7fut2ns
         iOcAMywOOo+BgLxcReqgHFNgwGGwLNgYzS4PDBFa/mAsNkNT10X2/1SeN43lxhSAEsMx
         bUDY9VR0F4hd42oXbKW6uhH7OihPPAb3Z/q1T555CPRlF5pahdMbYtGJ/VWyfM8VqTcP
         Hu+0Z+ANoISMSjwFUxG89kPqI1AVWomnQY5IDn9oqGOldXprA288a3FU2ri0wc1fMIX5
         paSg==
X-Gm-Message-State: AOAM531U3MD5j97TUErWIS+85ZQKuqhXi9t54w+TqGZVOKUhsKLbOWTc
        MebpQn3OYYMm0CT5wJKK9hw=
X-Google-Smtp-Source: ABdhPJzWVMi1VLKWqu3hQWDZMcuadRVOH57wAcQy3DSqT4gx3D0QZVZgN6qqKX8B3ko/zue+6TH/sg==
X-Received: by 2002:a05:622a:3c8:: with SMTP id k8mr19756748qtx.101.1616947903971;
        Sun, 28 Mar 2021 09:11:43 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id o7sm11275232qkb.104.2021.03.28.09.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 09:11:43 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Yang Li <yang.lee@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next] bpf: add 'BPF_RB_MAY_WAKEUP' flag
Date:   Sun, 28 Mar 2021 13:10:30 -0300
Message-Id: <20210328161055.257504-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current way to provide a no-op flag to 'bpf_ringbuf_submit()',
'bpf_ringbuf_discard()' and 'bpf_ringbuf_output()' is to provide a '0'
value.

A '0' value might notify the consumer if it already caught up in processing,
so let's provide a more descriptive notation for this value.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 include/uapi/linux/bpf.h                               | 8 ++++++++
 tools/include/uapi/linux/bpf.h                         | 8 ++++++++
 tools/testing/selftests/bpf/progs/ima.c                | 2 +-
 tools/testing/selftests/bpf/progs/ringbuf_bench.c      | 2 +-
 tools/testing/selftests/bpf/progs/test_ringbuf.c       | 2 +-
 tools/testing/selftests/bpf/progs/test_ringbuf_multi.c | 2 +-
 6 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 598716742593..100cb2e4c104 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4058,6 +4058,8 @@ union bpf_attr {
  * 		Copy *size* bytes from *data* into a ring buffer *ringbuf*.
  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
  * 		of new data availability is sent.
+ * 		If **BPF_RB_MAY_WAKEUP** is specified in *flags*, notification
+ * 		of new data availability is sent if needed.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
  * 	Return
@@ -4066,6 +4068,7 @@ union bpf_attr {
  * void *bpf_ringbuf_reserve(void *ringbuf, u64 size, u64 flags)
  * 	Description
  * 		Reserve *size* bytes of payload in a ring buffer *ringbuf*.
+ * 		*flags* must be 0.
  * 	Return
  * 		Valid pointer with *size* bytes of memory available; NULL,
  * 		otherwise.
@@ -4075,6 +4078,8 @@ union bpf_attr {
  * 		Submit reserved ring buffer sample, pointed to by *data*.
  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
  * 		of new data availability is sent.
+ * 		If **BPF_RB_MAY_WAKEUP** is specified in *flags*, notification
+ * 		of new data availability is sent if needed.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
  * 	Return
@@ -4085,6 +4090,8 @@ union bpf_attr {
  * 		Discard reserved ring buffer sample, pointed to by *data*.
  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
  * 		of new data availability is sent.
+ * 		If **BPF_RB_MAY_WAKEUP** is specified in *flags*, notification
+ * 		of new data availability is sent if needed.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
  * 	Return
@@ -4965,6 +4972,7 @@ enum {
  * BPF_FUNC_bpf_ringbuf_output flags.
  */
 enum {
+	BPF_RB_MAY_WAKEUP		= 0,
 	BPF_RB_NO_WAKEUP		= (1ULL << 0),
 	BPF_RB_FORCE_WAKEUP		= (1ULL << 1),
 };
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ab9f2233607c..3d6d324184c0 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4058,6 +4058,8 @@ union bpf_attr {
  * 		Copy *size* bytes from *data* into a ring buffer *ringbuf*.
  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
  * 		of new data availability is sent.
+ * 		If **BPF_RB_MAY_WAKEUP** is specified in *flags*, notification
+ * 		of new data availability is sent if needed.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
  * 	Return
@@ -4066,6 +4068,7 @@ union bpf_attr {
  * void *bpf_ringbuf_reserve(void *ringbuf, u64 size, u64 flags)
  * 	Description
  * 		Reserve *size* bytes of payload in a ring buffer *ringbuf*.
+ * 		*flags* must be 0.
  * 	Return
  * 		Valid pointer with *size* bytes of memory available; NULL,
  * 		otherwise.
@@ -4075,6 +4078,8 @@ union bpf_attr {
  * 		Submit reserved ring buffer sample, pointed to by *data*.
  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
  * 		of new data availability is sent.
+ * 		If **BPF_RB_MAY_WAKEUP** is specified in *flags*, notification
+ * 		of new data availability is sent if needed.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
  * 	Return
@@ -4085,6 +4090,8 @@ union bpf_attr {
  * 		Discard reserved ring buffer sample, pointed to by *data*.
  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
  * 		of new data availability is sent.
+ * 		If **BPF_RB_MAY_WAKEUP** is specified in *flags*, notification
+ * 		of new data availability is sent if needed.
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
  * 	Return
@@ -4959,6 +4966,7 @@ enum {
  * BPF_FUNC_bpf_ringbuf_output flags.
  */
 enum {
+	BPF_RB_MAY_WAKEUP		= 0,
 	BPF_RB_NO_WAKEUP		= (1ULL << 0),
 	BPF_RB_FORCE_WAKEUP		= (1ULL << 1),
 };
diff --git a/tools/testing/selftests/bpf/progs/ima.c b/tools/testing/selftests/bpf/progs/ima.c
index 96060ff4ffc6..0f4daced6aad 100644
--- a/tools/testing/selftests/bpf/progs/ima.c
+++ b/tools/testing/selftests/bpf/progs/ima.c
@@ -38,7 +38,7 @@ void BPF_PROG(ima, struct linux_binprm *bprm)
 			return;
 
 		*sample = ima_hash;
-		bpf_ringbuf_submit(sample, 0);
+		bpf_ringbuf_submit(sample, BPF_RB_MAY_WAKEUP);
 	}
 
 	return;
diff --git a/tools/testing/selftests/bpf/progs/ringbuf_bench.c b/tools/testing/selftests/bpf/progs/ringbuf_bench.c
index 123607d314d6..808e2e0e3d64 100644
--- a/tools/testing/selftests/bpf/progs/ringbuf_bench.c
+++ b/tools/testing/selftests/bpf/progs/ringbuf_bench.c
@@ -24,7 +24,7 @@ static __always_inline long get_flags()
 	long sz;
 
 	if (!wakeup_data_size)
-		return 0;
+		return BPF_RB_MAY_WAKEUP;
 
 	sz = bpf_ringbuf_query(&ringbuf, BPF_RB_AVAIL_DATA);
 	return sz >= wakeup_data_size ? BPF_RB_FORCE_WAKEUP : BPF_RB_NO_WAKEUP;
diff --git a/tools/testing/selftests/bpf/progs/test_ringbuf.c b/tools/testing/selftests/bpf/progs/test_ringbuf.c
index 8ba9959b036b..03a5cbd21356 100644
--- a/tools/testing/selftests/bpf/progs/test_ringbuf.c
+++ b/tools/testing/selftests/bpf/progs/test_ringbuf.c
@@ -21,7 +21,7 @@ struct {
 /* inputs */
 int pid = 0;
 long value = 0;
-long flags = 0;
+long flags = BPF_RB_MAY_WAKEUP;
 
 /* outputs */
 long total = 0;
diff --git a/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c b/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c
index edf3b6953533..f33c3fdfb1d6 100644
--- a/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c
+++ b/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c
@@ -71,7 +71,7 @@ int test_ringbuf(void *ctx)
 	sample->seq = total;
 	total += 1;
 
-	bpf_ringbuf_submit(sample, 0);
+	bpf_ringbuf_submit(sample, BPF_RB_MAY_WAKEUP);
 
 	return 0;
 }
-- 
2.25.1

