Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F8A30D026
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 01:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhBCAIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 19:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbhBCAIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 19:08:12 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5196C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 16:07:31 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id p20so12202774vsq.7
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 16:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZLsccFrIHE8oFBD81o9XFxPiN8lztYP+oWVJXY0bA70=;
        b=o5HAlWBHzHBR1jN6gQKE4t3a1ta5oVvI4HSjaA3jNfVPc3MV59d8iadcX3lrq8VNHP
         TDfjZeX0L6KbZdPoK8Caw1OaQXBAydptTLCvzY4fGR44MFQdbKM+avBvaDGQWhAh98F2
         rUz/nrMfaCKOzkH7i8hYhHYhs5/MAWsIzd+J6lHFTa5vMtyn8o3jbTI+X+nOxepJToeh
         pOHtZZnXF9i6rRnWrMn3L1AcJz29TuQ3779pGTvHs8bB8sjESsLvWZbTk5l9h02DH0xz
         7G6TW7P+8Z03d/J8mN5bcghqaMARDyHe5lkeJ3siS7UuPLe+/rzdhKQmyHyaz303tQzT
         y/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZLsccFrIHE8oFBD81o9XFxPiN8lztYP+oWVJXY0bA70=;
        b=szbqPsJXLCE6zj6cMnLrr1uI1HyRxMgZXmzkcMfb9YdLPSl7kiubDSqAuH+I2j1Fn6
         tpdJWfIIo6RneU7XHSSML9eGuwI8wkAlC8wspyLB5NnMWxO6C/E/e0TOBjUJUGz9jBhD
         Vl3n4L4bO9kMtmBaiDCBsLDWQDvlkK7B5Y6ueBWN5wVeRvB3ym5Bop6rr0aXqdUv1MUd
         CthH0YaznM/fwRZG5s63AyTtgUaW/iEadTzJhq0SQqXMdWram2PC0seWh0Qmxte0XPAK
         zF8zU3ej96c0wCX9icwy6fO5+z5l/CPT06e8fMaLjs/Dn80yx1BTBsxqkS1Bm2TOwqe6
         r0CA==
X-Gm-Message-State: AOAM532UzCR4rKp3MbBSH8qDzMVKjIPysTr6CNF9yZHWac65S/Vt+VO3
        GRTkfw5ko1G0r4V69ykkpc/tctLz3kGg8LsdIaFdRRyZFkhvZQ==
X-Google-Smtp-Source: ABdhPJz+088rQ2+WBrOxuwB6rZcbQNkROfuIXE7OxYzR6r6pfqgwI5t1p4xnT+ymdBMcFUodqk495JxrsffS0NVVtL8=
X-Received: by 2002:a67:cb1a:: with SMTP id b26mr274138vsl.22.1612310850805;
 Tue, 02 Feb 2021 16:07:30 -0800 (PST)
MIME-Version: 1.0
References: <20210129002136.70865-1-weiwan@google.com> <20210202180807-mutt-send-email-mst@kernel.org>
 <CAEA6p_Arqm2cgjc7rKibautqeVyxPkkMV7y20DU1sDaoCnLvzQ@mail.gmail.com> <CA+FuTSe-6MSpB4hwwvwPgDqHkxYJoxMZMDbOusNqiq0Gwa1eiQ@mail.gmail.com>
In-Reply-To: <CA+FuTSe-6MSpB4hwwvwPgDqHkxYJoxMZMDbOusNqiq0Gwa1eiQ@mail.gmail.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Tue, 2 Feb 2021 19:06:53 -0500
Message-ID: <CA+FuTSdkJcj_ikNnJmGadBZ1fa7q26MZ1g3ERf8Ax+YbXvgcng@mail.gmail.com>
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

On Tue, Feb 2, 2021 at 6:53 PM Willem de Bruijn <willemb@google.com> wrote:
>
> On Tue, Feb 2, 2021 at 6:47 PM Wei Wang <weiwan@google.com> wrote:
> >
> > On Tue, Feb 2, 2021 at 3:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Thu, Jan 28, 2021 at 04:21:36PM -0800, Wei Wang wrote:
> > > > With the implementation of napi-tx in virtio driver, we clean tx
> > > > descriptors from rx napi handler, for the purpose of reducing tx
> > > > complete interrupts. But this could introduce a race where tx complete
> > > > interrupt has been raised, but the handler found there is no work to do
> > > > because we have done the work in the previous rx interrupt handler.
> > > > This could lead to the following warning msg:
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
> > > > This patch adds a new param to struct vring_virtqueue, and we set it for
> > > > tx virtqueues if napi-tx is enabled, to suppress the warning in such
> > > > case.
> > > >
> > > > Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi")
> > > > Reported-by: Rick Jones <jonesrick@google.com>
> > > > Signed-off-by: Wei Wang <weiwan@google.com>
> > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > >
> > >
> > > This description does not make sense to me.
> > >
> > > irq X: nobody cared
> > > only triggers after an interrupt is unhandled repeatedly.
> > >
> > > So something causes a storm of useless tx interrupts here.
> > >
> > > Let's find out what it was please. What you are doing is
> > > just preventing linux from complaining.
> >
> > The traffic that causes this warning is a netperf tcp_stream with at
> > least 128 flows between 2 hosts. And the warning gets triggered on the
> > receiving host, which has a lot of rx interrupts firing on all queues,
> > and a few tx interrupts.
> > And I think the scenario is: when the tx interrupt gets fired, it gets
> > coalesced with the rx interrupt. Basically, the rx and tx interrupts
> > get triggered very close to each other, and gets handled in one round
> > of do_IRQ(). And the rx irq handler gets called first, which calls
> > virtnet_poll(). However, virtnet_poll() calls virtnet_poll_cleantx()
> > to try to do the work on the corresponding tx queue as well. That's
> > why when tx interrupt handler gets called, it sees no work to do.
> > And the reason for the rx handler to handle the tx work is here:
> > https://lists.linuxfoundation.org/pipermail/virtualization/2017-April/034740.html
>
> Indeed. It's not a storm necessarily. The warning occurs after one
> hundred such events, since boot, which is a small number compared real
> interrupt load.

Sorry, this is wrong. It is the other call to __report_bad_irq from
note_interrupt that applies here.

> Occasionally seeing an interrupt with no work is expected after
> 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi"). As
> long as this rate of events is very low compared to useful interrupts,
> and total interrupt count is greatly reduced vs not having work
> stealing, it is a net win.
