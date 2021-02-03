Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B155230E7EB
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbhBCXxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbhBCXxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 18:53:45 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2FCC061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 15:53:05 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id y128so1344359ybf.10
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 15:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y9kpewlk5gYuDap4TpjnTYr9hz25eAcipdXi2h66ecc=;
        b=pF3YNT068Tyefb09lUaYjysJwlnHay2owbXiu7J03Xlgz7z8PdsaMGmtnrM45APG58
         xr5aJgRK5Bfa3SO9Jbz1s8rPVfrW9dM/rgA/Y+cN1Jr+lc/BDZD2TAthAI3ynRCddQ/L
         5P3RCTElfSyOR94qHzzka0URSA6VJWCRLPsufiG9fKyG4j8+XeIEJydqk4VCpWVLZCEY
         didgfEWjlS1uX1zSu7m9Yi9VO20dY2IEltadPH6m0zNP8oluLLo0x4NcMmZEAD7JQO2M
         KxHTnqTsZIhyVhBN5T1LaTD8UEPeMS+l16cCuCpzoePWQzDWU50aZO6f99ef+Y0IGVC8
         8OXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y9kpewlk5gYuDap4TpjnTYr9hz25eAcipdXi2h66ecc=;
        b=MRHWi2RFoy9j2pJI8pIocnQ8WwIzGxF2s5ypnel2LzXaCDdx1UHPdKI54WOTYsb4ND
         4Y15XUd8CeFU5RgUxcH2ucNIY7mrJ2J3ow0vOrWBl8QNAtwawzmXCgAzM1N5lVt6TNzm
         2G6nqdx91z9dzcjQzeb861TDgO7+0jDivFfo4dgcPXe17feWVS0rtJbgaMqZzUGJ+uVh
         Ju5skgkdeAxRVVFcdOj8WYJvXI3GwRXsmpI3xNTpnLjLEPcoUw5ucDHPRTNWL/xC93z2
         KBI2ZxXcI5BbK5qXbHSXfr4RHyFi4lpPATQtSd5A+1ebaxbdIALtS/+p1GF4QqxFuCtj
         JorQ==
X-Gm-Message-State: AOAM530x0shZj+e0N/5Yh5P5VC1MhEltAupPgHiTikTiPkLZ2D4Trt7x
        9sij0AfD07dVodQfain5PrGp6a04zBc+qYcv2ASvHwcP4Ls=
X-Google-Smtp-Source: ABdhPJxGEQO1xVozjb/hlwXjVW+yOmBLJ1xqHLtdYHINqgXW+89mP1SWQdk7EwwBSkHus467jZRHe2dgtaW7KgUxGDQ=
X-Received: by 2002:a25:4981:: with SMTP id w123mr7973579yba.123.1612396384582;
 Wed, 03 Feb 2021 15:53:04 -0800 (PST)
MIME-Version: 1.0
References: <20210129002136.70865-1-weiwan@google.com> <20210202180807-mutt-send-email-mst@kernel.org>
 <CAEA6p_Arqm2cgjc7rKibautqeVyxPkkMV7y20DU1sDaoCnLvzQ@mail.gmail.com>
 <CA+FuTSe-6MSpB4hwwvwPgDqHkxYJoxMZMDbOusNqiq0Gwa1eiQ@mail.gmail.com>
 <CA+FuTSdkJcj_ikNnJmGadBZ1fa7q26MZ1g3ERf8Ax+YbXvgcng@mail.gmail.com>
 <20210203052924-mutt-send-email-mst@kernel.org> <CAF=yD-J8rsr9JWdMGBSc-muFGMG2=YCWYwWOiQBQZuryioBUoA@mail.gmail.com>
 <20210203175837-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210203175837-mutt-send-email-mst@kernel.org>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 3 Feb 2021 15:52:53 -0800
Message-ID: <CAEA6p_BqKECAU=C55TpJedG9gkZDakiiN27dcWOTJYH0YOFA_w@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 3:10 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Feb 03, 2021 at 01:24:08PM -0500, Willem de Bruijn wrote:
> > On Wed, Feb 3, 2021 at 5:42 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Tue, Feb 02, 2021 at 07:06:53PM -0500, Willem de Bruijn wrote:
> > > > On Tue, Feb 2, 2021 at 6:53 PM Willem de Bruijn <willemb@google.com> wrote:
> > > > >
> > > > > On Tue, Feb 2, 2021 at 6:47 PM Wei Wang <weiwan@google.com> wrote:
> > > > > >
> > > > > > On Tue, Feb 2, 2021 at 3:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > >
> > > > > > > On Thu, Jan 28, 2021 at 04:21:36PM -0800, Wei Wang wrote:
> > > > > > > > With the implementation of napi-tx in virtio driver, we clean tx
> > > > > > > > descriptors from rx napi handler, for the purpose of reducing tx
> > > > > > > > complete interrupts. But this could introduce a race where tx complete
> > > > > > > > interrupt has been raised, but the handler found there is no work to do
> > > > > > > > because we have done the work in the previous rx interrupt handler.
> > > > > > > > This could lead to the following warning msg:
> > > > > > > > [ 3588.010778] irq 38: nobody cared (try booting with the
> > > > > > > > "irqpoll" option)
> > > > > > > > [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> > > > > > > > 5.3.0-19-generic #20~18.04.2-Ubuntu
> > > > > > > > [ 3588.017940] Call Trace:
> > > > > > > > [ 3588.017942]  <IRQ>
> > > > > > > > [ 3588.017951]  dump_stack+0x63/0x85
> > > > > > > > [ 3588.017953]  __report_bad_irq+0x35/0xc0
> > > > > > > > [ 3588.017955]  note_interrupt+0x24b/0x2a0
> > > > > > > > [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> > > > > > > > [ 3588.017957]  handle_irq_event+0x3b/0x60
> > > > > > > > [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> > > > > > > > [ 3588.017961]  handle_irq+0x20/0x30
> > > > > > > > [ 3588.017964]  do_IRQ+0x50/0xe0
> > > > > > > > [ 3588.017966]  common_interrupt+0xf/0xf
> > > > > > > > [ 3588.017966]  </IRQ>
> > > > > > > > [ 3588.017989] handlers:
> > > > > > > > [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> > > > > > > > [ 3588.025099] Disabling IRQ #38
> > > > > > > >
> > > > > > > > This patch adds a new param to struct vring_virtqueue, and we set it for
> > > > > > > > tx virtqueues if napi-tx is enabled, to suppress the warning in such
> > > > > > > > case.
> > > > > > > >
> > > > > > > > Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi")
> > > > > > > > Reported-by: Rick Jones <jonesrick@google.com>
> > > > > > > > Signed-off-by: Wei Wang <weiwan@google.com>
> > > > > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > > > >
> > > > > > >
> > > > > > > This description does not make sense to me.
> > > > > > >
> > > > > > > irq X: nobody cared
> > > > > > > only triggers after an interrupt is unhandled repeatedly.
> > > > > > >
> > > > > > > So something causes a storm of useless tx interrupts here.
> > > > > > >
> > > > > > > Let's find out what it was please. What you are doing is
> > > > > > > just preventing linux from complaining.
> > > > > >
> > > > > > The traffic that causes this warning is a netperf tcp_stream with at
> > > > > > least 128 flows between 2 hosts. And the warning gets triggered on the
> > > > > > receiving host, which has a lot of rx interrupts firing on all queues,
> > > > > > and a few tx interrupts.
> > > > > > And I think the scenario is: when the tx interrupt gets fired, it gets
> > > > > > coalesced with the rx interrupt. Basically, the rx and tx interrupts
> > > > > > get triggered very close to each other, and gets handled in one round
> > > > > > of do_IRQ(). And the rx irq handler gets called first, which calls
> > > > > > virtnet_poll(). However, virtnet_poll() calls virtnet_poll_cleantx()
> > > > > > to try to do the work on the corresponding tx queue as well. That's
> > > > > > why when tx interrupt handler gets called, it sees no work to do.
> > > > > > And the reason for the rx handler to handle the tx work is here:
> > > > > > https://lists.linuxfoundation.org/pipermail/virtualization/2017-April/034740.html
> > > > >
> > > > > Indeed. It's not a storm necessarily. The warning occurs after one
> > > > > hundred such events, since boot, which is a small number compared real
> > > > > interrupt load.
> > > >
> > > > Sorry, this is wrong. It is the other call to __report_bad_irq from
> > > > note_interrupt that applies here.
> > > >
> > > > > Occasionally seeing an interrupt with no work is expected after
> > > > > 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi"). As
> > > > > long as this rate of events is very low compared to useful interrupts,
> > > > > and total interrupt count is greatly reduced vs not having work
> > > > > stealing, it is a net win.
> > >
> > > Right, but if 99900 out of 100000 interrupts were wasted, then it is
> > > surely an even greater win to disable interrupts while polling like
> > > this.  Might be tricky to detect, disabling/enabling aggressively every
> > > time even if there's nothing in the queue is sure to cause lots of cache
> > > line bounces, and we don't want to enable callbacks if they were not
> > > enabled e.g. by start_xmit ...  Some kind of counter?
> >
> > Yes. It was known that the work stealing is more effective in some
> > workloads than others. But a 99% spurious rate I had not anticipated.
> >
> > Most interesting is the number of interrupts suppressed as a result of
> > the feature. That is not captured by this statistic.
> >
> > In any case, we'll take a step back to better understand behavior. And
> > especially why this high spurious rate exhibits in this workload with
> > many concurrent flows.
>
>
> I've been thinking about it. Imagine work stealing working perfectly.
> Each time we xmit a packet, it is stolen and freed.
> Since xmit enables callbacks (just in case!) we also
> get an interrupt, which is automatically spurious.
>
> My conclusion is that we shouldn't just work around it but instead
> (or additionally?)
> reduce the number of interrupts by disabling callbacks e.g. when
> a. we are currently stealing packets
> or
> b. we stole all packets
>
Thinking along this line, that probably means, we should disable cb on
the tx virtqueue, when scheduling the napi work on the rx side, and
reenable it after the rx napi work is done?
Also, I wonder if it is too late to disable cb at the point we start
to steal pkts or have stolen all pkts. Because the steal work is done
in the napi handler of the rx queue. But the tx interrupt must have
been raised before that. Will we come back to process the tx interrupt
again after we re-enabled the cb on the tx side?

> This should be enough to reduce the chances below 99% ;)
>
> One annoying thing is that with split and event index, we do not disable
> interrupts. Could be worth revisiting, for now maybe just disable the
> event index feature? I am not sure it is actually worth it with
> stealing.
>
> --
> MST
>
