Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D81D1DA2F9
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 22:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgESUmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 16:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgESUme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 16:42:34 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B58C08C5C0;
        Tue, 19 May 2020 13:42:34 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id x13so317102qvr.2;
        Tue, 19 May 2020 13:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MxjzuKPTnqF+zzLncOFC5Grqt9HxOH+XXP2tkEyOZIU=;
        b=P/ZuyZJCVyPLY5ZtIPXe6zWNbKqkMgexWJlRC3ENjSls6Co34mNngtMJP8ZyGy4iCD
         Ro76TFrG/NqWv75K+jzp5ReOKHD966bFIm6ED/DlAIH6YEpun58VYSCPYvfNCSwkx06U
         G+R/awU6zm2tAlK9UaiHYRla/uqf8/S9zK2bYvdlVhF0xiRzrUb4MksNwqhkukvbdCdm
         4Bl22c3HJzK7x37QIxCfbfnezzqgT1JhlLymOdt1JR3IYSveya1XtT1JHt6So3OsYCHE
         XH+p46YIYixuMLMHeGUPwUFimSuPz5g7DR0Nif9D9Oa+Zq36ebdQEK23dyikHrlPJX9e
         sYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MxjzuKPTnqF+zzLncOFC5Grqt9HxOH+XXP2tkEyOZIU=;
        b=r6ZzCrUXcHDRNasMH1OuY4+regJW/zJ6biLxp/5ChtiGf0fHrvE9NKHZ73/MZ4QxEU
         I6XBojD7RpEJhvklmJAtBPlyJB9yXk7ZRqjyKs37ED2Ho5fnPTe2CtnB7/uwESL6Tjw2
         5RtKS7MZPjKJjWHVJ97+JaB73L8Edn2wYNGD+bkR1VQKgoBU54hv/mxuzzKF11uhprs0
         4WKivqw43dYgXDcvSCNZ4wSqUQLJgLF16Pd4fsgJXVwNyv7Ht0ytIyQkHzmG4BgFyStL
         vIsmk2whqzYhXPRa5ro+o2+wBo1OsgPjKPl469U8Dzp+EGBieILroEUbGCfZCvJ927YL
         SkPw==
X-Gm-Message-State: AOAM532IJBPo+p54XwH0qSgcA2fdg7wBlo5tfVjhRmI88jZNVM+xq34q
        2iPB5MEtIsf2ntb1hvVBe3s=
X-Google-Smtp-Source: ABdhPJxDd7E6iGbwI7VLhh2fvX9IgVo3t/EJnUPo9ANDGO1IO2Pk08BfulTqnEcCJYhBBdybQKMslw==
X-Received: by 2002:a0c:ba99:: with SMTP id x25mr1576878qvf.119.1589920953653;
        Tue, 19 May 2020 13:42:33 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.225])
        by smtp.gmail.com with ESMTPSA id n31sm813267qtc.36.2020.05.19.13.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 13:42:32 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id B3FB0C08DA; Tue, 19 May 2020 17:42:29 -0300 (-03)
Date:   Tue, 19 May 2020 17:42:29 -0300
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
Message-ID: <20200519204229.GQ2491@localhost.localdomain>
References: <CABUN9aCXZBTdYHSK5oSVX-HAA1wTWmyBW_ked_ydsCjsV-Ckaw@mail.gmail.com>
 <20200513160116.GA2491@localhost.localdomain>
 <CABUN9aCuoA+CXLujUxXyiKWQPkwq9_eOXNqOR=MK7dPY++Fxng@mail.gmail.com>
 <20200513213230.GE2491@localhost.localdomain>
 <CABUN9aBoxXjdPk9piKAZV-2dYOCEnuXr-4H5ZVVvqeMMFRsf7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABUN9aBoxXjdPk9piKAZV-2dYOCEnuXr-4H5ZVVvqeMMFRsf7A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 10:30:29AM +0200, Jonas Falkevik wrote:
> On Wed, May 13, 2020 at 11:32 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Wed, May 13, 2020 at 10:11:05PM +0200, Jonas Falkevik wrote:
> > > On Wed, May 13, 2020 at 6:01 PM Marcelo Ricardo Leitner
> > > <marcelo.leitner@gmail.com> wrote:
> > > >
> > > > On Wed, May 13, 2020 at 04:52:16PM +0200, Jonas Falkevik wrote:
> > > > > Do not generate SCTP_ADDR_{MADE_PRIM,ADDED} events for SCTP_FUTURE_ASSOC assocs.
> > > >
> > > > How did you get them?
> > > >
> > >
> > > I think one case is when receiving INIT chunk in sctp_sf_do_5_1B_init().
> > > Here a closed association is created, sctp_make_temp_assoc().
> > > Which is later used when calling sctp_process_init().
> > > In sctp_process_init() one of the first things are to call
> > > sctp_assoc_add_peer()
> > > on the closed / temp assoc.
> > >
> > > sctp_assoc_add_peer() are generating the SCTP_ADDR_ADDED event on the socket
> > > for the potentially new association.
> >
> > I see, thanks. The SCTP_FUTURE_ASSOC means something different. It is
> > for setting/getting socket options that will be used for new asocs. In
> > this case, it is just a coincidence that asoc_id is not set (but
> > initialized to 0) and SCTP_FUTURE_ASSOC is also 0.
> 
> yes, you are right, I overlooked that.
> 
> > Moreso, if I didn't
> > miss anything, it would block valid events, such as those from
> >  sctp_sf_do_5_1D_ce
> >    sctp_process_init
> > because sctp_process_init will only call sctp_assoc_set_id() by its
> > end.
> 
> Do we want these events at this stage?
> Since the association is a newly established one, have the peer address changed?
> Should we enqueue these messages with sm commands instead?
> And drop them if we don't have state SCTP_STATE_ESTABLISHED?
> 
> >
> > I can't see a good reason for generating any event on temp assocs. So
> > I'm thinking the checks on this patch should be on whether the asoc is
> > a temporary one instead. WDYT?
> >
> 
> Agree, we shouldn't rely on coincidence.
> Either check temp instead or the above mentioned state?
> 
> > Then, considering the socket is locked, both code points should be
> > allocating the IDR earlier. It's expensive, yes (point being, it could
> > be avoided in case of other failures), but it should be generating
> > events with the right assoc id. Are you interested in pursuing this
> > fix as well?
> 
> Sure.
> 
> If we check temp status instead, we would need to allocate IDR earlier,
> as you mention. So that we send the notification with correct assoc id.
> 
> But shouldn't the SCTP_COMM_UP, for a newly established association, be the
> first notification event sent?
> The SCTP_COMM_UP notification is enqueued later in sctp_sf_do_5_1D_ce().

The RFC doesn't mention any specific ordering for them, but it would
make sense. Reading the FreeBSD code now (which I consider a reference
implementation), it doesn't raise these notifications from
INIT_ACK/COOKIE_ECHO at all. The only trigger for SCTP_ADDR_ADDED
event is ASCONF ADD command itself. So these are extra in Linux, and
I'm afraid we got to stick with them.

Considering the error handling it already has, looks like the
reordering is feasible and welcomed. I'm thinking the temp check and
reordering is the best way forward here.

Thoughts? Neil? Xin? The assoc_id change might be considered an UAPI
breakage.

Thanks,
Marcelo
