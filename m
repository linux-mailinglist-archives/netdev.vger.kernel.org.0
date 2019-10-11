Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56EE6D362E
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfJKAiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:38:51 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33725 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfJKAiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:38:50 -0400
Received: by mail-lf1-f65.google.com with SMTP id y127so5748922lfc.0
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8R/eBx6NvZFxWNxVIYlfJkIW02oJ5zpbsmf6mm7nZ9s=;
        b=PVIaSCVsKoCSioNO1daQB3ogqBQmVD3fhqQo4gIUtxKKoYuLTwFMbHK9RhP3eWO8EI
         Sr27B+bTJnYiu57nb0HzGL8v5YSu8KyEgsQePndcV6s1X1xKoEpg2sEy65gP3Dzwrkmf
         8lMEoOvvlOjP0p1jwOektA10DSHG+MEbsWZHevWEGU3+YsaFOxOmztILHH7KtAMVF137
         7d0i2/TQUYZ4JzR8GQ3eYX3C/MfCuJm/SqpW2Mw2wFvfj9OtlsoHTvv49hgTnDyQZRwq
         2KmtuIKbReoDsybnK+ymQGg8Zv7msFnsJkQRrurtEeLYeftHey/w7tDkvx3OBHDTLubQ
         lgFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8R/eBx6NvZFxWNxVIYlfJkIW02oJ5zpbsmf6mm7nZ9s=;
        b=rPQPXZqhgOJac1NgJjz1VXv463eqf8ZnHkvy1A/54rh+xs1CIVuLQ/FpazLAea6jsW
         XI+AeO9KaGCLsQrUnJDZ+tyQvCZDYPsgFrO4dglw5WARYvni7/DHEaslMpT62O6gJG61
         60vq/uIEXYCHJ0aYx70WfCWJaZjN8RqG/+hvGOKBdlHwzeFGpEF6hqyla3qRkumNZXpE
         O2K3cO7+jTodnRFpKZbUfw1htqJuRpG17IBP9bY5qPrVofgZzCersLBCUNyuUzCrLpH8
         1Q7VDDQ8ZxuLPKq+KzctNaED9EwMaVH3J0IXJsAs39HC8WvMeFxthp6v1AfE+DEjFHIG
         dG6A==
X-Gm-Message-State: APjAAAVxH1B0hb0sayZoW8jT/MzssnP4nnx6emmoN8X8yymch/1fqZ7z
        YTR2+b3dJkXyDw6Kufxv8ehJLbwZy5vaP3RvRe1a
X-Google-Smtp-Source: APXvYqw0Yt32wE7spq2vSD4AfWdE6Sx9fE0xUf8vD/PbZQdv7a66StbcusgQqkSXaDuSAxoGBdQc3ElK5F9N13YICOc=
X-Received: by 2002:ac2:51b6:: with SMTP id f22mr7271786lfk.175.1570754325948;
 Thu, 10 Oct 2019 17:38:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <6fb4e270bfafef3d0477a06b0365fdcc5a5305b5.1568834524.git.rgb@redhat.com>
In-Reply-To: <6fb4e270bfafef3d0477a06b0365fdcc5a5305b5.1568834524.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 10 Oct 2019 20:38:34 -0400
Message-ID: <CAHC9VhS2111YTQ_rbHKe6+n9coPNbcTJqf5wnBx9LYHSf69THA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 04/21] audit: convert to contid list to check
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

On Wed, Sep 18, 2019 at 9:24 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Store the audit container identifier in a refcounted kernel object that
> is added to the master list of audit container identifiers.  This will
> allow multiple container orchestrators/engines to work on the same
> machine without danger of inadvertantly re-using an existing identifier.
> It will also allow an orchestrator to inject a process into an existing
> container by checking if the original container owner is the one
> injecting the task.  A hash table list is used to optimize searches.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h | 26 ++++++++++++++--
>  kernel/audit.c        | 86 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  kernel/audit.h        |  8 +++++
>  3 files changed, 112 insertions(+), 8 deletions(-)

One general comment before we go off into the weeds on this ... I can
understand why you wanted to keep this patch separate from the earlier
patches, but as we get closer to having mergeable code this should get
folded into the previous patches.  For example, there shouldn't be a
change in audit_task_info where you change the contid field from a u64
to struct pointer, it should be a struct pointer from the start.

It's also disappointing that idr appears to only be for 32-bit ID
values, if we had a 64-bit idr I think we could simplify this greatly.

> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index f2e3b81f2942..e317807cdd3e 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -95,10 +95,18 @@ struct audit_ntp_data {
>  struct audit_ntp_data {};
>  #endif
>
> +struct audit_cont {
> +       struct list_head        list;
> +       u64                     id;
> +       struct task_struct      *owner;
> +       refcount_t              refcount;
> +       struct rcu_head         rcu;
> +};

It seems as though in most of the code you are using "contid", any
reason why didn't stick with that naming scheme here, e.g. "struct
audit_contid"?

>  struct audit_task_info {
>         kuid_t                  loginuid;
>         unsigned int            sessionid;
> -       u64                     contid;
> +       struct audit_cont       *cont;

Same, why not stick with "contid"?

>  #ifdef CONFIG_AUDITSYSCALL
>         struct audit_context    *ctx;
>  #endif
> @@ -203,11 +211,15 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
>
>  static inline u64 audit_get_contid(struct task_struct *tsk)
>  {
> -       if (!tsk->audit)
> +       if (!tsk->audit || !tsk->audit->cont)
>                 return AUDIT_CID_UNSET;
> -       return tsk->audit->contid;
> +       return tsk->audit->cont->id;
>  }

Assuming for a moment that we implement an audit_contid_get() (see
Neil's comment as well as mine below), we probably need to name this
something different so we don't all lose our minds when we read this
code.  On the plus side we can probably preface it with an underscore
since it is a static, in which case _audit_contid_get() might be okay,
but I'm open to suggestions.

> +extern struct audit_cont *audit_cont(struct task_struct *tsk);
> +
> +extern void audit_cont_put(struct audit_cont *cont);

More of the "contid" vs "cont".

>  extern u32 audit_enabled;
>
>  extern int audit_signal_info(int sig, struct task_struct *t);
> @@ -277,6 +289,14 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
>         return AUDIT_CID_UNSET;
>  }
>
> +static inline struct audit_cont *audit_cont(struct task_struct *tsk)
> +{
> +       return NULL;
> +}
> +
> +static inline void audit_cont_put(struct audit_cont *cont)
> +{ }
> +
>  #define audit_enabled AUDIT_OFF
>
>  static inline int audit_signal_info(int sig, struct task_struct *t)
> diff --git a/kernel/audit.c b/kernel/audit.c
> index a36ea57cbb61..ea0899130cc1 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -137,6 +137,8 @@ struct audit_net {
>
>  /* Hash for inode-based rules */
>  struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
> +/* Hash for contid-based rules */
> +struct list_head audit_contid_hash[AUDIT_CONTID_BUCKETS];
>
>  static struct kmem_cache *audit_buffer_cache;
>
> @@ -204,6 +206,8 @@ struct audit_reply {
>
>  static struct kmem_cache *audit_task_cache;
>
> +static DEFINE_SPINLOCK(audit_contid_list_lock);

Since it looks like this protectects audit_contid_hash, I think it
would be better to move it up underneath audit_contid_hash.

>  void __init audit_task_init(void)
>  {
>         audit_task_cache = kmem_cache_create("audit_task",
> @@ -231,7 +235,9 @@ int audit_alloc(struct task_struct *tsk)
>         }
>         info->loginuid = audit_get_loginuid(current);
>         info->sessionid = audit_get_sessionid(current);
> -       info->contid = audit_get_contid(current);
> +       info->cont = audit_cont(current);
> +       if (info->cont)
> +               refcount_inc(&info->cont->refcount);

See the other comments about a "get" function, but I think we need a
RCU read lock around the above, no?

>         tsk->audit = info;
>
>         ret = audit_alloc_syscall(tsk);
> @@ -246,7 +252,7 @@ int audit_alloc(struct task_struct *tsk)
>  struct audit_task_info init_struct_audit = {
>         .loginuid = INVALID_UID,
>         .sessionid = AUDIT_SID_UNSET,
> -       .contid = AUDIT_CID_UNSET,
> +       .cont = NULL,

More "cont" vs "contid".

>  #ifdef CONFIG_AUDITSYSCALL
>         .ctx = NULL,
>  #endif
> @@ -266,6 +272,9 @@ void audit_free(struct task_struct *tsk)
>         /* Freeing the audit_task_info struct must be performed after
>          * audit_log_exit() due to need for loginuid and sessionid.
>          */
> +       spin_lock(&audit_contid_list_lock);
> +       audit_cont_put(tsk->audit->cont);
> +       spin_unlock(&audit_contid_list_lock);

Perhaps this will make sense as I get further into the patchset, but
why not move the spin lock operations into audit_[cont/contid]_put()?

>         info = tsk->audit;
>         tsk->audit = NULL;
>         kmem_cache_free(audit_task_cache, info);
> @@ -1657,6 +1666,9 @@ static int __init audit_init(void)
>         for (i = 0; i < AUDIT_INODE_BUCKETS; i++)
>                 INIT_LIST_HEAD(&audit_inode_hash[i]);
>
> +       for (i = 0; i < AUDIT_CONTID_BUCKETS; i++)
> +               INIT_LIST_HEAD(&audit_contid_hash[i]);
> +
>         mutex_init(&audit_cmd_mutex.lock);
>         audit_cmd_mutex.owner = NULL;
>
> @@ -2356,6 +2368,32 @@ int audit_signal_info(int sig, struct task_struct *t)
>         return audit_signal_info_syscall(t);
>  }
>
> +struct audit_cont *audit_cont(struct task_struct *tsk)
> +{
> +       if (!tsk->audit || !tsk->audit->cont)
> +               return NULL;
> +       return tsk->audit->cont;
> +}
> +
> +/* audit_contid_list_lock must be held by caller */
> +void audit_cont_put(struct audit_cont *cont)
> +{
> +       if (!cont)
> +               return;
> +       if (refcount_dec_and_test(&cont->refcount)) {
> +               put_task_struct(cont->owner);
> +               list_del_rcu(&cont->list);
> +               kfree_rcu(cont, rcu);
> +       }
> +}

I tend to agree with Neil's previous comment; if we've got a
audit_[cont/contid]_put(), why not an audit_[cont/contid]_get()?

> +static struct task_struct *audit_cont_owner(struct task_struct *tsk)
> +{
> +       if (tsk->audit && tsk->audit->cont)
> +               return tsk->audit->cont->owner;
> +       return NULL;
> +}

I'm not sure if this is possible (I haven't make my way through the
entire patchset) and the function above isn't used in this patch (why
is it here?), but it seems like it would be safer to convert this into
an audit_contid_isowner() function that simply returns 1/0 depending
on if the passed task_struct is the owner or not of a passed audit
container ID value?

>  /*
>   * audit_set_contid - set current task's audit contid
>   * @task: target task
> @@ -2382,9 +2420,12 @@ int audit_set_contid(struct task_struct *task, u64 contid)
>         }
>         oldcontid = audit_get_contid(task);
>         read_lock(&tasklist_lock);
> -       /* Don't allow the audit containerid to be unset */
> +       /* Don't allow the contid to be unset */
>         if (!audit_contid_valid(contid))
>                 rc = -EINVAL;
> +       /* Don't allow the contid to be set to the same value again */
> +       else if (contid == oldcontid) {
> +               rc = -EADDRINUSE;
>         /* if we don't have caps, reject */
>         else if (!capable(CAP_AUDIT_CONTROL))
>                 rc = -EPERM;

RCU read lock?  It's a bit dicey since I believe the tasklist_lock is
going to provide us the safety we need, but if we are going to claim
that the audit container ID list is protected by RCU we should
probably use it.

> @@ -2397,8 +2438,43 @@ int audit_set_contid(struct task_struct *task, u64 contid)
>         else if (audit_contid_set(task))
>                 rc = -ECHILD;
>         read_unlock(&tasklist_lock);
> -       if (!rc)
> -               task->audit->contid = contid;
> +       if (!rc) {
> +               struct audit_cont *oldcont = audit_cont(task);

Previously we held the tasklist_lock to protect the audit container ID
associated with the struct, should we still be holding it here?

Regardless, I worry that the lock dependencies between the
tasklist_lock and the audit_contid_list_lock are going to be tricky.
It might be nice to document the relationship in a comment up near
where you declare audit_contid_list_lock.

> +               struct audit_cont *cont = NULL;
> +               struct audit_cont *newcont = NULL;
> +               int h = audit_hash_contid(contid);
> +
> +               spin_lock(&audit_contid_list_lock);
> +               list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
> +                       if (cont->id == contid) {
> +                               /* task injection to existing container */
> +                               if (current == cont->owner) {

I understand the desire to limit a given audit container ID to the
orchestrator that created it, but are we certain that we can track
audit container ID "ownership" via a single instance of a task_struct?
 What happens when the orchestrator stops/restarts/crashes?  Do we
even care?

> +                                       refcount_inc(&cont->refcount);
> +                                       newcont = cont;

We can bail out of the loop here, yes?

> +                               } else {
> +                                       rc = -ENOTUNIQ;
> +                                       goto conterror;
> +                               }
> +                       }
> +               if (!newcont) {
> +                       newcont = kmalloc(sizeof(struct audit_cont), GFP_ATOMIC);
> +                       if (newcont) {
> +                               INIT_LIST_HEAD(&newcont->list);
> +                               newcont->id = contid;
> +                               get_task_struct(current);
> +                               newcont->owner = current;
> +                               refcount_set(&newcont->refcount, 1);
> +                               list_add_rcu(&newcont->list, &audit_contid_hash[h]);
> +                       } else {
> +                               rc = -ENOMEM;
> +                               goto conterror;
> +                       }
> +               }
> +               task->audit->cont = newcont;
> +               audit_cont_put(oldcont);
> +conterror:
> +               spin_unlock(&audit_contid_list_lock);
> +       }
>         task_unlock(task);
>
>         if (!audit_enabled)
> diff --git a/kernel/audit.h b/kernel/audit.h
> index 16bd03b88e0d..e4a31aa92dfe 100644
> --- a/kernel/audit.h
> +++ b/kernel/audit.h
> @@ -211,6 +211,14 @@ static inline int audit_hash_ino(u32 ino)
>         return (ino & (AUDIT_INODE_BUCKETS-1));
>  }
>
> +#define AUDIT_CONTID_BUCKETS   32
> +extern struct list_head audit_contid_hash[AUDIT_CONTID_BUCKETS];
> +
> +static inline int audit_hash_contid(u64 contid)
> +{
> +       return (contid & (AUDIT_CONTID_BUCKETS-1));
> +}
> +
>  /* Indicates that audit should log the full pathname. */
>  #define AUDIT_NAME_FULL -1
>

--
paul moore
www.paul-moore.com
