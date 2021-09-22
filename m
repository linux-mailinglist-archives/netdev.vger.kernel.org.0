Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC78414685
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbhIVKgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbhIVKgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 06:36:14 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2757EC061574;
        Wed, 22 Sep 2021 03:34:45 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id f129so2226231pgc.1;
        Wed, 22 Sep 2021 03:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G3lBTKL9FoS2GeTPW9J8hEJVFPyRUNCbdl3irWEPhFg=;
        b=VoKr+BxCSzT9CO4ryTvDD3G9wZrHUE0sTtMLZK2Lm+TkGGecOgC3OOiab9jGCY9Kll
         e3Nkk6KOEavdFjpqSE8OwPf42LqGMmpIaMjrJkf5FQ1bm4DCzaHMVjrS50k81Z5PYZvm
         LaQ3W++2hMpMzkR8a6WUIhPyrHKyj2ps2MmD7UAxL5yD/CVQu0BrCvgI9ZCx/6AZ2ero
         ZA58OyFlrguXiqRw6p72MTnEgdUXrgF+j0mJ9KKnzlhlbmg5lM2sj1CZeNsTS1IjKv3i
         HdblFX8nN+LqjFQBrI25lHxMdYEM3heJ/vSWPC9owVlrfu6UaOxGQhHTnyLKg4SRLwvw
         7IOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G3lBTKL9FoS2GeTPW9J8hEJVFPyRUNCbdl3irWEPhFg=;
        b=6yHojcxowanZBRrI1lC/9eSE6XI/Yow6wXDNUrwsRhwv0793xe32TPiiH2Nx6vVFKI
         osEaWmomzWu9WX3VeBaOq0lWm/5GzTGZjMt3elgjI1uWXralKPh/a0U3wqsbzdIHPJON
         lt4Elk3kB2wAhHNC3TMJhotAQeKmOqRXVibAwI53vw95S7CY+M7N/3XztUKaXC/UKvDs
         zod2bXRFltrj/3IzjLnGWkgjLyeZKQycn4H6nhHqjbIjrXW/x0hC4jXxHpqkssJrjoRr
         /+pQ+ZGYQS0rGlITI6zqhn1vtRhHgsklGvAwhYH4HKT4RO2JDq1zmgv3alpbaPzhTGKE
         0pEA==
X-Gm-Message-State: AOAM533fIlihjISAzrnWfN5Fbug5RxjRkEivSE6a/Wc2RjOKQRdCjz6R
        mcyR9xqa4yYI2azt7p5FHYY=
X-Google-Smtp-Source: ABdhPJw45PYU6V+KljQsJMZub2teNBXuKQfiyKdheHtrHWEuFzCoMIpWH2xXA/VT8gGeHXUNrWQ24A==
X-Received: by 2002:a63:561a:: with SMTP id k26mr32545930pgb.144.1632306884424;
        Wed, 22 Sep 2021 03:34:44 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id e13sm2007664pfi.210.2021.09.22.03.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 03:34:44 -0700 (PDT)
Subject: Re: [PATCH V5 12/12] net: netvsc: Add Isolation VM support for netvsc
 driver
To:     Christoph Hellwig <hch@lst.de>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        Michael Kelley <mikelley@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "rientjes@google.com" <rientjes@google.com>
References: <20210914133916.1440931-1-ltykernel@gmail.com>
 <20210914133916.1440931-13-ltykernel@gmail.com>
 <MWHPR21MB15939A5D74CA1DF25EE816ADD7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <43e22b84-7273-4099-42ea-54b06f398650@gmail.com>
Date:   Wed, 22 Sep 2021 18:34:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <MWHPR21MB15939A5D74CA1DF25EE816ADD7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph:
     This patch follows your purposal in the previous discussion.
Could you have a look?
     "use vmap_pfn as in the current series.  But in that case I think
     we should get rid of the other mapping created by vmalloc.  I
     though a bit about finding a way to apply the offset in vmalloc
     itself, but I think it would be too invasive to the normal fast
     path.  So the other sub-option would be to allocate the pages
     manually (maybe even using high order allocations to reduce TLB
     pressure) and then remap them(https://lkml.org/lkml/2021/9/2/112)

Otherwise, I merge your previous change for swiotlb into patch 9
“x86/Swiotlb: Add Swiotlb bounce buffer remap function for HV IVM”
You previous change 
link.(http://git.infradead.org/users/hch/misc.git/commit/8248f295928aded3364a1e54a4e0022e93d3610c) 
Please have a look.


Thanks.


On 9/16/2021 12:21 AM, Michael Kelley wrote:
> From: Tianyu Lan <ltykernel@gmail.com>  Sent: Tuesday, September 14, 2021 6:39 AM
>>
>> In Isolation VM, all shared memory with host needs to mark visible
>> to host via hvcall. vmbus_establish_gpadl() has already done it for
>> netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
>> pagebuffer() stills need to be handled. Use DMA API to map/umap
>> these memory during sending/receiving packet and Hyper-V swiotlb
>> bounce buffer dma address will be returned. The swiotlb bounce buffer
>> has been masked to be visible to host during boot up.
>>
>> Allocate rx/tx ring buffer via alloc_pages() in Isolation VM and map
>> these pages via vmap(). After calling vmbus_establish_gpadl() which
>> marks these pages visible to host, unmap these pages to release the
>> virtual address mapped with physical address below shared_gpa_boundary
>> and map them in the extra address space via vmap_pfn().
>>
>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>> ---
>> Change since v4:
>> 	* Allocate rx/tx ring buffer via alloc_pages() in Isolation VM
>> 	* Map pages after calling vmbus_establish_gpadl().
>> 	* set dma_set_min_align_mask for netvsc driver.
>>
>> Change since v3:
>> 	* Add comment to explain why not to use dma_map_sg()
>> 	* Fix some error handle.
>> ---
>>   drivers/net/hyperv/hyperv_net.h   |   7 +
>>   drivers/net/hyperv/netvsc.c       | 287 +++++++++++++++++++++++++++++-
>>   drivers/net/hyperv/netvsc_drv.c   |   1 +
>>   drivers/net/hyperv/rndis_filter.c |   2 +
>>   include/linux/hyperv.h            |   5 +
>>   5 files changed, 296 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
>> index 315278a7cf88..87e8c74398a5 100644
>> --- a/drivers/net/hyperv/hyperv_net.h
>> +++ b/drivers/net/hyperv/hyperv_net.h
>> @@ -164,6 +164,7 @@ struct hv_netvsc_packet {
>>   	u32 total_bytes;
>>   	u32 send_buf_index;
>>   	u32 total_data_buflen;
>> +	struct hv_dma_range *dma_range;
>>   };
>>
>>   #define NETVSC_HASH_KEYLEN 40
>> @@ -1074,6 +1075,8 @@ struct netvsc_device {
>>
>>   	/* Receive buffer allocated by us but manages by NetVSP */
>>   	void *recv_buf;
>> +	struct page **recv_pages;
>> +	u32 recv_page_count;
>>   	u32 recv_buf_size; /* allocated bytes */
>>   	struct vmbus_gpadl recv_buf_gpadl_handle;
>>   	u32 recv_section_cnt;
>> @@ -1082,6 +1085,8 @@ struct netvsc_device {
>>
>>   	/* Send buffer allocated by us */
>>   	void *send_buf;
>> +	struct page **send_pages;
>> +	u32 send_page_count;
>>   	u32 send_buf_size;
>>   	struct vmbus_gpadl send_buf_gpadl_handle;
>>   	u32 send_section_cnt;
>> @@ -1731,4 +1736,6 @@ struct rndis_message {
>>   #define RETRY_US_HI	10000
>>   #define RETRY_MAX	2000	/* >10 sec */
>>
>> +void netvsc_dma_unmap(struct hv_device *hv_dev,
>> +		      struct hv_netvsc_packet *packet);
>>   #endif /* _HYPERV_NET_H */
>> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
>> index 1f87e570ed2b..7d5254bf043e 100644
>> --- a/drivers/net/hyperv/netvsc.c
>> +++ b/drivers/net/hyperv/netvsc.c
>> @@ -20,6 +20,7 @@
>>   #include <linux/vmalloc.h>
>>   #include <linux/rtnetlink.h>
>>   #include <linux/prefetch.h>
>> +#include <linux/gfp.h>
>>
>>   #include <asm/sync_bitops.h>
>>   #include <asm/mshyperv.h>
>> @@ -150,11 +151,33 @@ static void free_netvsc_device(struct rcu_head *head)
>>   {
>>   	struct netvsc_device *nvdev
>>   		= container_of(head, struct netvsc_device, rcu);
>> +	unsigned int alloc_unit;
>>   	int i;
>>
>>   	kfree(nvdev->extension);
>> -	vfree(nvdev->recv_buf);
>> -	vfree(nvdev->send_buf);
>> +
>> +	if (nvdev->recv_pages) {
>> +		alloc_unit = (nvdev->recv_buf_size /
>> +			nvdev->recv_page_count) >> PAGE_SHIFT;
>> +
>> +		vunmap(nvdev->recv_buf);
>> +		for (i = 0; i < nvdev->recv_page_count; i++)
>> +			__free_pages(nvdev->recv_pages[i], alloc_unit);
>> +	} else {
>> +		vfree(nvdev->recv_buf);
>> +	}
>> +
>> +	if (nvdev->send_pages) {
>> +		alloc_unit = (nvdev->send_buf_size /
>> +			nvdev->send_page_count) >> PAGE_SHIFT;
>> +
>> +		vunmap(nvdev->send_buf);
>> +		for (i = 0; i < nvdev->send_page_count; i++)
>> +			__free_pages(nvdev->send_pages[i], alloc_unit);
>> +	} else {
>> +		vfree(nvdev->send_buf);
>> +	}
>> +
>>   	kfree(nvdev->send_section_map);
>>
>>   	for (i = 0; i < VRSS_CHANNEL_MAX; i++) {
>> @@ -330,6 +353,108 @@ int netvsc_alloc_recv_comp_ring(struct netvsc_device *net_device, u32 q_idx)
>>   	return nvchan->mrc.slots ? 0 : -ENOMEM;
>>   }
>>
>> +void *netvsc_alloc_pages(struct page ***pages_array, unsigned int *array_len,
>> +			 unsigned long size)
>> +{
>> +	struct page *page, **pages, **vmap_pages;
>> +	unsigned long pg_count = size >> PAGE_SHIFT;
>> +	int alloc_unit = MAX_ORDER_NR_PAGES;
>> +	int i, j, vmap_page_index = 0;
>> +	void *vaddr;
>> +
>> +	if (pg_count < alloc_unit)
>> +		alloc_unit = 1;
>> +
>> +	/* vmap() accepts page array with PAGE_SIZE as unit while try to
>> +	 * allocate high order pages here in order to save page array space.
>> +	 * vmap_pages[] is used as input parameter of vmap(). pages[] is to
>> +	 * store allocated pages and map them later.
>> +	 */
>> +	vmap_pages = kmalloc_array(pg_count, sizeof(*vmap_pages), GFP_KERNEL);
>> +	if (!vmap_pages)
>> +		return NULL;
>> +
>> +retry:
>> +	*array_len = pg_count / alloc_unit;
>> +	pages = kmalloc_array(*array_len, sizeof(*pages), GFP_KERNEL);
>> +	if (!pages)
>> +		goto cleanup;
>> +
>> +	for (i = 0; i < *array_len; i++) {
>> +		page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
>> +				   get_order(alloc_unit << PAGE_SHIFT));
>> +		if (!page) {
>> +			/* Try allocating small pages if high order pages are not available. */
>> +			if (alloc_unit == 1) {
>> +				goto cleanup;
>> +			} else {
> 
> The "else" clause isn't really needed because of the goto cleanup above.  Then
> the indentation of the code below could be reduced by one level.
> 
>> +				memset(vmap_pages, 0,
>> +				       sizeof(*vmap_pages) * vmap_page_index);
>> +				vmap_page_index = 0;
>> +
>> +				for (j = 0; j < i; j++)
>> +					__free_pages(pages[j], alloc_unit);
>> +
>> +				kfree(pages);
>> +				alloc_unit = 1;
> 
> This is the case where a large enough contiguous physical memory chunk could
> not be found.  But rather than dropping all the way down to single pages,
> would it make sense to try something smaller, but not 1?  For example,
> cut the alloc_unit in half and try again.  But I'm not sure of all the implications.
> 
>> +				goto retry;
>> +			}
>> +		}
>> +
>> +		pages[i] = page;
>> +		for (j = 0; j < alloc_unit; j++)
>> +			vmap_pages[vmap_page_index++] = page++;
>> +	}
>> +
>> +	vaddr = vmap(vmap_pages, vmap_page_index, VM_MAP, PAGE_KERNEL);
>> +	kfree(vmap_pages);
>> +
>> +	*pages_array = pages;
>> +	return vaddr;
>> +
>> +cleanup:
>> +	for (j = 0; j < i; j++)
>> +		__free_pages(pages[i], alloc_unit);
>> +
>> +	kfree(pages);
>> +	kfree(vmap_pages);
>> +	return NULL;
>> +}
>> +
>> +static void *netvsc_map_pages(struct page **pages, int count, int alloc_unit)
>> +{
>> +	int pg_count = count * alloc_unit;
>> +	struct page *page;
>> +	unsigned long *pfns;
>> +	int pfn_index = 0;
>> +	void *vaddr;
>> +	int i, j;
>> +
>> +	if (!pages)
>> +		return NULL;
>> +
>> +	pfns = kcalloc(pg_count, sizeof(*pfns), GFP_KERNEL);
>> +	if (!pfns)
>> +		return NULL;
>> +
>> +	for (i = 0; i < count; i++) {
>> +		page = pages[i];
>> +		if (!page) {
>> +			pr_warn("page is not available %d.\n", i);
>> +			return NULL;
>> +		}
>> +
>> +		for (j = 0; j < alloc_unit; j++) {
>> +			pfns[pfn_index++] = page_to_pfn(page++) +
>> +				(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
>> +		}
>> +	}
>> +
>> +	vaddr = vmap_pfn(pfns, pg_count, PAGE_KERNEL_IO);
>> +	kfree(pfns);
>> +	return vaddr;
>> +}
>> +
> 
> I think you are proposing this approach to allocating memory for the send
> and receive buffers so that you can avoid having two virtual mappings for
> the memory, per comments from Christop Hellwig.  But overall, the approach
> seems a bit complex and I wonder if it is worth it.  If allocating large contiguous
> chunks of physical memory is successful, then there is some memory savings
> in that the data structures needed to keep track of the physical pages is
> smaller than the equivalent page tables might be.  But if you have to revert
> to allocating individual pages, then the memory savings is reduced.
> 
> Ultimately, the list of actual PFNs has to be kept somewhere.  Another approach
> would be to do the reverse of what hv_map_memory() from the v4 patch
> series does.  I.e., you could do virt_to_phys() on each virtual address that
> maps above VTOM, and subtract out the shared_gpa_boundary to get the
> list of actual PFNs that need to be freed.   This way you don't have two copies
> of the list of PFNs -- one with and one without the shared_gpa_boundary added.
> But it comes at the cost of additional code so that may not be a great idea.
> 
> I think what you have here works, and I don't have a clearly better solution
> at the moment except perhaps to revert to the v4 solution and just have two
> virtual mappings.  I'll keep thinking about it.  Maybe Christop has other
> thoughts.
> 
>>   static int netvsc_init_buf(struct hv_device *device,
>>   			   struct netvsc_device *net_device,
>>   			   const struct netvsc_device_info *device_info)
>> @@ -337,7 +462,7 @@ static int netvsc_init_buf(struct hv_device *device,
>>   	struct nvsp_1_message_send_receive_buffer_complete *resp;
>>   	struct net_device *ndev = hv_get_drvdata(device);
>>   	struct nvsp_message *init_packet;
>> -	unsigned int buf_size;
>> +	unsigned int buf_size, alloc_unit;
>>   	size_t map_words;
>>   	int i, ret = 0;
>>
>> @@ -350,7 +475,14 @@ static int netvsc_init_buf(struct hv_device *device,
>>   		buf_size = min_t(unsigned int, buf_size,
>>   				 NETVSC_RECEIVE_BUFFER_SIZE_LEGACY);
>>
>> -	net_device->recv_buf = vzalloc(buf_size);
>> +	if (hv_isolation_type_snp())
>> +		net_device->recv_buf =
>> +			netvsc_alloc_pages(&net_device->recv_pages,
>> +					   &net_device->recv_page_count,
>> +					   buf_size);
>> +	else
>> +		net_device->recv_buf = vzalloc(buf_size);
>> +
> 
> I wonder if it is necessary to have two different code paths here.  The
> allocating and freeing of the send and receive buffers is not perf
> sensitive, and it seems like netvsc_alloc_pages() could be used
> regardless of whether SNP Isolation is in effect.  To my thinking,
> one code path is better than two code paths unless there's a
> compelling reason to have two.
> 
>>   	if (!net_device->recv_buf) {
>>   		netdev_err(ndev,
>>   			   "unable to allocate receive buffer of size %u\n",
>> @@ -375,6 +507,27 @@ static int netvsc_init_buf(struct hv_device *device,
>>   		goto cleanup;
>>   	}
>>
>> +	if (hv_isolation_type_snp()) {
>> +		alloc_unit = (buf_size / net_device->recv_page_count)
>> +				>> PAGE_SHIFT;
>> +
>> +		/* Unmap previous virtual address and map pages in the extra
>> +		 * address space(above shared gpa boundary) in Isolation VM.
>> +		 */
>> +		vunmap(net_device->recv_buf);
>> +		net_device->recv_buf =
>> +			netvsc_map_pages(net_device->recv_pages,
>> +					 net_device->recv_page_count,
>> +					 alloc_unit);
>> +		if (!net_device->recv_buf) {
>> +			netdev_err(ndev,
>> +				   "unable to allocate receive buffer of size %u\n",
>> +				   buf_size);
>> +			ret = -ENOMEM;
>> +			goto cleanup;
>> +		}
>> +	}
>> +
>>   	/* Notify the NetVsp of the gpadl handle */
>>   	init_packet = &net_device->channel_init_pkt;
>>   	memset(init_packet, 0, sizeof(struct nvsp_message));
>> @@ -456,13 +609,21 @@ static int netvsc_init_buf(struct hv_device *device,
>>   	buf_size = device_info->send_sections * device_info->send_section_size;
>>   	buf_size = round_up(buf_size, PAGE_SIZE);
>>
>> -	net_device->send_buf = vzalloc(buf_size);
>> +	if (hv_isolation_type_snp())
>> +		net_device->send_buf =
>> +			netvsc_alloc_pages(&net_device->send_pages,
>> +					   &net_device->send_page_count,
>> +					   buf_size);
>> +	else
>> +		net_device->send_buf = vzalloc(buf_size);
>> +
>>   	if (!net_device->send_buf) {
>>   		netdev_err(ndev, "unable to allocate send buffer of size %u\n",
>>   			   buf_size);
>>   		ret = -ENOMEM;
>>   		goto cleanup;
>>   	}
>> +
>>   	net_device->send_buf_size = buf_size;
>>
>>   	/* Establish the gpadl handle for this buffer on this
>> @@ -478,6 +639,27 @@ static int netvsc_init_buf(struct hv_device *device,
>>   		goto cleanup;
>>   	}
>>
>> +	if (hv_isolation_type_snp()) {
>> +		alloc_unit = (buf_size / net_device->send_page_count)
>> +				>> PAGE_SHIFT;
>> +
>> +		/* Unmap previous virtual address and map pages in the extra
>> +		 * address space(above shared gpa boundary) in Isolation VM.
>> +		 */
>> +		vunmap(net_device->send_buf);
>> +		net_device->send_buf =
>> +			netvsc_map_pages(net_device->send_pages,
>> +					 net_device->send_page_count,
>> +					 alloc_unit);
>> +		if (!net_device->send_buf) {
>> +			netdev_err(ndev,
>> +				   "unable to allocate receive buffer of size %u\n",
>> +				   buf_size);
>> +			ret = -ENOMEM;
>> +			goto cleanup;
>> +		}
>> +	}
>> +
>>   	/* Notify the NetVsp of the gpadl handle */
>>   	init_packet = &net_device->channel_init_pkt;
>>   	memset(init_packet, 0, sizeof(struct nvsp_message));
>> @@ -768,7 +950,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
>>
>>   	/* Notify the layer above us */
>>   	if (likely(skb)) {
>> -		const struct hv_netvsc_packet *packet
>> +		struct hv_netvsc_packet *packet
>>   			= (struct hv_netvsc_packet *)skb->cb;
>>   		u32 send_index = packet->send_buf_index;
>>   		struct netvsc_stats *tx_stats;
>> @@ -784,6 +966,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
>>   		tx_stats->bytes += packet->total_bytes;
>>   		u64_stats_update_end(&tx_stats->syncp);
>>
>> +		netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
>>   		napi_consume_skb(skb, budget);
>>   	}
>>
>> @@ -948,6 +1131,87 @@ static void netvsc_copy_to_send_buf(struct netvsc_device *net_device,
>>   		memset(dest, 0, padding);
>>   }
>>
>> +void netvsc_dma_unmap(struct hv_device *hv_dev,
>> +		      struct hv_netvsc_packet *packet)
>> +{
>> +	u32 page_count = packet->cp_partial ?
>> +		packet->page_buf_cnt - packet->rmsg_pgcnt :
>> +		packet->page_buf_cnt;
>> +	int i;
>> +
>> +	if (!hv_is_isolation_supported())
>> +		return;
>> +
>> +	if (!packet->dma_range)
>> +		return;
>> +
>> +	for (i = 0; i < page_count; i++)
>> +		dma_unmap_single(&hv_dev->device, packet->dma_range[i].dma,
>> +				 packet->dma_range[i].mapping_size,
>> +				 DMA_TO_DEVICE);
>> +
>> +	kfree(packet->dma_range);
>> +}
>> +
>> +/* netvsc_dma_map - Map swiotlb bounce buffer with data page of
>> + * packet sent by vmbus_sendpacket_pagebuffer() in the Isolation
>> + * VM.
>> + *
>> + * In isolation VM, netvsc send buffer has been marked visible to
>> + * host and so the data copied to send buffer doesn't need to use
>> + * bounce buffer. The data pages handled by vmbus_sendpacket_pagebuffer()
>> + * may not be copied to send buffer and so these pages need to be
>> + * mapped with swiotlb bounce buffer. netvsc_dma_map() is to do
>> + * that. The pfns in the struct hv_page_buffer need to be converted
>> + * to bounce buffer's pfn. The loop here is necessary because the
>> + * entries in the page buffer array are not necessarily full
>> + * pages of data.  Each entry in the array has a separate offset and
>> + * len that may be non-zero, even for entries in the middle of the
>> + * array.  And the entries are not physically contiguous.  So each
>> + * entry must be individually mapped rather than as a contiguous unit.
>> + * So not use dma_map_sg() here.
>> + */
>> +static int netvsc_dma_map(struct hv_device *hv_dev,
>> +		   struct hv_netvsc_packet *packet,
>> +		   struct hv_page_buffer *pb)
>> +{
>> +	u32 page_count =  packet->cp_partial ?
>> +		packet->page_buf_cnt - packet->rmsg_pgcnt :
>> +		packet->page_buf_cnt;
>> +	dma_addr_t dma;
>> +	int i;
>> +
>> +	if (!hv_is_isolation_supported())
>> +		return 0;
>> +
>> +	packet->dma_range = kcalloc(page_count,
>> +				    sizeof(*packet->dma_range),
>> +				    GFP_KERNEL);
>> +	if (!packet->dma_range)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < page_count; i++) {
>> +		char *src = phys_to_virt((pb[i].pfn << HV_HYP_PAGE_SHIFT)
>> +					 + pb[i].offset);
>> +		u32 len = pb[i].len;
>> +
>> +		dma = dma_map_single(&hv_dev->device, src, len,
>> +				     DMA_TO_DEVICE);
>> +		if (dma_mapping_error(&hv_dev->device, dma)) {
>> +			kfree(packet->dma_range);
>> +			return -ENOMEM;
>> +		}
>> +
>> +		packet->dma_range[i].dma = dma;
>> +		packet->dma_range[i].mapping_size = len;
>> +		pb[i].pfn = dma >> HV_HYP_PAGE_SHIFT;
>> +		pb[i].offset = offset_in_hvpage(dma);
> 
> With the DMA min align mask now being set, the offset within
> the Hyper-V page won't be changed by dma_map_single().  So I
> think the above statement can be removed.
> 
>> +		pb[i].len = len;
> 
> A few lines above, the value of "len" is set from pb[i].len.  Neither
> "len" nor "i" is changed in the loop, so this statement can also be
> removed.
> 
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static inline int netvsc_send_pkt(
>>   	struct hv_device *device,
>>   	struct hv_netvsc_packet *packet,
>> @@ -988,14 +1252,24 @@ static inline int netvsc_send_pkt(
>>
>>   	trace_nvsp_send_pkt(ndev, out_channel, rpkt);
>>
>> +	packet->dma_range = NULL;
>>   	if (packet->page_buf_cnt) {
>>   		if (packet->cp_partial)
>>   			pb += packet->rmsg_pgcnt;
>>
>> +		ret = netvsc_dma_map(ndev_ctx->device_ctx, packet, pb);
>> +		if (ret) {
>> +			ret = -EAGAIN;
>> +			goto exit;
>> +		}
>> +
>>   		ret = vmbus_sendpacket_pagebuffer(out_channel,
>>   						  pb, packet->page_buf_cnt,
>>   						  &nvmsg, sizeof(nvmsg),
>>   						  req_id);
>> +
>> +		if (ret)
>> +			netvsc_dma_unmap(ndev_ctx->device_ctx, packet);
>>   	} else {
>>   		ret = vmbus_sendpacket(out_channel,
>>   				       &nvmsg, sizeof(nvmsg),
>> @@ -1003,6 +1277,7 @@ static inline int netvsc_send_pkt(
>>   				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
>>   	}
>>
>> +exit:
>>   	if (ret == 0) {
>>   		atomic_inc_return(&nvchan->queue_sends);
>>
>> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
>> index 382bebc2420d..c3dc884b31e3 100644
>> --- a/drivers/net/hyperv/netvsc_drv.c
>> +++ b/drivers/net/hyperv/netvsc_drv.c
>> @@ -2577,6 +2577,7 @@ static int netvsc_probe(struct hv_device *dev,
>>   	list_add(&net_device_ctx->list, &netvsc_dev_list);
>>   	rtnl_unlock();
>>
>> +	dma_set_min_align_mask(&dev->device, HV_HYP_PAGE_SIZE - 1);
>>   	netvsc_devinfo_put(device_info);
>>   	return 0;
>>
>> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
>> index f6c9c2a670f9..448fcc325ed7 100644
>> --- a/drivers/net/hyperv/rndis_filter.c
>> +++ b/drivers/net/hyperv/rndis_filter.c
>> @@ -361,6 +361,8 @@ static void rndis_filter_receive_response(struct net_device *ndev,
>>   			}
>>   		}
>>
>> +		netvsc_dma_unmap(((struct net_device_context *)
>> +			netdev_priv(ndev))->device_ctx, &request->pkt);
>>   		complete(&request->wait_event);
>>   	} else {
>>   		netdev_err(ndev,
>> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
>> index c94c534a944e..81e58dd582dc 100644
>> --- a/include/linux/hyperv.h
>> +++ b/include/linux/hyperv.h
>> @@ -1597,6 +1597,11 @@ struct hyperv_service_callback {
>>   	void (*callback)(void *context);
>>   };
>>
>> +struct hv_dma_range {
>> +	dma_addr_t dma;
>> +	u32 mapping_size;
>> +};
>> +
>>   #define MAX_SRV_VER	0x7ffffff
>>   extern bool vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp, u8 *buf, u32 buflen,
>>   				const int *fw_version, int fw_vercnt,
>> --
>> 2.25.1
> 
