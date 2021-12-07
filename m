Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB5D46B0C1
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhLGCm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhLGCm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 21:42:26 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559D4C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 18:38:57 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id g17so36668026ybe.13
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 18:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S+DKigwGp6Dozfddy+ComH3k1nine6YyOJOFswg5zk0=;
        b=QqyaQoepN3IRPINl0f/Rju/GoHo5x064iTI4DhSacwwKhFfZl+lKy4Z0Wp+ElzMh7f
         AAeNiugPaIUxnrLdoKF4mwJcCSTysOo+KINvKGe5Z3sVT5GZQPvbROsMvxI1uh8UHmlY
         WCC7camjuRlRTjNfEul8yWR+tDwu8voapOnIncFa0YsFuAUyeVXXlcpFSOxWrrypm2OV
         bjSrWRYy9RsQHPGvhNq/jCb3Z4QpgwwpXUBStM8kxGYGXhRT3gfOPdwIDa07Pj4ylFq3
         Cn48RwngK4OuaDyPg6bBv48BmhG0LMOKtnx5R6JP6NdOpZ0at08B8kC39MG4+hBMglk8
         NXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S+DKigwGp6Dozfddy+ComH3k1nine6YyOJOFswg5zk0=;
        b=YkjjTVksIEIYNaP3cTX6cE/kxtMmtSGqDlYQgkFqCCIWnNi3Px5ftq3PfGRM6epdWM
         VxzFdJ9j53kd2tww6vdK8f/y2DAz5US+siMSq6rAHLVyup4N1J91Tf5koOC/33tzFfry
         4QS2QdyIEY4LDYomBaDTCPjnrwN96/M73CAseOx6gBPxBWiV53eowt88XfYQXsTRbMUH
         6zljOy8V0TVknNB1eqFhSg6LARGl1L23ex+fLxL7KEYkpK0cvmplCD2kR5rcc/sigWlo
         /25zgbeIVbzd0CRlu8LMh+F9UZs4Ra6xpYUGQD2pqCrJHq/596nhls1DisWhsptH0Jwg
         D4HQ==
X-Gm-Message-State: AOAM531/v8pG028rjBcU4q5YAWUfjRw7EOE/eRK/BsgJt6/X92n07m9k
        rrBxNtzbnX3qA5laYXc3hValxF+L4I91cKYtQfm7JhVkjwg=
X-Google-Smtp-Source: ABdhPJw3tqwgOH5uVd0mbTcBwZboxSrW0VPaLfyDEYfSYehxWoVyS1H5Q49Qrjnp3WH3agzzT6AHb408rvflo8+FPGE=
X-Received: by 2002:a5b:5c3:: with SMTP id w3mr28318817ybp.293.1638844735907;
 Mon, 06 Dec 2021 18:38:55 -0800 (PST)
MIME-Version: 1.0
References: <20211202024723.76257-1-xiangxia.m.yue@gmail.com>
 <20211202024723.76257-3-xiangxia.m.yue@gmail.com> <518bd06a-490c-47f0-652a-756805496063@iogearbox.net>
 <CAMDZJNUGyipTQgDv+M8_kiOEZwXJnivZo6KCwgYy_BoMOiEZew@mail.gmail.com> <CAMDZJNWx=MzSxB19JG_gmffmJrdLQ_cBzJhVYtor1EMb-DujXw@mail.gmail.com>
In-Reply-To: <CAMDZJNWx=MzSxB19JG_gmffmJrdLQ_cBzJhVYtor1EMb-DujXw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 6 Dec 2021 18:38:44 -0800
Message-ID: <CANn89iJVReHeT2y+QAOGh1mJ64PG-8QH_FoL5moY634jJpZVvQ@mail.gmail.com>
Subject: Re: [net v4 2/3] net: sched: add check tc_skip_classify in sch egress
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 6:17 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wro=
te:
>
> On Sat, Dec 4, 2021 at 9:42 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> w=
rote:
> >
> > On Sat, Dec 4, 2021 at 5:35 AM Daniel Borkmann <daniel@iogearbox.net> w=
rote:
> > >
> > > On 12/2/21 3:47 AM, xiangxia.m.yue@gmail.com wrote:
> > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > >
> > > > Try to resolve the issues as below:
> > > > * We look up and then check tc_skip_classify flag in net
> > > >    sched layer, even though skb don't want to be classified.
> > > >    That case may consume a lot of cpu cycles.
> > > >
> > > >    Install the rules as below:
> > > >    $ for id in $(seq 1 10000); do
> > > >    $       tc filter add ... egress prio $id ... action mirred egre=
ss redirect dev ifb0
> > > >    $ done
> > > >
> > > >    netperf:
> > > >    $ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
> > > >    $ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32
> > > >
> > > >    Before: 152.04 tps, 0.58 Mbit/s
> > > >    After:  303.07 tps, 1.51 Mbit/s
> > > >    For TCP_RR, there are 99.3% improvement, TCP_STREAM 160.3%.
> > >
> > > As it was pointed out earlier by Eric in v3, these numbers are moot s=
ince noone
> > > is realistically running such a setup in practice with 10k linear rul=
es.
> > Yes. As I said in v1, in production, we use the 5+ prio. With this
> > patch, little improvements, 1.x%
> >
> > This patch also fixes the packets loopback, if we use the bpf_redirect
> > to ifb in egress path.
> Hi Daniel, Eric
> What should I do next=EF=BC=9FThis patch try to fix the bug, and improve =
the
> performance(~1% in production).
> Should I update the commit message and send v5?


This is adding yet another bit in skb :/

We also have another patch series today adding one bit in skb.
For me, this is really an issue. This should be a last resort.

For example xmit_more is no longer a field in skb.
Why, because most probably this property  does not need to stick to
skb, but the context of execution.

Also this is not clear how stacked devices will be handled
(bonding/team/tunnels)
