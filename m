Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB5F10A673
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKZWRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:17:40 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40353 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfKZWRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:17:40 -0500
Received: by mail-qk1-f194.google.com with SMTP id a137so15851536qkc.7;
        Tue, 26 Nov 2019 14:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=f2Hd5WjuiqvQta5/vQm1F0KJvxXJh/55GVYUerwghhA=;
        b=BFCSVBGxPSAXY1PzblBrY0hRc5cUv1K4LLgzlFF8QCrnOpKydk05DBguKoBV/ZMbWA
         veGpy/TT5IwMgXJmLyn4GBUL61P2cLwA8BMmIeUfP5bLe34bW1hXkDkLTZ9SCI9yjovC
         N3IUJRCetOVp/rcmThFTk3/C+AikbOyGsFNeoAQHH6Q35QCgnJvnQH2moUccnfsNirB+
         W8qS2G7YeE0ovp8c6mSo881u17FdegIceCoMITHiSOOlsQzQGpWxmJDsA6UKR/p/TD6X
         xZu7VxHFEBRHW2J/s4oRyHqIMOnVBQot6+tcpTPIsD4JcbVKcxqD2+wPhcmsEeJod9hM
         yYcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=f2Hd5WjuiqvQta5/vQm1F0KJvxXJh/55GVYUerwghhA=;
        b=Fio5MvFbLrLO8o83gD3osq7MP0APbVNQXjREnEUqr0s5xdJfH22igIcYzb0ZAckMfg
         Fd/YF3cO7pYkjAiyQvpjMrPF1acEDEbEUTMvF3W8fP/zU0cVlH6jA0W8moZevSZ2fMY4
         5cGrUs5iZuF73SJOUs11axNf10pEG6ytMXQWuRKwjM+utFFMwdU10rjbQJnGfuXcQY5q
         BIE+z8bAqGrbgyX5gr6oRO9CExvgaIOhK2/sZg6hMIrzTpAZeZCebj7BH5YFgXopZVqP
         Z2LlcUSmwKFUQFjFMl5aFG5al9D0O5+jXWR2StLh1ma6GNRTs5ZpipVFGu8ekGE3zHLE
         p4eg==
X-Gm-Message-State: APjAAAU5qKN9SoPSEZsEX+gnY9yYJpmRqgr5zhKqrTjGmNGZhngw7EWK
        iywb3WWa5F2tUUN59K+Ij8A=
X-Google-Smtp-Source: APXvYqz/dH81SKnb/fSKY73zqbv+py8tqrQNnYWeHvfNmpY3Sfg7fynXtMdCo8qK9CCanoHIdo826Q==
X-Received: by 2002:a37:bc81:: with SMTP id m123mr866276qkf.358.1574806657302;
        Tue, 26 Nov 2019 14:17:37 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id d6sm6596208qtn.16.2019.11.26.14.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 14:17:36 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id D2F2840D3E; Tue, 26 Nov 2019 19:17:33 -0300 (-03)
Date:   Tue, 26 Nov 2019 19:17:33 -0300
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
Message-ID: <20191126221733.GB22719@kernel.org>
References: <20191126151045.GB19483@kernel.org>
 <20191126154836.GC19483@kernel.org>
 <87imn6y4n9.fsf@toke.dk>
 <20191126183451.GC29071@kernel.org>
 <87d0dexyij.fsf@toke.dk>
 <20191126190450.GD29071@kernel.org>
 <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
 <20191126221018.GA22719@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191126221018.GA22719@kernel.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Nov 26, 2019 at 07:10:18PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Nov 26, 2019 at 02:05:41PM -0800, Andrii Nakryiko escreveu:
> > On Tue, Nov 26, 2019 at 11:12 AM Arnaldo Carvalho de Melo
> > <arnaldo.melo@gmail.com> wrote:
> > >
> > > Em Tue, Nov 26, 2019 at 07:50:44PM +0100, Toke Høiland-Jørgensen escreveu:
> > > > Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> writes:
> > > >
> > > > > Em Tue, Nov 26, 2019 at 05:38:18PM +0100, Toke Høiland-Jørgensen escreveu:
> > > > >> Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> writes:
> > > > >>
> > > > >> > Em Tue, Nov 26, 2019 at 12:10:45PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > > >> >> Hi guys,
> > > > >> >>
> > > > >> >>    While merging perf/core with mainline I found the problem below for
> > > > >> >> which I'm adding this patch to my perf/core branch, that soon will go
> > > > >> >> Ingo's way, etc. Please let me know if you think this should be handled
> > > > >> >> some other way,
> > > > >> >
> > > > >> > This is still not enough, fails building in a container where all we
> > > > >> > have is the tarball contents, will try to fix later.
> > > > >>
> > > > >> Wouldn't the right thing to do not be to just run the script, and then
> > > > >> put the generated bpf_helper_defs.h into the tarball?
> > >
> > > > > I would rather continue just running tar and have the build process
> > > > > in-tree or outside be the same.
> > > >
> > > > Hmm, right. Well that Python script basically just parses
> > > > include/uapi/linux/bpf.h; and it can be given the path of that file with
> > > > the --filename argument. So as long as that file is present, it should
> > > > be possible to make it work, I guess?
> > >
> > > > However, isn't the point of the tarball to make a "stand-alone" source
> > > > distribution?
> > >
> > > Yes, it is, and as far as possible without any prep, just include the
> > > in-source tree files needed to build it.
> > >
> > > > I'd argue that it makes more sense to just include the
> > > > generated header, then: The point of the Python script is specifically
> > > > to extract the latest version of the helper definitions from the kernel
> > > > source tree. And if you're "freezing" a version into a tarball, doesn't
> > > > it make more sense to also freeze the list of BPF helpers?
> > >
> > > Your suggestion may well even be the only solution, as older systems
> > > don't have python3, and that script requires it :-\
> > >
> > > Some containers were showing this:
> > >
> > > /bin/sh: 1: /git/linux/scripts/bpf_helpers_doc.py: not found
> > > Makefile:184: recipe for target 'bpf_helper_defs.h' failed
> > > make[3]: *** [bpf_helper_defs.h] Error 127
> > > make[3]: *** Deleting file 'bpf_helper_defs.h'
> > > Makefile.perf:778: recipe for target '/tmp/build/perf/libbpf.a' failed
> > >
> > > That "not found" doesn't mean what it looks from staring at the above,
> > > its just that:
> > >
> > > nobody@1fb841e33ba3:/tmp/perf-5.4.0$ head -1 /tmp/perf-5.4.0/scripts/bpf_helpers_doc.py
> > > #!/usr/bin/python3
> > > nobody@1fb841e33ba3:/tmp/perf-5.4.0$ ls -la /usr/bin/python3
> > > ls: cannot access /usr/bin/python3: No such file or directory
> > > nobody@1fb841e33ba3:/tmp/perf-5.4.0$
> > >
> > > So, for now, I'll keep my fix and start modifying the containers where
> > > this fails and disable testing libbpf/perf integration with BPF on those
> > > containers :-\
> > 
> > I don't think there is anything Python3-specific in that script. I
> > changed first line to
> > 
> > #!/usr/bin/env python
> > 
> > and it worked just fine. Do you mind adding this fix and make those
> > older containers happy(-ier?).
> 
> I'll try it, was trying the other way around, i.e. adding python3 to
> those containers and they got happier, but fatter, so I'll remove that
> and try your way, thanks!
> 
> I didn't try it that way due to what comes right after the interpreter
> line:
> 
> #!/usr/bin/python3
> # SPDX-License-Identifier: GPL-2.0-only
> #
> # Copyright (C) 2018-2019 Netronome Systems, Inc.
> 
> # In case user attempts to run with Python 2.
> from __future__ import print_function

And that is why I think you got it working, that script uses things
like:

        print('Parsed description of %d helper function(s)' % len(self.helpers),
              file=sys.stderr)

That python2 thinks its science fiction, what tuple is that? Can't
understand, print isn't a function back then.

https://sebastianraschka.com/Articles/2014_python_2_3_key_diff.html#the-print-function

I've been adding python3  to where it is available and not yet in the
container images, most are working after that, some don't need because
they need other packages for BPF to work and those are not available, so
nevermind, lets have just the fix I provided, I'll add python3 and life
goes on.

- Arnaldo
