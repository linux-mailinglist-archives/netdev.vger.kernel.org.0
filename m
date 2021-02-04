Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCBF30FEC4
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhBDUtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhBDUtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 15:49:05 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E257CC0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 12:48:24 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id c8so1382928uae.13
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 12:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WHFhDe+wp14ydAMJQsCAOtxDAvzRUvWoj03qsINAbNU=;
        b=VI+4aHT6enALQkySTWA2qQrEBFtizPSCI55ptQ4sWY2L1/U0dgfsfKjYvrcHLzW3kq
         MPmLjyc4jXsJpr2UcULBP7w3R4Oa7RsTnOAuH+5SnjtkVQvqGzJr/x6a/3BRwIMDNw+z
         wHm28JUAYwOlAMgoh0A3lZzyLd8NjY/4r9toI8zwX1aafd2xmA4Ljazkk4lwi/+52+/w
         W9O2Q9uuBpfqnJc2vyGOMeI6Kbg9s69eaSFcEtFYDGJj6sRi1jMUe9f8wpa8UNa8I1zb
         716QdrpD1PFOJUKbs0rTloxT8h66gsC/jkjDmMcXbhwr+ilPc+pKoQ7XL0wMRKXz7QbB
         18Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WHFhDe+wp14ydAMJQsCAOtxDAvzRUvWoj03qsINAbNU=;
        b=S9ZmPw4DGsKyrBWLjh0cU3QOk8hZQJh5G54QSr92qeE50xvF9kdGQXZlqQKwa9HDMt
         ZSOprVKnwWpl84LkTZVrdy2qHYi/eJwO5CUuNutfVowSusnEJFqLXqihVFCNLM5x1ANN
         DV9RoQiqtnQp0p8Ygupc2owNQDiq4QWGSfPbdo6qOeI5GxTo6t4Xr7ferRfpxnE70jNs
         PnoSGqgnHonRdCOHLW9uYiquTw6QSkocc8xu3JdExIVHS+b4PsxmSURuPgCo4NTSOo2W
         rDGkxvEGwOamU/1XbByIc3+03BH96Htdoxl/7CafIYE0lNdPra9Bi4ZZ4xs992x1lABu
         J/YQ==
X-Gm-Message-State: AOAM5335fapg46dTgS6mP3MVRTyHhL7N0ufZZwekglWPXF1EM3Dn6rk+
        cjp8lsYoX3SG4wRP7y0KLyjjmn2Y7s4=
X-Google-Smtp-Source: ABdhPJx0+60SsW7SclwaIQ2W8C6MvDJApIMRnSsyQgjnWGUCx7K8DjeKnLeDcPTq2uVMV2uo/8kkHw==
X-Received: by 2002:ab0:3a91:: with SMTP id r17mr929422uaw.127.1612471703017;
        Thu, 04 Feb 2021 12:48:23 -0800 (PST)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com. [209.85.217.45])
        by smtp.gmail.com with ESMTPSA id g139sm855255vke.18.2021.02.04.12.48.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 12:48:21 -0800 (PST)
Received: by mail-vs1-f45.google.com with SMTP id l192so2476970vsd.5
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 12:48:21 -0800 (PST)
X-Received: by 2002:a67:fd74:: with SMTP id h20mr1071337vsa.51.1612471700741;
 Thu, 04 Feb 2021 12:48:20 -0800 (PST)
MIME-Version: 1.0
References: <20210129002136.70865-1-weiwan@google.com> <20210202180807-mutt-send-email-mst@kernel.org>
 <CAEA6p_Arqm2cgjc7rKibautqeVyxPkkMV7y20DU1sDaoCnLvzQ@mail.gmail.com>
 <CA+FuTSe-6MSpB4hwwvwPgDqHkxYJoxMZMDbOusNqiq0Gwa1eiQ@mail.gmail.com>
 <CA+FuTSdkJcj_ikNnJmGadBZ1fa7q26MZ1g3ERf8Ax+YbXvgcng@mail.gmail.com>
 <20210203052924-mutt-send-email-mst@kernel.org> <CAF=yD-J8rsr9JWdMGBSc-muFGMG2=YCWYwWOiQBQZuryioBUoA@mail.gmail.com>
 <20210203175837-mutt-send-email-mst@kernel.org> <CAEA6p_BqKECAU=C55TpJedG9gkZDakiiN27dcWOTJYH0YOFA_w@mail.gmail.com>
In-Reply-To: <CAEA6p_BqKECAU=C55TpJedG9gkZDakiiN27dcWOTJYH0YOFA_w@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 4 Feb 2021 15:47:44 -0500
X-Gmail-Original-Message-ID: <CA+FuTSf-uWyK6Jz=G67p+ep693oTczF55EUzrH9fXzBqTnoMQA@mail.gmail.com>
Message-ID: <CA+FuTSf-uWyK6Jz=G67p+ep693oTczF55EUzrH9fXzBqTnoMQA@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     Wei Wang <weiwan@google.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 6:53 PM Wei Wang <weiwan@google.com> wrote:
>
> On Wed, Feb 3, 2021 at 3:10 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Feb 03, 2021 at 01:24:08PM -0500, Willem de Bruijn wrote:
> > > On Wed, Feb 3, 2021 at 5:42 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Tue, Feb 02, 2021 at 07:06:53PM -0500, Willem de Bruijn wrote:
> > > > > On Tue, Feb 2, 2021 at 6:53 PM Willem de Bruijn <willemb@google.com> wrote:
> > > > > >
> > > > > > On Tue, Feb 2, 2021 at 6:47 PM Wei Wang <weiwan@google.com> wrote:
> > > > > > >
> > > > > > > On Tue, Feb 2, 2021 at 3:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Thu, Jan 28, 2021 at 04:21:36PM -0800, Wei Wang wrote:
> > > > > > > > > With the implementation of napi-tx in virtio driver, we clean tx
> > > > > > > > > descriptors from rx napi handler, for the purpose of reducing tx
> > > > > > > > > complete interrupts. But this could introduce a race where tx complete
> > > > > > > > > interrupt has been raised, but the handler found there is no work to do
> > > > > > > > > because we have done the work in the previous rx interrupt handler.
> > > > > > > > > This could lead to the following warning msg:
> > > > > > > > > [ 3588.010778] irq 38: nobody cared (try booting with the
> > > > > > > > > "irqpoll" option)
> > > > > > > > > [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> > > > > > > > > 5.3.0-19-generic #20~18.04.2-Ubuntu
> > > > > > > > > [ 3588.017940] Call Trace:
> > > > > > > > > [ 3588.017942]  <IRQ>
> > > > > > > > > [ 3588.017951]  dump_stack+0x63/0x85
> > > > > > > > > [ 3588.017953]  __report_bad_irq+0x35/0xc0
> > > > > > > > > [ 3588.017955]  note_interrupt+0x24b/0x2a0
> > > > > > > > > [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> > > > > > > > > [ 3588.017957]  handle_irq_event+0x3b/0x60
> > > > > > > > > [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> > > > > > > > > [ 3588.017961]  handle_irq+0x20/0x30
> > > > > > > > > [ 3588.017964]  do_IRQ+0x50/0xe0
> > > > > > > > > [ 3588.017966]  common_interrupt+0xf/0xf
> > > > > > > > > [ 3588.017966]  </IRQ>
> > > > > > > > > [ 3588.017989] handlers:
> > > > > > > > > [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> > > > > > > > > [ 3588.025099] Disabling IRQ #38
> > > > > > > > >
> > > > > > > > > This patch adds a new param to struct vring_virtqueue, and we set it for
> > > > > > > > > tx virtqueues if napi-tx is enabled, to suppress the warning in such
> > > > > > > > > case.
> > > > > > > > >
> > > > > > > > > Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi")
> > > > > > > > > Reported-by: Rick Jones <jonesrick@google.com>
> > > > > > > > > Signed-off-by: Wei Wang <weiwan@google.com>
> > > > > > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > > > > >
> > > > > > > >
> > > > > > > > This description does not make sense to me.
> > > > > > > >
> > > > > > > > irq X: nobody cared
> > > > > > > > only triggers after an interrupt is unhandled repeatedly.
> > > > > > > >
> > > > > > > > So something causes a storm of useless tx interrupts here.
> > > > > > > >
> > > > > > > > Let's find out what it was please. What you are doing is
> > > > > > > > just preventing linux from complaining.
> > > > > > >
> > > > > > > The traffic that causes this warning is a netperf tcp_stream with at
> > > > > > > least 128 flows between 2 hosts. And the warning gets triggered on the
> > > > > > > receiving host, which has a lot of rx interrupts firing on all queues,
> > > > > > > and a few tx interrupts.
> > > > > > > And I think the scenario is: when the tx interrupt gets fired, it gets
> > > > > > > coalesced with the rx interrupt. Basically, the rx and tx interrupts
> > > > > > > get triggered very close to each other, and gets handled in one round
> > > > > > > of do_IRQ(). And the rx irq handler gets called first, which calls
> > > > > > > virtnet_poll(). However, virtnet_poll() calls virtnet_poll_cleantx()
> > > > > > > to try to do the work on the corresponding tx queue as well. That's
> > > > > > > why when tx interrupt handler gets called, it sees no work to do.
> > > > > > > And the reason for the rx handler to handle the tx work is here:
> > > > > > > https://lists.linuxfoundation.org/pipermail/virtualization/2017-April/034740.html
> > > > > >
> > > > > > Indeed. It's not a storm necessarily. The warning occurs after one
> > > > > > hundred such events, since boot, which is a small number compared real
> > > > > > interrupt load.
> > > > >
> > > > > Sorry, this is wrong. It is the other call to __report_bad_irq from
> > > > > note_interrupt that applies here.
> > > > >
> > > > > > Occasionally seeing an interrupt with no work is expected after
> > > > > > 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi"). As
> > > > > > long as this rate of events is very low compared to useful interrupts,
> > > > > > and total interrupt count is greatly reduced vs not having work
> > > > > > stealing, it is a net win.
> > > >
> > > > Right, but if 99900 out of 100000 interrupts were wasted, then it is
> > > > surely an even greater win to disable interrupts while polling like
> > > > this.  Might be tricky to detect, disabling/enabling aggressively every
> > > > time even if there's nothing in the queue is sure to cause lots of cache
> > > > line bounces, and we don't want to enable callbacks if they were not
> > > > enabled e.g. by start_xmit ...  Some kind of counter?
> > >
> > > Yes. It was known that the work stealing is more effective in some
> > > workloads than others. But a 99% spurious rate I had not anticipated.
> > >
> > > Most interesting is the number of interrupts suppressed as a result of
> > > the feature. That is not captured by this statistic.
> > >
> > > In any case, we'll take a step back to better understand behavior. And
> > > especially why this high spurious rate exhibits in this workload with
> > > many concurrent flows.
> >
> >
> > I've been thinking about it. Imagine work stealing working perfectly.
> > Each time we xmit a packet, it is stolen and freed.
> > Since xmit enables callbacks (just in case!) we also
> > get an interrupt, which is automatically spurious.
> >
> > My conclusion is that we shouldn't just work around it but instead
> > (or additionally?)
> > reduce the number of interrupts by disabling callbacks e.g. when
> > a. we are currently stealing packets
> > or
> > b. we stole all packets

Agreed. This might prove a significant performance gain at the same time :)

> >
> Thinking along this line, that probably means, we should disable cb on
> the tx virtqueue, when scheduling the napi work on the rx side, and
> reenable it after the rx napi work is done?
> Also, I wonder if it is too late to disable cb at the point we start
> to steal pkts or have stolen all pkts.

The earlier the better. I see no benefit to delay until the rx handler
actually runs.

> Because the steal work is done
> in the napi handler of the rx queue. But the tx interrupt must have
> been raised before that. Will we come back to process the tx interrupt
> again after we re-enabled the cb on the tx side?
>
> > This should be enough to reduce the chances below 99% ;)
> >
> > One annoying thing is that with split and event index, we do not disable
> > interrupts. Could be worth revisiting, for now maybe just disable the
> > event index feature? I am not sure it is actually worth it with
> > stealing.

With event index, we suppress interrupts when another interrupt is
already pending from a previous packet, right? When the previous
position of the producer is already beyond the consumer. It doesn't
matter whether the previous packet triggered a tx interrupt or
deferred to an already scheduled rx interrupt? From that seems fine to
leave it out.
