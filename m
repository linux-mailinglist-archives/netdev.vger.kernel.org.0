Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3652B5B0A10
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiIGQ2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiIGQ2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:28:38 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9DE91D1B
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 09:28:37 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id r7so7833255ile.11
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 09:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=1rSFDHLg1qUELCcfcY1FOc7QEd2ZToDsySiPBL4o7HM=;
        b=ShPsBUMV/shgQU6DGqjpSVKK0oopeGgssghf7/tJoGHDTOwEwBgMgsgmLWXnnVwrnE
         vCMqBOvlr0tkKUdTpxKxXhC1R6jqx/Fr6SlHtHtP22nrdhEEhD2g39R3c0mOnZhq8FPP
         ItPJfMARO5RNJUrP69ZEEYWoSRz0pUR2kJKGe67cotAHt/N4pCXve+DWHy3RgbuQ9dyp
         b2VTdzEHb8smD88PT2ZBqma0bYcopyXQF7XB+HhnzElvjcb1FUXPIqZtUnCbQhgUZ/cn
         mkCrmdM23bd9u0ASVt3xkmaEGG6/C2Eg6umCBfmLDMtHIOKjwP3Ra0c6Xzimkm9t7zln
         0nSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=1rSFDHLg1qUELCcfcY1FOc7QEd2ZToDsySiPBL4o7HM=;
        b=Af0YgruAoGhaGWFNwzJK9xT/HiEPFz5fERdnKWEl4S8PGBG3FrePKMgqIKcW8yQVzj
         QcAPSzN8CDqdNz96kQmXgdMQKPqVR1LxBV33++gJnK9vBdyG5CMobdHvSNGT56ARXsuK
         goB3DnlfC+R8WT7iKIstZLU0hhxvaOOBgRydEdcqlSipF+O4Inc2AEHGoFr0xbMNZJlj
         /pQdsFpsJSGbiSgJVwd2pDV/PxzYBJ/II9KGVhqMMFupwFq87dUGO6fJaNCdxzH9ouYl
         Qa2MKWWpLWMTleP0DuTcTPL1VTvTHk/z5NGVoA3kBm7j5hKqRQOf2nD3DIXq/CB7yA0o
         i+Gw==
X-Gm-Message-State: ACgBeo0NxNm8ukQXr8qxLuYO/GwmIcvKjTq8kol1vqzkhMj1PJwWHhGP
        kvzDLtZM7QxNEa4hEyHk5h3n8pwEEvmDVRPZNb5R2g==
X-Google-Smtp-Source: AA6agR6c0+u00jL5pYJAvlMCQtBGp5dVYNd17boKH6kWq0MbvloI7bv+xu+rD/UiquS45lFSMCzvFhH6ipqEVr9eDhg=
X-Received: by 2002:a92:c5cc:0:b0:2eb:2065:e9c5 with SMTP id
 s12-20020a92c5cc000000b002eb2065e9c5mr2246895ilt.173.1662568116205; Wed, 07
 Sep 2022 09:28:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662361354.git.cdleonard@gmail.com> <0e4c0a98509b907e33c2f80b95cc6cfe713ac2b2.1662361354.git.cdleonard@gmail.com>
 <CANn89i+a0mMUMhUhTPoshifNzzuR_gfThPKptB8cuBiw6Bs5jw@mail.gmail.com> <4a47b4ea-750c-a569-5754-4aa0cd5218fc@gmail.com>
In-Reply-To: <4a47b4ea-750c-a569-5754-4aa0cd5218fc@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Sep 2022 09:28:25 -0700
Message-ID: <CANn89i+028SO1q6Hz8E3X7mrzkGSW5mQSLaMj70qka7amsPZ3w@mail.gmail.com>
Subject: Re: [PATCH v8 01/26] tcp: authopt: Initial support and key management
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Wed, Sep 7, 2022 at 9:19 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>
> On 9/7/22 01:57, Eric Dumazet wrote:
> > On Mon, Sep 5, 2022 at 12:06 AM Leonard Crestez <cdleonard@gmail.com> wrote:
> >>
> >> This commit adds support to add and remove keys but does not use them
> >> further.
> >>
> >> Similar to tcp md5 a single pointer to a struct tcp_authopt_info* struct
> >> is added to struct tcp_sock, this avoids increasing memory usage. The
> >> data structures related to tcp_authopt are initialized on setsockopt and
> >> only freed on socket close.
> >>
> >
> > Thanks Leonard.
> >
> > Small points from my side, please find them attached.
>
> ...
>
> >> +/* Free info and keys.
> >> + * Don't touch tp->authopt_info, it might not even be assigned yes.
> >> + */
> >> +void tcp_authopt_free(struct sock *sk, struct tcp_authopt_info *info)
> >> +{
> >> +       kfree_rcu(info, rcu);
> >> +}
> >> +
> >> +/* Free everything and clear tcp_sock.authopt_info to NULL */
> >> +void tcp_authopt_clear(struct sock *sk)
> >> +{
> >> +       struct tcp_authopt_info *info;
> >> +
> >> +       info = rcu_dereference_protected(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
> >> +       if (info) {
> >> +               tcp_authopt_free(sk, info);
> >> +               tcp_sk(sk)->authopt_info = NULL;
> >
> > RCU rules at deletion mandate that the pointer must be cleared before
> > the call_rcu()/kfree_rcu() call.
> >
> > It is possible that current MD5 code has an issue here, let's not copy/paste it.
>
> OK. Is there a need for some special form of assignment or is current
> plain form enough?

It is the right way (when clearing the pointer), no need for another form.

>
> >
> >> +       }
> >> +}
> >> +
> >> +/* checks that ipv4 or ipv6 addr matches. */
> >> +static bool ipvx_addr_match(struct sockaddr_storage *a1,
> >> +                           struct sockaddr_storage *a2)
> >> +{
> >> +       if (a1->ss_family != a2->ss_family)
> >> +               return false;
> >> +       if (a1->ss_family == AF_INET &&
> >> +           (((struct sockaddr_in *)a1)->sin_addr.s_addr !=
> >> +            ((struct sockaddr_in *)a2)->sin_addr.s_addr))
> >> +               return false;
> >> +       if (a1->ss_family == AF_INET6 &&
> >> +           !ipv6_addr_equal(&((struct sockaddr_in6 *)a1)->sin6_addr,
> >> +                            &((struct sockaddr_in6 *)a2)->sin6_addr))
> >> +               return false;
> >> +       return true;
> >> +}
> >
> > Always surprising to see this kind of generic helper being added in a patch.
>
> I remember looking for an equivalent and not finding it. Many places
> have distinct code paths for ipv4 and ipv6 and my use of
> "sockaddr_storage" as ipv4/ipv6 union is uncommon.

inetpeer_addr_cmp() might do it (and we also could fix a bug in it it
seems, at least for __tcp_get_metrics() usage :/

>
> It also wastes some memory.
>
> >> +int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
> >> +{
> >> +       struct tcp_sock *tp = tcp_sk(sk);
> >> +       struct tcp_authopt_info *info;
> >> +
> >> +       memset(opt, 0, sizeof(*opt));
> >> +       sock_owned_by_me(sk);
> >> +
> >> +       info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
> >
> > Probably not a big deal, but it seems the prior sock_owned_by_me()
> > might be redundant.
>
> The sock_owned_by_me call checks checks lockdep_sock_is_held
>
> The rcu_dereference_check call checks lockdep_sock_is_held ||
> rcu_read_lock_held()

Then if you own the socket lock, no need for rcu_dereference_check()

It could be instead an rcu_dereference_protected(). This is stronger, because
if your thread no longer owns the socket lock, but is inside
rcu_read_lock(), we would
still get a proper lockdep splat.

>
> This is a getsockopt so caller ensures socket locking but
> rcu_read_lock_held() == 0.
>
> The sock_owned_by_me is indeed redundant because it seems very unlikely
> the sockopt calling conditions will be changes. It was mostly there to
> clarify for myself because I had probably at one time with locking
> warnings. I guess they can be removed.
>
> >> +int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
> >> +{
> >> +       struct tcp_authopt_key opt;
> >> +       struct tcp_authopt_info *info;
> >> +       struct tcp_authopt_key_info *key_info, *old_key_info;
> >> +       struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
> >> +       int err;
> >> +
> >> +       sock_owned_by_me(sk);
> >> +       if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
> >> +               return -EPERM;
> >> +
> >> +       err = _copy_from_sockptr_tolerant((u8 *)&opt, sizeof(opt), optval, optlen);
> >> +       if (err)
> >> +               return err;
> >> +
> >> +       if (opt.flags & ~TCP_AUTHOPT_KEY_KNOWN_FLAGS)
> >> +               return -EINVAL;
> >> +
> >> +       if (opt.keylen > TCP_AUTHOPT_MAXKEYLEN)
> >> +               return -EINVAL;
> >> +
> >> +       /* Delete is a special case: */
> >> +       if (opt.flags & TCP_AUTHOPT_KEY_DEL) {
> >> +               mutex_lock(&net->mutex);
> >> +               key_info = tcp_authopt_key_lookup_exact(sk, net, &opt);
> >> +               if (key_info) {
> >> +                       tcp_authopt_key_del(net, key_info);
> >> +                       err = 0;
> >> +               } else {
> >> +                       err = -ENOENT;
> >> +               }
> >> +               mutex_unlock(&net->mutex);
> >> +               return err;
> >> +       }
> >> +
> >> +       /* check key family */
> >> +       if (opt.flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
> >> +               if (sk->sk_family != opt.addr.ss_family)
> >> +                       return -EINVAL;
> >> +       }
> >> +
> >> +       /* Initialize tcp_authopt_info if not already set */
> >> +       info = __tcp_authopt_info_get_or_create(sk);
> >> +       if (IS_ERR(info))
> >> +               return PTR_ERR(info);
> >> +
> >> +       key_info = kmalloc(sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
> >
> > kzalloc() ?
>
> Yes
>
> >> +static int tcp_authopt_init_net(struct net *full_net)
> >
> > Hmmm... our convention is to use "struct net *net"
> >
> >> +{
> >> +       struct netns_tcp_authopt *net = &full_net->tcp_authopt;
> >
> > Here, you should use a different name ...
>
> OK, will replace with net_ao
>
> >> @@ -2267,10 +2268,11 @@ void tcp_v4_destroy_sock(struct sock *sk)
> >>                  tcp_clear_md5_list(sk);
> >>                  kfree_rcu(rcu_dereference_protected(tp->md5sig_info, 1), rcu);
> >>                  tp->md5sig_info = NULL;
> >>          }
> >>   #endif
> >> +       tcp_authopt_clear(sk);
> >
> > Do we really own the socket lock at this point ?
>
> Not sure how I would tell but there is a lockdep_sock_is_held check
> inside tcp_authopt_clear. I also added sock_owned_by_me and there were
> no warnings.

Ok then :)
