Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14E674ADB6
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 00:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbfFRWMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 18:12:31 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34281 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbfFRWMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 18:12:30 -0400
Received: by mail-lf1-f65.google.com with SMTP id y198so10481412lfa.1
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 15:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ijTfZvfI5wTJeK3N+IrXSjofyksCP1FMpQA/cT2QWU=;
        b=x8SMGPt5CiziwkN3SCSA7Z0jWoPKkMXC56QCq+rhpdnCQb7X0zm6NrCqztIGSaqu0S
         nyx9ubiWqlPc5g01uCZnYqwpwQ+ekwt2L19wdNEr8eQ4SMT23yDlXm6uyuKiKEAncj8a
         38eLY2zHb8L9ly8vD63stgevnXOR2av3Rl1kjVaJ7v5e41jfNdl5sO7i6uBeFqHOn2lc
         xuI2Ibg6KEl9kMayLNOnRibmy+knfntp/5G3h4GQKG3amw+q/cyR6WDR5lE5sr9TXTPy
         O24VLdSd2ef7nPlyXmjKEsQCNSlingjELGr0xPg14Yar7eH7+qJMmBrqv91BJaROoXyo
         10NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ijTfZvfI5wTJeK3N+IrXSjofyksCP1FMpQA/cT2QWU=;
        b=KF+CelSVbtn5qxdj6s5PotQrXSMbcMW77HE+Lm/+GYHXq0W3Q2oKXPwc66cNPWG/iK
         aUedGx5xJbLU0x9g81ISFoEmafyu1o8n88IlKKJixb/R2gWwjbWd++nHWuAdkBLYhOh5
         45Ywr1JD3BBfUiMwh+fBvCm5gIdaaOJ0VLt0guI6XeVGDLPIFE+zA+ouL4PmXD1sODvL
         o5PYKGJ1jRQ4rfTBTkhCVF5hYsgIiI/1LdRicRiYDvWtWa3vc+SxuVeR3P7Wo+lXolGn
         /+SH/W/y033cIsIxHbI9gilO/+VWhJ6JnyCatlyH7qfBBoBCQGNqQ41mw2hcWMtmkU1z
         3R/w==
X-Gm-Message-State: APjAAAXbLpWDnByy9Fe0pVuGrPsSIwDNLf5W1iVdEP4VbX3DO/M8Y4+5
        mnAvCZ5l2qmxPB1/jggfnZUTEhnpUzt0oRlxFugy
X-Google-Smtp-Source: APXvYqzZQi06PsgleLiA9BnZDSf+AVj02P6GpIYllhxTaBU8QmqZTlzv0Kz7u7O4QUVbSMdtwS/xzb4L+qw66/UkkdQ=
X-Received: by 2002:ac2:5310:: with SMTP id c16mr59181153lfh.119.1560895948607;
 Tue, 18 Jun 2019 15:12:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190529145742.GA8959@cisco> <20190531002058.tsddah4edcazkuzs@madcap2.tricolour.ca>
 <CAHC9VhTrM1op_EH=YAn9pU8dMOr=jB-Ph4SxFeqGFskwLmFnCA@mail.gmail.com> <97478582.yP93vGJyqj@x2>
In-Reply-To: <97478582.yP93vGJyqj@x2>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 18 Jun 2019 18:12:17 -0400
Message-ID: <CAHC9VhQTPUnHt73SVn=iA_PW1mHkkDf=Nri1kgw_m5mcoiJV9A@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
To:     Steve Grubb <sgrubb@redhat.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Tycho Andersen <tycho@tycho.ws>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 4:24 PM Steve Grubb <sgrubb@redhat.com> wrote:
> Hello Paul,
>
> I am curious about this. We seemed to be close to getting this patch pulled
> in. A lot of people are waiting for it. Can you summarize what you think the
> patches need and who we think needs to do it? I'm lost. Does LXC people need
> to propose something? Does Richard? Someone else? Who's got the ball?

[My apologies, this was lost in my inbox and I just not noticed it.]

Please don't top post on things sent to the mailing lists Steve, you
know better than that.

Yes, things were moving along well, but upon talking with the LXC
folks it appears we underestimated the importance of nested
orchestrators.  I suspect my reply to Dan on the 4th covered your
questions, if you didn't see it, here is the relevant snippet:

"To be clear, that's where we are at: we need to figure out what the
kernel API would look like to support nested container orchestrators.
My gut feeling is that this isn't going to be terribly complicated
compared to the rest of the audit container ID work, but it is going
to be some work.  We had a discussion about some potential solutions
in the cover letter and it sounds like Richard is working up some
ideas now, let's wait to see what that looks like."

... and that is where we are at.  I'm looking forward to seeing
Richard's next patchset.

> On Friday, May 31, 2019 8:44:45 AM EDT Paul Moore wrote:
> > On Thu, May 30, 2019 at 8:21 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2019-05-30 19:26, Paul Moore wrote:
> > > > On Thu, May 30, 2019 at 5:29 PM Tycho Andersen <tycho@tycho.ws> wrote:
> > > > > On Thu, May 30, 2019 at 03:29:32PM -0400, Paul Moore wrote:
> > > > > > [REMINDER: It is an "*audit* container ID" and not a general
> > > > > > "container ID" ;)  Smiley aside, I'm not kidding about that part.]
> > > > >
> > > > > This sort of seems like a distinction without a difference;
> > > > > presumably
> > > > > audit is going to want to differentiate between everything that
> > > > > people
> > > > > in userspace call a container. So you'll have to support all this
> > > > > insanity anyway, even if it's "not a container ID".
> > > >
> > > > That's not quite right.  Audit doesn't care about what a container is,
> > > > or is not, it also doesn't care if the "audit container ID" actually
> > > > matches the ID used by the container engine in userspace and I think
> > > > that is a very important line to draw.  Audit is simply given a value
> > > > which it calls the "audit container ID", it ensures that the value is
> > > > inherited appropriately (e.g. children inherit their parent's audit
> > > > container ID), and it uses the value in audit records to provide some
> > > > additional context for log analysis.  The distinction isn't limited to
> > > > the value itself, but also to how it is used; it is an "audit
> > > > container ID" and not a "container ID" because this value is
> > > > exclusively for use by the audit subsystem.  We are very intentionally
> > > > not adding a generic container ID to the kernel.  If the kernel does
> > > > ever grow a general purpose container ID we will be one of the first
> > > > ones in line to make use of it, but we are not going to be the ones to
> > > > generically add containers to the kernel.  Enough people already hate
> > > > audit ;)
> > > >
> > > > > > I'm not interested in supporting/merging something that isn't
> > > > > > useful;
> > > > > > if this doesn't work for your use case then we need to figure out
> > > > > > what
> > > > > > would work.  It sounds like nested containers are much more common
> > > > > > in
> > > > > > the lxc world, can you elaborate a bit more on this?
> > > > > >
> > > > > > As far as the possible solutions you mention above, I'm not sure I
> > > > > > like the per-userns audit container IDs, I'd much rather just emit
> > > > > > the
> > > > > > necessary tracking information via the audit record stream and let
> > > > > > the
> > > > > > log analysis tools figure it out.  However, the bigger question is
> > > > > > how
> > > > > > to limit (re)setting the audit container ID when you are in a
> > > > > > non-init
> > > > > > userns.  For reasons already mentioned, using capable() is a non
> > > > > > starter for everything but the initial userns, and using
> > > > > > ns_capable()
> > > > > > is equally poor as it essentially allows any userns the ability to
> > > > > > munge it's audit container ID (obviously not good).  It appears we
> > > > > > need a different method for controlling access to the audit
> > > > > > container
> > > > > > ID.
> > > > >
> > > > > One option would be to make it a string, and have it be append only.
> > > > > That should be safe with no checks.
> > > > >
> > > > > I know there was a long thread about what type to make this thing. I
> > > > > think you could accomplish the append-only-ness with a u64 if you had
> > > > > some rule about only allowing setting lower order bits than those
> > > > > that
> > > > > are already set. With 4 bits for simplicity:
> > > > >
> > > > > 1100         # initial container id
> > > > > 1100 -> 1011 # not allowed
> > > > > 1100 -> 1101 # allowed, but now 1101 is set in stone since there are
> > > > >
> > > > >              # no lower order bits left
> > > > >
> > > > > There are probably fancier ways to do it if you actually understand
> > > > > math :)
> > > >
> > > >  ;)
> > > >
> > > > > Since userns nesting is limited to 32 levels (right now, IIRC), and
> > > > > you have 64 bits, this might be reasonable. You could just teach
> > > > > container engines to use the first say N bits for themselves, with a
> > > > > 1
> > > > > bit for the barrier at the end.
> > > >
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
> > > My first reaction to using the IDR code is that once an idr is given up,
> > > it can be reused.  I suppose we request IDRs and then never give them up
> > > to avoid reuse...
> >
> > I'm not sure we ever what to guarantee that an audit container ID
> > won't be reused during the lifetime of the system, it is a discrete
> > integer after all.  What I think we do want to guarantee is that we
> > won't allow an unintentional audit container ID collision between
> > different orchestrators; if a single orchestrator wants to reuse an
> > audit container ID then that is its choice.
> >
> > > I already had some ideas of preventing an existing ID from being reused,
> >
> > Cool.  I only made the idr suggestion since it is used for PIDs and
> > solves a very similar problem.
> >
> > > but that makes the practice of some container engines injecting
> > > processes into existing containers difficult if not impossible.
> >
> > Yes, we'll need some provision to indicate which orchestrator
> > "controls" that particular audit container ID, and allow that
> > orchestrator to reuse that particular audit container ID (until all
> > those containers disappear and the audit container ID is given back to
> > the pool).
>
>
>
>


--
paul moore
www.paul-moore.com
