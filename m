Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D268C32C48A
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392595AbhCDAPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47839 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233500AbhCCRA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 12:00:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614790724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YVxuue7y4Ed4LzXK8LsDrSNeQPTV4aHY0EceDjIx7oo=;
        b=N549gedJaC7I/X7tZetIZxYsotUq1B5PZ+tYas7AKlfad8rbNyNt4B2azflk3+Kje+QGy9
        I65G8sgt3V3XpUvvBI2Fmq06uPhObEZD3ZdIOq9cQkBNZpGeVVdX7nyu7jOYyK8UX3293r
        WzCnyoQUIsqjkd7PVCulMGbXXMC/lIc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-NYLQJRxCNxyCBin5zWPlcg-1; Wed, 03 Mar 2021 11:58:43 -0500
X-MC-Unique: NYLQJRxCNxyCBin5zWPlcg-1
Received: by mail-ej1-f69.google.com with SMTP id r26so5220513eja.22
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 08:58:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YVxuue7y4Ed4LzXK8LsDrSNeQPTV4aHY0EceDjIx7oo=;
        b=rR3+f/UxypixA84dcpuanDf0igUJNL8BCf1rVoSb3U5bcz95k8I3BxU0GrZp1zZaxU
         mKnnJrY6iVMOIwrIaH5CqgrHAxsGJwkRG3hPrSqvA5bDVSubo8zyVQX2PQwMmYMmF8Yd
         fMGpIzyP6lVoOi/1HyJTIxnX29bezXMd0tD+qMR6YnamKC9W6/+N7LDRZ7K00N4nMbrD
         4NqCb8OlGjT3waqdbnCJyxCcTzKeet6cIbT4x6nGdVfpQPuhNI1YXNW3+W5ndHGw2CIF
         Sj7AyOSjKjvGh18JZYB3SavfMUsZ8GbsI4qDevXdlhvHOyQ/WO/gO3Ssk/UjvTJD/00c
         smEA==
X-Gm-Message-State: AOAM530tFOpjjxSjTGBRCOsG7ZE7miRRBLfL13G4rnmklBsIF8Fxilmn
        8m7Q0YRpbPD2WMO0OAD+4ejVwtcZpfuJFqTUb9lQ08hPUS0gJK5B+eKpslr6MSLPQUWMudD42Ly
        69jHqR5xqjJQh7sSr
X-Received: by 2002:a05:6402:5211:: with SMTP id s17mr159783edd.327.1614790721754;
        Wed, 03 Mar 2021 08:58:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxY/SU0N9MgWd3KZ2ViJPUSomlejFErx+B7XNAbgw2BkwjxXMu2kBtsPZ5IfYmOkvBRaZ0h+Q==
X-Received: by 2002:a05:6402:5211:: with SMTP id s17mr159754edd.327.1614790721408;
        Wed, 03 Mar 2021 08:58:41 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d5sm22361912edu.12.2021.03.03.08.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 08:58:40 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de
Subject: Re: [RFC PATCH 2/12] x86/Hyper-V: Add new hvcall guest address host
 visibility support
In-Reply-To: <20210228150315.2552437-3-ltykernel@gmail.com>
References: <20210228150315.2552437-1-ltykernel@gmail.com>
 <20210228150315.2552437-3-ltykernel@gmail.com>
Date:   Wed, 03 Mar 2021 17:58:39 +0100
Message-ID: <87v9a8cgxs.fsf@vitty.brq.redhat.com>
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
> Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
> Co-Developed-by: Sunil Muthuswamy <sunilmut@microsoft.com>
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 13 ++++++++
>  arch/x86/include/asm/mshyperv.h    |  4 +--
>  arch/x86/kernel/cpu/mshyperv.c     | 46 ++++++++++++++++++++++++++
>  drivers/hv/channel.c               | 53 ++++++++++++++++++++++++++++--
>  drivers/net/hyperv/hyperv_net.h    |  1 +
>  drivers/net/hyperv/netvsc.c        |  9 +++--
>  drivers/uio/uio_hv_generic.c       |  6 ++--
>  include/asm-generic/hyperv-tlfs.h  |  1 +
>  include/linux/hyperv.h             |  3 +-
>  9 files changed, 126 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index fb1893a4c32b..d22b1c3f425a 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -573,4 +573,17 @@ enum hv_interrupt_type {
>  
>  #include <asm-generic/hyperv-tlfs.h>
>  
> +/* All input parameters should be in single page. */
> +#define HV_MAX_MODIFY_GPA_REP_COUNT		\
> +	((PAGE_SIZE - 2 * sizeof(u64)) / (sizeof(u64)))

Would it be easier to express this as '((PAGE_SIZE / sizeof(u64)) - 2' ?

> +
> +/* HvCallModifySparseGpaPageHostVisibility hypercall */
> +struct hv_input_modify_sparse_gpa_page_host_visibility {
> +	u64 partition_id;
> +	u32 host_visibility:2;
> +	u32 reserved0:30;
> +	u32 reserved1;
> +	u64 gpa_page_list[HV_MAX_MODIFY_GPA_REP_COUNT];
> +} __packed;
> +
>  #endif
> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
> index ccf60a809a17..1e8275d35c1f 100644
> --- a/arch/x86/include/asm/mshyperv.h
> +++ b/arch/x86/include/asm/mshyperv.h
> @@ -262,13 +262,13 @@ static inline void hv_set_msi_entry_from_desc(union hv_msi_entry *msi_entry,
>  	msi_entry->address.as_uint32 = msi_desc->msg.address_lo;
>  	msi_entry->data.as_uint32 = msi_desc->msg.data;
>  }
> -

stray change

>  struct irq_domain *hv_create_pci_msi_domain(void);
>  
>  int hv_map_ioapic_interrupt(int ioapic_id, bool level, int vcpu, int vector,
>  		struct hv_interrupt_entry *entry);
>  int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *entry);
> -
> +int hv_set_mem_host_visibility(void *kbuffer, u32 size, u32 visibility);
> +int hv_mark_gpa_visibility(u16 count, const u64 pfn[], u32 visibility);
>  #else /* CONFIG_HYPERV */
>  static inline void hyperv_init(void) {}
>  static inline void hyperv_setup_mmu_ops(void) {}
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> index e88bc296afca..347c32eac8fd 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -37,6 +37,8 @@
>  bool hv_root_partition;
>  EXPORT_SYMBOL_GPL(hv_root_partition);
>  
> +#define HV_PARTITION_ID_SELF ((u64)-1)
> +

We seem to have this already:

include/asm-generic/hyperv-tlfs.h:#define HV_PARTITION_ID_SELF          ((u64)-1)

>  struct ms_hyperv_info ms_hyperv;
>  EXPORT_SYMBOL_GPL(ms_hyperv);
>  
> @@ -477,3 +479,47 @@ const __initconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
>  	.init.msi_ext_dest_id	= ms_hyperv_msi_ext_dest_id,
>  	.init.init_platform	= ms_hyperv_init_platform,
>  };
> +
> +int hv_mark_gpa_visibility(u16 count, const u64 pfn[], u32 visibility)
> +{
> +	struct hv_input_modify_sparse_gpa_page_host_visibility **input_pcpu;
> +	struct hv_input_modify_sparse_gpa_page_host_visibility *input;
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
> +	input_pcpu = (struct hv_input_modify_sparse_gpa_page_host_visibility **)
> +			this_cpu_ptr(hyperv_pcpu_input_arg);
> +	input = *input_pcpu;
> +	if (unlikely(!input)) {
> +		local_irq_restore(flags);
> +		return -1;

-EFAULT/-ENOMEM/... maybe ?

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
> +	return -EFAULT;

Could we just propagate "hv_status & HV_HYPERCALL_RESULT_MASK" maybe?

> +}
> +EXPORT_SYMBOL(hv_mark_gpa_visibility);
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index daa21cc72beb..204e6f3598a5 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -237,6 +237,38 @@ int vmbus_send_modifychannel(u32 child_relid, u32 target_vp)
>  }
>  EXPORT_SYMBOL_GPL(vmbus_send_modifychannel);
>  
> +/*
> + * hv_set_mem_host_visibility - Set host visibility for specified memory.
> + */
> +int hv_set_mem_host_visibility(void *kbuffer, u32 size, u32 visibility)
> +{
> +	int i, pfn;
> +	int pagecount = size >> HV_HYP_PAGE_SHIFT;
> +	u64 *pfn_array;
> +	int ret = 0;
> +
> +	if (!hv_isolation_type_snp())
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

hv_mark_gpa_visibility() return different error codes and aggregating
them with 

 ret |= ...

will have an unpredictable result. I'd suggest bail immediately instead:

 if (ret)
     goto err_free_pfn_array;

> +		}
> +	}
> +

err_free_pfn_array:

> +	vfree(pfn_array);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(hv_set_mem_host_visibility);
> +
>  /*
>   * create_gpadl_header - Creates a gpadl for the specified buffer
>   */
> @@ -410,6 +442,12 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
>  	if (ret)
>  		return ret;
>  
> +	ret = hv_set_mem_host_visibility(kbuffer, size, visibility);
> +	if (ret) {
> +		pr_warn("Failed to set host visibility.\n");
> +		return ret;
> +	}
> +
>  	init_completion(&msginfo->waitevent);
>  	msginfo->waiting_channel = channel;
>  
> @@ -693,7 +731,9 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
>  error_free_info:
>  	kfree(open_info);
>  error_free_gpadl:
> -	vmbus_teardown_gpadl(newchannel, newchannel->ringbuffer_gpadlhandle);
> +	vmbus_teardown_gpadl(newchannel, newchannel->ringbuffer_gpadlhandle,
> +			     page_address(newchannel->ringbuffer_page),
> +			     newchannel->ringbuffer_pagecount << PAGE_SHIFT);

Instead of modifying vmbus_teardown_gpadl() interface and all its call
sites, could we just keep track of all established gpadls and then get 
the required data from there? I.e. make vmbus_establish_gpadl() save
kbuffer/size to some internal structure associated with 'gpadl_handle'.

>  	newchannel->ringbuffer_gpadlhandle = 0;
>  error_clean_ring:
>  	hv_ringbuffer_cleanup(&newchannel->outbound);
> @@ -740,7 +780,8 @@ EXPORT_SYMBOL_GPL(vmbus_open);
>  /*
>   * vmbus_teardown_gpadl -Teardown the specified GPADL handle
>   */
> -int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
> +int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle,
> +			 void *kbuffer, u32 size)

This probably doesn't matter but why not 'u64 size'?

>  {
>  	struct vmbus_channel_gpadl_teardown *msg;
>  	struct vmbus_channel_msginfo *info;
> @@ -793,6 +834,10 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
>  	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
>  
>  	kfree(info);
> +
> +	if (hv_set_mem_host_visibility(kbuffer, size, VMBUS_PAGE_NOT_VISIBLE))
> +		pr_warn("Fail to set mem host visibility.\n");

pr_err() maybe?

> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(vmbus_teardown_gpadl);
> @@ -869,7 +914,9 @@ static int vmbus_close_internal(struct vmbus_channel *channel)
>  	/* Tear down the gpadl for the channel's ring buffer */
>  	else if (channel->ringbuffer_gpadlhandle) {
>  		ret = vmbus_teardown_gpadl(channel,
> -					   channel->ringbuffer_gpadlhandle);
> +					   channel->ringbuffer_gpadlhandle,
> +					   page_address(channel->ringbuffer_page),
> +					   channel->ringbuffer_pagecount << PAGE_SHIFT);
>  		if (ret) {
>  			pr_err("Close failed: teardown gpadl return %d\n", ret);
>  			/*
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
> index 2a87cfa27ac0..b3a43c4ec8ab 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -1034,6 +1034,7 @@ struct netvsc_device {
>  
>  	/* Send buffer allocated by us */
>  	void *send_buf;
> +	u32 send_buf_size;
>  	u32 send_buf_gpadl_handle;
>  	u32 send_section_cnt;
>  	u32 send_section_size;
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index bb72c7578330..08d73401bb28 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -245,7 +245,9 @@ static void netvsc_teardown_recv_gpadl(struct hv_device *device,
>  
>  	if (net_device->recv_buf_gpadl_handle) {
>  		ret = vmbus_teardown_gpadl(device->channel,
> -					   net_device->recv_buf_gpadl_handle);
> +					   net_device->recv_buf_gpadl_handle,
> +					   net_device->recv_buf,
> +					   net_device->recv_buf_size);
>  
>  		/* If we failed here, we might as well return and have a leak
>  		 * rather than continue and a bugchk
> @@ -267,7 +269,9 @@ static void netvsc_teardown_send_gpadl(struct hv_device *device,
>  
>  	if (net_device->send_buf_gpadl_handle) {
>  		ret = vmbus_teardown_gpadl(device->channel,
> -					   net_device->send_buf_gpadl_handle);
> +					   net_device->send_buf_gpadl_handle,
> +					   net_device->send_buf,
> +					   net_device->send_buf_size);
>  
>  		/* If we failed here, we might as well return and have a leak
>  		 * rather than continue and a bugchk
> @@ -419,6 +423,7 @@ static int netvsc_init_buf(struct hv_device *device,
>  		ret = -ENOMEM;
>  		goto cleanup;
>  	}
> +	net_device->send_buf_size = buf_size;
>  
>  	/* Establish the gpadl handle for this buffer on this
>  	 * channel.  Note: This call uses the vmbus connection rather
> diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
> index 813a7bee5139..c8d4704fc90c 100644
> --- a/drivers/uio/uio_hv_generic.c
> +++ b/drivers/uio/uio_hv_generic.c
> @@ -181,13 +181,15 @@ static void
>  hv_uio_cleanup(struct hv_device *dev, struct hv_uio_private_data *pdata)
>  {
>  	if (pdata->send_gpadl) {
> -		vmbus_teardown_gpadl(dev->channel, pdata->send_gpadl);
> +		vmbus_teardown_gpadl(dev->channel, pdata->send_gpadl,
> +				     pdata->send_buf, SEND_BUFFER_SIZE);
>  		pdata->send_gpadl = 0;
>  		vfree(pdata->send_buf);
>  	}
>  
>  	if (pdata->recv_gpadl) {
> -		vmbus_teardown_gpadl(dev->channel, pdata->recv_gpadl);
> +		vmbus_teardown_gpadl(dev->channel, pdata->recv_gpadl,
> +				     pdata->recv_buf, RECV_BUFFER_SIZE);
>  		pdata->recv_gpadl = 0;
>  		vfree(pdata->recv_buf);
>  	}
> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
> index 83448e837ded..ad19f4199f90 100644
> --- a/include/asm-generic/hyperv-tlfs.h
> +++ b/include/asm-generic/hyperv-tlfs.h
> @@ -158,6 +158,7 @@ struct ms_hyperv_tsc_page {
>  #define HVCALL_RETARGET_INTERRUPT		0x007e
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
> +#define HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY 0x00db
>  
>  #define HV_FLUSH_ALL_PROCESSORS			BIT(0)
>  #define HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES	BIT(1)
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 016fdca20d6e..41cbaa2db567 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1183,7 +1183,8 @@ extern int vmbus_establish_gpadl(struct vmbus_channel *channel,
>  				      u32 visibility);
>  
>  extern int vmbus_teardown_gpadl(struct vmbus_channel *channel,
> -				     u32 gpadl_handle);
> +				u32 gpadl_handle,
> +				void *kbuffer, u32 size);
>  
>  void vmbus_reset_channel_cb(struct vmbus_channel *channel);

-- 
Vitaly

