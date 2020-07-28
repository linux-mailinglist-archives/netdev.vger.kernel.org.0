Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61731231272
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbgG1TU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732779AbgG1TU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 15:20:27 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06084C0619D4
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 12:20:26 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id x69so19851997qkb.1
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 12:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zhyOzytz6iJSScUYu7jEGkkpCqwNaUVgSQu0xrNp9O8=;
        b=A8Y+6VAPvuWH+aIlo7T3reqOGaenGbVa5TK25EuR+Xv8cQA/Fff1cSJaDMvvqB4Zi3
         2raGYmVfetxeXvomin6cxUkH060tGnbMVCoJVDjRmkcX8PakwJYXsab/ORt/RVFf7c9x
         YUAvlGkCqNSMpV5UT9aE4MJOi/o35qDqDgii1ZoDhaZVro4ct21uS0xsddH2mk6durIz
         jvVrDkIpQVjt0ByuCT10Ac5uRTwpCWdRELWiD3rds3NZ5SMhcEg+cFv6cmjvFu4DSZ/X
         1NyyXN9YqNFdsR5bWOoSHY2KmE9r1+UYAhWRkewTDKX1D4P5NqIgcQry8zksYeG9t0Ng
         mXvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zhyOzytz6iJSScUYu7jEGkkpCqwNaUVgSQu0xrNp9O8=;
        b=Ce+deEHYVLw5/rTqVsZZnRx397x2DjcPwbLfREN58irqOGLfgEEnLw3S0/cM1lpVYk
         nsC4bXmo/xlAaHn1/qHDhzgfQzDQoRQLjdxoW1Ly1iFhS0ds5x11/OJS3CYaklugUPcE
         zWO3vl7Hf1A4Iifr5vJzW12lS+HjCXHKq6v7b1DxO7dLMHQxXnc6hsvDrDpBSS1R3COu
         LQdNVFeMoSZvwPryW9QGaoCnW0rlThEZYHlaKs3MAytXAQste0Rnq4xO9k7OgBCBQ7fs
         hFodO6T17MasdMe1PocWONSaAHljsVY6XKsxfYTXflKCFqSGbTQq10h76KORurfIQUDA
         +Y5g==
X-Gm-Message-State: AOAM530JLBPrS4R/zmMnfJl+tebn7glY+42q2LPXu6MY194HhFLSjBV4
        4XsArdcYzgTe+rXisnCidCNeAH0c
X-Google-Smtp-Source: ABdhPJzM/zYMt8nbSF9ycNiSr96XmEC8WJLRSjk5e19z9rLQ7YLrQP9x6IrjnNQyBz+cOlITYNbLnQ==
X-Received: by 2002:a37:9e90:: with SMTP id h138mr21595184qke.176.1595964024989;
        Tue, 28 Jul 2020 12:20:24 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id r18sm19007217qtf.62.2020.07.28.12.20.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 12:20:23 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id 2so11187878ybr.13
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 12:20:23 -0700 (PDT)
X-Received: by 2002:a25:7453:: with SMTP id p80mr32423482ybc.441.1595964022809;
 Tue, 28 Jul 2020 12:20:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200726120228.1414348-1-jakub@cloudflare.com>
 <20200728012042.r3gkkeg6ib3r2diy@kafai-mbp> <87pn8fwskq.fsf@cloudflare.com>
 <20200728163758.2thfltlhsn2nse57@kafai-mbp> <87o8nzwnsy.fsf@cloudflare.com>
In-Reply-To: <87o8nzwnsy.fsf@cloudflare.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 28 Jul 2020 15:19:47 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfYRL18V7QCg+TXKp8gEcLP6S-jAYpO5HATQW+8Uv4Hhg@mail.gmail.com>
Message-ID: <CA+FuTSfYRL18V7QCg+TXKp8gEcLP6S-jAYpO5HATQW+8Uv4Hhg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] udp, bpf: Ignore connections in reuseport group
 after BPF sk lookup
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> >> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> >> >> index c394e674f486..29d9691359b9 100644
> >> >> --- a/net/ipv6/udp.c
> >> >> +++ b/net/ipv6/udp.c
> >> >> @@ -208,7 +208,7 @@ static inline struct sock *udp6_lookup_run_bpf(struct net *net,
> >> >>           return sk;
> >> >>
> >> >>   reuse_sk = lookup_reuseport(net, sk, skb, saddr, sport, daddr, hnum);
> >> >> - if (reuse_sk && !reuseport_has_conns(sk, false))
> >> >> + if (reuse_sk)
> >> > From __udp[46]_lib_lookup,
> >> > 1. The connected udp is picked by the kernel first.
> >> >    If a 4-tuple-matched connected udp is found.  It should have already
> >> >    been returned there.
> >> >
> >> > 2. If kernel cannot find a connected udp, the sk-lookup bpf prog can
> >> >    get a chance to pick another socket (likely bound to a different
> >> >    IP/PORT that the packet is destinated to) by bpf_sk_lookup_assign().
> >> >    However, bpf_sk_lookup_assign() does not allow TCP_ESTABLISHED.
> >> >
> >> >    With the change in this patch, it then allows the reuseport-bpf-prog
> >> >    to pick a connected udp which cannot be found in step (1).  Can you
> >> >    explain a use case for this?
> >>
> >> It is not intentional. It should not allow reuseport to pick a connected
> >> udp socket to be consistent with what sk-lookup prog can select. Thanks
> >> for pointing it out.
> >>
> >> I've incorrectly assumed that after acdcecc61285 ("udp: correct
> >> reuseport selection with connected sockets") reuseport returns only
> >> unconnected udp sockets, but thats not true for bpf reuseport.
> >>
> >> So this patch fixes one corner base, but breaks another one.
> >>
> >> I'll change the check to the below and respin:
> >>
> >> -    if (reuse_sk && !reuseport_has_conns(sk, false))
> >> +    if (reuse_sk && reuse_sk->sk_state != TCP_ESTABLISHED)
> > May be disallow TCP_ESTABLISHED in bpf_sk_select_reuseport() instead
> > so that the bpf reuseport prog can have a more consistent
> > behavior among sk-lookup and the regular sk-reuseport-select case.
> > Thought?
>
> Ah, I see now what you had in mind. If that option is on the table, I'm
> all for it. Being consistent makes it easier to explain and use.
>
> In that case, let me make that change in a separate submission. I want
> to get test coverage in for the three reuseport flavors.
>
> > From reuseport_select_sock(), it seems the kernel's select_by_hash
> > also avoids returning established sk.
>
> Right. CC'ing Willem to check if bpf was left out on purpose or not.

Not on purpose. I considered that this is up to the BPF program.
