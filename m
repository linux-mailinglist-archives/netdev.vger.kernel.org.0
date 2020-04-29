Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554F21BDB72
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 14:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgD2MKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 08:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726839AbgD2MJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 08:09:59 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F9FC03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 05:09:58 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a21so2292482ljj.11
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 05:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vf+C8h6StAA506JOpXUrNr3zk91+ARS0zJo+xzqGFSM=;
        b=AfE53vwzbOZQG9Uwlxriq6fPJaGEMUtPe0Hwksu620raSx6aG9jXXeEvLaYxc7DXsQ
         tSjnin8aj8N/Tsz6yiadsD8zfH2gh7D9gJA+c7sxStIGh+qd1wpXqKJhUu6VhMGtPB0L
         JF4RJgu7DYUIuRaEnb2nlLIEmoLYiB1HsM9vM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vf+C8h6StAA506JOpXUrNr3zk91+ARS0zJo+xzqGFSM=;
        b=hYxGKwRt8sDzSDvMCbzirKMpyUbMtx5EQTjvvmjntruXjIyd3wwJES2kEaSJWjcGrW
         FUXqHy7y8Rr5r5NLldjuaEbZLO+QZ51fHqPwwJKBu0WhJDHDKK1RRpaf1ZG3t+F5vDEV
         PJkXFgrcQ+//JMvI5xZyL1p7b5pYoJOMDxBDF2LJZfqDFZlc0AtMTV+xPoJLrvDtijIM
         ZaOddMb717yM2oLpqzLAIQu2+sgBu3dn1wS3XRjRAPgIeXcytquSxCIUUDQg7LH2Zvbu
         txPN5nygtEe68LIPaG55/4hszVzh9ZuZJdB3Kf/DS0DlLmi47hexATV85zeX3p4tnYyC
         bh8A==
X-Gm-Message-State: AGi0PuZbzwZPAA2bhYsJN+OK27iVAD/vj4LsytvCJtXFz+cz3y37ukXD
        kmUAlC+ug5JmXdvTX+4n4RHRBg==
X-Google-Smtp-Source: APiQypJzptSBBRh75X9vhV9blZrxc5Txx3w9RoZ1NtiVRpqoc/aGP66FI+vqRmti+8gZltEmWBav3Q==
X-Received: by 2002:a2e:8e22:: with SMTP id r2mr20423968ljk.286.1588162196782;
        Wed, 29 Apr 2020 05:09:56 -0700 (PDT)
Received: from [192.168.1.149] (ip-5-186-116-45.cgn.fibianet.dk. [5.186.116.45])
        by smtp.gmail.com with ESMTPSA id w9sm2200503ljj.88.2020.04.29.05.09.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 05:09:56 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 5/6] printk: add type-printing %pT<type>
 format specifier which uses BTF
To:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com
Cc:     kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
 <1587120160-3030-6-git-send-email-alan.maguire@oracle.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <88794f69-0761-2261-6c1a-8dbf7188ab5b@rasmusvillemoes.dk>
Date:   Wed, 29 Apr 2020 14:09:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1587120160-3030-6-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/04/2020 12.42, Alan Maguire wrote:
> printk supports multiple pointer object type specifiers (printing
> netdev features etc).  Extend this support using BTF to cover
> arbitrary types.  "%pT" specifies the typed format, and a suffix
> enclosed <like this> specifies the type, for example, specifying
> 
> 	printk("%pT<struct sk_buff>", skb)
> 
> ...will utilize BTF information to traverse the struct sk_buff *
> and display it.  Support is present for structs, unions, enums,
> typedefs and core types (though in the latter case there's not
> much value in using this feature of course).
> 
> Default output is compact, specifying values only, but the
> 'N' modifier can be used to show field names to more easily
> track values.  Pointer values are obfuscated as usual.  As
> an example:
> 
>   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
>   pr_info("%pTN<struct sk_buff>", skb);
> 
> ...gives us:
> 
> {{{.next=00000000c7916e9c,.prev=00000000c7916e9c,{.dev=00000000c7916e9c|.dev_scratch=0}}|.rbnode={.__rb_parent_color=0,.rb_right=00000000c7916e9c,.rb_left=00000000c7916e9c}|.list={.next=00000000c7916e9c,.prev=00000000c7916e9c}},{.sk=00000000c7916e9c|.ip_defrag_offset=0},{.tstamp=0|.skb_mstamp_ns=0},.cb=['\0'],{{._skb_refdst=0,.destructor=00000000c7916e9c}|.tcp_tsorted_anchor={.next=00000000c7916e9c,.prev=00000000c7916e9c}},._nfct=0,.len=0,.data_len=0,.mac_len=0,.hdr_len=0,.queue_mapping=0,.__cloned_offset=[],.cloned=0x0,.nohdr=0x0,.fclone=0x0,.peeked=0x0,.head_frag=0x0,.pfmemalloc=0x0,.active_extensions=0,.headers_start=[],.__pkt_type_offset=[],.pkt_type=0x0,.ignore_df=0x0,.nf_trace=0x0,.ip_summed=0x0,.ooo_okay=0x0,.l4_hash=0x0,.sw_hash=0x0,.wifi_acked_valid=0x0,.wifi_acked=0x0,.no_fcs=0x0,.encapsulation=0x0,.encap_hdr_csum=0x0,.csum_valid=0x0,.__pkt_vlan_present_offset=[],.vlan_present=0x0,.csum_complete_sw=0x0,.csum_level=0x0,.csum_not_inet=0x0,.dst_pending_co
> 
> printk output is truncated at 1024 bytes.  For such cases, the compact
> display mode (minus the field info) may be used. "|" differentiates
> between different union members.
> 
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  Documentation/core-api/printk-formats.rst |   8 ++
>  include/linux/btf.h                       |   3 +-
>  lib/Kconfig                               |  16 ++++
>  lib/vsprintf.c                            | 145 +++++++++++++++++++++++++++++-
>  4 files changed, 169 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
> index 8ebe46b1..b786577 100644
> --- a/Documentation/core-api/printk-formats.rst
> +++ b/Documentation/core-api/printk-formats.rst
> @@ -545,6 +545,14 @@ For printing netdev_features_t.
>  
>  Passed by reference.
>  
> +BTF-based printing of pointer data
> +----------------------------------
> +If '%pT[N]<type_name>' is specified, use the BPF Type Format (BTF) to
> +show the typed data.  For example, specifying '%pT<struct sk_buff>' will utilize
> +BTF information to traverse the struct sk_buff * and display it.
> +
> +Supported modifer is 'N' (show type field names).
> +
>  Thanks
>  ======
>  
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 2f78dc8..456bd8f 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -158,10 +158,11 @@ static inline const struct btf_member *btf_type_member(const struct btf_type *t)
>  	return (const struct btf_member *)(t + 1);
>  }
>  
> +struct btf *btf_parse_vmlinux(void);
> +
>  #ifdef CONFIG_BPF_SYSCALL
>  const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
>  const char *btf_name_by_offset(const struct btf *btf, u32 offset);
> -struct btf *btf_parse_vmlinux(void);
>  struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
>  #else
>  static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
> diff --git a/lib/Kconfig b/lib/Kconfig
> index bc7e563..e92109e 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -6,6 +6,22 @@
>  config BINARY_PRINTF
>  	def_bool n
>  
> +config BTF_PRINTF

I don't see any IS_ENABLED(BTF_PRINTF) anywhere in this patch? Shouldn't
the vsprintf.c handler be guarded by that?

> +#define is_btf_fmt_start(c)	(c == 'T')
> +#define is_btf_type_start(c)	(c == '<')
> +#define is_btf_type_end(c)	(c == '>')
> +
> +#define btf_modifier_flag(c)	(c == 'N' ? BTF_SHOW_NAME : 0)
> +
> +static noinline_for_stack
> +const char *skip_btf_type(const char *fmt, bool *found_btf_type)
> +{
> +	*found_btf_type = false;
> +
> +	if (!is_btf_fmt_start(*fmt))
> +		return fmt;
> +	fmt++;
> +
> +	while (btf_modifier_flag(*fmt))
> +		fmt++;
> +
> +	if (!is_btf_type_start(*fmt))
> +		return fmt;
> +
> +	while (!is_btf_type_end(*fmt) && *fmt != '\0')
> +		fmt++;
> +
> +	if (is_btf_type_end(*fmt)) {
> +		fmt++;
> +		*found_btf_type = true;
> +	}
> +
> +	return fmt;
> +}
> +
> +static noinline_for_stack
> +char *btf_string(char *buf, char *end, void *ptr, struct printf_spec spec,
> +		 const char *fmt)
> +{
> +	const struct btf_type *btf_type;
> +	char btf_name[KSYM_SYMBOL_LEN];

That seems to be a rather arbitrary size.

> +	u8 btf_kind = BTF_KIND_TYPEDEF;
> +	const struct btf *btf;
> +	char *buf_start = buf;
> +	u64 flags = 0, mod;
> +	s32 btf_id;
> +	int i;
> +
> +	/*
> +	 * Accepted format is [format_modifiers]*<type> ;
> +	 * for example "%pTN<struct sk_buff>" will show a representation
> +	 * of the sk_buff pointed to by the associated argument including
> +	 * member names.
> +	 */
> +	if (check_pointer(&buf, end, ptr, spec))
> +		return buf;
> +
> +	while (isalpha(*fmt)) {
> +		mod = btf_modifier_flag(*fmt);
> +		if (!mod)
> +			break;
> +		flags |= mod;
> +		fmt++;
> +	}
> +
> +	if (!is_btf_type_start(*fmt))
> +		return error_string(buf, end, "(%pT?)", spec);
> +	fmt++;
> +
> +	if (isspace(*fmt))
> +		fmt = skip_spaces(++fmt);

Why not just "fmt = skip_spaces(fmt);"? But actually, why would you want
to support arbitrary whitespace at all? Surely "%pT< struct  abc  >" is
a programmer error.

> +	if (strncmp(fmt, "struct ", strlen("struct ")) == 0) {
> +		btf_kind = BTF_KIND_STRUCT;
> +		fmt += strlen("struct ");
> +	} else if (strncmp(fmt, "union ", strlen("union ")) == 0) {
> +		btf_kind = BTF_KIND_UNION;
> +		fmt += strlen("union ");
> +	} else if (strncmp(fmt, "enum ", strlen("enum ")) == 0) {
> +		btf_kind = BTF_KIND_ENUM;
> +		fmt += strlen("enum ");
> +	}
> +
> +	if (isspace(*fmt))
> +		fmt = skip_spaces(++fmt);
> +
> +	for (i = 0; isalnum(*fmt) || *fmt == '_'; fmt++, i++)
> +		btf_name[i] = *fmt;

So what ensures btf_name is big enough? It's more robust to just store
the starting value of fmt, fast-forward fmt over alnums, compute the
length since the start, bail if too big, otherwise memcpy to btf_name.

> +	btf_name[i] = '\0';
> +
> +	if (isspace(*fmt))
> +		fmt = skip_spaces(++fmt);

Please don't.

> +	if (strlen(btf_name) == 0 || !is_btf_type_end(*fmt))
> +		return error_string(buf, end, "(%pT?)", spec);
> +
> +	btf = bpf_get_btf_vmlinux();
> +	if (IS_ERR_OR_NULL(btf))
> +		return ptr_to_id(buf, end, ptr, spec);
> +
> +	/*
> +	 * Assume type specified is a typedef as there's not much
> +	 * benefit in specifying %p<int> other than wasting time
> +	 * on BTF lookups; we optimize for the most useful path.
> +	 *
> +	 * Fall back to BTF_KIND_INT if this fails.
> +	 */
> +	btf_id = btf_find_by_name_kind(btf, btf_name, btf_kind);
> +	if (btf_id < 0)
> +		btf_id = btf_find_by_name_kind(btf, btf_name,
> +					       BTF_KIND_INT);
> +
> +	if (btf_id >= 0)
> +		btf_type = btf_type_by_id(btf, btf_id);
> +	if (btf_id < 0 || !btf_type)
> +		return ptr_to_id(buf, end, ptr, spec);

That seems like a lot of work to have to do. I'm wondering if the
compiler can't help us in some way (but I know nothing about BTF, so
pardon my ignorance), given that the type printed is known by the
caller. What I'm thinking of is having some kind of

struct pT_arg { int cookie; void *p; }

#define pT_arg(p) &(struct pT_arg) { .cookie =
magic_compiler_thing(typeof(p)), .p = p}

printk("%pT", pT_arg(p));

Even if that can't be done, you could consider using that scheme for
passing the "struct foo_bar" string instead of doing the <> parsing,
i.e. the "cookie" above would just be a "const char *", and the pT_arg()
macro would be called as

pT_arg("struct sk_buff", skb).

Or, better yet, make that pT_arg(struct sk_buff, skb), use
stringification to create the const char* argument, but also add some
BUILD_BUG_ON(!(same_type(t *, typeof(p)) || same_type(const t *,
typeof(p))).

> +	buf += btf_type_snprintf_show(btf, btf_id, ptr, buf,
> +				      end - buf_start, flags);

Does that btf_type_snprintf_show() helper do the right thing when given
a negative or too-small buffer size? From a quick look at patch 3, I see
two problems in btf_snprintf_show():

+	if (ssnprintf->len < 0)
+		return;

That early returns seems to imply that we never produce the "what would
be printed" in case we're already past the end of the buffer.

+	if (len < 0) {
+		ssnprintf->len_left = 0;
+		ssnprintf->len = len;

Testing the return value from snprintf() for being negative is always wrong.


> +	return widen_string(buf, buf - buf_start, end, spec);

Well, ok, but I highly doubt anyone is going to pass a field_width to %pT.

> +}
> +
>  /*
>   * Show a '%p' thing.  A kernel extension is that the '%p' is followed
>   * by an extra set of alphanumeric characters that are extended format
> @@ -2169,6 +2291,15 @@ char *fwnode_string(char *buf, char *end, struct fwnode_handle *fwnode,
>   *		P node name, including a possible unit address
>   * - 'x' For printing the address. Equivalent to "%lx".
>   *
> + * - 'T[N<type_name>]' For printing pointer data using BPF Type Format (BTF).
> + *
> + *			Optional arguments are
> + *			N		print type and member names
> + *
> + *			Required options are
> + *			<type_name>	associated pointer is interpreted
> + *					to point at type_name.
> + *
>   * ** When making changes please also update:
>   *	Documentation/core-api/printk-formats.rst
>   *
> @@ -2251,6 +2382,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  		if (!IS_ERR(ptr))
>  			break;
>  		return err_ptr(buf, end, ptr, spec);
> +	case 'T':
> +		return btf_string(buf, end, ptr, spec, fmt + 1);
>  	}
>  
>  	/* default is to _not_ leak addresses, hash before printing */
> @@ -2506,6 +2639,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>  	unsigned long long num;
>  	char *str, *end;
>  	struct printf_spec spec = {0};
> +	bool found_btf_type;
>  
>  	/* Reject out-of-range values early.  Large positive sizes are
>  	   used for unknown buffer sizes. */
> @@ -2577,8 +2711,15 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>  		case FORMAT_TYPE_PTR:
>  			str = pointer(fmt, str, end, va_arg(args, void *),
>  				      spec);
> -			while (isalnum(*fmt))
> -				fmt++;
> +			/*
> +			 * BTF type info is enclosed <like this>, so can
> +			 * contain whitespace.
> +			 */
> +			fmt = skip_btf_type(fmt, &found_btf_type);
> +			if (!found_btf_type) {
> +				while (isalnum(*fmt))
> +					fmt++;
> +			}

As indicated above, this (or the helpers) wants some dependency on
CONFIG_BTF_PRINTF.

Rasmus
