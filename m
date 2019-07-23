Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D05C572203
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392270AbfGWWLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:11:15 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38118 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731838AbfGWWLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:11:14 -0400
Received: by mail-pg1-f195.google.com with SMTP id f5so11267133pgu.5;
        Tue, 23 Jul 2019 15:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=krd47KBmbC2YCxG0oFNZuaclAvYF8DzUXwIztNKgp/I=;
        b=g64FknjB1Ux/dP39uEmwhdySu6Hzb5NU/78D1KqGbM+NljHM/GC86eNd0z2mq0R6pN
         Q/0LO/dO2Hm8SxcvPfuFxXdnEaBLGDhAt8WN+b7nZnfzchhoNMp0DN/jhKVpYUoW7zJQ
         lRbHx7dk8yeerW+8ZOgQiMEJbo7uZ2z4thhHcWmD/XXIlJIXDDmUX/pGfi4qe74+2vda
         ReKkc76sxMj7QrmPhK7ntX6lj69l84t4/j6fZnuCYqyNAXP3AV1X0ROEiVquv95akAIs
         1jVGPRrODrNz3RAC1fjxa7X6KXdqXYd7/V43Gsly1TQEeEvfMW+w2OOWQWui62+IJD79
         qXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=krd47KBmbC2YCxG0oFNZuaclAvYF8DzUXwIztNKgp/I=;
        b=kJCAWxYOKaFPVIVGUgl9VgHXpleY935FlA4XL2Vv3UvDzWdMptmifBQTuUwDri64Mb
         F8Fe82JDnllOutH+3zdte2vXmWVx+DI7l9M4ILflF2hiisy4KRO7+/QojodZ6FRlenYl
         5UL3//ncOeIO1mfDdsiusChDVGUeEF+tyVhnU0LRbt9Vhzj6JT8kXMdnF/vt9Pi06FN3
         dPlbah4zEeXBazVii9FPIVjXq1hk+fBE5mrgR0ceBXU0hFyfCYUDj5K8GSiip7skowha
         NHTfxpjPEZ4LBfffd1W40Yv8Ztrr8eyJAbtm+4TKKkwMTjutF0TutbQipwJz4c22oV6V
         L32A==
X-Gm-Message-State: APjAAAUjpsoZyV14Km2JCnx9Rk+nPMadk2KinlOceYZOemseRZjxuIAW
        hzoW2bQjsiFLMAo4Hi9z22E2F8kz
X-Google-Smtp-Source: APXvYqzpqmQoS42jlBkyd2u9JwIli71FfNCcHqIe3C7TEIeYvwgKH6Q2FwYVY7b7/wSD+FMDN1YaTA==
X-Received: by 2002:a63:5c07:: with SMTP id q7mr26313193pgb.436.1563919873115;
        Tue, 23 Jul 2019 15:11:13 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::3:46e3])
        by smtp.gmail.com with ESMTPSA id 65sm47859813pgf.30.2019.07.23.15.11.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 15:11:12 -0700 (PDT)
Date:   Tue, 23 Jul 2019 15:11:10 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, kernel-team@android.com
Subject: Re: [PATCH RFC 0/4] Add support to directly attach BPF program to
 ftrace
Message-ID: <20190723221108.gamojemj5lorol7k@ast-mbp>
References: <20190710141548.132193-1-joel@joelfernandes.org>
 <20190716205455.iimn3pqpvsc3k4ry@ast-mbp.dhcp.thefacebook.com>
 <20190716213050.GA161922@google.com>
 <20190716222650.tk2coihjtsxszarf@ast-mbp.dhcp.thefacebook.com>
 <20190716224150.GC172157@google.com>
 <20190716235500.GA199237@google.com>
 <20190717012406.lugqemvubixfdd6v@ast-mbp.dhcp.thefacebook.com>
 <20190717130119.GA138030@google.com>
 <CAADnVQJY_=yeY0C3k1ZKpRFu5oNbB4zhQf5tQnLr=Mi8i6cgeQ@mail.gmail.com>
 <20190718025143.GB153617@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718025143.GB153617@google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 10:51:43PM -0400, Joel Fernandes wrote:
> Hi Alexei,
> 
> On Wed, Jul 17, 2019 at 02:40:42PM -0700, Alexei Starovoitov wrote:
> > On Wed, Jul 17, 2019 at 6:01 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> > 
> > I trimmed cc. some emails were bouncing.
> 
> Ok, thanks.
> 
> > > > I think allowing one tracepoint and disallowing another is pointless
> > > > from security point of view. Tracing bpf program can do bpf_probe_read
> > > > of anything.
> > >
> > > I think the assumption here is the user controls the program instructions at
> > > runtime, but that's not the case. The BPF program we are loading is not
> > > dynamically generated, it is built at build time and it is loaded from a
> > > secure verified partition, so even though it can do bpf_probe_read, it is
> > > still not something that the user can change.
> > 
> > so you're saying that by having a set of signed bpf programs which
> > instructions are known to be non-malicious and allowed set of tracepoints
> > to attach via selinux whitelist, such setup will be safe?
> > Have you considered how mix and match will behave?
> 
> Do you mean the effect of mixing tracepoints and programs? I have not
> considered this. I am Ok with further enforcing of this (only certain
> tracepoints can be attached to certain programs) if needed. What do
> you think? We could have a new bpf(2) syscall attribute specify which
> tracepoint is expected, or similar.
> 
> I wanted to walk you through our 2 usecases we are working on:

thanks for sharing the use case details. Appreciate it.

> 1. timeinstate: By hooking 2 programs onto sched_switch and cpu_frequency
> tracepoints, we are able to collect CPU power per-UID (specific app). Connor
> O'Brien is working on that.
> 
> 2. inode to file path mapping: By hooking onto VFS tracepoints we are adding to
> the android kernels, we can collect data when the kernel resolves a file path
> to a inode/device number. A BPF map stores the inode/dev number (key) and the
> path (value). We have usecases where we need a high speed lookup of this
> without having to scan all the files in the filesystem.

Can you share the link to vfs tracepoints you're adding?
Sounds like you're not going to attempt to upstream them knowing
Al's stance towards them?
May be there is a way we can do the feature you need, but w/o tracepoints?

> For the first usecase, the BPF program will be loaded and attached to the
> scheduler and cpufreq tracepoints at boot time and will stay attached
> forever.  This is why I was saying having a daemon to stay alive all the time
> is pointless. However, if since you are completely against using tracefs
> which it sounds like, then we can do a daemon that is always alive.

As I said earlier this use case can be solved by pinning raw_tp object
into bpffs. Such patches are welcomed.

> For the second usecase, the program attach is needed on-demand unlike the
> first usecase, and then after the usecase completes, it is detached to avoid
> overhead.
> 
> For the second usecase, privacy is important and we want the data to not be
> available to any process. So we want to make sure only selected processes can
> attach to that tracepoint. This is the reason why I was doing working on
> these patches which use the tracefs as well, since we get that level of
> control.

It's hard to recommend anything w/o seeing the actual tracepoints you're adding
to vfs and type of data bpf program extracts from there.
Sounds like it's some sort of cache of inode->file name ?
If so, why is it privacy related?

