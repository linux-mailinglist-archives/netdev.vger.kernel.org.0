Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA9B5C0CA
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730220AbfGAQBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:01:24 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46873 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbfGAQBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:01:24 -0400
Received: by mail-pf1-f193.google.com with SMTP id 81so6784616pfy.13
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 09:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w3AGTFi2yabi5fElCsgG+H002dZt0acoXonnlRJZ73k=;
        b=nm4XIGXKGBE6KrktK3E3hZx4MKTXFtAaMHToLPzuN95J0N9URuAklZcgDUiut049Y8
         1AzSrJZ3BdZYW/MbvqCtTIWWNOAqgoQdovo7PNCtvchhoAgizigOxcxh95Op20snbDNb
         2OcMQNS7NqjQTk3YhwG+qkJzDQpGLoLZdxp/uCttW9QBX1AbAKv3nOVPGB+2t0OF+hsN
         inI2JzxrWKecYuXUJfd26ve8o06Nx7UYXZApX0KAqQGPxTqQ0LAb/fe9t5lXAYdnRNV7
         kErg5+hKo1riQKZAhIGCVmM0sT4NSbuiaMZI0eUXraphm/Wz28FoZcnLVPQtDYLtD5Xj
         6j4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=w3AGTFi2yabi5fElCsgG+H002dZt0acoXonnlRJZ73k=;
        b=JmFs5py8enTnGQtTmnfLHIkI7huJyb17hUbRdW5ZqaDq+Z4m2utLJ2OL3fQA0PXXDq
         PvVOBXaL/USak5Hl+I0fIcMeopfqkJMmKxLMrwBa17k/eocuwtIs9j6v2UXydatihmyD
         4rr3e+Q9L5cmbQTTSAjczrqytvrDWp6KvF0t4ORUcDLqdkqQzVvzNcbhQGJOagpqzHoG
         ZlbucbmUwIVfNh5E3OhA96ZhHFsSXJPo7HZl9+4mln0PL14dnPaAzBxemze+oqTH9CbU
         TxrBbPsx15zFxOPOR6cfxH56nQxJAUZUHu3GPIydSNZ00aNfI6yzkRDOwPn0Dv92Va6m
         0NiA==
X-Gm-Message-State: APjAAAUZ6PDZn/yW2VrbkngECBksMztc8BPhkNnOUdFCbUk7NfocihBs
        DvKgni7dwsntUG2IlkqzHQlR3Q==
X-Google-Smtp-Source: APXvYqwuzxgHKc7OFqqS5dyU2gwLHaJn/dfryRrxwmrqJK3vmyIMwKqrd+J4mRsCe0YZZBvZ6LxK0w==
X-Received: by 2002:a63:6883:: with SMTP id d125mr25911453pgc.281.1561996883384;
        Mon, 01 Jul 2019 09:01:23 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id n1sm9175872pgv.15.2019.07.01.09.01.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 09:01:22 -0700 (PDT)
Date:   Mon, 1 Jul 2019 09:01:22 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Yonghong Song <yhs@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: allow wide (u64) aligned stores for
 some fields of bpf_sock_addr
Message-ID: <20190701160122.GC6757@mini-arch>
References: <20190628231049.22149-1-sdf@google.com>
 <be223396-b181-e587-d63c-2b15eaca3721@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be223396-b181-e587-d63c-2b15eaca3721@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/30, Yonghong Song wrote:
> 
> 
> On 6/28/19 4:10 PM, Stanislav Fomichev wrote:
> > Since commit cd17d7770578 ("bpf/tools: sync bpf.h") clang decided
> > that it can do a single u64 store into user_ip6[2] instead of two
> > separate u32 ones:
> > 
> >   #  17: (18) r2 = 0x100000000000000
> >   #  ; ctx->user_ip6[2] = bpf_htonl(DST_REWRITE_IP6_2);
> >   #  19: (7b) *(u64 *)(r1 +16) = r2
> >   #  invalid bpf_context access off=16 size=8
> > 
> >  From the compiler point of view it does look like a correct thing
> > to do, so let's support it on the kernel side.
> > 
> > Credit to Andrii Nakryiko for a proper implementation of
> > bpf_ctx_wide_store_ok.
> > 
> > Cc: Andrii Nakryiko <andriin@fb.com>
> > Cc: Yonghong Song <yhs@fb.com>
> > Fixes: cd17d7770578 ("bpf/tools: sync bpf.h")
> > Reported-by: kernel test robot <rong.a.chen@intel.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> 
> The change looks good to me with the following nits:
>    1. could you add a cover letter for the patch set?
>       typically if the number of patches is more than one,
>       it would be a good practice with a cover letter.
>       See bpf_devel_QA.rst .
>    2. with this change, the comments in uapi bpf.h
>       are not accurate any more.
>          __u32 user_ip6[4];      /* Allows 1,2,4-byte read an 4-byte write.
>                                   * Stored in network byte order. 
> 
>                                   */
>          __u32 msg_src_ip6[4];   /* Allows 1,2,4-byte read an 4-byte write.
>                                   * Stored in network byte order.
>                                   */
>       now for stores, aligned 8-byte write is permitted.
>       could you update this as well?
> 
>  From the typical usage pattern, I did not see a need
> for 8-tye read of user_ip6 and msg_src_ip6 yet. So let
> us just deal with write for now.
> 
> With the above two nits,
> Acked-by: Yonghong Song <yhs@fb.com>
Thank you for a review, will follow up with a v2 shortly with both
things addressed!

> > ---
> >   include/linux/filter.h |  6 ++++++
> >   net/core/filter.c      | 22 ++++++++++++++--------
> >   2 files changed, 20 insertions(+), 8 deletions(-)
> > 
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index 340f7d648974..3901007e36f1 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -746,6 +746,12 @@ bpf_ctx_narrow_access_ok(u32 off, u32 size, u32 size_default)
> >   	return size <= size_default && (size & (size - 1)) == 0;
> >   }
> >   
> > +#define bpf_ctx_wide_store_ok(off, size, type, field)			\
> > +	(size == sizeof(__u64) &&					\
> > +	off >= offsetof(type, field) &&					\
> > +	off + sizeof(__u64) <= offsetofend(type, field) &&		\
> > +	off % sizeof(__u64) == 0)
> > +
> >   #define bpf_classic_proglen(fprog) (fprog->len * sizeof(fprog->filter[0]))
> >   
> >   static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index dc8534be12fc..5d33f2146dab 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -6849,6 +6849,16 @@ static bool sock_addr_is_valid_access(int off, int size,
> >   			if (!bpf_ctx_narrow_access_ok(off, size, size_default))
> >   				return false;
> >   		} else {
> > +			if (bpf_ctx_wide_store_ok(off, size,
> > +						  struct bpf_sock_addr,
> > +						  user_ip6))
> > +				return true;
> > +
> > +			if (bpf_ctx_wide_store_ok(off, size,
> > +						  struct bpf_sock_addr,
> > +						  msg_src_ip6))
> > +				return true;
> > +
> >   			if (size != size_default)
> >   				return false;
> >   		}
> > @@ -7689,9 +7699,6 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> >   /* SOCK_ADDR_STORE_NESTED_FIELD_OFF() has semantic similar to
> >    * SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF() but for store operation.
> >    *
> > - * It doesn't support SIZE argument though since narrow stores are not
> > - * supported for now.
> > - *
> >    * In addition it uses Temporary Field TF (member of struct S) as the 3rd
> >    * "register" since two registers available in convert_ctx_access are not
> >    * enough: we can't override neither SRC, since it contains value to store, nor
> > @@ -7699,7 +7706,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> >    * instructions. But we need a temporary place to save pointer to nested
> >    * structure whose field we want to store to.
> >    */
> > -#define SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, OFF, TF)		       \
> > +#define SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, SIZE, OFF, TF)	       \
> >   	do {								       \
> >   		int tmp_reg = BPF_REG_9;				       \
> >   		if (si->src_reg == tmp_reg || si->dst_reg == tmp_reg)	       \
> > @@ -7710,8 +7717,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> >   				      offsetof(S, TF));			       \
> >   		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(S, F), tmp_reg,	       \
> >   				      si->dst_reg, offsetof(S, F));	       \
> > -		*insn++ = BPF_STX_MEM(					       \
> > -			BPF_FIELD_SIZEOF(NS, NF), tmp_reg, si->src_reg,	       \
> > +		*insn++ = BPF_STX_MEM(SIZE, tmp_reg, si->src_reg,	       \
> >   			bpf_target_off(NS, NF, FIELD_SIZEOF(NS, NF),	       \
> >   				       target_size)			       \
> >   				+ OFF);					       \
> > @@ -7723,8 +7729,8 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
> >   						      TF)		       \
> >   	do {								       \
> >   		if (type == BPF_WRITE) {				       \
> > -			SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, OFF,    \
> > -							 TF);		       \
> > +			SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, SIZE,   \
> > +							 OFF, TF);	       \
> >   		} else {						       \
> >   			SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF(		       \
> >   				S, NS, F, NF, SIZE, OFF);  \
> > 
