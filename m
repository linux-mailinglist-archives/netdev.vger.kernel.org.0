Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8356185B4
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 18:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbiKCRFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 13:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiKCRFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 13:05:11 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57AD11C939
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 10:04:31 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id r3so2985559yba.5
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 10:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NZv2dY0yFJqMLdVk2KmNZo3zHTpFU9k8HiT7lLkRxNw=;
        b=EHzFTNrmtlwDQ8zm75RvzwKMMrfRIx1GTZbsMP2AfoYM6+q1PViM+DzZCyYY7XF/Eq
         bQydB+nvfdgrA1ZI9AjnMHmpQ5F55HFUO6s3HZ3UBZJe5aHIK7NJG1T9XhEr3GJCDVNt
         AoNCDYew3A7FbcqMTIFeJrkTjpfidEUTn3r36ufp5o0VPoWwpxvke4wVIlRkdIP2yQDZ
         aSWubCjXkidUZ+N3Tf534tVusucLWZZZNbwxoXqHA6MQVlRVmGaRULB/c2TWkFx24XMk
         YXlVIfxQtvZaaw403A0YCMtGbXAoJeGGUlbfFVrYTbA3yfxQcTbwhNJXzV1kBG8mFLLt
         vafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NZv2dY0yFJqMLdVk2KmNZo3zHTpFU9k8HiT7lLkRxNw=;
        b=ZxtpuT68CdddrgCrjs4m3e1N/kYF/4BzgSrpv0INB62JfoiEz+6r9ESjmxDJikv6NV
         xHB6SEmN5GlwMCCo+elSl9YpC9fZfn8Wm+HzVNpb1cReRKAtdozHh2BKa3PMa7kvNyxI
         zxzidftYsa2v7xpJ9CWot23mpQ3153MVd+gDAwVRELrKMK0RM3GZz2QKU4tBi/HzJjFy
         kWrrjRd/gEeArFeHRc1Jl++RuP0kOFnA+YgBKWEXgs8KH9QuasMOW2TKkP3t2S+82X25
         /TpF84cGhINv/Lgfak1BhF1DspgoKzo1/4dPTjC/ylC95nRX+hVpPkH4L2PP59aj6F2Z
         grWw==
X-Gm-Message-State: ACrzQf2cEl6JVHAyx9rerqqyeC0jiz+D92Ar5t9selByad/8cLZf2NTI
        CGpBF5GxjhZViIg+v/AA0QtnWkQ0Xg+mC/MjVvTQVg==
X-Google-Smtp-Source: AMsMyM4Dwbn9oGoS8pCqhuU1pSWVrzSW5pYUVHNZ/iIdST8NL8PoPk0Qb2ASkJM4NFq8qXCyXztAqfiM2oHozyiYOEM=
X-Received: by 2002:a25:7a01:0:b0:6b0:820:dd44 with SMTP id
 v1-20020a257a01000000b006b00820dd44mr28183106ybc.387.1667495070348; Thu, 03
 Nov 2022 10:04:30 -0700 (PDT)
MIME-Version: 1.0
References: <20221102211350.625011-1-dima@arista.com> <20221102211350.625011-3-dima@arista.com>
 <CANn89iLbOikuG9+Tna9M0Gr-diF2vFpfMV8MDP8rBuN49+Mwrg@mail.gmail.com> <b053edbd-2dbd-f3f3-7f6c-c70d5b58a00d@arista.com>
In-Reply-To: <b053edbd-2dbd-f3f3-7f6c-c70d5b58a00d@arista.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Nov 2022 10:04:19 -0700
Message-ID: <CANn89i+2ZOaQwmJ9EBn7796byAn9=mQPyM_gzdchsWCy-_GrjQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] net/tcp: Disable TCP-MD5 static key on
 tcp_md5sig_info destruction
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 3, 2022 at 9:53 AM Dmitry Safonov <dima@arista.com> wrote:
>
> On 11/2/22 21:25, Eric Dumazet wrote:
> > On Wed, Nov 2, 2022 at 2:14 PM Dmitry Safonov <dima@arista.com> wrote:
> [..]
> >> @@ -337,11 +338,13 @@ EXPORT_SYMBOL(tcp_time_wait);
> >>  void tcp_twsk_destructor(struct sock *sk)
> >>  {
> >>  #ifdef CONFIG_TCP_MD5SIG
> >> -       if (static_branch_unlikely(&tcp_md5_needed)) {
> >> +       if (static_branch_unlikely(&tcp_md5_needed.key)) {
> >>                 struct tcp_timewait_sock *twsk = tcp_twsk(sk);
> >>
> >> -               if (twsk->tw_md5_key)
> >> +               if (twsk->tw_md5_key) {
> >
> > Orthogonal to this patch, but I wonder why we do not clear
> > twsk->tw_md5_key before kfree_rcu()
> >
> > It seems a lookup could catch the invalid pointer.
> >
> >>                         kfree_rcu(twsk->tw_md5_key, rcu);
> >> +                       static_branch_slow_dec_deferred(&tcp_md5_needed);
> >> +               }
> >>         }
>
> I looked into that, it seems tcp_twsk_destructor() is called from
> inet_twsk_free(), which is either called from:
> 1. inet_twsk_put(), protected by tw->tw_refcnt
> 2. sock_gen_put(), protected by the same sk->sk_refcnt
>
> So, in result, if I understand correctly, lookups should fail on ref
> counter check. Maybe I'm missing something, but clearing here seems not
> necessary?
>
> I can add rcu_assign_pointer() just in case the destruction path changes
> in v2 if you think it's worth it :-)

Agree, this seems fine.
