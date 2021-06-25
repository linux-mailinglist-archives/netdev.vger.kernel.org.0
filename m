Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C353B3A13
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 02:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbhFYAQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 20:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhFYAQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 20:16:18 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8242BC061574;
        Thu, 24 Jun 2021 17:13:57 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id h15so13249853lfv.12;
        Thu, 24 Jun 2021 17:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y7tPKPvRNk7wzvHDimxSf6Hb5LyFrU2QdlsP0vbUrqg=;
        b=Skb/DiI9n9rky1ySpHofEY98q3c8i52bkZjSf0+qsIwAp2xJyvcvh4qCu4X554l1Q3
         jtEH0XIWjzR7ijgQK3IyGRPNrxNoqPtQV3UpZcG5I8OQKSSEStZSB1V/r++0Qt52egyQ
         GvZZca+++ho4tthUN3i7tV4Nw6jX5MM4IO6bqlQL3Jnk3CTpqqw3Ef/S0yODaxWQT6nU
         Js2m9gop+93Liq5X1dwOFpTsR3DLsx9YDERAoqpwmV21kQdAdgp5X6Slq44ZxJSrXZj/
         jRUgHoC1HEhOpkCCEBhxnuMlMp4Kdad5Ht7SRSN3AxCQ9JWTsdXy9lHBjhGeiYpWhjat
         DyqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y7tPKPvRNk7wzvHDimxSf6Hb5LyFrU2QdlsP0vbUrqg=;
        b=a0SjPswoJ0Rr0sbn5XNqf5DRC6kdfwgLZWE/wsKnlyM5jJg6oZj0HTFCdOAPEIARKp
         XPE+op3DS9IxGZoxgTw6+b6P2d1rLrlOmK0tM70yD3ypl1qCPU0Tp6neAc7Hr7e4S70K
         gBiDZKrvixC/wAqzNn5S2RjpVr0LpGLiwMt6vgnX5vgoWK64o7dV1F3M1THzAlpPqvwa
         68E95Hk1bFXfKp8RCX3o4qeajsMxDii2pDcpRgC1AHHbaPotuqPygAshOL2WG6IHQwD+
         WynK6SZMA3XaSyw0bFNEm4mYizmiBh7alLNjqUWAetI0Pa5tCIBlM0NT1er/++OKrZpT
         Zirw==
X-Gm-Message-State: AOAM533Hc3AGmUW9DYGjaA8mA4nE5elqSBbbFTfp942qBqIJmSB3lZ0L
        oMCy3rtl0iksTokO349cZm9A5+IkCzdfzRowve8=
X-Google-Smtp-Source: ABdhPJy0sAOhx8ZiWu5Mj2RkaPOW9KoA7w6HvdYF1993awXMvcQm0estIa+hJDIacn1Jup6Gh6uAuyLH+Pw+VxH71Ro=
X-Received: by 2002:a05:6512:b8d:: with SMTP id b13mr5698867lfv.524.1624580035808;
 Thu, 24 Jun 2021 17:13:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210618105526.265003-1-zenczykowski@gmail.com> <CACAyw9-UnQODTf+=xEmexpWE6zhYUQfp7go76bEEc_A1rAyd7Q@mail.gmail.com>
In-Reply-To: <CACAyw9-UnQODTf+=xEmexpWE6zhYUQfp7go76bEEc_A1rAyd7Q@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Thu, 24 Jun 2021 17:13:44 -0700
Message-ID: <CAHo-OoyxD=4gYvnrYPwJ_Lyb-JoR6n2Ehvrq6jKoQbmP5JJdpA@mail.gmail.com>
Subject: Re: [PATCH bpf] Revert "bpf: program: Refuse non-O_RDWR flags in BPF_OBJ_GET"
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Greg Kroah-Hartman <gregkh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reposting since apparently my reply only went to Lorenz.

On Wed, Jun 23, 2021 at 1:45 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Fri, 18 Jun 2021 at 11:55, Maciej =C5=BBenczykowski
> <zenczykowski@gmail.com> wrote:
> >
> > From: Maciej =C5=BBenczykowski <maze@google.com>
> >
> > This reverts commit d37300ed182131f1757895a62e556332857417e5.
> >
> > This breaks Android userspace which expects to be able to
> > fetch programs with just read permissions.
> >
> > See: https://cs.android.com/android/platform/superproject/+/master:fram=
eworks/libs/net/common/native/bpf_syscall_wrappers/include/BpfSyscallWrappe=
rs.h;drc=3D7005c764be23d31fa1d69e826b4a2f6689a8c81e;l=3D124
>
> As a follow up, what does Android expect to be able to do with this
> read only FD?

I'm not actually sure of all the use cases, but at a bare minimum:
We use it for iptables xt_bpf, and to attach to cgroup net hooks and
tc bpf hooks.
There's also some still incomplete support for xdp.
There's also non-networking stuff like gpu memory tracking and
tracepoints that I know very little about - probably something perf
related.
So I think the answer is that mostly we expect to be able to attach it
to places (iptables/cgroup/tc/xdp/....others...??)
