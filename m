Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD17C6EB90
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 22:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387807AbfGSU1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 16:27:08 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34117 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbfGSU1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 16:27:08 -0400
Received: by mail-qk1-f193.google.com with SMTP id t8so24219379qkt.1;
        Fri, 19 Jul 2019 13:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P41ktZ23AzniMkmfoHl3s3EBQx/gA0daUQo1XO44dRo=;
        b=B3lPrTS/JPjWd5iXrkOyfSTWOrmmQDbz7nd54nQVS/yhcaoXn619ECMEHXBBfaj6JV
         IsIsNpQ8GxaYe58VUd2SLWTCjvRU8B9i7Q7fuRLeXohKljlf4vekWBrG/W0bfp+8fgeP
         QISJUb3Eg3Jocn9R/eB2hAKGsaNzZRvbWa1cIv/YmmwlfzgnZf3GS6gxuzrqT43eDZBx
         vmWZruFQ5jU3aJyKuwfGs/JT1DJB+EAKdt02/9zpLllybGv0UdH0PBc4qV7lFGaJWxfw
         PSGFBcepbZ5Lo1bJasjdXAioRNVnvXCdAuySMRg8xQmGzMvoSveOrUl/YKK7bVGb0t9b
         Vm/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=P41ktZ23AzniMkmfoHl3s3EBQx/gA0daUQo1XO44dRo=;
        b=HL1hirKh8Irf3DX8xxSQ9N7mAlBx1qMQjM4iMtIuoRJIpDNnMXuF2sRCkRlCUhWi3X
         83ZbGkbcvpmiGl+gHmOGzjE62xHb4rdyJ4IoQkwulRKQcDTSLfAjkLtks8EGl/KsyjxX
         okSLsWFh+cp1gPozwRnjlc3F/WydCF0oPT6/IBplb3jj6FN0iMjuKoOyqWFp3BLfEJx1
         vfJNjpy8K6HAxVt1OAj7aU190h13dFiWvkK6dkWQxljXP+aMX1yXkmTb1n1wP4sdLDa8
         Jash+0zxB21qOQrx2ikOhNhZZevNDqkE/SUZf8SMwVINOhpGleFzp6ZuU1zK8hgt/c9S
         7orQ==
X-Gm-Message-State: APjAAAXVKubevAvvhZBvAAI0RT9BRikEW7rq83aiA6i7TQt8XIVyYdEx
        mNJD2liJu/GXWnwYFTbD5jI=
X-Google-Smtp-Source: APXvYqxFpxwJqdGOsjahL23tl36Bl5AFpsQ/TOQO2RlmQ8+6LCkHnlCvZu5ML58rrYfPJ2Z4y7a+RQ==
X-Received: by 2002:a37:95c5:: with SMTP id x188mr37198095qkd.149.1563568026671;
        Fri, 19 Jul 2019 13:27:06 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([177.159.11.82])
        by smtp.gmail.com with ESMTPSA id m10sm14247765qka.43.2019.07.19.13.27.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 13:27:05 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 20E2040340; Fri, 19 Jul 2019 17:27:03 -0300 (-03)
Date:   Fri, 19 Jul 2019 17:27:03 -0300
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing __WORDSIZE definition
Message-ID: <20190719202703.GR3624@kernel.org>
References: <CAEf4BzaPySx-hBwD5Lxo1tD7F_8ejA9qFjC0-ag56cakweqcbA@mail.gmail.com>
 <20190718185619.GL3624@kernel.org>
 <20190718191452.GM3624@kernel.org>
 <CAEf4BzburdiRTYSJUSpSFAxKmf6ELpvEeNW502eKskzyyMaUxQ@mail.gmail.com>
 <20190719011644.GN3624@kernel.org>
 <CAEf4BzaKDTnqe4QYebNSoCLfhcUJbhzgXC5sG+y+c4JLc9PFqg@mail.gmail.com>
 <20190719181423.GO3624@kernel.org>
 <CAEf4BzZtYnVG3tnn25-TTJLOmeevv9fSZnAf7S2pG3VA+dMM+Q@mail.gmail.com>
 <20190719183417.GQ3624@kernel.org>
 <CAEf4Bzb6Dfup+aRuWLyTj3=-Nyq3wWGsLXRSX7s=aMVs8WBiWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb6Dfup+aRuWLyTj3=-Nyq3wWGsLXRSX7s=aMVs8WBiWQ@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Jul 19, 2019 at 01:04:32PM -0700, Andrii Nakryiko escreveu:
> On Fri, Jul 19, 2019 at 11:34 AM Arnaldo Carvalho de Melo
> <arnaldo.melo@gmail.com> wrote:
> >
> > Em Fri, Jul 19, 2019 at 11:26:50AM -0700, Andrii Nakryiko escreveu:
> > > On Fri, Jul 19, 2019 at 11:14 AM Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> wrote:
> > > > Em Fri, Jul 19, 2019 at 10:54:44AM -0700, Andrii Nakryiko escreveu:
> > > > > Ok, did some more googling. This warning (turned error in your setup)
> > > > > is emitted when -Wshadow option is enabled for GCC/clang. It appears
> > > > > to be disabled by default, so it must be enabled somewhere for perf
> > > > > build or something.
> >
> > > > Right, I came to the exact same conclusion, doing tests here:
> >
> > > > [perfbuilder@3a58896a648d tmp]$ gcc -Wshadow shadow_global_decl.c   -o shadow_global_decl
> > > > shadow_global_decl.c: In function 'main':
> > > > shadow_global_decl.c:9: warning: declaration of 'link' shadows a global declaration
> > > > shadow_global_decl.c:4: warning: shadowed declaration is here
> > > > [perfbuilder@3a58896a648d tmp]$ gcc --version |& head -1
> > > > gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-23)
> > > > [perfbuilder@3a58896a648d tmp]$ gcc shadow_global_decl.c   -o shadow_global_decl
> > > > [perfbuilder@3a58896a648d tmp]$
> >
> > > > So I'm going to remove this warning from the places where it causes
> > > > problems.
> >
> > > > > Would it be possible to disable it at least for libbpf when building
> > > > > from perf either everywhere or for those systems where you see this
> > > > > warning? I don't think this warning is useful, to be honest, just
> > > > > random name conflict between any local and global variables will cause
> > > > > this.
> >
> > > > Yeah, I might end up having this applied.
> >
> > > Thanks!
> >
> > So, I'm ending up with the patch below, there is some value after all in
> > Wshadow, that is, from gcc 4.8 onwards :-)
> 
> I agree with the intent, but see below.
> 
> >
> > - Arnaldo
> >
> > diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
> > index 495066bafbe3..ded7a950dc40 100644
> > --- a/tools/scripts/Makefile.include
> > +++ b/tools/scripts/Makefile.include
> > @@ -32,7 +32,6 @@ EXTRA_WARNINGS += -Wno-system-headers
> >  EXTRA_WARNINGS += -Wold-style-definition
> >  EXTRA_WARNINGS += -Wpacked
> >  EXTRA_WARNINGS += -Wredundant-decls
> > -EXTRA_WARNINGS += -Wshadow
> >  EXTRA_WARNINGS += -Wstrict-prototypes
> >  EXTRA_WARNINGS += -Wswitch-default
> >  EXTRA_WARNINGS += -Wswitch-enum
> > @@ -69,8 +68,16 @@ endif
> >  # will do for now and keep the above -Wstrict-aliasing=3 in place
> >  # in newer systems.
> >  # Needed for the __raw_cmpxchg in tools/arch/x86/include/asm/cmpxchg.h
> > +#
> > +# See https://lkml.org/lkml/2006/11/28/253 and https://gcc.gnu.org/gcc-4.8/changes.html,
> > +# that takes into account Linus's comments (search for Wshadow) for the reasoning about
> > +# -Wshadow not being interesting before gcc 4.8.
> > +
> >  ifneq ($(filter 3.%,$(MAKE_VERSION)),)  # make-3
> 
> This is checking make version, not GCC version. So code comment and
> configurations are not in sync?

Ah, I should have added a few lines back:

# Hack to avoid type-punned warnings on old systems such as RHEL5:
# We should be changing CFLAGS and checking gcc version, but this
# will do for now and keep the above -Wstrict-aliasing=3 in place
# in newer systems.
# Needed for the __raw_cmpxchg in tools/arch/x86/include/asm/cmpxchg.h
#
# See https://lkml.org/lkml/2006/11/28/253 and https://gcc.gnu.org/gcc-4.8/changes.html,
# that takes into account Linus's comments (search for Wshadow) for the reasoning about
# -Wshadow not being interesting before gcc 4.8.


In time I'll try and get it to use the gcc version to be strict.

- Arnaldo
