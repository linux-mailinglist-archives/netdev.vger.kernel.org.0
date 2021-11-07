Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3FD447394
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 16:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbhKGPr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 10:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234160AbhKGPr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 10:47:27 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E5BC061570;
        Sun,  7 Nov 2021 07:44:45 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id c4so1928200pfj.2;
        Sun, 07 Nov 2021 07:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UfegZl3PfoA1eSdiglVJ/xQK86k6sF/IkxHdjwdJ4YU=;
        b=Gi3SpojGU0qFMF0/bWFnjT7zUR4BMCehwlUm3HDuPaH0dvTKOJIWFp8Gr04AyuWQIR
         f+DxkeIVcpVMjad0FhNtTX7wdoQ6VhXB7fwDdtlntcvPLfOCVq7ZOlqv3mja99rSVlXb
         WV3et8meLXH/KIV+OHXPQWBKy0sPvsKj7N8lyulvE79Y7lIpzRKLnm0qar2lNqZQJYyS
         RBs9LK0hPYEsJTsIuy/Z9eDaAA8eSmuJfrcVQ6CYWyvFrWHK6vlAmxZ4UIeJ+LtsbCwW
         QRNH1nELHrJcIN35TvoyAZxd9KyLXGdb+DtDesdhN/DTkp3kYAmcTr5MYXzipxU6GreQ
         E7Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UfegZl3PfoA1eSdiglVJ/xQK86k6sF/IkxHdjwdJ4YU=;
        b=iRAI5AC1HvvqjscSz1wdjQeceILM7XEJKJX4+xFIsHpdnE87Z0IB51u/tpNTuaGuyk
         0f0X7pnVtYsflBM/j9jOY9M1xW0UBeH5H8G+t/0jLrb+8HvT+tBuukbXF1dSBYY8ub56
         V8srITQk+7O+LUoOy6JeqFtNdQCRu3NqQrustpubElN503Ca3ODbEoDl3mK0y+apknVh
         Q1BL9jHCnDQOpdQsG4PQNcwAmPGX3xBqsvXoxTd/6qwh0sfv7PomffdGJ8/hNUbxJmoZ
         HnrtZlUEU69FOf9I9ZH6rFhT7RycxxKytuYopi+6+F7wtqxXkEGyqWpfZNoE8jiDJtPU
         RLBA==
X-Gm-Message-State: AOAM530q80qXoX5zfVl5RDf4v1iZJQZZyIVhn1zthXFkZJ9ircZGNx6E
        FUzv7fsLs3uXGXZzR7Tm2ZM=
X-Google-Smtp-Source: ABdhPJxRUj1zaBMXLE13iHdaEOnYVDWUo/Lu7fkvNCcJcxRnoLaVejugLICJcQVWNyl3XlIt2ZsbNQ==
X-Received: by 2002:a63:e107:: with SMTP id z7mr11628291pgh.294.1636299884455;
        Sun, 07 Nov 2021 07:44:44 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id p15sm8082777pjh.1.2021.11.07.07.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 07:44:44 -0800 (PST)
Date:   Sun, 7 Nov 2021 21:14:41 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC bpf-next v1 0/6] Introduce unstable CT lookup helpers
Message-ID: <20211107154441.jl2vxdr42mklmjv2@apollo.localdomain>
References: <20211030144609.263572-1-memxor@gmail.com>
 <20211102231642.yqgocduxcoladqne@ast-mbp.dhcp.thefacebook.com>
 <20211104125503.smxxptjqri6jujke@apollo.localdomain>
 <20211105204908.4cqxk2nbkas6bduw@ast-mbp.dhcp.thefacebook.com>
 <20211105211312.ms3r7zpna3c7ct4f@apollo.localdomain>
 <20211106181328.5u4w6adgny6rkr46@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211106181328.5u4w6adgny6rkr46@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 06, 2021 at 11:43:28PM IST, Alexei Starovoitov wrote:
> On Sat, Nov 06, 2021 at 02:43:12AM +0530, Kumar Kartikeya Dwivedi wrote:
> >
> > Right now only PTR_TO_BTF_ID and PTR_TO_SOCK and scalars are supported, as you
> > noted, for kfunc arguments.
> >
> > So in 3/6 I move the PTR_TO_CTX block before btf_is_kernel check, that means if
> > reg type is PTR_TO_CTX and it matches the argument for the program, it will use
> > that, otherwise it moves to btf_is_kernel(btf) block, which checks if reg->type
> > is PTR_TO_BTF_ID or one of PTR_TO_SOCK* and does struct match for those. Next, I
> > punt to ptr_to_mem for the rest of the cases, which I think is problematic,
> > since now you may pass PTR_TO_MEM where some kfunc wants a PTR_TO_BTF_ID.
> >
> > But without bpf_func_proto, I am not sure we can decide what is expected in the
> > kfunc. For something like bpf_sock_tuple, we'd want a PTR_TO_MEM, but taking in
> > a PTR_TO_BTF_ID also isn't problematic since it is just data, but for a struct
> > embedding pointers or other cases, it may be a problem.
> >
> > For PTR_TO_CTX in kfunc case, based on my reading and testing, it will reject
> > any attempts to pass anything other than PTR_TO_CTX due to btf_get_prog_ctx_type
> > for that argument. So that works fine.
> >
> > To me it seems like extending with some limited argument checking is necessary,
> > either using tagging as you mentioned or bpf_func_proto, or some other hardcoded
> > checking for now since the number of helpers needing this support is low.
>
> Got it. The patch 3 commit log was too terse for me to comprehend.
> Even with detailed explanation above it took me awhile to understand the
> consequences of the patch... and 'goto ptr_to_mem' I misunderstood completely.
> I think now we're on the same page :)
>
> Agree that allowing PTR_TO_CTX into kfunc is safe to do in all cases.
> Converting PTR_TO_MEM to PTR_TO_BTF_ID is also safe when kernel side 'struct foo'
> contains only scalars. The patches don't have this check yet (as far as I can see).
> That's the only missing piece.

This is a great idea! I think this does address the thing I was worried about.

> With that in place 'struct bpf_sock_tuple' can be defined on the kernel side.
> The bpf prog can do include "vmlinux.h" to use it to pass as PTR_TO_MEM
> into kfunc. The patch 5 kernel function bpf_skb_ct_lookup can stay as-is.
> So no tagging or extensions to bpf_func_proto are necessary.
>
> The piece I'm still missing is why you need two additional *btf_struct_access.
> Why do you want to restrict read access?
> The bpf-tcp infra has bpf_tcp_ca_btf_struct_access() to allow-list
> few safe fields for writing.
> Is there a use case to write into 'struct nf_conn' from bpf prog? Probably not yet.
> Then let's keep the default btf_struct_access() behavior for now.
> The patch 5 will be defining bpf_xdp_ct_lookup_tcp/bpf_skb_ct_lookup_tcp
> and no callbacks at all.
> acquire/release are probably cleaner as explicit btf_id_list-s.
> Similar to btf_id_list for PTR_TO_BTF_ID_OR_NULL vs PTR_TO_BTF_ID return type.

I agree with everything. I'll rework the BPF stuff like this. Thanks!

--
Kartikeya
