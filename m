Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6603A1F1A
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhFIVjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:39:54 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:40660 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhFIVjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 17:39:53 -0400
Received: by mail-ed1-f44.google.com with SMTP id t3so30244719edc.7
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 14:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hTjdamam67na35okFD1d8nEO7/NAMJitaSPOTFgv+V4=;
        b=L91WyrbPGUtgS7YmW9lG++XXxsYm/0TUhamUhPx2q0KglmWrBnOVqAj21Sdjdbdbxe
         HWxRHLmpGeVIJufSP+TvHgzvr3VqHeZIrWB7b93wZCAIBMDWsXtAkvkn7o4GexHfmDQ1
         soylWfkVRgUVkImDNSs/f+b9ZlavSRdQJqSp4ZukWDCBNX/OJseuxDlMiCEl97ogyKVh
         1SGGWmEkqAu66nfzED6o54Xz+39M25NCF9xWYoOwUSEXg9J9th7vkNQnK9M7fMjxdLcW
         MXWd3/cOzfO/je5N/XIDJ3YyDIMDVg9a2KSOUVJCY3MhzQXbqiCyXHM5aONogtqY4l39
         Md+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hTjdamam67na35okFD1d8nEO7/NAMJitaSPOTFgv+V4=;
        b=SbnffAo98xya8WwVQJvLmc05V8o+xyWIu5JBf9OTUheQH0/PoKJevUiC6zZtL5XLi0
         LeA12j3Efwt4OZ6yDh7ATEDKvaGhVjqJvmfC/xyIE9kuP1o+fxTGRugkryftLGyYGgEu
         eik1oNPU7fcWDCOQqKzKA3ccITWRNjXlRqGk8sa7++FTq6WWoM/oIxGElaSt28/ovl+Y
         YP8EarTe7bkdVUKYJ5sy+DXNXpSsmasm60cghG/8WpB/WG9Sx18Z+sFgGWy+96XieHP1
         AizIpxw2oIh0UPMj8Sfd3vmer/HRC/3PDanO4Um7NpwELP5iCJfQaEPKSN1KUqlQvxPw
         XNhw==
X-Gm-Message-State: AOAM530q3q3DckrvIo4i2ZGc3MynP09EP0444c210oapBpJxDvYLjRK2
        Sa0UmNyck6I1anhZ3XPM4hsz4v0/xrt/Eg==
X-Google-Smtp-Source: ABdhPJxn9YGHEtK0hfWBZ0OZwu7N6VTGSFH8L/wnT9rnvoYQz0q8OT+qknq7qj8DfYSfoTfCsWGrPQ==
X-Received: by 2002:aa7:da94:: with SMTP id q20mr1387556eds.310.1623274609066;
        Wed, 09 Jun 2021 14:36:49 -0700 (PDT)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com. [209.85.128.44])
        by smtp.gmail.com with ESMTPSA id n11sm306456ejg.43.2021.06.09.14.36.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 14:36:48 -0700 (PDT)
Received: by mail-wm1-f44.google.com with SMTP id l7-20020a05600c1d07b02901b0e2ebd6deso5121950wms.1
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 14:36:48 -0700 (PDT)
X-Received: by 2002:a7b:c935:: with SMTP id h21mr11765032wml.183.1623274607426;
 Wed, 09 Jun 2021 14:36:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210526082423.47837-1-mst@redhat.com> <CA+FuTScp-OhBnVzkXcsCBWxmq51VO6+8UGpSU5i3AJQV84eTLg@mail.gmail.com>
 <CA+FuTSf09nOJ=St4-3318oXy2ey0qRKkti8FvwheEUdiHSK0HA@mail.gmail.com>
In-Reply-To: <CA+FuTSf09nOJ=St4-3318oXy2ey0qRKkti8FvwheEUdiHSK0HA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 9 Jun 2021 17:36:09 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdrtsJpu2+ptT=6iUCnDH+1L1zgfT+1ggNC6kYcb5aTjg@mail.gmail.com>
Message-ID: <CA+FuTSdrtsJpu2+ptT=6iUCnDH+1L1zgfT+1ggNC6kYcb5aTjg@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] virtio net: spurious interrupt related fixes
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 10:53 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, May 26, 2021 at 11:34 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Wed, May 26, 2021 at 4:24 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > >
> > > With the implementation of napi-tx in virtio driver, we clean tx
> > > descriptors from rx napi handler, for the purpose of reducing tx
> > > complete interrupts. But this introduces a race where tx complete
> > > interrupt has been raised, but the handler finds there is no work to do
> > > because we have done the work in the previous rx interrupt handler.
> > > A similar issue exists with polling from start_xmit, it is however
> > > less common because of the delayed cb optimization of the split ring -
> > > but will likely affect the packed ring once that is more common.
> > >
> > > In particular, this was reported to lead to the following warning msg:
> > > [ 3588.010778] irq 38: nobody cared (try booting with the
> > > "irqpoll" option)
> > > [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> > > 5.3.0-19-generic #20~18.04.2-Ubuntu
> > > [ 3588.017940] Call Trace:
> > > [ 3588.017942]  <IRQ>
> > > [ 3588.017951]  dump_stack+0x63/0x85
> > > [ 3588.017953]  __report_bad_irq+0x35/0xc0
> > > [ 3588.017955]  note_interrupt+0x24b/0x2a0
> > > [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> > > [ 3588.017957]  handle_irq_event+0x3b/0x60
> > > [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> > > [ 3588.017961]  handle_irq+0x20/0x30
> > > [ 3588.017964]  do_IRQ+0x50/0xe0
> > > [ 3588.017966]  common_interrupt+0xf/0xf
> > > [ 3588.017966]  </IRQ>
> > > [ 3588.017989] handlers:
> > > [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> > > [ 3588.025099] Disabling IRQ #38
> > >
> > > This patchset attempts to fix this by cleaning up a bunch of races
> > > related to the handling of sq callbacks (aka tx interrupts).
> > > Somewhat tested but I couldn't reproduce the original issues
> > > reported, sending out for help with testing.
> > >
> > > Wei, does this address the spurious interrupt issue you are
> > > observing? Could you confirm please?
> >
> > Thanks for working on this, Michael. Wei is on leave. I'll try to reproduce.
>
> The original report was generated with five GCE virtual machines
> sharing a sole-tenant node, together sending up to 160 netperf
> tcp_stream connections to 16 other instances. Running Ubuntu 20.04-LTS
> with kernel 5.4.0-1034-gcp.
>
> But the issue can also be reproduced with just two n2-standard-16
> instances, running neper tcp_stream with high parallelism (-T 16 -F
> 240).
>
> It's a bit faster to trigger by reducing the interrupt count threshold
> from 99.9K/100K to 9.9K/10K. And I added additional logging to report
> the unhandled rate even if lower.
>
> Unhandled interrupt rate scales with the number of queue pairs
> (`ethtool -L $DEV combined $NUM`). It is essentially absent at 8
> queues, at around 90% at 14 queues. By default these GCE instances
> have one rx and tx interrupt per core, so 16 each. With the rx and tx
> interrupts for a given virtio-queue pinned to the same core.
>
> Unfortunately, commit 3/4 did not have a significant impact on these
> numbers. Have to think a bit more about possible mitigations. At least
> I'll be able to test the more easily now.

Continuing to experiment with approaches to avoid this interrupt disable.

I think it's good to remember that the real bug is the disabling of
interrupts, which may cause stalls in absence of receive events.

The spurious tx interrupts themselves are no worse than the processing
the tx and rx interrupts strictly separately without the optimization.
The clean-from-rx optimization just reduces latency. The spurious
interrupts indicate a cycle optimization opportunity for sure. I
support Jason's suggestion for a single combined interrupt for both tx
and rx. That is not feasible as a bugfix for stable, so we need something
to mitigate the impact in the short term.

For that, I suggest just an approach to maintain most benefit
from the opportunistic cleaning, while keeping spurious rate below the
threshold. A few variants:

1. In virtnet_poll_cleantx, a uniformly random draw on whether or not
to attemp to clean. Not trivial to get a good random source that is
essentially free. One example perhaps is sq->vq->num_free & 0x7, but
not sure how randomized those bits are. Pro: this can be implemented
strictly in virtio_net. Con: a probabilistic method will reduce the
incidence rate, but it may still occur at the tail.

2. If also changing virtio_ring, in vring_interrupt count spurious
interrupts and report this count through a new interface. Modify
virtio_net to query and skip the optimization if above a threshold.

2a. slight variant: in virtio_net count consecutive succesful
opportunistic cleaning operations. If 100% hit rate, then probably
the tx interrupts are all spurious. Temporarily back off. (virtio_net
is not called for interrupts if there is no work on the ring, so cannot
count these events independently itself).

3. Modify virtio_ring to explicitly allow opportunistic cleaning and
spurious interrupts on a per vring basis. Add a boolean to struct
vring_virtqueue. And return IRQ_HANDLED instead of IRQ_NONE for these
(only).

The first two patches in Michael's series, which ensure that all relevant
operations are executed with the tx lock held, perhaps shouldn't wait
on additional interrupt suppression / mitigation work.
