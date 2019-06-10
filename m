Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 819123BCFB
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 21:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389151AbfFJTgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 15:36:01 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45710 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388900AbfFJTgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 15:36:01 -0400
Received: by mail-pg1-f196.google.com with SMTP id w34so5545564pga.12
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 12:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+RJaEWUIppVrmeoZyRLRtvOqSSEDiSnEWAGgICbx7GY=;
        b=VCybmA9cAX0i9W14E6rEukh1H2UCMskNeTErRX2hMfbfXR8H2MQfGf51ad68wWqsac
         k1ldgZ/QJ25+5A5YmOc6bqM61bRd/I0zQL9NSofXzeN2mgW8BgKcIWXtgQyWuPlklHGE
         byHkAZTbvFiFiDy+PJKLxPNdqDIxCeQr78npmcwwSv9zr0l7WT+jlC+Fp+Y7c9JwBq84
         i5zlvufCM+FzWcwpaKhsTx573stv3gweJuW1oSnc4Xs+5r7FJ99822oS+/gKZxg3pr60
         o+FO9Snc9/P0kUVXX9mmsmIusppAEif4Pv/whcdT267tenSj/z3vO/KZLSkXxOmtyU2M
         455g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+RJaEWUIppVrmeoZyRLRtvOqSSEDiSnEWAGgICbx7GY=;
        b=DrQmFniSUJkxNRMoueEWqWYStHUwoYP2JF+XFSwzn/mV3q1VcW9eifiPicjfNdnd6u
         n4Hrh6ie/Wl0Xh7J7GVwMsTSX7vOmzwQ0XPVw3VImUr3mRM9xVpeQXNFy2r2FH6N4NDq
         LThCpzAiloTOQO+H3IeoC/TKTc0dpb+haQHS9ClgUvkdia+71kowVXGhL2UDKtJ4MAaI
         KiqbMLihipM/cFP5/Kh+hjJpSXOXC7SdNXSyRwNn2pkSVbgBs4pvQJJsHDCX4bi9/x5E
         HV1Hb1YXMuD0mkZMhl8Zl2UlRUlzFoTraQunG8v64z0klsLMd7G3Y0ZJBEwx5fr10L8E
         0J6Q==
X-Gm-Message-State: APjAAAU7gyYxk2swhTpIDimCs0fwYv2CorGnr+f4xqd2eT6DT69pu59b
        7KfjR9P6fWkK6ZMR9oFHaIGJxnGgjwg=
X-Google-Smtp-Source: APXvYqxxEBWRhv8a1o9h6sL0Dz7ABiJcwwSc0jCAcbR5j7UjFEE1x0dLur4Aes7bDG9dKtND0Njs0w==
X-Received: by 2002:a63:cc4e:: with SMTP id q14mr16833903pgi.84.1560195360231;
        Mon, 10 Jun 2019 12:36:00 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id w62sm12598215pfw.132.2019.06.10.12.35.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 12:35:59 -0700 (PDT)
Date:   Mon, 10 Jun 2019 12:35:58 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Martin Lau <kafai@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v4 1/8] bpf: implement getsockopt and setsockopt
 hooks
Message-ID: <20190610193558.GA9056@mini-arch>
References: <20190610163421.208126-1-sdf@google.com>
 <20190610163421.208126-2-sdf@google.com>
 <20190610190257.z75nsmbf2u7sdgv5@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610190257.z75nsmbf2u7sdgv5@kafai-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/10, Martin Lau wrote:
> On Mon, Jun 10, 2019 at 09:34:14AM -0700, Stanislav Fomichev wrote:
> > Implement new BPF_PROG_TYPE_CGROUP_SOCKOPT program type and
> > BPF_CGROUP_{G,S}ETSOCKOPT cgroup hooks.
> > 
> > BPF_CGROUP_SETSOCKOPT get a read-only view of the setsockopt arguments.
> > BPF_CGROUP_GETSOCKOPT can modify the supplied buffer.
> > Both of them reuse existing PTR_TO_PACKET{,_END} infrastructure.
> > 
> > The buffer memory is pre-allocated (because I don't think there is
> > a precedent for working with __user memory from bpf). This might be
> > slow to do for each {s,g}etsockopt call, that's why I've added
> > __cgroup_bpf_prog_array_is_empty that exits early if there is nothing
> > attached to a cgroup. Note, however, that there is a race between
> > __cgroup_bpf_prog_array_is_empty and BPF_PROG_RUN_ARRAY where cgroup
> > program layout might have changed; this should not be a problem
> > because in general there is a race between multiple calls to
> > {s,g}etsocktop and user adding/removing bpf progs from a cgroup.
> > 
> > The return code of the BPF program is handled as follows:
> > * 0: EPERM
> > * 1: success, execute kernel {s,g}etsockopt path after BPF prog exits
> > * 2: success, do _not_ execute kernel {s,g}etsockopt path after BPF
> >      prog exits
> > 
> > v4:
> > * don't export bpf_sk_fullsock helper (Martin Lau)
> > * size != sizeof(__u64) for uapi pointers (Martin Lau)
> > * offsetof instead of bpf_ctx_range when checking ctx access (Martin Lau)
> > 
> > v3:
> > * typos in BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY comments (Andrii Nakryiko)
> > * reverse christmas tree in BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY (Andrii
> >   Nakryiko)
> > * use __bpf_md_ptr instead of __u32 for optval{,_end} (Martin Lau)
> > * use BPF_FIELD_SIZEOF() for consistency (Martin Lau)
> > * new CG_SOCKOPT_ACCESS macro to wrap repeated parts
> > 
> > v2:
> > * moved bpf_sockopt_kern fields around to remove a hole (Martin Lau)
> > * aligned bpf_sockopt_kern->buf to 8 bytes (Martin Lau)
> > * bpf_prog_array_is_empty instead of bpf_prog_array_length (Martin Lau)
> > * added [0,2] return code check to verifier (Martin Lau)
> > * dropped unused buf[64] from the stack (Martin Lau)
> > * use PTR_TO_SOCKET for bpf_sockopt->sk (Martin Lau)
> > * dropped bpf_target_off from ctx rewrites (Martin Lau)
> > * use return code for kernel bypass (Martin Lau & Andrii Nakryiko)
> > 
> > Cc: Martin Lau <kafai@fb.com>
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/linux/bpf-cgroup.h |  29 ++++
> >  include/linux/bpf.h        |  45 +++++++
> >  include/linux/bpf_types.h  |   1 +
> >  include/linux/filter.h     |  13 ++
> >  include/uapi/linux/bpf.h   |  13 ++
> >  kernel/bpf/cgroup.c        | 262 +++++++++++++++++++++++++++++++++++++
> >  kernel/bpf/core.c          |   9 ++
> >  kernel/bpf/syscall.c       |  19 +++
> >  kernel/bpf/verifier.c      |  15 +++
> >  net/core/filter.c          |   2 +-
> >  net/socket.c               |  18 +++
> >  11 files changed, 425 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> > index b631ee75762d..406f1ba82531 100644
> > --- a/include/linux/bpf-cgroup.h
> > +++ b/include/linux/bpf-cgroup.h
> > @@ -124,6 +124,13 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
> >  				   loff_t *ppos, void **new_buf,
> >  				   enum bpf_attach_type type);
> >  
> > +int __cgroup_bpf_run_filter_setsockopt(struct sock *sock, int level,
> > +				       int optname, char __user *optval,
> > +				       unsigned int optlen);
> > +int __cgroup_bpf_run_filter_getsockopt(struct sock *sock, int level,
> > +				       int optname, char __user *optval,
> > +				       int __user *optlen);
> > +
> >  static inline enum bpf_cgroup_storage_type cgroup_storage_type(
> >  	struct bpf_map *map)
> >  {
> > @@ -280,6 +287,26 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
> >  	__ret;								       \
> >  })
> >  
> > +#define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, optlen)   \
> > +({									       \
> > +	int __ret = 0;							       \
> > +	if (cgroup_bpf_enabled)						       \
> > +		__ret = __cgroup_bpf_run_filter_setsockopt(sock, level,	       \
> > +							   optname, optval,    \
> > +							   optlen);	       \
> > +	__ret;								       \
> > +})
> > +
> > +#define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, optval, optlen)   \
> > +({									       \
> > +	int __ret = 0;							       \
> > +	if (cgroup_bpf_enabled)						       \
> > +		__ret = __cgroup_bpf_run_filter_getsockopt(sock, level,	       \
> > +							   optname, optval,    \
> > +							   optlen);	       \
> > +	__ret;								       \
> > +})
> > +
> >  int cgroup_bpf_prog_attach(const union bpf_attr *attr,
> >  			   enum bpf_prog_type ptype, struct bpf_prog *prog);
> >  int cgroup_bpf_prog_detach(const union bpf_attr *attr,
> > @@ -349,6 +376,8 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
> >  #define BPF_CGROUP_RUN_PROG_SOCK_OPS(sock_ops) ({ 0; })
> >  #define BPF_CGROUP_RUN_PROG_DEVICE_CGROUP(type,major,minor,access) ({ 0; })
> >  #define BPF_CGROUP_RUN_PROG_SYSCTL(head,table,write,buf,count,pos,nbuf) ({ 0; })
> > +#define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, optval, optlen) ({ 0; })
> > +#define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, optlen) ({ 0; })
> >  
> >  #define for_each_cgroup_storage_type(stype) for (; false; )
> >  
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index e5a309e6a400..194a47ca622f 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -520,6 +520,7 @@ struct bpf_prog_array {
> >  struct bpf_prog_array *bpf_prog_array_alloc(u32 prog_cnt, gfp_t flags);
> >  void bpf_prog_array_free(struct bpf_prog_array *progs);
> >  int bpf_prog_array_length(struct bpf_prog_array *progs);
> > +bool bpf_prog_array_is_empty(struct bpf_prog_array *array);
> >  int bpf_prog_array_copy_to_user(struct bpf_prog_array *progs,
> >  				__u32 __user *prog_ids, u32 cnt);
> >  
> > @@ -606,6 +607,49 @@ _out:							\
> >  		_ret;					\
> >  	})
> >  
> > +/* To be used by BPF_PROG_TYPE_CGROUP_SOCKOPT program type.
> > + *
> > + * Expected BPF program return values are:
> > + *   0: return -EPERM to the userspace
> > + *   1: sockopt was not handled by BPF, kernel should do it
> > + *   2: sockopt was handled by BPF, kernel should _not_ do it and return
> > + *      to the userspace instead
> > + *
> > + * Note, that return '0' takes precedence over everything else. In other
> > + * words, if any single program in the prog array has returned 0,
> > + * the userspace will get -EPERM (regardless of what other programs
> > + * return).
> > + *
> > + * The macro itself returns:
> > + *        0: sockopt was not handled by BPF, kernel should do it
> > + *        1: sockopt was handled by BPF, kernel should _not_ do it
> > + *   -EPERM: return error back to userspace
> > + */
> > +#define BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY(array, ctx, func)		\
> > +	({								\
> > +		struct bpf_prog_array_item *_item;			\
> > +		struct bpf_prog_array *_array;				\
> > +		struct bpf_prog *_prog;					\
> > +		u32 _success = 1;					\
> > +		u32 _bypass = 0;					\
> > +		u32 ret;						\
> > +		preempt_disable();					\
> > +		rcu_read_lock();					\
> > +		_array = rcu_dereference(array);			\
> > +		_item = &_array->items[0];				\
> > +		while ((_prog = READ_ONCE(_item->prog))) {		\
> > +			bpf_cgroup_storage_set(_item->cgroup_storage);	\
> > +			ret = func(_prog, ctx);				\
> > +			_success &= (ret > 0);				\
> > +			_bypass |= (ret == 2);				\
> > +			_item++;					\
> > +		}							\
> > +		rcu_read_unlock();					\
> > +		preempt_enable();					\
> > +		ret = _success ? _bypass : -EPERM;			\
> > +		ret;							\
> > +	})
> > +
> >  #define BPF_PROG_RUN_ARRAY(array, ctx, func)		\
> >  	__BPF_PROG_RUN_ARRAY(array, ctx, func, false)
> >  
> > @@ -1054,6 +1098,7 @@ extern const struct bpf_func_proto bpf_spin_unlock_proto;
> >  extern const struct bpf_func_proto bpf_get_local_storage_proto;
> >  extern const struct bpf_func_proto bpf_strtol_proto;
> >  extern const struct bpf_func_proto bpf_strtoul_proto;
> > +extern const struct bpf_func_proto bpf_tcp_sock_proto;
> >  
> >  /* Shared helpers among cBPF and eBPF. */
> >  void bpf_user_rnd_init_once(void);
> > diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> > index 5a9975678d6f..eec5aeeeaf92 100644
> > --- a/include/linux/bpf_types.h
> > +++ b/include/linux/bpf_types.h
> > @@ -30,6 +30,7 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE, raw_tracepoint_writable)
> >  #ifdef CONFIG_CGROUP_BPF
> >  BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_DEVICE, cg_dev)
> >  BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SYSCTL, cg_sysctl)
> > +BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SOCKOPT, cg_sockopt)
> >  #endif
> >  #ifdef CONFIG_BPF_LIRC_MODE2
> >  BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2)
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index 43b45d6db36d..6e64d01e4e36 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -1199,4 +1199,17 @@ struct bpf_sysctl_kern {
> >  	u64 tmp_reg;
> >  };
> >  
> > +struct bpf_sockopt_kern {
> > +	struct sock	*sk;
> > +	u8		*optval;
> > +	u8		*optval_end;
> > +	s32		level;
> > +	s32		optname;
> > +	u32		optlen;
> > +
> > +	/* Small on-stack optval buffer to avoid small allocations.
> > +	 */
> > +	u8 buf[64] __aligned(8);
> > +};
> > +
> >  #endif /* __LINUX_FILTER_H__ */
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 7c6aef253173..afaa7e28d1e4 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -170,6 +170,7 @@ enum bpf_prog_type {
> >  	BPF_PROG_TYPE_FLOW_DISSECTOR,
> >  	BPF_PROG_TYPE_CGROUP_SYSCTL,
> >  	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
> > +	BPF_PROG_TYPE_CGROUP_SOCKOPT,
> >  };
> >  
> >  enum bpf_attach_type {
> > @@ -192,6 +193,8 @@ enum bpf_attach_type {
> >  	BPF_LIRC_MODE2,
> >  	BPF_FLOW_DISSECTOR,
> >  	BPF_CGROUP_SYSCTL,
> > +	BPF_CGROUP_GETSOCKOPT,
> > +	BPF_CGROUP_SETSOCKOPT,
> >  	__MAX_BPF_ATTACH_TYPE
> >  };
> >  
> > @@ -3533,4 +3536,14 @@ struct bpf_sysctl {
> >  				 */
> >  };
> >  
> > +struct bpf_sockopt {
> > +	__bpf_md_ptr(struct bpf_sock *, sk);
> > +	__bpf_md_ptr(void *, optval);
> > +	__bpf_md_ptr(void *, optval_end);
> > +
> > +	__s32	level;
> > +	__s32	optname;
> > +	__u32	optlen;
> > +};
> > +
> >  #endif /* _UAPI__LINUX_BPF_H__ */
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 1b65ab0df457..dcc06edaad7b 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/bpf.h>
> >  #include <linux/bpf-cgroup.h>
> >  #include <net/sock.h>
> > +#include <net/bpf_sk_storage.h>
> >  
> >  DEFINE_STATIC_KEY_FALSE(cgroup_bpf_enabled_key);
> >  EXPORT_SYMBOL(cgroup_bpf_enabled_key);
> > @@ -924,6 +925,142 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
> >  }
> >  EXPORT_SYMBOL(__cgroup_bpf_run_filter_sysctl);
> >  
> > +static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
> > +					     enum bpf_attach_type attach_type)
> > +{
> > +	struct bpf_prog_array *prog_array;
> > +	bool empty;
> > +
> > +	rcu_read_lock();
> > +	prog_array = rcu_dereference(cgrp->bpf.effective[attach_type]);
> > +	empty = bpf_prog_array_is_empty(prog_array);
> > +	rcu_read_unlock();
> > +
> > +	return empty;
> > +}
> > +
> > +static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
> > +{
> > +	if (unlikely(max_optlen > PAGE_SIZE))
> > +		return -EINVAL;
> > +
> > +	if (likely(max_optlen <= sizeof(ctx->buf))) {
> > +		ctx->optval = ctx->buf;
> > +	} else {
> > +		ctx->optval = kzalloc(max_optlen, GFP_USER);
> > +		if (!ctx->optval)
> > +			return -ENOMEM;
> > +	}
> > +
> > +	ctx->optval_end = ctx->optval + max_optlen;
> > +	ctx->optlen = max_optlen;
> > +
> > +	return 0;
> > +}
> > +
> > +static void sockopt_free_buf(struct bpf_sockopt_kern *ctx)
> > +{
> > +	if (unlikely(ctx->optval != ctx->buf))
> > +		kfree(ctx->optval);
> > +}
> > +
> > +int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int level,
> > +				       int optname, char __user *optval,
> > +				       unsigned int optlen)
> > +{
> > +	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > +	struct bpf_sockopt_kern ctx = {
> > +		.sk = sk,
> > +		.level = level,
> > +		.optname = optname,
> > +	};
> > +	int ret;
> > +
> > +	/* Opportunistic check to see whether we have any BPF program
> > +	 * attached to the hook so we don't waste time allocating
> > +	 * memory and locking the socket.
> > +	 */
> > +	if (__cgroup_bpf_prog_array_is_empty(cgrp, BPF_CGROUP_SETSOCKOPT))
> > +		return 0;
> > +
> > +	ret = sockopt_alloc_buf(&ctx, optlen);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (copy_from_user(ctx.optval, optval, optlen) != 0) {
> > +		sockopt_free_buf(&ctx);
> > +		return -EFAULT;
> > +	}
> > +
> > +	lock_sock(sk);
> > +	ret = BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY(
> > +		cgrp->bpf.effective[BPF_CGROUP_SETSOCKOPT],
> > +		&ctx, BPF_PROG_RUN);
> > +	release_sock(sk);
> > +
> > +	sockopt_free_buf(&ctx);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(__cgroup_bpf_run_filter_setsockopt);
> > +
> > +int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
> > +				       int optname, char __user *optval,
> > +				       int __user *optlen)
> > +{
> > +	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > +	struct bpf_sockopt_kern ctx = {
> > +		.sk = sk,
> > +		.level = level,
> > +		.optname = optname,
> > +	};
> > +	int max_optlen;
> > +	int ret;
> > +
> > +	/* Opportunistic check to see whether we have any BPF program
> > +	 * attached to the hook so we don't waste time allocating
> > +	 * memory and locking the socket.
> > +	 */
> > +	if (__cgroup_bpf_prog_array_is_empty(cgrp, BPF_CGROUP_GETSOCKOPT))
> > +		return 0;
> > +
> > +	if (get_user(max_optlen, optlen))
> > +		return -EFAULT;
> > +
> > +	ret = sockopt_alloc_buf(&ctx, max_optlen);
> > +	if (ret)
> > +		return ret;
> > +
> > +	lock_sock(sk);
> > +	ret = BPF_PROG_CGROUP_SOCKOPT_RUN_ARRAY(
> > +		cgrp->bpf.effective[BPF_CGROUP_GETSOCKOPT],
> > +		&ctx, BPF_PROG_RUN);
> > +	release_sock(sk);
> > +
> > +	if (ret < 0) {
> > +		sockopt_free_buf(&ctx);
> > +		return ret;
> > +	}
> > +
> > +	if (ctx.optlen > max_optlen) {
> v4 looks very good.
> 
> One minor question here, what may be the use case if the bpf_prog makes
> ctx.optlen < max_optlen(==user's input) but sets ret == 0 (i.e. kernel should
> continue to handle it)?
Do you mean bpf fills in optval + adjusts optlen, but returns 0?
I don't see any usecase for that, bpf's output would be ignored in that case.

Do you think we should have an additional check to make sure
ctx.optval data is zero and ctx.optlen is not changed in that case?

> > +		sockopt_free_buf(&ctx);
> > +		return -EFAULT;
> > +	}
> > +
> > +	if (copy_to_user(optval, ctx.optval, ctx.optlen) != 0) {
> > +		sockopt_free_buf(&ctx);
> > +		return -EFAULT;
> > +	}
> > +
> > +	sockopt_free_buf(&ctx);
> > +
> > +	if (put_user(ctx.optlen, optlen))
> > +		return -EFAULT;
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(__cgroup_bpf_run_filter_getsockopt);
> > +
