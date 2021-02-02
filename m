Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835C730D007
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 00:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhBBXy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 18:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhBBXy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 18:54:26 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5661EC061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 15:53:46 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id i3so7729160uai.3
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 15:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cm7L1jZk+Tf7J/h07KS7GnOlEfqLg4cva7Z3zCdMTY4=;
        b=jBXIRqXExCsb7BMuPyJTN0QMqH7++VqtQGfXTa2TM7GejL5jBiyxlf3ztuTJvCxCve
         dBr2I5p0Gy9rPfxC+JBF878DOXbZCW1LYq06xdUyCfU28Bgs1gDArYKTQprZpZSTwPuD
         2H0QGY3Cg0VLJlpKdQj3Sq8eJMn6wVFxhJNlNpNz7sAyRaP+yaOBXqeQSyye2RRPSBLE
         P8cINF0AJMazIrASa4iCvaIzWdbMeZNe1YWZZlIoRXnxShWyrd1HZ31tTXNVV8GdBT1O
         KVQiO6Kn8uaq9jDKMg7av5/bxBco2tm3XsgBF43EFkYA4m6cNTpsau5a+QWZFnECNpJ3
         YzWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cm7L1jZk+Tf7J/h07KS7GnOlEfqLg4cva7Z3zCdMTY4=;
        b=YGRWCgVtHJH390MOLorn3Ru9j1SbxPvsqcheAfCEB5hO2puyXiX20qjkZnnCUV3pbf
         ixlcbtCEedEFFzIYZ4HyC7JCJKumyypByzFWp0zK0BWS1nH8gr+dY7wqQf+XVgRPjKOZ
         4zaya+Xvbe0+e+vsWgvejNK0S6DhmRDy+AltKGc43v44ogD3kxFhPjSm3OkR94lIGYe2
         LREJ0RPXhdgJfHyRCN7Nfau10DEm7mLSdoVtf20JiZxRFYmIRfsDDXYBkbYJd9ADOVUT
         ncF4z3JQBnJVxfxS7EYlYG06Pb5lF4EQPmq7Mt96xdzBaotFIyUEM0gRkiUuphTTpXRt
         LzoQ==
X-Gm-Message-State: AOAM531FPHGlAaTAbMyq7W3mm01JPOnqEUcxAjkOW4S+v5bD3MWqgDed
        tqjsEZ/wGigN9hBXBqPsrvNRGvzeV95S9ohrr1Ue6g==
X-Google-Smtp-Source: ABdhPJxE06Dp83rE1cqhgQ2rJ6UJGQ4Z/aL4FZ1B7UO+kjLCVtyANhxSivF6fZBwaqY6aRJM02AZHck+27ObY4jVzOc=
X-Received: by 2002:a9f:2a8e:: with SMTP id z14mr388542uai.122.1612310025288;
 Tue, 02 Feb 2021 15:53:45 -0800 (PST)
MIME-Version: 1.0
References: <20210129002136.70865-1-weiwan@google.com> <20210202180807-mutt-send-email-mst@kernel.org>
 <CAEA6p_Arqm2cgjc7rKibautqeVyxPkkMV7y20DU1sDaoCnLvzQ@mail.gmail.com>
In-Reply-To: <CAEA6p_Arqm2cgjc7rKibautqeVyxPkkMV7y20DU1sDaoCnLvzQ@mail.gmail.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Tue, 2 Feb 2021 18:53:08 -0500
Message-ID: <CA+FuTSe-6MSpB4hwwvwPgDqHkxYJoxMZMDbOusNqiq0Gwa1eiQ@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     Wei Wang <weiwan@google.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 6:47 PM Wei Wang <weiwan@google.com> wrote:
>
> On Tue, Feb 2, 2021 at 3:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, Jan 28, 2021 at 04:21:36PM -0800, Wei Wang wrote:
> > > With the implementation of napi-tx in virtio driver, we clean tx
> > > descriptors from rx napi handler, for the purpose of reducing tx
> > > complete interrupts. But this could introduce a race where tx complete
> > > interrupt has been raised, but the handler found there is no work to do
> > > because we have done the work in the previous rx interrupt handler.
> > > This could lead to the following warning msg:
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
> > > This patch adds a new param to struct vring_virtqueue, and we set it for
> > > tx virtqueues if napi-tx is enabled, to suppress the warning in such
> > > case.
> > >
> > > Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi")
> > > Reported-by: Rick Jones <jonesrick@google.com>
> > > Signed-off-by: Wei Wang <weiwan@google.com>
> > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> >
> >
> > This description does not make sense to me.
> >
> > irq X: nobody cared
> > only triggers after an interrupt is unhandled repeatedly.
> >
> > So something causes a storm of useless tx interrupts here.
> >
> > Let's find out what it was please. What you are doing is
> > just preventing linux from complaining.
>
> The traffic that causes this warning is a netperf tcp_stream with at
> least 128 flows between 2 hosts. And the warning gets triggered on the
> receiving host, which has a lot of rx interrupts firing on all queues,
> and a few tx interrupts.
> And I think the scenario is: when the tx interrupt gets fired, it gets
> coalesced with the rx interrupt. Basically, the rx and tx interrupts
> get triggered very close to each other, and gets handled in one round
> of do_IRQ(). And the rx irq handler gets called first, which calls
> virtnet_poll(). However, virtnet_poll() calls virtnet_poll_cleantx()
> to try to do the work on the corresponding tx queue as well. That's
> why when tx interrupt handler gets called, it sees no work to do.
> And the reason for the rx handler to handle the tx work is here:
> https://lists.linuxfoundation.org/pipermail/virtualization/2017-April/034740.html

Indeed. It's not a storm necessarily. The warning occurs after one
hundred such events, since boot, which is a small number compared real
interrupt load.

Occasionally seeing an interrupt with no work is expected after
7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi"). As
long as this rate of events is very low compared to useful interrupts,
and total interrupt count is greatly reduced vs not having work
stealing, it is a net win.
