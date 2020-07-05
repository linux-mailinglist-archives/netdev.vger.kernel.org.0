Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B013214D59
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 17:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgGEPKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 11:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbgGEPKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 11:10:12 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D35C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 08:10:12 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o18so35331206eje.7
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 08:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eesGq1spu54ggqtQAUupSk7Lp+Mlv7/qhf/cclrycog=;
        b=buieqKMIOy4fZ525LP8UwP8y3Z9QYIUD4ArYWpl7jDMWv49k1keyEzs1IHVvrKsEYR
         MzZpE8EX1wqsP6PbbPCr+sU4GzyycbuQyUtydPI/MmBPUIrVm6JjEFzG9ly4PWIi2mN7
         WmG8Hggbw6tRnUEcudBmseJeJ51lIx9t+kkVuF6Pzyt7eo6BlT/9an5LI8hAiEo6tkap
         q0Y6UULT9lpVeLIiuQQyu0N2gqKoEK3laR+r+53hmoCWqrpRKcw1BUOLInaINBH4vjvC
         dRsYhG3QJROH1n2/K5io3pRIsRICSobrWVvQwLQojZGKFrrO/Sb6uvvGY2JQT0YCV/u4
         +wIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eesGq1spu54ggqtQAUupSk7Lp+Mlv7/qhf/cclrycog=;
        b=YoT3h1je7wVC+iWKedjSrDihSkVXUQZUUyJfhC015qwDNYN9ow+qr1TopkckoxSpVH
         9NHGrf0FXKA1eks6OWFatf2t8E2trihhdqCcCgHLUoLAu55xZGpP/j4KJ6orxaVekZkh
         t8ZWeXYwiFNPUV3W/XAWi1mu+bJDHY8PEk6dDbu2wgVp68LYOl4Sy5A9DOzKHySuBC2d
         M+3cIdE6o8RU7NadwXofiqY1rKbyzyvYzRkmjlt71Fj3NA7a1Qr0dxwShlVgUEiqCM+G
         cBzklWVV2JXIl3Gz1pCahNWyhL+mdHM3tPENAb3rA7Fx8Gk422zTvHKxSCy1aE8cYO3+
         3RIA==
X-Gm-Message-State: AOAM530eCXqr+qidNRZxUbnBtTiQCNx/KEo4h3ONLMJG6zPfprkKUzG4
        eiifjBJs3hQ+qSARShiytSoP5mcyw+15iFCDq4TU
X-Google-Smtp-Source: ABdhPJy1E1Sw8Q5iWjt1KirrkFfpdSSt03aZwQ3uEENdmgYg7qspnLgZBziKDdWK7V2u1s7OqdWElZwK8p9Dttmc30Q=
X-Received: by 2002:a17:906:4757:: with SMTP id j23mr13638397ejs.431.1593961810932;
 Sun, 05 Jul 2020 08:10:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593198710.git.rgb@redhat.com> <e5a1ab6955c565743372b392a93f7d1ac98478a2.1593198710.git.rgb@redhat.com>
In-Reply-To: <e5a1ab6955c565743372b392a93f7d1ac98478a2.1593198710.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 5 Jul 2020 11:09:59 -0400
Message-ID: <CAHC9VhSgcOS79spSuFDMukw2TnLZfBh2p4BWGfoV_CGUS8b77w@mail.gmail.com>
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

On Sat, Jun 27, 2020 at 9:22 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Implement the proc fs write to set the audit container identifier of a
> process, emitting an AUDIT_CONTAINER_OP record to document the event.
>
> This is a write from the container orchestrator task to a proc entry of
> the form /proc/PID/audit_containerid where PID is the process ID of the
> newly created task that is to become the first task in a container, or
> an additional task added to a container.
>
> The write expects up to a u64 value (unset: 18446744073709551615).
>
> The writer must have capability CAP_AUDIT_CONTROL.
>
> This will produce a record such as this:
>   type=CONTAINER_OP msg=audit(2018-06-06 12:39:29.636:26949) : op=set opid=2209 contid=123456 old-contid=18446744073709551615
>
> The "op" field indicates an initial set.  The "opid" field is the
> object's PID, the process being "contained".  New and old audit
> container identifier values are given in the "contid" fields.
>
> It is not permitted to unset the audit container identifier.
> A child inherits its parent's audit container identifier.
>
> Store the audit container identifier in a refcounted kernel object that
> is added to the master list of audit container identifiers.  This will
> allow multiple container orchestrators/engines to work on the same
> machine without danger of inadvertantly re-using an existing identifier.
> It will also allow an orchestrator to inject a process into an existing
> container by checking if the original container owner is the one
> injecting the task.  A hash table list is used to optimize searches.
>
> Please see the github audit kernel issue for the main feature:
>   https://github.com/linux-audit/audit-kernel/issues/90
> Please see the github audit userspace issue for supporting additions:
>   https://github.com/linux-audit/audit-userspace/issues/51
> Please see the github audit testsuiite issue for the test case:
>   https://github.com/linux-audit/audit-testsuite/issues/64
> Please see the github audit wiki for the feature overview:
>   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> Acked-by: Steve Grubb <sgrubb@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  fs/proc/base.c             |  36 +++++++++++
>  include/linux/audit.h      |  33 ++++++++++
>  include/uapi/linux/audit.h |   2 +
>  kernel/audit.c             | 148 +++++++++++++++++++++++++++++++++++++++++++++
>  kernel/audit.h             |   8 +++
>  5 files changed, 227 insertions(+)

...

> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index c2150415f9df..2800d4f1a2a8 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -692,6 +715,16 @@ static inline bool audit_loginuid_set(struct task_struct *tsk)
>         return uid_valid(audit_get_loginuid(tsk));
>  }
>
> +static inline bool audit_contid_valid(u64 contid)
> +{
> +       return contid != AUDIT_CID_UNSET;
> +}
> +
> +static inline bool audit_contid_set(struct task_struct *tsk)
> +{
> +       return audit_contid_valid(audit_get_contid(tsk));
> +}

This is quasi-nitpicky, but it seems like audit_contid_valid() and
audit_contid_set() should be moved to kernel/audit.h if possible
(possibly even kernel/audit.c).  Maybe I'll see something later in the
patchset, but right now I'm struggling to think of why anyone outside
of audit would need to call these functions.

> diff --git a/kernel/audit.c b/kernel/audit.c
> index 5d8147a29291..6d387793f702 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -138,6 +138,13 @@ struct auditd_connection {
>
>  /* Hash for inode-based rules */
>  struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
> +/* Hash for contid object lists */
> +struct list_head audit_contid_hash[AUDIT_CONTID_BUCKETS];
> +/* Lock all additions and deletions to the contid hash lists, assignment
> + * of container objects to tasks.  There should be no need for
> + * interaction with tasklist_lock
> + */
> +static DEFINE_SPINLOCK(audit_contobj_list_lock);
>
>  static struct kmem_cache *audit_buffer_cache;
>
> @@ -212,6 +219,33 @@ void __init audit_task_init(void)
>                                              0, SLAB_PANIC, NULL);
>  }
>
> +/* rcu_read_lock must be held by caller unless new */
> +static struct audit_contobj *_audit_contobj_hold(struct audit_contobj *cont)
> +{
> +       if (cont)
> +               refcount_inc(&cont->refcount);
> +       return cont;
> +}
> +
> +static struct audit_contobj *_audit_contobj_get(struct task_struct *tsk)
> +{
> +       if (!tsk->audit)
> +               return NULL;
> +       return _audit_contobj_hold(tsk->audit->cont);
> +}
> +
> +/* rcu_read_lock must be held by caller */
> +static void _audit_contobj_put(struct audit_contobj *cont)
> +{
> +       if (!cont)
> +               return;
> +       if (refcount_dec_and_test(&cont->refcount)) {
> +               put_task_struct(cont->owner);
> +               list_del_rcu(&cont->list);

You should check your locking; I'm used to seeing exclusive locks
(e.g. the spinlock) around list adds/removes, it just reads/traversals
that can be done with just the RCU lock held.

> +               kfree_rcu(cont, rcu);
> +       }
> +}

Another nitpick, but it might be nice to have similar arguments to the
_get() and _put() functions, e.g. struct audit_contobj, but that is
some serious bikeshedding (basically rename _hold() to _get() and
rename _hold to audit_task_contid_hold() or similar).

>  /**
>   * audit_alloc - allocate an audit info block for a task
>   * @tsk: task
> @@ -232,6 +266,9 @@ int audit_alloc(struct task_struct *tsk)
>         }
>         info->loginuid = audit_get_loginuid(current);
>         info->sessionid = audit_get_sessionid(current);
> +       rcu_read_lock();
> +       info->cont = _audit_contobj_get(current);
> +       rcu_read_unlock();

The RCU locks aren't strictly necessary here, are they?  In fact I
suppose we could probably just replace the _get() call with a
refcount_set(1) just as we do in audit_set_contid(), yes?

>         tsk->audit = info;
>
>         ret = audit_alloc_syscall(tsk);
> @@ -246,6 +283,7 @@ int audit_alloc(struct task_struct *tsk)
>  struct audit_task_info init_struct_audit = {
>         .loginuid = INVALID_UID,
>         .sessionid = AUDIT_SID_UNSET,
> +       .cont = NULL,
>  #ifdef CONFIG_AUDITSYSCALL
>         .ctx = NULL,
>  #endif
> @@ -262,6 +300,9 @@ void audit_free(struct task_struct *tsk)
>         struct audit_task_info *info = tsk->audit;
>
>         audit_free_syscall(tsk);
> +       rcu_read_lock();
> +       _audit_contobj_put(tsk->audit->cont);
> +       rcu_read_unlock();
>         /* Freeing the audit_task_info struct must be performed after
>          * audit_log_exit() due to need for loginuid and sessionid.
>          */
> @@ -1709,6 +1750,9 @@ static int __init audit_init(void)
>         for (i = 0; i < AUDIT_INODE_BUCKETS; i++)
>                 INIT_LIST_HEAD(&audit_inode_hash[i]);
>
> +       for (i = 0; i < AUDIT_CONTID_BUCKETS; i++)
> +               INIT_LIST_HEAD(&audit_contid_hash[i]);
> +
>         mutex_init(&audit_cmd_mutex.lock);
>         audit_cmd_mutex.owner = NULL;
>
> @@ -2410,6 +2454,110 @@ int audit_signal_info(int sig, struct task_struct *t)
>         return audit_signal_info_syscall(t);
>  }
>
> +/*
> + * audit_set_contid - set current task's audit contid
> + * @task: target task
> + * @contid: contid value
> + *
> + * Returns 0 on success, -EPERM on permission failure.
> + *
> + * If the original container owner goes away, no task injection is
> + * possible to an existing container.
> + *
> + * Called (set) from fs/proc/base.c::proc_contid_write().
> + */
> +int audit_set_contid(struct task_struct *task, u64 contid)
> +{
> +       int rc = 0;
> +       struct audit_buffer *ab;
> +       struct audit_contobj *oldcont = NULL;
> +
> +       task_lock(task);
> +       /* Can't set if audit disabled */
> +       if (!task->audit) {
> +               task_unlock(task);
> +               return -ENOPROTOOPT;
> +       }

See my question/comment in patch 1/13; this check may not be needed or
it may need to be changed to something other than "!task->audit".

> +       read_lock(&tasklist_lock);
> +       /* Don't allow the contid to be unset */
> +       if (!audit_contid_valid(contid)) {
> +               rc = -EINVAL;
> +               goto unlock;
> +       }
> +       /* if we don't have caps, reject */
> +       if (!capable(CAP_AUDIT_CONTROL)) {
> +               rc = -EPERM;
> +               goto unlock;
> +       }
> +       /* if task has children or is not single-threaded, deny */
> +       if (!list_empty(&task->children) ||
> +           !(thread_group_leader(task) && thread_group_empty(task))) {
> +               rc = -EBUSY;
> +               goto unlock;
> +       }
> +       /* if contid is already set, deny */
> +       if (audit_contid_set(task))
> +               rc = -EEXIST;
> +unlock:

Can we move the "unlock" target to the end of the function where it
just handles the unlocking and returns an error, including the
AUDIT_CONTAINER_OP record if necessary?  From what I can see we only
jump to "unlock" in case of error where we are not going to set the
audit container ID, yet the "unlock" target is placed in a misleading
location in the middle of the function.  It may be that everything
works correctly, but I would argue this is a bad practice that
increases the likelihood of buggy behavior in future code changes.

If you can't find way to arrange the code nicely, just duplicate the
"tasklist_lock" unlock operation in the error handlers before jumping
down to the end of the function.  It isn't perfect, but I believe it
will be a lot less fragile than the current approach.


> +       read_unlock(&tasklist_lock);
> +       rcu_read_lock();
> +       oldcont = _audit_contobj_get(task);
> +       if (!rc) {
> +               struct audit_contobj *cont = NULL, *newcont = NULL;
> +               int h = audit_hash_contid(contid);
> +
> +               spin_lock(&audit_contobj_list_lock);
> +               list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
> +                       if (cont->id == contid) {
> +                               /* task injection to existing container */
> +                               if (current == cont->owner) {
> +                                       _audit_contobj_hold(cont);
> +                                       newcont = cont;
> +                               } else {
> +                                       rc = -ENOTUNIQ;
> +                                       spin_unlock(&audit_contobj_list_lock);
> +                                       goto conterror;
> +                               }
> +                               break;
> +                       }
> +               if (!newcont) {
> +                       newcont = kmalloc(sizeof(*newcont), GFP_ATOMIC);
> +                       if (newcont) {
> +                               INIT_LIST_HEAD(&newcont->list);
> +                               newcont->id = contid;
> +                               newcont->owner = get_task_struct(current);
> +                               refcount_set(&newcont->refcount, 1);
> +                               list_add_rcu(&newcont->list,
> +                                            &audit_contid_hash[h]);
> +                       } else {
> +                               rc = -ENOMEM;
> +                               spin_unlock(&audit_contobj_list_lock);
> +                               goto conterror;
> +                       }
> +               }
> +               spin_unlock(&audit_contobj_list_lock);
> +               task->audit->cont = newcont;
> +               _audit_contobj_put(oldcont);
> +       }
> +conterror:
> +       task_unlock(task);
> +
> +       if (!audit_enabled)
> +               return rc;
> +
> +       ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_OP);
> +       if (!ab)
> +               return rc;
> +
> +       audit_log_format(ab,
> +                        "op=set opid=%d contid=%llu old-contid=%llu",
> +                        task_tgid_nr(task), contid, oldcont ? oldcont->id : -1);
> +       _audit_contobj_put(oldcont);
> +       rcu_read_unlock();
> +       audit_log_end(ab);
> +       return rc;
> +}

--
paul moore
www.paul-moore.com
