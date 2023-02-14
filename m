Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B871695683
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 03:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbjBNCQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 21:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjBNCQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 21:16:07 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3266CAA;
        Mon, 13 Feb 2023 18:16:02 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id qw12so36715995ejc.2;
        Mon, 13 Feb 2023 18:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DT9O8MQdUnFqBP6BubjpFV9ysfJCXmduKRmos211Wq4=;
        b=JVSm1c2ZOjl9UWK7sRlsGr7O7zIUJivQIT7MMRibiajhI7lZZ/5l9mvfEgzwBeb0J7
         v9G+Nlf0lQOIrKDZmB39KJ/lWZoo1+1YuqwyLJVHvyBGXLItOCzpPAXs5b0LOtMsKDSS
         tJXF7CyeS38NA5Ky7zUNSDNL0Lnh1LJ55OGkikpi/xqqlYqN55bq5Sk9NxOaLw5OuJdk
         +ivhboo5RUrEPSObSeySNK+baa4DLa82aHl8NjWUD7PKGDSH27EsN6vhEQTK86soHT7F
         nIpRKN2u4py9mxEZgxuKGEc/GNCLnYh7/VZ7WgW6bwWH/5XOmR5ELQXFzED2FxBgiFJY
         8TCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DT9O8MQdUnFqBP6BubjpFV9ysfJCXmduKRmos211Wq4=;
        b=mESvtGaiZayPoCO1K7ahIMYob6X8uSMHkxiIeXI9fNJtbyYPOGt/Rtwrw1SEtWrdjc
         6d+pmbe3T67Fbxfq70crJVyndWUakyctp/lXOjJFhptFvG6U2+8aSoLJ4y4+naCfYgoo
         7qxtKe0GLbYR0AMMS1w97Jdl12proQbVZ7bGHwkY2SqPqVbh/wdmHLWm2JC1fJwdXLbk
         nJJdZ01Mwja1u4iEZvQHXQxlNxvwS317xjpXLpJZ4uqxaVONeDa1/8r8TfmbzYRcSx37
         DTr/sScYEbC4iqV2S6fgU+euaTPOh5Lyp7EV7o8ofOfAmgbbIjkXd27XpWjJ5AAcyhTy
         EgWQ==
X-Gm-Message-State: AO0yUKWIHzOd6Ysh+COR50CqIfPBq2UNpYKi9b+C7Am5UQp8E00uJ5ia
        W6DLSt7aM4Bw/6B3H0Ou9Bh0n4X6fhZZovRTyPo=
X-Google-Smtp-Source: AK7set+63D0fxyUKbhpOPXDU+jnIqMdgB7yKz7Brpg/OGr3ocRYLPnkEEj6rXKpom7wh1ysw24IxoC2/s87mlBJgM64=
X-Received: by 2002:a17:907:984a:b0:87b:dce7:c245 with SMTP id
 jj10-20020a170907984a00b0087bdce7c245mr518172ejc.3.1676340960684; Mon, 13 Feb
 2023 18:16:00 -0800 (PST)
MIME-Version: 1.0
References: <20230211065153.54116-1-kerneljasonxing@gmail.com> <20230213172939.39449-1-kuniyu@amazon.com>
In-Reply-To: <20230213172939.39449-1-kuniyu@amazon.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 14 Feb 2023 10:15:24 +0800
Message-ID: <CAL+tcoAMByaw8Bdj8kBbzq7Sz8wNJW67Swvw49NQnD0Ks3GWtg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Kconfig.debug: wrap socket refcnt debug
 into an option
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     bpf@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, kernelxing@tencent.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
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

On Tue, Feb 14, 2023 at 1:30 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Jason Xing <kerneljasonxing@gmail.com>
> Date:   Sat, 11 Feb 2023 14:51:53 +0800
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > Since commit 463c84b97f24 ("[NET]: Introduce inet_connection_sock")
> > commented out the definition of SOCK_REFCNT_DEBUG and later another
> > patch deleted it,
>

> e48c414ee61f ("[INET]: Generalise the TCP sock ID lookup routines")
> is the commit which commented out SOCK_REFCNT_DEBUG, and 463c84b97f24
> removed it.

Yes.

>
>
> > we need to enable it through defining it manually
> > somewhere. Wrapping it into an option in Kconfig.debug could make
> > it much clearer and easier for some developers to do things based
> > on this change.
>
> Considering SOCK_REFCNT_DEBUG is removed in 2005, how about removing
> the whole feature?  I think we can track the same info easily with
> bpftrace + kprobe.

I agree with you since it seems no one is developing more features
based on it.  I just did check every caller which may call those debug
interfaces and now confirm we surely can use bpf/kprobe related tools
to track. So I decided to remove the whole feature in the next
submission.

Thanks,
Jason

>
>
> >
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> >  include/net/sock.h            | 8 ++++----
> >  net/Kconfig.debug             | 8 ++++++++
> >  net/ipv4/inet_timewait_sock.c | 2 +-
> >  3 files changed, 13 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index dcd72e6285b2..1b001efeb9b5 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -1349,7 +1349,7 @@ struct proto {
> >       char                    name[32];
> >
> >       struct list_head        node;
> > -#ifdef SOCK_REFCNT_DEBUG
> > +#ifdef CONFIG_SOCK_REFCNT_DEBUG
> >       atomic_t                socks;
> >  #endif
> >       int                     (*diag_destroy)(struct sock *sk, int err);
> > @@ -1359,7 +1359,7 @@ int proto_register(struct proto *prot, int alloc_slab);
> >  void proto_unregister(struct proto *prot);
> >  int sock_load_diag_module(int family, int protocol);
> >
> > -#ifdef SOCK_REFCNT_DEBUG
> > +#ifdef CONFIG_SOCK_REFCNT_DEBUG
> >  static inline void sk_refcnt_debug_inc(struct sock *sk)
> >  {
> >       atomic_inc(&sk->sk_prot->socks);
> > @@ -1378,11 +1378,11 @@ static inline void sk_refcnt_debug_release(const struct sock *sk)
> >               printk(KERN_DEBUG "Destruction of the %s socket %p delayed, refcnt=%d\n",
> >                      sk->sk_prot->name, sk, refcount_read(&sk->sk_refcnt));
> >  }
> > -#else /* SOCK_REFCNT_DEBUG */
> > +#else /* CONFIG_SOCK_REFCNT_DEBUG */
> >  #define sk_refcnt_debug_inc(sk) do { } while (0)
> >  #define sk_refcnt_debug_dec(sk) do { } while (0)
> >  #define sk_refcnt_debug_release(sk) do { } while (0)
> > -#endif /* SOCK_REFCNT_DEBUG */
> > +#endif /* CONFIG_SOCK_REFCNT_DEBUG */
> >
> >  INDIRECT_CALLABLE_DECLARE(bool tcp_stream_memory_free(const struct sock *sk, int wake));
> >
> > diff --git a/net/Kconfig.debug b/net/Kconfig.debug
> > index 5e3fffe707dd..667396d70e10 100644
> > --- a/net/Kconfig.debug
> > +++ b/net/Kconfig.debug
> > @@ -18,6 +18,14 @@ config NET_NS_REFCNT_TRACKER
> >         Enable debugging feature to track netns references.
> >         This adds memory and cpu costs.
> >
> > +config SOCK_REFCNT_DEBUG
> > +     bool "Enable socket refcount debug"
> > +     depends on DEBUG_KERNEL && NET
> > +     default n
> > +     help
> > +       Enable debugging feature to track socket references.
> > +       This adds memory and cpu costs.
> > +
> >  config DEBUG_NET
> >       bool "Add generic networking debug"
> >       depends on DEBUG_KERNEL && NET
> > diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> > index beed32fff484..e313516b64ce 100644
> > --- a/net/ipv4/inet_timewait_sock.c
> > +++ b/net/ipv4/inet_timewait_sock.c
> > @@ -77,7 +77,7 @@ void inet_twsk_free(struct inet_timewait_sock *tw)
> >  {
> >       struct module *owner = tw->tw_prot->owner;
> >       twsk_destructor((struct sock *)tw);
> > -#ifdef SOCK_REFCNT_DEBUG
> > +#ifdef CONFIG_SOCK_REFCNT_DEBUG
> >       pr_debug("%s timewait_sock %p released\n", tw->tw_prot->name, tw);
> >  #endif
> >       kmem_cache_free(tw->tw_prot->twsk_prot->twsk_slab, tw);
> > --
> > 2.37.3
