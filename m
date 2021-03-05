Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E089A32E219
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 07:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCEGXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 01:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCEGXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 01:23:39 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A95C061574;
        Thu,  4 Mar 2021 22:23:38 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id n10so672520pgl.10;
        Thu, 04 Mar 2021 22:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6bsrWdk18xwSq5j7VeulqDoW7JtpQr0LqPrgQqxosEA=;
        b=uAb66O2HK4DjAXQAeJIdXvx2XI29IAq2l9KPvnQWqxtY4WuaM4vpok42yYJc3h6c8w
         mM9QCWNHsKmQj/1ZccKX4BZMOoVwQf9Ygj2QaPKG0gQwrZHkMb7nl6rFhVupjT7fP8zb
         oi21tSohIzHZI58n5rbnJ5scmc2bMu9/Uj5v6MR9y0x+tTOZpcQFYufLjDUOrrVspCDC
         O1h5CF7iyyouiehJ60F3N6Ayt4GUtf4ducd5FnKqxqFoZ5oAf4vpdLaDMcaR6szJFDUP
         TbbhF29e0MvFu571l2+n5OBfb9Ch1JEoBIioSjYOrcGe+Mbz5LdKPFoFZ7kXUAyesaw6
         pp0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6bsrWdk18xwSq5j7VeulqDoW7JtpQr0LqPrgQqxosEA=;
        b=o5kxxGuhcrYnN1W44SDaNoVrD1CJOgEOZtAG5xZghbAm2wDX4JxhCve2M0Cztn4o08
         XUUQ6+j3ZrotGmVFvHmgBt73yymZvloMUEP0tFBhJLPkrt/C0nueIReBi8RdTp76kbvA
         xrxhVOvjsZh56dt8DsXjPU72jx/sizPLpNEmHhchgKRUKzj4MHELPrMxJVr5XPtOKtHI
         hYJ0aZch24f2Foh3XnJH4/TaIz2E3kl7CgdbKiBiKlXqiqISkl6sRO1AwoejFivoaSCa
         SNTTa2VA5i4XJYhQfIWuP4yDM4BC1UK9eXW68yXN1iarxyMk+WxuEeIBc/PyY1G9mvC1
         Nfaw==
X-Gm-Message-State: AOAM5308RkGxNlShGHybhJatQcCt7xtAneeFC5MBaVccYKSF94jX8g8F
        hgpAeFcLGj/jUCVcTqIMhhc=
X-Google-Smtp-Source: ABdhPJyyZ+y+5D/3253Q5xtcnAbBo91ZJBCwkvERA60wHJcbFKFfWd/YoT3EOhNy2qJje27s/16Q0A==
X-Received: by 2002:a62:e80f:0:b029:1f1:5a1d:e79a with SMTP id c15-20020a62e80f0000b02901f15a1de79amr762889pfi.21.1614925418362;
        Thu, 04 Mar 2021 22:23:38 -0800 (PST)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id v3sm1268246pfe.147.2021.03.04.22.23.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 22:23:38 -0800 (PST)
Subject: Re: [RFC PATCH 2/12] x86/Hyper-V: Add new hvcall guest address host
 visibility support
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de
References: <20210228150315.2552437-1-ltykernel@gmail.com>
 <20210228150315.2552437-3-ltykernel@gmail.com>
 <87v9a8cgxs.fsf@vitty.brq.redhat.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <47b4dac7-b4b8-2fac-8271-9adcd1b19b70@gmail.com>
Date:   Fri, 5 Mar 2021 14:23:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <87v9a8cgxs.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/4/2021 12:58 AM, Vitaly Kuznetsov wrote:
> Tianyu Lan <ltykernel@gmail.com> writes:
> 
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>
>> Add new hvcall guest address host visibility support. Mark vmbus
>> ring buffer visible to host when create gpadl buffer and mark back
>> to not visible when tear down gpadl buffer.
>>
>> Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
>> Co-Developed-by: Sunil Muthuswamy <sunilmut@microsoft.com>
>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>> ---
>>   arch/x86/include/asm/hyperv-tlfs.h | 13 ++++++++
>>   arch/x86/include/asm/mshyperv.h    |  4 +--
>>   arch/x86/kernel/cpu/mshyperv.c     | 46 ++++++++++++++++++++++++++
>>   drivers/hv/channel.c               | 53 ++++++++++++++++++++++++++++--
>>   drivers/net/hyperv/hyperv_net.h    |  1 +
>>   drivers/net/hyperv/netvsc.c        |  9 +++--
>>   drivers/uio/uio_hv_generic.c       |  6 ++--
>>   include/asm-generic/hyperv-tlfs.h  |  1 +
>>   include/linux/hyperv.h             |  3 +-
>>   9 files changed, 126 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
>> index fb1893a4c32b..d22b1c3f425a 100644
>> --- a/arch/x86/include/asm/hyperv-tlfs.h
>> +++ b/arch/x86/include/asm/hyperv-tlfs.h
>> @@ -573,4 +573,17 @@ enum hv_interrupt_type {
>>   
>>   #include <asm-generic/hyperv-tlfs.h>
>>   
>> +/* All input parameters should be in single page. */
>> +#define HV_MAX_MODIFY_GPA_REP_COUNT		\
>> +	((PAGE_SIZE - 2 * sizeof(u64)) / (sizeof(u64)))
> 
> Would it be easier to express this as '((PAGE_SIZE / sizeof(u64)) - 2'
Yes, will update. Thanks.

>> +
>> +/* HvCallModifySparseGpaPageHostVisibility hypercall */
>> +struct hv_input_modify_sparse_gpa_page_host_visibility {
>> +	u64 partition_id;
>> +	u32 host_visibility:2;
>> +	u32 reserved0:30;
>> +	u32 reserved1;
>> +	u64 gpa_page_list[HV_MAX_MODIFY_GPA_REP_COUNT];
>> +} __packed;
>> +
>>   #endif
>> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
>> index ccf60a809a17..1e8275d35c1f 100644
>> --- a/arch/x86/include/asm/mshyperv.h
>> +++ b/arch/x86/include/asm/mshyperv.h
>> @@ -262,13 +262,13 @@ static inline void hv_set_msi_entry_from_desc(union hv_msi_entry *msi_entry,
>>   	msi_entry->address.as_uint32 = msi_desc->msg.address_lo;
>>   	msi_entry->data.as_uint32 = msi_desc->msg.data;
>>   }
>> -
> 
> stray change
> 
>>   struct irq_domain *hv_create_pci_msi_domain(void);
>>   
>>   int hv_map_ioapic_interrupt(int ioapic_id, bool level, int vcpu, int vector,
>>   		struct hv_interrupt_entry *entry);
>>   int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *entry);
>> -
>> +int hv_set_mem_host_visibility(void *kbuffer, u32 size, u32 visibility);
>> +int hv_mark_gpa_visibility(u16 count, const u64 pfn[], u32 visibility);
>>   #else /* CONFIG_HYPERV */
>>   static inline void hyperv_init(void) {}
>>   static inline void hyperv_setup_mmu_ops(void) {}
>> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
>> index e88bc296afca..347c32eac8fd 100644
>> --- a/arch/x86/kernel/cpu/mshyperv.c
>> +++ b/arch/x86/kernel/cpu/mshyperv.c
>> @@ -37,6 +37,8 @@
>>   bool hv_root_partition;
>>   EXPORT_SYMBOL_GPL(hv_root_partition);
>>   
>> +#define HV_PARTITION_ID_SELF ((u64)-1)
>> +
> 
> We seem to have this already:
> 
> include/asm-generic/hyperv-tlfs.h:#define HV_PARTITION_ID_SELF          ((u64)-1)

>>   struct ms_hyperv_info ms_hyperv;
>>   EXPORT_SYMBOL_GPL(ms_hyperv);
>>   
>> @@ -477,3 +479,47 @@ const __initconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
>>   	.init.msi_ext_dest_id	= ms_hyperv_msi_ext_dest_id,
>>   	.init.init_platform	= ms_hyperv_init_platform,
>>   };
>> +
>> +int hv_mark_gpa_visibility(u16 count, const u64 pfn[], u32 visibility)
>> +{
>> +	struct hv_input_modify_sparse_gpa_page_host_visibility **input_pcpu;
>> +	struct hv_input_modify_sparse_gpa_page_host_visibility *input;
>> +	u16 pages_processed;
>> +	u64 hv_status;
>> +	unsigned long flags;
>> +
>> +	/* no-op if partition isolation is not enabled */
>> +	if (!hv_is_isolation_supported())
>> +		return 0;
>> +
>> +	if (count > HV_MAX_MODIFY_GPA_REP_COUNT) {
>> +		pr_err("Hyper-V: GPA count:%d exceeds supported:%lu\n", count,
>> +			HV_MAX_MODIFY_GPA_REP_COUNT);
>> +		return -EINVAL;
>> +	}
>> +
>> +	local_irq_save(flags);
>> +	input_pcpu = (struct hv_input_modify_sparse_gpa_page_host_visibility **)
>> +			this_cpu_ptr(hyperv_pcpu_input_arg);
>> +	input = *input_pcpu;
>> +	if (unlikely(!input)) {
>> +		local_irq_restore(flags);
>> +		return -1;
> 
> -EFAULT/-ENOMEM/... maybe ?

Yes, will update.
> 
>> +	}
>> +
>> +	input->partition_id = HV_PARTITION_ID_SELF;
>> +	input->host_visibility = visibility;
>> +	input->reserved0 = 0;
>> +	input->reserved1 = 0;
>> +	memcpy((void *)input->gpa_page_list, pfn, count * sizeof(*pfn));
>> +	hv_status = hv_do_rep_hypercall(
>> +			HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY, count,
>> +			0, input, &pages_processed);
>> +	local_irq_restore(flags);
>> +
>> +	if (!(hv_status & HV_HYPERCALL_RESULT_MASK))
>> +		return 0;
>> +
>> +	return -EFAULT;
> 
> Could we just propagate "hv_status & HV_HYPERCALL_RESULT_MASK" maybe?

Yes. will update.

> 
>> +}
>> +EXPORT_SYMBOL(hv_mark_gpa_visibility);
>> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
>> index daa21cc72beb..204e6f3598a5 100644
>> --- a/drivers/hv/channel.c
>> +++ b/drivers/hv/channel.c
>> @@ -237,6 +237,38 @@ int vmbus_send_modifychannel(u32 child_relid, u32 target_vp)
>>   }
>>   EXPORT_SYMBOL_GPL(vmbus_send_modifychannel);
>>   
>> +/*
>> + * hv_set_mem_host_visibility - Set host visibility for specified memory.
>> + */
>> +int hv_set_mem_host_visibility(void *kbuffer, u32 size, u32 visibility)
>> +{
>> +	int i, pfn;
>> +	int pagecount = size >> HV_HYP_PAGE_SHIFT;
>> +	u64 *pfn_array;
>> +	int ret = 0;
>> +
>> +	if (!hv_isolation_type_snp())
>> +		return 0;
>> +
>> +	pfn_array = vzalloc(HV_HYP_PAGE_SIZE);
>> +	if (!pfn_array)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0, pfn = 0; i < pagecount; i++) {
>> +		pfn_array[pfn] = virt_to_hvpfn(kbuffer + i * HV_HYP_PAGE_SIZE);
>> +		pfn++;
>> +
>> +		if (pfn == HV_MAX_MODIFY_GPA_REP_COUNT || i == pagecount - 1) {
>> +			ret |= hv_mark_gpa_visibility(pfn, pfn_array, visibility);
>> +			pfn = 0;
> 
> hv_mark_gpa_visibility() return different error codes and aggregating
> them with
> 
>   ret |= ...
> 
> will have an unpredictable result. I'd suggest bail immediately instead:
> 
>   if (ret)
>       goto err_free_pfn_array;

Yes, this makes sense. Thanks.
> 
>> +		}
>> +	}
>> +
> 
> err_free_pfn_array:
> 
>> +	vfree(pfn_array);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(hv_set_mem_host_visibility);
>> +
>>   /*
>>    * create_gpadl_header - Creates a gpadl for the specified buffer
>>    */
>> @@ -410,6 +442,12 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
>>   	if (ret)
>>   		return ret;
>>   
>> +	ret = hv_set_mem_host_visibility(kbuffer, size, visibility);
>> +	if (ret) {
>> +		pr_warn("Failed to set host visibility.\n");
>> +		return ret;
>> +	}
>> +
>>   	init_completion(&msginfo->waitevent);
>>   	msginfo->waiting_channel = channel;
>>   
>> @@ -693,7 +731,9 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
>>   error_free_info:
>>   	kfree(open_info);
>>   error_free_gpadl:
>> -	vmbus_teardown_gpadl(newchannel, newchannel->ringbuffer_gpadlhandle);
>> +	vmbus_teardown_gpadl(newchannel, newchannel->ringbuffer_gpadlhandle,
>> +			     page_address(newchannel->ringbuffer_page),
>> +			     newchannel->ringbuffer_pagecount << PAGE_SHIFT);
> 
> Instead of modifying vmbus_teardown_gpadl() interface and all its call
> sites, could we just keep track of all established gpadls and then get
> the required data from there? I.e. make vmbus_establish_gpadl() save
> kbuffer/size to some internal structure associated with 'gpadl_handle'.
> 

Yes, that's another approach. Add an array or list in struct vmbus_channel.

>>   	newchannel->ringbuffer_gpadlhandle = 0;
>>   error_clean_ring:
>>   	hv_ringbuffer_cleanup(&newchannel->outbound);
>> @@ -740,7 +780,8 @@ EXPORT_SYMBOL_GPL(vmbus_open);
>>   /*
>>    * vmbus_teardown_gpadl -Teardown the specified GPADL handle
>>    */
>> -int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
>> +int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle,
>> +			 void *kbuffer, u32 size)
> 
> This probably doesn't matter but why not 'u64 size'?
> 
>>   {
>>   	struct vmbus_channel_gpadl_teardown *msg;
>>   	struct vmbus_channel_msginfo *info;
>> @@ -793,6 +834,10 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
>>   	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
>>   
>>   	kfree(info);
>> +
>> +	if (hv_set_mem_host_visibility(kbuffer, size, VMBUS_PAGE_NOT_VISIBLE))
>> +		pr_warn("Fail to set mem host visibility.\n");
> 
> pr_err() maybe?
> 

Yes, will update.

>> +
>>   	return ret;
>>   }
>>   EXPORT_SYMBOL_GPL(vmbus_teardown_gpadl);
>> @@ -869,7 +914,9 @@ static int vmbus_close_internal(struct vmbus_channel *channel)
>>   	/* Tear down the gpadl for the channel's ring buffer */
>>   	else if (channel->ringbuffer_gpadlhandle) {
>>   		ret = vmbus_teardown_gpadl(channel,
>> -					   channel->ringbuffer_gpadlhandle);
>> +					   channel->ringbuffer_gpadlhandle,
>> +					   page_address(channel->ringbuffer_page),
>> +					   channel->ringbuffer_pagecount << PAGE_SHIFT);
>>   		if (ret) {
>>   			pr_err("Close failed: teardown gpadl return %d\n", ret);
>>   			/*
>> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
>> index 2a87cfa27ac0..b3a43c4ec8ab 100644
>> --- a/drivers/net/hyperv/hyperv_net.h
>> +++ b/drivers/net/hyperv/hyperv_net.h
>> @@ -1034,6 +1034,7 @@ struct netvsc_device {
>>   
>>   	/* Send buffer allocated by us */
>>   	void *send_buf;
>> +	u32 send_buf_size;
>>   	u32 send_buf_gpadl_handle;
>>   	u32 send_section_cnt;
>>   	u32 send_section_size;
>> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
>> index bb72c7578330..08d73401bb28 100644
>> --- a/drivers/net/hyperv/netvsc.c
>> +++ b/drivers/net/hyperv/netvsc.c
>> @@ -245,7 +245,9 @@ static void netvsc_teardown_recv_gpadl(struct hv_device *device,
>>   
>>   	if (net_device->recv_buf_gpadl_handle) {
>>   		ret = vmbus_teardown_gpadl(device->channel,
>> -					   net_device->recv_buf_gpadl_handle);
>> +					   net_device->recv_buf_gpadl_handle,
>> +					   net_device->recv_buf,
>> +					   net_device->recv_buf_size);
>>   
>>   		/* If we failed here, we might as well return and have a leak
>>   		 * rather than continue and a bugchk
>> @@ -267,7 +269,9 @@ static void netvsc_teardown_send_gpadl(struct hv_device *device,
>>   
>>   	if (net_device->send_buf_gpadl_handle) {
>>   		ret = vmbus_teardown_gpadl(device->channel,
>> -					   net_device->send_buf_gpadl_handle);
>> +					   net_device->send_buf_gpadl_handle,
>> +					   net_device->send_buf,
>> +					   net_device->send_buf_size);
>>   
>>   		/* If we failed here, we might as well return and have a leak
>>   		 * rather than continue and a bugchk
>> @@ -419,6 +423,7 @@ static int netvsc_init_buf(struct hv_device *device,
>>   		ret = -ENOMEM;
>>   		goto cleanup;
>>   	}
>> +	net_device->send_buf_size = buf_size;
>>   
>>   	/* Establish the gpadl handle for this buffer on this
>>   	 * channel.  Note: This call uses the vmbus connection rather
>> diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
>> index 813a7bee5139..c8d4704fc90c 100644
>> --- a/drivers/uio/uio_hv_generic.c
>> +++ b/drivers/uio/uio_hv_generic.c
>> @@ -181,13 +181,15 @@ static void
>>   hv_uio_cleanup(struct hv_device *dev, struct hv_uio_private_data *pdata)
>>   {
>>   	if (pdata->send_gpadl) {
>> -		vmbus_teardown_gpadl(dev->channel, pdata->send_gpadl);
>> +		vmbus_teardown_gpadl(dev->channel, pdata->send_gpadl,
>> +				     pdata->send_buf, SEND_BUFFER_SIZE);
>>   		pdata->send_gpadl = 0;
>>   		vfree(pdata->send_buf);
>>   	}
>>   
>>   	if (pdata->recv_gpadl) {
>> -		vmbus_teardown_gpadl(dev->channel, pdata->recv_gpadl);
>> +		vmbus_teardown_gpadl(dev->channel, pdata->recv_gpadl,
>> +				     pdata->recv_buf, RECV_BUFFER_SIZE);
>>   		pdata->recv_gpadl = 0;
>>   		vfree(pdata->recv_buf);
>>   	}
>> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
>> index 83448e837ded..ad19f4199f90 100644
>> --- a/include/asm-generic/hyperv-tlfs.h
>> +++ b/include/asm-generic/hyperv-tlfs.h
>> @@ -158,6 +158,7 @@ struct ms_hyperv_tsc_page {
>>   #define HVCALL_RETARGET_INTERRUPT		0x007e
>>   #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
>>   #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
>> +#define HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY 0x00db
>>   
>>   #define HV_FLUSH_ALL_PROCESSORS			BIT(0)
>>   #define HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES	BIT(1)
>> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
>> index 016fdca20d6e..41cbaa2db567 100644
>> --- a/include/linux/hyperv.h
>> +++ b/include/linux/hyperv.h
>> @@ -1183,7 +1183,8 @@ extern int vmbus_establish_gpadl(struct vmbus_channel *channel,
>>   				      u32 visibility);
>>   
>>   extern int vmbus_teardown_gpadl(struct vmbus_channel *channel,
>> -				     u32 gpadl_handle);
>> +				u32 gpadl_handle,
>> +				void *kbuffer, u32 size);
>>   
>>   void vmbus_reset_channel_cb(struct vmbus_channel *channel);
> 
