Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB1B30FEE3
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhBDUvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhBDUv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 15:51:26 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887DFC0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 12:50:46 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id n18so2455656vsa.12
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 12:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=58FB/JLtXlmuPcKX/PnOSLc8qhL9LMB0SU8JDUNjepw=;
        b=eajEEpNLTkZ8PeyTgqyoJ0CWtX08KJK1DvIHwMdeQi9CAurdGltqC51x7Zk+GbuSuv
         8ZBE9uGrD8H2OjJFIYkHLqizhBmOpS5Ch4bvF/RWDKGriONIwFA0Ix7E1YCoEN+M6djQ
         i9sF0KqClIm5LOUFW+ucCkx3gXJXv00CCBdyqn/dX8VgkZNigN4SW5jpbxPnp69kP3qF
         tJ/uoIT8TbK+zyD9ymVEGejYvwguZQOpef1il0Atqjl/S1pApQvqbzt3nt2R7cXWSffm
         T6kZE7mmrvmI4lYQsAOQYcBAYXpi4kjUdI0gSc3wLKoNrkgqu9zjY4s6Gpeq/KbBbBmL
         sLmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=58FB/JLtXlmuPcKX/PnOSLc8qhL9LMB0SU8JDUNjepw=;
        b=DgLg/7ueEWw1H6nwmo7s4hvihVttbubYPER1DJcZ/xcB5M0pm4za7mvrjxz5Wt9BxA
         ERLxFedp6erXh1TrMM7LZ8cs5bU+RoU0euBLVReRN/NTWCTimJz/UcTtmyUG9hA2+wLe
         rYDNa+fwg+47SsZN6UnpzhD/8Hr+ncD3zTvGUT+1LVHZC43cIID/by1/5oyemhmbzmQ1
         p438PLEyOdZbwZDDMYWNeMMhKskMVcDGXfIwVn6gknVlUSoD34Om1DPN6jLDW0eVvyar
         G+V2Bg/RXkqRIyoHVDX5Li9wSlNAntYBY49KJoJxJJfOqRHp5/pP9CQtIQb0qB3FIgSG
         iZ9w==
X-Gm-Message-State: AOAM532rqv8UckeQZirudLB4kMJ1CYzRrhfwUnhC0qE9PnLE4bqzN73Z
        ccORv2ThO5t7znOQ0shkFdFUJRTk+eQ=
X-Google-Smtp-Source: ABdhPJy+E/Yc8PwEm883w8wOKLOnjN6GtKxnrDETFFBTeNlW0hq9OAtb1MBbwGSDYbnQcjdv2XXU5g==
X-Received: by 2002:a67:24c5:: with SMTP id k188mr1376112vsk.16.1612471844621;
        Thu, 04 Feb 2021 12:50:44 -0800 (PST)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com. [209.85.217.49])
        by smtp.gmail.com with ESMTPSA id d125sm203275vsd.3.2021.02.04.12.50.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 12:50:43 -0800 (PST)
Received: by mail-vs1-f49.google.com with SMTP id 186so2446710vsz.13
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 12:50:43 -0800 (PST)
X-Received: by 2002:a05:6102:21c2:: with SMTP id r2mr1296249vsg.13.1612471842695;
 Thu, 04 Feb 2021 12:50:42 -0800 (PST)
MIME-Version: 1.0
References: <20210129002136.70865-1-weiwan@google.com> <a0b2cb8d-eb8f-30fb-2a22-678e6dd2f58f@redhat.com>
 <CAF=yD-+aPBF2RaCR8L5orTM37bf7Z4Z8Qko2D2LZjOz0khHTUg@mail.gmail.com>
 <3a3e005d-f9b2-c16a-5ada-6e04242c618e@redhat.com> <CAF=yD-+NVKiwS6P2=cS=gk2nLcsWP1anMyy4ghdPiNrhOmLRDw@mail.gmail.com>
 <9b0b8f2a-8476-697e-9002-e9947e3eab63@redhat.com>
In-Reply-To: <9b0b8f2a-8476-697e-9002-e9947e3eab63@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 4 Feb 2021 15:50:06 -0500
X-Gmail-Original-Message-ID: <CA+FuTScVOuoHKtrdrRFswjA3Zq1-7sgMVhnP2iMB5sYFFS8NFg@mail.gmail.com>
Message-ID: <CA+FuTScVOuoHKtrdrRFswjA3Zq1-7sgMVhnP2iMB5sYFFS8NFg@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
To:     Jason Wang <jasowang@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 10:06 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/2/4 =E4=B8=8A=E5=8D=882:28, Willem de Bruijn wrote:
> > On Wed, Feb 3, 2021 at 12:33 AM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/2/2 =E4=B8=8B=E5=8D=8810:37, Willem de Bruijn wrote:
> >>> On Mon, Feb 1, 2021 at 10:09 PM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>> On 2021/1/29 =E4=B8=8A=E5=8D=888:21, Wei Wang wrote:
> >>>>> With the implementation of napi-tx in virtio driver, we clean tx
> >>>>> descriptors from rx napi handler, for the purpose of reducing tx
> >>>>> complete interrupts. But this could introduce a race where tx compl=
ete
> >>>>> interrupt has been raised, but the handler found there is no work t=
o do
> >>>>> because we have done the work in the previous rx interrupt handler.
> >>>>> This could lead to the following warning msg:
> >>>>> [ 3588.010778] irq 38: nobody cared (try booting with the
> >>>>> "irqpoll" option)
> >>>>> [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> >>>>> 5.3.0-19-generic #20~18.04.2-Ubuntu
> >>>>> [ 3588.017940] Call Trace:
> >>>>> [ 3588.017942]  <IRQ>
> >>>>> [ 3588.017951]  dump_stack+0x63/0x85
> >>>>> [ 3588.017953]  __report_bad_irq+0x35/0xc0
> >>>>> [ 3588.017955]  note_interrupt+0x24b/0x2a0
> >>>>> [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> >>>>> [ 3588.017957]  handle_irq_event+0x3b/0x60
> >>>>> [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> >>>>> [ 3588.017961]  handle_irq+0x20/0x30
> >>>>> [ 3588.017964]  do_IRQ+0x50/0xe0
> >>>>> [ 3588.017966]  common_interrupt+0xf/0xf
> >>>>> [ 3588.017966]  </IRQ>
> >>>>> [ 3588.017989] handlers:
> >>>>> [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> >>>>> [ 3588.025099] Disabling IRQ #38
> >>>>>
> >>>>> This patch adds a new param to struct vring_virtqueue, and we set i=
t for
> >>>>> tx virtqueues if napi-tx is enabled, to suppress the warning in suc=
h
> >>>>> case.
> >>>>>
> >>>>> Fixes: 7b0411ef4aa6 ("virtio-net: clean tx descriptors from rx napi=
")
> >>>>> Reported-by: Rick Jones <jonesrick@google.com>
> >>>>> Signed-off-by: Wei Wang <weiwan@google.com>
> >>>>> Signed-off-by: Willem de Bruijn <willemb@google.com>
> >>>> Please use get_maintainer.pl to make sure Michael and me were cced.
> >>> Will do. Sorry about that. I suggested just the virtualization list, =
my bad.
> >>>
> >>>>> ---
> >>>>>     drivers/net/virtio_net.c     | 19 ++++++++++++++-----
> >>>>>     drivers/virtio/virtio_ring.c | 16 ++++++++++++++++
> >>>>>     include/linux/virtio.h       |  2 ++
> >>>>>     3 files changed, 32 insertions(+), 5 deletions(-)
> >>>>>
> >>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >>>>> index 508408fbe78f..e9a3f30864e8 100644
> >>>>> --- a/drivers/net/virtio_net.c
> >>>>> +++ b/drivers/net/virtio_net.c
> >>>>> @@ -1303,13 +1303,22 @@ static void virtnet_napi_tx_enable(struct v=
irtnet_info *vi,
> >>>>>                 return;
> >>>>>         }
> >>>>>
> >>>>> +     /* With napi_tx enabled, free_old_xmit_skbs() could be called=
 from
> >>>>> +      * rx napi handler. Set work_steal to suppress bad irq warnin=
g for
> >>>>> +      * IRQ_NONE case from tx complete interrupt handler.
> >>>>> +      */
> >>>>> +     virtqueue_set_work_steal(vq, true);
> >>>>> +
> >>>>>         return virtnet_napi_enable(vq, napi);
> >>>> Do we need to force the ordering between steal set and napi enable?
> >>> The warning only occurs after one hundred spurious interrupts, so not
> >>> really.
> >>
> >> Ok, so it looks like a hint. Then I wonder how much value do we need t=
o
> >> introduce helper like virtqueue_set_work_steal() that allows the calle=
r
> >> to toggle. How about disable the check forever during virtqueue
> >> initialization?
> > Yes, that is even simpler.
> >
> > We still need the helper, as the internal variables of vring_virtqueue
> > are not accessible from virtio-net. An earlier patch added the
> > variable to virtqueue itself, but I think it belongs in
> > vring_virtqueue. And the helper is not a lot of code.
>
>
> It's better to do this before the allocating the irq. But it looks not
> easy unless we extend find_vqs().

Can you elaborate why that is better? At virtnet_open the interrupts
are not firing either.

I have no preference. Just curious, especially if it complicates the patch.
