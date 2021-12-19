Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232E647A1FA
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 20:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhLST4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 14:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhLST4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 14:56:06 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC95FC061574;
        Sun, 19 Dec 2021 11:56:06 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id v19so6414030plo.7;
        Sun, 19 Dec 2021 11:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1ze5IvY9qAbje0akMGSedFfQQtjgMJ3vv231HMycAUY=;
        b=QzNJHDt+yUIpvRdatcXm44yhN/wNatwQwqJk5DumdWQo/yJvTYXL+Afa0zt775A97f
         BBYXX34yAVMQzL1rsbuWN3ZmXJBdLMQfQK6XWyb80CzZGxnq+MlSMG6rpV8mwiCT1mY4
         vCRFwecmhPuz9xgAht8dezX+K3QCi4Dh2kFRnrhGfvbxrarc6a/AWoODSKyNQg7n62Tx
         MWdUBBaTAmEDUIOFmhHyzPK1lb0ufuN5i911+wAC8TVoV9LYQDsL758EqmimLiIstylQ
         h1t57TdCzuXrlFYTGPMtRhRuKpn5uIGkxDAPSY1RULKeFaKBPvD8hvKen9GvnZOeRD2Y
         LISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1ze5IvY9qAbje0akMGSedFfQQtjgMJ3vv231HMycAUY=;
        b=dyi/DrCU9JLLD1Lm6CSE/w5odIWMXyQjlh5sJYuvjbk7iCcD3aPtT4Kexwb2ZjR4FU
         Bb0SoTQG51NufvQSZnMthODLH9orjdZUCLsa7kwy6Bns4vXDzyG/VZrhOJ9ztGvbC/Hk
         nHkGauz3UfE3ZVpZ0aSB17filpJYpCXF/Vs60bnlSTYJzLwu8T51EQO4jzzY7ZFNgvto
         Bn1WAe5OaHu4lAT6nIvVQDu7rVaBCHFcsgockBogCxgiGRmYnc0yE3j+TDxutN29VPiX
         Jyb0Y8UcbvfU6SsEZymsDKjDOLoghPKWNWITLj8Ug9U605vd4gysY+8Jy4U6n7bSOWKH
         H9RA==
X-Gm-Message-State: AOAM530Dut+ymgjbnZ8KbNKHxcUVemjzfUsE6+6UgK6rgNNn9Nlt1G5R
        01Hdr7UTxtLdH7qxoyFtTD8=
X-Google-Smtp-Source: ABdhPJzUrQNXp8LsqFl71Gl6tzRps4TC6LHD0bl08JkG3w6qP6n5XaEAbgynWoZNeo+er+O61AqF0w==
X-Received: by 2002:a17:902:7298:b0:148:b730:81d0 with SMTP id d24-20020a170902729800b00148b73081d0mr13772280pll.171.1639943766070;
        Sun, 19 Dec 2021 11:56:06 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id v6sm13547411pgj.82.2021.12.19.11.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 11:56:05 -0800 (PST)
Date:   Mon, 20 Dec 2021 01:26:03 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v4 06/10] bpf: Track provenance for pointers
 formed from referenced PTR_TO_BTF_ID
Message-ID: <20211219195603.pta666hynpz45xlf@apollo.legion>
References: <20211217015031.1278167-7-memxor@gmail.com>
 <20211219022839.kdms7k3jte5ajubt@ast-mbp>
 <20211219031822.k2bfjhgazvvy5r7l@apollo.legion>
 <CAADnVQJ43O-eavsMuqW0kCiBZMf4PFHbFhSPa7vRWY1cjwqFAg@mail.gmail.com>
 <20211219043349.mmycwjnxcqc7lc2c@apollo.legion>
 <CAADnVQ+zWgUj5C=nJuzop2aOHj04eVH+Y4x+H3RyGwWjost9ZQ@mail.gmail.com>
 <20211219052540.yuqbxldypj4quhhd@apollo.legion>
 <CAADnVQ+EtYjnH+=tZCOYX+ioyx=d4NAxFFpRpN2PVfvye6thTA@mail.gmail.com>
 <20211219181044.5s2bopdn5gk7wwhz@apollo.legion>
 <20211219190810.p3q52rrlchnokufo@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211219190810.p3q52rrlchnokufo@ast-mbp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 12:38:10AM IST, Alexei Starovoitov wrote:
> On Sun, Dec 19, 2021 at 11:40:44PM +0530, Kumar Kartikeya Dwivedi wrote:
> > On Sun, Dec 19, 2021 at 11:13:18PM IST, Alexei Starovoitov wrote:
> > > On Sat, Dec 18, 2021 at 9:25 PM Kumar Kartikeya Dwivedi
> > > <memxor@gmail.com> wrote:
> > > >
> > > > On Sun, Dec 19, 2021 at 10:35:18AM IST, Alexei Starovoitov wrote:
> > > > > On Sat, Dec 18, 2021 at 8:33 PM Kumar Kartikeya Dwivedi
> > > > > <memxor@gmail.com> wrote:
> > > > > >
> > > > > > It is, but into parent_ref_obj_id, to match during release_reference.
> > > > > >
> > > > > > > Shouldn't r2 get a different ref_obj_id after r2 = r1->next ?
> > > > > >
> > > > > > It's ref_obj_id is still 0.
> > > > > >
> > > > > > Thinking about this more, we actually only need 1 extra bit of information in
> > > > > > reg_state, not even a new member. We can simply copy ref_obj_id and set this
> > > > > > bit, then we can reject this register during release but consider it during
> > > > > > release_reference.
> > > > >
> > > > > It seems to me that this patch created the problem and it's trying
> > > > > to fix it at the same time.
> > > > >
> > > >
> > > > Yes, sort of. Maybe I need to improve the commit message? I give an example
> > > > below, and the first half of commit explains that if we simply did copy
> > > > ref_obj_id, it would lead to the case in the previous mail (same BTF ID ptr can
> > > > be passed), so we need to do something different.
> > > >
> > > > Maybe that is what is confusing you.
> > >
> > > I'm still confused.
> > > Why does mark_btf_ld_reg() need to copy ref_obj_id ?
> > > It should keep it as zero.
> >
> > So that we can find deref pointers obtained from the reg having that ref_obj_id
> > when it is released, and invalidate them. But since directly storing in
> > ref_obj_id of deref dst_reg will be bad (if we get same BTF ID from deref we
> > could now pass it to release kfunc), we add a new member and match on that.
> >
> > > mark_btf_ld_reg() is used in deref only.
> > > The ref_obj_id is assigned by check_helper_call().
> > > r2 = r0; will copy it, but
> > > r2 = r0->next; will keep r2->ref_obj_id as zero.
> > >
> > > > > mark_btf_ld_reg() shouldn't be copying ref_obj_id.
> > > > > If it keeps it as zero the problem will not happen, no?
> > > >
> > > > It is copying it but writing it to parent_ref_obj_id. It keeps ref_obj_id as 0
> > > > for all deref pointers.
> > > >
> > > > r1 = acq(); // r1.ref = acquire_reference_state();
> > > >  ref = N
> > > > r2 = r1->a; // mark_btf_ld_reg -> copy r1.(ref ?: parent_ref) -> so r2.parent_ref = r1.ref
> > > > r3 = r2->b; // mark_btf_ld_reg -> copy r2.(ref ?: parent_ref) -> so r3.parent_ref = r2.parent_ref
> > > > r4 = r3->c; // mark_btf_ld_reg -> copy r3.(ref ?: parent_ref) -> so r4.parent_ref = r3.parent_ref
> > > > rel(r1);    // if (reg.ref == r1.ref || reg.parent_ref == r1.ref) invalidate(reg)
> > > >
> > > > As you see, mark_btf_ld_reg only ever writes to parent_ref_obj_id, not
> > > > ref_obj_id. It just copies ref_obj_id when it is set, over parent_ref_obj_id,
> > > > and only one of two can be set.
> > >
> > > I don't understand why such logic is needed.
> >
> > Ok, let me try to explain once how I arrived at it. If you still don't like it,
> > I'll drop it from the series.
> >
> > So until this patch, when we do the following:
> >
> > 	struct nf_conn *ct = bpf_xdp_ct_lookup(...);
> > 	if (ct) {
> > 		struct nf_conn *master = ct->master;
> > 		bpf_ct_release(ct);
> > 		unsigned long status = master->status; // I want to prevent this
> > 	}
> >
> > ... this will work, which is ok (as in won't crash the kernel) since the load
> > will be converted to BPF_PROBE_MEM, but I want to disallow this case since it is
> > obviously incorrect.
>
> Finally we're talking! This motivation should have been in the commit log
> and this thread wouldn't have been that long.
>

Indeed, sorry for wasting your time. I'll try to do better, and thanks for being
patient.

> > The obvious solution (to me) was to kill all registers and stack slots for deref
> > pointers.
> >
> > My first naive solution was to simply copy ref_obj_id on mark_btf_ld_reg, so
> > that it can be matched and released from release_reference.
>
> That what I was guessing.
>
> > But then I noticed that if the BTF ID is same, there is no difference when it is
> > passed to release kfunc compared to the original register it was loaded from.
> >
> > 	struct nf_conn *ct = bpf_xdp_ct_lookup(...);
> > 	if (ct) {
> > 		struct nf_conn *master = ct->master; // copied ref_obj_id
> > 		bpf_ct_release(master); // works, but shouldn't!
> > 	}
> >
> > So the code needed some way to distinguish this deref pointer that must be
> > invalidated only when its 'parent' goes away. Hence the introduction of
> > parent_ref_obj_id, and the invariant that only one of ref_obj_id or
> > parent_ref_obj_id must be set.
>
> The goal is clear now, but look at it differently:
> struct nf_conn *ct = bpf_xdp_ct_lookup(...);
> if (ct) {
>   struct nf_conn *master = ct->master;
>   struct net *net = ct->ct_net.net;
>
>   bpf_ct_release(ct);
>   master->status; // prevent this ?
>   net->ifindex;   // but allow this ?

I think both will be prevented with the current logic, no?
net will be ct + offset, so if mark_btf_ld_reg writes PTR_TO_BTF_ID to dst_reg
for net, it will copy ct's reg's ref_obj_id to parent_ref_obj_id of dst_reg (net).
Then on release of ct, net's reg gets killed too since reg[ct]->ref_obj_id
matches its parent_ref_obj_id.

I just tried it out:

7: (85) call bpf_skb_ct_lookup#121995
last_idx 7 first_idx 0
regs=8 stack=0 before 6: (b4) w5 = 4
regs=8 stack=0 before 5: (bf) r4 = r2
regs=8 stack=0 before 4: (b4) w3 = 4
last_idx 7 first_idx 0
regs=20 stack=0 before 6: (b4) w5 = 4
; if (ct) {
8: (15) if r0 == 0x0 goto pc+4
 R0_w=ptr_nf_conn(id=0,ref_obj_id=2,off=0,imm=0) R6_w=invP0 R10=fp0 fp-8=mmmm???? refs=2
; struct net *net = ct->ct_net.net;
9: (79) r6 = *(u64 *)(r0 +208)
; bpf_ct_release(ct);
10: (bf) r1 = r0
11: (85) call bpf_ct_release#121993
; return net->ifindex; // but allow this ?
12: (61) r6 = *(u32 *)(r6 +80)
R6 invalid mem access 'inv'
processed 13 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 1
-- END PROG LOAD LOG --

Same result when you follow pointer chains.

> }
> The verifier cannot statically check this. That's why all such deref
> are done via BPF_PROBE_MEM (which is the same as probe_read_kernel).
> We must disallow use after free when it can cause a crash.
> This case is not the one.

That is a valid point, this is certainly in 'nice to have/prevents obvious
misuse' territory, but if this can be done without introducing too much
complexity, I'd like us to do it.

A bit of a digression, but:
I'm afraid this patch is going to be brought up again for a future effort
related to XDP queueing that Toke is working on. We have a similar scenario
there, when xdp_md (aliasing xdp_frame) is dequeued from the PIFO map, and
PTR_TO_PACKET is obtained by reading xdp_md->data. The xdp_md is referenced, so
we need to invalidate these pkt pointers as well, in addition to killing xdp_md
copies. Also this parent_ref_obj_id state allows us to reject comparisons
between pkt pointers pointing into different xdp_md's (when you dequeue more
than one at once and form multiple pkt pointers pointing into different
xdp_mds).
Then it would be required for correctness purposes, but we'll discuss that once
it is posted (but wanted to let you know as an FYI). I can probably also
consider your map_uid suggestion for that, but IMO parent_ref_obj_id is more
generic, and requires less special cases in verifier.

>
> This one, though:
>   struct nf_conn *ct = bpf_xdp_ct_lookup(...);
>   struct nf_conn *master = ct->master;
>   bpf_ct_release(master);
> definitely has to be prevented, since it will cause a crash.
>
> As a follow up to this set would be great to allow ptr_to_btf_id
> pointers persist longer than program execution.
> Users already asked to allow the following:
>   map_value = bpf_map_lookup_elem(...);
>   struct nf_conn *ct = bpf_xdp_ct_lookup(...);
>   map_value->saved_ct = ct;
> and some time later in a different or the same program:
>   map_value = bpf_map_lookup_elem(...);
>   bpf_ct_release(map_value->saved_ct);
>
> Currently folks work around this deficiency by storing some
> sort of id and doing extra lookups while performance is suffering.
> wdyt?

Very interesting idea! I'm guessing we'll need something akin to bpf_timer
support, i.e. a dedicated type verified using BTF which can be embedded in
map_value? I'll be happy to work on enabling this.

One thought though (just confirming):
If user does map_value->saved_ct = ct, we have to ignore reference leak check
for ct's ref_id, but if they rewrite saved_ct, we would also have to unignore
it, correct?

I think we can make this tracking easier by limiting to one bpf_ptr_to_btf
struct in map_value, then it can simply be part of ptr_to_map_value's reg_state.

--
Kartikeya
