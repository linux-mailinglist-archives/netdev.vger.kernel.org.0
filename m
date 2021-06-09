Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91773A2075
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 01:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhFIXDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 19:03:02 -0400
Received: from mail-ej1-f51.google.com ([209.85.218.51]:36624 "EHLO
        mail-ej1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhFIXDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 19:03:01 -0400
Received: by mail-ej1-f51.google.com with SMTP id a11so40163969ejf.3
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 16:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S1+IDDRbCFrBM2Nt4FPi8XniHqz+yQsLuHjCR6gz92Q=;
        b=MCXQZxDcrPByXTk9JZhyK06vZosVVwKbmpLXxNm8i2jPgPizScpNHqGPllc6KnjhjD
         +BUjPCY1uFMhdUopHQgkHFkPHGm6l110bbbVSUQOjq833YMsOf/D6rcSny2ew9Gjibrg
         cQYjMivM8mETDv474BXqLgFtwUXv4Zf2f+ELH4TIbkBu4NMkOS8eJnWgSkUeu521t4ln
         xyNsH5MWHZiV4d/3mkjK0VeowtpEsNSd0P5ZP60bu0VHXIeFE9k8N6mhdIdL0dMF6JSz
         XL1I6RZp8lxpLLrHPrYX0yxAHtAOC5uu14MqcgyOLruSjKFnfyw/xRA33IwgOgWD74Q+
         sxuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S1+IDDRbCFrBM2Nt4FPi8XniHqz+yQsLuHjCR6gz92Q=;
        b=PZ6c9TRwg55YjpfFt2eKcaNEGdynSAoAYoaRtRNIxCEJCe38lzMObOVGw/Gpf1wgrt
         GMxHc3fbQvwzWCPNEtQTBaD2ufk6ezxoFpI24poU+XOOluEiwenVfA6rcrJj+2ucHd9e
         5GnQH7ArWu/N1ThZ8Ze+IWYWyasNzQPVqK5C0Ef8eRAvuVkghDQmipUZ4lbks0ZLmDLk
         93CZ/RkNlH+cUlLNolMnmn++jb+Q+i9nihrwrIRTCVoVPN4bmcg68CNSjOT/2pSzV2Oq
         FeOVwae3UWHJ6hu9Fd7an1V7gga2w/9l0Rs6KIygGZqcSS+dn6NpeHmJ4GFLBg9j6Oir
         ming==
X-Gm-Message-State: AOAM53232Aeo+8FKNGAMYzO3DEouYHFbFeM7QoozMs53kh8CH31WQ8l5
        1VwoWq8CVVn8eNe0RrDXVUJjmy3Dq8zRAw==
X-Google-Smtp-Source: ABdhPJy1By13ISyLAnXjsAOnyFE4hAGuaTAY2LB3D+Aj8TrfW2NtOSYyy6FXeUF3DXohZJVAyQ6l4Q==
X-Received: by 2002:a17:906:cc14:: with SMTP id ml20mr1843210ejb.515.1623279598171;
        Wed, 09 Jun 2021 15:59:58 -0700 (PDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com. [209.85.128.52])
        by smtp.gmail.com with ESMTPSA id rl12sm334839ejb.94.2021.06.09.15.59.57
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 15:59:57 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id f16-20020a05600c1550b02901b00c1be4abso5323033wmg.2
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 15:59:57 -0700 (PDT)
X-Received: by 2002:a1c:2456:: with SMTP id k83mr2012948wmk.87.1623279596725;
 Wed, 09 Jun 2021 15:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210526082423.47837-1-mst@redhat.com> <CA+FuTScp-OhBnVzkXcsCBWxmq51VO6+8UGpSU5i3AJQV84eTLg@mail.gmail.com>
 <CA+FuTSf09nOJ=St4-3318oXy2ey0qRKkti8FvwheEUdiHSK0HA@mail.gmail.com> <CA+FuTSdrtsJpu2+ptT=6iUCnDH+1L1zgfT+1ggNC6kYcb5aTjg@mail.gmail.com>
In-Reply-To: <CA+FuTSdrtsJpu2+ptT=6iUCnDH+1L1zgfT+1ggNC6kYcb5aTjg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 9 Jun 2021 18:59:18 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdviQGFx8p0VNb2A=Fzk_1wR5aQYmAnMKXf_96eXNXvZg@mail.gmail.com>
Message-ID: <CA+FuTSdviQGFx8p0VNb2A=Fzk_1wR5aQYmAnMKXf_96eXNXvZg@mail.gmail.com>
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

On Wed, Jun 9, 2021 at 5:36 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, May 31, 2021 at 10:53 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Wed, May 26, 2021 at 11:34 AM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Wed, May 26, 2021 at 4:24 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > >
> > > > With the implementation of napi-tx in virtio driver, we clean tx
> > > > descriptors from rx napi handler, for the purpose of reducing tx
> > > > complete interrupts. But this introduces a race where tx complete
> > > > interrupt has been raised, but the handler finds there is no work to do
> > > > because we have done the work in the previous rx interrupt handler.
> > > > A similar issue exists with polling from start_xmit, it is however
> > > > less common because of the delayed cb optimization of the split ring -
> > > > but will likely affect the packed ring once that is more common.
> > > >
> > > > In particular, this was reported to lead to the following warning msg:
> > > > [ 3588.010778] irq 38: nobody cared (try booting with the
> > > > "irqpoll" option)
> > > > [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> > > > 5.3.0-19-generic #20~18.04.2-Ubuntu
> > > > [ 3588.017940] Call Trace:
> > > > [ 3588.017942]  <IRQ>
> > > > [ 3588.017951]  dump_stack+0x63/0x85
> > > > [ 3588.017953]  __report_bad_irq+0x35/0xc0
> > > > [ 3588.017955]  note_interrupt+0x24b/0x2a0
> > > > [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> > > > [ 3588.017957]  handle_irq_event+0x3b/0x60
> > > > [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> > > > [ 3588.017961]  handle_irq+0x20/0x30
> > > > [ 3588.017964]  do_IRQ+0x50/0xe0
> > > > [ 3588.017966]  common_interrupt+0xf/0xf
> > > > [ 3588.017966]  </IRQ>
> > > > [ 3588.017989] handlers:
> > > > [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> > > > [ 3588.025099] Disabling IRQ #38
> > > >
> > > > This patchset attempts to fix this by cleaning up a bunch of races
> > > > related to the handling of sq callbacks (aka tx interrupts).
> > > > Somewhat tested but I couldn't reproduce the original issues
> > > > reported, sending out for help with testing.
> > > >
> > > > Wei, does this address the spurious interrupt issue you are
> > > > observing? Could you confirm please?
> > >
> > > Thanks for working on this, Michael. Wei is on leave. I'll try to reproduce.
> >
> > The original report was generated with five GCE virtual machines
> > sharing a sole-tenant node, together sending up to 160 netperf
> > tcp_stream connections to 16 other instances. Running Ubuntu 20.04-LTS
> > with kernel 5.4.0-1034-gcp.
> >
> > But the issue can also be reproduced with just two n2-standard-16
> > instances, running neper tcp_stream with high parallelism (-T 16 -F
> > 240).
> >
> > It's a bit faster to trigger by reducing the interrupt count threshold
> > from 99.9K/100K to 9.9K/10K. And I added additional logging to report
> > the unhandled rate even if lower.
> >
> > Unhandled interrupt rate scales with the number of queue pairs
> > (`ethtool -L $DEV combined $NUM`). It is essentially absent at 8
> > queues, at around 90% at 14 queues. By default these GCE instances
> > have one rx and tx interrupt per core, so 16 each. With the rx and tx
> > interrupts for a given virtio-queue pinned to the same core.
> >
> > Unfortunately, commit 3/4 did not have a significant impact on these
> > numbers. Have to think a bit more about possible mitigations. At least
> > I'll be able to test the more easily now.
>
> Continuing to experiment with approaches to avoid this interrupt disable.
>
> I think it's good to remember that the real bug is the disabling of
> interrupts, which may cause stalls in absence of receive events.
>
> The spurious tx interrupts themselves are no worse than the processing
> the tx and rx interrupts strictly separately without the optimization.
> The clean-from-rx optimization just reduces latency. The spurious
> interrupts indicate a cycle optimization opportunity for sure. I
> support Jason's suggestion for a single combined interrupt for both tx
> and rx. That is not feasible as a bugfix for stable, so we need something
> to mitigate the impact in the short term.
>
> For that, I suggest just an approach to maintain most benefit
> from the opportunistic cleaning, while keeping spurious rate below the
> threshold. A few variants:
>
> 1. In virtnet_poll_cleantx, a uniformly random draw on whether or not
> to attemp to clean. Not trivial to get a good random source that is
> essentially free. One example perhaps is sq->vq->num_free & 0x7, but
> not sure how randomized those bits are. Pro: this can be implemented
> strictly in virtio_net. Con: a probabilistic method will reduce the
> incidence rate, but it may still occur at the tail.
>
> 2. If also changing virtio_ring, in vring_interrupt count spurious
> interrupts and report this count through a new interface. Modify
> virtio_net to query and skip the optimization if above a threshold.
>
> 2a. slight variant: in virtio_net count consecutive succesful
> opportunistic cleaning operations. If 100% hit rate, then probably
> the tx interrupts are all spurious. Temporarily back off. (virtio_net
> is not called for interrupts if there is no work on the ring, so cannot
> count these events independently itself).
>
> 3. Modify virtio_ring to explicitly allow opportunistic cleaning and
> spurious interrupts on a per vring basis. Add a boolean to struct
> vring_virtqueue. And return IRQ_HANDLED instead of IRQ_NONE for these
> (only).
>
> The first two patches in Michael's series, which ensure that all relevant
> operations are executed with the tx lock held, perhaps shouldn't wait
> on additional interrupt suppression / mitigation work.

I forgot to mention: virtio_net cannot configure interrupt moderation through
ethtool. But to reduce interrupt rate, it may also be interesting to use try
/sys/class/net/$DEV/gro_flush_timeout. To mask the device interrupts and
instead wait on a kernel timer for some usec, to increase batching.
