Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFC74B75E7
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242593AbiBORfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:35:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242591AbiBORfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:35:07 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5415F2BB29
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:34:56 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id 124so30179593ybn.11
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BzSwHLb103hYeBDvOU2heIFUN8ZLSUmxkKK9+4IBNa4=;
        b=KrIOeEBFwQFiJVrFBJLn0Fb7+Ir/9Pofb0b0KLL3K6cxvQ+FCoP27/zEjpiCoEG5sV
         SFhhtggF92ERcKjrUDsyc5aq3mYTMlQPpJYfomqMr89r0P5WHgNM/Pum6+BYsXe+qocJ
         Yp4KbxzW+mxHdHxDWH7oKDV1qg+u8J5u+gn0HhnxE18qK3E6mXynKIZ+zGrexRnwz45C
         ovVsKT3UYvR2jDyBegAxRV6w03TFE6x5rUFEdSrk98yhxWg5BmnGHNZ518bltR3RMFKC
         Pfs8HldFX1t5lZTZkdMA8wAv8ubaOPbUSrDxINAaaIZ7hJoK9+YZPufVCjUD0YvPiWpb
         h2gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BzSwHLb103hYeBDvOU2heIFUN8ZLSUmxkKK9+4IBNa4=;
        b=Le9DhYFocL3QWRk6JHMmwOyDMLiNWZyYhX/D9fkTnNZW1a9arZOQCjGDeo5pxZ0jsx
         CXJCogSdFhOmel9VMfVgjsC8P6RNf50UQ6NMQ42rWmqe1iamEFirtBo6bAKT+Hfp+Q1F
         /E1LIvz+2vLCbjpg/kWVLqpfErR+R6FgAy71ldqXpM3ZO+oatUelHAUKH43KH6G46pK1
         eiZU6hBB6VFf7rvK06u0XCWGqvg9aTOOhH/eXSmBa277yqQ8/50tbNPbr/9XmCnQQChh
         dMic1AtVg/9IHxbufnHijmLFqWL3aRHhFgEVmgRQ3yy/fQZ45PkMOWu3dhEEbsY8mA4i
         btBA==
X-Gm-Message-State: AOAM530Obz5FV4wgjqY2KsD3QU72f7ufwpnLV03dj9LqpHt3zZzpJqt4
        TgLGMhs15JgSjS0i+ZAvnucCNA4SwphheQokWogztg==
X-Google-Smtp-Source: ABdhPJxu89+Z8sRKF9zGwgYt/T7SyMBaRjbf1acH6Iy0s1tiNyXgKzYrjSYee5hT8cWYikqq6sF9corJOHo7u/zwMew=
X-Received: by 2002:a25:d203:: with SMTP id j3mr4691620ybg.534.1644946495082;
 Tue, 15 Feb 2022 09:34:55 -0800 (PST)
MIME-Version: 1.0
References: <20220215112812.2093852-1-imagedong@tencent.com> <20220215112812.2093852-2-imagedong@tencent.com>
In-Reply-To: <20220215112812.2093852-2-imagedong@tencent.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 15 Feb 2022 09:34:44 -0800
Message-ID: <CANn89iLWOBy=X1CpY+gvukhQ-bb7hDWd5y+m46K7o5XR0Pbt_A@mail.gmail.com>
Subject: Re: [PATCH net-next 01/19] net: tcp: introduce tcp_drop_reason()
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        Willem de Bruijn <willemb@google.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        flyingpeng@tencent.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 3:30 AM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> For TCP protocol, tcp_drop() is used to free the skb when it needs
> to be dropped. To make use of kfree_skb_reason() and collect drop
> reasons, introduce the function tcp_drop_reason().
>
> tcp_drop_reason() will finally call kfree_skb_reason() and pass the
> drop reason to 'kfree_skb' tracepoint.
>
> PS: __kfree_skb() was used in tcp_drop(), I'm not sure if it's ok
> to replace it with kfree_skb_reason().
>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  net/ipv4/tcp_input.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index af94a6d22a9d..e3811afd1756 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -4684,10 +4684,19 @@ static bool tcp_ooo_try_coalesce(struct sock *sk,
>         return res;
>  }
>
> -static void tcp_drop(struct sock *sk, struct sk_buff *skb)
> +static void tcp_drop_reason(struct sock *sk, struct sk_buff *skb,
> +                           enum skb_drop_reason reason)
>  {
>         sk_drops_add(sk, skb);
> -       __kfree_skb(skb);
> +       /* why __kfree_skb() used here before, other than kfree_skb()?
> +        * confusing......

Do not add comments like that if you do not know the difference...

__kfree_skb() is used by TCP stack because it owns skb in receive
queues, and avoids touching skb->users
because it must be one already.

(We made sure not using skb_get() in TCP)

It seems fine to use kfree_skb() in tcp_drop(), it is hardly fast
path, and the added cost is pure noise.
