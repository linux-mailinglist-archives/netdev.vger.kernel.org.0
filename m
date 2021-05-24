Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A7F38F675
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 01:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhEXXrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 19:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhEXXrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 19:47:41 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722F1C061574;
        Mon, 24 May 2021 16:46:12 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id i4so40462351ybe.2;
        Mon, 24 May 2021 16:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6iczEggOtiy2FN7AYegw0B3aUi5aVpE5nDr01zddwxQ=;
        b=VOiyCupb1CJ6+Ni3mL9sB+N93oglb/TsQMDHnT2/aAIRkd0xfmVZMJ+siqdp4T6q9M
         wsw1OhkYDzVs4tiI5Az6RgSzRXETvQRAgJ+at9mIoTD+UIzQR+sJpijpkZPNibHKaxpz
         7/Ef8ZogOpgEBImU2v2pUbeuftAT7jvKIWrgIvKF1Ai0S7dw0awAuQxEIBhnfHZSjzUB
         pF05KjX7MxQk1Df+fD4VrORz8E680A3r7Q2H1u01sQg5vPnlbyeMHl+1jd7XtkbM4jSu
         7LooS0WXmT71zBPJ4nDyba0uAtYWKtE5qklPfmetFIbPZ0Kqy1Tl0qQI10PT7EMGrqDA
         FBTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6iczEggOtiy2FN7AYegw0B3aUi5aVpE5nDr01zddwxQ=;
        b=hdRCURNleIIoC78pm3Y81p2o6zkLAVinsK6JmAec62/4qtPH1tI1OrcfH3CY7Lkcqt
         lh9QUYe4iW1qrZfF3KVkc9oz8tmz5sFu+wr0ZjbKYvTnqVmcDnNjmk1nOZK/6nMDaqj6
         4i28JhxdwgOHKe7Rh7TDEWJIcOprWdWmGcDeU01sp54LTQSxWe8QzVa2TB9M9HhkxHIP
         Q/67BNxXe6rH8hAn37Lwepk+0bSQ8GhRiQz2bPWvRT80JfyK1qqctu/mdKwPCfYu9x/5
         xOl9yG0kyfj2zYcDGrXm55T4urjAUwWnqf/pR3Tdj/EMKenJyX1WBLlzRhnCUbRcuAW3
         UYxA==
X-Gm-Message-State: AOAM530S+SMcxQKINzEetXf0ZRp8JlGcmdsWA04yMDgeNLP4Q426xIsc
        Q1elFsALascgZ+zSQhm6ufnzaCw/3lkjoWHEzLGxaCnPQvQ=
X-Google-Smtp-Source: ABdhPJy9NppsxSVMgzNiwBF7EJy2Hn9kL3HJEFrj8uT2sCTyD5DFA+/dTO2ajeySsy+VtJ4KwD43XMaOoxBYn2Md2Rs=
X-Received: by 2002:a25:7507:: with SMTP id q7mr37158860ybc.27.1621899971663;
 Mon, 24 May 2021 16:46:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210519141936.GV8544@kitsune.suse.cz> <CAEf4BzZuU2TYMapSy7s3=D8iYtVw_N+=hh2ZMGG9w6N0G1HvbA@mail.gmail.com>
 <CAEf4BzZ0-sihSL-UAm21JcaCCY92CqfNxycHRZYXcoj8OYb=wA@mail.gmail.com>
In-Reply-To: <CAEf4BzZ0-sihSL-UAm21JcaCCY92CqfNxycHRZYXcoj8OYb=wA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 May 2021 16:46:00 -0700
Message-ID: <CAEf4BzZ9=aLVD7ytgCcSxcbOLqFNK-p1mj14Rv_TGnOyL3aO_g@mail.gmail.com>
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

On Mon, May 24, 2021 at 3:58 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, May 20, 2021 at 10:31 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, May 19, 2021 at 7:19 AM Michal Such=C3=A1nek <msuchanek@suse.de=
> wrote:
> > >
> > > Hello,
> > >
> > > linux-next fails to boot for me:
> > >
> > > [    0.000000] Linux version 5.13.0-rc2-next-20210519-1.g3455ff8-vani=
lla (geeko@buildhost) (gcc (SUSE Linux) 10.3.0, GNU ld (GNU Binutils;
> > > openSUSE Tumbleweed) 2.36.1.20210326-3) #1 SMP Wed May 19 10:05:10 UT=
C 2021 (3455ff8)
> > > [    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-5.13.0-rc2-ne=
xt-20210519-1.g3455ff8-vanilla root=3DUUID=3Dec42c33e-a2c2-4c61-afcc-93e952=
7
> > > 8f687 plymouth.enable=3D0 resume=3D/dev/disk/by-uuid/f1fe4560-a801-4f=
af-a638-834c407027c7 mitigations=3Dauto earlyprintk initcall_debug nomodese=
t
> > >  earlycon ignore_loglevel console=3DttyS0,115200
> > > ...
> > > [   26.093364] calling  tracing_set_default_clock+0x0/0x62 @ 1
> > > [   26.098937] initcall tracing_set_default_clock+0x0/0x62 returned 0=
 after 0 usecs
> > > [   26.106330] calling  acpi_gpio_handle_deferred_request_irqs+0x0/0x=
7c @ 1
> > > [   26.113033] initcall acpi_gpio_handle_deferred_request_irqs+0x0/0x=
7c returned 0 after 3 usecs
> > > [   26.121559] calling  clk_disable_unused+0x0/0x102 @ 1
> > > [   26.126620] initcall clk_disable_unused+0x0/0x102 returned 0 after=
 0 usecs
> > > [   26.133491] calling  regulator_init_complete+0x0/0x25 @ 1
> > > [   26.138890] initcall regulator_init_complete+0x0/0x25 returned 0 a=
fter 0 usecs
> > > [   26.147816] Freeing unused decrypted memory: 2036K
> > > [   26.153682] Freeing unused kernel image (initmem) memory: 2308K
> > > [   26.165776] Write protecting the kernel read-only data: 26624k
> > > [   26.173067] Freeing unused kernel image (text/rodata gap) memory: =
2036K
> > > [   26.180416] Freeing unused kernel image (rodata/data gap) memory: =
1184K
> > > [   26.187031] Run /init as init process
> > > [   26.190693]   with arguments:
> > > [   26.193661]     /init
> > > [   26.195933]   with environment:
> > > [   26.199079]     HOME=3D/
> > > [   26.201444]     TERM=3Dlinux
> > > [   26.204152]     BOOT_IMAGE=3D/boot/vmlinuz-5.13.0-rc2-next-2021051=
9-1.g3455ff8-vanilla
> > > [   26.254154] BPF:      type_id=3D35503 offset=3D178440 size=3D4
> > > [   26.259125] BPF:
> > > [   26.261054] BPF:Invalid offset
> > > [   26.264119] BPF:
> >
> > It took me a while to reliably bisect this, but it clearly points to
> > this commit:
> >
> > e481fac7d80b ("mm/page_alloc: convert per-cpu list protection to local_=
lock")
> >
> > One commit before it, 676535512684 ("mm/page_alloc: split per cpu page
> > lists and zone stats -fix"), works just fine.
> >
> > I'll have to spend more time debugging what exactly is happening, but
> > the immediate problem is two different definitions of numa_node
> > per-cpu variable. They both are at the same offset within
> > .data..percpu ELF section, they both have the same name, but one of
> > them is marked as static and another as global. And one is int
> > variable, while another is struct pagesets. I'll look some more
> > tomorrow, but adding Jiri and Arnaldo for visibility.
> >
> > [110907] DATASEC '.data..percpu' size=3D178904 vlen=3D303
> > ...
> >         type_id=3D27753 offset=3D163976 size=3D4 (VAR 'numa_node')
> >         type_id=3D27754 offset=3D163976 size=3D4 (VAR 'numa_node')
> >
> > [27753] VAR 'numa_node' type_id=3D27556, linkage=3Dstatic
> > [27754] VAR 'numa_node' type_id=3D20, linkage=3Dglobal
> >
> > [20] INT 'int' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=3DSIGNED
> >
> > [27556] STRUCT 'pagesets' size=3D0 vlen=3D1
> >         'lock' type_id=3D507 bits_offset=3D0
> >
> > [506] STRUCT '(anon)' size=3D0 vlen=3D0
> > [507] TYPEDEF 'local_lock_t' type_id=3D506
> >
> > So also something weird about those zero-sized struct pagesets and
> > local_lock_t inside it.
>
> Ok, so nothing weird about them. local_lock_t is designed to be
> zero-sized unless CONFIG_DEBUG_LOCK_ALLOC is defined.
>
> But such zero-sized per-CPU variables are confusing pahole during BTF
> generation, as now two different variables "occupy" the same address.

FWIW, here's the pahole fix (it tried to filter zero-sized per-CPU
vars, but not quite completely).

  [0] https://lore.kernel.org/bpf/20210524234222.278676-1-andrii@kernel.org=
/T/#u

>
> Given this seems to be the first zero-sized per-CPU variable, I wonder
> if it would be ok to make sure it's never zero-sized, while pahole
> gets fixed and it's latest version gets widely packaged and
> distributed.
>
> Mel, what do you think about something like below? Or maybe you can
> advise some better solution?
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 41b87d6f840c..6a1d7511cae9 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -124,6 +124,13 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
>
>  struct pagesets {
>      local_lock_t lock;
> +#if defined(CONFIG_DEBUG_INFO_BTF) && !defined(CONFIG_DEBUG_LOCK_ALLOC)
> +    /* pahole 1.21 and earlier gets confused by zero-sized per-CPU
> +     * variables and produces invalid BTF. So to accommodate earlier
> +     * versions of pahole, ensure that sizeof(struct pagesets) is never =
0.
> +     */
> +    char __filler;
> +#endif
>  };
>  static DEFINE_PER_CPU(struct pagesets, pagesets) =3D {
>      .lock =3D INIT_LOCAL_LOCK(lock),
>
> >
> > > [   26.264119]
> > > [   26.267437] failed to validate module [efivarfs] BTF: -22
> > > [   26.316724] systemd[1]: systemd 246.13+suse.105.g14581e0120 runnin=
g in system mode. (+PAM +AUDIT +SELINUX -IMA +APPARMOR -SMACK +SYSVINI
> > > T +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +ZSTD +SECCOMP +=
BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=3Dunified)
> > > [   26.357990] systemd[1]: Detected architecture x86-64.
> > > [   26.363068] systemd[1]: Running in initial RAM disk.
> > >
> >
> > [...]
