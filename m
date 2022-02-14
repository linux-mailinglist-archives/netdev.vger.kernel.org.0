Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7500B4B3EB3
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 01:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238915AbiBNAtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 19:49:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbiBNAtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 19:49:06 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612F2522DD
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 16:48:59 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id g21so4295422vsp.6
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 16:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j/DD1kcEEx1FzzkCqZJ0YWoWrY+Puf6kpaDWO9X0kpE=;
        b=UxXnQ+h5Be3hyDTbwpzsDKmzhSOjZW5TMJJU4VBOPp2yJx3PBW91E31z9r5A+8/8qs
         HPyU04cC9MHBRasi8tkCnmogo1Bbo0S6EtK0te9cYYko3udaFH2ilwtO5t7u7ldmSkBc
         cBZ4CEKRcpyTb55h8tezHTVFr+7R3RkfYXje0g8FHi11jYBg/OwZoEbsebSnyJO4LuEs
         rD4CRAjamnZXp+Xnuqnm6JgdlY8RVonXmVFI3OyjeAQFa6K9M5VbQxlBsI+qaGIkGrsC
         R040JN7eZXO6Kd1wuXxEgoIzVXsl69g1L1f1Xmcbx0T7meKtCJ+vEY4tBTreHEV8DrAy
         Lupw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j/DD1kcEEx1FzzkCqZJ0YWoWrY+Puf6kpaDWO9X0kpE=;
        b=S+3H1tibiS1o0Hv8AUaBiv8JgKvWSZlsFWaYzJm/20WiBLjFHTu5qrv7OuRYMDQLrH
         5WNfWvNMLIKkF5c19GsqTXt6KQNiz9CGDL4QgAxCGvzcR8f7xDtIVDx0RwtL30BD2SaK
         SDWnilTpAcgtlCYxR4Mmn0QL2ZQN4b3HR/6gbKf9YsM4Dzuv0CyBxUck1JqgOCpgay9i
         H0bPH+cTcW4PgKouoSHM2v+s7gSqyoAragr6fanl5vq7apVwcMocXyeFuHLLSSn4f3re
         gnI0bTLfUy68NZW2Gxz5ygnn1pUi568qgU40Ft34kbkTkc1GTbELwI6sUEMDbEqUCozc
         zVxw==
X-Gm-Message-State: AOAM532Om5uqOZgOaORxXESqHj4lPQgWBd0IIPjzQYK6gWxYTVNxnkXL
        +4htCjy4sScdNGQyg3iSOs2gncwXFg0=
X-Google-Smtp-Source: ABdhPJxV8HYuo6lOYCJFX3KN6k5gLB+lfqdMK0HsH/XrJ2I0DDsuj5pr3O2kEjKJ3/3CVt3SrWCimg==
X-Received: by 2002:a05:6102:3751:: with SMTP id u17mr817314vst.81.1644799738374;
        Sun, 13 Feb 2022 16:48:58 -0800 (PST)
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com. [209.85.221.170])
        by smtp.gmail.com with ESMTPSA id x18sm5383208vsj.20.2022.02.13.16.48.57
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Feb 2022 16:48:57 -0800 (PST)
Received: by mail-vk1-f170.google.com with SMTP id o129so7369763vko.7
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 16:48:57 -0800 (PST)
X-Received: by 2002:a05:6122:78d:: with SMTP id k13mr3230602vkr.29.1644799737434;
 Sun, 13 Feb 2022 16:48:57 -0800 (PST)
MIME-Version: 1.0
References: <MWHPR2201MB1072BCCCFCE779E4094837ACD0329@MWHPR2201MB1072.namprd22.prod.outlook.com>
 <CA+FuTSeY-GNfBCppjRwhWrOnUg9JDOaesjby2+QbuvPOO5g-=Q@mail.gmail.com> <CA+FuTScRGQV5ePxbu7LReuAUc_AU3sQd7Mb8KGVmu+X2jSQSCQ@mail.gmail.com>
In-Reply-To: <CA+FuTScRGQV5ePxbu7LReuAUc_AU3sQd7Mb8KGVmu+X2jSQSCQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 13 Feb 2022 19:48:21 -0500
X-Gmail-Original-Message-ID: <CA+FuTSc77mc6kwRpA4pvbyK-y5MdaJLkvWMqgXSohGp9XJFibw@mail.gmail.com>
Message-ID: <CA+FuTSc77mc6kwRpA4pvbyK-y5MdaJLkvWMqgXSohGp9XJFibw@mail.gmail.com>
Subject: Re: BUG: potential net namespace bug in IPv6 flow label management
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "Liu, Congyu" <liu3101@purdue.edu>,
        "security@kernel.org" <security@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
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

On Sun, Feb 13, 2022 at 6:47 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sun, Feb 13, 2022 at 11:10 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Sun, Feb 13, 2022 at 5:31 AM Liu, Congyu <liu3101@purdue.edu> wrote:
> > >
> > >
> > > Hi,
> > >
> > > In the test conducted on namespace, I found that one unsuccessful IPv6 flow label
> > > management from one net ns could stop other net ns's data transmission that requests
> > > flow label for a short time. Specifically, in our test case, one unsuccessful
> > > `setsockopt` to get flow label will affect other net ns's `sendmsg` with flow label
> > > set in cmsg. Simple PoC is included for verification. The behavior descirbed above
> > > can be reproduced in latest kernel.
> > >
> > > I managed to figure out the data flow behind this: when asking to get a flow label,
> > > some `setsockopt` parameters can trigger function `ipv6_flowlabel_get` to call `fl_create`
> > > to allocate an exclusive flow label, then call `fl_release` to release it before returning
> > > -ENOENT. Global variable `ipv6_flowlabel_exclusive`, a rate limit jump label that keeps
> > > track of number of alive exclusive flow labels, will get increased instantly after calling
> > > `fl_create`. Due to its rate limit design, `ipv6_flowlabel_exclusive` can only decrease
> > > sometime later after calling `fl_decrease`. During this period, if data transmission function
> > > in other net ns (e.g. `udpv6_sendmsg`) calls `fl_lookup`, the false `ipv6_flowlabel_exclusive`
> > > will invoke the `__fl_lookup`. In the test case observed, this function returns error and
> > > eventually stops the data transmission.
> > >
> > > I further noticed that this bug could somehow be vulnerable: if `setsockopt` is called
> > > continuously, then `sendmmsg` call from other net ns will be blocked forever. Using the PoC
> > > provided, if attack and victim programs are running simutaneously, victim program cannot transmit
> > > data; when running without attack program, the victim program can transmit data normally.
> >
> > Thanks for the clear explanation.
> >
> > Being able to use flowlabels without explicitly registering them
> > through a setsockopt is a fast path optimization introduced in commit
> > 59c820b2317f ("ipv6: elide flowlabel check if no exclusive leases
> > exist").
> >
> > Before this, any use of flowlabels required registering them, whether
> > the use was exclusive or not. As autoflowlabels already skipped this
> > stateful action, the commit extended this fast path to all non-exclusive
> > use. But if any exclusive flowlabel is active, to protect it, all
> > other flowlabel use has to be registered too.
> >
> > The commit message does state
> >
> >     This is an optimization. Robust applications still have to revert to
> >     requesting leases if the fast path fails due to an exclusive lease.
> >
> > Though I can see how the changed behavior has changed the perception of the API.
> >
> > That this extends up to a second after release of the last exclusive
> > flowlabel due to deferred release is only tangential to the issue?
> >
> > Flowlabels are stored globally, but associated with a netns
> > (fl->fl_net). Perhaps we can add a per-netns check to the
> > static_branch and maintain stateless behavior in other netns, even if
> > some netns maintain exclusive leases.
>
> The specific issue could be avoided by moving
>
>        if (fl_shared_exclusive(fl) || fl->opt)
>                static_branch_deferred_inc(&ipv6_flowlabel_exclusive);
>
> until later in ipv6_flowlabel_get, after the ENOENT response.
>
> But reserving a flowlabel is not a privileged operation, including for
> exclusive use. So the attack program can just be revised to pass
> IPV6_FL_F_CREATE and hold a real reservation. Then it also does
> not have to retry in a loop.
>
> The drop behavior is fully under control of the victim. If it reserves
> the flowlabel it intends to use, then the issue does not occur. For
> this reason I don't see this as a vulnerability.
>
> But the behavior is non-obvious and it is preferable to isolate netns
> from each other. I'm looking into whether we can add a per-netns
> "has exclusive leases" check.

Easiest is just to mark the netns as requiring the check only once it
starts having exclusive labels:

+++ b/include/net/ipv6.h
@@ -399,7 +399,8 @@ extern struct static_key_false_deferred
ipv6_flowlabel_exclusive;
 static inline struct ip6_flowlabel *fl6_sock_lookup(struct sock *sk,
                                                    __be32 label)
 {
-       if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key))
+       if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key) &&
+           READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
                return __fl6_sock_lookup(sk, label) ? : ERR_PTR(-ENOENT);

@@ -77,9 +77,10 @@ struct netns_ipv6 {
        spinlock_t              fib6_gc_lock;
        unsigned int             ip6_rt_gc_expire;
        unsigned long            ip6_rt_last_gc;
+       unsigned char           flowlabel_has_excl;
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
-       unsigned int            fib6_rules_require_fldissect;
        bool                    fib6_has_custom_rules;
+       unsigned int            fib6_rules_require_fldissect;

+++ b/net/ipv6/ip6_flowlabel.c
@@ -450,8 +450,10 @@ fl_create(struct net *net, struct sock *sk,
struct in6_flowlabel_req *freq,
                err = -EINVAL;
                goto done;
        }
-       if (fl_shared_exclusive(fl) || fl->opt)
+       if (fl_shared_exclusive(fl) || fl->opt) {
+               WRITE_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl, 1);
                static_branch_deferred_inc(&ipv6_flowlabel_exclusive);
+       }
        return fl;

Clearing flowlabel_has_excl when it stops using labels is more complex,
requiring either an atomic_t or walking the entire flowlabel hashtable on
each flowlabel free in the namespace. It can be skipped.
