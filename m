Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C441F37FAEF
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 17:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbhEMPmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 11:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234869AbhEMPmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 11:42:32 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135DEC061574;
        Thu, 13 May 2021 08:41:21 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id b21so14631400plz.0;
        Thu, 13 May 2021 08:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S0rCpDWqFzFb2Ye8JF/HqVeJjki9WL5JCSxIfaPJ7d4=;
        b=Se6FrICKBH34M680HsymP1FwYlvdLDaEftfCZui4fskbMIb/9w1PRa/9BwVqJ1dXqT
         tnE8aBtQF9GOVkB5JGX5cBbHTfv4LW/oJNajgdoa5vDpWa1F1s32YznsRwyFcq4oJTqr
         W5AQbPqcZgxAFyBOsDmaRzNqGl6R0DPYvWZwQU742sjgBXGVmcPaF5/2TzSgkB911Y1s
         R+Avg4DOg39cyNV2tELTJet8GOj73RVK4B0NCVoJoc1Rvlh7FmjwB6hmN6Q2EH0jGsWL
         65OXc/yi1y9KDYteEiGALzSOJok+hkGOob68fFl5vPiaVbaQpzSpeK+cjK9syU2NMhTi
         /ByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S0rCpDWqFzFb2Ye8JF/HqVeJjki9WL5JCSxIfaPJ7d4=;
        b=PSslszv/dMWKXrS5v67FCXhk8snuzlqpyUNRe6/3CoPY29nn9aEe8bS15dX83xqrWM
         l0dZdHyIA2eWEh8u8Cs7V1v8MUuC7VBOurIV/sWn88quhX7VLwWiZ2pZtnHLIRGPtZef
         go9zxJ3tQaImlV1OhiCzhBeCNUtGmU/cFoT2ip3L+kGZWqTWQpVT/4eZttgWzH9X0M3D
         Vb/i5q+C/3/lanKwSNdq2WJy+/Cc7Nl7SBCIZyqb1iI015J3x+arg7Sfuh89/Qqws4Et
         b7RDcE9r5FFEg/rQYALJgCWMGDBrVJjN3tTc4miv94zvahSGy6sGm+pWJp8prp2sKIxo
         ydZg==
X-Gm-Message-State: AOAM533p6LuW67cjofG/eYI1MP+jsb8U/EtS6Ks5zA6h7/yROX0FjMsN
        o3+VGTGAUUH73IXtxL/7lg0=
X-Google-Smtp-Source: ABdhPJyomL+EZYnJZdhLQIkr100kUS27b8B98fm+aUM4WURr0SgB6mFhRZt+fhAaDDtjU02Iko3AOQ==
X-Received: by 2002:a17:902:a401:b029:ef:4ee:6a7e with SMTP id p1-20020a170902a401b02900ef04ee6a7emr34938984plq.65.1620920480559;
        Thu, 13 May 2021 08:41:20 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9b6b])
        by smtp.gmail.com with ESMTPSA id t19sm2422622pfg.70.2021.05.13.08.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 08:41:19 -0700 (PDT)
Date:   Thu, 13 May 2021 08:41:15 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: bpf libraries and static variables. Was: [PATCH v2 bpf-next 2/6]
 libbpf: rename static variables during linking
Message-ID: <20210513154115.kzbyrhsmsqp6exjr@ast-mbp.dhcp.thefacebook.com>
References: <20210427022231.pbgtrdbxpgdx2zrw@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZOwTp4vQxvCSXaS4-94fz_eZ7Q4n6uQfkAnMQnLRaTbQ@mail.gmail.com>
 <20210428045545.egqvhyulr4ybbad6@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZo7_r-hsNvJt3w3kyrmmBJj7ghGY8+k4nvKF0KLjma=w@mail.gmail.com>
 <20210504044204.kpt6t5kaomj7oivq@ast-mbp>
 <CAADnVQ+WV8xZqJfWx8em5Ch8aKA8xcPqR0wT0BdFf9M==W5_FQ@mail.gmail.com>
 <CAEf4BzY2z+oh=N0X26RBLEWw0t9pT7_fN0mWyDqfGcwuK8A-kg@mail.gmail.com>
 <20210511230505.z3rdnppplk3v3jce@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbJ==4iUFp4pYpkgbKy40+Q6+RTPJVh0gUANHajs88ZTg@mail.gmail.com>
 <CACAyw9-9CwzMPzZGOOs6RD5Rz4X+MsBkDE-y3FZuLCw1znSUEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw9-9CwzMPzZGOOs6RD5Rz4X+MsBkDE-y3FZuLCw1znSUEQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 09:37:13AM +0100, Lorenz Bauer wrote:
> On Wed, 12 May 2021 at 19:50, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> 
> ...
> 
> > So at least for BPF skeleton, the flow I was imagining would be
> > like this.
> 
> Thank you for the worked out example, it's really helpful.
> 
> >
> > 1. BPF library abc consists of abc1.bpf.c and abc2.bpf.c. It also has
> > user-space component in abc.c.
> > 2. BPF app uses abs library and has its own app1.bpf.c and app2.bpf.c
> > and app.c for user-space.
> > 3. BPF library author sets up its Makefile to do
> >   a. clang -target bpf -g -O2 -c abc1.bpf.c -o abc1.bpf.o
> >   b. clang -target bpf -g -O2 -c abc2.bpf.c -o abc2.bpf.o
> >   c. bpftool gen lib libabc.bpf.o abc1.bpf.o abc2.bpf.o
> 
> I think we can plug this into bpf2go [1] on our side in the best case,
> which would avoid duplicating the static linker.
> 
> >   d. bpftool gen subskeleton libabc.bpf.o > libabc.subskel.h
> >   e. abc.c (user-space library) is of the form
> >
> > #include "libabc.subskel.h"
> >
> > static struct libabc_bpf *subskel;
> >
> > int libabc__init(struct bpf_object *obj)
> > {
> >     subskel = libabc_bpf__open_subskel(obj);
> >
> >     subskel->data->abc_my_var = 123;
> > }
> >
> > int libabc__attach()
> > {
> >     libabc_bpf__attach(subskel);
> > }
> >
> >   f. cc abc.c into libabc.a and then libabc.a and libabc.bpf.o are
> > distributed to end user
> >
> > 3. Now, from BPF application author side:
> >   a. clang -target bpf -g -O2 -c app1.bpf.c -o app1.bpf.o
> >   b. clang -target bpf -g -O2 -c app2.bpf.c -o app2.bpf.o
> >   c. bpftool gen object app.bpf.o app1.bpf.o app2.bpf.o libabc.bpf.o
> 
> I haven't worked out exactly how things would work, but on the Go side
> it might be possible to distribute libabc.bpf.o plus the Go "library"
> code as a package. So the Go toolchain would never create this merged
> object, but instead do
> 
>     bpftool gen object app.bpf.o app1.bpf.o app2.bpf.o
> 
> and later link app.bpf.o and libabc.bpf.o at runtime. It would be
> simpler from our side if bpftool gen object could link both libraries
> and "programs", maybe we can discuss the details of this during office
> hours.
> 
> 1: https://pkg.go.dev/github.com/cilium/ebpf/cmd/bpf2go

This is really cool! Looks like libbpf C skeleton that embeds the full
elf file as a string into golang object, but it doesn't support
direct data/rodata/bss variable access yet? Looks like only progs and maps
are natively exposed into golang?

Have you seen the light skeleton yet?
https://patchwork.kernel.org/project/netdevbpf/patch/20210512213256.31203-18-alexei.starovoitov@gmail.com/
It's design centered on supporting languages like golang that
cannot take libbpf in C as-is. I think reimplementation of everything
in every other language that doesn't have clean binding to C is going
to hurt BPF ecosystem long term. The light skeleton is designed to address that.
It's libbpf-less. We're going to teach bpftool to emit golang equivalent of .lskel.h
Here is trace_printk.lskel.h example:
https://gist.github.com/4ast/774ea58f8286abac6aa8e3bf3bf3b903
The hex string dumps in there are not elf file anymore.
They're blobs directly interpreted by the kernel.
Note the headers:
#include <bpf/bpf.h>
#include <bpf/skel_internal.h>
The light skeleton is using only three sys_bpf wrappers (map_create, prog_load, test_run).
While the end result looks and feels like existing skeleton.
It doesn't need libelf and doesn't need all of libbpf to load and attach progs.
The plan is to take cilium bpf progs and represent them lskel.h tests in selftests/bpf
to demonstrate the feature richness.

The work on llvm's ld.lld linker is in progress as well:
https://reviews.llvm.org/D101336
The users will be able to:
clang -target bpf -flto -O2 -g -c t1.c -o t1.bc
clang -target bpf -flto -O2 -g -c t2.c -o t2.bc
ld.lld -r t1.bc t2.bc -o final.o

Such llvm linking step can only happen once, since it's an LTO compilation.
To use it with libraries the users would need to:
// compile lib files
clang -target bpf -flto -g -O2 -c abc1.bpf.c -o abc1.bpf.o
clang -target bpf -flto -g -O2 -c abc2.bpf.c -o abc2.bpf.o
// compile app files
clang -target bpf -flto -g -O2 -c app1.bpf.c -o app1.bpf.o
clang -target bpf -flto -g -O2 -c app2.bpf.c -o app2.bpf.o
// link and LTO-compile everything
ld.lld -r abc1.bpf.o abc2.bpf.o app1.bpf.o app2.bpf.o -o final.o

Obviously we still need libbpf static linker for linking true .o-s
when LTO is not suitable.
