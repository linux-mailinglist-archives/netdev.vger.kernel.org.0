Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9D6214D6E
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 17:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgGEPLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 11:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727908AbgGEPK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 11:10:59 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D855C08C5E1
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 08:10:59 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id dg28so32356677edb.3
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 08:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r9DiCc6x8lICZPtnCZBRHzkDZvjjByWo+uBKuu1hw4E=;
        b=SCPCx+Sx02BqAKgTmj33lrp1AR1FkiN3RO22nh1Fu/8F2eXH8vqhqLZ0MmbbFp1BLJ
         rt7V4YfRsfUmQgPaQokSLc/XphPCbMTo1uS/16Gbgl0OmeYfJ6yoLJe42cmIFEZos9WJ
         9DRUs7HxBImo13Uo+ZqGlv5LvZybaRnN6wTZRZun06iDnfpUp9n6+bMHtxzTEv0eT4Ld
         IFxuQuMv6SygpIBJfVcZ8Lox2d6CSv26OVL0+Hf+Ww8glhlmjgJqQqnXZcMqqsDuolwL
         /qAfAE9gi+UVGO6uGqgli1IQbCkcVKoI0NZo1RNPF8/PuOQYneKAs39Q55cOsGE++J9N
         cCXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r9DiCc6x8lICZPtnCZBRHzkDZvjjByWo+uBKuu1hw4E=;
        b=Zx6tBzof70ORLfGP/NjaLbW3Z4SYd6Zx9/J4nhUYnOwVqWNBUFd3bG8O95HLzMiypR
         06rpdwkq8dHkWZjBlPrMZUJGTql/mwjAjQQX9kw7Z033d/nQhfOoXl6OPbN8VYhb5thv
         6RtL6nrlWzWopL0Bz+NsjvhV3BCp6lMDyulcHPbZNOJAoBz7lkFmJr0f1zUg0tbr3jsH
         23M/gR3qyzKWARAd8pAtaptN0CqkFZstWV2ZDryFIWIAxktDEIopLw4PP97uZCHenPlc
         k5GSEqAck8cChfacPyQ7Sits5NZ/eRlLxX79gayx3oJMaXSFet8sbWay+cPP7ljLWAnO
         8XaA==
X-Gm-Message-State: AOAM533ksnICKhsE+uSzbvPYDhkXNRoPOJtlKFLucMUwQXRZBokxvBQe
        NYq83mF6U8b7qPRGPS2QfGG1Qp5J6lwOjVF/a+4H
X-Google-Smtp-Source: ABdhPJy+MzquU6l4PmJHVYiVrCRYavqWOdZeZtU0571AD9O3iBB3b6pzT8i23qCcznUJF37mtItwe8m78Dp0MVWrol8=
X-Received: by 2002:aa7:c883:: with SMTP id p3mr52335550eds.128.1593961858091;
 Sun, 05 Jul 2020 08:10:58 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593198710.git.rgb@redhat.com> <f01f38dbb3190191e5914874322342700aecb9e1.1593198710.git.rgb@redhat.com>
In-Reply-To: <f01f38dbb3190191e5914874322342700aecb9e1.1593198710.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 5 Jul 2020 11:10:46 -0400
Message-ID: <CAHC9VhRPm4=_dVkZCu9iD5u5ixJOUnGNZ2wM9CL4kWwqv3GRnA@mail.gmail.com>
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

On Sat, Jun 27, 2020 at 9:22 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Add audit container identifier support to the action of signalling the
> audit daemon.
>
> Since this would need to add an element to the audit_sig_info struct,
> a new record type AUDIT_SIGNAL_INFO2 was created with a new
> audit_sig_info2 struct.  Corresponding support is required in the
> userspace code to reflect the new record request and reply type.
> An older userspace won't break since it won't know to request this
> record type.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h       |  8 ++++
>  include/uapi/linux/audit.h  |  1 +
>  kernel/audit.c              | 95 ++++++++++++++++++++++++++++++++++++++++++++-
>  security/selinux/nlmsgtab.c |  1 +
>  4 files changed, 104 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 5eeba0efffc2..89cf7c66abe6 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -22,6 +22,13 @@ struct audit_sig_info {
>         char            ctx[];
>  };
>
> +struct audit_sig_info2 {
> +       uid_t           uid;
> +       pid_t           pid;
> +       u32             cid_len;
> +       char            data[];
> +};
> +
>  struct audit_buffer;
>  struct audit_context;
>  struct inode;
> @@ -105,6 +112,7 @@ struct audit_contobj {
>         u64                     id;
>         struct task_struct      *owner;
>         refcount_t              refcount;
> +       refcount_t              sigflag;
>         struct rcu_head         rcu;
>  };

It seems like we need some protection in audit_set_contid() so that we
don't allow reuse of an audit container ID when "refcount == 0 &&
sigflag != 0", yes?

> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index fd98460c983f..a56ad77069b9 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -72,6 +72,7 @@
>  #define AUDIT_SET_FEATURE      1018    /* Turn an audit feature on or off */
>  #define AUDIT_GET_FEATURE      1019    /* Get which features are enabled */
>  #define AUDIT_CONTAINER_OP     1020    /* Define the container id and info */
> +#define AUDIT_SIGNAL_INFO2     1021    /* Get info auditd signal sender */
>
>  #define AUDIT_FIRST_USER_MSG   1100    /* Userspace messages mostly uninteresting to kernel */
>  #define AUDIT_USER_AVC         1107    /* We filter this differently */
> diff --git a/kernel/audit.c b/kernel/audit.c
> index a09f8f661234..54dd2cb69402 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -126,6 +126,8 @@ struct auditd_connection {
>  kuid_t         audit_sig_uid = INVALID_UID;
>  pid_t          audit_sig_pid = -1;
>  u32            audit_sig_sid = 0;
> +static struct audit_contobj *audit_sig_cid;
> +static struct task_struct *audit_sig_atsk;

This looks like a typo, or did you mean "atsk" for some reason?

>  /* Records can be lost in several ways:
>     0) [suppressed in audit_alloc]
> @@ -239,7 +241,33 @@ void _audit_contobj_put(struct audit_contobj *cont)
>  {
>         if (!cont)
>                 return;
> -       if (refcount_dec_and_test(&cont->refcount)) {
> +       if (refcount_dec_and_test(&cont->refcount) && !refcount_read(&cont->sigflag)) {
> +               put_task_struct(cont->owner);
> +               list_del_rcu(&cont->list);
> +               kfree_rcu(cont, rcu);
> +       }
> +}

It seems like it might be a good idea to modify the corresponding
_get() to WARN on the reuse of audit container objects where refcount
is zero, similar to the comment I made above.  What do you think?

> +/* rcu_read_lock must be held by caller unless new */
> +static struct audit_contobj *_audit_contobj_get_sig(struct task_struct *tsk)
> +{
> +       struct audit_contobj *cont;
> +
> +       if (!tsk->audit)
> +               return NULL;
> +       cont = tsk->audit->cont;
> +       if (cont)
> +               refcount_set(&cont->sigflag, 1);
> +       return cont;
> +}

If you are going to use a refcount and call this a "get" function you
might as well make it do an increment and not just a set(1).  It a bit
silly with just one auditd per system, but I suppose it will make more
sense when we have multiple audit daemons.  In a related comment, you
probably want to rename "sigflag" to "sigcount" or similar.

In summary, it's either a reference that supports multiple gets/puts
or it's a flag with just an on/off; it shouldn't attempt to straddle
both, that's both confusing and fragile.

> +/* rcu_read_lock must be held by caller */
> +static void _audit_contobj_put_sig(struct audit_contobj *cont)
> +{
> +       if (!cont)
> +               return;
> +       refcount_set(&cont->sigflag, 0);
> +       if (!refcount_read(&cont->refcount)) {
>                 put_task_struct(cont->owner);
>                 list_del_rcu(&cont->list);
>                 kfree_rcu(cont, rcu);
> @@ -309,6 +337,13 @@ void audit_free(struct task_struct *tsk)
>         info = tsk->audit;
>         tsk->audit = NULL;
>         kmem_cache_free(audit_task_cache, info);
> +       rcu_read_lock();
> +       if (audit_sig_atsk == tsk) {
> +               _audit_contobj_put_sig(audit_sig_cid);
> +               audit_sig_cid = NULL;
> +               audit_sig_atsk = NULL;
> +       }
> +       rcu_read_unlock();
>  }
>
>  /**
> @@ -1132,6 +1167,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
>         case AUDIT_ADD_RULE:
>         case AUDIT_DEL_RULE:
>         case AUDIT_SIGNAL_INFO:
> +       case AUDIT_SIGNAL_INFO2:
>         case AUDIT_TTY_GET:
>         case AUDIT_TTY_SET:
>         case AUDIT_TRIM:
> @@ -1294,6 +1330,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>         struct audit_buffer     *ab;
>         u16                     msg_type = nlh->nlmsg_type;
>         struct audit_sig_info   *sig_data;
> +       struct audit_sig_info2  *sig_data2;
>         char                    *ctx = NULL;
>         u32                     len;
>
> @@ -1559,6 +1596,52 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>                                  sig_data, sizeof(*sig_data) + len);
>                 kfree(sig_data);
>                 break;
> +       case AUDIT_SIGNAL_INFO2: {
> +               unsigned int contidstrlen = 0;
> +
> +               len = 0;
> +               if (audit_sig_sid) {
> +                       err = security_secid_to_secctx(audit_sig_sid, &ctx,
> +                                                      &len);
> +                       if (err)
> +                               return err;
> +               }
> +               if (audit_sig_cid) {
> +                       contidstr = kmalloc(21, GFP_KERNEL);
> +                       if (!contidstr) {
> +                               if (audit_sig_sid)
> +                                       security_release_secctx(ctx, len);
> +                               return -ENOMEM;
> +                       }
> +                       contidstrlen = scnprintf(contidstr, 20, "%llu", audit_sig_cid->id);
> +               }
> +               sig_data2 = kmalloc(sizeof(*sig_data2) + contidstrlen + len, GFP_KERNEL);
> +               if (!sig_data2) {
> +                       if (audit_sig_sid)
> +                               security_release_secctx(ctx, len);
> +                       kfree(contidstr);
> +                       return -ENOMEM;
> +               }
> +               sig_data2->uid = from_kuid(&init_user_ns, audit_sig_uid);
> +               sig_data2->pid = audit_sig_pid;
> +               if (audit_sig_cid) {
> +                       memcpy(sig_data2->data, contidstr, contidstrlen);
> +                       sig_data2->cid_len = contidstrlen;
> +                       kfree(contidstr);
> +               }
> +               if (audit_sig_sid) {
> +                       memcpy(sig_data2->data + contidstrlen, ctx, len);
> +                       security_release_secctx(ctx, len);
> +               }
> +               rcu_read_lock();
> +               _audit_contobj_put_sig(audit_sig_cid);
> +               rcu_read_unlock();

We probably want to drop the reference in the legacy/AUDIT_SIGNAL_INFO
case too, right?

> +               audit_sig_cid = NULL;
> +               audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO2, 0, 0,
> +                                sig_data2, sizeof(*sig_data2) + contidstrlen + len);
> +               kfree(sig_data2);
> +               break;
> +       }
>         case AUDIT_TTY_GET: {
>                 struct audit_tty_status s;
>                 unsigned int t;
> @@ -2470,6 +2553,11 @@ int audit_signal_info(int sig, struct task_struct *t)
>                 else
>                         audit_sig_uid = uid;
>                 security_task_getsecid(current, &audit_sig_sid);
> +               rcu_read_lock();
> +               _audit_contobj_put_sig(audit_sig_cid);
> +               audit_sig_cid = _audit_contobj_get_sig(current);
> +               rcu_read_unlock();
> +               audit_sig_atsk = t;
>         }
>
>         return audit_signal_info_syscall(t);
> @@ -2532,6 +2620,11 @@ int audit_set_contid(struct task_struct *task, u64 contid)
>                         if (cont->id == contid) {
>                                 /* task injection to existing container */
>                                 if (current == cont->owner) {
> +                                       if (!refcount_read(&cont->refcount)) {
> +                                               rc = -ESHUTDOWN;

Reuse -ENOTUNIQ; I'm not overly excited about providing a lot of
detail here as these are global system objects.  If you must have a
different errno (and I would prefer you didn't), use something like
-EBUSY.


> +                                               spin_unlock(&audit_contobj_list_lock);
> +                                               goto conterror;
> +                                       }
>                                         _audit_contobj_hold(cont);
>                                         newcont = cont;
>                                 } else {
> diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
> index b69231918686..8303bb7a63d0 100644
> --- a/security/selinux/nlmsgtab.c
> +++ b/security/selinux/nlmsgtab.c
> @@ -137,6 +137,7 @@ struct nlmsg_perm {
>         { AUDIT_DEL_RULE,       NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
>         { AUDIT_USER,           NETLINK_AUDIT_SOCKET__NLMSG_RELAY    },
>         { AUDIT_SIGNAL_INFO,    NETLINK_AUDIT_SOCKET__NLMSG_READ     },
> +       { AUDIT_SIGNAL_INFO2,   NETLINK_AUDIT_SOCKET__NLMSG_READ     },
>         { AUDIT_TRIM,           NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
>         { AUDIT_MAKE_EQUIV,     NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
>         { AUDIT_TTY_GET,        NETLINK_AUDIT_SOCKET__NLMSG_READ     },

--
paul moore
www.paul-moore.com
