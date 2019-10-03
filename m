Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD408CACE3
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbfJCRbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:31:13 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42935 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732760AbfJCRaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 13:30:19 -0400
Received: by mail-qt1-f196.google.com with SMTP id w14so4683192qto.9;
        Thu, 03 Oct 2019 10:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OwHzOlv94fNEQPzUN9beE8wR2Nx0PGCIq76ElwD91IY=;
        b=Kbfq1mSN6XsOJJ/hmRdAjfrwBr+ox+iLgaKkLdzPJeIQfnIY0MML3TLZCO/dvp94Q9
         rqVMaifyKHSu1yvsQgEU7rbHiPpghd6NdVs7s2NGC0fHenPikkmn21UFqpIAWNkUSijs
         CfsmewYSQH/tffSahrrtYwtqA4NXDUiV+CoMt8DvRrjkkqX+9smoyvlO7yYJpiiAuxsh
         gAwGJ3D3kgR+XLPKIxelQ2RTNDXvLJ6/62HYY1IGyS0FrcwUaQUb2esICGUo3z9Wl4+j
         1w+v5OpSY+CruNbhv2Q4EWNke7+ol1n66hqhvpigt1YNfqA/6R0gzFGYa+TuA2JglWT6
         kTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OwHzOlv94fNEQPzUN9beE8wR2Nx0PGCIq76ElwD91IY=;
        b=LM3Zu15rREJqJMJKY13YboqzNvOujoSpC2WAugiZtvHsr/YiMIP3EWoCd5p331a076
         7DlLubkOCFF4I00YeF/IOZPN7QOyPaWoNRRrh8Mv0RlS9PR3DNgO8IMqCUs7wpdOx8N1
         4s2FoGApJVQOTF9P8LHQgWb4qzjjoIIx//e2VNPL3+nnkrmE/hi8c7xBNCboztrf4zbm
         3Nz6ZL34zjkEDMXX/U68wtTKEZexjMQBLg3Rkdm3tpdTDE4ggr2Zok3ltaVL1pxi3GZt
         CRhv6y4Kc5n1qIx0/dUnXyGF3xFZcBRASFMazSzIOK3rnv2ZF6C9TJJO9tCs6khitA2Q
         oRNg==
X-Gm-Message-State: APjAAAV5vi/QlsQuU9khxV7MeQYfPvcbqf5OGlmzHrc3rI4qhNOi1Qtj
        daa/pWB6qhrxW9gnp63lWtSP6ngfckc3U2sfyo0=
X-Google-Smtp-Source: APXvYqytRvSGXPWUuop07pHcGjG3SqMoK6kaJugGE40KgcI3ho0s3kDM604BRnKN98+RZdamFAv6b3DBCaNpyly7YLc=
X-Received: by 2002:ac8:7401:: with SMTP id p1mr10966238qtq.141.1570123817595;
 Thu, 03 Oct 2019 10:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <20191001214141.6294-1-cneirabustos@gmail.com> <20191001214141.6294-3-cneirabustos@gmail.com>
 <79645731-da32-6071-e05f-6345cf47bcd1@iogearbox.net> <20191003145211.GA3657@frodo.byteswizards.com>
In-Reply-To: <20191003145211.GA3657@frodo.byteswizards.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Oct 2019 10:30:06 -0700
Message-ID: <CAEf4BzZvTvGcyVfM=RB7GA+WHxsDkS+OGmUrNLpMhfa7bMBA1w@mail.gmail.com>
Subject: Re: [PATCH V12 2/4] bpf: added new helper bpf_get_ns_current_pid_tgid
To:     Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        ebiederm@xmission.com, Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 8:01 AM Carlos Antonio Neira Bustos
<cneirabustos@gmail.com> wrote:
>
> On Wed, Oct 02, 2019 at 12:52:29PM +0200, Daniel Borkmann wrote:
> > On 10/1/19 11:41 PM, Carlos Neira wrote:
> > > New bpf helper bpf_get_ns_current_pid_tgid,
> > > This helper will return pid and tgid from current task
> > > which namespace matches dev_t and inode number provided,
> > > this will allows us to instrument a process inside a container.
> > >
> > > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > > ---
> > >   include/linux/bpf.h      |  1 +
> > >   include/uapi/linux/bpf.h | 18 +++++++++++++++++-
> > >   kernel/bpf/core.c        |  1 +
> > >   kernel/bpf/helpers.c     | 36 ++++++++++++++++++++++++++++++++++++
> > >   kernel/trace/bpf_trace.c |  2 ++
> > >   5 files changed, 57 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index 5b9d22338606..231001475504 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -1055,6 +1055,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
> > >   extern const struct bpf_func_proto bpf_strtol_proto;
> > >   extern const struct bpf_func_proto bpf_strtoul_proto;
> > >   extern const struct bpf_func_proto bpf_tcp_sock_proto;
> > > +extern const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto;
> > >   /* Shared helpers among cBPF and eBPF. */
> > >   void bpf_user_rnd_init_once(void);
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index 77c6be96d676..ea8145d7f897 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -2750,6 +2750,21 @@ union bpf_attr {
> > >    *                **-EOPNOTSUPP** kernel configuration does not enable SYN cookies
> > >    *
> > >    *                **-EPROTONOSUPPORT** IP packet version is not 4 or 6
> > > + *
> > > + * u64 bpf_get_ns_current_pid_tgid(u64 dev, u64 inum)
> > > + * Return
> > > + *         A 64-bit integer containing the current tgid and pid from current task
> > > + *              which namespace inode and dev_t matches , and is create as such:
> > > + *         *current_task*\ **->tgid << 32 \|**
> > > + *         *current_task*\ **->pid**.
> > > + *
> > > + *         On failure, the returned value is one of the following:
> > > + *
> > > + *         **-EINVAL** if dev and inum supplied don't match dev_t and inode number
> > > + *              with nsfs of current task, or if dev conversion to dev_t lost high bits.
> > > + *
> > > + *         **-ENOENT** if /proc/self/ns does not exists.
> > > + *
> > >    */
> > >   #define __BPF_FUNC_MAPPER(FN)             \
> > >     FN(unspec),                     \
> > > @@ -2862,7 +2877,8 @@ union bpf_attr {
> > >     FN(sk_storage_get),             \
> > >     FN(sk_storage_delete),          \
> > >     FN(send_signal),                \
> > > -   FN(tcp_gen_syncookie),
> > > +   FN(tcp_gen_syncookie),          \
> > > +   FN(get_ns_current_pid_tgid),
> > >   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > >    * function eBPF program intends to call
> > > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > > index 66088a9e9b9e..b2fd5358f472 100644
> > > --- a/kernel/bpf/core.c
> > > +++ b/kernel/bpf/core.c
> > > @@ -2042,6 +2042,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
> > >   const struct bpf_func_proto bpf_get_current_comm_proto __weak;
> > >   const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
> > >   const struct bpf_func_proto bpf_get_local_storage_proto __weak;
> > > +const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto __weak;
> > >   const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
> > >   {
> > > diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> > > index 5e28718928ca..8777181d1717 100644
> > > --- a/kernel/bpf/helpers.c
> > > +++ b/kernel/bpf/helpers.c
> > > @@ -11,6 +11,8 @@
> > >   #include <linux/uidgid.h>
> > >   #include <linux/filter.h>
> > >   #include <linux/ctype.h>
> > > +#include <linux/pid_namespace.h>
> > > +#include <linux/proc_ns.h>
> > >   #include "../../lib/kstrtox.h"
> > > @@ -487,3 +489,37 @@ const struct bpf_func_proto bpf_strtoul_proto = {
> > >     .arg4_type      = ARG_PTR_TO_LONG,
> > >   };
> > >   #endif
> > > +
> > > +BPF_CALL_2(bpf_get_ns_current_pid_tgid, u64, dev, u64, inum)
> > > +{
> > > +   struct task_struct *task = current;
> > > +   struct pid_namespace *pidns;
> > > +   pid_t pid, tgid;
> > > +
> > > +   if ((u64)(dev_t)dev != dev)
> > > +           return -EINVAL;
> > > +
> > > +   if (unlikely(!task))
> > > +           return -EINVAL;
> > > +
> > > +   pidns = task_active_pid_ns(task);
> > > +   if (unlikely(!pidns))
> > > +           return -ENOENT;
> > > +
> > > +
> > > +   if (!ns_match(&pidns->ns, (dev_t)dev, inum))
> > > +           return -EINVAL;
> > > +
> > > +   pid = task_pid_nr_ns(task, pidns);
> > > +   tgid = task_tgid_nr_ns(task, pidns);
> > > +
> > > +   return (u64) tgid << 32 | pid;
> >
> > Basically here you are overlapping the 64-bit return value for the valid
> > outcome with the error codes above for the invalid case. If you look at
> > bpf_perf_event_read() we already had such broken occasion that bit us in
> > the past, and needed to introduce bpf_perf_event_read_value() instead.
> > Lets not go there again and design it similarly to the latter.
> >
> > > +}
> > > +
> > > +const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto = {
> > > +   .func           = bpf_get_ns_current_pid_tgid,
> > > +   .gpl_only       = false,
> > > +   .ret_type       = RET_INTEGER,
> > > +   .arg1_type      = ARG_ANYTHING,
> > > +   .arg2_type      = ARG_ANYTHING,
> > > +};
> > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > index 44bd08f2443b..32331a1dcb6d 100644
> > > --- a/kernel/trace/bpf_trace.c
> > > +++ b/kernel/trace/bpf_trace.c
> > > @@ -735,6 +735,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > >   #endif
> > >     case BPF_FUNC_send_signal:
> > >             return &bpf_send_signal_proto;
> > > +   case BPF_FUNC_get_ns_current_pid_tgid:
> > > +           return &bpf_get_ns_current_pid_tgid_proto;
> > >     default:
> > >             return NULL;
> > >     }
> > >
> >
> Daniel,
> If I understand correctly, to avoid problems I need to change the helper's function signature to something like the following:
>
> struct bpf_ns_current_pid_tgid_storage {
>         __u64 dev;
>         __u64 inum;
>         __u64 pidtgid;

if you do it this way, please do

__u32 pid;
__u34 tgid;

I have to look up where pid and tgid is in that 64-bit number every
single time, let's not do it here for no good reason.

> };
>
> BPF_CALL_2(bpf_get_ns_current_pid_tgid,
>            struct bpf_ns_current_pid_tgid_storage *, buf, u32, size);
>
> then use dev and inum provided by the user and return the requested
> value into pidtgid of the struct. Would that work?
>
> Thanks for your help.
>
>
>
>
