Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526AB50189F
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiDNQ0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 12:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343490AbiDNQUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 12:20:20 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA61AD3722
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 08:58:08 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id u7so9872062lfs.8
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 08:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kUk5JygR0JjFN0Ag0erLGQrnwAWSH4YiuZY4dZAUjEA=;
        b=RUbUHj5EPVqvPqq+TcTWjMmObEujlnlWApV821IL5t8M1uRkgwTulDUjjbOYSN4WPI
         khljhSPQXRuJdDH4uiwC1DuxXhbbJ6pL9FW8RLdDZcFHCR5UpB5YLdtM26KPv1SW6pfP
         ujTm+FG8ENp0TFeKo4LPSnBmEsPABXqMKaotUtnJ8o8Xy/K7NcTEqq2uPLqDqP4SVu4e
         ST2uclRcXxmgNbxoBPrfZi4qnvI4WgKjrm4IW24N4YzZbyAx7JeNtu55MmD3LmDYpsBE
         sYNCKTdE8F3O24nudhXaMfo7x7SBMqviG/NuUZBRQ8VUfGK72/yqPM1d6lvk5bJC+Qvg
         wpfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kUk5JygR0JjFN0Ag0erLGQrnwAWSH4YiuZY4dZAUjEA=;
        b=4Y5tt3EfuU0dtKwN0qqyqoPKrFtEpGS63cm9+Zb7SCpA/Vc8YFdpHP3ToKWaZFmxYY
         6rSAk07ia74Wxujv5MnotXjyEFCKR2Wl4d9megHQf6xirzCnlIfAje0vQl0EkFvNfUOf
         n013SBnpnvffILer81qG1/QS4sIZ5aZm7czm4PyT8RX3PxKQpd/47woQBhL8m9UCCn+/
         4Y5nyyrORgCfccnm5j14iMJY+0XqQcARJ87cF15uRF0igdxAedqcTJlqZTXUK/N54Cww
         IPPYcKal4QDfCavOyGOqLJcnecr6CjFN7DUN26hMXzkR4JeCmcB6VyefTukAwMZIBgDK
         hiHQ==
X-Gm-Message-State: AOAM5329VVgChamWC1qjQhifN0MnzJB5fSjGzQmjYgJhfY5L6JGEwTVq
        lPkTF8jmTCSEmw7kbNC1ma6lN983BxMzllfN8pesRQ==
X-Google-Smtp-Source: ABdhPJy2QACz18n8/ud36eXsqX63eh5pWrMDuc8LQppovQ/4vOzDL0k5gg3rF/y3T/W7c6TeiIEZadlBMiRVNIn9qxQ=
X-Received: by 2002:ac2:4e66:0:b0:46b:c3d3:e203 with SMTP id
 y6-20020ac24e66000000b0046bc3d3e203mr2421966lfs.380.1649951886772; Thu, 14
 Apr 2022 08:58:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220414134134.247912-1-yangjihong1@huawei.com>
In-Reply-To: <20220414134134.247912-1-yangjihong1@huawei.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 14 Apr 2022 08:57:54 -0700
Message-ID: <CAKwvOdmZCS784R5myuA=MgSnxQfS6sPUsBKbbax_QN1fSMNzbQ@mail.gmail.com>
Subject: Re: [PATCH] perf llvm: Fix compile bpf failed to cope with latest llvm
To:     Yang Jihong <yangjihong1@huawei.com>
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@kernel.org, namhyung@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, nathan@kernel.org, trix@redhat.com,
        ak@linux.intel.com, adrian.hunter@intel.com, james.clark@arm.com,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 6:42 AM Yang Jihong <yangjihong1@huawei.com> wrote:
>
> Inline assembly used by asm/sysreg.h is incompatible with latest llvm,

With "latest" llvm makes it sound like LLVM has regressed. Has it? Or
have the headers changed in a way where now inline asm from a
different target (x86) than what's being targeted (BPF)? Perhaps
fixing that is simpler?

Clang will validate inline asm before LLVM drops unreferenced static
inline functions; this was a headache getting i386 building with
clang, but not insurmountable.

> If bpf C program include "linux/ptrace.h" (which is common), compile will fail:
>
>  # perf --debug verbose record -e bpf-output/no-inherit,name=evt/ \
>                               -e ./perf_bpf_test.c/map:channel.event=evt/ ls
>  [SNIP]
>  /lib/modules/5.17/build/./arch/x86/include/asm/arch_hweight.h:20:7: error: invalid output constraint '=a' in asm
>                           : "="REG_OUT (res)
>                            ^
>  /lib/modules/5.17/build/./arch/x86/include/asm/arch_hweight.h:48:7: error: invalid output constraint '=a' in asm
>                           : "="REG_OUT (res)
>                            ^
>  In file included from /root/projects/perf-bpf/perf_bpf_test.c:2:
>  In file included from /lib/modules/5.17/build/./include/linux/ptrace.h:6:
>  In file included from /lib/modules/5.17/build/./include/linux/sched.h:12:
>  In file included from /lib/modules/5.17/build/./arch/x86/include/asm/current.h:6:
>  In file included from /lib/modules/5.17/build/./arch/x86/include/asm/percpu.h:27:
>  In file included from /lib/modules/5.17/build/./include/linux/kernel.h:25:
>  In file included from /lib/modules/5.17/build/./include/linux/math.h:6:
>  /lib/modules/5.17.0/build/./arch/x86/include/asm/div64.h:85:28: error: invalid output constraint '=a' in asm
>          asm ("mulq %2; divq %3" : "=a" (q)
>  [SNIP]
>  # cat /root/projects/perf-bpf/perf_bpf_test.c
>  /************************ BEGIN **************************/
>  #include <uapi/linux/bpf.h>
>  #include <linux/ptrace.h>
>  #include <linux/types.h>
>  #define SEC(NAME) __attribute__((section(NAME), used))
>
>  struct bpf_map_def {
>          unsigned int type;
>          unsigned int key_size;
>          unsigned int value_size;
>          unsigned int max_entries;
>  };
>
>  static int (*perf_event_output)(void *, struct bpf_map_def *, int, void *,
>      unsigned long) = (void *)BPF_FUNC_perf_event_output;
>
>  struct bpf_map_def SEC("maps") channel = {
>          .type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
>          .key_size = sizeof(int),
>          .value_size = sizeof(__u32),
>          .max_entries = __NR_CPUS__,
>  };
>
>  #define MIN_BYTES 1024
>
>  SEC("func=vfs_read")
>  int bpf_myprog(struct pt_regs *ctx)
>  {
>          long bytes = ctx->dx;
>          if (bytes >= MIN_BYTES) {
>                  perf_event_output(ctx, &channel, BPF_F_CURRENT_CPU,
>                                    &bytes, sizeof(bytes));
>          }
>
>          return 0;
>  }
>
> char _license[] SEC("license") = "GPL";
> int _version SEC("version") = LINUX_VERSION_CODE;
> /************************* END ***************************/
>
> Compilation command is modified to be the same as that in samples/bpf/Makefile,
> use clang | opt | llvm-dis | llc chain of commands to solve the problem.
> see the comment in samples/bpf/Makefile.
>
> Modifications:
> 1. Change "clang --target bpf" to chain of commands "clang | opt | llvm-dis | llc"

This will drop the --target flag. That will mess up the default target
triple, and can affect command line option feature detection.

> 2. Delete "CLANG_EMIT_LLVM" and "LLVM_OPTIONS_PIPE" macros from the compilation
>    command because the two macros are not defined and the content is empty.
> 3. Add options llvm.llvm-opt-path, llvm.llvm-dis-path, and llvm.llc-path to
>    perf config for user-defined settings, which are similar to llvm.clang-path.
> 4. Add "-Wno-address-of-packed-member" to resolve the compilation warning of
>    "/lib/modules/5.17/build/./arch/x86/include/asm/processor.h:552:17: \
>     warning: taking address of packed member 'sp0' of class or structure \
>     'x86_hw_tss' may result in an unaligned pointer value [-Waddress-of-packed-member]
>         this_cpu_write(cpu_tss_rw.x86_tss.sp0, sp0);
>                        ^~~~~~~~~~~~~~~~~~~~~~
>    /lib/modules/5.17/build/./include/linux/percpu-defs.h:508:68: note: \
>    expanded from macro 'this_cpu_write' \
>     #define this_cpu_write(pcp, val)        __pcpu_size_call(this_cpu_write_, pcp, val)",
>    which is similar to that of sample/bpf/Makefile.
>
> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
> ---
>  tools/perf/Documentation/perf-config.txt | 16 ++++++++++-
>  tools/perf/util/llvm-utils.c             | 35 ++++++++++++++++++------
>  tools/perf/util/llvm-utils.h             |  4 +++
>  3 files changed, 45 insertions(+), 10 deletions(-)
>
> diff --git a/tools/perf/Documentation/perf-config.txt b/tools/perf/Documentation/perf-config.txt
> index 0420e71698ee..48f12bd6ca9a 100644
> --- a/tools/perf/Documentation/perf-config.txt
> +++ b/tools/perf/Documentation/perf-config.txt
> @@ -655,6 +655,15 @@ llvm.*::
>         llvm.clang-path::
>                 Path to clang. If omit, search it from $PATH.
>
> +       llvm.llvm-opt-path::
> +               Path to llvm opt. If omit, search it from $PATH.
> +
> +       llvm.llvm-dis-path::
> +               Path to llvm-dis. If omit, search it from $PATH.
> +
> +       llvm.llc-path::
> +               Path to llc. If omit, search it from $PATH.
> +
>         llvm.clang-bpf-cmd-template::
>                 Cmdline template. Below lines show its default value. Environment
>                 variable is used to pass options.
> @@ -662,8 +671,13 @@ llvm.*::
>                 "-DLINUX_VERSION_CODE=$LINUX_VERSION_CODE "     \
>                 "$CLANG_OPTIONS $PERF_BPF_INC_OPTIONS $KERNEL_INC_OPTIONS " \
>                 "-Wno-unused-value -Wno-pointer-sign "          \
> +               "-Wno-address-of-packed-member "                \
>                 "-working-directory $WORKING_DIR "              \
> -               "-c \"$CLANG_SOURCE\" -target bpf $CLANG_EMIT_LLVM -O2 -o - $LLVM_OPTIONS_PIPE"
> +               "-c \"$CLANG_SOURCE\" "                               \
> +               "-O2 -emit-llvm -Xclang -disable-llvm-passes -o - | " \
> +               "$LLVM_OPT_EXEC -O2 -mtriple=bpf-pc-linux | "         \
> +               "$LLVM_DIS_EXEC | "                                   \
> +               "$LLC_EXEC -march=bpf -filetype=obj -o -"
>
>         llvm.clang-opt::
>                 Options passed to clang.
> diff --git a/tools/perf/util/llvm-utils.c b/tools/perf/util/llvm-utils.c
> index 96c8ef60f4f8..c939681dfafb 100644
> --- a/tools/perf/util/llvm-utils.c
> +++ b/tools/perf/util/llvm-utils.c
> @@ -24,11 +24,18 @@
>                 "-DLINUX_VERSION_CODE=$LINUX_VERSION_CODE "     \
>                 "$CLANG_OPTIONS $PERF_BPF_INC_OPTIONS $KERNEL_INC_OPTIONS " \
>                 "-Wno-unused-value -Wno-pointer-sign "          \
> +               "-Wno-address-of-packed-member "                \
>                 "-working-directory $WORKING_DIR "              \
> -               "-c \"$CLANG_SOURCE\" -target bpf $CLANG_EMIT_LLVM -O2 -o - $LLVM_OPTIONS_PIPE"
> +               "-c \"$CLANG_SOURCE\" "                               \
> +               "-O2 -emit-llvm -Xclang -disable-llvm-passes -o - | " \
> +               "$LLVM_OPT_EXEC -O2 -mtriple=bpf-pc-linux | "         \
> +               "$LLVM_DIS_EXEC | "                                   \
> +               "$LLC_EXEC -march=bpf -filetype=obj -o -"
>
>  struct llvm_param llvm_param = {
>         .clang_path = "clang",
> +       .llvm_opt_path = "opt",
> +       .llvm_dis_path = "llvm-dis",
>         .llc_path = "llc",
>         .clang_bpf_cmd_template = CLANG_BPF_CMD_DEFAULT_TEMPLATE,
>         .clang_opt = NULL,
> @@ -48,6 +55,12 @@ int perf_llvm_config(const char *var, const char *value)
>
>         if (!strcmp(var, "clang-path"))
>                 llvm_param.clang_path = strdup(value);
> +       else if (!strcmp(var, "llvm-opt-path"))
> +               llvm_param.llvm_opt_path = strdup(value);
> +       else if (!strcmp(var, "llvm-dis-path"))
> +               llvm_param.llvm_dis_path = strdup(value);
> +       else if (!strcmp(var, "llc-path"))
> +               llvm_param.llc_path = strdup(value);
>         else if (!strcmp(var, "clang-bpf-cmd-template"))
>                 llvm_param.clang_bpf_cmd_template = strdup(value);
>         else if (!strcmp(var, "clang-opt"))
> @@ -456,6 +469,7 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
>         char linux_version_code_str[64];
>         const char *clang_opt = llvm_param.clang_opt;
>         char clang_path[PATH_MAX], llc_path[PATH_MAX], abspath[PATH_MAX], nr_cpus_avail_str[64];
> +       char llvm_opt_path[PATH_MAX], llvm_dis_path[PATH_MAX];
>         char serr[STRERR_BUFSIZE];
>         char *kbuild_dir = NULL, *kbuild_include_opts = NULL,
>              *perf_bpf_include_opts = NULL;
> @@ -475,9 +489,10 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
>         if (!template)
>                 template = CLANG_BPF_CMD_DEFAULT_TEMPLATE;
>
> -       err = search_program_and_warn(llvm_param.clang_path,
> -                            "clang", clang_path);
> -       if (err)
> +       if (search_program_and_warn(llvm_param.clang_path, "clang", clang_path) ||
> +           search_program_and_warn(llvm_param.llvm_opt_path, "opt", llvm_opt_path) ||
> +           search_program_and_warn(llvm_param.llvm_dis_path, "llvm-dis", llvm_dis_path) ||
> +           search_program_and_warn(llvm_param.llc_path, "llc", llc_path))
>                 return -ENOENT;
>
>         /*
> @@ -495,21 +510,23 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
>
>         snprintf(linux_version_code_str, sizeof(linux_version_code_str),
>                  "0x%x", kernel_version);
> -       if (asprintf(&perf_bpf_include_opts, "-I%s/bpf", perf_include_dir) < 0)
> +       if (asprintf(&perf_bpf_include_opts, "-I%s/bpf", perf_include_dir) < 0) {
> +               err = -ENOMEM;
>                 goto errout;
> +       }
> +
>         force_set_env("NR_CPUS", nr_cpus_avail_str);
>         force_set_env("LINUX_VERSION_CODE", linux_version_code_str);
>         force_set_env("CLANG_EXEC", clang_path);
> +       force_set_env("LLVM_OPT_EXEC", llvm_opt_path);
> +       force_set_env("LLVM_DIS_EXEC", llvm_dis_path);
> +       force_set_env("LLC_EXEC", llc_path);
>         force_set_env("CLANG_OPTIONS", clang_opt);
>         force_set_env("KERNEL_INC_OPTIONS", kbuild_include_opts);
>         force_set_env("PERF_BPF_INC_OPTIONS", perf_bpf_include_opts);
>         force_set_env("WORKING_DIR", kbuild_dir ? : ".");
>
>         if (opts) {
> -               err = search_program_and_warn(llvm_param.llc_path, "llc", llc_path);
> -               if (err)
> -                       goto errout;
> -
>                 err = -ENOMEM;
>                 if (asprintf(&pipe_template, "%s -emit-llvm | %s -march=bpf %s -filetype=obj -o -",
>                               template, llc_path, opts) < 0) {
> diff --git a/tools/perf/util/llvm-utils.h b/tools/perf/util/llvm-utils.h
> index 7878a0e3fa98..e276d10f85b4 100644
> --- a/tools/perf/util/llvm-utils.h
> +++ b/tools/perf/util/llvm-utils.h
> @@ -11,6 +11,10 @@
>  struct llvm_param {
>         /* Path of clang executable */
>         const char *clang_path;
> +       /* Path of llvm opt executable */
> +       const char *llvm_opt_path;
> +       /* Path of llvm-dis executable */
> +       const char *llvm_dis_path;
>         /* Path of llc executable */
>         const char *llc_path;
>         /*
> --
> 2.30.GIT
>


-- 
Thanks,
~Nick Desaulniers
