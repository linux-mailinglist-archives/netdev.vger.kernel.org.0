Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE5511007F
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 15:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfLCOlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 09:41:13 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44574 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfLCOlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 09:41:12 -0500
Received: by mail-qk1-f195.google.com with SMTP id i18so3573813qkl.11;
        Tue, 03 Dec 2019 06:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vXhD/Cg42jzYXyNOmi+P51+bDzKABFgmqewXbwdhiSk=;
        b=dRDTh2Hj0zfw0Y+ySTQkBAU7i7qdkFlw/LNWWR+faN6evr5Ox1mXGMcF9Ai5IetlRf
         7KaAx/kf4dUxrfnaAsjq0pT7p4YIkqh96IQKizZdGg0MheEiJv4vkFI8sgvqIroZjJ2S
         9z2uq1luL160NGANBP50NvBWurbNnGKxSqId2NgowdHRkqM7N+/cBp6wO5PW94F6dGl6
         4TKB7IkcKxinHV9u/piVO3uB9lx0sJE377C5D5A0wTUeGrOMK0sT3AXvJUL3Mg1rgFX4
         rGCrksL0cG3q4SgVzE/tVIf8RpI7W5uCnrkX0SBPlB+QLsfAxLbSF9q6ay7q28jvIJdm
         FCiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vXhD/Cg42jzYXyNOmi+P51+bDzKABFgmqewXbwdhiSk=;
        b=EGYQespowV7DV2hGVdXpCfiStD57NqElMc3tWB6ISBpVV78vue8bOexKsSy8SJFT1i
         T3Z+MDk7t0N6CJAPj4PtbeIVZ4dPwsmhTz7YqkYIA2nRlbHoFRqvVeaLbFBfGvmDiYn9
         7mXEcwrdZNp3AcAAAvnpQkZE7ZqCnouzyAcrKTxkpq1kCVg1yCu0ZWDVUzLiArxRo+Km
         NcMWUhPPnc7243WzDfKetZlwP3pDVxqzJHRacgFr3K3O0sGRvpdsyq6Z83OnPtZoocmI
         d/2bUMB5sIQjI+QO+K9bUEYTYKrYi1hCJukRIE9NKKJVKI5L6/Fi43WOWpVxp8MAVP23
         SkAw==
X-Gm-Message-State: APjAAAW9OsDb1akagDkMz/uvazPYXihCy69S4KZVAA6Smxeio6JPPchN
        zTU3I6ipT7mpmNkGops7/d0=
X-Google-Smtp-Source: APXvYqyXniDHUkFbSP7EpOte5PHY8jktoIGaL43k/lR3zWNKsmV0wcQJ/pjpRobQYuEvOIG8qzi39A==
X-Received: by 2002:a05:620a:131a:: with SMTP id o26mr4903868qkj.160.1575384071571;
        Tue, 03 Dec 2019 06:41:11 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id j7sm1780104qkd.46.2019.12.03.06.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 06:41:10 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 2FBC3405B6; Tue,  3 Dec 2019 11:41:07 -0300 (-03)
Date:   Tue, 3 Dec 2019 11:41:07 -0300
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
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
        Quentin Monnet <quentin.monnet@netronome.com>,
        Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH] libbpf: Use PRIu64 for sym->st_value to fix build on
 32-bit arches
Message-ID: <20191203144107.GC3247@kernel.org>
References: <20191126190450.GD29071@kernel.org>
 <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
 <20191126221018.GA22719@kernel.org>
 <20191126221733.GB22719@kernel.org>
 <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
 <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net>
 <20191126155228.0e6ed54c@cakuba.netronome.com>
 <20191127013901.GE29071@kernel.org>
 <20191127134553.GC22719@kernel.org>
 <CA+G9fYsK8zn3jqF=Wz6=8BBx4i1JTkv2h-LCbjE11UJkcz_NEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsK8zn3jqF=Wz6=8BBx4i1JTkv2h-LCbjE11UJkcz_NEA@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Dec 03, 2019 at 07:20:08PM +0530, Naresh Kamboju escreveu:
> Hi Arnaldo,
> 
> FYI,
> 
> On Wed, 27 Nov 2019 at 19:15, Arnaldo Carvalho de Melo
> <arnaldo.melo@gmail.com> wrote:
> >
> > Another fix I'm carrying in my perf/core branch,
> >
> > Regards,
> >
> > - Arnaldo
> >
> > commit 98bb09f90a0ae33125fabc8f41529345382f1498
> > Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Date:   Wed Nov 27 09:26:54 2019 -0300
> >
> >     libbpf: Use PRIu64 for sym->st_value to fix build on 32-bit arches
> >
> >     The st_value field is a 64-bit value, so use PRIu64 to fix this error on
> >     32-bit arches:
> >
> >       In file included from libbpf.c:52:
> >       libbpf.c: In function 'bpf_program__record_reloc':
> >       libbpf_internal.h:59:22: error: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'Elf64_Addr' {aka 'const long long unsigned int'} [-Werror=format=]
> >         libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
> >                             ^~~~~~~~~~
> >       libbpf_internal.h:62:27: note: in expansion of macro '__pr'
> >        #define pr_warn(fmt, ...) __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
> >                                  ^~~~
> >       libbpf.c:1822:4: note: in expansion of macro 'pr_warn'
> >           pr_warn("bad call relo offset: %lu\n", sym->st_value);
> >           ^~~~~~~
> >       libbpf.c:1822:37: note: format string is defined here
> >           pr_warn("bad call relo offset: %lu\n", sym->st_value);
> >                                          ~~^
> >                                          %llu
> 
> This build error is been noticed on Linux mainline kernel for 32-bit
> architectures from Nov 26.

Right, the fix is in the bpf tree:

https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=7c3977d1e804

Should go upstream soon.

- Arnaldo
 
> Full build log,
> https://ci.linaro.org/job/openembedded-lkft-linux-mainline/DISTRO=lkft,MACHINE=intel-core2-32,label=docker-lkft/2297/consoleText
> https://ci.linaro.org/job/openembedded-lkft-linux-mainline/
> 
> - Naresh

-- 

- Arnaldo
