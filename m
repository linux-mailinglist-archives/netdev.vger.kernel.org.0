Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AF31D2118
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 23:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgEMVcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 17:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728711AbgEMVce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 17:32:34 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32F5C061A0C;
        Wed, 13 May 2020 14:32:34 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id h26so1146733qtu.8;
        Wed, 13 May 2020 14:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A26fGJ89Px9TKT5FfDQDlph21JGLwE66ksaS/Q/F8qc=;
        b=OJhAG9BWcRTQOcesGOTjFYU1A4jllSMmBriAP4GeYXPeOgdqt0FSXLpHgZ1FWZLT9h
         ZrWqSF93q7aakC1EeMrchHZ5861vZgM002IlfxbHhkKlVtnxDoctsG0Gferf6NlXqGSj
         DYOLFbi3jlTYkWXAVSwpel0B+9fPkTYO1cgdmFgBZAFzzg9hXYbBPV5BhCWT/eBSWF1t
         AkpeLLUS2Tp486soxduAQhlfSrjYe0pxgO1ctU5ItmhBfkI6Ja3+UDgQL2od/1vW0Z9o
         B39JH/rr1zfg4umpOs+7ZEzn1szScpdJDc25SbeIBocFpIL4qfdCtr01AbGhLe4LsYML
         jpBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A26fGJ89Px9TKT5FfDQDlph21JGLwE66ksaS/Q/F8qc=;
        b=ul3gEAoPowPeemflbqfeFqQDMrJVk2RdUHvhQHdSd4HHUg4xhmchJVgmls8qQEVeI3
         O6tMlgEeyIUXNRwQCF7nvU3SIo1UfJ0s/EX9tQUcGFdVM6j95kV3HtmqdmlH8i/WV9/s
         v4B4GKGLEhoS4Iw7dHD+H/+tBLmDMaa9taZ6s5BarsphBuvLpTtVMJR4vQcPuw8R/mxn
         lHpAEiwtmi2FbtTLxbYCzz6YxtSbNhNVB3VP4b51KKUH3gUMnUaSI509T+uh7+BbwFh8
         7bjQzuAPbfhHXN7lmUAkls3ftFIpSehYBK6pJuBN9Ah2+GS/NYAX4pOe/K5RIzrwn7Kj
         uwjw==
X-Gm-Message-State: AOAM530zTjUmkcIbCe3SsQ2l/z+Kl6n1E9BsaNmtXSAS7SF1UN9rm0yc
        d5342SOd4XT0WzQczgfkBMk=
X-Google-Smtp-Source: ABdhPJz0LvTgZRILNLUUTLRj+osPwoofipFZkbm70QG25R3TUD61efFy8LIYbojG2TvIliuJ4Iyc+Q==
X-Received: by 2002:ac8:4890:: with SMTP id i16mr1203657qtq.299.1589405553665;
        Wed, 13 May 2020 14:32:33 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:f4e9:6bc3:5a0:7baf:1a14])
        by smtp.gmail.com with ESMTPSA id d196sm922814qkg.16.2020.05.13.14.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 14:32:32 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 383EBC08DA; Wed, 13 May 2020 18:32:30 -0300 (-03)
Date:   Wed, 13 May 2020 18:32:30 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jonas Falkevik <jonas.falkevik@gmail.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH] sctp: check assoc before SCTP_ADDR_{MADE_PRIM,ADDED}
 event
Message-ID: <20200513213230.GE2491@localhost.localdomain>
References: <CABUN9aCXZBTdYHSK5oSVX-HAA1wTWmyBW_ked_ydsCjsV-Ckaw@mail.gmail.com>
 <20200513160116.GA2491@localhost.localdomain>
 <CABUN9aCuoA+CXLujUxXyiKWQPkwq9_eOXNqOR=MK7dPY++Fxng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABUN9aCuoA+CXLujUxXyiKWQPkwq9_eOXNqOR=MK7dPY++Fxng@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 10:11:05PM +0200, Jonas Falkevik wrote:
> On Wed, May 13, 2020 at 6:01 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Wed, May 13, 2020 at 04:52:16PM +0200, Jonas Falkevik wrote:
> > > Do not generate SCTP_ADDR_{MADE_PRIM,ADDED} events for SCTP_FUTURE_ASSOC assocs.
> >
> > How did you get them?
> >
> 
> I think one case is when receiving INIT chunk in sctp_sf_do_5_1B_init().
> Here a closed association is created, sctp_make_temp_assoc().
> Which is later used when calling sctp_process_init().
> In sctp_process_init() one of the first things are to call
> sctp_assoc_add_peer()
> on the closed / temp assoc.
> 
> sctp_assoc_add_peer() are generating the SCTP_ADDR_ADDED event on the socket
> for the potentially new association.

I see, thanks. The SCTP_FUTURE_ASSOC means something different. It is
for setting/getting socket options that will be used for new asocs. In
this case, it is just a coincidence that asoc_id is not set (but
initialized to 0) and SCTP_FUTURE_ASSOC is also 0. Moreso, if I didn't
miss anything, it would block valid events, such as those from
 sctp_sf_do_5_1D_ce
   sctp_process_init
because sctp_process_init will only call sctp_assoc_set_id() by its
end.

I can't see a good reason for generating any event on temp assocs. So
I'm thinking the checks on this patch should be on whether the asoc is
a temporary one instead. WDYT?

Then, considering the socket is locked, both code points should be
allocating the IDR earlier. It's expensive, yes (point being, it could
be avoided in case of other failures), but it should be generating
events with the right assoc id. Are you interested in pursuing this
fix as well?

> 
> $ cat sctp.bpftrace
> #!/usr/local/bin/bpftrace
> 
> BEGIN
> {
>    printf("Tracing sctp_assoc_add_peer\n");
>    printf("Hit Ctrl-C to end.\n");
> }
> 
> kprobe:sctp_assoc_add_peer
> {
>    @[kstack]=count();
> }
> 
> $ sudo bpftrace sctp.bpftrace
> Attaching 2 probes...
> Tracing sctp_assoc_add_peer
> Hit Ctrl-C to end.
> ^C
> 
> @[
>    sctp_assoc_add_peer+1
>    sctp_process_init+77
>    sctp_sf_do_5_1B_init+615
>    sctp_do_sm+132
>    sctp_endpoint_bh_rcv+256
>    sctp_rcv+2379
>    ip_protocol_deliver_rcu+393
>    ip_local_deliver_finish+68
>    ip_local_deliver+203
>    ip_rcv+156
>    __netif_receive_skb_one_core+96
>    process_backlog+164
>    net_rx_action+312
>    __softirqentry_text_start+238
>    do_softirq_own_stack+42
>    do_softirq.part.0+65
>    __local_bh_enable_ip+75
>    ip_finish_output2+415
>    ip_output+102
>    __ip_queue_xmit+364
>    sctp_packet_transmit+1814
>    sctp_outq_flush_ctrl.constprop.0+394
>    sctp_outq_flush+86
>    sctp_do_sm+3914
>    sctp_primitive_ASSOCIATE+44
>    __sctp_connect+707
>    sctp_inet_connect+98
>    __sys_connect+156
>    __x64_sys_connect+22
>    do_syscall_64+91
>    entry_SYSCALL_64_after_hwframe+68
> ]: 1
> ...
> 
> > I'm thinking you're fixing a side-effect of another issue here. For
> > example, in sctp_assoc_update(), it first calls sctp_assoc_add_peer()
> > to only then call sctp_assoc_set_id(), which would generate the event
> > you might have seen. In this case, it should be allocating IDR before,
> > so that the event can be sent with the right assoc_id already.
> >
> > >
> > > These events are described in rfc6458#section-6.1
> > > SCTP_PEER_ADDR_CHANGE:
> > > This tag indicates that an address that is
> > > part of an existing association has experienced a change of
> > > state (e.g., a failure or return to service of the reachability
> > > of an endpoint via a specific transport address).
> > >
> > > Signed-off-by: Jonas Falkevik <jonas.falkevik@gmail.com>
> > > ---
> > >  net/sctp/associola.c | 11 ++++++++---
> > >  1 file changed, 8 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> > > index 437079a4883d..0c5dd295f9b8 100644
> > > --- a/net/sctp/associola.c
> > > +++ b/net/sctp/associola.c
> > > @@ -432,8 +432,10 @@ void sctp_assoc_set_primary(struct sctp_association *asoc,
> > >          changeover = 1 ;
> > >
> > >      asoc->peer.primary_path = transport;
> > > -    sctp_ulpevent_nofity_peer_addr_change(transport,
> > > -                          SCTP_ADDR_MADE_PRIM, 0);
> > > +    if (sctp_assoc2id(asoc) != SCTP_FUTURE_ASSOC)
> > > +        sctp_ulpevent_nofity_peer_addr_change(transport,
> > > +                              SCTP_ADDR_MADE_PRIM,
> > > +                              0);
> > >
> > >      /* Set a default msg_name for events. */
> > >      memcpy(&asoc->peer.primary_addr, &transport->ipaddr,
> > > @@ -714,7 +716,10 @@ struct sctp_transport *sctp_assoc_add_peer(struct
> > > sctp_association *asoc,
> > >      list_add_tail_rcu(&peer->transports, &asoc->peer.transport_addr_list);
> > >      asoc->peer.transport_count++;
> > >
> > > -    sctp_ulpevent_nofity_peer_addr_change(peer, SCTP_ADDR_ADDED, 0);
> > > +    if (sctp_assoc2id(asoc) != SCTP_FUTURE_ASSOC)
> > > +        sctp_ulpevent_nofity_peer_addr_change(peer,
> > > +                              SCTP_ADDR_ADDED,
> > > +                              0);
> > >
> > >      /* If we do not yet have a primary path, set one.  */
> > >      if (!asoc->peer.primary_path) {
> > > --
> > > 2.25.3
