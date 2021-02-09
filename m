Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDEE3154AE
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 18:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbhBIRIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 12:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbhBIRIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 12:08:36 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481C8C061756;
        Tue,  9 Feb 2021 09:07:56 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id q7so19562935iob.0;
        Tue, 09 Feb 2021 09:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=TQifJr5aPPIhub9mfwGeABlg7bR4JVPajGCqCrSIOyI=;
        b=fzDX22cVZ/+u1wjrorvtaA0zNZZM0eFExcEbO087UJn/aEAcCJsCUKgOj0i6wSdnHg
         Bajk+J+q9jJkQYZ2niSLgnf2vy6PZAhmppuZYW6d9xwgxmvWqpHL7fYcYo5VwUmMJBYB
         wzjjhEWxGh6YI+kU7ZirfNX77dz9D+PxvjS90YmuF5+SC0OClRg9TDNsltuWEEtq8jTS
         EWedNAvOVTpAkwEqIIqbqrhXnVgYyOQAavs+wxXCKlkp1ySOmlqV/MCVbg1dScnfW76b
         JvkB3K6XoBRg82WEUB+Hc25K+kK86+YDvhyBf2rHkl+qCdQ5KklgBkbWEd+7btJ4caJ7
         O6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=TQifJr5aPPIhub9mfwGeABlg7bR4JVPajGCqCrSIOyI=;
        b=tQPEv6ECGozmVXitq595MTmxR4bGsgfxKD4oPX1Y7paoz68qxIkNm25gfZavI7jHZV
         T05rFd8y+ko5OwNvmKDFvC/FnW9yW0dPUBroMUeL8WjVRk1NGc8KN71EqOc52nPjkYQ7
         m9GzYVEVcD1X8rSM8QGcKA3BqvLUQbVqggP4RKlibOsIyewst6pQRr3QhOHYd8fi1HoL
         j8fDpgZw5k89SfVm2BauMWSj4ehVIEcuNlWUsfax+TwGFhgBMoALLnHfzqlPlKyjPY/9
         iUZtwEotYsqT/+WovkvnwtlJiHy6uxJz3bogq4f/FPXWfdVmo0xWtcxZCZJOXTXpnRgm
         wOVw==
X-Gm-Message-State: AOAM533TbXU3p/k9fbY7DHQdeuNivtgGIUtnq8+dbOsDsXVFwF8EaiOB
        myBIlt9Vz/gkViQx23xcgVn/l6l0Ghrqof3fjqPGS8owUSiHhg==
X-Google-Smtp-Source: ABdhPJwrxt6arYx+ov2212m4Z36XOTDTvtqf8AUYE1r5O+OCzFNDjsakrvFoYCOdv6SpcrLouLGT08OBp3ecLedpisQ=
X-Received: by 2002:a02:9308:: with SMTP id d8mr14033453jah.138.1612890475636;
 Tue, 09 Feb 2021 09:07:55 -0800 (PST)
MIME-Version: 1.0
References: <20210209034416.GA1669105@ubuntu-m3-large-x86> <CAEf4BzYnT-eoKRL9_Pu_DEuqXVa+edN5F-s+k2RxBSzcsSTJ1g@mail.gmail.com>
 <20210209052311.GA125918@ubuntu-m3-large-x86> <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
 <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86> <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava> <YCKwxNDkS9rdr43W@krava> <20210209163514.GA1226277@ubuntu-m3-large-x86>
In-Reply-To: <20210209163514.GA1226277@ubuntu-m3-large-x86>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 9 Feb 2021 18:07:44 +0100
Message-ID: <CA+icZUWcyFLrFmW=btSFx_-5c-cUAYXhcjR+Jdog0-qV-bis7w@mail.gmail.com>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 5:35 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> On Tue, Feb 09, 2021 at 05:13:38PM +0100, Jiri Olsa wrote:
> > On Tue, Feb 09, 2021 at 04:09:36PM +0100, Jiri Olsa wrote:
> >
> > SNIP
> >
> > > > > > >                 DW_AT_prototyped        (true)
> > > > > > >                 DW_AT_type      (0x01cfdfe4 "long int")
> > > > > > >                 DW_AT_external  (true)
> > > > > > >
> > > > > >
> > > > > > Ok, the problem appears to be not in DWARF, but in mcount_loc d=
ata.
> > > > > > vfs_truncate's address is not recorded as ftrace-attachable, an=
d thus
> > > > > > pahole ignores it. I don't know why this happens and it's quite
> > > > > > strange, given vfs_truncate is just a normal global function.
> > > >
> > > > right, I can't see it in mcount adresses.. but it begins with instr=
uctions
> > > > that appears to be nops, which would suggest it's traceable
> > > >
> > > >   ffff80001031f430 <vfs_truncate>:
> > > >   ffff80001031f430: 5f 24 03 d5   hint    #34
> > > >   ffff80001031f434: 1f 20 03 d5   nop
> > > >   ffff80001031f438: 1f 20 03 d5   nop
> > > >   ffff80001031f43c: 3f 23 03 d5   hint    #25
> > > >
> > > > > >
> > > > > > I'd like to understand this issue before we try to fix it, but =
there
> > > > > > is at least one improvement we can make: pahole should check ft=
race
> > > > > > addresses only for static functions, not the global ones (globa=
l ones
> > > > > > should be always attachable, unless they are special, e.g., not=
race
> > > > > > and stuff). We can easily check that by looking at the correspo=
nding
> > > > > > symbol. But I'd like to verify that vfs_truncate is ftrace-atta=
chable
> > >
> > > I'm still trying to build the kernel.. however ;-)
> >
> > I finally reproduced.. however arm's not using mcount_loc
> > but some other special section.. so it's new mess for me
> >
> > however I tried the same build without LLVM=3D1 and it passed,
> > so my guess is that clang is doing something unexpected
> >
> > jirka
> >
>
> Additionally, if I remove the btfid generation section in
> scripts/link-vmlinux.sh to bypass that and get a working Image.gz,
> vfs_truncate is in the list of available functions:
>

I did the same trick by commenting in that section to provide a BROKEN
vmlinux file for linux-bpf folks.

[ BTFIDS-vmlinux.diff ]
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index eef40fa9485d..40f1b6aae553 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -330,7 +330,7 @@ vmlinux_link vmlinux "${kallsymso}" ${btf_vmlinux_bin_o=
}
# fill in BTF IDs
if [ -n "${CONFIG_DEBUG_INFO_BTF}" -a -n "${CONFIG_BPF}" ]; then
       info BTFIDS vmlinux
-       ${RESOLVE_BTFIDS} vmlinux
+       ##${RESOLVE_BTFIDS} vmlinux
fi

if [ -n "${CONFIG_BUILDTIME_TABLE_SORT}" ]; then
- EOF -

We should ask linux-kbuild/Masahiro to have an option to OVERRIDE:
When scripts/link-vmlinux.sh fails all generated files like vmlinux get rem=
oved.
For further debugging they should be kept.

My =E2=82=AC0.02.

- Sedat -

> / # grep vfs_truncate /sys/kernel/debug/tracing/available_filter_function=
s
> vfs_truncate
>
> / # cat /proc/version
> Linux version 5.11.0-rc7-dirty (nathan@ubuntu-m3-large-x86) (ClangBuiltLi=
nux clang version 13.0.0 (https://github.com/llvm/llvm-project 8f130f108fed=
fcf6cb80ef594560a87341028a37), LLD 13.0.0 (https://github.com/llvm/llvm-pro=
ject 8f130f108fedfcf6cb80ef594560a87341028a37)) #1 SMP PREEMPT Tue Feb 9 09=
:25:36 MST 2021
>
> / # zcat /proc/config.gz | grep "DEBUG_INFO_BTF\|FTRACE\|BPF"
> # CONFIG_CGROUP_BPF is not set
> CONFIG_BPF=3Dy
> # CONFIG_BPF_LSM is not set
> CONFIG_BPF_SYSCALL=3Dy
> CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=3Dy
> # CONFIG_BPF_JIT_ALWAYS_ON is not set
> CONFIG_BPF_JIT_DEFAULT_ON=3Dy
> # CONFIG_BPF_PRELOAD is not set
> # CONFIG_NETFILTER_XT_MATCH_BPF is not set
> # CONFIG_BPFILTER is not set
> # CONFIG_NET_CLS_BPF is not set
> # CONFIG_NET_ACT_BPF is not set
> CONFIG_BPF_JIT=3Dy
> CONFIG_HAVE_EBPF_JIT=3Dy
> # CONFIG_PSTORE_FTRACE is not set
> CONFIG_DEBUG_INFO_BTF=3Dy
> CONFIG_DEBUG_INFO_BTF_MODULES=3Dy
> CONFIG_HAVE_DYNAMIC_FTRACE=3Dy
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=3Dy
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=3Dy
> CONFIG_FTRACE=3Dy
> CONFIG_DYNAMIC_FTRACE=3Dy
> CONFIG_DYNAMIC_FTRACE_WITH_REGS=3Dy
> # CONFIG_FTRACE_SYSCALLS is not set
> CONFIG_BPF_EVENTS=3Dy
> CONFIG_FTRACE_MCOUNT_RECORD=3Dy
> # CONFIG_FTRACE_RECORD_RECURSION is not set
> # CONFIG_FTRACE_STARTUP_TEST is not set
> # CONFIG_TEST_BPF is not set
>
> Cheers,
> Nathan
>
> --
> You received this message because you are subscribed to the Google Groups=
 "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/clang-built-linux/20210209163514.GA1226277%40ubuntu-m3-large-x86.
