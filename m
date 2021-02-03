Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0544F30E286
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhBCS3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbhBCS33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 13:29:29 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F331AC0613D6
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 10:28:48 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id g10so838286eds.2
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 10:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=deKmDPZvxIuZwtD1VBiDKxq5DpDNT8e07XxCpE/cvT0=;
        b=hQVQuaI8pkqkS6L+ood4W5X3XXISXMSRVeb64JeIF1OiOmHm3hN1PXnNTa+eNomtdU
         k7yljb1eu//LQQBM7y4WbTbM+tyn7Xw0UEIch4M/IKBFs489HMKCV6Df7G4mSi/VrApx
         X2bg8yh17S1FKu077Sco/E+ZwgQLJqS/N0Psj3AVpJ4b/kRZ8rSoBoyjGp6qgFuoCzEm
         WijjfUbEjq0pEB8MPgoObqHatLhprPyRc7r0fA+63U5eUKCiiVsbOAplICfX37Jf7fk8
         zC+lblsfgUeFShy175Jk5Vb6MwXavlJelZA/velPqAsUhwJqhfXhcLLXNt9S9KiDbQ+b
         2x+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=deKmDPZvxIuZwtD1VBiDKxq5DpDNT8e07XxCpE/cvT0=;
        b=YnoGT+HxZTq5rfpEszGFC9MUFgZVxPXA853cKNa28aV0thRMaYzQATicXZ+y15xX5H
         kQJmFYNnMsKf7zOFk+vY/wM4+ddwdbQN31ZeaTSkqOlFJfCdZVZ5raocF0fZzVM+XON1
         QUVXOrnLg+fnMEtQHwgcBsQhOgKAeYs6NKXvrizjJNri41hI2jptvE4J9yVfYDvmCnp7
         2jzy5W/P9wa4PFejsNsn4pxwOWl6gzTFWZ5WQMbnz358Ai9QiHfyIn1ZqfvzTxA3dbLE
         0UjIrq2H+ldPA5YoENFSUjpZcJ4Gl9l/dmd1KpCMTjonPLccjRdZ6LJZTM9U4wsvmPaI
         lMtg==
X-Gm-Message-State: AOAM533DGtiK1X5EPYRBLI/+DoLO9cPRSdxYpfMhXYk0RMigs1vh33hi
        /CCfsBO0JJHcjF5isTrn1nQQi4vnAkaXUOItZTg=
X-Google-Smtp-Source: ABdhPJwOPfZsPY5C71OdoeodHEOHYUshG/GCcrIRNJjIbXDJNJk4/9fnLU/YytcvgbeZiYNkoUxV44likijyqs16nG4=
X-Received: by 2002:a05:6402:d09:: with SMTP id eb9mr4411830edb.285.1612376927774;
 Wed, 03 Feb 2021 10:28:47 -0800 (PST)
MIME-Version: 1.0
References: <20210129002136.70865-1-weiwan@google.com> <a0b2cb8d-eb8f-30fb-2a22-678e6dd2f58f@redhat.com>
 <CAF=yD-+aPBF2RaCR8L5orTM37bf7Z4Z8Qko2D2LZjOz0khHTUg@mail.gmail.com> <3a3e005d-f9b2-c16a-5ada-6e04242c618e@redhat.com>
In-Reply-To: <3a3e005d-f9b2-c16a-5ada-6e04242c618e@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 3 Feb 2021 13:28:11 -0500
Message-ID: <CAF=yD-+NVKiwS6P2=cS=gk2nLcsWP1anMyy4ghdPiNrhOmLRDw@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     Jason Wang <jasowang@redhat.com>
Cc:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 12:33 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/2/2 =E4=B8=8B=E5=8D=8810:37, Willem de Bruijn wrote:
> > On Mon, Feb 1, 2021 at 10:09 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/1/29 =E4=B8=8A=E5=8D=888:21, Wei Wang wrote:
> >>> With the implementation of napi-tx in virtio driver, we clean tx
> >>> descriptors from rx napi handler, for the purpose of reducing tx
> >>> complete interrupts. But this could introduce a race where tx complet=
e
> >>> interrupt has been raised, but the handler found there is no work to =
do
> >>> because we have done the work in the previous rx interrupt handler.
> >>> This could lead to the following warning msg:
> >>> [ 3588.010778] irq 38: nobody cared (try booting with the
> >>> "irqpoll" option)
> >>> [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> >>> 5.3.0-19-generic #20~18.04.2-Ubuntu
> >>> [ 3588.017940] Call Trace:
> >>> [ 3588.017942]  <IRQ>
> >>> [ 3588.017951]  dump_stack+0x63/0x85
> >>> [ 3588.017953]  __report_bad_irq+0x35/0xc0
> >>> [ 3588.017955]  note_interrupt+0x24b/0x2a0
> >>> [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> >>> [ 3588.017957]  handle_irq_event+0x3b/0x60
> >>> [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> >>> [ 3588.017961]  handle_irq+0x20/0x30
> >>> [ 3588.017964]  do_IRQ+0x50/0xe0
> >>> [ 3588.017966]  common_interrupt+0xf/0xf
> >>> [ 3588.017966]  </IRQ>
> >>> [ 3588.017989] handlers:
> >>> [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> >>> [ 3588.025099] Disabling IRQ #38
> >>>
> >>> This patch adds a new param to struct vring_virtqueue, and we set it =
for
> >>> tx virtqueues if napi-tx is enabled, to suppress the warning in such
> >>> case.
> >>>
> >>> Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi")
> >>> Reported-by: Rick Jones <jonesrick@google.com>
> >>> Signed-off-by: Wei Wang <weiwan@google.com>
> >>> Signed-off-by: Willem de Bruijn <willemb@google.com>
> >>
> >> Please use get_maintainer.pl to make sure Michael and me were cced.
> > Will do. Sorry about that. I suggested just the virtualization list, my=
 bad.
> >
> >>> ---
> >>>    drivers/net/virtio_net.c     | 19 ++++++++++++++-----
> >>>    drivers/virtio/virtio_ring.c | 16 ++++++++++++++++
> >>>    include/linux/virtio.h       |  2 ++
> >>>    3 files changed, 32 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >>> index 508408fbe78f..e9a3f30864e8 100644
> >>> --- a/drivers/net/virtio_net.c
> >>> +++ b/drivers/net/virtio_net.c
> >>> @@ -1303,13 +1303,22 @@ static void virtnet_napi_tx_enable(struct vir=
tnet_info *vi,
> >>>                return;
> >>>        }
> >>>
> >>> +     /* With napi_tx enabled, free_old_xmit_skbs() could be called f=
rom
> >>> +      * rx napi handler. Set work_steal to suppress bad irq warning =
for
> >>> +      * IRQ_NONE case from tx complete interrupt handler.
> >>> +      */
> >>> +     virtqueue_set_work_steal(vq, true);
> >>> +
> >>>        return virtnet_napi_enable(vq, napi);
> >>
> >> Do we need to force the ordering between steal set and napi enable?
> > The warning only occurs after one hundred spurious interrupts, so not
> > really.
>
>
> Ok, so it looks like a hint. Then I wonder how much value do we need to
> introduce helper like virtqueue_set_work_steal() that allows the caller
> to toggle. How about disable the check forever during virtqueue
> initialization?

Yes, that is even simpler.

We still need the helper, as the internal variables of vring_virtqueue
are not accessible from virtio-net. An earlier patch added the
variable to virtqueue itself, but I think it belongs in
vring_virtqueue. And the helper is not a lot of code.
