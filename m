Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3111CBD04
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 05:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgEIDqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 23:46:25 -0400
Received: from conssluserg-01.nifty.com ([210.131.2.80]:64746 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgEIDqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 23:46:25 -0400
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id 0493jxxE025229;
        Sat, 9 May 2020 12:46:00 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 0493jxxE025229
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1588995960;
        bh=/JfKiL/RGM8Ul2qInDwK96irbgr1Va5ryrfxFSjgTKg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=k06FdTzRKjrdElXIvitp9/Xdr2SgjgjsSFFy4/BhS8s79E3Dgq59mjxs15bqlSAxh
         24Ga0Sa7FZAb1Bb7j/ZY3oj3d1igqMjP2fe6Ar5uq/YOXHmWE7Tmt7iPXwDIvImgg+
         ElL5upiNatgE6IsDYO0EQdPVawNFPsrGHNOM3qJGzru2VF1bCQOsud3t+Eb39JEM1s
         t0mP5B5k641KRmZlL905p65MdRB7nqrJXMuPlA9wU8ZjcwI8hTE4zjpdbRJNWq8F1X
         9hI+9PpsuJiHkLvPIq8lzZeE/cZdLZ2OjpwCccBHxuyviPRkROx332ILPCIumpMGac
         H5/S5LST1A6NQ==
X-Nifty-SrcIP: [209.85.217.53]
Received: by mail-vs1-f53.google.com with SMTP id 1so2356203vsl.9;
        Fri, 08 May 2020 20:46:00 -0700 (PDT)
X-Gm-Message-State: AGi0PuakDG59gIRJShThevXYfuAkzZ/ZK3fI5E20eVice06cIRNOgNJq
        YNClJPKC5B6lnY9bIzn8+XgbCTVEUEfeN4TbF3A=
X-Google-Smtp-Source: APiQypKq/Kh2fPpShJ26DNT0TDaeZkwkivL6BcM96eY8ViOawYkv31II+HXjEPNIT9vFQPyHbYsvWPbLtj3Evo3++EU=
X-Received: by 2002:a67:db0d:: with SMTP id z13mr4634859vsj.155.1588995958737;
 Fri, 08 May 2020 20:45:58 -0700 (PDT)
MIME-Version: 1.0
References: <251580.1588912756@turing-police>
In-Reply-To: <251580.1588912756@turing-police>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Sat, 9 May 2020 12:45:22 +0900
X-Gmail-Original-Message-ID: <CAK7LNARbKdfGiozX+WrF7fTSf6tpXPUQ8Hr=jC_phUwZa_FONg@mail.gmail.com>
Message-ID: <CAK7LNARbKdfGiozX+WrF7fTSf6tpXPUQ8Hr=jC_phUwZa_FONg@mail.gmail.com>
Subject: Re: linux-next 20200506 - build failure with net/bpfilter/bpfilter_umh
To:     =?UTF-8?Q?Valdis_Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc:     Sam Ravnborg <sam@ravnborg.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 2:22 PM Valdis Kl=C4=93tnieks <valdis.kletnieks@vt.e=
du> wrote:
>
> My kernel build came to a screeching halt with:
>
>   CHECK   net/bpfilter/bpfilter_kern.c
>   CC [M]  net/bpfilter/bpfilter_kern.o
>   CC [U]  net/bpfilter/main.o
>   LD [U]  net/bpfilter/bpfilter_umh
> /usr/bin/ld: cannot find -lc
> collect2: error: ld returned 1 exit status
> make[2]: *** [scripts/Makefile.userprogs:36: net/bpfilter/bpfilter_umh] E=
rror 1
> make[1]: *** [scripts/Makefile.build:494: net/bpfilter] Error 2
> make: *** [Makefile:1726: net] Error 2
>
> The culprit is this commit:

Thanks. I will try to fix it,
but my commit is innocent because
it is just textual cleanups.
No functional change is intended.


This '-static' option has existed since
the day 1 of bpfilter umh support.
See commit d2ba09c17a0647f899d6c20a11bab9e6d3382f07



I built the mainline kernel in
Fedora running on docker.

I was able to reproduce the same issue.


[masahiro@ed7f2ae1915f linux]$ git log --oneline -1
0e698dfa2822 (HEAD, tag: v5.7-rc4) Linux 5.7-rc4
[masahiro@ed7f2ae1915f linux]$ make  defconfig
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/confdata.o
  HOSTCC  scripts/kconfig/expr.o
  LEX     scripts/kconfig/lexer.lex.c
  YACC    scripts/kconfig/parser.tab.[ch]
  HOSTCC  scripts/kconfig/lexer.lex.o
  HOSTCC  scripts/kconfig/parser.tab.o
  HOSTCC  scripts/kconfig/preprocess.o
  HOSTCC  scripts/kconfig/symbol.o
  HOSTCC  scripts/kconfig/util.o
  HOSTLD  scripts/kconfig/conf
*** Default configuration is based on 'x86_64_defconfig'
#
# configuration written to .config
#
[masahiro@ed7f2ae1915f linux]$ scripts/config -e BPFILTER
[masahiro@ed7f2ae1915f linux]$ scripts/config -e BPFILTER_UMH
[masahiro@ed7f2ae1915f linux]$ make -j24 net/bpfilter/
scripts/kconfig/conf  --syncconfig Kconfig
  SYSTBL  arch/x86/include/generated/asm/syscalls_32.h
  SYSHDR  arch/x86/include/generated/asm/unistd_32_ia32.h
  SYSHDR  arch/x86/include/generated/asm/unistd_64_x32.h
  SYSTBL  arch/x86/include/generated/asm/syscalls_64.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_32.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_64.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_x32.h
  WRAP    arch/x86/include/generated/uapi/asm/bpf_perf_event.h
  WRAP    arch/x86/include/generated/uapi/asm/errno.h
  WRAP    arch/x86/include/generated/uapi/asm/ioctl.h
  WRAP    arch/x86/include/generated/uapi/asm/ioctls.h
  WRAP    arch/x86/include/generated/uapi/asm/fcntl.h
  WRAP    arch/x86/include/generated/uapi/asm/param.h
  WRAP    arch/x86/include/generated/uapi/asm/ipcbuf.h
  WRAP    arch/x86/include/generated/uapi/asm/resource.h
  WRAP    arch/x86/include/generated/uapi/asm/poll.h
  WRAP    arch/x86/include/generated/uapi/asm/socket.h
  WRAP    arch/x86/include/generated/uapi/asm/sockios.h
  WRAP    arch/x86/include/generated/uapi/asm/termbits.h
  WRAP    arch/x86/include/generated/uapi/asm/termios.h
  WRAP    arch/x86/include/generated/uapi/asm/types.h
  HOSTCC  arch/x86/tools/relocs_32.o
  HOSTCC  arch/x86/tools/relocs_64.o
  HOSTCC  arch/x86/tools/relocs_common.o
  WRAP    arch/x86/include/generated/asm/export.h
  WRAP    arch/x86/include/generated/asm/early_ioremap.h
  WRAP    arch/x86/include/generated/asm/dma-contiguous.h
  WRAP    arch/x86/include/generated/asm/mcs_spinlock.h
  WRAP    arch/x86/include/generated/asm/mm-arch-hooks.h
  WRAP    arch/x86/include/generated/asm/mmiowb.h
  HOSTCC  scripts/kallsyms
  HOSTCC  scripts/sorttable
  HOSTCC  scripts/asn1_compiler
  UPD     include/config/kernel.release
  DESCEND  objtool
  HOSTCC  scripts/selinux/mdp/mdp
  HOSTCC  scripts/selinux/genheaders/genheaders
  UPD     include/generated/utsrelease.h
scripts/kallsyms.c: In function =E2=80=98read_symbol=E2=80=99:
scripts/kallsyms.c:222:2: warning: =E2=80=98strcpy=E2=80=99 writing between=
 1 and 128
bytes into a region of size 0 [-Wstringop-overflow=3D]
  222 |  strcpy(sym_name(sym), name);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~
  HOSTCC   /home/masahiro/ref/linux/tools/objtool/fixdep.o
  HOSTLD  arch/x86/tools/relocs
  HOSTLD   /home/masahiro/ref/linux/tools/objtool/fixdep-in.o
  LINK     /home/masahiro/ref/linux/tools/objtool/fixdep
  CC       /home/masahiro/ref/linux/tools/objtool/builtin-check.o
  CC       /home/masahiro/ref/linux/tools/objtool/builtin-orc.o
  CC       /home/masahiro/ref/linux/tools/objtool/check.o
  CC       /home/masahiro/ref/linux/tools/objtool/orc_gen.o
  CC       /home/masahiro/ref/linux/tools/objtool/orc_dump.o
  CC       /home/masahiro/ref/linux/tools/objtool/elf.o
  GEN      /home/masahiro/ref/linux/tools/objtool/arch/x86/lib/inat-tables.=
c
  CC       /home/masahiro/ref/linux/tools/objtool/special.o
  CC       /home/masahiro/ref/linux/tools/objtool/objtool.o
  CC       /home/masahiro/ref/linux/tools/objtool/libstring.o
  CC       /home/masahiro/ref/linux/tools/objtool/libctype.o
  CC       /home/masahiro/ref/linux/tools/objtool/str_error_r.o
  CC       /home/masahiro/ref/linux/tools/objtool/librbtree.o
  CC       /home/masahiro/ref/linux/tools/objtool/exec-cmd.o
  CC       /home/masahiro/ref/linux/tools/objtool/help.o
  CC       /home/masahiro/ref/linux/tools/objtool/pager.o
  CC       /home/masahiro/ref/linux/tools/objtool/parse-options.o
  CC       /home/masahiro/ref/linux/tools/objtool/run-command.o
  CC       /home/masahiro/ref/linux/tools/objtool/sigchain.o
  CC       /home/masahiro/ref/linux/tools/objtool/arch/x86/decode.o
  CC       /home/masahiro/ref/linux/tools/objtool/subcmd-config.o
  LD       /home/masahiro/ref/linux/tools/objtool/arch/x86/objtool-in.o
  LD       /home/masahiro/ref/linux/tools/objtool/libsubcmd-in.o
  AR       /home/masahiro/ref/linux/tools/objtool/libsubcmd.a
  CC      scripts/mod/devicetable-offsets.s
  CC      scripts/mod/empty.o
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/sumversion.o
  HOSTCC  scripts/mod/modpost.o
  UPD     scripts/mod/devicetable-offsets.h
  HOSTCC  scripts/mod/file2alias.o
  LD       /home/masahiro/ref/linux/tools/objtool/objtool-in.o
  LINK     /home/masahiro/ref/linux/tools/objtool/objtool
  HOSTLD  scripts/mod/modpost
  CC      kernel/bounds.s
  CALL    scripts/atomic/check-atomics.sh
  UPD     include/generated/timeconst.h
  UPD     include/generated/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
  UPD     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  HOSTCC  net/bpfilter/main.o
  CC      net/bpfilter/bpfilter_kern.o
  HOSTLD  net/bpfilter/bpfilter_umh
/usr/bin/ld: cannot find -lc
collect2: error: ld returned 1 exit status
make[2]: *** [scripts/Makefile.host:112: net/bpfilter/bpfilter_umh] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [scripts/Makefile.build:488: net/bpfilter] Error 2
make: *** [Makefile:1722: net] Error 2









>
> commit 0592c3c367c4c823f2a939968e72d39360fce1f4
> Author: Masahiro Yamada <masahiroy@kernel.org>
> Date:   Wed Apr 29 12:45:15 2020 +0900
>
>     bpfilter: use 'userprogs' syntax to build bpfilter_umh
>
> and specifically, this line:
>
> +userldflags +=3D -static
>
> At least on Fedora, this dies an ugly death unless you have the glibc-sta=
tic RPM
> installed (which is *not* part of the glibc-devel RPM).  Not sure how to =
fix this, or
> give a heads-up that there's a new requirement that might break the build=
.
>


--=20
Best Regards
Masahiro Yamada
