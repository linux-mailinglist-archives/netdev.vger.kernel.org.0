Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012423A0802
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhFHXvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:51:20 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:51196 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbhFHXvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 19:51:19 -0400
Received: by mail-wm1-f44.google.com with SMTP id d184so2931751wmd.0
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 16:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VJEJmU3TjmWlHd5escotygrK9mEkeGOFmkbOO7Ovndk=;
        b=YJiasMX/CSgvQzJSOSl14nv9P5TK7AT6YV9pmU8EH9rdtrRt8OTdmrI0NRex/lZ4B3
         tw5jpIjOdrfz0Lf4CO4KKNqNUyKyRLYQPnsFAYoXc+zQpkNR2AeoQbWSBP+xwGKP/QVF
         /zVM8QApNaAxXy+38+veFgarBWAfhIgrVV3Iz1zqUg44v+I563jNatKE1z6MRg5/13H3
         acGkpl1lv7G6PuHIw5hBjs+zdtaQyX1nlOZkrRIoPeyAfe01Pyo2JKv0zGcNeZJ85OCq
         wTpiIrfkJ08HgrHEtMUlX4gNtrUZo9Q9CrWQPGedm8vhMZvoq9hPaG0kHDtZeuftdnMM
         zHNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VJEJmU3TjmWlHd5escotygrK9mEkeGOFmkbOO7Ovndk=;
        b=gSK38mbkV2HvzynizkmZYQUcWAU44ZnKmm1392Q4UnbojOzsmlGSDjwDjEnVXv5KNk
         Lk/jiKvSs+aP57l8PryynheRffAxsIqI0so2EmZ/UobmoTIBMtEc8VyDKoTFHBI+M2+z
         qwhDCVV1YDX9M0NZiDhPW14HPYmtSU0I/AfwLaDTdUKGUTKxXc/278RhJXhR+XNJsnnd
         YVIrka+DUuPAxv5yqOnA54q47h29D92ZfAxixofABjzDhTq7iLk/qV9E6OIu0vakx2Pf
         0JdhhPFSU1YXhdrWRvy0fmzhYlJ+cVB4oZNETvpyON0oOORlB3XHDD4/o2bjVItjYKjA
         K2ow==
X-Gm-Message-State: AOAM5307uUjjgrEGnTdxAJf9NpnG9L41y8lJ6cy2u6KbIOvs8JxVyU2d
        mlUREqxKIcY4ubRrMpbLCqLzfge/PQ98CTzu1JCI7g==
X-Google-Smtp-Source: ABdhPJxtSj8CrY3NelQWe6b5UnM5Ga7yZY4pH7uh1uTA6qjLNwx8jgOI4pNVdk0pJ62BFT6Acu9ivXZlxt/FQIJWVc4=
X-Received: by 2002:a1c:7210:: with SMTP id n16mr6659744wmc.75.1623196094967;
 Tue, 08 Jun 2021 16:48:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAK6E8=dtFmPYpK71XJc=HFDUL9mYO1i36Q8BemwSGcCq+3BEmw@mail.gmail.com>
 <20210608230357.39528-1-kuniyu@amazon.co.jp>
In-Reply-To: <20210608230357.39528-1-kuniyu@amazon.co.jp>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Tue, 8 Jun 2021 16:47:37 -0700
Message-ID: <CAK6E8=cgFKuGecTzSCSQ8z3YJ_163C0uwO9yRvfDSE7vOe9mJA@mail.gmail.com>
Subject: Re: [PATCH v7 bpf-next 00/11] Socket migration for SO_REUSEPORT.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 8, 2021 at 4:04 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> From:   Yuchung Cheng <ycheng@google.com>
> Date:   Tue, 8 Jun 2021 10:48:06 -0700
> > On Tue, May 25, 2021 at 11:42 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> > > > The SO_REUSEPORT option allows sockets to listen on the same port and to
> > > > accept connections evenly. However, there is a defect in the current
> > > > implementation [1]. When a SYN packet is received, the connection is tied
> > > > to a listening socket. Accordingly, when the listener is closed, in-flight
> > > > requests during the three-way handshake and child sockets in the accept
> > > > queue are dropped even if other listeners on the same port could accept
> > > > such connections.
> > > >
> > > > This situation can happen when various server management tools restart
> > > > server (such as nginx) processes. For instance, when we change nginx
> > > > configurations and restart it, it spins up new workers that respect the new
> > > > configuration and closes all listeners on the old workers, resulting in the
> > > > in-flight ACK of 3WHS is responded by RST.
> > > >
> > > > To avoid such a situation, users have to know deeply how the kernel handles
> > > > SYN packets and implement connection draining by eBPF [2]:
> > > >
> > > >    1. Stop routing SYN packets to the listener by eBPF.
> > > >    2. Wait for all timers to expire to complete requests
> > > >    3. Accept connections until EAGAIN, then close the listener.
> > > >
> > > >    or
> > > >
> > > >    1. Start counting SYN packets and accept syscalls using the eBPF map.
> > > >    2. Stop routing SYN packets.
> > > >    3. Accept connections up to the count, then close the listener.
> > > >
> > > > In either way, we cannot close a listener immediately. However, ideally,
> > > > the application need not drain the not yet accepted sockets because 3WHS
> > > > and tying a connection to a listener are just the kernel behaviour. The
> > > > root cause is within the kernel, so the issue should be addressed in kernel
> > > > space and should not be visible to user space. This patchset fixes it so
> > > > that users need not take care of kernel implementation and connection
> > > > draining. With this patchset, the kernel redistributes requests and
> > > > connections from a listener to the others in the same reuseport group
> > > > at/after close or shutdown syscalls.
> > > >
> > > > Although some software does connection draining, there are still merits in
> > > > migration. For some security reasons, such as replacing TLS certificates,
> > > > we may want to apply new settings as soon as possible and/or we may not be
> > > > able to wait for connection draining. The sockets in the accept queue have
> > > > not started application sessions yet. So, if we do not drain such sockets,
> > > > they can be handled by the newer listeners and could have a longer
> > > > lifetime. It is difficult to drain all connections in every case, but we
> > > > can decrease such aborted connections by migration. In that sense,
> > > > migration is always better than draining.
> > > >
> > > > Moreover, auto-migration simplifies user space logic and also works well in
> > > > a case where we cannot modify and build a server program to implement the
> > > > workaround.
> > > >
> > > > Note that the source and destination listeners MUST have the same settings
> > > > at the socket API level; otherwise, applications may face inconsistency and
> > > > cause errors. In such a case, we have to use the eBPF program to select a
> > > > specific listener or to cancel migration.
> > This looks to be a useful feature. What happens to migrating a
> > passively fast-opened socket in the old listener but it has not yet
> > been accepted (TFO is both a mini-socket and a full-socket)?
> > It gets tricky when the old and new listener have different TFO key
>
> The tricky situation can happen without this patch set. We can change
> the listener's TFO key when TCP_SYN_RECV sockets are still in the accept
> queue. The change is already handled properly, so it does not crash
> applications.
>
> In the normal 3WHS case, a full-socket is created after 3WHS. In the TFO
> case, a full-socket is created after validating the TFO cookie in the
> initial SYN packet.
>
> After that, the connection is basically handled via the full-socket, except
> for accept() syscall. So in the both cases, the mini-socket is poped out of
> old listener's queue, cloned, and put into the new listner's queue. Then we
> can accept() its full-socket via the cloned mini-socket.

Thanks, that makes sense. Eric is the expert in this part to review
the correctness. My only suggestion is to add some stats tracking the
mini-sockets that fail to migrate due to a variety of reasons (the
code locations that the requests need to be dropped). This can be
useful to evaluate the effectiveness of this new feature.
