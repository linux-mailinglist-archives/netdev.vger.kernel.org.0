Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E70214D65
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 17:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgGEPKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 11:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbgGEPKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 11:10:51 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2A9C08C5E1
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 08:10:51 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id n2so23320738edr.5
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 08:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K1GlTWNj6PD7+zx4y3mMqpOJYFliIY0lpaJ9WmnrGsw=;
        b=TVETbdaAOuRO/jDxFj8DAvTi4hMrVVAbSwyctoP3jVXrzXh1bKEs45zZ1NEwfjHvwC
         UEx5ozOrG2hv594Z/YGdDPvxx0meRti7o88iXNnyvDq1UY0c749JNlHAxSyfiAZ23/wE
         /W2cFS8vmpT4joFagloB04C/hRBd6uqj57qzbxByKuMner1Wxk6V+snE08RaMl18Hk9E
         wL8obwq7ZGvHJcsgoQ5r5pfMFryIvQPDBD8Y335DeqXQuRh3M7tzDCgo/VLtblvRjCZg
         Y4ych2Z4P7RklJRXwWCUyyyN+2VWAPigZaKS7h/7Ihcy7zVtQbUBvhqezmjiX1U+6sBS
         s4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K1GlTWNj6PD7+zx4y3mMqpOJYFliIY0lpaJ9WmnrGsw=;
        b=N8K/Rc3UlsIgKvjMYk79oiO3RD4rjSVN3kRMOm9S+YH7HTAkZLrG/OYfrK/5pyq+ns
         RKdHfi3rc/kerwHzCWzGA7d3ym11uBvOZN4cj07OFaNKgUJ0N5j0NcIsj6n33Kfufjr4
         D0M/hnTEVjRiAOe9vcFBR2q0B/y9HNn6rhYZbSldDGNG9LKOoCDQphFjoimJk/ld6zkN
         y8IdzRAR/FdpNpTtCkzUiFDNJiWuSLtBbSay4wz3TMaqM83zw/TXyEGJyWh3chIAJzQw
         m2wc273HUlD0qklco0Cs5h2wukCewOPZzdnd90I6ti06srSGSelu3BBq2g+Zs80/fKiB
         dbzg==
X-Gm-Message-State: AOAM530RWIM3JVD4VU1es9Cb/WP9KfBhrS32bsTBzRjsOTAV8a2k5wsi
        2JT3oxEAZo7MJfK7ojIs7hqB8shVmbNRFL2y2WvLC8M=
X-Google-Smtp-Source: ABdhPJzPuOCZh7ofYNtUHCYMW3jBhuf1tPX7Hh6Nr+98EaJXJ76XW9p6lAoUkZaBiMUCY/jz5WPFypCksLJqOD5Wc9c=
X-Received: by 2002:aa7:cd52:: with SMTP id v18mr48740451edw.196.1593961849836;
 Sun, 05 Jul 2020 08:10:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593198710.git.rgb@redhat.com> <6e2e10432e1400f747918eeb93bf45029de2aa6c.1593198710.git.rgb@redhat.com>
In-Reply-To: <6e2e10432e1400f747918eeb93bf45029de2aa6c.1593198710.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 5 Jul 2020 11:10:38 -0400
Message-ID: <CAHC9VhSCm5eeBcyY8bBsnxr-hK4rkso9_NJHJec2OXLu4m5QTA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V9 05/13] audit: log container info of syscalls
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
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 9:22 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Create a new audit record AUDIT_CONTAINER_ID to document the audit
> container identifier of a process if it is present.
>
> Called from audit_log_exit(), syscalls are covered.
>
> Include target_cid references from ptrace and signal.
>
> A sample raw event:
> type=3DSYSCALL msg=3Daudit(1519924845.499:257): arch=3Dc000003e syscall=
=3D257 success=3Dyes exit=3D3 a0=3Dffffff9c a1=3D56374e1cef30 a2=3D241 a3=
=3D1b6 items=3D2 ppid=3D606 pid=3D635 auid=3D0 uid=3D0 gid=3D0 euid=3D0 sui=
d=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts0 ses=3D3 comm=3D"bash=
" exe=3D"/usr/bin/bash" subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0=
:c0.c1023 key=3D"tmpcontainerid"
> type=3DCWD msg=3Daudit(1519924845.499:257): cwd=3D"/root"
> type=3DPATH msg=3Daudit(1519924845.499:257): item=3D0 name=3D"/tmp/" inod=
e=3D13863 dev=3D00:27 mode=3D041777 ouid=3D0 ogid=3D0 rdev=3D00:00 obj=3Dsy=
stem_u:object_r:tmp_t:s0 nametype=3D PARENT cap_fp=3D0 cap_fi=3D0 cap_fe=3D=
0 cap_fver=3D0
> type=3DPATH msg=3Daudit(1519924845.499:257): item=3D1 name=3D"/tmp/tmpcon=
tainerid" inode=3D17729 dev=3D00:27 mode=3D0100644 ouid=3D0 ogid=3D0 rdev=
=3D00:00 obj=3Dunconfined_u:object_r:user_tmp_t:s0 nametype=3DCREATE cap_fp=
=3D0 cap_fi=3D0 cap_fe=3D0 cap_fver=3D0
> type=3DPROCTITLE msg=3Daudit(1519924845.499:257): proctitle=3D62617368002=
D6300736C65657020313B206563686F2074657374203E202F746D702F746D70636F6E746169=
6E65726964
> type=3DCONTAINER_ID msg=3Daudit(1519924845.499:257): contid=3D123458
>
> Please see the github audit kernel issue for the main feature:
>   https://github.com/linux-audit/audit-kernel/issues/90
> Please see the github audit userspace issue for supporting additions:
>   https://github.com/linux-audit/audit-userspace/issues/51
> Please see the github audit testsuiite issue for the test case:
>   https://github.com/linux-audit/audit-testsuite/issues/64
> Please see the github audit wiki for the feature overview:
>   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> Acked-by: Steve Grubb <sgrubb@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  include/linux/audit.h      |  7 +++++++
>  include/uapi/linux/audit.h |  1 +
>  kernel/audit.c             | 25 +++++++++++++++++++++++--
>  kernel/audit.h             |  4 ++++
>  kernel/auditsc.c           | 45 +++++++++++++++++++++++++++++++++++++++-=
-----
>  5 files changed, 74 insertions(+), 8 deletions(-)

...

> diff --git a/kernel/audit.c b/kernel/audit.c
> index 9e0b38ce1ead..a09f8f661234 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -2211,6 +2211,27 @@ void audit_log_session_info(struct audit_buffer *a=
b)
>         audit_log_format(ab, "auid=3D%u ses=3D%u", auid, sessionid);
>  }
>
> +/*
> + * audit_log_container_id - report container info
> + * @context: task or local context for record
> + * @cont: container object to report
> + */
> +void audit_log_container_id(struct audit_context *context,
> +                           struct audit_contobj *cont)
> +{
> +       struct audit_buffer *ab;
> +
> +       if (!cont)
> +               return;
> +       /* Generate AUDIT_CONTAINER_ID record with container ID */
> +       ab =3D audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER_ID);
> +       if (!ab)
> +               return;
> +       audit_log_format(ab, "contid=3D%llu", contid);

Did this patch compile?  Where is "contid" coming from?  I'm guessing
you mean to get it from "cont", but that isn't what appears to be
happening; likely a casualty of the object vs token discussion we had
during the last review cycle.

I'm assuming this code gets modified later in this patchset and you
only compiled tested the patchset as a whole.  Please make sure the
patchset compiles at each patch along the way to applying them all;
this helps ensure that git bisect remains useful and it fits better
with the general idea that individual patches must have merit on their
own.

... and yes, I do check for this when merging patchsets, it isn't just
a visual inspection, I compile test each patch.

If nothing else, at least this answers the question of if it is worth
respinning or not (this alone requires a respin).

> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index f03d3eb0752c..9e79645e5c0e 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -1458,6 +1466,7 @@ static void audit_log_exit(void)
>         struct audit_buffer *ab;
>         struct audit_aux_data *aux;
>         struct audit_names *n;
> +       struct audit_contobj *cont;
>
>         context->personality =3D current->personality;
>
> @@ -1541,7 +1550,7 @@ static void audit_log_exit(void)
>         for (aux =3D context->aux_pids; aux; aux =3D aux->next) {
>                 struct audit_aux_data_pids *axs =3D (void *)aux;
>
> -               for (i =3D 0; i < axs->pid_count; i++)
> +               for (i =3D 0; i < axs->pid_count; i++) {
>                         if (audit_log_pid_context(context, axs->target_pi=
d[i],
>                                                   axs->target_auid[i],
>                                                   axs->target_uid[i],
> @@ -1549,14 +1558,20 @@ static void audit_log_exit(void)
>                                                   axs->target_sid[i],
>                                                   axs->target_comm[i]))
>                                 call_panic =3D 1;
> +                       audit_log_container_id(context, axs->target_cid[i=
]);
> +               }

It might be nice to see an audit event example including the
ptrace/signal information.  I'm concerned there may be some confusion
about associating the different audit container IDs with the correct
information in the event.

>         }
>
> -       if (context->target_pid &&
> -           audit_log_pid_context(context, context->target_pid,
> -                                 context->target_auid, context->target_u=
id,
> -                                 context->target_sessionid,
> -                                 context->target_sid, context->target_co=
mm))
> +       if (context->target_pid) {
> +               if (audit_log_pid_context(context, context->target_pid,
> +                                         context->target_auid,
> +                                         context->target_uid,
> +                                         context->target_sessionid,
> +                                         context->target_sid,
> +                                         context->target_comm))
>                         call_panic =3D 1;
> +               audit_log_container_id(context, context->target_cid);
> +       }
>
>         if (context->pwd.dentry && context->pwd.mnt) {
>                 ab =3D audit_log_start(context, GFP_KERNEL, AUDIT_CWD);
> @@ -1575,6 +1590,14 @@ static void audit_log_exit(void)
>
>         audit_log_proctitle();
>
> +       rcu_read_lock();
> +       cont =3D _audit_contobj_get(current);
> +       rcu_read_unlock();
> +       audit_log_container_id(context, cont);
> +       rcu_read_lock();
> +       _audit_contobj_put(cont);
> +       rcu_read_unlock();

Do we need to grab an additional reference for the audit container
object here?  We don't create any additional references here that
persist beyond the lifetime of this function, right?


>         audit_log_container_drop();
>
>         /* Send end of event record to help user space know we are finish=
ed */

--
paul moore
www.paul-moore.com
