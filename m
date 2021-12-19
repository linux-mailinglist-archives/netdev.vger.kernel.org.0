Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EC7479F71
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 06:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbhLSFZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 00:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhLSFZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 00:25:44 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F56BC061574;
        Sat, 18 Dec 2021 21:25:44 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id t123so4416880pfc.13;
        Sat, 18 Dec 2021 21:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2r/lAOam35UnbOPt91pIDkFkHoz+6a7gbjQzhnDEKE8=;
        b=OF3Yx8XDZq/50DiljTpWlHNhcxXFsNV09eKYUvAgFgAgkdWG2Uai53x7fF4RcTS5RA
         1iuLI0q6b5lqPfxXfoU4lFVs3MgM2z2m9hAbbRScGqu9eBUqxMIdNPLHQCHx0gqxl+Lh
         +1V7Y8hewQKyCXo5hza30voU4g0E8YKujlJt/2c6Taudnfb4GpdtIxjikpi1bONWyhPV
         9as0sQl13NMT2JKcYMAnyt0ZgjAlvD9e3EL1G4ahobqdWqEYO92QpuKL/pY6AsDMRpa2
         W12IMjuIXJxyoEmy3N4n5qpqLB36kj5PYj0S3IJ92jPd/zj3bUn2PrkEZL9BbyXqUQbe
         jBCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2r/lAOam35UnbOPt91pIDkFkHoz+6a7gbjQzhnDEKE8=;
        b=lAxvEZL0avMtzK2QiA4ZzB2vGVcEJ4Oztm9n4PKYXUIEyFfuK9Uv7jNuiTLvbmJHEM
         J8D0YL6YER/kNrKF+8FM3dm+APeSXWVvkMeJKTmX0Y3n0olAvoCGjtqxKH/DeFLJTeUt
         uRZfy4c86MyXWjhY0FJ/JUFRH/0Xk4Bqpfbkes9mwjRsNp5BFPQnTORD7kcjh5GIxQCZ
         n241lT1xk6fXu5Tu5vYupq9XWL0raboZyJnbFTiBsqi7RdaDdSJJZT9ySHlUyjurCvBE
         2h5y1bA8v8zY89g/KHDczMjQTHeYVNPw9BXxb348TwFo3d4G2dGdNM/6i0ESQYZhlGNu
         wqXg==
X-Gm-Message-State: AOAM5338iMipE8bfI1RXyFi4MVabG9JYb2rU4jEWsmqpgTEqO1dIXE2Q
        3jVXKrbDUj0/Vg/dUA1/mas=
X-Google-Smtp-Source: ABdhPJzWsDq6+rJIlqkxJB4ftSm9nz9MvUq2tq8BizYY7Q8ktIEUCmEmfLiGVr1NpZdobKfnN9RM9A==
X-Received: by 2002:a05:6a00:b49:b0:49f:c8e0:51ff with SMTP id p9-20020a056a000b4900b0049fc8e051ffmr10447848pfo.36.1639891543544;
        Sat, 18 Dec 2021 21:25:43 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id w7sm12806641pgo.56.2021.12.18.21.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 21:25:43 -0800 (PST)
Date:   Sun, 19 Dec 2021 10:55:40 +0530
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
Message-ID: <20211219052540.yuqbxldypj4quhhd@apollo.legion>
References: <20211217015031.1278167-1-memxor@gmail.com>
 <20211217015031.1278167-7-memxor@gmail.com>
 <20211219022839.kdms7k3jte5ajubt@ast-mbp>
 <20211219031822.k2bfjhgazvvy5r7l@apollo.legion>
 <CAADnVQJ43O-eavsMuqW0kCiBZMf4PFHbFhSPa7vRWY1cjwqFAg@mail.gmail.com>
 <20211219043349.mmycwjnxcqc7lc2c@apollo.legion>
 <CAADnVQ+zWgUj5C=nJuzop2aOHj04eVH+Y4x+H3RyGwWjost9ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+zWgUj5C=nJuzop2aOHj04eVH+Y4x+H3RyGwWjost9ZQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 19, 2021 at 10:35:18AM IST, Alexei Starovoitov wrote:
> On Sat, Dec 18, 2021 at 8:33 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > It is, but into parent_ref_obj_id, to match during release_reference.
> >
> > > Shouldn't r2 get a different ref_obj_id after r2 = r1->next ?
> >
> > It's ref_obj_id is still 0.
> >
> > Thinking about this more, we actually only need 1 extra bit of information in
> > reg_state, not even a new member. We can simply copy ref_obj_id and set this
> > bit, then we can reject this register during release but consider it during
> > release_reference.
>
> It seems to me that this patch created the problem and it's trying
> to fix it at the same time.
>

Yes, sort of. Maybe I need to improve the commit message? I give an example
below, and the first half of commit explains that if we simply did copy
ref_obj_id, it would lead to the case in the previous mail (same BTF ID ptr can
be passed), so we need to do something different.

Maybe that is what is confusing you.

> mark_btf_ld_reg() shouldn't be copying ref_obj_id.
> If it keeps it as zero the problem will not happen, no?

It is copying it but writing it to parent_ref_obj_id. It keeps ref_obj_id as 0
for all deref pointers.

r1 = acq(); // r1.ref = acquire_reference_state();
 ref = N
r2 = r1->a; // mark_btf_ld_reg -> copy r1.(ref ?: parent_ref) -> so r2.parent_ref = r1.ref
r3 = r2->b; // mark_btf_ld_reg -> copy r2.(ref ?: parent_ref) -> so r3.parent_ref = r2.parent_ref
r4 = r3->c; // mark_btf_ld_reg -> copy r3.(ref ?: parent_ref) -> so r4.parent_ref = r3.parent_ref
rel(r1);    // if (reg.ref == r1.ref || reg.parent_ref == r1.ref) invalidate(reg)

As you see, mark_btf_ld_reg only ever writes to parent_ref_obj_id, not
ref_obj_id. It just copies ref_obj_id when it is set, over parent_ref_obj_id,
and only one of two can be set.

--
Kartikeya
