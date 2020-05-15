Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4571D4824
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgEOIam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726694AbgEOIam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 04:30:42 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E18C061A0C;
        Fri, 15 May 2020 01:30:41 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id b8so739268ybn.0;
        Fri, 15 May 2020 01:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EC0F16Lhf+mGr9sBBMIazR5Y1Rhhl5byvyHX6wEiBSA=;
        b=pRLpDEx1Oe+fTmC/biGMXuMA0uac1MntTWM5YhXJxnljsaKtNfN84KMoe8IIqanVX/
         4HqhjGaAOv9dC3mxRrFUMbpUeykI2wHus829SN2eCeETavkB1LSLPCTcahUsBnBl+Uus
         TXpomhTDN2Z/KdHpJACLdG9wtOR8VewLby8rAVNHL3FDjwFBVcw6FKWbXjhs/QQ0YbYP
         Kz8rm3HoAc3HygRinCrZblgESJxgQq0oIopLw3JTvcwBRK3B52n6UC2W40Sq89CDNx4b
         YuT/tHGESqEndPyxSgrumAded88CTc27uf1cuwaILhBiXokUPDnAkLjEal0hwLJX3DFM
         YKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EC0F16Lhf+mGr9sBBMIazR5Y1Rhhl5byvyHX6wEiBSA=;
        b=ld3y4eoOyU/t6cEswhcSedQg8Bmy2IYtN4BYYGu4LlInPnnnVfZouaUXR9jERJnWaC
         cTrsdjaCK0ZvDmKDVg/xXGoXVZdCkRvvrkBllvuKEpgds219eGf01fiR+zwCFgwL/Vqw
         9gvvqhqECVtqU/VbV7w2GblQD8nSH6n30u4XAxFRYbIiZHc+yO1K2HODmlBQwDBwXAhl
         xXDpqUzeYJrfw7y9RHH3h2NKYyIxlWbrzW12hx4MsAzvAHpNFjf9l3jFRsiKvEIa34Hx
         OnoqU4nSyiDNjlU813Ks1qH7SxM9HiK9C7iNQ79Qs36ndjaNoQlSpW0d4ympQ2D/RqvW
         6Dag==
X-Gm-Message-State: AOAM532SeRmPrD4sT6l27GTAahIJXvpVirW0I5al0PQV8/NrsRSuxRau
        bBOdozg5FK5ENG+j2e6Zsp8ZULN1mwKi4lSlrHDWkroM
X-Google-Smtp-Source: ABdhPJyorroK1wIpDSj3snZLmNxYQFwFupZ+Hyj/bGWY4gBbB5HKXHs+1Ft6QvjZfk6wdA87myP6piV07MBWNHH6cSo=
X-Received: by 2002:a25:bb03:: with SMTP id z3mr3630143ybg.6.1589531440987;
 Fri, 15 May 2020 01:30:40 -0700 (PDT)
MIME-Version: 1.0
References: <CABUN9aCXZBTdYHSK5oSVX-HAA1wTWmyBW_ked_ydsCjsV-Ckaw@mail.gmail.com>
 <20200513160116.GA2491@localhost.localdomain> <CABUN9aCuoA+CXLujUxXyiKWQPkwq9_eOXNqOR=MK7dPY++Fxng@mail.gmail.com>
 <20200513213230.GE2491@localhost.localdomain>
In-Reply-To: <20200513213230.GE2491@localhost.localdomain>
From:   Jonas Falkevik <jonas.falkevik@gmail.com>
Date:   Fri, 15 May 2020 10:30:29 +0200
Message-ID: <CABUN9aBoxXjdPk9piKAZV-2dYOCEnuXr-4H5ZVVvqeMMFRsf7A@mail.gmail.com>
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

On Wed, May 13, 2020 at 11:32 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, May 13, 2020 at 10:11:05PM +0200, Jonas Falkevik wrote:
> > On Wed, May 13, 2020 at 6:01 PM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > >
> > > On Wed, May 13, 2020 at 04:52:16PM +0200, Jonas Falkevik wrote:
> > > > Do not generate SCTP_ADDR_{MADE_PRIM,ADDED} events for SCTP_FUTURE_ASSOC assocs.
> > >
> > > How did you get them?
> > >
> >
> > I think one case is when receiving INIT chunk in sctp_sf_do_5_1B_init().
> > Here a closed association is created, sctp_make_temp_assoc().
> > Which is later used when calling sctp_process_init().
> > In sctp_process_init() one of the first things are to call
> > sctp_assoc_add_peer()
> > on the closed / temp assoc.
> >
> > sctp_assoc_add_peer() are generating the SCTP_ADDR_ADDED event on the socket
> > for the potentially new association.
>
> I see, thanks. The SCTP_FUTURE_ASSOC means something different. It is
> for setting/getting socket options that will be used for new asocs. In
> this case, it is just a coincidence that asoc_id is not set (but
> initialized to 0) and SCTP_FUTURE_ASSOC is also 0.

yes, you are right, I overlooked that.

> Moreso, if I didn't
> miss anything, it would block valid events, such as those from
>  sctp_sf_do_5_1D_ce
>    sctp_process_init
> because sctp_process_init will only call sctp_assoc_set_id() by its
> end.

Do we want these events at this stage?
Since the association is a newly established one, have the peer address changed?
Should we enqueue these messages with sm commands instead?
And drop them if we don't have state SCTP_STATE_ESTABLISHED?

>
> I can't see a good reason for generating any event on temp assocs. So
> I'm thinking the checks on this patch should be on whether the asoc is
> a temporary one instead. WDYT?
>

Agree, we shouldn't rely on coincidence.
Either check temp instead or the above mentioned state?

> Then, considering the socket is locked, both code points should be
> allocating the IDR earlier. It's expensive, yes (point being, it could
> be avoided in case of other failures), but it should be generating
> events with the right assoc id. Are you interested in pursuing this
> fix as well?

Sure.

If we check temp status instead, we would need to allocate IDR earlier,
as you mention. So that we send the notification with correct assoc id.

But shouldn't the SCTP_COMM_UP, for a newly established association, be the
first notification event sent?
The SCTP_COMM_UP notification is enqueued later in sctp_sf_do_5_1D_ce().


>
> >
> > $ cat sctp.bpftrace
> > #!/usr/local/bin/bpftrace
> >
> > BEGIN
> > {
> >    printf("Tracing sctp_assoc_add_peer\n");
> >    printf("Hit Ctrl-C to end.\n");
> > }
> >
> > kprobe:sctp_assoc_add_peer
> > {
> >    @[kstack]=count();
> > }
> >
> > $ sudo bpftrace sctp.bpftrace
> > Attaching 2 probes...
> > Tracing sctp_assoc_add_peer
> > Hit Ctrl-C to end.
> > ^C
> >
> > @[
> >    sctp_assoc_add_peer+1
> >    sctp_process_init+77
> >    sctp_sf_do_5_1B_init+615
> >    sctp_do_sm+132
> >    sctp_endpoint_bh_rcv+256
> >    sctp_rcv+2379
> >    ip_protocol_deliver_rcu+393
> >    ip_local_deliver_finish+68
> >    ip_local_deliver+203
> >    ip_rcv+156
> >    __netif_receive_skb_one_core+96
> >    process_backlog+164
> >    net_rx_action+312
> >    __softirqentry_text_start+238
> >    do_softirq_own_stack+42
> >    do_softirq.part.0+65
> >    __local_bh_enable_ip+75
> >    ip_finish_output2+415
> >    ip_output+102
> >    __ip_queue_xmit+364
> >    sctp_packet_transmit+1814
> >    sctp_outq_flush_ctrl.constprop.0+394
> >    sctp_outq_flush+86
> >    sctp_do_sm+3914
> >    sctp_primitive_ASSOCIATE+44
> >    __sctp_connect+707
> >    sctp_inet_connect+98
> >    __sys_connect+156
> >    __x64_sys_connect+22
> >    do_syscall_64+91
> >    entry_SYSCALL_64_after_hwframe+68
> > ]: 1
> > ...
> >
> > > I'm thinking you're fixing a side-effect of another issue here. For
> > > example, in sctp_assoc_update(), it first calls sctp_assoc_add_peer()
> > > to only then call sctp_assoc_set_id(), which would generate the event
> > > you might have seen. In this case, it should be allocating IDR before,
> > > so that the event can be sent with the right assoc_id already.
> > >
> > > >
> > > > These events are described in rfc6458#section-6.1
> > > > SCTP_PEER_ADDR_CHANGE:
> > > > This tag indicates that an address that is
> > > > part of an existing association has experienced a change of
> > > > state (e.g., a failure or return to service of the reachability
> > > > of an endpoint via a specific transport address).
> > > >
> > > > Signed-off-by: Jonas Falkevik <jonas.falkevik@gmail.com>
> > > > ---
> > > >  net/sctp/associola.c | 11 ++++++++---
> > > >  1 file changed, 8 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> > > > index 437079a4883d..0c5dd295f9b8 100644
> > > > --- a/net/sctp/associola.c
> > > > +++ b/net/sctp/associola.c
> > > > @@ -432,8 +432,10 @@ void sctp_assoc_set_primary(struct sctp_association *asoc,
> > > >          changeover = 1 ;
> > > >
> > > >      asoc->peer.primary_path = transport;
> > > > -    sctp_ulpevent_nofity_peer_addr_change(transport,
> > > > -                          SCTP_ADDR_MADE_PRIM, 0);
> > > > +    if (sctp_assoc2id(asoc) != SCTP_FUTURE_ASSOC)
> > > > +        sctp_ulpevent_nofity_peer_addr_change(transport,
> > > > +                              SCTP_ADDR_MADE_PRIM,
> > > > +                              0);
> > > >
> > > >      /* Set a default msg_name for events. */
> > > >      memcpy(&asoc->peer.primary_addr, &transport->ipaddr,
> > > > @@ -714,7 +716,10 @@ struct sctp_transport *sctp_assoc_add_peer(struct
> > > > sctp_association *asoc,
> > > >      list_add_tail_rcu(&peer->transports, &asoc->peer.transport_addr_list);
> > > >      asoc->peer.transport_count++;
> > > >
> > > > -    sctp_ulpevent_nofity_peer_addr_change(peer, SCTP_ADDR_ADDED, 0);
> > > > +    if (sctp_assoc2id(asoc) != SCTP_FUTURE_ASSOC)
> > > > +        sctp_ulpevent_nofity_peer_addr_change(peer,
> > > > +                              SCTP_ADDR_ADDED,
> > > > +                              0);
> > > >
> > > >      /* If we do not yet have a primary path, set one.  */
> > > >      if (!asoc->peer.primary_path) {
> > > > --
> > > > 2.25.3
