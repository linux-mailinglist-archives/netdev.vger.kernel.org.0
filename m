Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70ED045474D
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 14:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbhKQNf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 08:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbhKQNfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 08:35:25 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE3CC061570;
        Wed, 17 Nov 2021 05:32:26 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so5241989pjb.5;
        Wed, 17 Nov 2021 05:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zR3oNRYhTYJUZxaoak8qMlUuBunZjm5m9hqskt3h3S4=;
        b=ggvPHm4xgldOYNuvLAK0wCZC8fi4QdT92wt9aO0Z1D+A8KeOi+P1P1JWtXkWduE+Ch
         r6ou4FvXsNhepLE8E70VqGkz+/lDwWv7enCCiPmHwIBtd8kf2It6TjK/tqJvLKuShbGK
         0bql4MAv8/pbMx8YyG0cDh/0zTFZMrBCBap5FVuQdaMLz170KD8tA2xrwcyOnV2CGSaU
         XC9McvnV4rtzWcYyCt8336Tl0rj1KT9TWDrtW7oGGCWhI41aW30RYAShzVcOFPieXpQ2
         2szScJ98dW1z6BZ6y4Px5EjFn8WqTBG7cb5V8p7izkymWXTEpGK00GSfEtG9CuZzRkDF
         KZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zR3oNRYhTYJUZxaoak8qMlUuBunZjm5m9hqskt3h3S4=;
        b=Bo70UPaDpuKqXPdkCLD4hIxGsoZ9ov6Skbxan7ghjroDGPwLtV4RdV40T0ybBfHSSi
         11pTZCDHFNqfghkJ+CNvWZyl55kC2E+cKGGYouVJK0c7/ivT0bd9lHJvQ7huE6dQLuE1
         0hFAJhcQXGAW8jz1/aflFPBnr52pYtFC6Lc3L8uWgpw9S0VySh61qsKBOSWIEmQyUsGU
         zBh0tYvF5zk4tscJHwMiegrx8Xa5VuPzLqNBn3BDbcYFcW711cO1oFshV6cTvI0Tnn/m
         45rE1mw0QwrnQP6oDER8ZI1aURvNdtfOQ7982rJpZFjenzVvHBfs8aykD96xlEEyVBt+
         msOw==
X-Gm-Message-State: AOAM5324Mn9w+WcXllL4TU8hHswJ/3uJ4k7uk3wRiM3lZHA8su92G4Zl
        7pQeJcFnkBbbiOfSZ8yRrmE=
X-Google-Smtp-Source: ABdhPJzUpe9LLZVlH0z5E35okJoiJmMYQnfNMpmq8a9kmB7F5FUzY6wGExQKYAIJCpzqgtl9+SISaw==
X-Received: by 2002:a17:90a:ab17:: with SMTP id m23mr9499872pjq.194.1637155946398;
        Wed, 17 Nov 2021 05:32:26 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id y28sm23237747pfa.208.2021.11.17.05.32.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 05:32:26 -0800 (PST)
Message-ID: <0ab42ae0-9323-9297-c2c8-1cfc1ebada08@gmail.com>
Date:   Wed, 17 Nov 2021 21:32:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 1/5] x86/Swiotlb: Add Swiotlb bounce buffer remap function
 for HV IVM
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, parri.andrea@gmail.com,
        thomas.lendacky@amd.com, dave.hansen@intel.com
References: <20211116153923.196763-1-ltykernel@gmail.com>
 <20211116153923.196763-2-ltykernel@gmail.com> <20211117095953.GA10330@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <20211117095953.GA10330@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph:
       Thanks for your review.

On 11/17/2021 5:59 PM, Christoph Hellwig wrote:
> The subject is wrong, nothing x86-specific here.  Please use
> "swiotlb: " as the prefix

OK. Will update. Thanks.

> 
>> + * @vaddr:	The vaddr of the swiotlb memory pool. The swiotlb
>> + *		memory pool may be remapped in the memory encrypted case and store
> 
> Please avoid the overly long line. >
>> +	/*
>> +	 * With swiotlb_unencrypted_base setting, swiotlb bounce buffer will
>> +	 * be remapped in the swiotlb_update_mem_attributes() and return here
>> +	 * directly.
>> +	 */
> 
> I'd word this as:
> 
> 	/*
> 	 * If swiotlb_unencrypted_base is set, the bounce buffer memory will
> 	 * be remapped and cleared in swiotlb_update_mem_attributes.
> 	 */

Thanks for suggestion. Will update. Thanks.


>> +	ret = swiotlb_init_io_tlb_mem(mem, __pa(tlb), nslabs, false);
>> +	if (ret) {
>> +		memblock_free(mem->slots, alloc_size);
>> +		return ret;
>> +	}
> 
> With the latest update swiotlb_init_io_tlb_mem will always return 0,
> so no need for the return value change or error handling here.
> 

OK. Will revert the change.
