Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B7B18A796
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 23:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgCRWGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 18:06:16 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45894 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgCRWGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 18:06:16 -0400
Received: by mail-ed1-f65.google.com with SMTP id u59so28048edc.12
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 15:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TDXZZkhqjusv291He84nhKQlMbFezXaGS9XY4w8phpE=;
        b=EGq9j8ta0EzuoZHC99ctGlzz5FJgMcHEAbQAY1LzC7m2yp+tVJkMr4r617GRqI0ca6
         Z6smPIs417FGSdP6HYXkQWHLvupus3gRbB6ttGrFxU6ommiXyDGunEw+TRP0TgHao1TU
         4Zuy5cg6A3jg+knqeniLehrw6GKjBIxp7c/IQ4oZLNCTkhb+VBMb4rkbGmGRA69VSJR9
         LYyO7JXPLwrPS+tF7PpR1NKN+psauSaajm2Y6qFCN6eNWY78mekonIly4LPjoSQO9Xwj
         pnC3ZVehyi0uC3wqWOG172opZ0qSIKIrqp40cuBX5baeZ0IuWv1Udr4hof6nAKv0n3Rx
         3PAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TDXZZkhqjusv291He84nhKQlMbFezXaGS9XY4w8phpE=;
        b=YbcOkvqkPYGKbyvQPk7krOKfwlNq7qLPqVxRhpVcUARrfg7WBy05x79gQEnwSko0Ci
         s3fb6fhQLbb+xXGZE1xCWaqU1thv6oIp1QB6cJKmQIx9vpegne9dVQHAvvgNb9fgJ9QW
         j1OVEqObvGXUoxFk9ImghtroFKal8ROwl72yuuj3ntuM/9JL/GhvzUTrbSjb1nKDbdTK
         i/09CzQZZPf2oUHfuywEJJ5kir0aCCufwX7zel8Zrj/si/Kv80x9Dgl4WZn6/i0rL6ZW
         jkZH7SM6hUTh86MYNn7EUSKQRFCiDAuVG28fCAZmWfNEgvp+OaWqLMPfEXMnHE7zjDEB
         4qTw==
X-Gm-Message-State: ANhLgQ2C5CE2ZOWjOBsNbwz/owyn4EqIJugKvrBqLuBGcazcWGmqdOzj
        6k67uYIxRcKFUKS8PEMAC6KfGqcOrbNmAEPG8GAf
X-Google-Smtp-Source: ADFU+vtW4mfjwnuF24IoXcYzayNDU8snpAdY8T07RFr+nxOE2IbbjW1zRxqJVYGpUJx8Vd5VOBHbcoPpD4xtj23EMDs=
X-Received: by 2002:a17:906:cb93:: with SMTP id mf19mr378815ejb.272.1584569171696;
 Wed, 18 Mar 2020 15:06:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhQquokw+7UOU=G0SsD35UdgmfysVKCGCE87JVaoTkbisg@mail.gmail.com>
 <3142237.YMNxv0uec1@x2> <CAHC9VhTiCHQbp2SwK0Xb1QgpUZxOQ26JKKPsVGT0ZvMqx28oPQ@mail.gmail.com>
 <CAHC9VhS09b_fM19tn7pHZzxfyxcHnK+PJx80Z9Z1hn8-==4oLA@mail.gmail.com>
 <20200312193037.2tb5f53yeisfq4ta@madcap2.tricolour.ca> <CAHC9VhQoVOzy_b9W6h+kmizKr1rPkC4cy5aYoKT2i0ZgsceNDg@mail.gmail.com>
 <20200313185900.y44yvrfm4zxa5lfk@madcap2.tricolour.ca> <CAHC9VhR2zCCE5bjH75rSwfLC7TJGFj4RBnrtcOoUiqVp9q5TaA@mail.gmail.com>
 <20200318212630.mw2geg4ykhnbtr3k@madcap2.tricolour.ca> <CAHC9VhRYvGAru3aOMwWKCCWDktS+2pGr+=vV4SjHW_0yewD98A@mail.gmail.com>
 <20200318215550.es4stkjwnefrfen2@madcap2.tricolour.ca>
In-Reply-To: <20200318215550.es4stkjwnefrfen2@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 18 Mar 2020 18:06:00 -0400
Message-ID: <CAHC9VhSdDDP7Ec-w61NhGxZG5ZiekmrBCAg=Y=VJvEZcgQh46g@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling
 the audit daemon
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com,
        nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 5:56 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-03-18 17:42, Paul Moore wrote:
> > On Wed, Mar 18, 2020 at 5:27 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-03-18 16:56, Paul Moore wrote:
> > > > On Fri, Mar 13, 2020 at 2:59 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > On 2020-03-13 12:29, Paul Moore wrote:
> > > > > > On Thu, Mar 12, 2020 at 3:30 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > > On 2020-02-13 16:44, Paul Moore wrote:
> > > > > > > > This is a bit of a thread-hijack, and for that I apologize, but
> > > > > > > > another thought crossed my mind while thinking about this issue
> > > > > > > > further ... Once we support multiple auditd instances, including the
> > > > > > > > necessary record routing and duplication/multiple-sends (the host
> > > > > > > > always sees *everything*), we will likely need to find a way to "trim"
> > > > > > > > the audit container ID (ACID) lists we send in the records.  The
> > > > > > > > auditd instance running on the host/initns will always see everything,
> > > > > > > > so it will want the full container ACID list; however an auditd
> > > > > > > > instance running inside a container really should only see the ACIDs
> > > > > > > > of any child containers.
> > > > > > >
> > > > > > > Agreed.  This should be easy to check and limit, preventing an auditd
> > > > > > > from seeing any contid that is a parent of its own contid.
> > > > > > >
> > > > > > > > For example, imagine a system where the host has containers 1 and 2,
> > > > > > > > each running an auditd instance.  Inside container 1 there are
> > > > > > > > containers A and B.  Inside container 2 there are containers Y and Z.
> > > > > > > > If an audit event is generated in container Z, I would expect the
> > > > > > > > host's auditd to see a ACID list of "1,Z" but container 1's auditd
> > > > > > > > should only see an ACID list of "Z".  The auditd running in container
> > > > > > > > 2 should not see the record at all (that will be relatively
> > > > > > > > straightforward).  Does that make sense?  Do we have the record
> > > > > > > > formats properly designed to handle this without too much problem (I'm
> > > > > > > > not entirely sure we do)?
> > > > > > >
> > > > > > > I completely agree and I believe we have record formats that are able to
> > > > > > > handle this already.
> > > > > >
> > > > > > I'm not convinced we do.  What about the cases where we have a field
> > > > > > with a list of audit container IDs?  How do we handle that?
> > > > >
> > > > > I don't understand the problem.  (I think you crossed your 1/2 vs
> > > > > A/B/Y/Z in your example.) ...
> > > >
> > > > It looks like I did, sorry about that.
> > > >
> > > > > ... Clarifying the example above, if as you
> > > > > suggest an event happens in container Z, the hosts's auditd would report
> > > > >         Z,^2
> > > > > and the auditd in container 2 would report
> > > > >         Z,^2
> > > > > but if there were another auditd running in container Z it would report
> > > > >         Z
> > > > > while the auditd in container 1 or A/B would see nothing.
> > > >
> > > > Yes.  My concern is how do we handle this to minimize duplicating and
> > > > rewriting the records?  It isn't so much about the format, although
> > > > the format is a side effect.
> > >
> > > Are you talking about caching, or about divulging more information than
> > > necessary or even information leaks?  Or even noticing that records that
> > > need to be generated to two audit daemons share the same contid field
> > > values and should be generated at the same time or information shared
> > > between them?  I'd see any of these as optimizations that don't affect
> > > the api.
> >
> > Imagine a record is generated in a container which has more than one
> > auditd in it's ancestry that should receive this record, how do we
> > handle that without completely killing performance?  That's my
> > concern.  If you've already thought up a plan for this - excellent,
> > please share :)
>
> No, I haven't given that much thought other than the correctness and
> security issues of making sure that each audit daemon is sufficiently
> isolated to do its job but not jeopardize another audit domain.  Audit
> already kills performance, according to some...
>
> We currently won't have that problem since there can only be one so far.
> Fixing and optimizing this is part of the next phase of the challenge of
> adding a second audit daemon.
>
> Let's work on correctness and reasonable efficiency for this phase and
> not focus on a problem we don't yet have.  I wouldn't consider this
> incurring technical debt at this point.

I agree, one stage at a time, but the choice we make here is going to
have a significant impact on what we can do later.  We need to get
this as "right" as possible; this isn't something we should dismiss
with a hand-wave as a problem for the next stage.  We don't need an
implementation, but I would like to see a rough design of how we would
address this problem.

> I could see cacheing a contid string from one starting point, but it may
> be more work to search that cached string to truncate it or add to it
> when another audit daemon requests a copy of a similar string.  I
> suppose every full contid string could be generated the first time it is
> used and parts of it used (start/finish) as needed but that
> search/indexing may not be worth it.

I hope we can do better than string manipulations in the kernel.  I'd
much rather defer generating the ACID list (if possible), than
generating a list only to keep copying and editing it as the record is
sent.

-- 
paul moore
www.paul-moore.com
