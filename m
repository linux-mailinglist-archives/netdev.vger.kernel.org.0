Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B742039ECCE
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhFHDQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhFHDQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 23:16:01 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BBAC061574;
        Mon,  7 Jun 2021 20:13:54 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id m21so13990437lfg.13;
        Mon, 07 Jun 2021 20:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b71LtaSQOEalI7Wb6oIYULiHeLXln/VVhWK4vkhKUmc=;
        b=fT/nwBiGE67zpjQxpY9UxGqZT9b+/lWmhFrMT2AqKDfY/qLlTS89yISQUnLyMASJeA
         IZf4K0h0H9num9H0Z7yWthhJ/MlusWb8yOZDWpWkWM47jSRBnqbz+GWBM/SqP1Ii2g9I
         XMr2k1CiodjH0GzVzh6+KdKoFIQXhvQBfijxkN6EIxgY3REQWUwDQxyouf4PBjGQSr20
         CG49Iv2+EwypG3GRuvVPbb/ywzTCnu9pgJ/eqluqRA3h1Fd5LmJa/gLsUyltxv2o3MYt
         bn0EexDXcWFanzbiIctSfpAXdj9jILw265jSGLtMPjusMvzuvOy6icxJxkRfu5hCuHef
         8Tng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b71LtaSQOEalI7Wb6oIYULiHeLXln/VVhWK4vkhKUmc=;
        b=V5rK63IQ0RCDNCtJx9BKXZC4hC+tip7ssUQisy4J8QUt4Nggthz9bGxRz6NIeO9e2e
         He/9Ob/882+SykbbX7arJCFXsxPuxkQzjIEjG9ufterorav/TgX4qr6yFMPHfnS+cP0V
         o+f5ufyBYUbwsqVe2x7FMOvQvSqyG3xQEHh5HtFhSjVgkAWCjpttogSZKrtjpqwI/0Gt
         H+BCz5DGEHJFI2Bh/dPZd65ISeKMGUvhY/ugcvlHQJQOJb8ZrJ8PRePoUtDuVd4ZpEBS
         dXeK7ngCW/nWa0KUOvSwdr97oiQmFgICVFrDGzB8xaagBplvZI2SK6fUr+jtaX+scZRQ
         ecGQ==
X-Gm-Message-State: AOAM530uzIvkdQ0aSIBjvtzDdp5iJGXioBVUDg74//GnX1mlRu5ZKO42
        iiVwaChjI41hBHaGjNGps9tJgQP5R3i9WwdO9Hk=
X-Google-Smtp-Source: ABdhPJxBFASWnHLu4/DydbhtQFlH0qnVY3yYAKNLdfEArnLeowEF3WxjaeKW25A/4KAob5s02n/n9XA9VwTJL8OpIOs=
X-Received: by 2002:a05:6512:2010:: with SMTP id a16mr11344288lfb.38.1623122032820;
 Mon, 07 Jun 2021 20:13:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210521182104.18273-1-kuniyu@amazon.co.jp> <c423bd7b-03ab-91f2-60af-25c6dfa28b71@iogearbox.net>
In-Reply-To: <c423bd7b-03ab-91f2-60af-25c6dfa28b71@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 7 Jun 2021 20:13:41 -0700
Message-ID: <CAADnVQJ5wwLoQXegWK6c2vCnLx-J32ZUFAHGouP2HwKNJkU8zg@mail.gmail.com>
Subject: Re: [PATCH v7 bpf-next 00/11] Socket migration for SO_REUSEPORT.
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 11:42 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> > The SO_REUSEPORT option allows sockets to listen on the same port and to
> > accept connections evenly. However, there is a defect in the current
> > implementation [1]. When a SYN packet is received, the connection is tied
> > to a listening socket. Accordingly, when the listener is closed, in-flight
> > requests during the three-way handshake and child sockets in the accept
> > queue are dropped even if other listeners on the same port could accept
> > such connections.
> >
> > This situation can happen when various server management tools restart
> > server (such as nginx) processes. For instance, when we change nginx
> > configurations and restart it, it spins up new workers that respect the new
> > configuration and closes all listeners on the old workers, resulting in the
> > in-flight ACK of 3WHS is responded by RST.
> >
> > To avoid such a situation, users have to know deeply how the kernel handles
> > SYN packets and implement connection draining by eBPF [2]:
> >
> >    1. Stop routing SYN packets to the listener by eBPF.
> >    2. Wait for all timers to expire to complete requests
> >    3. Accept connections until EAGAIN, then close the listener.
> >
> >    or
> >
> >    1. Start counting SYN packets and accept syscalls using the eBPF map.
> >    2. Stop routing SYN packets.
> >    3. Accept connections up to the count, then close the listener.
> >
> > In either way, we cannot close a listener immediately. However, ideally,
> > the application need not drain the not yet accepted sockets because 3WHS
> > and tying a connection to a listener are just the kernel behaviour. The
> > root cause is within the kernel, so the issue should be addressed in kernel
> > space and should not be visible to user space. This patchset fixes it so
> > that users need not take care of kernel implementation and connection
> > draining. With this patchset, the kernel redistributes requests and
> > connections from a listener to the others in the same reuseport group
> > at/after close or shutdown syscalls.
> >
> > Although some software does connection draining, there are still merits in
> > migration. For some security reasons, such as replacing TLS certificates,
> > we may want to apply new settings as soon as possible and/or we may not be
> > able to wait for connection draining. The sockets in the accept queue have
> > not started application sessions yet. So, if we do not drain such sockets,
> > they can be handled by the newer listeners and could have a longer
> > lifetime. It is difficult to drain all connections in every case, but we
> > can decrease such aborted connections by migration. In that sense,
> > migration is always better than draining.
> >
> > Moreover, auto-migration simplifies user space logic and also works well in
> > a case where we cannot modify and build a server program to implement the
> > workaround.
> >
> > Note that the source and destination listeners MUST have the same settings
> > at the socket API level; otherwise, applications may face inconsistency and
> > cause errors. In such a case, we have to use the eBPF program to select a
> > specific listener or to cancel migration.
> >
> > Special thanks to Martin KaFai Lau for bouncing ideas and exchanging code
> > snippets along the way.
> >
> >
> > Link:
> >   [1] The SO_REUSEPORT socket option
> >   https://lwn.net/Articles/542629/
> >
> >   [2] Re: [PATCH 1/1] net: Add SO_REUSEPORT_LISTEN_OFF socket option as drain mode
> >   https://lore.kernel.org/netdev/1458828813.10868.65.camel@edumazet-glaptop3.roam.corp.google.com/
>
> This series needs review/ACKs from TCP maintainers. Eric/Neal/Yuchung please take
> a look again.

Eric,

I've looked through bpf and tcp changes and they don't look scary at all.
I think the feature is useful and a bit of extra complexity is worth it.
So please review tcp bits to make sure we didn't miss anything.

Thanks!
