Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF363B7615
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 18:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbhF2QCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 12:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbhF2QC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 12:02:29 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8218EC061767
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 09:00:01 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id l26so12406734vsm.9
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 09:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XhBLIZ8SeN0Q4YkyREg3OHNcuvIGJYM1mFWikBEBPjU=;
        b=FNLQ9Y+Fv5j4B6qlfvyZe82uBP23klCkWrC+zqTQCsIKE9CExq5Wu3RYv92l0WWnuX
         OZOi5q2iZAlkBZZONRziR9DxhUBzG9qRJIWj+85GGmVWGjSJESzhulPiLgA8E1cOS7gi
         Q6ybHlbpK/8HeKc4zyiPQXwNfl4mWqhmi0pJz3az+GiZzWjUqgAjXPbrZvmZTkkeFA9j
         MyzyZWHf2KRP14eJYRtPRi0l6A5wzUfiu689G7caqSon0tLYoLxQn9T9/7PbERYJ8Ysi
         Pb2WtmowmxRgENSjeCtuNeE/oir4tnyMBUjVkCwlvP+9tVCdhRe3IE3znOORbBtwhHn0
         7DsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XhBLIZ8SeN0Q4YkyREg3OHNcuvIGJYM1mFWikBEBPjU=;
        b=pVLrQ8ljiM+0bY5RDg4wlqDjt8rVedCL3udPRYOWIgORWUHYHPJFAMCpngvPlkTO59
         /v5mi1QjRViPEgf9KlssLkRg9E6R4KcIUtae/u43gpt5wH5O01y8f3COoy2mFxqQB63k
         zAZY4ejmwmc2Ctyuw7Br+m/SWBUIOLgjUI71megpKIX18WvyawSlAnlUmflMri3cYU7p
         96Xg2RF/3S67oNjrWV5BBgpfRZLQB1zetQ6uA791v5NYQxTwbj6lnRd9kPO/XVTIt1Ew
         YdFGbU6o5XYEaykU0ffz7zs60vt1bKZlv+hoVl0+O3xM/IFCbVSlqL7StDtttam89s6q
         lkHA==
X-Gm-Message-State: AOAM533w6hTqTonqsp4qatbGY0r7yLpKVUyvHR3aQU6uPxo7YgjQBmf1
        rBIiuB4BmCW0/dbrRiu6p4ocCr4s3izokgiWaVhFcw==
X-Google-Smtp-Source: ABdhPJwobUDC1855lf1exKUJy1yWcCxV2mM/hLHb8peV3rSrtPvrKzHsicCp5dWdk4WZMrWLD9E2gkICoF7r5fVgRlY=
X-Received: by 2002:a05:6102:a33:: with SMTP id 19mr24990687vsb.54.1624982400345;
 Tue, 29 Jun 2021 09:00:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210628144908.881499-1-phind.uet@gmail.com> <CANn89iJ6M2WFS3B+sSOysekScUFmO9q5YHxgHGsbozbvkW9ivg@mail.gmail.com>
 <79490158-e6d1-aabf-64aa-154b71205c74@gmail.com> <CADVnQy=Q9W=Vxu81ctPLx08D=ALnHBXGr0c4BLtQGxwQE+yjRg@mail.gmail.com>
 <ee5ef69e-ee3f-1df0-2033-5adc06a46b9c@gmail.com> <CADVnQynqMQhO4cBON=xUCkne9-E1hze3naMZZ8tQ-a0k71kh8g@mail.gmail.com>
 <205F52AB-4A5B-4953-B97E-17E7CACBBCD8@gmail.com> <CANn89iJbquZ=tVBRg7JNR8pB106UY4Xvi7zkPVn0Uov9sj8akg@mail.gmail.com>
 <1786BBEE-9C7B-45B2-B451-F535ABB804EF@gmail.com> <CANn89iK4Qwf0ezWac3Cn1xWN_Hw+-QL-+H8YmDm4cZP=FH+MTQ@mail.gmail.com>
In-Reply-To: <CANn89iK4Qwf0ezWac3Cn1xWN_Hw+-QL-+H8YmDm4cZP=FH+MTQ@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Tue, 29 Jun 2021 11:59:43 -0400
Message-ID: <CADVnQyk9maCc+tJ4-b6kufcBES9+Y2KpHPZadXssoVWX=Xr1Vw@mail.gmail.com>
Subject: Re: [PATCH] tcp: Do not reset the icsk_ca_initialized in tcp_init_transfer.
To:     Eric Dumazet <edumazet@google.com>
Cc:     Nguyen Dinh Phi <phind.uet@gmail.com>,
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

  On Tue, Jun 29, 2021 at 8:58 AM Eric Dumazet <edumazet@google.com> wrote:
> > Because the problem only happens with CDG, is adding check in its tcp_cdg_init() function Ok? And about  icsk_ca_initialized, Could I expect it to be 0 in CC's init functions?
>
> I think icsk_ca_initialized  lost its strong meaning when CDG was
> introduced (since this is the only CC allocating memory)
>
> The bug really is that before clearing icsk_ca_initialized we should
> call cc->release()
>
> Maybe we missed this cleanup in commit
> 8919a9b31eb4fb4c0a93e5fb350a626924302aa6 ("tcp: Only init congestion
> control if not initialized already")

From my perspective, the bug was introduced when that 8919a9b31eb4
commit introduced icsk_ca_initialized and set icsk_ca_initialized to 0
in tcp_init_transfer(), missing the possibility that a process could
call setsockopt(TCP_CONGESTION)  in state TCP_SYN_SENT (i.e. after the
connect() or TFO open sendmsg()), which would call
tcp_init_congestion_control(). The 8919a9b31eb4 commit did not intend
to reset any initialization that the user had already explicitly made;
it just missed the possibility of that particular sequence (which
syzkaller managed to find!).

> Although I am not sure what happens at accept() time when the listener
> socket is cloned.

It seems that for listener sockets, they cannot initialize their CC
module state, because there is no way for them to reach
tcp_init_congestion_control(), since:

(a) tcp_set_congestion_control() -> tcp_reinit_congestion_control()
will not call tcp_init_congestion_control() on a socket in CLOSE or
LISTEN

(b) tcp_init_transfer() -> tcp_init_congestion_control() can only
happen for established sockets and successful TFO SYN_RECV sockets

So it seems my previously suggested change (yesterday in this thread)
to add icsk_ca_initialized=0 in tcp_ca_openreq_child() is not needed.

> If we make any hypothesis, we need to check all CC modules to make
> sure they respect it.

AFAICT the fix is correct; it just needs a Fixes: tag and a more clear
description in the commit message.

I have cherry-picked the patch into our kernel and verified it passes
all of our internal packetdrill tests.

So the diff seems OK, but I would suggest a commit message something
like the following:

--
[PATCH] tcp: fix tcp_init_transfer() to not reset icsk_ca_initialized

This commit fixes a bug (found by syzkaller) that could cause spurious
double-initializations for congestion control modules, which could cause memory
leaks orother problems for congestion control modules (like CDG) that allocate
memory in their init functions.

The buggy scenario constructed by syzkaller was something like:

(1) create a TCP socket
(2) initiate a TFO connect via sendto()
(3) while socket is in TCP_SYN_SENT, call setsockopt(TCP_CONGESTION),
    which calls:
       tcp_set_congestion_control() ->
         tcp_reinit_congestion_control() ->
           tcp_init_congestion_control()
(4) receive ACK, connection is established, call tcp_init_transfer(),
    set icsk_ca_initialized=0 (without first calling cc->release()),
    call tcp_init_congestion_control() again.

Note that in this sequence tcp_init_congestion_control() is called twice
without a cc->release() call in between. Thus, for CC modules that allocate
memory in their init() function, e.g, CDG, a memory leak may occur. The
syzkaller tool managed to find a reproducer that triggered such a leak in CDG.

The bug was introduced when that 8919a9b31eb4 commit introduced
icsk_ca_initialized and set icsk_ca_initialized to 0 in tcp_init_transfer(),
missing the possibility for a sequence like the one above, where a process
could call setsockopt(TCP_CONGESTION) in state TCP_SYN_SENT (i.e. after the
connect() or TFO open sendmsg()), which would call
tcp_init_congestion_control(). The 8919a9b31eb4 commit did not intend to reset
any initialization that the user had already explicitly made; it just missed
the possibility of that particular sequence (which syzkaller managed to find).

Fixes: 8919a9b31eb4 ("tcp: Only init congestion control if not
initialized already")
Reported-by: syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
--

neal
