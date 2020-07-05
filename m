Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2595D214D53
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 17:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgGEPJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 11:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbgGEPJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 11:09:56 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF0CC08C5DE
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 08:09:56 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a1so39748858ejg.12
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 08:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+a+NkZk/z82sUmwa8lAR9nOo6EtZay2vAebfwkhsk6k=;
        b=UmdjKJ50jJWLthi/DT6Fs4iFmWFWyVC7Y7eZrOOgck5bWy1qD1rM0CMXNWKAJDlHVL
         MAa2rwS/APF5ZIIu7ChRJtgEZ53i8mPF0SjaJsiJKKGawhM60E/UxhFkn1iaFCLKkDvX
         ABjq8jVd+aSn/1mm8gcR3scWaSwN1qN6a3STwAf24/t6ZOCeOFxo9U4AkYeDjAYvwVle
         q6JqxJ/OONYa7eHq//8Oh7lZaQDQjIrW4vcI+eC9CiyArhAChgft2Fyel1fL2i4bo0FM
         6wrDxMJNUxIz0louWOYU4KpBGZlmriR+9XhHFy+lzf7hU5ECANHSv5nn2SFzJDJ0i7zK
         Dr2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+a+NkZk/z82sUmwa8lAR9nOo6EtZay2vAebfwkhsk6k=;
        b=raYCpPdJ/cc2HL7TiEP6qWrSNFbd6cbmXQgbItwfZyc1ool+yV/UH1kwAvY+CeHDd3
         a0ZaMx2YGuITTyOzzJS3KKSKjntajDMETQIoBt9gf56aWzCkLneXe4dMQlea/JTHE0eZ
         PSRvEF1zdTf2mvFJgzikvYQSgDPByMvSz3OX+HVHjkPpzdLZ9raYn1Y0dhTwJZjXblvE
         RYbo6ubic+4HKjrjaQHP6cvbW71uUNB58kVr8wC/UXQ1wngFUGDGaW8nsfEL9P4J+c22
         u3PDYNEKfZ9TnVclkFU2lq4FdR/uCtzx+v6AqcLuhLPVzh761PRMeYXFUFTM+0hl3xoh
         /w5g==
X-Gm-Message-State: AOAM533GcSMV7LmGVfbfyf8uxMsf/Xo5+liOlwENwNjMPXENyMDADbDO
        N/4ScLLnMsE1AmsJveXP2eaKNI43Fdg70Re4mrj1
X-Google-Smtp-Source: ABdhPJzoaJJDK0x6hHKY5IxkG2I5cD4JeTPSKb1HFyRKKxTq3fNryDZXuEZTaO6XoOjUl+x6NLfxACNsUd1JYOUwikw=
X-Received: by 2002:a17:906:7d86:: with SMTP id v6mr38973801ejo.542.1593961794741;
 Sun, 05 Jul 2020 08:09:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593198710.git.rgb@redhat.com> <6abeb26e64489fc29b00c86b60b501c8b7316424.1593198710.git.rgb@redhat.com>
In-Reply-To: <6abeb26e64489fc29b00c86b60b501c8b7316424.1593198710.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 5 Jul 2020 11:09:43 -0400
Message-ID: <CAHC9VhTx=4879F1MSXg4=Xd1i5rhEtyam6CakQhy=_ZjGtTaMA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V9 01/13] audit: collect audit task parameters
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

On Sat, Jun 27, 2020 at 9:21 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> The audit-related parameters in struct task_struct should ideally be
> collected together and accessed through a standard audit API.
>
> Collect the existing loginuid, sessionid and audit_context together in a
> new struct audit_task_info called "audit" in struct task_struct.
>
> Use kmem_cache to manage this pool of memory.
> Un-inline audit_free() to be able to always recover that memory.
>
> Please see the upstream github issue
> https://github.com/linux-audit/audit-kernel/issues/81
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  include/linux/audit.h | 49 +++++++++++++++++++++++------------
>  include/linux/sched.h |  7 +----
>  init/init_task.c      |  3 +--
>  init/main.c           |  2 ++
>  kernel/audit.c        | 71 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  kernel/audit.h        |  5 ++++
>  kernel/auditsc.c      | 26 ++++++++++---------
>  kernel/fork.c         |  1 -
>  8 files changed, 124 insertions(+), 40 deletions(-)
>
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 3fcd9ee49734..c2150415f9df 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -100,6 +100,16 @@ enum audit_nfcfgop {
>         AUDIT_XT_OP_UNREGISTER,
>  };
>
> +struct audit_task_info {
> +       kuid_t                  loginuid;
> +       unsigned int            sessionid;
> +#ifdef CONFIG_AUDITSYSCALL
> +       struct audit_context    *ctx;
> +#endif
> +};
> +
> +extern struct audit_task_info init_struct_audit;
> +
>  extern int is_audit_feature_set(int which);
>
>  extern int __init audit_register_class(int class, unsigned *list);

...

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index b62e6aaf28f0..2213ac670386 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -34,7 +34,6 @@
>  #include <linux/kcsan.h>
>
>  /* task_struct member predeclarations (sorted alphabetically): */
> -struct audit_context;
>  struct backing_dev_info;
>  struct bio_list;
>  struct blk_plug;
> @@ -946,11 +945,7 @@ struct task_struct {
>         struct callback_head            *task_works;
>
>  #ifdef CONFIG_AUDIT
> -#ifdef CONFIG_AUDITSYSCALL
> -       struct audit_context            *audit_context;
> -#endif
> -       kuid_t                          loginuid;
> -       unsigned int                    sessionid;
> +       struct audit_task_info          *audit;
>  #endif
>         struct seccomp                  seccomp;

In the early days of this patchset we talked a lot about how to handle
the task_struct and the changes that would be necessary, ultimately
deciding that encapsulating all of the audit fields into an
audit_task_info struct.  However, what is puzzling me a bit at this
moment is why we are only including audit_task_info in task_info by
reference *and* making it a build time conditional (via CONFIG_AUDIT).

If audit is enabled at build time it would seem that we are always
going to allocate an audit_task_info struct, so I have to wonder why
we don't simply embed it inside the task_info struct (similar to the
seccomp struct in the snippet above?  Of course the audit_context
struct needs to remain as is, I'm talking only about the
task_info/audit_task_info struct.

Richard, I'm sure you can answer this off the top of your head, but
I'd have to go digging through the archives to pull out the relevant
discussions so I figured I would just ask you for a reminder ... ?  I
imagine it's also possible things have changed a bit since those early
discussions and the solution we arrived at then no longer makes as
much sense as it did before.

> diff --git a/init/init_task.c b/init/init_task.c
> index 15089d15010a..92d34c4b7702 100644
> --- a/init/init_task.c
> +++ b/init/init_task.c
> @@ -130,8 +130,7 @@ struct task_struct init_task
>         .thread_group   = LIST_HEAD_INIT(init_task.thread_group),
>         .thread_node    = LIST_HEAD_INIT(init_signals.thread_head),
>  #ifdef CONFIG_AUDIT
> -       .loginuid       = INVALID_UID,
> -       .sessionid      = AUDIT_SID_UNSET,
> +       .audit          = &init_struct_audit,
>  #endif
>  #ifdef CONFIG_PERF_EVENTS
>         .perf_event_mutex = __MUTEX_INITIALIZER(init_task.perf_event_mutex),
> diff --git a/init/main.c b/init/main.c
> index 0ead83e86b5a..349470ad7458 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -96,6 +96,7 @@
>  #include <linux/jump_label.h>
>  #include <linux/mem_encrypt.h>
>  #include <linux/kcsan.h>
> +#include <linux/audit.h>
>
>  #include <asm/io.h>
>  #include <asm/bugs.h>
> @@ -1028,6 +1029,7 @@ asmlinkage __visible void __init start_kernel(void)
>         nsfs_init();
>         cpuset_init();
>         cgroup_init();
> +       audit_task_init();
>         taskstats_init_early();
>         delayacct_init();
>
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 8c201f414226..5d8147a29291 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -203,6 +203,73 @@ struct audit_reply {
>         struct sk_buff *skb;
>  };
>
> +static struct kmem_cache *audit_task_cache;
> +
> +void __init audit_task_init(void)
> +{
> +       audit_task_cache = kmem_cache_create("audit_task",
> +                                            sizeof(struct audit_task_info),
> +                                            0, SLAB_PANIC, NULL);
> +}
> +
> +/**
> + * audit_alloc - allocate an audit info block for a task
> + * @tsk: task
> + *
> + * Call audit_alloc_syscall to filter on the task information and
> + * allocate a per-task audit context if necessary.  This is called from
> + * copy_process, so no lock is needed.
> + */
> +int audit_alloc(struct task_struct *tsk)
> +{
> +       int ret = 0;
> +       struct audit_task_info *info;
> +
> +       info = kmem_cache_alloc(audit_task_cache, GFP_KERNEL);
> +       if (!info) {
> +               ret = -ENOMEM;
> +               goto out;
> +       }
> +       info->loginuid = audit_get_loginuid(current);
> +       info->sessionid = audit_get_sessionid(current);
> +       tsk->audit = info;
> +
> +       ret = audit_alloc_syscall(tsk);
> +       if (ret) {
> +               tsk->audit = NULL;
> +               kmem_cache_free(audit_task_cache, info);
> +       }
> +out:
> +       return ret;
> +}

This is a big nitpick, and I'm only mentioning this in the case you
need to respin this patchset: the "out" label is unnecessary in the
function above.  Simply return the error code, there is no need to
jump to "out" only to immediately return the error code there and
nothing more.

> +struct audit_task_info init_struct_audit = {
> +       .loginuid = INVALID_UID,
> +       .sessionid = AUDIT_SID_UNSET,
> +#ifdef CONFIG_AUDITSYSCALL
> +       .ctx = NULL,
> +#endif
> +};
> +
> +/**
> + * audit_free - free per-task audit info
> + * @tsk: task whose audit info block to free
> + *
> + * Called from copy_process and do_exit
> + */
> +void audit_free(struct task_struct *tsk)
> +{
> +       struct audit_task_info *info = tsk->audit;
> +
> +       audit_free_syscall(tsk);
> +       /* Freeing the audit_task_info struct must be performed after
> +        * audit_log_exit() due to need for loginuid and sessionid.
> +        */
> +       info = tsk->audit;
> +       tsk->audit = NULL;
> +       kmem_cache_free(audit_task_cache, info);

Another nitpick, and this one may even become a moot point given the
question posed above.  However, is there any reason we couldn't get
rid of "info" and simplify this a bit?

  audit_free_syscall(tsk);
  kmem_cache_free(audit_task_cache, tsk->audit);
  tsk->audit = NULL;

> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 468a23390457..f00c1da587ea 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -1612,7 +1615,6 @@ void __audit_free(struct task_struct *tsk)
>                 if (context->current_state == AUDIT_RECORD_CONTEXT)
>                         audit_log_exit();
>         }
> -
>         audit_set_context(tsk, NULL);
>         audit_free_context(context);
>  }

This nitpick is barely worth the time it is taking me to write this,
but the whitespace change above isn't strictly necessary.


--
paul moore
www.paul-moore.com
