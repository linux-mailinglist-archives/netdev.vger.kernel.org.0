Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CA938BDE8
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 07:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhEUFcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 01:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhEUFcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 01:32:53 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17963C061574;
        Thu, 20 May 2021 22:31:30 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id y36so9313297ybi.11;
        Thu, 20 May 2021 22:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jvPYzY/XrELEm8iFWOXL9/Ix8RD17PPfttVLbzrKYec=;
        b=lQ5tjhFo6xYnlzJbI640wMPyQRf1dqFxRemvkhjsAElJtQVm2U5iNU4AGipHhl2k3U
         uz8YOl1OV72Cj9ZpLBYXKoDlnlu9dWo0/sN5IJi0p0MnjTHvWS0XFt2SgfMbPbB3ZJ+s
         OqCzADLd1EN1DoimD0tj92fH8eyO0/bArNvFs6ezuujsETiQ/2LglZvGUd4K6gSEQFH8
         5UbRXCUgDvsgCEG6YLh04NS6I8diOUOy/OlII9rLU5xmFKmvS0XwP0eIgibjMkj1wZLb
         00IOiC7I+EzT512Xpb6CI/MkC8vgVD36P8OyfaaS2Dqhz8QhqVjufW39XC0B1TmpxiXL
         lNQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jvPYzY/XrELEm8iFWOXL9/Ix8RD17PPfttVLbzrKYec=;
        b=K4WtnVBL68hsD72Kt282zAXRb8dW2nRONTPy6J2lqc2JLD5RS+5q87NU6CMLHxf/Tt
         CvDQ7Ix4dR9PjEUPRFErkir8DbYS/A5ksHuHy7MZRjRwQdjPZZxDygllcaeYDvUlmvsq
         zePf0PbypY91zjouE0xDc/vy5jpTTK570RYwxhg+dgKmWVcEdtMRrVobe4WtGQ3DjkJM
         o2EsrkoT3PGs2tuSyptJk75qrvEAYAySVXE0B+ZGP9iL4bMvkPKVTLqrkPdO+NQn/QRh
         woUs1eo8/2i12D21YpSrSr7MXhTdrpF0MgBNyTFQgHh5Jbp/1h9+Vl/c7e3zsKkwvB55
         qFGw==
X-Gm-Message-State: AOAM531AkpImGZVwUrkv6CAPMYwvpWV9+v1dHkgTaEZRw0U1AzNfMEP3
        AVjTd0XdeLGxxsdYBPf3nBv/LPdx37IerkZrPo4=
X-Google-Smtp-Source: ABdhPJxlGn2A+LFevhEFgfWiXj276hp4bn0wK8a9PEU7IC9APYD3h1HL6ueNzCdq7ctUe4FUv481Ssq7WTzAnn0lbZE=
X-Received: by 2002:a5b:286:: with SMTP id x6mr13291645ybl.347.1621575089244;
 Thu, 20 May 2021 22:31:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210519141936.GV8544@kitsune.suse.cz>
In-Reply-To: <20210519141936.GV8544@kitsune.suse.cz>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 May 2021 22:31:18 -0700
Message-ID: <CAEf4BzZuU2TYMapSy7s3=D8iYtVw_N+=hh2ZMGG9w6N0G1HvbA@mail.gmail.com>
Subject: Re: BPF: failed module verification on linux-next
To:     =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>
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
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 7:19 AM Michal Such=C3=A1nek <msuchanek@suse.de> wr=
ote:
>
> Hello,
>
> linux-next fails to boot for me:
>
> [    0.000000] Linux version 5.13.0-rc2-next-20210519-1.g3455ff8-vanilla =
(geeko@buildhost) (gcc (SUSE Linux) 10.3.0, GNU ld (GNU Binutils;
> openSUSE Tumbleweed) 2.36.1.20210326-3) #1 SMP Wed May 19 10:05:10 UTC 20=
21 (3455ff8)
> [    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-5.13.0-rc2-next-2=
0210519-1.g3455ff8-vanilla root=3DUUID=3Dec42c33e-a2c2-4c61-afcc-93e9527
> 8f687 plymouth.enable=3D0 resume=3D/dev/disk/by-uuid/f1fe4560-a801-4faf-a=
638-834c407027c7 mitigations=3Dauto earlyprintk initcall_debug nomodeset
>  earlycon ignore_loglevel console=3DttyS0,115200
> ...
> [   26.093364] calling  tracing_set_default_clock+0x0/0x62 @ 1
> [   26.098937] initcall tracing_set_default_clock+0x0/0x62 returned 0 aft=
er 0 usecs
> [   26.106330] calling  acpi_gpio_handle_deferred_request_irqs+0x0/0x7c @=
 1
> [   26.113033] initcall acpi_gpio_handle_deferred_request_irqs+0x0/0x7c r=
eturned 0 after 3 usecs
> [   26.121559] calling  clk_disable_unused+0x0/0x102 @ 1
> [   26.126620] initcall clk_disable_unused+0x0/0x102 returned 0 after 0 u=
secs
> [   26.133491] calling  regulator_init_complete+0x0/0x25 @ 1
> [   26.138890] initcall regulator_init_complete+0x0/0x25 returned 0 after=
 0 usecs
> [   26.147816] Freeing unused decrypted memory: 2036K
> [   26.153682] Freeing unused kernel image (initmem) memory: 2308K
> [   26.165776] Write protecting the kernel read-only data: 26624k
> [   26.173067] Freeing unused kernel image (text/rodata gap) memory: 2036=
K
> [   26.180416] Freeing unused kernel image (rodata/data gap) memory: 1184=
K
> [   26.187031] Run /init as init process
> [   26.190693]   with arguments:
> [   26.193661]     /init
> [   26.195933]   with environment:
> [   26.199079]     HOME=3D/
> [   26.201444]     TERM=3Dlinux
> [   26.204152]     BOOT_IMAGE=3D/boot/vmlinuz-5.13.0-rc2-next-20210519-1.=
g3455ff8-vanilla
> [   26.254154] BPF:      type_id=3D35503 offset=3D178440 size=3D4
> [   26.259125] BPF:
> [   26.261054] BPF:Invalid offset
> [   26.264119] BPF:

It took me a while to reliably bisect this, but it clearly points to
this commit:

e481fac7d80b ("mm/page_alloc: convert per-cpu list protection to local_lock=
")

One commit before it, 676535512684 ("mm/page_alloc: split per cpu page
lists and zone stats -fix"), works just fine.

I'll have to spend more time debugging what exactly is happening, but
the immediate problem is two different definitions of numa_node
per-cpu variable. They both are at the same offset within
.data..percpu ELF section, they both have the same name, but one of
them is marked as static and another as global. And one is int
variable, while another is struct pagesets. I'll look some more
tomorrow, but adding Jiri and Arnaldo for visibility.

[110907] DATASEC '.data..percpu' size=3D178904 vlen=3D303
...
        type_id=3D27753 offset=3D163976 size=3D4 (VAR 'numa_node')
        type_id=3D27754 offset=3D163976 size=3D4 (VAR 'numa_node')

[27753] VAR 'numa_node' type_id=3D27556, linkage=3Dstatic
[27754] VAR 'numa_node' type_id=3D20, linkage=3Dglobal

[20] INT 'int' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=3DSIGNED

[27556] STRUCT 'pagesets' size=3D0 vlen=3D1
        'lock' type_id=3D507 bits_offset=3D0

[506] STRUCT '(anon)' size=3D0 vlen=3D0
[507] TYPEDEF 'local_lock_t' type_id=3D506

So also something weird about those zero-sized struct pagesets and
local_lock_t inside it.

> [   26.264119]
> [   26.267437] failed to validate module [efivarfs] BTF: -22
> [   26.316724] systemd[1]: systemd 246.13+suse.105.g14581e0120 running in=
 system mode. (+PAM +AUDIT +SELINUX -IMA +APPARMOR -SMACK +SYSVINI
> T +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +ZSTD +SECCOMP +BLKI=
D +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=3Dunified)
> [   26.357990] systemd[1]: Detected architecture x86-64.
> [   26.363068] systemd[1]: Running in initial RAM disk.
>

[...]
