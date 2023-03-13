Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD9C6B8678
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjCMX7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjCMX7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:59:00 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836F860AB6;
        Mon, 13 Mar 2023 16:58:59 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id k18-20020a17090a591200b0023d36e30cb5so535158pji.1;
        Mon, 13 Mar 2023 16:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678751939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mwQ187piTg/LwOnQhafpEuDnmgMkumYLbSusILMjqAE=;
        b=E88p5WmcdiS4Xi58+SRapeAzO+vzrgb31ATDBG0hkCtNlJ9O8AxI/exsMgq4ber2yH
         +nEJB8B9vreIw+nRns1zqWv3gd3Rb6WwjsYtiGZ/oGsdO3LQYtGuhsKcxcYSkv7faLKA
         IfPgkY7YpO1bBodGtrLG25pWpyRi8CTHt6hLRKQQ61bKL/XBL4EPsnTqsDPwQfEY4Yr2
         py09giZ737vfUs1HOPVwwPMFkEQwG/nv/uPN1gRYcaRSOXu/sFakJdzMAiDz80PHJJyL
         5LLg9WFHKxekjlfqTT4LjGdlpZC7siCBTPgiDJmHvC770uac7b7waQGxjx3XCG76TNk+
         p3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678751939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mwQ187piTg/LwOnQhafpEuDnmgMkumYLbSusILMjqAE=;
        b=rzwHqZ3u5ZzD0uZHpqfXBBQOj3cvg2dgWP91II6PVaFMXmvdV49EBxkaUTNpcBX7Gh
         x1Smo5QGjuO21FuOKik4GOgCDfo4pWal0HvIUxNbLkZzPXTBo0Ln5rdTAM5SbZ3fKTjI
         Njj2TefkKkcMOqi0ZtiYUBo5oY+DuDhEciRElq2tBCzUE1cBNUi9Yy7AFuPyBZAoDvVm
         q9A2xiaauZjlIarKf5Hlwy6wIYASzZ/IgAzVXWj3u3ugPky1nYOHeUL75zoGPBWbs/tq
         wA1Ddg4VayB9uoh/Xa6ev2MGJSZo74woHpqnoDiOTWb2lhuNy4Y0AF9oYaNwwgPEypzz
         UorQ==
X-Gm-Message-State: AO0yUKXCdNjw4uZCUwDbvYrBWBS8cZT5hTtrgS4Ori5gSY6IFK2YnCsP
        Q5nLThi3U7O2lCEHUlVALCA=
X-Google-Smtp-Source: AK7set+EHgWNI4zzbIxvRrnZxV7UXPBLCTLCL8jhwoAbrUnOe9fsqJ3WqXLwCI1jrl+7broLqm9j1A==
X-Received: by 2002:a17:90b:1c88:b0:234:1d1d:6ae6 with SMTP id oo8-20020a17090b1c8800b002341d1d6ae6mr37264595pjb.1.1678751938986;
        Mon, 13 Mar 2023 16:58:58 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:ad6b])
        by smtp.gmail.com with ESMTPSA id p13-20020a17090a284d00b0023d0e743ff6sm409653pjf.3.2023.03.13.16.58.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Mar 2023 16:58:58 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 2/3] bpf: Allow helpers access trusted PTR_TO_BTF_ID.
Date:   Mon, 13 Mar 2023 16:58:44 -0700
Message-Id: <20230313235845.61029-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230313235845.61029-1-alexei.starovoitov@gmail.com>
References: <20230313235845.61029-1-alexei.starovoitov@gmail.com>
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

From: Alexei Starovoitov <ast@kernel.org>

The verifier rejects the code:
  bpf_strncmp(task->comm, 16, "my_task");
with the message:
  16: (85) call bpf_strncmp#182
  R1 type=trusted_ptr_ expected=fp, pkt, pkt_meta, map_key, map_value, mem, ringbuf_mem, buf

Teach the verifier that such access pattern is safe.
Do not allow untrusted and legacy ptr_to_btf_id to be passed into helpers.

Reported-by: David Vernet <void@manifault.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 883d4ff2e288..2bbd89279070 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6303,6 +6303,9 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 				env,
 				regno, reg->off, access_size,
 				zero_size_allowed, ACCESS_HELPER, meta);
+	case PTR_TO_BTF_ID:
+		return check_ptr_to_btf_access(env, regs, regno, reg->off,
+					       access_size, BPF_READ, -1);
 	case PTR_TO_CTX:
 		/* in case the function doesn't know how to access the context,
 		 * (because we are in a program of type SYSCALL for example), we
@@ -7014,6 +7017,7 @@ static const struct bpf_reg_types mem_types = {
 		PTR_TO_MEM,
 		PTR_TO_MEM | MEM_RINGBUF,
 		PTR_TO_BUF,
+		PTR_TO_BTF_ID | PTR_TRUSTED,
 	},
 };
 
@@ -7145,6 +7149,17 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 	if (base_type(reg->type) != PTR_TO_BTF_ID)
 		return 0;
 
+	if (compatible == &mem_types) {
+		if (!(arg_type & MEM_RDONLY)) {
+			verbose(env,
+				"%s() may write into memory pointed by R%d type=%s\n",
+				func_id_name(meta->func_id),
+				regno, reg_type_str(env, reg->type));
+			return -EACCES;
+		}
+		return 0;
+	}
+
 	switch ((int)reg->type) {
 	case PTR_TO_BTF_ID:
 	case PTR_TO_BTF_ID | PTR_TRUSTED:
-- 
2.34.1

