Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7F043782E
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 15:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbhJVNm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 09:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbhJVNmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 09:42:18 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D153C061243;
        Fri, 22 Oct 2021 06:40:01 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so3127502pjb.0;
        Fri, 22 Oct 2021 06:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VyuNv/wxaNQgxYmmFQJvMD+vS7wEW2zYfkmJZgPEJ50=;
        b=enq/FYZGYWHIVmwxT7Me498mHtFTvdIPZ+9pmwRCMBa6Saa2z6OcwEnoEnSHtBwsXk
         21E7CyG/6l98sy1BHuDqNLp4gxnpNZfSLYGRKiReTKI8NGJvlY2pncPx0cNUdrOUIGJV
         woBqWXceSHfNUy84YVLyyO3JMdLk9jpy6x5TOFx1NDfnqx6w1aL1aTmr5F1vV9ErXNcH
         SR3/OUhHCQYYYtSSdz+4oPPt9kbadRO9/C0mybdJVf7A3IODb0/8xPTBr6r9foqmqcr9
         3XdygMxtCiVb5CqAvsJSPS0ka/Atf3FmU+25bjlR9CkXSjURiR7pDY8gihm8TM1ZkBnu
         YIMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VyuNv/wxaNQgxYmmFQJvMD+vS7wEW2zYfkmJZgPEJ50=;
        b=C1+gGTscoq2zAMSAxFyIzwWRN61AHqmDFQ5d0jXMjltoVecMQLSBoFY/NFsSn5hAqN
         rOfF2ecGNNgU37SMazjj9bYpcasnYXjRARCpg0dK7GGViL5rCjACM+xbKk3oXyLT7EmY
         //EMLeXbNdmjAuOPUuEJRKUv9AcVGAiAnsimrnbh6JdrB3b7pdIV+8ezn57JXf7cByOy
         G2tHfL3hX0oOHwqzVRuqNVBb5Ix5Ea9YACJVpHGyZbWXq35X6qKGDMX9iz6K/wwTolrP
         XHIJx2xamEnnfjho+socMIvBpja6KSZU0N9ewQSJrERdaRHwGEf5C7iKXdwT1t7jPUew
         9uFg==
X-Gm-Message-State: AOAM5336ByaIkoUZGpJ4u1jhBsZMtv6bfyrfi6MSfsoA8UILMjUiDXxS
        +w9q85i52rJFgeMeTtZXAKM=
X-Google-Smtp-Source: ABdhPJweU/0TBCUzDM1adxMha2tHP6MJa2AkINYyDrAB6GEDW0zqfONLUg7bmnjPvLQ9GETEZINl9A==
X-Received: by 2002:a17:90b:3505:: with SMTP id ls5mr10214208pjb.31.1634910000702;
        Fri, 22 Oct 2021 06:40:00 -0700 (PDT)
Received: from ?IPV6:2404:f801:0:6:8000::a31c? ([2404:f801:9000:1a:efeb::a31c])
        by smtp.gmail.com with ESMTPSA id x2sm2896261pjd.50.2021.10.22.06.39.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 06:40:00 -0700 (PDT)
Message-ID: <00946764-7fe0-675f-7b3e-9fb3b8e3eb89@gmail.com>
Date:   Fri, 22 Oct 2021 21:39:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH V8 5/9] x86/sev-es: Expose sev_es_ghcb_hv_call() to call
 ghcb hv call out of sev code
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        rientjes@google.com, pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        saravanand@fb.com, aneesh.kumar@linux.ibm.com, hannes@cmpxchg.org,
        tj@kernel.org, michael.h.kelley@microsoft.com,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
References: <20211021154110.3734294-1-ltykernel@gmail.com>
 <20211021154110.3734294-6-ltykernel@gmail.com> <YXGTwppQ8syUyJ72@zn.tnic>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <YXGTwppQ8syUyJ72@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/2021 12:22 AM, Borislav Petkov wrote:
> On Thu, Oct 21, 2021 at 11:41:05AM -0400, Tianyu Lan wrote:
>> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
>> index ea9abd69237e..368ed36971e3 100644
>> --- a/arch/x86/kernel/sev-shared.c
>> +++ b/arch/x86/kernel/sev-shared.c
>> @@ -124,10 +124,9 @@ static enum es_result verify_exception_info(struct ghcb *ghcb, struct es_em_ctxt
>>   	return ES_VMM_ERROR;
>>   }
>>   
>> -static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>> -					  struct es_em_ctxt *ctxt,
>> -					  u64 exit_code, u64 exit_info_1,
>> -					  u64 exit_info_2)
>> +enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb, bool set_ghcb_msr,
>> +				   struct es_em_ctxt *ctxt, u64 exit_code,
>> +				   u64 exit_info_1, u64 exit_info_2)
>>   {
>>   	/* Fill in protocol and format specifiers */
>>   	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
>> @@ -137,7 +136,15 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>>   	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
>>   	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
>>   
>> -	sev_es_wr_ghcb_msr(__pa(ghcb));
>> +	/*
>> +	 * Hyper-V unenlightened guests use a paravisor for communicating and
>> +	 * GHCB pages are being allocated and set up by that paravisor. Linux
>> +	 * should not change ghcb page pa in such case and so add set_ghcb_msr
> 
> "... not change the GHCB page's physical address."
> 
> Remove the "so add... " rest.
> 
> Otherwise, LGTM.
> 
> Do you want me to take it through the tip tree?

Yes, please and this patch is based on the your clean up patch which is 
already in the tip sev branch.
