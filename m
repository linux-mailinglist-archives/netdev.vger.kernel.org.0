Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65552D3700
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 00:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731765AbgLHXkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 18:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731698AbgLHXkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 18:40:04 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65569C0613CF;
        Tue,  8 Dec 2020 15:39:24 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id s2so148061plr.9;
        Tue, 08 Dec 2020 15:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eADlgZ+VjApM3WW59Y7Aka72cQ/enDZQufZ1bqN1G7Y=;
        b=PRYy90S2a10HzP8M3XAQCd6kxKLzsPGp5mxNW8EHVFF4pbThTcPjukcmB1kj4phiCr
         jrUKM+h1rmpcfYc3Yi6vA0D4cGUr94JnDUI2EldL7edxiPc3/HylD0gJgi8GffHK4vY7
         RaES8auVFkOqjWbprInGYS215fThr9uSo11mxJ0XHlWDpDlXDArxB1BDSvjDEaoxw1mH
         k0H7t31cy7S84eCe1IKmXZ+55Dt7htvPPOenLOIgC0VCDCOU4MkxZk1+UlGXf/XzWmQv
         DUUwZAxJcFnx7XXm7c7y+cxZyHhmRnm9ueB5P85nWQHofxSGqP3gDHbgFhIQLgHCEgrX
         kDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eADlgZ+VjApM3WW59Y7Aka72cQ/enDZQufZ1bqN1G7Y=;
        b=dfU83b9G61sW1JpMgp4Xnb1fC8rhmIBVoW2pTCyeOd4eT7s528FT62yABJRqA4x6GY
         01DGtq/qNVLBi7KpgjmLrfSQ13o708iR4lx8r5jNqaQT4UYP/UYDwGcrMjPGFdJFcpof
         oBFJSl/3UGGgNzXLgIIirsPM6vJlRSAS4IBscs3aUECsmRwitNtsUHpYjPV14jbCBj0L
         PP+4nzJfob6Sveu4DtqC9qs1r1nQ1BTjbvGuJwDwBD/QnRKDGA6rKIWG4EOjPFGuXPrf
         is3oIQ1Izbh8yROyknYwrht1O55+Cd6tE1pLYoeIkdUaNrA2/vRJEKke0QURk7JEfqlW
         ae+Q==
X-Gm-Message-State: AOAM5301ec8yzEIZfmDB8/W2QA4IpblkrrVtv6ulTM5/2ddDFpeywh40
        js9ZYP/LmcyHKgzuCYIbN5E=
X-Google-Smtp-Source: ABdhPJyRBhpBWukVk3kYVyTCafGf+5OHPBpsn3w8pRsIHVQVTrhyBCHCPp9DPczSHMfJQzQio7Qd6Q==
X-Received: by 2002:a17:902:ed11:b029:da:3137:2695 with SMTP id b17-20020a170902ed11b02900da31372695mr309660pld.1.1607470763853;
        Tue, 08 Dec 2020 15:39:23 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:42ab])
        by smtp.gmail.com with ESMTPSA id 19sm266933pfn.133.2020.12.08.15.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 15:39:23 -0800 (PST)
Date:   Tue, 8 Dec 2020 15:39:20 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: support module BTF for
 BPF_TYPE_ID_TARGET CO-RE relocation
Message-ID: <20201208233920.qgrluwoafckvq476@ast-mbp>
References: <20201205025140.443115-1-andrii@kernel.org>
 <alpine.LRH.2.23.451.2012071623080.3652@localhost>
 <20201208031206.26mpjdbrvqljj7vl@ast-mbp>
 <CAEf4BzaXvFQzoYXbfutVn7A9ndQc9472SCK8Gj8R_Yj7=+rTcg@mail.gmail.com>
 <alpine.LRH.2.23.451.2012082202450.25628@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.23.451.2012082202450.25628@localhost>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 10:13:35PM +0000, Alan Maguire wrote:
> On Mon, 7 Dec 2020, Andrii Nakryiko wrote:
> 
> > On Mon, Dec 7, 2020 at 7:12 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Mon, Dec 07, 2020 at 04:38:16PM +0000, Alan Maguire wrote:
> > > > Sorry about this Andrii, but I'm a bit stuck here.
> > > >
> > > > I'm struggling to get tests working where the obj fd is used to designate
> > > > the module BTF. Unless I'm missing something there are a few problems:
> > > >
> > > > - the fd association is removed by libbpf when the BPF program has loaded;
> > > > the module fds are closed and the module BTF is discarded.  However even if
> > > > that isn't done (and as you mentioned, we could hold onto BTF that is in
> > > > use, and I commented out the code that does that to test) - there's
> > > > another problem:
> > > > - I can't see a way to use the object fd value we set here later in BPF
> > > > program context; btf_get_by_fd() returns -EBADF as the fd is associated
> > > > with the module BTF in the test's process context, not necessarily in
> > > > the context that the BPF program is running.  Would it be possible in this
> > > > case to use object id? Or is there another way to handle the fd->module
> > > > BTF association that we need to make in BPF program context that I'm
> > > > missing?
> > > > - A more long-term issue; if we use fds to specify module BTFs and write
> > > > the object fd into the program, we can pin the BPF program such that it
> > > > outlives fds that refer to its associated BTF.  So unless we pinned the
> > > > BTF too, any code that assumed the BTF fd-> module mapping was valid would
> > > > start to break once the user-space side went away and the pinned program
> > > > persisted.
> > >
> > > All of the above are not issues. They are features of FD based approach.
> > > When the program refers to btf via fd the verifier needs to increment btf's refcnt
> > > so it won't go away while the prog is running. For module's BTF it means
> > > that the module can be unloaded, but its BTF may stay around if there is a prog
> > > that needs to access it.
> > > I think the missing piece in the above is that btf_get_by_fd() should be
> > > done at load time instead of program run-time.
> > > Everything FD based needs to behave similar to map_fds where ld_imm64 insn
> > > contains map_fd that gets converted to map_ptr by the verifier at load time.
> > 
> > Right. I was going to extend verifier to do the same for all used BTF
> > objects as part of ksym support for module BTFs. So totally agree.
> > Just didn't need it so far.
> > 
> 
> Does this approach prevent more complex run-time specification of BTF 
> object fd though?  For example, I've been working on a simple tracer 
> focused on kernel debugging; it uses a BPF map entry for each kernel 
> function that is traced. User-space populates the map entry with BTF type 
> ids for the function arguments/return value, and when the BPF program 
> runs it uses the instruction pointer to look up the map entry for that
> function, and uses bpf_snprintf_btf() to write the string representations 
> of the function arguments/return values.  I'll send out an RFC soon, 
> but longer-term I was hoping to extend it to support module-specific 
> types.  Would a dynamic case like that - where the BTF module fd is looked 
> up in a map entry during program execution (rather than derived via 
> __btf_builtin_type_id()) work too? Thanks!

fd has to be resolved in the process context. bpf prog can read fd
number from the map, but that number is meaningless.
Say we allow using btf_obj_id+btf_id, how user space will know these
two numbers? Some new libbpf api that searches for it?
An extension to libbpf_find_vmlinux_btf_id() ? I was hoping that this api
will stay semi-internal. But say it's extended.
The user space will store a pair of numbers into a map and
what program are going to do with it?
If it's printing struct veth_stats contents it should have attached to
a corresponding function in the veth module via fentry or something.
The prog has hard coded logic in C with specific pointer to print.
The prog has its type right there. Why would the prog take a pointer
from one place, but it's type_id from the map? That's not realistic.
Where it would potentially make sense is what I think you're descring
where single kprobe style prog attached to many places and args of
those places are stored in a map and the prog selects them with
map_lookup with key=PT_REGS_IP ?
And passes pointers into bpf_snprintf_btf() from PT_REGS_PARM1() ?
I see why that is useful, but it's so racy. By the time the map
is populated those btf_obj_id+btf_id could be invalid.
I think instead of doing this in user space the program needs an access
to vmlinux+mods BTFs. Sort-of like proposed bpf helper to return ksym
based on IP there could be a helper to figure out btf_id+btf_obj_POINTER
based on IP. Then there will no need for external map to populate.
Would that solve your use case?
