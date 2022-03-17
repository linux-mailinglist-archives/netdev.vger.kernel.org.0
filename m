Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745394DBF19
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 07:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiCQGRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 02:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiCQGQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 02:16:55 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE86173F4F;
        Wed, 16 Mar 2022 22:58:00 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id b15so5265894edn.4;
        Wed, 16 Mar 2022 22:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M46+b6LrSwlI17F3i2XgwwHhummNRK4ZjijSW7M5eUw=;
        b=MLTj4ZmHdyx25fg7w0lOrZpPwEk7fIl7wAVtHpvwbK6NEeUfcO5SVg0X1F/bXuT1Xb
         JW6S8Gw/HDvoRzKQN1LyGLjLXypdrZQtpGe7po37uu0Ssk4P8YqTr9+3qBW52vNNqN5T
         rVmrUAdSSTZPTKHfIq56U3PbaSPy267wvVJEEgeOcPojiYk/yrr6c6AOtE43FUZ87/B0
         uIBs7yFagvX6GcGaF04hxyIwE4PxLEL+0X7LX2H0ACBNEiIqMJtVNFIBarxS+g6NpIx5
         XJFu/4ylG+SOO+ni2HNYpnYhmjuHFl037esPjHzsKmvPj7dlNzMu4A//agoMYA7ZqodZ
         rzqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M46+b6LrSwlI17F3i2XgwwHhummNRK4ZjijSW7M5eUw=;
        b=DnNfNZ228xG1NnIHIK2IYYr101JzweS1joWyPpwMV9+0L/BS0Iuhnaxf0YqkL1I/Ae
         0M/u9CT2qublrnOVPnIMox6USiGV7cG5AxI0cX/FA55KwjWhPVj0tfaukCD2s/IqeVSJ
         qmwxkgwjWJh42vWrjSscMujJvu1IxwxIS+C0PiXU0L7x6H6GD5Xcitd8eN6jEx4sGcgR
         Fgdl1qZ0unleCHmrehoCKiDAywoxbIjmlkZ+4sSzInK8u0MpQ7yxqOvXqHc3+22Mjx3O
         9mJoo9wBhtee7ebjUxX/tje6Nx5Ip3UsPJ3lLf0qBBxQo7rMJUQ1AxoSa0wpAxaKwMzI
         753A==
X-Gm-Message-State: AOAM531WQuoS9wOsjLSji1fr9qxg2PH3EUT8vHxo1kf87AmkZmm7TjLI
        SQCSMcIiIbCqvXgu0PkW8CmQyUlU/XrgeOD1R2E=
X-Google-Smtp-Source: ABdhPJwwgfN9Pm7u8o3A/pWTIWCkEF7haDR9qtfyQEOxF/c5gMjwo7rBL5gSc4AclOQ9nadb//7GGAa6ClPLzDmItQw=
X-Received: by 2002:a05:6402:486:b0:413:bd00:4f3f with SMTP id
 k6-20020a056402048600b00413bd004f3fmr2673050edv.103.1647496679362; Wed, 16
 Mar 2022 22:57:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220316063148.700769-1-imagedong@tencent.com>
 <20220316063148.700769-4-imagedong@tencent.com> <20220316201853.0734280f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220316201853.0734280f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 17 Mar 2022 13:57:47 +0800
Message-ID: <CADxym3attjUpVhP6NYO+MyFg8Psko1VhrSo9aNf=atgQgWo_uQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/3] net: icmp: add reasons of the skb drops
 to icmp protocol
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
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

On Thu, Mar 17, 2022 at 11:18 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
[......]
> > -bool ping_rcv(struct sk_buff *skb)
> > +enum skb_drop_reason ping_rcv(struct sk_buff *skb)
> >  {
> > +     enum skb_drop_reason reason = SKB_DROP_REASON_NO_SOCKET;
> >       struct sock *sk;
> >       struct net *net = dev_net(skb->dev);
> >       struct icmphdr *icmph = icmp_hdr(skb);
> > -     bool rc = false;
> >
> >       /* We assume the packet has already been checked by icmp_rcv */
> >
> > @@ -980,15 +980,17 @@ bool ping_rcv(struct sk_buff *skb)
> >               struct sk_buff *skb2 = skb_clone(skb, GFP_ATOMIC);
> >
> >               pr_debug("rcv on socket %p\n", sk);
> > -             if (skb2 && !ping_queue_rcv_skb(sk, skb2))
> > -                     rc = true;
> > +             if (skb2)
> > +                     reason = __ping_queue_rcv_skb(sk, skb2);
> > +             else
> > +                     reason = SKB_DROP_REASON_NOMEM;
> >               sock_put(sk);
> >       }
> >
> > -     if (!rc)
> > +     if (reason)
> >               pr_debug("no socket, dropping\n");
>
> This is going to be printed on memory allocation failures now as well.

Enn...This logic is not changed. In the previous, skb2==NULL means
rc is false, and this message is printed too.

Seems this can be optimized by the way? Printing the message only for
no socket found.
