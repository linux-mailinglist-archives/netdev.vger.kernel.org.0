Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9D2534D0F
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 12:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbiEZKMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 06:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347017AbiEZKMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 06:12:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4E962651;
        Thu, 26 May 2022 03:12:36 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A3931477;
        Thu, 26 May 2022 03:12:36 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.2.68])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78E903F70D;
        Thu, 26 May 2022 03:12:28 -0700 (PDT)
Date:   Thu, 26 May 2022 11:12:24 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        hpa@zytor.com, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH bpf-next v5 3/6] bpf: Remove is_valid_bpf_tramp_flags()
Message-ID: <Yo9SiJssne1oJgIq@FVFF77S0Q05N>
References: <20220518131638.3401509-1-xukuohai@huawei.com>
 <20220518131638.3401509-4-xukuohai@huawei.com>
 <Yo4y54M6Jb41lqX+@FVFF77S0Q05N>
 <985fe022-552c-9d04-16d8-14784c4075f8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <985fe022-552c-9d04-16d8-14784c4075f8@huawei.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 05:45:25PM +0800, Xu Kuohai wrote:
> On 5/25/2022 9:45 PM, Mark Rutland wrote:
> > On Wed, May 18, 2022 at 09:16:35AM -0400, Xu Kuohai wrote:
> >> BPF_TRAM_F_XXX flags are not used by user code and are almost constant
> >> at compile time, so run time validation is a bit overkill. Remove
> >> is_valid_bpf_tramp_flags() and add some usage comments.
> >>
> >> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> >> Acked-by: Song Liu <songliubraving@fb.com>
> > 
> > Am I right in thinking this is independent of the arm64-specific bits, and
> > could be taken on its own now?
> > 
> 
> Currenly is_valid_bpf_tramp_flags() is defined in x86 and called before
> bpf trampoline is constructed. The check logic is irrelevant to the
> architecture code. So we also need to call this function on arm64. But
> as Alexei pointed out, the check is not requried, so it's better to
> remove it before adding bpf trampoline to arm64.

Cool. So this patch could be merged now, even if the rest of the series needs
more work?

Thanks,
Mark.

> >> ---
> >>  arch/x86/net/bpf_jit_comp.c | 20 --------------------
> >>  kernel/bpf/bpf_struct_ops.c |  3 +++
> >>  kernel/bpf/trampoline.c     |  3 +++
> >>  3 files changed, 6 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> >> index a2b6d197c226..7698ef3b4821 100644
> >> --- a/arch/x86/net/bpf_jit_comp.c
> >> +++ b/arch/x86/net/bpf_jit_comp.c
> >> @@ -1922,23 +1922,6 @@ static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
> >>  	return 0;
> >>  }
> >>  
> >> -static bool is_valid_bpf_tramp_flags(unsigned int flags)
> >> -{
> >> -	if ((flags & BPF_TRAMP_F_RESTORE_REGS) &&
> >> -	    (flags & BPF_TRAMP_F_SKIP_FRAME))
> >> -		return false;
> >> -
> >> -	/*
> >> -	 * BPF_TRAMP_F_RET_FENTRY_RET is only used by bpf_struct_ops,
> >> -	 * and it must be used alone.
> >> -	 */
> >> -	if ((flags & BPF_TRAMP_F_RET_FENTRY_RET) &&
> >> -	    (flags & ~BPF_TRAMP_F_RET_FENTRY_RET))
> >> -		return false;
> >> -
> >> -	return true;
> >> -}
> >> -
> >>  /* Example:
> >>   * __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev);
> >>   * its 'struct btf_func_model' will be nr_args=2
> >> @@ -2017,9 +2000,6 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >>  	if (nr_args > 6)
> >>  		return -ENOTSUPP;
> >>  
> >> -	if (!is_valid_bpf_tramp_flags(flags))
> >> -		return -EINVAL;
> >> -
> >>  	/* Generated trampoline stack layout:
> >>  	 *
> >>  	 * RBP + 8         [ return address  ]
> >> diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
> >> index d9a3c9207240..0572cc5aeb28 100644
> >> --- a/kernel/bpf/bpf_struct_ops.c
> >> +++ b/kernel/bpf/bpf_struct_ops.c
> >> @@ -341,6 +341,9 @@ int bpf_struct_ops_prepare_trampoline(struct bpf_tramp_links *tlinks,
> >>  
> >>  	tlinks[BPF_TRAMP_FENTRY].links[0] = link;
> >>  	tlinks[BPF_TRAMP_FENTRY].nr_links = 1;
> >> +	/* BPF_TRAMP_F_RET_FENTRY_RET is only used by bpf_struct_ops,
> >> +	 * and it must be used alone.
> >> +	 */
> >>  	flags = model->ret_size > 0 ? BPF_TRAMP_F_RET_FENTRY_RET : 0;
> >>  	return arch_prepare_bpf_trampoline(NULL, image, image_end,
> >>  					   model, flags, tlinks, NULL);
> >> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> >> index 93c7675f0c9e..bd3f2e673874 100644
> >> --- a/kernel/bpf/trampoline.c
> >> +++ b/kernel/bpf/trampoline.c
> >> @@ -358,6 +358,9 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
> >>  
> >>  	if (tlinks[BPF_TRAMP_FEXIT].nr_links ||
> >>  	    tlinks[BPF_TRAMP_MODIFY_RETURN].nr_links)
> >> +		/* NOTE: BPF_TRAMP_F_RESTORE_REGS and BPF_TRAMP_F_SKIP_FRAME
> >> +		 * should not be set together.
> >> +		 */
> >>  		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
> >>  
> >>  	if (ip_arg)
> >> -- 
> >> 2.30.2
> >>
> > .
> 
