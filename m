Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE6D46DC46
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239595AbhLHTga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:36:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239598AbhLHTg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:36:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638991977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YQ1E78Ne8vjALFP2xkCWPlT3pLBIYO8xU81gXWhpDuU=;
        b=hFxv2c31WVmz4xt6w8Y3Owcz4LZozYM1vJLpnKOfRjppt+r2eazVQ24ed70KCM4aiQyihy
        kGLIUVZbA87sUbA4qPP+SkofRMkz8wEO6l+N2EPwfDxUlgsCa6ci4UiN/msJQEDCfRfhne
        B4MhB47mbuL+u4+K6ZEVIAPm/9bTgAE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-aAiESaZOM0Cn-DDu6PLk6w-1; Wed, 08 Dec 2021 14:32:55 -0500
X-MC-Unique: aAiESaZOM0Cn-DDu6PLk6w-1
Received: by mail-wm1-f70.google.com with SMTP id v62-20020a1cac41000000b0033719a1a714so1794381wme.6
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 11:32:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YQ1E78Ne8vjALFP2xkCWPlT3pLBIYO8xU81gXWhpDuU=;
        b=m93SHgH5KZBvmGZ5oJr1QD5VXjxbLahHJ8S5pCmhlV95gvU7Mp1zM6wRRLoMY2uYCX
         KmQfMP+zKOlRvxMGU2YemwU3fppFgXpXdUdApw4rab2CA9TGasUb3eVG2mvAldePoU55
         n0l1HvVVVm5Cr/+2l3BaroloRLmLpTTHQv53NoCFA15WDncVy+khelvUEWsACh3/Gvcx
         6Z2NOWkQAispsS7T3owrVOTB4yVIyY1u134WXEatT5qgN3ymC/nhjm8pINu85VW1o97v
         fgpLkqi0Te8B8+IrobPTHqMHRjFMRGkYAvj5uLNlMoMnKN4AZhXh4gpOJNAR8UpL+sY7
         ItxA==
X-Gm-Message-State: AOAM533sCej7Vu3/ydBFgl3zrNL8E+LpKHUaXoxKTFDq4sCT9s52lifI
        JfHUWjnlGW2ng/pakYiHOsv6StG7FkJE8Ta9uwNtiMZG592kUdSo9ktSC2GjKjyysrZaGseTAU5
        Z3wos9rFUOjiXqnUw
X-Received: by 2002:a7b:ca55:: with SMTP id m21mr921554wml.178.1638991974459;
        Wed, 08 Dec 2021 11:32:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwf1JmKxMS+ShochuP7Q0LlIlxnITOIcrKgvNRny3DBK05gXMQVdOsFNxRyq3o7taqCwiaDtA==
X-Received: by 2002:a7b:ca55:: with SMTP id m21mr921520wml.178.1638991974219;
        Wed, 08 Dec 2021 11:32:54 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id g13sm3497338wmk.37.2021.12.08.11.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:32:53 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCHv2 bpf-next 1/5] bpf: Allow access to int pointer arguments in tracing programs
Date:   Wed,  8 Dec 2021 20:32:41 +0100
Message-Id: <20211208193245.172141-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211208193245.172141-1-jolsa@kernel.org>
References: <20211208193245.172141-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to access arguments with int pointer arguments
in tracing programs.

Currently we allow tracing programs to access only pointers to
string (char pointer), void pointers and pointers to structs.

If we try to access argument which is pointer to int, verifier
will fail to load the program with;

  R1 type=ctx expected=fp
  ; int BPF_PROG(fmod_ret_test, int _a, __u64 _b, int _ret)
  0: (bf) r6 = r1
  ; int BPF_PROG(fmod_ret_test, int _a, __u64 _b, int _ret)
  1: (79) r9 = *(u64 *)(r6 +8)
  func 'bpf_modify_return_test' arg1 type INT is not a struct

There is no harm for the program to access int pointer argument.
We are already doing that for string pointer, which is pointer
to int with 1 byte size.

Changing the is_string_ptr to generic integer check and renaming
it to btf_type_is_int.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/btf.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 01b47d4df3ab..8a79e906dabb 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4826,7 +4826,7 @@ struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
 		return prog->aux->attach_btf;
 }
 
-static bool is_string_ptr(struct btf *btf, const struct btf_type *t)
+static bool is_int_ptr(struct btf *btf, const struct btf_type *t)
 {
 	/* t comes in already as a pointer */
 	t = btf_type_by_id(btf, t->type);
@@ -4835,8 +4835,7 @@ static bool is_string_ptr(struct btf *btf, const struct btf_type *t)
 	if (BTF_INFO_KIND(t->info) == BTF_KIND_CONST)
 		t = btf_type_by_id(btf, t->type);
 
-	/* char, signed char, unsigned char */
-	return btf_type_is_int(t) && t->size == 1;
+	return btf_type_is_int(t);
 }
 
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
@@ -4957,7 +4956,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		 */
 		return true;
 
-	if (is_string_ptr(btf, t))
+	if (is_int_ptr(btf, t))
 		return true;
 
 	/* this is a pointer to another type */
-- 
2.33.1

