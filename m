Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E8E3EAC2B
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 23:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhHLVAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 17:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbhHLVAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 17:00:38 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8165DC0613D9
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 14:00:12 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id go31so14128371ejc.6
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 14:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+HsAkzG0KbQu4HqDlrQg17A0XETgrWzgdJJglZ2doTQ=;
        b=SyoV9uKa8cDgpg4IH2Nt4FQB6sgeK+4ZEegniL0vgAFl37sP4bd7TQmBGK+Tp1MxOO
         N3Cg/X/Ebv8Ijjwwd8719g0vRF2fF9ruyIDI43nKim0KfLpSVpoh+H6qY8pKr3pg+x6c
         zNY1339TCuLrmbweK7J4pw5i6XN8W8rmOVMjBht/1+SefMLFaRbfMcRMLDWuKppMhOGO
         YyAKgLrlJwWPiz5aSqpqvActqM/CvFvV54OjEewuNh6jsYqklrYpQt+RWWHDF8NyHHVP
         5EmMbJ4Jd7TjH/ADnRGoFh8K+QH8JW6QAJoKHFLpPj1w8Yz0acrPBDkt5Unw/DUrPJp/
         unqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+HsAkzG0KbQu4HqDlrQg17A0XETgrWzgdJJglZ2doTQ=;
        b=etkTwKHnMhzWELLAPFx7rwtzZk67W8wgm2wm8WdQzCW+VDy5ToRSGRZdEiGOwUtWat
         v4tcikcWZpA8/LBVO7F/ISVP6tlPpbQFFlY7xc/2tID5va/hlj4IQr84dM6/w9Q9PsH7
         xNmjV/kmgUy2IJYiSmZljJqSg86jwCs9ImhdUQe1DM9Fn+5DWbzm3OjHLPyZKlzqHeng
         Hz7zskGCYwsrv+E5dgtveUfVq3cW47aCjWvsP4MIdtql+zubV1NabzOLYpjRCo7zkhpV
         VbV++gvFjMvN+VolwzS3GiLoZrX1ODVaNXW0BlAoYOBNmvfPZHfHCTNkllRNXHG3LI0Q
         kViA==
X-Gm-Message-State: AOAM532paZEyeRiJKFWvEL4s48T4ml59JL0ntp6Pqpw3UwQYLwS7UPlK
        dSjOfr1inhr13qJYL72xpPekStd4YIbBgn2QF09g
X-Google-Smtp-Source: ABdhPJyp9rQn46328pcjEFH2P5j9WTyFqzl+u4ni1mRT+7fxsE7esiw8ye7RC4ZXlMyJsBE40Z4obrchbb1stkrdWHk=
X-Received: by 2002:a17:906:3915:: with SMTP id f21mr5598918eje.178.1628802010835;
 Thu, 12 Aug 2021 14:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210722004758.12371-1-casey@schaufler-ca.com> <20210722004758.12371-23-casey@schaufler-ca.com>
In-Reply-To: <20210722004758.12371-23-casey@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 12 Aug 2021 16:59:59 -0400
Message-ID: <CAHC9VhTj2OJ7E6+iSBLNZaiPK-16UY0zSFJikpz+teef3JOosg@mail.gmail.com>
Subject: Re: [PATCH v28 22/25] Audit: Add record for multiple process LSM attributes
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     casey.schaufler@intel.com, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        Stephen Smalley <sds@tycho.nsa.gov>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 9:12 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> Create a new audit record type to contain the subject information
> when there are multiple security modules that require such data.
> This record is linked with the same timestamp and serial number
> using the audit_alloc_local() mechanism.
> The record is produced only in cases where there is more than one
> security module with a process "context".
> In cases where this record is produced the subj= fields of
> other records in the audit event will be set to "subj=?".
>
> An example of the MAC_TASK_CONTEXTS (1420) record is:
>
>         type=UNKNOWN[1420]
>         msg=audit(1600880931.832:113)
>         subj_apparmor="=unconfined"
>         subj_smack="_"
>
> There will be a subj_$LSM= entry for each security module
> LSM that supports the secid_to_secctx and secctx_to_secid
> hooks. The BPF security module implements secid/secctx
> translation hooks, so it has to be considered to provide a
> secctx even though it may not actually do so.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> To: paul@paul-moore.com
> To: linux-audit@redhat.com
> To: rgb@redhat.com
> Cc: netdev@vger.kernel.org
> ---
>  drivers/android/binder.c                |  2 +-
>  include/linux/audit.h                   | 16 +++++
>  include/linux/security.h                | 16 ++++-
>  include/net/netlabel.h                  |  2 +-
>  include/net/scm.h                       |  2 +-
>  include/net/xfrm.h                      | 13 +++-
>  include/uapi/linux/audit.h              |  1 +
>  kernel/audit.c                          | 90 +++++++++++++++++++------
>  kernel/auditfilter.c                    |  5 +-
>  kernel/auditsc.c                        | 27 ++++++--
>  net/ipv4/ip_sockglue.c                  |  2 +-
>  net/netfilter/nf_conntrack_netlink.c    |  4 +-
>  net/netfilter/nf_conntrack_standalone.c |  2 +-
>  net/netfilter/nfnetlink_queue.c         |  2 +-
>  net/netlabel/netlabel_unlabeled.c       | 21 +++---
>  net/netlabel/netlabel_user.c            | 14 ++--
>  net/netlabel/netlabel_user.h            |  6 +-
>  net/xfrm/xfrm_policy.c                  |  8 ++-
>  net/xfrm/xfrm_state.c                   | 18 +++--
>  security/integrity/ima/ima_api.c        |  6 +-
>  security/integrity/integrity_audit.c    |  5 +-
>  security/security.c                     | 46 ++++++++-----
>  security/smack/smackfs.c                |  3 +-
>  23 files changed, 221 insertions(+), 90 deletions(-)
>
> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> index 2c3a2348a144..3520caa0260c 100644
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -2722,7 +2722,7 @@ static void binder_transaction(struct binder_proc *proc,
>                  * case well anyway.
>                  */
>                 security_task_getsecid_obj(proc->tsk, &blob);
> -               ret = security_secid_to_secctx(&blob, &lsmctx);
> +               ret = security_secid_to_secctx(&blob, &lsmctx, LSMBLOB_DISPLAY);
>                 if (ret) {
>                         return_error = BR_FAILED_REPLY;
>                         return_error_param = ret;
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 97cd7471e572..85eb87f6f92d 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -291,6 +291,7 @@ extern int  audit_alloc(struct task_struct *task);
>  extern void __audit_free(struct task_struct *task);
>  extern struct audit_context *audit_alloc_local(gfp_t gfpflags);
>  extern void audit_free_context(struct audit_context *context);
> +extern void audit_free_local(struct audit_context *context);
>  extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
>                                   unsigned long a2, unsigned long a3);
>  extern void __audit_syscall_exit(int ret_success, long ret_value);
> @@ -386,6 +387,19 @@ static inline void audit_ptrace(struct task_struct *t)
>                 __audit_ptrace(t);
>  }
>
> +static inline struct audit_context *audit_alloc_for_lsm(gfp_t gfp)
> +{
> +       struct audit_context *context = audit_context();
> +
> +       if (context)
> +               return context;
> +
> +       if (lsm_multiple_contexts())
> +               return audit_alloc_local(gfp);
> +
> +       return NULL;
> +}

We don't want to do this, at least not as it is written above.  We
shouldn't have a function which abstracts away the creation of a local
audit_context.  Usage of a local audit_context should be explicit in
the caller, and if the caller's execution context is ambiguous enough
that it can require both a task_struct audit_context and a local
audit_context then we need to handle that on a case-by-case basis.
Hiding it like this is guaranteed to cause problems later.

I probably did a poor job of explaining what a local context is during
the last patchset; I'll try to do a better job here but also let me
say this as clear as I can ... if the "current" task struct is valid
for a given code path, *never* use a local audit context.  The local
audit context is a hack that is made necessary by the fact that we
have to audit things which happen outside the scope of an executing
task, e.g. the netfilter audit hooks, it should *never* be used when
there is a valid task_struct.

It's the audit_context which helps bind multiple audit records into a
single event, creating a new, "local" audit_context destroys that
binding as audit records created using that local audit_context have a
different timestamp from those records created using the current
task_struct's audit_context.

Hopefully that makes sense?

>                                 /* Private API (for audit.c only) */
>  extern void __audit_ipc_obj(struct kern_ipc_perm *ipcp);
>  extern void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, umode_t mode);
> @@ -560,6 +574,8 @@ extern int audit_signals;
>  }
>  static inline void audit_free_context(struct audit_context *context)
>  { }
> +static inline void audit_free_local(struct audit_context *context)
> +{ }
>  static inline int audit_alloc(struct task_struct *task)
>  {
>         return 0;
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 3e9743118fb9..b3cf68cf2bd6 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -182,6 +182,8 @@ struct lsmblob {
>  #define LSMBLOB_INVALID                -1      /* Not a valid LSM slot number */
>  #define LSMBLOB_NEEDED         -2      /* Slot requested on initialization */
>  #define LSMBLOB_NOT_NEEDED     -3      /* Slot not requested */
> +#define LSMBLOB_DISPLAY                -4      /* Use the "display" slot */
> +#define LSMBLOB_FIRST          -5      /* Use the default "display" slot */
>
>  /**
>   * lsmblob_init - initialize an lsmblob structure
> @@ -248,6 +250,15 @@ static inline u32 lsmblob_value(const struct lsmblob *blob)
>         return 0;
>  }
>
> +static inline bool lsm_multiple_contexts(void)
> +{
> +#ifdef CONFIG_SECURITY
> +       return lsm_slot_to_name(1) != NULL;
> +#else
> +       return false;
> +#endif
> +}
> +
>  /* These functions are in security/commoncap.c */
>  extern int cap_capable(const struct cred *cred, struct user_namespace *ns,
>                        int cap, unsigned int opts);
> @@ -578,7 +589,8 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
>                          size_t size);
>  int security_netlink_send(struct sock *sk, struct sk_buff *skb);
>  int security_ismaclabel(const char *name);
> -int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp);
> +int security_secid_to_secctx(struct lsmblob *blob, struct lsmcontext *cp,
> +                            int display);
>  int security_secctx_to_secid(const char *secdata, u32 seclen,
>                              struct lsmblob *blob);
>  void security_release_secctx(struct lsmcontext *cp);
> @@ -1433,7 +1445,7 @@ static inline int security_ismaclabel(const char *name)
>  }
>
>  static inline int security_secid_to_secctx(struct lsmblob *blob,
> -                                          struct lsmcontext *cp)
> +                                          struct lsmcontext *cp, int display)
>  {
>         return -EOPNOTSUPP;
>  }
> diff --git a/include/net/netlabel.h b/include/net/netlabel.h
> index 73fc25b4042b..216cb1ffc8f0 100644
> --- a/include/net/netlabel.h
> +++ b/include/net/netlabel.h
> @@ -97,7 +97,7 @@ struct calipso_doi;
>
>  /* NetLabel audit information */
>  struct netlbl_audit {
> -       u32 secid;
> +       struct lsmblob lsmdata;
>         kuid_t loginuid;
>         unsigned int sessionid;
>  };

This chunk seems lost here, does it belong in another patch?

> diff --git a/include/net/scm.h b/include/net/scm.h
> index b77a52f93389..f4d567d4885e 100644
> --- a/include/net/scm.h
> +++ b/include/net/scm.h
> @@ -101,7 +101,7 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
>                  * and the infrastructure will know which it is.
>                  */
>                 lsmblob_init(&lb, scm->secid);
> -               err = security_secid_to_secctx(&lb, &context);
> +               err = security_secid_to_secctx(&lb, &context, LSMBLOB_DISPLAY);

Misplaced code change?

>                 if (!err) {
>                         put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, context.len,
> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> index cbff7c2a9724..a10fa01f7bf4 100644
> --- a/include/net/xfrm.h
> +++ b/include/net/xfrm.h
> @@ -660,13 +660,22 @@ struct xfrm_spi_skb_cb {
>  #define XFRM_SPI_SKB_CB(__skb) ((struct xfrm_spi_skb_cb *)&((__skb)->cb[0]))
>
>  #ifdef CONFIG_AUDITSYSCALL
> -static inline struct audit_buffer *xfrm_audit_start(const char *op)
> +static inline struct audit_buffer *xfrm_audit_start(const char *op,
> +                                                   struct audit_context **lac)
>  {
> +       struct audit_context *context;
>         struct audit_buffer *audit_buf = NULL;
>
>         if (audit_enabled == AUDIT_OFF)
>                 return NULL;
> -       audit_buf = audit_log_start(audit_context(), GFP_ATOMIC,
> +       context = audit_context();
> +       if (lac != NULL) {
> +               if (lsm_multiple_contexts() && context == NULL)
> +                       context = audit_alloc_local(GFP_ATOMIC);
> +               *lac = context;
> +       }
> +
> +       audit_buf = audit_log_start(context, GFP_ATOMIC,
>                                     AUDIT_MAC_IPSEC_EVENT);
>         if (audit_buf == NULL)
>                 return NULL;

Related to the other comments around local audit_contexts, we don't
want to do this; use the existing audit_context, @lac in this case, so
that this audit record is bound to the other associated records into a
single audit event (all have the same timestamp).

> diff --git a/kernel/audit.c b/kernel/audit.c
> index 841123390d41..cba63789a164 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -386,10 +386,12 @@ void audit_log_lost(const char *message)
>  static int audit_log_config_change(char *function_name, u32 new, u32 old,
>                                    int allow_changes)
>  {
> +       struct audit_context *context;
>         struct audit_buffer *ab;
>         int rc = 0;
>
> -       ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONFIG_CHANGE);
> +       context = audit_alloc_for_lsm(GFP_KERNEL);
> +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONFIG_CHANGE);

We shouldn't need to do this for the reasons discussed up near the top
of this email (and elsewhere as well).

I'm going to refrain from commenting on the other uses of
audit_alloc_for_lsm() in this patch unless there is something unique
to the code path, so if you don't see me comment about a use of
audit_alloc_for_lsm() you can assume it should be removed and the
existing audit_context used instead.

> @@ -399,6 +401,7 @@ static int audit_log_config_change(char *function_name, u32 new, u32 old,
>                 allow_changes = 0; /* Something weird, deny request */
>         audit_log_format(ab, " res=%d", allow_changes);
>         audit_log_end(ab);
> +       audit_free_local(context);

See my comment directly above regarding usage of
audit_alloc_for_lsm(), it obviously applies here too.

> @@ -2128,6 +2136,36 @@ void audit_log_key(struct audit_buffer *ab, char *key)
>                 audit_log_format(ab, "(null)");
>  }
>
> +static void audit_log_lsm(struct audit_context *context, struct lsmblob *blob)

See my note below about moving this into audit_log_task_context(), but
if we really need to keep this as a separate function, let's consider
changing the name to something which indicates that it logs the LSM
data as *subject* fields.  How about audit_log_lsm_subj()?

> +{
> +       struct audit_buffer *ab;
> +       struct lsmcontext lsmdata;
> +       bool sep = false;
> +       int error;
> +       int i;
> +
> +       ab = audit_log_start(context, GFP_ATOMIC, AUDIT_MAC_TASK_CONTEXTS);
> +       if (!ab)
> +               return; /* audit_panic or being filtered */
> +
> +       for (i = 0; i < LSMBLOB_ENTRIES; i++) {
> +               if (blob->secid[i] == 0)
> +                       continue;
> +               error = security_secid_to_secctx(blob, &lsmdata, i);
> +               if (error && error != -EINVAL) {
> +                       audit_panic("error in audit_log_lsm");
> +                       return;
> +               }
> +
> +               audit_log_format(ab, "%ssubj_%s=\"%s\"", sep ? " " : "",
> +                                lsm_slot_to_name(i), lsmdata.context);
> +               sep = true;

Since @i starts at zero, you can get rid of @sep by replacing it with @i:

  audit_log_format(ab, ..., (i ? " " : ""), ...);

> +               security_release_secctx(&lsmdata);
> +       }
> +       audit_log_end(ab);
> +}

> @@ -2138,7 +2176,18 @@ int audit_log_task_context(struct audit_buffer *ab)
>         if (!lsmblob_is_set(&blob))
>                 return 0;
>
> -       error = security_secid_to_secctx(&blob, &context);
> +       /*
> +        * If there is more than one security module that has a
> +        * subject "context" it's necessary to put the subject data
> +        * into a separate record to maintain compatibility.
> +        */
> +       if (lsm_multiple_contexts()) {
> +               audit_log_format(ab, " subj=?");
> +               audit_log_lsm(ab->ctx, &blob);
> +               return 0;
> +       }
> +
> +       error = security_secid_to_secctx(&blob, &context, LSMBLOB_FIRST);

Instead of the lsm_multiple_contexts() case bailing on the rest of the
function with a return inside the if-block, let's made the code a bit
more robust by organizing it like this:

  int audit_log_task_context(ab)
  {
     /* common stuff at the start */

     if (lsm_multiple_contexts()) {
       /* multi-LSM stuff */
     } else {
       /* single LSM stuff */
     }

     /* common stuff at the end */
  }

... it also may make sense to just move the body of audit_log_lsm()
into audit_log_task_context() and do away with audit_log_lsm()
entirely; is it ever going to be called from anywhere else?

> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 0e58a3ab56f5..01fdcbf468c0 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -993,12 +993,11 @@ struct audit_context *audit_alloc_local(gfp_t gfpflags)
>         context = audit_alloc_context(AUDIT_STATE_BUILD, gfpflags);
>         if (!context) {
>                 audit_log_lost("out of memory in audit_alloc_local");
> -               goto out;
> +               return NULL;
>         }
>         context->serial = audit_serial();
>         ktime_get_coarse_real_ts64(&context->ctime);
>         context->local = true;
> -out:
>         return context;
>  }

This chunk should be moved to 21/25 when audit_alloc_local() is first defined.

> @@ -1019,6 +1018,13 @@ void audit_free_context(struct audit_context *context)
>  }
>  EXPORT_SYMBOL(audit_free_context);
>
> +void audit_free_local(struct audit_context *context)
> +{
> +       if (context && context->local)
> +               audit_free_context(context);
> +}
> +EXPORT_SYMBOL(audit_free_local);

If this is strictly necessary, and I don't think it is, it should also
be moved to patch 21/25 with the original definition of a local
audit_context.  However,  there really should be no reason why we have
to distinguish between a proper and local audtit_context when it comes
to free'ing the memory, just call audit_free_context() in both cases.

> @@ -1036,7 +1042,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
>                          from_kuid(&init_user_ns, auid),
>                          from_kuid(&init_user_ns, uid), sessionid);
>         if (lsmblob_is_set(blob)) {
> -               if (security_secid_to_secctx(blob, &lsmctx)) {
> +               if (security_secid_to_secctx(blob, &lsmctx, LSMBLOB_FIRST)) {

Misplaced code change?

Actually, there are a lot of these below, I'm not going to comment on
all of them as I think you get the idea ... and I very well may be
wrong so I'll save you all of my wrongness in that case :)

> diff --git a/security/security.c b/security/security.c
> index cb359e185d1a..5d7fd982f84a 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2309,7 +2309,7 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
>                 hlist_for_each_entry(hp, &security_hook_heads.setprocattr,
>                                      list) {
>                         rc = hp->hook.setprocattr(name, value, size);
> -                       if (rc < 0)
> +                       if (rc < 0 && rc != -EINVAL)
>                                 return rc;
>                 }

This really looks misplaced ... ?

-- 
paul moore
www.paul-moore.com
