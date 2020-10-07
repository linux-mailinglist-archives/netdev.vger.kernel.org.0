Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21031286BBF
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 01:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgJGX4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 19:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728960AbgJGXze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 19:55:34 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C30C061755;
        Wed,  7 Oct 2020 16:55:32 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id y13so940941iow.4;
        Wed, 07 Oct 2020 16:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Sly+jSo5uHkKVd82Cdup+xbB2BPZ+7ybPmcaK772I1Y=;
        b=MRNa0oGKp/jKa9gnd1DRIwo425fNSTops0T2KLhbsEMG2HR6IUsSmvmNX2RgVC6vS6
         94WS+7wFaHRISD0C+Edyn2inrNtwdrC9QB0ztPPfMoXGc1tVgwRxTQpJ9Arg9c6Hgs6z
         xUEWHHggvhDU/yojgaG0FfpVA1kX5VJF0qv7OqxiXUQ2RhXpLclp9EOwBA3HM5bhTRlD
         uC2omn/zQMWpIwEimvvkfDsLVNJTUF5e7W7mIZdnXZMeA4/4Ram88kulm5vhjXrPxMpW
         uXc77NS9lVT9aA+oml0TQ5/AVdb5vPMYf5jObNjb7LKQ13q4JSOvsDxYWPxu0q3k7ibE
         /Saw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Sly+jSo5uHkKVd82Cdup+xbB2BPZ+7ybPmcaK772I1Y=;
        b=LkBmQL1ywXo8HUShgdI1fOYHPEI/q7Uu8ylQ0MnGLAU3azgRnY9/R1jCfq9mMge62R
         BDCPWEBYu4X/aYDHF3h8sW9Rg75QzEsusYepZ2BjMrQCEH5OunjFKPsPgJQwQlZWc6HK
         Tw62OVyr9pvJSgfjWzYfdZza0gaemtcNpjrtMJuFJ3+L3sdgGQcUV867juOv6PdE7gig
         KggbxVMyspXdgxQlZNfTBmgZIJIChN/h3byU/2JDqKi/KsYWT/CHdF7VhlQaBIhMAuR5
         LphZCL9D2NnDimsTYndstA7ZcWzj+uq/PZhocE3jbFJ/irCcRnUp8EacfaaFfqp8OoKx
         zq+g==
X-Gm-Message-State: AOAM530C17jTGahV4dOZNEi8TBghg09abOPoJZXKQUtbwrLtB1FRf6t5
        9N5YYpqsWMBf/sF3A71I9L4=
X-Google-Smtp-Source: ABdhPJxoiqI9DEdSxF3ncfR6wgxjD+sn0UfuXLPPkI0SjxpvuX30vD6gIFYwmk9gCb/6gLlwRVbS3A==
X-Received: by 2002:a02:c499:: with SMTP id t25mr4861922jam.101.1602114932151;
        Wed, 07 Oct 2020 16:55:32 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v78sm1807782ilk.20.2020.10.07.16.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 16:55:31 -0700 (PDT)
Date:   Wed, 07 Oct 2020 16:55:24 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Message-ID: <5f7e556c1e610_1a831208d2@john-XPS-13-9370.notmuch>
In-Reply-To: <5f7e52ce81308_1a83120890@john-XPS-13-9370.notmuch>
References: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
 <20201006200955.12350-2-alexei.starovoitov@gmail.com>
 <5f7e52ce81308_1a83120890@john-XPS-13-9370.notmuch>
Subject: RE: [PATCH bpf-next 1/3] bpf: Propagate scalar ranges through
 register assignments.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> > 
> > The llvm register allocator may use two different registers representing the
> > same virtual register. In such case the following pattern can be observed:
> > 1047: (bf) r9 = r6
> > 1048: (a5) if r6 < 0x1000 goto pc+1
> > 1050: ...
> > 1051: (a5) if r9 < 0x2 goto pc+66
> > 1052: ...
> > 1053: (bf) r2 = r9 /* r2 needs to have upper and lower bounds */
> > 
> > In order to track this information without backtracking allocate ID
> > for scalars in a similar way as it's done for find_good_pkt_pointers().
> > 
> > When the verifier encounters r9 = r6 assignment it will assign the same ID
> > to both registers. Later if either register range is narrowed via conditional
> > jump propagate the register state into the other register.
> > 
> > Clear register ID in adjust_reg_min_max_vals() for any alu instruction.
> 
> Do we also need to clear the register ID on reg0 for CALL ops into a
> helper?
> 
> Looks like check_helper_call might mark reg0 as a scalar, but I don't
> see where it would clear the reg->id? Did I miss it. Either way maybe
> a comment here would help make it obvious how CALLs are handled?
> 
> Thanks,
> John

OK sorry for the noise found it right after hitting send. Any call to
mark_reg_unknown will zero the id.


/* Mark a register as having a completely unknown (scalar) value. */
static void __mark_reg_unknown(const struct bpf_verifier_env *env,
			       struct bpf_reg_state *reg)
{
	/*
	 * Clear type, id, off, and union(map_ptr, range) and
	 * padding between 'type' and union
	 */
	memset(reg, 0, offsetof(struct bpf_reg_state, var_off));


And check_helper_call() does,

	/* update return register (already marked as written above) */
	if (fn->ret_type == RET_INTEGER) {
		/* sets type to SCALAR_VALUE */
		mark_reg_unknown(env, regs, BPF_REG_0);

so looks good to me. In the check_func_call() case the if is_global
branch will mark_reg_unknown(). The other case only seems to do a
clear_caller_saved_regs though. Is that enough?

.John


> 
> > 
> > Newly allocated register ID is ignored for scalars in regsafe() and doesn't
> > affect state pruning. mark_reg_unknown() also clears the ID.
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >  kernel/bpf/verifier.c                         | 38 +++++++++++++++++++
> >  .../testing/selftests/bpf/prog_tests/align.c  | 16 ++++----
> >  .../bpf/verifier/direct_packet_access.c       |  2 +-
> >  3 files changed, 47 insertions(+), 9 deletions(-)
> > 
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 01120acab09a..09e17b483b0b 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -6432,6 +6432,8 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
> >  	src_reg = NULL;
> >  	if (dst_reg->type != SCALAR_VALUE)
> >  		ptr_reg = dst_reg;
> > +	else
> > +		dst_reg->id = 0;
> >  	if (BPF_SRC(insn->code) == BPF_X) {
> >  		src_reg = &regs[insn->src_reg];
> >  		if (src_reg->type != SCALAR_VALUE) {
> > @@ -6565,6 +6567,8 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
> >  				/* case: R1 = R2
> >  				 * copy register state to dest reg
> >  				 */
> > +				if (src_reg->type == SCALAR_VALUE)
> > +					src_reg->id = ++env->id_gen;
> >  				*dst_reg = *src_reg;
> >  				dst_reg->live |= REG_LIVE_WRITTEN;
> >  				dst_reg->subreg_def = DEF_NOT_SUBREG;
> > @@ -7365,6 +7369,30 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
> >  	return true;
> >  }


