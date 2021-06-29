Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CFE3B72CE
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 14:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhF2NA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 09:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbhF2NA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 09:00:56 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E63C061767
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 05:58:28 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id o139so16247069ybg.9
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 05:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Ixc1yg9az9B0t1cymNZSTN2Zbg+u86yZpoOKVTjo0E=;
        b=Wicg5j6Czkzx0aBfwLjleCGbinRhL8+0w31l9FEZowcaMUpWvwBFPkRpcYqAIq9Uhn
         E/eMTTWZeI+EKOhf4H++Inrj3nLMtGcbPRthOpIWvPU9ZmoRh54CInF1TPBq8qaOcML3
         tv+eMU6hdKk3RSimSdiuYz3fuVFIXc5LrHNGoNn0v5la4fA5NQIzcBmQhbFzSBmoQfcw
         Srg8l463/0H/NQh/0SnvrHEwFqijLF0lSv6Mgh99EyZCG2ATAywcksdxC5avjcBuwa/M
         9ALnQkHDCcsr7Z8AZJsCIMqeB1MArs/LWT6uP+QARJjnyjCjwGkbEXFii77kkOS3lXtT
         h19A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Ixc1yg9az9B0t1cymNZSTN2Zbg+u86yZpoOKVTjo0E=;
        b=IVZwDqcGRfRryUlUnEMN4Tha0XYuDvlvqGQZhB8N+lknt3XDk7kJzcs0UXLdsHiqcP
         djPBRa+aVnu3PJ1ALqDnm8EwCUloAu63lYHTxoQFDI9DKkHzNLj9AnhMpVdluDwXQAMw
         GWfOEDIyDzMmZksJA/gv0E6/yzIQX409icLci7tOPjbAlzLTuwpEFv0rM8/QFAfC/Per
         bSIVx+X1+E7j7s5Op4HpO8xf/4Ve73gMbYTyijr7sQEBBHEzlZ4wGQFceE6GM2EOyxN1
         6IoXyr6HkSvlo3dqOKcT7eW53AzKuZE3JM8dfT5Upr4jSx7VJUHvsLDHd8zc5ZxX1EwG
         Kspw==
X-Gm-Message-State: AOAM532nKi1ZUVlD6ZvLZN/KIUU5xhbPLccVWlwIXkiupRFH6M+2Hy31
        gnHg1wvPBdiUbKsZvkr7POrBLFAQy0TIi5pE7gTn5g==
X-Google-Smtp-Source: ABdhPJzzoslHpNOjPtnVYKAzjGWGsIH245MtaS0SvFM7raV9Sntz6KxmD/giFXDhp6Zk1NFGv/oaa+Fhm006+0DYpUI=
X-Received: by 2002:a05:6902:544:: with SMTP id z4mr39530633ybs.452.1624971507741;
 Tue, 29 Jun 2021 05:58:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210628144908.881499-1-phind.uet@gmail.com> <CANn89iJ6M2WFS3B+sSOysekScUFmO9q5YHxgHGsbozbvkW9ivg@mail.gmail.com>
 <79490158-e6d1-aabf-64aa-154b71205c74@gmail.com> <CADVnQy=Q9W=Vxu81ctPLx08D=ALnHBXGr0c4BLtQGxwQE+yjRg@mail.gmail.com>
 <ee5ef69e-ee3f-1df0-2033-5adc06a46b9c@gmail.com> <CADVnQynqMQhO4cBON=xUCkne9-E1hze3naMZZ8tQ-a0k71kh8g@mail.gmail.com>
 <205F52AB-4A5B-4953-B97E-17E7CACBBCD8@gmail.com> <CANn89iJbquZ=tVBRg7JNR8pB106UY4Xvi7zkPVn0Uov9sj8akg@mail.gmail.com>
 <1786BBEE-9C7B-45B2-B451-F535ABB804EF@gmail.com>
In-Reply-To: <1786BBEE-9C7B-45B2-B451-F535ABB804EF@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 29 Jun 2021 14:58:16 +0200
Message-ID: <CANn89iK4Qwf0ezWac3Cn1xWN_Hw+-QL-+H8YmDm4cZP=FH+MTQ@mail.gmail.com>
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

On Tue, Jun 29, 2021 at 2:28 PM Nguyen Dinh Phi <phind.uet@gmail.com> wrote:
>
> On June 29, 2021 4:21:59 PM GMT+08:00, Eric Dumazet <edumazet@google.com> wrote:
> >On Tue, Jun 29, 2021 at 9:17 AM Nguyen Dinh Phi <phind.uet@gmail.com>
> >wrote:
> >>
> >> On June 29, 2021 1:20:19 AM GMT+08:00, Neal Cardwell
> ><ncardwell@google.com> wrote:
> >> >)
> >> >
> >> >On Mon, Jun 28, 2021 at 1:15 PM Phi Nguyen <phind.uet@gmail.com>
> >wrote:
> >> >>
> >> >> On 6/29/2021 12:24 AM, Neal Cardwell wrote:
> >> >>
> >> >> > Thanks.
> >> >> >
> >> >> > Can you also please provide a summary of the event sequence that
> >> >> > triggers the bug? Based on your Reported-by tag, I guess this is
> >> >based
> >> >> > on the syzbot reproducer:
> >> >> >
> >> >> >
> >>
> >>https://groups.google.com/g/syzkaller-bugs/c/VbHoSsBz0hk/m/cOxOoTgPCAAJ
> >> >> >
> >> >> > but perhaps you can give a summary of the event sequence that
> >> >causes
> >> >> > the bug? Is it that the call:
> >> >> >
> >> >> > setsockopt$inet_tcp_TCP_CONGESTION(r0, 0x6, 0xd,
> >> >> > &(0x7f0000000000)='cdg\x00', 0x4)
> >> >> >
> >> >> > initializes the CC and happens before the connection is
> >> >established,
> >> >> > and then when the connection is established, the line that sets:
> >> >> >    icsk->icsk_ca_initialized = 0;
> >> >> > is incorrect, causing the CC to be initialized again without
> >first
> >> >> > calling the cleanup code that deallocates the CDG-allocated
> >memory?
> >> >> >
> >> >> > thanks,
> >> >> > neal
> >> >> >
> >> >>
> >> >> Hi Neal,
> >> >>
> >> >> The gdb stack trace that lead to init_transfer_input() is as
> >bellow,
> >> >the
> >> >> current sock state is TCP_SYN_RECV.
> >> >
> >> >Thanks. That makes sense as a snapshot of time for
> >> >tcp_init_transfer(), but I think what would be more useful would be
> >a
> >> >description of the sequence of events, including when the CC was
> >> >initialized previous to that point (as noted above, was it that the
> >> >setsockopt(TCP_CONGESTION) completed before that point?).
> >> >
> >> >thanks,
> >> >neal
> >>
> >> I resend my message because I accidently used html format in last
> >one. I am very sorry for the inconvenience caused.
> >> ---
> >> Yes, the CC had been initialized by the setsockopt, after that, it
> >was initialized again in function tcp_init_transfer() because of
> >setting isck_ca_initialized to 0.
> >
> >"the setsockopt" is rather vague, sorry.
> >
> >
> >The hard part is that all scenarios have to be considered.
> >
> >TCP flows can either be passive and active.
> >
> >CC can be set :
> >
> >1) Before the connect() or accept()
> >2) After the connect() or accept()
> >3) after the connect() but before 3WHS is completed.
> >
> >So we need to make sure all cases will still work with any combination
> >of CDG CC (before/after) in the picture.
> >
> >Note that a memory leak for a restricted CC (CDG can only be used by
> >CAP_NET_ADMIN privileged user)
> > is a small problem compared to more serious bug that could be added
> >by an incomplete fix.
> >
> >I also note that if icsk_ca_priv] was increased from 104 to 120 bytes,
> >tcp_cdg would no longer need a dynamic memory allocation.
> >
> >Thank you.
>
> Hi,
> I will try to see whether I am able to get the full sequence. I am also affraid of making a change that could affect big part of the kernel.
> About CDG, how we can get rid of dynamic allocation by increasing icsk_priv_data to 120? because I see that the window size is a module parameter, so I guess it is not a fixed value.

Given this module parameter is constant, I doubt anyone really uses a
bigger window.
If researchers want to experiment bigger window, they could adjust a
macro and recompile (#define TCP_CDG_WINDOW 8 -> X)

> Because the problem only happens with CDG, is adding check in its tcp_cdg_init() function Ok? And about  icsk_ca_initialized, Could I expect it to be 0 in CC's init functions?

I think icsk_ca_initialized  lost its strong meaning when CDG was
introduced (since this is the only CC allocating memory)

The bug really is that before clearing icsk_ca_initialized we should
call cc->release()

Maybe we missed this cleanup in commit
8919a9b31eb4fb4c0a93e5fb350a626924302aa6 ("tcp: Only init congestion
control if not initialized already")

Although I am not sure what happens at accept() time when the listener
socket is cloned.

If we make any hypothesis, we need to check all CC modules to make
sure they respect it.

>
> Thank you.
