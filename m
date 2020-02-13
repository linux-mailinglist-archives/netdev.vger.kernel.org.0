Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF1915CDAD
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 22:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgBMV7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 16:59:12 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35875 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbgBMV7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 16:59:11 -0500
Received: by mail-ed1-f65.google.com with SMTP id j17so8737522edp.3
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 13:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dR96Ls041PGles0WWTgdxsFA4gswjPBr2dNrlkBSuNQ=;
        b=rRCxR57CMKJEJvKUsBRBaCGNlEl5GeneJok3J1oqVCL9i03XHBTkzBKLVXlCX80abR
         waS3e2st7hqr5AUSVywbiuHu/XcoJmFgOcPcq/NRWkATB05enSVqkl80JRFrqFA7+TzZ
         VP60OmlNYIOOnNo1pTgwF6ZUTJ9B+xYWfKepxQsuTcSQlH2ADq4oxtRLbeGf/SyLe7Z5
         YYEdGrtOkXicpYXO7tS/kxFgOlUN19E6+SiiE6iPdGEHXwVtgWm62Jeai1NFqHNb4FeV
         UgDE19W1OOEMKwc3kfP3rCvuUG9qKToWRYzTN/pkKxHZ/jtbJNqySZOSNxS3RDDHFH+p
         8DDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dR96Ls041PGles0WWTgdxsFA4gswjPBr2dNrlkBSuNQ=;
        b=h1Gk1HxeLsQYdJ2ORhUIKcIZBG2zjR3ouIGBrXtliwacag2q3jb9oFzc+TecZDqHDo
         aECcSmFLygyWSKBvUUzofI2UGIE6dZRxbFrisHOFWjJ5GjCCAuRWv1W+B1yVYBqEmp5d
         2rN9P9nmxTyuGxW0Z5yyuouOkWpwXp94V65jZ+1UpjapaiFugb1SEG0p1GAiMlOY7EYQ
         ELHcvNBq9a8oIPF0cTyBzMqi7RraRIwGQ+R19/43yZZIl4mvei9d3vqn1Nhvh6+M+V2l
         f4AY7DN0l75gVWGRxHkuJozElHZ6qi230ZiNBR7EhCejk0ApCYIfWa9ObXOmqlgvahye
         fy7Q==
X-Gm-Message-State: APjAAAUcCOvuYr4TckoiAcX8SwT/oY5o/I6s+s+HaiAgUaIS4jFxqbiP
        Fawtin5eQMC+bgbBUN544l+DNKs3KScVkEDk0ypO
X-Google-Smtp-Source: APXvYqwJlC4P1+vTqQ7auzlqHDyoqi32fnbka+h4eFFK4GnrJSQwBwYPSRpLTAitL/ZfvrnPR1P7gUIIEptxDZxCT9E=
X-Received: by 2002:a50:a7a5:: with SMTP id i34mr17484612edc.128.1581631147637;
 Thu, 13 Feb 2020 13:59:07 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <5941671b6b6b5de28ab2cc80e72f288cf83291d5.1577736799.git.rgb@redhat.com>
 <CAHC9VhQYXQp+C0EHwLuW50yUenfH4KF1xKQdS=bn_OzHfnFmmg@mail.gmail.com>
 <20200205003930.2efpm4tvrisgmj4t@madcap2.tricolour.ca> <CAHC9VhSsfBbfYmqLoR=QBgF5_VwbA8Dqqz97MjqwwJ6Jq6fHwA@mail.gmail.com>
 <20200206125135.u4dmybkmvxfgui2b@madcap2.tricolour.ca>
In-Reply-To: <20200206125135.u4dmybkmvxfgui2b@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 13 Feb 2020 16:58:56 -0500
Message-ID: <CAHC9VhT8RsFtmqD22p_NxJaqoAg+do9mX45Luw9fEkr+nQjvxg@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 16/16] audit: add capcontid to set contid
 outside init_user_ns
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 6, 2020 at 7:52 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-02-05 17:56, Paul Moore wrote:
> > On Tue, Feb 4, 2020 at 7:39 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-01-22 16:29, Paul Moore wrote:
> > > > On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > >
> > > > > Provide a mechanism similar to CAP_AUDIT_CONTROL to explicitly give a
> > > > > process in a non-init user namespace the capability to set audit
> > > > > container identifiers.
> > > > >
> > > > > Provide /proc/$PID/audit_capcontid interface to capcontid.
> > > > > Valid values are: 1==enabled, 0==disabled
> > > >
> > > > It would be good to be more explicit about "enabled" and "disabled" in
> > > > the commit description.  For example, which setting allows the target
> > > > task to set audit container IDs of it's children processes?
> > >
> > > Ok...
> > >
> > > > > Report this action in message type AUDIT_SET_CAPCONTID 1022 with fields
> > > > > opid= capcontid= old-capcontid=
> > > > >
> > > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > > ---
> > > > >  fs/proc/base.c             | 55 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > >  include/linux/audit.h      | 14 ++++++++++++
> > > > >  include/uapi/linux/audit.h |  1 +
> > > > >  kernel/audit.c             | 35 +++++++++++++++++++++++++++++
> > > > >  4 files changed, 105 insertions(+)
> >
> > ...
> >
> > > > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > > > index 1287f0b63757..1c22dd084ae8 100644
> > > > > --- a/kernel/audit.c
> > > > > +++ b/kernel/audit.c
> > > > > @@ -2698,6 +2698,41 @@ static bool audit_contid_isowner(struct task_struct *tsk)
> > > > >         return false;
> > > > >  }
> > > > >
> > > > > +int audit_set_capcontid(struct task_struct *task, u32 enable)
> > > > > +{
> > > > > +       u32 oldcapcontid;
> > > > > +       int rc = 0;
> > > > > +       struct audit_buffer *ab;
> > > > > +
> > > > > +       if (!task->audit)
> > > > > +               return -ENOPROTOOPT;
> > > > > +       oldcapcontid = audit_get_capcontid(task);
> > > > > +       /* if task is not descendant, block */
> > > > > +       if (task == current)
> > > > > +               rc = -EBADSLT;
> > > > > +       else if (!task_is_descendant(current, task))
> > > > > +               rc = -EXDEV;
> > > >
> > > > See my previous comments about error code sanity.
> > >
> > > I'll go with EXDEV.
> > >
> > > > > +       else if (current_user_ns() == &init_user_ns) {
> > > > > +               if (!capable(CAP_AUDIT_CONTROL) && !audit_get_capcontid(current))
> > > > > +                       rc = -EPERM;
> > > >
> > > > I think we just want to use ns_capable() in the context of the current
> > > > userns to check CAP_AUDIT_CONTROL, yes?  Something like this ...
> > >
> > > I thought we had firmly established in previous discussion that
> > > CAP_AUDIT_CONTROL in anything other than init_user_ns was completely irrelevant
> > > and untrustable.
> >
> > In the case of a container with multiple users, and multiple
> > applications, one being a nested orchestrator, it seems relevant to
> > allow that container to control which of it's processes are able to
> > exercise CAP_AUDIT_CONTROL.  Granted, we still want to control it
> > within the overall host, e.g. the container in question must be
> > allowed to run a nested orchestrator, but allowing the container
> > itself to provide it's own granularity seems like the right thing to
> > do.
>
> Looking back to discussion on the v6 patch 2/10 (2019-05-30 15:29 Paul
> Moore[1], 2019-07-08 14:05 RGB[2]) , it occurs to me that the
> ns_capable(CAP_AUDIT_CONTROL) application was dangerous since there was
> no parental accountability in storage or reporting.  Now that is in
> place, it does seem a bit more reasonable to allow it, but I'm still not
> clear on why we would want both mechanisms now.  I don't understand what
> the last line in that email meant: "We would probably still want a
> ns_capable(CAP_AUDIT_CONTROL) restriction in this case."  Allow
> ns_capable(CAP_AUDIT_CONTROL) to govern these actions, or restrict
> ns_capable(CAP_AUDIT_CONTROL) from being used to govern these actions?
>
> If an unprivileged user has been given capcontid to be able run their
> own container orchestrator/engine and spawns a user namespace with
> CAP_AUDIT_CONTROL, what matters is capcontid, and not CAP_AUDIT_CONTROL.
> I could see needing CAP_AUDIT_CONTROL *in addition* to capcontid to give
> it finer grained control, but since capcontid would have to be given to
> each process explicitly anways, I don't see the point.
>
> If that unprivileged user had not been given capcontid,
> giving itself or one of its descendants CAP_AUDIT_CONTROL should not let
> it jump into the game all of a sudden unless the now chained audit
> container identifiers are deemed accountable enough.  And then now we
> need those hard limits on container depth and network namespace
> container membership.

Perhaps I'm not correctly understanding what you are trying to do with
this patchset, but my current understanding is that you are trying to
use capcontid to control which child audit container IDs (ACIDs) are
allowed to manage their own ACIDs.  Further, I believe that the
capcontid setting operates at a per-ACID level, meaning there is no
provision for the associated container to further restrict that
ability, i.e. no access control granularity below the ACID level.  My
thinking is that ns_capable(CAP_AUDIT_CONTROL) could be used within an
ACID to increase the granularity of the access controls so that only
privileged processes running inside the ACID would be able to manage
the ACIDs.  Does that make sense?

-- 
paul moore
www.paul-moore.com
