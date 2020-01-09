Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73E27136325
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbgAIWRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:17:44 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36516 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgAIWRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 17:17:43 -0500
Received: by mail-pf1-f194.google.com with SMTP id x184so89418pfb.3;
        Thu, 09 Jan 2020 14:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZjlXGrcIrgSYd6x8hwZXT+u8KxCmGaYuFNLU0pV4LNk=;
        b=WxtZkCCHdaWDmmKC9OvjWwBWRg6wUEtsaca3Ni6W/t29kTmhY6V+WWtwcTz6PdVtAx
         5FIHxcZxsJIUHm6AVTjrxTd3H2OqzssNikh5Lqp2IMqwzc4xdSUuNNFzEyZrlHuxWf6z
         5e7254/iSoLjOSlg0AxDbRaqC7fu2gVXlbQ/iOPewHIiL4lDAIyJYramq24gH3fOGVSa
         o5V+RWTb5mGY6crzoBrYvaUY5su3S6+YCZA/RjEzCKogFIdbHA1h9SfaLLQGE3Etoqcj
         ECGLsO2RtIq4wKmdvjAeqtDusWmqVKDPc3vGqW3oksVKW7Frp5L7heAIW/nGSxodtriZ
         yEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZjlXGrcIrgSYd6x8hwZXT+u8KxCmGaYuFNLU0pV4LNk=;
        b=qh9HV3vXQW8F7dOR50y6Id40RjFZl+AllVXrFEyicBb0bxmb+prng9X79MgNkXcx/p
         NKaORwKGrIF+2LRI9vDmWHQ/a2mHBb9uKU+0T0pbm70HN23pGY6UTtPW74zgPNzhCDb0
         7IDeQi54iBvcN0LzU7nqi7oPxwKyLoaX18AwODJ9Goq96Ky240Sdxbr+WECTKVI9zW44
         k5s001T9mY9KS2actd8HkHgltXbiQe/wkLzps98q8tHW6whGI6G7964SsBcpqfTba9Wg
         2OF+z/ZbKRWAE542WB65UdYSIugHB4KoH/b+6h0MRrN2qVfXaX6vtvDHH5KhecK8BMCS
         lECA==
X-Gm-Message-State: APjAAAUOLrkDLJ0pookHM4CZB08hj9r7gIc+xDeTZInebyEiBHphaf2B
        asl10gdUbCy3w4G5xv1gT8gsaUWH
X-Google-Smtp-Source: APXvYqwalZ4S/hjcSupy+pc7zuTVdkVGqOOt2RIXBjcml6cPwvuNvlPRWgWmY5mIsrY/5le2ehMjfQ==
X-Received: by 2002:a63:360a:: with SMTP id d10mr254569pga.366.1578608262732;
        Thu, 09 Jan 2020 14:17:42 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::3:d3c9])
        by smtp.gmail.com with ESMTPSA id n15sm8755506pgf.17.2020.01.09.14.17.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jan 2020 14:17:41 -0800 (PST)
Date:   Thu, 9 Jan 2020 14:17:40 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 3/7] bpf: Introduce function-by-function
 verification
Message-ID: <20200109221739.a7wuiqe37rqameqh@ast-mbp>
References: <20200109063745.3154913-1-ast@kernel.org>
 <20200109063745.3154913-4-ast@kernel.org>
 <B7A2A8DD-B070-4F80-A9A0-6570260D4346@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B7A2A8DD-B070-4F80-A9A0-6570260D4346@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 06:09:08PM +0000, Song Liu wrote:
> 
> 
> > On Jan 8, 2020, at 10:37 PM, Alexei Starovoitov <ast@kernel.org> wrote:
> 
> [...]
> 
> > 
> > Note that the stack limit of 512 still applies to the call chain regardless whether
> > functions were static or global. The nested level of 8 also still applies. The
> > same recursion prevention checks are in place as well.
> > 
> > The type information and static/global kind is preserved after the verification
> > hence in the above example global function f2() and f3() can be replaced later
> > by equivalent functions with the same types that are loaded and verified later
> > without affecting safety of this main() program. Such replacement (re-linking)
> > of global functions is a subject of future patches.
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> 
> With one nit below. 
> 
> [...]
> 
> > +
> > +static int do_check_common(struct bpf_verifier_env *env, int subprog)
> > +{
> > +	struct bpf_verifier_state *state;
> > +	struct bpf_reg_state *regs;
> > +	int ret, i;
> > +
> > +	env->prev_linfo = NULL;
> > +	env->pass_cnt++;
> > +
> > +	state = kzalloc(sizeof(struct bpf_verifier_state), GFP_KERNEL);
> > +	if (!state)
> > +		return -ENOMEM;
> > +	state->curframe = 0;
> > +	state->speculative = false;
> > +	state->branches = 1;
> > +	state->frame[0] = kzalloc(sizeof(struct bpf_func_state), GFP_KERNEL);
> > +	if (!state->frame[0]) {
> > +		kfree(state);
> > +		return -ENOMEM;
> > +	}
> > +	env->cur_state = state;
> > +	init_func_state(env, state->frame[0],
> > +			BPF_MAIN_FUNC /* callsite */,
> > +			0 /* frameno */,
> > +			subprog);
> > +
> > +	regs = state->frame[state->curframe]->regs;
> > +	if (subprog) {
> > +		ret = btf_prepare_func_args(env, subprog, regs);
> > +		if (ret)
> > +			goto out;
> > +		for (i = BPF_REG_1; i <= BPF_REG_5; i++) {
> > +			if (regs[i].type == PTR_TO_CTX)
> > +				mark_reg_known_zero(env, regs, i);
> > +			else if (regs[i].type == SCALAR_VALUE)
> > +				mark_reg_unknown(env, regs, i);
> > +		}
> > +	} else {
> > +		/* 1st arg to a function */
> > +		regs[BPF_REG_1].type = PTR_TO_CTX;
> > +		mark_reg_known_zero(env, regs, BPF_REG_1);
> > +		ret = btf_check_func_arg_match(env, subprog, regs);
> > +		if (ret == -EFAULT)
> > +			/* unlikely verifier bug. abort.
> > +			 * ret == 0 and ret < 0 are sadly acceptable for
> > +			 * main() function due to backward compatibility.
> > +			 * Like socket filter program may be written as:
> > +			 * int bpf_prog(struct pt_regs *ctx)
> > +			 * and never dereference that ctx in the program.
> > +			 * 'struct pt_regs' is a type mismatch for socket
> > +			 * filter that should be using 'struct __sk_buff'.
> > +			 */
> > +			goto out;
> > +	}
> > +
> > +	ret = do_check(env);
> > +out:
> > +	if (env->cur_state) {
> 
> I think env->cur_state will never be NULL here. This check is necessary 
> before this patch (when we allocate cur_state in do_check()). 

yeah. good catch. 'if' can be dropped. I'll follow up with a clean up patch or
will fold it if respin is necessary for other reasons.
