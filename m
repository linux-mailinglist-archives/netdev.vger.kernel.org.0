Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63AD3B1275
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 05:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFWDvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 23:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFWDvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 23:51:01 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63158C061574;
        Tue, 22 Jun 2021 20:48:44 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id h21-20020a1ccc150000b02901d4d33c5ca0so358287wmb.3;
        Tue, 22 Jun 2021 20:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8+ZeLnwHh9Py0eDeZIZvkJQttIs0sxzhqw37BA3s270=;
        b=qlWreJ/BoQONV/bBEO+485rLDa7rgGeR7Xu6Ve+1XJU6wbKjZKUJaNVDVnBMH65DQY
         FXN1TjCpmXE2QOe9g5i8zT5/2pk4to0/vT+7TYDirQ7Jzu6Ucxzgn2GXJqwJK6/+Ap5p
         jYEWQdWvyXjDFGDXab5xQNyzM1JSgKoSpc5c0OBXfig6KyAUH7OSPqRl0d2n3cn57AGY
         zpAVeNxUnnaY4Frx4AO/mNJHXZA329LQM71+DtuW91R+uB4mU32SRL0/QyWayCbgU4zJ
         /awWYA1g5mHS9OCK7mnQIPcRWZoqGz7nMddb8Uee0H3P+KI4VSOXgpIaRITrQ7jCSu2F
         1Fcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8+ZeLnwHh9Py0eDeZIZvkJQttIs0sxzhqw37BA3s270=;
        b=KzsH2LusU0vVqA1P/7RPqz/dl1gBU9s1RabGs3HXKq4mjN5L6+ZBJCzNrcxgXfsdle
         IEM8pGpR0QpmFCpAPgcQctjhvy9nd/DVSt0ShYpk4IiLju5dkHPH/AakGHiqKkX0yCrW
         pEwZa2V7qaFD0ibhUdNJWpBbtEz/OOhE1sMlIWW9n6wkNldmu30g4/4I9i8qiXMPL7ol
         0WC1wD4ccUPWoR+gH7ajO858QYI3z3mrkABjvVMxLK2XBlA1AIgBItqGkX/DL5sgmgDc
         Zup5b+cyZd+gffPqnECBueaBQg4POyIfT7VuUyyQUlhDYowgyt42rEFTs0+cE5SFGOVm
         LCRQ==
X-Gm-Message-State: AOAM531RatzdrpHCwg23PKICApvs+n2mnHVr3X6plvC0i1r6XqGxKz8x
        FWZtNmbxKCv325RTQdYLmeNTzM9btKRKI5NgWq8=
X-Google-Smtp-Source: ABdhPJzFgactEuWl5qZafUmm5ynYzUFp21GHhNlV06lVCPK9bXBCIS5NB3nCJYmQbe6HRCPbi6K5IPfdm/womrknF0I=
X-Received: by 2002:a1c:5413:: with SMTP id i19mr8616884wmb.12.1624420122997;
 Tue, 22 Jun 2021 20:48:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1624384990.git.lucien.xin@gmail.com> <cfaa01992d064520b3a9138983e8ec41@AcuMS.aculab.com>
 <CADvbK_e7D4s81vS0rq=P4mQe47dshJgQzaWnrUyCi-Cis4xyhQ@mail.gmail.com>
In-Reply-To: <CADvbK_e7D4s81vS0rq=P4mQe47dshJgQzaWnrUyCi-Cis4xyhQ@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 22 Jun 2021 23:48:33 -0400
Message-ID: <CADvbK_eeJVoWps8UrygEfNdXL76Q2XMoNOoELWHFqOTq2634cA@mail.gmail.com>
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

On Tue, Jun 22, 2021 at 9:09 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Tue, Jun 22, 2021 at 6:13 PM David Laight <David.Laight@aculab.com> wrote:
> >
> > From: Xin Long
> > > Sent: 22 June 2021 19:05
> > >
> > > Overview(From RFC8899):
> > >
> > >   In contrast to PMTUD, Packetization Layer Path MTU Discovery
> > >   (PLPMTUD) [RFC4821] introduces a method that does not rely upon
> > >   reception and validation of PTB messages.  It is therefore more
> > >   robust than Classical PMTUD.  This has become the recommended
> > >   approach for implementing discovery of the PMTU [BCP145].
> > >
> > >   It uses a general strategy in which the PL sends probe packets to
> > >   search for the largest size of unfragmented datagram that can be sent
> > >   over a network path.  Probe packets are sent to explore using a
> > >   larger packet size.  If a probe packet is successfully delivered (as
> > >   determined by the PL), then the PLPMTU is raised to the size of the
> > >   successful probe.  If a black hole is detected (e.g., where packets
> > >   of size PLPMTU are consistently not received), the method reduces the
> > >   PLPMTU.
> >
> > This seems to take a long time (probably well over a minute)
> > to determine the mtu.
> I just noticed this is a misread of RFC8899, and the next probe packet
> should be sent immediately once the ACK of the last probe is received,
> instead of waiting the timeout, which should be for the missing probe.
>
> I will fix this with:
>
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index d29b579da904..f3aca1acf93a 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -1275,6 +1275,8 @@ enum sctp_disposition
> sctp_sf_backbeat_8_3(struct net *net,
>                         return SCTP_DISPOSITION_DISCARD;
>
>                 sctp_transport_pl_recv(link);
> +               sctp_add_cmd_sf(commands, SCTP_CMD_PROBE_TIMER_UPDATE,
> +                               SCTP_TRANSPORT(link));
>                 return SCTP_DISPOSITION_CONSUME;
>         }
>
> diff --git a/net/sctp/transport.c b/net/sctp/transport.c
> index f27b856ea8ce..88815b98d9d0 100644
> --- a/net/sctp/transport.c
> +++ b/net/sctp/transport.c
> @@ -215,6 +215,11 @@ void sctp_transport_reset_probe_timer(struct
> sctp_transport *transport)
>  {
>         int scale = 1;
>
> +       if (transport->pl.probe_count == 0) {
> +               if (!mod_timer(&transport->probe_timer, jiffies +
> transport->rto))
> +                       sctp_transport_hold(transport);
> +               return;
> +       }
>         if (timer_pending(&transport->probe_timer))
>                 return;
>         if (transport->pl.state == SCTP_PL_COMPLETE &&
>
> Thanks for the comment.
A more efficient improvement:

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index d29b579da904..d5cb0124bafa 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1275,7 +1275,13 @@ enum sctp_disposition
sctp_sf_backbeat_8_3(struct net *net,
                        return SCTP_DISPOSITION_DISCARD;

                sctp_transport_pl_recv(link);
-               return SCTP_DISPOSITION_CONSUME;
+
+               if (link->pl.state == SCTP_PL_COMPLETE) {
+                       sctp_add_cmd_sf(commands, SCTP_CMD_PROBE_TIMER_UPDATE,
+                                       SCTP_TRANSPORT(link));
+                       return SCTP_DISPOSITION_CONSUME;
+               }
+               return sctp_sf_send_probe(net, ep, asoc, type, link, commands);
        }

        max_interval = link->hbinterval + link->rto;
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index f27b856ea8ce..37f65f617f05 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -215,10 +215,8 @@ void sctp_transport_reset_probe_timer(struct
sctp_transport *transport)
 {
        int scale = 1;

-       if (timer_pending(&transport->probe_timer))
-               return;
        if (transport->pl.state == SCTP_PL_COMPLETE &&
-           transport->pl.probe_count == 1)
+           transport->pl.probe_count == 0)
                scale = 30; /* works as PMTU_RAISE_TIMER */
        if (!mod_timer(&transport->probe_timer,
                       jiffies + transport->probe_interval * scale))

[103] pl_send: PLPMTUD: state: 1, size: 1200, high: 0 <--[a]
[103] pl_recv: PLPMTUD: state: 1, size: 1200, high: 0
[103] pl_send: PLPMTUD: state: 2, size: 1232, high: 0
[103] pl_recv: PLPMTUD: state: 2, size: 1232, high: 0
[103] pl_send: PLPMTUD: state: 2, size: 1264, high: 0
[103] pl_recv: PLPMTUD: state: 2, size: 1264, high: 0
[103] pl_send: PLPMTUD: state: 2, size: 1296, high: 0
[103] pl_recv: PLPMTUD: state: 2, size: 1296, high: 0
[103] pl_send: PLPMTUD: state: 2, size: 1328, high: 0
[103] pl_recv: PLPMTUD: state: 2, size: 1328, high: 0
[103] pl_send: PLPMTUD: state: 2, size: 1360, high: 0
[103] pl_recv: PLPMTUD: state: 2, size: 1360, high: 0
[103] pl_send: PLPMTUD: state: 2, size: 1392, high: 0
[103] pl_recv: PLPMTUD: state: 2, size: 1392, high: 0
[103] pl_send: PLPMTUD: state: 2, size: 1424, high: 0
[103] pl_recv: PLPMTUD: state: 2, size: 1424, high: 0
[103] pl_send: PLPMTUD: state: 2, size: 1456, high: 0
[103] pl_recv: PLPMTUD: state: 2, size: 1456, high: 0  <--[b]
[103] pl_send: PLPMTUD: state: 2, size: 1488, high: 0
[108] pl_send: PLPMTUD: state: 2, size: 1488, high: 0
[113] pl_send: PLPMTUD: state: 2, size: 1488, high: 0
[118] pl_send: PLPMTUD: state: 2, size: 1488, high: 0
[118] pl_recv: PLPMTUD: state: 2, size: 1456, high: 1488 <---[c]
[118] pl_send: PLPMTUD: state: 2, size: 1460, high: 1488
[118] pl_recv: PLPMTUD: state: 2, size: 1460, high: 1488 <--- [d]
[118] pl_send: PLPMTUD: state: 2, size: 1464, high: 1488
[124] pl_send: PLPMTUD: state: 2, size: 1464, high: 1488
[129] pl_send: PLPMTUD: state: 2, size: 1464, high: 1488
[134] pl_send: PLPMTUD: state: 2, size: 1464, high: 1488
[134] pl_recv: PLPMTUD: state: 2, size: 1460, high: 1464 <-- around
30s "search complete from 1200 bytes"
[287] pl_send: PLPMTUD: state: 3, size: 1460, high: 0
[287] pl_recv: PLPMTUD: state: 3, size: 1460, high: 0
[287] pl_send: PLPMTUD: state: 2, size: 1464, high: 0 <-- [aa]
[292] pl_send: PLPMTUD: state: 2, size: 1464, high: 0
[298] pl_send: PLPMTUD: state: 2, size: 1464, high: 0
[303] pl_send: PLPMTUD: state: 2, size: 1464, high: 0
[303] pl_recv: PLPMTUD: state: 2, size: 1460, high: 1464  <--[bb]  <--
around 15s "re-search complete from current pmtu"

So since no interval to send the next probe when the ACK is received
for the last one,
it won't take much time from [a] to [b], and [c] to [d],
and there are at most 2 failures to find the right pmtu, each failure
takes 5s * 3 = 15s.

when it goes back to search from search complete after a long timeout,
it will take only 1 failure to get the right pmtu from [aa] to [bb].

 Thanks.
> >
> > What is used for the actual mtu while this is in progress?
> >
> > Does packet loss and packet retransmission cause the mtu
> > to be reduced as well?
> No, the data packet is not a probe in this implementation.
>
> >
> > I can imagine that there is an expectation (from the application)
> > that the mtu is that of an ethernet link - perhaps less a PPPoE
> > header.
> > Starting with an mtu of 1200 will break this assumption and may
> > have odd side effects.
> Starting searching from mtu of 1200, but the real pmtu will only be updated
> when the search is done and optimal mtu is found.
> So at the beginning, it will still use the dst mtu as before.
>
> > For TCP/UDP the ICMP segmentation required error is immediate
> > and gets used for the retransmissions.
> > This code seems to be looking at separate timeouts - so a lot of
> > packets could get discarded and application timers expire before
> > if determines the correct mtu.
> This patch will also process ICMP error msg, and gets the 'mtu' size from it
> but before using it, it will verify(probe) it first:
>
> see Patch: sctp: do state transition when receiving an icmp TOOBIG packet
>
> >
> > Maybe I missed something about this only being done on inactive
> > paths?
> >
> >         David
> >
> > -
> > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > Registration No: 1397386 (Wales)
> >
