Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0163E35D892
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbhDMHOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhDMHOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 03:14:33 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27195C061574;
        Tue, 13 Apr 2021 00:14:14 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id a85so10401494pfa.0;
        Tue, 13 Apr 2021 00:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JXWyaO6uozRpzUejkv6WQM7k14W2GQD/gxKY/Zgj0os=;
        b=IgthMJcsWYYBaUVsCfL/HbE0ZaJtQFIY5p4YI9kFhAsE+Hjq0kxXZ+QXPpaa3VzZ5D
         Uw7RK/1Qo9fsGZY03B6ckRYtpYFHbHVtQFCPYovaQwORWXldZsvgRevJX/CudvS2oRGy
         SI9TgvFcU5BwPNYQWQMQbDXVr/UzkOX9luFk/oXJLr99hZVwVP+910tsp6lRpMLmXImn
         znGmsQvTGsLsc8LELvOFJKJsf/9LWtFWEK/Vg6kfYjTSO7+oGZU1nHEMQIoSMDXXM/n6
         mTBBeGyPwVECAF7LMtvXdBNOWZhYtAGuwcRItQwRSMCVVoLBCkqiao+AIRnuU554OTi3
         BR9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JXWyaO6uozRpzUejkv6WQM7k14W2GQD/gxKY/Zgj0os=;
        b=Miu+1r3AmrCjO1VRtFVEB35KYiBE8MYouy5LJbj+XokikoHqdjarrwn+DUmml/z//N
         pJKlQFkR6L2FLS/I175cuVO4cn9KdCQHkyj8r77ZthnnZuIMvqI7LObdiCocmAydT+yO
         FAqRKgwmJ/Zrxj/JHVY7DStit2s/hxsWUh4CswRpmW3NPhvD9ehRHLVcLkNrxjgdRMHP
         4DuyakQSQOARfuG36lrfnG4jh1GcfV/2jdhQNd/RUmxXXQS/ssFFspt1nUrvjcg7zlft
         oauVP8EFWcUGJ99RWjKKgbs/JytiBjDW5pealCSvMHqmtLgpquDBXdy7rz9Y82HAgDKl
         PkMg==
X-Gm-Message-State: AOAM531dMEYuuGcyjQD33gnmPRAQfpFAoNtC17wxYGvb0+473dQ3b77u
        uRtfUZejj8Sxg/JVsX6LlWDRBhLxDaWFPjpJOF8=
X-Google-Smtp-Source: ABdhPJwQs2XodemFscvFdh/gdWgL/U2Ub+qpoUQL8HAP+6IaGgok4qnYmV4V1xkgfB5Pv/XbeG5S5ntdX3SJ0HrVJfk=
X-Received: by 2002:a63:cf55:: with SMTP id b21mr32288770pgj.126.1618298053549;
 Tue, 13 Apr 2021 00:14:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ8uoz2jym_AmCyMt_B32YBAEsjTNpaQF-WAJUavUe3P5_at3w@mail.gmail.com>
 <1618278328.0085247-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1618278328.0085247-1-xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 13 Apr 2021 09:14:02 +0200
Message-ID: <CAJ8uoz27wTWU0HhfVWkcHESfAtMXT6dj=p+JW87zm-ownDF7Ww@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/2] xsk: introduce generic almost-zerocopy xmit
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 3:49 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> On Mon, 12 Apr 2021 16:13:12 +0200, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > On Wed, Mar 31, 2021 at 2:27 PM Alexander Lobakin <alobakin@pm.me> wrote:
> > >
> > > This series is based on the exceptional generic zerocopy xmit logics
> > > initially introduced by Xuan Zhuo. It extends it the way that it
> > > could cover all the sane drivers, not only the ones that are capable
> > > of xmitting skbs with no linear space.
> > >
> > > The first patch is a random while-we-are-here improvement over
> > > full-copy path, and the second is the main course. See the individual
> > > commit messages for the details.
> > >
> > > The original (full-zerocopy) path is still here and still generally
> > > faster, but for now it seems like virtio_net will remain the only
> > > user of it, at least for a considerable period of time.
> > >
> > > From v1 [0]:
> > >  - don't add a whole SMP_CACHE_BYTES because of only two bytes
> > >    (NET_IP_ALIGN);
> > >  - switch to zerocopy if the frame is 129 bytes or longer, not 128.
> > >    128 still fit to kmalloc-512, while a zerocopy skb is always
> > >    kmalloc-1024 -> can potentially be slower on this frame size.
> > >
> > > [0] https://lore.kernel.org/netdev/20210330231528.546284-1-alobakin@pm.me
> > >
> > > Alexander Lobakin (2):
> > >   xsk: speed-up generic full-copy xmit
> >
> > I took both your patches for a spin on my machine and for the first
> > one I do see a small but consistent drop in performance. I thought it
> > would go the other way, but it does not so let us put this one on the
> > shelf for now.
> >
> > >   xsk: introduce generic almost-zerocopy xmit
> >
> > This one wreaked havoc on my machine ;-). The performance dropped with
> > 75% for packets larger than 128 bytes when the new scheme kicks in.
> > Checking with perf top, it seems that we spend much more time
> > executing the sendmsg syscall. Analyzing some more:
> >
> > $ sudo bpftrace -e 'kprobe:__sys_sendto { @calls = @calls + 1; }
> > interval:s:1 {printf("calls/sec: %d\n", @calls); @calls = 0;}'
> > Attaching 2 probes...
> > calls/sec: 1539509 with your patch compared to
> >
> > calls/sec: 105796 without your patch
> >
> > The application spends a lot of more time trying to get the kernel to
> > send new packets, but the kernel replies with "have not completed the
> > outstanding ones, so come back later" = EAGAIN. Seems like the
> > transmission takes longer when the skbs have fragments, but I have not
> > examined this any further. Did you get a speed-up?
>
> Regarding this solution, I actually tested it on my mlx5 network card, but the
> performance was severely degraded, so I did not continue this solution later. I
> guess it might have something to do with the physical network card. We can try
> other network cards.

I tried it on a third card and got a 40% degradation, so let us scrap
this idea. It should stay optional as it is today as the (software)
drivers that benefit from this can turn it on explicitly.

> links: https://www.spinics.net/lists/netdev/msg710918.html
>
> Thanks.
>
> >
> > >  net/xdp/xsk.c | 32 ++++++++++++++++++++++----------
> > >  1 file changed, 22 insertions(+), 10 deletions(-)
> > >
> > > --
> > > Well, this is untested. I currently don't have an access to my setup
> > > and is bound by moving to another country, but as I don't know for
> > > sure at the moment when I'll get back to work on the kernel next time,
> > > I found it worthy to publish this now -- if any further changes will
> > > be required when I already will be out-of-sight, maybe someone could
> > > carry on to make a another revision and so on (I'm still here for any
> > > questions, comments, reviews and improvements till the end of this
> > > week).
> > > But this *should* work with all the sane drivers. If a particular
> > > one won't handle this, it's likely ill. Any tests are highly
> > > appreciated. Thanks!
> > > --
> > > 2.31.1
> > >
> > >
