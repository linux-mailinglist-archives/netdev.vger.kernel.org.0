Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D68536CE01
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbhD0V43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbhD0V43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 17:56:29 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE03C061574;
        Tue, 27 Apr 2021 14:55:45 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id n138so96093940lfa.3;
        Tue, 27 Apr 2021 14:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3CGUbJegsHJUSe5Nc4E44D2BPZYrUahyNp0cHa9OA5s=;
        b=OTtwu9m/KCIX81TcNNET1YkRFHJSl06WC3wlij3hpe76YNQVyb+W7XTonmajLIFKu2
         qeP3UCmFxDAwP0E+8Y3Jp9r+x/bCGNg/C89/QYW26LieU2N7mZtVZRWbIdZdVpb2ly2a
         jOschFyNpcSwC29/GYQRtafgH2tdhXsB1lCDDKte35Imcewrnfz+NOJgmdLgRvMXVBFq
         RCJVa+zuEPX5kQqRhZzrxKm6gkpxrlaMov5SLlPQuRHVeC00vzxnMAY9K0xOTlDeBW7R
         sXYSuP3aRw/foQoCMpJPatLBV7udmkD78Vzdh7vKBpLSk/vMc25IkLd+cCRxpDt/apMy
         Bxpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3CGUbJegsHJUSe5Nc4E44D2BPZYrUahyNp0cHa9OA5s=;
        b=Sfw7Xew/a6THct/w+kLUvCpEJZqeKWoTjvvIRiej9LJTe+gHkfhK8AVhWXIjsJfqy0
         IdKNqlVq9Duyq6+5IRT9m3IlDPC4WEtLl4sQ31spLEfkXs4PHpgDWgE70Pr7fpLI1gkH
         Z6grMEh1eTaSlmIbpSFrdybkLu4MQUZRO2Q80uequ2MU0K/132Yk5xxJTRV78w7/92Wj
         UK6CqbBFmClrCr8vdwc6JOBSTK5nFFGHNF1hz8lLwpPlm7XoIERUk+KTXJUfC/pV4FZo
         zO7T5fb2+MRe10B0J6PHKeQ+xGLBej0gfCsEOfV/cITifIr770UroAqnRFBbE7xsZbRD
         7lcw==
X-Gm-Message-State: AOAM533hD06LodfDS4D/+HCAyL1dQHwNE3lK0JuRKtknHDM14c5ct48G
        3tX3g0bBKZod+uMlmvmGUZTOxyh/rqDd437gh3g=
X-Google-Smtp-Source: ABdhPJwQPB7779x9oFADzbtMBQvA6JyhIHy10R//1p3hh0Zj3aPmpAdBtmRH5hwnr6ihVer8uxvdpKvD0O3PNhbi7zs=
X-Received: by 2002:a05:6512:2296:: with SMTP id f22mr17413780lfu.161.1619560543660;
 Tue, 27 Apr 2021 14:55:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210427034623.46528-1-kuniyu@amazon.co.jp>
In-Reply-To: <20210427034623.46528-1-kuniyu@amazon.co.jp>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 27 Apr 2021 14:55:32 -0700
Message-ID: <CAHo-OowFTjZa8hiFEb9ECRuJCLchcb=CvMpPavoP4QcmS47OOQ@mail.gmail.com>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 8:47 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> The SO_REUSEPORT option allows sockets to listen on the same port and to
> accept connections evenly. However, there is a defect in the current
> implementation [1]. When a SYN packet is received, the connection is tied
> to a listening socket. Accordingly, when the listener is closed, in-flight
> requests during the three-way handshake and child sockets in the accept
> queue are dropped even if other listeners on the same port could accept
> such connections.
>
> This situation can happen when various server management tools restart
> server (such as nginx) processes. For instance, when we change nginx
> configurations and restart it, it spins up new workers that respect the new
> configuration and closes all listeners on the old workers, resulting in the
> in-flight ACK of 3WHS is responded by RST.

This is IMHO a userspace bug.

You should never be closing or creating new SO_REUSEPORT sockets on a
running server (listening port).

There's at least 3 ways to accomplish this.

One involves a shim parent process that takes care of creating the
sockets (without close-on-exec),
then fork-exec's the actual server process[es] (which will use the
already opened listening fds),
and can thus re-fork-exec a new child while using the same set of sockets.
Here the old server can terminate before the new one starts.

(one could even envision systemd being modified to support this...)

The second involves the old running server fork-execing the new server
and handing off the non-CLOEXEC sockets that way.

The third approach involves unix fd passing of sockets to hand off the
listening sockets from the old process/thread(s) to the new
process/thread(s).  Once handed off the old server can stop accept'ing
on the listening sockets and close them (the real copies are in the
child), finish processing any still active connections (or time them
out) and terminate.

Either way you're never creating new SO_REUSEPORT sockets (dup doesn't
count), nor closing the final copy of a given socket.

This is basically the same thing that was needed not to lose incoming
connections in a pre-SO_REUSEPORT world.
(no SO_REUSEADDR by itself doesn't prevent an incoming SYN from
triggering a RST during the server restart, it just makes the window
when RSTs happen shorter)

This was from day one (I reported to Tom and worked with him on the
very initial distribution function) envisioned to work like this,
and we (Google) have always used it with unix fd handoff to support
transparent restart.
