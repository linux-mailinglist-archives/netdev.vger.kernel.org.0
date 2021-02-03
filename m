Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC58630E6D9
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbhBCXL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:11:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233420AbhBCXLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 18:11:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612393803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LtzGg6dZpqPJQB7lGKdN2ttxSh+zZAXIh6EOub7tjwE=;
        b=VRj8c6KbOyBuGTIFsYU3XTLx3Vd5PjBDiWm1BJ2riGdY011Ek9ONRqwrFR/gMPGnL6R+9h
        Evu0MRI6CZ8TPFHNaS3bSgSBf/WnmPdWb2994NFswQOj5uoQn7dGx1PDRX039QHy11GjJR
        x5OLn/t0N0JhZaI1dxJRxYrt7t0UuLw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-FmWZrEhlM1qdld0OxKH7xw-1; Wed, 03 Feb 2021 18:10:00 -0500
X-MC-Unique: FmWZrEhlM1qdld0OxKH7xw-1
Received: by mail-ed1-f71.google.com with SMTP id ay16so1013936edb.2
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 15:10:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LtzGg6dZpqPJQB7lGKdN2ttxSh+zZAXIh6EOub7tjwE=;
        b=ikc8IZ9np7jLMe/MxCAsqyGkzNGWZufjj6+6AiSsmO+ao81lSaOwvUlff3Zr5Yyww2
         jZTCFRgj9OvTgLfI4EZDu1AjDcvhodnUH1dSyEsO6u9lqo/Uh/+gj6j7Yvk/hFUmvuRE
         WsY+3LPLq+iKxmYnk951DojPAd6DaMDF8HdZv2FartJNaeYVsALUHvW9vymXtvAF6fnN
         w2y587LmPuuSHBNTdnNkc93PRhAkL8PjwbPeAzxUx3yl/PFmZQ1380L63TGZDbGdx1zr
         9YyztAF3ZN5cGB8sI2iNdEMQPkkZUWYnzWYXdIw/qlWTDXpT6mek0t0AMvlcw15lrIEO
         beJg==
X-Gm-Message-State: AOAM5334V1M32Ek6Gc+DIdn841ypTLAXDiJjqWEdLNePx24nE9ya3blo
        TdqazezrLEp6C2iCjLQRA2Lh0yrBjorUUUYsS1V0NHoVAwZ1r/5lYxgYs6L7lJip/NRIchhiO0z
        kEoxb+gp1ADY4uPg4
X-Received: by 2002:a05:6402:702:: with SMTP id w2mr5620001edx.78.1612393799497;
        Wed, 03 Feb 2021 15:09:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx7uuyn7GsgjD7SgLw/k1gUkxWYIzXI9BcVKuOiANjROSuZVhWfyl1m56Xp7IHob7FtY1oJzg==
X-Received: by 2002:a05:6402:702:: with SMTP id w2mr5619986edx.78.1612393799288;
        Wed, 03 Feb 2021 15:09:59 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id r11sm1558107edt.58.2021.02.03.15.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 15:09:58 -0800 (PST)
Date:   Wed, 3 Feb 2021 18:09:55 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Willem de Bruijn <willemb@google.com>,
        Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
Message-ID: <20210203175837-mutt-send-email-mst@kernel.org>
References: <20210129002136.70865-1-weiwan@google.com>
 <20210202180807-mutt-send-email-mst@kernel.org>
 <CAEA6p_Arqm2cgjc7rKibautqeVyxPkkMV7y20DU1sDaoCnLvzQ@mail.gmail.com>
 <CA+FuTSe-6MSpB4hwwvwPgDqHkxYJoxMZMDbOusNqiq0Gwa1eiQ@mail.gmail.com>
 <CA+FuTSdkJcj_ikNnJmGadBZ1fa7q26MZ1g3ERf8Ax+YbXvgcng@mail.gmail.com>
 <20210203052924-mutt-send-email-mst@kernel.org>
 <CAF=yD-J8rsr9JWdMGBSc-muFGMG2=YCWYwWOiQBQZuryioBUoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-J8rsr9JWdMGBSc-muFGMG2=YCWYwWOiQBQZuryioBUoA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 01:24:08PM -0500, Willem de Bruijn wrote:
> On Wed, Feb 3, 2021 at 5:42 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Feb 02, 2021 at 07:06:53PM -0500, Willem de Bruijn wrote:
> > > On Tue, Feb 2, 2021 at 6:53 PM Willem de Bruijn <willemb@google.com> wrote:
> > > >
> > > > On Tue, Feb 2, 2021 at 6:47 PM Wei Wang <weiwan@google.com> wrote:
> > > > >
> > > > > On Tue, Feb 2, 2021 at 3:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Thu, Jan 28, 2021 at 04:21:36PM -0800, Wei Wang wrote:
> > > > > > > With the implementation of napi-tx in virtio driver, we clean tx
> > > > > > > descriptors from rx napi handler, for the purpose of reducing tx
> > > > > > > complete interrupts. But this could introduce a race where tx complete
> > > > > > > interrupt has been raised, but the handler found there is no work to do
> > > > > > > because we have done the work in the previous rx interrupt handler.
> > > > > > > This could lead to the following warning msg:
> > > > > > > [ 3588.010778] irq 38: nobody cared (try booting with the
> > > > > > > "irqpoll" option)
> > > > > > > [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> > > > > > > 5.3.0-19-generic #20~18.04.2-Ubuntu
> > > > > > > [ 3588.017940] Call Trace:
> > > > > > > [ 3588.017942]  <IRQ>
> > > > > > > [ 3588.017951]  dump_stack+0x63/0x85
> > > > > > > [ 3588.017953]  __report_bad_irq+0x35/0xc0
> > > > > > > [ 3588.017955]  note_interrupt+0x24b/0x2a0
> > > > > > > [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> > > > > > > [ 3588.017957]  handle_irq_event+0x3b/0x60
> > > > > > > [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> > > > > > > [ 3588.017961]  handle_irq+0x20/0x30
> > > > > > > [ 3588.017964]  do_IRQ+0x50/0xe0
> > > > > > > [ 3588.017966]  common_interrupt+0xf/0xf
> > > > > > > [ 3588.017966]  </IRQ>
> > > > > > > [ 3588.017989] handlers:
> > > > > > > [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> > > > > > > [ 3588.025099] Disabling IRQ #38
> > > > > > >
> > > > > > > This patch adds a new param to struct vring_virtqueue, and we set it for
> > > > > > > tx virtqueues if napi-tx is enabled, to suppress the warning in such
> > > > > > > case.
> > > > > > >
> > > > > > > Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi")
> > > > > > > Reported-by: Rick Jones <jonesrick@google.com>
> > > > > > > Signed-off-by: Wei Wang <weiwan@google.com>
> > > > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > > >
> > > > > >
> > > > > > This description does not make sense to me.
> > > > > >
> > > > > > irq X: nobody cared
> > > > > > only triggers after an interrupt is unhandled repeatedly.
> > > > > >
> > > > > > So something causes a storm of useless tx interrupts here.
> > > > > >
> > > > > > Let's find out what it was please. What you are doing is
> > > > > > just preventing linux from complaining.
> > > > >
> > > > > The traffic that causes this warning is a netperf tcp_stream with at
> > > > > least 128 flows between 2 hosts. And the warning gets triggered on the
> > > > > receiving host, which has a lot of rx interrupts firing on all queues,
> > > > > and a few tx interrupts.
> > > > > And I think the scenario is: when the tx interrupt gets fired, it gets
> > > > > coalesced with the rx interrupt. Basically, the rx and tx interrupts
> > > > > get triggered very close to each other, and gets handled in one round
> > > > > of do_IRQ(). And the rx irq handler gets called first, which calls
> > > > > virtnet_poll(). However, virtnet_poll() calls virtnet_poll_cleantx()
> > > > > to try to do the work on the corresponding tx queue as well. That's
> > > > > why when tx interrupt handler gets called, it sees no work to do.
> > > > > And the reason for the rx handler to handle the tx work is here:
> > > > > https://lists.linuxfoundation.org/pipermail/virtualization/2017-April/034740.html
> > > >
> > > > Indeed. It's not a storm necessarily. The warning occurs after one
> > > > hundred such events, since boot, which is a small number compared real
> > > > interrupt load.
> > >
> > > Sorry, this is wrong. It is the other call to __report_bad_irq from
> > > note_interrupt that applies here.
> > >
> > > > Occasionally seeing an interrupt with no work is expected after
> > > > 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi"). As
> > > > long as this rate of events is very low compared to useful interrupts,
> > > > and total interrupt count is greatly reduced vs not having work
> > > > stealing, it is a net win.
> >
> > Right, but if 99900 out of 100000 interrupts were wasted, then it is
> > surely an even greater win to disable interrupts while polling like
> > this.  Might be tricky to detect, disabling/enabling aggressively every
> > time even if there's nothing in the queue is sure to cause lots of cache
> > line bounces, and we don't want to enable callbacks if they were not
> > enabled e.g. by start_xmit ...  Some kind of counter?
> 
> Yes. It was known that the work stealing is more effective in some
> workloads than others. But a 99% spurious rate I had not anticipated.
> 
> Most interesting is the number of interrupts suppressed as a result of
> the feature. That is not captured by this statistic.
> 
> In any case, we'll take a step back to better understand behavior. And
> especially why this high spurious rate exhibits in this workload with
> many concurrent flows.


I've been thinking about it. Imagine work stealing working perfectly.
Each time we xmit a packet, it is stolen and freed.
Since xmit enables callbacks (just in case!) we also
get an interrupt, which is automatically spurious.

My conclusion is that we shouldn't just work around it but instead
(or additionally?)
reduce the number of interrupts by disabling callbacks e.g. when
a. we are currently stealing packets
or
b. we stole all packets

This should be enough to reduce the chances below 99% ;)

One annoying thing is that with split and event index, we do not disable
interrupts. Could be worth revisiting, for now maybe just disable the
event index feature? I am not sure it is actually worth it with
stealing.

-- 
MST

