Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBD1297947
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 00:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1757095AbgJWWXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 18:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757090AbgJWWXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 18:23:22 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2DCC0613CE;
        Fri, 23 Oct 2020 15:23:22 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id l15so2456601ybp.2;
        Fri, 23 Oct 2020 15:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=teoadB9A4wSfj5Ud7RaxveSuWTipSA4mNAPFFIKYL90=;
        b=T6OvFAIayET/EkhtDXbUtqzI6e9iIqNEhS+zXPn/yPVBAhhykWrISE0kGQmAPk55u/
         lM1CoZ79sQvdYdV8yFjLm3TTcuP5yj3SXFJ0CvLndlUmDexxO23s7sNVJW4p8yC7bi8B
         rxNBVjw6FwoFsdowjOmr2yBnuV0aOgML8WmxQUaCaK9IxEOl9h3aKzrOeeiY6PhLgt0c
         0IE4qG7YOzqk2XrRLSnuJ9NPyu3vdmk6nymSwiaG0lyx23Hul4KSlnEMelJfiVFYaK2i
         vpK7WvbdfdwHDaGXbrl/wJdiCczmw/TvcpK05WEJMBUPHhs/tfaqQ+Ms9Nv1i7yulcl5
         U/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=teoadB9A4wSfj5Ud7RaxveSuWTipSA4mNAPFFIKYL90=;
        b=YeIjkO/zfIvHlSQgaaDUA3JwbNtU3H+iOrRlN2iIGSz1UuKqfPCTRYC7eeUhGQND83
         ZYjM4nw+XWwMBVHmpXLvYoNAkkOblWTmuAAodVcOJ2B8teWJuSYeTDjRRXKFhavv/8rC
         x6uUH0q5K2iWmRlTgSP/YEOWrFr6M85OJORh1tCBasai3MHv66oVz+10MaL40F+wUNG7
         tG3PUrgHJ0t2enNt3AaKmHd6Oux8vIHBd877wVm+CG6/jJ2VYjp9BhlmQw7wCvDjAvLs
         3ITYArbbQeLTzUV8ZxGn9AFmnIAQqF4VZo9i5RHMdrVf5AyngxnujVkUSWLR4E6hg9ds
         BexA==
X-Gm-Message-State: AOAM531WVLtoeG1e4htpBnzt/wOGk56gGjsqK9KG4/ELlIw4f0oMX9Rx
        hjAnQdbXY2gbildvzBKfdFZH+ZcWclBt29lNmJg=
X-Google-Smtp-Source: ABdhPJzl3woa7gaYNBi3jy1QEUdw6w1/CF/hzDcBzOq2AcNgG1OkkhM8QeQc1VcxUDndFWZkxovgwyGhzVQQIPXWfXI=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr6922247ybe.403.1603491801621;
 Fri, 23 Oct 2020 15:23:21 -0700 (PDT)
MIME-Version: 1.0
References: <20201022082138.2322434-1-jolsa@kernel.org> <20201022082138.2322434-10-jolsa@kernel.org>
 <CAEf4Bzb_HPmGSoUX+9+LvSP2Yb95OqEQKtjpMiW1Um-rixAM8Q@mail.gmail.com> <20201023163110.54e4a202@gandalf.local.home>
In-Reply-To: <20201023163110.54e4a202@gandalf.local.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Oct 2020 15:23:10 -0700
Message-ID: <CAEf4Bza4=KKZS_OGnaLvFELE8W+Nm4sah2--CYP6wopQecxg5g@mail.gmail.com>
Subject: Re: [RFC bpf-next 09/16] bpf: Add BPF_TRAMPOLINE_BATCH_ATTACH support
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 1:31 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 23 Oct 2020 13:03:22 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > Basically, maybe ftrace subsystem could provide a set of APIs to
> > prepare a set of functions to attach to. Then BPF subsystem would just
> > do what it does today, except instead of attaching to a specific
> > kernel function, it would attach to ftrace's placeholder. I don't know
> > anything about ftrace implementation, so this might be far off. But I
> > thought that looking at this problem from a bit of a different angle
> > would benefit the discussion. Thoughts?
>
> I probably understand bpf internals as much as you understand ftrace
> internals ;-)
>

Heh :) But while we are here, what do you think about this idea of
preparing a no-op trampoline, that a bunch (thousands, potentially) of
function entries will jump to. And once all that is ready and patched
through kernel functions entry points, then allow to attach BPF
program or ftrace callback (if I get the terminology right) in a one
fast and simple operation? For users that would mean that they will
either get calls for all or none of attached kfuncs, with a simple and
reliable semantics.

Something like this, where bpf_prog attachment (which replaces nop)
happens as step 2:

+------------+  +----------+  +----------+
|  kfunc1    |  |  kfunc2  |  |  kfunc3  |
+------+-----+  +----+-----+  +----+-----+
       |             |             |
       |             |             |
       +---------------------------+
                     |
                     v
                 +---+---+           +-----------+
                 |  nop  +----------->  bpf_prog |
                 +-------+           +-----------+


> Anyway, what I'm currently working on, is a fast way to get to the
> arguments of a function. For now, I'm just focused on x86_64, and only add
> 6 argments.
>
> The main issue that Alexei had with using the ftrace trampoline, was that
> the only way to get to the arguments was to set the "REGS" flag, which
> would give a regs parameter that contained a full pt_regs. The problem with
> this approach is that it required saving *all* regs for every function
> traced. Alexei felt that this was too much overehead.
>
> Looking at Jiri's patch, I took a look at the creation of the bpf
> trampoline, and noticed that it's copying the regs on a stack (at least
> what is used, which I think could be an issue).

Right. And BPF doesn't get access to the entire pt_regs struct, so it
doesn't have to pay the prices of saving it.

But just FYI. Alexei is out till next week, so don't expect him to
reply in the next few days. But he's probably best to discuss these
nitty-gritty details with :)

>
> For tracing a function, one must store all argument registers used, and
> restore them, as that's how they are passed from caller to callee. And
> since they are stored anyway, I figure, that should also be sent to the
> function callbacks, so that they have access to them too.
>
> I'm working on a set of patches to make this a reality.
>
> -- Steve
