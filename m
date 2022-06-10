Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2DF546ECE
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350634AbiFJUyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350238AbiFJUyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:54:05 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3363D4B6;
        Fri, 10 Jun 2022 13:53:58 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id n185so67910wmn.4;
        Fri, 10 Jun 2022 13:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BPAA/Q9nrzzsrnA4whI0Nkp0q+9CluXi9i2hfcEo5dM=;
        b=FeTryA++nxauIaK9v3GI39jeBsEkvHFVGGJjON+Wka8w6ETR2tRNSN11JU2mDvRuwB
         +1wFOeFTSe6GK3u+VJEIdxvWRxa888GPpNVHty7Rch88MvNiGTdBZ75EQHF7b5x6Zccf
         dcFEP3lFof3SyXUJodn49z4wVyMz3HObJ1yTMK3oiXLufrhXB3kqUC5vZUuWMg2ge2fY
         17P3CnSiRdFUWT/YE84SxNIVcpnHkrj9n+l2ho0rcJPLed0SxGfof2hfwdoBMyEcNP0e
         LzONI0UIWyOJpZ6Uqs0aQMORHhVrpGTwb8wrNkyHxId6pcFThysmPlXiDIlcd2jL88xF
         rWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BPAA/Q9nrzzsrnA4whI0Nkp0q+9CluXi9i2hfcEo5dM=;
        b=bArMlO898poHa2Uz/5yhQET6+oEbdKfbGuECrPbPbugxBABDiHJUkQ4/QUNXRkWEwu
         lcm6NBZj7F0yNnk2ZpMDv7jiwDmCHsNejAkwz9ZiomltOl/h2MEZZV6eida5ogNZuvkp
         pTSYsiZwPhMnoK9gabhyTKbGD/7xyGCtdi+00P9J03A8oWjc5QNPIrsV1BcA80R5/W+0
         taPsMk3YDjBP7HbMWnFYTEFh5I8Gq6OBFaBcpTjvgV22T++aokClb2rA8YC4voEBjm6o
         Rscm7L9QbItVNIOrE8EddIgLzeaXNA/uOQtwhS+KrIMV5BVTFydXmaPZAhUG+HuFvOkK
         f3Rw==
X-Gm-Message-State: AOAM531T19PuCJnpW7RXcWcW0zG85wW9gGtdsI/wyttgU0RGSzhDdQpU
        wg+4YgtPpzuq8qkbs/g/z+4=
X-Google-Smtp-Source: ABdhPJxbliEL/hYv/fP0SjKlQiswtu7udcoNpcIT39cVAiBHu+Yh65eUuMdCJWOkeoXOl77mZy0xKw==
X-Received: by 2002:a05:600c:1e0a:b0:39c:4b31:5af5 with SMTP id ay10-20020a05600c1e0a00b0039c4b315af5mr1514493wmb.174.1654894437236;
        Fri, 10 Jun 2022 13:53:57 -0700 (PDT)
Received: from krava ([83.240.60.46])
        by smtp.gmail.com with ESMTPSA id v22-20020a7bcb56000000b0039482d95ab7sm121477wmj.24.2022.06.10.13.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 13:53:56 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 10 Jun 2022 22:53:54 +0200
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: Re: [PATCHv4 bpf-next 0/2] perf tools: Fix prologue generation
Message-ID: <YqOvYo1tp32gKviM@krava>
References: <20220603204509.15044-1-jolsa@kernel.org>
 <CAEf4BzbT4Z=B2hZxTQf1MrCp6TGiMgP+_t7p8G5A+RdVyNP+8w@mail.gmail.com>
 <YqOOsL8EbbO3lhmC@kernel.org>
 <CAEf4BzaKP8MHtGZDVSpwbCxNUD4zY9wkjEa4HKR0LWxYKW5cGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaKP8MHtGZDVSpwbCxNUD4zY9wkjEa4HKR0LWxYKW5cGQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 11:45:48AM -0700, Andrii Nakryiko wrote:
> On Fri, Jun 10, 2022 at 11:34 AM Arnaldo Carvalho de Melo
> <acme@kernel.org> wrote:
> >
> > Em Thu, Jun 09, 2022 at 01:31:52PM -0700, Andrii Nakryiko escreveu:
> > > On Fri, Jun 3, 2022 at 1:45 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > hi,
> > > > sending change we discussed some time ago [1] to get rid of
> > > > some deprecated functions we use in perf prologue code.
> > > >
> > > > Despite the gloomy discussion I think the final code does
> > > > not look that bad ;-)
> > > >
> > > > This patchset removes following libbpf functions from perf:
> > > >   bpf_program__set_prep
> > > >   bpf_program__nth_fd
> > > >   struct bpf_prog_prep_result
> > > >
> > > > v4 changes:
> > > >   - fix typo [Andrii]
> > > >
> > > > v3 changes:
> > > >   - removed R0/R1 zero init in libbpf_prog_prepare_load_fn,
> > > >     because it's not needed [Andrii]
> > > >   - rebased/post on top of bpf-next/master which now has
> > > >     all the needed perf/core changes
> > > >
> > > > v2 changes:
> > > >   - use fallback section prog handler, so we don't need to
> > > >     use section prefix [Andrii]
> > > >   - realloc prog->insns array in bpf_program__set_insns [Andrii]
> > > >   - squash patch 1 from previous version with
> > > >     bpf_program__set_insns change [Daniel]
> > > >   - patch 3 already merged [Arnaldo]
> > > >   - added more comments
> > > >
> > > > thanks,
> > > > jirka
> > > >
> > >
> > > Arnaldo, can I get an ack from you for this patch set? Thank you!
> >
> > So, before these patches:
> >
> > [acme@quaco perf-urgent]$ git log --oneline -5
> > 22905f78d181f446 (HEAD) libperf evsel: Open shouldn't leak fd on failure
> > a3c6da3dbd4bdf9c perf test: Fix "perf stat CSV output linter" test on s390
> > 785cb9e85e8ba66f perf unwind: Fix uninitialized variable
> > 874c8ca1e60b2c56 netfs: Fix gcc-12 warning by embedding vfs inode in netfs_i_context
> > 3d9f55c57bc3659f Merge tag 'fs_for_v5.19-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
> > [acme@quaco perf-urgent]$ sudo su -
> > [root@quaco ~]# perf -v
> > perf version 5.19.rc1.g22905f78d181
> > [root@quaco ~]# perf test 42
> >  42: BPF filter                                                      :
> >  42.1: Basic BPF filtering                                           : Ok
> >  42.2: BPF pinning                                                   : Ok
> >  42.3: BPF prologue generation                                       : Ok
> > [root@quaco ~]#
> >
> > And after:
> >
> > [acme@quaco perf-urgent]$ git log --oneline -5
> > f8ec656242acf2de (HEAD -> perf/urgent) perf tools: Rework prologue generation code
> > a750a8dd7e5d2d4b perf tools: Register fallback libbpf section handler
> > d28f2a8ad42af160 libperf evsel: Open shouldn't leak fd on failure
> > a3c6da3dbd4bdf9c perf test: Fix "perf stat CSV output linter" test on s390
> > 785cb9e85e8ba66f perf unwind: Fix uninitialized variable
> > [acme@quaco perf-urgent]$ sudo su -
> > [root@quaco ~]# perf -v
> > perf version 5.19.rc1.gf8ec656242ac
> > [root@quaco ~]# perf test 42
> >  42: BPF filter                                                      :
> >  42.1: Basic BPF filtering                                           : FAILED!
> >  42.2: BPF pinning                                                   : FAILED!
> >  42.3: BPF prologue generation                                       : Ok
> > [root@quaco ~]#
> >
> > Jiri, can you try reproducing these? Do this require some other work
> > that is in bpf-next/master? Lemme try...
> >
> > Further details:
> >
> > [acme@quaco perf-urgent]$ clang -v
> > clang version 13.0.0 (five:git/llvm-project d667b96c98438edcc00ec85a3b151ac2dae862f3)
> > Target: x86_64-unknown-linux-gnu
> > Thread model: posix
> > InstalledDir: /usr/local/bin
> > Found candidate GCC installation: /usr/lib/gcc/x86_64-redhat-linux/12
> > Selected GCC installation: /usr/lib/gcc/x86_64-redhat-linux/12
> > Candidate multilib: .;@m64
> > Candidate multilib: 32;@m32
> > Selected multilib: .;@m64
> > [acme@quaco perf-urgent]$ cat /etc/fedora-release
> > Fedora release 36 (Thirty Six)
> > [acme@quaco perf-urgent]$ gcc -v
> > Using built-in specs.
> > COLLECT_GCC=/usr/bin/gcc
> > COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/12/lto-wrapper
> > OFFLOAD_TARGET_NAMES=nvptx-none
> > OFFLOAD_TARGET_DEFAULT=1
> > Target: x86_64-redhat-linux
> > Configured with: ../configure --enable-bootstrap --enable-languages=c,c++,fortran,objc,obj-c++,ada,go,d,lto --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-shared --enable-threads=posix --enable-checking=release --enable-multilib --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-gcc-major-version-only --enable-libstdcxx-backtrace --with-linker-hash-style=gnu --enable-plugin --enable-initfini-array --with-isl=/builddir/build/BUILD/gcc-12.1.1-20220507/obj-x86_64-redhat-linux/isl-install --enable-offload-targets=nvptx-none --without-cuda-driver --enable-offload-defaulted --enable-gnu-indirect-function --enable-cet --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux --with-build-config=bootstrap-lto --enable-link-serialization=1
> > Thread model: posix
> > Supported LTO compression algorithms: zlib zstd
> > gcc version 12.1.1 20220507 (Red Hat 12.1.1-1) (GCC)
> > [acme@quaco perf-urgent]$
> >
> > [root@quaco ~]# perf test -v 42
> >  42: BPF filter                                                      :
> >  42.1: Basic BPF filtering                                           :
> > --- start ---
> > test child forked, pid 638881
> > Kernel build dir is set to /lib/modules/5.17.11-300.fc36.x86_64/build
> > set env: KBUILD_DIR=/lib/modules/5.17.11-300.fc36.x86_64/build
> > unset env: KBUILD_OPTS
> > include option is set to -nostdinc -I./arch/x86/include -I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/compiler-version.h -include ./include/linux/kconfig.h
> > set env: NR_CPUS=8
> > set env: LINUX_VERSION_CODE=0x5110b
> > set env: CLANG_EXEC=/usr/lib64/ccache/clang
> > set env: CLANG_OPTIONS=-xc -g

ok, it's the BTF debug info as Andrii mentioned below,
I assume you have 'clang-opt=-g' in .perfconfig, right?

when I add it to mine I can reproduce, perfect

SNIP

> > bpf: config 'func=do_epoll_wait' is ok
> > Looking at the vmlinux_path (8 entries long)
> > symsrc__init: build id mismatch for vmlinux.
> > Using /usr/lib/debug/lib/modules/5.17.11-300.fc36.x86_64/vmlinux for symbols
> > Open Debuginfo file: /usr/lib/debug/.build-id/f2/26f5d75e6842add57095a0615a1e5c16783dd7.debug
> > Try to find probe point from debuginfo.
> > Matched function: do_epoll_wait [38063fb]
> > Probe point found: do_epoll_wait+0
> > Found 1 probe_trace_events.
> > Opening /sys/kernel/tracing//kprobe_events write=1
> > Opening /sys/kernel/tracing//README write=0
> > Writing event: p:perf_bpf_probe/func _text+3943040
> > libbpf: map 'flip_table': created successfully, fd=4
> > libbpf: prog 'bpf_func__SyS_epoll_pwait': BPF program load failed: Invalid argument
> > libbpf: prog 'bpf_func__SyS_epoll_pwait': -- BEGIN PROG LOAD LOG --
> > Invalid insn code at line_info[11].insn_off
> 
> Mismatched line_info.
> 
> Jiri, I think we need to clear func_info and line_info in
> bpf_program__set_insns() because at that point func/line info can be
> mismatched and won't correspond to the actual set of instructions.
> 
> Arnaldo, thanks for testing and providing details!

sounds good, I'll check on that.. now I can reproduce

thanks,
jirka
