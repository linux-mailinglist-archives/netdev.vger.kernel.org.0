Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43ECC1D1FDC
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 22:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390832AbgEMULU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 16:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388033AbgEMULT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 16:11:19 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8696EC061A0C;
        Wed, 13 May 2020 13:11:19 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id g185so680831qke.7;
        Wed, 13 May 2020 13:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bu6Mn7nu/2nMhVqLxMtcXhprIvb1oiL88xKXB3rFnvs=;
        b=ha2rz7a+uJSIrsNLif4JDODHzjcRXp87jUXkhEL+uI8YXozF6E43esRWkYOsJzLrSM
         ByTUwpBZpCbutk1E+8Joqld19nq3FK/B5nHwWJ//YPb7IjJIY8MWOoLCASo0fEDL/86d
         DnSjFGMeYuRF2yGqfW1B2Lgk4Pip9qE7Y4w8nIdM7/lMSJZEnxx7EbvhjX6JxFWao368
         hFQB9e9zwx9vSXH3CjKICejxKsJKXNRmsedmcnoM/KSVmiH5JyAS+zETrHTy/O4XFaQo
         xWvJRPMY9SVeMXkLzr4NhIquCG0k5yr0Wui6w7PK0/ibVMqKPE8DWSlHyUHg1LcKbnJt
         713Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bu6Mn7nu/2nMhVqLxMtcXhprIvb1oiL88xKXB3rFnvs=;
        b=MQSGV8C8AR93lRbLcLD21EBhWzE3NDfP/lLR5qxvFScK3W+pnSDWe5UzVVP/zclT5p
         vnI+n/yP2DOUozk/aYD8R2c1vuk+MzNASJTqvw/yu4WmsbkYbw8R3LOluYs8h49NttLU
         fk3d/8gGMwmbHfobLJ32+hy7JUcAc/y+m3fD01AYHXF00uCl3R7RBfXDR85XREAf2vK7
         wvdAol8HMZpXXrMEx70+55hdBkADAil1Ai7h5+bP8R7G/rlrLtZcUX8o8pbgSplPj2XA
         7gWYjhR+NEN64IXNJlmA7lVumJbcvKEu6A7Y3WArDnzmxWBeNgwUSIO3E9uKTT/C3hpy
         hg0A==
X-Gm-Message-State: AOAM530yrEfZWgx1a+/leyQrUoypk/UxBrdJqb185TZvS3pDUmDTpvUB
        Ppeu1LjhZtquplEfNgPEG1xQurL6Az/NkIaxSKvrXvQ//xs=
X-Google-Smtp-Source: ABdhPJy9XpniT38I13QZIJ/GI7X+4v3jGCbSZ0uedfL9qJ9DsRL9/uVljftMTDd9/4jjkJLUfKHeFS0MrhTajYNO8No=
X-Received: by 2002:a25:d103:: with SMTP id i3mr1370559ybg.182.1589400678679;
 Wed, 13 May 2020 13:11:18 -0700 (PDT)
MIME-Version: 1.0
References: <CABUN9aCXZBTdYHSK5oSVX-HAA1wTWmyBW_ked_ydsCjsV-Ckaw@mail.gmail.com>
 <20200513160116.GA2491@localhost.localdomain>
In-Reply-To: <20200513160116.GA2491@localhost.localdomain>
From:   Jonas Falkevik <jonas.falkevik@gmail.com>
Date:   Wed, 13 May 2020 22:11:05 +0200
Message-ID: <CABUN9aCuoA+CXLujUxXyiKWQPkwq9_eOXNqOR=MK7dPY++Fxng@mail.gmail.com>
Subject: Re: [PATCH] sctp: check assoc before SCTP_ADDR_{MADE_PRIM,ADDED} event
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 6:01 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, May 13, 2020 at 04:52:16PM +0200, Jonas Falkevik wrote:
> > Do not generate SCTP_ADDR_{MADE_PRIM,ADDED} events for SCTP_FUTURE_ASSOC assocs.
>
> How did you get them?
>

I think one case is when receiving INIT chunk in sctp_sf_do_5_1B_init().
Here a closed association is created, sctp_make_temp_assoc().
Which is later used when calling sctp_process_init().
In sctp_process_init() one of the first things are to call
sctp_assoc_add_peer()
on the closed / temp assoc.

sctp_assoc_add_peer() are generating the SCTP_ADDR_ADDED event on the socket
for the potentially new association.

$ cat sctp.bpftrace
#!/usr/local/bin/bpftrace

BEGIN
{
   printf("Tracing sctp_assoc_add_peer\n");
   printf("Hit Ctrl-C to end.\n");
}

kprobe:sctp_assoc_add_peer
{
   @[kstack]=count();
}

$ sudo bpftrace sctp.bpftrace
Attaching 2 probes...
Tracing sctp_assoc_add_peer
Hit Ctrl-C to end.
^C

@[
   sctp_assoc_add_peer+1
   sctp_process_init+77
   sctp_sf_do_5_1B_init+615
   sctp_do_sm+132
   sctp_endpoint_bh_rcv+256
   sctp_rcv+2379
   ip_protocol_deliver_rcu+393
   ip_local_deliver_finish+68
   ip_local_deliver+203
   ip_rcv+156
   __netif_receive_skb_one_core+96
   process_backlog+164
   net_rx_action+312
   __softirqentry_text_start+238
   do_softirq_own_stack+42
   do_softirq.part.0+65
   __local_bh_enable_ip+75
   ip_finish_output2+415
   ip_output+102
   __ip_queue_xmit+364
   sctp_packet_transmit+1814
   sctp_outq_flush_ctrl.constprop.0+394
   sctp_outq_flush+86
   sctp_do_sm+3914
   sctp_primitive_ASSOCIATE+44
   __sctp_connect+707
   sctp_inet_connect+98
   __sys_connect+156
   __x64_sys_connect+22
   do_syscall_64+91
   entry_SYSCALL_64_after_hwframe+68
]: 1
...

> I'm thinking you're fixing a side-effect of another issue here. For
> example, in sctp_assoc_update(), it first calls sctp_assoc_add_peer()
> to only then call sctp_assoc_set_id(), which would generate the event
> you might have seen. In this case, it should be allocating IDR before,
> so that the event can be sent with the right assoc_id already.
>
> >
> > These events are described in rfc6458#section-6.1
> > SCTP_PEER_ADDR_CHANGE:
> > This tag indicates that an address that is
> > part of an existing association has experienced a change of
> > state (e.g., a failure or return to service of the reachability
> > of an endpoint via a specific transport address).
> >
> > Signed-off-by: Jonas Falkevik <jonas.falkevik@gmail.com>
> > ---
> >  net/sctp/associola.c | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> > index 437079a4883d..0c5dd295f9b8 100644
> > --- a/net/sctp/associola.c
> > +++ b/net/sctp/associola.c
> > @@ -432,8 +432,10 @@ void sctp_assoc_set_primary(struct sctp_association *asoc,
> >          changeover = 1 ;
> >
> >      asoc->peer.primary_path = transport;
> > -    sctp_ulpevent_nofity_peer_addr_change(transport,
> > -                          SCTP_ADDR_MADE_PRIM, 0);
> > +    if (sctp_assoc2id(asoc) != SCTP_FUTURE_ASSOC)
> > +        sctp_ulpevent_nofity_peer_addr_change(transport,
> > +                              SCTP_ADDR_MADE_PRIM,
> > +                              0);
> >
> >      /* Set a default msg_name for events. */
> >      memcpy(&asoc->peer.primary_addr, &transport->ipaddr,
> > @@ -714,7 +716,10 @@ struct sctp_transport *sctp_assoc_add_peer(struct
> > sctp_association *asoc,
> >      list_add_tail_rcu(&peer->transports, &asoc->peer.transport_addr_list);
> >      asoc->peer.transport_count++;
> >
> > -    sctp_ulpevent_nofity_peer_addr_change(peer, SCTP_ADDR_ADDED, 0);
> > +    if (sctp_assoc2id(asoc) != SCTP_FUTURE_ASSOC)
> > +        sctp_ulpevent_nofity_peer_addr_change(peer,
> > +                              SCTP_ADDR_ADDED,
> > +                              0);
> >
> >      /* If we do not yet have a primary path, set one.  */
> >      if (!asoc->peer.primary_path) {
> > --
> > 2.25.3
