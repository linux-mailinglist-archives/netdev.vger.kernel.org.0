Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD7832D3A4
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237098AbhCDMwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237026AbhCDMwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 07:52:08 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AD4C061760
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 04:51:28 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id p193so28390011yba.4
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 04:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UbKR0YKWlCKHpmhNCoQrLbVisWZY+TmQW326zT0SiyI=;
        b=fmLGogyb8LXc+4mMfRCk4Qa0lFh6vru4AogOz46MIHptXdrCAEIf/mD2omWUuOPaXw
         20KZbP8iluxmoJlMJvArH3syyj5lHAGl2lvlnEW/MQXkG9gPwE8+tTXCBsTXrP65gdyI
         RrRamsyPv5xvFzd/jGVdweKyr/gN53qCG7MMY+qoDCPrQtTyyTPx+p6YEplXYroTpO3H
         6FWcVD937q4cHTU9fQkIHY02p2eN9JgeXS3H2pHh7RW54hEgy4FulkrM+kitrYVFRBDJ
         jugYtGNht5hio2/0dHij3jHBq5lH/vjFm2I/uTUlFZLFBUb1DMxD0uHW/qotDxvUa97c
         GtBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UbKR0YKWlCKHpmhNCoQrLbVisWZY+TmQW326zT0SiyI=;
        b=gWxFeVF1/BqWypk4KS6fWn8wJb6oTf6BpmyCnpHd01EC1pV1Jd93bM4Xkoe2XuWEcJ
         xwnsHX9dODoVSraUAXzyAq1XNOeqLEithulzY7iIfuiK6CMzZkG2rzP7bJNo4xeCpf0L
         pfIkPHX3xlXYIQi70McbQV3JT6Qvjr3MHcGc2UpQ+m1L/v3y3+7x4PxQGWlZ//XR75I1
         Db5lLQVyJ77C3+DriBOqoeAwpNBZ/VO1UNIwmcT5e6su9vzcX2bauO4UlGjUah7Ojng9
         JKFyeqFrblnbjfxgHM13QzuAOXDA1or+SEFHN8n4Zj4eR19tbjKqoqYK9W092hudWy/b
         D0yw==
X-Gm-Message-State: AOAM533w4Ys3dufys/0WPx5KaInQyPvFLOT75j6/Elj43ohnulxvfoiT
        fPj6bfti/1T4GfzzeE0BvPIdUQMTl8194Zp761PDHw==
X-Google-Smtp-Source: ABdhPJxsn4TH9WmZkqjfafUuMKY5MAgXyuesFdlj1tnbA+9KOFPjfs+8fGF4GxAQiQVizpXXnCJTjE8OXuDRgoK+68M=
X-Received: by 2002:a25:ac52:: with SMTP id r18mr6085541ybd.303.1614862287193;
 Thu, 04 Mar 2021 04:51:27 -0800 (PST)
MIME-Version: 1.0
References: <20210302060753.953931-1-kuba@kernel.org> <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
 <CAKgT0UdXiFBW9oDwvsFPe_ZoGveHLGh6RXf55jaL6kOYPEh0Hg@mail.gmail.com>
 <20210303160715.2333d0ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAKgT0Ue9w4WBojY94g3kcLaQrVbVk6S-HgsFgLVXoqsY20hwuw@mail.gmail.com>
In-Reply-To: <CAKgT0Ue9w4WBojY94g3kcLaQrVbVk6S-HgsFgLVXoqsY20hwuw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 4 Mar 2021 13:51:15 +0100
Message-ID: <CANn89iL9fBKDQvAM0mTnh_B5ggmsebDBYxM6WAfYgMuD8-vcBw@mail.gmail.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen SYN
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 4, 2021 at 3:45 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, Mar 3, 2021 at 4:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Wed, 3 Mar 2021 13:35:53 -0800 Alexander Duyck wrote:
> > > On Tue, Mar 2, 2021 at 1:37 PM Eric Dumazet <edumazet@google.com> wrote:
> > > > On Tue, Mar 2, 2021 at 7:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > > When receiver does not accept TCP Fast Open it will only ack
> > > > > the SYN, and not the data. We detect this and immediately queue
> > > > > the data for (re)transmission in tcp_rcv_fastopen_synack().
> > > > >
> > > > > In DC networks with very low RTT and without RFS the SYN-ACK
> > > > > may arrive before NIC driver reported Tx completion on
> > > > > the original SYN. In which case skb_still_in_host_queue()
> > > > > returns true and sender will need to wait for the retransmission
> > > > > timer to fire milliseconds later.
> > > > >
> > > > > Revert back to non-fast clone skbs, this way
> > > > > skb_still_in_host_queue() won't prevent the recovery flow
> > > > > from completing.
> > > > >
> > > > > Suggested-by: Eric Dumazet <edumazet@google.com>
> > > > > Fixes: 355a901e6cf1 ("tcp: make connect() mem charging friendly")
> > > >
> > > > Hmmm, not sure if this Fixes: tag makes sense.
> > > >
> > > > Really, if we delay TX completions by say 10 ms, other parts of the
> > > > stack will misbehave anyway.
> > > >
> > > > Also, backporting this patch up to linux-3.19 is going to be tricky.
> > > >
> > > > The real issue here is that skb_still_in_host_queue() can give a false positive.
> > > >
> > > > I have mixed feelings here, as you can read my answer :/
> > > >
> > > > Maybe skb_still_in_host_queue() signal should not be used when a part
> > > > of the SKB has been received/acknowledged by the remote peer
> > > > (in this case the SYN part).
> > > >
> > > > Alternative is that drivers unable to TX complete their skbs in a
> > > > reasonable time should call skb_orphan()
> > > >  to avoid skb_unclone() penalties (and this skb_still_in_host_queue() issue)
> > > >
> > > > If you really want to play and delay TX completions, maybe provide a
> > > > way to disable skb_still_in_host_queue() globally,
> > > > using a static key ?
> > >
> > > The problem as I see it is that the original fclone isn't what we sent
> > > out on the wire and that is confusing things. What we sent was a SYN
> > > with data, but what we have now is just a data frame that hasn't been
> > > put out on the wire yet.
> >
> > Not sure I understand why it's the key distinction here. Is it
> > re-transmitting part of the frame or having different flags?
> > Is re-transmit of half of a GSO skb also considered not the same?
>
> The difference in my mind is the flags. So specifically the clone of
> the syn_data frame in the case of the TCP fast open isn't actually a
> clone of the sent frame. Instead we end up modifying the flags so that
> it becomes the first data frame. We already have the SYN sitting in
> the retransmit queue before we send the SYN w/ data frame. In addition
> the SYN packet in the retransmit queue has a reference count of 1 so
> it is not encumbered by the fclone reference count check so it could
> theoretically be retransmitted immediately, it is just the data packet
> that is being held.
>
> If we replay a GSO frame we will get the same frames all over again.
> In the case of a TCP fast open syn_data packet that isn't the case.
> The first time out it is one packet, the second time it is two.
>
> > To me the distinction is that the receiver has implicitly asked
> > us for the re-transmission. If it was requested by SACK we should
> > ignore "in_queue" for the first transmission as well, even if the
> > skb state is identical.
>
> In my mind the distinction is the fact that what we have in the
> retransmit queue is 2 frames, a SYN and a data. Whereas what we have
> put on the wire is SYN w/ data.
>
> > > I wonder if we couldn't get away with doing something like adding a
> > > fourth option of SKB_FCLONE_MODIFIED that we could apply to fastopen
> > > skbs? That would keep the skb_still_in_host queue from triggering as
> > > we would be changing the state from SKB_FCLONE_ORIG to
> > > SKB_FCLONE_MODIFIED for the skb we store in the retransmit queue. In
> > > addition if we have to clone it again and the fclone reference count
> > > is 1 we could reset it back to SKB_FCLONE_ORIG.
> >
> > The unused value of fclone was tempting me as well :)
> >
> > AFAICT we have at least these options:
> >
> > 1 - don't use a fclone skb [v1]
> >
> > 2 - mark the fclone as "special" at Tx to escape the "in queue" check
>
> This is what I had in mind. Basically just add a function to
> transition from SKB_FCLONE_ORIG to SKB_FCLONE_MODIFIED/DIRTY when the
> clone no longer represents what is actually on the wire.
>
> The added benefit is that we can potentially restore it to
> SKB_FCLONE_ORIG if we clone it again assuming the reference count fell
> back to 1.
>


I think we are over thinking this really (especially if the fix needs
a change in core networking or drivers)

We can reuse TSQ logic to have a chance to recover when the clone is
eventually freed.
This will be more generic, not only for the SYN+data of FastOpen.

Can you please test the following patch ?

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6d0a33d1c0db6defaa005335c3e285f0f1ac686c..43317b40df54718edf9165ca2018da92ddfeab62
100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1136,7 +1136,7 @@ static inline bool skb_fclone_busy(const struct sock *sk,

        return skb->fclone == SKB_FCLONE_ORIG &&
               refcount_read(&fclones->fclone_ref) > 1 &&
-              fclones->skb2.sk == sk;
+              READ_ONCE(fclones->skb2.sk) == sk;
 }

 /**
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fbf140a770d8e21b936369b79abbe9857537acd8..0996e12e6c75121030e5db2fc8f2bd6d07037164
100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2775,13 +2775,22 @@ bool tcp_schedule_loss_probe(struct sock *sk,
bool advancing_rto)
  * a packet is still in a qdisc or driver queue.
  * In this case, there is very little point doing a retransmit !
  */
-static bool skb_still_in_host_queue(const struct sock *sk,
+static bool skb_still_in_host_queue(struct sock *sk,
                                    const struct sk_buff *skb)
 {
        if (unlikely(skb_fclone_busy(sk, skb))) {
-               NET_INC_STATS(sock_net(sk),
-                             LINUX_MIB_TCPSPURIOUS_RTX_HOSTQUEUES);
-               return true;
+               set_bit(TSQ_THROTTLED, &sk->sk_tsq_flags);
+               /* If TX completion is really slow, we could have
received an ACK
+                * for a packet not yet freed by the driver.
+                * Setting TSQ_THROTTLED makes sure we will attempt to
retransmit
+                * later when fclone is no longer busy.
+                */
+               smp_mb__after_atomic();
+               if (skb_fclone_busy(sk, skb)) {
+                       NET_INC_STATS(sock_net(sk),
+                                     LINUX_MIB_TCPSPURIOUS_RTX_HOSTQUEUES);
+                       return true;
+               }
        }
        return false;
 }
