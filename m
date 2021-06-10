Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A34B3A28A8
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 11:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhFJJtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 05:49:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56093 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229941AbhFJJtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 05:49:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623318449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6SOXwaEoB1r4wx6rBI6iO/FkwbNbkxuPQhDm99+pms4=;
        b=DxUbaHr+IR2BJrfcV3lRRTsDMkQD3Eq+/l/GWK74HGbPDkk0sCtsNtCYoH994aTx6IsdIn
        dl0ESmKY1Is3DZIZJ5YIBKh/oxvDt2K6h3vrSCllkGU9/54XcYuaiBHHu3PSh+UhfMVTOE
        PegkkPomB14HicD7aUhJrSSyiUbDWRU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-9Zhh4KM9NWaGZEAsz5fANA-1; Thu, 10 Jun 2021 05:47:27 -0400
X-MC-Unique: 9Zhh4KM9NWaGZEAsz5fANA-1
Received: by mail-wm1-f71.google.com with SMTP id v20-20020a05600c2154b029019a6368bfe4so2861032wml.2
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 02:47:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6SOXwaEoB1r4wx6rBI6iO/FkwbNbkxuPQhDm99+pms4=;
        b=CyHcm4QfBpEmxCp1VhyWIwOBbIM65HJLO7rTy0wiJVFhF6Xhx2GzenUs9dKx7HyDSa
         DX8PzKKqeCNV1dUR2KkDwCguT+tj5hQK/NrxxtTaY8JW+/c0tdQaSx5aHYoqAwW2UchC
         WFE4L8c7BHe++JJdTI110x0yFfFoJwEvHhxfHUgX4rQr+ojEUkKTmscBNjVDj3GwTp1W
         nq9FGe3OuKbaq1wx7VBPm5IB2Cc9eup66n9wQvG9ER3NjI8JFdKO3lh8HtiU7yCYuquP
         BRqTn4ghXFwmPkv3DE6mGRu7Zc5P+lRHiNMpHszPcLbznXiHlSmBlppsSS07hQY56/KA
         D5bw==
X-Gm-Message-State: AOAM530X+Qb0Szjk4p6VFtuPB2bw/4wQtdBiArFTKFw0JsdYKtyalPo3
        B3Cem4994yWvYqGnNwE/Ysd6gdWALmA8y/jFtHEgQBfX3wMb12l8gXTNmlUK6Eklk4NWpgXLW8l
        vXj9rycgc7UugCw4I
X-Received: by 2002:a5d:6a02:: with SMTP id m2mr4390699wru.77.1623318446699;
        Thu, 10 Jun 2021 02:47:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2dUezxzGYnsl/xPnZ5DutUwwD8Qpsl170CTiWMTdnHNIbMR6YpxqB5Zb+USUdHAJsBsFR8g==
X-Received: by 2002:a5d:6a02:: with SMTP id m2mr4390649wru.77.1623318446473;
        Thu, 10 Jun 2021 02:47:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x125sm2708442wmg.37.2021.06.10.02.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 02:47:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, cai@lca.pw,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        Tianyu.Lan@microsoft.com, konrad.wilk@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: Re: [RFC PATCH V3 03/11] x86/Hyper-V: Add new hvcall guest address
 host visibility support
In-Reply-To: <20210530150628.2063957-4-ltykernel@gmail.com>
References: <20210530150628.2063957-1-ltykernel@gmail.com>
 <20210530150628.2063957-4-ltykernel@gmail.com>
Date:   Thu, 10 Jun 2021 11:47:23 +0200
Message-ID: <878s3iyrtg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tianyu Lan <ltykernel@gmail.com> writes:

> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>
> Add new hvcall guest address host visibility support. Mark vmbus
> ring buffer visible to host when create gpadl buffer and mark back
> to not visible when tear down gpadl buffer.
>
> Co-developed-by: Sunil Muthuswamy <sunilmut@microsoft.com>
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  arch/x86/hyperv/Makefile           |   2 +-
>  arch/x86/hyperv/ivm.c              | 106 +++++++++++++++++++++++++++++
>  arch/x86/include/asm/hyperv-tlfs.h |  24 +++++++
>  arch/x86/include/asm/mshyperv.h    |   4 +-
>  arch/x86/mm/pat/set_memory.c       |  10 ++-
>  drivers/hv/channel.c               |  38 ++++++++++-
>  include/asm-generic/hyperv-tlfs.h  |   1 +
>  include/linux/hyperv.h             |  10 +++
>  8 files changed, 190 insertions(+), 5 deletions(-)
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
> diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
> new file mode 100644
> index 000000000000..fad1d3024056
> --- /dev/null
> +++ b/arch/x86/hyperv/ivm.c
> @@ -0,0 +1,106 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Hyper-V Isolation VM interface with paravisor and hypervisor
> + *
> + * Author:
> + *  Tianyu Lan <Tianyu.Lan@microsoft.com>
> + */
> +
> +#include <linux/hyperv.h>
> +#include <linux/types.h>
> +#include <linux/bitfield.h>
> +#include <asm/io.h>
> +#include <asm/mshyperv.h>
> +
> +/*
> + * hv_mark_gpa_visibility - Set pages visible to host via hvcall.
> + *
> + * In Isolation VM, all guest memory is encripted from host and guest
> + * needs to set memory visible to host via hvcall before sharing memory
> + * with host.
> + */
> +int hv_mark_gpa_visibility(u16 count, const u64 pfn[], u32 visibility)
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
> +}
> +EXPORT_SYMBOL(hv_mark_gpa_visibility);
> +
> +/*
> + * hv_set_mem_host_visibility - Set specified memory visible to host.
> + *
> + * In Isolation VM, all guest memory is encrypted from host and guest
> + * needs to set memory visible to host via hvcall before sharing memory
> + * with host. This function works as wrap of hv_mark_gpa_visibility()
> + * with memory base and size.
> + */
> +int hv_set_mem_host_visibility(void *kbuffer, size_t size,
> +			       enum vmbus_page_visibility visibility)
> +{
> +	int pagecount = size >> HV_HYP_PAGE_SHIFT;
> +	u64 *pfn_array;
> +	int ret = 0;
> +	int i, pfn;
> +
> +	if (!hv_is_isolation_supported())
> +		return 0;
> +
> +	pfn_array = vzalloc(HV_HYP_PAGE_SIZE);
> +	if (!pfn_array)
> +		return -ENOMEM;
> +
> +	for (i = 0, pfn = 0; i < pagecount; i++) {
> +		pfn_array[pfn] = virt_to_hvpfn(kbuffer + i * HV_HYP_PAGE_SIZE);
> +		pfn++;
> +
> +		if (pfn == HV_MAX_MODIFY_GPA_REP_COUNT || i == pagecount - 1) {
> +			ret |= hv_mark_gpa_visibility(pfn, pfn_array, visibility);
> +			pfn = 0;
> +
> +			if (ret)
> +				goto err_free_pfn_array;
> +		}
> +	}
> +
> + err_free_pfn_array:
> +	vfree(pfn_array);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(hv_set_mem_host_visibility);
> +
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index 606f5cc579b2..632281b91b44 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -262,6 +262,17 @@ enum hv_isolation_type {
>  #define HV_X64_MSR_TIME_REF_COUNT	HV_REGISTER_TIME_REF_COUNT
>  #define HV_X64_MSR_REFERENCE_TSC	HV_REGISTER_REFERENCE_TSC
>  
> +/* Hyper-V GPA map flags */
> +#define HV_MAP_GPA_PERMISSIONS_NONE            0x0
> +#define HV_MAP_GPA_READABLE                    0x1
> +#define HV_MAP_GPA_WRITABLE                    0x2
> +
> +enum vmbus_page_visibility {
> +	VMBUS_PAGE_NOT_VISIBLE = 0,
> +	VMBUS_PAGE_VISIBLE_READ_ONLY = 1,
> +	VMBUS_PAGE_VISIBLE_READ_WRITE = 3
> +};
> +

Why do we need both flags and the enum? I don't see HV_MAP_GPA_* being
used anywhere and VMBUS_PAGE_VISIBLE_READ_WRITE looks like
HV_MAP_GPA_READABLE | HV_MAP_GPA_WRITABLE.

As this is used to communicate with the host, I'd suggest to avoid using
enum and just use flags everywhere.

>  /*
>   * Declare the MSR used to setup pages used to communicate with the hypervisor.
>   */
> @@ -561,4 +572,17 @@ enum hv_interrupt_type {
>  
>  #include <asm-generic/hyperv-tlfs.h>
>  
> +/* All input parameters should be in single page. */
> +#define HV_MAX_MODIFY_GPA_REP_COUNT		\
> +	((PAGE_SIZE / sizeof(u64)) - 2)
> +
> +/* HvCallModifySparseGpaPageHostVisibility hypercall */
> +struct hv_gpa_range_for_visibility {
> +	u64 partition_id;
> +	u32 host_visibility:2;
> +	u32 reserved0:30;
> +	u32 reserved1;
> +	u64 gpa_page_list[HV_MAX_MODIFY_GPA_REP_COUNT];
> +} __packed;
> +
>  #endif
> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
> index aeacca7c4da8..6af9d55ffe3b 100644
> --- a/arch/x86/include/asm/mshyperv.h
> +++ b/arch/x86/include/asm/mshyperv.h
> @@ -194,7 +194,9 @@ struct irq_domain *hv_create_pci_msi_domain(void);
>  int hv_map_ioapic_interrupt(int ioapic_id, bool level, int vcpu, int vector,
>  		struct hv_interrupt_entry *entry);
>  int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *entry);
> -
> +int hv_mark_gpa_visibility(u16 count, const u64 pfn[], u32 visibility);
> +int hv_set_mem_host_visibility(void *kbuffer, size_t size,
> +			       enum vmbus_page_visibility visibility);
>  #else /* CONFIG_HYPERV */
>  static inline void hyperv_init(void) {}
>  static inline void hyperv_setup_mmu_ops(void) {}
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 156cd235659f..a82975600107 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -29,6 +29,8 @@
>  #include <asm/proto.h>
>  #include <asm/memtype.h>
>  #include <asm/set_memory.h>
> +#include <asm/hyperv-tlfs.h>
> +#include <asm/mshyperv.h>
>  
>  #include "../mm_internal.h"
>  
> @@ -1986,8 +1988,14 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>  	int ret;
>  
>  	/* Nothing to do if memory encryption is not active */
> -	if (!mem_encrypt_active())
> +	if (hv_is_isolation_supported()) {
> +		return hv_set_mem_host_visibility((void *)addr,
> +				numpages * HV_HYP_PAGE_SIZE,
> +				enc ? VMBUS_PAGE_NOT_VISIBLE
> +				: VMBUS_PAGE_VISIBLE_READ_WRITE);
> +	} else if (!mem_encrypt_active()) {
>  		return 0;
> +	}
>  
>  	/* Should not be working on unaligned addresses */
>  	if (WARN_ONCE(addr & ~PAGE_MASK, "misaligned address: %#lx\n", addr))
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index f3761c73b074..01048bb07082 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -17,6 +17,7 @@
>  #include <linux/hyperv.h>
>  #include <linux/uio.h>
>  #include <linux/interrupt.h>
> +#include <linux/set_memory.h>
>  #include <asm/page.h>
>  #include <asm/mshyperv.h>
>  
> @@ -465,7 +466,7 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
>  	struct list_head *curr;
>  	u32 next_gpadl_handle;
>  	unsigned long flags;
> -	int ret = 0;
> +	int ret = 0, index;
>  
>  	next_gpadl_handle =
>  		(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
> @@ -474,6 +475,13 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
>  	if (ret)
>  		return ret;
>  
> +	ret = set_memory_decrypted((unsigned long)kbuffer,
> +				   HVPFN_UP(size));
> +	if (ret) {
> +		pr_warn("Failed to set host visibility.\n");
> +		return ret;
> +	}
> +
>  	init_completion(&msginfo->waitevent);
>  	msginfo->waiting_channel = channel;
>  
> @@ -539,6 +547,15 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
>  	/* At this point, we received the gpadl created msg */
>  	*gpadl_handle = gpadlmsg->gpadl;
>  
> +	if (type == HV_GPADL_BUFFER)
> +		index = 0;
> +	else
> +		index = channel->gpadl_range[1].gpadlhandle ? 2 : 1;
> +
> +	channel->gpadl_range[index].size = size;
> +	channel->gpadl_range[index].buffer = kbuffer;
> +	channel->gpadl_range[index].gpadlhandle = *gpadl_handle;
> +
>  cleanup:
>  	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
>  	list_del(&msginfo->msglistentry);
> @@ -549,6 +566,11 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
>  	}
>  
>  	kfree(msginfo);
> +
> +	if (ret)
> +		set_memory_encrypted((unsigned long)kbuffer,
> +				     HVPFN_UP(size));
> +
>  	return ret;
>  }
>  
> @@ -811,7 +833,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
>  	struct vmbus_channel_gpadl_teardown *msg;
>  	struct vmbus_channel_msginfo *info;
>  	unsigned long flags;
> -	int ret;
> +	int ret, i;
>  
>  	info = kzalloc(sizeof(*info) +
>  		       sizeof(struct vmbus_channel_gpadl_teardown), GFP_KERNEL);
> @@ -859,6 +881,18 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
>  	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
>  
>  	kfree(info);
> +
> +	/* Find gpadl buffer virtual address and size. */
> +	for (i = 0; i < VMBUS_GPADL_RANGE_COUNT; i++)
> +		if (channel->gpadl_range[i].gpadlhandle == gpadl_handle)
> +			break;
> +
> +	if (set_memory_encrypted((unsigned long)channel->gpadl_range[i].buffer,
> +			HVPFN_UP(channel->gpadl_range[i].size)))
> +		pr_warn("Fail to set mem host visibility.\n");
> +
> +	channel->gpadl_range[i].gpadlhandle = 0;
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(vmbus_teardown_gpadl);
> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
> index 515c3fb06ab3..8a0219255545 100644
> --- a/include/asm-generic/hyperv-tlfs.h
> +++ b/include/asm-generic/hyperv-tlfs.h
> @@ -158,6 +158,7 @@ struct ms_hyperv_tsc_page {
>  #define HVCALL_RETARGET_INTERRUPT		0x007e
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
> +#define HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY 0x00db
>  
>  /* Extended hypercalls */
>  #define HV_EXT_CALL_QUERY_CAPABILITIES		0x8001
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 2e859d2f9609..06eccaba10c5 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -809,6 +809,14 @@ struct vmbus_device {
>  
>  #define VMBUS_DEFAULT_MAX_PKT_SIZE 4096
>  
> +struct vmbus_gpadl_range {
> +	u32 gpadlhandle;
> +	u32 size;
> +	void *buffer;
> +};
> +
> +#define VMBUS_GPADL_RANGE_COUNT		3
> +
>  struct vmbus_channel {
>  	struct list_head listentry;
>  
> @@ -829,6 +837,8 @@ struct vmbus_channel {
>  	struct completion rescind_event;
>  
>  	u32 ringbuffer_gpadlhandle;
> +	/* GPADL_RING and Send/Receive GPADL_BUFFER. */
> +	struct vmbus_gpadl_range gpadl_range[VMBUS_GPADL_RANGE_COUNT];
>  
>  	/* Allocated memory for ring buffer */
>  	struct page *ringbuffer_page;

-- 
Vitaly

