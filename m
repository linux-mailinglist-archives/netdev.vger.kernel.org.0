Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4496B262
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 01:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389133AbfGPXa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 19:30:28 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39164 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389124AbfGPXa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 19:30:28 -0400
Received: by mail-lf1-f68.google.com with SMTP id v85so14942423lfa.6
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 16:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YWcpEc5FvGUxMrkeRiB0cnwgYS5TPs4Urt5+gPVZDh8=;
        b=kfuVXg1GBNwcOoznZPvryqh6/i2XrbBE6hkmVUMgSZi+LTGFCMeiia9P0u53fqR03S
         Db8ww5cz17ZFCZKlTuva1FUSo3Y2oMZofZ8fP/h1fLivURlC81chU7PWbmPju7Admx1Z
         0vNl1Znw/JxnQbaEB3qodZy91u3UJcA/kBkF3/fop+D+uNxeIU9ClEdXjFRvVywlejx8
         DnAqQwuvXO4VpPWfxjCThhbeKljqILhPjFnODqbpRq1N11o4FSdml1BI7L1b7dz9y+YP
         fYw1lfsvEQejaiRHp3kfd9vzzpXxhC6v4ipIrx4uMBDRiXoRA77MJ55m7j30qsm5olyc
         8AKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YWcpEc5FvGUxMrkeRiB0cnwgYS5TPs4Urt5+gPVZDh8=;
        b=eMuSqCh6mWgGX9pdJ1nCRJzYf46xtpDiLsgOHj0uy3NGmEGb/Y7EWQFxvXn7wECEZ3
         aOEjYWYk7M7DSHkp2BECbpTGOo+liLuVxMjr1xZnr2HY6Igyjo90UbxE7LRvu2eCoQkV
         CemeSdIjng/hzDizMR7IRBvHb+IV74L4oJ3bq/dmlUC69mUlbVEHpfDgiNbZRz8tKz7l
         xEGUA6qrzXpQxMrYDyjkci4+yF852HQBPmyOyHGoo6E/X5OIUWJe6tCIccqV9KYPGryh
         sY47nUfG8OhasXuGvx1q1w+BbYqBOJXBSq349Oquwipjpm2ucv0yviEbBwXfZXeOUXS4
         s8RQ==
X-Gm-Message-State: APjAAAXrYUe8PULHVzkX763F8zUV+YSbxCOldWjGk/xu9Ju20jdMg/iz
        jAWqgWIw6wZR1AxQ8GWhZLzQmQIl9v55wpfd3Q==
X-Google-Smtp-Source: APXvYqxz39ngK72ytLQXqEXgHBnS7WXBpZpi6vOwRoyqlsR7YPmTcb6oeRneK/RtXK9BLw25UxnyGGXWi29uMJ0dI9o=
X-Received: by 2002:ac2:4109:: with SMTP id b9mr14480083lfi.31.1563319826317;
 Tue, 16 Jul 2019 16:30:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190529145742.GA8959@cisco> <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
 <20190529153427.GB8959@cisco> <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
 <20190529222835.GD8959@cisco> <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
 <20190530170913.GA16722@mail.hallyn.com> <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
 <20190708180558.5bar6ripag3sdadl@madcap2.tricolour.ca> <CAHC9VhRTT7JWqNnynvK04wKerjc-3UJ6R1uPtjCAPVr_tW-7MA@mail.gmail.com>
 <20190716220320.sotbfqplgdructg7@madcap2.tricolour.ca>
In-Reply-To: <20190716220320.sotbfqplgdructg7@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 16 Jul 2019 19:30:15 -0400
Message-ID: <CAHC9VhScHizB2r5q3T5s0P3jkYdvzBPPudDksosYFp_TO7W9-Q@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        Tycho Andersen <tycho@tycho.ws>,
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

On Tue, Jul 16, 2019 at 6:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-07-15 17:04, Paul Moore wrote:
> > On Mon, Jul 8, 2019 at 2:06 PM Richard Guy Briggs <rgb@redhat.com> wrote:

...

> > > If we can't trust ns_capable() then why are we passing on
> > > CAP_AUDIT_CONTROL?  It is being passed down and not stripped purposely
> > > by the orchestrator/engine.  If ns_capable() isn't inherited how is it
> > > gained otherwise?  Can it be inserted by cotainer image?  I think the
> > > answer is "no".  Either we trust ns_capable() or we have audit
> > > namespaces (recommend based on user namespace) (or both).
> >
> > My thinking is that since ns_capable() checks the credentials with
> > respect to the current user namespace we can't rely on it to control
> > access since it would be possible for a privileged process running
> > inside an unprivileged container to manipulate the audit container ID
> > (containerized process has CAP_AUDIT_CONTROL, e.g. running as root in
> > the container, while the container itself does not).
>
> What makes an unprivileged container unprivileged?  "root", or "CAP_*"?

My understanding is that when most people refer to an unprivileged
container they are referring to a container run without capabilities
or a container run by a user other than root.  I'm sure there are
better definitions out there, by folks much smarter than me on these
things, but that's my working definition.

> If CAP_AUDIT_CONTROL is granted, does "root" matter?

Our discussions here have been about capabilities, not UIDs.  The only
reason root might matter is that it generally has the full capability
set.

> Does it matter what user namespace it is in?

What likely matters is what check is called: capable() or
ns_capable().  Those can yield very different results.

> I understand that root is *gained* in an
> unprivileged user namespace, but capabilities are inherited or permitted
> and that process either has it or it doesn't and an unprivileged user
> namespace can't gain a capability that has been rescinded.  Different
> subsystems use the userid or capabilities or both to determine
> privileges.

Once again, I believe the important thing to focus on here is
capable() vs ns_capable().  We can't safely rely on ns_capable() for
the audit container ID policy since that is easily met inside the
container regardless of the process' creds which started the
container.

> In this case, is the userid relevant?

We don't do UID checks, we do capability checks, so yes, the UID is irrelevant.

> > > At this point I would say we are at an impasse unless we trust
> > > ns_capable() or we implement audit namespaces.
> >
> > I'm not sure how we can trust ns_capable(), but if you can think of a
> > way I would love to hear it.  I'm also not sure how namespacing audit
> > is helpful (see my above comments), but if you think it is please
> > explain.
>
> So if we are not namespacing, why do we not trust capabilities?

We can trust capable(CAP_AUDIT_CONTROL) for enforcing audit container
ID policy, we can not trust ns_capable(CAP_AUDIT_CONTROL).

-- 
paul moore
www.paul-moore.com
