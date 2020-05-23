Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143CB1DF712
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 14:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387826AbgEWMEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 08:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387741AbgEWMEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 08:04:37 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0DDC061A0E;
        Sat, 23 May 2020 05:04:36 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id l67so2385788ybl.4;
        Sat, 23 May 2020 05:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DhGzYuZdmCs4q+4fA867qJiX3xyRHjIKtnyYfMLs02I=;
        b=ichpuJ0gIuSQ2VCmkBvKBIr/6XI99zmSJr9dAZG4GCI8TclCluamytMNS1M3w6wlJN
         uoCQNqrD9uMHmlZ0MYZJ8ZA1KW4+ljvi6LB6xjNMK4o6QoH8ZabLGUzAHeLTrzCIClUY
         Iw2f5OTCJdY4tMaSSXNDCOKOqx/Hq8zvTNNjmEUS61uniS5ZSb/bHiFZ1h74b9d1p6ts
         +GAnIGQNVyjGooMjx69E4svYmMo+9G3IiSCnBqt64Guxbvg5SnsgCiqSP6kouOmQ6SuT
         sAUvZaH7PeXdfYkCDA9LBtKPdSNC1Cd+jf4Uj0h5cf8HT4ZRwfIwGma1byxZ9ktmAqnq
         msjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DhGzYuZdmCs4q+4fA867qJiX3xyRHjIKtnyYfMLs02I=;
        b=h4JqYkaGYVJ1saMxK9avGOhd1XZRYscxquKpFppeC+04dmaFBIZ5gM1ggt+evIFgmY
         od/aHzTbSDEMRUGKMMq+R0PYA6wuITDzUppSSJGpzDEcUxN/lS/NoPWZZWT12wMdRNuY
         /aw78+oYL4UwMlc6glL8VaAVw84Ko8GJKacDJVEidtiQGHnSGZknpWZt2o9TqrOrM25m
         W7iQkz0zFV1MVIWow5/cYb6A9T3pSSVung5fy4FFtkXvxAKgZXrz+ADDyAk6yl7XeJVN
         TRmT4PKH3mIKN9DZ0Zg2y8dkWoNouLxFQ6XPYnChvEqUmc3Iku52d68gn51lqgRo6RhU
         SOjQ==
X-Gm-Message-State: AOAM533Xi0iUnLfFQzij25910ZfwsGAF5E7l6s5z6xM2Bq4TKosEtEZ+
        dF739i8mc+ySxiKMLVb6g3jA3iUMsi0buUZNMjg=
X-Google-Smtp-Source: ABdhPJzpQfFvhmqh+ffL0lGGfCUKTAYxpl53Gwm9m7DeCkDOiysK4rwSC54fee+1LsCqH6/NLesyFQ9pe+KO4fg5PNc=
X-Received: by 2002:a5b:811:: with SMTP id x17mr29774810ybp.27.1590235476111;
 Sat, 23 May 2020 05:04:36 -0700 (PDT)
MIME-Version: 1.0
References: <CABUN9aCXZBTdYHSK5oSVX-HAA1wTWmyBW_ked_ydsCjsV-Ckaw@mail.gmail.com>
 <20200513160116.GA2491@localhost.localdomain> <CABUN9aCuoA+CXLujUxXyiKWQPkwq9_eOXNqOR=MK7dPY++Fxng@mail.gmail.com>
 <20200513213230.GE2491@localhost.localdomain> <CABUN9aBoxXjdPk9piKAZV-2dYOCEnuXr-4H5ZVVvqeMMFRsf7A@mail.gmail.com>
 <20200519204229.GQ2491@localhost.localdomain>
In-Reply-To: <20200519204229.GQ2491@localhost.localdomain>
From:   Jonas Falkevik <jonas.falkevik@gmail.com>
Date:   Sat, 23 May 2020 14:04:24 +0200
Message-ID: <CABUN9aD85O3mF8j72QfrC8vbXPzj5Q=L801t2M6XsbDHn+9D1A@mail.gmail.com>
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

On Tue, May 19, 2020 at 10:42 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Fri, May 15, 2020 at 10:30:29AM +0200, Jonas Falkevik wrote:
> > On Wed, May 13, 2020 at 11:32 PM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > >
> > > On Wed, May 13, 2020 at 10:11:05PM +0200, Jonas Falkevik wrote:
> > > > On Wed, May 13, 2020 at 6:01 PM Marcelo Ricardo Leitner
> > > > <marcelo.leitner@gmail.com> wrote:
> > > > >
> > > > > On Wed, May 13, 2020 at 04:52:16PM +0200, Jonas Falkevik wrote:
> > > > > > Do not generate SCTP_ADDR_{MADE_PRIM,ADDED} events for SCTP_FUTURE_ASSOC assocs.
> > > > >
> > > > > How did you get them?
> > > > >
> > > >
> > > > I think one case is when receiving INIT chunk in sctp_sf_do_5_1B_init().
> > > > Here a closed association is created, sctp_make_temp_assoc().
> > > > Which is later used when calling sctp_process_init().
> > > > In sctp_process_init() one of the first things are to call
> > > > sctp_assoc_add_peer()
> > > > on the closed / temp assoc.
> > > >
> > > > sctp_assoc_add_peer() are generating the SCTP_ADDR_ADDED event on the socket
> > > > for the potentially new association.
> > >
> > > I see, thanks. The SCTP_FUTURE_ASSOC means something different. It is
> > > for setting/getting socket options that will be used for new asocs. In
> > > this case, it is just a coincidence that asoc_id is not set (but
> > > initialized to 0) and SCTP_FUTURE_ASSOC is also 0.
> >
> > yes, you are right, I overlooked that.
> >
> > > Moreso, if I didn't
> > > miss anything, it would block valid events, such as those from
> > >  sctp_sf_do_5_1D_ce
> > >    sctp_process_init
> > > because sctp_process_init will only call sctp_assoc_set_id() by its
> > > end.
> >
> > Do we want these events at this stage?
> > Since the association is a newly established one, have the peer address changed?
> > Should we enqueue these messages with sm commands instead?
> > And drop them if we don't have state SCTP_STATE_ESTABLISHED?
> >
> > >
> > > I can't see a good reason for generating any event on temp assocs. So
> > > I'm thinking the checks on this patch should be on whether the asoc is
> > > a temporary one instead. WDYT?
> > >
> >
> > Agree, we shouldn't rely on coincidence.
> > Either check temp instead or the above mentioned state?
> >
> > > Then, considering the socket is locked, both code points should be
> > > allocating the IDR earlier. It's expensive, yes (point being, it could
> > > be avoided in case of other failures), but it should be generating
> > > events with the right assoc id. Are you interested in pursuing this
> > > fix as well?
> >
> > Sure.
> >
> > If we check temp status instead, we would need to allocate IDR earlier,
> > as you mention. So that we send the notification with correct assoc id.
> >
> > But shouldn't the SCTP_COMM_UP, for a newly established association, be the
> > first notification event sent?
> > The SCTP_COMM_UP notification is enqueued later in sctp_sf_do_5_1D_ce().
>
> The RFC doesn't mention any specific ordering for them, but it would
> make sense. Reading the FreeBSD code now (which I consider a reference
> implementation), it doesn't raise these notifications from
> INIT_ACK/COOKIE_ECHO at all. The only trigger for SCTP_ADDR_ADDED
> event is ASCONF ADD command itself. So these are extra in Linux, and
> I'm afraid we got to stick with them.
>
> Considering the error handling it already has, looks like the
> reordering is feasible and welcomed. I'm thinking the temp check and
> reordering is the best way forward here.
>
> Thoughts? Neil? Xin? The assoc_id change might be considered an UAPI
> breakage.

Some order is mentioned in RFC 6458 Chapter 6.1.1.

      SCTP_COMM_UP:  A new association is now ready, and data may be
         exchanged with this peer.  When an association has been
         established successfully, this notification should be the
         first one.

I can make a patch with a check on temp and make COMM_UP event first.
Currently the COMM_UP event is enqueued via commands
while the SCTP_ADDR_ADDED event is enqueued directly.

sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
vs.
asoc->stream.si->enqueue_event(&asoc->ulpq, event);

Do you want me to change to use commands instead of enqueing?
Or should we enqueue the COMM_UP event directly?

-Jonas
