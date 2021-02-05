Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1A93119FD
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbhBFD0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhBFCbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:31:32 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF5EC08EC31
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:28:45 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id v123so8222530yba.13
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CTjF3lcvtxzEk61kps3cqc0oF/+9f44lThGQhXiTv78=;
        b=ZdRQOArfin5+YhEpJj5USxrKabfh87LOklnsnP0WQPElrAIGptPXUSz2bx4w88RS2i
         xyk4cKYKHL13jgZXkKiNFhTlXt+7S8GhZvc55UL4FsnWtPKyvn3fiDYyOevCw7DOwkqK
         xW1GwzKW4KLPHaPNeCFY45RfODj6PSFsrmOcup2co0KBCjimcJ+y5bzHd9pV0fqKkuG2
         Msu855V5BeDFkWr/yVvXqxsNMf3HQ6toOS0JHr6Dzmx3+W3zNHS3KixHOBChI/m7ZHDB
         eM2dbrQzPBFG5IJuiUoVKKXppB66VnXSJhCWc7schLHmgQv3iQg1XGNINnaxzCLx2mTo
         Q/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CTjF3lcvtxzEk61kps3cqc0oF/+9f44lThGQhXiTv78=;
        b=d1wDP7K26W0jCk4XXl7eKON1XVWV9PDAvpKO3PpHHzVlC2kuio2AiwNYPyskYsLnDc
         de6Ac9tVcpsS9Iguc/rj7FAGTFJckd8eexBwrHdQlUdDyHwd/Vzzqmh/mMq4sRFDb8/U
         fxgw57i/n8YD7ME6yXReLf5cpicvwPDOCSgV032JTgdCHmD95R89U6SxCjwmiNak0cWI
         ahQszjg8hwXjJLErjoMECfBKRuhSTFhH+ZWV58XHuTKEDAeTFvzJK4ezDZ36DKK5V7+P
         bGaM2OYbXF89VEiPxzgQ1HQ9xqyNMygfCH5u83Oafq7z9NUWUc0V9xJAgT5Xcxrr5g/f
         fnbw==
X-Gm-Message-State: AOAM530EmTc5qC7QGo8LTabU9SO4tPpjMeUtatHKM20b/neB4cjsySDA
        YHA2kp+CKQnhOpVtnGskB4RH+0PoG5TiuPrspY8qPQ==
X-Google-Smtp-Source: ABdhPJxl6rubsetWEopClE35ZkEaPgrH4m3B6GrhI5DjrRGo6EBqcwqFPqXW43LqnZMgN+Py99Ziy1gQIPDWNzpoYNE=
X-Received: by 2002:a25:bb8f:: with SMTP id y15mr9099422ybg.139.1612564124621;
 Fri, 05 Feb 2021 14:28:44 -0800 (PST)
MIME-Version: 1.0
References: <20210129002136.70865-1-weiwan@google.com> <20210202180807-mutt-send-email-mst@kernel.org>
 <CAEA6p_Arqm2cgjc7rKibautqeVyxPkkMV7y20DU1sDaoCnLvzQ@mail.gmail.com>
 <CA+FuTSe-6MSpB4hwwvwPgDqHkxYJoxMZMDbOusNqiq0Gwa1eiQ@mail.gmail.com>
 <CA+FuTSdkJcj_ikNnJmGadBZ1fa7q26MZ1g3ERf8Ax+YbXvgcng@mail.gmail.com>
 <20210203052924-mutt-send-email-mst@kernel.org> <CAF=yD-J8rsr9JWdMGBSc-muFGMG2=YCWYwWOiQBQZuryioBUoA@mail.gmail.com>
 <20210203175837-mutt-send-email-mst@kernel.org> <CAEA6p_BqKECAU=C55TpJedG9gkZDakiiN27dcWOTJYH0YOFA_w@mail.gmail.com>
 <CA+FuTSf-uWyK6Jz=G67p+ep693oTczF55EUzrH9fXzBqTnoMQA@mail.gmail.com>
In-Reply-To: <CA+FuTSf-uWyK6Jz=G67p+ep693oTczF55EUzrH9fXzBqTnoMQA@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 5 Feb 2021 14:28:33 -0800
Message-ID: <CAEA6p_DGgErG6oa1T9zJr+K6CosxoMb-TA=f2kQ_1bFdeMWAcg@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, jasowang@redhat.com
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 12:48 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, Feb 3, 2021 at 6:53 PM Wei Wang <weiwan@google.com> wrote:
> >
> > On Wed, Feb 3, 2021 at 3:10 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Wed, Feb 03, 2021 at 01:24:08PM -0500, Willem de Bruijn wrote:
> > > > On Wed, Feb 3, 2021 at 5:42 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Tue, Feb 02, 2021 at 07:06:53PM -0500, Willem de Bruijn wrote:
> > > > > > On Tue, Feb 2, 2021 at 6:53 PM Willem de Bruijn <willemb@google.com> wrote:
> > > > > > >
> > > > > > > On Tue, Feb 2, 2021 at 6:47 PM Wei Wang <weiwan@google.com> wrote:
> > > > > > > >
> > > > > > > > On Tue, Feb 2, 2021 at 3:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Thu, Jan 28, 2021 at 04:21:36PM -0800, Wei Wang wrote:
> > > > > > > > > > With the implementation of napi-tx in virtio driver, we clean tx
> > > > > > > > > > descriptors from rx napi handler, for the purpose of reducing tx
> > > > > > > > > > complete interrupts. But this could introduce a race where tx complete
> > > > > > > > > > interrupt has been raised, but the handler found there is no work to do
> > > > > > > > > > because we have done the work in the previous rx interrupt handler.
> > > > > > > > > > This could lead to the following warning msg:
> > > > > > > > > > [ 3588.010778] irq 38: nobody cared (try booting with the
> > > > > > > > > > "irqpoll" option)
> > > > > > > > > > [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> > > > > > > > > > 5.3.0-19-generic #20~18.04.2-Ubuntu
> > > > > > > > > > [ 3588.017940] Call Trace:
> > > > > > > > > > [ 3588.017942]  <IRQ>
> > > > > > > > > > [ 3588.017951]  dump_stack+0x63/0x85
> > > > > > > > > > [ 3588.017953]  __report_bad_irq+0x35/0xc0
> > > > > > > > > > [ 3588.017955]  note_interrupt+0x24b/0x2a0
> > > > > > > > > > [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> > > > > > > > > > [ 3588.017957]  handle_irq_event+0x3b/0x60
> > > > > > > > > > [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> > > > > > > > > > [ 3588.017961]  handle_irq+0x20/0x30
> > > > > > > > > > [ 3588.017964]  do_IRQ+0x50/0xe0
> > > > > > > > > > [ 3588.017966]  common_interrupt+0xf/0xf
> > > > > > > > > > [ 3588.017966]  </IRQ>
> > > > > > > > > > [ 3588.017989] handlers:
> > > > > > > > > > [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> > > > > > > > > > [ 3588.025099] Disabling IRQ #38
> > > > > > > > > >
> > > > > > > > > > This patch adds a new param to struct vring_virtqueue, and we set it for
> > > > > > > > > > tx virtqueues if napi-tx is enabled, to suppress the warning in such
> > > > > > > > > > case.
> > > > > > > > > >
> > > > > > > > > > Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi")
> > > > > > > > > > Reported-by: Rick Jones <jonesrick@google.com>
> > > > > > > > > > Signed-off-by: Wei Wang <weiwan@google.com>
> > > > > > > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > This description does not make sense to me.
> > > > > > > > >
> > > > > > > > > irq X: nobody cared
> > > > > > > > > only triggers after an interrupt is unhandled repeatedly.
> > > > > > > > >
> > > > > > > > > So something causes a storm of useless tx interrupts here.
> > > > > > > > >
> > > > > > > > > Let's find out what it was please. What you are doing is
> > > > > > > > > just preventing linux from complaining.
> > > > > > > >
> > > > > > > > The traffic that causes this warning is a netperf tcp_stream with at
> > > > > > > > least 128 flows between 2 hosts. And the warning gets triggered on the
> > > > > > > > receiving host, which has a lot of rx interrupts firing on all queues,
> > > > > > > > and a few tx interrupts.
> > > > > > > > And I think the scenario is: when the tx interrupt gets fired, it gets
> > > > > > > > coalesced with the rx interrupt. Basically, the rx and tx interrupts
> > > > > > > > get triggered very close to each other, and gets handled in one round
> > > > > > > > of do_IRQ(). And the rx irq handler gets called first, which calls
> > > > > > > > virtnet_poll(). However, virtnet_poll() calls virtnet_poll_cleantx()
> > > > > > > > to try to do the work on the corresponding tx queue as well. That's
> > > > > > > > why when tx interrupt handler gets called, it sees no work to do.
> > > > > > > > And the reason for the rx handler to handle the tx work is here:
> > > > > > > > https://lists.linuxfoundation.org/pipermail/virtualization/2017-April/034740.html
> > > > > > >
> > > > > > > Indeed. It's not a storm necessarily. The warning occurs after one
> > > > > > > hundred such events, since boot, which is a small number compared real
> > > > > > > interrupt load.
> > > > > >
> > > > > > Sorry, this is wrong. It is the other call to __report_bad_irq from
> > > > > > note_interrupt that applies here.
> > > > > >
> > > > > > > Occasionally seeing an interrupt with no work is expected after
> > > > > > > 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi"). As
> > > > > > > long as this rate of events is very low compared to useful interrupts,
> > > > > > > and total interrupt count is greatly reduced vs not having work
> > > > > > > stealing, it is a net win.
> > > > >
> > > > > Right, but if 99900 out of 100000 interrupts were wasted, then it is
> > > > > surely an even greater win to disable interrupts while polling like
> > > > > this.  Might be tricky to detect, disabling/enabling aggressively every
> > > > > time even if there's nothing in the queue is sure to cause lots of cache
> > > > > line bounces, and we don't want to enable callbacks if they were not
> > > > > enabled e.g. by start_xmit ...  Some kind of counter?
> > > >
> > > > Yes. It was known that the work stealing is more effective in some
> > > > workloads than others. But a 99% spurious rate I had not anticipated.
> > > >
> > > > Most interesting is the number of interrupts suppressed as a result of
> > > > the feature. That is not captured by this statistic.
> > > >
> > > > In any case, we'll take a step back to better understand behavior. And
> > > > especially why this high spurious rate exhibits in this workload with
> > > > many concurrent flows.
> > >
> > >
> > > I've been thinking about it. Imagine work stealing working perfectly.
> > > Each time we xmit a packet, it is stolen and freed.
> > > Since xmit enables callbacks (just in case!) we also
> > > get an interrupt, which is automatically spurious.
> > >
> > > My conclusion is that we shouldn't just work around it but instead
> > > (or additionally?)
> > > reduce the number of interrupts by disabling callbacks e.g. when
> > > a. we are currently stealing packets
> > > or
> > > b. we stole all packets
>
> Agreed. This might prove a significant performance gain at the same time :)
>
> > >
> > Thinking along this line, that probably means, we should disable cb on
> > the tx virtqueue, when scheduling the napi work on the rx side, and
> > reenable it after the rx napi work is done?
> > Also, I wonder if it is too late to disable cb at the point we start
> > to steal pkts or have stolen all pkts.
>
> The earlier the better. I see no benefit to delay until the rx handler
> actually runs.
>

I've been thinking more on this. I think the fundamental issue here is
that the rx napi handler virtnet_poll() does the tx side work by
calling virtnet_poll_cleantx() without any notification to the tx
side.
I am thinking, in virtnet_poll(), instead of directly call
virtnet_poll_cleantx(), why not do virtqueue_napi_schedule() to
schedule the tx side napi, and let the tx napi handler do the cleaning
work. This way, we automatically call virtqueue_disable_cb() on the tx
vq, and after the tx work is done, virtqueue_napi_complete() is called
to re-enable the cb on the tx side. This way, the tx side knows what
has been done, and will likely reduce the # of spurious tx interrupts?
And I don't think there is much cost in doing that, since
napi_schedule() basically queues the tx napi to the back of its
napi_list, and serves it right after the rx napi handler is done.
What do you guys think? I could quickly test it up to see if it solves
the issue.

> > Because the steal work is done
> > in the napi handler of the rx queue. But the tx interrupt must have
> > been raised before that. Will we come back to process the tx interrupt
> > again after we re-enabled the cb on the tx side?
> >
> > > This should be enough to reduce the chances below 99% ;)
> > >
> > > One annoying thing is that with split and event index, we do not disable
> > > interrupts. Could be worth revisiting, for now maybe just disable the
> > > event index feature? I am not sure it is actually worth it with
> > > stealing.
>
> With event index, we suppress interrupts when another interrupt is
> already pending from a previous packet, right? When the previous
> position of the producer is already beyond the consumer. It doesn't
> matter whether the previous packet triggered a tx interrupt or
> deferred to an already scheduled rx interrupt? From that seems fine to
> leave it out.
