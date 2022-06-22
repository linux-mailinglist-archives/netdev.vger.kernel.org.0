Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809C4555153
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359122AbiFVQ3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358980AbiFVQ3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:29:48 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEA73150E
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:29:47 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id i15so26252835ybp.1
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5L9B2F5DxgxEwUF4SO/M3juq2QVguuraKNG6M5m+j8w=;
        b=YX7lGMmSIM0ipx4rHeLX1aZjiMzymgIc1RdgkkYLyLBaKs/tyo6Ld8mO0XwMREmTBL
         83BaVvRSJjwXgcApbA7Y6yb+Ved5XPvqJa8rV5a6ZbaZLobZjVgbF2f3Hu/w14VGTOMG
         OFpLd2tPUNK439bPNRlIlR9xu8J6lEH0oSzPIIG4ragPD0yLYPPxUOtugpzycVcFzqKd
         xzMI/cnq9ckM8XSG0mIpUizTlLxikuN30/vORy0Qw8JweLevj2A2rfCZZmsI3tpQOZ/7
         ivfazIJfvotbGN87aof2YIcO+tLhDf9a8qsEyM8X3f19PqWWCuDvN2PnbiRDJUkwAhdf
         Uf8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5L9B2F5DxgxEwUF4SO/M3juq2QVguuraKNG6M5m+j8w=;
        b=L6OYtum6+1xSlt2qsqXiWQw34zc/aUa7oioA4pM4XzfTTUblWzwR7DBV3wXG04eyo+
         gqQjHfTy1leN2WSNFohjzH8ScKFX9E6S1zdnC+BfOhOWFuwLLQ8QSKE2JEyv8Zv2IUBl
         GT3qgC1peIcG5pWNgsv8GOfRuaqX0/gJnXHcgkcQck2uoEdqY1fiwbVpZFRWBQG2c+xq
         tcQ3+MlTeFEQSlHiANuw9Or/fio66UCp2aZL7iEmgs/ldH4qE0nDKx6FScprsZAY/z3K
         Ny5QfKB6h+Uify2CNEE/yKSxv2LauIrqEu9qk22z4sXVXWtoFVbM3p7VOardUod2YCXI
         oWnQ==
X-Gm-Message-State: AJIora+RnPbVWwC6Wgm5E6epz6p+1QDU8xyqOkfpIWpJIdKeMWWvzDj8
        BRjxGb77/Y8PX6EPRYYjQz9IGAt7Sdym1pTOjEUSTw==
X-Google-Smtp-Source: AGRyM1sQz53n+2/kWSmsSLyW/gQtsFKwxxZ8XtEPZg6/+Mc2e4hy4Jp5GsQoh9O+a3UB5nIl3YUncb9FVze3GSqpFgs=
X-Received: by 2002:a25:ae23:0:b0:668:daf8:c068 with SMTP id
 a35-20020a25ae23000000b00668daf8c068mr4570417ybj.427.1655915385986; Wed, 22
 Jun 2022 09:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220619003919.394622-1-i.maximets@ovn.org> <CANn89iL_EmkEgPAVdhNW4tyzwQbARyji93mUQ9E2MRczWpNm7g@mail.gmail.com>
 <20220622102813.GA24844@breakpoint.cc> <CANn89iLGKbeeBNoDQU9C7nPRCxc6FUsrwn0LfrAKrJiJ14PH+w@mail.gmail.com>
 <c7ab4a7b-a987-e74b-dd2d-ee2c8ca84147@ovn.org> <CANn89iLxqae9wZ-h5M-whSsmAZ_7hW1e_=krvSyF8x89Y6o76w@mail.gmail.com>
 <068ad894-c60f-c089-fd4a-5deda1c84cdd@ovn.org>
In-Reply-To: <068ad894-c60f-c089-fd4a-5deda1c84cdd@ovn.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 Jun 2022 18:29:33 +0200
Message-ID: <CANn89iJ=Xc57pdZ-NaRF7FXZnq2skh5MJ3aDtDCGp8RNG4oowA@mail.gmail.com>
Subject: Re: [PATCH net] net: ensure all external references are released in
 deferred skbuffs
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 4:26 PM Ilya Maximets <i.maximets@ovn.org> wrote:
>
> On 6/22/22 13:43, Eric Dumazet wrote:

>
> I tested the patch below and it seems to fix the issue seen
> with OVS testsuite.  Though it's not obvious for me why this
> happens.  Can you explain a bit more?

Anyway, I am not sure we can call nf_reset_ct(skb) that early.

git log seems to say that xfrm check needs to be done before
nf_reset_ct(skb), I have no idea why.

I suspect some incoming packets are not going through
xfrm4_policy_check() and end up being stored in a TCP receive queue.

Maybe something is missing before calling tcp_child_process()


>
> >
> > I note that IPv6 does the nf_reset_ct() earlier, from ip6_protocol_deliver_rcu()
> >
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index fda811a5251f2d76ac24a036e6b4f4e7d7d96d6f..a06464f96fe0cc94dd78272738ddaab2c19e87db
> > 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -1919,6 +1919,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
> >         struct sock *sk;
> >         int ret;
> >
> > +       nf_reset_ct(skb);
> > +
> >         drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
> >         if (skb->pkt_type != PACKET_HOST)
> >                 goto discard_it;
> > @@ -2046,8 +2048,6 @@ int tcp_v4_rcv(struct sk_buff *skb)
> >         if (drop_reason)
> >                 goto discard_and_relse;
> >
> > -       nf_reset_ct(skb);
> > -
> >         if (tcp_filter(sk, skb)) {
> >                 drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
> >                 goto discard_and_relse;
>
