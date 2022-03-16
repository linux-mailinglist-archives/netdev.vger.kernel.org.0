Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D044DA763
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 02:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352960AbiCPBfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 21:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235181AbiCPBfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 21:35:37 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08DE33345;
        Tue, 15 Mar 2022 18:34:24 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id qa43so1155055ejc.12;
        Tue, 15 Mar 2022 18:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FZ3oVgkOFdOjGN51ntkgRhkDvnpqzxtfBSJIorikP9U=;
        b=MF4OFcWkN113wb2xn99qdSLN90WhYrhjiB1meFH3g/pvR/wn4KTxp1olCmPraAAOhr
         99ISfAji2kd7Pk+86KrwIGKLSFzOQD44dofaN8orFNNjdP6d/psqo+/S9BJp0bIVh0UU
         1xoRekdSa1sexSz9BI0nk/6OU+T1jo2PNcgCYZpVkIcUyoXfPF2V01c80rX4KpoySw4D
         0DLcoG9QdABSAKO+X0NpjqoeHXxiyi2UWihwOLWuHJnifBHIKtD/MDZfU5rOYAvXJa9Y
         +oRUIJodgU5s3UsHrF8v0qrzsNDu3RPGqflb9NKpgJ1IJlV+ffdJhFgDc0aWGjcTWEQ5
         V2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FZ3oVgkOFdOjGN51ntkgRhkDvnpqzxtfBSJIorikP9U=;
        b=u+mJpjcysjo7BJtm9sL+fOeU+L2tE8kdhiIeKZ3fKJ3d+REhuKugHmgBSmE9WuM5Kr
         rVNL2dvafLN90YtG2/nw3X+2CME1hn/nuAW3vU2CUzpKoTaAdLSXFpe6cQl1wP8BA9b5
         Dou+FD6fdIUDrQzQMdKTMd7qeIqpGu2YC3waSG9H8YzjQRNQuQVq4OtoZfzzdh5tRW8s
         Jpntp7+53As6/KZiCn199HsF3NBgiarShexp7GaFeqCPpN4wKlZ3qgsFr30fcI+0HTPO
         ORce6maPBIG+RZPPxc0ikQnEN6Ol0NUyEdXd/Atnyd08Nmahuvpzxbz0+lySuv1GdR26
         rEbw==
X-Gm-Message-State: AOAM530teCklBVFkOdsT97HYgDGa4egu+vrBACImxvqU6BUjUv1+T/KX
        X8eDmEDSdhIfF3zVz7hNjH/DGYpmrBpTJqFPmog=
X-Google-Smtp-Source: ABdhPJynXp+7Y230gb//h3ClR+cHtYN8nWHsWZVXpuNYslVA5wGBSOl+g6K4w2Z1LOGwB6i8Q+ofPm+QDwWvl0zN9T0=
X-Received: by 2002:a17:906:3144:b0:6ce:de5d:5e3b with SMTP id
 e4-20020a170906314400b006cede5d5e3bmr25449418eje.689.1647394463212; Tue, 15
 Mar 2022 18:34:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220314113225.151959-1-imagedong@tencent.com>
 <20220314113225.151959-3-imagedong@tencent.com> <5ebf8873334a3a38855e378748cb6d8948fbd0c7.camel@redhat.com>
In-Reply-To: <5ebf8873334a3a38855e378748cb6d8948fbd0c7.camel@redhat.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 16 Mar 2022 09:34:09 +0800
Message-ID: <CADxym3b+XwEJu7rT-AUs9vD=RWPHZ2D845thDJdc-ioMwRvYWg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: icmp: add skb drop reasons to ping_queue_rcv_skb()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>, dongli.zhang@oracle.com,
        maze@google.com, aahringo@redhat.com, Wei Wang <weiwan@google.com>,
        yangbo.lu@nxp.com, Florian Westphal <fw@strlen.de>,
        tglx@linutronix.de, rpalethorpe@suse.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
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

On Tue, Mar 15, 2022 at 8:49 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Mon, 2022-03-14 at 19:32 +0800, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > In order to get the reasons of skb drops, replace sock_queue_rcv_skb()
> > used in ping_queue_rcv_skb() with sock_queue_rcv_skb_reason().
> > Meanwhile, use kfree_skb_reason() instead of kfree_skb().
> >
> > As we can see in ping_rcv(), 'skb' will be freed if '-1' is returned
> > by ping_queue_rcv_skb(). In order to get the drop reason of 'skb',
> > make ping_queue_rcv_skb() return the drop reason.
> >
> > As ping_queue_rcv_skb() is used as 'ping_prot.backlog_rcv()', we can't
> > change its return type. (Seems ping_prot.backlog_rcv() is not used?)
> > Therefore, make it return 'drop_reason * -1' to keep the origin logic.
> >
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  net/ipv4/ping.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> > index 3ee947557b88..cd4eb211431a 100644
> > --- a/net/ipv4/ping.c
> > +++ b/net/ipv4/ping.c
> > @@ -936,12 +936,13 @@ EXPORT_SYMBOL_GPL(ping_recvmsg);
> >
> >  int ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> >  {
> > +     enum skb_drop_reason reason;
>
> Please insert an empty line between variable declaration and code.

Ok

>
> >       pr_debug("ping_queue_rcv_skb(sk=%p,sk->num=%d,skb=%p)\n",
> >                inet_sk(sk), inet_sk(sk)->inet_num, skb);
> > -     if (sock_queue_rcv_skb(sk, skb) < 0) {
> > -             kfree_skb(skb);
> > +     if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0) {
> > +             kfree_skb_reason(skb, reason);
> >               pr_debug("ping_queue_rcv_skb -> failed\n");
> > -             return -1;
> > +             return -reason;
>
> This changes the return value for the release callback.  Such callback
> has a long and non trivial call chain via sk_backlog_rcv.
>
> It *should* be safe, but have you considered factoring out an
> __ping_queue_rcv_skb() variant returning the full drop reason, use it
> in the next patch and build ping_queue_rcv_skb() on top of such helper
> to that backlog_rcv() return code will not change?
>
> The above should additionally avoid the IMHO not so nice:
>
>         reason = ping_queue_rcv_skb(sk, skb2) * -1;
>
> in the next patch - it will become:
>
>         reason = __ping_queue_rcv_skb(sk, skb2);
>

Good idea, thanks!

Menglong Dong
