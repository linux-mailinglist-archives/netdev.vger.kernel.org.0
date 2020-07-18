Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AA9224860
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 05:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgGRDy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 23:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbgGRDy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 23:54:58 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AF5C0619D2;
        Fri, 17 Jul 2020 20:54:58 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id w34so9247932qte.1;
        Fri, 17 Jul 2020 20:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nUYZqgN60e61lWs8+/CbKMuYFAKYxWsBo2re3pyVmgM=;
        b=E/eK0xXjRh5CUEg74It/wKYFSRi85iw6FOyXm7Bpoi09Y/ptqeXBE1b18nPc9AhrlN
         gw+QmSL+i0gNdiPJmZcTEL5BInF4MeAOXdfnFXe3/T6fmiBUkfDFd96nIl1rWJ+c/RA/
         WCqm5eTQaVQghaTadLaG+2MsZh+xWBoMHHuKCwkIH3PzuoiEL6nrNqb6+hyRLRN9+941
         C5jXJclvdDmb9VNKxjXvaTAjophmIPd0cVGRDNrCOnTqWYYrMvafC8W/uyvJYfD17sxF
         hhm6sxWn5W5V/Uc0RBchh7lc0QQl0odNbY652oe7AVo0s0FLkCJZG8EOnhEo3q/r+57k
         WxMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nUYZqgN60e61lWs8+/CbKMuYFAKYxWsBo2re3pyVmgM=;
        b=h0WPJjcT17OtCDdoq5mp749rMXWJrvrdABnKCrgd92wM8xRVC8YbC7+1lf/FFQ/uTP
         5ZmWBcsWv3EsZOmy4daOyC5YaC6oI/3F/+h/2OzfjLad8lwjUOhQK9LVYYuZQUOLku+v
         UBiEujd0PbF3POrLVA3DaxGRN1MG6bNjLPmB2aBkcOI8PtggR9hyYZPa6MIslbbWA0Es
         o25JBpmDz/c84/KT7qqLwwAu0woYGQEDN4VC0ebiZw9RPQp+mgTl1dmWGSdKRj/YFZDv
         lAqA98chSU1OV7yyZ1CC9xZKDehNBY+TJ1+PJvaGDPt9aZofpzLZ09L4tD7O70qzQYtg
         T3uA==
X-Gm-Message-State: AOAM531fRwmO0vpAD6upKUYUwQaIeg1x70BJNFp4K8geIAoY17o+pUdC
        aNFUikVkOvWpoYRqMj91VttbWrpRuu50ticien0=
X-Google-Smtp-Source: ABdhPJxIMXvAJTdKPq3YIIz5qUskYmVaU6Sn3XJ9V+y974tgXZWsI7YIsXsEuGnAKloLdh3PoIsg1LEBzx6ALWkhC48=
X-Received: by 2002:aed:2cc5:: with SMTP id g63mr13518636qtd.59.1595044497102;
 Fri, 17 Jul 2020 20:54:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4Bzbu1wnwWFOWYA3e6KFeSmfg8oANPWD9LsUMRy2E_zrQ0w@mail.gmail.com>
 <87pn8xg6x7.fsf@toke.dk> <CAEf4BzYAoetyfyofTX45RQjtz3M-c9=YNeH1uRDbYgK4Ae0TwA@mail.gmail.com>
 <87d04xg2p4.fsf@toke.dk> <20200714231133.ap5qnalf6moptvfk@ast-mbp.dhcp.thefacebook.com>
 <874kq9ey2j.fsf@toke.dk> <20200715234123.rr7oj74t5hflzmsn@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbodR-+=Q3wRE2UaiouBexvqfwpE-zJGm4Rr1cV2dgZHQ@mail.gmail.com>
 <20200716054408.so34cuc2g2iqcppr@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbiD9Cuqip2=FGHGHLZs-7b8AziS-hJOpX1HuONTM4udQ@mail.gmail.com> <20200717030920.6kxs6kyvisuvoqnt@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200717030920.6kxs6kyvisuvoqnt@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Jul 2020 20:54:45 -0700
Message-ID: <CAEf4BzZyGJGork=fDEAp+SmkzHs1+ydqVwZmYt8QeCZzf-yyvA@mail.gmail.com>
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

On Thu, Jul 16, 2020 at 8:09 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jul 16, 2020 at 12:59:30PM -0700, Andrii Nakryiko wrote:
> > On Wed, Jul 15, 2020 at 10:44 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Jul 15, 2020 at 06:11:39PM -0700, Andrii Nakryiko wrote:
> > > > >
> > > > > On Wed, Jul 15, 2020, Andrii Nakryiko wrote:
> > > > > >
> > > > > > Inability to figure out what's wrong when using BPF is at the top of
> > > > > > complaints from many users, together with hard to understand logs from
> > > > > > verifier.
> > > > >
> > > > > Only the second part is true. All users are complaining about the verifier.
> > > > > No one is complaing that failed prog attach is somehow lacking string message.
> > > >
> > > > Ok, next time I'll be helping someone to figure out another -EINVAL,
> > > > I'll remember to reassure them that it's not really frustrating, not a
> > > > guess game, and not a time sink at all.
> > >
> > > When the next time the users hit EINVAL due to _their_ usage and not
> > > due to kernel or libbpf bug and libbpf couldn't do anything to make
> > > the error user friendly then yes please raise it up.
> >
> > I know this is futile to convince you anyways, so I won't go dig all
> > the details, but here are few general examples. With the benefit of
> > hindsight in a lot of those cases libbpf can do extra checks and
> > guessing (though bad guess is worse than no guess), but that doesn't
> > scale because of the sheer amount of possible situations.
> >
> > What I personally went through when I was building runqslower:
> >
> > 1. You write a simple BPF program, open + load. You run it, you get EPERM.
> > 2. You go check if you ran the program with sudo, retry with sudo.
> > 3. You still get EPERM. You bang your head against the wall for 30
> > minutes, you recall about RLIMIT_MEMLOCK, you bump it up.
> > 4. If you are happy, now everything works. I don't remember now if I
> > had to bang my head some more until I got the initial minimal version
> > of runqslower successfully load BPF program.
>
> But we have libbpf hinting on that already?
> Are you saying that hint wasn't working somehow?

At that time the message was just "failed to load primitive BPF
program", we added mentions of CONFIG_BPF_SYSCALL and RLIMIT_MEMLOCK
much later. And even current message might be misleading, because it
might be that you are not a root (or, in more modern kernels, don't
have CAP_BPF). Maybe not, if we are relying on unprivileged BPF for
primitive prog, I don't know.

>
> >
> > Some popular other issues I can recall.
> >
> > 1. People get excited and try to use fentry/fexit, get -EINVAL. Most
> > probably it's because they don't have a recent enough kernel.
> > Otherwise (if they know libbpf behavior), they'd probably have gotten
> > something about not being able to find the desired BTF func in the
> > kernel. Even in that case, is that that they don't have BTF at all
> > (CONFIG_DEBUG_BTF_INFO=y)? Or it's just an old one with no FUNCs
> > because pahole isn't recent enough? Kernel build won't mention that
> > you need 1.16 for fentry/fexit, of course. And so on. This is actually
> > not the worst case, because I can walk them through this process.
>
> Exactly. Either old kernel or missing config in the kernel.
> libbpf is above that. It could have provided a hint.
> When libbpf is processing SEC("fentry/") and it fails to load with
> empty verifier log it could start probing.

As I said, listing these examples I didn't expect to convince you,
because I knew you'd propose one or another way how libbpf can provide
more "diagnostics". In a lot of cases it can. But usually after the
fact (debugging it in a painful way). I don't believe we can
anticipate all cases, though, and even those that we can, I'm not sure
how scalable it is to do all that. Requiring anyone adding any new API
to provide a comprehensive set of probing/checks/diagnostics to
prevent possible error conditions seems to be way too harsh on
contributors.

Unfortunately, details escape me now for the case I had in mind, where
I had absolutely no clue which of many checks are failing, even after
reading kernel source code very carefully. Too bad, but I don't keep
such detailed notes.

> Only libbpf can do it. Kernel is helpless here.
> Say we change the kernel errno for all unsuported prog types and maps
> it would return ENOTSUPP or something.
> Would it really help the situation?

IMO, if the kernel just prints out "Unknown BPF command 123" or
"Unknown map type 345" that would be already a nice improvement.


> Probably not. There will be old kernels and the same usability
> issue as you described.

Of course old kernels will still have those problems, but it never
stopped us from fixing and improving the kernel moving forward so that
eventually a better version is available (almost) everywhere.

>
> > 2. When dealing with cgroups. You get EINVAL for every tiny misstep.
> > You want to replace the BPF program, you get EINVAL. Maybe you forgot
> > one of the necessary flags? Or maybe you specified incompatible flags
> > (BPF_F_REPLACE | BPF_F_ALLOW_MULTI)? Or the parent cgroup has a
> > non-overridable BPF program attached already? Or maybe prog FD is
> > wrong, or cgroup FD is wrong, or?...
>
> A wrong FD for prog or cgroup would be a libbpf bug.

cgroup fd is the direct input parameter for
bpf_program__attach_cgroup() and bpf_prog_attach() APIs. But, of
course, we can also add a variant that takes a string path to cgroup
and fetches it. Or we can double-check that provided cgroup FD is
actually cgroup FD.

> imo that's the case where kernel must not return a string even
> if there is a log_buf facility.
>
> non-overridable already attached is EPERM. It's not EINVAL.
> multi-prog vs overridable is also EPERM.

Attaching the same BPF prog is EINVAL, though. But it doesn't matter
which error code specifically, either EPERM, or EINVAL, or even E2BIG
have many possible meanings in bpf() syscall.

> Say, the kernel has log_buf for hierarchy_allows_attach().
> what kind of message do you think it can print that will be user friendly?
> "attach is not allowed because there is a parent cgroup
> that has no override flag set"
> How is it much better than EPERM?

"parent cgroup prevents attaching BPF program" would already lead into
the right direction. It's not perfect and full, but better than more
generic EPERM. But sure, EPERM has less variants than EINVAL, so I'm
personally always happier with EPERM, than with EINVAL.

> Two differentiate between these two EPERM?
> Both to me look like the same category if permission checks.
> I don't know how to the kernel can print full cgroup path here.
> It has 'struct cgroup *'. Then go to kernfs? then what?
> cgroupfs is mounted somwhere.
> To have meaningul message the user would want to see something like:
> "
>   /sys/fs/cgroup/my_container <- has no-override bpf prog, hence
>   the kernel doesn't allow attach at:
>   /sys/fs/cgroup/my_container/here
> "
> Only libbpf can print such message.
> The user gave libbpf a string path. Attaching is relative to that.
> Whereas the kernel has hard time with mounts/paths/namespaces.

Sure, I didn't even hope for cgroup path or anything like that. Maybe
cgroup ID would be nice, don't know, but even without that just saying
that it's parent cgroup that's the culprit is a big step forward, IMO.

>
> May be to solve this cgroup attaching ambiguity we can add a libbpf
> helper that can walk hierarchy and print state?
> Either libbpf calls it automatically or user can trigger it?
>
> > 3. Someone gets excited about libbpf-tools in BCC, decides to convert
> > a tool. Needs to dump the hashmap fast. There is BATCH_LOOKUP, nice!
> > They try, they get EINVAL. Most probably outdated kernel, but I'll
> > need to dig into kernel sources to see what else could go wrong.
>
> right. that is similar to 1. I don't see how kernel could have helped.
> Say sys_bpf got top level log_buf for _all_ commands.
> The user is passing a command that is unsupported.
> The kernel has no clue whether log_buf is even there in bpf_attr.
> It cannot return a string. Only errno.
> If we change that errno from current EINVAL to ENOTSUPP...
> it would go back to the point I made above.
> Not really helping much.
> imo that's another case where libbpf probing can go long way to
> improve user experience.

log_buf can't help existing kernels. Period. No one is arguing or
expecting that. But moving forward, just having that "unknown command
123" would be great.

But yeah, of course libbpf can create a probing map and try to do
BATCH_LOOKUP, to detect BATCH_LOOKUP support.

>
> >
> > 4. Try using some of the low-level APIs from libbpf/bpf.h, like the
> > same cgroup program replacement. You'll get E2BIG and will scratch
> > your head for a while, checking how the list of attached BPF programs
> > can be too big, if it's the only one. Just to realize that again, your
> > kernel is just a touch too old and just complains about non-zero
> > unknown field in bpf_attr.
>
> The low-level APIs of libbpf is indeed a pain.
> There are also old and partially broken libbpf APIs.
> I think we need to start aggressively deprecating some of them.
> Especially those that cause debugging issues to users.
>
> > 5. Just few days ago, one user was doing bpf_program__attach_tracepoint():
> >
> > libbpf: program 'tp/sched/sched_process_exit': failed to attach to pfd
> > 10: File exists
> >
> > After a bit of back and forth turns out he had a second instance of
> > that program running in parallel. Good, I quickly realize that it's an
> > old kernel and it doesn't allow me to attach more than 1 BPF program
> > to the tracepoint. Case solved. But what about many other BPF users
> > that do not have access to someone developing BPF in the kernel?
>
> I similarly don't see how kernel string would have helped.
> It would have said the same thing: "cannot attach".

This one is for perf subsystem, actually, it's its
PERF_EVENT_IOC_SET_BPF ioctl (until we add bpf_link for perf_event
attachment).

"limit of allowed BPF programs reached" would be good enough. "cannot
attach" is too generic.

>
> > And the list goes on. Even if it was my full-time job just to
> > anticipate all the misuses and try to check/guess them in libbpf, that
> > wouldn't work and won't scale.
> >
> > And all I was asking (and not finger pointing or blaming anything or
> > anyone) to have a mechanism in the kernel to get a single-line
> > human-readable hint as to which one out of many
> > EINVAL/E2BIG/ENOENT/EPERM conditions was hit. No need to immediately
> > convert all of them, we could have gradually added that, prioritizing
> > common and most probable ones to hit.
>
> I'm not against adding log_buf to more bpf commands.
> In many cases they are needed.
> I'm against the blank statement that _all_ bpf commands need log_buf
> and that is somehow will solve user debug nightmares.

There was no such statement. There was no statement that it will
"solve" debug nightmares. But it will certainly ease the pain.

My proposal was about adding the ability to emit something to log_buf
from any of the BPF commands, if that BPF command chooses to provide
extra error information. The whole point of this was to avoid adding
log_buf in command-specific ways (as Toke was doing in the patch that
I used to initiate the discussion) and do it once for entire syscall,
so that we can gradually utilize it where it makes most sense.

>
> > project. Of course let's make libbpf more user-friendly where possible
> > and feasible,
>
> Let's do so.
> This thread jumped to early conclusion that log_buf for all bpf commands
> will magically improve user experience. Both you and Toke were happy to
> conclude that "horrible kernel UI/UX" is responsible for everything and
> it has to be the one to fix.

You somehow concluded that it has to be either kernel or libbpf that
has to be improved, not both. I don't know how you came to this
conclusion. I didn't say or mean that, neither I read that from Toke's
replies. Let me walk through relevant parts verbatim.

Me:
> > > > I think BPF syscall would benefit from common/generalized log support
> > > > across all commands, given how powerful/complex it already is.
> > > > Sometimes it's literally impossible to understand why one gets -EINVAL
> > > > without adding printk()s in the kernel.

Toke:
> > > Yes, I agree! This is horrible UI!

Me:
> > UI?.. It's a perfectly fine and extensible API for all functionality
> > it provides, it just needs a better human-readable feedback mechanism,
> > which is what I'm proposing. Error codes are not working when you have
>> so many different situations that can result in error.

... Some technical details back and forth follows ...

You:
> I really don't like 'common attr across all commands'.
> Both of you are talking as libbpf developers who occasionally need to
> add printk-s to the kernel. That is not an excuse to bloat api that will be
> useful to two people.

You not liking this I get, this is fine, we all have our preferences,
we don't have to agree on everything. But then you just jumped into
conclusion about our motivation and claimed that it will be useful to
only two people (presumably me and Toke). I'm also not sure about
bloating the API, given that such API is already part of BPF_PROG_LOAD
command, but there is no point in discussing such technical details
anymore.

Toke said that it's a horrible story to debug such generic errors (and
I concur, it is), not that the kernel is horrible itself or was
written by horrible people. I don't feel offended if libbpf provides
horrible user experience in parts I've implemented or changed. I might
disagree about the qualification in some cases, but I won't get
offended about someone not liking my code, API or design.


> I don't think that's the case and I hope
> working through the examples of bad user experience above made it clear.

Not at all. All you showed is that once someone runs into some
specific API misuse and debugs it to success, then it's usually pretty
obvious how libbpf could have helped doing additional diagnostics.
With the benefit of hindsight.

I agree that if such diagnostics are reliable and the situation itself
is common and experienced by multiple users, then it might make sense
to add such checks to libbpf. But I also don't think it's always
possible to diagnose something automatically with 100% confidence. We
can give hints, but misdiagnosing the problem can just further confuse
things instead. Also quite often such problems are one-offs, which
doesn't make them any less confusing and frustrating, but custom
diagnostics for every such case has a potential of bloating libbpf
beyond recognition and I'm not convinced that we should diagnose all
of them. That's what I meant that this is not a scalable approach to
just say "fix libbpf to be more user friendly, kernel does its best
already".


This thread was about generalizing log_buf to entire bpf(), even
though it got diverted into something entirely different. I would
still be interested to know the technical implications of syscall
using extra args (like in my original proposal #1, about adding 2
extra args if some flag in the existing argument is set). Is that even
safe to do with syscalls? Even if we don't do it, it's still useful to
know for the future. I think the syscall() wrapper is inherently
vararg and accepts an arbitrary number of args, so I assumed it's
actually ok, but don't know how to prove it.
