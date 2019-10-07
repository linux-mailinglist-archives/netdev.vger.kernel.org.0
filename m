Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A11FCE94E
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 18:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbfJGQcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 12:32:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38478 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfJGQcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 12:32:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x97GJih5175731;
        Mon, 7 Oct 2019 16:32:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2019-08-05;
 bh=vn0SF1aIH2ygJLdFyST+9pATbIs0gjOm1zB1cxfQQ48=;
 b=UyaT8WgjqbcSY7JPQVnWzTUVT7wWoeo5WK4e/hALyRXFGSSqIE7hBd5oKVyZurV+h57n
 uuA4f6lW2iD6O8ErP2reSQuUHwYEVfrBIz/5esV97/HtevnmY7n0DJ4AuYoq9MzowFV4
 o1reskx/QmzPZxL3LjC8Lrd8zqscccxNfSZDqqZSkVAZh2g52b2j0OV0F/IhjWDAAqpN
 I9MSiMi6zGn0lAZSzchOGS2QJeHm2tX9JrH9oSkuebXbdMozngoZHeAQJEMIKhX3sY9Q
 3j7seHmWboICcOe0LyTacs1zTFipv/l6GGrAOxl60X6HN0pciw7hqlgzl1Qonpz5+dol iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vek4q7xq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Oct 2019 16:32:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x97GIU2x017622;
        Mon, 7 Oct 2019 16:32:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vg2044hfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Oct 2019 16:32:22 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x97GWKO3003785;
        Mon, 7 Oct 2019 16:32:21 GMT
Received: from dhcp-10-175-213-187.vpn.oracle.com (/10.175.213.187)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Oct 2019 09:32:20 -0700
Date:   Mon, 7 Oct 2019 17:32:04 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@dhcp-10-175-191-98.vpn.oracle.com
To:     Alexei Starovoitov <ast@kernel.org>
cc:     davem@davemloft.net, daniel@iogearbox.net, x86@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 05/10] bpf: implement accurate raw_tp context
 access via BTF
In-Reply-To: <20191005050314.1114330-6-ast@kernel.org>
Message-ID: <alpine.LRH.2.20.1910071131470.12667@dhcp-10-175-191-98.vpn.oracle.com>
References: <20191005050314.1114330-1-ast@kernel.org> <20191005050314.1114330-6-ast@kernel.org>
User-Agent: Alpine 2.20 (LRH 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910070155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910070155
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Oct 2019, Alexei Starovoitov wrote:

> libbpf analyzes bpf C program, searches in-kernel BTF for given type name
> and stores it into expected_attach_type.
> The kernel verifier expects this btf_id to point to something like:
> typedef void (*btf_trace_kfree_skb)(void *, struct sk_buff *skb, void *loc);
> which represents signature of raw_tracepoint "kfree_skb".
> 
> Then btf_ctx_access() matches ctx+0 access in bpf program with 'skb'
> and 'ctx+8' access with 'loc' arguments of "kfree_skb" tracepoint.
> In first case it passes btf_id of 'struct sk_buff *' back to the verifier core
> and 'void *' in second case.
> 
> Then the verifier tracks PTR_TO_BTF_ID as any other pointer type.
> Like PTR_TO_SOCKET points to 'struct bpf_sock',
> PTR_TO_TCP_SOCK points to 'struct bpf_tcp_sock', and so on.
> PTR_TO_BTF_ID points to in-kernel structs.
> If 1234 is btf_id of 'struct sk_buff' in vmlinux's BTF
> then PTR_TO_BTF_ID#1234 points to one of in kernel skbs.
> 
> When PTR_TO_BTF_ID#1234 is dereferenced (like r2 = *(u64 *)r1 + 32)
> the btf_struct_access() checks which field of 'struct sk_buff' is
> at offset 32. Checks that size of access matches type definition
> of the field and continues to track the dereferenced type.
> If that field was a pointer to 'struct net_device' the r2's type
> will be PTR_TO_BTF_ID#456. Where 456 is btf_id of 'struct net_device'
> in vmlinux's BTF.
> 
> Such verifier anlaysis prevents "cheating" in BPF C program.
> The program cannot cast arbitrary pointer to 'struct sk_buff *'
> and access it. C compiler would allow type cast, of course,
> but the verifier will notice type mismatch based on BPF assembly
> and in-kernel BTF.
>

This is an incredible leap forward! One question I have relates to 
another aspect of checking. As we move from bpf_probe_read() to "direct 
struct access", should we have the verifier insist on the same sort of 
checking we have for direct packet access? Specifically I'm thinking of 
the case where a typed pointer argument might be NULL and we attempt to 
dereference it.  This might be as simple as adding 
PTR_TO_BTF_ID to the reg_type_may_be_null() check:

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0717aac..6559b4d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -342,7 +342,8 @@ static bool reg_type_may_be_null(enum bpf_reg_type 
type)
        return type == PTR_TO_MAP_VALUE_OR_NULL ||
               type == PTR_TO_SOCKET_OR_NULL ||
               type == PTR_TO_SOCK_COMMON_OR_NULL ||
-              type == PTR_TO_TCP_SOCK_OR_NULL;
+              type == PTR_TO_TCP_SOCK_OR_NULL ||
+              type == PTR_TO_BTF_ID;
 }
 
...in order to ensure we don't dereference the pointer before checking for 
NULL.  Possibly I'm missing something that will do that NULL checking 
already?

Thanks!

Alan

 > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf.h          |  15 ++-
>  include/linux/bpf_verifier.h |   2 +
>  kernel/bpf/btf.c             | 179 +++++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c        |  69 +++++++++++++-
>  kernel/trace/bpf_trace.c     |   2 +-
>  5 files changed, 262 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 5b9d22338606..2dc3a7c313e9 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -281,6 +281,7 @@ enum bpf_reg_type {
>  	PTR_TO_TCP_SOCK_OR_NULL, /* reg points to struct tcp_sock or NULL */
>  	PTR_TO_TP_BUFFER,	 /* reg points to a writable raw tp's buffer */
>  	PTR_TO_XDP_SOCK,	 /* reg points to struct xdp_sock */
> +	PTR_TO_BTF_ID,
>  };
>  
>  /* The information passed from prog-specific *_is_valid_access
> @@ -288,7 +289,11 @@ enum bpf_reg_type {
>   */
>  struct bpf_insn_access_aux {
>  	enum bpf_reg_type reg_type;
> -	int ctx_field_size;
> +	union {
> +		int ctx_field_size;
> +		u32 btf_id;
> +	};
> +	struct bpf_verifier_env *env; /* for verbose logs */
>  };
>  
>  static inline void
> @@ -747,6 +752,14 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>  int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
>  				     const union bpf_attr *kattr,
>  				     union bpf_attr __user *uattr);
> +bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> +		    const struct bpf_prog *prog,
> +		    struct bpf_insn_access_aux *info);
> +int btf_struct_access(struct bpf_verifier_env *env,
> +		      const struct btf_type *t, int off, int size,
> +		      enum bpf_access_type atype,
> +		      u32 *next_btf_id);
> +
>  #else /* !CONFIG_BPF_SYSCALL */
>  static inline struct bpf_prog *bpf_prog_get(u32 ufd)
>  {
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 432ba8977a0a..e21782f49c45 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -52,6 +52,8 @@ struct bpf_reg_state {
>  		 */
>  		struct bpf_map *map_ptr;
>  
> +		u32 btf_id; /* for PTR_TO_BTF_ID */
> +
>  		/* Max size from any of the above. */
>  		unsigned long raw;
>  	};
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 848f9d4b9d7e..61ff8a54ca22 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3433,6 +3433,185 @@ struct btf *btf_parse_vmlinux(void)
>  	return ERR_PTR(err);
>  }
>  
> +extern struct btf *btf_vmlinux;
> +
> +bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> +		    const struct bpf_prog *prog,
> +		    struct bpf_insn_access_aux *info)
> +{
> +	u32 btf_id = prog->expected_attach_type;
> +	const struct btf_param *args;
> +	const struct btf_type *t;
> +	const char prefix[] = "btf_trace_";
> +	const char *tname;
> +	u32 nr_args;
> +
> +	if (!btf_id)
> +		return true;
> +
> +	if (IS_ERR(btf_vmlinux)) {
> +		bpf_verifier_log_write(info->env, "btf_vmlinux is malformed\n");
> +		return false;
> +	}
> +
> +	t = btf_type_by_id(btf_vmlinux, btf_id);
> +	if (!t || BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF) {
> +		bpf_verifier_log_write(info->env, "btf_id is invalid\n");
> +		return false;
> +	}
> +
> +	tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
> +	if (strncmp(prefix, tname, sizeof(prefix) - 1)) {
> +		bpf_verifier_log_write(info->env,
> +				       "btf_id points to wrong type name %s\n",
> +				       tname);
> +		return false;
> +	}
> +	tname += sizeof(prefix) - 1;
> +
> +	t = btf_type_by_id(btf_vmlinux, t->type);
> +	if (!btf_type_is_ptr(t))
> +		return false;
> +	t = btf_type_by_id(btf_vmlinux, t->type);
> +	if (!btf_type_is_func_proto(t))
> +		return false;
> +
> +	args = (const struct btf_param *)(t + 1);
> +	/* skip first 'void *__data' argument in btf_trace_* */
> +	nr_args = btf_type_vlen(t) - 1;
> +	if (off >= nr_args * 8) {
> +		bpf_verifier_log_write(info->env,
> +				       "raw_tp '%s' doesn't have %d-th argument\n",
> +				       tname, off / 8);
> +		return false;
> +	}
> +
> +	/* raw tp arg is off / 8, but typedef has extra 'void *', hence +1 */
> +	t = btf_type_by_id(btf_vmlinux, args[off / 8 + 1].type);
> +	if (btf_type_is_int(t))
> +		/* accessing a scalar */
> +		return true;
> +	if (!btf_type_is_ptr(t)) {
> +		bpf_verifier_log_write(info->env,
> +				       "raw_tp '%s' arg%d '%s' has type %s. Only pointer access is allowed\n",
> +				       tname, off / 8,
> +				       __btf_name_by_offset(btf_vmlinux, t->name_off),
> +				       btf_kind_str[BTF_INFO_KIND(t->info)]);
> +		return false;
> +	}
> +	if (t->type == 0)
> +		/* This is a pointer to void.
> +		 * It is the same as scalar from the verifier safety pov.
> +		 * No further pointer walking is allowed.
> +		 */
> +		return true;
> +
> +	/* this is a pointer to another type */
> +	info->reg_type = PTR_TO_BTF_ID;
> +	info->btf_id = t->type;
> +
> +	t = btf_type_by_id(btf_vmlinux, t->type);
> +	bpf_verifier_log_write(info->env,
> +			       "raw_tp '%s' arg%d has btf_id %d type %s '%s'\n",
> +			       tname, off / 8, info->btf_id,
> +			       btf_kind_str[BTF_INFO_KIND(t->info)],
> +			       __btf_name_by_offset(btf_vmlinux, t->name_off));
> +	return true;
> +}
> +
> +int btf_struct_access(struct bpf_verifier_env *env,
> +		      const struct btf_type *t, int off, int size,
> +		      enum bpf_access_type atype,
> +		      u32 *next_btf_id)
> +{
> +	const struct btf_member *member;
> +	const struct btf_type *mtype;
> +	const char *tname, *mname;
> +	int i, moff = 0, msize;
> +
> +again:
> +	tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> +	if (!btf_type_is_struct(t)) {
> +		bpf_verifier_log_write(env, "Type '%s' is not a struct", tname);
> +		return -EINVAL;
> +	}
> +	if (btf_type_vlen(t) < 1) {
> +		bpf_verifier_log_write(env, "struct %s doesn't have fields", tname);
> +		return -EINVAL;
> +	}
> +
> +	for_each_member(i, t, member) {
> +
> +		/* offset of the field */
> +		moff = btf_member_bit_offset(t, member);
> +
> +		if (off < moff / 8)
> +			continue;
> +
> +		/* type of the field */
> +		mtype = btf_type_by_id(btf_vmlinux, member->type);
> +		mname = __btf_name_by_offset(btf_vmlinux, member->name_off);
> +
> +		/* skip typedef, volotile modifiers */
> +		while (btf_type_is_modifier(mtype))
> +			mtype = btf_type_by_id(btf_vmlinux, mtype->type);
> +
> +		if (btf_type_is_array(mtype))
> +			/* array deref is not supported yet */
> +			continue;
> +
> +		if (!btf_type_has_size(mtype) && !btf_type_is_ptr(mtype)) {
> +			bpf_verifier_log_write(env,
> +					       "field %s doesn't have size\n",
> +					       mname);
> +			return -EFAULT;
> +		}
> +		if (btf_type_is_ptr(mtype))
> +			msize = 8;
> +		else
> +			msize = mtype->size;
> +		if (off >= moff / 8 + msize)
> +			/* rare case, must be a field of the union with smaller size,
> +			 * let's try another field
> +			 */
> +			continue;
> +		/* the 'off' we're looking for is either equal to start
> +		 * of this field or inside of this struct
> +		 */
> +		if (btf_type_is_struct(mtype)) {
> +			/* our field must be inside that union or struct */
> +			t = mtype;
> +
> +			/* adjust offset we're looking for */
> +			off -= moff / 8;
> +			goto again;
> +		}
> +		if (msize != size) {
> +			/* field access size doesn't match */
> +			bpf_verifier_log_write(env,
> +					       "cannot access %d bytes in struct %s field %s that has size %d\n",
> +					       size, tname, mname, msize);
> +			return -EACCES;
> +		}
> +
> +		if (btf_type_is_ptr(mtype)) {
> +			const struct btf_type *stype;
> +
> +			stype = btf_type_by_id(btf_vmlinux, mtype->type);
> +			if (btf_type_is_struct(stype)) {
> +				*next_btf_id = mtype->type;
> +				return PTR_TO_BTF_ID;
> +			}
> +		}
> +		/* all other fields are treated as scalars */
> +		return SCALAR_VALUE;
> +	}
> +	bpf_verifier_log_write(env,
> +			       "struct %s doesn't have field at offset %d\n",
> +			       tname, off);
> +	return -EINVAL;
> +}
> +
>  void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
>  		       struct seq_file *m)
>  {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 91c4db4d1c6a..3c155873ffea 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -406,6 +406,7 @@ static const char * const reg_type_str[] = {
>  	[PTR_TO_TCP_SOCK_OR_NULL] = "tcp_sock_or_null",
>  	[PTR_TO_TP_BUFFER]	= "tp_buffer",
>  	[PTR_TO_XDP_SOCK]	= "xdp_sock",
> +	[PTR_TO_BTF_ID]		= "ptr_",
>  };
>  
>  static char slot_type_char[] = {
> @@ -460,6 +461,10 @@ static void print_verifier_state(struct bpf_verifier_env *env,
>  			/* reg->off should be 0 for SCALAR_VALUE */
>  			verbose(env, "%lld", reg->var_off.value + reg->off);
>  		} else {
> +			if (t == PTR_TO_BTF_ID)
> +				verbose(env, "%s",
> +					btf_name_by_offset(btf_vmlinux,
> +							   btf_type_by_id(btf_vmlinux, reg->btf_id)->name_off));
>  			verbose(env, "(id=%d", reg->id);
>  			if (reg_type_may_be_refcounted_or_null(t))
>  				verbose(env, ",ref_obj_id=%d", reg->ref_obj_id);
> @@ -2337,10 +2342,12 @@ static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
>  
>  /* check access to 'struct bpf_context' fields.  Supports fixed offsets only */
>  static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off, int size,
> -			    enum bpf_access_type t, enum bpf_reg_type *reg_type)
> +			    enum bpf_access_type t, enum bpf_reg_type *reg_type,
> +			    u32 *btf_id)
>  {
>  	struct bpf_insn_access_aux info = {
>  		.reg_type = *reg_type,
> +		.env = env,
>  	};
>  
>  	if (env->ops->is_valid_access &&
> @@ -2354,7 +2361,10 @@ static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off,
>  		 */
>  		*reg_type = info.reg_type;
>  
> -		env->insn_aux_data[insn_idx].ctx_field_size = info.ctx_field_size;
> +		if (*reg_type == PTR_TO_BTF_ID)
> +			*btf_id = info.btf_id;
> +		else
> +			env->insn_aux_data[insn_idx].ctx_field_size = info.ctx_field_size;
>  		/* remember the offset of last byte accessed in ctx */
>  		if (env->prog->aux->max_ctx_offset < off + size)
>  			env->prog->aux->max_ctx_offset = off + size;
> @@ -2745,6 +2755,53 @@ static void coerce_reg_to_size(struct bpf_reg_state *reg, int size)
>  	reg->smax_value = reg->umax_value;
>  }
>  
> +static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
> +				   struct bpf_reg_state *regs,
> +				   int regno, int off, int size,
> +				   enum bpf_access_type atype,
> +				   int value_regno)
> +{
> +	struct bpf_reg_state *reg = regs + regno;
> +	const struct btf_type *t = btf_type_by_id(btf_vmlinux, reg->btf_id);
> +	const char *tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> +	u32 btf_id;
> +	int ret;
> +
> +	if (atype != BPF_READ) {
> +		verbose(env, "only read is supported\n");
> +		return -EACCES;
> +	}
> +
> +	if (off < 0) {
> +		verbose(env,
> +			"R%d is ptr_%s negative access %d is not allowed\n",
> +			regno, tname, off);
> +		return -EACCES;
> +	}
> +	if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
> +		char tn_buf[48];
> +
> +		tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
> +		verbose(env,
> +			"R%d is ptr_%s invalid variable offset: off=%d, var_off=%s\n",
> +			regno, tname, off, tn_buf);
> +		return -EACCES;
> +	}
> +
> +	ret = btf_struct_access(env, t, off, size, atype, &btf_id);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret == SCALAR_VALUE) {
> +		mark_reg_unknown(env, regs, value_regno);
> +		return 0;
> +	}
> +	mark_reg_known_zero(env, regs, value_regno);
> +	regs[value_regno].type = PTR_TO_BTF_ID;
> +	regs[value_regno].btf_id = btf_id;
> +	return 0;
> +}
> +
>  /* check whether memory at (regno + off) is accessible for t = (read | write)
>   * if t==write, value_regno is a register which value is stored into memory
>   * if t==read, value_regno is a register which will receive the value from memory
> @@ -2787,6 +2844,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
>  
>  	} else if (reg->type == PTR_TO_CTX) {
>  		enum bpf_reg_type reg_type = SCALAR_VALUE;
> +		u32 btf_id = 0;
>  
>  		if (t == BPF_WRITE && value_regno >= 0 &&
>  		    is_pointer_value(env, value_regno)) {
> @@ -2798,7 +2856,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
>  		if (err < 0)
>  			return err;
>  
> -		err = check_ctx_access(env, insn_idx, off, size, t, &reg_type);
> +		err = check_ctx_access(env, insn_idx, off, size, t, &reg_type, &btf_id);
>  		if (!err && t == BPF_READ && value_regno >= 0) {
>  			/* ctx access returns either a scalar, or a
>  			 * PTR_TO_PACKET[_META,_END]. In the latter
> @@ -2817,6 +2875,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
>  				 * a sub-register.
>  				 */
>  				regs[value_regno].subreg_def = DEF_NOT_SUBREG;
> +				if (reg_type == PTR_TO_BTF_ID)
> +					regs[value_regno].btf_id = btf_id;
>  			}
>  			regs[value_regno].type = reg_type;
>  		}
> @@ -2876,6 +2936,9 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
>  		err = check_tp_buffer_access(env, reg, regno, off, size);
>  		if (!err && t == BPF_READ && value_regno >= 0)
>  			mark_reg_unknown(env, regs, value_regno);
> +	} else if (reg->type == PTR_TO_BTF_ID) {
> +		err = check_ptr_to_btf_access(env, regs, regno, off, size, t,
> +					      value_regno);
>  	} else {
>  		verbose(env, "R%d invalid mem access '%s'\n", regno,
>  			reg_type_str[reg->type]);
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 44bd08f2443b..6221e8c6ecc3 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1074,7 +1074,7 @@ static bool raw_tp_prog_is_valid_access(int off, int size,
>  		return false;
>  	if (off % size != 0)
>  		return false;
> -	return true;
> +	return btf_ctx_access(off, size, type, prog, info);
>  }
>  
>  const struct bpf_verifier_ops raw_tracepoint_verifier_ops = {
> -- 
> 2.20.0
> 
> 
