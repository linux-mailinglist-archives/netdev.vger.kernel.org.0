Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75F734BD2F
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 18:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhC1QMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 12:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhC1QMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 12:12:19 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9DCC061756;
        Sun, 28 Mar 2021 09:12:19 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id l13so7733805qtu.9;
        Sun, 28 Mar 2021 09:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EoB1lzpwxAqyu9em5N+FxcoQ8XVr6mBu39binMjHk4s=;
        b=Wxoep/cEAj+Tq6gmNkUBd1h8eDxK2s8DsrD0u0QVXkDDhksgXUF7RzylmGKA6JZBh6
         shglOGvmkIri/7ycrZGAoY7OXP1p8St5iw0R/Aa/UPEMYtb1A2bp3HHaoLxL1ryg8Zyr
         GO2RBGiRItEP/70K1JFd1IeA3pnrldH0zxq2lpBWWG+rUXqlCL3kJHeLr8qVaGdMrBQ8
         Iqnv6qJVNX+A7tgPODPt5MhV6Y8wMd+yIKm8VrpREO26qHeBX7g7gSju1q6yRc7HOWs5
         IopJipqSJ+GNFmonbpzO0CNbvIMGy0A+M/Lxx/FkgAkX3LPqMuVJDgPekUbwtBPog4yN
         RP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EoB1lzpwxAqyu9em5N+FxcoQ8XVr6mBu39binMjHk4s=;
        b=V6MYtfF0lpPbwOzoeVQW986wuEseRWnquNQxBm00oXS8WZ7+BlYFcNpGkq47gYnP0P
         wEzpXT3moX9HsDIaqiWuAHtcNR7W5A/oWldMv5wWjKHV90xUAsQAijoyTxner5/C+pmN
         RFLM5vcm9mwZbnNPU373z6FSS5g0C83NA1Ug2qg1pCVIXjvisR76/TqYRW05W+nnF53R
         OSA7COh5oe1xgkZnicxo3SV03r9csNpSbuf1GRuHAxvs2n9n2yQ9lgygLXpRdzV18pic
         ZfIL9ncI3J0/RM5RIDQy2YXOgEeP0xhBm3c99yY/6qqbqGiuariBq/j+3tKTEv9vRFU8
         XGsA==
X-Gm-Message-State: AOAM53327w5bKypurYa47SbfaMg7SISQlDqHryiEWbnNLU/4LxSkhEY3
        +HPW5wmmpGk9tud7PQOOUns=
X-Google-Smtp-Source: ABdhPJxa6nd3aqepLvErlJ9Ev8tSzRlw1CqYdwAeShDlpBaokev8LcBhp0H3Gv6qKO4d/DUa2Bn6Vg==
X-Received: by 2002:ac8:702:: with SMTP id g2mr19879403qth.215.1616947938463;
        Sun, 28 Mar 2021 09:12:18 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id o7sm11275232qkb.104.2021.03.28.09.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 09:12:18 -0700 (PDT)
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
Subject: [PATCH bpf-next] bpf: check flags in 'bpf_ringbuf_discard()' and 'bpf_ringbuf_submit()'
Date:   Sun, 28 Mar 2021 13:10:31 -0300
Message-Id: <20210328161055.257504-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210328161055.257504-1-pctammela@mojatatu.com>
References: <20210328161055.257504-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code only checks flags in 'bpf_ringbuf_output()'.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 include/uapi/linux/bpf.h       |  8 ++++----
 kernel/bpf/ringbuf.c           | 13 +++++++++++--
 tools/include/uapi/linux/bpf.h |  8 ++++----
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 100cb2e4c104..232b5e5dd045 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4073,7 +4073,7 @@ union bpf_attr {
  * 		Valid pointer with *size* bytes of memory available; NULL,
  * 		otherwise.
  *
- * void bpf_ringbuf_submit(void *data, u64 flags)
+ * int bpf_ringbuf_submit(void *data, u64 flags)
  * 	Description
  * 		Submit reserved ring buffer sample, pointed to by *data*.
  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
@@ -4083,9 +4083,9 @@ union bpf_attr {
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
  * 	Return
- * 		Nothing. Always succeeds.
+ * 		0 on success, or a negative error in case of failure.
  *
- * void bpf_ringbuf_discard(void *data, u64 flags)
+ * int bpf_ringbuf_discard(void *data, u64 flags)
  * 	Description
  * 		Discard reserved ring buffer sample, pointed to by *data*.
  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
@@ -4095,7 +4095,7 @@ union bpf_attr {
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
  * 	Return
- * 		Nothing. Always succeeds.
+ * 		0 on success, or a negative error in case of failure.
  *
  * u64 bpf_ringbuf_query(void *ringbuf, u64 flags)
  *	Description
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index f25b719ac786..f76dafe2427e 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -397,26 +397,35 @@ static void bpf_ringbuf_commit(void *sample, u64 flags, bool discard)
 
 BPF_CALL_2(bpf_ringbuf_submit, void *, sample, u64, flags)
 {
+	if (unlikely(flags & ~(BPF_RB_NO_WAKEUP | BPF_RB_FORCE_WAKEUP)))
+		return -EINVAL;
+
 	bpf_ringbuf_commit(sample, flags, false /* discard */);
+
 	return 0;
 }
 
 const struct bpf_func_proto bpf_ringbuf_submit_proto = {
 	.func		= bpf_ringbuf_submit,
-	.ret_type	= RET_VOID,
+	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_ALLOC_MEM,
 	.arg2_type	= ARG_ANYTHING,
 };
 
 BPF_CALL_2(bpf_ringbuf_discard, void *, sample, u64, flags)
 {
+
+	if (unlikely(flags & ~(BPF_RB_NO_WAKEUP | BPF_RB_FORCE_WAKEUP)))
+		return -EINVAL;
+
 	bpf_ringbuf_commit(sample, flags, true /* discard */);
+
 	return 0;
 }
 
 const struct bpf_func_proto bpf_ringbuf_discard_proto = {
 	.func		= bpf_ringbuf_discard,
-	.ret_type	= RET_VOID,
+	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_ALLOC_MEM,
 	.arg2_type	= ARG_ANYTHING,
 };
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 3d6d324184c0..d19c8c2688a2 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4073,7 +4073,7 @@ union bpf_attr {
  * 		Valid pointer with *size* bytes of memory available; NULL,
  * 		otherwise.
  *
- * void bpf_ringbuf_submit(void *data, u64 flags)
+ * int bpf_ringbuf_submit(void *data, u64 flags)
  * 	Description
  * 		Submit reserved ring buffer sample, pointed to by *data*.
  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
@@ -4083,9 +4083,9 @@ union bpf_attr {
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
  * 	Return
- * 		Nothing. Always succeeds.
+ * 		0 on success, or a negative error in case of failure.
  *
- * void bpf_ringbuf_discard(void *data, u64 flags)
+ * int bpf_ringbuf_discard(void *data, u64 flags)
  * 	Description
  * 		Discard reserved ring buffer sample, pointed to by *data*.
  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
@@ -4095,7 +4095,7 @@ union bpf_attr {
  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
  * 		of new data availability is sent unconditionally.
  * 	Return
- * 		Nothing. Always succeeds.
+ * 		0 on success, or a negative error in case of failure.
  *
  * u64 bpf_ringbuf_query(void *ringbuf, u64 flags)
  *	Description
-- 
2.25.1

