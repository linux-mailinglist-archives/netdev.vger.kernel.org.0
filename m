Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79936030CB
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 18:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiJRQ3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 12:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiJRQ3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 12:29:35 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0613F09;
        Tue, 18 Oct 2022 09:29:21 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id 13so33541911ejn.3;
        Tue, 18 Oct 2022 09:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3kT33+mNIFBJ/DJxtGCpSH0GNDOQJK7DLYP/xqwSgzc=;
        b=W7swoyXzIJAHfFFkFgPm0e9j3tls98PDd/9hIvON+rJrVUxtMkTv+jROg9rKGKsRBF
         i0fcSjrgRuxJoHU0pBU6mwl6ZjMPAUry3qhgIPLMjTcG8DTLCofddLB3ZhMrmAtnWPWU
         B+dLe/0vtuwGiYAPn30BKWQ4BFjVeQRFX4FEFyO4wzTd0dGtBiRadwuakNq9OAHJvZp5
         N8yV8BFYDWJJvvMZyuToLMSqIUTbg2ri6zCHJGViW64L5TP5NsIZltxb/3ODoQ4zSB6y
         Onm55aSiSJF1r1RWIinOmyHYppAKoFgYNW52I4EhHWojxO3P8q6LdtSqapaLPjozfD5R
         0UPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3kT33+mNIFBJ/DJxtGCpSH0GNDOQJK7DLYP/xqwSgzc=;
        b=XpcW88gO8I8Rk47Y/W98lDHZ9qQsnUA50QO2ZIzmB+tQUm91TMILpvIArS/xWXM9U6
         puwP2W2fDSDfqY4fuYnYAVXDmgPP5tqN4iPPmMUtvgL5nRPk1jDsdObEQWRElQKLZ4aq
         KoqnnEEfe0CXELIui7nqw9Z+lYLwK2OE7bhpJzeLrFulJM/sdAFY76no5B3IsGFeaI0D
         HaDffHIGddo7775lGJ4FPDQ+Hcfbc/aoVmuMuzL+jzajSRSRmOV5E9KiJ2Z93LOcZhdS
         IlRc0gwF0pB+5OvqdMuJ8vLvYjTibswiBNa1DIgTP732xLe9/hDtMP8+c+zn/WNvQoDr
         JHgA==
X-Gm-Message-State: ACrzQf14QQ6dy53EJ/wy8P1RO9CSpZLJGdtC9B4iKWQbA+nr9mDFjOyM
        9aA7fpQwZK7Ztp/0wzhrcW6+Q+Aw1WKZa5bmp2w=
X-Google-Smtp-Source: AMsMyM5WoWjJQAvW3IeWbUZgz575QczId7A8erat7mPlN60+d3oZxLYKHrysfuufSZGov0mVWUAwtVnQ3hHQSgHOLvM=
X-Received: by 2002:a17:907:7f93:b0:791:91a6:5615 with SMTP id
 qk19-20020a1709077f9300b0079191a65615mr3246670ejc.708.1666110558666; Tue, 18
 Oct 2022 09:29:18 -0700 (PDT)
MIME-Version: 1.0
References: <20221018090205.never.090-kees@kernel.org>
In-Reply-To: <20221018090205.never.090-kees@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Oct 2022 09:29:07 -0700
Message-ID: <CAADnVQKBfPeDqHE8U6f79XKqrQsLWysRQMweBhwBd-qRP0FDpw@mail.gmail.com>
Subject: Re: [PATCH] bpf, test_run: Track allocation size of data
To:     Kees Cook <keescook@chromium.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 2:02 AM Kees Cook <keescook@chromium.org> wrote:
>
> In preparation for requiring that build_skb() have a non-zero size
> argument, track the data allocation size explicitly and pass it into
> build_skb(). To retain the original result of using the ksize()
> side-effect on the skb size, explicitly round up the size during
> allocation.
>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Song Liu <song@kernel.org>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Hao Luo <haoluo@google.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: bpf@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  net/bpf/test_run.c | 84 +++++++++++++++++++++++++---------------------
>  1 file changed, 46 insertions(+), 38 deletions(-)
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 13d578ce2a09..299ff102f516 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -762,28 +762,38 @@ BTF_ID_FLAGS(func, bpf_kfunc_call_test_ref, KF_TRUSTED_ARGS)
>  BTF_ID_FLAGS(func, bpf_kfunc_call_test_destructive, KF_DESTRUCTIVE)
>  BTF_SET8_END(test_sk_check_kfunc_ids)
>
> -static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
> -                          u32 size, u32 headroom, u32 tailroom)
> +struct bpfalloc {
> +       size_t len;
> +       void  *data;
> +};
> +
> +static int bpf_test_init(struct bpfalloc *alloc,
> +                        const union bpf_attr *kattr, u32 user_size,
> +                        u32 size, u32 headroom, u32 tailroom)
>  {
>         void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
> -       void *data;
>
>         if (size < ETH_HLEN || size > PAGE_SIZE - headroom - tailroom)
> -               return ERR_PTR(-EINVAL);
> +               return -EINVAL;
>
>         if (user_size > size)
> -               return ERR_PTR(-EMSGSIZE);
> +               return -EMSGSIZE;
>
> -       data = kzalloc(size + headroom + tailroom, GFP_USER);
> -       if (!data)
> -               return ERR_PTR(-ENOMEM);
> +       alloc->len = kmalloc_size_roundup(size + headroom + tailroom);
> +       alloc->data = kzalloc(alloc->len, GFP_USER);

Don't you need to do this generalically in many places in the kernel?
