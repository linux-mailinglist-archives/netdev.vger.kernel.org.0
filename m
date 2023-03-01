Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20276A703D
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjCAPvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjCAPvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:51:16 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C107460B6;
        Wed,  1 Mar 2023 07:51:05 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id q31-20020a17090a17a200b0023750b69614so13395235pja.5;
        Wed, 01 Mar 2023 07:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677685864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4DPxaA2KI42WAf76J1TanSD7CSM/V5DVF96yv7d/wc=;
        b=EIQ7A/TQ7fUfT9sOtpVnwbN3FCuKT5ph7fowyHWRXS+5BkLiTCjwpZy7qO94/hlVsa
         zUyeUMq0u8HLnLh2Bptv8vJOett9qXR2ukG9vCHBxZK9smian0GKGwB2guc+8cF4Yznf
         jNIRoouqZdGw4A5OPTaWiwgS1yPJuE0WE/vQGunq9kd3JFwfHaTnmyobgJBSEGZIMiF9
         6dykfjskY10r2bHO7W+xNVY01SyKUZesewVG19cgdO6AWLo/tpHn9p+pDgxT/fTLfnOb
         M5Ro3Ro4swii/SDA5wQcQQYqkWw/xBka7wheWrgGZFnwjyuvFHSH/E2mgO0u+8vcmO8P
         vi9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677685864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4DPxaA2KI42WAf76J1TanSD7CSM/V5DVF96yv7d/wc=;
        b=BCoaa236AQDvydHzJdZVPUyQKqk1g5M+Q9TY11bT677JWFPhlBQPcHGPOa2oMtQJlz
         c4pXFzNazXO2OwmNZORG77iLZwDuksiBzIHN/oOlM5ODeujrAIUbFYnekKdiptV2Tw0I
         KCXPXEq1VJJWAcQvNVxFY6XFHHnUoF2/r86QYOu+Vv3lagXkQIvJYg16gBUntWsNjk+P
         oHO8jhYJIDO8M/Sf6Q4xn1OoaPDao1Sm2d2SQTxnneaE+fLTREJtPs4l6R3/ebU4rd7b
         erCQJT2ZQz0KYX58PUWfc5p7WIAbI7MK1DlTB4Aece60k8IdQpC2KzzM5vqiD1sn+J6Y
         i9eg==
X-Gm-Message-State: AO0yUKUubIGsyy+Zy5KXIuBr3EFWyBF/50/GA7idLNVzqWsITg5KWePm
        C3ui71tZWq+FyD/bN+7nNbmu8ZyN49M=
X-Google-Smtp-Source: AK7set9tA06H3MkU2MbpWGhaKJE2cTn5in+oadiPHTa0nCZPsxUzil2Uc2TIc3LGzaCPWmtLwIgEDw==
X-Received: by 2002:a05:6a20:548a:b0:c6:bd82:ea2d with SMTP id i10-20020a056a20548a00b000c6bd82ea2dmr10089053pzk.2.1677685864330;
        Wed, 01 Mar 2023 07:51:04 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id c9-20020a637249000000b00502f20aa4desm7589490pgn.70.2023.03.01.07.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 07:51:03 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v13 bpf-next 04/10] bpf: Define no-ops for externally called bpf dynptr functions
Date:   Wed,  1 Mar 2023 07:49:47 -0800
Message-Id: <20230301154953.641654-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230301154953.641654-1-joannelkoong@gmail.com>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some bpf dynptr functions will be called from places where
if CONFIG_BPF_SYSCALL is not set, then the dynptr function is
undefined. For example, when skb type dynptrs are added in the
next commit, dynptr functions are called from net/core/filter.c

This patch defines no-op implementations of these dynptr functions
so that they do not break compilation by being an undefined reference.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/bpf.h | 75 +++++++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 30 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 520b238abd5a..296841a31749 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1124,6 +1124,33 @@ static __always_inline __nocfi unsigned int bpf_dispatcher_nop_func(
 	return bpf_func(ctx, insnsi);
 }
 
+/* the implementation of the opaque uapi struct bpf_dynptr */
+struct bpf_dynptr_kern {
+	void *data;
+	/* Size represents the number of usable bytes of dynptr data.
+	 * If for example the offset is at 4 for a local dynptr whose data is
+	 * of type u64, the number of usable bytes is 4.
+	 *
+	 * The upper 8 bits are reserved. It is as follows:
+	 * Bits 0 - 23 = size
+	 * Bits 24 - 30 = dynptr type
+	 * Bit 31 = whether dynptr is read-only
+	 */
+	u32 size;
+	u32 offset;
+} __aligned(8);
+
+enum bpf_dynptr_type {
+	BPF_DYNPTR_TYPE_INVALID,
+	/* Points to memory that is local to the bpf program */
+	BPF_DYNPTR_TYPE_LOCAL,
+	/* Underlying data is a ringbuf record */
+	BPF_DYNPTR_TYPE_RINGBUF,
+};
+
+int bpf_dynptr_check_size(u32 size);
+u32 bpf_dynptr_get_size(const struct bpf_dynptr_kern *ptr);
+
 #ifdef CONFIG_BPF_JIT
 int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr);
 int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr);
@@ -2266,6 +2293,11 @@ static inline bool has_current_bpf_ctx(void)
 }
 
 void notrace bpf_prog_inc_misses_counter(struct bpf_prog *prog);
+
+void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
+		     enum bpf_dynptr_type type, u32 offset, u32 size);
+void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr);
+void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr);
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
@@ -2495,6 +2527,19 @@ static inline void bpf_prog_inc_misses_counter(struct bpf_prog *prog)
 static inline void bpf_cgrp_storage_free(struct cgroup *cgroup)
 {
 }
+
+static inline void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
+				   enum bpf_dynptr_type type, u32 offset, u32 size)
+{
+}
+
+static inline void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr)
+{
+}
+
+static inline void bpf_dynptr_set_rdonly(struct bpf_dynptr_kern *ptr)
+{
+}
 #endif /* CONFIG_BPF_SYSCALL */
 
 void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
@@ -2913,36 +2958,6 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 			u32 num_args, struct bpf_bprintf_data *data);
 void bpf_bprintf_cleanup(struct bpf_bprintf_data *data);
 
-/* the implementation of the opaque uapi struct bpf_dynptr */
-struct bpf_dynptr_kern {
-	void *data;
-	/* Size represents the number of usable bytes of dynptr data.
-	 * If for example the offset is at 4 for a local dynptr whose data is
-	 * of type u64, the number of usable bytes is 4.
-	 *
-	 * The upper 8 bits are reserved. It is as follows:
-	 * Bits 0 - 23 = size
-	 * Bits 24 - 30 = dynptr type
-	 * Bit 31 = whether dynptr is read-only
-	 */
-	u32 size;
-	u32 offset;
-} __aligned(8);
-
-enum bpf_dynptr_type {
-	BPF_DYNPTR_TYPE_INVALID,
-	/* Points to memory that is local to the bpf program */
-	BPF_DYNPTR_TYPE_LOCAL,
-	/* Underlying data is a kernel-produced ringbuf record */
-	BPF_DYNPTR_TYPE_RINGBUF,
-};
-
-void bpf_dynptr_init(struct bpf_dynptr_kern *ptr, void *data,
-		     enum bpf_dynptr_type type, u32 offset, u32 size);
-void bpf_dynptr_set_null(struct bpf_dynptr_kern *ptr);
-int bpf_dynptr_check_size(u32 size);
-u32 bpf_dynptr_get_size(const struct bpf_dynptr_kern *ptr);
-
 #ifdef CONFIG_BPF_LSM
 void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype);
 void bpf_cgroup_atype_put(int cgroup_atype);
-- 
2.34.1

