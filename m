Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6B12219D8
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 04:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgGPC0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 22:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgGPC0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 22:26:09 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B364C061755;
        Wed, 15 Jul 2020 19:26:09 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id u12so3699674qth.12;
        Wed, 15 Jul 2020 19:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kjvl6rFGkk9g9nxLnI4XOxymN+I5ew8fyR92hePQTR8=;
        b=RXhiyNA+0OxuYMJrEw6B4uGMnNcX7+7QCTKEolilVr/e7wNWbkdscev14WHOSBHMkt
         6MNk7uijNpKfxlkO6sxTwJwsqQOUcKyNXo7jxPjTTPj30mPid5CnkP/sA3vm5okmcOUq
         KXhLNu6q/AC6Ei4wbhtkoAK+LCR1I6dQg89PErMgAuuI+q6XbZ3tBQS9/eCt46N3bGgZ
         PrS/YR9CIQB3fP0mcxcrJ2xiUs3WQyGJOO4YG6lSte4ZZvk9tOohxGuNxK69mYQGNkJC
         ioMd1gdc3jXsg+wRyltMEqfBnqduVS5YmK7w+/dk5pbtPQnlKkCjvMa3WNvDpf9D5dbF
         2BbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kjvl6rFGkk9g9nxLnI4XOxymN+I5ew8fyR92hePQTR8=;
        b=U5823ZZH9PmHvPlkvXdklNK3IJANsNdUFB2eJcgq3PWrbuu35jAGUJioBTt5DKHhx/
         9+8dJRpbItOzN4166wtiYDMBs+MPiraAcj80HNx8cWE/5awI213trXrO1xi0UkMS63EK
         JIwAUOuVps53+aZ709m5R5yPv3kFyL2AB/W9QcWiqFD3w5Jj9eXJzb4Jfd6ZqNvsJm3E
         zFDOlXI4vGLx8rp0NG4s1fVefIJidrGnwg2LYFtcYSjuaXaBMCZlRrsOsz8ENUMP+Ahm
         3zkv3M8q1u7OzJWioigh5+x7LePbCxiRAirp8pLUGcgjlJvCvxmhzEumoXu6tCVvHLe5
         L0/Q==
X-Gm-Message-State: AOAM531zfVkWggDfrp7gUQkpZRQcarbqbQWYgqNIjQzeOyJfKfAfgGfl
        gjT+uQ+dTe90o+AI8TDxZL61nblxCUbA1Vq9LmY=
X-Google-Smtp-Source: ABdhPJznZEqer5Ex/ztjd1B3AG7F9PlzYwNkP8ocA82vubjoB2jHvw544ilqCfscT4rqGe3aDS2ypdRUjkyEPlT3KJ0=
X-Received: by 2002:ac8:1991:: with SMTP id u17mr2828869qtj.93.1594866368439;
 Wed, 15 Jul 2020 19:26:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200713174654.642628-1-jakub@cloudflare.com>
In-Reply-To: <20200713174654.642628-1-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jul 2020 19:25:57 -0700
Message-ID: <CAEf4Bza0o1km866baqy5DErZGR_BbHrjGX+AP7+p4V-nSrN7bQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 00/16] Run a BPF program on socket lookup
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 10:47 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Dependencies
> ============
>
> This patch series depends on:
>
> 1. 'bpf-multi-prog-prep' series in 'bpf' [0]
>    (commit 951f38cf0835 ("Merge branch 'bpf-multi-prog-prep'"))
> 2. "bpf: Shift and mask loads narrower than context field size" patch
>    https://lore.kernel.org/bpf/20200710173123.427983-1-jakub@cloudflare.com/
>

[...]

>
> Overview
> ========
>
> This series proposes a new BPF program type named BPF_PROG_TYPE_SK_LOOKUP,
> or BPF sk_lookup for short.
>
> BPF sk_lookup program runs when transport layer is looking up a listening
> socket for a new connection request (TCP), or when looking up an
> unconnected socket for a packet (UDP).
>
> This serves as a mechanism to overcome the limits of what bind() API allows
> to express. Two use-cases driving this work are:
>
>  (1) steer packets destined to an IP range, fixed port to a single socket
>
>      192.0.2.0/24, port 80 -> NGINX socket
>
>  (2) steer packets destined to an IP address, any port to a single socket
>
>      198.51.100.1, any port -> L7 proxy socket
>
> In its context, program receives information about the packet that
> triggered the socket lookup. Namely IP version, L4 protocol identifier, and
> address 4-tuple.
>
> To select a socket BPF program fetches it from a map holding socket
> references, like SOCKMAP or SOCKHASH, calls bpf_sk_assign(ctx, sk, ...)
> helper to record the selection, and returns SK_PASS code. Transport layer
> then uses the selected socket as a result of socket lookup.
>
> Alternatively, program can also fail the lookup (SK_DROP), or let the
> lookup continue as usual (SK_PASS without selecting a socket).
>
> This lets the user match packets with listening (TCP) or receiving (UDP)
> sockets freely at the last possible point on the receive path, where we
> know that packets are destined for local delivery after undergoing
> policing, filtering, and routing.
>
> Program is attached to a network namespace, similar to BPF flow_dissector.
> We add a new attach type, BPF_SK_LOOKUP, for this. Multiple programs can be
> attached at the same time, in which case their return values are aggregated
> according the rules outlined in patch #4 description.
>
> Series structure
> ================
>
> Patches are organized as so:
>
>  1: enables multiple link-based prog attachments for bpf-netns
>  2: introduces sk_lookup program type
>  3-4: hook up the program to run on ipv4/tcp socket lookup
>  5-6: hook up the program to run on ipv6/tcp socket lookup
>  7-8: hook up the program to run on ipv4/udp socket lookup
>  9-10: hook up the program to run on ipv6/udp socket lookup
>  11-13: libbpf & bpftool support for sk_lookup
>  14-16: verifier and selftests for sk_lookup
>
> Patches are also available on GH:
>
>   https://github.com/jsitnicki/linux/commits/bpf-inet-lookup-v4
>
> Follow-up work
> ==============
>
> I'll follow up with below items, which IMHO don't block the review:
>
> - benchmark results for udp6 small packet flood scenario,
> - user docs for new BPF prog type, Documentation/bpf/prog_sk_lookup.rst,
> - timeout for accept() in tests after extending network_helper.[ch].
>

Looks good to me overall. I've looked through networking-specific code
and didn't spot anything, but I might be missing some subtleties,
hopefully not, though.

I left a few suggestions, please take a look, and if they make sense,
apply them in the follow up(s). Thanks!

For the series:

Acked-by: Andrii Nakryiko <andriin@fb.com>

> Thanks to the reviewers for their feedback to this patch series:
>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: Marek Majkowski <marek@cloudflare.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
>
> -jkbs
>

[...]
