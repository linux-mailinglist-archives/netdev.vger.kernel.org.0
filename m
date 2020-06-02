Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A868D1EC572
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 01:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgFBXH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 19:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgFBXHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 19:07:25 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD30C08C5C0;
        Tue,  2 Jun 2020 16:07:25 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id v2so208337pfv.7;
        Tue, 02 Jun 2020 16:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KTZvJtVigtxw9MJWkvf+29F3R4dmcqUDp8xnTxy0Txg=;
        b=SffIyj5c6wB/USCSVZ2pPT+HAw4XdCf3Vgezto5/vwEHy3Od0dsHLz8l6GNwjYIauT
         q8oiIB3tAf5ApNH+taK8cXQj7aXeHfC2XUQKHEdTa1Cxv3oLgAmnKsEplhN3cQfBulTf
         P1+i9ueya/3X6qhNOfv3wtnWgxg+hfWQlWc/y0nC2wBqUvfUJHq7Ry5RUE4pWvMfZ1Mo
         TR1Aw+IUPIXt0G968mg6qnFTyLxiQb7cJ5JMyD8zTa6GrGmvuaQhFk3SuphUwRlMAu//
         7N1sPtcEOo//9sFQOKNh4thRnfqlkOgLVxvZksrakcj10H9x5h5iCCaqvpVWMDBHQofA
         3qTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KTZvJtVigtxw9MJWkvf+29F3R4dmcqUDp8xnTxy0Txg=;
        b=tBJu8kO535xpY10YkMOhnAhk/Ke2asiB4vZpMUZnj6vmeFSzi7h7+oBnPV2KOpOSZa
         sjFgmsZm3lxy86a1ZnbJICNTKu1iz8Ps8LH/U8LKYrFFlzbGixNKi+6JoWNCLeokNYfn
         P137LYZgcXZkmABpxYuJDCXTtfOWW9DbEMIOCt6ZQfoNG9VF4nSU6qnNfEJtG0pXvTdJ
         rzg2iSjheCus5W1d9GiAUIdqTd77EeVS4NwDmwTEreDzKdV8t53nHdIo6Oael+Sr/ZSV
         sibSVSIKQICA/9QT6gJfldDbETVtuNFYSeUJRLDtsJZW8NaC6k8zBdVEEDakObGHtPHL
         GoYQ==
X-Gm-Message-State: AOAM531nAGcV9sCqjuF8WnPTPVp66GVgRhJeWYJ79ckyk/T1elCQhYUS
        t/1O/PAya+60H5cjUxwQjWk=
X-Google-Smtp-Source: ABdhPJxgn2b2dGiJxuYgsnRLu1c5e44iX50wlO46J8oofZKEqJiCurqFF5LzZDsoFGXddL/77VWKLA==
X-Received: by 2002:a65:6790:: with SMTP id e16mr27092510pgr.145.1591139244993;
        Tue, 02 Jun 2020 16:07:24 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:514a])
        by smtp.gmail.com with ESMTPSA id h3sm102760pje.28.2020.06.02.16.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 16:07:23 -0700 (PDT)
Date:   Tue, 2 Jun 2020 16:07:20 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Michael Forney <mforney@mforney.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: switch BPF UAPI #define constants
 used from BPF program side to enums
Message-ID: <20200602230720.hf2ysnlssg67cpmw@ast-mbp.dhcp.thefacebook.com>
References: <20200303003233.3496043-1-andriin@fb.com>
 <20200303003233.3496043-2-andriin@fb.com>
 <fb80ddac-d104-d0b7-8bed-694d20b62d61@iogearbox.net>
 <CAEf4BzZWXRX_TrFSPb=ORcfun8B+GdGOAF6C29B-3xB=NaJO7A@mail.gmail.com>
 <87blpc4g14.fsf@toke.dk>
 <945cf1c4-78bb-8d3c-10e3-273d100ce41c@iogearbox.net>
 <CAGw6cBuCwmbULDq2v76SWqVYL2o8i+pBg7JnDi=F+6Wcq3SDTA@mail.gmail.com>
 <20200602191703.xbhgy75l7cb537xe@ast-mbp.dhcp.thefacebook.com>
 <CAGw6cBstsD40MMoHg2dGUe7YvR5KdHD8BqQ5xeXoYKLCUFAudg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGw6cBstsD40MMoHg2dGUe7YvR5KdHD8BqQ5xeXoYKLCUFAudg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 02:40:52PM -0700, Michael Forney wrote:
> On 2020-06-02, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > It's possible, but I'm not sure what it will fix.
> > Your example is a bit misleading, since it's talking about B
> > which doesn't have type specifier, whereas enums in bpf.h have ULL
> > suffix where necessary.
> > And the one you pointed out BPF_F_CTXLEN_MASK has sizeof == 8 in all cases.
> 
> Apologies if I wasn't clear, I was just trying to explain why this C
> extension can have confusing semantics where the type of an enum
> constant depends on where it is used. You're right that it doesn't
> happen in this particular case.
> 
> The breakage appears with my C compiler, which as I mentioned, only
> implements the extension when the enum constants fit into unsigned int
> to avoid these problems.
> 
> $ cproc -x c -c - -o /dev/null <<EOF
> > #include <linux/bpf.h>
> > EOF
> <stdin>:420:41: error: enumerator 'BPF_F_CTXLEN_MASK' value cannot be
> represented as 'int' or 'unsigned int'
> cproc: compile: process 3772 exited with status 1
> cproc: preprocess: process signaled: Terminated
> cproc: assemble: process signaled: Terminated
> $
> 
> Since the Linux UAPI headers may be used with a variety of compilers,
> I think it's important to stick to the standard as much as possible.
> BPF_F_CTXLEN_MASK is the only enum constant I've encountered in the
> Linux UAPI that has a value outside the range of unsigned int.

the enum definition of BPF_F_CTXLEN_MASK is certainly within standard.
I don't think kernel should adjust its headers because some compiler
is failing to understand C standard.

> > Also when B is properly annotated like 0x80000000ULL it will have size 8
> > as well.
> 
> Even with a suffixed integer literal, it still may be the case that an
> annotated constant has a different type inside and outside the enum.
> 
> For example, in
> 
> 	enum {
> 		A = 0x80000000ULL,
> 		S1 = sizeof(A),
> 	};
> 	enum {
> 		S2 = sizeof(A),
> 	};
> 
> we have S1 == 8 and S2 == 4.

correct, because enum needs to fit all of its constants.
It's not at all related to size.
sizeof() is an expression that is being evulated in the context and
affects the size of enum.
It could have been any other math operation on constants known
at compile time.

> 
> >> Also, I'm not sure if it was considered, but using enums also changes
> >> the signedness of these constants. Many of the previous macro
> >> expressions had type unsigned long long, and now they have type int
> >> (the type of the expression specifying the constant value does not
> >> matter). I could see this causing problems if these constants are used
> >> in expressions involving shifts or implicit conversions.
> >
> > It would have been if the enums were not annotated. But that's not the case.
> 
> The type of the expression has no relation to the type of the constant
> outside the enum. Take this example from bpf.h:
> 
> 	enum {
> 		BPF_DEVCG_DEV_BLOCK     = (1ULL << 0),
> 	 	BPF_DEVCG_DEV_CHAR      = (1ULL << 1),
> 	};
> 
> Previously, with the defines, they had type unsigned long long. Now,
> they have type int. sizeof(BPF_DEVCG_DEV_BLOCK) == 4 and
> -BPF_DEVCG_DEV_BLOCK < 0 == 1.

and I still don't see how it breaks anything.
If it was #define and .h switched its definition from 1 to 1ULL
it would have had the same effect. That is the point of the constant in .h.
Same effect regardless whether it was done via #define and via enum.
The size and type of the constant may change. It's not uapi breakage.
