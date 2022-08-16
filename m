Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C667859596C
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235300AbiHPLHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbiHPLG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:06:57 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00A6FFD;
        Tue, 16 Aug 2022 03:36:31 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id z187so8974327pfb.12;
        Tue, 16 Aug 2022 03:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=5A5RtN/YS/4w7sXimiNz+39ndA1ngcqHQiad4s8fg4Q=;
        b=i6P3O5ievivOXk5mzbsJWm6wlAnJEdrEfilGpTvRGnyai46rxm0+Jxp11BbZf4IsKj
         qO97j0j41kC2x7RN6OHQ5vKhu3lUys1t4Y/+GkEuD9xgT/9qOQNr3CRdg6oE1xXIBPeJ
         ynhUqnRAtvl35XghDcmpU28lgm0ECn2J1dvMqcf3vlfFFhlWg1IRbPXGhMBWZoKhsFwa
         xQFqWuBeH0sO4xR/fjRkJWxPidM8yOpSI+msEzo9XfCYVIqj4/B4g4B0FcEESZHhcxV0
         /jObHO/tfzPys3En7Dz6pDXNkWxwZgmanen3mAEOEL3lgL110Iz6twsy/infxn/w03bi
         DfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=5A5RtN/YS/4w7sXimiNz+39ndA1ngcqHQiad4s8fg4Q=;
        b=dDBtcD4dfzW/X/5s7EeR6dMAOm9IdGFJD7Hcq8VHc1CZeWd9FJ3iuef7nrKpTbE4y4
         sD5N+ENdD6qyyKJB60QkTq8Yu+5tJkiNKr2LqW3TkTZVdNJYOTdQ3kUWlVYlRE6Yfpo8
         yDhvXMPU73FxeiCI5r1ZzU6vb5KDfrY1AXOlAlU2NugKN8Ga2lECwBYwTpZUQuUEdD82
         tRgTq5XnBY3IS3E8VDS2fyRKbpfVOtj7pETWkozH5nB+IqJJ3j5SUMGPOKd5utWbk86h
         PoQjgTRPIzznRiAy5663OF+764AY4OR5/DcmXEJZdptJ7LUZxzgIhulxhlkbTsIexio5
         djeA==
X-Gm-Message-State: ACgBeo2RIIbGWxghv4jrAm6fzm/HVX68sjjQNXfafKCMeGLM8CYtt+1C
        +BearPuihUXnzGxS6dVy/jg=
X-Google-Smtp-Source: AA6agR7VYoPwJ0fUKY7DGeSKdzzsM77Cgyq30uiP5ZbMuykBi4NKULWYUxSi8YlueLMCiucRw4dhxA==
X-Received: by 2002:a63:5620:0:b0:429:9ad7:b4f2 with SMTP id k32-20020a635620000000b004299ad7b4f2mr3326930pgb.162.1660646190469;
        Tue, 16 Aug 2022 03:36:30 -0700 (PDT)
Received: from localhost ([36.112.86.8])
        by smtp.gmail.com with ESMTPSA id a8-20020a170902ecc800b0016efbccf2c0sm8771705plh.56.2022.08.16.03.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 03:36:30 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        yin31149@gmail.com, linux-kernel-mentees@lists.linuxfoundation.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] net: Fix suspicious RCU usage in bpf_sk_reuseport_detach()
Date:   Tue, 16 Aug 2022 18:34:52 +0800
Message-Id: <20220816103452.479281-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <166064248071.3502205.10036394558814861778.stgit@warthog.procyon.org.uk>
References: <166064248071.3502205.10036394558814861778.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 at 17:34, David Howells <dhowells@redhat.com> wrote:
>
> Fix this by adding a new helper, __locked_read_sk_user_data_with_flags()
> that checks to see if sk->sk_callback_lock() is held and use that here
> instead.
Hi, I wonder if we make this more geniric, for I think maybe the future
code who use __rcu_dereference_sk_user_data_with_flags() may
also meet this bug.

To be more specific, maybe we can refactor
__rcu_dereference_sk_user_data_with_flags() to
__rcu_dereference_sk_user_data_with_flags_check(), like
rcu_dereference() and rcu_dereference_check(). Maybe:

diff --git a/include/net/sock.h b/include/net/sock.h
index 05a1bbdf5805..cf123954eab9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -578,18 +578,27 @@ static inline bool sk_user_data_is_nocopy(const struct sock *sk)
 #define __sk_user_data(sk) ((*((void __rcu **)&(sk)->sk_user_data)))
 
 /**
- * __rcu_dereference_sk_user_data_with_flags - return the pointer
- * only if argument flags all has been set in sk_user_data. Otherwise
- * return NULL
+ * __rcu_dereference_sk_user_data_with_flags_check - return the pointer
+ * only if argument flags all has been set in sk_user_data, with debug
+ * checking. Otherwise return NULL
  *
- * @sk: socket
- * @flags: flag bits
+ * Do __rcu_dereference_sk_user_data_with_flags(), but check that the
+ * conditions under which the rcu dereference will take place are correct,
+ * which is a bit like rcu_dereference_check() and rcu_derefence().
+ *
+ * @sk		: socket
+ * @flags	: flag bits
+ * @condition	: the conditions under which the rcu dereference will
+ * take place
  */
 static inline void *
-__rcu_dereference_sk_user_data_with_flags(const struct sock *sk,
-					  uintptr_t flags)
+__rcu_dereference_sk_user_data_with_flags_check(const struct sock *sk,
+						uintptr_t flags, bool condition)
 {
-	uintptr_t sk_user_data = (uintptr_t)rcu_dereference(__sk_user_data(sk));
+	uintptr_t sk_user_data;
+
+	sk_user_data = (uintptr_t)rcu_dereference_check(__sk_user_data(sk),
+							condition);
 
 	WARN_ON_ONCE(flags & SK_USER_DATA_PTRMASK);
 
@@ -598,6 +607,8 @@ __rcu_dereference_sk_user_data_with_flags(const struct sock *sk,
 	return NULL;
 }
 
+#define __rcu_dereference_sk_user_data_with_flags(sk, flags) \
+	__rcu_dereference_sk_user_data_with_flags_check(sk, flags, 0)
 #define rcu_dereference_sk_user_data(sk)				\
 	__rcu_dereference_sk_user_data_with_flags(sk, 0)
 #define __rcu_assign_sk_user_data_with_flags(sk, ptr, flags)		\

> +/**
> + * __locked_read_sk_user_data_with_flags - return the pointer
> + * only if argument flags all has been set in sk_user_data. Otherwise
> + * return NULL
> + *
> +               (uintptr_t)rcu_dereference_check(__sk_user_data(sk),
> +                                                lockdep_is_held(&sk->sk_callback_lock));

> diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
> index 85fa9dbfa8bf..82c61612f382 100644
> --- a/kernel/bpf/reuseport_array.c
> +++ b/kernel/bpf/reuseport_array.c
> @@ -24,7 +24,7 @@ void bpf_sk_reuseport_detach(struct sock *sk)
>         struct sock __rcu **socks;
> 
>         write_lock_bh(&sk->sk_callback_lock);
> -       socks = __rcu_dereference_sk_user_data_with_flags(sk, SK_USER_DATA_BPF);
> +       socks = __locked_read_sk_user_data_with_flags(sk, SK_USER_DATA_BPF);
>         if (socks) {
>                 WRITE_ONCE(sk->sk_user_data, NULL);
>                 /*
Then, as you point out, we can pass
condition(lockdep_is_held(&sk->sk_callback_lock)) to
__rcu_dereference_sk_user_data_with_flags_check() in order to
make compiler happy as below:

diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 85fa9dbfa8bf..a772610987c5 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -24,7 +24,10 @@ void bpf_sk_reuseport_detach(struct sock *sk)
 	struct sock __rcu **socks;
 
 	write_lock_bh(&sk->sk_callback_lock);
-	socks = __rcu_dereference_sk_user_data_with_flags(sk, SK_USER_DATA_BPF);
+	socks = __rcu_dereference_sk_user_data_with_flags_check(
+			sk, SK_USER_DATA_BPF,
+			lockdep_is_held(&sk->sk_callback_lock));
+
 	if (socks) {
 		WRITE_ONCE(sk->sk_user_data, NULL);
 		/*
