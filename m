Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E304391225
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 10:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhEZISa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 04:18:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229594AbhEZIS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 04:18:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622017017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eE2fP+TWlAmJ/gnP75aIg5o6IkLWt2hvDOXfzvWSdZk=;
        b=BfIHRC0oi+PwWOBcWm8hX2lopehAS2XrAFC4ugpz8FO4WBSXqecUQBOvxv7m0YeAO0F87A
        1wSXnwA9nXdBn/2aL75kipdmVqe24wG1SMiIU0KjYZXHaQRBuKKhcDuBwVws02NbR7nbYQ
        MZ4hDBH0C0x9qem5vj6Nc4W3tDHG3rM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-BvhKIyG1OCm7jzGFMggs5Q-1; Wed, 26 May 2021 04:16:56 -0400
X-MC-Unique: BvhKIyG1OCm7jzGFMggs5Q-1
Received: by mail-wm1-f71.google.com with SMTP id b206-20020a1c1bd70000b02901713122405eso195611wmb.1
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 01:16:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eE2fP+TWlAmJ/gnP75aIg5o6IkLWt2hvDOXfzvWSdZk=;
        b=edAuF8bKG0gvIgV1dnkwnylIgCXKfZS7RaVUYwV+jM1NQfhzpbSVmliyLqlDZq8IUs
         fyc26n7opk5xorGcee6L2NMhiB3ImZx7LGAwXnTf5BCb3iaWBkimnCNhif5/NFMXrd5Y
         Ja0lUrh2vGhY/FGWmk0+3CpOrhWheHdgmELZc/ntlsFXF8cDrZcmnv2/dobll4jav0YG
         wUUv5HQyTKhylI1J7PsRX9srgLJugVmL8dIdBkw2sEYEmfWRNXwWgrGCx3y+CDvyMRv4
         wH+zpO8sX7aFk9ebvLjorEEXOsbeDqTTamjMWMHn90vR1TIxOBGLUyQddZOAh5kiwQzM
         J54Q==
X-Gm-Message-State: AOAM533r+Immr34mh6D/SywQkcjnD+hrEuVB76ablTasZpF9cujtjlYQ
        alUKqdW8OuQ1pZSnAXjPG39VRhWERTUyvTkEYeZTwinW8IPj4ZH6FIn3rn7MJXfAE30Jjn5hWKd
        Y9J63h/dMU5Q1+GbX
X-Received: by 2002:a1c:65c2:: with SMTP id z185mr2258136wmb.2.1622017014968;
        Wed, 26 May 2021 01:16:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDurN//AkVCUXWdJMKlfPy9+peeMSfkF9wTU1C0DbAfbotusb1FD6LmhriDoL80bxtSiHvqg==
X-Received: by 2002:a1c:65c2:: with SMTP id z185mr2258108wmb.2.1622017014711;
        Wed, 26 May 2021 01:16:54 -0700 (PDT)
Received: from ?IPv6:2003:d8:2f38:2400:62f4:c5fa:ba13:ac32? (p200300d82f38240062f4c5faba13ac32.dip0.t-ipconnect.de. [2003:d8:2f38:2400:62f4:c5fa:ba13:ac32])
        by smtp.gmail.com with ESMTPSA id 60sm1695777wrq.14.2021.05.26.01.16.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 01:16:54 -0700 (PDT)
Subject: Re: [PATCH] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
To:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Suchanek <msuchanek@suse.de>,
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
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
References: <20210526080741.GW30378@techsingularity.net>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <1e0f727a-f9c4-4fc1-b4d2-c075df7a4600@redhat.com>
Date:   Wed, 26 May 2021 10:16:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210526080741.GW30378@techsingularity.net>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.05.21 10:07, Mel Gorman wrote:
> Michal Suchanek reported the following problem with linux-next
> 
>    [    0.000000] Linux version 5.13.0-rc2-next-20210519-1.g3455ff8-vanilla (geeko@buildhost) (gcc (SUSE Linux) 10.3.0, GNU ld (GNU Binutils; openSUSE Tumbleweed) 2.36.1.20210326-3) #1 SMP Wed May 19 10:05:10 UTC 2021 (3455ff8)
>    [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.13.0-rc2-next-20210519-1.g3455ff8-vanilla root=UUID=ec42c33e-a2c2-4c61-afcc-93e9527 8f687 plymouth.enable=0 resume=/dev/disk/by-uuid/f1fe4560-a801-4faf-a638-834c407027c7 mitigations=auto earlyprintk initcall_debug nomodeset earlycon ignore_loglevel console=ttyS0,115200
> ...
>    [   26.093364] calling  tracing_set_default_clock+0x0/0x62 @ 1
>    [   26.098937] initcall tracing_set_default_clock+0x0/0x62 returned 0 after 0 usecs
>    [   26.106330] calling  acpi_gpio_handle_deferred_request_irqs+0x0/0x7c @ 1
>    [   26.113033] initcall acpi_gpio_handle_deferred_request_irqs+0x0/0x7c returned 0 after 3 usecs
>    [   26.121559] calling  clk_disable_unused+0x0/0x102 @ 1
>    [   26.126620] initcall clk_disable_unused+0x0/0x102 returned 0 after 0 usecs
>    [   26.133491] calling  regulator_init_complete+0x0/0x25 @ 1
>    [   26.138890] initcall regulator_init_complete+0x0/0x25 returned 0 after 0 usecs
>    [   26.147816] Freeing unused decrypted memory: 2036K
>    [   26.153682] Freeing unused kernel image (initmem) memory: 2308K
>    [   26.165776] Write protecting the kernel read-only data: 26624k
>    [   26.173067] Freeing unused kernel image (text/rodata gap) memory: 2036K
>    [   26.180416] Freeing unused kernel image (rodata/data gap) memory: 1184K
>    [   26.187031] Run /init as init process
>    [   26.190693]   with arguments:
>    [   26.193661]     /init
>    [   26.195933]   with environment:
>    [   26.199079]     HOME=/
>    [   26.201444]     TERM=linux
>    [   26.204152]     BOOT_IMAGE=/boot/vmlinuz-5.13.0-rc2-next-20210519-1.g3455ff8-vanilla
>    [   26.254154] BPF:      type_id=35503 offset=178440 size=4
>    [   26.259125] BPF:
>    [   26.261054] BPF:Invalid offset
>    [   26.264119] BPF:
>    [   26.264119]
>    [   26.267437] failed to validate module [efivarfs] BTF: -22
> 
> Andrii Nakryiko bisected the problem to the commit "mm/page_alloc: convert
> per-cpu list protection to local_lock" currently staged in mmotm. In his
> own words
> 
>    The immediate problem is two different definitions of numa_node per-cpu
>    variable. They both are at the same offset within .data..percpu ELF
>    section, they both have the same name, but one of them is marked as
>    static and another as global. And one is int variable, while another
>    is struct pagesets. I'll look some more tomorrow, but adding Jiri and
>    Arnaldo for visibility.
> 
>    [110907] DATASEC '.data..percpu' size=178904 vlen=303
>    ...
>          type_id=27753 offset=163976 size=4 (VAR 'numa_node')
>          type_id=27754 offset=163976 size=4 (VAR 'numa_node')
> 
>    [27753] VAR 'numa_node' type_id=27556, linkage=static
>    [27754] VAR 'numa_node' type_id=20, linkage=global
> 
>    [20] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
> 
>    [27556] STRUCT 'pagesets' size=0 vlen=1
>          'lock' type_id=507 bits_offset=0
> 
>    [506] STRUCT '(anon)' size=0 vlen=0
>    [507] TYPEDEF 'local_lock_t' type_id=506
> 
> The patch in question introduces a zero-sized per-cpu struct and while
> this is not wrong, versions of pahole prior to 1.22 (unreleased) get
> confused during BTF generation with two separate variables occupying the
> same address.
> 
> This patch checks for older versions of pahole and forces struct pagesets
> to be non-zero sized as a workaround when CONFIG_DEBUG_INFO_BTF is set. A
> warning is omitted so that distributions can update pahole when 1.22
> is released.
> 
> Reported-by: Michal Suchanek <msuchanek@suse.de>
> Reported-by: Hritik Vijay <hritikxx8@gmail.com>
> Debugged-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> ---
>   lib/Kconfig.debug |  3 +++
>   mm/page_alloc.c   | 11 +++++++++++
>   2 files changed, 14 insertions(+)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 678c13967580..f88a155b80a9 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -313,6 +313,9 @@ config DEBUG_INFO_BTF
>   config PAHOLE_HAS_SPLIT_BTF
>   	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
>   
> +config PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT
> +	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "122")
> +
>   config DEBUG_INFO_BTF_MODULES
>   	def_bool y
>   	depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ff8f706839ea..1d56d3de8e08 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -124,6 +124,17 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
>   
>   struct pagesets {
>   	local_lock_t lock;
> +#if defined(CONFIG_DEBUG_INFO_BTF) &&			\
> +    !defined(CONFIG_DEBUG_LOCK_ALLOC) &&		\
> +    !defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)
> +	/*
> +	 * pahole 1.21 and earlier gets confused by zero-sized per-CPU
> +	 * variables and produces invalid BTF. Ensure that
> +	 * sizeof(struct pagesets) != 0 for older versions of pahole.
> +	 */
> +	char __pahole_hack;
> +	#warning "pahole too old to support zero-sized struct pagesets"
> +#endif
>   };
>   static DEFINE_PER_CPU(struct pagesets, pagesets) = {
>   	.lock = INIT_LOCAL_LOCK(lock),
> 

Looks sane to me.

-- 
Thanks,

David / dhildenb

