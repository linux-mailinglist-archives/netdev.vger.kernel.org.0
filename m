Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2771E1554
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 22:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390712AbgEYUwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 16:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388714AbgEYUwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 16:52:05 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27A0C061A0E;
        Mon, 25 May 2020 13:52:04 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id z5so8552947qvw.4;
        Mon, 25 May 2020 13:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MLeVvYrTYMYJfLw2SqD/fO7uDAqzrwrJACplTDu/IZ0=;
        b=m9RFvrfdNTkbbjfzQYISDexRTtf6OaOV3pQqX+BGncXEnPlSh01lH9Ch/bWzMRNmJo
         FyhZGrsVzahSOQsjZe9RYoZGCmz0dgEvokil7mD0sitItZx4QkQYnGL+LYEOtHUkIYtG
         PdugN0/KzUTk5/QCTD9yc1Q5VCPI1+4urVlSNyV2MNyx0iT03fBe8saVLvxogd4Yejdt
         KUTun20Baq4QW/z2NG39++7uTzy4Si4yrVZ4v5oUEsj7wfpsKRHPwoMtI90oB9BzRY8A
         JNehw9m2lggBKzQG/ejWx2yWiB33FQIuSc5yhg6+kGjHhTGoV+zprLFM12inIURUTG8I
         btsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MLeVvYrTYMYJfLw2SqD/fO7uDAqzrwrJACplTDu/IZ0=;
        b=mAf1J1kHBux8vXF2mDeRi8SdzyEi7o0ng+b4aXAMthsyrF2Zmj/ZdPBoCKPVPlvwRh
         UwVlCEKlos9aZTbx2qbrFszIPI+pbs3HnySo9ZypsSOLz5IXA4x7yHV5rXsEe29H6/Ra
         8drbyAaU5v78aFaboKVAJFT1tlmtPPslPUFpDK5qBviYYioze6KryOlf0mBDmlIG+um4
         9/ayR0G9N3nGivodfdKXxhhArRPb38ajKOV9kMjpTwzevKj6cXwzk9ZREVqcpf+jMz8t
         qgY82L3JaM6O58l56BpAQlgxpR8PK8MFLEziDgZH7ZKAKL858iUYED/NQxsRfB6fShWm
         XRRA==
X-Gm-Message-State: AOAM532pwiWFq1zFEipJcqOyEqicY8BW8DnUoUyWt3QEd/1TfkWbrbBB
        AlVzpaXeWXICTioApBBeVVI=
X-Google-Smtp-Source: ABdhPJwiJzDi4vHVK8/h1L+ZUiX5yxBYbD3jymcGoLyXPau2DFV6hQ27vp2QB9ew/TghoO9eQevuCw==
X-Received: by 2002:a05:6214:1594:: with SMTP id m20mr17497026qvw.110.1590439923896;
        Mon, 25 May 2020 13:52:03 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:8992:a39b:b6ab:3df8:5b60])
        by smtp.gmail.com with ESMTPSA id o23sm3898134qko.124.2020.05.25.13.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 13:52:03 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id BB1C4C1B76; Mon, 25 May 2020 17:52:00 -0300 (-03)
Date:   Mon, 25 May 2020 17:52:00 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jonas Falkevik <jonas.falkevik@gmail.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sctp: check assoc before SCTP_ADDR_{MADE_PRIM,ADDED}
 event
Message-ID: <20200525205200.GB2491@localhost.localdomain>
References: <20200513160116.GA2491@localhost.localdomain>
 <CABUN9aCuoA+CXLujUxXyiKWQPkwq9_eOXNqOR=MK7dPY++Fxng@mail.gmail.com>
 <20200513213230.GE2491@localhost.localdomain>
 <CABUN9aBoxXjdPk9piKAZV-2dYOCEnuXr-4H5ZVVvqeMMFRsf7A@mail.gmail.com>
 <20200519204229.GQ2491@localhost.localdomain>
 <CABUN9aD85O3mF8j72QfrC8vbXPzj5Q=L801t2M6XsbDHn+9D1A@mail.gmail.com>
 <CADvbK_fpZWexYckNtmsEatb+JU_EW4=Xn9OpcL=Tk-a8odDHuw@mail.gmail.com>
 <20200525131036.GA2491@localhost.localdomain>
 <CADvbK_fGCKg1jB86MTJmkPXaLmdDV191vpgfs1YomJ5_0zgONA@mail.gmail.com>
 <CABUN9aBOvnCQEWyOd8qtPUZxO1SD-Fecstgqygz0Qc76qCq9aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABUN9aBOvnCQEWyOd8qtPUZxO1SD-Fecstgqygz0Qc76qCq9aA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 10:49:06PM +0200, Jonas Falkevik wrote:
> On Mon, May 25, 2020 at 6:10 PM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Mon, May 25, 2020 at 9:10 PM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > >
> > > On Mon, May 25, 2020 at 04:42:16PM +0800, Xin Long wrote:
> > > > On Sat, May 23, 2020 at 8:04 PM Jonas Falkevik <jonas.falkevik@gmail.com> wrote:
> > > > >
> > > > > On Tue, May 19, 2020 at 10:42 PM Marcelo Ricardo Leitner
> > > > > <marcelo.leitner@gmail.com> wrote:
> > > > > >
> > > > > > On Fri, May 15, 2020 at 10:30:29AM +0200, Jonas Falkevik wrote:
> > > > > > > On Wed, May 13, 2020 at 11:32 PM Marcelo Ricardo Leitner
> > > > > > > <marcelo.leitner@gmail.com> wrote:
> > > > > > > >
> > > > > > > > On Wed, May 13, 2020 at 10:11:05PM +0200, Jonas Falkevik wrote:
> > > > > > > > > On Wed, May 13, 2020 at 6:01 PM Marcelo Ricardo Leitner
> > > > > > > > > <marcelo.leitner@gmail.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Wed, May 13, 2020 at 04:52:16PM +0200, Jonas Falkevik wrote:
> > > > > > > > > > > Do not generate SCTP_ADDR_{MADE_PRIM,ADDED} events for SCTP_FUTURE_ASSOC assocs.
> > > > > > > > > >
> > > > > > > > > > How did you get them?
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > I think one case is when receiving INIT chunk in sctp_sf_do_5_1B_init().
> > > > > > > > > Here a closed association is created, sctp_make_temp_assoc().
> > > > > > > > > Which is later used when calling sctp_process_init().
> > > > > > > > > In sctp_process_init() one of the first things are to call
> > > > > > > > > sctp_assoc_add_peer()
> > > > > > > > > on the closed / temp assoc.
> > > > > > > > >
> > > > > > > > > sctp_assoc_add_peer() are generating the SCTP_ADDR_ADDED event on the socket
> > > > > > > > > for the potentially new association.
> > > > > > > >
> > > > > > > > I see, thanks. The SCTP_FUTURE_ASSOC means something different. It is
> > > > > > > > for setting/getting socket options that will be used for new asocs. In
> > > > > > > > this case, it is just a coincidence that asoc_id is not set (but
> > > > > > > > initialized to 0) and SCTP_FUTURE_ASSOC is also 0.
> > > > > > >
> > > > > > > yes, you are right, I overlooked that.
> > > > > > >
> > > > > > > > Moreso, if I didn't
> > > > > > > > miss anything, it would block valid events, such as those from
> > > > > > > >  sctp_sf_do_5_1D_ce
> > > > > > > >    sctp_process_init
> > > > > > > > because sctp_process_init will only call sctp_assoc_set_id() by its
> > > > > > > > end.
> > > > > > >
> > > > > > > Do we want these events at this stage?
> > > > > > > Since the association is a newly established one, have the peer address changed?
> > > > > > > Should we enqueue these messages with sm commands instead?
> > > > > > > And drop them if we don't have state SCTP_STATE_ESTABLISHED?
> > > > > > >
> > > > > > > >
> > > > > > > > I can't see a good reason for generating any event on temp assocs. So
> > > > > > > > I'm thinking the checks on this patch should be on whether the asoc is
> > > > > > > > a temporary one instead. WDYT?
> > > > > > > >
> > > > > > >
> > > > > > > Agree, we shouldn't rely on coincidence.
> > > > > > > Either check temp instead or the above mentioned state?
> > > > > > >
> > > > > > > > Then, considering the socket is locked, both code points should be
> > > > > > > > allocating the IDR earlier. It's expensive, yes (point being, it could
> > > > > > > > be avoided in case of other failures), but it should be generating
> > > > > > > > events with the right assoc id. Are you interested in pursuing this
> > > > > > > > fix as well?
> > > > > > >
> > > > > > > Sure.
> > > > > > >
> > > > > > > If we check temp status instead, we would need to allocate IDR earlier,
> > > > > > > as you mention. So that we send the notification with correct assoc id.
> > > > > > >
> > > > > > > But shouldn't the SCTP_COMM_UP, for a newly established association, be the
> > > > > > > first notification event sent?
> > > > > > > The SCTP_COMM_UP notification is enqueued later in sctp_sf_do_5_1D_ce().
> > > > > >
> > > > > > The RFC doesn't mention any specific ordering for them, but it would
> > > > > > make sense. Reading the FreeBSD code now (which I consider a reference
> > > > > > implementation), it doesn't raise these notifications from
> > > > > > INIT_ACK/COOKIE_ECHO at all. The only trigger for SCTP_ADDR_ADDED
> > > > > > event is ASCONF ADD command itself. So these are extra in Linux, and
> > > > > > I'm afraid we got to stick with them.
> > > > > >
> > > > > > Considering the error handling it already has, looks like the
> > > > > > reordering is feasible and welcomed. I'm thinking the temp check and
> > > > > > reordering is the best way forward here.
> > > > > >
> > > > > > Thoughts? Neil? Xin? The assoc_id change might be considered an UAPI
> > > > > > breakage.
> > > > >
> > > > > Some order is mentioned in RFC 6458 Chapter 6.1.1.
> > > > >
> > > > >       SCTP_COMM_UP:  A new association is now ready, and data may be
> > > > >          exchanged with this peer.  When an association has been
> > > > >          established successfully, this notification should be the
> > > > >          first one.
> > >
> > > Oh, nice finding.
> > >
> > > > If this is true, as SCTP_COMM_UP event is always followed by state changed
> > > > to ESTABLISHED. So I'm thinking to NOT make addr events by checking the
> > > > state:
> > > >
> > > > @@ -343,6 +343,9 @@ void sctp_ulpevent_nofity_peer_addr_change(struct
> > > > sctp_transport *transport,
> > > >         struct sockaddr_storage addr;
> > > >         struct sctp_ulpevent *event;
> > > >
> > > > +       if (asoc->state < SCTP_STATE_ESTABLISHED)
> > > > +               return;
> > > > +
> > > >         memset(&addr, 0, sizeof(struct sockaddr_storage));
> > > >         memcpy(&addr, &transport->ipaddr, transport->af_specific->sockaddr_len);
> > >
> > > With the above said, yep. Thanks.
> > >
> > > >
> > > > It's not easy to completely do assoc_id change/event reordering/temp check.
> > > > As:
> > >
> > > Temp check should be fine, but agree re the others. Anyhow, the above
> > > will be good already. :-)
> > Hi Jonas,
> >
> > What do you think? If you agree, can you please continue to go with it
> > after testing?
> >
> > Thanks.
> >
> I agree, it looks good. Looks like it will produce results similar to
> the initial change.
> Will test and verify as well.
> Then should I submit v2 of the patch?

Yes,

> 
> While at it, I have a patch renaming nofity to notify in the function
> sctp_ulpevent_nofity_peer_addr_change.
> Did I misunderstand the name or is it a typo? Worth submitting as well?

Oops! Yes :-) (as a different patch)

Thanks,
Marcelo
