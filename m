Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6CB4A887C
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352182AbiBCQSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352170AbiBCQSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:18:47 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B38C06173D
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:18:47 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 124so9864909ybw.6
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 08:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3q/cWOL3ZlVqjrUNlIy7qw4rghP9mEWMr54e6NmDLs0=;
        b=TpIKr9km45LRGn2HQwNDS5cd4h+3Tra02vddoTGU7XB5Qo+lT+Wrwm4CHAMM/H4guM
         P5lxMYSYyPFoSg6AjI9XTSZ2xiZxU8iF7WkWM4qfNI82rUdWmbj02lPYkQ64z2SozNo4
         AqH8ZvotvaX6A4nfjqVQWVtMty+AxIwzSymwzyYC9CaAu2eOiAw/FnUhnu3dgPlFE1Bk
         Y80YFiGVjV+i9d7dXYVWqbzZJc+elWbsKxYzPnFmcGiZVj/4sON4WKVSjEV/uRuaN9aL
         ZjzOpXujPzIvq+Fs+X7gYfe/oWxHNNQ0yigl3mKCeASR1veXSox6e4Gq3vZqYVQcLnIA
         hKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3q/cWOL3ZlVqjrUNlIy7qw4rghP9mEWMr54e6NmDLs0=;
        b=iGSwCjSDEbYWhnWEwetLQDSS8ds9MZKyau7wL4cPSPbccGlt9q2NwLJfse5hGRv5WK
         e3AbLj/cJubYEclkCWl/3u+DWVCajVkOT34NkgG1nKE5EzTXjQKRBRk8o6Fv3bLVvdod
         xEzl04s1ctJ3/xjIHFV2Z2wldARtFv5XptybsS7vAeNVICoxvQO79TtMcTYU/sSoODou
         5Z3oa4JPQEd7OLvOxfbZk15hlZujRf78llKtweFb0oBNiBy73XF3vGXGeh0eDE/MzEfX
         qIaEDjX9HrFTOhuC1BbiRoYnz56SLRfRjLeaPKhpAZEbFrUaylxPKKwSwrSQB3lbdtRH
         tkvw==
X-Gm-Message-State: AOAM533vbCiUEORygoof5RqXG4exFulVgoWA7hs8zt903B78gnShxH/h
        3Lhvq44oQ5TvUWNBHTsNp/jDqjghCh7JHIE9TSdjmONMOFseuoMvD7Y=
X-Google-Smtp-Source: ABdhPJy74vnGDFJmBBH5O0UdNEuZALuhvVvSoyWh71ZDEDEMmX/oPUocPymeXbkXrtVlL0aQ9RKolahlMeDkWjWEFWw=
X-Received: by 2002:a25:8885:: with SMTP id d5mr27287245ybl.383.1643905126551;
 Thu, 03 Feb 2022 08:18:46 -0800 (PST)
MIME-Version: 1.0
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-4-bigeasy@linutronix.de> <CANn89iLVPnhybrdjRh6ccv6UZHW-_W0ZHRO5c7dnWU44FUgd_g@mail.gmail.com>
 <YfvwbsKm4XtTUlsx@linutronix.de> <CANn89i+66MvzQVp=eTENzZY6s8+B+jQCoKEO_vXdzaDeHVTH5w@mail.gmail.com>
 <Yfv3c+5XieVR0xAh@linutronix.de>
In-Reply-To: <Yfv3c+5XieVR0xAh@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 08:18:34 -0800
Message-ID: <CANn89i+t4TgrryvSBmBMfsY63m6Fhxi+smiKfOwHTRAKxvcPLQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] net: dev: Makes sure netif_rx() can be
 invoked in any context.
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 7:40 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2022-02-03 07:25:01 [-0800], Eric Dumazet wrote:
> >
> > No, the loopback device (ifconfig log) I am referring to is in
> > drivers/net/loopback.c
> >
> > loopback_xmit() calls netif_rx() directly, while bh are already disabled.
>
> ah okay. Makes sense.
>
> > Instead of adding a local_bh_disable()/local_bh_enable() in netif_rx()
> > I suggested
> > to rename current netif_rx() to __netif_rx() and add a wrapper, eg :
>
> So we still end up with two interfaces. Do I move a few callers like the
> one you already mentioned over to the __netif_rx() interface or will it
> be the one previously mentioned for now?


I would say vast majority of drivers would use netif_rx()

Only the one we consider critical (loopback traffic) would use
__netif_rx(), after careful inspection.

As we said modern/high performance NIC are using NAPI and GRO these days.

Only virtual drivers might still use legacy netif_rx() and be in critical paths.

>
> Would something like
>
> diff --git a/include/linux/bottom_half.h b/include/linux/bottom_half.h
> index fc53e0ad56d90..561cbca431ca6 100644
> --- a/include/linux/bottom_half.h
> +++ b/include/linux/bottom_half.h
> @@ -30,7 +30,12 @@ static inline void local_bh_enable_ip(unsigned long ip)
>
>  static inline void local_bh_enable(void)
>  {
> -       __local_bh_enable_ip(_THIS_IP_, SOFTIRQ_DISABLE_OFFSET);
> +       if (unlikely(softirq_count() == SOFTIRQ_DISABLE_OFFSET)) {
> +               __local_bh_enable_ip(_THIS_IP_, SOFTIRQ_DISABLE_OFFSET);
> +       } else {
> +               preempt_count_sub(SOFTIRQ_DISABLE_OFFSET);
> +               barrier();
> +       }
>  }
>
>  #ifdef CONFIG_PREEMPT_RT
>
> lower the overhead to acceptable range? (I still need to sell this to
> peterz first).

I guess the cost of the  local_bh_enable()/local_bh_disable() pair
will be roughly the same, please measure it :)

>
> Sebastian
