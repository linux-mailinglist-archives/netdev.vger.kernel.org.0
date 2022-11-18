Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22EE562F31D
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 12:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241426AbiKRLAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 06:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbiKRLA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 06:00:29 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A77E9151E
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 03:00:28 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x102so6703418ede.0
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 03:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=045BZCX9liXxVr7hMCOumqgYgOm6S+oLJaGhMlxPCy8=;
        b=I2RMDm1JWgqMYiMi5enWEcSL7EZaXVunJxsnCx003DfI8AZZvwtbMaLFE0kkOEn3uD
         Ec6cceLLNEbSLveEoOb8V9r75+BL1ORUeWRRLyPKUqE4sA5JsbI7xHrscsLB62vPkuVc
         0WCUEhoNFoLw8IystACxE3ro6QsVq6BfOW9zE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=045BZCX9liXxVr7hMCOumqgYgOm6S+oLJaGhMlxPCy8=;
        b=IL2/tCIqzykLZP1LYW8au4tTl1pV6KRPX6E8c7+aAr5qXhNbR3fgvYnzZRaMxKt3iy
         ntXbmSeSa1k4/UIPgw5YiuQZDR3b2JeKtge878kzW+bGDttqr+VWJxkrasoon+19Kzbo
         qse5e5vwOBc2ce2OdwnM0Zhtk/oJhyK+6DO0BZEHxjQY3c+kIY/SDfbqmtVUYnQ+X9Kv
         BMfzXERReYTsFJ0I8zqMVu/1OfAUDF866rjFpcyzgb5WPyE1NsGXYMlIhsSb0vcHl0oj
         jGAy2c8mh105bvlXehGsZ3w6wmcAbbeV/dtDdWDIBEJWGTjwJwmHwo02nVnsIb8LJpoN
         UTkw==
X-Gm-Message-State: ANoB5pnsRRArUlju6Y6+rXrT4ub95I8Y3rpIaSlP0xFNOoge8aOliE0+
        lrBrzG4ohU5OGMxmutcd5wpnUw==
X-Google-Smtp-Source: AA0mqf5RbbGoDxPPW3TLD49f8SLrjo4ImlJcyvR60sK6w+XJrcrdTpY12XimoeELGoCpPLVpHs3f3w==
X-Received: by 2002:a05:6402:f11:b0:467:8813:cab5 with SMTP id i17-20020a0564020f1100b004678813cab5mr5661411eda.369.1668769226585;
        Fri, 18 Nov 2022 03:00:26 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id p18-20020a17090628d200b00782ee6b34f2sm1519021ejd.183.2022.11.18.03.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 03:00:26 -0800 (PST)
References: <20221114191619.124659-1-jakub@cloudflare.com>
 <166860541774.25745.4396978792984957790.git-patchwork-notify@kernel.org>
 <CANn89iLQUZnyGNCn2GpW31FXpE_Lt7a5Urr21RqzfAE4sYxs+w@mail.gmail.com>
 <CANn89i+8r6rvBZeVG7u01vJ4rYO5cqe+jfSFvYDvdUHyzb5HaQ@mail.gmail.com>
 <87wn7t29ac.fsf@cloudflare.com>
 <CANn89i+iRoHnJ=+MFB5N3c36t5AeeDpd7aHqheBdgKjhNH17qA@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     patchwork-bot+netdevbpf@kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        tparkin@katalix.com, g1042620637@gmail.com
Subject: Re: [PATCH net v4] l2tp: Serialize access to sk_user_data with
 sk_callback_lock
Date:   Fri, 18 Nov 2022 11:57:29 +0100
In-reply-to: <CANn89i+iRoHnJ=+MFB5N3c36t5AeeDpd7aHqheBdgKjhNH17qA@mail.gmail.com>
Message-ID: <877czsplx3.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 02:28 AM -08, Eric Dumazet wrote:
> On Thu, Nov 17, 2022 at 1:57 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> On Thu, Nov 17, 2022 at 01:40 AM -08, Eric Dumazet wrote:
>> > On Thu, Nov 17, 2022 at 1:07 AM Eric Dumazet <edumazet@google.com> wrote:
>> >>
>> >> On Wed, Nov 16, 2022 at 5:30 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
>> >> >
>> >> > Hello:
>> >> >
>> >> > This patch was applied to netdev/net.git (master)
>> >> > by David S. Miller <davem@davemloft.net>:
>> >> >
>> >> > On Mon, 14 Nov 2022 20:16:19 +0100 you wrote:
>> >> > > sk->sk_user_data has multiple users, which are not compatible with each
>> >> > > other. Writers must synchronize by grabbing the sk->sk_callback_lock.
>> >> > >
>> >> > > l2tp currently fails to grab the lock when modifying the underlying tunnel
>> >> > > socket fields. Fix it by adding appropriate locking.
>> >> > >
>> >> > > We err on the side of safety and grab the sk_callback_lock also inside the
>> >> > > sk_destruct callback overridden by l2tp, even though there should be no
>> >> > > refs allowing access to the sock at the time when sk_destruct gets called.
>> >> > >
>> >> > > [...]
>> >> >
>> >> > Here is the summary with links:
>> >> >   - [net,v4] l2tp: Serialize access to sk_user_data with sk_callback_lock
>> >> >     https://git.kernel.org/netdev/net/c/b68777d54fac
>> >> >
>> >> >
>> >>
>> >> I guess this patch has not been tested with LOCKDEP, right ?
>> >>
>> >> sk_callback_lock always needs _bh safety.
>> >>
>> >> I will send something like:
>> >>
>> >> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
>> >> index 754fdda8a5f52e4e8e2c0f47331c3b22765033d0..a3b06a3cf68248f5ec7ae8be2a9711d0f482ac36
>> >> 100644
>> >> --- a/net/l2tp/l2tp_core.c
>> >> +++ b/net/l2tp/l2tp_core.c
>> >> @@ -1474,7 +1474,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel
>> >> *tunnel, struct net *net,
>> >>         }
>> >>
>> >>         sk = sock->sk;
>> >> -       write_lock(&sk->sk_callback_lock);
>> >> +       write_lock_bh(&sk->sk_callback_lock);
>> >
>> > Unfortunately this might still not work, because
>> > setup_udp_tunnel_sock->udp_encap_enable() probably could sleep in
>> > static_branch_inc() ?
>> >
>> > I will release the syzbot report, and let you folks work on a fix, thanks.
>>
>> Ah, the problem is with pppol2tp_connect racing with itself. Thanks for
>> the syzbot report. I will take a look. I live for debugging deadlocks
>> :-)
>
> Hi Jakub, any updates on this issue ? (Other syzbot reports with the
> same root cause are piling up)
>
> Thanks

Sorry, I don't have anything yet. I have reserved time to work on it
this afternoon (I'm in the CET timezone).

Alternatively, I can send a revert right away and come back with fixed
patch once I have that, if you prefer.
