Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2489D56D48
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbfFZPGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:06:18 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:47009 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfFZPGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:06:18 -0400
Received: by mail-ed1-f67.google.com with SMTP id d4so3776897edr.13
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b0unKbcA9BlVcyCPfxzQoEzQK5x2oOCaxq/RCUz2p1Q=;
        b=ti9MGBdGOH/i+AU1HR793kESwIeTLvrBuNDVafCUz/+EFNwi9vr1AfO9rNjpBd6/ds
         4If/Nxjn54E2MTgGajT0lw+xFABIea4XuNK0H8Slwwu1InHOkRnm6Ak3a+2rCT8LkHam
         HDGRWC0Ol1xOnwghWCdruEplyjk/qwfZlkY4PoTrD7mf6jIisQZ9H7OGfkFKcZI6b0CR
         Ebl0MDyMbIhgSZMKzS0S1lAvpvOFtiTXvcAhGcT/NprneUu/DIZItz8LTSd+IxafW4kt
         Imo5t7zVm00F1HZutdwAAhs/kvet+AgKSTbbW8TKT+MuvUdTRSxSfHTrMBa9OsXLaelA
         h7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b0unKbcA9BlVcyCPfxzQoEzQK5x2oOCaxq/RCUz2p1Q=;
        b=QM+pJ6CYbCBPdOcXBhvMvLLTBHfmaKXXRVVF/VEkUjOUbJDHYgOBQ2T886NotPYn6x
         NOPSJ2s0F4FHGc+Q/eDb56CZogbcBwpRhJ/p751iMpIeLK9dhdlSFmDH4LvYcTSgxRbB
         cl1zN3+oshY4uniQkQ2VvbJUBG6kC/1TkRmJCeW81x7gZ6PEYkguBJZBP7/HoZohVEQs
         ht19nOw59X33J2wss/X4vCDIZdRe8VoA/aMzNBvSjiIQoKjkU/kpdifzBnocCztpnJL6
         1jNkNOeFB/+1QyODUVh8k0RIha5Nn8MToNJgX6UzZ3S0Kt5aotV96AMwQEnfoHhQu8Yn
         DfqA==
X-Gm-Message-State: APjAAAVuUkCoCgpbm8k/p7qou8kmAlgKoD82se2LB9jW7jzii3PydR80
        0X+OL/6fmjT3C6QG/CMI8Q5SW2cdBVZL+fgys9E=
X-Google-Smtp-Source: APXvYqzt+3xJN+1P3FIm2iNJMTt6Rn1w1lNOpvUFFCm4G5Nnl1OScPIoeNp3T/cNA/l2wZmq1DIB2MGTDkemH0LsDcs=
X-Received: by 2002:a50:b1db:: with SMTP id n27mr6036477edd.62.1561561575939;
 Wed, 26 Jun 2019 08:06:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190619202533.4856-1-nhorman@tuxdriver.com> <20190625215749.22840-1-nhorman@tuxdriver.com>
 <CAF=yD-+fCNGQyoRNAZngof3=_gGbHn9aSCQA_hNvFSsSZtZQxA@mail.gmail.com> <20190626105403.GA31355@hmswarspite.think-freely.org>
In-Reply-To: <20190626105403.GA31355@hmswarspite.think-freely.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 26 Jun 2019 11:05:39 -0400
Message-ID: <CAF=yD-+_khMRCK0gE2q7nAi8fAtwvZ2FerHZKo1U1M-=991+Zg@mail.gmail.com>
Subject: Re: [PATCH v4 net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 6:54 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Tue, Jun 25, 2019 at 06:30:08PM -0400, Willem de Bruijn wrote:
> > > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > > index a29d66da7394..a7ca6a003ebe 100644
> > > --- a/net/packet/af_packet.c
> > > +++ b/net/packet/af_packet.c
> > > @@ -2401,6 +2401,9 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
> > >
> > >                 ts = __packet_set_timestamp(po, ph, skb);
> > >                 __packet_set_status(po, ph, TP_STATUS_AVAILABLE | ts);
> > > +
> > > +               if (!packet_read_pending(&po->tx_ring))
> > > +                       complete(&po->skb_completion);
> > >         }
> > >
> > >         sock_wfree(skb);
> > > @@ -2585,7 +2588,7 @@ static int tpacket_parse_header(struct packet_sock *po, void *frame,
> > >
> > >  static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> > >  {
> > > -       struct sk_buff *skb;
> > > +       struct sk_buff *skb = NULL;
> > >         struct net_device *dev;
> > >         struct virtio_net_hdr *vnet_hdr = NULL;
> > >         struct sockcm_cookie sockc;
> > > @@ -2600,6 +2603,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> > >         int len_sum = 0;
> > >         int status = TP_STATUS_AVAILABLE;
> > >         int hlen, tlen, copylen = 0;
> > > +       long timeo = 0;
> > >
> > >         mutex_lock(&po->pg_vec_lock);
> > >
> > > @@ -2646,12 +2650,21 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> > >         if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)
> > >                 size_max = dev->mtu + reserve + VLAN_HLEN;
> > >
> > > +       reinit_completion(&po->skb_completion);
> > > +
> > >         do {
> > >                 ph = packet_current_frame(po, &po->tx_ring,
> > >                                           TP_STATUS_SEND_REQUEST);
> > >                 if (unlikely(ph == NULL)) {
> > > -                       if (need_wait && need_resched())
> > > -                               schedule();
> > > +                       if (need_wait && skb) {
> > > +                               timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
> > > +                               timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);
> >
> > This looks really nice.
> >
> > But isn't it still susceptible to the race where tpacket_destruct_skb
> > is called in between po->xmit and this
> > wait_for_completion_interruptible_timeout?
> >
> Thats not an issue, since the complete is only gated on packet_read_pending
> reaching 0 in tpacket_destuct_skb.  Previously it was gated on my
> wait_on_complete flag being non-zero, so we had to set that prior to calling
> po->xmit, or the complete call might never get made, resulting in a hang.  Now,
> we will always call complete, and the completion api allows for arbitrary
> ordering of complete/wait_for_complete (since its internal done variable gets
> incremented), making a call to wait_for_complete effectively a fall through if
> complete gets called first.

Perfect! I was not aware that it handles that internally. Hadn't read
do_wait_for_common closely before.

> There is an odd path here though.  If an application calls sendmsg on a packet
> socket here with MSG_DONTWAIT set, then need_wait will be zero, and we will
> eventually exit this loop without ever having called wait_for_complete, but
> tpacket_destruct_skb will still have called complete when all the frames
> complete transmission.  In and of itself, thats fine, but it leave the
> completion structure in a state where its done variable will have been
> incremented at least once (specifically it will be set to N, where N is the
> number of frames transmitted during the call where MSG_DONTWAIT is set).  If the
> application then calls sendmsg on this socket with MSG_DONTWAIT clear, we will
> call wait_for_complete, but immediately return from it (due to the previously
> made calls to complete).  I've corrected this however, but adding that call to
> reinit_completion prior to the loop entry, so that we are always guaranteed to
> have the completion variable set properly to wait for only the frames being sent
> in this particular instance of the sendmsg call.

Yep, understood.

>
> > The test for skb is shorthand for packet_read_pending  != 0, right?
> >
> Sort of.  gating on skb guarantees for us that we have sent at least one frame
> in this call to tpacket_snd.  If we didn't do that, then it would be possible
> for an application to call sendmsg without setting any frames in the buffer to
> TP_STATUS_SEND_REQUEST, which would cause us to wait for a completion without
> having sent any frames, meaning we would block waiting for an event
> (tpacket_destruct_skb), that will never happen.  The check for skb ensures that
> tpacket_snd_skb will get called, and that we will get a wakeup from a call to
> wait_for_complete.  It does suggest that packet_read_pending != 0, but thats not
> guaranteed, because tpacket_destruct_skb may already have been called (see the
> above explination regarding ordering of complete/wait_for_complete).

But the inverse is true: if gating sleeping on packet_read_pending,
the process only ever waits if a packet is still to be acknowledged.
Then both the wait and wake clearly depend on the same state.

Either way works, I think. So this is definitely fine.

One possible refinement would be to keep po->wait_on_complete (but
rename as po->wake_om_complete), set it before entering the loop and
clear it before function return (both within the pg_vec_lock critical
section). And test that in tpacket_destruct_skb to avoid calling
complete if MSG_DONTWAIT. But I don't think it's worth the complexity.

One rare edge case is a MSG_DONTWAIT send followed by a !MSG_DONTWAIT.
It is then possible for a tpacket_destruct_skb to be run as a result
from the first call, during the second call, after the call to
reinit_completion. That would cause the next wait to return before
*its* packets have been sent. But due to the packet_read_pending test
in the while () condition it will loop again and return to wait. So that's fine.

Thanks for bearing with me.

Reviewed-by: Willem de Bruijn <willemb@google.com>
