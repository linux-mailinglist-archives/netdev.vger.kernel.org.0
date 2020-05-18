Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6931D7450
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 11:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgERJr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 05:47:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48966 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgERJr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 05:47:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04I9ff4x181635;
        Mon, 18 May 2020 09:47:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=IMhvil5b3eckC8IaWjSnELY80zhoQgBi9cwRaMEPeo0=;
 b=uEn0oHmN6hfPIQuwn50NoA8KKvU0/krfkQJfTZJCa9nF19PvcwVth9sJEWKUpdzIOYCX
 v+pZJvbA6HMD+u/zwJi64g2Zs9SGnEvt2emSBc1PSoUJ3qCDWqQ9YrBkr4QiFyUjY1Ax
 Ku5JI+kIKtaMK+3WD6s7S7LyAVStluy4SiPknoKiH5RfiYcXzVZj+E4X3uslSW3ONTVe
 bb5PGXD/NcEGM2MhUTJnnPDic1XNT7z7QTqw86ypdCbVnbiIk6avovPsLamEE0Fn3OhG
 9nk+PCDerQUrQiJ/loYWduZq18ETDa5DKHEMl+6pVZthe6zIfDIkbd0AWzXO3HTvNS+P Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31284kns87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 18 May 2020 09:47:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04I9iJ5D071104;
        Mon, 18 May 2020 09:47:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 312t3v923s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 09:47:07 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04I9l5qx006629;
        Mon, 18 May 2020 09:47:05 GMT
Received: from dhcp-10-175-184-176.vpn.oracle.com (/10.175.184.176)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 02:47:04 -0700
Date:   Mon, 18 May 2020 10:46:58 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Yonghong Song <yhs@fb.com>
cc:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org, joe@perches.com,
        linux@rasmusvillemoes.dk, arnaldo.melo@gmail.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 2/7] bpf: move to generic BTF show support,
 apply it to seq files/strings
In-Reply-To: <2a2c5072-8cd2-610b-db2a-16589df90faf@fb.com>
Message-ID: <alpine.LRH.2.21.2005181012040.893@localhost>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com> <1589263005-7887-3-git-send-email-alan.maguire@oracle.com> <2a2c5072-8cd2-610b-db2a-16589df90faf@fb.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9624 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=4 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005180087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9624 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005180087
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020, Yonghong Song wrote:

> 
> > +struct btf_show {
> > +	u64 flags;
> > +	void *target;	/* target of show operation (seq file, buffer) */
> > +	void (*showfn)(struct btf_show *show, const char *fmt, ...);
> > +	const struct btf *btf;
> > +	/* below are used during iteration */
> > +	struct {
> > +		u8 depth;
> > +		u8 depth_shown;
> > +		u8 depth_check;
> 
> I have some difficulties to understand the relationship between
> the above three variables. Could you add some comments here?
>

Will do; sorry the code got a bit confusing. The goal is to track
which sub-components in a data structure we need to display.  The
"depth" variable tracks where we are currently; "depth_shown"
is the depth at which we have something nonzer to display (perhaps
"depth_to_show" would be a better name?). "depth_check" tells
us whether we are currently checking depth or doing printing.
If we're checking, we don't actually print anything, we merely note
if we hit a non-zero value, and if so, we set "depth_shown"
to the depth at which we hit that value.

When we show a struct, union or array, we will only display an
object has one or more non-zero members.  But because
the struct can in turn nest a struct or array etc, we need
to recurse into the object.  When we are doing that, depth_check
is set, and this tells us not to do any actual display. When
that recursion is complete, we check if "depth_shown" (depth
to show) is > depth (i.e. we found something) and if it is
we go on to display the object (setting depth_check to 0).

There may be a better way to solve this problem of course,
but I wanted to avoid storing values where possible as
deeply-nested data structures might overrun such storage.

> > +		u8 array_member:1,
> > +		   array_terminated:1;
> > +		u16 array_encoding;
> > +		u32 type_id;
> > +		const struct btf_type *type;
> > +		const struct btf_member *member;
> > +		char name[KSYM_NAME_LEN];	/* scratch space for name */
> > +		char type_name[KSYM_NAME_LEN];	/* scratch space for type */
> 
> KSYM_NAME_LEN is for symbol name, not for type name. But I guess in kernel we
> probably do not have > 128 bytes type name so we should be
> okay here.
> 

Yeah, I couldn't find a good length to use here.  We
eliminate qualifiers such as "const" in the display, so
it's unlikely we'd overrun.

> > +	} state;
> > +};
> > +
> >   struct btf_kind_operations {
> >    s32 (*check_meta)(struct btf_verifier_env *env,
> >   			  const struct btf_type *t,
> > @@ -297,9 +323,9 @@ struct btf_kind_operations {
> >    			  const struct btf_type *member_type);
> >    void (*log_details)(struct btf_verifier_env *env,
> >   			    const struct btf_type *t);
> > -	void (*seq_show)(const struct btf *btf, const struct btf_type *t,
> > +	void (*show)(const struct btf *btf, const struct btf_type *t,
> >   			 u32 type_id, void *data, u8 bits_offsets,
> > -			 struct seq_file *m);
> > +			 struct btf_show *show);
> >   };
> >   
> >   static const struct btf_kind_operations * const kind_ops[NR_BTF_KINDS];
> > @@ -676,6 +702,340 @@ bool btf_member_is_reg_int(const struct btf *btf,
> > const struct btf_type *s,
> >   	return true;
> >   }
> >   
> > +/* Similar to btf_type_skip_modifiers() but does not skip typedefs. */
> > +static inline
> > +const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf, u32
> > id)
> > +{
> > +	const struct btf_type *t = btf_type_by_id(btf, id);
> > +
> > +	while (btf_type_is_modifier(t) &&
> > +	       BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF) {
> > +		id = t->type;
> > +		t = btf_type_by_id(btf, t->type);
> > +	}
> > +
> > +	return t;
> > +}
> > +
> > +#define BTF_SHOW_MAX_ITER	10
> > +
> > +#define BTF_KIND_BIT(kind)	(1ULL << kind)
> > +
> > +static inline const char *btf_show_type_name(struct btf_show *show,
> > +					     const struct btf_type *t)
> > +{
> > +	const char *array_suffixes = "[][][][][][][][][][]";
> 
> Add a comment here saying length BTF_SHOW_MAX_ITER * 2
> so later on if somebody changes the BTF_SHOW_MAX_ITER from 10 to 12,
> it won't miss here?
> 
> > +	const char *array_suffix = &array_suffixes[strlen(array_suffixes)];
> > +	const char *ptr_suffixes = "**********";
> 
> The same here.
>

Good idea; will do.
 
> > +	const char *ptr_suffix = &ptr_suffixes[strlen(ptr_suffixes)];
> > +	const char *type_name = NULL, *prefix = "", *parens = "";
> > +	const struct btf_array *array;
> > +	u32 id = show->state.type_id;
> > +	bool allow_anon = true;
> > +	u64 kinds = 0;
> > +	int i;
> > +
> > +	show->state.type_name[0] = '\0';
> > +
> > +	/*
> > +	 * Start with type_id, as we have have resolved the struct btf_type *
> > +	 * via btf_modifier_show() past the parent typedef to the child
> > +	 * struct, int etc it is defined as.  In such cases, the type_id
> > +	 * still represents the starting type while the the struct btf_type *
> > +	 * in our show->state points at the resolved type of the typedef.
> > +	 */
> > +	t = btf_type_by_id(show->btf, id);
> > +	if (!t)
> > +		return show->state.type_name;
> > +
> > +	/*
> > +	 * The goal here is to build up the right number of pointer and
> > +	 * array suffixes while ensuring the type name for a typedef
> > +	 * is represented.  Along the way we accumulate a list of
> > +	 * BTF kinds we have encountered, since these will inform later
> > +	 * display; for example, pointer types will not require an
> > +	 * opening "{" for struct, we will just display the pointer value.
> > +	 *
> > +	 * We also want to accumulate the right number of pointer or array
> > +	 * indices in the format string while iterating until we get to
> > +	 * the typedef/pointee/array member target type.
> > +	 *
> > +	 * We start by pointing at the end of pointer and array suffix
> > +	 * strings; as we accumulate pointers and arrays we move the pointer
> > +	 * or array string backwards so it will show the expected number of
> > +	 * '*' or '[]' for the type.  BTF_SHOW_MAX_ITER of nesting of pointers
> > +	 * and/or arrays and typedefs are supported as a precaution.
> > +	 *
> > +	 * We also want to get typedef name while proceeding to resolve
> > +	 * type it points to so that we can add parentheses if it is a
> > +	 * "typedef struct" etc.
> > +	 */
> > +	for (i = 0; i < BTF_SHOW_MAX_ITER; i++) {
> > +
> > +		switch (BTF_INFO_KIND(t->info)) {
> > +		case BTF_KIND_TYPEDEF:
> > +			if (!type_name)
> > +				type_name = btf_name_by_offset(show->btf,
> > +							       t->name_off);
> > +			kinds |= BTF_KIND_BIT(BTF_KIND_TYPEDEF);
> > +			id = t->type;
> > +			break;
> > +		case BTF_KIND_ARRAY:
> > +			kinds |= BTF_KIND_BIT(BTF_KIND_ARRAY);
> > +			parens = "[";
> > +			array = btf_type_array(t);
> > +			if (!array)
> > +				return show->state.type_name;
> > +			if (!t)
> > +				return show->state.type_name;
> > +			if (array_suffix > array_suffixes)
> > +				array_suffix -= 2;
> > +			id = array->type;
> > +			break;
> > +		case BTF_KIND_PTR:
> > +			kinds |= BTF_KIND_BIT(BTF_KIND_PTR);
> > +			if (ptr_suffix > ptr_suffixes)
> > +				ptr_suffix -= 1;
> > +			id = t->type;
> > +			break;
> > +		default:
> > +			id = 0;
> > +			break;
> > +		}
> > +		if (!id)
> > +			break;
> > +		t = btf_type_skip_qualifiers(show->btf, id);
> > +		if (!t)
> > +			return show->state.type_name;
> > +	}
> 
> Do we do pointer tracing here? For example
> struct t {
> 	int *m[5];
> }
> 
> When trying to access memory, the above code may go through
> ptr->array and out of loop when hitting array element type "int"?
>

I'm not totally sure I understand the question so I'll
try and describe how the above is supposed to work. I
think there's a bug here alright.

In the above case, when we reach the "m" field of "struct t",
the code  should start with the BTF_KIND_ARRAY, set up
the array suffix, then get the array type which is a PTR
and we will set up the ptr suffix to be "*" and we set
the id to the id associated with "int", and
btf_type_skip_qualifiers() will use that id to look up
the new value for the type used in btf_name_by_offset().
So on the next iteration we hit the int itself and bail from
the loop, having noted that we've got a _PTR and _ARRAY set in
the "kinds" bitfield.

Then we look up the int type using "t" with btf_name_by_offset,
so we end up displaying "(int *m[])" as the type.
  
However the code assumes we don't need the parentheses for
the array if we have encountered a pointer; that's never
the case.  We only should eliminate the opening parens
for a struct or union "{" in such cases, as in those cases
we have a pointer to the struct rather than a nested struct.
So that needs to be fixed. Are the other problems here you're
seeing that the above doesn't cover?

> > +	/* We may not be able to represent this type; bail to be safe */
> > +	if (i == BTF_SHOW_MAX_ITER)
> > +		return show->state.type_name;
> > +
> > +	if (!type_name)
> > +		type_name = btf_name_by_offset(show->btf, t->name_off);
> > +
> > +	switch (BTF_INFO_KIND(t->info)) {
> > +	case BTF_KIND_STRUCT:
> > +	case BTF_KIND_UNION:
> > +		prefix = BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT ?
> > +			 "struct" : "union";
> > +		/* if it's an array of struct/union, parens is already set */
> > +		if (!(kinds & (BTF_KIND_BIT(BTF_KIND_ARRAY))))
> > +			parens = "{";
> > +		break;
> > +	case BTF_KIND_ENUM:
> > +		prefix = "enum";
> > +		break;
> > +	default:
> > +		allow_anon = false;
> > +		break;
> > +	}
> > +
> > +	/* pointer does not require parens */
> > +	if (kinds & BTF_KIND_BIT(BTF_KIND_PTR))
> > +		parens = "";

This is wrong for the example case you gave, as we don't want to 
eliminate the opening array parentheses for an array of pointers.

> > +	/* typedef does not require struct/union/enum prefix */
> > +	if (kinds & BTF_KIND_BIT(BTF_KIND_TYPEDEF))
> > +		prefix = "";
> > +
> > +	if (!type_name || strlen(type_name) == 0) {
> > +		if (allow_anon)
> > +			type_name = "";
> > +		else
> > +			return show->state.type_name;
> > +	}
> > +
> > +	/* Even if we don't want type name info, we want parentheses etc */
> > +	if (show->flags & BTF_SHOW_NONAME)
> > +		snprintf(show->state.type_name, sizeof(show->state.type_name),
> > +			 "%s", parens);
> > +	else
> > +		snprintf(show->state.type_name, sizeof(show->state.type_name),
> > +			 "(%s%s%s%s%s%s)%s",
> > +			 prefix,
> > +			 strlen(prefix) > 0 && strlen(type_name) > 0 ? " " :
> > "",
> > +			 type_name,
> > +			 strlen(ptr_suffix) > 0 ? " " : "", ptr_suffix,
> > +			 array_suffix, parens);
> > +
> > +	return show->state.type_name;
> > +}
> > +
> > +static inline const char *btf_show_name(struct btf_show *show)
> > +{
> > +	const struct btf_type *t = show->state.type;
> > +	const struct btf_member *m = show->state.member;
> > +	const char *member = NULL;
> > +	const char *type = "";
> > +
> > +	show->state.name[0] = '\0';
> > +
> > +	if ((!m && !t) || show->state.array_member)
> > +		return show->state.name;
> > +
> > +	if (m)
> > +		t = btf_type_skip_qualifiers(show->btf, m->type);
> > +
> > +	if (t) {
> > +		type = btf_show_type_name(show, t);
> > +		if (!type)
> > +			return show->state.name;
> > +	}
> > +
> > +	if (m && !(show->flags & BTF_SHOW_NONAME)) {
> > +		member = btf_name_by_offset(show->btf, m->name_off);
> > +		if (member && strlen(member) > 0) {
> > +			snprintf(show->state.name, sizeof(show->state.name),
> > +				 ".%s = %s", member, type);
> > +			return show->state.name;
> > +		}
> > +	}
> > +
> > +	snprintf(show->state.name, sizeof(show->state.name), "%s", type);
> > +
> > +	return show->state.name;
> > +}
> > +
> > +#define btf_show(show, ...)
> > \
> > +	do {
> > \
> > +		if (!show->state.depth_check)
> > \
> 
> As I mentioned above, some comments will be good to understand here.
>

Absolutely.
 
> > +			show->showfn(show, __VA_ARGS__);
> > \
> > +	} while (0)
> > +

> > +static inline const char *__btf_show_indent(struct btf_show *show)
> > +{
> > +	const char *indents = "                                ";
> > +	const char *indent = &indents[strlen(indents)];
> > +
> > +	if ((indent - show->state.depth) >= indents)
> > +		return indent - show->state.depth;
> > +	return indents;
> > +}
> > +
> > +#define btf_show_indent(show)
> > \
> > +	((show->flags & BTF_SHOW_COMPACT) ? "" : __btf_show_indent(show))
> > +
> > +#define btf_show_newline(show)
> > \
> > +	((show->flags & BTF_SHOW_COMPACT) ? "" : "\n")
> > +
> > +#define btf_show_delim(show)
> > \
> > +	(show->state.depth == 0 ? "" :
> > \
> > +	 ((show->flags & BTF_SHOW_COMPACT) && show->state.type &&
> > \
> > +	  BTF_INFO_KIND(show->state.type->info) == BTF_KIND_UNION) ? "|" :
> > ",")
> > +
> > +#define btf_show_type_value(show, fmt, value)
> > \
> > +	do {
> > \
> > +		if ((value) != 0 || (show->flags & BTF_SHOW_ZERO) ||
> > \
> > +		    show->state.depth == 0) {
> > \
> > +			btf_show(show, "%s%s" fmt "%s%s",
> > \
> > +				 btf_show_indent(show),
> > \
> > +				 btf_show_name(show),
> > \
> > +				 value, btf_show_delim(show),
> > \
> > +				 btf_show_newline(show));
> > \
> > +			if (show->state.depth > show->state.depth_shown)
> > \
> > +				show->state.depth_shown = show->state.depth;
> > \
> > +		}
> > \
> > +	} while (0)
> > +
> > +#define btf_show_type_values(show, fmt, ...)
> > \
> > +	do {
> > \
> > +		btf_show(show, "%s%s" fmt "%s%s", btf_show_indent(show),
> > \
> > +			 btf_show_name(show),
> > \
> > +			 __VA_ARGS__, btf_show_delim(show),
> > \
> > +			 btf_show_newline(show));
> > \
> > +		if (show->state.depth > show->state.depth_shown)
> > \
> > +			show->state.depth_shown = show->state.depth;
> > \
> > +	} while (0)
> > +
> [...]
> >   
> >   static int btf_array_check_member(struct btf_verifier_env *env,
> > @@ -2104,28 +2489,87 @@ static void btf_array_log(struct btf_verifier_env
> > *env,
> >   			 array->type, array->index_type, array->nelems);
> >   }
> >   
> > -static void btf_array_seq_show(const struct btf *btf, const struct btf_type
> > *t,
> > -			       u32 type_id, void *data, u8 bits_offset,
> > -			       struct seq_file *m)
> > +static void __btf_array_show(const struct btf *btf, const struct btf_type
> > *t,
> > +			     u32 type_id, void *data, u8 bits_offset,
> > +			     struct btf_show *show)
> >   {
> >    const struct btf_array *array = btf_type_array(t);
> >    const struct btf_kind_operations *elem_ops;
> >    const struct btf_type *elem_type;
> > -	u32 i, elem_size, elem_type_id;
> > +	u32 i, elem_size = 0, elem_type_id;
> > +	u16 encoding = 0;
> >   
> >   	elem_type_id = array->type;
> > -	elem_type = btf_type_id_size(btf, &elem_type_id, &elem_size);
> > +	elem_type = btf_type_skip_modifiers(btf, elem_type_id, NULL);
> > +	if (elem_type && btf_type_has_size(elem_type))
> > +		elem_size = elem_type->size;
> > +
> > +	if (elem_type && btf_type_is_int(elem_type)) {
> > +		u32 int_type = btf_type_int(elem_type);
> > +
> > +		encoding = BTF_INT_ENCODING(int_type);
> > +
> > +		/*
> > +		 * BTF_INT_CHAR encoding never seems to be set for
> > +		 * char arrays, so if size is 1 and element is
> > +		 * printable as a char, we'll do that.
> > +		 */
> > +		if (elem_size == 1) > +			encoding =
> > BTF_INT_CHAR;
> 
> Some char array may be printable and some may not be printable,
> how did you differentiate this?
>

I should probably change the logic to ensure all chars
(before a \0) are printable. I'll do that for v2. We will always
have cases (e.g. the skb cb[] field) where the char[] is not
intended as a string, but I think the utility of showing them as
strings where possible is worthwhile.

Thanks again for reviewing!

Alan 
