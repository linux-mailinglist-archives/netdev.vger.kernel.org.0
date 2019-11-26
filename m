Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC02F10A6EB
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 00:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKZXKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 18:10:35 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43978 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfKZXKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 18:10:35 -0500
Received: by mail-pf1-f196.google.com with SMTP id 3so9934986pfb.10
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 15:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=KBpvCHEa5sLELqT+roIOkYleYG/FrG+DhoT0SoH7wto=;
        b=QcqygajnmtxaddE8/+AVs9ixIiq/T+dAFkPCspbbuZ7uTZB05Nwtu5lcic9Sg8WP4R
         Xo+tgNd9z2hVN4Tp1KW/2rr7Kavy4k/VAzPhkgzC6bcYQepqYVBhj//ESPxcNPKBEFe+
         kOHAoPJY+D49wBam22nG743QpapWP8hQmkY3OGJU6cMdmZYEWDvBUcH9Ni6Ymd5lUAeT
         BBwfxcLulCDgZda5ti3fY9z4uFQVbB4DPtgRNvoOD2nzBl5p1Iz4xR4OVya5qAy7k7nQ
         G2mf0521nk7tnXeuWYhRYMvWDjk0j3oC1+9AxnM6w55AsKBFqosPI3nGSp5yn2haHK1z
         WFjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=KBpvCHEa5sLELqT+roIOkYleYG/FrG+DhoT0SoH7wto=;
        b=AVb6S9JtJvQgR+CqPIRJNAxxO/WGVWbzjOiE43ILXv3JFBQYaVnztmiC63SnqD3n3o
         umfA8+hNOfGcm8pPtM2MQsVeZ4vTzZi9hkk0qFXgqbu4PJDdQ2Ndd39iV9BDfKIONCNw
         O9l7gfKtW9+uUrhnnKhXFbW4dkBUAjwpaWj9kw4SLz/dG5FsQOONq/GWAOUIH11QqimH
         loF6DqvltVn5KGQvaCsu46bnK7JfkoVY8NF9FMkeKNDH5Vik8HvbrHvNGES8eNjidzij
         rN86scF54qy4LggNlyFlQu6OgRe77FE4rPt9efDBGObOJnlDyg2HGqvrnh1yKLJ0m86o
         I9/g==
X-Gm-Message-State: APjAAAWHs/2ocWldsWR8im6yYt1xmNga+lRM+n12BF5UWIZN4oZRzBO5
        W4kx1IURcFrwHbpGCygxXZ0VLg==
X-Google-Smtp-Source: APXvYqzBYAFQIZHabnmN7XFlslj/eCfFqTCFvh934/aSie59lir3EYOcytq0kCJwg6n6vjGE1hVHeg==
X-Received: by 2002:a63:190a:: with SMTP id z10mr1111375pgl.153.1574809832264;
        Tue, 26 Nov 2019 15:10:32 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id 206sm15686831pfu.45.2019.11.26.15.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 15:10:31 -0800 (PST)
Date:   Tue, 26 Nov 2019 15:10:30 -0800
From:   Stanislav Fomichev <sdf@fomichev.me>
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
Message-ID: <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net>
References: <20191126151045.GB19483@kernel.org>
 <20191126154836.GC19483@kernel.org>
 <87imn6y4n9.fsf@toke.dk>
 <20191126183451.GC29071@kernel.org>
 <87d0dexyij.fsf@toke.dk>
 <20191126190450.GD29071@kernel.org>
 <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
 <20191126221018.GA22719@kernel.org>
 <20191126221733.GB22719@kernel.org>
 <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26, Andrii Nakryiko wrote:
> On Tue, Nov 26, 2019 at 2:17 PM Arnaldo Carvalho de Melo
> <arnaldo.melo@gmail.com> wrote:
> >
> > Em Tue, Nov 26, 2019 at 07:10:18PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > Em Tue, Nov 26, 2019 at 02:05:41PM -0800, Andrii Nakryiko escreveu:
> > > > On Tue, Nov 26, 2019 at 11:12 AM Arnaldo Carvalho de Melo
> > > > <arnaldo.melo@gmail.com> wrote:
> > > > >
> > > > > Em Tue, Nov 26, 2019 at 07:50:44PM +0100, Toke Høiland-Jørgensen escreveu:
> > > > > > Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> writes:
> > > > > >
> > > > > > > Em Tue, Nov 26, 2019 at 05:38:18PM +0100, Toke Høiland-Jørgensen escreveu:
> > > > > > >> Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> writes:
> > > > > > >>
> > > > > > >> > Em Tue, Nov 26, 2019 at 12:10:45PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > > > > >> >> Hi guys,
> > > > > > >> >>
> > > > > > >> >>    While merging perf/core with mainline I found the problem below for
> > > > > > >> >> which I'm adding this patch to my perf/core branch, that soon will go
> > > > > > >> >> Ingo's way, etc. Please let me know if you think this should be handled
> > > > > > >> >> some other way,
> > > > > > >> >
> > > > > > >> > This is still not enough, fails building in a container where all we
> > > > > > >> > have is the tarball contents, will try to fix later.
> > > > > > >>
> > > > > > >> Wouldn't the right thing to do not be to just run the script, and then
> > > > > > >> put the generated bpf_helper_defs.h into the tarball?
> > > > >
> > > > > > > I would rather continue just running tar and have the build process
> > > > > > > in-tree or outside be the same.
> > > > > >
> > > > > > Hmm, right. Well that Python script basically just parses
> > > > > > include/uapi/linux/bpf.h; and it can be given the path of that file with
> > > > > > the --filename argument. So as long as that file is present, it should
> > > > > > be possible to make it work, I guess?
> > > > >
> > > > > > However, isn't the point of the tarball to make a "stand-alone" source
> > > > > > distribution?
> > > > >
> > > > > Yes, it is, and as far as possible without any prep, just include the
> > > > > in-source tree files needed to build it.
> > > > >
> > > > > > I'd argue that it makes more sense to just include the
> > > > > > generated header, then: The point of the Python script is specifically
> > > > > > to extract the latest version of the helper definitions from the kernel
> > > > > > source tree. And if you're "freezing" a version into a tarball, doesn't
> > > > > > it make more sense to also freeze the list of BPF helpers?
> > > > >
> > > > > Your suggestion may well even be the only solution, as older systems
> > > > > don't have python3, and that script requires it :-\
> > > > >
> > > > > Some containers were showing this:
> > > > >
> > > > > /bin/sh: 1: /git/linux/scripts/bpf_helpers_doc.py: not found
> > > > > Makefile:184: recipe for target 'bpf_helper_defs.h' failed
> > > > > make[3]: *** [bpf_helper_defs.h] Error 127
> > > > > make[3]: *** Deleting file 'bpf_helper_defs.h'
> > > > > Makefile.perf:778: recipe for target '/tmp/build/perf/libbpf.a' failed
> > > > >
> > > > > That "not found" doesn't mean what it looks from staring at the above,
> > > > > its just that:
> > > > >
> > > > > nobody@1fb841e33ba3:/tmp/perf-5.4.0$ head -1 /tmp/perf-5.4.0/scripts/bpf_helpers_doc.py
> > > > > #!/usr/bin/python3
> > > > > nobody@1fb841e33ba3:/tmp/perf-5.4.0$ ls -la /usr/bin/python3
> > > > > ls: cannot access /usr/bin/python3: No such file or directory
> > > > > nobody@1fb841e33ba3:/tmp/perf-5.4.0$
> > > > >
> > > > > So, for now, I'll keep my fix and start modifying the containers where
> > > > > this fails and disable testing libbpf/perf integration with BPF on those
> > > > > containers :-\
> > > >
> > > > I don't think there is anything Python3-specific in that script. I
> > > > changed first line to
> > > >
> > > > #!/usr/bin/env python
> > > >
> > > > and it worked just fine. Do you mind adding this fix and make those
> > > > older containers happy(-ier?).
> > >
> > > I'll try it, was trying the other way around, i.e. adding python3 to
> > > those containers and they got happier, but fatter, so I'll remove that
> > > and try your way, thanks!
> > >
> > > I didn't try it that way due to what comes right after the interpreter
> > > line:
> > >
> > > #!/usr/bin/python3
> > > # SPDX-License-Identifier: GPL-2.0-only
> > > #
> > > # Copyright (C) 2018-2019 Netronome Systems, Inc.
> > >
> > > # In case user attempts to run with Python 2.
> > > from __future__ import print_function
> >
> > And that is why I think you got it working, that script uses things
> > like:
> >
> >         print('Parsed description of %d helper function(s)' % len(self.helpers),
> >               file=sys.stderr)
> >
> > That python2 thinks its science fiction, what tuple is that? Can't
> > understand, print isn't a function back then.
> 
> Not a Python expert (or even regular user), but quick googling showed
> that this import is the way to go to use Python3 semantics of print
> within Python2, so seems like that's fine. But maybe Quentin has
> anything to say about this.
We are using this script with python2.7, works just fine :-)
So maybe doing s/python3/python/ is the way to go, whatever
default python is installed, it should work with that.

> > https://sebastianraschka.com/Articles/2014_python_2_3_key_diff.html#the-print-function
> >
> > I've been adding python3  to where it is available and not yet in the
> > container images, most are working after that, some don't need because
> > they need other packages for BPF to work and those are not available, so
> > nevermind, lets have just the fix I provided, I'll add python3 and life
> > goes on.
> >
> > - Arnaldo
