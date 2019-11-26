Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 136F710A45B
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 20:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfKZTMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 14:12:13 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45538 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfKZTMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 14:12:13 -0500
Received: by mail-qt1-f193.google.com with SMTP id 30so22599210qtz.12;
        Tue, 26 Nov 2019 11:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=KjGyaSiUKmJdB9E8MZospziw2v4nGOZn1672kkp9/8M=;
        b=S1pKrMQrWEycS+aFsuMbpYub6ZnYzf7SsJd3Q+Fa2GlIxEHOscRAlMUNfY8UAjMHHr
         NlLogQI1LKz2t29IPDNrXqS58k/PJP1wKBwHhExK5r+HfP8QWQVRyhgYnRFPAatNrqFq
         OH8X3qGU8b3vEfOOiBuBGMk3ZjZgmK8sVYZjuiq1PjZfBXm1GhcKOpzDJmkxP6iQBPsQ
         EzEVYAFpg8yrkNsH7mbg1qaipqgqOdrWZ6hvL4XuwPOHoNJSIq07XGArzqX0Ajjjop17
         c8PTSyjfbPnAo4BLwGKM4kjK1PmUwrngmt09jTjIcpwM4Wscyb794IEBNn2KdEriAuMG
         S0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=KjGyaSiUKmJdB9E8MZospziw2v4nGOZn1672kkp9/8M=;
        b=VfPPL87c4S+UoolWTQlCzVxfwetBpAJxERLgIUdsb5m0khHWWQ5XQJoyTzlwVriCOS
         QKjcsfkssHlFpMWc4pU7iKjw+WJgRaRZAMjsaPxNUdiuBedfFvfYloyVpJBFb0/X2om/
         6Rfw/xjFFuwb5c3Ko5fiwr3FzLq9vDp7tpS/NowedbtDpC3JgMwrKOM+ZZrC/ytQtmZ5
         dTApAw88Uj2HG1xT76IPFa9Cy+PuLZKgj9hAV4bXDDbMlUbbme2qf9ARxKWGmJYItqh3
         Wmng0PSa8Qy7VAEvg7wPzyfIkUAiwa+tAZSco8hEtLV5NcEwU5fIRFOm+0ojaIqGxlFj
         O/rg==
X-Gm-Message-State: APjAAAUeGilAvkDTGUNmWX09W1STrQ4jqU1SdAdrz+QddmS8fPMhnsfR
        VOph9fz83nMdHn+MahJmxcA=
X-Google-Smtp-Source: APXvYqyxkbb3ltVCzAL9ujSkpYmh+k+5SdSvHtIqfMfGyuWFbLc2sZLc6XDhsOZqn5+tHFPyY5rwAQ==
X-Received: by 2002:ac8:73c6:: with SMTP id v6mr36967132qtp.137.1574795531820;
        Tue, 26 Nov 2019 11:12:11 -0800 (PST)
Received: from quaco.ghostprotocols.net (179-240-181-120.3g.claro.net.br. [179.240.181.120])
        by smtp.gmail.com with ESMTPSA id z17sm6162363qtq.69.2019.11.26.11.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 11:12:11 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 2ADDD40D3E; Tue, 26 Nov 2019 16:04:50 -0300 (-03)
Date:   Tue, 26 Nov 2019 16:04:50 -0300
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
Message-ID: <20191126190450.GD29071@kernel.org>
References: <20191126151045.GB19483@kernel.org>
 <20191126154836.GC19483@kernel.org>
 <87imn6y4n9.fsf@toke.dk>
 <20191126183451.GC29071@kernel.org>
 <87d0dexyij.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87d0dexyij.fsf@toke.dk>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Nov 26, 2019 at 07:50:44PM +0100, Toke Høiland-Jørgensen escreveu:
> Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> writes:
> 
> > Em Tue, Nov 26, 2019 at 05:38:18PM +0100, Toke Høiland-Jørgensen escreveu:
> >> Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> writes:
> >> 
> >> > Em Tue, Nov 26, 2019 at 12:10:45PM -0300, Arnaldo Carvalho de Melo escreveu:
> >> >> Hi guys,
> >> >> 
> >> >>    While merging perf/core with mainline I found the problem below for
> >> >> which I'm adding this patch to my perf/core branch, that soon will go
> >> >> Ingo's way, etc. Please let me know if you think this should be handled
> >> >> some other way,
> >> >
> >> > This is still not enough, fails building in a container where all we
> >> > have is the tarball contents, will try to fix later.
> >> 
> >> Wouldn't the right thing to do not be to just run the script, and then
> >> put the generated bpf_helper_defs.h into the tarball?

> > I would rather continue just running tar and have the build process
> > in-tree or outside be the same.
> 
> Hmm, right. Well that Python script basically just parses
> include/uapi/linux/bpf.h; and it can be given the path of that file with
> the --filename argument. So as long as that file is present, it should
> be possible to make it work, I guess?
 
> However, isn't the point of the tarball to make a "stand-alone" source
> distribution?

Yes, it is, and as far as possible without any prep, just include the
in-source tree files needed to build it.

> I'd argue that it makes more sense to just include the
> generated header, then: The point of the Python script is specifically
> to extract the latest version of the helper definitions from the kernel
> source tree. And if you're "freezing" a version into a tarball, doesn't
> it make more sense to also freeze the list of BPF helpers?

Your suggestion may well even be the only solution, as older systems
don't have python3, and that script requires it :-\

Some containers were showing this:

/bin/sh: 1: /git/linux/scripts/bpf_helpers_doc.py: not found
Makefile:184: recipe for target 'bpf_helper_defs.h' failed
make[3]: *** [bpf_helper_defs.h] Error 127
make[3]: *** Deleting file 'bpf_helper_defs.h'
Makefile.perf:778: recipe for target '/tmp/build/perf/libbpf.a' failed

That "not found" doesn't mean what it looks from staring at the above,
its just that:

nobody@1fb841e33ba3:/tmp/perf-5.4.0$ head -1 /tmp/perf-5.4.0/scripts/bpf_helpers_doc.py
#!/usr/bin/python3
nobody@1fb841e33ba3:/tmp/perf-5.4.0$ ls -la /usr/bin/python3
ls: cannot access /usr/bin/python3: No such file or directory
nobody@1fb841e33ba3:/tmp/perf-5.4.0$

So, for now, I'll keep my fix and start modifying the containers where
this fails and disable testing libbpf/perf integration with BPF on those
containers :-\

I.e. doing:

nobody@1fb841e33ba3:/tmp/perf-5.4.0$ make NO_LIBBPF=1 -C /tmp/perf-5.4.0/tools/perf/ O=/tmp/build/perf

which ends up with a functional perf, just one without libbpf linked in:

nobody@1fb841e33ba3:/tmp/perf-5.4.0$ /tmp/build/perf/perf -vv
perf version 5.4.gf69779ce8f86
                 dwarf: [ on  ]  # HAVE_DWARF_SUPPORT
    dwarf_getlocations: [ OFF ]  # HAVE_DWARF_GETLOCATIONS_SUPPORT
                 glibc: [ on  ]  # HAVE_GLIBC_SUPPORT
                  gtk2: [ on  ]  # HAVE_GTK2_SUPPORT
         syscall_table: [ on  ]  # HAVE_SYSCALL_TABLE_SUPPORT
                libbfd: [ on  ]  # HAVE_LIBBFD_SUPPORT
                libelf: [ on  ]  # HAVE_LIBELF_SUPPORT
               libnuma: [ OFF ]  # HAVE_LIBNUMA_SUPPORT
numa_num_possible_cpus: [ OFF ]  # HAVE_LIBNUMA_SUPPORT
               libperl: [ on  ]  # HAVE_LIBPERL_SUPPORT
             libpython: [ on  ]  # HAVE_LIBPYTHON_SUPPORT
              libslang: [ on  ]  # HAVE_SLANG_SUPPORT
             libcrypto: [ on  ]  # HAVE_LIBCRYPTO_SUPPORT
             libunwind: [ on  ]  # HAVE_LIBUNWIND_SUPPORT
    libdw-dwarf-unwind: [ on  ]  # HAVE_DWARF_SUPPORT
                  zlib: [ on  ]  # HAVE_ZLIB_SUPPORT
                  lzma: [ on  ]  # HAVE_LZMA_SUPPORT
             get_cpuid: [ on  ]  # HAVE_AUXTRACE_SUPPORT
                   bpf: [ OFF ]  # HAVE_LIBBPF_SUPPORT
                   aio: [ on  ]  # HAVE_AIO_SUPPORT
                  zstd: [ OFF ]  # HAVE_ZSTD_SUPPORT
nobody@1fb841e33ba3:/tmp/perf-5.4.0$

The the build tests for libbpf and the bpf support in perf will
continue, but for a reduced set of containers, those with python3.

People wanting to build libbpf on such older systems will hopefully find
this discussion in google, run the script, get the output and have it
working.

- Arnaldo
