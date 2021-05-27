Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33BD3938A5
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 00:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236291AbhE0WTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 18:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbhE0WTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 18:19:35 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E428C061574;
        Thu, 27 May 2021 15:18:00 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id f9so2825604ybo.6;
        Thu, 27 May 2021 15:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DxChOSpPmHGZ1ijYrTb6dHkWnJSZrDLkZ2E9rH1emeA=;
        b=Phj24WK84hN6iA7WbxlFsqIe2I+sRC4fwLRpWgFWcuD2jDmiTsdkWWu8EQB6Gxj9Ff
         6aA0s85+RxjYGHVZLczJgOo6x3y1PekYqJ4RODmlbD4O22sGqLTY9+NY6pf7Z9GZgZ7T
         soJlYHFc63S8CQLWVg1LSciLL6/gT0jziUKflz2NRKYhxjUb0iVjXNSPjr+PugXmxy2O
         OiUrr/Az9Gdr+4u8tdGUfAowjeVOt1AVcDZRux0/ih6vcCiR2yFevGt9ZyYNJKAC/nND
         uV5aMoympb9Sg/eYBS3KTbETrXtjqcYpLesrpwlGxWcqrP2c2UJEZHSfTfP3YuIEI31o
         Qp7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DxChOSpPmHGZ1ijYrTb6dHkWnJSZrDLkZ2E9rH1emeA=;
        b=OtVt0lHaDZiKyUMb7v9fgk2EreyC7aNrqtSA5wafYiIFVRx+Il6QHi3aBEP3+lB1oF
         rUVQTjwJtK9WmAXDuW/qW3CU5hjzQSNTSE7cMx0A3Y4raewbc5MCi9x3TMWdGN1RhPN8
         mfUQcDanfSo0R0AYUKtXaa/V3/5ic67BXLWmg09Xq0R4utTw/JtnTz5RCujT8kq7WLSM
         pVKCe4UkvLCjTrBcJwVfYaQLnk61uFNG05UPhf2A6mi/zN9iTT9OzJjF/KfaV8fBRRAK
         mL8ITsn6nwtDE8Q6PQvfmZlodtq4wCi92/wDyCd+JW6S+ZAp27GQgVHP1LGHwUaWCLZr
         TO0Q==
X-Gm-Message-State: AOAM533JJCzYNIvvG/YPrTXNaqXvhX6EvWg+O+z5tjmuS1VNzHMSMrOC
        a2QTloiYqC3Q62etWCwss1LdNGTam6nlbozXI/oY2NvPSUwHDg==
X-Google-Smtp-Source: ABdhPJw8lIPLxLValnKSTALusos4965AR23ijk8FGrt4v/0mXszJlPll94PCML7FMkN9Oh2dFxndfHx3gumydtUmdMc=
X-Received: by 2002:a25:7246:: with SMTP id n67mr8194689ybc.510.1622153879670;
 Thu, 27 May 2021 15:17:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210527171923.GG30378@techsingularity.net>
In-Reply-To: <20210527171923.GG30378@techsingularity.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 27 May 2021 15:17:48 -0700
Message-ID: <CAEf4BzZB7Z3fGyVH1+a9SvTtm1LBBG2T++pYiTjRVxbrodzzZA@mail.gmail.com>
Subject: Re: [PATCH v3] mm/page_alloc: Require pahole v1.22 to cope with
 zero-sized struct pagesets
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>,
        Linux-BPF <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, clm@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 10:19 AM Mel Gorman <mgorman@techsingularity.net> w=
rote:
>
> This patch replaces
> mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix.patch in
> Andrew's tree.
>
> Michal Suchanek reported the following problem with linux-next
>
>   [    0.000000] Linux version 5.13.0-rc2-next-20210519-1.g3455ff8-vanill=
a (geeko@buildhost) (gcc (SUSE Linux) 10.3.0, GNU ld (GNU Binutils; openSUS=
E Tumbleweed) 2.36.1.20210326-3) #1 SMP Wed May 19 10:05:10 UTC 2021 (3455f=
f8)
>   [    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-5.13.0-rc2-next=
-20210519-1.g3455ff8-vanilla root=3DUUID=3Dec42c33e-a2c2-4c61-afcc-93e9527 =
8f687 plymouth.enable=3D0 resume=3D/dev/disk/by-uuid/f1fe4560-a801-4faf-a63=
8-834c407027c7 mitigations=3Dauto earlyprintk initcall_debug nomodeset earl=
ycon ignore_loglevel console=3DttyS0,115200
> ...
>   [   26.093364] calling  tracing_set_default_clock+0x0/0x62 @ 1
>   [   26.098937] initcall tracing_set_default_clock+0x0/0x62 returned 0 a=
fter 0 usecs
>   [   26.106330] calling  acpi_gpio_handle_deferred_request_irqs+0x0/0x7c=
 @ 1
>   [   26.113033] initcall acpi_gpio_handle_deferred_request_irqs+0x0/0x7c=
 returned 0 after 3 usecs
>   [   26.121559] calling  clk_disable_unused+0x0/0x102 @ 1
>   [   26.126620] initcall clk_disable_unused+0x0/0x102 returned 0 after 0=
 usecs
>   [   26.133491] calling  regulator_init_complete+0x0/0x25 @ 1
>   [   26.138890] initcall regulator_init_complete+0x0/0x25 returned 0 aft=
er 0 usecs
>   [   26.147816] Freeing unused decrypted memory: 2036K
>   [   26.153682] Freeing unused kernel image (initmem) memory: 2308K
>   [   26.165776] Write protecting the kernel read-only data: 26624k
>   [   26.173067] Freeing unused kernel image (text/rodata gap) memory: 20=
36K
>   [   26.180416] Freeing unused kernel image (rodata/data gap) memory: 11=
84K
>   [   26.187031] Run /init as init process
>   [   26.190693]   with arguments:
>   [   26.193661]     /init
>   [   26.195933]   with environment:
>   [   26.199079]     HOME=3D/
>   [   26.201444]     TERM=3Dlinux
>   [   26.204152]     BOOT_IMAGE=3D/boot/vmlinuz-5.13.0-rc2-next-20210519-=
1.g3455ff8-vanilla
>   [   26.254154] BPF:      type_id=3D35503 offset=3D178440 size=3D4
>   [   26.259125] BPF:
>   [   26.261054] BPF:Invalid offset
>   [   26.264119] BPF:
>   [   26.264119]
>   [   26.267437] failed to validate module [efivarfs] BTF: -22
>
> Andrii Nakryiko bisected the problem to the commit "mm/page_alloc: conver=
t
> per-cpu list protection to local_lock" currently staged in mmotm. In his
> own words
>
>   The immediate problem is two different definitions of numa_node per-cpu
>   variable. They both are at the same offset within .data..percpu ELF
>   section, they both have the same name, but one of them is marked as
>   static and another as global. And one is int variable, while another
>   is struct pagesets. I'll look some more tomorrow, but adding Jiri and
>   Arnaldo for visibility.
>
>   [110907] DATASEC '.data..percpu' size=3D178904 vlen=3D303
>   ...
>         type_id=3D27753 offset=3D163976 size=3D4 (VAR 'numa_node')
>         type_id=3D27754 offset=3D163976 size=3D4 (VAR 'numa_node')
>
>   [27753] VAR 'numa_node' type_id=3D27556, linkage=3Dstatic
>   [27754] VAR 'numa_node' type_id=3D20, linkage=3Dglobal
>
>   [20] INT 'int' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=3DSIGNED
>
>   [27556] STRUCT 'pagesets' size=3D0 vlen=3D1
>         'lock' type_id=3D507 bits_offset=3D0
>
>   [506] STRUCT '(anon)' size=3D0 vlen=3D0
>   [507] TYPEDEF 'local_lock_t' type_id=3D506
>
> The patch in question introduces a zero-sized per-cpu struct and while
> this is not wrong, versions of pahole prior to 1.22 get confused during
> BTF generation with two separate variables occupying the same address.
>
> This patch adds a requirement for pahole 1.22 before setting
> DEBUG_INFO_BTF.  While pahole 1.22 does not exist yet, a fix is in the
> pahole git tree as ("btf_encoder: fix and complete filtering out zero-siz=
ed
> per-CPU variables").
>
> Reported-by: Michal Suchanek <msuchanek@suse.de>
> Reported-by: Hritik Vijay <hritikxx8@gmail.com>
> Debugged-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> ---

I still think that v1 ([0]) is a more appropriate temporary solution
until pahole 1.22 is released and widely packaged. Suddenly raising
the minimum version to 1.22, which is not even released even, is a
pretty big compatibility concern for all the users that rely on
CONFIG_DEBUG_INFO_BTF. Just a few days ago pahole 1.16 worked fine and
here we suddenly (and silently due to how Kconfig functions) raise
that to a version that doesn't exist. That's going to break workflows
for a lot of people.

I'm asking to have that ugly work-around to ensure sizeof(struct
pagesets) > 0 as a temporary solution only. If we have to raise the
minimum pahole version to 1.22 we should also use that as an
opportunity to clean up and simplify pahole integration in Kbuild.
Kernel-side work-around will give us enough time to test and validate
everything instead of rushing bug fix release. Once 1.22 is widely
available we'll get rid of work-around and make
scripts/link-vmlinux.sh simpler (see discussion in [1]).

  [0] https://lore.kernel.org/bpf/20210526080741.GW30378@techsingularity.ne=
t/
  [1] https://lore.kernel.org/bpf/CAEf4BzaTP_jULKMN_hx6ZOqwESOmsR6_HxWW-Lnr=
A5xwRNtSWg@mail.gmail.com/

>  lib/Kconfig.debug | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 678c13967580..825be101767e 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -301,10 +301,14 @@ config DEBUG_INFO_DWARF5
>
>  endchoice # "DWARF version"
>
> +config PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT
> +       def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]=
+)\.([0-9]+)/\1\2/'` -ge "122")
> +
>  config DEBUG_INFO_BTF
>         bool "Generate BTF typeinfo"
>         depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
>         depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
> +       depends on PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT
>         help
>           Generate deduplicated BTF type information from DWARF debug inf=
o.
>           Turning this on expects presence of pahole tool, which will con=
vert
