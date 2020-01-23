Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36E6147354
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 22:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgAWVrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 16:47:52 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45534 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728939AbgAWVrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 16:47:51 -0500
Received: by mail-lj1-f193.google.com with SMTP id j26so5410936ljc.12
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 13:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YhdQmzKcBNrdoLI54N+iRiz95hS2N5V9TEIVZsNwGUQ=;
        b=zvNKYSbEyhPQ3NLDHr7JObqj/IOu7umr2jteRknL+jllPcUiisljvVVxsdw8gofqQK
         djFVBpfpXx33ps/9HFrET+9LsNNf6IOgVO5Ct5mt8yuTvADQoze2He42TBidV7Za/Iwq
         VBXPOWZrBBAZzXzwaR382mYyF5nCrbeLgZNckklHJsSzIlPecfo+hjxfKH6pbXlHSAPF
         53CdBCMcn+McG0AixIwVLmEANV4WY5a0Wb770ITfd/hdieQoZvbliSVbkfrt7UVpM15K
         LlmSSoir7uAu5IXp4zxnY6Hor3F2/BfeHrW0PFBhSJxd0bVbH0FXqfBUKkdNP4XX5tOU
         OCTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YhdQmzKcBNrdoLI54N+iRiz95hS2N5V9TEIVZsNwGUQ=;
        b=NUudd+FJZ0X7pGo9nR/dLsLc69RuotMZiy6NVXg3drhPT+qgWzpd1D6f5ol1XLwN2b
         bdMTbJg5KRIixOiYeWH4u0OoesxOMnVH5e8Yo/HFNYkp//pTsKyiz54L7r/TVVyr/JQt
         UTdv9Ej4k3T3zfdPRyOs1NesUqOJJnJW8qFXm0AAncIZ6apiO2t0Ji26AQAt2Kq9aEiY
         YmqwvMMk5pICDXUL3oVPxYW6JmbbJsv8gmwAivpSWDtnXg8rkbgITM4qOGFwzuXVEnSh
         0A8GkjdpmcEaFaJRO1IN4A12v5ZzKt5d9KSZuRbvb1SN0sHsC6lZmrMITXaJy/tXlsbu
         +SsA==
X-Gm-Message-State: APjAAAWJXLbhEJtXZm5zFBM2LqsOsfUKCAg6+/a7LHqn7xUnsOulfBNr
        n5HE4zQf3a3EyssbTftGw3yu/za3+SjAqKkR9jAu
X-Google-Smtp-Source: APXvYqztFa7vAl8EvjnBAbXT/Sxp3LD4cPaFKrc0PnFsn1Bc8BoDdWYI9cS1dXL0IglZHlYX5t78xA0hNpmBE5LAkJ0=
X-Received: by 2002:a05:651c:204f:: with SMTP id t15mr251303ljo.240.1579816069696;
 Thu, 23 Jan 2020 13:47:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <cfbb80a08fc770dd0dcf6dac6ff307a80d877c3f.1577736799.git.rgb@redhat.com>
 <CAHC9VhT1+mx_tVzyXD=UBqagqYgAFjZ=X1A6oBiMvjVCn8=V-w@mail.gmail.com> <20200123210240.sq64tptjm3ds7xss@madcap2.tricolour.ca>
In-Reply-To: <20200123210240.sq64tptjm3ds7xss@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 23 Jan 2020 16:47:38 -0500
Message-ID: <CAHC9VhQtAfW-+sK3Gb6y=jPYOkyXnopO94k+u_6UKAAaACg44Q@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 12/16] audit: contid check descendancy and nesting
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

On Thu, Jan 23, 2020 at 4:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-01-22 16:29, Paul Moore wrote:
> > On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > Require the target task to be a descendant of the container
> > > orchestrator/engine.
> > >
> > > You would only change the audit container ID from one set or inherited
> > > value to another if you were nesting containers.
> > >
> > > If changing the contid, the container orchestrator/engine must be a
> > > descendant and not same orchestrator as the one that set it so it is not
> > > possible to change the contid of another orchestrator's container.
> > >
> > > Since the task_is_descendant() function is used in YAMA and in audit,
> > > remove the duplication and pull the function into kernel/core/sched.c
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  include/linux/sched.h    |  3 +++
> > >  kernel/audit.c           | 44 ++++++++++++++++++++++++++++++++++++--------
> > >  kernel/sched/core.c      | 33 +++++++++++++++++++++++++++++++++
> > >  security/yama/yama_lsm.c | 33 ---------------------------------
> > >  4 files changed, 72 insertions(+), 41 deletions(-)
> >
> > ...
> >
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index f7a8d3288ca0..ef8e07524c46 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > @@ -2603,22 +2610,43 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> > >         oldcontid = audit_get_contid(task);
> > >         read_lock(&tasklist_lock);
> > >         /* Don't allow the contid to be unset */
> > > -       if (!audit_contid_valid(contid))
> > > +       if (!audit_contid_valid(contid)) {
> > >                 rc = -EINVAL;
> > > +               goto unlock;
> > > +       }
> > >         /* Don't allow the contid to be set to the same value again */
> > > -       else if (contid == oldcontid) {
> > > +       if (contid == oldcontid) {
> > >                 rc = -EADDRINUSE;
> > > +               goto unlock;
> > > +       }
> > >         /* if we don't have caps, reject */
> > > -       else if (!capable(CAP_AUDIT_CONTROL))
> > > +       if (!capable(CAP_AUDIT_CONTROL)) {
> > >                 rc = -EPERM;
> > > -       /* if task has children or is not single-threaded, deny */
> > > -       else if (!list_empty(&task->children))
> > > +               goto unlock;
> > > +       }
> > > +       /* if task has children, deny */
> > > +       if (!list_empty(&task->children)) {
> > >                 rc = -EBUSY;
> > > -       else if (!(thread_group_leader(task) && thread_group_empty(task)))
> > > +               goto unlock;
> > > +       }
> > > +       /* if task is not single-threaded, deny */
> > > +       if (!(thread_group_leader(task) && thread_group_empty(task))) {
> > >                 rc = -EALREADY;
> > > -       /* if contid is already set, deny */
> > > -       else if (audit_contid_set(task))
> > > +               goto unlock;
> > > +       }
> >
> > It seems like the if/else-if conversion above should be part of an
> > earlier patchset.
>
> I had considered that, but it wasn't obvious where that conversion
> should happen since it wasn't necessary earlier and is now.  I can move
> it earlier if you feel strongly about it.

Not particularly.

-- 
paul moore
www.paul-moore.com
