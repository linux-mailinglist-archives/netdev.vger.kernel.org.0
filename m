Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1589B286C76
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 03:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgJHBqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 21:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgJHBqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 21:46:00 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF1EC061755;
        Wed,  7 Oct 2020 18:45:58 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id t20so2298084qvv.8;
        Wed, 07 Oct 2020 18:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8xPZXqurmoKLP1UHXHTqNYMHqnVHm76fQwna6HsBE2k=;
        b=r8j27erinzcsKo3V0pwYKyIr/werd5KeyIGCMEHlTPMtm+hoRKbWivspQ63J1pQ5K3
         6zuSSxQl0XhDdW9G5xxS7hZ6rJ5iPLb+gsO00VUicwJjXZ7y9tKTN20oxTiqkmB/k9dK
         ujJu04JrWFdJSQNCRFkTCGX0tH9egDWawpa/E7yifwYQoB/26hhWAVGvZ0ubTE1Rm49h
         NLKYSoKb0Q/IVFx3Q8u+ZNktIkKCSamGC5nU2kIF0f3jTCTWk0cpamBmu66+vmJTQBp2
         5sV0O6nRClVxOHdxNGdlr53/KzepHZLSHs2JATZFfWCiyC4rWpiARFPUsOIc9sL8fOKk
         5mDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8xPZXqurmoKLP1UHXHTqNYMHqnVHm76fQwna6HsBE2k=;
        b=BHqv/WIZFqpg6DCNK689G+LEMK60VIfHhJj3cAWTZaHM2r4jFGTyZiYammfsd/SzIY
         CD1xJfEaQ5Z6MFGoGOTmRQB3TuhUWj3KKQwD1vklWUnUkWmuQc1xBrAwLCYt8SeGoIFQ
         HpaMw/TrY+/ZLPheSNu35sk0mvHDz8P+MivFbaNil+6aZmLFYSksBUUJR9yxYXoxiMRR
         NHZRFFli103619JL/XCdeNXYJNDuMpOTbnpVQBs2k5E2g+hZcVI9rjtLvfFiAXOYas1/
         zDU+quKlHD3LKfAw59d1MoDNPuGZ2LunxuqQrWukEv5gDDp/U/zgHb1xINL6rwuGVAiW
         rzWg==
X-Gm-Message-State: AOAM5324b9K0PTuYrtJVAU6osBOGSH7PFUXMCmS1Oa35t12Z+V5740rT
        0fOyqc/dXT1w84NGfXDG5+/WeARvrRj7Yg==
X-Google-Smtp-Source: ABdhPJwNvVfVL5Gm3b1yU4EIkInZQkCtX2mc/uJlUIBU5Y+VywR8Jj7E1lp2djhOVR5BZJg9s2b1eA==
X-Received: by 2002:a17:902:ab92:b029:d3:b2d3:43f0 with SMTP id f18-20020a170902ab92b02900d3b2d343f0mr5213744plr.56.1602121557314;
        Wed, 07 Oct 2020 18:45:57 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:a47c])
        by smtp.gmail.com with ESMTPSA id e2sm3900765pjw.13.2020.10.07.18.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 18:45:56 -0700 (PDT)
Date:   Wed, 7 Oct 2020 18:45:53 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/3] bpf: Propagate scalar ranges through
 register assignments.
Message-ID: <20201008014553.tbw7gioqnsg6zowb@ast-mbp>
References: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
 <20201006200955.12350-2-alexei.starovoitov@gmail.com>
 <5f7e52ce81308_1a83120890@john-XPS-13-9370.notmuch>
 <5f7e556c1e610_1a831208d2@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f7e556c1e610_1a831208d2@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 04:55:24PM -0700, John Fastabend wrote:
> John Fastabend wrote:
> > Alexei Starovoitov wrote:
> > > From: Alexei Starovoitov <ast@kernel.org>
> > > 
> > > The llvm register allocator may use two different registers representing the
> > > same virtual register. In such case the following pattern can be observed:
> > > 1047: (bf) r9 = r6
> > > 1048: (a5) if r6 < 0x1000 goto pc+1
> > > 1050: ...
> > > 1051: (a5) if r9 < 0x2 goto pc+66
> > > 1052: ...
> > > 1053: (bf) r2 = r9 /* r2 needs to have upper and lower bounds */
> > > 
> > > In order to track this information without backtracking allocate ID
> > > for scalars in a similar way as it's done for find_good_pkt_pointers().
> > > 
> > > When the verifier encounters r9 = r6 assignment it will assign the same ID
> > > to both registers. Later if either register range is narrowed via conditional
> > > jump propagate the register state into the other register.
> > > 
> > > Clear register ID in adjust_reg_min_max_vals() for any alu instruction.
> > 
> > Do we also need to clear the register ID on reg0 for CALL ops into a
> > helper?

Thank you for asking all those questions. Much appreciate it!

> > 
> > Looks like check_helper_call might mark reg0 as a scalar, but I don't
> > see where it would clear the reg->id? Did I miss it. Either way maybe
> > a comment here would help make it obvious how CALLs are handled?
> > 
> > Thanks,
> > John
> 
> OK sorry for the noise found it right after hitting send. Any call to
> mark_reg_unknown will zero the id.


Right. The verifier uses mark_reg_unknown() in lots of places,
so I figured it doesn't make sense to list them all.

> 
> /* Mark a register as having a completely unknown (scalar) value. */
> static void __mark_reg_unknown(const struct bpf_verifier_env *env,
> 			       struct bpf_reg_state *reg)
> {
> 	/*
> 	 * Clear type, id, off, and union(map_ptr, range) and
> 	 * padding between 'type' and union
> 	 */
> 	memset(reg, 0, offsetof(struct bpf_reg_state, var_off));

Excatly and the comment mentions 'id' too.

> 
> And check_helper_call() does,
> 
> 	/* update return register (already marked as written above) */
> 	if (fn->ret_type == RET_INTEGER) {
> 		/* sets type to SCALAR_VALUE */
> 		mark_reg_unknown(env, regs, BPF_REG_0);
> 
> so looks good to me. In the check_func_call() case the if is_global
> branch will mark_reg_unknown(). The other case only seems to do a
> clear_caller_saved_regs though. Is that enough?

clear_caller_saved_regs() -> mark_reg_not_init() -> __mark_reg_unknown().

I couldn't think of any other case where scalar's ID has to be cleared.
Any kind of assignment and r0 return do it as well.

We can clear id in r6 - r10 when we call a helper, but that's a bit
paranoid, since the registers are still valid and still equal.
Like:
r6 = r7
call foo
// after the call
if r6 > 5 goto
if r7 < 2 goto
// here both r6 and r7 will have bounds

I think it's good for the verifier to support that.

The other case with calls:

r1 = r2
call foo
  // and now inside the callee
  if r1 > 5 goto
  if r2 < 2 goto
  // here both r1 and r2 will have bounds

This case will also work.

Both cases are artificial and the verifier doesn't have to be that
smart, but it doesn't hurt and I don't think it's worth to restrict.

I'll add two synthetic tests for these cases.

Any other case you can think of ?
I think some time in the past you've mentioned that you hit
exactly this greedy register alloc issue in your cilium programs.
Is it the case or am I misremembering?
