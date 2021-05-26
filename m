Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C12C391C22
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbhEZPhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 11:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235427AbhEZPhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:37:13 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C03C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 08:35:40 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id j10so2045784edw.8
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 08:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4i4/JADLLWuhSkK2wdVlLXgKR24CptL/t5AAz2nz3BU=;
        b=c6j7asrLfBobMaZJRUR3yBanPKdhLG/0NeIa5XZI8VeHu9RS9K/FneHMvfJthT5QWF
         1FDCpYdbe1syEsGKDCpGtxrRy6qurxgbW4rsuLP+50l/xjOndmiZzQx7HhOC1IpzbN0x
         CoErWnMSH/8e94+tviidtDTfMCIFnHt2xConTNAW8jfJbV+E/waUbs3m8aitUnSgk5P5
         rwjk6kblU7kXpKeWycq2MqQqr4KVVvPZHdp/0ZKbp5NZnColf4ibJr+/M1SoFtE4tiu2
         DR3padVCduXnyp++GsO0K8ALn8Sealsa+KcYR1SQYGSVmWb4qjwaoSs6eACcQvCYsGUv
         ia/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4i4/JADLLWuhSkK2wdVlLXgKR24CptL/t5AAz2nz3BU=;
        b=sOAKq8iY+KG+zjOFX9DLgqC8sjgiWGR4m0SE2wS4HzFk2xhvLmEY79ODyZx/e9KRMb
         452ygHHfVSIDOa2yN0WO0QfR83SgBqQ95TRgKXH6gYDuJEa53r8ARmQk+zW0jHXGOGyp
         Eiy0LS/rJBUogsaBbQ8yM5W5uFsgmRzG4Ej1qDe5Vv87Gu4nDdlVcWuxnR8VsP0Vwdu7
         So+b2CSMN30bAG3my5yGLBhWTWSMenV53ijPQOfxgS60MjSkzxQFxPLTftckK1CUaPgQ
         BEgr+C2rZdz2lDOzkNnEw7cRrcZjGqh3pyKcAkK2Dd9Lp2CxgV1eoEhWKrkfRBzZBsCm
         qokQ==
X-Gm-Message-State: AOAM533QJiMTDUsljTnGekwx4z+7v+QortmJ8Phko/hFt3ew2f1Qsnje
        BKkn52oXI9CrGD9FSm1jHcIdN+EP+Uk=
X-Google-Smtp-Source: ABdhPJye88WBapcRVsVKiCrYBjgT/hASO4otiBCQ32XgL1ZzVqmWsmmRjSTerlt6hlE4lDJevZnrDg==
X-Received: by 2002:a05:6402:176b:: with SMTP id da11mr38232798edb.234.1622043339030;
        Wed, 26 May 2021 08:35:39 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id a22sm10435304ejs.84.2021.05.26.08.35.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 08:35:37 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id x8so1587271wrq.9
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 08:35:37 -0700 (PDT)
X-Received: by 2002:a5d:64cf:: with SMTP id f15mr32482348wri.327.1622043336742;
 Wed, 26 May 2021 08:35:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210526082423.47837-1-mst@redhat.com>
In-Reply-To: <20210526082423.47837-1-mst@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 26 May 2021 11:34:58 -0400
X-Gmail-Original-Message-ID: <CA+FuTScp-OhBnVzkXcsCBWxmq51VO6+8UGpSU5i3AJQV84eTLg@mail.gmail.com>
Message-ID: <CA+FuTScp-OhBnVzkXcsCBWxmq51VO6+8UGpSU5i3AJQV84eTLg@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] virtio net: spurious interrupt related fixes
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 4:24 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
>
> With the implementation of napi-tx in virtio driver, we clean tx
> descriptors from rx napi handler, for the purpose of reducing tx
> complete interrupts. But this introduces a race where tx complete
> interrupt has been raised, but the handler finds there is no work to do
> because we have done the work in the previous rx interrupt handler.
> A similar issue exists with polling from start_xmit, it is however
> less common because of the delayed cb optimization of the split ring -
> but will likely affect the packed ring once that is more common.
>
> In particular, this was reported to lead to the following warning msg:
> [ 3588.010778] irq 38: nobody cared (try booting with the
> "irqpoll" option)
> [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> 5.3.0-19-generic #20~18.04.2-Ubuntu
> [ 3588.017940] Call Trace:
> [ 3588.017942]  <IRQ>
> [ 3588.017951]  dump_stack+0x63/0x85
> [ 3588.017953]  __report_bad_irq+0x35/0xc0
> [ 3588.017955]  note_interrupt+0x24b/0x2a0
> [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> [ 3588.017957]  handle_irq_event+0x3b/0x60
> [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> [ 3588.017961]  handle_irq+0x20/0x30
> [ 3588.017964]  do_IRQ+0x50/0xe0
> [ 3588.017966]  common_interrupt+0xf/0xf
> [ 3588.017966]  </IRQ>
> [ 3588.017989] handlers:
> [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> [ 3588.025099] Disabling IRQ #38
>
> This patchset attempts to fix this by cleaning up a bunch of races
> related to the handling of sq callbacks (aka tx interrupts).
> Somewhat tested but I couldn't reproduce the original issues
> reported, sending out for help with testing.
>
> Wei, does this address the spurious interrupt issue you are
> observing? Could you confirm please?

Thanks for working on this, Michael. Wei is on leave. I'll try to reproduce.

My main concern is whether the cost of the fix may be greater than the
race, if the additional locking may significantly impact
efficiency/throughput/latency. We lack that performance data right
now. The race had not been reported for years, and caused no real
concerns in the initial report we did get, either. That said, it may
be more problematic in specific scenarios, such as the packed rings
you pointed out.

One (additional) short term mitigation could be to further restrict
tx_napi default-on to exclude such scenarios.

Let me take a closer look at the individual patches.


>
> Thanks!
>
> changes from v2:
>         Fixed a race condition in start_xmit: enable_cb_delayed was
>         done as an optimization (to push out event index for
>         split ring) so we did not have to care about it
>         returning false (recheck). Now that we actually disable the cb
>         we have to do test the return value and do the actual recheck.
>
>
> Michael S. Tsirkin (4):
>   virtio_net: move tx vq operation under tx queue lock
>   virtio_net: move txq wakeups under tx q lock
>   virtio: fix up virtio_disable_cb
>   virtio_net: disable cb aggressively
>
>  drivers/net/virtio_net.c     | 49 ++++++++++++++++++++++++++++--------
>  drivers/virtio/virtio_ring.c | 26 ++++++++++++++++++-
>  2 files changed, 64 insertions(+), 11 deletions(-)
>
> --
> MST
>
