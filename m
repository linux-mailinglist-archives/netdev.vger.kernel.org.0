Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A109391E5F
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbhEZRue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:50:34 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:51678 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhEZRuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 13:50:32 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 May 2021 13:50:31 EDT
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AB4191FD2E;
        Wed, 26 May 2021 17:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622050991; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FhwLWgQA/H6r0Q6/NuTDJGX+fECggpPUHvnSVd8w/N8=;
        b=qM2YF4S8iluCj3stLUkfbHkmbEFUUrWr3CglsS78PeoFOwT8Bq8CNAxavh0Ceg0ZTsWqiY
        VEyn7N3f3LK1ItLgdHiJpb0kIqrp6ELFu092RmbDrZ/A5d0CBGJXQHABCiwrc5tgUWGjmF
        7n3CjJ7dZo9E7Mz+2K/ZVw4gzTS+67w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622050991;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FhwLWgQA/H6r0Q6/NuTDJGX+fECggpPUHvnSVd8w/N8=;
        b=bz56rcfOXvFGrxINSTVBEX+E5H+XYi9VDKyWbITpJ/MbfJFoo9losKPDUsaPT0ptGSgBvm
        SxrLcNJlJTHgAQDA==
Received: from director2.suse.de (director2.suse-dmz.suse.de [192.168.254.72])
        by imap.suse.de (Postfix) with ESMTPSA id 80C5411A98;
        Wed, 26 May 2021 17:43:11 +0000 (UTC)
Date:   Wed, 26 May 2021 19:43:10 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>, bpf <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: (BTF) [PATCH] mm/page_alloc: Work around a pahole limitation
 with zero-sized struct pagesets
Message-ID: <20210526174310.GA8544@kitsune.suse.cz>
References: <20210526080741.GW30378@techsingularity.net>
 <20210526083342.GY8544@kitsune.suse.cz>
 <CAEf4BzZBW5bNF61p3+n7akUs1qztNJ4FwY4yAYRdjmP4ShFQKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzZBW5bNF61p3+n7akUs1qztNJ4FwY4yAYRdjmP4ShFQKQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 10:00:34AM -0700, Andrii Nakryiko wrote:
> On Wed, May 26, 2021 at 1:33 AM Michal Suchánek <msuchanek@suse.de> wrote:
> >
> > On Wed, May 26, 2021 at 09:07:41AM +0100, Mel Gorman wrote:
> > > Michal Suchanek reported the following problem with linux-next
> > >
> > >   [    0.000000] Linux version 5.13.0-rc2-next-20210519-1.g3455ff8-vanilla (geeko@buildhost) (gcc (SUSE Linux) 10.3.0, GNU ld (GNU Binutils; openSUSE Tumbleweed) 2.36.1.20210326-3) #1 SMP Wed May 19 10:05:10 UTC 2021 (3455ff8)
> > >   [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.13.0-rc2-next-20210519-1.g3455ff8-vanilla root=UUID=ec42c33e-a2c2-4c61-afcc-93e9527 8f687 plymouth.enable=0 resume=/dev/disk/by-uuid/f1fe4560-a801-4faf-a638-834c407027c7 mitigations=auto earlyprintk initcall_debug nomodeset earlycon ignore_loglevel console=ttyS0,115200
> > > ...
> > >   [   26.093364] calling  tracing_set_default_clock+0x0/0x62 @ 1
> > >   [   26.098937] initcall tracing_set_default_clock+0x0/0x62 returned 0 after 0 usecs
> > >   [   26.106330] calling  acpi_gpio_handle_deferred_request_irqs+0x0/0x7c @ 1
> > >   [   26.113033] initcall acpi_gpio_handle_deferred_request_irqs+0x0/0x7c returned 0 after 3 usecs
> > >   [   26.121559] calling  clk_disable_unused+0x0/0x102 @ 1
> > >   [   26.126620] initcall clk_disable_unused+0x0/0x102 returned 0 after 0 usecs
> > >   [   26.133491] calling  regulator_init_complete+0x0/0x25 @ 1
> > >   [   26.138890] initcall regulator_init_complete+0x0/0x25 returned 0 after 0 usecs
> > >   [   26.147816] Freeing unused decrypted memory: 2036K
> > >   [   26.153682] Freeing unused kernel image (initmem) memory: 2308K
> > >   [   26.165776] Write protecting the kernel read-only data: 26624k
> > >   [   26.173067] Freeing unused kernel image (text/rodata gap) memory: 2036K
> > >   [   26.180416] Freeing unused kernel image (rodata/data gap) memory: 1184K
> > >   [   26.187031] Run /init as init process
> > >   [   26.190693]   with arguments:
> > >   [   26.193661]     /init
> > >   [   26.195933]   with environment:
> > >   [   26.199079]     HOME=/
> > >   [   26.201444]     TERM=linux
> > >   [   26.204152]     BOOT_IMAGE=/boot/vmlinuz-5.13.0-rc2-next-20210519-1.g3455ff8-vanilla
> > >   [   26.254154] BPF:      type_id=35503 offset=178440 size=4
> > >   [   26.259125] BPF:
> > >   [   26.261054] BPF:Invalid offset
> > >   [   26.264119] BPF:
> > >   [   26.264119]
> > >   [   26.267437] failed to validate module [efivarfs] BTF: -22
> > >
> > > Andrii Nakryiko bisected the problem to the commit "mm/page_alloc: convert
> > > per-cpu list protection to local_lock" currently staged in mmotm. In his
> > > own words
> > >
> > >   The immediate problem is two different definitions of numa_node per-cpu
> > >   variable. They both are at the same offset within .data..percpu ELF
> > >   section, they both have the same name, but one of them is marked as
> > >   static and another as global. And one is int variable, while another
> > >   is struct pagesets. I'll look some more tomorrow, but adding Jiri and
> > >   Arnaldo for visibility.
> > >
> > >   [110907] DATASEC '.data..percpu' size=178904 vlen=303
> > >   ...
> > >         type_id=27753 offset=163976 size=4 (VAR 'numa_node')
> > >         type_id=27754 offset=163976 size=4 (VAR 'numa_node')
> > >
> > >   [27753] VAR 'numa_node' type_id=27556, linkage=static
> > >   [27754] VAR 'numa_node' type_id=20, linkage=global
> > >
> > >   [20] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
> > >
> > >   [27556] STRUCT 'pagesets' size=0 vlen=1
> > >         'lock' type_id=507 bits_offset=0
> > >
> > >   [506] STRUCT '(anon)' size=0 vlen=0
> > >   [507] TYPEDEF 'local_lock_t' type_id=506
> > >
> > > The patch in question introduces a zero-sized per-cpu struct and while
> > > this is not wrong, versions of pahole prior to 1.22 (unreleased) get
> > > confused during BTF generation with two separate variables occupying the
> > > same address.
> > >
> > > This patch checks for older versions of pahole and forces struct pagesets
> > > to be non-zero sized as a workaround when CONFIG_DEBUG_INFO_BTF is set. A
> > > warning is omitted so that distributions can update pahole when 1.22
> > > is released.
> > >
> > > Reported-by: Michal Suchanek <msuchanek@suse.de>
> > > Reported-by: Hritik Vijay <hritikxx8@gmail.com>
> > > Debugged-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > > Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> > > ---
> > >  lib/Kconfig.debug |  3 +++
> > >  mm/page_alloc.c   | 11 +++++++++++
> > >  2 files changed, 14 insertions(+)
> > >
> > > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > > index 678c13967580..f88a155b80a9 100644
> > > --- a/lib/Kconfig.debug
> > > +++ b/lib/Kconfig.debug
> > > @@ -313,6 +313,9 @@ config DEBUG_INFO_BTF
> > >  config PAHOLE_HAS_SPLIT_BTF
> > >       def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
> > >
> > > +config PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT
> > > +     def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "122")
> > > +
> >
> > This does not seem workable with dummy-tools.
> >
> > Do we even have dummy pahole?
> >
> 
> I don't know what dummy-tools is, so probably no. But if you don't
> have pahole on the build host, you can't have DEBUG_INFO_BTF=y
> anyways. As in, your build will fail because it will be impossible to
> generate BTF information. So you'll have to disable DEBUG_INFO_BTF if
> you can't get pahole onto your build host for some reason.

dummy-tools is used to maintain configuration files outside of build
the environment. It is not easy to have all tools with all bells and
whistles for all architectures on one machine. That is you should be
able to enable DEBUG_INFO_BTF without pahole, and then build the config
on a build host that has a compiler and pohole for the target
architecture.

Thanks

Michal
