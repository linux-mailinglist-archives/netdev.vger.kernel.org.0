Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2A536CE64
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 00:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239285AbhD0WBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 18:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239543AbhD0WBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 18:01:11 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE51C06175F;
        Tue, 27 Apr 2021 15:00:25 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id x19so65600082lfa.2;
        Tue, 27 Apr 2021 15:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qVpZyC/iy3gZywSmjhcPhq3t4KIiewkiosuhWqnHkjg=;
        b=R4QYRj2+7YTdv7oQwieK/Q9iecxnfBo3J/r9Cfc6+qeZKPeQJKcDiS5jtg0UXvbXnV
         PIf/MED0050CNSHA6Y9vnTx+/+a5DN+VipUd1+6AIbQvwbzNROV7n8FvgVIeSrelQX74
         M2N7XgIW96AIXekpxFWlgwCwDEogMZ1Mn1Z0085gbzcsgc6XFgiUyvKkvSfAAZ0bBqff
         KqAkDogj/u5URiTqEa5RtSC3XFIMNL3wiRxs4Gtn7aZ9jqFtq9n9G5oyw7vbkEA5xK4i
         i0q/yhnhp8ewqFLZR8yQY4YJrHeur4+6xiGwRglq/aRr0lz/c4gQTLa9wOyf24QWWGrM
         vKPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qVpZyC/iy3gZywSmjhcPhq3t4KIiewkiosuhWqnHkjg=;
        b=a19YyHunCWBOotkm5L8qDymKs1hmkD/MqdVRq3SsIbDtI6UWAxtP0vnuic3PJymbN/
         /VJUZwlNVFmqD/KCJqiZIZxJLFYGwS3IsfP9PVEQUlrCyv3mR/72JPJ27f9o0wLDBP1w
         q++cqkVQyZiAT9PQOGaqhmMIjSnD7L2S5slwqWyqXclyE7QMh/7oN/deyJrrJHeZYd6M
         cMosSwn3o2GDF4u7WD53Keu+S5BIvOvXCmNU6QwIf4e1idqJidXbUKwcaCiGrMqFe2mr
         XuU93OtTW0rnm+M8gpIEKjISuPU7t9k7sH5PFW/NLjA29339mh27LKNmit144/JJP3/L
         6wPw==
X-Gm-Message-State: AOAM532kETToEc6FgkxB2J8QuyGsP7Gmf++icUDU+FyXXPixt/X9r54r
        Inw0k1+vvWlp0/rgJ5E2adVT4rEATc3h0qFNHCI=
X-Google-Smtp-Source: ABdhPJw4tg1NIO3miV4pq/BNBT6QON9KE5YZ/nE0tcYG9K/EPtCMcnm+5XX8S9934n6LJ1LeDK+29ouI2b9bgTClf00=
X-Received: by 2002:a05:6512:3c95:: with SMTP id h21mr11354181lfv.270.1619560824139;
 Tue, 27 Apr 2021 15:00:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210427034623.46528-1-kuniyu@amazon.co.jp> <CAHo-OowFTjZa8hiFEb9ECRuJCLchcb=CvMpPavoP4QcmS47OOQ@mail.gmail.com>
In-Reply-To: <CAHo-OowFTjZa8hiFEb9ECRuJCLchcb=CvMpPavoP4QcmS47OOQ@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 27 Apr 2021 15:00:12 -0700
Message-ID: <CAHo-Ooz252rnWZ=9k6nO0vjGKFkQDoaLxZ1jxiTomtckq9DbYA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 00/11] Socket migration for SO_REUSEPORT.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        BPF Mailing List <bpf@vger.kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 2:55 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
> On Mon, Apr 26, 2021 at 8:47 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> w=
rote:
> > The SO_REUSEPORT option allows sockets to listen on the same port and t=
o
> > accept connections evenly. However, there is a defect in the current
> > implementation [1]. When a SYN packet is received, the connection is ti=
ed
> > to a listening socket. Accordingly, when the listener is closed, in-fli=
ght
> > requests during the three-way handshake and child sockets in the accept
> > queue are dropped even if other listeners on the same port could accept
> > such connections.
> >
> > This situation can happen when various server management tools restart
> > server (such as nginx) processes. For instance, when we change nginx
> > configurations and restart it, it spins up new workers that respect the=
 new
> > configuration and closes all listeners on the old workers, resulting in=
 the
> > in-flight ACK of 3WHS is responded by RST.
>
> This is IMHO a userspace bug.
>
> You should never be closing or creating new SO_REUSEPORT sockets on a
> running server (listening port).
>
> There's at least 3 ways to accomplish this.
>
> One involves a shim parent process that takes care of creating the
> sockets (without close-on-exec),
> then fork-exec's the actual server process[es] (which will use the
> already opened listening fds),
> and can thus re-fork-exec a new child while using the same set of sockets=
.
> Here the old server can terminate before the new one starts.
>
> (one could even envision systemd being modified to support this...)
>
> The second involves the old running server fork-execing the new server
> and handing off the non-CLOEXEC sockets that way.

(this doesn't even need to be fork-exec -- can just be exec -- and is
potentially easier)

> The third approach involves unix fd passing of sockets to hand off the
> listening sockets from the old process/thread(s) to the new
> process/thread(s).  Once handed off the old server can stop accept'ing
> on the listening sockets and close them (the real copies are in the
> child), finish processing any still active connections (or time them

(this doesn't actually need to be a child, in can be an entirely new
parallel instance of the server,
potentially running in an entirely new container/cgroup setup, though
in the same network namespace)

> out) and terminate.
>
> Either way you're never creating new SO_REUSEPORT sockets (dup doesn't
> count), nor closing the final copy of a given socket.
>
> This is basically the same thing that was needed not to lose incoming
> connections in a pre-SO_REUSEPORT world.
> (no SO_REUSEADDR by itself doesn't prevent an incoming SYN from
> triggering a RST during the server restart, it just makes the window
> when RSTs happen shorter)
>
> This was from day one (I reported to Tom and worked with him on the
> very initial distribution function) envisioned to work like this,
> and we (Google) have always used it with unix fd handoff to support
> transparent restart.
