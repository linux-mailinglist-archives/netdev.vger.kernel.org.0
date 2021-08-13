Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2513F3EB967
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 17:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbhHMPrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 11:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236818AbhHMPrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 11:47:03 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6A9C061756;
        Fri, 13 Aug 2021 08:46:37 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id l11so12496463plk.6;
        Fri, 13 Aug 2021 08:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wKFFzJ6O/UU/EGmVRS4t6oCyritoPh4g9td5WczAyTo=;
        b=gpOB0Y8XQiqz1aLvaU6jIg9RPMX5OaDCdWoo9W0/Q2q+kzIydjrOBlFyjP7UzB3kKu
         pKC5fQKwcstAd0YQI+OOMc+Hph81qJBcgd6a6j/eZV4DZzaRXi8P0eE9TkqFFEfuP6Fs
         nqc3F+blWCYXnhrDhS5Xax0X9UD9UA1rqQ97e73U530OMewKqtQ32RmFCPlsK9QLyJDd
         JzDYB4UO2udw85z6h2dZ4RGC4/E80VSb0OqYVuR0Ko6CkL954JcBoU8gKe0yErZye0/l
         hpIPQs5WrePOhscpt5NogL/l9EEbPoUJkMopea8nPd8pJVwp5GuAwu7eXpiJmMd23C80
         v3rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wKFFzJ6O/UU/EGmVRS4t6oCyritoPh4g9td5WczAyTo=;
        b=fZWoB17GaTa4GCnBfHifAwb+TTx6ktWabYM6mAyZnCEI63dBVeRCup5DuEoyERKd6+
         L/jgF71woHzWFrxFFV2lzUAmnpE2Q2OsH5IzbX7xQBZHeLCCBjZtnHMPJOhB3OXAcA2g
         hsuCsebXjfG024uoxWo61Oul/9lh8+bf7fsco38Tb/ZhUTk7FxxHNJemumE9R76YPiYp
         75sy8gaoDX8V0fo075g/0XTgbP/ofeS3Ye+ZfkEuUaBaezc0AUaqhDUSgfrFhLtWOv8S
         jQRb9CXB/AVEBkBiwIIuGqgmbGBCRty76+8IoloTTv46tONTxByc2J0stesk7HRHkGqJ
         wjag==
X-Gm-Message-State: AOAM532nE3efJ2fiypn7We4Hg7Lu5vEzzfwPCnmufeUJe0G1+5SP1aM6
        7uA/CG0nUw3jAL3nFbh0hwc=
X-Google-Smtp-Source: ABdhPJzk13A/+fCbnakCVSOwZJNHKGdKPt2T4sFIbI1aKCvZDK2x7JFoHkEcCMPEgs+3McCqxtRHYw==
X-Received: by 2002:a65:6894:: with SMTP id e20mr2777702pgt.419.1628869596537;
        Fri, 13 Aug 2021 08:46:36 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id g26sm3345160pgb.45.2021.08.13.08.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 08:46:36 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
Subject: Re: [PATCH V3 01/13] x86/HV: Initialize GHCB page in Isolation VM
To:     Michael Kelley <mikelley@microsoft.com>,
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
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "tj@kernel.org" <tj@kernel.org>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-2-ltykernel@gmail.com>
 <MWHPR21MB1593BDFA4A71CE6882E25400D7F99@MWHPR21MB1593.namprd21.prod.outlook.com>
Message-ID: <ec1b8b47-46b7-910e-df87-584bce585999@gmail.com>
Date:   Fri, 13 Aug 2021 23:46:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <MWHPR21MB1593BDFA4A71CE6882E25400D7F99@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael:
      Thanks for your review.

On 8/13/2021 3:14 AM, Michael Kelley wrote:
> From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, August 9, 2021 10:56 AM
>> Subject: [PATCH V3 01/13] x86/HV: Initialize GHCB page in Isolation VM
> 
> The subject line tag on patches under arch/x86/hyperv is generally "x86/hyperv:".
> There's some variation in the spelling of "hyperv", but let's go with the all
> lowercase "hyperv".

OK. Will update.

> 
>>
>> Hyper-V exposes GHCB page via SEV ES GHCB MSR for SNP guest
>> to communicate with hypervisor. Map GHCB page for all
>> cpus to read/write MSR register and submit hvcall request
>> via GHCB.
>>
>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>> ---
>>   arch/x86/hyperv/hv_init.c       | 66 +++++++++++++++++++++++++++++++--
>>   arch/x86/include/asm/mshyperv.h |  2 +
>>   include/asm-generic/mshyperv.h  |  2 +
>>   3 files changed, 66 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
>> index 708a2712a516..0bb4d9ca7a55 100644
>> --- a/arch/x86/hyperv/hv_init.c
>> +++ b/arch/x86/hyperv/hv_init.c
>> @@ -20,6 +20,7 @@
>>   #include <linux/kexec.h>
>>   #include <linux/version.h>
>>   #include <linux/vmalloc.h>
>> +#include <linux/io.h>
>>   #include <linux/mm.h>
>>   #include <linux/hyperv.h>
>>   #include <linux/slab.h>
>> @@ -42,6 +43,31 @@ static void *hv_hypercall_pg_saved;
>>   struct hv_vp_assist_page **hv_vp_assist_page;
>>   EXPORT_SYMBOL_GPL(hv_vp_assist_page);
>>
>> +static int hyperv_init_ghcb(void)
>> +{
>> +	u64 ghcb_gpa;
>> +	void *ghcb_va;
>> +	void **ghcb_base;
>> +
>> +	if (!ms_hyperv.ghcb_base)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * GHCB page is allocated by paravisor. The address
>> +	 * returned by MSR_AMD64_SEV_ES_GHCB is above shared
>> +	 * ghcb boundary and map it here.
>> +	 */
>> +	rdmsrl(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
>> +	ghcb_va = memremap(ghcb_gpa, HV_HYP_PAGE_SIZE, MEMREMAP_WB);
>> +	if (!ghcb_va)
>> +		return -ENOMEM;
>> +
>> +	ghcb_base = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
>> +	*ghcb_base = ghcb_va;
>> +
>> +	return 0;
>> +}
>> +
>>   static int hv_cpu_init(unsigned int cpu)
>>   {
>>   	union hv_vp_assist_msr_contents msr = { 0 };
>> @@ -85,6 +111,8 @@ static int hv_cpu_init(unsigned int cpu)
>>   		}
>>   	}
>>
>> +	hyperv_init_ghcb();
>> +
>>   	return 0;
>>   }
>>
>> @@ -177,6 +205,14 @@ static int hv_cpu_die(unsigned int cpu)
>>   {
>>   	struct hv_reenlightenment_control re_ctrl;
>>   	unsigned int new_cpu;
>> +	void **ghcb_va = NULL;
> 
> I'm not seeing any reason why this needs to be initialized.
> 
>> +
>> +	if (ms_hyperv.ghcb_base) {
>> +		ghcb_va = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
>> +		if (*ghcb_va)
>> +			memunmap(*ghcb_va);
>> +		*ghcb_va = NULL;
>> +	}
>>
>>   	hv_common_cpu_die(cpu);
>>
>> @@ -383,9 +419,19 @@ void __init hyperv_init(void)
>>   			VMALLOC_END, GFP_KERNEL, PAGE_KERNEL_ROX,
>>   			VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
>>   			__builtin_return_address(0));
>> -	if (hv_hypercall_pg == NULL) {
>> -		wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
>> -		goto remove_cpuhp_state;
>> +	if (hv_hypercall_pg == NULL)
>> +		goto clean_guest_os_id;
>> +
>> +	if (hv_isolation_type_snp()) {
>> +		ms_hyperv.ghcb_base = alloc_percpu(void *);
>> +		if (!ms_hyperv.ghcb_base)
>> +			goto clean_guest_os_id;
>> +
>> +		if (hyperv_init_ghcb()) {
>> +			free_percpu(ms_hyperv.ghcb_base);
>> +			ms_hyperv.ghcb_base = NULL;
>> +			goto clean_guest_os_id;
>> +		}
> 
> Having the GHCB setup code here splits the hypercall page setup into
> two parts, which is unexpected.  First the memory is allocated
> for the hypercall page, then the GHCB stuff is done, then the hypercall
> MSR is setup.  Is there a need to do this split?  Also, if the GHCB stuff
> fails and you goto clean_guest_os_id, the memory allocated for the
> hypercall page is never freed.


Just not enable hypercall when fails to setup ghcb. Otherwise, we need 
to disable hypercall in the failure code path.

Yes，hypercall page should be freed in the clean_guest_os_id path.

> 
> It's also unexpected to have hyperv_init_ghcb() called here and called
> in hv_cpu_init().  Wouldn't it be possible to setup ghcb_base *before*
> cpu_setup_state() is called, so that hv_cpu_init() would take care of
> calling hyperv_init_ghcb() for the boot CPU?  That's the pattern used
> by the VP assist page, the percpu input page, etc.

I will have a try and report back. Thanks for suggestion.

> 
>>   	}
>>
>>   	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
>> @@ -456,7 +502,8 @@ void __init hyperv_init(void)
>>   	hv_query_ext_cap(0);
>>   	return;
>>
>> -remove_cpuhp_state:
>> +clean_guest_os_id:
>> +	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
>>   	cpuhp_remove_state(cpuhp);
>>   free_vp_assist_page:
>>   	kfree(hv_vp_assist_page);
>> @@ -484,6 +531,9 @@ void hyperv_cleanup(void)
>>   	 */
>>   	hv_hypercall_pg = NULL;
>>
>> +	if (ms_hyperv.ghcb_base)
>> +		free_percpu(ms_hyperv.ghcb_base);
>> +
> 
> I don't think this cleanup is necessary.  The primary purpose of
> hyperv_cleanup() is to ensure that things like overlay pages are
> properly reset in Hyper-V before doing a kexec(), or before
> panic'ing and running the kdump kernel.  There's no need to do
> general memory free'ing in Linux.  Doing so just adds to the risk
> that the panic path could itself fail.

Nice catch. I will remove this.

> 
>>   	/* Reset the hypercall page */
>>   	hypercall_msr.as_uint64 = 0;
>>   	wrmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
>> @@ -559,3 +609,11 @@ bool hv_is_isolation_supported(void)
>>   {
>>   	return hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE;
>>   }
>> +
>> +DEFINE_STATIC_KEY_FALSE(isolation_type_snp);
>> +
>> +bool hv_isolation_type_snp(void)
>> +{
>> +	return static_branch_unlikely(&isolation_type_snp);
>> +}
>> +EXPORT_SYMBOL_GPL(hv_isolation_type_snp);
>> diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
>> index adccbc209169..6627cfd2bfba 100644
>> --- a/arch/x86/include/asm/mshyperv.h
>> +++ b/arch/x86/include/asm/mshyperv.h
>> @@ -11,6 +11,8 @@
>>   #include <asm/paravirt.h>
>>   #include <asm/mshyperv.h>
>>
>> +DECLARE_STATIC_KEY_FALSE(isolation_type_snp);
>> +
>>   typedef int (*hyperv_fill_flush_list_func)(
>>   		struct hv_guest_mapping_flush_list *flush,
>>   		void *data);
>> diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
>> index c1ab6a6e72b5..4269f3174e58 100644
>> --- a/include/asm-generic/mshyperv.h
>> +++ b/include/asm-generic/mshyperv.h
>> @@ -36,6 +36,7 @@ struct ms_hyperv_info {
>>   	u32 max_lp_index;
>>   	u32 isolation_config_a;
>>   	u32 isolation_config_b;
>> +	void  __percpu **ghcb_base;
> 
> This doesn't feel like the right place to put this pointer.  The other
> fields in the ms_hyperv_info structure are just fixed values obtained
> from the CPUID instruction.   The existing patterns similar to ghcb_base
> are the VP assist page and the percpu input and output args.  They are
> all based on standalone global variables.  It would be more consistent
> to do the same with the ghcb_base.

OK. I will update in the next version.

> 
>>   };
>>   extern struct ms_hyperv_info ms_hyperv;
>>
>> @@ -237,6 +238,7 @@ bool hv_is_hyperv_initialized(void);
>>   bool hv_is_hibernation_supported(void);
>>   enum hv_isolation_type hv_get_isolation_type(void);
>>   bool hv_is_isolation_supported(void);
>> +bool hv_isolation_type_snp(void);
>>   void hyperv_cleanup(void);
>>   bool hv_query_ext_cap(u64 cap_query);
>>   #else /* CONFIG_HYPERV */
>> --
>> 2.25.1
> 
