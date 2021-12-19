Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288D947A1AD
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 19:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbhLSSKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 13:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbhLSSKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 13:10:48 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779A2C061574;
        Sun, 19 Dec 2021 10:10:48 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 196so3207823pfw.10;
        Sun, 19 Dec 2021 10:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HWaowpQYVNBi7ZgTlHcYtA0MJAtoNpzRRSp3pLbX1r8=;
        b=daFtI85bNTGNBzeqUQ8OxK7RPxkobvotmDmqLhYO878UgYWsPfPEnorXiWrmcj1uMU
         SeC3IAJ6HbpV7Qqi3s6H4easnkD8h0IQtJSnYsFBhAIZqlHI12p39KJYYPvEvv9D0aEr
         A1FYCjo/HbOf8G5H8opUxd8bWS5ShN7zBA8lg+3QVMb5HktfRza5X1qDQ2KKvx+1aeO5
         Mtj8MtntsXycheVPidyls7PUWbXQ6oUbDx7xGIKqIBM9dtTokMojsLvm5l8+ih9oWWWa
         kwXjAdYkYWXzYXMulLMOpLB81UFjI/wIH0g8yHxtKHR9MrsuY+IreQvr1Lu6Sj7ARPIc
         lwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HWaowpQYVNBi7ZgTlHcYtA0MJAtoNpzRRSp3pLbX1r8=;
        b=NKV1HG2D5FhMOfyeCJuosR6KwL8Kn6h8WNTyvsnsvmvpcO581d2eS+TudQKIc+hFo1
         gnMpuIL4Lu6ONNqdNOMtpzw7fjueCT++Ky3IZcWuHAqh7I7OPdKUSjB62ybkA5745LJT
         gSw2sCVQeZcFd6c8ghyPAUjLRQ92pQjZPhA4TigsyuHMFN77Lgi1+hdQuA84zWa8dt3t
         GuvtinfUhnLjNIGVvxRMmY36YOZByeHwUabBvAQ+HieCONmnzdSzWPUjF1TGS6EPfll0
         0UO7r41Owoq+ZICI98e/X3rX0bhF2RwDZ4BdSD/GkdwGycnhwpfbSDkhlYmLJcDMpF//
         5YTg==
X-Gm-Message-State: AOAM530jgRiLY7CGLX12Q4i6IYbsxFqk3IHc6JJIPJzSweQ+RkXqzXfk
        PPzOTf0Tb+L4rIKiCYED7IE=
X-Google-Smtp-Source: ABdhPJwlwx9WRvPD5SHIKiIbKO3Jx78y2EBYxMtgaRwRRJrCRIMx6PBaRB2kYsNO7FFZi/rKIfzWEQ==
X-Received: by 2002:a05:6a00:1809:b0:4ad:58fe:8a0a with SMTP id y9-20020a056a00180900b004ad58fe8a0amr12520798pfa.70.1639937447691;
        Sun, 19 Dec 2021 10:10:47 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id h10sm14464342pgj.64.2021.12.19.10.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 10:10:47 -0800 (PST)
Date:   Sun, 19 Dec 2021 23:40:44 +0530
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
Message-ID: <20211219181044.5s2bopdn5gk7wwhz@apollo.legion>
References: <20211217015031.1278167-1-memxor@gmail.com>
 <20211217015031.1278167-7-memxor@gmail.com>
 <20211219022839.kdms7k3jte5ajubt@ast-mbp>
 <20211219031822.k2bfjhgazvvy5r7l@apollo.legion>
 <CAADnVQJ43O-eavsMuqW0kCiBZMf4PFHbFhSPa7vRWY1cjwqFAg@mail.gmail.com>
 <20211219043349.mmycwjnxcqc7lc2c@apollo.legion>
 <CAADnVQ+zWgUj5C=nJuzop2aOHj04eVH+Y4x+H3RyGwWjost9ZQ@mail.gmail.com>
 <20211219052540.yuqbxldypj4quhhd@apollo.legion>
 <CAADnVQ+EtYjnH+=tZCOYX+ioyx=d4NAxFFpRpN2PVfvye6thTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+EtYjnH+=tZCOYX+ioyx=d4NAxFFpRpN2PVfvye6thTA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 19, 2021 at 11:13:18PM IST, Alexei Starovoitov wrote:
> On Sat, Dec 18, 2021 at 9:25 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Sun, Dec 19, 2021 at 10:35:18AM IST, Alexei Starovoitov wrote:
> > > On Sat, Dec 18, 2021 at 8:33 PM Kumar Kartikeya Dwivedi
> > > <memxor@gmail.com> wrote:
> > > >
> > > > It is, but into parent_ref_obj_id, to match during release_reference.
> > > >
> > > > > Shouldn't r2 get a different ref_obj_id after r2 = r1->next ?
> > > >
> > > > It's ref_obj_id is still 0.
> > > >
> > > > Thinking about this more, we actually only need 1 extra bit of information in
> > > > reg_state, not even a new member. We can simply copy ref_obj_id and set this
> > > > bit, then we can reject this register during release but consider it during
> > > > release_reference.
> > >
> > > It seems to me that this patch created the problem and it's trying
> > > to fix it at the same time.
> > >
> >
> > Yes, sort of. Maybe I need to improve the commit message? I give an example
> > below, and the first half of commit explains that if we simply did copy
> > ref_obj_id, it would lead to the case in the previous mail (same BTF ID ptr can
> > be passed), so we need to do something different.
> >
> > Maybe that is what is confusing you.
>
> I'm still confused.
> Why does mark_btf_ld_reg() need to copy ref_obj_id ?
> It should keep it as zero.

So that we can find deref pointers obtained from the reg having that ref_obj_id
when it is released, and invalidate them. But since directly storing in
ref_obj_id of deref dst_reg will be bad (if we get same BTF ID from deref we
could now pass it to release kfunc), we add a new member and match on that.

> mark_btf_ld_reg() is used in deref only.
> The ref_obj_id is assigned by check_helper_call().
> r2 = r0; will copy it, but
> r2 = r0->next; will keep r2->ref_obj_id as zero.
>
> > > mark_btf_ld_reg() shouldn't be copying ref_obj_id.
> > > If it keeps it as zero the problem will not happen, no?
> >
> > It is copying it but writing it to parent_ref_obj_id. It keeps ref_obj_id as 0
> > for all deref pointers.
> >
> > r1 = acq(); // r1.ref = acquire_reference_state();
> >  ref = N
> > r2 = r1->a; // mark_btf_ld_reg -> copy r1.(ref ?: parent_ref) -> so r2.parent_ref = r1.ref
> > r3 = r2->b; // mark_btf_ld_reg -> copy r2.(ref ?: parent_ref) -> so r3.parent_ref = r2.parent_ref
> > r4 = r3->c; // mark_btf_ld_reg -> copy r3.(ref ?: parent_ref) -> so r4.parent_ref = r3.parent_ref
> > rel(r1);    // if (reg.ref == r1.ref || reg.parent_ref == r1.ref) invalidate(reg)
> >
> > As you see, mark_btf_ld_reg only ever writes to parent_ref_obj_id, not
> > ref_obj_id. It just copies ref_obj_id when it is set, over parent_ref_obj_id,
> > and only one of two can be set.
>
> I don't understand why such logic is needed.

Ok, let me try to explain once how I arrived at it. If you still don't like it,
I'll drop it from the series.

So until this patch, when we do the following:

	struct nf_conn *ct = bpf_xdp_ct_lookup(...);
	if (ct) {
		struct nf_conn *master = ct->master;
		bpf_ct_release(ct);
		unsigned long status = master->status; // I want to prevent this
	}

... this will work, which is ok (as in won't crash the kernel) since the load
will be converted to BPF_PROBE_MEM, but I want to disallow this case since it is
obviously incorrect.

The obvious solution (to me) was to kill all registers and stack slots for deref
pointers.

My first naive solution was to simply copy ref_obj_id on mark_btf_ld_reg, so
that it can be matched and released from release_reference.

But then I noticed that if the BTF ID is same, there is no difference when it is
passed to release kfunc compared to the original register it was loaded from.

	struct nf_conn *ct = bpf_xdp_ct_lookup(...);
	if (ct) {
		struct nf_conn *master = ct->master; // copied ref_obj_id
		bpf_ct_release(master); // works, but shouldn't!
	}

So the code needed some way to distinguish this deref pointer that must be
invalidated only when its 'parent' goes away. Hence the introduction of
parent_ref_obj_id, and the invariant that only one of ref_obj_id or
parent_ref_obj_id must be set.

Now release_reference becomes: kill all registers/stack slots with ref ==
ref_obj_id (directly acquired) and ref == parent_ref_obj_id (formed using deref
chains (of arbitrary length)).

Either a register is dst_reg of acquire kfunc, or deref of that reg, but can't
be both. Only the first case can be passed to release kfunc (or a copy from
mov), not the second (since it will always have invalid ref_obj_id == 0).

If this is still not inspiring confidence, I'll drop the patch for now.

--
Kartikeya
