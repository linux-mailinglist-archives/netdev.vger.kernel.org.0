Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8FE3B6F42
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 10:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhF2IYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 04:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbhF2IYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 04:24:39 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3078FC061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 01:22:12 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id m9so23076924ybo.5
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 01:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b86U7qOD9Go7UjAxHqjyMo73nkm6a/V5QTpw7IQUw/0=;
        b=SiX9r9dgg6r6z6VL+6XFCBA8PtLqqP8EjVjknH/LRrL0MsSzgzW6NoXOwoh0xQNgPV
         6zIu/InaqEx5zmydhC+QuLMT+UMrbsEXBw2JBgAPME4uXG67oygSZzmwUNSox69rlWOl
         MX8DDVzp8OTnMDPgbU3dYgjX+GSSPjCuZ14XCNAxPWIgvPccT/Hzd3IOYj+o0/eUUvdb
         Xp+he1Qspq+Fdop1raUQPjpzigswTnTn1q2/UJAdIYap8JNAzHw0+GAejHDASg54Q5bo
         S4TvOHlDZq/nWPxwgJroeOGnUqlY5YSG7WsfshaVlEH555kOnVTzX/B0chf7qEMnaXED
         hqOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b86U7qOD9Go7UjAxHqjyMo73nkm6a/V5QTpw7IQUw/0=;
        b=ipJ9UFmZsQVEjgQ57NdqKe93oBEC9Y2imuU2vmvpRtP33KJxU8cPQKEbLX1gahpy+7
         nT8CYXXbp8qmdAcmrTBissWQmKfQnHBqsMDNVf/OP0tUmD3w945FAY9/q/ubD+etJ+iy
         GC/s5ksaP6uJp0h1Hu/HeT4roJNHEccbq0U1naP1wMw7YiSnhZOY9z1BH84I8v2S7VX2
         3C1CgNNEgQhpaV3k0PuUh26/PszM8tbTQomB3DKR+yM8E4ksJZDLsOC1ud2wKJ/hoOvM
         CYIorzLr/YVmyb0xINOz2yS+BAL02G1lcHIteiG0XKR8S0zHKmRJP//d0yOqxpD8Y0Gy
         0vrQ==
X-Gm-Message-State: AOAM530dRy/RbKlXU6VZbUBaP8LQl1FNyb+dhPJMiyQSJeSp5LH7L8L3
        uQzsmWnwAT2f+9mqSay5ZzjZldEZp2PxiBnydMb4Ow==
X-Google-Smtp-Source: ABdhPJxeB+P2TJ4vfKfTrwgdN9swrJc/3hVQCio5bE343GXZDKj6fcFsoFxiEZmmVoGyrBJ22yERCtdFyRrcpJD+H8o=
X-Received: by 2002:a25:f0b:: with SMTP id 11mr21678043ybp.518.1624954930973;
 Tue, 29 Jun 2021 01:22:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210628144908.881499-1-phind.uet@gmail.com> <CANn89iJ6M2WFS3B+sSOysekScUFmO9q5YHxgHGsbozbvkW9ivg@mail.gmail.com>
 <79490158-e6d1-aabf-64aa-154b71205c74@gmail.com> <CADVnQy=Q9W=Vxu81ctPLx08D=ALnHBXGr0c4BLtQGxwQE+yjRg@mail.gmail.com>
 <ee5ef69e-ee3f-1df0-2033-5adc06a46b9c@gmail.com> <CADVnQynqMQhO4cBON=xUCkne9-E1hze3naMZZ8tQ-a0k71kh8g@mail.gmail.com>
 <205F52AB-4A5B-4953-B97E-17E7CACBBCD8@gmail.com>
In-Reply-To: <205F52AB-4A5B-4953-B97E-17E7CACBBCD8@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 29 Jun 2021 10:21:59 +0200
Message-ID: <CANn89iJbquZ=tVBRg7JNR8pB106UY4Xvi7zkPVn0Uov9sj8akg@mail.gmail.com>
Subject: Re: [PATCH] tcp: Do not reset the icsk_ca_initialized in tcp_init_transfer.
To:     Nguyen Dinh Phi <phind.uet@gmail.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 9:17 AM Nguyen Dinh Phi <phind.uet@gmail.com> wrote:
>
> On June 29, 2021 1:20:19 AM GMT+08:00, Neal Cardwell <ncardwell@google.com> wrote:
> >)
> >
> >On Mon, Jun 28, 2021 at 1:15 PM Phi Nguyen <phind.uet@gmail.com> wrote:
> >>
> >> On 6/29/2021 12:24 AM, Neal Cardwell wrote:
> >>
> >> > Thanks.
> >> >
> >> > Can you also please provide a summary of the event sequence that
> >> > triggers the bug? Based on your Reported-by tag, I guess this is
> >based
> >> > on the syzbot reproducer:
> >> >
> >> >
> >https://groups.google.com/g/syzkaller-bugs/c/VbHoSsBz0hk/m/cOxOoTgPCAAJ
> >> >
> >> > but perhaps you can give a summary of the event sequence that
> >causes
> >> > the bug? Is it that the call:
> >> >
> >> > setsockopt$inet_tcp_TCP_CONGESTION(r0, 0x6, 0xd,
> >> > &(0x7f0000000000)='cdg\x00', 0x4)
> >> >
> >> > initializes the CC and happens before the connection is
> >established,
> >> > and then when the connection is established, the line that sets:
> >> >    icsk->icsk_ca_initialized = 0;
> >> > is incorrect, causing the CC to be initialized again without first
> >> > calling the cleanup code that deallocates the CDG-allocated memory?
> >> >
> >> > thanks,
> >> > neal
> >> >
> >>
> >> Hi Neal,
> >>
> >> The gdb stack trace that lead to init_transfer_input() is as bellow,
> >the
> >> current sock state is TCP_SYN_RECV.
> >
> >Thanks. That makes sense as a snapshot of time for
> >tcp_init_transfer(), but I think what would be more useful would be a
> >description of the sequence of events, including when the CC was
> >initialized previous to that point (as noted above, was it that the
> >setsockopt(TCP_CONGESTION) completed before that point?).
> >
> >thanks,
> >neal
>
> I resend my message because I accidently used html format in last one. I am very sorry for the inconvenience caused.
> ---
> Yes, the CC had been initialized by the setsockopt, after that, it was initialized again in function tcp_init_transfer() because of setting isck_ca_initialized to 0.

"the setsockopt" is rather vague, sorry.


The hard part is that all scenarios have to be considered.

TCP flows can either be passive and active.

CC can be set :

1) Before the connect() or accept()
2) After the connect() or accept()
3) after the connect() but before 3WHS is completed.

So we need to make sure all cases will still work with any combination
of CDG CC (before/after) in the picture.

Note that a memory leak for a restricted CC (CDG can only be used by
CAP_NET_ADMIN privileged user)
 is a small problem compared to more serious bug that could be added
by an incomplete fix.

I also note that if icsk_ca_priv] was increased from 104 to 120 bytes,
tcp_cdg would no longer need a dynamic memory allocation.

Thank you.
