Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E1A227658
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 05:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgGUDAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 23:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUDAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 23:00:17 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA579C061794;
        Mon, 20 Jul 2020 20:00:17 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id i3so15101871qtq.13;
        Mon, 20 Jul 2020 20:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6I0kGriBhWaPJalIIBzwuVx6mrDtwL7sBtF3Cdy/HwM=;
        b=T6q03xwVMQYzWQD2Ozu/CipwaT36wNpk2+h+WBAUyn9edP4nuJPPwaEJILsycx1Q8Q
         MwUCtZoi90Rv1C4dxhgq04ahu5NHkQtNQfi4SkOTcuZVpADpyFGu2kufwv42uOcn8tSG
         dLDZJcxO6lVUcyfmxaC13fEbJwkCR+fqjeVkKB3z/BeLUPhSoRjV12wNTeoIyNWXFVrM
         zGVqlWsJnKnVyh7nBeflJyHcAk3NhXE61oSZ1o77ZHmekzuK5h6RECbu/OT30/JSlQ0h
         qBqevZWqbQabXZomT45tLAb78AhWYoLeoImscoPPQCAPB3Na4vRqaJB/IkWe6yz0F9Gs
         Ea/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6I0kGriBhWaPJalIIBzwuVx6mrDtwL7sBtF3Cdy/HwM=;
        b=hJRh6GB6C3qEYJsVZ8g5hLYhGonJs4Sr0PJFgpifd7li46ICQqtr73uUrMrfKojYjq
         XFqEPTv6ox5z6WOGseIgW6iBeZLwzzmkBP50XLBY+bl+QdSetdkOoqvsXYVuDcYHs6q+
         9wSbbTC5CHKSlFqLZdXziL0zOSJq4tpmVa/YcOTPZLg0AYjEKpPTkULFqeajs0JsLhRp
         5atQNw2I/eOAMhHOtUssWWZxaDlKymslN1Kl9TbsnVYtJkPnl5Dutkq7QwjQqtw7K5Bm
         +nMrHZuWLhz61GaUZVtmui0hpTa4tHnilYmzhwsvwptzElRPVlOWAICH7sPRLDPE3yxI
         9KZQ==
X-Gm-Message-State: AOAM5300rXNAUfxubM1X7sLqB7e9dXJT07E/CQYP/ow/ls3rd/yRoizj
        l9QJnxHY3xk3BZY3bP+CS95aJtLxgfprgmefchU=
X-Google-Smtp-Source: ABdhPJyDIrj/XzCbOY8O2PCNClLKYTgErQeSQ66uDoULn2e57Nhmv8tYg2xV+TZRyNYCs3pCA7L1znmTsJjYFZBfx7E=
X-Received: by 2002:aed:2cc5:: with SMTP id g63mr26508739qtd.59.1595300416734;
 Mon, 20 Jul 2020 20:00:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzYAoetyfyofTX45RQjtz3M-c9=YNeH1uRDbYgK4Ae0TwA@mail.gmail.com>
 <87d04xg2p4.fsf@toke.dk> <20200714231133.ap5qnalf6moptvfk@ast-mbp.dhcp.thefacebook.com>
 <874kq9ey2j.fsf@toke.dk> <20200715234123.rr7oj74t5hflzmsn@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbodR-+=Q3wRE2UaiouBexvqfwpE-zJGm4Rr1cV2dgZHQ@mail.gmail.com>
 <20200716054408.so34cuc2g2iqcppr@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbiD9Cuqip2=FGHGHLZs-7b8AziS-hJOpX1HuONTM4udQ@mail.gmail.com>
 <20200717030920.6kxs6kyvisuvoqnt@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZyGJGork=fDEAp+SmkzHs1+ydqVwZmYt8QeCZzf-yyvA@mail.gmail.com> <20200720223055.zoad5vw6tx4sqqpj@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200720223055.zoad5vw6tx4sqqpj@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 20 Jul 2020 20:00:05 -0700
Message-ID: <CAEf4BzYhggTC_9CJqcZnVMpWe+uAZtJtHGL3-Z4AFLDL0St1xA@mail.gmail.com>
Subject: Re: BPF logging infrastructure. Was: [PATCH bpf-next 4/6] tools: add
 new members to bpf_attr.raw_tracepoint in bpf.h
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Blake Matheny <bmatheny@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 3:31 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jul 17, 2020 at 08:54:45PM -0700, Andrii Nakryiko wrote:
> >
> > > Only libbpf can do it. Kernel is helpless here.
> > > Say we change the kernel errno for all unsuported prog types and maps
> > > it would return ENOTSUPP or something.
> > > Would it really help the situation?
> >
> > IMO, if the kernel just prints out "Unknown BPF command 123" or
> > "Unknown map type 345" that would be already a nice improvement.
> ...
> > log_buf can't help existing kernels. Period. No one is arguing or
> > expecting that. But moving forward, just having that "unknown command
> > 123" would be great.
> >
> > But yeah, of course libbpf can create a probing map and try to do
> > BATCH_LOOKUP, to detect BATCH_LOOKUP support.
>
> Also with BTF the kernel is self documented.
> The following will print all commands that kernel supports:
> bpftool btf dump file ./bld_x64/vmlinux |grep -A40 bpf_cmd
> and with 'grep BPF_MAP_TYPE_' all supported maps.
> For older kernels there is 'bpftool feature probe'.
> Since libbpf reads vmlinux BTF anyway it could have got a knowledge
> of all the features it supports based on BTF.
>

Yes.

> But let's continue this thought experiment for augmenting error
> reporting with a string.
> For 'Unknown BPF command 123' to work log_buf needs to passed
> outside of 'union bpf_attr'. Probably as 4th argument to sys_bpf ?
> and then a bit in 'int cmd' would need to be burned to indicate
> that 4th arg is there. Probably size of the arg needs to be passed
> either as 5th arg or as part of the 'struct bpf_log_buf' so it can
> be extensible.
> Using that log_buf directly in
> SYSCALL_DEFINE[45](bpf, int cmd, ... struct bpf_log_buf *log_buf)
> will be trivial.

Right, so far exactly what I proposed as #1 proposal.

> But to pass it into any of first level functions (bpf_iter_create,
> bpf_prog_attach, etc) they would need to gain an extra argument.
> To pass it all the way into hierarchy_allows_attach() it needs to be added to:
> __cgroup_bpf_attach
> cgroup_bpf_attach
> cgroup_bpf_link_attach
> link_create

I was hoping we can do it in such a way that we won't have to thread
through extra input arguments. Current task_struct looked like a good
candidate, given syscalls are always happening in a process context. I
was considering a per-CPU variable, but CPU migration precludes that.
I certainly was hoping that it could be implemented without huge code
churn.

>
> Another case of ambiguous 'return -EINVAL' would cause another change
> to a bunch of function prototypes.
> So it's better to integrate it into current task_struct to avoid huge code churn.

Right, exactly.

>
> But if we do so what stops us from generalizing log_buf reporting to
> other syscalls? perf_event_open is in the same category.

Nothing, of course, except for the need to convince other folks. I
thought starting with bpf() syscall and proving usefulness in practice
was a good first step. Then we could expand that to other syscalls.

>
> > This one is for perf subsystem, actually, it's its
> > PERF_EVENT_IOC_SET_BPF ioctl (until we add bpf_link for perf_event
> > attachment).
>
> clearly not only sys_bpf and sys_perf_event_open, but sys_ioctl would need
> string support to be a full answer to ambiguous einval-s.
>
> > My proposal was about adding the ability to emit something to log_buf
> > from any of the BPF commands, if that BPF command chooses to provide
> > extra error information. The whole point of this was to avoid adding
> > log_buf in command-specific ways (as Toke was doing in the patch that
> > I used to initiate the discussion) and do it once for entire syscall,
> > so that we can gradually utilize it where it makes most sense.
>
> I don't think that works due to code churn. Whether we pay that price
> once or 'gradually' it doesn't make it any better.

See above, here you are assuming explicit passing of log_buf through
all functions. If done through current there would be no code churn.

> When log_buf is added to an existing command the 'union bpf_attr' is there
> in the function proto and nothing new needs to passed to a lot of functions.

Not all the functions that do error checking have a bpf_attr pointer
anyway, so even in that case we could have a lot of code churn, if we
don't do it in a smarter way (i.e., current).

> So I certainly prefer Toke's approach of adding log_buf to one specific
> command if it's really needed there.
>
> The alternative is to solve it for all syscalls.

I do like the alternative, of course, but I'd start with just bpf()
syscall initially. But that's less of a technical choice, of course.

>
> > I agree that if such diagnostics are reliable and the situation itself
> > is common and experienced by multiple users, then it might make sense
> > to add such checks to libbpf.
>
> 'experienced by multiple users' is going to be a judgement call
> either for libbpf or for kernel.
> I'm saying let's improve libbpf user-friendlyness everywhere we can.
> We can always drop these hints later. Unlike kernel messages that
> might become stable api.
> One thing is log_buf that the verifier is dumping. It's huge and not parsable.
> Whereas a string next to return EINVAL may become an uapi.
> I wouldn't be surprised if some of netlink extack strings got to this
> level of stability and changing the string may cause somebody to notice
> and the commit would get reverted.
>
> > But I also don't think it's always
> > possible to diagnose something automatically with 100% confidence. We
> > can give hints, but misdiagnosing the problem can just further confuse
> > things instead.
>
> I think the possible confusion is fine.
> The libbpf has an opportunity to try them and remove if things don't work out.
> The kernel strings would be much more scrutinized and harder to change.
>

I see where you are coming from w.r.t. stability of those strings, but
I hope that's not going to be the case. Otherwise one might argue that
kernel WARN() messages could become a stable API.

But regardless, "try them and remove if things don't work out" isn't
exactly a user-friendly strategy, if that causes pain and confusion.
So I think we should still be very careful with what we add to libbpf.


> > Also quite often such problems are one-offs, which
> > doesn't make them any less confusing and frustrating, but custom
> > diagnostics for every such case has a potential of bloating libbpf
> > beyond recognition
>
> bloating libbpf with strings is imo better way to figure out how to
> improve user experience than bloating kernel.

By bloat I meant not strings, but the logic of determining the exact
cause of failure. Which from what we discussed can be quite elaborate
and non-trivial. Strings bloat are an easy thing to fix in the kernel.
We can conditionally compile them out if some Kconfig value is set.
E.g., for cases of embedded kernels where every kilobyte counts. It's
a matter of having the proper macros/funcs to do error reporting.

>
> > of them. That's what I meant that this is not a scalable approach to
> > just say "fix libbpf to be more user friendly, kernel does its best
> > already".
>
> Ok. I will take it back. The kernel can be improved with extra strings
> here and there, but only if it's done without huge code churn.
> If current task_struct approach can work and the changes would be
> limited to something like:
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index ac53102e244a..244df18728c2 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -196,8 +196,12 @@ static bool hierarchy_allows_attach(struct cgroup *cgrp,
>                         return true;
>                 cnt = prog_list_length(&p->bpf.progs[type]);
>                 WARN_ON_ONCE(cnt > 1);
> -               if (cnt == 1)
> -                       return !!(flags & BPF_F_ALLOW_OVERRIDE);
> +               if (cnt == 1) {
> +                       ret = !!(flags & BPF_F_ALLOW_OVERRIDE);
> +                       if (!ret)
> +                               syscall_string("cgroup has non-overridable program in the parent");
> +                       return ret;
> +               }
>
> Then such syscall_string reporting mechanism would be solid addition to the
> kernel. Otherwise the cost of passing explicit log_buf everywhere is not worth
> it.
>

Right, that's something like what I had in mind in terms of how
non-intrusive it has to be to get adopted.

> I think such syscall_string can probably piggy back on "socket local storage
> into generic local storage" work. Sooner or later we will have
> per task_struct storage. If that's a single pointer in task_struct that will
> be used by both task local storage from inside tracing bpf program and
> by this syscall_string() reporting mechanism then we can land it.

Not sure why the need to unify it with task-local storage? What's the
use case and what are the benefits of conflating syscall logging and
some BPF program's logging? It just adds problems, e.g., some BPF
programs might interleave its log output with syscall's output. I'm
not saying we shouldn't do it, but I don't see why we have to do it.

> May be all syscalls will become stateful. sys_bpf, sys_perf_event_open, sys_ioctl
> followed by new syscall "give me back the error string".
> Or may be we can do some asm magic and pass both errno and a string from
> a syscall at the same time.


So stateful logging (e.g., through extra syscall to set user log
buffer and unset it), which was proposal #2, definitely makes it easy
to do this across all syscalls uniformly without touching that syscall
API at all. The biggest downside, though, is runtimes like Golang,
where application doesn't control which OS thread it runs on. So
getting reliable and consistent log between syscalls becomes a
problem. Maybe there is some thread pinning API, though, and this
might not be a problem. Don't know.
