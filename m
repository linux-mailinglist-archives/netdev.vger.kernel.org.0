Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6041D0296
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 00:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731293AbgELW4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 18:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728286AbgELW4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 18:56:05 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7235EC061A0C;
        Tue, 12 May 2020 15:56:05 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x13so1202942pfn.11;
        Tue, 12 May 2020 15:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kmjMSsilvDueKCK4rnatBS9cG7gtBraddvhfZMJ/pb8=;
        b=ubZwQfzsC/hTSlz0kXIlR4cEfEBbkiYhSmszg0kWBDy0N7FwI9prFaM/YctRcKuBdB
         za61grOEe6n9akYDTRjponySuXxJyhCmkWD7ui8L0IvLAfyjb4bRG68WIjNBPoAwTpbB
         gkvIaBhIq0ea65JZ+txHoMH7XSNMTd5DIkyvyOSvm5ppolqAyr9psauQsMwvOWp2Q8+T
         f8O7Rd77fAaI2HthsTEh5ALcFWyP4rbfQwLvT3hJ8IhcpK/QVccrhhfUDqVV2PzXNgFz
         SIUnuTliHxQCfTMPAJ4+sa8ZTu2B9BSrDJv9GcOqG8dUZUsmdTQ8EICOKA8OrJMsGVYi
         P8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kmjMSsilvDueKCK4rnatBS9cG7gtBraddvhfZMJ/pb8=;
        b=IQE9Jol0EiSe4dTxpXRrrEREl60QBmwCIaItTXkrKbvaRdQu09MBPcdYJ7/DBktK1W
         urMHMRlPw6C2DcFkf9/h8Fknb8dr1CACNj1zXv+xpGz+G8VW1U3BR07J74QP41YoYtJO
         ieTzGL432kRsSQHE17zlHUV+ls0uh+uF/D1FXQSHKKW+e9ShmlZ85t1ZYWg+jb9VIYXk
         LlMhmEByM1vptA8HoZE1c1L0jJu3cC89P+JFvkwTrOtV90dDr8ePkiliem5wYteI/7o0
         uTHUA9I2svzeIpGMzXTfb0Vc4oXT8yjGPc7dTG0iVf1g6eL1S0hW5vzN8Km+1ro21a1k
         Mv3w==
X-Gm-Message-State: AGi0PuZpvH3SP7if1rkXVNfGhU+f2iBIOz/fCPsx7HEiVk0+T+yP4xBa
        zBmF4p4nPcG9KTkOmXbAl3c=
X-Google-Smtp-Source: APiQypLdoPtuqafQKiHCEZklO5IrF/a5YEbLDP9nz8pRH/ym5xy376nOJjN176qZY+A2Q0UVjlmAQg==
X-Received: by 2002:a62:ab16:: with SMTP id p22mr22065653pff.216.1589324164815;
        Tue, 12 May 2020 15:56:04 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:68dc])
        by smtp.gmail.com with ESMTPSA id z190sm12850797pfz.84.2020.05.12.15.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 15:56:03 -0700 (PDT)
Date:   Tue, 12 May 2020 15:56:01 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com
Subject: Re: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
Message-ID: <20200512225601.2jgsnnm7m63ylfqt@ast-mbp>
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
 <20200508215340.41921-3-alexei.starovoitov@gmail.com>
 <2aac2366-151a-5ae1-d65f-9232433f425f@iogearbox.net>
 <20200512182515.7kvp6lvtnsij4jvj@ast-mbp>
 <2203fb7d-f1e5-a9a1-8dfc-98c8c9ce3889@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2203fb7d-f1e5-a9a1-8dfc-98c8c9ce3889@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 10:07:08PM +0200, Daniel Borkmann wrote:
> On 5/12/20 8:25 PM, Alexei Starovoitov wrote:
> > On Tue, May 12, 2020 at 04:35:41PM +0200, Daniel Borkmann wrote:
> > > On 5/8/20 11:53 PM, Alexei Starovoitov wrote:
> > > > From: Alexei Starovoitov <ast@kernel.org>
> > > > 
> > > > Implement permissions as stated in uapi/linux/capability.h
> > > > In order to do that the verifier allow_ptr_leaks flag is split
> > > > into allow_ptr_leaks and bpf_capable flags and they are set as:
> > > >     env->allow_ptr_leaks = perfmon_capable();
> > > >     env->bpf_capable = bpf_capable();
> > > > 
> > > > bpf_capable enables bounded loops, variable stack access and other verifier features.
> > > > allow_ptr_leaks enable ptr leaks, ptr conversions, subtraction of pointers, etc.
> > > > It also disables side channel mitigations.
> > > > 
> > > > That means that the networking BPF program loaded with CAP_BPF + CAP_NET_ADMIN will
> > > > have speculative checks done by the verifier and other spectre mitigation applied.
> > > > Such networking BPF program will not be able to leak kernel pointers.
> > > 
> > > I don't quite follow this part in the code below yet, see my comments.
> > > 
> > > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > [...]
> > > > diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> > > > index 6abd5a778fcd..c32a7880fa62 100644
> > > > --- a/include/linux/bpf_verifier.h
> > > > +++ b/include/linux/bpf_verifier.h
> > > > @@ -375,6 +375,7 @@ struct bpf_verifier_env {
> > > >    	u32 used_map_cnt;		/* number of used maps */
> > > >    	u32 id_gen;			/* used to generate unique reg IDs */
> > > >    	bool allow_ptr_leaks;
> > > > +	bool bpf_capable;
> > > >    	bool seen_direct_write;
> > > >    	struct bpf_insn_aux_data *insn_aux_data; /* array of per-insn state */
> > > >    	const struct bpf_line_info *prev_linfo;
> > > > diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> > > > index 95d77770353c..264a9254dc39 100644
> > > > --- a/kernel/bpf/arraymap.c
> > > > +++ b/kernel/bpf/arraymap.c
> > > > @@ -77,7 +77,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
> > > >    	bool percpu = attr->map_type == BPF_MAP_TYPE_PERCPU_ARRAY;
> > > >    	int ret, numa_node = bpf_map_attr_numa_node(attr);
> > > >    	u32 elem_size, index_mask, max_entries;
> > > > -	bool unpriv = !capable(CAP_SYS_ADMIN);
> > > > +	bool unpriv = !bpf_capable();
> > > 
> > > So here progs loaded with CAP_BPF will have spectre mitigations bypassed which
> > > is the opposite of above statement, no?
> > 
> > right. good catch, but now I'm not sure it was such a good call to toss
> > spectre into cap_perfmon. It probably should be disabled under cap_bpf.
> 
> Right. :( Too bad CAP_*s are not more fine-grained today for more descriptive
> policy. I would presume granting both CAP_BPF + CAP_PERFMON combination is not
> always desired either, so probably makes sense to leave it out with a clear
> description in patch 1/3 for CAP_BPF about the implications.

My reasoning to bypass spectre mitigation under cap_perfmon was
that cap_perfmon allows reading kernel memory and side channels are
doing the same thing just in much more complicated way.
Whereas cap_bpf is about enabling advanced bpf features in the verifier
and other places that could be security sensitive only because of lack
of exposure to unpriv in the past, but by themselves cap_bpf doesn't hold
any known security issues. I think it makes sense to stick to that.
It sucks that indirect var access will be disallowed in the verifier
without cap_perfmon, but to make extensions easier in the future I'll add
env->bypass_spec_v1 and env->bypass_spec_v4 internal verifier knobs that will
deal with these two cases.
In the next revision I'll init them with perfmon_capable() and eventually
relax it to:
env->bypass_spec_v1 = perfmon_capable() || spectre_v1_mitigation == SPECTRE_V1_MITIGATION_NONE;
env->bypass_spec_v4 = perfmon_capable() || ssb_mode == SPEC_STORE_BYPASS_NONE;

The latter conditions are x86 specific and I don't want to mess with x86 bits
at this moment and argue about generalization of this for other archs.
Just doing env->bypass_spec_v1 = perfmon_capable(); is good enough for now
and can be improved like above in the follow up.

> > > >    	u64 cost, array_size, mask64;
> > > >    	struct bpf_map_memory mem;
> > > >    	struct bpf_array *array;
> > > [...]
> > > > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > > > index 6aa11de67315..8f421dd0c4cf 100644
> > > > --- a/kernel/bpf/core.c
> > > > +++ b/kernel/bpf/core.c
> > > > @@ -646,7 +646,7 @@ static bool bpf_prog_kallsyms_verify_off(const struct bpf_prog *fp)
> > > >    void bpf_prog_kallsyms_add(struct bpf_prog *fp)
> > > >    {
> > > >    	if (!bpf_prog_kallsyms_candidate(fp) ||
> > > > -	    !capable(CAP_SYS_ADMIN))
> > > > +	    !bpf_capable())
> > > >    		return;
> > > >    	bpf_prog_ksym_set_addr(fp);
> > > > @@ -824,7 +824,7 @@ static int bpf_jit_charge_modmem(u32 pages)
> > > >    {
> > > >    	if (atomic_long_add_return(pages, &bpf_jit_current) >
> > > >    	    (bpf_jit_limit >> PAGE_SHIFT)) {
> > > > -		if (!capable(CAP_SYS_ADMIN)) {
> > > > +		if (!bpf_capable()) {
> > > 
> > > Should there still be an upper charge on module mem for !CAP_SYS_ADMIN?
> > 
> > hmm. cap_bpf is a subset of cap_sys_admin. I don't see a reason
> > to keep requiring cap_sys_admin here.
> 
> It should probably be described in the CAP_BPF comment as well since this
> is different compared to plain unpriv.

I'm going to keep it under CAP_SYS_ADMIN for now. Just to avoid arguing.

> > > >    			atomic_long_sub(pages, &bpf_jit_current);
> > > >    			return -EPERM;
> > > >    		}
> > > [...]
> > > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > > index 70ad009577f8..a6893746cd87 100644
> > > > --- a/kernel/bpf/verifier.c
> > > > +++ b/kernel/bpf/verifier.c
> > > [...]
> > > > @@ -3428,7 +3429,7 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
> > > >    		 * Spectre masking for stack ALU.
> > > >    		 * See also retrieve_ptr_limit().
> > > >    		 */
> > > > -		if (!env->allow_ptr_leaks) {
> > > > +		if (!env->bpf_capable) {
> > > 
> > > This needs to stay on env->allow_ptr_leaks, the can_skip_alu_sanitation() does
> > > check on env->allow_ptr_leaks as well, otherwise this breaks spectre mitgation
> > > when masking alu.
> > 
> > The patch kept it in can_skip_alu_sanitation(), but I missed it here.
> > Don't really recall the details of discussion around
> > commit 088ec26d9c2d ("bpf: Reject indirect var_off stack access in unpriv mode")
> > 
> > So thinking all over this bit will effectively disable variable
> > stack access which is one of main usability features.
> 
> The reason is that we otherwise cannot derive a fixed limit for the masking
> in order to avoid oob access under speculation.

I guess we can revisit this and came up with better handling of this case
in the verifier.
In the next revision the above will be "if (!env->bypass_spec_v1)".
