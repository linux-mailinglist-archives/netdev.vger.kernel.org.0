Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39ADFD3659
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfJKAkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:40:19 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41699 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbfJKAkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:40:17 -0400
Received: by mail-lf1-f65.google.com with SMTP id r2so5721113lfn.8
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WruOl9m8rjj6B/eISV7ZrAuuDk2P1Av0bY+CVqaL58Q=;
        b=V4Xxbr0U3eWT6U16YQ3PdgJXfFSijS5xRPN5nuMN6zDdNiLlA8dHWQaXw0Yzr3J0GG
         jRh9YIrZ+DWce+KF5cgww4hLWK47rxojTThwR/zgSvMLAFygAJZkWRqj2iX38L3KwI8a
         8I1WdUsdx/j6CuBhFGYvw5LMxUP/iOf/nOVB405Wnz4NBTkrngUoYzEwv5G2EC8sUbzW
         8umuXVw1jEwxdYwwQY1tM0o6fLNk5h+gKKD1b6UGgzKcpmc1HiwzfF7qiFKwl/7qqXWI
         JgymE+NEGRdwv29QW/erS6VgnlAN5h0RSuumHCtPnB4wHvJox9JrE8jqfIDTC0rUqT73
         QlDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WruOl9m8rjj6B/eISV7ZrAuuDk2P1Av0bY+CVqaL58Q=;
        b=Og9LzJ67tEzypolLwNn6rN8SwvGXOVbkcYDUpp5Ei+qQHf6TxaczSfl0vDfzNCLXak
         VT1vAV7FdCOLmyiSjkbW6iJQrujdCSLX1robf6EKaeJj2S/4HKRVczclXv5rmu16ONAk
         j7swegcsu/MhFoDeWE9PXP0mqlo2pPPpBQKP/8UkBkzXvPZlZl967TrMJ7T8bDUO8AEf
         HK7FBm0SrKBz7Stws4f9q11LrWS4m+fm/sLjHLNYp6FfQLN/iUUwlNFdEceNW9xs9bKL
         tLxovm986LoE+z2sDUQ6aJLnNWZqSQiizUiEGX3RkM3p2NCWuEQRuYg0wiF0CsLlBN9r
         rVQA==
X-Gm-Message-State: APjAAAVHH7sWpqmpXsRPydgwOJ0fqMc51I+9uA1fd49E9uhHjjI1wIPZ
        50LKFbG8M5Mj7H+IwysePPLVkHBhhOf4RH19qR1Q
X-Google-Smtp-Source: APXvYqx4281+tmbi3ZlPDrW+JB0898oZIUJra8F7IZWiEF8jcqHh8UQR+dgmOr5eN7CEnXk9zl63wAZJvDvH7MBwJLo=
X-Received: by 2002:ac2:51b6:: with SMTP id f22mr7273869lfk.175.1570754414142;
 Thu, 10 Oct 2019 17:40:14 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <16abf1b2aafeb5f1b8dae20b9a4836e54f959ca5.1568834524.git.rgb@redhat.com>
In-Reply-To: <16abf1b2aafeb5f1b8dae20b9a4836e54f959ca5.1568834524.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 10 Oct 2019 20:40:03 -0400
Message-ID: <CAHC9VhSRmn46DcazH4Q35vOSxVoEu8PsX79aurkHkFymRoMwag@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 14/21] audit: contid check descendancy and nesting
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

On Wed, Sep 18, 2019 at 9:26 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> ?fixup! audit: convert to contid list to check for orch/engine ownership

?

> Require the target task to be a descendant of the container
> orchestrator/engine.
>
> You would only change the audit container ID from one set or inherited
> value to another if you were nesting containers.
>
> If changing the contid, the container orchestrator/engine must be a
> descendant and not same orchestrator as the one that set it so it is not
> possible to change the contid of another orchestrator's container.

Did you mean to say that the container orchestrator must be an
ancestor of the target, and the same orchestrator as the one that set
the target process' audit container ID?

Or maybe I'm missing something about what you are trying to do?

> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/audit.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 62 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 9ce7a1ec7a92..69fe1e9af7cb 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -2560,6 +2560,39 @@ static struct task_struct *audit_cont_owner(struct task_struct *tsk)
>  }
>
>  /*
> + * task_is_descendant - walk up a process family tree looking for a match
> + * @parent: the process to compare against while walking up from child
> + * @child: the process to start from while looking upwards for parent
> + *
> + * Returns 1 if child is a descendant of parent, 0 if not.
> + */
> +static int task_is_descendant(struct task_struct *parent,
> +                             struct task_struct *child)
> +{
> +       int rc = 0;
> +       struct task_struct *walker = child;
> +
> +       if (!parent || !child)
> +               return 0;
> +
> +       rcu_read_lock();
> +       if (!thread_group_leader(parent))
> +               parent = rcu_dereference(parent->group_leader);
> +       while (walker->pid > 0) {
> +               if (!thread_group_leader(walker))
> +                       walker = rcu_dereference(walker->group_leader);
> +               if (walker == parent) {
> +                       rc = 1;
> +                       break;
> +               }
> +               walker = rcu_dereference(walker->real_parent);
> +       }
> +       rcu_read_unlock();
> +
> +       return rc;
> +}
> +
> +/*
>   * audit_set_contid - set current task's audit contid
>   * @task: target task
>   * @contid: contid value
> @@ -2587,22 +2620,43 @@ int audit_set_contid(struct task_struct *task, u64 contid)
>         oldcontid = audit_get_contid(task);
>         read_lock(&tasklist_lock);
>         /* Don't allow the contid to be unset */
> -       if (!audit_contid_valid(contid))
> +       if (!audit_contid_valid(contid)) {
>                 rc = -EINVAL;
> +               goto unlock;
> +       }
>         /* Don't allow the contid to be set to the same value again */
> -       else if (contid == oldcontid) {
> +       if (contid == oldcontid) {
>                 rc = -EADDRINUSE;
> +               goto unlock;
> +       }
>         /* if we don't have caps, reject */
> -       else if (!capable(CAP_AUDIT_CONTROL))
> +       if (!capable(CAP_AUDIT_CONTROL)) {
>                 rc = -EPERM;
> -       /* if task has children or is not single-threaded, deny */
> -       else if (!list_empty(&task->children))
> +               goto unlock;
> +       }
> +       /* if task has children, deny */
> +       if (!list_empty(&task->children)) {
>                 rc = -EBUSY;
> -       else if (!(thread_group_leader(task) && thread_group_empty(task)))
> +               goto unlock;
> +       }
> +       /* if task is not single-threaded, deny */
> +       if (!(thread_group_leader(task) && thread_group_empty(task))) {
>                 rc = -EALREADY;
> -       /* if contid is already set, deny */
> -       else if (audit_contid_set(task))
> +               goto unlock;
> +       }
> +       /* if task is not descendant, block */
> +       if (task == current) {
> +               rc = -EBADSLT;
> +               goto unlock;
> +       }
> +       if (!task_is_descendant(current, task)) {
> +               rc = -EXDEV;
> +               goto unlock;
> +       }
> +       /* only allow contid setting again if nesting */
> +       if (audit_contid_set(task) && current == audit_cont_owner(task))
>                 rc = -ECHILD;
> +unlock:
>         read_unlock(&tasklist_lock);
>         if (!rc) {
>                 struct audit_cont *oldcont = audit_cont(task);

--
paul moore
www.paul-moore.com
