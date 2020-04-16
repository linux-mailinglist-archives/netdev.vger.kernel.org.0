Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A871AD31C
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 01:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgDPXSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 19:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgDPXSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 19:18:35 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E30EC061A0F;
        Thu, 16 Apr 2020 16:18:34 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a32so236242pje.5;
        Thu, 16 Apr 2020 16:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XG57rR3E8DeijyO8lkg2NM/irBg+FSpnfdZfo3yuSgo=;
        b=hb4TNWwsv8izF8rvJgU0XnPkPwX7f5golszhr2oxJn1ykhZu5ZqR56lwyLCzvvUvTg
         glqlMNO54tUZnfT39hDZyoALcQyNnLS8E/L1gXwApA6qWXJbR3KEbxtSe9p+jP0OWi5K
         CoCoeL02DcWjYZZocDU1fvJZVN32eOY7gI6qXtwtGXyC/vIXS59VZnC6I/619U5oWtf7
         B/gX/YqQ4rblYvrzSk06yCmKUsY5oPBEzx7FbnoprW/ry9VxjEYJRTl6/iUAa2G5sDIz
         Aa+fN+3ACc0y6AIXCaJ9b+vULZtcjuMMnppue23yZ3O3FoWEURfiWT4R314WvznwmCum
         BUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XG57rR3E8DeijyO8lkg2NM/irBg+FSpnfdZfo3yuSgo=;
        b=M13F4wTCrYIin1HJ1UMqM/c+b8sS9NH5X1ncNbPTzcIJ7i2K4XdLb+END7tUq/GpyS
         9OzlEySjo04kSBjdGi6qpf6ZSz+YAgFs/RMKyoY7X5+BiJOLGYPbFM/YSsase4+FEWZQ
         EFtDOIUDfL16res1A+cM+daB6dkbH5sKrUq9TUrKGw3BqPiowDLV6rYuTD/a6/606xlC
         IA+3QBwpF9yV4xgbZGPFJfeSDWkMuqzTTcIpOFwq8a4E7LSuuYIcVmFHqJZ6+GgHrGM1
         yOGKCHW4qHrGWkTvQ1lFYvP3NhZ0VN6+1SDLxZdr40cqxjWQxqXRRY4mMKpBE9KfxW2G
         5+Uw==
X-Gm-Message-State: AGi0PuYvsxAAYQ037JndKRgYwLmQXs5d4KcvoYPRxurQdjCdsmq+BLbm
        5c3SjA6SYnIpDzY0aW2aDcJr9E3+
X-Google-Smtp-Source: APiQypLMrTaQKMREtD2kOvlx+/AhbMZm78+PylYZLCutxEXh6qNMdYjhrPe9plhp6PqBvLJBI0Dd2w==
X-Received: by 2002:a17:90a:276a:: with SMTP id o97mr879785pje.194.1587079113469;
        Thu, 16 Apr 2020 16:18:33 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:fff8])
        by smtp.gmail.com with ESMTPSA id l71sm11994846pge.3.2020.04.16.16.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 16:18:32 -0700 (PDT)
Date:   Thu, 16 Apr 2020 16:18:29 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
Message-ID: <20200416231829.o4yngurm5nzrakoj@ast-mbp.dhcp.thefacebook.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4Bzawu2dFXL7nvYhq1tKv9P7Bb9=6ksDpui5nBjxRrx=3_w@mail.gmail.com>
 <4bf72b3c-5fee-269f-1d71-7f808f436db9@fb.com>
 <CAEf4BzZnq958Guuusb9y65UCtB-DARxdk7_q7ZPBZ3WOwjSKaw@mail.gmail.com>
 <20200415164640.evaujoootr4n55sc@ast-mbp>
 <CAEf4Bza2YkmFMZ_d6d6keLqeWNDr8dbBQj=42xSrONaULK1PXg@mail.gmail.com>
 <20200416170414.ds3hcb3bgfetjt4v@ast-mbp>
 <CAEf4BzY0a_Rzt8vtLLSz3+xAhx0CWhetxcUNdyK7ZygMms7srA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY0a_Rzt8vtLLSz3+xAhx0CWhetxcUNdyK7ZygMms7srA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 12:35:07PM -0700, Andrii Nakryiko wrote:
> >
> > I slept on it and still fundamentally disagree that seq_file + bpf_prog
> > is a derivative of link. Or in OoO terms it's not a child class of bpf_link.
> > seq_file is its own class that should contain bpf_link as one of its
> > members, but it shouldn't be derived from 'class bpf_link'.
> 
> Referring to inheritance here doesn't seem necessary or helpful, I'd
> rather not confuse and complicate all this further.
> 
> bpfdump provider/target + bpf_prog = bpf_link. bpf_link is "a factory"
> of seq_files. That's it, no inheritance.

named seq_file in bpfdumpfs does indeed look like "factory" pattern.
And yes, there is no inheritance between named seq_file and given seq_file after open().

> > In that sense Yonghong proposed api (raw_tp_open to create anon seq_file+prog
> > and obj_pin to create a template of named seq_file+prog) are the best fit.
> > Implementation wise his 'struct extra_priv_data' needs to include
> > 'struct bpf_link' instead of 'struct bpf_prog *prog;' directly.
> >
> > So evertime 'cat' opens named seq_file there is bpf_link registered in IDR.
> > Anon seq_file should have another bpf_link as well.
> 
> So that's where I disagree and don't see the point of having all those
> short-lived bpf_links. cat opening seq_file doesn't create a bpf_link,
> it creates a seq_file. If we want to associate some ID with it, it's
> fine, but it's not a bpf_link ID (in my opinion, of course).

I thought we're on the same page with the definition of bpf_link ;)
Let's recap. To make it easier I'll keep using object oriented analogy
since I think it's the most appropriate to internalize all the concepts.
- first what is file descriptor? It's nothing but std::shared_ptr<> to some kernel object.
- then there is a key class == struct bpf_link
- for raw tracepoints raw_tp_open() returns an FD to child class of bpf_link
  which is 'struct bpf_raw_tp_link'.
  In other words it returns std::shared_ptr<struct bpf_raw_tp_link>.
- for fentry/fexit/freplace/lsm raw_tp_open() returns an FD to a different child
  class of bpf_link which is "struct bpf_tracing_link".
  This is std::share_ptr<struct bpf_trace_link>.
- for cgroup-bpf progs bpf_link_create() returns an FD to child class of bpf_link
  which is 'struct bpf_cgroup_link'.
  This is std::share_ptr<struct bpf_cgroup_link>.

In all those cases three different shared pointers are seen as file descriptors
from the process pov but they point to different children of bpf_link base class.
link_update() is a method of base class bpf_link and it has to work for
all children classes.
Similarly your future get_obj_info_by_fd() from any of these three shared pointers
will return information specific to that child class.
In all those cases one link attaches one program to one kernel object.

Now back to bpfdumpfs.
In the latest Yonghong's patches raw_tp_open() returns an FD that is a pointer
to seq_file. This is existing kernel base class. It has its own seq_operations
virtual methods that are defined for bpfdumpfs_seq_file which is a child class
of seq_file that keeps start/stop/next methods as-is and overrides show()
method to be able to call bpf prog for every iteratable kernel object.

What you're proposing is to make bpfdump_seq_file class to be a child of two
base classes (seq_file and bpf_link) whereas I'm saying that it should be
a child of seq_file only, since bpf_link methods do not apply to it.
Like there is no sensible behavior for link_update() on such dual parent object.

In my proposal bpfdump_seq_file class keeps cat-ability and all methods of seq_file
and no extra methods from bpf_link that don't belong in seq_file.
But I'm arguing that bpfdump_seq_file class should have a member bpf_link
instead of simply holding bpf_prog via refcnt.
Let's call this child class of bpf_link the bpf_seq_file_link class. Having
bpf_seq_file_link as member would mean that such link is discoverable via IDR,
the user process can get an FD to it and can do get_obj_info_by_fd().
The information returned for such link will be a pair (bpfdump_prog, bpfdump_seq_file).
Meaning that at any given time 'bpftool link show' will show where every bpf
prog in the system is attached to.
Say named bpfdump_seq_file exists in /sys/kernel/bpfdump/tasks/foo.
No one is doing a 'cat' on it yet.
"bpftool link show" will show one link which is a pair (bpfdump_prog, "tasks/foo").
Now two humans are doing 'cat' of that file.
The bpfdump_prog refcnt is now 3 and there are two additional seq_files created
by the kernel when user said open("/sys/kernel/bpfdump/tasks/foo").
If these two humans are slow somebody could have done "rm /sys/kernel/bpfdump/tasks/foo"
and that bpfdump_seq_file and it's member bpf_seq_file_link would be gone,
but two other bpdump_seq_file-s are still active and they are different.
"bpftool link show" should be showing two pairs (bpfdump_prog, seq_file_A) and
(bpfdump_prog, seq_file_B).
The users could have been in different pid namespaces. What seq_file_A is
iterating could be completely different from seq_file_B, but I think it's
useful for admin to know where all bpf progs in the system are attached and
what kind of things are triggering them.
