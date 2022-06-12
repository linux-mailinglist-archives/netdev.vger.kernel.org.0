Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3456F547B10
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 18:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiFLQZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 12:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiFLQZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 12:25:15 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060AC5E156;
        Sun, 12 Jun 2022 09:25:14 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id s1so4407048wra.9;
        Sun, 12 Jun 2022 09:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5flk/qL29qSBs94WkHtYEwD+wqRTcbtd2jwDx4HEmtw=;
        b=kCZC/ubVDGgfgJOVNWXI+3kJ02DI3Gcre3OAO5T1JVJ2mwAXcSAawvwpWwyLVABuc5
         NH2/mT8v9/3bXBTqbmcCtmhlh6dPIaGuOxAEYaL6Hkxe5YTx+duCyOyGZlo1IECtuy53
         7FRR5yfqFsZB+fpymAiGle7AZygTeFIuAxut5r4AsYPnXif51MfXXwOl4m30l1RInQM1
         mS1zvywicUEs44S/k3NvXw8TkTxy/giidylVZ7J0WBvboOvJ+8gcq08/OlUQqviyguub
         dEaYDj86E17t4szLBjvnKN4iP25sF9tSY60/z3qQxyEC36Vpg2L4h1HVsm7W/tcvnyex
         KXlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5flk/qL29qSBs94WkHtYEwD+wqRTcbtd2jwDx4HEmtw=;
        b=4383g0FTSX0ZGT0rFp4Jadyn7fB0bPhKIcmuY6oMRbR+1uks7uYjPNF6WJ0BR4kMgi
         /mZSi0cFaoeU8V+meABtq3Ij/FlxB6OklhMTJynrO3NkyY5Qb3I2IyYI0rikwmG6ZzM/
         cvpmFsKsfraXIreCIt+thQqXcLU1da2rlslkAyfY7uMwD4kEMkDz6idRMrr/ZuOmdoFS
         abP+tPi66zfj+2r45lKDowPnzP+Y1oE2j509aYoMEq11BuP9FDN1K3ETijiSwJ2E0EKD
         ufmuYxWXSj4gvOSFCOFVUFpPomSADj3LO86heTZljK2abdKQ3p2ktlYDCter6EGRzRBT
         fMmA==
X-Gm-Message-State: AOAM531rjm+oY2v2wr4aSzmigdrHUDxz8ovNq+q3Ts/W7yCjKInaFlBZ
        c+wg3hyyyQS9X3peDsrylM4=
X-Google-Smtp-Source: ABdhPJzQR8sIKhKkmeF3b5mQJO9Q/sBMcf3hU2YFJhcGfnIIEvoVi8aCQdWdCSB7rstN0yVsI4LuPw==
X-Received: by 2002:adf:e991:0:b0:210:3222:cd1e with SMTP id h17-20020adfe991000000b002103222cd1emr55285164wrm.49.1655051112386;
        Sun, 12 Jun 2022 09:25:12 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id r15-20020a05600c35cf00b0039c54f34948sm11277924wmq.5.2022.06.12.09.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 09:25:11 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Sun, 12 Jun 2022 18:25:09 +0200
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <YqYTZVa44Y6RQ11W@krava>
References: <20220603204509.15044-1-jolsa@kernel.org>
 <CAEf4BzbT4Z=B2hZxTQf1MrCp6TGiMgP+_t7p8G5A+RdVyNP+8w@mail.gmail.com>
 <YqOOsL8EbbO3lhmC@kernel.org>
 <CAEf4BzaKP8MHtGZDVSpwbCxNUD4zY9wkjEa4HKR0LWxYKW5cGQ@mail.gmail.com>
 <YqOvYo1tp32gKviM@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqOvYo1tp32gKviM@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 10:53:57PM +0200, Jiri Olsa wrote:
> On Fri, Jun 10, 2022 at 11:45:48AM -0700, Andrii Nakryiko wrote:
> > On Fri, Jun 10, 2022 at 11:34 AM Arnaldo Carvalho de Melo
> > <acme@kernel.org> wrote:
> > >
> > > Em Thu, Jun 09, 2022 at 01:31:52PM -0700, Andrii Nakryiko escreveu:
> > > > On Fri, Jun 3, 2022 at 1:45 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > > > >
> > > > > hi,
> > > > > sending change we discussed some time ago [1] to get rid of
> > > > > some deprecated functions we use in perf prologue code.
> > > > >
> > > > > Despite the gloomy discussion I think the final code does
> > > > > not look that bad ;-)
> > > > >
> > > > > This patchset removes following libbpf functions from perf:
> > > > >   bpf_program__set_prep
> > > > >   bpf_program__nth_fd
> > > > >   struct bpf_prog_prep_result
> > > > >
> > > > > v4 changes:
> > > > >   - fix typo [Andrii]
> > > > >
> > > > > v3 changes:
> > > > >   - removed R0/R1 zero init in libbpf_prog_prepare_load_fn,
> > > > >     because it's not needed [Andrii]
> > > > >   - rebased/post on top of bpf-next/master which now has
> > > > >     all the needed perf/core changes
> > > > >
> > > > > v2 changes:
> > > > >   - use fallback section prog handler, so we don't need to
> > > > >     use section prefix [Andrii]
> > > > >   - realloc prog->insns array in bpf_program__set_insns [Andrii]
> > > > >   - squash patch 1 from previous version with
> > > > >     bpf_program__set_insns change [Daniel]
> > > > >   - patch 3 already merged [Arnaldo]
> > > > >   - added more comments
> > > > >
> > > > > thanks,
> > > > > jirka
> > > > >
> > > >
> > > > Arnaldo, can I get an ack from you for this patch set? Thank you!
> > >
> > > So, before these patches:
> > >
> > > [acme@quaco perf-urgent]$ git log --oneline -5
> > > 22905f78d181f446 (HEAD) libperf evsel: Open shouldn't leak fd on failure
> > > a3c6da3dbd4bdf9c perf test: Fix "perf stat CSV output linter" test on s390
> > > 785cb9e85e8ba66f perf unwind: Fix uninitialized variable
> > > 874c8ca1e60b2c56 netfs: Fix gcc-12 warning by embedding vfs inode in netfs_i_context
> > > 3d9f55c57bc3659f Merge tag 'fs_for_v5.19-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
> > > [acme@quaco perf-urgent]$ sudo su -
> > > [root@quaco ~]# perf -v
> > > perf version 5.19.rc1.g22905f78d181
> > > [root@quaco ~]# perf test 42
> > >  42: BPF filter                                                      :
> > >  42.1: Basic BPF filtering                                           : Ok
> > >  42.2: BPF pinning                                                   : Ok
> > >  42.3: BPF prologue generation                                       : Ok
> > > [root@quaco ~]#
> > >
> > > And after:
> > >
> > > [acme@quaco perf-urgent]$ git log --oneline -5
> > > f8ec656242acf2de (HEAD -> perf/urgent) perf tools: Rework prologue generation code
> > > a750a8dd7e5d2d4b perf tools: Register fallback libbpf section handler
> > > d28f2a8ad42af160 libperf evsel: Open shouldn't leak fd on failure
> > > a3c6da3dbd4bdf9c perf test: Fix "perf stat CSV output linter" test on s390
> > > 785cb9e85e8ba66f perf unwind: Fix uninitialized variable
> > > [acme@quaco perf-urgent]$ sudo su -
> > > [root@quaco ~]# perf -v
> > > perf version 5.19.rc1.gf8ec656242ac
> > > [root@quaco ~]# perf test 42
> > >  42: BPF filter                                                      :
> > >  42.1: Basic BPF filtering                                           : FAILED!
> > >  42.2: BPF pinning                                                   : FAILED!
> > >  42.3: BPF prologue generation                                       : Ok
> > > [root@quaco ~]#
> > >
> > > Jiri, can you try reproducing these? Do this require some other work
> > > that is in bpf-next/master? Lemme try...
> > >
> > > Further details:
> > >
> > > [acme@quaco perf-urgent]$ clang -v
> > > clang version 13.0.0 (five:git/llvm-project d667b96c98438edcc00ec85a3b151ac2dae862f3)
> > > Target: x86_64-unknown-linux-gnu
> > > Thread model: posix
> > > InstalledDir: /usr/local/bin
> > > Found candidate GCC installation: /usr/lib/gcc/x86_64-redhat-linux/12
> > > Selected GCC installation: /usr/lib/gcc/x86_64-redhat-linux/12
> > > Candidate multilib: .;@m64
> > > Candidate multilib: 32;@m32
> > > Selected multilib: .;@m64
> > > [acme@quaco perf-urgent]$ cat /etc/fedora-release
> > > Fedora release 36 (Thirty Six)
> > > [acme@quaco perf-urgent]$ gcc -v
> > > Using built-in specs.
> > > COLLECT_GCC=/usr/bin/gcc
> > > COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/12/lto-wrapper
> > > OFFLOAD_TARGET_NAMES=nvptx-none
> > > OFFLOAD_TARGET_DEFAULT=1
> > > Target: x86_64-redhat-linux
> > > Configured with: ../configure --enable-bootstrap --enable-languages=c,c++,fortran,objc,obj-c++,ada,go,d,lto --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-shared --enable-threads=posix --enable-checking=release --enable-multilib --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-gcc-major-version-only --enable-libstdcxx-backtrace --with-linker-hash-style=gnu --enable-plugin --enable-initfini-array --with-isl=/builddir/build/BUILD/gcc-12.1.1-20220507/obj-x86_64-redhat-linux/isl-install --enable-offload-targets=nvptx-none --without-cuda-driver --enable-offload-defaulted --enable-gnu-indirect-function --enable-cet --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux --with-build-config=bootstrap-lto --enable-link-serialization=1
> > > Thread model: posix
> > > Supported LTO compression algorithms: zlib zstd
> > > gcc version 12.1.1 20220507 (Red Hat 12.1.1-1) (GCC)
> > > [acme@quaco perf-urgent]$
> > >
> > > [root@quaco ~]# perf test -v 42
> > >  42: BPF filter                                                      :
> > >  42.1: Basic BPF filtering                                           :
> > > --- start ---
> > > test child forked, pid 638881
> > > Kernel build dir is set to /lib/modules/5.17.11-300.fc36.x86_64/build
> > > set env: KBUILD_DIR=/lib/modules/5.17.11-300.fc36.x86_64/build
> > > unset env: KBUILD_OPTS
> > > include option is set to -nostdinc -I./arch/x86/include -I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/compiler-version.h -include ./include/linux/kconfig.h
> > > set env: NR_CPUS=8
> > > set env: LINUX_VERSION_CODE=0x5110b
> > > set env: CLANG_EXEC=/usr/lib64/ccache/clang
> > > set env: CLANG_OPTIONS=-xc -g
> 
> ok, it's the BTF debug info as Andrii mentioned below,
> I assume you have 'clang-opt=-g' in .perfconfig, right?
> 
> when I add it to mine I can reproduce, perfect
> 
> SNIP
> 
> > > bpf: config 'func=do_epoll_wait' is ok
> > > Looking at the vmlinux_path (8 entries long)
> > > symsrc__init: build id mismatch for vmlinux.
> > > Using /usr/lib/debug/lib/modules/5.17.11-300.fc36.x86_64/vmlinux for symbols
> > > Open Debuginfo file: /usr/lib/debug/.build-id/f2/26f5d75e6842add57095a0615a1e5c16783dd7.debug
> > > Try to find probe point from debuginfo.
> > > Matched function: do_epoll_wait [38063fb]
> > > Probe point found: do_epoll_wait+0
> > > Found 1 probe_trace_events.
> > > Opening /sys/kernel/tracing//kprobe_events write=1
> > > Opening /sys/kernel/tracing//README write=0
> > > Writing event: p:perf_bpf_probe/func _text+3943040
> > > libbpf: map 'flip_table': created successfully, fd=4
> > > libbpf: prog 'bpf_func__SyS_epoll_pwait': BPF program load failed: Invalid argument
> > > libbpf: prog 'bpf_func__SyS_epoll_pwait': -- BEGIN PROG LOAD LOG --
> > > Invalid insn code at line_info[11].insn_off
> > 
> > Mismatched line_info.
> > 
> > Jiri, I think we need to clear func_info and line_info in
> > bpf_program__set_insns() because at that point func/line info can be
> > mismatched and won't correspond to the actual set of instructions.

so the problem is that we prepend init proglogue instructions
for each program not just for the one that needs it, so it will
mismatch later on.. the fix below makes it work for me

Arnaldo,
I squashed and pushed the change below changes to my bpf/depre
branch, could you please retest?

thanks,
jirka


---
diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
index 30d0e688beec..6bd7c288e820 100644
--- a/tools/perf/util/bpf-loader.c
+++ b/tools/perf/util/bpf-loader.c
@@ -107,6 +107,17 @@ static int bpf_perf_object__add(struct bpf_object *obj)
 	return perf_obj ? 0 : -ENOMEM;
 }
 
+static void *program_priv(const struct bpf_program *prog)
+{
+	void *priv;
+
+	if (IS_ERR_OR_NULL(bpf_program_hash))
+		return NULL;
+	if (!hashmap__find(bpf_program_hash, prog, &priv))
+		return NULL;
+	return priv;
+}
+
 static struct bpf_insn prologue_init_insn[] = {
 	BPF_MOV64_IMM(BPF_REG_2, 0),
 	BPF_MOV64_IMM(BPF_REG_3, 0),
@@ -120,9 +131,18 @@ static int libbpf_prog_prepare_load_fn(struct bpf_program *prog,
 {
 	size_t init_size_cnt = ARRAY_SIZE(prologue_init_insn);
 	size_t orig_insn_cnt, insn_cnt, init_size, orig_size;
+	struct bpf_prog_priv *priv = program_priv(prog);
 	const struct bpf_insn *orig_insn;
 	struct bpf_insn *insn;
 
+	if (IS_ERR_OR_NULL(priv)) {
+		pr_debug("bpf: failed to get private field\n");
+		return -BPF_LOADER_ERRNO__INTERNAL;
+	}
+
+	if (!priv->need_prologue)
+		return 0;
+
 	/* prepend initialization code to program instructions */
 	orig_insn = bpf_program__insns(prog);
 	orig_insn_cnt = bpf_program__insn_cnt(prog);
@@ -312,17 +332,6 @@ static bool ptr_equal(const void *key1, const void *key2,
 	return key1 == key2;
 }
 
-static void *program_priv(const struct bpf_program *prog)
-{
-	void *priv;
-
-	if (IS_ERR_OR_NULL(bpf_program_hash))
-		return NULL;
-	if (!hashmap__find(bpf_program_hash, prog, &priv))
-		return NULL;
-	return priv;
-}
-
 static int program_set_priv(struct bpf_program *prog, void *priv)
 {
 	void *old_priv;
