Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC9824DFED
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 20:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgHUSsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 14:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgHUSsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 14:48:14 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D662C061755
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 11:48:14 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id df16so2281538edb.9
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 11:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zFS0hAClZdBqg1ygZpYSD8oadp4rG9FtsqCxJLGMqfA=;
        b=sR7x2B3WYmbJC0y0bskKUkgCZEZ0j6lJfaOE9m/aD1tPrwC+sndJCJ4t2wQ4hKQfbQ
         7FoezsNiRLAR4hKbKjrEMl76ogeQUCZGtDMDP7LxzfEgFbINSDDNYgMAGx1xoEXq3VpN
         v0MSaBpjMz+kGMMSpn3MoG9Z87EHCAuqGjzax6a4NbGzpiktpJ1dlZ1SY+H8NzLr9EeP
         RaXaiuPjTpMpdTeUflreO3Gt+Uk4fksOchPjyUfHNBmJ931yTLIpXUOk8bUq2a67QQCy
         o+VkBqZZx2uUaYQDUr/mQYz9VD5rnYJzHOfyeLpwvLQYSpQ3DMVul1NsBzC3nzxmWEMr
         GElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zFS0hAClZdBqg1ygZpYSD8oadp4rG9FtsqCxJLGMqfA=;
        b=Pj/wF2BfuhLE1hkRzY9lZBgmz8JILsqgp+W3x40a6cqpEkQnfeU8Sxaq053cSblytG
         i2TOvBDI3HRg8gcsYkxcGTjtRZFDrdKAycSowFHJHsq2e3fNjffZPgVpo6M9L0nj+npB
         /cxA/bG+LuFV89PJmXiN2Njd0zwk/cFrB9lJt5ridsJmBEChaT3g79UDD4l9njxg7Ath
         CqwPphKg6EWRaPLyhZbZaCAeC9OqhZ0eA3mkQ+3dbJI5tINorINY7Zg3FnJmVt4gqYgu
         u4OYJZ9e7daFbLO/qmGkIO8Qigt9hcsP1mTLA73QGoNawX0JpFynosSgxlY8uQwXTVUk
         +pZg==
X-Gm-Message-State: AOAM530sU6MLwJCyd+ztnafqHNYVdp1Ip7KbriQxDy8o1uSYwsvbdJXf
        AarmRDupDoN/+GQIRvr0SdsnTbFI7fnWWYsn+auW
X-Google-Smtp-Source: ABdhPJxY+3WwF8gu1nXbDCAOZ7CXNs3ESEQrI/MAHP08AsZCOrBpTjUWaGk4a55AOk3EOVvdlEJTtMfdxww8QDWXNp8=
X-Received: by 2002:a50:ee93:: with SMTP id f19mr4182974edr.31.1598035692549;
 Fri, 21 Aug 2020 11:48:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593198710.git.rgb@redhat.com> <f01f38dbb3190191e5914874322342700aecb9e1.1593198710.git.rgb@redhat.com>
 <CAHC9VhRPm4=_dVkZCu9iD5u5ixJOUnGNZ2wM9CL4kWwqv3GRnA@mail.gmail.com> <20200729190025.mueangq3os3r7ew6@madcap2.tricolour.ca>
In-Reply-To: <20200729190025.mueangq3os3r7ew6@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 21 Aug 2020 14:48:01 -0400
Message-ID: <CAHC9VhQoSH7Lza517WNr+6LaS7i890JPQfvisV6thLmnu01QOw@mail.gmail.com>
Subject: Re: [PATCH ghak90 V9 06/13] audit: add contid support for signalling
 the audit daemon
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

On Wed, Jul 29, 2020 at 3:00 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-07-05 11:10, Paul Moore wrote:
> > On Sat, Jun 27, 2020 at 9:22 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > Add audit container identifier support to the action of signalling the
> > > audit daemon.
> > >
> > > Since this would need to add an element to the audit_sig_info struct,
> > > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > > audit_sig_info2 struct.  Corresponding support is required in the
> > > userspace code to reflect the new record request and reply type.
> > > An older userspace won't break since it won't know to request this
> > > record type.
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  include/linux/audit.h       |  8 ++++
> > >  include/uapi/linux/audit.h  |  1 +
> > >  kernel/audit.c              | 95 ++++++++++++++++++++++++++++++++++++++++++++-
> > >  security/selinux/nlmsgtab.c |  1 +
> > >  4 files changed, 104 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > index 5eeba0efffc2..89cf7c66abe6 100644
> > > --- a/include/linux/audit.h
> > > +++ b/include/linux/audit.h
> > > @@ -22,6 +22,13 @@ struct audit_sig_info {
> > >         char            ctx[];
> > >  };
> > >
> > > +struct audit_sig_info2 {
> > > +       uid_t           uid;
> > > +       pid_t           pid;
> > > +       u32             cid_len;
> > > +       char            data[];
> > > +};
> > > +
> > >  struct audit_buffer;
> > >  struct audit_context;
> > >  struct inode;
> > > @@ -105,6 +112,7 @@ struct audit_contobj {
> > >         u64                     id;
> > >         struct task_struct      *owner;
> > >         refcount_t              refcount;
> > > +       refcount_t              sigflag;
> > >         struct rcu_head         rcu;
> > >  };
> >
> > It seems like we need some protection in audit_set_contid() so that we
> > don't allow reuse of an audit container ID when "refcount == 0 &&
> > sigflag != 0", yes?
>
> We have it, see -ESHUTDOWN below.

That check in audit_set_contid() is checking ->refcount and not
->sigflag; ->sigflag is more important in this context, yes?

> > > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > > index fd98460c983f..a56ad77069b9 100644
> > > --- a/include/uapi/linux/audit.h
> > > +++ b/include/uapi/linux/audit.h
> > > @@ -72,6 +72,7 @@
> > >  #define AUDIT_SET_FEATURE      1018    /* Turn an audit feature on or off */
> > >  #define AUDIT_GET_FEATURE      1019    /* Get which features are enabled */
> > >  #define AUDIT_CONTAINER_OP     1020    /* Define the container id and info */
> > > +#define AUDIT_SIGNAL_INFO2     1021    /* Get info auditd signal sender */
> > >
> > >  #define AUDIT_FIRST_USER_MSG   1100    /* Userspace messages mostly uninteresting to kernel */
> > >  #define AUDIT_USER_AVC         1107    /* We filter this differently */
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index a09f8f661234..54dd2cb69402 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > @@ -126,6 +126,8 @@ struct auditd_connection {
> > >  kuid_t         audit_sig_uid = INVALID_UID;
> > >  pid_t          audit_sig_pid = -1;
> > >  u32            audit_sig_sid = 0;
> > > +static struct audit_contobj *audit_sig_cid;
> > > +static struct task_struct *audit_sig_atsk;
> >
> > This looks like a typo, or did you mean "atsk" for some reason?
>
> No, I meant atsk to refer specifically to the audit daemon task and not
> any other random one that is doing the signalling.  I can change it is
> there is a strong objection.

Esh, yeah, "atsk" looks too much like a typo ;)  At the very leask add
a 'd' in there, e.g. "adtsk", but something better than that would be
welcome.

> > > @@ -2532,6 +2620,11 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> > >                         if (cont->id == contid) {
> > >                                 /* task injection to existing container */
> > >                                 if (current == cont->owner) {
> > > +                                       if (!refcount_read(&cont->refcount)) {
> > > +                                               rc = -ESHUTDOWN;
> >
> > Reuse -ENOTUNIQ; I'm not overly excited about providing a lot of
> > detail here as these are global system objects.  If you must have a
> > different errno (and I would prefer you didn't), use something like
> > -EBUSY.
>
> I don't understand the issue of "global system objects" since the only
> time this error would be issued is if its own contid were being reused
> but it hadn't cleaned up its own references yet by either issuing an
> AUDIT_SIGNAL_INFO* request or the targetted audit daemon hadn't cleaned
> up yet.  EBUSY could be confused with already having spawned threads or
> children, and ENOTUNIQ could indicate that another orchestrator/engine
> had stolen its desired contid after we released it and wanted to reuse
> it.

All the more reason for ENOTUNIQ.  The point is that the audit
container ID is not available for use, and since the IDs are shared
across the entire system I think we are better off having some
ambiquity here with errnos.

> This gets me thinking about making reservations for preferred
> contids that are otherwise unavailable and making callbacks to indicate
> when they become available, but that seems undesirably complex right
> now.

That is definitely beyond the scope of this work, or rather *should*
be beyond the scope of this work.

-- 
paul moore
www.paul-moore.com
