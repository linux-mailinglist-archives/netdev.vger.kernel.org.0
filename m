Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3975B509514
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 04:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383784AbiDUCkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 22:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiDUCk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 22:40:29 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1725F2C4;
        Wed, 20 Apr 2022 19:37:41 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id s18so7294163ejr.0;
        Wed, 20 Apr 2022 19:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bc6AgyH0v562982pO2Yvqlt5tZo1Pxn0qGkmDxnDxTc=;
        b=NDZsv++7ZxmRwH9twfMYY1A+fEgP/rXvja7BsjUu2f+5jP0ByNXtXs2jGXNsMhavn4
         oiFnnCQTxIqLtqqqmAsnkpAM1k/uJZwu9Pv7odDIITUjAlI8y7Vkqn/FGf5vVaIf06wk
         PmEwe7TiK2t/g30F/B4NK3VcHEF0EIcWhqSINZSfXlJkS3En6o96xsZpaLvo9R+rAfsH
         F8uGQ6E/EOEgoHUXaxuaeNFB2d3U2p0z7XEIgM0AJGDutrA82nFyyq+JOS83+ZCfesRn
         VqANgAQeFilKK6oHyBcIe9hn5QcG/wx+pPNok9Y7oZD4AFQXrtB1V4zsOEc1G/7DXtU+
         g1Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bc6AgyH0v562982pO2Yvqlt5tZo1Pxn0qGkmDxnDxTc=;
        b=5M7LtJc2QkfYnSwNJkfA6eY3K+ZeeVVAS4mkOO/DMKTrDseSZ08wqdUx7uu/ecXD4Z
         LjAuEdqsTLFdwaqFSfQNxsgIb59QVLBJU7+rbbe+0OjYDhOw20iZJkGWkrpX/BTxPiXF
         fMV5R25BH9RjjD85GCabVoNTQrGon7b9GXKZgkxk6vnsKx517gWzsIHBWBFuIEzwcE6S
         T8R+Y5y51FB3ItDCI8TUAUKnZN5OcufHmR9XkH4iTWrZGKjiiKsYilZahxLoHWj3lfIt
         Z2XbnH3qqNQR+eGleqyG2pFDVLKrax+F4iANoKViTkzgWRxl2XDTVboqAwYOvp8PInj9
         5blw==
X-Gm-Message-State: AOAM533chuznfMH1FxdtXPNlHcyWE09pCrS9KhEmk8IJ4Pe//CAI4YzQ
        O2uAdDNHQ+YJKpWyB7gWCI5/gDSyaexorqJhfXDie165hBmOoA==
X-Google-Smtp-Source: ABdhPJwcPnziEwqWtahGs8Isz+W7mW/jNnh7EFWcj/w42t3+lmdcFmjK/Y1paTP3/P12gB0Qs1A8s3qzj3uOuHmR96g=
X-Received: by 2002:a17:907:7204:b0:6e8:c1e9:49f7 with SMTP id
 dr4-20020a170907720400b006e8c1e949f7mr20971128ejc.251.1650508659624; Wed, 20
 Apr 2022 19:37:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220420122307.5290-1-xiangxia.m.yue@gmail.com>
 <878rrzj4r6.fsf@toke.dk> <CAEf4Bzafe3Am5uep7erd7r+-pgdGRc9hsJASYfFH47ty8x9mTA@mail.gmail.com>
In-Reply-To: <CAEf4Bzafe3Am5uep7erd7r+-pgdGRc9hsJASYfFH47ty8x9mTA@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 21 Apr 2022 10:37:03 +0800
Message-ID: <CAMDZJNVTSLyLoNc=O5zL8+suAd+C_HihCoutULWGiSCb-Fw0Vw@mail.gmail.com>
Subject: Re: [net-next v1] bpf: add bpf_ktime_get_real_ns helper
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Joanne Koong <joannekoong@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 12:17 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Apr 20, 2022 at 5:53 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@ke=
rnel.org> wrote:
> >
> > xiangxia.m.yue@gmail.com writes:
> >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > This patch introduce a new bpf_ktime_get_real_ns helper, which may
> > > help us to measure the skb latency in the ingress/forwarding path:
> > >
> > > HW/SW[1] -> ip_rcv/tcp_rcv_established -> tcp_recvmsg_locked/tcp_upda=
te_recv_tstamps
> > >
> > > * Insert BPF kprobe into ip_rcv/tcp_rcv_established invoking this hel=
per.
> > >   Then we can inspect how long time elapsed since HW/SW.
> > > * If inserting BPF kprobe tcp_update_recv_tstamps invoked by tcp_recv=
msg,
> > >   we can measure how much latency skb in tcp receive queue. The reaso=
n for
> > >   this can be application fetch the TCP messages too late.
> >
> > Why not just use one of the existing ktime helpers and also add a BPF
> > probe to set the initial timestamp instead of relying on skb->tstamp?
> >
>
> You don't even need a BPF probe for this. See [0] for how retsnoop is
> converting bpf_ktime_get_ns() into real time.
>
>   [0] https://github.com/anakryiko/retsnoop/blob/master/src/retsnoop.c#L6=
49-L668
I try to calculate this offset too. But one case:
If administrator manually or NTP changes the clock, we should
calculate the offset.
How do we know the changes, one solution is that inserting kprobe in
tk_set_wall_to_mono() kernel function,
and using perf_event to notify userspace.

> > -Toke



--=20
Best regards, Tonghao
