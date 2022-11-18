Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7289062F288
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 11:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbiKRK2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 05:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbiKRK2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 05:28:16 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5B4748EE
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 02:28:15 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-3938dc90ab0so26261357b3.4
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 02:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Phe8K3T2roJQ1H+frONUksDfd5FX5n6CX3jAvHcRAko=;
        b=iZDGHkz4bWccZNOy4nNBs+SAhqcijow+G5h5E1f6G5t5Ykw4vGCycpUktA9+dAoSuJ
         GDRIngqZXYvBoi6reLEWTIGSblB3PCup2StrNUpbiYU8q7Tk1pj1pJqrMASArmUbyeJK
         GUcJ5R7eIc8dnZ/lklzQycHOjH2oCBKnkCQHZ/tUbT7k+FsFv4GvdVW00VYvnhyG7WTv
         3l/QCOtMtLtu0sgcoGmLPwa4Y0RF2WAuaw3TKgXprpRvjLAgJeIiuyJ4AkFg7joihd8H
         tsQU5SShMFOik3SKTg6v2yJEpRwbRGBMDZOaIKQcQ0cex1GdGf4/MA2QD+KufxdddVYc
         sgkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Phe8K3T2roJQ1H+frONUksDfd5FX5n6CX3jAvHcRAko=;
        b=2V1BWyfjRElLcPFtOcIfR7PQHJO+d1bR0mNkQG1+4nAi8pjHNwFZ86fLap4nmj6x3x
         gmpwo9uU5wc0GG2PPGa46jqBmXQFerBg5wC0urbsvwBN4+6Au0dYpiOvBBvD4HsJZENl
         3izpG/Lf0alkwmUoOtkGwiv9CLnaNe/1FHeVNF26k8/wH4JkvHI/bVKE3M4BJ4FUHsnb
         B6BkJP8LvqU/CC8PwfIv44ER0h5ADG2feFchXOIRFcndKMSKslLn+3rMmrtqw98fUdSX
         V6iKCTdn2nUUo7pAKfT0YhPgVygpqJy411vvZo+LCGx+fETJqyRl5Q4wtVHTzmJsyZhY
         kE5w==
X-Gm-Message-State: ANoB5pl4gK2FJrYA5XH/FxNgrbSipCcPUb8RfeNutQcKHxWEiLlR9Bls
        GUcncEDjHh2XMf78kKvH7Dij9u9H30aAeE2HDNVeLg==
X-Google-Smtp-Source: AA0mqf7Ft0RFLdGTX2pztfLfXEjyixvuHCGCnPyFS7E1lZU0l0btAoPPk6zwdPkOjjqbhUih3AOXnTi3Ib52nSnbL8M=
X-Received: by 2002:a81:5f04:0:b0:393:ab0b:5a31 with SMTP id
 t4-20020a815f04000000b00393ab0b5a31mr3790452ywb.55.1668767294674; Fri, 18 Nov
 2022 02:28:14 -0800 (PST)
MIME-Version: 1.0
References: <20221114191619.124659-1-jakub@cloudflare.com> <166860541774.25745.4396978792984957790.git-patchwork-notify@kernel.org>
 <CANn89iLQUZnyGNCn2GpW31FXpE_Lt7a5Urr21RqzfAE4sYxs+w@mail.gmail.com>
 <CANn89i+8r6rvBZeVG7u01vJ4rYO5cqe+jfSFvYDvdUHyzb5HaQ@mail.gmail.com> <87wn7t29ac.fsf@cloudflare.com>
In-Reply-To: <87wn7t29ac.fsf@cloudflare.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 18 Nov 2022 02:28:03 -0800
Message-ID: <CANn89i+iRoHnJ=+MFB5N3c36t5AeeDpd7aHqheBdgKjhNH17qA@mail.gmail.com>
Subject: Re: [PATCH net v4] l2tp: Serialize access to sk_user_data with sk_callback_lock
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     patchwork-bot+netdevbpf@kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        tparkin@katalix.com, g1042620637@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 1:57 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Thu, Nov 17, 2022 at 01:40 AM -08, Eric Dumazet wrote:
> > On Thu, Nov 17, 2022 at 1:07 AM Eric Dumazet <edumazet@google.com> wrote:
> >>
> >> On Wed, Nov 16, 2022 at 5:30 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
> >> >
> >> > Hello:
> >> >
> >> > This patch was applied to netdev/net.git (master)
> >> > by David S. Miller <davem@davemloft.net>:
> >> >
> >> > On Mon, 14 Nov 2022 20:16:19 +0100 you wrote:
> >> > > sk->sk_user_data has multiple users, which are not compatible with each
> >> > > other. Writers must synchronize by grabbing the sk->sk_callback_lock.
> >> > >
> >> > > l2tp currently fails to grab the lock when modifying the underlying tunnel
> >> > > socket fields. Fix it by adding appropriate locking.
> >> > >
> >> > > We err on the side of safety and grab the sk_callback_lock also inside the
> >> > > sk_destruct callback overridden by l2tp, even though there should be no
> >> > > refs allowing access to the sock at the time when sk_destruct gets called.
> >> > >
> >> > > [...]
> >> >
> >> > Here is the summary with links:
> >> >   - [net,v4] l2tp: Serialize access to sk_user_data with sk_callback_lock
> >> >     https://git.kernel.org/netdev/net/c/b68777d54fac
> >> >
> >> >
> >>
> >> I guess this patch has not been tested with LOCKDEP, right ?
> >>
> >> sk_callback_lock always needs _bh safety.
> >>
> >> I will send something like:
> >>
> >> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> >> index 754fdda8a5f52e4e8e2c0f47331c3b22765033d0..a3b06a3cf68248f5ec7ae8be2a9711d0f482ac36
> >> 100644
> >> --- a/net/l2tp/l2tp_core.c
> >> +++ b/net/l2tp/l2tp_core.c
> >> @@ -1474,7 +1474,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel
> >> *tunnel, struct net *net,
> >>         }
> >>
> >>         sk = sock->sk;
> >> -       write_lock(&sk->sk_callback_lock);
> >> +       write_lock_bh(&sk->sk_callback_lock);
> >
> > Unfortunately this might still not work, because
> > setup_udp_tunnel_sock->udp_encap_enable() probably could sleep in
> > static_branch_inc() ?
> >
> > I will release the syzbot report, and let you folks work on a fix, thanks.
>
> Ah, the problem is with pppol2tp_connect racing with itself. Thanks for
> the syzbot report. I will take a look. I live for debugging deadlocks
> :-)

Hi Jakub, any updates on this issue ? (Other syzbot reports with the
same root cause are piling up)

Thanks
