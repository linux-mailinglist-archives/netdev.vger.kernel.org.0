Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0885014A819
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 17:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgA0Qcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 11:32:42 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34968 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0Qcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 11:32:42 -0500
Received: by mail-pj1-f66.google.com with SMTP id q39so3329670pjc.0;
        Mon, 27 Jan 2020 08:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=yfqKKScN9erJDLyfAZ/eeOFCFvHhzHx9ItrFxMErWaY=;
        b=XIhROTkAa/1F+4Ob/nffmYpH9qUBNBVG75VLRRErPkZsKgXCyU0exw79/vU7xYpe+b
         lM90WmSSbeOCvvOvTfK3OHfLzHXAiIy6EsxUS5i7XiNwQsmsgelJJ9MMQ/8iuM7Rz2o/
         kG51IKxMDjbgbVxXmlD0HF2qHitKwAl1kofZaah46h6oDakwWZ/H+2K6zCF5ZZkN6xOm
         hV3JZtL8FT9NDjZZ6B3noKDof0f1b9UTgJkg1b+bT7OOwE6D102dtMjh94zxEp1svC28
         eRyL79PdD1XeJplhi+j9HOLw7CW5iUcyKkXXmjtXsTI5nSQ4AnrBREnZz8Cf/T86iMue
         7z9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=yfqKKScN9erJDLyfAZ/eeOFCFvHhzHx9ItrFxMErWaY=;
        b=eTTn7AK0SOvEPf4IfBHCw4u/yzsAp+NDnqjsAXN98xKpi7zhZd4WRa9607s2CQ6OEj
         Yz/jkQ3nmmhXOf85loFV6w8wmkWl5ARIWh2ueQPiuAnnkaBGo89yP8WILdCbOfrEMKo0
         1CeGuJ5AWwHxlzNlvwZY7yK5YLY9l3I4ioM5y2iLAlhSE7HhfaPJ/Rj142mG5fh+wf9I
         Wyup2fqrqAJ+kOdIJN9ciuppIhyt9QP6yiJeNGwJlweuZEnYGh3C8AR0f9nlrY+NFXkN
         DfldHIGHItt7He92gfdlJ7Heowni19qnxXQMgGFLnwmorXrKk6KduIF+HQTDNoSUoBvV
         5aWg==
X-Gm-Message-State: APjAAAVICwEuQo84DPwYPaDEGMHQofrXzQwFNgSrE3AaX2hzkP32K1yb
        ozWsYL4wTCT1Tl4VlpWdr1V3N29B
X-Google-Smtp-Source: APXvYqy6EgI1L9vwsCy8g59TRXDHAxWSeqWJHuy3+MTXGVyrDfzg0vROXTxK1ThyhxhMpj1sjFW0NQ==
X-Received: by 2002:a17:902:8a8d:: with SMTP id p13mr18076146plo.159.1580142761041;
        Mon, 27 Jan 2020 08:32:41 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 72sm12931000pfw.7.2020.01.27.08.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 08:32:40 -0800 (PST)
Date:   Mon, 27 Jan 2020 08:32:33 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Cc:     yhs@fb.com, ast@kernel.org, netdev@vger.kernel.org
Message-ID: <5e2f10a13d270_16ba2b17879225c4e5@john-XPS-13-9370.notmuch>
In-Reply-To: <a181642e-a479-2485-dd57-a8f13e59c3dd@iogearbox.net>
References: <158007722209.21106.17558935396388172908.stgit@john-XPS-13-9370>
 <a181642e-a479-2485-dd57-a8f13e59c3dd@iogearbox.net>
Subject: Re: [bpf PATCH v2] bpf: verifier, do_refine_retval_range may clamp
 umin to 0 incorrectly
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 1/26/20 11:20 PM, John Fastabend wrote:
> > do_refine_retval_range() is called to refine return values from specified
> > helpers, probe_read_str and get_stack at the moment, the reasoning is
> > because both have a max value as part of their input arguments and
> > because the helper ensure the return value will not be larger than this
> > we can set smax values of the return register, r0.
> > 
> > However, the return value is a signed integer so setting umax is incorrect
> > It leads to further confusion when the do_refine_retval_range() then calls,
> > __reg_deduce_bounds() which will see a umax value as meaning the value is
> > unsigned and then assuming it is unsigned set the smin = umin which in this
> > case results in 'smin = 0' and an 'smax = X' where X is the input argument
> > from the helper call.
> > 
> > Here are the comments from _reg_deduce_bounds() on why this would be safe
> > to do.
> > 
> >   /* Learn sign from unsigned bounds.  Signed bounds cross the sign
> >    * boundary, so we must be careful.
> >    */
> >   if ((s64)reg->umax_value >= 0) {
> > 	/* Positive.  We can't learn anything from the smin, but smax
> > 	 * is positive, hence safe.
> > 	 */
> > 	reg->smin_value = reg->umin_value;
> > 	reg->smax_value = reg->umax_value = min_t(u64, reg->smax_value,
> > 						  reg->umax_value);
> > 
> > But now we incorrectly have a return value with type int with the
> > signed bounds (0,X). Suppose the return value is negative, which is
> > possible the we have the verifier and reality out of sync. Among other
> > things this may result in any error handling code being falsely detected
> > as dead-code and removed. For instance the example below shows using
> > bpf_probe_read_str() causes the error path to be identified as dead
> > code and removed.
> > 
> >>From the 'llvm-object -S' dump,
> > 
> >   r2 = 100
> >   call 45
> >   if r0 s< 0 goto +4
> >   r4 = *(u32 *)(r7 + 0)
> > 
> > But from dump xlate
> > 
> >    (b7) r2 = 100
> >    (85) call bpf_probe_read_compat_str#-96768
> >    (61) r4 = *(u32 *)(r7 +0)  <-- dropped if goto
> > 
> > Due to verifier state after call being
> > 
> >   R0=inv(id=0,umax_value=100,var_off=(0x0; 0x7f))
> > 
> > To fix omit setting the umax value because its not safe. The only
> > actual bounds we know is the smax. This results in the correct bounds
> > (SMIN, X) where X is the max length from the helper. After this the
> > new verifier state looks like the following after call 45.
> > 
> > R0=inv(id=0,smax_value=100)
> > 
> > Then xlated version no longer removed dead code giving the expected
> > result,
> > 
> >    (b7) r2 = 100
> >    (85) call bpf_probe_read_compat_str#-96768
> >    (c5) if r0 s< 0x0 goto pc+4
> >    (61) r4 = *(u32 *)(r7 +0)
> > 
> > Note, bpf_probe_read_* calls are root only so we wont hit this case
> > with non-root bpf users.
> > 
> > v2 note: In original version we set msize_smax_value from check_func_arg()
> > and propagated this into smax of retval. The logic was smax is the bound
> > on the retval we set and because the type in the helper is ARG_CONST_SIZE
> > we know that the reg is a positive tnum_const() so umax=smax. Alexei
> > pointed out though this is a bit odd to read because the register in
> > check_func_arg() has a C type of u32 and the umax bound would be the
> > normally relavent bound here. Pulling in extra knowledge about future
> > checks makes reading the code a bit tricky. Further having a signed
> > meta data that can only ever be positive is also a bit odd. So dropped
> > the msize_smax_value metadata and made it a u64 msize_max_Value to
> > indicate its unsigned. And additionally save bound from umax value in
> > check_arg_funcs which is the same as smax due to as noted above tnumx_cont
> > and negative check but reads better. By my analysis nothing functionally
> > changes in v2 but it does get easier to read so that is win.
> > 
> > Fixes: 849fa50662fbc ("bpf: verifier, refine bounds may clamp umin to 0 incorrectly")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> 
> The Fixes tag is not correct. I presume you meant to say:
> 
> Fixes: 849fa50662fbc ("bpf/verifier: refine retval R0 state for bpf_get_stack helper")

correct thanks.

> 
> > ---
> >   kernel/bpf/verifier.c |   20 ++++++++++++--------
> >   1 file changed, 12 insertions(+), 8 deletions(-)
> > 
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 7d530ce8719d..1c63436510d8 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -227,8 +227,7 @@ struct bpf_call_arg_meta {
> >   	bool pkt_access;
> >   	int regno;
> >   	int access_size;
> > -	s64 msize_smax_value;
> > -	u64 msize_umax_value;
> > +	u64 msize_max_value;
> >   	int ref_obj_id;
> >   	int func_id;
> >   	u32 btf_id;
> > @@ -3569,11 +3568,16 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
> >   	} else if (arg_type_is_mem_size(arg_type)) {
> >   		bool zero_size_allowed = (arg_type == ARG_CONST_SIZE_OR_ZERO);
> >   
> > -		/* remember the mem_size which may be used later
> > -		 * to refine return values.
> > +		/* This is used to refine r0 return value bounds for helpers
> > +		 * that enforce this value as an upper bound on return values.
> > +		 * See do_refine_retval_range() for helpers that can refine
> > +		 * the return value. C type of helper is u32 so we pull register
> > +		 * bound from umax_value however, if not a const then meta
> > +		 * is null'd and if negative verifier errors out. Only upper
> 
> The 'meta is null'd' part for non-const, isn't this irrelevant in this case? Meaning,
> we'll still adapt the ret register with msize_max_value in this case and it provides
> the upper bound same way as with const reg (just for latter that min==max).

Agreed unrelevant info I'll remove it so we don't confuse people.

> 
> > +		 * bounds can be learned because retval is an int type and
> > +		 * negative retvals are allowed.
> >   		 */
> > -		meta->msize_smax_value = reg->smax_value;
> > -		meta->msize_umax_value = reg->umax_value;
> > +		meta->msize_max_value = reg->umax_value;
> >   
> >   		/* The register is SCALAR_VALUE; the access check
> >   		 * happens using its boundaries.
> > @@ -4077,10 +4081,10 @@ static void do_refine_retval_range(struct bpf_reg_state *regs, int ret_type,
> >   	     func_id != BPF_FUNC_probe_read_str))
> >   		return;
> >   
> > -	ret_reg->smax_value = meta->msize_smax_value;
> > -	ret_reg->umax_value = meta->msize_umax_value;
> > +	ret_reg->smax_value = meta->msize_max_value;
> >   	__reg_deduce_bounds(ret_reg);
> >   	__reg_bound_offset(ret_reg);
> > +	__update_reg_bounds(ret_reg);
> >   }
> >   
> >   static int
> > 
> 


