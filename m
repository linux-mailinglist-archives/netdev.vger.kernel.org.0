Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6C1221C0D
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 07:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgGPFoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 01:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgGPFoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 01:44:14 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298FCC061755;
        Wed, 15 Jul 2020 22:44:14 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id f16so4117714pjt.0;
        Wed, 15 Jul 2020 22:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sBQ5K8y3Wcj2yM8m9FnuFs7JEvOXkirRak/QLYiDMdI=;
        b=eOYTfouAklGsav502XoosLPpFJC/7EimgtqYDwqN1I2HDGwO3tfG1bdzZvbG9Yu+dm
         Rk0DI0CE1e5TzGBH45wsjk35S5sZ+ARQYAZ/4Chxwktgngkiei6JWoNZji9mogDlAIrL
         6BS8LF8Y2jI4pT9t4r0sMJbpjKTpyu6B6vOWCcuTkM3LsUh1+g1VFWcKRfHji0h1xxty
         6iFItecP/oNnJ4O2o8eZIjUrRR24yrzHYiu6Gmbbf2kl+P3ozJyqNGe5DbuSIRKFS6UP
         dBZlVrLT26riTYvZ5J9nIcsGJnGpUt2+gqba2tPN0zrVx7GMMgGRQdI1WuzqIqsUKXom
         HPaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sBQ5K8y3Wcj2yM8m9FnuFs7JEvOXkirRak/QLYiDMdI=;
        b=bryghKnfXSXaka2maATrzBD3gkecZkuIHUNx23VWED7miGCGBcDnfUa58JT2E22ON/
         0PlntyMD5IUcUNzk8HxaOMYhBQorpV0LmJk+bZ9oNrn2MOPiLmFwOiw/Ft2++cCqeCLz
         RpxmhN+Ey4flu1So7RPk2ke5EdgeG+EnkUzLMGuDM1nXi2J8tzjclucZ1AeOfrXyclVV
         yDlMXJ2P9YBG1rAOpKtpQE5QYWx405KKpolcRLhWnFYbCrgAJvP/wJn3X7q+RH6ACcqa
         hVMycb6h1pca2WbKPcBcCujIQOQFldDhzXQxHEhoEt1/++fsqeIdVXrDxrYFrF4C0+RO
         tI1Q==
X-Gm-Message-State: AOAM532XT8A6y1biImnE5qWE7+WmzADFTsPSUSN6gY/JyWeOqYYLhR1D
        2AJf9RvVtDzyy6U3wzOtV0w=
X-Google-Smtp-Source: ABdhPJyGOZRjaF9EP3KCntoWFXcaPkEMeP2NijLD1GFvpW+aPP6xTxIQpz21bSzBFqpyh1BCApseGg==
X-Received: by 2002:a17:90a:3488:: with SMTP id p8mr3347352pjb.211.1594878253555;
        Wed, 15 Jul 2020 22:44:13 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:96f0])
        by smtp.gmail.com with ESMTPSA id 66sm3453157pfg.63.2020.07.15.22.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 22:44:12 -0700 (PDT)
Date:   Wed, 15 Jul 2020 22:44:08 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: BPF logging infrastructure. Was: [PATCH bpf-next 4/6] tools: add
 new members to bpf_attr.raw_tracepoint in bpf.h
Message-ID: <20200716054408.so34cuc2g2iqcppr@ast-mbp.dhcp.thefacebook.com>
References: <CAEf4BzZ_-vXP_3hSEjuceW10VX_H+EeuXMiV=_meBPZn7izK8A@mail.gmail.com>
 <87r1tegusj.fsf@toke.dk>
 <CAEf4Bzbu1wnwWFOWYA3e6KFeSmfg8oANPWD9LsUMRy2E_zrQ0w@mail.gmail.com>
 <87pn8xg6x7.fsf@toke.dk>
 <CAEf4BzYAoetyfyofTX45RQjtz3M-c9=YNeH1uRDbYgK4Ae0TwA@mail.gmail.com>
 <87d04xg2p4.fsf@toke.dk>
 <20200714231133.ap5qnalf6moptvfk@ast-mbp.dhcp.thefacebook.com>
 <874kq9ey2j.fsf@toke.dk>
 <20200715234123.rr7oj74t5hflzmsn@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbodR-+=Q3wRE2UaiouBexvqfwpE-zJGm4Rr1cV2dgZHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbodR-+=Q3wRE2UaiouBexvqfwpE-zJGm4Rr1cV2dgZHQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 06:11:39PM -0700, Andrii Nakryiko wrote:
> >
> > On Wed, Jul 15, 2020, Andrii Nakryiko wrote:
> > >
> > > Inability to figure out what's wrong when using BPF is at the top of
> > > complaints from many users, together with hard to understand logs from
> > > verifier.
> >
> > Only the second part is true. All users are complaining about the verifier.
> > No one is complaing that failed prog attach is somehow lacking string message.
> 
> Ok, next time I'll be helping someone to figure out another -EINVAL,
> I'll remember to reassure them that it's not really frustrating, not a
> guess game, and not a time sink at all.

When the next time the users hit EINVAL due to _their_ usage and not
due to kernel or libbpf bug and libbpf couldn't do anything to make
the error user friendly then yes please raise it up.

> > The users are also complaing about libbpf being too verbose.
> 
> Very well might be, but apart from your complaints on that patch
> adding program loading debug message, I can't remember a single case
> when someone complained about that. Do you have a link for me to get
> some context?
> 
> > Yet you've refused to address the verbosity where it should be reduced and
> 
> It's open-source, everyone is welcome to submit their patches. Just
> because I don't think we need to remove some log messages and thus not
> am creating such patches, doesn't mean it can't be done by someone
> else.

So myself and Toke are wearing 'bpf user' hat in that context.
Both of us indicated that libbpf output is too verbose.
Your response "just send a patch" is a sure way to turn away more users.

> > now refusing to add it where it's needed.
> 
> Can you point to or quote where I refused to add a helpful message to libbpf?

see below for detailed example.

> 
> > It's libbpf job to explain users kernel errors.
> 
> To the best of its ability, yes. Unfortunately there were many times
> where I, as a human, couldn't figure it out without printk'ing my way
> around the kernel. If I can't do that, I can't teach libbpf to do it.
> Error codes are just not granular enough to allow distinguishing a lot
> of error conditions, either by humans or automatically by libbpf.

If there are such cases please bring it up. I'm sure kernel errnos
can become more unique.

> >
> > The same thing is happening with perf_event_open syscall.
> > Every one who's trying to code it directly complaining about the kernel. But
> > not a single user is complaing about perf syscall when they use libraries and
> > tools. Same thing with bpf syscall. libbpf is the interface. It needs to clear
> > and to the point. Right now it's not doing it well. elf dump is too verbose and
> > unnecessary whereas in other places it says nothing informative where it
> > could have printed human hint.
> >
> > libbpf's pr_perm_msg() hint is the only one where libbpf cares about its users.
> > All other messages are useful to libbpf developers and not its users.
> 
> "Couldn't load trivial BPF program. Make sure your kernel supports BPF
> (CONFIG_BPF_SYSCALL=y) and/or that RLIMIT_MEMLOCK is set to big enough
> value."
> "kernel doesn't support global data"
> "can't attach BPF program w/o FD (did you load it?)"
> "specified path %s is not on BPF FS"
> "vmlinux BTF is not found" -- we should clearly add "you need a kernel
> built with CONFIG_DEBUG_INFO_BTF=y"
> "invalid relo for \'%s\' in special section 0x%x; forgot to initialize
> global var?.."

sure. those count too.

> That doesn't mean, though, that the kernel itself can't do better in
> terms of error reporting. But you clearly don't think it's a real
> problem, so I'll let it rest, thank you.

It is a real problem and libbpf has to step up to address it.
The kernel does everything it can already.

Let's take this raw_tp_open patches as an example.
Currently raw_tp_open will EINVAL if prog_fd is incorrect, tp name
is not specified or expected_attach_type doesn't match.
If that happens it's a _libbpf_ bug. It's not a user mistake.
With Toke's patches tgt prog_fd and btf_id are added.
Both can be incorrect. If that happens it's most likely libbpf bug.
The user is writing their bpf_prog.c file with SEC("freplace/name")
libbpf could have messed up prog_fd and btf_id resolution.
The user didn't specify btf_id as a raw integer.
It was a libbpf job to convert user's string name into prog_fd
and btf_id in the first place. If libbpf messes it it shouldn't rely
on the kernel to catch such bugs. It's not a job of the kernel to
point out bugs in the libraries that suppose to be tightly
coupled with the kernel.
When libbpf is doing its job correctly tgt_prog_fd and tgt_btf_id are
valid and BTF of the extension prog can miscompare with BTF of
target prog it's trying to attach to via raw_tp_open with these two
arguments. Take a look at Toke's patches. That comparison is done via
btf_check_type_match(). The most helpful kernel message in such case
will be 'arg2 in foo() has size 4 while bar() has 2'.
That's the best the kernel can do. Yet it's very user unfriendly.
The kernel has no infra today to print BTF in a human friendly way.
But libbpf has BTF dumper. btf_dump__emit_type_decl() alone is
magnitude friendlier to users than kernel messages.
When the kernel's raw_tp_open syscall realizes that BTFs don't match
it can return single unique errno and libbpf can tell the user:
"
Function prototype of BPF prog:
   int ext_bpf_prog(struct __sk_buff *);
doesn't match function prototype of target prog:
   int tgt_prog_name(struct xdp_md *);
"
Everything is available in libbpf to print such error in human friendly way.
Whereas the kernel has no ability to do so.
If that message was coming from the kernel it would have been from
btf_check_type_match() and would be:
"arg1 in ext_bpf_prog() is not a pointer to context".
Compare that to above libbpf error message.
I think the difference is pretty drastic.
libbpf by far is a better place to print human friendly errors.

I'm arguing that raw_tp_open with additional tgt_prog_fd and tgt_btf_id
parameters is not much different from sys_kcmp syscall and from memcmp() libc
function. They compare two objects and return equal or not.
It's not a job of the kernel to say
'objects are not equal because byte 2 is different'.
Such message is not helpeful to users.
It's libbpf job to print two BTFs in human friendly way when the kernel
found them different. It's easier for human to glance over two function
prototypes and spot the difference instead of 'arg1 is not a pointer to context'.

So please make libbpf user friendly. Enough of pointing fingers at the kernel.
