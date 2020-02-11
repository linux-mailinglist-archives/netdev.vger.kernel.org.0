Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E751599D3
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 20:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731704AbgBKTcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 14:32:31 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40470 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728849AbgBKTcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 14:32:31 -0500
Received: by mail-qk1-f194.google.com with SMTP id b7so11306080qkl.7;
        Tue, 11 Feb 2020 11:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Jv32+hQlvyuqWyQZrfmL7SM1lCUMOPRtNgkxMCMMRjc=;
        b=o/Bs8QDgs29PFBmp+uMx+YyqHqyX9gug4WxKxnazsRYu6qnpmicfba9R7CkyqVmpwO
         Vr+kdV9BiNqbUF/ew7oOTCuMHSrGRDPmcIe8ADMqcQwE5FmY0H7uGbuBaHdoyuY0VEJS
         VpSRKEavyELmFEjxeDRGvaXRpp/jpfjCNoVq6TmyrrVtrPTZfaURUSfaoz7OjSeDRIVm
         gfGeXQFODdAKKzf58mYhI1wRcUHzs4ewFeaioIr6Bp5p0kqDPKjLFCJ2nTmdmZGrpQay
         w7N1JS0btthILjiPzXAr8sPJl/4s524Z2mptG+bTIwoGgThpvXf37rPt5K+xthXKKolc
         WFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Jv32+hQlvyuqWyQZrfmL7SM1lCUMOPRtNgkxMCMMRjc=;
        b=tc/EoLcPEgXtWRZlbfz5pa+7hmYh+LgX8Ju0dUZG8fAh2KuoCrt5dpz+qO06YM/5JB
         8wH4A+dSx9SaPvPbZIi+4BhPphzV61TUG6Ti38grtlkMKpkbKz/jgV5ZPUbcAXwRQ2Ku
         dF8zJbfHKPl/wqGXELZJyYNgipHZwO5zPGVi3zaHDiTnIRV30LzRNxSCUc93jKVPLsFJ
         xpIyx09zlmKzYnO6Qvjke0H7yhXP6aHBaavE5tzVIEkby5DIAMbBDwg53zgqF5b1jYPo
         ls/+42ieaq7rViwKxWcFOlCI+UfJ15y5IWOrrvKpc6nJdZRcyOpjPAWKHyor28WIjebp
         UIIg==
X-Gm-Message-State: APjAAAU2h3YGEhfqkjIVcA7/rdMhjoDwX/PKM7WVuxYK4zmaHweTATx8
        N67Wrk758Lsw3ngfp6Q7gUg=
X-Google-Smtp-Source: APXvYqx7hgyhFuIjIj0kJ8Hkkx3RAoznfr4OmkQ2Zz6673Q4D6ZSqHyiIAc3mt+ZsUHoGzqEr7wu5w==
X-Received: by 2002:a05:620a:140d:: with SMTP id d13mr3297259qkj.450.1581449549652;
        Tue, 11 Feb 2020 11:32:29 -0800 (PST)
Received: from quaco.ghostprotocols.net ([177.195.209.176])
        by smtp.gmail.com with ESMTPSA id v10sm2755866qtj.26.2020.02.11.11.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 11:32:29 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id CA36840A7D; Tue, 11 Feb 2020 16:32:23 -0300 (-03)
Date:   Tue, 11 Feb 2020 16:32:23 -0300
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [PATCH 00/14] bpf: Add trampoline and dispatcher to
 /proc/kallsyms
Message-ID: <20200211193223.GI3416@kernel.org>
References: <20200208154209.1797988-1-jolsa@kernel.org>
 <CAJ+HfNhBDU9c4-0D5RiHFZBq_LN7E=k8=rhL+VbmxJU7rdDBxQ@mail.gmail.com>
 <20200210161751.GC28110@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200210161751.GC28110@krava>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Feb 10, 2020 at 05:17:51PM +0100, Jiri Olsa escreveu:
> On Mon, Feb 10, 2020 at 04:51:08PM +0100, Björn Töpel wrote:
> > On Sat, 8 Feb 2020 at 16:42, Jiri Olsa <jolsa@kernel.org> wrote:
> > > this patchset adds trampoline and dispatcher objects
> > > to be visible in /proc/kallsyms. The last patch also
> > > adds sorting for all bpf objects in /proc/kallsyms.

> > Thanks for working on this!

> > I'm probably missing something with my perf setup; I've applied your
> > patches, and everything seem to work fine from an kallsyms
> > perspective:

> > # grep bpf_dispatcher_xdp /proc/kallsyms
> > ...
> > ffffffffc0511000 t bpf_dispatcher_xdp   [bpf]
> > 
> > However, when I run
> > # perf top
> > 
> > I still see the undecorated one:
> > 0.90%  [unknown]                  [k] 0xffffffffc0511037
> > 
> > Any ideas?
 
> yea strange.. it should be picked up from /proc/kallsyms as
> fallback if there's no other source, I'll check on that
> (might be the problem with perf depending on address going
> only higher in /proc/kallsyms, while bpf symbols are at the
> end and start over from the lowest bpf address)
> 
> anyway, in perf we enumerate bpf_progs via the perf events
> PERF_BPF_EVENT_PROG_LOAD,PERF_BPF_EVENT_PROG_UNLOAD interface
> together with PERF_RECORD_KSYMBOL_TYPE_BPF events
> 
> we might need to add something like:
>   PERF_RECORD_KSYMBOL_TYPE_BPF_TRAMPOLINE
>   PERF_RECORD_KSYMBOL_TYPE_BPF_DISPATCHER
> 
> to notify about the area, I'll check on that
> 
> however the /proc/kallsyms fallback should work in any
> case.. thanks for report ;-)

We should by now move kallsyms to be the preferred source of symbols,
not vmlinux, right?

Perhaps what is happening is:

[root@quaco ~]# strace -f -e open,openat -o /tmp/bla perf top
[root@quaco ~]# grep vmlinux /tmp/bla
11013 openat(AT_FDCWD, "vmlinux", O_RDONLY) = -1 ENOENT (No such file or directory)
11013 openat(AT_FDCWD, "/boot/vmlinux", O_RDONLY) = -1 ENOENT (No such file or directory)
11013 openat(AT_FDCWD, "/boot/vmlinux-5.5.0+", O_RDONLY) = -1 ENOENT (No such file or directory)
11013 openat(AT_FDCWD, "/usr/lib/debug/boot/vmlinux-5.5.0+", O_RDONLY) = -1 ENOENT (No such file or directory)
11013 openat(AT_FDCWD, "/lib/modules/5.5.0+/build/vmlinux", O_RDONLY) = 152
[root@quaco ~]#

I.e. it is using vmlinux for resolving symbols and he should try with:

[root@quaco ~]# strace -f -e open,openat -o /tmp/bla perf top --ignore-vmlinux
[root@quaco ~]# perf top -h vmlinux

 Usage: perf top [<options>]

    -k, --vmlinux <file>  vmlinux pathname
        --ignore-vmlinux  don't load vmlinux even if found

[root@quaco ~]# grep vmlinux /tmp/bla
[root@quaco ~]#

Historically vmlinux was preferred because it contains function sizes,
but with all these out of the blue symbols, we need to prefer starting
with /proc/kallsyms and, as we do now, continue getting updates via
PERF_RECORD_KSYMBOL.

Humm, but then trampolines don't generate that, right? Or does it? If it
doesn't, then we will know about just the trampolines in place when the
record/top session starts, reparsing /proc/kallsyms periodically seems
excessive?

- Arnaldo
