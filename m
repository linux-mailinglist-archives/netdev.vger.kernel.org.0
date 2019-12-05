Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA62113BE3
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 07:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfLEGob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 01:44:31 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46239 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfLEGob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 01:44:31 -0500
Received: by mail-pl1-f195.google.com with SMTP id k20so810629pll.13;
        Wed, 04 Dec 2019 22:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JJ+TzLHDcOe2a66UupATU7so/38ErY2rdjO/+4opCJ8=;
        b=eTraJXdW2kApg87qYZLb4fC25HuA9TjwSaOYN8nQF7Tvi0UgY+j0DXM2E2uul9Lbms
         tRjobL19iNlCz2QKg1xolLERyIFEsN4I6XRh/D3LStIkFVU7Ed8MPF8HW8lSgTafPjJQ
         U47Psc0jV8my1W262rMB8o2vhfSSlizhaZtV8SSgL37Mp2C4nnRf5nwAazirOogox/V9
         6NTg/wR8siO9hKTLmc1b2U7M4ffQBGD+lZG0eGJFKuIxp1yCYStbzkW+7AUa6G4Ql7q9
         v2J2LirMS1reO1KSbQfOsVIZ7/GNoBHoj1ppvln4gLD3m8J/VNBiQM3xPOAAJ5XrE52A
         9qBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JJ+TzLHDcOe2a66UupATU7so/38ErY2rdjO/+4opCJ8=;
        b=rBjYq4JSjsgXOA8LkrBMtc0x+IdkNr3sLWd6liHYPuS/pOwDzExnlzgKiGpHgF3HuR
         +6AMuJIMh3Ym6VvlY6poFxHN4b89BBNKoS09BVbX8T6kp6CRx2IP0CTpWSjMLQyZnXfv
         qPSMYOmG6Xf7/pazqHsYIRFUxU7Zzr8pjAGksAutdbopxfZzZOTYL6cFxiCmuFD+EPgB
         FjWP12kmnQfjurkU/E4S+roC8m6ExQ9b2lbRVTio0Txb80wKRWja3hdcWzjmepoWEZ2L
         hoSxDTh8kwtqmtAgZ4ZTJLTxPhSTJrnDgPyr2GiTEnJi3gg3hIfggP7SFWH3v8Bsl3M3
         9/9g==
X-Gm-Message-State: APjAAAUCbw4wCskKtL8Ct6F5brxPYb6tKaPOOAraCKoanMDn6POR/eD6
        /DiDxp+lD4pLB+lgj4mOmmqWC6TC
X-Google-Smtp-Source: APXvYqyu2Ew8K13y/YP8AGp/vwyfBJ54TZnh5mTZaeM5N4E4MJx/JUNlDE5lbqP11aA7HVdWnvD7xQ==
X-Received: by 2002:a17:902:7898:: with SMTP id q24mr7359712pll.23.1575528269852;
        Wed, 04 Dec 2019 22:44:29 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::f3d1])
        by smtp.gmail.com with ESMTPSA id t8sm11334464pfq.92.2019.12.04.22.44.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Dec 2019 22:44:29 -0800 (PST)
Date:   Wed, 4 Dec 2019 22:44:26 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCHv4 0/6] perf/bpftool: Allow to link libbpf dynamically
Message-ID: <20191205064424.uzqopwr3kehfsabn@ast-mbp.dhcp.thefacebook.com>
References: <87wobepgy0.fsf@toke.dk>
 <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
 <CAEf4BzZ+0XpH_zJ0P78vjzmFAH3kGZ21w3-LcSEG=B=+ZQWJ=w@mail.gmail.com>
 <20191204135405.3ffb9ad6@cakuba.netronome.com>
 <20191204233948.opvlopjkxe5o66lr@ast-mbp.dhcp.thefacebook.com>
 <20191204162348.49be5f1b@cakuba.netronome.com>
 <20191205010930.izft6kv5xlnejgog@ast-mbp.dhcp.thefacebook.com>
 <20191204181028.6cdb40d4@cakuba.netronome.com>
 <20191205031718.ax46kfv55zauuopt@ast-mbp.dhcp.thefacebook.com>
 <20191204202638.3b0b0c8c@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204202638.3b0b0c8c@cakuba.netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 04, 2019 at 08:26:38PM -0800, Jakub Kicinski wrote:
> On Wed, 4 Dec 2019 19:17:20 -0800, Alexei Starovoitov wrote:
> > On Wed, Dec 04, 2019 at 06:10:28PM -0800, Jakub Kicinski wrote:
> > > On Wed, 4 Dec 2019 17:09:32 -0800, Alexei Starovoitov wrote:  
> > > > On Wed, Dec 04, 2019 at 04:23:48PM -0800, Jakub Kicinski wrote:  
> > > > > On Wed, 4 Dec 2019 15:39:49 -0800, Alexei Starovoitov wrote:    
> > > > > > > Agreed. Having libbpf on GH is definitely useful today, but one can hope
> > > > > > > a day will come when distroes will get up to speed on packaging libbpf,
> > > > > > > and perhaps we can retire it? Maybe 2, 3 years from now? Putting
> > > > > > > bpftool in the same boat is just more baggage.      
> > > > > > 
> > > > > > Distros should be packaging libbpf and bpftool from single repo on github.
> > > > > > Kernel tree is for packaging kernel.    
> > > > > 
> > > > > Okay, single repo on GitHub:
> > > > > 
> > > > > https://github.com/torvalds/linux    
> > > > 
> > > > and how will you git submodule only libbpf part of kernel github into bcc
> > > > and other projects?  
> > > 
> > > Why does bcc have to submodule libbpf? Is it in a "special
> > > relationship" with libbpf as well? 
> > > 
> > > dnf/apt install libbpf
> > > 
> > > Or rather:
> > > 
> > > dnf/apt install bcc
> > > 
> > > since BCC's user doesn't care about dependencies. The day distroes
> > > started packaging libbpf and bpftool the game has changed.  
> > 
> > have you ever built bcc ? or bpftrace?
> > I'm not sure how to answer such 'suggestion'.
> 
> Perhaps someone else has more patience to explain it - why bcc can't
> just use binary libbpf distribution (static lib + headers) and link
> against it like it links against other libraries?

why systemd considered using libbpf as submodule ?
When project like bcc needs to run on different distros and
different versions of the same distro such project cannot force users
to upgrade core libraries to get features that project might need.
libbpf is far from stability of libc, libmnl, libelf.
There are mature libraries and actively developed libraries.
libbpf is at its infancy stage. We're trying hard to be stable,
but accumulated baggage is already huge and it is slowing us down.
systemd is considering to use libbpf without being submodule too,
but it's mainly driven by systemd's CI limitations and nothing else.

> Share with us what you dislike about iproute2 so we can fix it. 

let's start with 24-hr review cycle that we're trying hard to keep in bpf/net
trees. Can you help with 24-hr review in iproute2 ?

> Because libbpf just now entered the distroes, and you suggested the
> distroes use the GH repo, so sure now it's wasted work.

You got the timeline wrong. GH repo was done before some distros started
packaging libbpf. libbpf is still not available in centos/rhel afaik.
But bcc and bpftrace need to work there. Answer? submodules...

> > Are you trolling? Do you understand why __ is there?
> 
> Not the point. Tell me how the coding style is different. The
> underscores is the only thing I could think of that's not common 
> in the kernel.

we don't actively enforce xmas tree :)

> But master of libbpf must have all features to test the kernel with,
> right? So how do we branch of a release in the middle? That's only
> possible if kernel cycle happens to not have had any features that
> required libbpf yet?

libbpf rate of changes is higher than bpf bits of the kernel.
Amount of patches per week is higher as well.
Something like skeleton work might warrant independent release just
to get into the hands of people faster. Why wait 8 weeks for kernel
release? No reason.

> Or are you thinking 3 tier branching where we'd branch off libbpf
> release, say 2.6.0 that corresponds to kernel X, 

libbpf does not correspond to kernel.
All libbpf releases must work with any kernel.

> but it wouldn't be a
> stable-only release, and we can still backport features added in kernel
> X + 1 cycle, features which don't require kernel support, and release
> libbpf 2.7.0?

Say libbpf 0.1 was developed during kernel 5.4.
We can 'backport' all libbpf features from kernel tree 5.5 into libbpf 0.1+
and that libbpf 0.1+ must work with kernels 5.4 and 5.5.
That is what existing github/libbpf CI is testing.

