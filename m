Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B064B7DCF
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343791AbiBPChG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:37:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343787AbiBPChF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:37:05 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACA1FD9;
        Tue, 15 Feb 2022 18:36:54 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id z13so1407812edc.12;
        Tue, 15 Feb 2022 18:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oi37CwrmvQWu7kYLVP5Qk+0R9r5dukdFd1VytzpZS/k=;
        b=EDSUeOStPRdTC6e5aVvR3crbzquCKKUUHq9bE/JBhRpM91KRMVWhwlS6PoIvLjB72y
         QjSm3yKx8nywjkWrNcWqj9gA0rKDsD7PvCAMt9/3EY3WaGEjnuUE6EtSOYytso/LsFpi
         LJMd1vbP7zV1D9gVnO2RiV3+saydmHnS9GrLpeHG8Xf9PRe0uhybuU1kiw47zGVrnvwH
         N6E9dc1kAfpjsrKo/gdpDQlTGNVqXjJaN3eBnawmKfP+8eqWtIp1U4yGdAoGoEwSgCkv
         6YzJis1GlGFGRgomPQXLEGd1zkUsno+wS88vhegX55R3P0g/d3uYQfZeUgPaEjG7z3IX
         Mokg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oi37CwrmvQWu7kYLVP5Qk+0R9r5dukdFd1VytzpZS/k=;
        b=bZefY+01iFnC7vR1NU9rBpMYYkBtYgMIrh/s8Fkkc61G4xIM4ToFlGIc37YCdVPbXh
         x0HFFgXLFiLe2dghNudTCLN2E8xUVgxm2pbXTGHqDE2P48/6tP7kH4u5tSD0E7ZwSCwh
         A+rLoGNWDgj71NiKCpfDpgfF3DCO9wEUqcuogsQLfFnDtXIOXqc+1n6+tKx9stujuY4Y
         qL0IOD14NWHhgXHUH9X6NwH1WGdF31348/jkSBGlGXv8uhjlbPNZYAKjqsK5rUwUKdXc
         NNWSoQfdte8n9u/079SwHSI40nTYouV60nSGavTYBktQBlCNEr5b9ts9QP6OH3ETeRa+
         rk/g==
X-Gm-Message-State: AOAM530RIeBbgbtB71ZuIe0l8IMD3YYxmkqxCPguCfrw5L+n9UBhBxAm
        eRsIyj0h76hNHFdt8qP473jdgTY5qItyejX+Bq8=
X-Google-Smtp-Source: ABdhPJyRK0CgWIKxOqLj+s3vIq/pIS4hN2pbnh5k1INrJtCXtsRgDOlnXAu9rp/1GcUUmkkbrGKn22Iv06SB4NDAns4=
X-Received: by 2002:a05:6402:2801:b0:410:a592:a5d0 with SMTP id
 h1-20020a056402280100b00410a592a5d0mr713990ede.253.1644979012622; Tue, 15 Feb
 2022 18:36:52 -0800 (PST)
MIME-Version: 1.0
References: <20220215112812.2093852-1-imagedong@tencent.com>
 <20220215112812.2093852-2-imagedong@tencent.com> <CANn89iLWOBy=X1CpY+gvukhQ-bb7hDWd5y+m46K7o5XR0Pbt_A@mail.gmail.com>
In-Reply-To: <CANn89iLWOBy=X1CpY+gvukhQ-bb7hDWd5y+m46K7o5XR0Pbt_A@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 16 Feb 2022 10:31:41 +0800
Message-ID: <CADxym3Y+ova1uEouJHy0EmaouK0gWwjE7AAUDzr1+K1D2qGWBg@mail.gmail.com>
Subject: Re: [PATCH net-next 01/19] net: tcp: introduce tcp_drop_reason()
To:     Eric Dumazet <edumazet@google.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 1:34 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Feb 15, 2022 at 3:30 AM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > For TCP protocol, tcp_drop() is used to free the skb when it needs
> > to be dropped. To make use of kfree_skb_reason() and collect drop
> > reasons, introduce the function tcp_drop_reason().
> >
> > tcp_drop_reason() will finally call kfree_skb_reason() and pass the
> > drop reason to 'kfree_skb' tracepoint.
> >
> > PS: __kfree_skb() was used in tcp_drop(), I'm not sure if it's ok
> > to replace it with kfree_skb_reason().
> >
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  net/ipv4/tcp_input.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index af94a6d22a9d..e3811afd1756 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -4684,10 +4684,19 @@ static bool tcp_ooo_try_coalesce(struct sock *sk,
> >         return res;
> >  }
> >
> > -static void tcp_drop(struct sock *sk, struct sk_buff *skb)
> > +static void tcp_drop_reason(struct sock *sk, struct sk_buff *skb,
> > +                           enum skb_drop_reason reason)
> >  {
> >         sk_drops_add(sk, skb);
> > -       __kfree_skb(skb);
> > +       /* why __kfree_skb() used here before, other than kfree_skb()?
> > +        * confusing......
>
> Do not add comments like that if you do not know the difference...
>
> __kfree_skb() is used by TCP stack because it owns skb in receive
> queues, and avoids touching skb->users
> because it must be one already.
>
> (We made sure not using skb_get() in TCP)
>
> It seems fine to use kfree_skb() in tcp_drop(), it is hardly fast
> path, and the added cost is pure noise.

I understand why __kfree_skb() was used now, and it seems
this commit is ok (with the comments removed of course). I'll
keep it still.

Thanks!
Menglong Dong
