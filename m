Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAC15AD437
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238162AbiIENo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238060AbiIENo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:44:28 -0400
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C77C6141;
        Mon,  5 Sep 2022 06:44:26 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id s11so11396813edd.13;
        Mon, 05 Sep 2022 06:44:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=eOfgeQnQ9LhjPeT1sUCEF5jyGKSmHYeqEshoHJc9BRI=;
        b=b2zBi/MDu24APKNKQW279wY+HJr5a8I16+jXS2YKv3fRlE2SNANYnz+XthHFgL8BO5
         GG7UqH3MpkIpTKdeYFBLmvow/9yuwj42bn5X/sBAGQri4sIJ/FTP7gt5e2e+cOgDrS94
         LXANbIZ4MMuf6sjfD5gJTdH+jKmih/4VZoX5aYGYTeYf32Qj69DIpFnZisNLpcAFoqL8
         Sr+sfNg6UmIMfwBO0kZoJBPj/xX6YQfzcmj10pLQCpVu/Ox1YNr4UnBIWzElYVYgCmCB
         Z05AiVplbvOJ/RbBFLE4oY7dLEmKcjiGlFYIM+5JCA2ZV3VeNKpU7sCGI+1yMHKnL+cv
         v1wg==
X-Gm-Message-State: ACgBeo2WA5BcxaBVvT+7uDWWsJ5hj3wvxyu4dSkRsvl81tFyyV/zGvfS
        RwXRk2ZMUmHLhphXgLumbJ0=
X-Google-Smtp-Source: AA6agR45jiO8Yyj+s62ODWB0VQFamqiLaONUcR5S6g3Nn+19aR/KN2N+NWwUWmJfWOOK6iTVO7kVDA==
X-Received: by 2002:a05:6402:501d:b0:443:1c7:ccb9 with SMTP id p29-20020a056402501d00b0044301c7ccb9mr43886761eda.101.1662385464528;
        Mon, 05 Sep 2022 06:44:24 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-023.fbsv.net. [2a03:2880:31ff:17::face:b00c])
        by smtp.gmail.com with ESMTPSA id b29-20020a50ccdd000000b0044ebf63d337sm28771edj.57.2022.09.05.06.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 06:44:24 -0700 (PDT)
Date:   Mon, 5 Sep 2022 06:44:22 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, leit@fb.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND net-next] tcp: socket-specific version of
 WARN_ON_ONCE()
Message-ID: <YxX9NjhQlppDUMkE@gmail.com>
References: <20220831133758.3741187-1-leitao@debian.org>
 <CANn89iLe9spogp7eaXPziA0L-FqJ0w=6VxdWDL6NKGobTyuQRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLe9spogp7eaXPziA0L-FqJ0w=6VxdWDL6NKGobTyuQRw@mail.gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Eric,

On Sat, Sep 03, 2022 at 09:42:43AM -0700, Eric Dumazet wrote:
> On Wed, Aug 31, 2022 at 6:38 AM Breno Leitao <leitao@debian.org> wrote:
> >
> > There are cases where we need information about the socket during a
> > warning, so, it could help us to find bugs that happens that do not have
> > a easily repro.
> >
> > BPF congestion control algorithms can change socket state in unexpected
> > ways, leading to WARNings. Additional information about the socket state
> > is useful to identify the culprit.

A little bit of more context here. We hit this warning in production
several hundred times a day. We don't know exactly where it is coming
from, that is why this patch is being proposed.

> Well, this suggests we need to fix BPF side ?

This patch might help us to identify who is the culprit that is setting
the wrong value in the congestion window. If the problem is on the BPF
side, we probably need to Fix BPF side, for sure.

> It seems you already found the issue in an eBPF CC, can you share the details ?

Not really.  I've applied this patch into our internal kernel, and we
might soon find more information of what is causing this warning.

> > This diff creates a TCP socket-specific version of WARN_ON_ONCE(), and
> > attaches it to tcp_snd_cwnd_set().
> 
> Well, I feel this will need constant additions... the state of a
> custom BPF CC is opaque to core TCP stack anyway ?
> 
> >
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  include/net/tcp.h       |  3 ++-
> >  include/net/tcp_debug.h | 10 ++++++++++
> >  net/ipv4/tcp.c          | 30 ++++++++++++++++++++++++++++++
> >  3 files changed, 42 insertions(+), 1 deletion(-)
> >  create mode 100644 include/net/tcp_debug.h
> >
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index d10962b9f0d0..73c3970d8839 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -40,6 +40,7 @@
> >  #include <net/inet_ecn.h>
> >  #include <net/dst.h>
> >  #include <net/mptcp.h>
> > +#include <net/tcp_debug.h>
> >
> >  #include <linux/seq_file.h>
> >  #include <linux/memcontrol.h>
> > @@ -1222,7 +1223,7 @@ static inline u32 tcp_snd_cwnd(const struct tcp_sock *tp)
> >
> >  static inline void tcp_snd_cwnd_set(struct tcp_sock *tp, u32 val)
> >  {
> > -       WARN_ON_ONCE((int)val <= 0);
> > +       TCP_SOCK_WARN_ON_ONCE(tp, (int)val <= 0);
> >         tp->snd_cwnd = val;
> >  }
> >
> > diff --git a/include/net/tcp_debug.h b/include/net/tcp_debug.h
> > new file mode 100644
> > index 000000000000..50e96d87d335
> > --- /dev/null
> > +++ b/include/net/tcp_debug.h
> > @@ -0,0 +1,10 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _LINUX_TCP_DEBUG_H
> > +#define _LINUX_TCP_DEBUG_H
> > +
> > +void tcp_sock_warn(const struct tcp_sock *tp);
> > +
> > +#define TCP_SOCK_WARN_ON_ONCE(tcp_sock, condition) \
> > +               DO_ONCE_LITE_IF(condition, tcp_sock_warn, tcp_sock)
> > +
> > +#endif  /* _LINUX_TCP_DEBUG_H */
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index bbe218753662..71771fee72f7 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -4684,6 +4684,36 @@ int tcp_abort(struct sock *sk, int err)
> >  }
> >  EXPORT_SYMBOL_GPL(tcp_abort);
> >
> > +void tcp_sock_warn(const struct tcp_sock *tp)
> > +{
> > +       const struct sock *sk = (const struct sock *)tp;
> > +       struct inet_sock *inet = inet_sk(sk);
> > +       struct inet_connection_sock *icsk = inet_csk(sk);
> > +
> > +       WARN_ON(1);
> > +
> > +       if (!tp)
> > +               return;
> > +
> > +       pr_warn("Socket Info: family=%u state=%d sport=%u dport=%u ccname=%s cwnd=%u",
> > +               sk->sk_family, sk->sk_state, ntohs(inet->inet_sport),
> > +               ntohs(inet->inet_dport), icsk->icsk_ca_ops->name, tcp_snd_cwnd(tp));
> > +
> > +       switch (sk->sk_family) {
> > +       case AF_INET:
> > +               pr_warn("saddr=%pI4 daddr=%pI4", &inet->inet_saddr,
> > +                       &inet->inet_daddr);
> > +               break;
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +       case AF_INET6:
> > +               pr_warn("saddr=%pI6 daddr=%pI6", &sk->sk_v6_rcv_saddr,
> > +                       &sk->sk_v6_daddr);
> > +               break;
> > +#endif
> > +       }
> > +}
> > +EXPORT_SYMBOL_GPL(tcp_sock_warn);
> > +
> >  extern struct tcp_congestion_ops tcp_reno;
> >
> >  static __initdata unsigned long thash_entries;
> > --
> > 2.30.2
> >
