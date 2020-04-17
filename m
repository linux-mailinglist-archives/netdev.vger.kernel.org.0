Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329721AD3B6
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 02:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgDQAlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 20:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726114AbgDQAlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 20:41:23 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80061C061A0C;
        Thu, 16 Apr 2020 17:41:23 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n16so243708pgb.7;
        Thu, 16 Apr 2020 17:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nGluuBbMo2Lmzg+gVVdDKC2GK3TJmk6pOomEHD1ggkc=;
        b=MnPuIJ5WT2F1GM6dbgStKRd5JUdAHo3Y8DbCgE9gSmDYDhofAehuVRT7+vHXoSekYm
         w/pgXBef9yERFgw64cJ/smde6F4ZcM0gzQn5BrYGlnILiWo7D0PztYZ2s0bdfKwyiz+v
         zUBNYs7lPMFbpcdvf+zyU8a5o8KCWJEfhbV0qSnLI6WWlSn+U7iSc2cN+mBsLS9jpn0/
         tstJHSYbht1jj3YQgrYBLN/g5kMx3KeIL8wTnWzCc8DkfMduo/aCtK/I1ST7K8UJHugt
         0agN1lXhVQauKIhtRWTHIUrESNE/E11qtffd9A+HaRot0QOfqPTYAvuEByuf6G+59nqX
         9d1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nGluuBbMo2Lmzg+gVVdDKC2GK3TJmk6pOomEHD1ggkc=;
        b=BbmPi0UY1aNGy+8O3C38u3aQcDkH/wXFS1ELNMKZ2rgzOESDEUdDeao/v2rC1MjRzz
         zQkBVxqNByVUO6mpbTOsZ6e8SDFQ62DeJeAPG76ovRYQyb0Ta4vdlOAdv5FUjUZ/y1uy
         gXCj/VxeViR4p6MmgHtlwOyXL+x2vBtwRjGmU0pwgJ5g5gqNZHuvUCzzTKukrbGIGeBp
         1nD13R+PjH0T7UseVvAVDbIwsiz2BZl36959XOVUCXeHhD55Wn87/GXHx2L7OaF70S3a
         /jNN2eXwAH/+lk+5QqttKf1x63CM1ankj8exaFJ1hFNhrcqTi04kzwSFzlbK4Fz5N+k3
         fIpQ==
X-Gm-Message-State: AGi0PuZVVeyGr0GCT3/QILjioVLNbft+8F87VEVNQjiGQbxuaFEY0jDy
        KyrWJR5ukbcmT2u8sKKtO9U=
X-Google-Smtp-Source: APiQypI1pK/0/Px0nyfF6rvf6hKS2afJx68BnvR07h54uQSU5CV/jqM4sJyYoXi2mOqDMDUy8s+7PQ==
X-Received: by 2002:a62:2506:: with SMTP id l6mr499186pfl.184.1587084082893;
        Thu, 16 Apr 2020 17:41:22 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:fff8])
        by smtp.gmail.com with ESMTPSA id t3sm7801017pfq.110.2020.04.16.17.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 17:41:22 -0700 (PDT)
Date:   Thu, 16 Apr 2020 17:41:19 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jann Horn <jannh@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf] bpf: Use pointer type whitelist for XADD
Message-ID: <20200417004119.owbpb7pavdf3nt5t@ast-mbp.dhcp.thefacebook.com>
References: <20200415204743.206086-1-jannh@google.com>
 <20200416211116.qxqcza5vo2ddnkdq@ast-mbp.dhcp.thefacebook.com>
 <CAG48ez0ZaSo-fC0bXnYChAmEZvv_0sGsxUG5HdFn6YJdOf1=Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0ZaSo-fC0bXnYChAmEZvv_0sGsxUG5HdFn6YJdOf1=Mg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 12:34:42AM +0200, Jann Horn wrote:
> On Thu, Apr 16, 2020 at 11:11 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > On Wed, Apr 15, 2020 at 10:47:43PM +0200, Jann Horn wrote:
> > > At the moment, check_xadd() uses a blacklist to decide whether a given
> > > pointer type should be usable with the XADD instruction. Out of all the
> > > pointer types that check_mem_access() accepts, only four are currently let
> > > through by check_xadd():
> > >
> > > PTR_TO_MAP_VALUE
> > > PTR_TO_CTX           rejected
> > > PTR_TO_STACK
> > > PTR_TO_PACKET        rejected
> > > PTR_TO_PACKET_META   rejected
> > > PTR_TO_FLOW_KEYS     rejected
> > > PTR_TO_SOCKET        rejected
> > > PTR_TO_SOCK_COMMON   rejected
> > > PTR_TO_TCP_SOCK      rejected
> > > PTR_TO_XDP_SOCK      rejected
> > > PTR_TO_TP_BUFFER
> > > PTR_TO_BTF_ID
> > >
> > > Looking at the currently permitted ones:
> > >
> > >  - PTR_TO_MAP_VALUE: This makes sense and is the primary usecase for XADD.
> > >  - PTR_TO_STACK: This doesn't make much sense, there is no concurrency on
> > >    the BPF stack. It also causes confusion further down, because the first
> > >    check_mem_access() won't check whether the stack slot being read from is
> > >    STACK_SPILL and the second check_mem_access() assumes in
> > >    check_stack_write() that the value being written is a normal scalar.
> > >    This means that unprivileged users can leak kernel pointers.
> > >  - PTR_TO_TP_BUFFER: This is a local output buffer without concurrency.
> > >  - PTR_TO_BTF_ID: This is read-only, XADD can't work. When the verifier
> > >    tries to verify XADD on such memory, the first check_ptr_to_btf_access()
> > >    invocation gets confused by value_regno not being a valid array index
> > >    and writes to out-of-bounds memory.
> >
> > > Limit XADD to PTR_TO_MAP_VALUE, since everything else at least doesn't make
> > > sense, and is sometimes broken on top of that.
> > >
> > > Fixes: 17a5267067f3 ("bpf: verifier (add verifier core)")
> > > Signed-off-by: Jann Horn <jannh@google.com>
> > > ---
> > > I'm just sending this on the public list, since the worst-case impact for
> > > non-root users is leaking kernel pointers to userspace. In a context where
> > > you can reach BPF (no sandboxing), I don't think that kernel ASLR is very
> > > effective at the moment anyway.
> > >
> > > This breaks ten unit tests that assume that XADD is possible on the stack,
> > > and I'm not sure how all of them should be fixed up; I'd appreciate it if
> > > someone else could figure out how to fix them. I think some of them might
> > > be using XADD to cast pointers to numbers, or something like that? But I'm
> > > not sure.
> > >
> > > Or is XADD on the stack actually something you want to support for some
> > > reason, meaning that that part would have to be fixed differently?
> >
> > yeah. 'doesnt make sense' is relative.
> > I prefer to fix the issues instead of disabling them.
> > xadd to PTR_TO_STACK, PTR_TO_TP_BUFFER, PTR_TO_BTF_ID should all work
> > because they are direct pointers to objects.
> 
> PTR_TO_STACK and PTR_TO_TP_BUFFER I can sort of understand. But
> PTR_TO_BTF_ID is always readonly, so XADD on PTR_TO_BTF_ID really
> doesn't make any sense AFAICS.

Not quite. See bpf_tcp_ca_btf_struct_access(). Few fields of one specific
'struct tcp_sock' are whitelisted for write.

> 
> > Unlike pointer to ctx and flow_key that will be rewritten and are not
> > direct pointers.
> >
> > Short term I think it's fine to disable PTR_TO_TP_BUFFER because
> > prog breakage is unlikely (if it's actually broken which I'm not sure yet).
> > But PTR_TO_BTF_ID and PTR_TO_STACK should be fixed.
> > The former could be used in bpf-tcp-cc progs. I don't think it is now,
> > but it's certainly conceivable.
> > PTR_TO_STACK should continue to work because tests are using it.
> > 'but stack has no concurrency' is not an excuse to break tests.
> 
> Meh, if you insist, I guess I can patch it differently. Although I
> really think that "tests abuse it as a hack" shouldn't be a reason to
> keep around functionality that doesn't make sense for production use.

The pointer could have reached __sync_fetch_and_add() via two different paths
just to simplify the C code:
if (..)
 my_value = lookup();
else
 my_value = &my_init_value;
__sync_fetch_and_add(&my_init_value->counter, 1);
