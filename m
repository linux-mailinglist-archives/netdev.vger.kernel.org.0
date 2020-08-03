Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D9323AC69
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 20:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgHCSd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 14:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727907AbgHCSd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 14:33:27 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FCAC06174A;
        Mon,  3 Aug 2020 11:33:26 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id v9so6270704ljk.6;
        Mon, 03 Aug 2020 11:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YKCFMiXgUprAfOtTAJFluerMVX+Gtd8K9VHkEllzvoQ=;
        b=tU6CmDxaaFS+gchg1ZgV0zbZrms45MW+M407MKCUjllnktxPZG3c8KUmX/Zqszr5DS
         ckyXZDNopQsBrVElISuidPHwZLHOiR/oDqNsearT6XNPgLzvbwRPsxrU8NJrQre3CgdV
         TeNIB4StkgApX4Y5dH4nh/fGuhODUO9tCmpBckOtt2yc8poPKkeqTrw3DkCEnakiswVF
         zWi/J/aeGRcAJra4Xgu07NtAZFkFtsNWSuoji04TmsTN0D+sS/OKnN1do8GLiu0jX9zR
         KJND/Axp3nXkv5LHS9KqidpRoVH3QEVKlFmL+gHJ+7b4K/PPpsiPVIgZaFX89OXP6Qj/
         eRNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YKCFMiXgUprAfOtTAJFluerMVX+Gtd8K9VHkEllzvoQ=;
        b=etvgTsX98iCaGtcaP/9/rNrARrRRt4tPuY+SuPSYttni6HnJEK6PWyJhXeqVLnlO/y
         n81WZH0BBjBLFu9SrQyVcTVDgzh6NzWV9Gi3ep6mokLAW9aLkdZrV/cuLLqn+CeLJHVN
         /v61pvtEyX9FdFCym9Fm6Tg3Br193EputqL8ORaofHhoSRNavIj5ecbRdhAZIM3ZnCRp
         2bzrkuhwkEIJLS38tSsG1LCc1BEhOOaCRC2LL44sFBM4qU2XcgnS6PIawHoNDcglPZWo
         Z3KuRNO8XN2FHMl79IbZa8Cb8E8yLKFi+k3+MpbAwA3uL6aYdt4t6kn5dx0CGfQYxMVm
         e8+g==
X-Gm-Message-State: AOAM531isjKB8NwIDCzPrCh7Pxh5RUpDtx0WahQjMMFUWFOBAJkyQz32
        To36tW9TcpE8oU3R1AazQvgXu6OizGQK1jKyBKOd+6C7
X-Google-Smtp-Source: ABdhPJwCJmzHyGOSMxu1l7JJ2m3B/tHW+tKlkp7tdBMoW+ZufJ3L6rCtFYvb62PkniAcVnfMI42PYaBpzCXSdEuC8GA=
X-Received: by 2002:a2e:a489:: with SMTP id h9mr8631929lji.121.1596479605091;
 Mon, 03 Aug 2020 11:33:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200802222950.34696-1-alexei.starovoitov@gmail.com>
 <20200802222950.34696-4-alexei.starovoitov@gmail.com> <33d2db5b-3f81-e384-bed8-96f1d7f1d4c7@iogearbox.net>
 <430839eb-2761-0c1a-4b99-dffb07b9f502@iogearbox.net> <736dc34e-254d-de46-ac91-512029f675e7@iogearbox.net>
In-Reply-To: <736dc34e-254d-de46-ac91-512029f675e7@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 3 Aug 2020 11:33:13 -0700
Message-ID: <CAADnVQ+TRC11LnqMfstZwa-DDBBjL5uJoVgkxP0NkEDxAT2zEQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 3/4] bpf: Add kernel module with user mode
 driver that populates bpffs.
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 3, 2020 at 10:40 AM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 8/3/20 7:34 PM, Daniel Borkmann wrote:
> > On 8/3/20 7:15 PM, Daniel Borkmann wrote:
> >> On 8/3/20 12:29 AM, Alexei Starovoitov wrote:
> >>> From: Alexei Starovoitov <ast@kernel.org>
> >>>
> >>> Add kernel module with user mode driver that populates bpffs with
> >>> BPF iterators.
> >>>
> >>> $ mount bpffs /my/bpffs/ -t bpf
> >>> $ ls -la /my/bpffs/
> >>> total 4
> >>> drwxrwxrwt  2 root root    0 Jul  2 00:27 .
> >>> drwxr-xr-x 19 root root 4096 Jul  2 00:09 ..
> >>> -rw-------  1 root root    0 Jul  2 00:27 maps.debug
> >>> -rw-------  1 root root    0 Jul  2 00:27 progs.debug
> >>>
> >>> The user mode driver will load BPF Type Formats, create BPF maps, pop=
ulate BPF
> >>> maps, load two BPF programs, attach them to BPF iterators, and finall=
y send two
> >>> bpf_link IDs back to the kernel.
> >>> The kernel will pin two bpf_links into newly mounted bpffs instance u=
nder
> >>> names "progs.debug" and "maps.debug". These two files become human re=
adable.
> >>>
> >>> $ cat /my/bpffs/progs.debug
> >>>    id name            attached
> >>>    11 dump_bpf_map    bpf_iter_bpf_map
> >>>    12 dump_bpf_prog   bpf_iter_bpf_prog
> >>>    27 test_pkt_access
> >>>    32 test_main       test_pkt_access test_pkt_access
> >>>    33 test_subprog1   test_pkt_access_subprog1 test_pkt_access
> >>>    34 test_subprog2   test_pkt_access_subprog2 test_pkt_access
> >>>    35 test_subprog3   test_pkt_access_subprog3 test_pkt_access
> >>>    36 new_get_skb_len get_skb_len test_pkt_access
> >>>    37 new_get_skb_ifindex get_skb_ifindex test_pkt_access
> >>>    38 new_get_constant get_constant test_pkt_access
> >>>
> >>> The BPF program dump_bpf_prog() in iterators.bpf.c is printing this d=
ata about
> >>> all BPF programs currently loaded in the system. This information is =
unstable
> >>> and will change from kernel to kernel as ".debug" suffix conveys.
> >>>
> >>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >> [...]
> >>> diff --git a/kernel/bpf/preload/Kconfig b/kernel/bpf/preload/Kconfig
> >>> new file mode 100644
> >>> index 000000000000..b8ba5a9398ed
> >>> --- /dev/null
> >>> +++ b/kernel/bpf/preload/Kconfig
> >>> @@ -0,0 +1,18 @@
> >>> +# SPDX-License-Identifier: GPL-2.0-only
> >>> +menuconfig BPF_PRELOAD
> >>> +    bool "Preload BPF file system with kernel specific program and m=
ap iterators"
> >>> +    depends on BPF
> >>> +    help
> >>> +      This builds kernel module with several embedded BPF programs t=
hat are
> >>> +      pinned into BPF FS mount point as human readable files that ar=
e
> >>> +      useful in debugging and introspection of BPF programs and maps=
.
> >>> +
> >>> +if BPF_PRELOAD
> >>> +config BPF_PRELOAD_UMD
> >>> +    tristate "bpf_preload kernel module with user mode driver"
> >>> +    depends on CC_CAN_LINK
> >>> +    depends on m || CC_CAN_LINK_STATIC
> >>> +    default m
> >>> +    help
> >>> +      This builds bpf_preload kernel module with embedded user mode =
driver.
> >>> +endif
> >> [...]
> >> When I applied this set locally to run build & selftests I noticed tha=
t the above
> >> kconfig will appear in the top-level menuconfig. This is how it looks =
in menuconfig:
> >>
> >>    =E2=94=82 =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=90 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                           Gener=
al setup  --->                                                             =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                       [*] 64-bi=
t kernel                                                                   =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                           Proce=
ssor type and features  --->                                               =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                           Power=
 management and ACPI options  --->                                         =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                           Bus o=
ptions (PCI etc.)  --->                                                    =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                           Binar=
y Emulations  --->                                                         =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                           Firmw=
are Drivers  --->                                                          =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                       [*] Virtu=
alization  --->                                                            =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                           Gener=
al architecture-dependent options  --->                                    =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                       [*] Enabl=
e loadable module support  --->                                            =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                       -*- Enabl=
e the block layer  --->                                                    =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                           IO Sc=
hedulers  --->                                                             =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                       [ ] Prelo=
ad BPF file system with kernel specific program and map iterators  ----    =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                           Execu=
table file formats  --->                                                   =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                           Memor=
y Management options  --->                                                 =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                       [*] Netwo=
rking support  --->                                                        =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                           Devic=
e Drivers  --->                                                            =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                           File =
systems  --->                                                              =
                         =E2=94=82 =E2=94=82
> >>    =E2=94=82 =E2=94=82                                           Secur=
ity options  --->                                                          =
                         =E2=94=82 =E2=94=82
> >> [...]
> >>
> >> I assume the original intention was to have it under 'general setup' o=
n a similar level for
> >> the JIT settings, or is this intentional to have it at this high level=
 next to 'networking
> >> support' and others?

I don't remember when last time I did menuconfig.
How do you propose to move it?
Any particular suggestion how kconfig suppose to look like?

> >
> > Hm, my config has:
> >
> > CONFIG_BPF_PRELOAD=3Dy
> > CONFIG_BPF_PRELOAD_UMD=3Dy
> >
> > I'm getting the following 3 warnings and build error below:
> >
> > root@tank:~/bpf-next# make -j8 > /dev/null
> > arch/x86/hyperv/hv_apic.c: In function =E2=80=98hv_send_ipi_mask_allbut=
self=E2=80=99:
> > arch/x86/hyperv/hv_apic.c:236:1: warning: the frame size of 1032 bytes =
is larger than 1024 bytes [-Wframe-larger-than=3D]
> >   }
> >   ^
> > make[3]: *** No rule to make target 'kernel/bpf/preload/./../../tools/l=
ib/bpf/bpf.c', needed by 'kernel/bpf/preload/./../../tools/lib/bpf/bpf.o'. =
 Stop.
> > make[3]: *** Waiting for unfinished jobs....
> > kernel/bpf/preload/iterators/iterators.c: In function =E2=80=98main=E2=
=80=99:
> > kernel/bpf/preload/iterators/iterators.c:50:2: warning: ignoring return=
 value of =E2=80=98dup=E2=80=99, declared with attribute warn_unused_result=
 [-Wunused-result]
> >    dup(debug_fd);
> >    ^~~~~~~~~~~~~
> > kernel/bpf/preload/iterators/iterators.c:53:2: warning: ignoring return=
 value of =E2=80=98read=E2=80=99, declared with attribute warn_unused_resul=
t [-Wunused-result]
> >    read(from_kernel, &magic, sizeof(magic));
> >    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > kernel/bpf/preload/iterators/iterators.c:85:2: warning: ignoring return=
 value of =E2=80=98read=E2=80=99, declared with attribute warn_unused_resul=
t [-Wunused-result]
> >    read(from_kernel, &magic, sizeof(magic));
> >    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > make[2]: *** [kernel/bpf/preload] Error 2
> > make[1]: *** [kernel/bpf] Error 2
> > make: *** [kernel] Error 2
> > make: *** Waiting for unfinished jobs....
> > [...]
> >
> > Have you seen the target error before, what am I missing?
>
> Looks like the path in this patch is wrong:
>
> diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
> index 191d82209842..136c6ca0c196 100644
> --- a/kernel/bpf/preload/Makefile
> +++ b/kernel/bpf/preload/Makefile
> @@ -1,6 +1,6 @@
>   # SPDX-License-Identifier: GPL-2.0
>
> -LIBBPF :=3D $(srctree)/../../tools/lib/bpf
> +LIBBPF :=3D $(srctree)/../../../tools/lib/bpf

hmm. that's very odd.
Are you building in-src-tree ?
I'm building out-of-src-tree with KBUILD_OUTPUT.
And two pairs of dots would be correct.
make V=3D1 kernel/bpf/preload/
gcc  -m64 -lelf -lz  -o kernel/bpf/preload/bpf_preload_umd
kernel/bpf/preload/iterators/iterators.o
kernel/bpf/preload/../../../tools/lib/bpf/bpf.o

see three pairs above. the first pair comes from $(srctree) somehow.

>   userccflags +=3D -I $(srctree)/tools/include/ -I $(srctree)/tools/inclu=
de/uapi -I $(LIBBPF) \
>          -I $(srctree)/tools/lib/ \
>          -I $(srctree)/kernel/bpf/preload/iterators/ -Wno-int-conversion =
\
>
> With that, I'm now getting the following error:
>
> root@tank:~/bpf-next# make -j8
>    DESCEND  objtool
>    DESCEND  bpf/resolve_btfids
>    CALL    scripts/atomic/check-atomics.sh
>    CALL    scripts/checksyscalls.sh
>    CHK     include/generated/compile.h
>    CC      kernel/events/core.o
>    CC [U]  kernel/bpf/preload/iterators/iterators.o
> kernel/bpf/preload/iterators/iterators.c: In function =E2=80=98main=E2=80=
=99:
> kernel/bpf/preload/iterators/iterators.c:50:2: warning: ignoring return v=
alue of =E2=80=98dup=E2=80=99, declared with attribute warn_unused_result [=
-Wunused-result]
>    dup(debug_fd);
>    ^~~~~~~~~~~~~
> kernel/bpf/preload/iterators/iterators.c:53:2: warning: ignoring return v=
alue of =E2=80=98read=E2=80=99, declared with attribute warn_unused_result =
[-Wunused-result]
>    read(from_kernel, &magic, sizeof(magic));
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> kernel/bpf/preload/iterators/iterators.c:85:2: warning: ignoring return v=
alue of =E2=80=98read=E2=80=99, declared with attribute warn_unused_result =
[-Wunused-result]
>    read(from_kernel, &magic, sizeof(magic));
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    CC      kernel/events/ring_buffer.o
>    CC [U]  kernel/bpf/preload/./../../../tools/lib/bpf/bpf.o
>    CC [U]  kernel/bpf/preload/./../../../tools/lib/bpf/libbpf.o
> In file included from kernel/bpf/preload/./../../../tools/lib/bpf/libbpf.=
c:47:0:
> ./tools/include/tools/libc_compat.h:11:21: error: static declaration of =
=E2=80=98reallocarray=E2=80=99 follows non-static declaration
>   static inline void *reallocarray(void *ptr, size_t nmemb, size_t size)
>                       ^~~~~~~~~~~~

I saw this in the past when makefile was wrong. I suspect it's related
to the above issue.
Could you send me your build script / command line and make version?
