Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46FC1963CF
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbfHTPKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:10:49 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37520 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfHTPKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 11:10:49 -0400
Received: by mail-qk1-f196.google.com with SMTP id s14so4777822qkm.4;
        Tue, 20 Aug 2019 08:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZzrXH/OTAoz3na8tK/IErTDIaI4QDIyFiN1rHrMvGCw=;
        b=R7/ZlH8QwjCZyHZVhEyO+V1AMs+aPYdTcO4vbybJV04WVfRYQsU/ZogQx23ufLRF5O
         oZl/mfoXliPECQMlvDI5ZiUfl5nFamhC2Le4xZqUeVxfP3bcHFS+Ir6ppOD74efBqnEi
         ToAr+3eXq8jxOzlMcxRrM78orMywFDBfdUjn4iTsbuad+d3tZzry6xA1GsZuibfGqXxi
         19NqVyp94ow8vfCMDPSfSHq1wh1JiwoN+QlhmjyqnmFDYY8hJN1ejfSJgQcgmrMoq70y
         z6LZIdXCi4IAMwmJpQZYzo6MvhY/YfCu3ozdMtr72RoI3n4K6Tuk8oBd4GI8mm4Owxtr
         7+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZzrXH/OTAoz3na8tK/IErTDIaI4QDIyFiN1rHrMvGCw=;
        b=sMaiLXt8iE0C9l9q131DTgAcSLuxty2NcuzyRpsFbLh6X6rsu0plPAFWueSMieQjsw
         LlRzSmyyd8WkcRung64TG+Yj8dA3XuO3AzGduOlXh2T6/Y5ayTcyQbwzdae3yq0ccfrz
         8BePxiaIKeyLIlYfdrHDWsaL9zl8IQq+Kx8O4E3bxznjKl2dw5RGbX2fL2aMDC1I8hdk
         gqJnj/+koJcyrpE+pxKmkq0r98nePzaRNianDoDH92rIRmYTuHRIhjyLQbEDCHwweMZk
         d87kIufA7KpYaaNJcrhOrddzjaJ9SN61N8ZWwjXe9KvlC50MRnkP9pDpp1Q/xwOgzxfD
         g8MA==
X-Gm-Message-State: APjAAAU7WIvcfU7K24HJtvnIcivFdXQQ/bDVKIZm2adrBxXMn7IYZOc1
        wXTA3w/AZWGjjZA3pLpWI/M=
X-Google-Smtp-Source: APXvYqzLih+CT7OuuYuy7Se/O/4vNJCGDkDBwV+UmtGQq8fBNc1iBMKnLZrJ7kr44F4MbgIhNVb2zw==
X-Received: by 2002:a37:5fc6:: with SMTP id t189mr26142588qkb.483.1566313846999;
        Tue, 20 Aug 2019 08:10:46 -0700 (PDT)
Received: from localhost ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id x3sm8654588qkl.71.2019.08.20.08.10.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 08:10:46 -0700 (PDT)
Date:   Tue, 20 Aug 2019 15:10:42 +0000
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next V9 1/3] bpf: new helper to obtain namespace data
 from current task
Message-ID: <20190820151040.GA53610@localhost>
References: <20190813184747.12225-1-cneirabustos@gmail.com>
 <20190813184747.12225-2-cneirabustos@gmail.com>
 <445a4535-b8cc-b6bc-717b-a5736030533a@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <445a4535-b8cc-b6bc-717b-a5736030533a@fb.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yonghong,

Thanks for taking the time to review this.


> > + *
> > + *		**-EINVAL** if *size_of_pidns* is not valid or unable to get ns, pid
> > + *		or tgid of the current task.
> > + *
> > + *		**-ECHILD** if /proc/self/ns/pid does not exists.
> > + *
> > + *		**-ENOTDIR** if /proc/self/ns does not exists.
> 
> Let us remove ECHILD and ENOTDIR and replace it with ENOENT as I
> described below.
> 
> Please *do verify* what happens when namespaces or pid_ns are not
> configured.
>


I have tested kernel configurations without namespace support and with 
namespace support but without pid namespaces, the helper returns -EINVAL
on both cases, now it should return -ENOENT.


> > +struct bpf_pidns_info {
> > +	__u32 dev;
> 
> Please add a comment for dev for how device major and minor number are 
> derived. User space gets device major and minor number, they need to
> compare to the corresponding major/minor numbers returned by this helper.
> 
> > +	__u32 nsid;
> > +	__u32 tgid;
> > +	__u32 pid;
> > +};
>

What do you think of this comment ?

struct bpf_pidns_info {
	__u32 dev;	/* major/minor numbers from /proc/self/ns/pid.
			 * User space gets device major and minor numbers from
			 * the same device that need to be compared against the
			 * major/minor numbers returned by this helper.
			 */
	__u32 nsid;
	__u32 tgid;
	__u32 pid;
};

> 
> Please put an empty line. As a general rule for readability,
> put an empty line if control flow is interrupted, e.g., by
> "return", "break" or "continue". At least this is what
> I saw most in bpf mailing list.
>
I'll fix it in version 10.

> > +	len = strlen(pidns_path) + 1;
> > +	memcpy((char *)tmp->name, pidns_path, len);
> > +	tmp->uptr = NULL;
> > +	tmp->aname = NULL;
> > +	tmp->refcnt = 1;
> > +	ret = filename_lookup(AT_FDCWD, tmp, 0, &kp, NULL);
> Adding below to free kmem cache memory
> 	kmem_cache_free(names_cachep, fname);
> 

I think we don't need to call kmem_cache_free as filename_lookup
calls putname that calls kmem_cache_free. 


Thanks a lot for your help.

Bests

> In the above, we checked task_active_pid_ns().
> If not returning NULL, we have a valid pid ns. So the above
> filename_lookup should not go wrong. We can still keep
> the error checking though.
> 
> > +	if (ret) {
> > +		memset((void *)pidns_info, 0, (size_t) size);
> > +		return ret;
> 
>

I think we could get rid of this.


On Tue, Aug 13, 2019 at 10:35:42PM +0000, Yonghong Song wrote:
> 
> 
> On 8/13/19 11:47 AM, Carlos Neira wrote:
> > From: Carlos <cneirabustos@gmail.com>
> > 
> > New bpf helper bpf_get_current_pidns_info.
> > This helper obtains the active namespace from current and returns
> > pid, tgid, device and namespace id as seen from that namespace,
> > allowing to instrument a process inside a container.
> > 
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > ---
> >   fs/internal.h            |  2 --
> >   fs/namei.c               |  1 -
> >   include/linux/bpf.h      |  1 +
> >   include/linux/namei.h    |  4 +++
> >   include/uapi/linux/bpf.h | 31 ++++++++++++++++++++++-
> >   kernel/bpf/core.c        |  1 +
> >   kernel/bpf/helpers.c     | 64 ++++++++++++++++++++++++++++++++++++++++++++++++
> >   kernel/trace/bpf_trace.c |  2 ++
> >   8 files changed, 102 insertions(+), 4 deletions(-)
> 
> I prefer to break this into two patches to reduce
> the potential merging conflicts:
>    patch 1: fs/internal.h, fs/namei.c, include/linux/namei.h
>    patch 2: rest of changes
> patch 1 is simply a preparing patches to make filename_lookup
> available later.
> 
> > 
> > diff --git a/fs/internal.h b/fs/internal.h
> > index 315fcd8d237c..6647e15dd419 100644
> > --- a/fs/internal.h
> > +++ b/fs/internal.h
> > @@ -59,8 +59,6 @@ extern int finish_clean_context(struct fs_context *fc);
> >   /*
> >    * namei.c
> >    */
> > -extern int filename_lookup(int dfd, struct filename *name, unsigned flags,
> > -			   struct path *path, struct path *root);
> >   extern int user_path_mountpoint_at(int, const char __user *, unsigned int, struct path *);
> >   extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
> >   			   const char *, unsigned int, struct path *);
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 209c51a5226c..a89fc72a4a10 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -19,7 +19,6 @@
> >   #include <linux/export.h>
> >   #include <linux/kernel.h>
> >   #include <linux/slab.h>
> > -#include <linux/fs.h>
> >   #include <linux/namei.h>
> >   #include <linux/pagemap.h>
> >   #include <linux/fsnotify.h>
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index f9a506147c8a..e4adf5e05afd 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1050,6 +1050,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
> >   extern const struct bpf_func_proto bpf_strtol_proto;
> >   extern const struct bpf_func_proto bpf_strtoul_proto;
> >   extern const struct bpf_func_proto bpf_tcp_sock_proto;
> > +extern const struct bpf_func_proto bpf_get_current_pidns_info_proto;
> >   
> >   /* Shared helpers among cBPF and eBPF. */
> >   void bpf_user_rnd_init_once(void);
> > diff --git a/include/linux/namei.h b/include/linux/namei.h
> > index 9138b4471dbf..b45c8b6f7cb4 100644
> > --- a/include/linux/namei.h
> > +++ b/include/linux/namei.h
> > @@ -6,6 +6,7 @@
> >   #include <linux/path.h>
> >   #include <linux/fcntl.h>
> >   #include <linux/errno.h>
> > +#include <linux/fs.h>
> >   
> >   enum { MAX_NESTED_LINKS = 8 };
> >   
> > @@ -97,6 +98,9 @@ extern void unlock_rename(struct dentry *, struct dentry *);
> >   
> >   extern void nd_jump_link(struct path *path);
> >   
> > +extern int filename_lookup(int dfd, struct filename *name, unsigned flags,
> > +			   struct path *path, struct path *root);
> > +
> >   static inline void nd_terminate_link(void *name, size_t len, size_t maxlen)
> >   {
> >   	((char *) name)[min(len, maxlen)] = '\0';
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 4393bd4b2419..db241857ec15 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2741,6 +2741,28 @@ union bpf_attr {
> >    *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
> >    *
> >    *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
> > + *
> > + * int bpf_get_current_pidns_info(struct bpf_pidns_info *pidns, u32 size_of_pidns)
> 
> size_of_pidns => size.
> 
> > + *	Description
> > + *		Copies into *pidns* pid, namespace id and tgid as seen by the
> Copies => Copy.
> Maybe something like below:
> Get tgid, pid and namespace id as seen by the current namespace, and 
> device major/minor numbers from device /proc/self/ns/pid. Such
> information is stored in *pidns* of size *size*.
> 
> > + *		current namespace and also device from /proc/self/ns/pid.
> > + *		*size_of_pidns* must be the size of *pidns*
> > + *
> > + *		This helper is used when pid filtering is needed inside a
> > + *		container as bpf_get_current_tgid() helper returns always the
> 
> returns always => always returns.
> 
> > + *		pid id as seen by the root namespace.
> > + *	Return
> > + *		0 on success
> > + *
> > + *		**-EINVAL** if *size_of_pidns* is not valid or unable to get ns, pid
> > + *		or tgid of the current task.
> > + *
> > + *		**-ECHILD** if /proc/self/ns/pid does not exists.
> > + *
> > + *		**-ENOTDIR** if /proc/self/ns does not exists.
> 
> Let us remove ECHILD and ENOTDIR and replace it with ENOENT as I
> described below.
> 
> Please *do verify* what happens when namespaces or pid_ns are not
> configured.
> 
> > + *
> > + *		**-ENOMEM**  if allocation fails.
> 
> helper internal allocation fails.
> 
> > + *
> >    */
> >   #define __BPF_FUNC_MAPPER(FN)		\
> >   	FN(unspec),			\
> > @@ -2853,7 +2875,8 @@ union bpf_attr {
> >   	FN(sk_storage_get),		\
> >   	FN(sk_storage_delete),		\
> >   	FN(send_signal),		\
> > -	FN(tcp_gen_syncookie),
> > +	FN(tcp_gen_syncookie),		\
> > +	FN(get_current_pidns_info),
> >   
> >   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> >    * function eBPF program intends to call
> > @@ -3604,4 +3627,10 @@ struct bpf_sockopt {
> >   	__s32	retval;
> >   };
> >   
> > +struct bpf_pidns_info {
> > +	__u32 dev;
> 
> Please add a comment for dev for how device major and minor number are 
> derived. User space gets device major and minor number, they need to
> compare to the corresponding major/minor numbers returned by this helper.
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
> > index 5e28718928ca..41fbf1f28a48 100644
> > --- a/kernel/bpf/helpers.c
> > +++ b/kernel/bpf/helpers.c
> > @@ -11,6 +11,12 @@
> >   #include <linux/uidgid.h>
> >   #include <linux/filter.h>
> >   #include <linux/ctype.h>
> > +#include <linux/pid_namespace.h>
> > +#include <linux/major.h>
> > +#include <linux/stat.h>
> > +#include <linux/namei.h>
> > +#include <linux/version.h>
> > +
> >   
> >   #include "../../lib/kstrtox.h"
> >   
> > @@ -312,6 +318,64 @@ void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
> >   	preempt_enable();
> >   }
> >   
> > +BPF_CALL_2(bpf_get_current_pidns_info, struct bpf_pidns_info *, pidns_info, u32,
> > +	 size)
> > +{
> > +	const char *pidns_path = "/proc/self/ns/pid";
> > +	struct pid_namespace *pidns = NULL;
> > +	struct filename *tmp = NULL;
> 
> tmp => fname
> 
> > +	struct inode *inode;
> > +	struct path kp;
> > +	pid_t tgid = 0;
> > +	pid_t pid = 0;
> > +	int ret;
> > +	int len;
> > +
> > +	if (unlikely(size != sizeof(struct bpf_pidns_info)))
> > +		return -EINVAL;
> 
> Please put an empty line. As a general rule for readability,
> put an empty line if control flow is interrupted, e.g., by
> "return", "break" or "continue". At least this is what
> I saw most in bpf mailing list.
> 
> > +	pidns = task_active_pid_ns(current);
> > +	if (unlikely(!pidns))
> > +		goto clear;
> 
> An empty line. Also, there is nothing to clear.
> I prefer an error code -ENOENT.
> 
> You can set
> 	ret = -EINVAL;
> here
> 
> > +	pidns_info->nsid =  pidns->ns.inum;
> > +	pid = task_pid_nr_ns(current, pidns);
> > +	if (unlikely(!pid))
> > +		goto clear;
> 
> An empty line.
> 
> > +	tgid = task_tgid_nr_ns(current, pidns);
> > +	if (unlikely(!tgid))
> > +		goto clear;
> 
> An empty line.
> 
> > +	pidns_info->tgid = (u32) tgid;
> > +	pidns_info->pid = (u32) pid;
> 
> Different functionality, an empty line.
> 
> > +	tmp = kmem_cache_alloc(names_cachep, GFP_ATOMIC);
> > +	if (unlikely(!tmp)) {
> > +		memset((void *)pidns_info, 0, (size_t) size);
> > +		return -ENOMEM;
> 
> ret = -ENOMEM;
> goto clear;
> 
> > +	}
> 
> An empty line.
> 
> > +	len = strlen(pidns_path) + 1;
> > +	memcpy((char *)tmp->name, pidns_path, len);
> > +	tmp->uptr = NULL;
> > +	tmp->aname = NULL;
> > +	tmp->refcnt = 1;
> > +	ret = filename_lookup(AT_FDCWD, tmp, 0, &kp, NULL);
> Adding below to free kmem cache memory
> 	kmem_cache_free(names_cachep, fname);
> 
> In the above, we checked task_active_pid_ns().
> If not returning NULL, we have a valid pid ns. So the above
> filename_lookup should not go wrong. We can still keep
> the error checking though.
> 
> > +	if (ret) {
> > +		memset((void *)pidns_info, 0, (size_t) size);
> > +		return ret;
> 
> goto clear;
> 
> > +	}
> 
> An empty line.
> 
> > +	inode = d_backing_inode(kp.dentry);
> > +	pidns_info->dev = inode->i_sb->s_dev;
> > +	return 0;
> 
> An empty line.
> 
> > +clear > +	memset((void *)pidns_info, 0, (size_t) size);
> > +	return -EINVAL;
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
