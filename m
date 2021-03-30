Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D026B34F4A3
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 00:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbhC3WzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 18:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbhC3Wyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 18:54:35 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259E8C061574;
        Tue, 30 Mar 2021 15:54:32 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id q12so9041926qvc.8;
        Tue, 30 Mar 2021 15:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eFmHihTpoem5adT81kUPrW+58bPc31rODVCKQkE0csg=;
        b=Qw+scW22tFeCE65Wr0PhTMAUOS9zhNSx1efkAlrVbwzJ0cyXIZgxJv3uCoyMfMmwBg
         /IlitQ7KluxvcE7dtcrL9Ome1FOwXvAmQKx/O/cxVbGx8sp8R+LjP4JxC384Ea0JN5nU
         +X1Tnpcq4y3tsJmK+ZMpknYjkOXe90ntqukd9+Udq/irSqV2B6X0+3SYnuTrrITqiNf6
         vQW5kUtvxzjCjPemjML286i5sVGy18yUsBpHrmj2TfobkGlmEKjXYjFSzJ0vGnR7DVtZ
         2Yb/4j6q36gC8N30t4i4MU35x+4iv+ayjF5Aq031Eg+ahzg024nXOqsXsPuXupBG4JUs
         kUWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eFmHihTpoem5adT81kUPrW+58bPc31rODVCKQkE0csg=;
        b=bhMwZZ+W3yc1PoAKIVhwHUqro0QD2d9cseqEVzL2NCVFJhYTB4V5+8rw36JrVRoD3m
         S3Bqd7BvFjq3EFazLcidnjOSWlGWy2kCWTQhVmozueYy0b04och75VagTA9z+1kh3ZTs
         kDezeUKpguMs2X5Gi6ff3yH9JmvI2AgEuNplqHHjKF+Wtti6b4OW1dRJpju1BmTvMT+/
         2iNNUUxMjmMvzbXChfkC9UYDbDXvQEdunsq39g9MiW8xUMBGXvI5C+g5QiQmIpf/j04z
         HUtGKfCwBFhKdlEsfU2Achpcv+JgG/KB3CDbNPIF5FGCu/ZXfY/uAdDQmNayYch7MJSC
         t48g==
X-Gm-Message-State: AOAM5337MMLm7HrSHoXjkC/wWa5d5b+FLS7fR9KU4WRQwOVQIQamOhI+
        epqjuJqmih/b+pOfSJ+Z/lo=
X-Google-Smtp-Source: ABdhPJw7ulZ1m9vkjJFExetYhO1Zrab6HWWmNT64RuT1//039HoXsWBmOkcwfUKNntM0BYzXUOA/aQ==
X-Received: by 2002:a0c:f6cd:: with SMTP id d13mr518033qvo.20.1617144871216;
        Tue, 30 Mar 2021 15:54:31 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id b1sm129058qkk.117.2021.03.30.15.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 15:54:30 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list)
Cc:     Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH bpf-next v2] bpf: check flags in 'bpf_ringbuf_discard()' and 'bpf_ringbuf_submit()'
Date:   Tue, 30 Mar 2021 19:37:46 -0300
Message-Id: <20210330223748.399563-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 100cb2e4c104..38b0b15f99f0 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4073,7 +4073,7 @@ union bpf_attr {
  * 		Valid pointer with *size* bytes of memory available; NULL,
  * 		otherwise.
  *
- * void bpf_ringbuf_submit(void *data, u64 flags)
+ * long bpf_ringbuf_submit(void *data, u64 flags)
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
+ * long bpf_ringbuf_discard(void *data, u64 flags)
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
index 3d6d324184c0..a32eefb786f9 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4073,7 +4073,7 @@ union bpf_attr {
  * 		Valid pointer with *size* bytes of memory available; NULL,
  * 		otherwise.
  *
- * void bpf_ringbuf_submit(void *data, u64 flags)
+ * long bpf_ringbuf_submit(void *data, u64 flags)
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
+ * long bpf_ringbuf_discard(void *data, u64 flags)
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

