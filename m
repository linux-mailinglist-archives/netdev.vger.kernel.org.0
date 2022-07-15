Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D22A5766A8
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 20:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiGOSUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 14:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiGOSUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 14:20:21 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5856050A
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 11:20:20 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id sz17so10350244ejc.9
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 11:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kUVb2YldJYFqRZdfm4sKuO71AGYYcsztL65MiCI9xtw=;
        b=MHtBbnrINlTNT06b9vE3YtrZ3VZwkOQyEF5ttEbK2zse0e6mnGc9I20BjQJt+2Npzx
         n9/LmI1tfSxsDkm8aAh4WY9T3wrGzqxVnKAdYcjLjz0SFR0MpL5lPjbOAqQ2bg+jyDK+
         cBNDlJPFF6LMsE9L2zTUuCepQGb3Zq2yAra8tqXk6sR5DvQYt7D3jtGJQv3yFFzjWMr9
         Dqyt8katB4SpaJSqAMIl1IwDY45ewXcUhjoZOBONA2IXqAQsN8+plvK59sE1+2/hupoF
         kxIPCpXa0YlQVBDkSyLBYSvch6+DVHEkc1flxdp5TxWFYBVJ6lvI+dRL7GQx8ATpItck
         899g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kUVb2YldJYFqRZdfm4sKuO71AGYYcsztL65MiCI9xtw=;
        b=Wrl5d81guB7kdkiQJS0seWZ6Ky2B9m09zZxZyN3b52mMjYllClQ1cd4v9KPTN+WJhQ
         4+LMTU1i99ADVAIjU07VGLffkQwLhsGajAyMm8rXbQEgdGBKMVBm4WkBURKilzUnH4yD
         Qc/T4KydHeMJb3kmaH3tYfMPbqHgzc9dF/L/qq2MG+xgFDnalFDE+XDcDgY53M2ks+nK
         //eNdy5ME4xj34/j4td+FDJdtpJbJwWSgCpFri5bIjlpvq8CqbC6o6mbNEXXnuxlz4a0
         o4iLRDv5VxyL5ozsd0g7ac6ts1NynokIgz5Slxy9AQHC5AzzmqXbo/nzr+kh95Pw6KCW
         /E7Q==
X-Gm-Message-State: AJIora9XRvxPGpf+leKPZ8CgeYj2i6zRqbv9sKm9UtRaFAE/3yW1Rimc
        XrGIhwc40diOnYdWUUlTt9fzXLLXJltBr2HbMFs=
X-Google-Smtp-Source: AGRyM1suQ+efFgSEm6WMYwr7VPInDZvgIajC37kfEc1dT+3lPzB+hU0jtrktZqlBNSgn+ZcMm4yYr8C1LOiy0hhHWyQ=
X-Received: by 2002:a17:906:dc8c:b0:726:e51b:d5c3 with SMTP id
 cs12-20020a170906dc8c00b00726e51bd5c3mr14355983ejc.369.1657909219529; Fri, 15
 Jul 2022 11:20:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220712235310.1935121-1-joannelkoong@gmail.com>
 <20220712235310.1935121-2-joannelkoong@gmail.com> <2a43287c8ec57119b9dcab46bd6fe7317b9f1f69.camel@redhat.com>
In-Reply-To: <2a43287c8ec57119b9dcab46bd6fe7317b9f1f69.camel@redhat.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 15 Jul 2022 11:20:08 -0700
Message-ID: <CAJnrk1ZLkn_hUa_Mh=Gc0ad9bz_mg53Rkhqu0xqtRWpjzxr91Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net: Add a bhash2 table hashed by port + address
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
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

On Thu, Jul 14, 2022 at 2:08 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2022-07-12 at 16:53 -0700, Joanne Koong wrote:
> > @@ -238,12 +331,23 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
> >                       continue;
> >               head = &hinfo->bhash[inet_bhashfn(net, port,
> >                                                 hinfo->bhash_size)];
> > +             head2 = inet_bhashfn_portaddr(hinfo, sk, net, port);
> > +
> >               spin_lock_bh(&head->lock);
> > +
> > +             if (inet_use_bhash2_on_bind(sk)) {
> > +                     if (inet_bhash2_addr_any_conflict(sk, port, l3mdev, relax, false))
> > +                             goto next_port;
> > +             }
> > +
> > +             spin_lock(&head2->lock);
>
> Minor nit: it looks like you can compute hash2 but not use it if the
> inet_bhash2_addr_any_conflict() call above is unsuccesful. You can move
> the inet_bhashfn_portaddr() down.
I will move this down.
>
>
> [...]
>
> > @@ -675,6 +785,112 @@ void inet_unhash(struct sock *sk)
> >  }
> >  EXPORT_SYMBOL_GPL(inet_unhash);
> >
> > +static bool inet_bind2_bucket_match(const struct inet_bind2_bucket *tb,
> > +                                 const struct net *net, unsigned short port,
> > +                                 int l3mdev, const struct sock *sk)
> > +{
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +     if (sk->sk_family == AF_INET6)
> > +             return net_eq(ib2_net(tb), net) && tb->port == port &&
> > +                     tb->l3mdev == l3mdev &&
> > +                     ipv6_addr_equal(&tb->v6_rcv_saddr, &sk->sk_v6_rcv_saddr);
> > +     else
> > +#endif
> > +             return net_eq(ib2_net(tb), net) && tb->port == port &&
> > +                     tb->l3mdev == l3mdev && tb->rcv_saddr == sk->sk_rcv_saddr;
> > +}
> > +
> > +bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb, const struct net *net,
> > +                                   unsigned short port, int l3mdev, const struct sock *sk)
> > +{
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +     struct in6_addr addr_any = {};
> > +
> > +     if (sk->sk_family == AF_INET6)
> > +             return net_eq(ib2_net(tb), net) && tb->port == port &&
> > +                     tb->l3mdev == l3mdev &&
> > +                     ipv6_addr_equal(&tb->v6_rcv_saddr, &addr_any);
> > +     else
> > +#endif
> > +             return net_eq(ib2_net(tb), net) && tb->port == port &&
> > +                     tb->l3mdev == l3mdev && tb->rcv_saddr == 0;
> > +}
> > +
> > +/* The socket's bhash2 hashbucket spinlock must be held when this is called */
> > +struct inet_bind2_bucket *
> > +inet_bind2_bucket_find(const struct inet_bind_hashbucket *head, const struct net *net,
> > +                    unsigned short port, int l3mdev, const struct sock *sk)
> > +{
> > +     struct inet_bind2_bucket *bhash2 = NULL;
> > +
> > +     inet_bind_bucket_for_each(bhash2, &head->chain)
> > +             if (inet_bind2_bucket_match(bhash2, net, port, l3mdev, sk))
> > +                     break;
> > +
> > +     return bhash2;
> > +}
> > +
> > +struct inet_bind_hashbucket *
> > +inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, int port)
> > +{
> > +     struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
> > +     u32 hash;
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +     struct in6_addr addr_any = {};
> > +
> > +     if (sk->sk_family == AF_INET6)
> > +             hash = ipv6_portaddr_hash(net, &addr_any, port);
> > +     else
> > +#endif
> > +             hash = ipv4_portaddr_hash(net, 0, port);
> > +
> > +     return &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
> > +}
> > +
> > +int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct sock *sk)
> > +{
> > +     struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
> > +     struct inet_bind_hashbucket *head, *head2;
> > +     struct inet_bind2_bucket *tb2, *new_tb2;
> > +     int l3mdev = inet_sk_bound_l3mdev(sk);
> > +     int port = inet_sk(sk)->inet_num;
> > +     struct net *net = sock_net(sk);
> > +
> > +     /* Allocate a bind2 bucket ahead of time to avoid permanently putting
> > +      * the bhash2 table in an inconsistent state if a new tb2 bucket
> > +      * allocation fails.
> > +      */
> > +     new_tb2 = kmem_cache_alloc(hinfo->bind2_bucket_cachep, GFP_ATOMIC);
> > +     if (!new_tb2)
> > +             return -ENOMEM;
> > +
> > +     head = &hinfo->bhash[inet_bhashfn(net, port,
> > +                                       hinfo->bhash_size)];
>
> Here 'head' is unused, you can avoid computing the related hash.
>
Ah yes,  you're right. We don't need head here since we already pass
in prev_saddr. Thanks for catching this, I will remove this.
>
> Cheers,
>
> Paolo
Thanks for taking a look, Paolo!
>
