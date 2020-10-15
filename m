Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4408728FA1A
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 22:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732561AbgJOU2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 16:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgJOU2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 16:28:38 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDA6C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 13:28:37 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e2so420568wme.1
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 13:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2JQYws+cXlPQiME7QrvtzwfEDqbM+DrpSZEL42AxhEs=;
        b=pMDfb78pXTEeAihYWjGlqWa9AQk+n6vtUbwdEWRxKjqhKX5C0nK3jH9d7MTC9+So99
         Lg78mIzwY6B89CcuzOXrn7PKcb3q1hN8bmSaQgaBDQvxJIO2t/6hbS6MujMSRllJqiKH
         gAQUbIW0zoglE4dtgt2eE68cjavOxWDpi7kTkK36FIIx0Zlhr8/r8mu7sy9eyl2FEks7
         mSIh34Iti6bXZb52hAMM1qVDWO0vJgE/dg9j0ZfR/vMxOqL67jg41iliUYJYQGu7n0Nh
         BIYhXA80L1wQyzD7fwLNukc6lh12Cisg1KRTGuDTEVZoG0CEdcjnWyt3tYPsviaAOxT2
         5N8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2JQYws+cXlPQiME7QrvtzwfEDqbM+DrpSZEL42AxhEs=;
        b=hvV4UEWHqgNjFYrf3q3sg0CH3cQz9z8oTkqViXtyLcFPw9AGJpKgItRzsvA0TZQsa1
         usstbABlB0WooN+flliZ07fuqXhFyUQtYU6EdIQR9MYTQVc1ajC5mb4L55gLE6hA/vMS
         B4EsvIa4+1hSKBFLMMlBjjdNvhDs8tO5mNqe0Tt0u83DjIz5ZEPvrdTwx31cv7ZSaqYy
         ZDV5p4evQ5afh3oUbAUhfu0/NTGPgwj1kgbnak0sWQhF7cl/wsz4H/76zkCHwYgWAvSN
         RRVik9269h/JeWcBg/Wbk3McuA38MlPvgLOs7do61qtBKohII4bbE0fCyBMh6z9XgJ7m
         7RhA==
X-Gm-Message-State: AOAM532CmE7y4WNvZI5cnclxc4/zjY4X0OTZ7eb7D9FRjFrdCako1oUV
        slVsJfv4+dVoxP4zWF1l0C4/7gFjbY9qL1iFITAqhQ==
X-Google-Smtp-Source: ABdhPJxpG/p65i2CAe5DmA9wuzNojuZyPfG53HpLVU5D3Alj427F1aVM5eKxL0x4WAbD3BZgVlSEn6u8uhcYy2nJz54=
X-Received: by 2002:a7b:c255:: with SMTP id b21mr414048wmj.25.1602793716060;
 Thu, 15 Oct 2020 13:28:36 -0700 (PDT)
MIME-Version: 1.0
References: <87eelz4abk.fsf@marvin.dmesg.gr> <CADVnQym6OPVRcJ6PdR3hjN5Krcn0pugshdLZsrnzNQe1c52HXA@mail.gmail.com>
In-Reply-To: <CADVnQym6OPVRcJ6PdR3hjN5Krcn0pugshdLZsrnzNQe1c52HXA@mail.gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 15 Oct 2020 16:27:59 -0400
Message-ID: <CACSApvaPLMpzSja3j1LEuow2JofPQvL8i5Yo0BYL++xgHe3b1g@mail.gmail.com>
Subject: Re: TCP sender stuck in persist despite peer advertising non-zero window
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Apollon Oikonomopoulos <apoikos@dmesg.gr>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 4:22 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Thu, Oct 15, 2020 at 2:31 PM Apollon Oikonomopoulos <apoikos@dmesg.gr> wrote:
> >
> > Hi,
> >
> > I'm trying to debug a (possible) TCP issue we have been encountering
> > sporadically during the past couple of years. Currently we're running
> > 4.9.144, but we've been observing this since at least 3.16.
> >
> > Tl;DR: I believe we are seeing a case where snd_wl1 fails to be properly
> > updated, leading to inability to recover from a TCP persist state and
> > would appreciate some help debugging this.
>
> Thanks for the detailed report and diagnosis. I think we may need a
> fix something like the following patch below.
>
> Eric/Yuchung/Soheil, what do you think?
>
> commit 42b37c72aa73aaabd0c01b8c05c2205236279021
> Author: Neal Cardwell <ncardwell@google.com>
> Date:   Thu Oct 15 16:06:11 2020 -0400
>
>     tcp: fix to update snd_wl1 in bulk receiver fast path
>
>     In the header prediction fast path for a bulk data receiver, if no
>     data is newly acknowledged then we do not call tcp_ack() and do not
>     call tcp_ack_update_window(). This means that a bulk receiver that
>     receives large amounts of data can have the incoming sequence numbers
>     wrap, so that the check in tcp_may_update_window fails:
>        after(ack_seq, tp->snd_wl1)
>
>     The fix is to update snd_wl1 in the header prediction fast path for a
>     bulk data receiver, so that it keeps up and does not see wrapping
>     problems.
>
>     Signed-off-by: Neal Cardwell <ncardwell@google.com>
>     Reported-By: Apollon Oikonomopoulos <apoikos@dmesg.gr>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Looks great to me! thanks for the quick fix!

> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index b1ce2054291d..75be97f6a7da 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5766,6 +5766,8 @@ void tcp_rcv_established(struct sock *sk, struct
> sk_buff *skb)
>                                 tcp_data_snd_check(sk);
>                                 if (!inet_csk_ack_scheduled(sk))
>                                         goto no_ack;
> +                       } else {
> +                               tcp_update_wl(tp, TCP_SKB_CB(skb)->seq);
>                         }
>
>                         __tcp_ack_snd_check(sk, 0);
>
> neal
