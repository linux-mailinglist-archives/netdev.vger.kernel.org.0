Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9733A3C2A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 08:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhFKGpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 02:45:49 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:36817 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhFKGps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 02:45:48 -0400
Received: by mail-pj1-f47.google.com with SMTP id s17-20020a17090a8811b029016e89654f93so102468pjn.1;
        Thu, 10 Jun 2021 23:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pjo7phW2AHZZ8B5JlH88sMLV9txhd3FEwdOrHfgfVAo=;
        b=cr77dycXfwlqd+e99g9BpfiCQ4clm91T9VhRdbdek1NeGb12o2zE+VypzAVNp0oXgm
         OuaG5grEk6R9E6SUDMu/HbvjYaNAIwhT6UQwkgMF4gl76/hnE/0oVfN8Vwv9LQ6LPfhC
         tSeBf+8jUV3EFKkV9zb1820qd88X1VLr5fyWijEZsnknFP7sfKV4B1uPVpNH7CSuBecN
         PF64UTX1mSMypQ/vDxzvZrcaf29IC/UDmrv6wWUeRvI+VQqTsuoXnOCDlDyJKWyHoub3
         W69QktspgIeqMWBHbw5Yc73TjoeMpaJ/s8YWkpnVq7C8ohWhZARIVpzTgjLCbELcCu28
         F8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pjo7phW2AHZZ8B5JlH88sMLV9txhd3FEwdOrHfgfVAo=;
        b=JnuLXObWqYxSif4hoeVujhoBjwJw2HVNZmGoTmG0bXNnnSAOZg8zhKH3DnCJ0E4uck
         w9//YjT9FZ3pLK/XGuPbmjFUNdcZv5NrPi+GIMc7gu1httaVzbvBnygiVD8U+MrSyhuE
         Fxz+sAcNoBAKdU9f6sbtLd0tBXbFocvwdd0eCj7MHH3lkByHaqGy0lBkRBNQzPdETcLV
         /itk3nsiHIgmXK0kmSRjOWb/2LIixD6cM0JyCtOaBiNtjiFXLsPi3wi+bsR3Ei97H+m6
         s12wRL+IETNXl/btqCE4Ujm+WwOUkHcbD2qhYdVXEzJvyJP6Z9y8EZUQnegsRYyP8cft
         9/JQ==
X-Gm-Message-State: AOAM530ySXyvoASCMNVJFALN7l9Uq0AxbQbaH3lHA83iIOjPhfF5g+MT
        JqJVYk43l31meoM6KQgRQTQL9LauE8fRLyv1+nU=
X-Google-Smtp-Source: ABdhPJyG8pB+KRBDHSoCn1KawiWbvPXqoK+nhbtuPO57cIQBRfyMTIj2UYjOblOg3xi/uWkeiBgH9M3fkQm7+Be5N+o=
X-Received: by 2002:a17:902:694b:b029:118:b8b1:1e23 with SMTP id
 k11-20020a170902694bb0290118b8b11e23mr219478plt.31.1623393755882; Thu, 10 Jun
 2021 23:42:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com> <20210611042442.65444-2-alexei.starovoitov@gmail.com>
In-Reply-To: <20210611042442.65444-2-alexei.starovoitov@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 10 Jun 2021 23:42:24 -0700
Message-ID: <CAM_iQpW=a_ukO574qtZ6m4rqo2FrQifoGC1jcrd7yWK=6WWg1w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 9:27 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Introduce 'struct bpf_timer { __u64 :64; __u64 :64; };' that can be embedded
> in hash/array/lru maps as regular field and helpers to operate on it:

Can be or has to be? Huge difference here.

In the other thread, you said it is global data, which implies that it does
not have to be in a map.

In your test case or your example, all timers are still in a map. So what has
changed since then? Looks nothing to me.

>
> The bpf_timer_init() helper is receiving hidden 'map' and 'prog' arguments
> supplied by the verifier. The prog pointer is needed to do refcnting of bpf
> program to make sure that program doesn't get freed while timer is armed.
>

Nice trick but...

[...]

> +BPF_CALL_2(bpf_timer_start, struct bpf_timer_kern *, timer, u64, nsecs)
> +{
> +       struct bpf_hrtimer *t;
> +       int ret = 0;
> +
> +       ____bpf_spin_lock(&timer->lock);
> +       t = timer->timer;
> +       if (!t) {
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +       if (!hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer))
> +               /* If the timer wasn't active or callback already executing
> +                * bump the prog refcnt to keep it alive until
> +                * callback is invoked (again).
> +                */
> +               bpf_prog_inc(t->prog);

Hmm, finally you begin refcounting it, which you were strongly against. ;)

Three questions:

1. Can t->prog be freed between bpf_timer_init() and bpf_timer_start()?
If the timer subprog is always in the same prog which installs it, then
this is fine. But then how do multiple programs share a timer? In the
case of conntrack, either ingress or egress could install the timer,
it only depends which one gets traffic first. Do they have to copy
the same subprog for the same timer?

2. Can t->prog be freed between a timer expiration and bpf_timer_start()
again? It gets a refcnt when starting a timer and puts it when cancelling
or expired, so t->prog can be freed right after cancelling or expired. What
if another program which shares this timer wants to restart this timer?

3. Since you offer no API to read the expiration time, why not just use
BPF_TEST_RUN with a user-space timer? This is preferred by Andrii.

Thanks.
