Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08207223182
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 05:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgGQDJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 23:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgGQDJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 23:09:26 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C74C061755;
        Thu, 16 Jul 2020 20:09:26 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t6so5981658pgq.1;
        Thu, 16 Jul 2020 20:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fe41iyAaH817zoIO+WYRMSbdWzpmmUo3k0dG3Pd+jPQ=;
        b=Pp2z0wnO6nj1CrFnBGVerufSKpJvVpoDzDYv9MICCjYEDtfIaKAVXOVulND+mQPpUR
         qPa7NUXEljroBUP1pML2dNBUD2uRHikz1NiPpYTPqhTdYzmXOumIRKJRX39QveYMLjES
         Vh11S0bMrG8sjy3bx6cr4VRCm4PynajJ2PCLd+Q7+rBH7JFOkdFP8cgeHZ0OchxvnIa1
         vxgZFFPVJ6d66hHSqILFx9U6R8VN4Qkj+6Qyox1EUMbKRz9ong8Z+DQrj8zAk82OJvCF
         TOFCf+ecZe7Qxkez4nhNj6DJi5PE8VcnmvhRn6QPjC8Qrif7VjI94a0PaEgxLu+EjfGp
         rwyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fe41iyAaH817zoIO+WYRMSbdWzpmmUo3k0dG3Pd+jPQ=;
        b=mmKSaDTottd4fwiGZDP3aoEua26yaaP3SYuLRhha4pl9xZa52PFl/5rPfRa9acIubL
         ip08NEGMkOLEUaY8yzP0HD1Z5eOS5e0zWIV48LHKannXdU5/e89TADD+xC5RENTz+zhA
         71Vhdf4ve0RV/WJDyFmphikIpSDYqS21qUf9zw1nFDd5q4NaYCv6dwXDANON9oB94oOr
         TwnkWGvEVHJ6gyTPruEqoAe4XPOGMbxIx0rEPII0qD+BQNHJ+CQqBH4yuoXTkhMoI3Sd
         GPVbz8zCFEQt2d9ccor21mJ6xdP0u4cgFDSEHGfFzjVIXq7JAB5BumNTW0PCbb6ZGWcL
         lhNw==
X-Gm-Message-State: AOAM5326TNtLWhgwNyfyeLMBuAdEflCyqNMp1+LwGy0ys6RWuFyocYS3
        VIERwEtW7yPWIL89eJkKOj4=
X-Google-Smtp-Source: ABdhPJzrm4g8J+YkQXAU+GJXkf4mOoU7hEashfd/vARBZbh0djo6lPihpNtBmAU9+dtJ7Ro+Kvfd0w==
X-Received: by 2002:a65:584e:: with SMTP id s14mr6714281pgr.151.1594955365629;
        Thu, 16 Jul 2020 20:09:25 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e3b])
        by smtp.gmail.com with ESMTPSA id z10sm6147837pfr.90.2020.07.16.20.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 20:09:24 -0700 (PDT)
Date:   Thu, 16 Jul 2020 20:09:20 -0700
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
        Kernel Team <kernel-team@fb.com>,
        Blake Matheny <bmatheny@fb.com>
Subject: Re: BPF logging infrastructure. Was: [PATCH bpf-next 4/6] tools: add
 new members to bpf_attr.raw_tracepoint in bpf.h
Message-ID: <20200717030920.6kxs6kyvisuvoqnt@ast-mbp.dhcp.thefacebook.com>
References: <CAEf4Bzbu1wnwWFOWYA3e6KFeSmfg8oANPWD9LsUMRy2E_zrQ0w@mail.gmail.com>
 <87pn8xg6x7.fsf@toke.dk>
 <CAEf4BzYAoetyfyofTX45RQjtz3M-c9=YNeH1uRDbYgK4Ae0TwA@mail.gmail.com>
 <87d04xg2p4.fsf@toke.dk>
 <20200714231133.ap5qnalf6moptvfk@ast-mbp.dhcp.thefacebook.com>
 <874kq9ey2j.fsf@toke.dk>
 <20200715234123.rr7oj74t5hflzmsn@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbodR-+=Q3wRE2UaiouBexvqfwpE-zJGm4Rr1cV2dgZHQ@mail.gmail.com>
 <20200716054408.so34cuc2g2iqcppr@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbiD9Cuqip2=FGHGHLZs-7b8AziS-hJOpX1HuONTM4udQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbiD9Cuqip2=FGHGHLZs-7b8AziS-hJOpX1HuONTM4udQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 12:59:30PM -0700, Andrii Nakryiko wrote:
> On Wed, Jul 15, 2020 at 10:44 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Jul 15, 2020 at 06:11:39PM -0700, Andrii Nakryiko wrote:
> > > >
> > > > On Wed, Jul 15, 2020, Andrii Nakryiko wrote:
> > > > >
> > > > > Inability to figure out what's wrong when using BPF is at the top of
> > > > > complaints from many users, together with hard to understand logs from
> > > > > verifier.
> > > >
> > > > Only the second part is true. All users are complaining about the verifier.
> > > > No one is complaing that failed prog attach is somehow lacking string message.
> > >
> > > Ok, next time I'll be helping someone to figure out another -EINVAL,
> > > I'll remember to reassure them that it's not really frustrating, not a
> > > guess game, and not a time sink at all.
> >
> > When the next time the users hit EINVAL due to _their_ usage and not
> > due to kernel or libbpf bug and libbpf couldn't do anything to make
> > the error user friendly then yes please raise it up.
> 
> I know this is futile to convince you anyways, so I won't go dig all
> the details, but here are few general examples. With the benefit of
> hindsight in a lot of those cases libbpf can do extra checks and
> guessing (though bad guess is worse than no guess), but that doesn't
> scale because of the sheer amount of possible situations.
> 
> What I personally went through when I was building runqslower:
> 
> 1. You write a simple BPF program, open + load. You run it, you get EPERM.
> 2. You go check if you ran the program with sudo, retry with sudo.
> 3. You still get EPERM. You bang your head against the wall for 30
> minutes, you recall about RLIMIT_MEMLOCK, you bump it up.
> 4. If you are happy, now everything works. I don't remember now if I
> had to bang my head some more until I got the initial minimal version
> of runqslower successfully load BPF program.

But we have libbpf hinting on that already?
Are you saying that hint wasn't working somehow?

> 
> Some popular other issues I can recall.
> 
> 1. People get excited and try to use fentry/fexit, get -EINVAL. Most
> probably it's because they don't have a recent enough kernel.
> Otherwise (if they know libbpf behavior), they'd probably have gotten
> something about not being able to find the desired BTF func in the
> kernel. Even in that case, is that that they don't have BTF at all
> (CONFIG_DEBUG_BTF_INFO=y)? Or it's just an old one with no FUNCs
> because pahole isn't recent enough? Kernel build won't mention that
> you need 1.16 for fentry/fexit, of course. And so on. This is actually
> not the worst case, because I can walk them through this process.

Exactly. Either old kernel or missing config in the kernel.
libbpf is above that. It could have provided a hint.
When libbpf is processing SEC("fentry/") and it fails to load with
empty verifier log it could start probing.
Only libbpf can do it. Kernel is helpless here.
Say we change the kernel errno for all unsuported prog types and maps
it would return ENOTSUPP or something.
Would it really help the situation?
Probably not. There will be old kernels and the same usability
issue as you described.

> 2. When dealing with cgroups. You get EINVAL for every tiny misstep.
> You want to replace the BPF program, you get EINVAL. Maybe you forgot
> one of the necessary flags? Or maybe you specified incompatible flags
> (BPF_F_REPLACE | BPF_F_ALLOW_MULTI)? Or the parent cgroup has a
> non-overridable BPF program attached already? Or maybe prog FD is
> wrong, or cgroup FD is wrong, or?...

A wrong FD for prog or cgroup would be a libbpf bug.
imo that's the case where kernel must not return a string even
if there is a log_buf facility.

non-overridable already attached is EPERM. It's not EINVAL.
multi-prog vs overridable is also EPERM.
Say, the kernel has log_buf for hierarchy_allows_attach().
what kind of message do you think it can print that will be user friendly?
"attach is not allowed because there is a parent cgroup
that has no override flag set"
How is it much better than EPERM?
Two differentiate between these two EPERM?
Both to me look like the same category if permission checks.
I don't know how to the kernel can print full cgroup path here.
It has 'struct cgroup *'. Then go to kernfs? then what?
cgroupfs is mounted somwhere.
To have meaningul message the user would want to see something like:
"
  /sys/fs/cgroup/my_container <- has no-override bpf prog, hence
  the kernel doesn't allow attach at:
  /sys/fs/cgroup/my_container/here
"
Only libbpf can print such message.
The user gave libbpf a string path. Attaching is relative to that.
Whereas the kernel has hard time with mounts/paths/namespaces.

May be to solve this cgroup attaching ambiguity we can add a libbpf
helper that can walk hierarchy and print state?
Either libbpf calls it automatically or user can trigger it?

> 3. Someone gets excited about libbpf-tools in BCC, decides to convert
> a tool. Needs to dump the hashmap fast. There is BATCH_LOOKUP, nice!
> They try, they get EINVAL. Most probably outdated kernel, but I'll
> need to dig into kernel sources to see what else could go wrong.

right. that is similar to 1. I don't see how kernel could have helped.
Say sys_bpf got top level log_buf for _all_ commands.
The user is passing a command that is unsupported.
The kernel has no clue whether log_buf is even there in bpf_attr.
It cannot return a string. Only errno.
If we change that errno from current EINVAL to ENOTSUPP...
it would go back to the point I made above.
Not really helping much.
imo that's another case where libbpf probing can go long way to
improve user experience.

> 
> 4. Try using some of the low-level APIs from libbpf/bpf.h, like the
> same cgroup program replacement. You'll get E2BIG and will scratch
> your head for a while, checking how the list of attached BPF programs
> can be too big, if it's the only one. Just to realize that again, your
> kernel is just a touch too old and just complains about non-zero
> unknown field in bpf_attr.

The low-level APIs of libbpf is indeed a pain.
There are also old and partially broken libbpf APIs.
I think we need to start aggressively deprecating some of them.
Especially those that cause debugging issues to users.

> 5. Just few days ago, one user was doing bpf_program__attach_tracepoint():
> 
> libbpf: program 'tp/sched/sched_process_exit': failed to attach to pfd
> 10: File exists
> 
> After a bit of back and forth turns out he had a second instance of
> that program running in parallel. Good, I quickly realize that it's an
> old kernel and it doesn't allow me to attach more than 1 BPF program
> to the tracepoint. Case solved. But what about many other BPF users
> that do not have access to someone developing BPF in the kernel?

I similarly don't see how kernel string would have helped.
It would have said the same thing: "cannot attach".

> And the list goes on. Even if it was my full-time job just to
> anticipate all the misuses and try to check/guess them in libbpf, that
> wouldn't work and won't scale.
> 
> And all I was asking (and not finger pointing or blaming anything or
> anyone) to have a mechanism in the kernel to get a single-line
> human-readable hint as to which one out of many
> EINVAL/E2BIG/ENOENT/EPERM conditions was hit. No need to immediately
> convert all of them, we could have gradually added that, prioritizing
> common and most probable ones to hit.

I'm not against adding log_buf to more bpf commands.
In many cases they are needed.
I'm against the blank statement that _all_ bpf commands need log_buf
and that is somehow will solve user debug nightmares.

> project. Of course let's make libbpf more user-friendly where possible
> and feasible,

Let's do so.
This thread jumped to early conclusion that log_buf for all bpf commands
will magically improve user experience. Both you and Toke were happy to
conclude that "horrible kernel UI/UX" is responsible for everything and
it has to be the one to fix. I don't think that's the case and I hope
working through the examples of bad user experience above made it clear.
