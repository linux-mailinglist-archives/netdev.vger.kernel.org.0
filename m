Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F4F29780A
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 22:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755290AbgJWUDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 16:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755282AbgJWUDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 16:03:36 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAFBC0613CE;
        Fri, 23 Oct 2020 13:03:34 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id d15so2165921ybl.10;
        Fri, 23 Oct 2020 13:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mZMLYvg9F1kA8EipanfdPEqGzP+y+I3fiu8XTpKKgdE=;
        b=QOXNStIMaB9GXtzVwQ37Hbcr+tAdc4ZxYnpidXkHxA41ypUHS23UsrC/j/DGfIGqyD
         /aYJ+FfrNXm3ibUQtHBVMdE3dJ3kTcvNbVgACUwW3yK+VlSKLFSsHT4q185EsG3XUw0E
         xpTs/GsXYLAmjrveERhdHI2+WEtJq0TO6t2gvSUr/bjdL0LDtxMlWDXHAzOTbqnF5Vpu
         w24Ze4VsshUX8qB9LU0ou3rJio/nnWma5OcrROsooC89lj5Jug2CNjaq9+0vhs2R82Zh
         ASZftpi/VqA3nxwRnNOYZGkbC9g723PlY6Ru3iv+QlRCLHt0y5/AI3PNrR+Ct2lgO4Z9
         1v5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mZMLYvg9F1kA8EipanfdPEqGzP+y+I3fiu8XTpKKgdE=;
        b=cTk/DDNGSfsOw9PJabvXrNV4oxWMegbWeYqapXB2HoITkbEPS4k1/K3aic3B18rys5
         aeKKkvfOK+qKjurvXLelZ1YjYHIPB+qjv08bOlK/WUkW+2H8h1L8sa1H6R4UD5Mx2fg6
         9N94jLIePtFVw59k0BQgZn68c0UFLApCFZHDOkCDpNelAui+X/4MmNvqNxpb9ID9uqrh
         4Y7FtVMaiMbcs7G6dz19+2lDvTB/KwNK6vmqwybJz7OHWayol/+Cycr76FnLPsj3MXja
         TC6RcD11gAvdQjbcXKRR4ciFDx0p8v87lhqos9Ime1NCUbH312BOFp4QZAruuvWWpY+h
         RzMA==
X-Gm-Message-State: AOAM532uh4Rw0yb/BRRA4HBOkrNAVldtnZUXzekvpWTLCXGqhDnjepFU
        L/2l+pqCIxQv9XRYfMA5k/oNWbv7MBtFPbd0Ihg=
X-Google-Smtp-Source: ABdhPJwhKtokx5ScT41RnoaZpbdTI2gJwWhVwhC3teiUlXTWYo8+14omDhJS3D37/9VrOqPVHC0aF52fipGxWeQes+I=
X-Received: by 2002:a25:cb10:: with SMTP id b16mr5904989ybg.459.1603483413548;
 Fri, 23 Oct 2020 13:03:33 -0700 (PDT)
MIME-Version: 1.0
References: <20201022082138.2322434-1-jolsa@kernel.org> <20201022082138.2322434-10-jolsa@kernel.org>
In-Reply-To: <20201022082138.2322434-10-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Oct 2020 13:03:22 -0700
Message-ID: <CAEf4Bzb_HPmGSoUX+9+LvSP2Yb95OqEQKtjpMiW1Um-rixAM8Q@mail.gmail.com>
Subject: Re: [RFC bpf-next 09/16] bpf: Add BPF_TRAMPOLINE_BATCH_ATTACH support
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 8:01 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding BPF_TRAMPOLINE_BATCH_ATTACH support, that allows to attach
> tracing multiple fentry/fexit pograms to trampolines within one
> syscall.
>
> Currently each tracing program is attached in seprate bpf syscall
> and more importantly by separate register_ftrace_direct call, which
> registers trampoline in ftrace subsystem. We can save some cycles
> by simple using its batch variant register_ftrace_direct_ips.
>
> Before:
>
>  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s*
>     { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
>
>      2,199,433,771      cycles:k               ( +-  0.55% )
>        936,105,469      cycles:u               ( +-  0.37% )
>
>              26.48 +- 3.57 seconds time elapsed  ( +- 13.49% )
>
> After:
>
>  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s*
>     { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
>
>      1,456,854,867      cycles:k               ( +-  0.57% )
>        937,737,431      cycles:u               ( +-  0.13% )
>
>              12.44 +- 2.98 seconds time elapsed  ( +- 23.95% )
>
> The new BPF_TRAMPOLINE_BATCH_ATTACH syscall command expects
> following data in union bpf_attr:
>
>   struct {
>           __aligned_u64   in;
>           __aligned_u64   out;
>           __u32           count;
>   } trampoline_batch;
>
>   in    - pointer to user space array with file descrptors of loaded bpf
>           programs to attach
>   out   - pointer to user space array for resulting link descriptor
>   count - number of 'in/out' file descriptors
>
> Basically the new code gets programs from 'in' file descriptors and
> attaches them the same way the current code does, apart from the last
> step that registers probe ip with trampoline. This is done at the end
> with new register_ftrace_direct_ips function.
>
> The resulting link descriptors are written in 'out' array and match
> 'in' array file descriptors order.
>

I think this is a pretty hard API to use correctly from user-space.
Think about all those partially attached and/or partially detached BPF
programs. And subsequent clean up for them. Also there is nothing even
close to atomicity, so you might get a spurious invocation a few times
before batch-attach fails mid-way and the kernel (hopefully) will
detach those already attached programs in an attempt to clean
everything up. Debugging and handling that is a big pain for users,
IMO.

Here's a raw idea, let's think if it would be possible to implement
something like this. It seems like what you need is to create a set of
logically-grouped placeholders for multiple functions you are about to
attach to. Until the BPF program is attached, those placeholders are
just no-ops (e.g., they might jump to an "inactive" single trampoline,
which just immediately returns). Then you attach the BPF program
atomically into a single place, and all those no-op jumps to a
trampoline start to call the BPF program at the same time. It's not
strictly atomic, but is much closer in time with each other. Also,
because it's still a single trampoline, you get a nice mapping to a
single bpf_link, so detaching is not an issue.

Basically, maybe ftrace subsystem could provide a set of APIs to
prepare a set of functions to attach to. Then BPF subsystem would just
do what it does today, except instead of attaching to a specific
kernel function, it would attach to ftrace's placeholder. I don't know
anything about ftrace implementation, so this might be far off. But I
thought that looking at this problem from a bit of a different angle
would benefit the discussion. Thoughts?


> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h      | 15 ++++++-
>  include/uapi/linux/bpf.h |  7 ++++
>  kernel/bpf/syscall.c     | 88 ++++++++++++++++++++++++++++++++++++++--
>  kernel/bpf/trampoline.c  | 69 +++++++++++++++++++++++++++----
>  4 files changed, 164 insertions(+), 15 deletions(-)
>

[...]
