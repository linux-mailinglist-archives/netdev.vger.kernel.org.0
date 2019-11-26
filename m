Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC4710A6AB
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfKZWim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:38:42 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41182 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfKZWim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:38:42 -0500
Received: by mail-qt1-f195.google.com with SMTP id 59so17729654qtg.8;
        Tue, 26 Nov 2019 14:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Cuckp8xLFQCsFXXaZnTlFMiRntZZABnlhdtpodYvu3Q=;
        b=owN/OM/FYLq33X8taJaKH7rWaqSx3+Qpg/qjnQMMpmIyUj2rnpTJdJBLvlcrpwjh6l
         6k0ToHrP4dbFBaiyoWDIQHtMLWHGhM6t5giRZj0vngYptIbGFSs/G6xc2IFmrE8x9Pv8
         BlhU5zgiDDT5oUjsbQkmeDNpkA1FsKtf1vgzOxIKr4wjkUoEiPoSj2xr+DH5pjghIThX
         ORteHFjY/RL6nozvpPSkR6kgpWOFcDfoMd0mju57w3Q2T+8qUk7uC7K07pyd4RkgIm4w
         dPoaF2eejwRp36H50n3DI4Lq5v5CiGkyXjpTOIPoD873MMFGeg+EgSAs3I2yWFB6P65q
         eDag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Cuckp8xLFQCsFXXaZnTlFMiRntZZABnlhdtpodYvu3Q=;
        b=PaP0UllNTlplvWWcr2Jbif7/ktac6kaDWtNLUaKkQCm/SFPZhLGkLOfn7owOEc4lvz
         Y87R92PWXu+GCAPq/bPTBylCtRnTh70D5kwkcedYQRC6a+7sgBqkUXozcH3Fd/rcuVCR
         bf9LnFAIMjTgn+mk7UhgDmtg5Xoho604neNmLhON7J1scx9FtBjwx9ZkVaAqseEcGOl/
         d4urpJt0FWJbpd2gPqS2eU1rxrHQGUd6d7cDJV/pWdM5xkC9gVmLp0MnATIJwaV2/hoY
         gTW3oe5YQdtA4QiqgvBky9Epah6CvQ56mJMWNQispa0ILpLjEiS28G99dVZ8FjYine2v
         IWGA==
X-Gm-Message-State: APjAAAUoCNa4T35eR2XzLz7OeIBpXLAhuQuCJRnnOReL8IEroNnsQb3F
        hk0myJZhOSSSJDHCdhZ+wg2nurQv6z2QkAwSXVU=
X-Google-Smtp-Source: APXvYqxHNDC9Cz2So5gx4c1a1krT1PGyI05u9GQYoWmBrpnFFWa+aXYO2juHVa1LyxgZVtaqoZpTvMqgW9cr3c8CfDY=
X-Received: by 2002:ac8:5457:: with SMTP id d23mr3975020qtq.93.1574807920220;
 Tue, 26 Nov 2019 14:38:40 -0800 (PST)
MIME-Version: 1.0
References: <20191126151045.GB19483@kernel.org> <20191126154836.GC19483@kernel.org>
 <87imn6y4n9.fsf@toke.dk> <20191126183451.GC29071@kernel.org>
 <87d0dexyij.fsf@toke.dk> <20191126190450.GD29071@kernel.org>
 <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
 <20191126221018.GA22719@kernel.org> <20191126221733.GB22719@kernel.org>
In-Reply-To: <20191126221733.GB22719@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 Nov 2019 14:38:29 -0800
Message-ID: <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 2:17 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Tue, Nov 26, 2019 at 07:10:18PM -0300, Arnaldo Carvalho de Melo escrev=
eu:
> > Em Tue, Nov 26, 2019 at 02:05:41PM -0800, Andrii Nakryiko escreveu:
> > > On Tue, Nov 26, 2019 at 11:12 AM Arnaldo Carvalho de Melo
> > > <arnaldo.melo@gmail.com> wrote:
> > > >
> > > > Em Tue, Nov 26, 2019 at 07:50:44PM +0100, Toke H=C3=B8iland-J=C3=B8=
rgensen escreveu:
> > > > > Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> writes:
> > > > >
> > > > > > Em Tue, Nov 26, 2019 at 05:38:18PM +0100, Toke H=C3=B8iland-J=
=C3=B8rgensen escreveu:
> > > > > >> Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> writes:
> > > > > >>
> > > > > >> > Em Tue, Nov 26, 2019 at 12:10:45PM -0300, Arnaldo Carvalho d=
e Melo escreveu:
> > > > > >> >> Hi guys,
> > > > > >> >>
> > > > > >> >>    While merging perf/core with mainline I found the proble=
m below for
> > > > > >> >> which I'm adding this patch to my perf/core branch, that so=
on will go
> > > > > >> >> Ingo's way, etc. Please let me know if you think this shoul=
d be handled
> > > > > >> >> some other way,
> > > > > >> >
> > > > > >> > This is still not enough, fails building in a container wher=
e all we
> > > > > >> > have is the tarball contents, will try to fix later.
> > > > > >>
> > > > > >> Wouldn't the right thing to do not be to just run the script, =
and then
> > > > > >> put the generated bpf_helper_defs.h into the tarball?
> > > >
> > > > > > I would rather continue just running tar and have the build pro=
cess
> > > > > > in-tree or outside be the same.
> > > > >
> > > > > Hmm, right. Well that Python script basically just parses
> > > > > include/uapi/linux/bpf.h; and it can be given the path of that fi=
le with
> > > > > the --filename argument. So as long as that file is present, it s=
hould
> > > > > be possible to make it work, I guess?
> > > >
> > > > > However, isn't the point of the tarball to make a "stand-alone" s=
ource
> > > > > distribution?
> > > >
> > > > Yes, it is, and as far as possible without any prep, just include t=
he
> > > > in-source tree files needed to build it.
> > > >
> > > > > I'd argue that it makes more sense to just include the
> > > > > generated header, then: The point of the Python script is specifi=
cally
> > > > > to extract the latest version of the helper definitions from the =
kernel
> > > > > source tree. And if you're "freezing" a version into a tarball, d=
oesn't
> > > > > it make more sense to also freeze the list of BPF helpers?
> > > >
> > > > Your suggestion may well even be the only solution, as older system=
s
> > > > don't have python3, and that script requires it :-\
> > > >
> > > > Some containers were showing this:
> > > >
> > > > /bin/sh: 1: /git/linux/scripts/bpf_helpers_doc.py: not found
> > > > Makefile:184: recipe for target 'bpf_helper_defs.h' failed
> > > > make[3]: *** [bpf_helper_defs.h] Error 127
> > > > make[3]: *** Deleting file 'bpf_helper_defs.h'
> > > > Makefile.perf:778: recipe for target '/tmp/build/perf/libbpf.a' fai=
led
> > > >
> > > > That "not found" doesn't mean what it looks from staring at the abo=
ve,
> > > > its just that:
> > > >
> > > > nobody@1fb841e33ba3:/tmp/perf-5.4.0$ head -1 /tmp/perf-5.4.0/script=
s/bpf_helpers_doc.py
> > > > #!/usr/bin/python3
> > > > nobody@1fb841e33ba3:/tmp/perf-5.4.0$ ls -la /usr/bin/python3
> > > > ls: cannot access /usr/bin/python3: No such file or directory
> > > > nobody@1fb841e33ba3:/tmp/perf-5.4.0$
> > > >
> > > > So, for now, I'll keep my fix and start modifying the containers wh=
ere
> > > > this fails and disable testing libbpf/perf integration with BPF on =
those
> > > > containers :-\
> > >
> > > I don't think there is anything Python3-specific in that script. I
> > > changed first line to
> > >
> > > #!/usr/bin/env python
> > >
> > > and it worked just fine. Do you mind adding this fix and make those
> > > older containers happy(-ier?).
> >
> > I'll try it, was trying the other way around, i.e. adding python3 to
> > those containers and they got happier, but fatter, so I'll remove that
> > and try your way, thanks!
> >
> > I didn't try it that way due to what comes right after the interpreter
> > line:
> >
> > #!/usr/bin/python3
> > # SPDX-License-Identifier: GPL-2.0-only
> > #
> > # Copyright (C) 2018-2019 Netronome Systems, Inc.
> >
> > # In case user attempts to run with Python 2.
> > from __future__ import print_function
>
> And that is why I think you got it working, that script uses things
> like:
>
>         print('Parsed description of %d helper function(s)' % len(self.he=
lpers),
>               file=3Dsys.stderr)
>
> That python2 thinks its science fiction, what tuple is that? Can't
> understand, print isn't a function back then.

Not a Python expert (or even regular user), but quick googling showed
that this import is the way to go to use Python3 semantics of print
within Python2, so seems like that's fine. But maybe Quentin has
anything to say about this.


>
> https://sebastianraschka.com/Articles/2014_python_2_3_key_diff.html#the-p=
rint-function
>
> I've been adding python3  to where it is available and not yet in the
> container images, most are working after that, some don't need because
> they need other packages for BPF to work and those are not available, so
> nevermind, lets have just the fix I provided, I'll add python3 and life
> goes on.
>
> - Arnaldo
