Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 018AC18DAA1
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 22:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgCTV4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 17:56:20 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44368 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbgCTV4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 17:56:19 -0400
Received: by mail-ed1-f65.google.com with SMTP id z3so8889631edq.11
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 14:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a8ahsfZRQ8/CSI+HAyAd7oA0o7kapBNHEzGZ00xwq3I=;
        b=joKgmK9wgVE7QE07hU5dO+MoJls/GcqZynQzrl68rPRQ51Q52Ru9XsznWpGol/aQ0O
         M3YgBzyDaIz8nYyYqpF9yduv/p9Sd4U1gly8tWOTPlboNkBQW5c+mQtPlmJCGCWXrNkI
         LTZG3vIb0+0VYhUO8n6mbY+/vsqyNELZcnMQUfb8hjguw2bdDsvVn8u2ddElF+EN9IMD
         +qetEs210+YIzihlQmhQJGbQqNw8qHsfd4OT9QIOzpHTQ1yVFW0QBhCYb/l4Nv3fwjcv
         nHOcM3bspTnrBFbgoJVgt7QLNYhjjYHzUqmXLYTwloY4/4m221E0gs5EhZr7MNb3crv/
         /fbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a8ahsfZRQ8/CSI+HAyAd7oA0o7kapBNHEzGZ00xwq3I=;
        b=k7SIuTYTbZoYKlhnH2gI8oi6x0PjRKGkwtPb16BQJxKqsSJTF/f+/mrJm/xVspDPPZ
         yuaYTSriCsbSri22pqaQrp0DAOir6A5SiiOv11F2UipwbCDws5jOiwn05SLE5UKy0gqL
         iw3A6hQo5NVCLOhgWqHo/dZLafawCYbJGpp+XCjSunBGGBQPohSTQ8l+FevaumMY6dA7
         oDZ0c9kpPKcDUL7Q9xW4ePINg7/SjM55N0nmYUyQTyYKxWSfxwEKhuYCCfquD2AQpWtF
         7+ZPkbuKKn3IXWHtwotudO/ib8M7wy8Hq+Sw6BU8fNjU2HihJ25CKPfgxD4GoTnOOl1p
         83LA==
X-Gm-Message-State: ANhLgQ13pPxMPWAibOq9d2qfs4YkNxfhjw3Vs8nxcmC8ah8Mhe9YfZri
        BYvHU1K4raYZyOc9CRuP5J8zVJAHa4bflSv+Kk+w
X-Google-Smtp-Source: ADFU+vsnJYrIu/MOTz9EI2jeor+Xy6uyGiLiWiERy9jOTAu1RDM2AARj7RAdubH3sb2vtE4+97cBebgy5KEDdsp3hZk=
X-Received: by 2002:aa7:dd01:: with SMTP id i1mr9889360edv.164.1584741376576;
 Fri, 20 Mar 2020 14:56:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200204231454.oxa7pyvuxbj466fj@madcap2.tricolour.ca>
 <CAHC9VhQquokw+7UOU=G0SsD35UdgmfysVKCGCE87JVaoTkbisg@mail.gmail.com>
 <3142237.YMNxv0uec1@x2> <CAHC9VhTiCHQbp2SwK0Xb1QgpUZxOQ26JKKPsVGT0ZvMqx28oPQ@mail.gmail.com>
 <20200312202733.7kli64zsnqc4mrd2@madcap2.tricolour.ca> <CAHC9VhS9DtxJ4gvOfMRnzoo6ccGJVKL+uZYe6qqH+SPqD8r01Q@mail.gmail.com>
 <20200313192306.wxey3wn2h4htpccm@madcap2.tricolour.ca> <CAHC9VhQKOpVWxDg-tWuCWV22QRu8P_NpFKme==0Ot1RQKa_DWA@mail.gmail.com>
 <20200318214154.ycxy5dl4pxno6fvi@madcap2.tricolour.ca> <CAHC9VhSuMnd3-ci2Bx-xJ0yscQ=X8ZqFAcNPKpbh_ZWN3FJcuQ@mail.gmail.com>
 <20200319214759.qgxt2sfkmd6srdol@madcap2.tricolour.ca>
In-Reply-To: <20200319214759.qgxt2sfkmd6srdol@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 20 Mar 2020 17:56:05 -0400
Message-ID: <CAHC9VhTp25OAaTO5UMft0OzUZ=oQpZFjebkjjQP0-NrPp0bNAg@mail.gmail.com>
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

On Thu, Mar 19, 2020 at 5:48 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-03-18 17:47, Paul Moore wrote:
> > On Wed, Mar 18, 2020 at 5:42 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-03-18 17:01, Paul Moore wrote:
> > > > On Fri, Mar 13, 2020 at 3:23 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > On 2020-03-13 12:42, Paul Moore wrote:
> > > >
> > > > ...
> > > >
> > > > > > The thread has had a lot of starts/stops, so I may be repeating a
> > > > > > previous suggestion, but one idea would be to still emit a "death
> > > > > > record" when the final task in the audit container ID does die, but
> > > > > > block the particular audit container ID from reuse until it the
> > > > > > SIGNAL2 info has been reported.  This gives us the timely ACID death
> > > > > > notification while still preventing confusion and ambiguity caused by
> > > > > > potentially reusing the ACID before the SIGNAL2 record has been sent;
> > > > > > there is a small nit about the ACID being present in the SIGNAL2
> > > > > > *after* its death, but I think that can be easily explained and
> > > > > > understood by admins.
> > > > >
> > > > > Thinking quickly about possible technical solutions to this, maybe it
> > > > > makes sense to have two counters on a contobj so that we know when the
> > > > > last process in that container exits and can issue the death
> > > > > certificate, but we still block reuse of it until all further references
> > > > > to it have been resolved.  This will likely also make it possible to
> > > > > report the full contid chain in SIGNAL2 records.  This will eliminate
> > > > > some of the issues we are discussing with regards to passing a contobj
> > > > > vs a contid to the audit_log_contid function, but won't eliminate them
> > > > > all because there are still some contids that won't have an object
> > > > > associated with them to make it impossible to look them up in the
> > > > > contobj lists.
> > > >
> > > > I'm not sure you need a full second counter, I imagine a simple flag
> > > > would be okay.  I think you just something to indicate that this ACID
> > > > object is marked as "dead" but it still being held for sanity reasons
> > > > and should not be reused.
> > >
> > > Ok, I see your point.  This refcount can be changed to a flag easily
> > > enough without change to the api if we can be sure that more than one
> > > signal can't be delivered to the audit daemon *and* collected by sig2.
> > > I'll have a more careful look at the audit daemon code to see if I can
> > > determine this.
> >
> > Maybe I'm not understanding your concern, but this isn't really
> > different than any of the other things we track for the auditd signal
> > sender, right?  If we are worried about multiple signals being sent
> > then it applies to everything, not just the audit container ID.
>
> Yes, you are right.  In all other cases the information is simply
> overwritten.  In the case of the audit container identifier any
> previous value is put before a new one is referenced, so only the last
> signal is kept.  So, we only need a flag.  Does a flag implemented with
> a rcu-protected refcount sound reasonable to you?

Well, if I recall correctly you still need to fix the locking in this
patchset so until we see what that looks like it is hard to say for
certain.  Just make sure that the flag is somehow protected from
races; it is probably a lot like the "valid" flags you sometimes see
with RCU protected lists.

> > > Another question occurs to me is that what if the audit daemon is sent a
> > > signal and it cannot or will not collect the sig2 information from the
> > > kernel (SIGKILL?)?  Does that audit container identifier remain dead
> > > until reboot, or do we institute some other form of reaping, possibly
> > > time-based?
> >
> > In order to preserve the integrity of the audit log that ACID value
> > would need to remain unavailable until the ACID which contains the
> > associated auditd is "dead" (no one can request the signal sender's
> > info if that container is dead).
>
> I don't understand why it would be associated with the contid of the
> audit daemon process rather than with the audit daemon process itself.
> How does the signal collection somehow get transferred or delegated to
> another member of that audit daemon's container?

Presumably once we support multiple audit daemons we will need a
struct to contain the associated connection state, with at most one
struct (and one auditd) allowed for a given ACID.  I would expect that
the signal sender info would be part of that state included in that
struct.  If a task sent a signal to it's associated auditd, and no one
ever queried the signal information stored in the per-ACID state
struct, I would expect that the refcount/flag/whatever would remain
held for the signal sender's ACID until the auditd state's ACID died
(the struct would be reaped as part of the ACID death).  In cases
where the container orchestrator blocks sending signals across ACID
boundaries this really isn't an issue as it will all be the same ACID,
but since we don't want to impose any restrictions on what a container
*could* be it is important to make sure we handle the case where the
signal sender's ACID may be different from the associated auditd's
ACID.

> Thinking aloud here, the audit daemon's exit when it calls audit_free()
> needs to ..._put_sig and cancel that audit_sig_cid (which in the future
> will be allocated per auditd rather than the global it is now since
> there is only one audit daemon).
>
> > paul moore
>
> - RGB
>
> --
> Richard Guy Briggs <rgb@redhat.com>
> Sr. S/W Engineer, Kernel Security, Base Operating Systems
> Remote, Ottawa, Red Hat Canada
> IRC: rgb, SunRaycer
> Voice: +1.647.777.2635, Internal: (81) 32635

-- 
paul moore
www.paul-moore.com
