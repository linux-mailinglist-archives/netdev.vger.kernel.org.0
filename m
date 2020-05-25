Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1EF1E154F
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 22:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390613AbgEYUtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 16:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388714AbgEYUtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 16:49:19 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A4BC061A0E;
        Mon, 25 May 2020 13:49:19 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id 67so8805747ybn.11;
        Mon, 25 May 2020 13:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X2wJfkwbKoafaibyK+N9Ncu/Ynk3DXqdQFTHlcWriCI=;
        b=DLoQT+V2udFTowJHySdOBw06G/UIsYeLP87d30xgz4hAP0qMlOlBknkyKi7woMm59x
         +I+r/LdT0/H+xSs4dWDSHY53MDe87qjqdx7N475LOSVb39FUQ60zqwVlF4QeYURRriMw
         lTvf7XbjTfXP6X5qxhb771G7IZauyztXEchfwysAeOqt5d/hpzuH/zM5uKwNSerEDXjx
         Mgk/vZurhuzImXDUVqmsGUcIUra9cQKxJ7EY5iKiPPL3sBdBSTXlv4s6VKcfDvS6mvu5
         aFU/+YmczMahVOFpixeJtUtViIE/gvioCDKzBuHpMUW3+AADYfqOVRBkeeP2/3xdhTu0
         nNQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X2wJfkwbKoafaibyK+N9Ncu/Ynk3DXqdQFTHlcWriCI=;
        b=jTg7FUg5YI+6Rg32+tEIijb3qfK7hnJFF+UM6Y2jz6hUGHAtzFfFR+04+5BiIZuN/x
         DViT1v4d/QIB+1d0xAQom8WjrHKYCfy4QiNMyPt1BfbBFktZ+NaJcWdRNBhRwvVLRfcr
         l3dfc3x9ZTvGOePTDFRwOPIWai2TbxHU9Chr5+0iDmxjHvu6FZCI89fuj2PXrMgKEvTX
         eFOgDH4iNUWKWbaf2hV3aAXooCDwHiYFuZRskp9pY4lY8ORArIQ/itu33Ri2E1onLK/J
         aid/HKNGwFImZrFjH1814E3cKM0pRp/lqZhhVK+CGsem8jE1DziaBkuwORGSWu5eprSX
         ZipQ==
X-Gm-Message-State: AOAM531Fs1vbfX5cQI42NynfWpEroI8Tcm7oONXTxyVqylMlcDFEn/3q
        OrpGwg6zifxhfKAQ1k9crorEsHTtgc9C1vEZLVw=
X-Google-Smtp-Source: ABdhPJzgpiJqdMUzZN83thhRsUTHOOWHt309UKnrE8jNJgje+Vakr1QMGa452UN65oM+b/Yhru6vCtiKbNu05k8H07M=
X-Received: by 2002:a25:c08b:: with SMTP id c133mr44862469ybf.286.1590439758754;
 Mon, 25 May 2020 13:49:18 -0700 (PDT)
MIME-Version: 1.0
References: <CABUN9aCXZBTdYHSK5oSVX-HAA1wTWmyBW_ked_ydsCjsV-Ckaw@mail.gmail.com>
 <20200513160116.GA2491@localhost.localdomain> <CABUN9aCuoA+CXLujUxXyiKWQPkwq9_eOXNqOR=MK7dPY++Fxng@mail.gmail.com>
 <20200513213230.GE2491@localhost.localdomain> <CABUN9aBoxXjdPk9piKAZV-2dYOCEnuXr-4H5ZVVvqeMMFRsf7A@mail.gmail.com>
 <20200519204229.GQ2491@localhost.localdomain> <CABUN9aD85O3mF8j72QfrC8vbXPzj5Q=L801t2M6XsbDHn+9D1A@mail.gmail.com>
 <CADvbK_fpZWexYckNtmsEatb+JU_EW4=Xn9OpcL=Tk-a8odDHuw@mail.gmail.com>
 <20200525131036.GA2491@localhost.localdomain> <CADvbK_fGCKg1jB86MTJmkPXaLmdDV191vpgfs1YomJ5_0zgONA@mail.gmail.com>
In-Reply-To: <CADvbK_fGCKg1jB86MTJmkPXaLmdDV191vpgfs1YomJ5_0zgONA@mail.gmail.com>
From:   Jonas Falkevik <jonas.falkevik@gmail.com>
Date:   Mon, 25 May 2020 22:49:06 +0200
Message-ID: <CABUN9aBOvnCQEWyOd8qtPUZxO1SD-Fecstgqygz0Qc76qCq9aA@mail.gmail.com>
Subject: Re: [PATCH] sctp: check assoc before SCTP_ADDR_{MADE_PRIM,ADDED} event
To:     Xin Long <lucien.xin@gmail.com>
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

On Mon, May 25, 2020 at 6:10 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Mon, May 25, 2020 at 9:10 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Mon, May 25, 2020 at 04:42:16PM +0800, Xin Long wrote:
> > > On Sat, May 23, 2020 at 8:04 PM Jonas Falkevik <jonas.falkevik@gmail.com> wrote:
> > > >
> > > > On Tue, May 19, 2020 at 10:42 PM Marcelo Ricardo Leitner
> > > > <marcelo.leitner@gmail.com> wrote:
> > > > >
> > > > > On Fri, May 15, 2020 at 10:30:29AM +0200, Jonas Falkevik wrote:
> > > > > > On Wed, May 13, 2020 at 11:32 PM Marcelo Ricardo Leitner
> > > > > > <marcelo.leitner@gmail.com> wrote:
> > > > > > >
> > > > > > > On Wed, May 13, 2020 at 10:11:05PM +0200, Jonas Falkevik wrote:
> > > > > > > > On Wed, May 13, 2020 at 6:01 PM Marcelo Ricardo Leitner
> > > > > > > > <marcelo.leitner@gmail.com> wrote:
> > > > > > > > >
> > > > > > > > > On Wed, May 13, 2020 at 04:52:16PM +0200, Jonas Falkevik wrote:
> > > > > > > > > > Do not generate SCTP_ADDR_{MADE_PRIM,ADDED} events for SCTP_FUTURE_ASSOC assocs.
> > > > > > > > >
> > > > > > > > > How did you get them?
> > > > > > > > >
> > > > > > > >
> > > > > > > > I think one case is when receiving INIT chunk in sctp_sf_do_5_1B_init().
> > > > > > > > Here a closed association is created, sctp_make_temp_assoc().
> > > > > > > > Which is later used when calling sctp_process_init().
> > > > > > > > In sctp_process_init() one of the first things are to call
> > > > > > > > sctp_assoc_add_peer()
> > > > > > > > on the closed / temp assoc.
> > > > > > > >
> > > > > > > > sctp_assoc_add_peer() are generating the SCTP_ADDR_ADDED event on the socket
> > > > > > > > for the potentially new association.
> > > > > > >
> > > > > > > I see, thanks. The SCTP_FUTURE_ASSOC means something different. It is
> > > > > > > for setting/getting socket options that will be used for new asocs. In
> > > > > > > this case, it is just a coincidence that asoc_id is not set (but
> > > > > > > initialized to 0) and SCTP_FUTURE_ASSOC is also 0.
> > > > > >
> > > > > > yes, you are right, I overlooked that.
> > > > > >
> > > > > > > Moreso, if I didn't
> > > > > > > miss anything, it would block valid events, such as those from
> > > > > > >  sctp_sf_do_5_1D_ce
> > > > > > >    sctp_process_init
> > > > > > > because sctp_process_init will only call sctp_assoc_set_id() by its
> > > > > > > end.
> > > > > >
> > > > > > Do we want these events at this stage?
> > > > > > Since the association is a newly established one, have the peer address changed?
> > > > > > Should we enqueue these messages with sm commands instead?
> > > > > > And drop them if we don't have state SCTP_STATE_ESTABLISHED?
> > > > > >
> > > > > > >
> > > > > > > I can't see a good reason for generating any event on temp assocs. So
> > > > > > > I'm thinking the checks on this patch should be on whether the asoc is
> > > > > > > a temporary one instead. WDYT?
> > > > > > >
> > > > > >
> > > > > > Agree, we shouldn't rely on coincidence.
> > > > > > Either check temp instead or the above mentioned state?
> > > > > >
> > > > > > > Then, considering the socket is locked, both code points should be
> > > > > > > allocating the IDR earlier. It's expensive, yes (point being, it could
> > > > > > > be avoided in case of other failures), but it should be generating
> > > > > > > events with the right assoc id. Are you interested in pursuing this
> > > > > > > fix as well?
> > > > > >
> > > > > > Sure.
> > > > > >
> > > > > > If we check temp status instead, we would need to allocate IDR earlier,
> > > > > > as you mention. So that we send the notification with correct assoc id.
> > > > > >
> > > > > > But shouldn't the SCTP_COMM_UP, for a newly established association, be the
> > > > > > first notification event sent?
> > > > > > The SCTP_COMM_UP notification is enqueued later in sctp_sf_do_5_1D_ce().
> > > > >
> > > > > The RFC doesn't mention any specific ordering for them, but it would
> > > > > make sense. Reading the FreeBSD code now (which I consider a reference
> > > > > implementation), it doesn't raise these notifications from
> > > > > INIT_ACK/COOKIE_ECHO at all. The only trigger for SCTP_ADDR_ADDED
> > > > > event is ASCONF ADD command itself. So these are extra in Linux, and
> > > > > I'm afraid we got to stick with them.
> > > > >
> > > > > Considering the error handling it already has, looks like the
> > > > > reordering is feasible and welcomed. I'm thinking the temp check and
> > > > > reordering is the best way forward here.
> > > > >
> > > > > Thoughts? Neil? Xin? The assoc_id change might be considered an UAPI
> > > > > breakage.
> > > >
> > > > Some order is mentioned in RFC 6458 Chapter 6.1.1.
> > > >
> > > >       SCTP_COMM_UP:  A new association is now ready, and data may be
> > > >          exchanged with this peer.  When an association has been
> > > >          established successfully, this notification should be the
> > > >          first one.
> >
> > Oh, nice finding.
> >
> > > If this is true, as SCTP_COMM_UP event is always followed by state changed
> > > to ESTABLISHED. So I'm thinking to NOT make addr events by checking the
> > > state:
> > >
> > > @@ -343,6 +343,9 @@ void sctp_ulpevent_nofity_peer_addr_change(struct
> > > sctp_transport *transport,
> > >         struct sockaddr_storage addr;
> > >         struct sctp_ulpevent *event;
> > >
> > > +       if (asoc->state < SCTP_STATE_ESTABLISHED)
> > > +               return;
> > > +
> > >         memset(&addr, 0, sizeof(struct sockaddr_storage));
> > >         memcpy(&addr, &transport->ipaddr, transport->af_specific->sockaddr_len);
> >
> > With the above said, yep. Thanks.
> >
> > >
> > > It's not easy to completely do assoc_id change/event reordering/temp check.
> > > As:
> >
> > Temp check should be fine, but agree re the others. Anyhow, the above
> > will be good already. :-)
> Hi Jonas,
>
> What do you think? If you agree, can you please continue to go with it
> after testing?
>
> Thanks.
>
I agree, it looks good. Looks like it will produce results similar to
the initial change.
Will test and verify as well.
Then should I submit v2 of the patch?

While at it, I have a patch renaming nofity to notify in the function
sctp_ulpevent_nofity_peer_addr_change.
Did I misunderstand the name or is it a typo? Worth submitting as well?

Thanks,
Jonas
