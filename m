Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110DD222C70
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgGPT7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728907AbgGPT7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 15:59:47 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420D6C061755;
        Thu, 16 Jul 2020 12:59:47 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id e12so5909882qtr.9;
        Thu, 16 Jul 2020 12:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6RBv4BQCo7j0ajjXcOIRieXiuNsweHArsDFo282gNcY=;
        b=uSc4YdPrt1kOS8sdXUr3PVUV0FAcgY6iA0jB668F7a4DBafNWOlVYOSYWDIswNFM+h
         UHbmV+0GULPoPRiW/FNjtASYiqa6/8+eDLWVCKutUZfdvl4LiGY8EK8/POzy5nHukSeK
         oVDe98iJ5sEhqobD2cC7yvYQld5IPEnx3yMX4ewMgmiY6kkYEbTwf8z84yAZwjM8+isG
         Yuq0ubqwUUn5JX4JuPyPK8vNhD6rdumyZqNy2DKlSCn3+wUrbmwUMUsX6gPCs9VnR0ZY
         MS3pt896Yf4s6U4C3L+mwohpTFP2TxPFJrqrbg8+RkuyAhAkfBKfaXTY6s5BnFnTTdyG
         ftZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6RBv4BQCo7j0ajjXcOIRieXiuNsweHArsDFo282gNcY=;
        b=n32/WFR42z0gTBlJ72Q63Nhy0o6Vdr78VqwAc6yefc872UNzVtOWzPuC1Z6WYOT+Fm
         unsWpYhCEF8Sc57vlt3RcrER710bOL0mY3ukODVxYW7SRwZ25sECSBoThVopMLe5982b
         jGQAlqgBm1U3LelgBFEENG+H4EX96vv7nvGEfbh1F+S/JSUHAP0ftpB1pjv/tMEKeJgG
         Z8kjl0oU+V31Lfu8gUuqUBtXwyfWWzzONXmSwkVKEGTIuPVDBdwVGMWoYCW+z5cw/eeT
         YF7Fp9A/K8sfe34+pn+vzEvQoKJ95B4IJtr2g6n96c7TzzrKi+BFDVuL9TDzKxlWFdCO
         MHgw==
X-Gm-Message-State: AOAM530SLel4TQ0X/RW19PHt37M1UgY8CnEfU4HgZjLW7YIsZWv2xpAj
        4TGXq1UiYiRYu84JqQS552QsVOAV58FK6FkTJtY=
X-Google-Smtp-Source: ABdhPJyJI1ji+TaJ7iprbAOJQJC6Lk+amlOv2rtE1wH5U2EmYU5DapJOeBMBssXK+GFPJnf95H+MqkdLhZ/x8mu8tYI=
X-Received: by 2002:ac8:18d4:: with SMTP id o20mr6921484qtk.141.1594929586224;
 Thu, 16 Jul 2020 12:59:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzZ_-vXP_3hSEjuceW10VX_H+EeuXMiV=_meBPZn7izK8A@mail.gmail.com>
 <87r1tegusj.fsf@toke.dk> <CAEf4Bzbu1wnwWFOWYA3e6KFeSmfg8oANPWD9LsUMRy2E_zrQ0w@mail.gmail.com>
 <87pn8xg6x7.fsf@toke.dk> <CAEf4BzYAoetyfyofTX45RQjtz3M-c9=YNeH1uRDbYgK4Ae0TwA@mail.gmail.com>
 <87d04xg2p4.fsf@toke.dk> <20200714231133.ap5qnalf6moptvfk@ast-mbp.dhcp.thefacebook.com>
 <874kq9ey2j.fsf@toke.dk> <20200715234123.rr7oj74t5hflzmsn@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbodR-+=Q3wRE2UaiouBexvqfwpE-zJGm4Rr1cV2dgZHQ@mail.gmail.com> <20200716054408.so34cuc2g2iqcppr@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200716054408.so34cuc2g2iqcppr@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jul 2020 12:59:30 -0700
Message-ID: <CAEf4BzbiD9Cuqip2=FGHGHLZs-7b8AziS-hJOpX1HuONTM4udQ@mail.gmail.com>
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

On Wed, Jul 15, 2020 at 10:44 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jul 15, 2020 at 06:11:39PM -0700, Andrii Nakryiko wrote:
> > >
> > > On Wed, Jul 15, 2020, Andrii Nakryiko wrote:
> > > >
> > > > Inability to figure out what's wrong when using BPF is at the top of
> > > > complaints from many users, together with hard to understand logs from
> > > > verifier.
> > >
> > > Only the second part is true. All users are complaining about the verifier.
> > > No one is complaing that failed prog attach is somehow lacking string message.
> >
> > Ok, next time I'll be helping someone to figure out another -EINVAL,
> > I'll remember to reassure them that it's not really frustrating, not a
> > guess game, and not a time sink at all.
>
> When the next time the users hit EINVAL due to _their_ usage and not
> due to kernel or libbpf bug and libbpf couldn't do anything to make
> the error user friendly then yes please raise it up.

I know this is futile to convince you anyways, so I won't go dig all
the details, but here are few general examples. With the benefit of
hindsight in a lot of those cases libbpf can do extra checks and
guessing (though bad guess is worse than no guess), but that doesn't
scale because of the sheer amount of possible situations.

What I personally went through when I was building runqslower:

1. You write a simple BPF program, open + load. You run it, you get EPERM.
2. You go check if you ran the program with sudo, retry with sudo.
3. You still get EPERM. You bang your head against the wall for 30
minutes, you recall about RLIMIT_MEMLOCK, you bump it up.
4. If you are happy, now everything works. I don't remember now if I
had to bang my head some more until I got the initial minimal version
of runqslower successfully load BPF program.


Some popular other issues I can recall.

1. People get excited and try to use fentry/fexit, get -EINVAL. Most
probably it's because they don't have a recent enough kernel.
Otherwise (if they know libbpf behavior), they'd probably have gotten
something about not being able to find the desired BTF func in the
kernel. Even in that case, is that that they don't have BTF at all
(CONFIG_DEBUG_BTF_INFO=y)? Or it's just an old one with no FUNCs
because pahole isn't recent enough? Kernel build won't mention that
you need 1.16 for fentry/fexit, of course. And so on. This is actually
not the worst case, because I can walk them through this process.

2. When dealing with cgroups. You get EINVAL for every tiny misstep.
You want to replace the BPF program, you get EINVAL. Maybe you forgot
one of the necessary flags? Or maybe you specified incompatible flags
(BPF_F_REPLACE | BPF_F_ALLOW_MULTI)? Or the parent cgroup has a
non-overridable BPF program attached already? Or maybe prog FD is
wrong, or cgroup FD is wrong, or?...

3. Someone gets excited about libbpf-tools in BCC, decides to convert
a tool. Needs to dump the hashmap fast. There is BATCH_LOOKUP, nice!
They try, they get EINVAL. Most probably outdated kernel, but I'll
need to dig into kernel sources to see what else could go wrong.

4. Try using some of the low-level APIs from libbpf/bpf.h, like the
same cgroup program replacement. You'll get E2BIG and will scratch
your head for a while, checking how the list of attached BPF programs
can be too big, if it's the only one. Just to realize that again, your
kernel is just a touch too old and just complains about non-zero
unknown field in bpf_attr.

5. Just few days ago, one user was doing bpf_program__attach_tracepoint():

libbpf: program 'tp/sched/sched_process_exit': failed to attach to pfd
10: File exists

After a bit of back and forth turns out he had a second instance of
that program running in parallel. Good, I quickly realize that it's an
old kernel and it doesn't allow me to attach more than 1 BPF program
to the tracepoint. Case solved. But what about many other BPF users
that do not have access to someone developing BPF in the kernel?

And the list goes on. Even if it was my full-time job just to
anticipate all the misuses and try to check/guess them in libbpf, that
wouldn't work and won't scale.

And all I was asking (and not finger pointing or blaming anything or
anyone) to have a mechanism in the kernel to get a single-line
human-readable hint as to which one out of many
EINVAL/E2BIG/ENOENT/EPERM conditions was hit. No need to immediately
convert all of them, we could have gradually added that, prioritizing
common and most probable ones to hit. But alas, it's easier to blame
me for not perfecting libbpf and anticipating all that beforehand.


>
> > > The users are also complaing about libbpf being too verbose.
> >
> > Very well might be, but apart from your complaints on that patch
> > adding program loading debug message, I can't remember a single case
> > when someone complained about that. Do you have a link for me to get
> > some context?
> >
> > > Yet you've refused to address the verbosity where it should be reduced and
> >
> > It's open-source, everyone is welcome to submit their patches. Just
> > because I don't think we need to remove some log messages and thus not
> > am creating such patches, doesn't mean it can't be done by someone
> > else.
>
> So myself and Toke are wearing 'bpf user' hat in that context.
> Both of us indicated that libbpf output is too verbose.
> Your response "just send a patch" is a sure way to turn away more users.
>

I can't find any such complaint from Toke in this thread, and can't
really recall something like that from recent discussions. I'd rather
have him speak for himself.

But neither you nor Toke are "just bpf users", you are totally capable
of creating a patch addressing something that bugs you.

Upstream BPF users have never complained to me about the verbosity of
logs. Furthermore, they rarely (if ever) see those **debug** logs,
until I actually ask them to turn it on to help me help them. Yes,
debug-level libbpf logs are driven more towards me and other people
(like Toke) who know internals and are helping users with issues. I
actually try to help BPF users, not ask them for patches to libbpf,
and you can find many patches from me where I was
improving/fixing/adding to kernel and libbpf as a response to both
upstream and internal BPF users. I am far from asking for recognition
of that, but please don't make false accusations either.

> > > now refusing to add it where it's needed.
> >
> > Can you point to or quote where I refused to add a helpful message to libbpf?
>
> see below for detailed example.
>
> >
> > > It's libbpf job to explain users kernel errors.
> >
> > To the best of its ability, yes. Unfortunately there were many times
> > where I, as a human, couldn't figure it out without printk'ing my way
> > around the kernel. If I can't do that, I can't teach libbpf to do it.
> > Error codes are just not granular enough to allow distinguishing a lot
> > of error conditions, either by humans or automatically by libbpf.
>
> If there are such cases please bring it up. I'm sure kernel errnos
> can become more unique.

See above for a few typical examples. I don't keep track of all the
issues I had to debug myself or help others with.

>
> > >
> > > The same thing is happening with perf_event_open syscall.
> > > Every one who's trying to code it directly complaining about the kernel. But
> > > not a single user is complaing about perf syscall when they use libraries and
> > > tools. Same thing with bpf syscall. libbpf is the interface. It needs to clear
> > > and to the point. Right now it's not doing it well. elf dump is too verbose and
> > > unnecessary whereas in other places it says nothing informative where it
> > > could have printed human hint.
> > >
> > > libbpf's pr_perm_msg() hint is the only one where libbpf cares about its users.
> > > All other messages are useful to libbpf developers and not its users.
> >
> > "Couldn't load trivial BPF program. Make sure your kernel supports BPF
> > (CONFIG_BPF_SYSCALL=y) and/or that RLIMIT_MEMLOCK is set to big enough
> > value."
> > "kernel doesn't support global data"
> > "can't attach BPF program w/o FD (did you load it?)"
> > "specified path %s is not on BPF FS"
> > "vmlinux BTF is not found" -- we should clearly add "you need a kernel
> > built with CONFIG_DEBUG_INFO_BTF=y"
> > "invalid relo for \'%s\' in special section 0x%x; forgot to initialize
> > global var?.."
>
> sure. those count too.

great, thanks for acknowledging

>
> > That doesn't mean, though, that the kernel itself can't do better in
> > terms of error reporting. But you clearly don't think it's a real
> > problem, so I'll let it rest, thank you.
>
> It is a real problem and libbpf has to step up to address it.
> The kernel does everything it can already.
>
> Let's take this raw_tp_open patches as an example.
> Currently raw_tp_open will EINVAL if prog_fd is incorrect, tp name
> is not specified or expected_attach_type doesn't match.
> If that happens it's a _libbpf_ bug. It's not a user mistake.
> With Toke's patches tgt prog_fd and btf_id are added.
> Both can be incorrect. If that happens it's most likely libbpf bug.
> The user is writing their bpf_prog.c file with SEC("freplace/name")
> libbpf could have messed up prog_fd and btf_id resolution.
> The user didn't specify btf_id as a raw integer.
> It was a libbpf job to convert user's string name into prog_fd
> and btf_id in the first place. If libbpf messes it it shouldn't rely
> on the kernel to catch such bugs. It's not a job of the kernel to
> point out bugs in the libraries that suppose to be tightly
> coupled with the kernel.
> When libbpf is doing its job correctly tgt_prog_fd and tgt_btf_id are
> valid and BTF of the extension prog can miscompare with BTF of
> target prog it's trying to attach to via raw_tp_open with these two
> arguments. Take a look at Toke's patches. That comparison is done via
> btf_check_type_match(). The most helpful kernel message in such case
> will be 'arg2 in foo() has size 4 while bar() has 2'.
> That's the best the kernel can do. Yet it's very user unfriendly.
> The kernel has no infra today to print BTF in a human friendly way.
> But libbpf has BTF dumper. btf_dump__emit_type_decl() alone is
> magnitude friendlier to users than kernel messages.
> When the kernel's raw_tp_open syscall realizes that BTFs don't match
> it can return single unique errno and libbpf can tell the user:
> "
> Function prototype of BPF prog:
>    int ext_bpf_prog(struct __sk_buff *);
> doesn't match function prototype of target prog:
>    int tgt_prog_name(struct xdp_md *);
> "
> Everything is available in libbpf to print such error in human friendly way.
> Whereas the kernel has no ability to do so.
> If that message was coming from the kernel it would have been from
> btf_check_type_match() and would be:
> "arg1 in ext_bpf_prog() is not a pointer to context".
> Compare that to above libbpf error message.
> I think the difference is pretty drastic.
> libbpf by far is a better place to print human friendly errors.
>
> I'm arguing that raw_tp_open with additional tgt_prog_fd and tgt_btf_id
> parameters is not much different from sys_kcmp syscall and from memcmp() libc
> function. They compare two objects and return equal or not.
> It's not a job of the kernel to say
> 'objects are not equal because byte 2 is different'.
> Such message is not helpeful to users.
> It's libbpf job to print two BTFs in human friendly way when the kernel
> found them different. It's easier for human to glance over two function
> prototypes and spot the difference instead of 'arg1 is not a pointer to context'.

Ok, so I assume that is an example where I refused to add helpful
error reporting to libbpf?

First, thanks for taking the time to elaborate on this. I'm sure Toke
will appreciate it, though I have nothing to do with arguing for or
against this. It was Toke's scepticism, not mine, that you are
addressing. I never said we shouldn't do this.

I do agree that in some cases libbpf has the same or more information
and it's easier to pretty-print extra context, like in this case,
which we should take advantage of.

I started this topic to discuss extending bpf() syscall in general,
regardless of this particular change and feature.

>
> So please make libbpf user friendly. Enough of pointing fingers at the kernel.

It's an honor you are associating me personally and libbpf, but I
still hope we can move this forward as a community and collective
project. Of course let's make libbpf more user-friendly where possible
and feasible, but I don't think arguing about debug-level logging in
libbpf is the right place to start.

I don't know where "finger pointing" comes from, I had no intent nor I
said anything to offend either the kernel or you personally. Proposing
changes up for discussion shouldn't be considered a form of attacking
or finger pointing, I hope.
