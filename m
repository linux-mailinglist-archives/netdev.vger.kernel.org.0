Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FF7446FC6
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 19:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbhKFSQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 14:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhKFSQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 14:16:12 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85385C061570;
        Sat,  6 Nov 2021 11:13:31 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s136so11202325pgs.4;
        Sat, 06 Nov 2021 11:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/pd4AN/EPfNtALjSC0dARA3+z1qOP7tBAG8Hf0q4bR8=;
        b=p7b/BsfeNtIj+CZMhcaWNbowSRvp0svZKRdUyWzOq7ugOIzDhT7u08PGhobo6K56TC
         2kHqaYG61PKXAyHUJefnbCANCPzsKCh+gNuxj9QVQ34WyI7bIxlbKiblmoUSet9eMgHV
         yeHu7Gs0UG+nB6rE3qof9HvTD93bN7HpErTT5gfCmNB87whWCz+Ww67uXWEU4url2IQz
         VKZJsXpg3DDmouJStLCWjsVQiuIBA4yxGnGyof2i1djPCKl3YRvwGuxDmqo601FtFRnU
         sHH9HopjOUE5g14U4sEgptOs7KUeJpDyV0fiNVW48g290pZ0xy49bGXWCw2gmsJUgO75
         U7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/pd4AN/EPfNtALjSC0dARA3+z1qOP7tBAG8Hf0q4bR8=;
        b=52kY8UNbwmqqHmuDEjwtq1P1G24/45ILyTzpALInzjeL4H1dBNUNp/dWEILt6r2Qy4
         DwKlY5Rj17LElZiUadpm/5yK46skuwya/i0ni8fijYc+KhdFBSJMR+/8TrFddJzw8Stu
         Ydw3HAucZ8p5km+BLTFo3ug0mD7UjLZ9x532i9BfrqEZgT/vCr0YHR0aqS98c4T/22fM
         A5dNcdy9/3xFaYsa2UQ/ir+PKOmBR0rOIaHTFOUtUx0EmtSlDxYP0MyGBPs+MjSvFbYy
         9/dMNIoYqZOagtqG+wQRMGp4GIqr/l/iYNtvUIWhF5TXhu/ZVMrDdCDJeWjFO8s6v9B2
         skqw==
X-Gm-Message-State: AOAM5317hVbM/WFNrkdqliFH+S8aXPULPYLAUGNriHAZPBt7hCZla1M8
        j7OSQBdzqqCUkDegutSNAa0=
X-Google-Smtp-Source: ABdhPJzGQGTpQUu6xtX42zka1eiTpf2E2QWoWzC+A2FNvouADaP0JNLoOvXV32MQ+yCqTBLoocpmTw==
X-Received: by 2002:a63:af06:: with SMTP id w6mr50830059pge.436.1636222410850;
        Sat, 06 Nov 2021 11:13:30 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:5e3b])
        by smtp.gmail.com with ESMTPSA id j8sm11412392pfu.27.2021.11.06.11.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Nov 2021 11:13:30 -0700 (PDT)
Date:   Sat, 6 Nov 2021 11:13:28 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
Message-ID: <20211106181328.5u4w6adgny6rkr46@ast-mbp.dhcp.thefacebook.com>
References: <20211030144609.263572-1-memxor@gmail.com>
 <20211102231642.yqgocduxcoladqne@ast-mbp.dhcp.thefacebook.com>
 <20211104125503.smxxptjqri6jujke@apollo.localdomain>
 <20211105204908.4cqxk2nbkas6bduw@ast-mbp.dhcp.thefacebook.com>
 <20211105211312.ms3r7zpna3c7ct4f@apollo.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105211312.ms3r7zpna3c7ct4f@apollo.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 06, 2021 at 02:43:12AM +0530, Kumar Kartikeya Dwivedi wrote:
> 
> Right now only PTR_TO_BTF_ID and PTR_TO_SOCK and scalars are supported, as you
> noted, for kfunc arguments.
> 
> So in 3/6 I move the PTR_TO_CTX block before btf_is_kernel check, that means if
> reg type is PTR_TO_CTX and it matches the argument for the program, it will use
> that, otherwise it moves to btf_is_kernel(btf) block, which checks if reg->type
> is PTR_TO_BTF_ID or one of PTR_TO_SOCK* and does struct match for those. Next, I
> punt to ptr_to_mem for the rest of the cases, which I think is problematic,
> since now you may pass PTR_TO_MEM where some kfunc wants a PTR_TO_BTF_ID.
> 
> But without bpf_func_proto, I am not sure we can decide what is expected in the
> kfunc. For something like bpf_sock_tuple, we'd want a PTR_TO_MEM, but taking in
> a PTR_TO_BTF_ID also isn't problematic since it is just data, but for a struct
> embedding pointers or other cases, it may be a problem.
> 
> For PTR_TO_CTX in kfunc case, based on my reading and testing, it will reject
> any attempts to pass anything other than PTR_TO_CTX due to btf_get_prog_ctx_type
> for that argument. So that works fine.
> 
> To me it seems like extending with some limited argument checking is necessary,
> either using tagging as you mentioned or bpf_func_proto, or some other hardcoded
> checking for now since the number of helpers needing this support is low.

Got it. The patch 3 commit log was too terse for me to comprehend.
Even with detailed explanation above it took me awhile to understand the
consequences of the patch... and 'goto ptr_to_mem' I misunderstood completely.
I think now we're on the same page :)

Agree that allowing PTR_TO_CTX into kfunc is safe to do in all cases.
Converting PTR_TO_MEM to PTR_TO_BTF_ID is also safe when kernel side 'struct foo'
contains only scalars. The patches don't have this check yet (as far as I can see).
That's the only missing piece.
With that in place 'struct bpf_sock_tuple' can be defined on the kernel side.
The bpf prog can do include "vmlinux.h" to use it to pass as PTR_TO_MEM
into kfunc. The patch 5 kernel function bpf_skb_ct_lookup can stay as-is.
So no tagging or extensions to bpf_func_proto are necessary.

The piece I'm still missing is why you need two additional *btf_struct_access.
Why do you want to restrict read access?
The bpf-tcp infra has bpf_tcp_ca_btf_struct_access() to allow-list
few safe fields for writing.
Is there a use case to write into 'struct nf_conn' from bpf prog? Probably not yet.
Then let's keep the default btf_struct_access() behavior for now.
The patch 5 will be defining bpf_xdp_ct_lookup_tcp/bpf_skb_ct_lookup_tcp
and no callbacks at all.
acquire/release are probably cleaner as explicit btf_id_list-s.
Similar to btf_id_list for PTR_TO_BTF_ID_OR_NULL vs PTR_TO_BTF_ID return type.
