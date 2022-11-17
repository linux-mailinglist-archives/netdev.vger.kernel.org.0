Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC6862D733
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239481AbiKQJkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239318AbiKQJkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:40:15 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1507765C7
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:40:15 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id g127so1205484ybg.8
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wPCF5TynOos8jFWTZzpZKRWse/8XXCCxUMqLIMwBweY=;
        b=HKLe08Zh90AN7Z9LJtncym+NwpRlKmo9sg7NHCGTdDGsX0L7RwVUaKrEu4tljhu4SV
         yBcrdgfUgf3NcLcDoCqr8c+lyG1a3FMrE+2VP/45ZO9ANTGOteFqs+8YRYddfY3u33Em
         MEkzlTOXCXtm8wWVAI0bsl7+uLusUV0VcbOwmEXECY5sGx2LPkv/C9JCUcS83V/ZnH8B
         57BS9/tNx7PsMSCWSVgQEKwspMcgdY6rvFth7C0w6SwqOsb24KB7wojHrS7PEK6AGhh3
         uUMIkDSf8L+RuBbjw2oqrc5oqj80fdJWbmSnkrFp4yDLVXlaUaQkl1gcAtYzUei3Pqr8
         pKEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wPCF5TynOos8jFWTZzpZKRWse/8XXCCxUMqLIMwBweY=;
        b=MId4nxnEkX7nekngQsB9cQfxUxx1+xHdeTvNhRAfTrSRBYHMj46EM+5OrepDJ7t++m
         zTMt7wpXL02TwNhfRM6c1/ohb1q/Zx5YSnBt0M9tFIVAwwulF6IZHyScuF1n+T4rZfXP
         nyQOGKAXAjrs3/4obdcEf7UhoIttgPdTouKzIVv7PBWxVIj5t2GBMd9cyZGJ2lgE4v6Q
         Ih+XXQ89LF/7z2TtU5pLcTsomEUo98GxRBUYD1CMZR07bLuSnpDZWUZBvSYHHj5lTYwz
         16+F2FAhh7RY4ZqMxJDb8JpRpPctKA0FEJt9DtMU8nTGx0DEVVMQ2MU3y7Nrb/O3E2h8
         D7uA==
X-Gm-Message-State: ANoB5plIkOWxJ9ajw9uOwFL+TRd2Q+hhOU6Q9p6kZvuYCkKgoEAW8DBM
        EssFumHv6DeqGMQJxceYpMTHaKQmtCjQEakgiKtFFhqnj8foQA==
X-Google-Smtp-Source: AA0mqf7GJwck6LmT1b18kDscHyyNj2GbSW08UZNIUBiGf1zETDl1+qur3F3N0SVp78CM+vLZuyE/DOWLbEXRFY3zoD0=
X-Received: by 2002:a25:bcc6:0:b0:6dd:1c5c:5602 with SMTP id
 l6-20020a25bcc6000000b006dd1c5c5602mr1455584ybm.36.1668678014033; Thu, 17 Nov
 2022 01:40:14 -0800 (PST)
MIME-Version: 1.0
References: <20221114191619.124659-1-jakub@cloudflare.com> <166860541774.25745.4396978792984957790.git-patchwork-notify@kernel.org>
 <CANn89iLQUZnyGNCn2GpW31FXpE_Lt7a5Urr21RqzfAE4sYxs+w@mail.gmail.com>
In-Reply-To: <CANn89iLQUZnyGNCn2GpW31FXpE_Lt7a5Urr21RqzfAE4sYxs+w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Nov 2022 01:40:02 -0800
Message-ID: <CANn89i+8r6rvBZeVG7u01vJ4rYO5cqe+jfSFvYDvdUHyzb5HaQ@mail.gmail.com>
Subject: Re: [PATCH net v4] l2tp: Serialize access to sk_user_data with sk_callback_lock
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
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

On Thu, Nov 17, 2022 at 1:07 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Nov 16, 2022 at 5:30 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
> >
> > Hello:
> >
> > This patch was applied to netdev/net.git (master)
> > by David S. Miller <davem@davemloft.net>:
> >
> > On Mon, 14 Nov 2022 20:16:19 +0100 you wrote:
> > > sk->sk_user_data has multiple users, which are not compatible with each
> > > other. Writers must synchronize by grabbing the sk->sk_callback_lock.
> > >
> > > l2tp currently fails to grab the lock when modifying the underlying tunnel
> > > socket fields. Fix it by adding appropriate locking.
> > >
> > > We err on the side of safety and grab the sk_callback_lock also inside the
> > > sk_destruct callback overridden by l2tp, even though there should be no
> > > refs allowing access to the sock at the time when sk_destruct gets called.
> > >
> > > [...]
> >
> > Here is the summary with links:
> >   - [net,v4] l2tp: Serialize access to sk_user_data with sk_callback_lock
> >     https://git.kernel.org/netdev/net/c/b68777d54fac
> >
> >
>
> I guess this patch has not been tested with LOCKDEP, right ?
>
> sk_callback_lock always needs _bh safety.
>
> I will send something like:
>
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index 754fdda8a5f52e4e8e2c0f47331c3b22765033d0..a3b06a3cf68248f5ec7ae8be2a9711d0f482ac36
> 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -1474,7 +1474,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel
> *tunnel, struct net *net,
>         }
>
>         sk = sock->sk;
> -       write_lock(&sk->sk_callback_lock);
> +       write_lock_bh(&sk->sk_callback_lock);

Unfortunately this might still not work, because
setup_udp_tunnel_sock->udp_encap_enable() probably could sleep in
static_branch_inc() ?

I will release the syzbot report, and let you folks work on a fix, thanks.
