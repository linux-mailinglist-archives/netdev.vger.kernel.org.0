Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC0F47A1E2
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 20:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbhLSTIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 14:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234537AbhLSTIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 14:08:13 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81E9C061574;
        Sun, 19 Dec 2021 11:08:13 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id v11so3656508pfu.2;
        Sun, 19 Dec 2021 11:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2dN7E/VzTbQwrYtSlhWJ/1kL7M68pbdpSsprZtVcG1g=;
        b=Y4OK2+HGZBhs4EW51cOA4dNslLnEWpehW3DvW1mYvxmtV4ZifbAoxaJpe71DXDBQMc
         glSvZsKOng5cfh5LdEWNPzpTPdYQC5MRU8S7KrGm5K8cc/OVpY8q0T95vOKG+3dVDiKK
         7VHz34kEUEl29wZwJRmKZYk4kCH5ocZoHQOlXss1/BAYi4yg6x68+8sr6rNkhhOBUVL2
         HwRbXRd8sQ7romyDTjvQL3zzqhYCi1x8TE2TTlzI+rUW1nEJvHZrRySzeRwmcMExnDmV
         a7bM9yfpudGGNiEQNlqaxrpJ/pNhpMmgZWsZU+AvhPslo9NCB1XbU3eJQZNpxxKU+LU/
         7Gkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2dN7E/VzTbQwrYtSlhWJ/1kL7M68pbdpSsprZtVcG1g=;
        b=g4o7pC1hIR9L8M/i3MOBCu/XEKBxF3cxT6JG/U+3TXMuIrDL+s292W/97AhUFsvA3T
         wctv1S6iAY8F5p2KgESJvElPa3cPrTtpV9gSLyM6Fla6Dp5jSdvZCJHjO66Lg8+UHn4S
         lW9Lm/orQWNqZK6jivYt6PDiJEDLfkvMXCEn2EdWT+Uu3DuaV3AqxOgEp0V2OMlN0hFq
         L+Hk2ptBQTfPUn/gkYFHWesl02W5Oua1/zmUWPyGM5NBeGcafvYDb2wqnXX2wtLoMCRw
         N2qEokMu4d6MSEhT5MUFyK2xqaLfPra0ZHp5BOaV2b8LJQPe5kfAr7+SS8L5DVGuaIn4
         KIbw==
X-Gm-Message-State: AOAM5314pWE5oHnQ2rXy1ZMS1VjTbUqI59h5uwUhDG4n2rPMCpM++HAD
        zk/BO0uazFCvblWQUwp/6bE=
X-Google-Smtp-Source: ABdhPJzphkfZZoZ8vKkeJffl8TkXT1Jjb+49XBdizrM6z+5X9ZknKHzmzZSkA8MQpGgQFPSFk7O92Q==
X-Received: by 2002:a62:ed1a:0:b0:4ba:da1c:804c with SMTP id u26-20020a62ed1a000000b004bada1c804cmr1860559pfh.4.1639940893048;
        Sun, 19 Dec 2021 11:08:13 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:9874])
        by smtp.gmail.com with ESMTPSA id oa9sm5963695pjb.31.2021.12.19.11.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 11:08:12 -0800 (PST)
Date:   Sun, 19 Dec 2021 11:08:10 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
Message-ID: <20211219190810.p3q52rrlchnokufo@ast-mbp>
References: <20211217015031.1278167-1-memxor@gmail.com>
 <20211217015031.1278167-7-memxor@gmail.com>
 <20211219022839.kdms7k3jte5ajubt@ast-mbp>
 <20211219031822.k2bfjhgazvvy5r7l@apollo.legion>
 <CAADnVQJ43O-eavsMuqW0kCiBZMf4PFHbFhSPa7vRWY1cjwqFAg@mail.gmail.com>
 <20211219043349.mmycwjnxcqc7lc2c@apollo.legion>
 <CAADnVQ+zWgUj5C=nJuzop2aOHj04eVH+Y4x+H3RyGwWjost9ZQ@mail.gmail.com>
 <20211219052540.yuqbxldypj4quhhd@apollo.legion>
 <CAADnVQ+EtYjnH+=tZCOYX+ioyx=d4NAxFFpRpN2PVfvye6thTA@mail.gmail.com>
 <20211219181044.5s2bopdn5gk7wwhz@apollo.legion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211219181044.5s2bopdn5gk7wwhz@apollo.legion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 19, 2021 at 11:40:44PM +0530, Kumar Kartikeya Dwivedi wrote:
> On Sun, Dec 19, 2021 at 11:13:18PM IST, Alexei Starovoitov wrote:
> > On Sat, Dec 18, 2021 at 9:25 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > On Sun, Dec 19, 2021 at 10:35:18AM IST, Alexei Starovoitov wrote:
> > > > On Sat, Dec 18, 2021 at 8:33 PM Kumar Kartikeya Dwivedi
> > > > <memxor@gmail.com> wrote:
> > > > >
> > > > > It is, but into parent_ref_obj_id, to match during release_reference.
> > > > >
> > > > > > Shouldn't r2 get a different ref_obj_id after r2 = r1->next ?
> > > > >
> > > > > It's ref_obj_id is still 0.
> > > > >
> > > > > Thinking about this more, we actually only need 1 extra bit of information in
> > > > > reg_state, not even a new member. We can simply copy ref_obj_id and set this
> > > > > bit, then we can reject this register during release but consider it during
> > > > > release_reference.
> > > >
> > > > It seems to me that this patch created the problem and it's trying
> > > > to fix it at the same time.
> > > >
> > >
> > > Yes, sort of. Maybe I need to improve the commit message? I give an example
> > > below, and the first half of commit explains that if we simply did copy
> > > ref_obj_id, it would lead to the case in the previous mail (same BTF ID ptr can
> > > be passed), so we need to do something different.
> > >
> > > Maybe that is what is confusing you.
> >
> > I'm still confused.
> > Why does mark_btf_ld_reg() need to copy ref_obj_id ?
> > It should keep it as zero.
> 
> So that we can find deref pointers obtained from the reg having that ref_obj_id
> when it is released, and invalidate them. But since directly storing in
> ref_obj_id of deref dst_reg will be bad (if we get same BTF ID from deref we
> could now pass it to release kfunc), we add a new member and match on that.
> 
> > mark_btf_ld_reg() is used in deref only.
> > The ref_obj_id is assigned by check_helper_call().
> > r2 = r0; will copy it, but
> > r2 = r0->next; will keep r2->ref_obj_id as zero.
> >
> > > > mark_btf_ld_reg() shouldn't be copying ref_obj_id.
> > > > If it keeps it as zero the problem will not happen, no?
> > >
> > > It is copying it but writing it to parent_ref_obj_id. It keeps ref_obj_id as 0
> > > for all deref pointers.
> > >
> > > r1 = acq(); // r1.ref = acquire_reference_state();
> > >  ref = N
> > > r2 = r1->a; // mark_btf_ld_reg -> copy r1.(ref ?: parent_ref) -> so r2.parent_ref = r1.ref
> > > r3 = r2->b; // mark_btf_ld_reg -> copy r2.(ref ?: parent_ref) -> so r3.parent_ref = r2.parent_ref
> > > r4 = r3->c; // mark_btf_ld_reg -> copy r3.(ref ?: parent_ref) -> so r4.parent_ref = r3.parent_ref
> > > rel(r1);    // if (reg.ref == r1.ref || reg.parent_ref == r1.ref) invalidate(reg)
> > >
> > > As you see, mark_btf_ld_reg only ever writes to parent_ref_obj_id, not
> > > ref_obj_id. It just copies ref_obj_id when it is set, over parent_ref_obj_id,
> > > and only one of two can be set.
> >
> > I don't understand why such logic is needed.
> 
> Ok, let me try to explain once how I arrived at it. If you still don't like it,
> I'll drop it from the series.
> 
> So until this patch, when we do the following:
> 
> 	struct nf_conn *ct = bpf_xdp_ct_lookup(...);
> 	if (ct) {
> 		struct nf_conn *master = ct->master;
> 		bpf_ct_release(ct);
> 		unsigned long status = master->status; // I want to prevent this
> 	}
> 
> ... this will work, which is ok (as in won't crash the kernel) since the load
> will be converted to BPF_PROBE_MEM, but I want to disallow this case since it is
> obviously incorrect.

Finally we're talking! This motivation should have been in the commit log
and this thread wouldn't have been that long.

> The obvious solution (to me) was to kill all registers and stack slots for deref
> pointers.
> 
> My first naive solution was to simply copy ref_obj_id on mark_btf_ld_reg, so
> that it can be matched and released from release_reference.

That what I was guessing.

> But then I noticed that if the BTF ID is same, there is no difference when it is
> passed to release kfunc compared to the original register it was loaded from.
> 
> 	struct nf_conn *ct = bpf_xdp_ct_lookup(...);
> 	if (ct) {
> 		struct nf_conn *master = ct->master; // copied ref_obj_id
> 		bpf_ct_release(master); // works, but shouldn't!
> 	}
> 
> So the code needed some way to distinguish this deref pointer that must be
> invalidated only when its 'parent' goes away. Hence the introduction of
> parent_ref_obj_id, and the invariant that only one of ref_obj_id or
> parent_ref_obj_id must be set.

The goal is clear now, but look at it differently:
struct nf_conn *ct = bpf_xdp_ct_lookup(...);
if (ct) {
  struct nf_conn *master = ct->master;
  struct net *net = ct->ct_net.net;

  bpf_ct_release(ct);
  master->status; // prevent this ?
  net->ifindex;   // but allow this ?
}
The verifier cannot statically check this. That's why all such deref
are done via BPF_PROBE_MEM (which is the same as probe_read_kernel).
We must disallow use after free when it can cause a crash.
This case is not the one.

This one, though:
  struct nf_conn *ct = bpf_xdp_ct_lookup(...);
  struct nf_conn *master = ct->master;
  bpf_ct_release(master);
definitely has to be prevented, since it will cause a crash.

As a follow up to this set would be great to allow ptr_to_btf_id
pointers persist longer than program execution.
Users already asked to allow the following:
  map_value = bpf_map_lookup_elem(...);
  struct nf_conn *ct = bpf_xdp_ct_lookup(...);
  map_value->saved_ct = ct;
and some time later in a different or the same program:
  map_value = bpf_map_lookup_elem(...);
  bpf_ct_release(map_value->saved_ct);

Currently folks work around this deficiency by storing some
sort of id and doing extra lookups while performance is suffering.
wdyt?
