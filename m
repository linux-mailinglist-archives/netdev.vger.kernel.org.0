Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2A0113AC7
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 05:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfLEE1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 23:27:06 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39083 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbfLEE1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 23:27:06 -0500
Received: by mail-lj1-f194.google.com with SMTP id e10so1875247ljj.6
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 20:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=IkVfhW3J2Ojg/cQ1sCp3mgS439i6j3OWnwWO8MYbCxw=;
        b=NSsYEUAt7gTMqN1+NXjsIlxafwjK69m5mS0tNpnoWfy0UadHmm8CX1gfyuOz7v2Yxz
         kbTNICGwY198z4xMarvH/6E3qlLNzPt0M3bLWDc36QSEXnyzvRmvUS9GbtdwCSNCUwKB
         LqwNK4QR0XMrix+tuXNRqP7+Xlfwq6p6T7TVHRVvBbc9d8jBp2FsbfohKyc8J+6SLqEx
         ipNT+xdBuLAZhFvi762ck9XdKMorIXUMkNKbYT0hTOESKGZD+gW+Kr6o0DDT//sUiEBG
         K9mvLW6W7mAEhzaGPzN8TrezyiZIsFhJB8/GaaQwfj+atxTduv7WgKkc/rcNAuXF0HeI
         u5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=IkVfhW3J2Ojg/cQ1sCp3mgS439i6j3OWnwWO8MYbCxw=;
        b=uFjhKvI4Pfg+r4/0R+1XXAEvhFZqM2FGSodsiYUKgBG+I0EMrh3sHQDlfdGcJmDMxn
         DaFb/qdrKqNzrPApBmJtJlLC0UvdPHlPkkNTMabUS4iKoPQpeG7FRxyWLXwQx8DNvT1A
         P+HB4+KjpGHGwtfDaptQaMQthXtmVeHThxWdg5Wctyqz+7UPPgRtlyDhe+NVyyl6Ohm0
         OMHCSDfpteFf6kDWxTljdIsm/wWi66gqe3wrPJKeRra4dlIkX7pfJuKP4wo3daL1JOs3
         JcKAPfActiUzPVzhftc9vMEwRkpnRVbBklpNIF7h+s+ewWnKQkY0fAxbk4mN8j7GzpRo
         +p7A==
X-Gm-Message-State: APjAAAUpFQBVusGNP9fx09ygNOWBK1C8LIWMAsqOsSQZFu2NgvpDWGsZ
        VBpftw3k06G9n4FPsFGdvi3pxA==
X-Google-Smtp-Source: APXvYqzYoC5e23Lvp57sngoz6hCJxFrnVW1oTzolrTDsnPYZcS0A9POyeQOteXLbSOwjOa9MJqsfdA==
X-Received: by 2002:a2e:9741:: with SMTP id f1mr3881806ljj.123.1575520023206;
        Wed, 04 Dec 2019 20:27:03 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c12sm4251857ljk.77.2019.12.04.20.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 20:27:02 -0800 (PST)
Date:   Wed, 4 Dec 2019 20:26:38 -0800
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
Message-ID: <20191204202638.3b0b0c8c@cakuba.netronome.com>
In-Reply-To: <20191205031718.ax46kfv55zauuopt@ast-mbp.dhcp.thefacebook.com>
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
        <20191205031718.ax46kfv55zauuopt@ast-mbp.dhcp.thefacebook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Dec 2019 19:17:20 -0800, Alexei Starovoitov wrote:
> On Wed, Dec 04, 2019 at 06:10:28PM -0800, Jakub Kicinski wrote:
> > On Wed, 4 Dec 2019 17:09:32 -0800, Alexei Starovoitov wrote: =20
> > > On Wed, Dec 04, 2019 at 04:23:48PM -0800, Jakub Kicinski wrote: =20
> > > > On Wed, 4 Dec 2019 15:39:49 -0800, Alexei Starovoitov wrote:   =20
> > > > > > Agreed. Having libbpf on GH is definitely useful today, but one=
 can hope
> > > > > > a day will come when distroes will get up to speed on packaging=
 libbpf,
> > > > > > and perhaps we can retire it? Maybe 2, 3 years from now? Putting
> > > > > > bpftool in the same boat is just more baggage.     =20
> > > > >=20
> > > > > Distros should be packaging libbpf and bpftool from single repo o=
n github.
> > > > > Kernel tree is for packaging kernel.   =20
> > > >=20
> > > > Okay, single repo on GitHub:
> > > >=20
> > > > https://github.com/torvalds/linux   =20
> > >=20
> > > and how will you git submodule only libbpf part of kernel github into=
 bcc
> > > and other projects? =20
> >=20
> > Why does bcc have to submodule libbpf? Is it in a "special
> > relationship" with libbpf as well?=20
> >=20
> > dnf/apt install libbpf
> >=20
> > Or rather:
> >=20
> > dnf/apt install bcc
> >=20
> > since BCC's user doesn't care about dependencies. The day distroes
> > started packaging libbpf and bpftool the game has changed. =20
>=20
> have you ever built bcc ? or bpftrace?
> I'm not sure how to answer such 'suggestion'.

Perhaps someone else has more patience to explain it - why bcc can't
just use binary libbpf distribution (static lib + headers) and link
against it like it links against other libraries?

> > Please accept iproute2 as an example of a user space toolset closely
> > related to the kernel. If kernel release model and process made no
> > sense in user space, why do iproute2s developers continue to follow it
> > for years?  =20
>=20
> imo iproute2 is an example how things should not be run.
> But that's a very different topic.

Please explain, the topic is how to maintain user space closely related
to the kernel.

Share with us what you dislike about iproute2 so we can fix it. Instead
of adding parts of it to bpftool and then pretending that the API added
to libbpf to facilitate that duplication is some internal bpftool-only
magic which then prevents us from dynamic linking..... =F0=9F=98=A0

> > > Packaging is different. =20
> >=20
> > There are mostly disadvantages, but the process should be well known.
> > perf has been packaged for years. =20
>=20
> perf was initially seen as something that should match kernel one to one.
> yet it diverged over years. I think it's a counter example.
>=20
> > What do you mean? I've sure as hell sent patches to net with Fixes tags=
 =20
>=20
> which was complete waste of time for people who were sending these
> patches, for maintainers who applied them and for all stables folks
> who carried them into kernel stable releases.
> Not a single libbpf build was made out of those sources.

Because libbpf just now entered the distroes, and you suggested the
distroes use the GH repo, so sure now it's wasted work.

IIRC there were bpftool crash fixes which landed in Fedora via stable.

> > > Even coding style is different. =20
> >=20
> > Is it? You mean the damn underscores people are making fun of? :/ =20
>=20
> Are you trolling? Do you understand why __ is there?

Not the point. Tell me how the coding style is different. The
underscores is the only thing I could think of that's not common=20
in the kernel.

> > libbpf doesn't have a roadmap either,  =20
>=20
> I think you're contrasting that with kernel and saying
> that kernel has a roadmap ? What is kernel roadmap?

Kernel road map is the same as libbpf's road map.

> > it's not really a full-on project
> > on its own. What's 0.1.0 gonna be? =20
>=20
> whenever this bpf community decides to call it 0.1.0.
>
> > Besides stuff lands in libbpf before it hits a major kernel release.
> > So how are you gonna make libbpf releases independently from kernel
> > ones? What if a feature gets a last minute revert in the kernel and it's
> > in libbpf's ABI? =20
>=20
> You mean when kernel gets new feature, then libbpf gets new feature, then
> libbpf is released, but then kernel feature is reverted? Obviously we sho=
uld
> avoid making a libbpf release that relies on kernel features that didn't =
reach
> the mainline. Yet there could be plenty of reasons why making libbpf rele=
ase in
> the middle of kernel development cycle makes perfect sense.

But master of libbpf must have all features to test the kernel with,
right? So how do we branch of a release in the middle? That's only
possible if kernel cycle happens to not have had any features that
required libbpf yet?

Or are you thinking 3 tier branching where we'd branch off libbpf
release, say 2.6.0 that corresponds to kernel X, but it wouldn't be a
stable-only release, and we can still backport features added in kernel
X + 1 cycle, features which don't require kernel support, and release
libbpf 2.7.0?

Could work but it'd get tricky, cause if we want to break ABI we'd
actually need 4 tiers. ABI compat, kernel version, feature version,
stable version.

> Also reaching Linus's tree in rc1 is also not a guarantee of non-revert. =
Yet we
> release libbpf around rc1 because everyone expects bug-fixes after rc1.=20

I consider current process to be broken. Hopefully we can improve it.

> So it's an exception that solidifies the rule.
>
> > > libbpf has to run on all kernels. Newer and older. How do you support
> > > that if libbpf is tied with the kernel? =20
> >=20
> > Say I have built N kernels UM or for a VM, and we have some test
> > suite: I pull libbpf, build it, run its tests. The only difference
> > between in tree and out of tree is that "pull libbpf" means pulling
> > smaller or larger repo. Doesn't matter that match, it's a low --depth
> > local clone. =20
>=20
> The expected CI is:
> 1. pull-req proposed.
> 2. CI picks it up, builds, run tests.
> 3. humans see results and land or reject pull-req.
> Now try to think through how CI on top of full kernel tree will
> be able to pick just the right commits to start build/test cycle.
> Is it going to cherry-pick from patchworks? That would be awesome.
> Yet intel 0bot results show that it's easier said than done.
> I'm not saying it's not possible. Just complex.
> If you have cycles to integrate *-next into kernelci.org, please go ahead.

Yes, it is very complex, I know. I've been hacking on something along
those lines for the last few weeks. Hopefully I'll have results at some
point..

First stab is just doing build testing, checkpatch, verify tags etc.
Uploading to patchwork, and sending an email if there were failures.

Even that's not easy as a weekend/evening task :( And it requires a lot
of manual inspection upfront before it's unleashed on the ML, because it
will catch a lot of stupid little stuff and a lot of people will get
grumpy.

We need to modernize the process across the board. I don't think having
zombie read-only repos on GitHub will give contributors confidence so
it's not a step in right direction. We should start from the hard
problem, that is the CI itself.

The problem of correlating user space and kernel patches will have to=20
be solved for netdev, because netdev tests depend on iproute2.
