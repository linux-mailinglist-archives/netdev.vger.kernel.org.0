Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A383145DD6
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 22:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgAVV2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 16:28:30 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37130 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgAVV23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 16:28:29 -0500
Received: by mail-lj1-f195.google.com with SMTP id o13so725518ljg.4
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 13:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yryeoDudvvVBVjLIWUT7Qspa9cODolKNnOJTJo0W59s=;
        b=XLP+MxpIl6Rqt4CMHS9bv6u8gknBwtKepFbH0qs4oXsL8ecX0hhWTdnnNM/A1L5w3J
         nZW+Nfn7rixKkEfsV0xUt2eFp6WEdlfbJkeQgVzKHhGcPDg5V+BBXwF+xgyZFijWKdub
         t7qCaqhWs0oGP56hW4c4/BxazdPpCcOLrwgCvRe1SHbFM4MLEtoHnBMzKtJnyR0rOB72
         2X16VfdSV5uRAoNH5dtF1mP5NvKIvM5hysmj2UrgyCHmsdCd1pe1cTxMZONDXIc7nqjy
         3237eFhGp7jmFqlsByYKAWo+B96GWWSHX/lrvfHsYix8RWciif6xspDWq8lVKWsQxF+t
         GuLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yryeoDudvvVBVjLIWUT7Qspa9cODolKNnOJTJo0W59s=;
        b=YflEOW2BDBqjV0/1++4HGwWBDVMI8ZLpGsipMYVcmYtapsD4kBy/rSdW9BC+RAne8L
         AUrStBXHSA30lN88lBKoDgvNmGVeOyOUv7Cw4qqA2TiHXP5MS6sO5x4exed1oN7FB7PZ
         AIniT+YbwzBaB+fPwQTWBLxn8d9UPs23LiETPqqugqaib8stifwuXYRbelnLnP0nGjR/
         K/b0HDSwl6NO0HWfC8DP8vApi8xPaEly/Ie2VOJGPfcGP6/bL5aapzCuGyv9p28G9gT1
         EJAA/IloROin42jlPgOk/3LiRpeP+GBASbfdiOpxPQOXE5B/vvFbIkz5dUTsJvRith14
         JocA==
X-Gm-Message-State: APjAAAVspd2bXVS/c0i2jV0Hf+vTUyX2wnhtuBcaVY2s2oTOWpZec5YK
        zQUDqSchk58xmZYz+pMr3Ed+oL46D7Y6C1Dh7Mnv
X-Google-Smtp-Source: APXvYqytpK2WymEiSfK8I2a6UuKsyuVHMmGosxklKTzxBk+yqkYU0o/zTyXD7HwnnsZGXSRkCPgx2ifkK/nPI1GIE80=
X-Received: by 2002:a2e:5357:: with SMTP id t23mr21084406ljd.227.1579728507143;
 Wed, 22 Jan 2020 13:28:27 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <a911acf0b209c05dc156fb6b57f9da45778747ce.1577736799.git.rgb@redhat.com>
In-Reply-To: <a911acf0b209c05dc156fb6b57f9da45778747ce.1577736799.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 22 Jan 2020 16:28:16 -0500
Message-ID: <CAHC9VhRRW2fFcgBs-R_BZ7ZWCP5wsXA9DB1RUM=QeKj2xZkS2Q@mail.gmail.com>
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

On Tue, Dec 31, 2019 at 2:50 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
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
>  include/linux/audit.h | 14 ++++++--
>  kernel/audit.c        | 98 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  kernel/audit.h        |  8 +++++
>  3 files changed, 112 insertions(+), 8 deletions(-)

...

> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index a045b34ecf44..0e6dbe943ae4 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -94,10 +94,18 @@ struct audit_ntp_data {
>  struct audit_ntp_data {};
>  #endif
>
> +struct audit_contobj {
> +       struct list_head        list;
> +       u64                     id;
> +       struct task_struct      *owner;
> +       refcount_t              refcount;
> +       struct rcu_head         rcu;
> +};
> +
>  struct audit_task_info {
>         kuid_t                  loginuid;
>         unsigned int            sessionid;
> -       u64                     contid;
> +       struct audit_contobj    *cont;
>  #ifdef CONFIG_AUDITSYSCALL
>         struct audit_context    *ctx;
>  #endif
> @@ -203,9 +211,9 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
>
>  static inline u64 audit_get_contid(struct task_struct *tsk)
>  {
> -       if (!tsk->audit)
> +       if (!tsk->audit || !tsk->audit->cont)
>                 return AUDIT_CID_UNSET;
> -       return tsk->audit->contid;
> +       return tsk->audit->cont->id;
>  }
>
>  extern u32 audit_enabled;
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 2d7707426b7d..4bab20f5f781 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -212,6 +218,31 @@ void __init audit_task_init(void)
>                                              0, SLAB_PANIC, NULL);
>  }
>
> +static struct audit_contobj *_audit_contobj(struct task_struct *tsk)
> +{
> +       if (!tsk->audit)
> +               return NULL;
> +       return tsk->audit->cont;

It seems like it would be safer to grab a reference here (e.g.
_audit_contobj_hold(...)), yes?  Or are you confident we will never
have tsk go away while the caller is holding on to the returned audit
container ID object?

> +}
> +
> +/* audit_contobj_list_lock must be held by caller unless new */
> +static void _audit_contobj_hold(struct audit_contobj *cont)
> +{
> +       refcount_inc(&cont->refcount);
> +}

If we are going to call the matching decrement function "_put" it
seems like we might want to call the function about "_get".  Further,
we can also have it return an audit_contobj pointer in case the caller
needs to do an assignment as well (which seems typical if you need to
bump the refcount):

  _audit_contobj_get(audit_contobj *cont)
  {
    if (cont)
      refcount_inc(cont);
    return cont;
  }

> +/* audit_contobj_list_lock must be held by caller */
> +static void _audit_contobj_put(struct audit_contobj *cont)
> +{
> +       if (!cont)
> +               return;
> +       if (refcount_dec_and_test(&cont->refcount)) {
> +               put_task_struct(cont->owner);
> +               list_del_rcu(&cont->list);
> +               kfree_rcu(cont, rcu);
> +       }
> +}
> +
>  /**
>   * audit_alloc - allocate an audit info block for a task
>   * @tsk: task
> @@ -232,7 +263,11 @@ int audit_alloc(struct task_struct *tsk)
>         }
>         info->loginuid = audit_get_loginuid(current);
>         info->sessionid = audit_get_sessionid(current);
> -       info->contid = audit_get_contid(current);
> +       spin_lock(&audit_contobj_list_lock);
> +       info->cont = _audit_contobj(current);
> +       if (info->cont)
> +               _audit_contobj_hold(info->cont);
> +       spin_unlock(&audit_contobj_list_lock);

If we are taking a spinlock in order to bump the refcount, does it
really need to be a refcount_t or can we just use a normal integer?
In RCU protected lists a spinlock is usually used to protect
adds/removes to the list, not the content of individual list items.

My guess is you probably want to use the spinlock as described above
(list add/remove protection) and manipulate the refcount_t inside a
RCU read lock protected region.

>         tsk->audit = info;
>
>         ret = audit_alloc_syscall(tsk);
> @@ -267,6 +302,9 @@ void audit_free(struct task_struct *tsk)
>         /* Freeing the audit_task_info struct must be performed after
>          * audit_log_exit() due to need for loginuid and sessionid.
>          */
> +       spin_lock(&audit_contobj_list_lock);
> +       _audit_contobj_put(tsk->audit->cont);
> +       spin_unlock(&audit_contobj_list_lock);

This is another case of refcount_t vs normal integer in a spinlock
protected region.

>         info = tsk->audit;
>         tsk->audit = NULL;
>         kmem_cache_free(audit_task_cache, info);
> @@ -2365,6 +2406,9 @@ int audit_signal_info(int sig, struct task_struct *t)
>   *
>   * Returns 0 on success, -EPERM on permission failure.
>   *
> + * If the original container owner goes away, no task injection is
> + * possible to an existing container.
> + *
>   * Called (set) from fs/proc/base.c::proc_contid_write().
>   */
>  int audit_set_contid(struct task_struct *task, u64 contid)
> @@ -2381,9 +2425,12 @@ int audit_set_contid(struct task_struct *task, u64 contid)
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

First, is that brace a typo?  It looks like it.  Did this compile?

Second, can you explain why (re)setting the audit container ID to the
same value is something we need to prohibit?  I'm guessing it has
something to do with explicitly set vs inherited, but I don't want to
assume too much about your thinking behind this.

If it is "set vs inherited", would allowing an orchestrator to
explicitly "set" an inherited audit container ID provide some level or
protection against moving the task?

>         /* if we don't have caps, reject */
>         else if (!capable(CAP_AUDIT_CONTROL))
>                 rc = -EPERM;
> @@ -2396,8 +2443,49 @@ int audit_set_contid(struct task_struct *task, u64 contid)
>         else if (audit_contid_set(task))
>                 rc = -ECHILD;
>         read_unlock(&tasklist_lock);
> -       if (!rc)
> -               task->audit->contid = contid;
> +       if (!rc) {
> +               struct audit_contobj *oldcont = _audit_contobj(task);
> +               struct audit_contobj *cont = NULL, *newcont = NULL;
> +               int h = audit_hash_contid(contid);
> +
> +               rcu_read_lock();
> +               list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
> +                       if (cont->id == contid) {
> +                               /* task injection to existing container */
> +                               if (current == cont->owner) {

Do we have any protection against the task pointed to by cont->owner
going away and a new task with the same current pointer value (no
longer the legitimate audit container ID owner) manipulating the
target task's audit container ID?

> +                                       spin_lock(&audit_contobj_list_lock);
> +                                       _audit_contobj_hold(cont);
> +                                       spin_unlock(&audit_contobj_list_lock);

More of the recount_t vs integer/spinlock question.

> +                                       newcont = cont;
> +                               } else {
> +                                       rc = -ENOTUNIQ;
> +                                       goto conterror;
> +                               }
> +                               break;
> +                       }
> +               if (!newcont) {
> +                       newcont = kmalloc(sizeof(*newcont), GFP_ATOMIC);
> +                       if (newcont) {
> +                               INIT_LIST_HEAD(&newcont->list);
> +                               newcont->id = contid;
> +                               get_task_struct(current);
> +                               newcont->owner = current;

newcont->owner = get_task_struct(current);

(This is what I was talking about above with returning the struct
pointer in the _get/_hold function)

> +                               refcount_set(&newcont->refcount, 1);
> +                               spin_lock(&audit_contobj_list_lock);
> +                               list_add_rcu(&newcont->list, &audit_contid_hash[h]);
> +                               spin_unlock(&audit_contobj_list_lock);

I think we might have a problem where multiple tasks could race adding
the same audit container ID and since there is no check inside the
spinlock protected region we could end up adding multiple instances of
the same audit container ID, yes?

> +                       } else {
> +                               rc = -ENOMEM;
> +                               goto conterror;
> +                       }
> +               }
> +               task->audit->cont = newcont;
> +               spin_lock(&audit_contobj_list_lock);
> +               _audit_contobj_put(oldcont);
> +               spin_unlock(&audit_contobj_list_lock);

More of the refcount_t/integer/spinlock question.


> +conterror:
> +               rcu_read_unlock();
> +       }
>         task_unlock(task);
>
>         if (!audit_enabled)

--
paul moore
www.paul-moore.com
