Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033A13E59E2
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240544AbhHJMZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240271AbhHJMZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 08:25:58 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA82C0613D3;
        Tue, 10 Aug 2021 05:25:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id lw7-20020a17090b1807b029017881cc80b7so4045256pjb.3;
        Tue, 10 Aug 2021 05:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KL/EO4tx0TgX51zBlp9/CRNMvpFlpR97J3ss4EOthZ4=;
        b=Ku17ZPCf0pl6UbjbC+OHRNn+ACNBAQsVDchdBbllR6na7JEZVKeCa/0V92DnHTF4iu
         ltIgOtvQG3ChEWFKQGS+ZCmo2X5SwNpdvKDzPZ6w0gyO5dvGz4wCAvWk5byjwwrwUcRC
         5GXqtBHSfAX3q8Kpy97hYWlFUn1WyjEzTjjzbz4eIMRpPJ/3pBUQT0IeP+6w+Os/n12x
         G3057aJUPMJ9DEYkyOBYuaABfzqFcCP+cS+hRvjLg1IN1XmahkLLELPX+1i2xq4zJ7oh
         O3GJi71MYUghn8gllMllI0c3neKMWm0JGzHgfC7goYCwLqZcdx+lapv2oLk7A8os2kge
         ueiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KL/EO4tx0TgX51zBlp9/CRNMvpFlpR97J3ss4EOthZ4=;
        b=E0JZUG4q36mSikq5Ex9Cbju8Wb0OSef/1tbuDcBfHD4016KgnE1Elpgbx2k2kuAJok
         nZ45W5Dn4EfSwngwo/aEx8WXEgJ0LSvf1wYuoNlzlc2dCrSTJ5jx8vt02t6GWFfg6LyT
         +T4ww2nSo23VXQ05QrG5F2P0+LQ3xF2jMh8sjpaEDixld5RKYfCI1Zn6/spMvSkDujsr
         ysr8RkpZ3iXAD25zEXvXZgPNzEYHVa1EFpUWZhSomQcgURvnXteqs3nxFxqwWP/aIi+y
         Da2dyHx76YGd0Z93SW1q9LXduuL9he6Hxs5q213ZCccrSNJblWbTl8eM0ozBTOFuRMpU
         Ztww==
X-Gm-Message-State: AOAM5317Ehxq4bjpl4shswiO7XMrA51+ebpja3YVwFQRd+26RO0aPYW/
        pnW+2OQvrIPGNIpS2keZqxw=
X-Google-Smtp-Source: ABdhPJxebFlgnG0NPPgyE6OjM0zu1XGnchtqFN1rLMZ/uNLQlKSp1bY7DCu3pvqaqyd/DJ1LphsUcQ==
X-Received: by 2002:a63:e116:: with SMTP id z22mr254278pgh.361.1628598336671;
        Tue, 10 Aug 2021 05:25:36 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id c14sm27323452pgv.86.2021.08.10.05.25.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 05:25:35 -0700 (PDT)
Subject: Re: [PATCH V3 03/13] x86/HV: Add new hvcall guest address host
 visibility support
To:     Wei Liu <wei.liu@kernel.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
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
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-4-ltykernel@gmail.com>
 <20210810110359.i4qodw7h36zrsicp@liuwe-devbox-debian-v2>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <3a888810-69cf-fa4d-b374-2053432e1e56@gmail.com>
Date:   Tue, 10 Aug 2021 20:25:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810110359.i4qodw7h36zrsicp@liuwe-devbox-debian-v2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/2021 7:03 PM, Wei Liu wrote:
>> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
>> index 0bb4d9ca7a55..b3683083208a 100644
>> --- a/arch/x86/hyperv/hv_init.c
>> +++ b/arch/x86/hyperv/hv_init.c
>> @@ -607,6 +607,12 @@ EXPORT_SYMBOL_GPL(hv_get_isolation_type);
>>   
>>   bool hv_is_isolation_supported(void)
>>   {
>> +	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
>> +		return 0;
> Nit: false instead of 0.
> 

OK. Will fix in the next version.

>> +int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
>> +			   enum hv_mem_host_visibility visibility)
>> +{
>> +	struct hv_gpa_range_for_visibility **input_pcpu, *input;
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
>> +	input_pcpu = (struct hv_gpa_range_for_visibility **)
>> +			this_cpu_ptr(hyperv_pcpu_input_arg);
>> +	input = *input_pcpu;
>> +	if (unlikely(!input)) {
>> +		local_irq_restore(flags);
>> +		return -EINVAL;
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
>> +	return hv_status & HV_HYPERCALL_RESULT_MASK;
> Joseph introduced a few helper functions in 753ed9c95c37d. They will
> make the code simpler.

OK. Will update in the next version.

Thanks.
