Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44106113994
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 03:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfLECK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 21:10:57 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37129 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbfLECKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 21:10:55 -0500
Received: by mail-lj1-f193.google.com with SMTP id u17so1638484lja.4
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 18:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=egQHAC9LGSWziTm0H/woVfatmjKm3wVavrNlPWEdRMI=;
        b=XofSFKkOSllLUoMBe9eaClL6WevokUSySklcr6UDDFNdFPn5jonNcDdLZ6vtZsiaPW
         MMacI5WDEx180F9oz82z74SLb+ibSjgzPgcPoO+t0LQf+cKocps4TrygC5xCyGSiu7rB
         UkCUSqdgFVRKxMxRZesJMr8PpWQM2Rk/5Qm0Ngf80t9kPZDdOOto+eqR9tXIe1/kSiTa
         xOUCGBXNIHubCddzRBRMFSPNptOzMFYRzZnmsJVsuGQCUSr9HsuEUVQcVF1D1BzWzSyc
         AGQO3wCriSIFvIIFginuO1P4K8c4ArcwQXc+pFUutBSlc0Kb0Gg/gBgwUVog5GkzLCw6
         JmOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=egQHAC9LGSWziTm0H/woVfatmjKm3wVavrNlPWEdRMI=;
        b=MRJNFMNXMZ7RWyFZRVhN/dphTjoQcovgnxgNnS8SqUn/QDjyLEveA4ARdQMNYGOhnk
         5v5y2qoPZOKfCtHbY3dxMQ3hmEHOn6O/jlEtYXkObFYBqWHaHZCKhH1WkNKaeRA8kgiv
         MfChIH8jifJ3k2HGm6wOJqLumxg+k452M3PzV0lBoDqzo9z/a+cCLMxlQsJGqegCh/Lp
         UMIXR02JNO8+NEE2IHf547MtE4V9xfnSSOL5m3wtPy+hAOhQeeWOKiInpqa9zbfJcXL+
         rBDLujEM56ovgtAL8xhgXzLOb8BDoDcXvyHrFS8wyCZMKs9t2I0CecvsRWb297OfY83p
         WL2w==
X-Gm-Message-State: APjAAAV/buaHpiEyOt2Ea+RAExqWPUL+MkuX3XbQTFOH4Qv1fbzyOF+4
        FCqcSNruGi/yAxGbs1O++wUsPw==
X-Google-Smtp-Source: APXvYqyFCNMBBWVhRhZw0mX9EhZAvAdYRSxxfnI4A/fHOTGj5ylYBNF4aLTfLSS67O71pHuFym0W6Q==
X-Received: by 2002:a2e:91cb:: with SMTP id u11mr1341708ljg.82.1575511852393;
        Wed, 04 Dec 2019 18:10:52 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g5sm4145202lfc.11.2019.12.04.18.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 18:10:52 -0800 (PST)
Date:   Wed, 4 Dec 2019 18:10:28 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
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
Message-ID: <20191204181028.6cdb40d4@cakuba.netronome.com>
In-Reply-To: <20191205010930.izft6kv5xlnejgog@ast-mbp.dhcp.thefacebook.com>
References: <20191202131847.30837-1-jolsa@kernel.org>
        <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com>
        <87wobepgy0.fsf@toke.dk>
        <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
        <CAEf4BzZ+0XpH_zJ0P78vjzmFAH3kGZ21w3-LcSEG=B=+ZQWJ=w@mail.gmail.com>
        <20191204135405.3ffb9ad6@cakuba.netronome.com>
        <20191204233948.opvlopjkxe5o66lr@ast-mbp.dhcp.thefacebook.com>
        <20191204162348.49be5f1b@cakuba.netronome.com>
        <20191205010930.izft6kv5xlnejgog@ast-mbp.dhcp.thefacebook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Dec 2019 17:09:32 -0800, Alexei Starovoitov wrote:
> On Wed, Dec 04, 2019 at 04:23:48PM -0800, Jakub Kicinski wrote:
> > On Wed, 4 Dec 2019 15:39:49 -0800, Alexei Starovoitov wrote:  
> > > > Agreed. Having libbpf on GH is definitely useful today, but one can hope
> > > > a day will come when distroes will get up to speed on packaging libbpf,
> > > > and perhaps we can retire it? Maybe 2, 3 years from now? Putting
> > > > bpftool in the same boat is just more baggage.    
> > > 
> > > Distros should be packaging libbpf and bpftool from single repo on github.
> > > Kernel tree is for packaging kernel.  
> > 
> > Okay, single repo on GitHub:
> > 
> > https://github.com/torvalds/linux  
> 
> and how will you git submodule only libbpf part of kernel github into bcc
> and other projects?

Why does bcc have to submodule libbpf? Is it in a "special
relationship" with libbpf as well? 

dnf/apt install libbpf

Or rather:

dnf/apt install bcc

since BCC's user doesn't care about dependencies. The day distroes
started packaging libbpf and bpftool the game has changed.

> > You also said a few times you don't want to merge fixes into bpf/net.
> > That divergence from kernel development process is worrying.  
> 
> worrying - why? what exactly the concern you see?

First it's still in the tree so it just feels wrong to have the process
fundamentally different for sections of the tree. 

Secondly it's best to stick to the tried and tested processes unless
there's a good and stated reason to diverge.

Now we're neither doing standard user library process nor kernel
process. Both of which must account for stable fixes (Dave explained
the enterprise distro needs in his reply).

> Tying user space release into kernel release and user space process into
> kernel process makes little sense to me.

I'm not saying we can't do user space, but we should pick one.

I have slight preference for kernel process, because it's familiar and
it automatically takes of policy questions, which otherwise consume
developer's time.

Please accept iproute2 as an example of a user space toolset closely
related to the kernel. If kernel release model and process made no
sense in user space, why do iproute2s developers continue to follow it
for years? 

Let's learn from experience :/

> Packaging is different.

There are mostly disadvantages, but the process should be well known.
perf has been packaged for years.

iproute2 sometimes lags behind the upstream, more than perf in my
experience. Also there's rarely a need to update tools closely related
to the kernel without the kernel..

> Compatibility requirements are different.

True.

> CI is different.

Well, hard to argue about things which don't exist :/

> Integration with other projects is different.

IMHO the submodule use case is fading. dnf/apt install, it's just a
normal C library, we've done this for decades.

And there is no submodule need for bpftool, which we are discussing.

> libbpf source code is in the kernel tree only because kernel changes plus
> libbpf changes plus selftests changes come as single patchset. That is really
> the only reason. Packaging scripts, CI scripts, etc should be kept out of
> kernel tree. All that stuff belongs at github/libbpf.
> 
> > None of this makes very much sense to me. We're diverging from well
> > established development practices without as much as a justification.  
> 
> The kernel development process was never used for libbpf.

What do you mean? I've sure as hell sent patches to net with Fixes tags,
S-o-B and all that jazz for libbpf and bpftool.

> Even coding style is different.

Is it? You mean the damn underscores people are making fun of? :/

> I'm puzzled why you think user space
> should be tied to kernel. Everything is so vastly different.

Not what I'm saying, I'm saying either run it as user space project in
separate repos or kernel project.

You're proposing we do both with some syncs and no clear process.

> Some people say that 8 weeks to bump libbpf version is too long.
> Other people say that it's too often.

Those are two conflicting requirements, Alexei, how is breaking apart
from the kernel going to make any difference?

At least kernel gives us this somewhat reasonable 8 week cadence and 
we don't have to ponder whether it should be shorter or longer until
someone presents us with a compelling reason.

> libbpf version numbers != kernel version numbers.

Well, libbpf's numbers are arbitrary, and meaningless. They could as
well be kernel numbers, like they are for bpftool. Or dates.

libbpf doesn't have a roadmap either, it's not really a full-on project
on its own. What's 0.1.0 gonna be? 

Besides stuff lands in libbpf before it hits a major kernel release.
So how are you gonna make libbpf releases independently from kernel
ones? What if a feature gets a last minute revert in the kernel and it's
in libbpf's ABI?

Eh, you're just convincing me it should just stay in the kernel now.

> There is no definition of LTS for libbpf. One day it will be
> and the version of libbpf picked for LTS will likely have
> nothing to do with kernel LTS choices.

Again, libbpf inherits the kernel process so there is LTS process, the
kernel one, and it's taken care of for us by all the existing stable
automation.

By merging everything into -next you're loosing that, with all but a
vague mirage of how there may one day be multiple stable branches..

> libbpf has to run on all kernels. Newer and older. How do you support
> that if libbpf is tied with the kernel?

Say I have built N kernels UM or for a VM, and we have some test
suite: I pull libbpf, build it, run its tests. The only difference
between in tree and out of tree is that "pull libbpf" means pulling
smaller or larger repo. Doesn't matter that match, it's a low --depth
local clone.

Sorry for the long response.
