Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13801D4139
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgENWk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:40:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33314 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgENWk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 18:40:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EMbBkD041377;
        Thu, 14 May 2020 22:40:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=7jeBYTKdJXILRFlOyJBWzzBBYkyl5qncMvx+DPb9jjE=;
 b=BUCHb8+v+/Y2usXX8qcnWYk2NWXXkf1DQVbZpkRrw9e7xi7tgLoL5DXEzUeWtxCa9+Zk
 6PXty/Qsa9YEUkE3DeZ5PmpaApWO4N5UTa5NaRCBEjacD4GqD63G9aFFdaL6C8eUh/TV
 m9TTJXEY19X0AvJkRWl+clYcDQNdckMR7M0EGY5AlH52jI+YO2eLSMz7nH5/zYYM1Z1O
 xizc6VXZc1UAZk8lLWfGbjBr/jx0UIgHfO8x2Cgf7ydqNWtUiNQnnC78ncFdOYau3Tx4
 pT2bRjBpe43B2UADmpLli/KIBL/GwcC8KFwPsGpRFmkYTSA9KV4M5dUTkTInHO9onSjS Dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3100xwwgnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 22:40:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EMc6ll036345;
        Thu, 14 May 2020 22:38:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3100ydh5k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 22:38:08 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04EMbwce010319;
        Thu, 14 May 2020 22:37:58 GMT
Received: from dhcp-10-175-210-26.vpn.oracle.com (/10.175.210.26)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 15:37:58 -0700
Date:   Thu, 14 May 2020 23:37:52 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Yonghong Song <yhs@fb.com>
cc:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org, joe@perches.com,
        linux@rasmusvillemoes.dk, arnaldo.melo@gmail.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 4/7] printk: add type-printing %pT format
 specifier which uses BTF
In-Reply-To: <51ac81f5-3d74-e394-3183-5d8366e2ddcc@fb.com>
Message-ID: <alpine.LRH.2.21.2005142330430.24127@localhost>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com> <1589263005-7887-5-git-send-email-alan.maguire@oracle.com> <51ac81f5-3d74-e394-3183-5d8366e2ddcc@fb.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=3 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140196
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=3 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140196
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Wed, 13 May 2020, Yonghong Song wrote:

> 
> 
> On 5/11/20 10:56 PM, Alan Maguire wrote:
> > printk supports multiple pointer object type specifiers (printing
> > netdev features etc).  Extend this support using BTF to cover
> > arbitrary types.  "%pT" specifies the typed format, and the pointer
> > argument is a "struct btf_ptr *" where struct btf_ptr is as follows:
> > 
> > struct btf_ptr {
> >  void *ptr;
> >  const char *type;
> >  u32 id;
> > };
> > 
> > Either the "type" string ("struct sk_buff") or the BTF "id" can be
> > used to identify the type to use in displaying the associated "ptr"
> > value.  A convenience function to create and point at the struct
> > is provided:
> > 
> >  printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> > 
> > When invoked, BTF information is used to traverse the sk_buff *
> > and display it.  Support is present for structs, unions, enums,
> > typedefs and core types (though in the latter case there's not
> > much value in using this feature of course).
> > 
> > Default output is indented, but compact output can be specified
> > via the 'c' option.  Type names/member values can be suppressed
> > using the 'N' option.  Zero values are not displayed by default
> > but can be using the '0' option.  Pointer values are obfuscated
> > unless the 'x' option is specified.  As an example:
> > 
> >    struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
> >    pr_info("%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> > 
> > ...gives us:
> > 
> > (struct sk_buff){
> >   .transport_header = (__u16)65535,
> >   .mac_header = (__u16)65535,
> >   .end = (sk_buff_data_t)192,
> >   .head = (unsigned char *)000000006b71155a,
> >   .data = (unsigned char *)000000006b71155a,
> >   .truesize = (unsigned int)768,
> >   .users = (refcount_t){
> >    .refs = (atomic_t){
> >    .counter = (int)1,
> >   },
> >   },
> >   .extensions = (struct skb_ext *)00000000f486a130,
> > }
> > 
> > printk output is truncated at 1024 bytes.  For cases where overflow
> > is likely, the compact/no type names display modes may be used.
> > 
> > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > ---
> >   Documentation/core-api/printk-formats.rst |  15 ++++
> >   include/linux/btf.h                       |   3 +-
> >   include/linux/printk.h                    |  16 +++++
> >   lib/Kconfig                               |  16 +++++
> >   lib/vsprintf.c                            | 113
> >   ++++++++++++++++++++++++++++++
> >   5 files changed, 162 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/core-api/printk-formats.rst
> > b/Documentation/core-api/printk-formats.rst
> > index 8ebe46b1..5c66097 100644
> > --- a/Documentation/core-api/printk-formats.rst
> > +++ b/Documentation/core-api/printk-formats.rst
> > @@ -545,6 +545,21 @@ For printing netdev_features_t.
> >   
> >   Passed by reference.
> >   
> > +BTF-based printing of pointer data
> > +----------------------------------
> > +If '%pT' is specified, use the struct btf_ptr * along with kernel vmlinux
> > +BPF Type Format (BTF) to show the typed data.  For example, specifying
> > +
> > +	printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct_sk_buff));
> > +
> > +will utilize BTF information to traverse the struct sk_buff * and display
> > it.
> > +
> > +Supported modifers are
> > + 'c' compact output (no indentation, newlines etc)
> > + 'N' do not show type names
> > + 'x' show raw pointers (no obfuscation)
> > + '0' show zero-valued data (it is not shown by default)
> > +
> >   Thanks
> >   ======
> >   
> > diff --git a/include/linux/btf.h b/include/linux/btf.h
> > index d571125..7b585ab 100644
> > --- a/include/linux/btf.h
> > +++ b/include/linux/btf.h
> > @@ -169,10 +169,11 @@ static inline const struct btf_member
> > *btf_type_member(const struct btf_type *t)
> >   	return (const struct btf_member *)(t + 1);
> >   }
> >   
> > +struct btf *btf_parse_vmlinux(void);
> > +
> >   #ifdef CONFIG_BPF_SYSCALL
> >   const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
> >   const char *btf_name_by_offset(const struct btf *btf, u32 offset);
> > -struct btf *btf_parse_vmlinux(void);
> >   struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
> >   #else
> >   static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
> > diff --git a/include/linux/printk.h b/include/linux/printk.h
> > index fcde0772..3c3ea53 100644
> > --- a/include/linux/printk.h
> > +++ b/include/linux/printk.h
> > @@ -528,4 +528,20 @@ static inline void print_hex_dump_debug(const char
> > *prefix_str, int prefix_type,
> >   #define print_hex_dump_bytes(prefix_str, prefix_type, buf, len)	\
> >    print_hex_dump_debug(prefix_str, prefix_type, 16, 1, buf, len, true)
> >   +/**
> > + * struct btf_ptr is used for %pT (typed pointer) display; the
> > + * additional type string/BTF id are used to render the pointer
> > + * data as the appropriate type.
> > + */
> > +struct btf_ptr {
> > +	void *ptr;
> > +	const char *type;
> > +	u32 id;
> > +};
> > +
> > +#define	BTF_PTR_TYPE(ptrval, typeval) \
> > +	(&((struct btf_ptr){.ptr = ptrval, .type = #typeval}))
> > +
> > +#define BTF_PTR_ID(ptrval, idval) \
> > +	(&((struct btf_ptr){.ptr = ptrval, .id = idval}))
> >   #endif
> [...]
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> > index 7c488a1..f9276f8 100644
> > --- a/lib/vsprintf.c
> > +++ b/lib/vsprintf.c
> > @@ -43,6 +43,7 @@
> >   #ifdef CONFIG_BLOCK
> >   #include <linux/blkdev.h>
> >   #endif
> > +#include <linux/btf.h>
> >   
> >   #include "../mm/internal.h"	/* For the trace_print_flags arrays */
> >   
> > @@ -2059,6 +2060,103 @@ char *fwnode_string(char *buf, char *end, struct
> > fwnode_handle *fwnode,
> >   	return widen_string(buf, buf - buf_start, end, spec);
> >   }
> >   
> > +#if IS_ENABLED(CONFIG_BTF_PRINTF)
> > +#define btf_modifier_flag(c)	(c == 'c' ? BTF_SHOW_COMPACT :	\
> > +				 c == 'N' ? BTF_SHOW_NONAME :	\
> > +				 c == 'x' ? BTF_SHOW_PTR_RAW :	\
> > +				 c == '0' ? BTF_SHOW_ZERO : 0)
> > +
> > +static noinline_for_stack
> > +char *btf_string(char *buf, char *end, void *ptr, struct printf_spec spec,
> > +		 const char *fmt)
> > +{
> > +	struct btf_ptr *bp = (struct btf_ptr *)ptr;
> > +	u8 btf_kind = BTF_KIND_TYPEDEF;
> > +	const struct btf_type *t;
> > +	const struct btf *btf;
> > +	char *buf_start = buf;
> > +	const char *btf_type;
> > +	u64 flags = 0, mod;
> > +	s32 btf_id;
> > +
> > +	if (check_pointer(&buf, end, ptr, spec))
> > +		return buf;
> > +
> > +	if (check_pointer(&buf, end, bp->ptr, spec))
> > +		return buf;
> > +
> > +	while (isalnum(*fmt)) {
> > +		mod = btf_modifier_flag(*fmt);
> > +		if (!mod)
> > +			break;
> > +		flags |= mod;
> > +		fmt++;
> > +	}
> > +
> > +	btf = bpf_get_btf_vmlinux();
> > +	if (IS_ERR_OR_NULL(btf))
> > +		return ptr_to_id(buf, end, bp->ptr, spec);
> > +
> > +	if (bp->type != NULL) {
> > +		btf_type = bp->type;
> > +
> > +		if (strncmp(bp->type, "struct ", strlen("struct ")) == 0) {
> > +			btf_kind = BTF_KIND_STRUCT;
> > +			btf_type += strlen("struct ");
> > +		} else if (strncmp(btf_type, "union ", strlen("union ")) == 0)
> > {
> > +			btf_kind = BTF_KIND_UNION;
> > +			btf_type += strlen("union ");
> > +		} else if (strncmp(btf_type, "enum ", strlen("enum ")) == 0) {
> > +			btf_kind = BTF_KIND_ENUM;
> > +			btf_type += strlen("enum ");
> > +		}
> 
> I think typedef should be supported here.
> In kernel, we have some structure directly defined as typedef's.
> A lot of internal int types also typedefs, like u32, atomic_t,
> possible_net_t, etc.
> 
> A type name without prefix "struct", "union", "enum" can be
> treated as a typedef first.
> 

That's how the code works today; we start with a typedef assumption.
See the comment below starting "Assume type specified is a typedef";
we initialize btf_kind to be a typedef above; it's only changed
to an BTF_KIND_INT if we find a struct/enum/union prefix or if lookup
using the typedef kind fails. I should probably make this clearer
though (move the comment up maybe?). Thanks for taking a look!

> If the type name is not a typedef, it is then compared to a limited
> number of C basic int types like "char", "unsigned char", "short",
> "unsigned short", ...
> 
> > +
> > +		if (strlen(btf_type) == 0)
> > +			return ptr_to_id(buf, end, bp->ptr, spec);
> > +
> > +		/*
> > +		 * Assume type specified is a typedef as there's not much
> > +		 * benefit in specifying int types other than wasting time
> > +		 * on BTF lookups; we optimize for the most useful path.
> > +		 *
> > +		 * Fall back to BTF_KIND_INT if this fails.
> > +		 */
> > +		btf_id = btf_find_by_name_kind(btf, btf_type, btf_kind);
> > +		if (btf_id < 0)
> > +			btf_id = btf_find_by_name_kind(btf, btf_type,
> > +						       BTF_KIND_INT);
> > +	} else if (bp->id > 0)
> > +		btf_id = bp->id;
> > +	else
> > +		return ptr_to_id(buf, end, bp->ptr, spec);
> > +
> > +	if (btf_id > 0)
> > +		t = btf_type_by_id(btf, btf_id);
> > +	if (btf_id <= 0 || !t)
> > +		return ptr_to_id(buf, end, bp->ptr, spec);
> > +
> > +	buf += btf_type_snprintf_show(btf, btf_id, bp->ptr, buf,
> > +				      end - buf_start, flags);
> > +
> > +	return widen_string(buf, buf - buf_start, end, spec);
> > +}
> > +#else
> > +static noinline_for_stack
> > +char *btf_string(char *buf, char *end, void *ptr, struct printf_spec spec,
> > +	const char *fmt)
> > +{
> > +	struct btf_ptr *bp = (struct btf_ptr *)ptr;
> > +
> > +	if (check_pointer(&buf, end, ptr, spec))
> > +		return buf;
> > +
> > +	if (check_pointer(&buf, end, bp->ptr, spec))
> > +		return buf;
> > +
> > +	return ptr_to_id(buf, end, bp->ptr, spec);
> > +}
> > +#endif /* IS_ENABLED(CONFIG_BTF_PRINTF) */
> > +
> >   /*
> >    * Show a '%p' thing.  A kernel extension is that the '%p' is followed
> >    * by an extra set of alphanumeric characters that are extended format
> > @@ -2169,6 +2267,19 @@ char *fwnode_string(char *buf, char *end, struct
> > fwnode_handle *fwnode,
> >    *		P node name, including a possible unit address
> >    * - 'x' For printing the address. Equivalent to "%lx".
> >    *
> > + * - 'T[cNx0]' For printing struct btf_ptr * data using BPF Type Format
> > (BTF).
> > + *
> > + *			Optional arguments are
> > + *			c		compact (no indentation/newlines)
> > + *			N		do not print type and member names
> > + *			x		do not obfuscate pointers
> > + *			0		show 0-valued data
> > + *
> > + *    BPF_PTR_TYPE(ptr, type) can be used to place pointer and type string
> > + *    in the "struct btf_ptr *" expected; for example:
> > + *
> > + *	printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> > + *
> >    * ** When making changes please also update:
> >    *	Documentation/core-api/printk-formats.rst
> >    *
> > @@ -2251,6 +2362,8 @@ char *pointer(const char *fmt, char *buf, char *end,
> > void *ptr,
> >     if (!IS_ERR(ptr))
> >     	break;
> >   		return err_ptr(buf, end, ptr, spec);
> > +	case 'T':
> > +		return btf_string(buf, end, ptr, spec, fmt + 1);
> >    }
> >   
> >    /* default is to _not_ leak addresses, hash before printing */
> > 
> 
> 
