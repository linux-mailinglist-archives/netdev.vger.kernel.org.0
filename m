Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 307BA2E111
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 17:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfE2P3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 11:29:19 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38431 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfE2P3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 11:29:19 -0400
Received: by mail-lj1-f194.google.com with SMTP id o13so2909457lji.5
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 08:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zGaoYWpZqQThaCeamoLFUvuaep53rUnIcLcyCp5w/vg=;
        b=K16i45JTnOhNMfVGcEM3dEc/HE4jxUF98k+I1d4LAg3DOuRJvQylZri7olnMGkge0H
         4u/1DHCKb96WcllkEwg/MgRcL7L1CCWB/hO2xL6zPqW540FOdvpqq8ULGBnZRtoyr3fP
         /dGrfil607dUvRtiW7bu8V4ywrGKbWRLqU6mf6azB7C8mCUui5dBAoSANEn7un7OuRYk
         IqepsvKsbnqV/1oKEERjHclI3LARwVOrafGfm/8g8m245GMvIADoi+bQuHeE9itYkX84
         p6l1akwBNRSzQLd+wftooHrEfiVN9zwWBxGF+rHhkqPeWkDXyPffgp3T4WNSYiCr0lTu
         +NzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zGaoYWpZqQThaCeamoLFUvuaep53rUnIcLcyCp5w/vg=;
        b=ZNlfoX76dv/4oCb2qR5wxnvHQpROHYUc5upucMrlEcXgbMpBM6X99cjVQRys08aZbL
         Q5lXvJRc7zYlX/eTRy4SNg2jzEPNSLhotAug/dnqKcWWNgmSqmOqaw4oxD22uH4qHU7p
         nxuGSlXZ1nnO2H7Qo9hl//NklfIjEPV24FPJrvEccb4b77pG9E2tora/4TmqvjmCgHo1
         j9XLWT3Lxb3FUnJc+ptM6FYfJTn+Yf1QKMsz8dkAuih7kTHP2vJ24mQZiojhgqbfvxPa
         OE3xEmGdZ51VT16NmxDBa8CSWyg9f9pSTIeUBqbDx/j0VNufnBLlh+OM3tnRG3ZBawri
         /J8Q==
X-Gm-Message-State: APjAAAXlapg5G1eY+rZg4ky2rPXbgLxwyeuKuTMomzvJ1IHyoBxuk1+I
        iGkyecZYv9bMmEyw0OYsNWtNObt+shS5U8b1qpMZ
X-Google-Smtp-Source: APXvYqzA1he5CqqTYdGxCaEGH42J2+OT0TC3I1+seVKjcqbN4107AbF/Fb/yxBclhcMIQ95Q2dNrHCvd5kXZOEP8NA8=
X-Received: by 2002:a2e:92cc:: with SMTP id k12mr2501807ljh.16.1559143756865;
 Wed, 29 May 2019 08:29:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <9edad39c40671fb53f28d76862304cc2647029c6.1554732921.git.rgb@redhat.com>
 <20190529145742.GA8959@cisco>
In-Reply-To: <20190529145742.GA8959@cisco>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 29 May 2019 11:29:05 -0400
Message-ID: <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
To:     Tycho Andersen <tycho@tycho.ws>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 10:57 AM Tycho Andersen <tycho@tycho.ws> wrote:
>
> On Mon, Apr 08, 2019 at 11:39:09PM -0400, Richard Guy Briggs wrote:
> > It is not permitted to unset the audit container identifier.
> > A child inherits its parent's audit container identifier.
>
> ...
>
> >  /**
> > + * audit_set_contid - set current task's audit contid
> > + * @contid: contid value
> > + *
> > + * Returns 0 on success, -EPERM on permission failure.
> > + *
> > + * Called (set) from fs/proc/base.c::proc_contid_write().
> > + */
> > +int audit_set_contid(struct task_struct *task, u64 contid)
> > +{
> > +     u64 oldcontid;
> > +     int rc = 0;
> > +     struct audit_buffer *ab;
> > +     uid_t uid;
> > +     struct tty_struct *tty;
> > +     char comm[sizeof(current->comm)];
> > +
> > +     task_lock(task);
> > +     /* Can't set if audit disabled */
> > +     if (!task->audit) {
> > +             task_unlock(task);
> > +             return -ENOPROTOOPT;
> > +     }
> > +     oldcontid = audit_get_contid(task);
> > +     read_lock(&tasklist_lock);
> > +     /* Don't allow the audit containerid to be unset */
> > +     if (!audit_contid_valid(contid))
> > +             rc = -EINVAL;
> > +     /* if we don't have caps, reject */
> > +     else if (!capable(CAP_AUDIT_CONTROL))
> > +             rc = -EPERM;
> > +     /* if task has children or is not single-threaded, deny */
> > +     else if (!list_empty(&task->children))
> > +             rc = -EBUSY;
> > +     else if (!(thread_group_leader(task) && thread_group_empty(task)))
> > +             rc = -EALREADY;
> > +     read_unlock(&tasklist_lock);
> > +     if (!rc)
> > +             task->audit->contid = contid;
> > +     task_unlock(task);
> > +
> > +     if (!audit_enabled)
> > +             return rc;
>
> ...but it is allowed to change it (assuming
> capable(CAP_AUDIT_CONTROL), of course)? Seems like this might be more
> immediately useful since we still live in the world of majority
> privileged containers if we didn't allow changing it, in addition to
> un-setting it.

The idea is that only container orchestrators should be able to
set/modify the audit container ID, and since setting the audit
container ID can have a significant effect on the records captured
(and their routing to multiple daemons when we get there) modifying
the audit container ID is akin to modifying the audit configuration
which is why it is gated by CAP_AUDIT_CONTROL.  The current thinking
is that you would only change the audit container ID from one
set/inherited value to another if you were nesting containers, in
which case the nested container orchestrator would need to be granted
CAP_AUDIT_CONTROL (which everyone to date seems to agree is a workable
compromise).  We did consider allowing for a chain of nested audit
container IDs, but the implications of doing so are significant
(implementation mess, runtime cost, etc.) so we are leaving that out
of this effort.

From a practical perspective, un-setting the audit container ID is
pretty much the same as changing it from one set value to another so
most of the above applies to that case as well.

-- 
paul moore
www.paul-moore.com
