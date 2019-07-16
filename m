Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F8E6AC7E
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 18:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388006AbfGPQIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 12:08:31 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45732 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387959AbfGPQIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 12:08:30 -0400
Received: by mail-lj1-f196.google.com with SMTP id m23so20477096lje.12
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 09:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/PtK1riFgjOIHlhJQFDyC4q5ySxhAO8yRuQks2dZNfk=;
        b=Qwsq8LGcu+4f6+GbfIyFs2u6MHmOVpuck5n/OWKzIuI5zY2IEMHVb2BlOPpRjweGnr
         9i8WS3lTXJvrmNA3uKxRy/kBzYt9LaiqRshEtKmQEJUbp5IcyCsprGyn+/Hostoq0Akp
         fBp77TXTneOqutrYEP4nt1/3Z35g24lfztChoxSwOTJHnvFJU0e4D6mkSR+WiqY5947O
         nUfntsUfvTqtO5CBerTxsjINgBIZoRysGAHtdFIJX2J3zv5YHlQOcJYFs3td5L4fR8Lk
         d0sWfz0Mu/72Rs/IxvY5zxIgaImboim9OQzpxpGSwCOla8rOm2uf6o8KvI1dmBTbh+OU
         4jcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/PtK1riFgjOIHlhJQFDyC4q5ySxhAO8yRuQks2dZNfk=;
        b=QqkgHqG3yu9bK/2gfGayab3jnZnlg66NRHxQ21n+M2qTFVa1zJzV5irEhjeI8aH1Ly
         JpnlyHVxpudjB6dr4q18ib67tEKtb7pZmez8gI5Ctl1To6chQTDaZNMevleJn6ksIwjM
         zeK7UXiDmpdNc7pyKD+X6a7IVt4ZW2fn/tgG/+EWn8CMD2DuisEfBLuaukbyvattpe+4
         tutz4C3QE2kOJ3J5cRR0ddg3i5K1m8bV+GSiQYDsM2VUMSznhYRkh0ajCoImL05gQfKt
         UU7d525dyfdO/4SxkC/KoDeWxlS1Rq+FRInoDYNV8jAVja8FHzcA2KH/8/IQucGJDmJK
         Zr+A==
X-Gm-Message-State: APjAAAWAGZCbeQb6SSTNV4Vq1JWtyQpbPUoVbab0q+y6D/bXgvHp5jso
        pXeEQMFmJV52MVoyeFbwbdvXXCi4pY6SvKviaQ==
X-Google-Smtp-Source: APXvYqyKryFIQegG0hjOTB9NgCpoMoahL1Zn87LGMl/BlFDzO2b4dUJIotzjf0uK56x3MSXiQ8vlXsbNOXtxYHU7vwc=
X-Received: by 2002:a2e:9dc1:: with SMTP id x1mr18159218ljj.0.1563293308121;
 Tue, 16 Jul 2019 09:08:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190529153427.GB8959@cisco> <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
 <20190529222835.GD8959@cisco> <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
 <20190530170913.GA16722@mail.hallyn.com> <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
 <20190530212900.GC5739@cisco> <CAHC9VhT5HPt9rCJoDutdvA3r1Y1GOHfpXe2eJ54atNC1=Vd8LA@mail.gmail.com>
 <20190708181237.5poheliito7zpvmc@madcap2.tricolour.ca> <CAHC9VhT0V+xi_6nAR5TsM2vs34LbgMeO=-W+MS_kqiXRRzneZQ@mail.gmail.com>
 <20190716153705.xx7dwrhliny5amut@madcap2.tricolour.ca>
In-Reply-To: <20190716153705.xx7dwrhliny5amut@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 16 Jul 2019 12:08:16 -0400
Message-ID: <CAHC9VhTaLqCo8rmAaySJQB+Pf-580=3mvX1rPmtEeb9o5Uy9Qg@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Tycho Andersen <tycho@tycho.ws>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        ebiederm@xmission.com, nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 11:37 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-07-15 17:09, Paul Moore wrote:
> > On Mon, Jul 8, 2019 at 2:12 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2019-05-30 19:26, Paul Moore wrote:
> >
> > ...
> >
> > > > I like the creativity, but I worry that at some point these
> > > > limitations are going to be raised (limits have a funny way of doing
> > > > that over time) and we will be in trouble.  I say "trouble" because I
> > > > want to be able to quickly do an audit container ID comparison and
> > > > we're going to pay a penalty for these larger values (we'll need this
> > > > when we add multiple auditd support and the requisite record routing).
> > > >
> > > > Thinking about this makes me also realize we probably need to think a
> > > > bit longer about audit container ID conflicts between orchestrators.
> > > > Right now we just take the value that is given to us by the
> > > > orchestrator, but if we want to allow multiple container orchestrators
> > > > to work without some form of cooperation in userspace (I think we have
> > > > to assume the orchestrators will not talk to each other) we likely
> > > > need to have some way to block reuse of an audit container ID.  We
> > > > would either need to prevent the orchestrator from explicitly setting
> > > > an audit container ID to a currently in use value, or instead generate
> > > > the audit container ID in the kernel upon an event triggered by the
> > > > orchestrator (e.g. a write to a /proc file).  I suspect we should
> > > > start looking at the idr code, I think we will need to make use of it.
> > >
> > > To address this, I'd suggest that it is enforced to only allow the
> > > setting of descendants and to maintain a master list of audit container
> > > identifiers (with a hash table if necessary later) that includes the
> > > container owner.
> >
> > We're discussing the audit container ID management policy elsewhere in
> > this thread so I won't comment on that here, but I did want to say
> > that we will likely need something better than a simple list of audit
> > container IDs from the start.  It's common for systems to have
> > thousands of containers now (or multiple thousands), which tells me
> > that a list is a poor choice.  You mentioned a hash table, so I would
> > suggest starting with that over the list for the initial patchset.
>
> I saw that as an internal incremental improvement that did not affect
> the API, so I wanted to keep things a bit simpler (as you've requested
> in the past) to get this going, and add that enhancement later.

In general a simple approach is a good way to start when the
problem/use-case is not very well understood; in other words, don't
spend a lot of time/effort optimizing something you don't yet
understand.  In this case we know that people want to deploy a *lot*
of containers on a single system so we should design the data
structures appropriately.  A list is simply not a good fit here, I
believe/hope you know that too.

> I'll start working on it now.  The hash table would simply point to
> lists anyways unless you can recommend a better approach.

I assume when you say "point to lists" you are talking about using
lists for the hash buckets?  If so, yes that should be fine at this
point.  In general if the per-bucket lists become a bottleneck we can
look at the size of the table (or make it tunable) or even use a
different approach entirely.  Ultimately the data store is an
implementation detail private to the audit subsystem in the kernel so
we should be able to change it as necessary without breaking anything.

-- 
paul moore
www.paul-moore.com
