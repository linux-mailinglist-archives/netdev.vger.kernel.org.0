Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E9D3603FF
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 10:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhDOIOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 04:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhDOIOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 04:14:17 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6A2C061574;
        Thu, 15 Apr 2021 01:13:53 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id j32so1606213pgm.6;
        Thu, 15 Apr 2021 01:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fHEMmI0zE+vS0F59KD+p8uLBPHfbYBHWkM9/N8ompfg=;
        b=soGoMktoPpdmcNOzFk1ITFDuDtu3Bms6GteRh5tLiO6qb0bvu2ZpKl/SQUxnJZVhIy
         TZByoPlO2do1WWZ1mSqK2SULn034q1AHzgoZKCn8bh+JZVf3F6F6PB7g20X/Nh1WpAHF
         rCBCP3iFqt4C1IuZLp4HVH8Pfaz9ffUilpbXSsLHdoKjMpv5l2AhgJxNUtRKf5pKGRRa
         95wZ67Np7MfVTeLuR4irmligwiqSTYlfHtXkkfjZSOcWleOgpSFBA/fc79RIp3kM1TcP
         PP7bCdAai6YFnjMRcKLl7cDXD/3rCBRVrWlkJt0NHB4UQEIOQQycVlS65Yq0aMOH/E/g
         9lkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fHEMmI0zE+vS0F59KD+p8uLBPHfbYBHWkM9/N8ompfg=;
        b=FWYIi25XYF9pNQbvE6JYqPCvYcyBW2WIhoaTkBnqFeC4gfItFpUxkul6hl6x+pWNiM
         W2F56q/B6HQRC2LBkxZfH72C9nYIBZdPDTqaC0mGJxtX97YpkX8HRpduRMLNPx1VNZ7J
         EACRXcu11BwbBN/jVB6tYZFbX1adAWZP2kJ35gmVCsdvHQgwL0t0GXt0s1Yr1UCYQAer
         EcqiUn8BL4+Gdinv0cCJuBz1vKo4JX6w/LKxvxaRu8jwlGUmoTLxEcmW+ZYDBizUk1ZL
         ohLE9w3PIVUlFE9/oAufAQCAJMlUDrEUQ3Bl/zjTScSVEEM5cOZbOZLl3m5/g8T27pzg
         6VVQ==
X-Gm-Message-State: AOAM531CtilSRly6B7g0TnnMEnRP3aPBENu+KdEmZ1G9+A7D4Orng00C
        njv725aSciXupjh0o6tsDXw=
X-Google-Smtp-Source: ABdhPJxO29fqU99JC5dI1dJM618j9ehjc6CzkxxJfsgiXjKmSO/GcguSS35F2oL6Ti4QORoZgkAHpg==
X-Received: by 2002:a63:36ce:: with SMTP id d197mr2329852pga.237.1618474433176;
        Thu, 15 Apr 2021 01:13:53 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:6:8000::a31c? ([2404:f801:9000:1a:efeb::a31c])
        by smtp.gmail.com with ESMTPSA id u21sm771781pfm.89.2021.04.15.01.13.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 01:13:52 -0700 (PDT)
Subject: Re: [Resend RFC PATCH V2 03/12] x86/Hyper-V: Add new hvcall guest
 address host visibility support
To:     Christoph Hellwig <hch@lst.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
References: <20210414144945.3460554-1-ltykernel@gmail.com>
 <20210414144945.3460554-4-ltykernel@gmail.com>
 <20210414154028.GA32045@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <d79e4a79-2259-6a5a-ca7d-3580f6d9dc8f@gmail.com>
Date:   Thu, 15 Apr 2021 16:13:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210414154028.GA32045@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph:
	Thanks for your review.

On 4/14/2021 11:40 PM, Christoph Hellwig wrote:
>> +/*
>> + * hv_set_mem_host_visibility - Set host visibility for specified memory.
>> + */
> 
> I don't think this comment really clarifies anything over the function
> name.  What is 'host visibility'

OK. Will update the comment.

> 
>> +int hv_set_mem_host_visibility(void *kbuffer, u32 size, u32 visibility)
> 
> Should size be a size_t?
> Should visibility be an enum of some kind?
> 

Will update.

>> +int hv_mark_gpa_visibility(u16 count, const u64 pfn[], u32 visibility)
> 
> Not sure what this does either.

Will add a comment.

> 
>> +	local_irq_save(flags);
>> +	input_pcpu = (struct hv_input_modify_sparse_gpa_page_host_visibility **)
> 
> Is there a chance we could find a shorter but still descriptive
> name for this variable?  Why do we need the cast?

Sure. The cast is to avoid build error due to "incompatible-pointer-types"
> 
>> +#define VMBUS_PAGE_VISIBLE_READ_ONLY HV_MAP_GPA_READABLE
>> +#define VMBUS_PAGE_VISIBLE_READ_WRITE (HV_MAP_GPA_READABLE|HV_MAP_GPA_WRITABLE)
> 
> pointlessly overlong line.
> 
