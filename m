Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B118545881C
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 03:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhKVCv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 21:51:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52605 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232064AbhKVCvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 21:51:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637549329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bCpHgtK0TLoUoBYAl3rKsWf4v1EviHMP7QNyo8Nuefw=;
        b=eO+1y7hhModGV9J3rCIiD4km7JibIdbZZuGNesyTUYp9O2diAMjY9NNPWCPSJ9zjAtt/zq
        m69MjJaXNRamcy/qs+jqxc7OKpN2L4HvzGIQ3luNRJaURioCf1wjdcBwqNLj1/0+rUhVpa
        0LvMbtdTPZf/y4b17XXwn/Q6Po+AktQ=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-DY1j5APpN_WEYomKdlEF4Q-1; Sun, 21 Nov 2021 21:48:48 -0500
X-MC-Unique: DY1j5APpN_WEYomKdlEF4Q-1
Received: by mail-lf1-f70.google.com with SMTP id b23-20020a0565120b9700b00403a044bfcdso10971758lfv.13
        for <netdev@vger.kernel.org>; Sun, 21 Nov 2021 18:48:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bCpHgtK0TLoUoBYAl3rKsWf4v1EviHMP7QNyo8Nuefw=;
        b=TFYoDitbRTjI9bFLxoMmTMoIN+43vEZCHo10GyeHq0zX1l1CiAeTl0/ZgA4As62adV
         et9WCqHYrp5YrHgfQnTH2UXDsh0G6FGuFXubbtms+wbVmKPKx9Q8+9icX8UbKWMP9da4
         6/NHI/nYV8q0pn3nBcDZpd7+71CNZMBBaB+OusBYh9waf6zQOuWvo3ozMIIVqfRmwMKO
         bqbvlTE9ltYyWnUZwO98Gc3QUu/xJV/FRAjqceD+10WfK3jW629RzKfb2L48NeHaQ/da
         S6p4xLw2qlSsZes8YSblhbQuDsqn3OCPjhzMwh3ZPZ273Su5NFhDwC2q6yaF6WwF8UWo
         NVVA==
X-Gm-Message-State: AOAM533qriJodGvCH2yWRFiRm1lfB4nX6J67V2aqFA2kQX5FYnqCAHMQ
        prqxjOXrguaAiZCZZlrBlQeiIytBruHmMvTyIdWf3zZGuTnW7Gnw2Qf6cNpbcNiencmn+aTAVCT
        ejzUsyHPPIb/yfzTTodgwxOx1Tzp4Syqe
X-Received: by 2002:a2e:3012:: with SMTP id w18mr47494881ljw.217.1637549326835;
        Sun, 21 Nov 2021 18:48:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzhMUoYJy/fa5HNf3Y1dZw9n8WaAFEGalW9iZHLhJvk00Yldk6U6avgseBmGbi5f8k7IKQdMCJIgKYGrl1mobY=
X-Received: by 2002:a2e:3012:: with SMTP id w18mr47494851ljw.217.1637549326643;
 Sun, 21 Nov 2021 18:48:46 -0800 (PST)
MIME-Version: 1.0
References: <20211115153003.9140-1-arbn@yandex-team.com> <20211115153003.9140-6-arbn@yandex-team.com>
 <CACGkMEumax9RFVNgWLv5GyoeQAmwo-UgAq=DrUd4yLxPAUUqBw@mail.gmail.com> <b163233f-090f-baaf-4460-37978cab4d55@yandex-team.com>
In-Reply-To: <b163233f-090f-baaf-4460-37978cab4d55@yandex-team.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 22 Nov 2021 10:48:35 +0800
Message-ID: <CACGkMEuNhRf8_nhAsJ68J4HFxGJcnjNyA8ZyktNcBhNGfSafmA@mail.gmail.com>
Subject: Re: [PATCH 6/6] vhost_net: use RCU callbacks instead of synchronize_rcu()
To:     Andrey Ryabinin <arbn@yandex-team.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 7:31 PM Andrey Ryabinin <arbn@yandex-team.com> wrote:
>
>
>
> On 11/16/21 8:00 AM, Jason Wang wrote:
> > On Mon, Nov 15, 2021 at 11:32 PM Andrey Ryabinin <arbn@yandex-team.com> wrote:
> >>
> >> Currently vhost_net_release() uses synchronize_rcu() to synchronize
> >> freeing with vhost_zerocopy_callback(). However synchronize_rcu()
> >> is quite costly operation. It take more than 10 seconds
> >> to shutdown qemu launched with couple net devices like this:
> >>         -netdev tap,id=tap0,..,vhost=on,queues=80
> >> because we end up calling synchronize_rcu() netdev_count*queues times.
> >>
> >> Free vhost net structures in rcu callback instead of using
> >> synchronize_rcu() to fix the problem.
> >
> > I admit the release code is somehow hard to understand. But I wonder
> > if the following case can still happen with this:
> >
> > CPU 0 (vhost_dev_cleanup)   CPU1
> > (vhost_net_zerocopy_callback()->vhost_work_queue())
> >                                                 if (!dev->worker)
> > dev->worker = NULL
> >
> > wake_up_process(dev->worker)
> >
> > If this is true. It seems the fix is to move RCU synchronization stuff
> > in vhost_net_ubuf_put_and_wait()?
> >
>
> It all depends whether vhost_zerocopy_callback() can be called outside of vhost
> thread context or not.

I think the answer is yes, the callback will be mainly used in the
zerocopy path when the underlayer NIC finishes the DMA of a packet.

> If it can run after vhost thread stopped, than the race you
> describe seems possible and the fix in commit b0c057ca7e83 ("vhost: fix a theoretical race in device cleanup")
> wasn't complete. I would fix it by calling synchronize_rcu() after vhost_net_flush()
> and before vhost_dev_cleanup().
>
> As for the performance problem, it can be solved by replacing synchronize_rcu() with synchronize_rcu_expedited().

Yes, that's another way, but see below.

>
> But now I'm not sure that this race is actually exists and that synchronize_rcu() needed at all.
> I did a bit of testing and I only see callback being called from vhost thread:
>
> vhost-3724  3733 [002]  2701.768731: probe:vhost_zerocopy_callback: (ffffffff81af8c10)
>         ffffffff81af8c11 vhost_zerocopy_callback+0x1 ([kernel.kallsyms])
>         ffffffff81bb34f6 skb_copy_ubufs+0x256 ([kernel.kallsyms])
>         ffffffff81bce621 __netif_receive_skb_core.constprop.0+0xac1 ([kernel.kallsyms])
>         ffffffff81bd062d __netif_receive_skb_one_core+0x3d ([kernel.kallsyms])
>         ffffffff81bd0748 netif_receive_skb+0x38 ([kernel.kallsyms])
>         ffffffff819a2a1e tun_get_user+0xdce ([kernel.kallsyms])
>         ffffffff819a2cf4 tun_sendmsg+0xa4 ([kernel.kallsyms])
>         ffffffff81af9229 handle_tx_zerocopy+0x149 ([kernel.kallsyms])
>         ffffffff81afaf05 handle_tx+0xc5 ([kernel.kallsyms])
>         ffffffff81afce86 vhost_worker+0x76 ([kernel.kallsyms])
>         ffffffff811581e9 kthread+0x169 ([kernel.kallsyms])
>         ffffffff810018cf ret_from_fork+0x1f ([kernel.kallsyms])
>                        0 [unknown] ([unknown])
>

From the call trace you can send packets between two TAP. Since the TX
of TAP is synchronous so we can't see callback to be called out of
vhost thread.

In order to test it, we need 1) enable zerocopy
(experimental_zcopytx=1) and 2) sending the packet to the real NIC
with bridge or macvlan

Zerocopy was disalbed due to a lot of isuses (098eadce3c62 "vhost_net:
disable zerocopy by default"). So if we fix by moving it to
vhost_net_ubuf_put_and_wait(), there won't be a synchronize_rcu() in
the non-zerocopy path which seems to be sufficient. And we can use
synchronize_rcu_expedited() on top if it is really needed.

Thanks

> This means that the callback can't run after kthread_stop() in vhost_dev_cleanup() and no synchronize_rcu() needed.
>
> I'm not confident that my quite limited testing cover all possible vhost_zerocopy_callback() callstacks.
>

