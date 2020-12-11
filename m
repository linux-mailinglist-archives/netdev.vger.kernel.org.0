Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95BE2D81D1
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 23:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406801AbgLKWRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 17:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406763AbgLKWQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 17:16:19 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77DFC0613D6;
        Fri, 11 Dec 2020 14:15:39 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id u12so10172665ilv.3;
        Fri, 11 Dec 2020 14:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nUk8Ck2w9TWl88cogCNNeTiJsQCttP4ejXz/+asJ8qU=;
        b=BSYSvxGR9Ntaxosd0faMpMSmuyQ2CfboP2bMFENX8tdORmhTpc1VfEdED84Rn0mJ41
         SpvVQiK9lAbbqsHaGPCEdn4NOC7jUF7G9jaJsJZR4bhy3EQvq8lo2K7B8UHH1SOMHktP
         DeiYFpAOAJEoA98nHD/nBDtF/jncPHy99FUV4it5K9DWjbTq966BvKdITT66X7JcgbT1
         6ElHlDg5C2YwkaufAYZGsV2OmKyOBjh/czornvIu33wMdWlD6NuXUJDKvhLzy+cqOKuy
         id2vtogT0TfkS2h3ozXB7cwWx2sVLwXlN2PjxmVuA8xk2jUpRT7mu7BUu8lutx4nucc+
         DPYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nUk8Ck2w9TWl88cogCNNeTiJsQCttP4ejXz/+asJ8qU=;
        b=Nn7vAclk6i+9LDBiURqj0bNFGLpEt0K5Gna6z2GUQec7FYfwn07A1CJQbEzumG+ge3
         KSTMMtvigbLZq8bSXYksugPNVmM5p7D8y8w9UH/Kc23/C6yGhutZ2S7WqgCndsk20+MO
         Ol0OG7z9Smurg/bGXY8G89xTIKwBqh8QpoRukDMPHrG6wrC3HGiTsktdWbdUE0yxEq1N
         XUiS4zHtbsmJL/2t/4FYJ2DPqpXIfCLN1SXQGc1MQHnADiZSK1y+wuXQ6blW7pgTsY/L
         O0fq3/IhBtvgOKR1ZzcqrFixuCUetROOewjRxYAw5JdrJPq6VEpOH7q+2I+L9AQaPe1j
         kZlQ==
X-Gm-Message-State: AOAM5325CB/ryRaV6t/oSC72b2fjT5vhASerBvBuSpCf7rqeYCxfvFKK
        66jrEqWLFY4mx8rA6ZWCFqq3uLcx58dUFv3V9Mw=
X-Google-Smtp-Source: ABdhPJzI0PKfFkzHltF9ToLnMZ3E9+3S+Nx8jTtgQI4Oh/+MkPPGl+8k7GbTOXWOIY2doi2OSqLsdIyrVbmsK7Cxeqw=
X-Received: by 2002:a05:6e02:c25:: with SMTP id q5mr18252638ilg.286.1607724938985;
 Fri, 11 Dec 2020 14:15:38 -0800 (PST)
MIME-Version: 1.0
References: <20201211042734.730147-1-andrii@kernel.org> <20201211042734.730147-3-andrii@kernel.org>
 <20201211212741.o2peyh3ybnkxsu5a@ast-mbp>
In-Reply-To: <20201211212741.o2peyh3ybnkxsu5a@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Dec 2020 14:15:28 -0800
Message-ID: <CAEf4BzbZK8uZOprwHq_+mh=2Lb27POv5VMW4kB6eyPc_6bcSPg@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 2/4] bpf: support BPF ksym variables in
 kernel modules
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 1:27 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Dec 10, 2020 at 08:27:32PM -0800, Andrii Nakryiko wrote:
> > During BPF program load time, verifier will resolve FD to BTF object and will
> > take reference on BTF object itself and, for module BTFs, corresponding module
> > as well, to make sure it won't be unloaded from under running BPF program. The
> > mechanism used is similar to how bpf_prog keeps track of used bpf_maps.
> ...
> > +
> > +     /* if we reference variables from kernel module, bump its refcount */
> > +     if (btf_is_module(btf)) {
> > +             btf_mod->module = btf_try_get_module(btf);
>
> Is it necessary to refcnt the module? Correct me if I'm wrong, but
> for module's BTF we register a notifier. Then the module can be rmmod-ed
> at any time and we will do btf_put() for corresponding BTF, but that BTF may
> stay around because bpftool or something is looking at it.

Correct, BTF object itself doesn't take a refcnt on module.

> Similarly when prog is attached to raw_tp in a module we currently do try_module_get(),
> but is it really necessary ? When bpf is attached to a netdev the netdev can
> be removed and the link will be dangling. May be it makes sense to do the same
> with modules?  The raw_tp can become dangling after rmmod and the prog won't be

So for raw_tp it's not the case today. I tested, I attached raw_tp,
kept triggering it in a loop, and tried to rmmod bpf_testmod. It
failed, because raw tracepoint takes refcnt on module. rmmod -f
bpf_testmod also didn't work, but it's because my kernel wasn't built
with force-unload enabled for modules. But force-unload is an entirely
different matter and it's inherently dangerous to do, it can crash and
corrupt anything in the kernel.

> executed anymore. So hard coded address of a per-cpu var in a ksym will
> be pointing to freed mod memory after rmmod, but that's ok, since that prog will
> never execute.

Not so fast :) Indeed, if somehow module gets unloaded while we keep
BPF program loaded, we'll point to unallocated memory **OR** to a
memory re-used for something else. That's bad. Nothing will crash even
if it's unmapped memory (due to bpf_probe_read semantics), but we will
potentially be reading some garbage (not zeroes), if some other module
re-uses that per-CPU memory.

As for the BPF program won't be triggered. That's not true in general,
as you mention yourself below.

> On the other side if we envision a bpf prog attaching to a vmlinux function
> and accessing per-cpu or normal ksym in some module it would need to inc refcnt
> of that module, since we won't be able to guarantee that this prog will
> not execute any more. So we cannot allow dangling memory addresses.

That's what my new selftest is doing actually. It's a generic
sys_enter raw_tp, which doesn't attach to the module, but it does read
module's per-CPU variable. So I actually ran a test before posting. I
successfully unloaded bpf_testmod, but kept running the prog. And it
kept returning *correct* per-CPU value. Most probably due to per-CPU
memory not unmapped and not yet reused for something else. But it's a
really nasty and surprising situation.

Keep in mind, also, that whenever BPF program declares per-cpu
variable extern, it doesn't know or care whether it will get resolved
to built-in vmlinux per-CPU variable or module per-CPU variable.
Restricting attachment to only module-provided hooks is both tedious
and might be quite surprising sometimes, seems not worth the pain.

> If latter is what we want to allow then we probably need a test case for it and
> document the reasons for keeping modules pinned while progs access their data.
> Since such pinning behavior is different from other bpf attaching cases where
> underlying objects (like netdev and cgroup) can go away.

See above, that's already the case for module tracepoints.

So in summary, I think we should take a refcnt on module, as that's
already the case for stuff like raw_tp. I can add more comments to
make this clear, of course.
