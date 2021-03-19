Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F84342465
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 19:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhCSSP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 14:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhCSSP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 14:15:26 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6800C06175F;
        Fri, 19 Mar 2021 11:15:25 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id k24so4231329pgl.6;
        Fri, 19 Mar 2021 11:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yApSLu496m7gvqSRhwz6HeRoNaU50Bo27wlXzUIZtfg=;
        b=eehFhYe7ZsCKZWptxyH0GSZhy5Czr+VIm5/5FElKHxrK/4P3sYqetHdmkKeorMqAYi
         SOqlnw7HVehgKaV9C3Kyg2dqeOXMpmUGRwPDbPWy8Wj60BO5RYzhJuDbY6apBrJIoKkJ
         vsDoSq9U5qjx7mrQtiO7xxMr3a7sPCgcEsRBofgPCNCKu4+fl90GquyGAIelLzNL2/tu
         o2D3UCZjwpL9gZwPwvnYNWadT/m0WXeJH7wAl/giSchVh6Zuk0qB0t++wjck5fDXCmjq
         K8hCc5k+e9VqSZKvXaaK7CfRxCJFfhTb3Djc0TjK13IhEknLZhDgVaBAnXLUV0lC2o3n
         W7bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yApSLu496m7gvqSRhwz6HeRoNaU50Bo27wlXzUIZtfg=;
        b=reOf36TGQ7b21vv9PZWNE+e3qJwoNYfeH3iVPfHV7zTncH1cXadKdWUjjV7A0pNwn6
         eEiml+4gfqsN10wQgiWEqpOtpsgjbak+jIwadP3Lwv5k46lNF84Uh8GkHT1lzvrhuv5W
         Y35uPmu3PaslpvMxmsc9Vc8tG+dKaPCG2JLFlAcoJrm8Xzp87pZP8IPs/lk1Sk7ei/29
         J7qT0G9EMp7kB0Nx2ohWKMGz2WuvL0vaBbV9FOFtgyynhC5wAvQrJJ/A3rbM0RM2inP2
         tDJKEgg7mPvC+rKzbnXZE20hwrYvlT5AEQ9NUdNbJUm7WEr38CYzfVwEirM7UfKyVGDh
         xUww==
X-Gm-Message-State: AOAM533iZQoOv9U7UXmJsGwYGv5sCSSEZecGnfVNQmxX/lIfzXK6XXTB
        qMT3IGHUJ1c4AyIi15G0n6Fuj8Jzp6bgr8HIAMs=
X-Google-Smtp-Source: ABdhPJynWk83Rk87ejofNY38HDvwGkAlAwC/1NnuFdTn/Q4bqR54h7dRTJcA85qzFKeZsG/59qaCjB39fsY4RX26G+Q=
X-Received: by 2002:aa7:85c1:0:b029:1f4:4fcc:384d with SMTP id
 z1-20020aa785c10000b02901f44fcc384dmr10609791pfn.10.1616177725389; Fri, 19
 Mar 2021 11:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
 <1615777818-13969-1-git-send-email-linyunsheng@huawei.com>
 <20210315115332.1647e92b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpXvVZxBRHF6PBDOYSOSCj08nPyfcY0adKuuTg=cqffV+w@mail.gmail.com>
 <87eegddhsj.fsf@toke.dk> <CAHmME9qDU7VRmBV+v0tzLiUpMJykjswSDwqc9P43ZwG1UD7mzw@mail.gmail.com>
 <3bae7b26-9d7f-15b8-d466-ff5c26d08b35@huawei.com>
In-Reply-To: <3bae7b26-9d7f-15b8-d466-ff5c26d08b35@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 19 Mar 2021 11:15:14 -0700
Message-ID: <CAM_iQpVvR1eUQxgihWrZ==X=xQjaaeH_qkehvU0Y2R6i9eM-Qw@mail.gmail.com>
Subject: Re: [Linuxarm] Re: [RFC v2] net: sched: implement TCQ_F_CAN_BYPASS
 for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 12:33 AM Yunsheng Lin <linyunsheng@huawei.com> wrot=
e:
>
> On 2021/3/17 21:45, Jason A. Donenfeld wrote:
> > On 3/17/21, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
> >> Cong Wang <xiyou.wangcong@gmail.com> writes:
> >>
> >>> On Mon, Mar 15, 2021 at 2:07 PM Jakub Kicinski <kuba@kernel.org> wrot=
e:
> >>>>
> >>>> I thought pfifo was supposed to be "lockless" and this change
> >>>> re-introduces a lock between producer and consumer, no?
> >>>
> >>> It has never been truly lockless, it uses two spinlocks in the ring
> >>> buffer
> >>> implementation, and it introduced a q->seqlock recently, with this pa=
tch
> >>> now we have priv->lock, 4 locks in total. So our "lockless" qdisc end=
s
> >>> up having more locks than others. ;) I don't think we are going to a
> >>> right direction...
> >>
> >> Just a thought, have you guys considered adopting the lockless MSPC ri=
ng
> >> buffer recently introduced into Wireguard in commit:
> >>
> >> 8b5553ace83c ("wireguard: queueing: get rid of per-peer ring buffers")
> >>
> >> Jason indicated he was willing to work on generalising it into a
> >> reusable library if there was a use case for it. I haven't quite thoug=
h
> >> through the details of whether this would be such a use case, but
> >> figured I'd at least mention it :)
> >
> > That offer definitely still stands. Generalization sounds like a lot of=
 fun.
> >
> > Keep in mind though that it's an eventually consistent queue, not an
> > immediately consistent one, so that might not match all use cases. It
> > works with wg because we always trigger the reader thread anew when it
> > finishes, but that doesn't apply to everyone's queueing setup.
>
> Thanks for mentioning this.
>
> "multi-producer, single-consumer" seems to match the lockless qdisc's
> paradigm too, for now concurrent enqueuing/dequeuing to the pfifo_fast's
> queues() is not allowed, it is protected by producer_lock or consumer_loc=
k.
>
> So it would be good to has lockless concurrent enqueuing, while dequeuing
> can be protected by qdisc_lock() or q->seqlock, which meets the "multi-pr=
oducer,
> single-consumer" paradigm.

I don't think so. Usually we have one queue for each CPU so we can expect
each CPU has a lockless qdisc assigned, but we can not assume this in
the code, so we still have to deal with multiple CPU's sharing a lockless q=
disc,
and we usually enqueue and dequeue in process context, so it means we could
have multiple producers and multiple consumers.

On the other hand, I don't think the problems we have been fixing are the r=
ing
buffer implementation itself, they are about the high-level qdisc
state transitions.

Thanks.
