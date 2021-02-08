Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05490313E8F
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbhBHTLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbhBHTJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 14:09:45 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D54C061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 11:09:05 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y8so20001148ede.6
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 11:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=l0kbrSaQgUXnEY1P7PcjdolquDqjSA58IJTFJAK0lBc=;
        b=pZSi6AjgTzOb5nK5lYZzBBmmH71S7J5hcYyYCI/j+LZgR+XB/OEBx583W9IvuD3OmO
         Gh9yAkRs7VivwAQH/DpjjIx4/kSgX3x4xPwL/Ynz6MT6jVab9uVkiqSA4KUob9JSv9zd
         DYZZj9hRKIUHDDQM7eO0f3fmzd7WQHf291nYmuV9TqKFWlUEmz2V45l2CP99wGE6hHs5
         xp2JWFLVVgUUThvW6unDGE+8hJw/a56AZneBjxfUSxcoFaGwJlqzBYeToU/13zx6xQuW
         J7u3PwDgBhq7QXlCj8aeDm/puefJf6LpqINcZee+M9iJQvFvkNUjoSRIyjKnGxrrIiXs
         NZ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=l0kbrSaQgUXnEY1P7PcjdolquDqjSA58IJTFJAK0lBc=;
        b=HAsEsRNNg85ZEgxrv4ur7mgqDKmZ6snwyzqQip/Mb3QEc70qZ/tBhY75W4JMc2U5CO
         VPD2O4YnKu0CWqhX7UXbHM/3MMOvrVy9Bl2vYtWvSkc6qwzBsOoOZDrG52OL60R5FjSQ
         IyB2ymPJkT+AiI6AfI3bKF6tzt7F/5sdnfZ45Q94HkQ6kvD5JJxkaT+HlIWpbLkdYwgU
         NYl1IHLuNGMl7QNfQufstIoi91A7xqfmoI3REFbWHCTVqkZ66BoQqmIjM9wEj8lGX5Ck
         EAhKwOISc7KJp5VRIeKyMEiywhSF60ZnVZ5gLgpAeOo6sO/r+ddvDJbLHP7g2/mt76TJ
         bUyg==
X-Gm-Message-State: AOAM533+VZ8yJmjmrFJuRTecYV1GwDmAmrRjBVoZaO1hHN47XQLwbcxS
        SmLFz6yq94G8fVdUppml6jIgb+jtwbe2aFPOiVM=
X-Google-Smtp-Source: ABdhPJxF/8gMEIpp3RevkkNsme+QbmBql5G+BJf6SWQ5H8PvnybBbCf5zSqSrZK7g3ZZiquPGd4IV15YthKlqI8F5eY=
X-Received: by 2002:aa7:da17:: with SMTP id r23mr18113059eds.176.1612811343705;
 Mon, 08 Feb 2021 11:09:03 -0800 (PST)
MIME-Version: 1.0
References: <20210129002136.70865-1-weiwan@google.com> <a0b2cb8d-eb8f-30fb-2a22-678e6dd2f58f@redhat.com>
 <CAF=yD-+aPBF2RaCR8L5orTM37bf7Z4Z8Qko2D2LZjOz0khHTUg@mail.gmail.com>
 <3a3e005d-f9b2-c16a-5ada-6e04242c618e@redhat.com> <CAF=yD-+NVKiwS6P2=cS=gk2nLcsWP1anMyy4ghdPiNrhOmLRDw@mail.gmail.com>
 <9b0b8f2a-8476-697e-9002-e9947e3eab63@redhat.com> <CA+FuTScVOuoHKtrdrRFswjA3Zq1-7sgMVhnP2iMB5sYFFS8NFg@mail.gmail.com>
 <50ae0b71-df87-f26c-8b4d-8035f9f6a58d@redhat.com>
In-Reply-To: <50ae0b71-df87-f26c-8b4d-8035f9f6a58d@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 8 Feb 2021 14:08:26 -0500
Message-ID: <CAF=yD-J5-60D=JDwvpecjaO6J03SZHoHJyCsR3B1HbP1-jbqng@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     Jason Wang <jasowang@redhat.com>
Cc:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 7, 2021 at 10:29 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/2/5 =E4=B8=8A=E5=8D=884:50, Willem de Bruijn wrote:
> > On Wed, Feb 3, 2021 at 10:06 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/2/4 =E4=B8=8A=E5=8D=882:28, Willem de Bruijn wrote:
> >>> On Wed, Feb 3, 2021 at 12:33 AM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>> On 2021/2/2 =E4=B8=8B=E5=8D=8810:37, Willem de Bruijn wrote:
> >>>>> On Mon, Feb 1, 2021 at 10:09 PM Jason Wang <jasowang@redhat.com> wr=
ote:
> >>>>>> On 2021/1/29 =E4=B8=8A=E5=8D=888:21, Wei Wang wrote:
> >>>>>>> With the implementation of napi-tx in virtio driver, we clean tx
> >>>>>>> descriptors from rx napi handler, for the purpose of reducing tx
> >>>>>>> complete interrupts. But this could introduce a race where tx com=
plete
> >>>>>>> interrupt has been raised, but the handler found there is no work=
 to do
> >>>>>>> because we have done the work in the previous rx interrupt handle=
r.
> >>>>>>> This could lead to the following warning msg:
> >>>>>>> [ 3588.010778] irq 38: nobody cared (try booting with the
> >>>>>>> "irqpoll" option)
> >>>>>>> [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> >>>>>>> 5.3.0-19-generic #20~18.04.2-Ubuntu
> >>>>>>> [ 3588.017940] Call Trace:
> >>>>>>> [ 3588.017942]  <IRQ>
> >>>>>>> [ 3588.017951]  dump_stack+0x63/0x85
> >>>>>>> [ 3588.017953]  __report_bad_irq+0x35/0xc0
> >>>>>>> [ 3588.017955]  note_interrupt+0x24b/0x2a0
> >>>>>>> [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> >>>>>>> [ 3588.017957]  handle_irq_event+0x3b/0x60
> >>>>>>> [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> >>>>>>> [ 3588.017961]  handle_irq+0x20/0x30
> >>>>>>> [ 3588.017964]  do_IRQ+0x50/0xe0
> >>>>>>> [ 3588.017966]  common_interrupt+0xf/0xf
> >>>>>>> [ 3588.017966]  </IRQ>
> >>>>>>> [ 3588.017989] handlers:
> >>>>>>> [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> >>>>>>> [ 3588.025099] Disabling IRQ #38
> >>>>>>>
> >>>>>>> This patch adds a new param to struct vring_virtqueue, and we set=
 it for
> >>>>>>> tx virtqueues if napi-tx is enabled, to suppress the warning in s=
uch
> >>>>>>> case.
> >>>>>>>
> >>>>>>> Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx na=
pi")
> >>>>>>> Reported-by: Rick Jones <jonesrick@google.com>
> >>>>>>> Signed-off-by: Wei Wang <weiwan@google.com>
> >>>>>>> Signed-off-by: Willem de Bruijn <willemb@google.com>
> >>>>>> Please use get_maintainer.pl to make sure Michael and me were cced=
.
> >>>>> Will do. Sorry about that. I suggested just the virtualization list=
, my bad.
> >>>>>
> >>>>>>> ---
> >>>>>>>      drivers/net/virtio_net.c     | 19 ++++++++++++++-----
> >>>>>>>      drivers/virtio/virtio_ring.c | 16 ++++++++++++++++
> >>>>>>>      include/linux/virtio.h       |  2 ++
> >>>>>>>      3 files changed, 32 insertions(+), 5 deletions(-)
> >>>>>>>
> >>>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >>>>>>> index 508408fbe78f..e9a3f30864e8 100644
> >>>>>>> --- a/drivers/net/virtio_net.c
> >>>>>>> +++ b/drivers/net/virtio_net.c
> >>>>>>> @@ -1303,13 +1303,22 @@ static void virtnet_napi_tx_enable(struct=
 virtnet_info *vi,
> >>>>>>>                  return;
> >>>>>>>          }
> >>>>>>>
> >>>>>>> +     /* With napi_tx enabled, free_old_xmit_skbs() could be call=
ed from
> >>>>>>> +      * rx napi handler. Set work_steal to suppress bad irq warn=
ing for
> >>>>>>> +      * IRQ_NONE case from tx complete interrupt handler.
> >>>>>>> +      */
> >>>>>>> +     virtqueue_set_work_steal(vq, true);
> >>>>>>> +
> >>>>>>>          return virtnet_napi_enable(vq, napi);
> >>>>>> Do we need to force the ordering between steal set and napi enable=
?
> >>>>> The warning only occurs after one hundred spurious interrupts, so n=
ot
> >>>>> really.
> >>>> Ok, so it looks like a hint. Then I wonder how much value do we need=
 to
> >>>> introduce helper like virtqueue_set_work_steal() that allows the cal=
ler
> >>>> to toggle. How about disable the check forever during virtqueue
> >>>> initialization?
> >>> Yes, that is even simpler.
> >>>
> >>> We still need the helper, as the internal variables of vring_virtqueu=
e
> >>> are not accessible from virtio-net. An earlier patch added the
> >>> variable to virtqueue itself, but I think it belongs in
> >>> vring_virtqueue. And the helper is not a lot of code.
> >>
> >> It's better to do this before the allocating the irq. But it looks not
> >> easy unless we extend find_vqs().
> > Can you elaborate why that is better? At virtnet_open the interrupts
> > are not firing either.
>
>
> I think you meant NAPI actually?

I meant interrupt: we don't have to worry about the spurious interrupt
warning when no interrupts will be firing. Until virtnet_open
completes, the device is down.


>
> >
> > I have no preference. Just curious, especially if it complicates the pa=
tch.
> >
>
> My understanding is that. It's probably ok for net. But we probably need
> to document the assumptions to make sure it was not abused in other drive=
rs.
>
> Introduce new parameters for find_vqs() can help to eliminate the subtle
> stuffs but I agree it looks like a overkill.
>
> (Btw, I forget the numbers but wonder how much difference if we simple
> remove the free_old_xmits() from the rx NAPI path?)

The committed patchset did not record those numbers, but I found them
in an earlier iteration:

  [PATCH net-next 0/3] virtio-net tx napi
  https://lists.openwall.net/netdev/2017/04/02/55

It did seem to significantly reduce compute cycles ("Gcyc") at the
time. For instance:

    TCP_RR Latency (us):
    1x:
      p50              24       24       21
      p99              27       27       27
      Gcycles         299      432      308

I'm concerned that removing it now may cause a regression report in a
few months. That is higher risk than the spurious interrupt warning
that was only reported after years of use.
