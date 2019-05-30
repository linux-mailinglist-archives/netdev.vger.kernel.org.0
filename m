Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9B3302C6
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfE3T3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:29:51 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33725 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfE3T3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:29:48 -0400
Received: by mail-lj1-f195.google.com with SMTP id w1so7254528ljw.0
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 12:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iVk/NFNgHVBFx7MhewVcDHKeuh0/y8uv27n+wctjBBw=;
        b=iUJd3oa19CugyfCed6zmPxPNuarTP/1imCFXfhjAKXmDQBo5jZe7ZBR5RJOq+hx6br
         tfQzOOPQSqboRyGxFLT3oSfQ+JEgq29U2q60jo8Rr2CFQTVVxATpRL8XEc0KJdCPnkC0
         SbiJiRSFkAq8oO5wi8mEi96cPVRUr9w8MIZ/OWqOCcFnsB6CPb5tpIu+P0Ghso3X245/
         NCySiboUIcKL8ug8JS2mDcOFFPLquJEQpPTys/6K9z3FovVwTZAdFmLqlzNlKDrXytw1
         cQv+DRz6iJnKKRbUgD8k65be4+HNaacB+tw7zitbPLmamQffqA0s+u7+l5fj7cD+yxkk
         BtIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iVk/NFNgHVBFx7MhewVcDHKeuh0/y8uv27n+wctjBBw=;
        b=Gsgz+XSlTQxPvoiJZPXWYyfjWXrb4R8DpL7b7MChN+kxgu+KuJf7E7hCo/W66iDTDP
         2E9uYo2RS8wOL1X9tYwc22/RaqBFFk1jYFnYNo6Mlg90+pleB/ezEc5IaT5QYMDyyHRU
         mMIHGyPDo38Xn4aJbQKot/8QVJdc9on6RdlMO8iUqqxf7cXe5KvsNGhbv89uKaFKIOrQ
         hS37FjCowJL8SG+ITVVfad5dIha1k8j0inuAzjUOV9f/Aj4jHbMjFX1tfAHqYYdOSQuG
         d7Eia8oGfKuOOH4q3WATSZIZFovwORgWxgzJ7dLgRmshbLXLEdbUNDLsLca55FfpywUS
         adDg==
X-Gm-Message-State: APjAAAXREGgGLdfI5Mje3blCNRLf8yYXWQ8isZjtNEaYdf8X7KVAOXrf
        H+7kxThWxLdjyOQotaQacilN8BQWpPYtCq7dxZlX
X-Google-Smtp-Source: APXvYqy4oT9/ncpEwgceU+Uxm1SPfMQyT6tfoJxHZH5OZOJlX84DZdkuPn8yylZ7C5804jX66KJvTV8Txj+BX2224oo=
X-Received: by 2002:a2e:9bc5:: with SMTP id w5mr3279775ljj.87.1559244585165;
 Thu, 30 May 2019 12:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <9edad39c40671fb53f28d76862304cc2647029c6.1554732921.git.rgb@redhat.com>
 <20190529145742.GA8959@cisco> <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
 <20190529153427.GB8959@cisco> <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
 <20190529222835.GD8959@cisco> <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
 <20190530170913.GA16722@mail.hallyn.com>
In-Reply-To: <20190530170913.GA16722@mail.hallyn.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 30 May 2019 15:29:32 -0400
Message-ID: <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
To:     "Serge E. Hallyn" <serge@hallyn.com>
Cc:     Tycho Andersen <tycho@tycho.ws>,
        Richard Guy Briggs <rgb@redhat.com>,
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

On Thu, May 30, 2019 at 1:09 PM Serge E. Hallyn <serge@hallyn.com> wrote:
> On Wed, May 29, 2019 at 06:39:48PM -0400, Paul Moore wrote:
> > On Wed, May 29, 2019 at 6:28 PM Tycho Andersen <tycho@tycho.ws> wrote:
> > > On Wed, May 29, 2019 at 12:03:58PM -0400, Paul Moore wrote:
> > > > On Wed, May 29, 2019 at 11:34 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > > > > On Wed, May 29, 2019 at 11:29:05AM -0400, Paul Moore wrote:
> > > > > > On Wed, May 29, 2019 at 10:57 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > > > > > > On Mon, Apr 08, 2019 at 11:39:09PM -0400, Richard Guy Briggs wrote:

...

> > > > > > The current thinking
> > > > > > is that you would only change the audit container ID from one
> > > > > > set/inherited value to another if you were nesting containers, in
> > > > > > which case the nested container orchestrator would need to be granted
> > > > > > CAP_AUDIT_CONTROL (which everyone to date seems to agree is a workable
> > > > > > compromise).
> > >
> > > won't work in user namespaced containers, because they will never be
> > > capable(CAP_AUDIT_CONTROL); so I don't think this will work for
> > > nesting as is. But maybe nobody cares :)
> >
> > That's fun :)
> >
> > To be honest, I've never been a big fan of supporting nested
> > containers from an audit perspective, so I'm not really too upset
> > about this.  The k8s/cri-o folks seem okay with this, or at least I
> > haven't heard any objections; lxc folks, what do you have to say?
>
> I actually thought the answer to this (when last I looked, "some time" ago)
> was that userspace should track an audit message saying "task X in
> container Y is changing its auditid to Z", and then decide to also track Z.
> This should be doable, but a lot of extra work in userspace.
>
> Per-userns containerids would also work.  So task X1 is in containerid
> 1 on the host and creates a new task Y in new userns;  it continues to
> be reported in init_user_ns as containerid 1 forever;  but in its own
> userns it can request to be known as some other containerid.  Audit
> socks would be per-userns, allowing root in a container to watch for
> audit events in its own (and descendent) namespaces.
>
> But again I'm sure we've gone over all this in the last few years.
>
> I suppose we can look at this as a "first step", and talk about
> making it user-ns-nestable later.  But agreed it's not useful in a
> lot of situations as is.

[REMINDER: It is an "*audit* container ID" and not a general
"container ID" ;)  Smiley aside, I'm not kidding about that part.]

I'm not interested in supporting/merging something that isn't useful;
if this doesn't work for your use case then we need to figure out what
would work.  It sounds like nested containers are much more common in
the lxc world, can you elaborate a bit more on this?

As far as the possible solutions you mention above, I'm not sure I
like the per-userns audit container IDs, I'd much rather just emit the
necessary tracking information via the audit record stream and let the
log analysis tools figure it out.  However, the bigger question is how
to limit (re)setting the audit container ID when you are in a non-init
userns.  For reasons already mentioned, using capable() is a non
starter for everything but the initial userns, and using ns_capable()
is equally poor as it essentially allows any userns the ability to
munge it's audit container ID (obviously not good).  It appears we
need a different method for controlling access to the audit container
ID.

Punting this to a LSM hook is an obvious thing to do, and something we
might want to do anyway, but currently audit doesn't rely on the LSM
for proper/safe operation and I'm not sure I want to change that now.

The next obvious thing is to create some sort of access control knob
in audit itself.  Perhaps an auditctl operation that would allow the
administrator to specify which containers, via their corresponding
audit container IDs, are allowed to change their audit container ID?
The permission granting would need to be done in the init userns, but
it would allow containers with a non-init userns the ability to change
their audit container ID.  We would probably still want a
ns_capable(CAP_AUDIT_CONTROL) restriction in this case.

Does anyone else have any other ideas?

-- 
paul moore
www.paul-moore.com
