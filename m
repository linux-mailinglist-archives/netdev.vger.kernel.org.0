Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA5E8C550
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 02:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfHNA4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 20:56:13 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38870 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfHNA4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 20:56:12 -0400
Received: by mail-qk1-f194.google.com with SMTP id u190so17625717qkh.5;
        Tue, 13 Aug 2019 17:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wSVU7X6FDHSzGui+U01+dU0a8uqfo3Om7EwOJxgXvjg=;
        b=cO5oYCHY9B8BqdUuyrs3V4uWB1YQIukhe0i/njLz/v710Oy0eocp/HCBcGjgvTVaHC
         KAG1pXoukRPfjgoKzBzshesRlXH2Oxva9veb/H6Z+JjNis7EIT/pvmjr1ri+2t6JqgdE
         spUqAO3k47MSnBPZ0dajVm8D5UGuVHHLbnOZpo53UY9ifiYVhOFFnlqpgXV9/8uw48RR
         MJW82Ji+jI4/hiUosUfhy/YXZv4uzo9rDo/0P9hxQpxC+Pzoe6o8uMBCWxnkrSgLxVSU
         D3pakX1a3xwniOXop4Lp3XTGNx2SINVSFFUBwMyq4dARRNPH1KWlWxM0q3E4lhrx39G9
         JBEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wSVU7X6FDHSzGui+U01+dU0a8uqfo3Om7EwOJxgXvjg=;
        b=m/uRyUzkSZUCg+c7xRsvzB841zI/J4vJtvp5FyymkFVGXgJRGs4cQGRbomj8jwZMA7
         WPBJutCUmhdKQPNmmeh235PM8tY96O9kIH8EmDeM0ASh518bGf1qvYaBvfz6Itghy21b
         ftGfdJnwVFvSHHMWBayJjZuloEDjoBZrM8iDXxMZYShHim6uzDwD40oru6CvegPSc3ax
         ZcksIFzd27kaKk3ttW7dSJtb6y79lqnpDsyxtuCBiv3jaIQ9/tH+27AWR+3ZA0GUa9IR
         oV60jQzJPlnaJaJwaiX8CXc8nZQ1unju+SGDuMV/82fHwZVj113/J/4Iq2Wbqvj46nY6
         SCcA==
X-Gm-Message-State: APjAAAW2XoEGkxUSO1C4AOFU716jDsZo/Bg92K9BMT3umpTehgES40Bi
        LGY3s3cEUKrlEawadcRUc4s=
X-Google-Smtp-Source: APXvYqwAXDoEai916wiIMXb+JdOnBMkZJH+sp6XQPnTBVLnrmCO6hNgNnvZXwq+7V7jz8t4Kxt0YHw==
X-Received: by 2002:a37:83c4:: with SMTP id f187mr35101968qkd.380.1565744171141;
        Tue, 13 Aug 2019 17:56:11 -0700 (PDT)
Received: from dev00 ([190.162.109.53])
        by smtp.gmail.com with ESMTPSA id k25sm61524808qta.78.2019.08.13.17.56.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 13 Aug 2019 17:56:10 -0700 (PDT)
Date:   Tue, 13 Aug 2019 20:56:06 -0400
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next V9 1/3] bpf: new helper to obtain namespace data
 from current task
Message-ID: <20190814005604.yeqb45uv2fc3anab@dev00>
References: <20190813184747.12225-1-cneirabustos@gmail.com>
 <20190813184747.12225-2-cneirabustos@gmail.com>
 <13b7f81f-83b6-07c9-4864-b49749cbf7d9@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13b7f81f-83b6-07c9-4864-b49749cbf7d9@fb.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 11:11:14PM +0000, Yonghong Song wrote:
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
> > + *	Description
> > + *		Copies into *pidns* pid, namespace id and tgid as seen by the
> > + *		current namespace and also device from /proc/self/ns/pid.
> > + *		*size_of_pidns* must be the size of *pidns*
> > + *
> > + *		This helper is used when pid filtering is needed inside a
> > + *		container as bpf_get_current_tgid() helper returns always the
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
> > + *
> > + *		**-ENOMEM**  if allocation fails.
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
> > +	struct inode *inode;
> > +	struct path kp;
> > +	pid_t tgid = 0;
> > +	pid_t pid = 0;
> > +	int ret;
> > +	int len;
> 

Thank you very much for catching this!. 
Could you share how to replicate this bug?.

> I am running your sample program and get the following kernel bug:
> 
> ...
> [   26.414825] BUG: sleeping function called from invalid context at 
> /data/users/yhs/work/net-next/fs
> /dcache.c:843
> [   26.416314] in_atomic(): 1, irqs_disabled(): 0, pid: 1911, name: ping
> [   26.417189] CPU: 0 PID: 1911 Comm: ping Tainted: G        W 
> 5.3.0-rc1+ #280
> [   26.418182] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
> BIOS 1.9.3-1.el7.centos 04/01/2
> 014
> [   26.419393] Call Trace:
> [   26.419697]  <IRQ>
> [   26.419960]  dump_stack+0x46/0x5b
> [   26.420434]  ___might_sleep+0xe4/0x110
> [   26.420894]  dput+0x2a/0x200
> [   26.421265]  walk_component+0x10c/0x280
> [   26.421773]  link_path_walk+0x327/0x560
> [   26.422280]  ? proc_ns_dir_readdir+0x1a0/0x1a0
> [   26.422848]  ? path_init+0x232/0x330
> [   26.423364]  path_lookupat+0x88/0x200
> [   26.423808]  ? selinux_parse_skb.constprop.69+0x124/0x430
> [   26.424521]  filename_lookup+0xaf/0x190
> [   26.425031]  ? simple_attr_release+0x20/0x20
> [   26.425560]  bpf_get_current_pidns_info+0xfa/0x190
> [   26.426168]  bpf_prog_83627154cefed596+0xe66/0x1000
> [   26.426779]  trace_call_bpf+0xb5/0x160
> [   26.427317]  ? __netif_receive_skb_core+0x1/0xbb0
> [   26.427929]  ? __netif_receive_skb_core+0x1/0xbb0
> [   26.428496]  kprobe_perf_func+0x4d/0x280
> [   26.428986]  ? tracing_record_taskinfo_skip+0x1a/0x30
> [   26.429584]  ? tracing_record_taskinfo+0xe/0x80
> [   26.430152]  ? ttwu_do_wakeup.isra.114+0xcf/0xf0
> [   26.430737]  ? __netif_receive_skb_core+0x1/0xbb0
> [   26.431334]  ? __netif_receive_skb_core+0x5/0xbb0
> [   26.431930]  kprobe_ftrace_handler+0x90/0xf0
> [   26.432495]  ftrace_ops_assist_func+0x63/0x100
> [   26.433060]  0xffffffffc03180bf
> [   26.433471]  ? __netif_receive_skb_core+0x1/0xbb0
> ...
> 
> To prevent we are running in arbitrary task (e.g., idle task)
> context which may introduce sleeping issues, the following
> probably appropriate:
> 
>         if (in_nmi() || in_softirq())
>                 return -EPERM;
> 
> Anyway, if in nmi or softirq, the namespace and pid/tgid
> we get may be just accidentally associated with the bpf running
> context, but it could be in a different context. So such info
> is not reliable any way.
> 
> > +
> > +	if (unlikely(size != sizeof(struct bpf_pidns_info)))
> > +		return -EINVAL;
> > +	pidns = task_active_pid_ns(current);
> > +	if (unlikely(!pidns))
> > +		goto clear;
> > +	pidns_info->nsid =  pidns->ns.inum;
> > +	pid = task_pid_nr_ns(current, pidns);
> > +	if (unlikely(!pid))
> > +		goto clear;
> > +	tgid = task_tgid_nr_ns(current, pidns);
> > +	if (unlikely(!tgid))
> > +		goto clear;
> > +	pidns_info->tgid = (u32) tgid;
> > +	pidns_info->pid = (u32) pid;
> > +	tmp = kmem_cache_alloc(names_cachep, GFP_ATOMIC);
> > +	if (unlikely(!tmp)) {
> > +		memset((void *)pidns_info, 0, (size_t) size);
> > +		return -ENOMEM;
> > +	}
> > +	len = strlen(pidns_path) + 1;
> > +	memcpy((char *)tmp->name, pidns_path, len);
> > +	tmp->uptr = NULL;
> > +	tmp->aname = NULL;
> > +	tmp->refcnt = 1;
> > +	ret = filename_lookup(AT_FDCWD, tmp, 0, &kp, NULL);
> > +	if (ret) {
> > +		memset((void *)pidns_info, 0, (size_t) size);
> > +		return ret;
> > +	}
> > +	inode = d_backing_inode(kp.dentry);
> > +	pidns_info->dev = inode->i_sb->s_dev;
> > +	return 0;
> > +clear:
> > +	memset((void *)pidns_info, 0, (size_t) size);
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
