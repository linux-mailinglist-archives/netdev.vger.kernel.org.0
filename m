Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFD824E0B8
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 21:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgHUThH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 15:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgHUThE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 15:37:04 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C82C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 12:37:03 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id u21so3020306ejz.0
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 12:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jQURKxDjRWMiMTxRUVV2iQZ2ZeobDW7AH50DwoJj7f8=;
        b=sD6uHtx5WmZbLrlelrAxJJlU8yrwBa7XdhUItXD/MUiuplcXnFHNbs0uCDwUQgzFtN
         jurCNLEA/E4vr3a4yeIje3FqyDQI8sRF2c9YCo0QgyXFJuEqVPmkW2lS0/NsyrCgrxja
         tHGI+6w07Ab8+AjC5II2mNiy2hdZ+3qmZyA6KHRLmlNmhG0wcFb6d/3S35p6poEvsoRd
         vlwL/zS/4H3Jx2D9+lvUJjrS4TpaS1QO3eL2d4amih7Ujdzt9QbFU97rAayMqUXL50px
         JXF3OtgHHiAAnV5emKHZq4o9IjgjW6eSdpoPKf4Z/6Md2pN6nt5uPCWgvaPZOR/vzBsW
         mzSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jQURKxDjRWMiMTxRUVV2iQZ2ZeobDW7AH50DwoJj7f8=;
        b=Dd+WiFhyAZDqOGauZRUrSw5eGX16AAF7s/S1dpMZP2pW4nOlrgmsnBo2EQkvLaSXN+
         wchVlFUiYKvzm4MtZ+2hW++z/AICz+fpC50upFgpPCuGGpZIg9VRxdtVACo5kobKyWHg
         MV0ugyOvDTut0TSZMFcPLFxEsMGRWJy7BOgRLjeooY3KpdvghqGbYTcMNHFDWOQWPX3t
         mVtcC4JblJxOGgH8XQFBSUWUn8Q3p7+Fyyj+ef+A3Sad4dXjDMDK39W/jkmFw4rvLZay
         Dclr7v8zP2nXxkXn5kNMfc+mde2zoXoomuiAYev/hNF7VyQquxwT+3rOkVBl3Oq58pbv
         z8xg==
X-Gm-Message-State: AOAM5332bS48sq5t9d7//yo0xx0Y/wyTzHtxg8NiFhA78ns/S09Ldg98
        ftbYoHpzMBKMEBKQQMZmiyqItSUHpqmUK9qdOQvp
X-Google-Smtp-Source: ABdhPJxv9ljf/EC5lZy/k36EEbz/l4zL+9SOFpsYjODOPjAFI0K0Ji1ACIURRzkOqqw0PrvW8Opqs3fti74vNH7Daus=
X-Received: by 2002:a17:906:43c9:: with SMTP id j9mr4383574ejn.542.1598038620869;
 Fri, 21 Aug 2020 12:37:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593198710.git.rgb@redhat.com> <e5a1ab6955c565743372b392a93f7d1ac98478a2.1593198710.git.rgb@redhat.com>
 <CAHC9VhSgcOS79spSuFDMukw2TnLZfBh2p4BWGfoV_CGUS8b77w@mail.gmail.com> <20200729200545.5apwc7fashwsnglj@madcap2.tricolour.ca>
In-Reply-To: <20200729200545.5apwc7fashwsnglj@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 21 Aug 2020 15:36:49 -0400
Message-ID: <CAHC9VhQTiu+yY6cY8tvBf-1ZtZrre3Ljs+Zd6Jf9ZM766bhUYQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V9 02/13] audit: add container id
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, Ondrej Mosnacek <omosnace@redhat.com>,
        dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 4:06 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-07-05 11:09, Paul Moore wrote:
> > On Sat, Jun 27, 2020 at 9:22 AM Richard Guy Briggs <rgb@redhat.com> wrote:

...

> > > @@ -212,6 +219,33 @@ void __init audit_task_init(void)
> > >                                              0, SLAB_PANIC, NULL);
> > >  }
> > >
> > > +/* rcu_read_lock must be held by caller unless new */
> > > +static struct audit_contobj *_audit_contobj_hold(struct audit_contobj *cont)
> > > +{
> > > +       if (cont)
> > > +               refcount_inc(&cont->refcount);
> > > +       return cont;
> > > +}
> > > +
> > > +static struct audit_contobj *_audit_contobj_get(struct task_struct *tsk)
> > > +{
> > > +       if (!tsk->audit)
> > > +               return NULL;
> > > +       return _audit_contobj_hold(tsk->audit->cont);
> > > +}
> > > +
> > > +/* rcu_read_lock must be held by caller */
> > > +static void _audit_contobj_put(struct audit_contobj *cont)
> > > +{
> > > +       if (!cont)
> > > +               return;
> > > +       if (refcount_dec_and_test(&cont->refcount)) {
> > > +               put_task_struct(cont->owner);
> > > +               list_del_rcu(&cont->list);
> >
> > You should check your locking; I'm used to seeing exclusive locks
> > (e.g. the spinlock) around list adds/removes, it just reads/traversals
> > that can be done with just the RCU lock held.
>
> Ok, I've redone the locking yet again.  I knew this on one level but
> that didn't translate consistently to code...
>
> > > +               kfree_rcu(cont, rcu);
> > > +       }
> > > +}
> >
> > Another nitpick, but it might be nice to have similar arguments to the
> > _get() and _put() functions, e.g. struct audit_contobj, but that is
> > some serious bikeshedding (basically rename _hold() to _get() and
> > rename _hold to audit_task_contid_hold() or similar).
>
> I have some idea what you are trying to say, but I think you misspoke.
> Did you mean rename _hold to _get, rename _get to
> audit_task_contobj_hold()?

It reads okay to me, but I know what I'm intending here :)  I agree it
could be a bit confusing.  Let me try to put my suggestion into some
quick pseudo-code function prototypes to make things a bit more
concrete.

The _audit_contobj_hold() function would become:
   struct audit_contobj *_audit_contobj_hold(struct task_struct *tsk);

The _audit_contobj_get() function would become:
   struct audit_contobj *_audit_contobj_get(struct audit_contobj *cont);

The _audit_contobj_put() function would become:
   void _audit_contobj_put(struct audit_contobj *cont);

Basically swap the _get() and _hold() function names so that the
arguments are the same for both the _get() and _set() functions.  Does
this make more sense?

> > >  /**
> > >   * audit_alloc - allocate an audit info block for a task
> > >   * @tsk: task
> > > @@ -232,6 +266,9 @@ int audit_alloc(struct task_struct *tsk)
> > >         }
> > >         info->loginuid = audit_get_loginuid(current);
> > >         info->sessionid = audit_get_sessionid(current);
> > > +       rcu_read_lock();
> > > +       info->cont = _audit_contobj_get(current);
> > > +       rcu_read_unlock();
> >
> > The RCU locks aren't strictly necessary here, are they?  In fact I
> > suppose we could probably just replace the _get() call with a
> > refcount_set(1) just as we do in audit_set_contid(), yes?
>
> I don't understand what you are getting at here.  It needs a *contobj,
> along with bumping up the refcount of the existing contobj.

Sorry, you can disregard.  My mental definition for audit_alloc() is
permanently messed up; I usually double check myself before commenting
on related code, but I must have forgotten here.

-- 
paul moore
www.paul-moore.com
