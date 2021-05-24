Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFA038F5F9
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 00:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhEXXAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 19:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhEXXAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 19:00:10 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A00C061574;
        Mon, 24 May 2021 15:58:41 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id i4so40336467ybe.2;
        Mon, 24 May 2021 15:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aeA6ZzJ9wtLKU0spfXFvzN/vxEYBOrxPH2HZTAIR6G4=;
        b=BlN/F3DALifeeVLcQMifYUL1JTB7D90uTeUf49tlCUgw7ST0wvnsN+yYX629qZHlcI
         ggd5JIQr0QsP0hgqaUNvQzhfty9eAzRA05zi97R3mDUwmKeVWdtUzvPmWn/jeQW3UCmz
         xo5xt4pMAnqxtxzOm1183OXeVq60wH57wG4vUtQRoJzhbrPCotgRHwyLRrposZ4OnXxT
         uLlCdgHvKGQPQnCNT50bIT9kLIITr+XDmAECdGMQa8PXwc5Cp6EIFgS3Dn1gdHDYblLa
         KS+0kjkPiZQTDDrI8vjT2XlbSzDw6VJxsd8tJOLmBBiC89kROo9IX/OoPRt/9HUpmk1/
         0I9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aeA6ZzJ9wtLKU0spfXFvzN/vxEYBOrxPH2HZTAIR6G4=;
        b=IAb1/LyjU82Zta5PtGRir/GzpVgN42p+nb2x8vHTNXonbPv7FYLQBlnAL1yO/m/NEB
         cPfQy4qh/tvcElgcstjcn9F1KXktkLgD92qvVrcAZzWWlkw6J5LdBv/VnA/+RB9C5EiN
         3TLOw2QR2sQeh9C99p6NPPZzFtlc+ewjEoOt5Z8tMDZaIAf6aUH/ABWaXDGMJylPpHx5
         afdrojORVnfJoPWd3gCHcwynAwuuewmtKUpC4JAaxywSLtiyGR3074LMoYG9fTstSLw9
         fEJeEuSzmdroZsrzA7tCqFSjSx1eUJovUPtmx2i1I2f66/0jt/CXw9HWNYlScQdz8pOK
         5+Sw==
X-Gm-Message-State: AOAM532zgXEuvzHH2bQ+296hPXt+vk2cQXuDR6qsnSpyZxtjTNpEO08A
        0ppzpCC47q69p+ul4EBkHtMCfJEQG9uDZzsu6Qg=
X-Google-Smtp-Source: ABdhPJwCD58vucK7G7O5g1HdcPSR435C+4XpCO00AfQnWJG7NAMraj9RQJBJ/g/36D2p6ru8HmfULYTulkIULklsKRM=
X-Received: by 2002:a25:3357:: with SMTP id z84mr38084998ybz.260.1621897120617;
 Mon, 24 May 2021 15:58:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210519141936.GV8544@kitsune.suse.cz> <CAEf4BzZuU2TYMapSy7s3=D8iYtVw_N+=hh2ZMGG9w6N0G1HvbA@mail.gmail.com>
In-Reply-To: <CAEf4BzZuU2TYMapSy7s3=D8iYtVw_N+=hh2ZMGG9w6N0G1HvbA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 May 2021 15:58:29 -0700
Message-ID: <CAEf4BzZ0-sihSL-UAm21JcaCCY92CqfNxycHRZYXcoj8OYb=wA@mail.gmail.com>
Subject: Re: BPF: failed module verification on linux-next
To:     =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>,
        Mel Gorman <mgorman@techsingularity.net>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 10:31 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, May 19, 2021 at 7:19 AM Michal Such=C3=A1nek <msuchanek@suse.de> =
wrote:
> >
> > Hello,
> >
> > linux-next fails to boot for me:
> >
> > [    0.000000] Linux version 5.13.0-rc2-next-20210519-1.g3455ff8-vanill=
a (geeko@buildhost) (gcc (SUSE Linux) 10.3.0, GNU ld (GNU Binutils;
> > openSUSE Tumbleweed) 2.36.1.20210326-3) #1 SMP Wed May 19 10:05:10 UTC =
2021 (3455ff8)
> > [    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-5.13.0-rc2-next=
-20210519-1.g3455ff8-vanilla root=3DUUID=3Dec42c33e-a2c2-4c61-afcc-93e9527
> > 8f687 plymouth.enable=3D0 resume=3D/dev/disk/by-uuid/f1fe4560-a801-4faf=
-a638-834c407027c7 mitigations=3Dauto earlyprintk initcall_debug nomodeset
> >  earlycon ignore_loglevel console=3DttyS0,115200
> > ...
> > [   26.093364] calling  tracing_set_default_clock+0x0/0x62 @ 1
> > [   26.098937] initcall tracing_set_default_clock+0x0/0x62 returned 0 a=
fter 0 usecs
> > [   26.106330] calling  acpi_gpio_handle_deferred_request_irqs+0x0/0x7c=
 @ 1
> > [   26.113033] initcall acpi_gpio_handle_deferred_request_irqs+0x0/0x7c=
 returned 0 after 3 usecs
> > [   26.121559] calling  clk_disable_unused+0x0/0x102 @ 1
> > [   26.126620] initcall clk_disable_unused+0x0/0x102 returned 0 after 0=
 usecs
> > [   26.133491] calling  regulator_init_complete+0x0/0x25 @ 1
> > [   26.138890] initcall regulator_init_complete+0x0/0x25 returned 0 aft=
er 0 usecs
> > [   26.147816] Freeing unused decrypted memory: 2036K
> > [   26.153682] Freeing unused kernel image (initmem) memory: 2308K
> > [   26.165776] Write protecting the kernel read-only data: 26624k
> > [   26.173067] Freeing unused kernel image (text/rodata gap) memory: 20=
36K
> > [   26.180416] Freeing unused kernel image (rodata/data gap) memory: 11=
84K
> > [   26.187031] Run /init as init process
> > [   26.190693]   with arguments:
> > [   26.193661]     /init
> > [   26.195933]   with environment:
> > [   26.199079]     HOME=3D/
> > [   26.201444]     TERM=3Dlinux
> > [   26.204152]     BOOT_IMAGE=3D/boot/vmlinuz-5.13.0-rc2-next-20210519-=
1.g3455ff8-vanilla
> > [   26.254154] BPF:      type_id=3D35503 offset=3D178440 size=3D4
> > [   26.259125] BPF:
> > [   26.261054] BPF:Invalid offset
> > [   26.264119] BPF:
>
> It took me a while to reliably bisect this, but it clearly points to
> this commit:
>
> e481fac7d80b ("mm/page_alloc: convert per-cpu list protection to local_lo=
ck")
>
> One commit before it, 676535512684 ("mm/page_alloc: split per cpu page
> lists and zone stats -fix"), works just fine.
>
> I'll have to spend more time debugging what exactly is happening, but
> the immediate problem is two different definitions of numa_node
> per-cpu variable. They both are at the same offset within
> .data..percpu ELF section, they both have the same name, but one of
> them is marked as static and another as global. And one is int
> variable, while another is struct pagesets. I'll look some more
> tomorrow, but adding Jiri and Arnaldo for visibility.
>
> [110907] DATASEC '.data..percpu' size=3D178904 vlen=3D303
> ...
>         type_id=3D27753 offset=3D163976 size=3D4 (VAR 'numa_node')
>         type_id=3D27754 offset=3D163976 size=3D4 (VAR 'numa_node')
>
> [27753] VAR 'numa_node' type_id=3D27556, linkage=3Dstatic
> [27754] VAR 'numa_node' type_id=3D20, linkage=3Dglobal
>
> [20] INT 'int' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=3DSIGNED
>
> [27556] STRUCT 'pagesets' size=3D0 vlen=3D1
>         'lock' type_id=3D507 bits_offset=3D0
>
> [506] STRUCT '(anon)' size=3D0 vlen=3D0
> [507] TYPEDEF 'local_lock_t' type_id=3D506
>
> So also something weird about those zero-sized struct pagesets and
> local_lock_t inside it.

Ok, so nothing weird about them. local_lock_t is designed to be
zero-sized unless CONFIG_DEBUG_LOCK_ALLOC is defined.

But such zero-sized per-CPU variables are confusing pahole during BTF
generation, as now two different variables "occupy" the same address.

Given this seems to be the first zero-sized per-CPU variable, I wonder
if it would be ok to make sure it's never zero-sized, while pahole
gets fixed and it's latest version gets widely packaged and
distributed.

Mel, what do you think about something like below? Or maybe you can
advise some better solution?

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 41b87d6f840c..6a1d7511cae9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -124,6 +124,13 @@ static DEFINE_MUTEX(pcp_batch_high_lock);

 struct pagesets {
     local_lock_t lock;
+#if defined(CONFIG_DEBUG_INFO_BTF) && !defined(CONFIG_DEBUG_LOCK_ALLOC)
+    /* pahole 1.21 and earlier gets confused by zero-sized per-CPU
+     * variables and produces invalid BTF. So to accommodate earlier
+     * versions of pahole, ensure that sizeof(struct pagesets) is never 0.
+     */
+    char __filler;
+#endif
 };
 static DEFINE_PER_CPU(struct pagesets, pagesets) =3D {
     .lock =3D INIT_LOCAL_LOCK(lock),

>
> > [   26.264119]
> > [   26.267437] failed to validate module [efivarfs] BTF: -22
> > [   26.316724] systemd[1]: systemd 246.13+suse.105.g14581e0120 running =
in system mode. (+PAM +AUDIT +SELINUX -IMA +APPARMOR -SMACK +SYSVINI
> > T +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +ZSTD +SECCOMP +BL=
KID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=3Dunified)
> > [   26.357990] systemd[1]: Detected architecture x86-64.
> > [   26.363068] systemd[1]: Running in initial RAM disk.
> >
>
> [...]
