Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F144555162
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376558AbiFVQjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359639AbiFVQjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:39:23 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E533369C0
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:39:21 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id t1so31148763ybd.2
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hFEGuXQ8pK4dLxL00tb3iGKoWKxFFjHeOeemIT5G5fY=;
        b=ejnhZWkwjnv2aEad9hfgM3U18d/V+KXP/XBPIap0IO6WH7tonq9Z5XNuk2ssK7IV32
         aD3pjA/KtRGInpdjEJr/T/MWdcvASxOpewrMXWEp01TNjIHhuN12y0bmysiCkXhX1u2r
         ib5XaEktSnEG264A93jIQl+SWjM4E5rXZIGu5nbJAmF4LQk6NxZ1zLDVj0qu2Ij+qQBu
         j4U8RW0m+/NxKqIWLKdmT7vLWKAeXpn61uuqJSAkg/GUKIPbXjsnPR5/KU/FoZkngSsj
         KHlM4yuhniP8iyxNyppsAPbGT/6BvOWePSUEzlXX8/V8Kfgba2CaeDMGjxcWBQtg0dBY
         pYXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hFEGuXQ8pK4dLxL00tb3iGKoWKxFFjHeOeemIT5G5fY=;
        b=t1jNlAv9QEwE5fVrsFl17DgFtOEsseD4RMiN8aRNpijInz6tCw6x79WioKHr01LLY3
         wf0eYbFP0YfoIWfchPkdJnyH2pBK6R/iPy2FlhFyqQfyQdbpIi0Pjl66+lnryEjXixPE
         iZx8eZFE3yEhGdjoSbiV49wVisHRD+NJHbrFKrpt+lpAgMU+WAqKAjSdOrSYFP+CLmxD
         cGrvQlSGotLzDsQBfwSQCsjgRf8ZKhug0EXu5YEUy5gfAmYS7mgT1amxtocs/VHvgF+k
         fdTRxFjiDvl3suOKj6MVn/qfNt39/wBVBb3my5n014B+qIb7kX3srK16SYrZTRWapueD
         31xQ==
X-Gm-Message-State: AJIora90ZYoZpk2MpR0cjRuuohnOg3SSXiSY3uXbWiSJBmgQ9iDwjyRG
        g4tQ3hmkqzGtksyQsVlnHk/j5LeqjJGz/5E3pgmLYTNIwaXlNg==
X-Google-Smtp-Source: AGRyM1uZUu+M59Kc5BR3AyPetczLJJl5qcJ6HT8XIVHSZtvdZjECKYCNrOasNs+rQNTUZ8eCn4ZEXiov2Bf/YR7cNqI=
X-Received: by 2002:a25:6c5:0:b0:669:a17a:2289 with SMTP id
 188-20020a2506c5000000b00669a17a2289mr1473725ybg.231.1655915960442; Wed, 22
 Jun 2022 09:39:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220619003919.394622-1-i.maximets@ovn.org> <CANn89iL_EmkEgPAVdhNW4tyzwQbARyji93mUQ9E2MRczWpNm7g@mail.gmail.com>
 <20220622102813.GA24844@breakpoint.cc> <CANn89iLGKbeeBNoDQU9C7nPRCxc6FUsrwn0LfrAKrJiJ14PH+w@mail.gmail.com>
 <c7ab4a7b-a987-e74b-dd2d-ee2c8ca84147@ovn.org> <CANn89iLxqae9wZ-h5M-whSsmAZ_7hW1e_=krvSyF8x89Y6o76w@mail.gmail.com>
 <068ad894-c60f-c089-fd4a-5deda1c84cdd@ovn.org> <CANn89iJ=Xc57pdZ-NaRF7FXZnq2skh5MJ3aDtDCGp8RNG4oowA@mail.gmail.com>
In-Reply-To: <CANn89iJ=Xc57pdZ-NaRF7FXZnq2skh5MJ3aDtDCGp8RNG4oowA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 Jun 2022 18:39:08 +0200
Message-ID: <CANn89i+yy3mL2BUT=uhhkACVviWXCA9fdE1mrG=ZMuSQKdK8SQ@mail.gmail.com>
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

On Wed, Jun 22, 2022 at 6:29 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Jun 22, 2022 at 4:26 PM Ilya Maximets <i.maximets@ovn.org> wrote:
> >
> > On 6/22/22 13:43, Eric Dumazet wrote:
>
> >
> > I tested the patch below and it seems to fix the issue seen
> > with OVS testsuite.  Though it's not obvious for me why this
> > happens.  Can you explain a bit more?
>
> Anyway, I am not sure we can call nf_reset_ct(skb) that early.
>
> git log seems to say that xfrm check needs to be done before
> nf_reset_ct(skb), I have no idea why.

Additional remark: In IPv6 side, xfrm6_policy_check() _is_ called
after nf_reset_ct(skb)

Steffen, do you have some comments ?

Some context:
commit b59c270104f03960069596722fea70340579244d
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Jan 6 23:06:10 2006 -0800

    [NETFILTER]: Keep conntrack reference until IPsec policy checks are done

    Keep the conntrack reference until policy checks have been performed for
    IPsec NAT support. The reference needs to be dropped before a packet is
    queued to avoid having the conntrack module unloadable.

    Signed-off-by: Patrick McHardy <kaber@trash.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>


>
> I suspect some incoming packets are not going through
> xfrm4_policy_check() and end up being stored in a TCP receive queue.
>
> Maybe something is missing before calling tcp_child_process()
>
>
> >
> > >
> > > I note that IPv6 does the nf_reset_ct() earlier, from ip6_protocol_deliver_rcu()
> > >
> > > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > > index fda811a5251f2d76ac24a036e6b4f4e7d7d96d6f..a06464f96fe0cc94dd78272738ddaab2c19e87db
> > > 100644
> > > --- a/net/ipv4/tcp_ipv4.c
> > > +++ b/net/ipv4/tcp_ipv4.c
> > > @@ -1919,6 +1919,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
> > >         struct sock *sk;
> > >         int ret;
> > >
> > > +       nf_reset_ct(skb);
> > > +
> > >         drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
> > >         if (skb->pkt_type != PACKET_HOST)
> > >                 goto discard_it;
> > > @@ -2046,8 +2048,6 @@ int tcp_v4_rcv(struct sk_buff *skb)
> > >         if (drop_reason)
> > >                 goto discard_and_relse;
> > >
> > > -       nf_reset_ct(skb);
> > > -
> > >         if (tcp_filter(sk, skb)) {
> > >                 drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
> > >                 goto discard_and_relse;
> >
