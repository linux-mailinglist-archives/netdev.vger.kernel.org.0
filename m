Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0EB3DD5BA
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 14:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhHBMfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 08:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbhHBMfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 08:35:38 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA10C06175F;
        Mon,  2 Aug 2021 05:35:28 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mt6so25034541pjb.1;
        Mon, 02 Aug 2021 05:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P17ATPCGukDO//xkLZQBZuaX2KkafCVoCkJP2PCc12U=;
        b=uSz1V29fGX6wnfKClfnD5P1rh/6G4ybzLhb6KPWPPb6eZ2HEzfmHStIAm2N43ack5x
         ETcWD1FyNZMQBoyjY4aCEFCx2Wfye33oL5jKcyzFy4TChrGqa8j99tNqb7Peud6qur0g
         HSxbyh/S9VvDFpJm7czUM9e5UouUkzwjmLx3vV4iYXQnMQPDEp/wTYllcK7ITNHn68Dp
         MOnWhBnFiANNaMTFuwQk3MvS8R2grVLz4JqJf+n7xVj3C562MTurnsVUTflJysxfQYhE
         z53shCXQsRsAmcyYsm/NSjWT+vMCIAA2FisxRh/yWsZWWPV20EW7K2BRieMbbucA+e61
         TZ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P17ATPCGukDO//xkLZQBZuaX2KkafCVoCkJP2PCc12U=;
        b=X+OFDc/y+s1JIlq22pMnEiNDBHlSmiWXbnixxHzFnzgDcq3s9yF9lVRrMk+kULbAwJ
         lxdDCGy2vMj8HXUM52Y0vG++9f26YCh4CAlsrSYMScTOdB8cZEpUYFUU3SAUUzjKVryo
         r/gOg5QXPRXrE2BOVgAaexvNUaoREHwQphyLq4PDtUkmO9m5qMpvdo/ws6LtGWdoHvVc
         315LqtaMYhkGNFeS2hMfVlPwKt9CdGcqLr0rRqZtL50ADEpbHJj3DA/YrQ4ZtDbglDaM
         RKYMqi+NI2us5W6dR9A6TDa9NDKITAIIuHLvvxzWojNdiR3vvTCx2dDgcKCmU7KjEGam
         ZZVQ==
X-Gm-Message-State: AOAM531ezAbbWi2MqJ1lW4jKCOEo/EhOhrcBjoGFspELXtYMnUUf7pUu
        6GKpK4i13K7LGNW4F8/EWPE=
X-Google-Smtp-Source: ABdhPJzYaozKahVEd/Y/yLXvnuEsqWmP1RjZTZHrtR9OGLLZiEzcQgoWz5sbNZrtoNXJm1QhUBxNOw==
X-Received: by 2002:a17:90b:4a90:: with SMTP id lp16mr16910701pjb.74.1627907727675;
        Mon, 02 Aug 2021 05:35:27 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id g11sm10696958pju.13.2021.08.02.05.35.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 05:35:27 -0700 (PDT)
Subject: Re: [PATCH 01/13] x86/HV: Initialize GHCB page in Isolation VM
To:     Joerg Roedel <joro@8bytes.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, rientjes@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        rppt@kernel.org, kirill.shutemov@linux.intel.com,
        aneesh.kumar@linux.ibm.com, krish.sadhukhan@oracle.com,
        saravanand@fb.com, xen-devel@lists.xenproject.org,
        pgonda@google.com, david@redhat.com, keescook@chromium.org,
        hannes@cmpxchg.org, sfr@canb.auug.org.au,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, anparri@microsoft.com
References: <20210728145232.285861-1-ltykernel@gmail.com>
 <20210728145232.285861-2-ltykernel@gmail.com> <YQfctjRm16IP0qZy@8bytes.org>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <e8918379-5c59-c718-3cec-27da931660e9@gmail.com>
Date:   Mon, 2 Aug 2021 20:35:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQfctjRm16IP0qZy@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joerg:
      Thanks for your review.


On 8/2/2021 7:53 PM, Joerg Roedel wrote:
> On Wed, Jul 28, 2021 at 10:52:16AM -0400, Tianyu Lan wrote:
>> +static int hyperv_init_ghcb(void)
>> +{
>> +	u64 ghcb_gpa;
>> +	void *ghcb_va;
>> +	void **ghcb_base;
>> +
>> +	if (!ms_hyperv.ghcb_base)
>> +		return -EINVAL;
>> +
>> +	rdmsrl(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
>> +	ghcb_va = memremap(ghcb_gpa, HV_HYP_PAGE_SIZE, MEMREMAP_WB);
> 
> This deserves a comment. As I understand it, the GHCB pa is set by
> Hyper-V or the paravisor, so the page does not need to be allocated by
> Linux.
> And it is not mapped unencrypted because the GHCB page is allocated
> above the VTOM boundary?

You are right. The ghdb page is allocated by paravisor and its physical 
address is above VTOM boundary. Will add a comment to describe this.
Thanks for suggestion.

> 
>> @@ -167,6 +190,31 @@ static int hv_cpu_die(unsigned int cpu)
>>   {
>>   	struct hv_reenlightenment_control re_ctrl;
>>   	unsigned int new_cpu;
>> +	unsigned long flags;
>> +	void **input_arg;
>> +	void *pg;
>> +	void **ghcb_va = NULL;
>> +
>> +	local_irq_save(flags);
>> +	input_arg = (void **)this_cpu_ptr(hyperv_pcpu_input_arg);
>> +	pg = *input_arg;
> 
> Pg is never used later on, why is it set?

Sorry for noise. This should be removed during rebase and will fix in 
the next version.
