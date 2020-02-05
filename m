Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66D03153B22
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 23:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgBEWku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 17:40:50 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37931 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727472AbgBEWku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 17:40:50 -0500
Received: by mail-ed1-f67.google.com with SMTP id p23so3837447edr.5
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 14:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8xXG1QtEMIn8V9gNjRgmErq86awhNCCbmdyeTvn2xh4=;
        b=B2gKGom18+c9MF6YGaz2F1Z1qW9+72OISrmowso176+fbEJ4JZdJKOh3vsryaEmTh2
         qsQvM5njKuNSX/pDogHOs3oz3vOQ0pSe5bjZ3GghT09ZXUiPFwt+WUNdZWFtpiBvr/Vo
         35XRtzO5XOYYDiWHXeJnqRi+81XvR1hD6IRxs+Agj7o11R3YTydxawjWSUzK+RHi0MZn
         Qz4QNQ8DGRcLR8vX7dZCGPvsmhfEZ4NN3T2QQS15BGUtGdgRlr1kIGvLIHMoZd+OjNMA
         UPaI06zrpOfJBd5wMiWOhk/QoVlDtFLtkPQ7CGVCqyrKxkW/Rki6/QlMAUO25kMLkiU5
         KqHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8xXG1QtEMIn8V9gNjRgmErq86awhNCCbmdyeTvn2xh4=;
        b=RL29brMfLImnTycBnwcre+D5yStx4YgLLwb+ESnuR4AU5uRCiwEQEeyjz7aTmBJSYY
         VFmU8btaSQl+YYGAnBTZfS0Syu6CRePN1q1E06A0mab9OWdvnvwktssIQwArCih+1Jt7
         vU8SRpNLuiWA+moFIff9aZz/x57pCMcIcL8dP1O7DQe/BQp6jBMnnMe3zjqhYHfE9M6n
         nJpBVuhNMPPF44tyegwinFmJgnu7eUF/GjExR/eakhtch5UxAExUyqvTw2T7odeOKQNc
         2eLZ38p6GgyV82ktZq201xhgGB2GsYF4a8b8j69xEojitwj+EwQ8R/3L7i7Lxdq0IDzm
         sfcA==
X-Gm-Message-State: APjAAAU6XyhXLuxvvTC5P0fHpVgy5GUbKIfjDMvKRq2ljbYzJeevNt7n
        dHR9tS/vEEFtlS0QnfUgULUQWGv34SZLDbc9yOnz
X-Google-Smtp-Source: APXvYqyVmzGVk7l0HXNY4hEqVOGOlb69aaI9jrvMLTASMwXkrAFjGVXWNm6juE48f6syGPPLenhCV6x6YfwAuvnC2Wk=
X-Received: by 2002:a50:a7a5:: with SMTP id i34mr396051edc.128.1580942447650;
 Wed, 05 Feb 2020 14:40:47 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <a911acf0b209c05dc156fb6b57f9da45778747ce.1577736799.git.rgb@redhat.com>
 <CAHC9VhRRW2fFcgBs-R_BZ7ZWCP5wsXA9DB1RUM=QeKj2xZkS2Q@mail.gmail.com> <20200204225148.io3ayosk4efz2qii@madcap2.tricolour.ca>
In-Reply-To: <20200204225148.io3ayosk4efz2qii@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 5 Feb 2020 17:40:36 -0500
Message-ID: <CAHC9VhQSZDt4KyFmc9TtLvKgziMCkPzRWdwa71Juo=LZRygfVA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 04/16] audit: convert to contid list to check
 for orch/engine ownership
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 4, 2020 at 5:52 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-01-22 16:28, Paul Moore wrote:
> > On Tue, Dec 31, 2019 at 2:50 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > Store the audit container identifier in a refcounted kernel object that
> > > is added to the master list of audit container identifiers.  This will
> > > allow multiple container orchestrators/engines to work on the same
> > > machine without danger of inadvertantly re-using an existing identifier.
> > > It will also allow an orchestrator to inject a process into an existing
> > > container by checking if the original container owner is the one
> > > injecting the task.  A hash table list is used to optimize searches.
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  include/linux/audit.h | 14 ++++++--
> > >  kernel/audit.c        | 98 ++++++++++++++++++++++++++++++++++++++++++++++++---
> > >  kernel/audit.h        |  8 +++++
> > >  3 files changed, 112 insertions(+), 8 deletions(-)

...

> > > @@ -232,7 +263,11 @@ int audit_alloc(struct task_struct *tsk)
> > >         }
> > >         info->loginuid = audit_get_loginuid(current);
> > >         info->sessionid = audit_get_sessionid(current);
> > > -       info->contid = audit_get_contid(current);
> > > +       spin_lock(&audit_contobj_list_lock);
> > > +       info->cont = _audit_contobj(current);
> > > +       if (info->cont)
> > > +               _audit_contobj_hold(info->cont);
> > > +       spin_unlock(&audit_contobj_list_lock);
> >
> > If we are taking a spinlock in order to bump the refcount, does it
> > really need to be a refcount_t or can we just use a normal integer?
> > In RCU protected lists a spinlock is usually used to protect
> > adds/removes to the list, not the content of individual list items.
> >
> > My guess is you probably want to use the spinlock as described above
> > (list add/remove protection) and manipulate the refcount_t inside a
> > RCU read lock protected region.
>
> Ok, I guess it could be an integer if it were protected by the spinlock,
> but I think you've guessed my intent, so let us keep it as a refcount
> and tighten the spinlock scope and use rcu read locking to protect _get
> and _put in _alloc, _free, and later on when protecting the network
> namespace contobj lists.  This should reduce potential contention for
> the spinlock to one location over fewer lines of code in that place
> while speeding up updates and slightly simplifying code in the others.

If it helps, you should be able to find plenty of rcu/spinlock
protected list examples in the kernel code.  It might be a good idea
if you spent some time looking at those implementations first to get
an idea of how it is usually done.

> > > @@ -2381,9 +2425,12 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> > >         }
> > >         oldcontid = audit_get_contid(task);
> > >         read_lock(&tasklist_lock);
> > > -       /* Don't allow the audit containerid to be unset */
> > > +       /* Don't allow the contid to be unset */
> > >         if (!audit_contid_valid(contid))
> > >                 rc = -EINVAL;
> > > +       /* Don't allow the contid to be set to the same value again */
> > > +       else if (contid == oldcontid) {
> > > +               rc = -EADDRINUSE;
> >
> > First, is that brace a typo?  It looks like it.  Did this compile?
>
> Yes, it was fixed in the later patch that restructured the if
> statements.

Generic reminder that each patch should compile and function on it's
own without the need for any follow-up patches.  I know Richard is
already aware of that, and this was a mistake that slipped through the
cracks; this reminder is more for those who may be lurking on the
list.

> > Second, can you explain why (re)setting the audit container ID to the
> > same value is something we need to prohibit?  I'm guessing it has
> > something to do with explicitly set vs inherited, but I don't want to
> > assume too much about your thinking behind this.
>
> It made the refcounting more complicated later, and besides, the
> prohibition on setting the contid again if it is already set would catch
> this case, so I'll remove it in this patch and ensure this action
> doesn't cause a problem in later patches.
>
> > If it is "set vs inherited", would allowing an orchestrator to
> > explicitly "set" an inherited audit container ID provide some level or
> > protection against moving the task?
>
> I can't see it helping prevent this since later descendancy checks will
> stop this move anyways.

That's what I thought, but I was just trying to think of any reason
why you felt this might have been useful since it was in the patch.
If it's in the patch I tend to fall back on the idea that it must have
served a purpose ;)

> > > @@ -2396,8 +2443,49 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> > >         else if (audit_contid_set(task))
> > >                 rc = -ECHILD;
> > >         read_unlock(&tasklist_lock);
> > > -       if (!rc)
> > > -               task->audit->contid = contid;
> > > +       if (!rc) {
> > > +               struct audit_contobj *oldcont = _audit_contobj(task);
> > > +               struct audit_contobj *cont = NULL, *newcont = NULL;
> > > +               int h = audit_hash_contid(contid);
> > > +
> > > +               rcu_read_lock();
> > > +               list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
> > > +                       if (cont->id == contid) {
> > > +                               /* task injection to existing container */
> > > +                               if (current == cont->owner) {
> >
> > Do we have any protection against the task pointed to by cont->owner
> > going away and a new task with the same current pointer value (no
> > longer the legitimate audit container ID owner) manipulating the
> > target task's audit container ID?
>
> Yes, the get_task_struct() call below.

Gotcha.

-- 
paul moore
www.paul-moore.com
