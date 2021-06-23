Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094013B1139
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 03:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFWBMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 21:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhFWBMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 21:12:21 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744BFC061574;
        Tue, 22 Jun 2021 18:10:03 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id a13so648056wrf.10;
        Tue, 22 Jun 2021 18:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y3Aelhd0xYneu7PB70C6L0IGKS46F1btdIrEPS3y978=;
        b=ceuv0/LgbZ0kBUuOo0yRyRJonYwzko3jybra6PVQPj11mQus1UnrgpBdanhbCd/dax
         MYUUtm/M0xo6BuPD+DJRsrmhsVwLZLAOPSN7p7SVmQoMnpR6nTfZnJQDb8b40JcLqlkk
         TyZvPhJQsOWkPjWYIdQif2DxZE6J+WIHz5+1+Lb1SPOQw+oGTrQoa3uM6QW/JBQl7kyo
         WLD/TwDLQCsppI387BY8rB+W7GvDG76HEuWxXhFJc5yJWKkzO5u4ESw3t4jN2FYOHstO
         F7y7eeIe9CkhZdpZC3WucT74Gi26JhogPuywaxbAu7F30xhYNjwD347EHU89R9B0d15v
         Qjig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y3Aelhd0xYneu7PB70C6L0IGKS46F1btdIrEPS3y978=;
        b=FcMBvqn4rbEv1fYjcYedtGV8vve7w40WZjs+O2ez3NATUXRBZHvcdebeQxj4szasiV
         md9nxlMR3CHm2DEtKFJyxOseIYXkCWgufa23+B2PhYDSRYMa11auRb9tPKDp6HB9q6IO
         UdwXFH6cPEyIXvjDcTbcoeNPeAUHit8dtkQ9Kq7OkwO/dSYOSKUP0q1t7KT9fr0jUKNZ
         GHANrbDfnx5AyIgXklmi3GeAUtucBAuzuvt9l45fjgJbCTyE8XiifRnyJ36j+OOd974X
         Dl7bzGsNIprEDNDCz1/kj6Xel1l8jxwdtoL7nnjuaYmHFMy8prS1W5GyqP9vnnsoDUeP
         2MgA==
X-Gm-Message-State: AOAM531DN50nlqkfqefpZM1yIMzxMbULXjEJz8v4KtoMJVgRLj3QWqFc
        RI9YJlIPM4uCFvhF7GYLK9tOKVRqUW8VP6K0tUw=
X-Google-Smtp-Source: ABdhPJyu+vHBkTHREj6Kmpu6WAHX19SeGBrLmMq/IqwR+SQIYmTseoN2f3VHBJgcJHzthLX5YguD4IrVMPsJGeGSjcA=
X-Received: by 2002:a5d:5187:: with SMTP id k7mr5056177wrv.395.1624410602044;
 Tue, 22 Jun 2021 18:10:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1624384990.git.lucien.xin@gmail.com> <cfaa01992d064520b3a9138983e8ec41@AcuMS.aculab.com>
In-Reply-To: <cfaa01992d064520b3a9138983e8ec41@AcuMS.aculab.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 22 Jun 2021 21:09:52 -0400
Message-ID: <CADvbK_e7D4s81vS0rq=P4mQe47dshJgQzaWnrUyCi-Cis4xyhQ@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 00/14] sctp: implement RFC8899: Packetization
 Layer Path MTU Discovery for SCTP transport
To:     David Laight <David.Laight@aculab.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 6:13 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Xin Long
> > Sent: 22 June 2021 19:05
> >
> > Overview(From RFC8899):
> >
> >   In contrast to PMTUD, Packetization Layer Path MTU Discovery
> >   (PLPMTUD) [RFC4821] introduces a method that does not rely upon
> >   reception and validation of PTB messages.  It is therefore more
> >   robust than Classical PMTUD.  This has become the recommended
> >   approach for implementing discovery of the PMTU [BCP145].
> >
> >   It uses a general strategy in which the PL sends probe packets to
> >   search for the largest size of unfragmented datagram that can be sent
> >   over a network path.  Probe packets are sent to explore using a
> >   larger packet size.  If a probe packet is successfully delivered (as
> >   determined by the PL), then the PLPMTU is raised to the size of the
> >   successful probe.  If a black hole is detected (e.g., where packets
> >   of size PLPMTU are consistently not received), the method reduces the
> >   PLPMTU.
>
> This seems to take a long time (probably well over a minute)
> to determine the mtu.
I just noticed this is a misread of RFC8899, and the next probe packet
should be sent immediately once the ACK of the last probe is received,
instead of waiting the timeout, which should be for the missing probe.

I will fix this with:

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index d29b579da904..f3aca1acf93a 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1275,6 +1275,8 @@ enum sctp_disposition
sctp_sf_backbeat_8_3(struct net *net,
                        return SCTP_DISPOSITION_DISCARD;

                sctp_transport_pl_recv(link);
+               sctp_add_cmd_sf(commands, SCTP_CMD_PROBE_TIMER_UPDATE,
+                               SCTP_TRANSPORT(link));
                return SCTP_DISPOSITION_CONSUME;
        }

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index f27b856ea8ce..88815b98d9d0 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -215,6 +215,11 @@ void sctp_transport_reset_probe_timer(struct
sctp_transport *transport)
 {
        int scale = 1;

+       if (transport->pl.probe_count == 0) {
+               if (!mod_timer(&transport->probe_timer, jiffies +
transport->rto))
+                       sctp_transport_hold(transport);
+               return;
+       }
        if (timer_pending(&transport->probe_timer))
                return;
        if (transport->pl.state == SCTP_PL_COMPLETE &&

Thanks for the comment.
>
> What is used for the actual mtu while this is in progress?
>
> Does packet loss and packet retransmission cause the mtu
> to be reduced as well?
No, the data packet is not a probe in this implementation.

>
> I can imagine that there is an expectation (from the application)
> that the mtu is that of an ethernet link - perhaps less a PPPoE
> header.
> Starting with an mtu of 1200 will break this assumption and may
> have odd side effects.
Starting searching from mtu of 1200, but the real pmtu will only be updated
when the search is done and optimal mtu is found.
So at the beginning, it will still use the dst mtu as before.

> For TCP/UDP the ICMP segmentation required error is immediate
> and gets used for the retransmissions.
> This code seems to be looking at separate timeouts - so a lot of
> packets could get discarded and application timers expire before
> if determines the correct mtu.
This patch will also process ICMP error msg, and gets the 'mtu' size from it
but before using it, it will verify(probe) it first:

see Patch: sctp: do state transition when receiving an icmp TOOBIG packet

>
> Maybe I missed something about this only being done on inactive
> paths?
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
