Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AE138906F
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354364AbhESORQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354067AbhESOPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:15:53 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC7FC061353;
        Wed, 19 May 2021 07:14:16 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id z130so7387206wmg.2;
        Wed, 19 May 2021 07:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TgZRck3xYV0eFV5WJ+ErP6x1msBFrX+wPITeA+FZUrM=;
        b=GuQ5Akj8Ly+gdqTeAq5q22pTqo7tXEPeY6AwdcM/dr9/gL5j8OOLLuHWkolLSAwh8e
         TZbp9Pl89OiCF2xbGd+50tvoPPMzq6MXiaY0mHUJE6gMBT1rQGQbOHMr4ryvO7zA2yZ7
         VnxGiOB1KoDFdgyk0AtfZrGUcYaE/aGEZacSx5ouWMx60eGWLCVe/QJL89T3tElz4E6k
         iFa5QsVDV29YonGlYcPMhNgbiZvPZdvDrfQWnekENszuBRsgg3iAz41si2GFCyj+UJgc
         jSNt0BcHHnSKzysHRk1rmQxTLtJpUPrqoIRLwhYjMxh4gFXVI6AaFKTKl31cxtEO+3F5
         0U+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TgZRck3xYV0eFV5WJ+ErP6x1msBFrX+wPITeA+FZUrM=;
        b=YvirdeUIawYgYvjQoSuYyM/lBrj6mC19l08f0h5EonxpWH5cugG9fnoqW9gNomjEdE
         v8YyPLyRMgc6MLJJoH4OqfKJlMIdUnoTSd2FSADyYgBt7qKNW5k0l6DY6N/fAkuiNFYt
         DKQJrDEHUVplCjfyIZE+CQBzXdiayNRz6sqd/iRkVLk9W/x2IskvW51nUWCKUs0NY3wc
         paVFr6reuiQcInBIGpxXusIEgHwsqCdTDDEpuu77zC9RMqUGczfwkxgpjenrGKRuqc4s
         /+AUZZP7x8ioO1mkN9cHwUCOzEu/M8mw2yML6YP8YdABCJWul3HxXdMgVBTbzZEokxUK
         VQqg==
X-Gm-Message-State: AOAM531e1r5ZiYqbmiS7E7eK4/8Sez0OoFRFDsxUG6arhFjS4SdF1ioR
        uEdFZBQLsx5QiasMq3G+nP99SHcZzewyQ0Y3
X-Google-Smtp-Source: ABdhPJw+wd+UozFtpbl+Z/t/uneOgX1/Bte3KlOFMiTkRTMRQj1OIuk8/XQSGR+LbC3/ff7nMycKSQ==
X-Received: by 2002:a1c:7e45:: with SMTP id z66mr11790687wmc.126.1621433654771;
        Wed, 19 May 2021 07:14:14 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:14:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Subject: [PATCH 20/23] bpf: Add bpf_copy_to_user() helper
Date:   Wed, 19 May 2021 15:13:31 +0100
Message-Id: <dd32e4ad90c998669256bd01a9d67c99a3d535e3.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to bpf_copy_from_user(), also allow sleepable BPF programs
to write to user memory.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  8 ++++++++
 kernel/bpf/helpers.c           | 17 +++++++++++++++++
 tools/include/uapi/linux/bpf.h |  7 +++++++
 4 files changed, 33 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 00597b0c719c..9b775e2b2a01 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1899,6 +1899,7 @@ extern const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
 extern const struct bpf_func_proto bpf_copy_from_user_proto;
+extern const struct bpf_func_proto bpf_copy_to_user_proto;
 extern const struct bpf_func_proto bpf_snprintf_btf_proto;
 extern const struct bpf_func_proto bpf_per_cpu_ptr_proto;
 extern const struct bpf_func_proto bpf_this_cpu_ptr_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 7719ec4a33e7..6f19839d2b05 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3648,6 +3648,13 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
+ * long bpf_copy_to_user(void *user_ptr, const void *src, u32 size)
+ * 	Description
+ * 		Read *size* bytes from *src* and store the data in user space
+ * 		address *user_ptr*. This is a wrapper of **copy_to_user**\ ().
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
  * long bpf_snprintf_btf(char *str, u32 str_size, struct btf_ptr *ptr, u32 btf_ptr_size, u64 flags)
  *	Description
  *		Use BTF to store a string representation of *ptr*->ptr in *str*,
@@ -4085,6 +4092,7 @@ union bpf_attr {
 	FN(iouring_queue_sqe),		\
 	FN(iouring_emit_cqe),		\
 	FN(iouring_reap_cqe),		\
+	FN(copy_to_user),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 308427fe03a3..9d7814c564e5 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -634,6 +634,23 @@ const struct bpf_func_proto bpf_copy_from_user_proto = {
 	.arg3_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_3(bpf_copy_to_user, void __user *, user_ptr,
+	   const void *, src, u32, size)
+{
+	int ret = copy_to_user(user_ptr, src, size);
+
+	return ret ? -EFAULT : 0;
+}
+
+const struct bpf_func_proto bpf_copy_to_user_proto = {
+	.func		= bpf_copy_to_user,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
+};
+
 BPF_CALL_2(bpf_per_cpu_ptr, const void *, ptr, u32, cpu)
 {
 	if (cpu >= nr_cpu_ids)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 79c893310492..18d497247d69 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3647,6 +3647,13 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
+ * long bpf_copy_to_user(void *user_ptr, const void *src, u32 size)
+ * 	Description
+ * 		Read *size* bytes from *src* and store the data in user space
+ * 		address *user_ptr*. This is a wrapper of **copy_to_user**\ ().
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
  * long bpf_snprintf_btf(char *str, u32 str_size, struct btf_ptr *ptr, u32 btf_ptr_size, u64 flags)
  *	Description
  *		Use BTF to store a string representation of *ptr*->ptr in *str*,
-- 
2.31.1

