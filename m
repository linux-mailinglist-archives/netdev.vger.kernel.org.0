Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C150D1E08E3
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388487AbgEYIfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388175AbgEYIfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 04:35:14 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB9AC061A0E;
        Mon, 25 May 2020 01:35:14 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id j198so2486720wmj.0;
        Mon, 25 May 2020 01:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=utTxuQuhV5kC1MhRAQXBvYt9lvtCYob3xbuIYIIjyLU=;
        b=EtNfOKyN2JkBQlKiwqesSu9Ry83/fCOryWZZX9yiS1f4JWidvXoCv52kuYtaNfEgsJ
         n1SWnxrzCZv0YijZwoDS7PSngrRPzDue+N5qjeMC2oEgG8BWTyDxmp8Mw8A5LZS1u9kS
         Dc9bosy43uxf2k3z2fQJ+HAN26Rnk+RQddmNI3rjgJWqproQwl3qFDiYjFRSxUIySYLR
         aY9cMYenbIAxC9tfgsKmmFMvVPyHXmzvujedBJ8Y04s7uKY9jAtCnPY3JYsqsZkaChZt
         UibY405UJk6WWrJGBAEnZ01KkwFmXwlv384HfRjiy4fJZE3GCXD5Jy1C8i6SBq9WAYNc
         Pu3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=utTxuQuhV5kC1MhRAQXBvYt9lvtCYob3xbuIYIIjyLU=;
        b=e+XNVw08MASc+JnD16uBg+BMFDARuPAoT+N0/nPqySmpek+KE7vKE5PECDHo1I63ak
         5BBolOB2Iap/YqlLdrNQVji7nwGChkaSlt5tJ417wsXThoVghVvtTKh+8D3Mv9WVL++x
         8czO4c8zWbaj7dq9VrWCo3bYsobno7wGCBzvO9MK/lrDxmvDe/PNYWBmddMfPm70AA7n
         YMdprjhWlrtLqijhlpd8ev4ioP1J+pigR2g0NPVpVc2dlWiTU2FaUsaDZi33tWmpJ18Y
         TrL064WZqXGBXfyQoyQyRy7Q/k06sKxplUzAnXNp6AKe+BFO2uki1heWOsfZgxK+HQMC
         Ftpg==
X-Gm-Message-State: AOAM5304DtZG7EO7VwFhjgeTD9urxrqNvyNrTM8LTrIqld3HqnqKzcqC
        1oN8mttuqOl2DgNy5o9OorDz5dSrN06NGDo/0UU=
X-Google-Smtp-Source: ABdhPJy7weRrpmuFm2osnwPDsf+PWFLnSm7uM6pYCY7NCCawtOic2+bfs6votgnuA/S1AwhF8ActB2xRCOnqKnAbjt0=
X-Received: by 2002:a7b:c253:: with SMTP id b19mr25292433wmj.110.1590395713230;
 Mon, 25 May 2020 01:35:13 -0700 (PDT)
MIME-Version: 1.0
References: <CABUN9aCXZBTdYHSK5oSVX-HAA1wTWmyBW_ked_ydsCjsV-Ckaw@mail.gmail.com>
 <20200513160116.GA2491@localhost.localdomain> <CABUN9aCuoA+CXLujUxXyiKWQPkwq9_eOXNqOR=MK7dPY++Fxng@mail.gmail.com>
 <20200513213230.GE2491@localhost.localdomain> <CABUN9aBoxXjdPk9piKAZV-2dYOCEnuXr-4H5ZVVvqeMMFRsf7A@mail.gmail.com>
 <20200519204229.GQ2491@localhost.localdomain> <CABUN9aD85O3mF8j72QfrC8vbXPzj5Q=L801t2M6XsbDHn+9D1A@mail.gmail.com>
In-Reply-To: <CABUN9aD85O3mF8j72QfrC8vbXPzj5Q=L801t2M6XsbDHn+9D1A@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 25 May 2020 16:42:16 +0800
Message-ID: <CADvbK_fpZWexYckNtmsEatb+JU_EW4=Xn9OpcL=Tk-a8odDHuw@mail.gmail.com>
Subject: Re: [PATCH] sctp: check assoc before SCTP_ADDR_{MADE_PRIM,ADDED} event
To:     Jonas Falkevik <jonas.falkevik@gmail.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 23, 2020 at 8:04 PM Jonas Falkevik <jonas.falkevik@gmail.com> wrote:
>
> On Tue, May 19, 2020 at 10:42 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Fri, May 15, 2020 at 10:30:29AM +0200, Jonas Falkevik wrote:
> > > On Wed, May 13, 2020 at 11:32 PM Marcelo Ricardo Leitner
> > > <marcelo.leitner@gmail.com> wrote:
> > > >
> > > > On Wed, May 13, 2020 at 10:11:05PM +0200, Jonas Falkevik wrote:
> > > > > On Wed, May 13, 2020 at 6:01 PM Marcelo Ricardo Leitner
> > > > > <marcelo.leitner@gmail.com> wrote:
> > > > > >
> > > > > > On Wed, May 13, 2020 at 04:52:16PM +0200, Jonas Falkevik wrote:
> > > > > > > Do not generate SCTP_ADDR_{MADE_PRIM,ADDED} events for SCTP_FUTURE_ASSOC assocs.
> > > > > >
> > > > > > How did you get them?
> > > > > >
> > > > >
> > > > > I think one case is when receiving INIT chunk in sctp_sf_do_5_1B_init().
> > > > > Here a closed association is created, sctp_make_temp_assoc().
> > > > > Which is later used when calling sctp_process_init().
> > > > > In sctp_process_init() one of the first things are to call
> > > > > sctp_assoc_add_peer()
> > > > > on the closed / temp assoc.
> > > > >
> > > > > sctp_assoc_add_peer() are generating the SCTP_ADDR_ADDED event on the socket
> > > > > for the potentially new association.
> > > >
> > > > I see, thanks. The SCTP_FUTURE_ASSOC means something different. It is
> > > > for setting/getting socket options that will be used for new asocs. In
> > > > this case, it is just a coincidence that asoc_id is not set (but
> > > > initialized to 0) and SCTP_FUTURE_ASSOC is also 0.
> > >
> > > yes, you are right, I overlooked that.
> > >
> > > > Moreso, if I didn't
> > > > miss anything, it would block valid events, such as those from
> > > >  sctp_sf_do_5_1D_ce
> > > >    sctp_process_init
> > > > because sctp_process_init will only call sctp_assoc_set_id() by its
> > > > end.
> > >
> > > Do we want these events at this stage?
> > > Since the association is a newly established one, have the peer address changed?
> > > Should we enqueue these messages with sm commands instead?
> > > And drop them if we don't have state SCTP_STATE_ESTABLISHED?
> > >
> > > >
> > > > I can't see a good reason for generating any event on temp assocs. So
> > > > I'm thinking the checks on this patch should be on whether the asoc is
> > > > a temporary one instead. WDYT?
> > > >
> > >
> > > Agree, we shouldn't rely on coincidence.
> > > Either check temp instead or the above mentioned state?
> > >
> > > > Then, considering the socket is locked, both code points should be
> > > > allocating the IDR earlier. It's expensive, yes (point being, it could
> > > > be avoided in case of other failures), but it should be generating
> > > > events with the right assoc id. Are you interested in pursuing this
> > > > fix as well?
> > >
> > > Sure.
> > >
> > > If we check temp status instead, we would need to allocate IDR earlier,
> > > as you mention. So that we send the notification with correct assoc id.
> > >
> > > But shouldn't the SCTP_COMM_UP, for a newly established association, be the
> > > first notification event sent?
> > > The SCTP_COMM_UP notification is enqueued later in sctp_sf_do_5_1D_ce().
> >
> > The RFC doesn't mention any specific ordering for them, but it would
> > make sense. Reading the FreeBSD code now (which I consider a reference
> > implementation), it doesn't raise these notifications from
> > INIT_ACK/COOKIE_ECHO at all. The only trigger for SCTP_ADDR_ADDED
> > event is ASCONF ADD command itself. So these are extra in Linux, and
> > I'm afraid we got to stick with them.
> >
> > Considering the error handling it already has, looks like the
> > reordering is feasible and welcomed. I'm thinking the temp check and
> > reordering is the best way forward here.
> >
> > Thoughts? Neil? Xin? The assoc_id change might be considered an UAPI
> > breakage.
>
> Some order is mentioned in RFC 6458 Chapter 6.1.1.
>
>       SCTP_COMM_UP:  A new association is now ready, and data may be
>          exchanged with this peer.  When an association has been
>          established successfully, this notification should be the
>          first one.
If this is true, as SCTP_COMM_UP event is always followed by state changed
to ESTABLISHED. So I'm thinking to NOT make addr events by checking the
state:

@@ -343,6 +343,9 @@ void sctp_ulpevent_nofity_peer_addr_change(struct
sctp_transport *transport,
        struct sockaddr_storage addr;
        struct sctp_ulpevent *event;

+       if (asoc->state < SCTP_STATE_ESTABLISHED)
+               return;
+
        memset(&addr, 0, sizeof(struct sockaddr_storage));
        memcpy(&addr, &transport->ipaddr, transport->af_specific->sockaddr_len);

It's not easy to completely do assoc_id change/event reordering/temp check.
As:

1. sctp_assoc_add_peer() is called in quite a few places where assoc_id is
   not set.
2. it's almost impossible to move SCTP_ADDR_ADDED from sctp_assoc_add_peer()
   after SCTP_COMM_UP.

>
> I can make a patch with a check on temp and make COMM_UP event first.
> Currently the COMM_UP event is enqueued via commands
> while the SCTP_ADDR_ADDED event is enqueued directly.
>
> sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
> vs.
> asoc->stream.si->enqueue_event(&asoc->ulpq, event);
>
> Do you want me to change to use commands instead of enqueing?
> Or should we enqueue the COMM_UP event directly?
>
> -Jonas
