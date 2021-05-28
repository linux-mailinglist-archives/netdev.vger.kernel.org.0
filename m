Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8291D394087
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 12:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbhE1KCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 06:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236356AbhE1KBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 06:01:52 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA50EC061761;
        Fri, 28 May 2021 03:00:16 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g18so2859071pfr.2;
        Fri, 28 May 2021 03:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XkhajJbVENw05gdm0/64f1bFmGYssSVOr17T3Gt0/TA=;
        b=OGyzp5KG7AHufFdzzq7prRUBmxGSWx5buDkbnOOI6Upr/hoTqaCW/YmXcoyWHFODK8
         Qi5xl8fYevu5ZJ+AOL5VNsxnkKzOMsCPxKz4iJ/QtYhzruIilsr9f4Abc8n5r/S2Vwzn
         rCGB0m80A8TH9VRD+DVB+fi/MleJ1qKTMvE7tkRPaM5H2JHBPDGdqlAsfhcgwjEbMoj8
         NwaZpuy8mDWIpisgf5yuxVIdTLBjKP8rEpUWTR2WyT13iUzZVN9EMQ0sskhLM1IadNkb
         +geO8JBC5s00S5TGVNudqVMsaAegJYgRrPWa33LhH3biQpBff9ooRuEp01lz/LoliRSe
         H6pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XkhajJbVENw05gdm0/64f1bFmGYssSVOr17T3Gt0/TA=;
        b=da4Sb+IMH3T0LpLQrYYPExR48wOOmIzdD3NoJyTdM+T0rrrK0CkMGPDFhDQxvscUMd
         /YDFJakvfTrOUuc8JfXUtmldBh5UclaF0o92TbY3qMFgCeeyyVPqPMqI9pPMOWZKKq0W
         vjta9cPi2ekrQ9CU/9yBAv6rf1d7BoUnYFXKwkfyESUdBLNFbJuu+2CP5kUOlBZ//uf0
         RVTN8SzcjSXt5NbG6DyYMT4GgNZ4dCiTe49W96r5hURQcuquQZCIK1EQ2s6kU/SYl+Qm
         TDNJ83mKF5ivezeoNTjFFFvjRF7VYCqqWpUgeDFi2jZwzNvE4UTLeldRjwZYWS6Pd3/O
         5QHA==
X-Gm-Message-State: AOAM530ajyKIxio7xo5S63MpoXlXab1zI7557x1fGAVae0k6zH0f0pLC
        yG9/EsGhapU+bV1zBSTs4QeDiZR6xJxq5mqr6J8=
X-Google-Smtp-Source: ABdhPJzpHzych1ZR/lCf/I1GJFWkEX3bq9CrKC/JOR6cXsfHlRhWYM5vyYGtS7dzZujHidAOb/oBtymZ56fJZnqgl9E=
X-Received: by 2002:a63:7056:: with SMTP id a22mr8258180pgn.292.1622196016295;
 Fri, 28 May 2021 03:00:16 -0700 (PDT)
MIME-Version: 1.0
References: <87im33grtt.fsf@toke.dk> <1622192521.5931044-1-xuanzhuo@linux.alibaba.com>
 <20210528115003.37840424@carbon>
In-Reply-To: <20210528115003.37840424@carbon>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 28 May 2021 12:00:05 +0200
Message-ID: <CAJ8uoz2bhfsk4XX--cNB-gKczx0jZENB5kdthoWkuyxcOHQfjg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: support AF_PACKET
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xie He <xie.he.0141@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        John Ogness <john.ogness@linutronix.de>,
        Wang Hai <wanghai38@huawei.com>,
        Tanner Love <tannerlove@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 11:52 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Fri, 28 May 2021 17:02:01 +0800
> Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> > On Fri, 28 May 2021 10:55:58 +0200, Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
> > > Xuan Zhuo <xuanzhuo@linux.alibaba.com> writes:
> > >
> > > > In xsk mode, users cannot use AF_PACKET(tcpdump) to observe the cur=
rent
> > > > rx/tx data packets. This feature is very important in many cases. S=
o
> > > > this patch allows AF_PACKET to obtain xsk packages.
> > >
> > > You can use xdpdump to dump the packets from the XDP program before i=
t
> > > gets redirected into the XSK:
> > > https://github.com/xdp-project/xdp-tools/tree/master/xdp-dump
> >
> > Wow, this is a good idea.
>
> Yes, it is rather cool (credit to Eelco).  Notice the extra info you
> can capture from 'exit', like XDP return codes, if_index, rx_queue.
>
> The tool uses the perf ring-buffer to send/copy data to userspace.
> This is actually surprisingly fast, but I still think AF_XDP will be
> faster (but it usually 'steals' the packet).
>
> Another (crazy?) idea is to extend this (and xdpdump), is to leverage
> Hangbin's recent XDP_REDIRECT extension e624d4ed4aa8 ("xdp: Extend
> xdp_redirect_map with broadcast support").  We now have a
> xdp_redirect_map flag BPF_F_BROADCAST, what if we create a
> BPF_F_CLONE_PASS flag?
>
> The semantic meaning of BPF_F_CLONE_PASS flag is to copy/clone the
> packet for the specified map target index (e.g AF_XDP map), but
> afterwards it does like veth/cpumap and creates an SKB from the
> xdp_frame (see __xdp_build_skb_from_frame()) and send to netstack.
> (Feel free to kick me if this doesn't make any sense)

This would be a smooth way to implement clone support for AF_XDP. If
we had this and someone added AF_XDP support to libpcap, we could both
capture AF_XDP traffic with tcpdump (using this clone functionality in
the XDP program) and speed up tcpdump for dumping traffic destined for
regular sockets. Would that solve your use case Xuan? Note that I have
not looked into the BPF_F_CLONE_PASS code, so do not know at this
point what it would take to support this for XSKMAPs.

> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
