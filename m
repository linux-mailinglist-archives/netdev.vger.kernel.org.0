Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838A72E83C
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfE2W2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:28:39 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35304 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfE2W2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 18:28:39 -0400
Received: by mail-pl1-f196.google.com with SMTP id p1so1656356plo.2
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 15:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sxlc+0BZVMGJBkklhDGCMx7b3nCRFgQD29T89CaCav0=;
        b=uDH3DgbAe0Nn6uZaYSAgEAJNiDB6BDF/SuDggKMk+TzPiQYZumu8d83PNR+BSvvkjD
         Zqgy1VvS2JR173DGBaMMLDmuLhmKeQfKXMNlQBW4bysvH4ieNup9nkRjVZOnltvcIRfr
         Un/6jJdo23xTg/mEWqa20n0xKot6OMJNahZU8iLMCLL2z7ewLtQbJ+ax8N766OPUalEX
         LmOHsG+B+hAfQLAOa3r/719u+3/4C10vzjsXK8xSeC0B1qMmi7ercJginmJWLiQ/Du9O
         CdugUw32bHOBq8kpQNaof0wrf0z5h5vT0lQXg26TskQGxiFnhC9kzmnRUvkeCSa7Mkgu
         eDtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sxlc+0BZVMGJBkklhDGCMx7b3nCRFgQD29T89CaCav0=;
        b=Jb/V4y1P+nodXfY93g3sy4QOiOfvH6VRrCXa2+nybv3MJW7ea0JinZokiCI66DiEUO
         bFNnPaRklzLkmvcV4dAobKS3y+ofYNfb4GbUMWmiVIO9qHUdzW7GCIGtN3gTv4WpMqJx
         cb92ysqlNEwHYjsFCQL8bfKGHREZna5GF5Tk79DxmUKRkk1QEBgQdr3EEhiWa1jNzCXT
         jKOmVXyhyOgHLqDsmn8vAaNl9GzO5D4SGOwlmMdEVjSIoOfqsM8ltOtDMlEBY0SPvuYa
         T4kf6rdM3i0qA3YcmYFLATpg6hH9PlZpfhmWLMNu1XDZiBDBPiNIt+xlBcbLIi+ec42q
         TqYA==
X-Gm-Message-State: APjAAAWGsI635oEAdOTITAjciudeI4F+D8hCuY5e9HSEG25d6XkDfGAg
        MjkP9Nw6aIq1NtfbBcLm1AazlQ==
X-Google-Smtp-Source: APXvYqx6u4nIn/AIcvxi8a5nOwft+8sm1j1THFLIGuymwboILKVpX0Iml7oLKuGzIYvIJUQMu6yW9g==
X-Received: by 2002:a17:902:24d:: with SMTP id 71mr340297plc.166.1559168918326;
        Wed, 29 May 2019 15:28:38 -0700 (PDT)
Received: from cisco ([2601:280:b:edbb:840:fa90:7243:7032])
        by smtp.gmail.com with ESMTPSA id w187sm690493pfw.20.2019.05.29.15.28.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 May 2019 15:28:37 -0700 (PDT)
Date:   Wed, 29 May 2019 16:28:35 -0600
From:   Tycho Andersen <tycho@tycho.ws>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
Message-ID: <20190529222835.GD8959@cisco>
References: <cover.1554732921.git.rgb@redhat.com>
 <9edad39c40671fb53f28d76862304cc2647029c6.1554732921.git.rgb@redhat.com>
 <20190529145742.GA8959@cisco>
 <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
 <20190529153427.GB8959@cisco>
 <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 12:03:58PM -0400, Paul Moore wrote:
> On Wed, May 29, 2019 at 11:34 AM Tycho Andersen <tycho@tycho.ws> wrote:
> >
> > On Wed, May 29, 2019 at 11:29:05AM -0400, Paul Moore wrote:
> > > On Wed, May 29, 2019 at 10:57 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > > >
> > > > On Mon, Apr 08, 2019 at 11:39:09PM -0400, Richard Guy Briggs wrote:
> > > > > It is not permitted to unset the audit container identifier.
> > > > > A child inherits its parent's audit container identifier.
> > > >
> > > > ...
> > > >
> > > > >  /**
> > > > > + * audit_set_contid - set current task's audit contid
> > > > > + * @contid: contid value
> > > > > + *
> > > > > + * Returns 0 on success, -EPERM on permission failure.
> > > > > + *
> > > > > + * Called (set) from fs/proc/base.c::proc_contid_write().
> > > > > + */
> > > > > +int audit_set_contid(struct task_struct *task, u64 contid)
> > > > > +{
> > > > > +     u64 oldcontid;
> > > > > +     int rc = 0;
> > > > > +     struct audit_buffer *ab;
> > > > > +     uid_t uid;
> > > > > +     struct tty_struct *tty;
> > > > > +     char comm[sizeof(current->comm)];
> > > > > +
> > > > > +     task_lock(task);
> > > > > +     /* Can't set if audit disabled */
> > > > > +     if (!task->audit) {
> > > > > +             task_unlock(task);
> > > > > +             return -ENOPROTOOPT;
> > > > > +     }
> > > > > +     oldcontid = audit_get_contid(task);
> > > > > +     read_lock(&tasklist_lock);
> > > > > +     /* Don't allow the audit containerid to be unset */
> > > > > +     if (!audit_contid_valid(contid))
> > > > > +             rc = -EINVAL;
> > > > > +     /* if we don't have caps, reject */
> > > > > +     else if (!capable(CAP_AUDIT_CONTROL))
> > > > > +             rc = -EPERM;
> > > > > +     /* if task has children or is not single-threaded, deny */
> > > > > +     else if (!list_empty(&task->children))
> > > > > +             rc = -EBUSY;
> > > > > +     else if (!(thread_group_leader(task) && thread_group_empty(task)))
> > > > > +             rc = -EALREADY;
> > > > > +     read_unlock(&tasklist_lock);
> > > > > +     if (!rc)
> > > > > +             task->audit->contid = contid;
> > > > > +     task_unlock(task);
> > > > > +
> > > > > +     if (!audit_enabled)
> > > > > +             return rc;
> > > >
> > > > ...but it is allowed to change it (assuming
> > > > capable(CAP_AUDIT_CONTROL), of course)? Seems like this might be more
> > > > immediately useful since we still live in the world of majority
> > > > privileged containers if we didn't allow changing it, in addition to
> > > > un-setting it.
> > >
> > > The idea is that only container orchestrators should be able to
> > > set/modify the audit container ID, and since setting the audit
> > > container ID can have a significant effect on the records captured
> > > (and their routing to multiple daemons when we get there) modifying
> > > the audit container ID is akin to modifying the audit configuration
> > > which is why it is gated by CAP_AUDIT_CONTROL.  The current thinking
> > > is that you would only change the audit container ID from one
> > > set/inherited value to another if you were nesting containers, in
> > > which case the nested container orchestrator would need to be granted
> > > CAP_AUDIT_CONTROL (which everyone to date seems to agree is a workable
> > > compromise).
> >
> > But then don't you want some kind of ns_capable() instead (probably
> > not the obvious one, though...)? With capable(), you can't really nest
> > using the audit-id and user namespaces together.
> 
> You want capable() and not ns_capable() because you want to ensure
> that the orchestrator has the rights in the init_ns as changes to the
> audit container ID could have an auditing impact that spans the entire
> system.

Ok but,

> > > The current thinking
> > > is that you would only change the audit container ID from one
> > > set/inherited value to another if you were nesting containers, in
> > > which case the nested container orchestrator would need to be granted
> > > CAP_AUDIT_CONTROL (which everyone to date seems to agree is a workable
> > > compromise).

won't work in user namespaced containers, because they will never be
capable(CAP_AUDIT_CONTROL); so I don't think this will work for
nesting as is. But maybe nobody cares :)

Tycho
