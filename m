Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF041AD587
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 07:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgDQFLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 01:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgDQFLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 01:11:40 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5897EC061A0C;
        Thu, 16 Apr 2020 22:11:40 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id y19so339795qvv.4;
        Thu, 16 Apr 2020 22:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9sEnVvIiDTUmwgMQkX3BpUVF3hxyW8dcfgPmZRjOcDc=;
        b=POPhMxmOT4AqkXp13lw9V+CEf3qUaUOqQ+vJ14weJIxkmRh4zLa16GfofbVV2azZDz
         oRptF5zGdfwWMKYzkWgUIpR6mxg0+I5IzbPdbUWFUQBumj1+YXAC4BpF8Sj1CalHB7/x
         vXxj96JzKYSbCD2l0nQpY6766lqoqKZZwRzbPFRDpdOIJ95M4XdgbdxMAaAclu7whaVb
         ZGwydfmODsJlMGkpNqJ5xC+kEFoM63wYY0rPuaCxPPX3UfzXllB1lo7B507x0XedjPPp
         CQEX4FX3UJ+1n4jQLHce7UaCHl8v/Or7+eMJ+mJpO4TiANKSvIYjXiEUrheVe4EKpPLU
         lKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9sEnVvIiDTUmwgMQkX3BpUVF3hxyW8dcfgPmZRjOcDc=;
        b=ILsSu+9XRstaYRH8k621z7Q+op7sT3g5Y/riKdgu6tXIq9Ik2vcPlAju34UB1JutkD
         1nSiyZBHSRBQF3Scd2dLZNH+1dHnhDCK07trZDtYyrjbfV8l4AGxbAxSmTIKHJJnXh4h
         EFmAS4IX2BWC8s71Jm/MOuawGGrthsN2pM9TurKtu+QUdIwTvEo7ZJKakuuZsapC39Wi
         SdX1Yvbrhtq16Lk4VvnOYOGKkJG7hQaquTL0wwdCyJFh6FwNmFlwwnWge21/pYTcnZT3
         WWzrwD+WQM4gYLRnzZW5SRi48TwI8/olk61SH+TcAlaN0Fo2P1g9sC3unsU3ceZwkPUf
         ep1Q==
X-Gm-Message-State: AGi0PubZstl6ZHJyt8Hau1r4Z/zT5GtUcFJqWq9bGEkFFAdDxSjH/ouR
        04vQ1a8qP6X6bD6Foz1tZCo6Ci4t2HU8Fl8kRFM=
X-Google-Smtp-Source: APiQypKeoHNnD+bfvovL4M33ZQ0mVohc06w1IIPLTUcUZpiiJqZdBh/IloFN66P/XNlARe71AxP0rg1+nCsqZdjkhyA=
X-Received: by 2002:a0c:fd8c:: with SMTP id p12mr1074809qvr.163.1587100298684;
 Thu, 16 Apr 2020 22:11:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4Bzawu2dFXL7nvYhq1tKv9P7Bb9=6ksDpui5nBjxRrx=3_w@mail.gmail.com>
 <4bf72b3c-5fee-269f-1d71-7f808f436db9@fb.com> <CAEf4BzZnq958Guuusb9y65UCtB-DARxdk7_q7ZPBZ3WOwjSKaw@mail.gmail.com>
 <20200415164640.evaujoootr4n55sc@ast-mbp> <CAEf4Bza2YkmFMZ_d6d6keLqeWNDr8dbBQj=42xSrONaULK1PXg@mail.gmail.com>
 <20200416170414.ds3hcb3bgfetjt4v@ast-mbp> <CAEf4BzY0a_Rzt8vtLLSz3+xAhx0CWhetxcUNdyK7ZygMms7srA@mail.gmail.com>
 <20200416231829.o4yngurm5nzrakoj@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200416231829.o4yngurm5nzrakoj@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Apr 2020 22:11:27 -0700
Message-ID: <CAEf4Bzb7tr3GCxN_WtE2RVD7j3NA7w_pJQ25Sz87tVDL1j4e1g@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 4:18 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Apr 16, 2020 at 12:35:07PM -0700, Andrii Nakryiko wrote:
> > >
> > > I slept on it and still fundamentally disagree that seq_file + bpf_prog
> > > is a derivative of link. Or in OoO terms it's not a child class of bpf_link.
> > > seq_file is its own class that should contain bpf_link as one of its
> > > members, but it shouldn't be derived from 'class bpf_link'.
> >
> > Referring to inheritance here doesn't seem necessary or helpful, I'd
> > rather not confuse and complicate all this further.
> >
> > bpfdump provider/target + bpf_prog = bpf_link. bpf_link is "a factory"
> > of seq_files. That's it, no inheritance.
>
> named seq_file in bpfdumpfs does indeed look like "factory" pattern.
> And yes, there is no inheritance between named seq_file and given seq_file after open().
>
> > > In that sense Yonghong proposed api (raw_tp_open to create anon seq_file+prog
> > > and obj_pin to create a template of named seq_file+prog) are the best fit.
> > > Implementation wise his 'struct extra_priv_data' needs to include
> > > 'struct bpf_link' instead of 'struct bpf_prog *prog;' directly.
> > >
> > > So evertime 'cat' opens named seq_file there is bpf_link registered in IDR.
> > > Anon seq_file should have another bpf_link as well.
> >
> > So that's where I disagree and don't see the point of having all those
> > short-lived bpf_links. cat opening seq_file doesn't create a bpf_link,
> > it creates a seq_file. If we want to associate some ID with it, it's
> > fine, but it's not a bpf_link ID (in my opinion, of course).
>
> I thought we're on the same page with the definition of bpf_link ;)
> Let's recap. To make it easier I'll keep using object oriented analogy
> since I think it's the most appropriate to internalize all the concepts.
> - first what is file descriptor? It's nothing but std::shared_ptr<> to some kernel object.

I agree overall, but if I may be 100% pedantic, FD and kernel objects
topology can be quite a bit more complicated:

FD ---> struct file --(private_data)----> kernel object
     /                                 /
FD --                                 /
                                     /
FD ---> struct file --(private_data)/

I'll refer to this a bit further down.

> - then there is a key class == struct bpf_link
> - for raw tracepoints raw_tp_open() returns an FD to child class of bpf_link
>   which is 'struct bpf_raw_tp_link'.
>   In other words it returns std::shared_ptr<struct bpf_raw_tp_link>.
> - for fentry/fexit/freplace/lsm raw_tp_open() returns an FD to a different child
>   class of bpf_link which is "struct bpf_tracing_link".
>   This is std::share_ptr<struct bpf_trace_link>.
> - for cgroup-bpf progs bpf_link_create() returns an FD to child class of bpf_link
>   which is 'struct bpf_cgroup_link'.
>   This is std::share_ptr<struct bpf_cgroup_link>.
>
> In all those cases three different shared pointers are seen as file descriptors
> from the process pov but they point to different children of bpf_link base class.
> link_update() is a method of base class bpf_link and it has to work for
> all children classes.
> Similarly your future get_obj_info_by_fd() from any of these three shared pointers
> will return information specific to that child class.
> In all those cases one link attaches one program to one kernel object.
>

Thank you for a nice recap! :)

> Now back to bpfdumpfs.
> In the latest Yonghong's patches raw_tp_open() returns an FD that is a pointer
> to seq_file. This is existing kernel base class. It has its own seq_operations
> virtual methods that are defined for bpfdumpfs_seq_file which is a child class
> of seq_file that keeps start/stop/next methods as-is and overrides show()
> method to be able to call bpf prog for every iteratable kernel object.
>
> What you're proposing is to make bpfdump_seq_file class to be a child of two
> base classes (seq_file and bpf_link) whereas I'm saying that it should be
> a child of seq_file only, since bpf_link methods do not apply to it.
> Like there is no sensible behavior for link_update() on such dual parent object.
>
> In my proposal bpfdump_seq_file class keeps cat-ability and all methods of seq_file
> and no extra methods from bpf_link that don't belong in seq_file.
> But I'm arguing that bpfdump_seq_file class should have a member bpf_link
> instead of simply holding bpf_prog via refcnt.
> Let's call this child class of bpf_link the bpf_seq_file_link class. Having
> bpf_seq_file_link as member would mean that such link is discoverable via IDR,
> the user process can get an FD to it and can do get_obj_info_by_fd().
> The information returned for such link will be a pair (bpfdump_prog, bpfdump_seq_file).
> Meaning that at any given time 'bpftool link show' will show where every bpf
> prog in the system is attached to.
> Say named bpfdump_seq_file exists in /sys/kernel/bpfdump/tasks/foo.
> No one is doing a 'cat' on it yet.
> "bpftool link show" will show one link which is a pair (bpfdump_prog, "tasks/foo").
> Now two humans are doing 'cat' of that file.
> The bpfdump_prog refcnt is now 3 and there are two additional seq_files created
> by the kernel when user said open("/sys/kernel/bpfdump/tasks/foo").
> If these two humans are slow somebody could have done "rm /sys/kernel/bpfdump/tasks/foo"
> and that bpfdump_seq_file and it's member bpf_seq_file_link would be gone,
> but two other bpdump_seq_file-s are still active and they are different.
> "bpftool link show" should be showing two pairs (bpfdump_prog, seq_file_A) and
> (bpfdump_prog, seq_file_B).
> The users could have been in different pid namespaces. What seq_file_A is
> iterating could be completely different from seq_file_B, but I think it's
> useful for admin to know where all bpf progs in the system are attached and
> what kind of things are triggering them.

How exactly bpf_link is implemented for bpfdumper is not all that
important to me. It can be a separate struct, a field, a pointer to a
separate struct -- not that different.

I didn't mean for this thread to be just another endless discussion,
so I'll try to wrap it up in this email. I really like bpfdumper idea
and usability overall. Getting call for end of iteration is a big deal
and I'm glad I got at least that :)

But let me try to just point out few things you proposed above that I
disagree on the high-level with, as well as provide few supporting
point to the scheme I proposed previously. If all that is not
convincing, I rest my case and I won't object to bpfdumper to go in in
any form, as long as I can use it anonymously with extra call at the
end to do post-aggregation.

So, first. I do not see a point of treating each instance of seq_file
as if it was an new bpf_link:
1. It's a bit like saying that each inherited cgroup bpf program in
effective_prog_array should has a new bpf_link created. It's not how
it's done for cgroups and I think for a good reason.
2. Further, each seq_file, when created from "seq_file template",
should take a refcnt on bpf_prog, not bpf_link. Because seq_file
expects bpf_prog itself to be exactly the same throughout entire
iteration process. Bpf_link, on the other hand, allows to do in-place
update of bpf_program, which would ruin seq_file iteration,
potentially. I know we can disable that, but it just feels like
arbitrary restrictions.
3. Suppose each seq_file is/has bpf_link and one can iterate over each
active seq_file (what I've been calling a session, but whatever). What
kind of info user-facing info you can get from get_obj_info? prog_id,
prog_tag, provider ID/name (i.e., /sys/fs/bpfdump/task). Is that
useful? Yes! Is that enough to do anything actionable? No! Immediately
you'd need to know PIDs of all processes that have FD open to that
seq_file (and see diagram above, there could be many processes with
many FDs for the same seq_file). bpf_link doesn't know all PIDs. So
it's this generic "who has this file opened" problem all over again,
which I'm already pretty tired to talk about :) Except now we have at
least 3 ways to answer such questions: iterate procfs+fdinfo, drgn
scripts, now also bpfdump program for task/file provider.

So even if you can enumerate active bpfdump seq_files in the system,
you still need extra info and iterate over task/file items to be able
to do anything about that. Which is one of the reasons I think
auto-creating bpf_links for each seq_file is useless and will just
pollute the view of the system (from bpf_link standpoint).

Now, second. Getting back what I proposed with 3-4 step process (load
--> attach (create_link) --> (pin in bpfdumpds + open() |
BPF_NEW_DUMP_SESSION)). I realize now that attach might seem
superficial here, because it doesn't provide any extra information (FD
of provider was specified at prog load time). It does feel a bit
weird, but:

1. It's not that weird, because fentry/fexit/freplace and tp_btf also
don't provide anything extra: all the info was specified at load time.
2. This attach step is a good point to provide some sort of
"parametrization" to narrow down behavior of providers. I'll give two
examples that I think are going to be very useful and we'll eventually
add support for them in one way or another.

Example A. task/file provider. Instead of iterating over all tasks,
the simplest extension would be to specify **one** specific task PID
to iterate all files of. Attach time would be the place to specify
this PID. We don't need to know PID at load time, because that doesn't
change anything about BPF program validation and verified just doesn't
need to know. So now, once attached, bpf_link is created that can be
pinned in bpfdumpfs or BPF_NEW_DUMP_SESSION can be used to create
potentially many seq_files (e.g., poll every second) to see all open
files from a specific task. We can keep generalizing to, say, having
all tasks in a given cgroup. All that can be implemented by filtering
out inside BPF program, of course, but having narrower scope from the
beginning could save tons of time and resources.

Example B. Iterating BPF map items. We already have bpf_map provider,
next could be bpf_map/items, which would call BPF program for each
key/value pair, something like:

int BPF_PROG(for_each_map_kv, struct seq_file *seq, struct bpf_map *map,
             void *key, size_t key_size, void *value, size_t value_size)
{
    ...
}

Now, once you have that, a natural next desire is to say "only dump
items of map with ID 123", instead of iterating over all BPF maps in
the system. That map ID could be specified at attachment time, when
bpf_link with these parameters are going to be created. Again, at load
time BPF verifier doesn't need to know specific BPF map we are going
to iterate, if we stick to generic key/value blobs semantics.

So with such possibility considered, I hope having explicit
LINK_CREATE step starts making much more sense. This, plus not having
to distinguish between named and anonymous dumpers (just like we don't
distinguish pinned, i.e. "named", bpf_link from anonymous one), makes
me still believe that this is a better approach.

But alas, my goal here is to bring different perspectives, not to
obstruct or delay progress. So I'm going to spend some more time
reviewing v2 and will provide feedback on relevant patches, but if my
arguments were not convincing, I'm fine with that. I managed to
convince you guys that "anonymous" bpfdumper without bpfdumpfs pinning
and post-aggregation callback are a good thing and I'm happy about
that already. Can't get 100% of what I want, right? :)
