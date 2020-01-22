Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9B5145DE8
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 22:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbgAVV3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 16:29:10 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39983 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgAVV3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 16:29:10 -0500
Received: by mail-lj1-f196.google.com with SMTP id n18so708543ljo.7
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 13:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=znKmNqKr9gQDPfmrmtDejwJ1HslDiuzLboL4qUqmh40=;
        b=TP5mJnA7Gm0zdUG0OehnvyJWts/xMVo/mJxSurXzDTUcBQIzgsR1ns3H1p5rCpwp/o
         o5WEcw4A9HNc0n06O9ImPfjXjQS6Nxh19LC0d4tgDt1Av2slE1y47OS6cviu0l1oIqGb
         nh2EDlHL5wynTTB5yhFbFZDoa5TkK67zq9GykjlOT7s5XEF58dYNcPell0+CauOKp+XT
         nLFr9NOTwYPXWpaLNMfgFzqUgIZQ4EPNmzDpdQRueK1UtfBk0Xs1bWMty7FyANkkTdvm
         VpHNDh0cBO2f65tpkygyfW6HPpO5AJZ4qHWFD4baSKueZohLmEzK207pMLwN5wsHnsWU
         4+wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=znKmNqKr9gQDPfmrmtDejwJ1HslDiuzLboL4qUqmh40=;
        b=OiBiJy7ZAfC7Rq2HGKJPBRtn5syyJJSk141tUkAgh38xVSzlDFuHuiszfjkVZkaHsB
         7hQMOgrvAD9lkzRjfVoRZCB6mUsuaSaW1jAZerzEJ71aXBEsRL/8sws/hRx2DwkFnc/+
         hGOmytQVyvlXyJ45e1uzI+xx+Iq232+hZXYxDEqp0uJuxEIrx+2RXl807/gNLW38s2LF
         iuROnjd700cL6aBzghd7SMA6x3QS1/3EcaDxG+VsS4pZZofFD1fhkotq7PaFAF6SW8sZ
         CAvlbbEg+vy9MpDsBKfHMPYE9MtHIU/8C9ffMpH0qA8wIiiRFN8Imu0+XjAKgs4TQca4
         feMg==
X-Gm-Message-State: APjAAAX/KIE+tXJ8jxoY2ApQ6NyfbVhG0nH8s+zOV5wy918Bu3F9wATZ
        IcArQxPX8mSE65d7EsvjQ0toV0EDEKBYHnOJFPIK
X-Google-Smtp-Source: APXvYqwNba8ProlqYi+98kL7VZ17yOmxtTEHhSWsRlLym5CCBD8UqFSuw3B9hkfCZhhRvoe+Scem/yZ0v/+v52re61A=
X-Received: by 2002:a2e:9196:: with SMTP id f22mr21784742ljg.18.1579728548032;
 Wed, 22 Jan 2020 13:29:08 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <2954ed671a7622ddf3abdb8854dbba2ad13e9f33.1577736799.git.rgb@redhat.com>
In-Reply-To: <2954ed671a7622ddf3abdb8854dbba2ad13e9f33.1577736799.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 22 Jan 2020 16:28:57 -0500
Message-ID: <CAHC9VhRw3Fj9-hi+Vj8JJb_GXM4B9N5hRXa9H6aQkuuFqJJ15w@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 11/16] audit: add support for containerid to
 network namespaces
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

On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> This also adds support to qualify NETFILTER_PKT records.
>
> Audit events could happen in a network namespace outside of a task
> context due to packets received from the net that trigger an auditing
> rule prior to being associated with a running task.  The network
> namespace could be in use by multiple containers by association to the
> tasks in that network namespace.  We still want a way to attribute
> these events to any potential containers.  Keep a list per network
> namespace to track these audit container identifiiers.
>
> Add/increment the audit container identifier on:
> - initial setting of the audit container identifier via /proc
> - clone/fork call that inherits an audit container identifier
> - unshare call that inherits an audit container identifier
> - setns call that inherits an audit container identifier
> Delete/decrement the audit container identifier on:
> - an inherited audit container identifier dropped when child set
> - process exit
> - unshare call that drops a net namespace
> - setns call that drops a net namespace
>
> Add audit container identifier auxiliary record(s) to NETFILTER_PKT
> event standalone records.  Iterate through all potential audit container
> identifiers associated with a network namespace.
>
> Please see the github audit kernel issue for contid net support:
>   https://github.com/linux-audit/audit-kernel/issues/92
> Please see the github audit testsuiite issue for the test case:
>   https://github.com/linux-audit/audit-testsuite/issues/64
> Please see the github audit wiki for the feature overview:
>   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  include/linux/audit.h    |  24 +++++++++
>  kernel/audit.c           | 132 ++++++++++++++++++++++++++++++++++++++++++++++-
>  kernel/nsproxy.c         |   4 ++
>  net/netfilter/nft_log.c  |  11 +++-
>  net/netfilter/xt_AUDIT.c |  11 +++-
>  5 files changed, 176 insertions(+), 6 deletions(-)

...

> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 5531d37a4226..ed8d5b74758d 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -12,6 +12,7 @@
>  #include <linux/sched.h>
>  #include <linux/ptrace.h>
>  #include <uapi/linux/audit.h>
> +#include <linux/refcount.h>
>
>  #define AUDIT_INO_UNSET ((unsigned long)-1)
>  #define AUDIT_DEV_UNSET ((dev_t)-1)
> @@ -121,6 +122,13 @@ struct audit_task_info {
>
>  extern struct audit_task_info init_struct_audit;
>
> +struct audit_contobj_netns {
> +       struct list_head        list;
> +       u64                     id;

Since we now track audit container IDs in their own structure, why not
link directly to the audit container ID object (and bump the
refcount)?

> +       refcount_t              refcount;
> +       struct rcu_head         rcu;
> +};
> +
>  extern int is_audit_feature_set(int which);
>
>  extern int __init audit_register_class(int class, unsigned *list);
> @@ -225,6 +233,12 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
>  }
>
>  extern void audit_log_container_id(struct audit_context *context, u64 contid);
> +extern void audit_netns_contid_add(struct net *net, u64 contid);
> +extern void audit_netns_contid_del(struct net *net, u64 contid);
> +extern void audit_switch_task_namespaces(struct nsproxy *ns,
> +                                        struct task_struct *p);
> +extern void audit_log_netns_contid_list(struct net *net,
> +                                       struct audit_context *context);
>
>  extern u32 audit_enabled;
>
> @@ -297,6 +311,16 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
>
>  static inline void audit_log_container_id(struct audit_context *context, u64 contid)
>  { }
> +static inline void audit_netns_contid_add(struct net *net, u64 contid)
> +{ }
> +static inline void audit_netns_contid_del(struct net *net, u64 contid)
> +{ }
> +static inline void audit_switch_task_namespaces(struct nsproxy *ns,
> +                                               struct task_struct *p)
> +{ }
> +static inline void audit_log_netns_contid_list(struct net *net,
> +                                              struct audit_context *context)
> +{ }
>
>  #define audit_enabled AUDIT_OFF
>
> diff --git a/kernel/audit.c b/kernel/audit.c
> index d4e6eafe5644..f7a8d3288ca0 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -59,6 +59,7 @@
>  #include <linux/freezer.h>
>  #include <linux/pid_namespace.h>
>  #include <net/netns/generic.h>
> +#include <net/net_namespace.h>
>
>  #include "audit.h"
>
> @@ -86,9 +87,13 @@
>  /**
>   * struct audit_net - audit private network namespace data
>   * @sk: communication socket
> + * @contid_list: audit container identifier list
> + * @contid_list_lock audit container identifier list lock
>   */
>  struct audit_net {
>         struct sock *sk;
> +       struct list_head contid_list;
> +       spinlock_t contid_list_lock;
>  };
>
>  /**
> @@ -305,8 +310,11 @@ struct audit_task_info init_struct_audit = {
>  void audit_free(struct task_struct *tsk)
>  {
>         struct audit_task_info *info = tsk->audit;
> +       struct nsproxy *ns = tsk->nsproxy;
>
>         audit_free_syscall(tsk);
> +       if (ns)
> +               audit_netns_contid_del(ns->net_ns, audit_get_contid(tsk));
>         /* Freeing the audit_task_info struct must be performed after
>          * audit_log_exit() due to need for loginuid and sessionid.
>          */
> @@ -409,6 +417,120 @@ static struct sock *audit_get_sk(const struct net *net)
>         return aunet->sk;
>  }
>
> +void audit_netns_contid_add(struct net *net, u64 contid)
> +{
> +       struct audit_net *aunet;
> +       struct list_head *contid_list;
> +       struct audit_contobj_netns *cont;
> +
> +       if (!net)
> +               return;
> +       if (!audit_contid_valid(contid))
> +               return;
> +       aunet = net_generic(net, audit_net_id);
> +       if (!aunet)
> +               return;
> +       contid_list = &aunet->contid_list;
> +       rcu_read_lock();
> +       list_for_each_entry_rcu(cont, contid_list, list)
> +               if (cont->id == contid) {
> +                       spin_lock(&aunet->contid_list_lock);
> +                       refcount_inc(&cont->refcount);
> +                       spin_unlock(&aunet->contid_list_lock);
> +                       goto out;
> +               }
> +       cont = kmalloc(sizeof(*cont), GFP_ATOMIC);
> +       if (cont) {
> +               INIT_LIST_HEAD(&cont->list);
> +               cont->id = contid;
> +               refcount_set(&cont->refcount, 1);
> +               spin_lock(&aunet->contid_list_lock);
> +               list_add_rcu(&cont->list, contid_list);
> +               spin_unlock(&aunet->contid_list_lock);
> +       }
> +out:
> +       rcu_read_unlock();
> +}

See my comments about refcount_t, spinlocks, and list manipulation
races from earlier in the patchset; the same thing applies to the
function above.


--
paul moore
www.paul-moore.com
