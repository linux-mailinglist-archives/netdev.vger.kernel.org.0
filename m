Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C55396BA2
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 04:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhFACzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 22:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbhFACzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 22:55:48 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF392C061574
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 19:54:06 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y7so15487403eda.2
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 19:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=knN8PuwxMBMRUW0OyIkUMzniIsTf65LkkSfLXCcSzrY=;
        b=SvSffryegS+ysrvJelHxE0GDMIqYsiauOEAlrh+QIGJ4/aDIqhLCDQp2geMHP0p4EI
         o4sGgoCoODwCdY8h/iz7IjvTCxCzB07KIFYilnJ0a2ObrIdreIO9MOhx0UqE1X2eGufH
         /r7H7u+lQ2oOsS7H1+vMdNDI2SzPH6XNLpEIxDThc/aaGQSl61QvOXHwZ1dz4Q6RA7ee
         dqNy10UwQqXOMlDaCRQ13VjmQu/cFkSAcxY7UWJ43rVbLw/DyyxRYIch12GlLQr6yLHn
         wBDhSj5MCRhSyWb2Cpg1ZmjCvQoC5IFHyff1F4lSqgNZZASoNgUJ94Qku7CmF9xnUrWC
         p2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=knN8PuwxMBMRUW0OyIkUMzniIsTf65LkkSfLXCcSzrY=;
        b=tin09ojrUgJK80VGlkQM0oAEHHD+VPtV1EYE21xrdyetOOk/lJrXmXl4+DcgqKtMip
         M6YbyB00VeDKwXs4j7OvYfjH3ki+xP/6qr9dlHau8GvCM2pKNeT+z9c0UM/JyybXbuQh
         sb/XmIcetuyhBLa8oaSHevuZ6n5qMU44kVKF6TWDWRt83BeFjuZpJZdNjCDlrNZ2e/4N
         Ew4qfvmIpEwWY9lgSD9a726lZgXJKvlZkKRoShpa6Ao3xAQlXz1uvb4FHUUb9kO7yHrv
         dCmt1FKfHU5tLDIrp6rI6gURYcUHdcTd3xwQVZrRjCL5iFtxyLIaSBPYluGqeP0tqFVM
         NbNA==
X-Gm-Message-State: AOAM531+YRXlRhg2gnjrBjeqQW9cH3akT2ooosQfdp6YAuP2wtmaJ2+1
        4rD96z3l+c5RdesarBwUv1gfSasdR+687w==
X-Google-Smtp-Source: ABdhPJwSQGTKXA5gPWxR8c89cIiyA0esEKIxA3Y3hmKj+RiEFZ3gzg0bOJP4iy66kzjLBcXPUZQMFQ==
X-Received: by 2002:aa7:c445:: with SMTP id n5mr9550088edr.64.1622516045109;
        Mon, 31 May 2021 19:54:05 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id de19sm421967edb.70.2021.05.31.19.54.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 19:54:03 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id z8so7478782wrp.12
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 19:54:02 -0700 (PDT)
X-Received: by 2002:adf:fa04:: with SMTP id m4mt4367695wrr.275.1622516042429;
 Mon, 31 May 2021 19:54:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210526082423.47837-1-mst@redhat.com> <CA+FuTScp-OhBnVzkXcsCBWxmq51VO6+8UGpSU5i3AJQV84eTLg@mail.gmail.com>
In-Reply-To: <CA+FuTScp-OhBnVzkXcsCBWxmq51VO6+8UGpSU5i3AJQV84eTLg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 31 May 2021 22:53:26 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf09nOJ=St4-3318oXy2ey0qRKkti8FvwheEUdiHSK0HA@mail.gmail.com>
Message-ID: <CA+FuTSf09nOJ=St4-3318oXy2ey0qRKkti8FvwheEUdiHSK0HA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] virtio net: spurious interrupt related fixes
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 11:34 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, May 26, 2021 at 4:24 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> >
> > With the implementation of napi-tx in virtio driver, we clean tx
> > descriptors from rx napi handler, for the purpose of reducing tx
> > complete interrupts. But this introduces a race where tx complete
> > interrupt has been raised, but the handler finds there is no work to do
> > because we have done the work in the previous rx interrupt handler.
> > A similar issue exists with polling from start_xmit, it is however
> > less common because of the delayed cb optimization of the split ring -
> > but will likely affect the packed ring once that is more common.
> >
> > In particular, this was reported to lead to the following warning msg:
> > [ 3588.010778] irq 38: nobody cared (try booting with the
> > "irqpoll" option)
> > [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> > 5.3.0-19-generic #20~18.04.2-Ubuntu
> > [ 3588.017940] Call Trace:
> > [ 3588.017942]  <IRQ>
> > [ 3588.017951]  dump_stack+0x63/0x85
> > [ 3588.017953]  __report_bad_irq+0x35/0xc0
> > [ 3588.017955]  note_interrupt+0x24b/0x2a0
> > [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> > [ 3588.017957]  handle_irq_event+0x3b/0x60
> > [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> > [ 3588.017961]  handle_irq+0x20/0x30
> > [ 3588.017964]  do_IRQ+0x50/0xe0
> > [ 3588.017966]  common_interrupt+0xf/0xf
> > [ 3588.017966]  </IRQ>
> > [ 3588.017989] handlers:
> > [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> > [ 3588.025099] Disabling IRQ #38
> >
> > This patchset attempts to fix this by cleaning up a bunch of races
> > related to the handling of sq callbacks (aka tx interrupts).
> > Somewhat tested but I couldn't reproduce the original issues
> > reported, sending out for help with testing.
> >
> > Wei, does this address the spurious interrupt issue you are
> > observing? Could you confirm please?
>
> Thanks for working on this, Michael. Wei is on leave. I'll try to reproduce.

The original report was generated with five GCE virtual machines
sharing a sole-tenant node, together sending up to 160 netperf
tcp_stream connections to 16 other instances. Running Ubuntu 20.04-LTS
with kernel 5.4.0-1034-gcp.

But the issue can also be reproduced with just two n2-standard-16
instances, running neper tcp_stream with high parallelism (-T 16 -F
240).

It's a bit faster to trigger by reducing the interrupt count threshold
from 99.9K/100K to 9.9K/10K. And I added additional logging to report
the unhandled rate even if lower.

Unhandled interrupt rate scales with the number of queue pairs
(`ethtool -L $DEV combined $NUM`). It is essentially absent at 8
queues, at around 90% at 14 queues. By default these GCE instances
have one rx and tx interrupt per core, so 16 each. With the rx and tx
interrupts for a given virtio-queue pinned to the same core.

Unfortunately, commit 3/4 did not have a significant impact on these
numbers. Have to think a bit more about possible mitigations. At least
I'll be able to test the more easily now.
