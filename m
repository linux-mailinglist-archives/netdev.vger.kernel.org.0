Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4073E58D1
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239979AbhHJLE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:04:26 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:37841 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhHJLEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 07:04:24 -0400
Received: by mail-wm1-f49.google.com with SMTP id l34-20020a05600c1d22b02902573c214807so1653649wms.2;
        Tue, 10 Aug 2021 04:04:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h9AyImD9UvKdyZgMt8rSQ3Uk0c9+Og7qG6N7oOE6PXA=;
        b=kknAMMFV3iMz7H80toJ2ORuFVGtBvrkwJSfkuHhCKbXuVF4OQrz5PzJeOs0Xuz5j7p
         xhL01MjmRsVdVz+M1yfRR6HD0JtOpP9lWpZ2u7MXBMiK1QDNFeMlAHjMMT4+7RL64lZ/
         RpW/x+ew/PaPWvQIdT40J1Iowt1KgPE4VrCtwiCPn8thDNonKp409qm/GB1+UzcDGSjn
         jhZmnZFZgbsxFJKCtuVxgZlNwskbq6ZXK3i/8jlp36f7Dulvq2C4aLQ6xJakO46mL0ha
         LVO7IMmMrZ0bzcvNmLbMSR1bSK02iDDOlflDfU95laObwOK3RlOqUoWtNz6qIE8/bTXV
         e7MQ==
X-Gm-Message-State: AOAM530vZi9rm76tpq+UMpAaKrkGothBLTB+7QkuShDZb1+suRtR6Gms
        ncPISjSddmFAV61dsjlXEHI=
X-Google-Smtp-Source: ABdhPJyrk1wBfHB9MekkHvpHW9x6fYmFebxaC/tx0zZS+XISdOGMjx9hLm+CPvA9MFZ9+dQ3n/YQhA==
X-Received: by 2002:a05:600c:3798:: with SMTP id o24mr4061437wmr.18.1628593441621;
        Tue, 10 Aug 2021 04:04:01 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id q3sm3504575wmf.37.2021.08.10.04.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 04:04:01 -0700 (PDT)
Date:   Tue, 10 Aug 2021 11:03:59 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        sfr@canb.auug.org.au, saravanand@fb.com,
        krish.sadhukhan@oracle.com, aneesh.kumar@linux.ibm.com,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        hannes@cmpxchg.org, tj@kernel.org, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: Re: [PATCH V3 03/13] x86/HV: Add new hvcall guest address host
 visibility support
Message-ID: <20210810110359.i4qodw7h36zrsicp@liuwe-devbox-debian-v2>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-4-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809175620.720923-4-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 01:56:07PM -0400, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> Add new hvcall guest address host visibility support to mark
> memory visible to host. Call it inside set_memory_decrypted
> /encrypted(). Add HYPERVISOR feature check in the
> hv_is_isolation_supported() to optimize in non-virtualization
> environment.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
> Change since v2:
>        * Rework __set_memory_enc_dec() and call Hyper-V and AMD function
>          according to platform check.
> 
> Change since v1:
>        * Use new staic call x86_set_memory_enc to avoid add Hyper-V
>          specific check in the set_memory code.
> ---
>  arch/x86/hyperv/Makefile           |   2 +-
>  arch/x86/hyperv/hv_init.c          |   6 ++
>  arch/x86/hyperv/ivm.c              | 114 +++++++++++++++++++++++++++++
>  arch/x86/include/asm/hyperv-tlfs.h |  20 +++++
>  arch/x86/include/asm/mshyperv.h    |   4 +-
>  arch/x86/mm/pat/set_memory.c       |  19 +++--
>  include/asm-generic/hyperv-tlfs.h  |   1 +
>  include/asm-generic/mshyperv.h     |   1 +
>  8 files changed, 160 insertions(+), 7 deletions(-)
>  create mode 100644 arch/x86/hyperv/ivm.c
> 
> diff --git a/arch/x86/hyperv/Makefile b/arch/x86/hyperv/Makefile
> index 48e2c51464e8..5d2de10809ae 100644
> --- a/arch/x86/hyperv/Makefile
> +++ b/arch/x86/hyperv/Makefile
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -obj-y			:= hv_init.o mmu.o nested.o irqdomain.o
> +obj-y			:= hv_init.o mmu.o nested.o irqdomain.o ivm.o
>  obj-$(CONFIG_X86_64)	+= hv_apic.o hv_proc.o
>  
>  ifdef CONFIG_X86_64
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index 0bb4d9ca7a55..b3683083208a 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -607,6 +607,12 @@ EXPORT_SYMBOL_GPL(hv_get_isolation_type);
>  
>  bool hv_is_isolation_supported(void)
>  {
> +	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
> +		return 0;

Nit: false instead of 0.

> +
> +	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV))
> +		return 0;
> +
>  	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
>  }
>  
[...]
> +int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
> +			   enum hv_mem_host_visibility visibility)
> +{
> +	struct hv_gpa_range_for_visibility **input_pcpu, *input;
> +	u16 pages_processed;
> +	u64 hv_status;
> +	unsigned long flags;
> +
> +	/* no-op if partition isolation is not enabled */
> +	if (!hv_is_isolation_supported())
> +		return 0;
> +
> +	if (count > HV_MAX_MODIFY_GPA_REP_COUNT) {
> +		pr_err("Hyper-V: GPA count:%d exceeds supported:%lu\n", count,
> +			HV_MAX_MODIFY_GPA_REP_COUNT);
> +		return -EINVAL;
> +	}
> +
> +	local_irq_save(flags);
> +	input_pcpu = (struct hv_gpa_range_for_visibility **)
> +			this_cpu_ptr(hyperv_pcpu_input_arg);
> +	input = *input_pcpu;
> +	if (unlikely(!input)) {
> +		local_irq_restore(flags);
> +		return -EINVAL;
> +	}
> +
> +	input->partition_id = HV_PARTITION_ID_SELF;
> +	input->host_visibility = visibility;
> +	input->reserved0 = 0;
> +	input->reserved1 = 0;
> +	memcpy((void *)input->gpa_page_list, pfn, count * sizeof(*pfn));
> +	hv_status = hv_do_rep_hypercall(
> +			HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY, count,
> +			0, input, &pages_processed);
> +	local_irq_restore(flags);
> +
> +	if (!(hv_status & HV_HYPERCALL_RESULT_MASK))
> +		return 0;
> +
> +	return hv_status & HV_HYPERCALL_RESULT_MASK;

Joseph introduced a few helper functions in 753ed9c95c37d. They will
make the code simpler.

Wei.
