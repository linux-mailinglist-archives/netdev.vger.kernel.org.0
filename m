Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EABBAAF51A
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 06:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfIKEd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 00:33:56 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42277 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfIKEd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 00:33:56 -0400
Received: by mail-qt1-f193.google.com with SMTP id c17so4303207qtv.9;
        Tue, 10 Sep 2019 21:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8ya/RkghcFeGChOJ4VF6BjHTJqDe4QSzZMyHbHOCjX8=;
        b=dNNKowyb/LTs2d8dKJhbbyjh7v/JmT+66fk5vQ2E21NdvRyJGiyDD4q2a2S8Kaf2Bu
         o+eWWi2NLT+H4CsTrqn5SqQqh5oBESoa2YuiL2v/UnZABCoKsZW6//eaP39GyQlTVian
         +m8Y4LykN5nnPzNFV/zIbJnSkeAgoKZ4EjtB7AV8vtnggfTd2CxTErwNUHRbyUc6ZucB
         YQQVRSsVX5UFtG1qbr/NjNtafvtlUPnmFMtz8xEmsE8yiOIa3OuvN3fLYQ68bgJNpg/G
         KP9oENKP8dJMuCYBQz1Fz8MQKY8fiCqFHc/KSbdpF7RI+fbu3y1pXncd+TjBG0GXe+bX
         M/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8ya/RkghcFeGChOJ4VF6BjHTJqDe4QSzZMyHbHOCjX8=;
        b=RR8EHW11mA/xfQaRfoeIvwSEcnyUfhNInFY1dgmZ+lIYiyeZdC4fmrQAyW5n7+BCvG
         uRmgKlPy4U34I7FGehtfhB35LDlgs7N8rKDIz2KCLKPba4gtYt9pgc9INwQoYG4KQfep
         IE+a0iffq9QOVB7TQks5M9AF9ajusHHxTQg0oeMfA8qV3MnyJUuKWJSpBmUbnNZJMTOk
         TODcqYWr8Al8Jr3EyrdvQQTYsZwUhFzJeX6GsFuW7FR3TwkI3jr36enwKg5+wAfA9WN/
         rE2SZWtjHSrWgtu3+ArSJKksm23LsV6qUEqiUWsMPHLvkucSNW680aAr9IJG4aNz9JPm
         DvxA==
X-Gm-Message-State: APjAAAW0dLReFbT18Bl3/lG6iRen9FkVMlcx+65GAapdZnFRVgAdXwup
        OQR6n1WA9pfm7lO68GpqYNw=
X-Google-Smtp-Source: APXvYqxDxiMbTHdu+04GJHqJ3iNePP0bHyGlTBy+m7LMLtmipM6gEkSMP5IcUhbktuzXcODB5TqXbw==
X-Received: by 2002:ac8:71d9:: with SMTP id i25mr523259qtp.99.1568176434868;
        Tue, 10 Sep 2019 21:33:54 -0700 (PDT)
Received: from frodo.byteswizards.com ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id h7sm6699980qto.16.2019.09.10.21.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 21:33:54 -0700 (PDT)
Date:   Wed, 11 Sep 2019 01:33:50 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace
 data from current task New bpf helper bpf_get_current_pidns_info.
Message-ID: <20190911043350.GB22183@frodo.byteswizards.com>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
 <20190906150952.23066-3-cneirabustos@gmail.com>
 <c5ecd602-8b45-94bd-96e8-2264a88a3c09@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5ecd602-8b45-94bd-96e8-2264a88a3c09@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for reviewing the rest of the code, 
I'll include these changes in ver 11.

Bests 
On Tue, Sep 10, 2019 at 10:46:45PM +0000, Yonghong Song wrote:
> 
> 
> On 9/6/19 4:09 PM, Carlos Neira wrote:
> > This helper(bpf_get_current_pidns_info) obtains the active namespace from
> > current and returns pid, tgid, device and namespace id as seen from that
> > namespace, allowing to instrument a process inside a container.
> > 
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > ---
> >   include/linux/bpf.h      |  1 +
> >   include/uapi/linux/bpf.h | 35 +++++++++++++++++++-
> >   kernel/bpf/core.c        |  1 +
> >   kernel/bpf/helpers.c     | 86 ++++++++++++++++++++++++++++++++++++++++++++++++
> >   kernel/trace/bpf_trace.c |  2 ++
> >   5 files changed, 124 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 5b9d22338606..819cb1c84be0 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1055,6 +1055,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
> >   extern const struct bpf_func_proto bpf_strtol_proto;
> >   extern const struct bpf_func_proto bpf_strtoul_proto;
> >   extern const struct bpf_func_proto bpf_tcp_sock_proto;
> > +extern const struct bpf_func_proto bpf_get_current_pidns_info_proto;
> >   
> >   /* Shared helpers among cBPF and eBPF. */
> >   void bpf_user_rnd_init_once(void);
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index b5889257cc33..3ec9aa1438b7 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2747,6 +2747,32 @@ union bpf_attr {
> >    *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
> >    *
> >    *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
> > + *
> > + * int bpf_get_current_pidns_info(struct bpf_pidns_info *pidns, u32 size_of_pidns)
> > + *	Description
> > + *		Get tgid, pid and namespace id as seen by the current namespace,
> > + *		and device major/minor numbers from /proc/self/ns/pid. Such
> > + *		information is stored in *pidns* of size *size*.
> > + *
> > + *		This helper is used when pid filtering is needed inside a
> > + *		container as bpf_get_current_tgid() helper always returns the
> > + *		pid id as seen by the root namespace.
> > + *	Return
> > + *		0 on success
> > + *
> > + *		On failure, the returned value is one of the following:
> > + *
> > + *		**-EINVAL** if *size_of_pidns* is not valid or unable to get ns, pid
> > + *		or tgid of the current task.
> > + *
> > + *		**-ENOENT** if /proc/self/ns/pid does not exists.
> > + *
> > + *		**-ENOENT** if /proc/self/ns does not exists.
> > + *
> > + *		**-ENOMEM** if helper internal allocation fails.
> 
> -ENOMEM can be removed.
> 
> > + *
> > + *		**-EPERM** if not able to call helper.
> > + *
> >    */
> >   #define __BPF_FUNC_MAPPER(FN)		\
> >   	FN(unspec),			\
> > @@ -2859,7 +2885,8 @@ union bpf_attr {
> >   	FN(sk_storage_get),		\
> >   	FN(sk_storage_delete),		\
> >   	FN(send_signal),		\
> > -	FN(tcp_gen_syncookie),
> > +	FN(tcp_gen_syncookie),		\
> > +	FN(get_current_pidns_info),
> >   
> >   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> >    * function eBPF program intends to call
> > @@ -3610,4 +3637,10 @@ struct bpf_sockopt {
> >   	__s32	retval;
> >   };
> >   
> > +struct bpf_pidns_info {
> > +	__u32 dev;	/* dev_t from /proc/self/ns/pid inode */
> 
>     /* dev_t of pid namespace pseudo file (typically /proc/seelf/ns/pid) 
> after following symbolic link */
> 
> > +	__u32 nsid;
> > +	__u32 tgid;
> > +	__u32 pid;
> > +};
> >   #endif /* _UAPI__LINUX_BPF_H__ */
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 8191a7db2777..3159f2a0188c 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -2038,6 +2038,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
> >   const struct bpf_func_proto bpf_get_current_comm_proto __weak;
> >   const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
> >   const struct bpf_func_proto bpf_get_local_storage_proto __weak;
> > +const struct bpf_func_proto bpf_get_current_pidns_info __weak;
> >   
> >   const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
> >   {
> > diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> > index 5e28718928ca..8dbe6347893c 100644
> > --- a/kernel/bpf/helpers.c
> > +++ b/kernel/bpf/helpers.c
> > @@ -11,6 +11,11 @@
> >   #include <linux/uidgid.h>
> >   #include <linux/filter.h>
> >   #include <linux/ctype.h>
> > +#include <linux/pid_namespace.h>
> > +#include <linux/kdev_t.h>
> > +#include <linux/stat.h>
> > +#include <linux/namei.h>
> > +#include <linux/version.h>
> >   
> >   #include "../../lib/kstrtox.h"
> >   
> > @@ -312,6 +317,87 @@ void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
> >   	preempt_enable();
> >   }
> >   
> > +BPF_CALL_2(bpf_get_current_pidns_info, struct bpf_pidns_info *, pidns_info, u32,
> > +	 size)
> > +{
> > +	const char *pidns_path = "/proc/self/ns/pid";
> > +	struct pid_namespace *pidns = NULL;
> > +	struct filename *fname = NULL;
> > +	struct inode *inode;
> > +	struct path kp;
> > +	pid_t tgid = 0;
> > +	pid_t pid = 0;
> > +	int ret = -EINVAL;
> > +	int len;
> > +
> > +	if (unlikely(in_interrupt() ||
> > +			current->flags & (PF_KTHREAD | PF_EXITING)))
> > +		return -EPERM;
> > +
> > +	if (unlikely(size != sizeof(struct bpf_pidns_info)))
> > +		return -EINVAL;
> > +
> > +	pidns = task_active_pid_ns(current);
> > +	if (unlikely(!pidns))
> > +		return -ENOENT;
> > +
> > +	pidns_info->nsid =  pidns->ns.inum;
> > +	pid = task_pid_nr_ns(current, pidns);
> > +	if (unlikely(!pid))
> > +		goto clear;
> > +
> > +	tgid = task_tgid_nr_ns(current, pidns);
> > +	if (unlikely(!tgid))
> > +		goto clear;
> > +
> > +	pidns_info->tgid = (u32) tgid;
> > +	pidns_info->pid = (u32) pid;
> > +
> [...]
> > +	fname = kmem_cache_alloc(names_cachep, GFP_ATOMIC);
> > +	if (unlikely(!fname)) {
> > +		ret = -ENOMEM;
> > +		goto clear;
> > +	}
> > +	const size_t fnamesize = offsetof(struct filename, iname[1]);
> > +	struct filename *tmp;
> > +
> > +	tmp = kmalloc(fnamesize, GFP_ATOMIC);
> > +	if (unlikely(!tmp)) {
> > +		__putname(fname);
> > +		ret = -ENOMEM;
> > +		goto clear;
> > +	}
> > +
> > +	tmp->name = (char *)fname;
> > +	fname = tmp;
> > +	len = strlen(pidns_path) + 1;
> > +	memcpy((char *)fname->name, pidns_path, len);
> > +	fname->uptr = NULL;
> > +	fname->aname = NULL;
> > +	fname->refcnt = 1;
> > +
> > +	ret = filename_lookup(AT_FDCWD, fname, 0, &kp, NULL);
> > +	if (ret)
> > +		goto clear;
> > +
> > +	inode = d_backing_inode(kp.dentry);
> > +	pidns_info->dev = (u32)inode->i_rdev;
> The above can bee replaced with new nsfs interface function
> ns_get_inum_dev().
> > +
> > +	return 0;
> > +
> > +clear:
> > +	memset((void *)pidns_info, 0, (size_t) size);
> > +	return ret;
> > +}
> > +
> > +const struct bpf_func_proto bpf_get_current_pidns_info_proto = {
> > +	.func		= bpf_get_current_pidns_info,
> > +	.gpl_only	= false,
> > +	.ret_type	= RET_INTEGER,
> > +	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
> > +	.arg2_type	= ARG_CONST_SIZE,
> > +};
> > +
> >   #ifdef CONFIG_CGROUPS
> >   BPF_CALL_0(bpf_get_current_cgroup_id)
> >   {
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index ca1255d14576..5e1dc22765a5 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -709,6 +709,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >   #endif
> >   	case BPF_FUNC_send_signal:
> >   		return &bpf_send_signal_proto;
> > +	case BPF_FUNC_get_current_pidns_info:
> > +		return &bpf_get_current_pidns_info_proto;
> >   	default:
> >   		return NULL;
> >   	}
> > 
