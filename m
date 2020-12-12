Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B7D2D83E2
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 02:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgLLBx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 20:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728615AbgLLBxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 20:53:00 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115C8C0613CF;
        Fri, 11 Dec 2020 17:52:20 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id t18so5551791plo.0;
        Fri, 11 Dec 2020 17:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qv3DidBYtPDwQNr5XUslmszgwOaWsKjFqi+1HuzsbAA=;
        b=hJsgl3jePWT/MSbzk7nnQK3GSgoOtQGRs9t/Y1bzEpekrtSnN2dXgeLO+N0ayb/sVN
         zRxOXisXIatkMST0B1QOBKfFfaGAbWXz/cwwD9azjDnhYWOkbV0C47jRbPQRXR4y72zO
         Qk0SzS5ZdZs10JQFXt+mR0uOqJkayeSXY+93nacKYQPWo3Ox6UZwJFetg58Bl9+B6UKa
         AF1HFuEfl8yB3wiVsaGMEmZjBj3rZDof+LoCs5CTX5U/rPDKXVStQNh3jdACW5yu/Uuf
         of6bgaIrEKxTYxfwIyDZL1+7qmW82D3ObWQ7EfAhqufHzsv8n3aL2q5ZjFku/Ajr0U2r
         Koxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qv3DidBYtPDwQNr5XUslmszgwOaWsKjFqi+1HuzsbAA=;
        b=QCCEDUbbfd3LyXjHgEX3rFzsgdoVspNpOUze1+Jnl75fW/4BVf/rk4H8iYCKHiefPw
         or4CpIHVTnNbF0SNouV5uP5W5BwUQSu1S4GaLy/shPS89lYXyoUnUVYzGUFDDMDmBmsZ
         kntHltnwp+jUShk6NHJK14ZaRzwJpDfEem+xpr+jT0xcGT4MFIJQFTTbiGe1hZQwqT08
         QAHwXCCiutrbFoMrXbJYyG9tHqbStcnG22PvXmqk5uVVhExb1ni5WHAV9sOEH8ZsXVAn
         4RbZAcs7AOeQymbuS/R/UUjhzKEDGxUcEkkzklefWNdG2LmPRU03a7x3WT6VF8LbVpDY
         C4Lg==
X-Gm-Message-State: AOAM532dMnEVXrfLH3WnOgiic4reBvsFyoVSFj3ctBOJB3v1wcF+28dG
        hcw2jOOsS/MaXXedcYaOonM=
X-Google-Smtp-Source: ABdhPJy9ZBQeTkfO8a3SazZkLNf5teIWbrtU15/RCLVzC0XZdffUe/p8mtFcmObrlinX6adGy4mwlg==
X-Received: by 2002:a17:90a:cc06:: with SMTP id b6mr15508282pju.94.1607737939395;
        Fri, 11 Dec 2020 17:52:19 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:70e5])
        by smtp.gmail.com with ESMTPSA id x22sm12273909pfc.19.2020.12.11.17.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 17:52:18 -0800 (PST)
Date:   Fri, 11 Dec 2020 17:52:15 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH RFC bpf-next 2/4] bpf: support BPF ksym variables in
 kernel modules
Message-ID: <20201212015215.zmychededhpv55th@ast-mbp>
References: <20201211042734.730147-1-andrii@kernel.org>
 <20201211042734.730147-3-andrii@kernel.org>
 <20201211212741.o2peyh3ybnkxsu5a@ast-mbp>
 <CAEf4BzbZK8uZOprwHq_+mh=2Lb27POv5VMW4kB6eyPc_6bcSPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbZK8uZOprwHq_+mh=2Lb27POv5VMW4kB6eyPc_6bcSPg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 02:15:28PM -0800, Andrii Nakryiko wrote:
> On Fri, Dec 11, 2020 at 1:27 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Dec 10, 2020 at 08:27:32PM -0800, Andrii Nakryiko wrote:
> > > During BPF program load time, verifier will resolve FD to BTF object and will
> > > take reference on BTF object itself and, for module BTFs, corresponding module
> > > as well, to make sure it won't be unloaded from under running BPF program. The
> > > mechanism used is similar to how bpf_prog keeps track of used bpf_maps.
> > ...
> > > +
> > > +     /* if we reference variables from kernel module, bump its refcount */
> > > +     if (btf_is_module(btf)) {
> > > +             btf_mod->module = btf_try_get_module(btf);
> >
> > Is it necessary to refcnt the module? Correct me if I'm wrong, but
> > for module's BTF we register a notifier. Then the module can be rmmod-ed
> > at any time and we will do btf_put() for corresponding BTF, but that BTF may
> > stay around because bpftool or something is looking at it.
> 
> Correct, BTF object itself doesn't take a refcnt on module.
> 
> > Similarly when prog is attached to raw_tp in a module we currently do try_module_get(),
> > but is it really necessary ? When bpf is attached to a netdev the netdev can
> > be removed and the link will be dangling. May be it makes sense to do the same
> > with modules?  The raw_tp can become dangling after rmmod and the prog won't be
> 
> So for raw_tp it's not the case today. I tested, I attached raw_tp,
> kept triggering it in a loop, and tried to rmmod bpf_testmod. It
> failed, because raw tracepoint takes refcnt on module. rmmod -f

Right. I meant that we can change that behavior if it would make sense to do so.

> bpf_testmod also didn't work, but it's because my kernel wasn't built
> with force-unload enabled for modules. But force-unload is an entirely
> different matter and it's inherently dangerous to do, it can crash and
> corrupt anything in the kernel.
> 
> > executed anymore. So hard coded address of a per-cpu var in a ksym will
> > be pointing to freed mod memory after rmmod, but that's ok, since that prog will
> > never execute.
> 
> Not so fast :) Indeed, if somehow module gets unloaded while we keep
> BPF program loaded, we'll point to unallocated memory **OR** to a
> memory re-used for something else. That's bad. Nothing will crash even
> if it's unmapped memory (due to bpf_probe_read semantics), but we will
> potentially be reading some garbage (not zeroes), if some other module
> re-uses that per-CPU memory.
> 
> As for the BPF program won't be triggered. That's not true in general,
> as you mention yourself below.
> 
> > On the other side if we envision a bpf prog attaching to a vmlinux function
> > and accessing per-cpu or normal ksym in some module it would need to inc refcnt
> > of that module, since we won't be able to guarantee that this prog will
> > not execute any more. So we cannot allow dangling memory addresses.
> 
> That's what my new selftest is doing actually. It's a generic
> sys_enter raw_tp, which doesn't attach to the module, but it does read
> module's per-CPU variable. 

Got it. I see that now.

> So I actually ran a test before posting. I
> successfully unloaded bpf_testmod, but kept running the prog. And it
> kept returning *correct* per-CPU value. Most probably due to per-CPU
> memory not unmapped and not yet reused for something else. But it's a
> really nasty and surprising situation.

you mean you managed to unload early during development before
you've introduced refcnting of modules?

> Keep in mind, also, that whenever BPF program declares per-cpu
> variable extern, it doesn't know or care whether it will get resolved
> to built-in vmlinux per-CPU variable or module per-CPU variable.
> Restricting attachment to only module-provided hooks is both tedious
> and might be quite surprising sometimes, seems not worth the pain.
> 
> > If latter is what we want to allow then we probably need a test case for it and
> > document the reasons for keeping modules pinned while progs access their data.
> > Since such pinning behavior is different from other bpf attaching cases where
> > underlying objects (like netdev and cgroup) can go away.
> 
> See above, that's already the case for module tracepoints.
> 
> So in summary, I think we should take a refcnt on module, as that's
> already the case for stuff like raw_tp. I can add more comments to
> make this clear, of course.

ok. agreed.

Regarding fd+id in upper/lower 32-bit of ld_imm64...
That works for ksyms because at that end the pair is converted to single
address that fits into ld_imm64. That won't work for Alan's case
where btf_obj pointer and btf_id are two values (64-bit and 32-bit).
So api-wise it's fine here, but cannot adopt the same idea everywhere.

re: patch 4
Please add non-percpu var to the test. Just for completeness.
The pair fd+id should be enough to disambiguate, right?

re: patch 1.
Instead of copy paste that hack please convert it to sys_membarrier(MEMBARRIER_CMD_GLOBAL).

The rest looks good to me.
