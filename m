Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752C0546CAC
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 20:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347681AbiFJSqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 14:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346688AbiFJSqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 14:46:05 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812E5270427;
        Fri, 10 Jun 2022 11:46:03 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id e4so95372ljl.1;
        Fri, 10 Jun 2022 11:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SXZybrEFLbvb/l2ppLyGyg3imtiTWccdLLwduakgTi4=;
        b=RrV0/OAbbh1lYjYIwEq257CXO5Em3jLnnRuzDWq2VZUeR2UnIt3zQONaBTGcliOYk8
         TNSFQw3P1kQheBwIatzQbqPpuLEYCdCIJS+TICFflRP72efIf88Nm5yJ8ehVpliCQJf1
         wjcL0L0ItqGURBxEdmxGrwMqSJpnZ9NJgxSCgbx+g6wXAq05UYGi0JdDGnx6T33MKsfi
         o2WGvMOnb7Rw5UN6GiJlH+MFiZRv0QMFieit2l8oAROWYZ72doxwVxStU1O9WWkrJXI0
         yjueiYCQQBMJFjrIAZV/JhrQlaPvjIXVtpxVabtRr7PRVuxblbSal+DGCEdwGvcH4ItM
         rLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SXZybrEFLbvb/l2ppLyGyg3imtiTWccdLLwduakgTi4=;
        b=7WtmkJyt/J85NTvbT4WCrsMjyPb7C0GugFG09VuBwerWWWkE7yurQkpVTYh2lM52R3
         hLYPgGAyT1er6q71iX3G4OY737hfGwOZYgawlCsZbCQcZKdus+LJYlsgbpkpPoCQrhjv
         2DU9nx+daY/57qvktNM5XqTg7lGb0nUIcHLumuYaKxAx7lg/jIYlWQm+rLtEwsTemlE3
         BGJFrkfpG90qBtAt/BQ8Q7cl9eLD5zcxWUD1aaR1vacHpYrmOXar6+81aNdKLPFS99r/
         uSPh7tdHbq1CWOMs9vZQSrM2phrjwrFBVXxp3JL/Y2zHHv9euIRhIJjrAOu8GdZUBVyu
         1FHA==
X-Gm-Message-State: AOAM530ah+jpkUIGBcLj26d37cXr8t1v99KuN20hfZojWrjSMTYYbigv
        ro+aZkT4vx6arQTzZHI6v6mU/lHUN9nF5/j6GSo=
X-Google-Smtp-Source: ABdhPJw3n2I1LbpbUJxSqiv3HRlIhH9D8R2chaCVYtkx9QlLh3Vy0ULAG9lrultP1AL04nUz3H2hpPyzp7gLi8L3W9Y=
X-Received: by 2002:a2e:a7c7:0:b0:255:8ecd:14b0 with SMTP id
 x7-20020a2ea7c7000000b002558ecd14b0mr16746244ljp.472.1654886761426; Fri, 10
 Jun 2022 11:46:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220603204509.15044-1-jolsa@kernel.org> <CAEf4BzbT4Z=B2hZxTQf1MrCp6TGiMgP+_t7p8G5A+RdVyNP+8w@mail.gmail.com>
 <YqOOsL8EbbO3lhmC@kernel.org>
In-Reply-To: <YqOOsL8EbbO3lhmC@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Jun 2022 11:45:48 -0700
Message-ID: <CAEf4BzaKP8MHtGZDVSpwbCxNUD4zY9wkjEa4HKR0LWxYKW5cGQ@mail.gmail.com>
Subject: Re: [PATCHv4 bpf-next 0/2] perf tools: Fix prologue generation
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 11:34 AM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Em Thu, Jun 09, 2022 at 01:31:52PM -0700, Andrii Nakryiko escreveu:
> > On Fri, Jun 3, 2022 at 1:45 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > hi,
> > > sending change we discussed some time ago [1] to get rid of
> > > some deprecated functions we use in perf prologue code.
> > >
> > > Despite the gloomy discussion I think the final code does
> > > not look that bad ;-)
> > >
> > > This patchset removes following libbpf functions from perf:
> > >   bpf_program__set_prep
> > >   bpf_program__nth_fd
> > >   struct bpf_prog_prep_result
> > >
> > > v4 changes:
> > >   - fix typo [Andrii]
> > >
> > > v3 changes:
> > >   - removed R0/R1 zero init in libbpf_prog_prepare_load_fn,
> > >     because it's not needed [Andrii]
> > >   - rebased/post on top of bpf-next/master which now has
> > >     all the needed perf/core changes
> > >
> > > v2 changes:
> > >   - use fallback section prog handler, so we don't need to
> > >     use section prefix [Andrii]
> > >   - realloc prog->insns array in bpf_program__set_insns [Andrii]
> > >   - squash patch 1 from previous version with
> > >     bpf_program__set_insns change [Daniel]
> > >   - patch 3 already merged [Arnaldo]
> > >   - added more comments
> > >
> > > thanks,
> > > jirka
> > >
> >
> > Arnaldo, can I get an ack from you for this patch set? Thank you!
>
> So, before these patches:
>
> [acme@quaco perf-urgent]$ git log --oneline -5
> 22905f78d181f446 (HEAD) libperf evsel: Open shouldn't leak fd on failure
> a3c6da3dbd4bdf9c perf test: Fix "perf stat CSV output linter" test on s39=
0
> 785cb9e85e8ba66f perf unwind: Fix uninitialized variable
> 874c8ca1e60b2c56 netfs: Fix gcc-12 warning by embedding vfs inode in netf=
s_i_context
> 3d9f55c57bc3659f Merge tag 'fs_for_v5.19-rc2' of git://git.kernel.org/pub=
/scm/linux/kernel/git/jack/linux-fs
> [acme@quaco perf-urgent]$ sudo su -
> [root@quaco ~]# perf -v
> perf version 5.19.rc1.g22905f78d181
> [root@quaco ~]# perf test 42
>  42: BPF filter                                                      :
>  42.1: Basic BPF filtering                                           : Ok
>  42.2: BPF pinning                                                   : Ok
>  42.3: BPF prologue generation                                       : Ok
> [root@quaco ~]#
>
> And after:
>
> [acme@quaco perf-urgent]$ git log --oneline -5
> f8ec656242acf2de (HEAD -> perf/urgent) perf tools: Rework prologue genera=
tion code
> a750a8dd7e5d2d4b perf tools: Register fallback libbpf section handler
> d28f2a8ad42af160 libperf evsel: Open shouldn't leak fd on failure
> a3c6da3dbd4bdf9c perf test: Fix "perf stat CSV output linter" test on s39=
0
> 785cb9e85e8ba66f perf unwind: Fix uninitialized variable
> [acme@quaco perf-urgent]$ sudo su -
> [root@quaco ~]# perf -v
> perf version 5.19.rc1.gf8ec656242ac
> [root@quaco ~]# perf test 42
>  42: BPF filter                                                      :
>  42.1: Basic BPF filtering                                           : FA=
ILED!
>  42.2: BPF pinning                                                   : FA=
ILED!
>  42.3: BPF prologue generation                                       : Ok
> [root@quaco ~]#
>
> Jiri, can you try reproducing these? Do this require some other work
> that is in bpf-next/master? Lemme try...
>
> Further details:
>
> [acme@quaco perf-urgent]$ clang -v
> clang version 13.0.0 (five:git/llvm-project d667b96c98438edcc00ec85a3b151=
ac2dae862f3)
> Target: x86_64-unknown-linux-gnu
> Thread model: posix
> InstalledDir: /usr/local/bin
> Found candidate GCC installation: /usr/lib/gcc/x86_64-redhat-linux/12
> Selected GCC installation: /usr/lib/gcc/x86_64-redhat-linux/12
> Candidate multilib: .;@m64
> Candidate multilib: 32;@m32
> Selected multilib: .;@m64
> [acme@quaco perf-urgent]$ cat /etc/fedora-release
> Fedora release 36 (Thirty Six)
> [acme@quaco perf-urgent]$ gcc -v
> Using built-in specs.
> COLLECT_GCC=3D/usr/bin/gcc
> COLLECT_LTO_WRAPPER=3D/usr/libexec/gcc/x86_64-redhat-linux/12/lto-wrapper
> OFFLOAD_TARGET_NAMES=3Dnvptx-none
> OFFLOAD_TARGET_DEFAULT=3D1
> Target: x86_64-redhat-linux
> Configured with: ../configure --enable-bootstrap --enable-languages=3Dc,c=
++,fortran,objc,obj-c++,ada,go,d,lto --prefix=3D/usr --mandir=3D/usr/share/=
man --infodir=3D/usr/share/info --with-bugurl=3Dhttp://bugzilla.redhat.com/=
bugzilla --enable-shared --enable-threads=3Dposix --enable-checking=3Drelea=
se --enable-multilib --with-system-zlib --enable-__cxa_atexit --disable-lib=
unwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --wit=
h-gcc-major-version-only --enable-libstdcxx-backtrace --with-linker-hash-st=
yle=3Dgnu --enable-plugin --enable-initfini-array --with-isl=3D/builddir/bu=
ild/BUILD/gcc-12.1.1-20220507/obj-x86_64-redhat-linux/isl-install --enable-=
offload-targets=3Dnvptx-none --without-cuda-driver --enable-offload-default=
ed --enable-gnu-indirect-function --enable-cet --with-tune=3Dgeneric --with=
-arch_32=3Di686 --build=3Dx86_64-redhat-linux --with-build-config=3Dbootstr=
ap-lto --enable-link-serialization=3D1
> Thread model: posix
> Supported LTO compression algorithms: zlib zstd
> gcc version 12.1.1 20220507 (Red Hat 12.1.1-1) (GCC)
> [acme@quaco perf-urgent]$
>
> [root@quaco ~]# perf test -v 42
>  42: BPF filter                                                      :
>  42.1: Basic BPF filtering                                           :
> --- start ---
> test child forked, pid 638881
> Kernel build dir is set to /lib/modules/5.17.11-300.fc36.x86_64/build
> set env: KBUILD_DIR=3D/lib/modules/5.17.11-300.fc36.x86_64/build
> unset env: KBUILD_OPTS
> include option is set to -nostdinc -I./arch/x86/include -I./arch/x86/incl=
ude/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/include/g=
enerated/uapi -I./include/uapi -I./include/generated/uapi -include ./includ=
e/linux/compiler-version.h -include ./include/linux/kconfig.h
> set env: NR_CPUS=3D8
> set env: LINUX_VERSION_CODE=3D0x5110b
> set env: CLANG_EXEC=3D/usr/lib64/ccache/clang
> set env: CLANG_OPTIONS=3D-xc -g
> set env: KERNEL_INC_OPTIONS=3D-nostdinc -I./arch/x86/include -I./arch/x86=
/include/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/incl=
ude/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./i=
nclude/linux/compiler-version.h -include ./include/linux/kconfig.h
> set env: PERF_BPF_INC_OPTIONS=3D-I/home/acme/lib/perf/include/bpf
> set env: WORKING_DIR=3D/lib/modules/5.17.11-300.fc36.x86_64/build
> set env: CLANG_SOURCE=3D-
> llvm compiling command template: echo '// SPDX-License-Identifier: GPL-2.=
0
> /*
>  * bpf-script-example.c
>  * Test basic LLVM building
>  */
> #ifndef LINUX_VERSION_CODE
> # error Need LINUX_VERSION_CODE
> # error Example: for 4.2 kernel, put 'clang-opt=3D"-DLINUX_VERSION_CODE=
=3D0x40200" into llvm section of ~/.perfconfig'
> #endif
> #define BPF_ANY 0
> #define BPF_MAP_TYPE_ARRAY 2
> #define BPF_FUNC_map_lookup_elem 1
> #define BPF_FUNC_map_update_elem 2
>
> static void *(*bpf_map_lookup_elem)(void *map, void *key) =3D
>         (void *) BPF_FUNC_map_lookup_elem;
> static void *(*bpf_map_update_elem)(void *map, void *key, void *value, in=
t flags) =3D
>         (void *) BPF_FUNC_map_update_elem;
>
> struct bpf_map_def {
>         unsigned int type;
>         unsigned int key_size;
>         unsigned int value_size;
>         unsigned int max_entries;
> };
>
> #define SEC(NAME) __attribute__((section(NAME), used))
> struct bpf_map_def SEC("maps") flip_table =3D {
>         .type =3D BPF_MAP_TYPE_ARRAY,
>         .key_size =3D sizeof(int),
>         .value_size =3D sizeof(int),
>         .max_entries =3D 1,
> };
>
> SEC("func=3Ddo_epoll_wait")
> int bpf_func__SyS_epoll_pwait(void *ctx)
> {
>         int ind =3D0;
>         int *flag =3D bpf_map_lookup_elem(&flip_table, &ind);
>         int new_flag;
>         if (!flag)
>                 return 0;
>         /* flip flag and store back */
>         new_flag =3D !*flag;
>         bpf_map_update_elem(&flip_table, &ind, &new_flag, BPF_ANY);
>         return new_flag;
> }
> char _license[] SEC("license") =3D "GPL";
> int _version SEC("version") =3D LINUX_VERSION_CODE;
> ' | $CLANG_EXEC -D__KERNEL__ -D__NR_CPUS__=3D$NR_CPUS -DLINUX_VERSION_COD=
E=3D$LINUX_VERSION_CODE $CLANG_OPTIONS $PERF_BPF_INC_OPTIONS $KERNEL_INC_OP=
TIONS -Wno-unused-value -Wno-pointer-sign -working-directory $WORKING_DIR -=
c "$CLANG_SOURCE" -target bpf $CLANG_EMIT_LLVM -O2 -o - $LLVM_OPTIONS_PIPE
> llvm compiling command : echo '// SPDX-License-Identifier: GPL-2.0
> /*
>  * bpf-script-example.c
>  * Test basic LLVM building
>  */
> #ifndef LINUX_VERSION_CODE
> # error Need LINUX_VERSION_CODE
> # error Example: for 4.2 kernel, put 'clang-opt=3D-DLINUX_VERSION_CODE=3D=
0x40200 into llvm section of ~/.perfconfig'
> #endif
> #define BPF_ANY 0
> #define BPF_MAP_TYPE_ARRAY 2
> #define BPF_FUNC_map_lookup_elem 1
> #define BPF_FUNC_map_update_elem 2
>
> static void *(*bpf_map_lookup_elem)(void *map, void *key) =3D
>         (void *) BPF_FUNC_map_lookup_elem;
> static void *(*bpf_map_update_elem)(void *map, void *key, void *value, in=
t flags) =3D
>         (void *) BPF_FUNC_map_update_elem;
>
> struct bpf_map_def {
>         unsigned int type;
>         unsigned int key_size;
>         unsigned int value_size;
>         unsigned int max_entries;
> };
>
> #define SEC(NAME) __attribute__((section(NAME), used))
> struct bpf_map_def SEC(maps) flip_table =3D {
>         .type =3D BPF_MAP_TYPE_ARRAY,
>         .key_size =3D sizeof(int),
>         .value_size =3D sizeof(int),
>         .max_entries =3D 1,
> };
>
> SEC(func=3Ddo_epoll_wait)
> int bpf_func__SyS_epoll_pwait(void *ctx)
> {
>         int ind =3D0;
>         int *flag =3D bpf_map_lookup_elem(&flip_table, &ind);
>         int new_flag;
>         if (!flag)
>                 return 0;
>         /* flip flag and store back */
>         new_flag =3D !*flag;
>         bpf_map_update_elem(&flip_table, &ind, &new_flag, BPF_ANY);
>         return new_flag;
> }
> char _license[] SEC(license) =3D GPL;
> int _version SEC(version) =3D LINUX_VERSION_CODE;
> ' | /usr/lib64/ccache/clang -D__KERNEL__ -D__NR_CPUS__=3D8 -DLINUX_VERSIO=
N_CODE=3D0x5110b -xc -g -I/home/acme/lib/perf/include/bpf -nostdinc -I./arc=
h/x86/include -I./arch/x86/include/generated  -I./include -I./arch/x86/incl=
ude/uapi -I./arch/x86/include/generated/uapi -I./include/uapi -I./include/g=
enerated/uapi -include ./include/linux/compiler-version.h -include ./includ=
e/linux/kconfig.h  -Wno-unused-value -Wno-pointer-sign -working-directory /=
lib/modules/5.17.11-300.fc36.x86_64/build -c - -target bpf  -O2 -o -
> libbpf: loading object '[basic_bpf_test]' from buffer
> libbpf: elf: section(3) func=3Ddo_epoll_wait, size 192, link 0, flags 6, =
type=3D1
> libbpf: sec 'func=3Ddo_epoll_wait': found program 'bpf_func__SyS_epoll_pw=
ait' at insn offset 0 (0 bytes), code size 24 insns (192 bytes)
> libbpf: elf: section(4) .relfunc=3Ddo_epoll_wait, size 32, link 22, flags=
 0, type=3D9
> libbpf: elf: section(5) maps, size 16, link 0, flags 3, type=3D1
> libbpf: elf: section(6) license, size 4, link 0, flags 3, type=3D1
> libbpf: license of [basic_bpf_test] is GPL
> libbpf: elf: section(7) version, size 4, link 0, flags 3, type=3D1
> libbpf: kernel version of [basic_bpf_test] is 5110b
> libbpf: elf: section(13) .BTF, size 576, link 0, flags 0, type=3D1
> libbpf: elf: section(15) .BTF.ext, size 256, link 0, flags 0, type=3D1
> libbpf: elf: section(22) .symtab, size 336, link 1, flags 0, type=3D2
> libbpf: looking for externs among 14 symbols...
> libbpf: collected 0 externs total
> libbpf: elf: found 1 legacy map definitions (16 bytes) in [basic_bpf_test=
]
> libbpf: map 'flip_table' (legacy): legacy map definitions are deprecated,=
 use BTF-defined maps instead
> libbpf: map 'flip_table' (legacy): at sec_idx 5, offset 0.
> libbpf: map 11 is "flip_table"
> libbpf: Use of BPF_ANNOTATE_KV_PAIR is deprecated, use BTF-defined maps i=
n .maps section instead
> libbpf: map:flip_table container_name:____btf_map_flip_table cannot be fo=
und in BTF. Missing BPF_ANNOTATE_KV_PAIR?
> libbpf: sec '.relfunc=3Ddo_epoll_wait': collecting relocation for section=
(3) 'func=3Ddo_epoll_wait'
> libbpf: sec '.relfunc=3Ddo_epoll_wait': relo #0: insn #4 against 'flip_ta=
ble'
> libbpf: prog 'bpf_func__SyS_epoll_pwait': found map 0 (flip_table, sec 5,=
 off 0) for insn #4
> libbpf: sec '.relfunc=3Ddo_epoll_wait': relo #1: insn #17 against 'flip_t=
able'
> libbpf: prog 'bpf_func__SyS_epoll_pwait': found map 0 (flip_table, sec 5,=
 off 0) for insn #17
> bpf: config program 'func=3Ddo_epoll_wait'
> symbol:do_epoll_wait file:(null) line:0 offset:0 return:0 lazy:(null)
> bpf: config 'func=3Ddo_epoll_wait' is ok
> Looking at the vmlinux_path (8 entries long)
> symsrc__init: build id mismatch for vmlinux.
> Using /usr/lib/debug/lib/modules/5.17.11-300.fc36.x86_64/vmlinux for symb=
ols
> Open Debuginfo file: /usr/lib/debug/.build-id/f2/26f5d75e6842add57095a061=
5a1e5c16783dd7.debug
> Try to find probe point from debuginfo.
> Matched function: do_epoll_wait [38063fb]
> Probe point found: do_epoll_wait+0
> Found 1 probe_trace_events.
> Opening /sys/kernel/tracing//kprobe_events write=3D1
> Opening /sys/kernel/tracing//README write=3D0
> Writing event: p:perf_bpf_probe/func _text+3943040
> libbpf: map 'flip_table': created successfully, fd=3D4
> libbpf: prog 'bpf_func__SyS_epoll_pwait': BPF program load failed: Invali=
d argument
> libbpf: prog 'bpf_func__SyS_epoll_pwait': -- BEGIN PROG LOAD LOG --
> Invalid insn code at line_info[11].insn_off

Mismatched line_info.

Jiri, I think we need to clear func_info and line_info in
bpf_program__set_insns() because at that point func/line info can be
mismatched and won't correspond to the actual set of instructions.

Arnaldo, thanks for testing and providing details!

> processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0 pe=
ak_states 0 mark_read 0
> -- END PROG LOAD LOG --
> libbpf: failed to load program 'bpf_func__SyS_epoll_pwait'
> libbpf: failed to load object '[basic_bpf_test]'
> bpf: load objects failed: err=3D-22: (Invalid argument)
> Failed to add events selected by BPF
> Opening /sys/kernel/tracing//kprobe_events write=3D1
> Opening /sys/kernel/tracing//uprobe_events write=3D1
> Parsing probe_events: p:perf_bpf_probe/func _text+3943040
> Group:perf_bpf_probe Event:func probe:p
> Writing event: -:perf_bpf_probe/func
> test child finished with -1

[...]
