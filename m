Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB069113A48
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 04:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfLEDRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 22:17:25 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42082 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbfLEDRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 22:17:25 -0500
Received: by mail-pl1-f194.google.com with SMTP id x13so604941plr.9;
        Wed, 04 Dec 2019 19:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zLpHyfDlF7oQvCvT4lYlP0xSLBE9XB3er9Iyz3kTfxs=;
        b=fWnVCCFOkDeBoEPZ4BsVcKyU4UgXHt+5LD09GawCHJ+CpHS2M8OqoXDHqH48slnSMQ
         AcXyOuR/f2qRCdXcVoDDQJjChjZ6kn187QJXKpUb47nkGO9UwfvmGHG4efEOf8dZpwZV
         Vu719TqWqWvPZiVyB/pHimURNPG5EZFgxg9InXNchwcNFTrc6DpW+1Aw/lorprKli7yo
         32sS8P/hy4Bln43s2hBTlpIAGWntvzZX9b6+UpYzEVsiDhyvZUKaF20FITVlNV0BRDLQ
         XVtSlx/+bbwgucaTj0Xvr9/2FSlpgpRr654jdcXwWOsl1ZBjbRxiRH/c7ZRegdMyAdwM
         KDjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zLpHyfDlF7oQvCvT4lYlP0xSLBE9XB3er9Iyz3kTfxs=;
        b=Ehkw65bxj8NJTSlIF7chzJ0CAwitE4LAhvjPyHdfG4FQnrZP80QmbewsN4F9ju+tCw
         7klyfvUEmZMkoPea3bx48qVOJv9Bcx4L+TITdPmwr1Sk/lnCOoSv0s02DVR0h1HMqmtK
         5duTOHZTGGNp6ud/UTIY4JEU1rTu6hnh6Rqb+EIPeaP1+O5REfgk8SdynvjLcM5OhKSK
         tWBJ0ikyRWu25K2xhFAz3SRk3JuzbrS0mL2vDIBDVNeN3J28qdIqg+Yr7NFGuL8dLtYM
         FLnSzz7PBwxew09HQ0ZA4nBTzRAayUNd00F7wX/02BkNDwefv22FDSnr08uBl6chnXac
         hgeg==
X-Gm-Message-State: APjAAAUU0Cui/+vztDpvsK/jaJ+pI7xp/8GqGmy9pxMyA76M9cGlAyyu
        fy+Tj9uywwgJM74FAjHuFOw=
X-Google-Smtp-Source: APXvYqzmJ9DBP5chyXAdhaajV8T/LkxZLnhB5DjwpqMtcFnQ/T53yodnmDxLbLnHHjcTU1sHLLEyqg==
X-Received: by 2002:a17:902:b70e:: with SMTP id d14mr6402427pls.51.1575515843852;
        Wed, 04 Dec 2019 19:17:23 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::f9fe])
        by smtp.gmail.com with ESMTPSA id b16sm9209616pfo.64.2019.12.04.19.17.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Dec 2019 19:17:23 -0800 (PST)
Date:   Wed, 4 Dec 2019 19:17:20 -0800
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
Message-ID: <20191205031718.ax46kfv55zauuopt@ast-mbp.dhcp.thefacebook.com>
References: <20191202131847.30837-1-jolsa@kernel.org>
 <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com>
 <87wobepgy0.fsf@toke.dk>
 <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
 <CAEf4BzZ+0XpH_zJ0P78vjzmFAH3kGZ21w3-LcSEG=B=+ZQWJ=w@mail.gmail.com>
 <20191204135405.3ffb9ad6@cakuba.netronome.com>
 <20191204233948.opvlopjkxe5o66lr@ast-mbp.dhcp.thefacebook.com>
 <20191204162348.49be5f1b@cakuba.netronome.com>
 <20191205010930.izft6kv5xlnejgog@ast-mbp.dhcp.thefacebook.com>
 <20191204181028.6cdb40d4@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204181028.6cdb40d4@cakuba.netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 04, 2019 at 06:10:28PM -0800, Jakub Kicinski wrote:
> On Wed, 4 Dec 2019 17:09:32 -0800, Alexei Starovoitov wrote:
> > On Wed, Dec 04, 2019 at 04:23:48PM -0800, Jakub Kicinski wrote:
> > > On Wed, 4 Dec 2019 15:39:49 -0800, Alexei Starovoitov wrote:  
> > > > > Agreed. Having libbpf on GH is definitely useful today, but one can hope
> > > > > a day will come when distroes will get up to speed on packaging libbpf,
> > > > > and perhaps we can retire it? Maybe 2, 3 years from now? Putting
> > > > > bpftool in the same boat is just more baggage.    
> > > > 
> > > > Distros should be packaging libbpf and bpftool from single repo on github.
> > > > Kernel tree is for packaging kernel.  
> > > 
> > > Okay, single repo on GitHub:
> > > 
> > > https://github.com/torvalds/linux  
> > 
> > and how will you git submodule only libbpf part of kernel github into bcc
> > and other projects?
> 
> Why does bcc have to submodule libbpf? Is it in a "special
> relationship" with libbpf as well? 
> 
> dnf/apt install libbpf
> 
> Or rather:
> 
> dnf/apt install bcc
> 
> since BCC's user doesn't care about dependencies. The day distroes
> started packaging libbpf and bpftool the game has changed.

have you ever built bcc ? or bpftrace?
I'm not sure how to answer such 'suggestion'.

> Please accept iproute2 as an example of a user space toolset closely
> related to the kernel. If kernel release model and process made no
> sense in user space, why do iproute2s developers continue to follow it
> for years? 

imo iproute2 is an example how things should not be run.
But that's a very different topic.

> > Packaging is different.
> 
> There are mostly disadvantages, but the process should be well known.
> perf has been packaged for years.

perf was initially seen as something that should match kernel one to one.
yet it diverged over years. I think it's a counter example.

> What do you mean? I've sure as hell sent patches to net with Fixes tags

which was complete waste of time for people who were sending these
patches, for maintainers who applied them and for all stables folks
who carried them into kernel stable releases.
Not a single libbpf build was made out of those sources.

> S-o-B and all that jazz for libbpf and bpftool.

Many open source projects use SOB. It's not kernel specific.

> 
> > Even coding style is different.
> 
> Is it? You mean the damn underscores people are making fun of? :/

Are you trolling? Do you understand why __ is there?

> libbpf doesn't have a roadmap either, 

I think you're contrasting that with kernel and saying
that kernel has a roadmap ? What is kernel roadmap?

> it's not really a full-on project
> on its own. What's 0.1.0 gonna be?

whenever this bpf community decides to call it 0.1.0.

> Besides stuff lands in libbpf before it hits a major kernel release.
> So how are you gonna make libbpf releases independently from kernel
> ones? What if a feature gets a last minute revert in the kernel and it's
> in libbpf's ABI?

You mean when kernel gets new feature, then libbpf gets new feature, then
libbpf is released, but then kernel feature is reverted? Obviously we should
avoid making a libbpf release that relies on kernel features that didn't reach
the mainline. Yet there could be plenty of reasons why making libbpf release in
the middle of kernel development cycle makes perfect sense.

Also reaching Linus's tree in rc1 is also not a guarantee of non-revert. Yet we
release libbpf around rc1 because everyone expects bug-fixes after rc1. So it's
an exception that solidifies the rule.

> > libbpf has to run on all kernels. Newer and older. How do you support
> > that if libbpf is tied with the kernel?
> 
> Say I have built N kernels UM or for a VM, and we have some test
> suite: I pull libbpf, build it, run its tests. The only difference
> between in tree and out of tree is that "pull libbpf" means pulling
> smaller or larger repo. Doesn't matter that match, it's a low --depth
> local clone.

The expected CI is:
1. pull-req proposed.
2. CI picks it up, builds, run tests.
3. humans see results and land or reject pull-req.
Now try to think through how CI on top of full kernel tree will
be able to pick just the right commits to start build/test cycle.
Is it going to cherry-pick from patchworks? That would be awesome.
Yet intel 0bot results show that it's easier said than done.
I'm not saying it's not possible. Just complex.
If you have cycles to integrate *-next into kernelci.org, please go ahead.

