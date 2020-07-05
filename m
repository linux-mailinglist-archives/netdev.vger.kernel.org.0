Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77287214D83
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 17:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgGEPLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 11:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728029AbgGEPLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 11:11:45 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2678AC08C5DE
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 08:11:45 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id dr13so39776713ejc.3
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 08:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cTmMCRlwM4HQ8oiNse3u7FDYUgevd5poSx17KumY0vY=;
        b=amuEfY6QBDRlEub7AjLbAs3MFoHaZYkgMZoZqni63pTZzRlQH5ZvcCcZqH8Ix5qe2o
         7Sa0goKImYNSmoSxgLc+eYU8KTS1doy1F++Ra5Q2PTRuY5JybgSmnLMI4qeBFJiQ+Ach
         41hAjVX2Lq8fa/Jn+/3lNHk+41i6jTmv4HQGn2e/YPRVjLIbVW1Am7j+4m6XxnELPA//
         Rly5UI+W1g0Fab6yN3LaHKnX4UM5IKMGbcXEn97Ignxj75clEffWqJNucyOExJxI8Eff
         FKJxKLJG+5zsn0jZWuvOTOYMcEZ/zIx6IIWAm6ZYgvJstpi0fMgdBgVQ4Gj00kDqzfg7
         DuAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cTmMCRlwM4HQ8oiNse3u7FDYUgevd5poSx17KumY0vY=;
        b=JKT0Nj68pGiiip/lmqjZenzdSpbcfy93uUKxDn8d/G0cUcdRJS/yvEWH1a7lJekzLH
         jXMNeh5uqesWxJ1ZHFl4gj47n41+taLsxe2gRSWI2FkdHO2AwKdEAu+B4yHdnOGNRMGP
         SmYWq8uDfGNamGAk1ipBShcEmtWOcPvRSspqrTYBwXw7sDO6qjGiWLxVJZptmFcvGO9y
         0qpWPTuVqA3QPVqY7x9unXwkqAfjdGRI/qLdnbhCp3zxahciDRo3inQJpVtS5puRuEDo
         HODNDkKnios5o/IaKuCSWZUSez3qo0hf1PvUsFEaqhMNkaqCk2NPo0gKH2/LbjvbqHCy
         5SyQ==
X-Gm-Message-State: AOAM530JgW61w8fuFcAx1KlOPcSrGm5ToZY3UfMCqrA9sC7ZlPJm1agB
        508Eo3MjoNu2KbT3zznbWNt/RsddIgP3AsM9CNNk
X-Google-Smtp-Source: ABdhPJzbzoqFDznCDtmzV+i8Jle6Pdv/RYrhTG0ZL3ik10sa7kBVeBjSG5XnXZVxMrvQrksvZHxq1jdy/wlvs+PxtLI=
X-Received: by 2002:a17:906:c1d8:: with SMTP id bw24mr30265666ejb.91.1593961903721;
 Sun, 05 Jul 2020 08:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593198710.git.rgb@redhat.com> <01229b93733d9baf6ac9bb0cc243eeb08ad579cd.1593198710.git.rgb@redhat.com>
In-Reply-To: <01229b93733d9baf6ac9bb0cc243eeb08ad579cd.1593198710.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 5 Jul 2020 11:11:32 -0400
Message-ID: <CAHC9VhT6cLxxws_pYWcL=mWe786xPoTTFfPZ1=P4hx4V3nytXA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V9 11/13] audit: contid check descendancy and nesting
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

On Sat, Jun 27, 2020 at 9:23 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Require the target task to be a descendant of the container
> orchestrator/engine.
>
> You would only change the audit container ID from one set or inherited
> value to another if you were nesting containers.
>
> If changing the contid, the container orchestrator/engine must be a
> descendant and not same orchestrator as the one that set it so it is not
> possible to change the contid of another orchestrator's container.
>
> Since the task_is_descendant() function is used in YAMA and in audit,
> remove the duplication and pull the function into kernel/core/sched.c
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/sched.h    |  3 +++
>  kernel/audit.c           | 23 +++++++++++++++++++++--
>  kernel/sched/core.c      | 33 +++++++++++++++++++++++++++++++++
>  security/yama/yama_lsm.c | 33 ---------------------------------
>  4 files changed, 57 insertions(+), 35 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 2213ac670386..06938d0b9e0c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2047,4 +2047,7 @@ static inline void rseq_syscall(struct pt_regs *regs)
>
>  const struct cpumask *sched_trace_rd_span(struct root_domain *rd);
>
> +extern int task_is_descendant(struct task_struct *parent,
> +                             struct task_struct *child);
> +
>  #endif
> diff --git a/kernel/audit.c b/kernel/audit.c
> index a862721dfd9b..efa65ec01239 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -2713,6 +2713,20 @@ int audit_signal_info(int sig, struct task_struct *t)
>         return audit_signal_info_syscall(t);
>  }
>
> +static bool audit_contid_isnesting(struct task_struct *tsk)
> +{
> +       bool isowner = false;
> +       bool ownerisparent = false;
> +
> +       rcu_read_lock();
> +       if (tsk->audit && tsk->audit->cont) {
> +               isowner = current == tsk->audit->cont->owner;
> +               ownerisparent = task_is_descendant(tsk->audit->cont->owner, current);

I want to make sure I'm understanding this correctly and I keep
mentally tripping over something: it seems like for a given audit
container ID a task is either the owner or a descendent, there is no
third state, is that correct?

Assuming that is true, can the descendent check simply be a negative
owner check given they both have the same audit container ID?

> +       }
> +       rcu_read_unlock();
> +       return !isowner && ownerisparent;
> +}
> +
>  /*
>   * audit_set_contid - set current task's audit contid
>   * @task: target task
> @@ -2755,8 +2769,13 @@ int audit_set_contid(struct task_struct *task, u64 contid)
>                 rc = -EBUSY;
>                 goto unlock;
>         }
> -       /* if contid is already set, deny */
> -       if (audit_contid_set(task))
> +       /* if task is not descendant, block */
> +       if (task == current || !task_is_descendant(current, task)) {

I'm also still fuzzy on why we can't let a task set it's own audit
container ID, assuming it meets all the criteria established in patch
2/13.  It somewhat made sense when you were tracking inherited vs
explicitly set audit container IDs, but that doesn't appear to be the
case so far in this patchset, yes?

> +               rc = -EXDEV;

I'm fairly confident we had a discussion about not using all these
different error codes, but that may be a moot point given my next
comment.

> +               goto unlock;
> +       }
> +       /* only allow contid setting again if nesting */
> +       if (audit_contid_set(task) && !audit_contid_isnesting(task))
>                 rc = -EEXIST;

It seems like what we need in audit_set_contid() is a check to ensure
that the task being modified is only modified by the owner of the
audit container ID, yes?  If so, I would think we could do this quite
easily with the following, or similar logic, (NOTE: assumes both
current and tsk are properly setup):

  if ((current->audit->cont != tsk->audit->cont) ||
(current->audit->cont->owner != current))
    return -EACCESS;

This is somewhat independent of the above issue, but we may also want
to add to the capability check.  Patch 2 adds a
"capable(CAP_AUDIT_CONTROL)" which is good, but perhaps we also need a
"ns_capable(CAP_AUDIT_CONTROL)" to allow a given audit container ID
orchestrator/owner the ability to control which of it's descendants
can change their audit container ID, for example:

  if (!capable(CAP_AUDIT_CONTROL) ||
      !ns_capable(current->nsproxy->user_ns, CAP_AUDIT_CONTROL))
    return -EPERM;

--
paul moore
www.paul-moore.com
