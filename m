Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879DA360A37
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 15:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhDONKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 09:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhDONKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 09:10:30 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F10CC061574;
        Thu, 15 Apr 2021 06:10:06 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id nm3-20020a17090b19c3b029014e1bbf6c60so8477926pjb.4;
        Thu, 15 Apr 2021 06:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=poev2NLsdLHtupyejHZKkNm25xi1OhRVKq9U5bDqj4Y=;
        b=KNPOcw6j5OJVFQEITV0zl9nFv5wKiaDDOVhQTVZrioNOvxNbbVVePVc0Sac2AFTGrn
         LlCmeEVxZX+TnHB0bM5v2GNgxRliBXndsENyyTgtkkKKBcDSLLVHjcAeoy4/izS0zN1a
         etTIL7G7cjXthlIai4+MlcuJE55+AsRYbU2INYQgl6CQrMKyUFjcADhDGiNrtlqiOCt6
         wqIhbyYLAjYpIB7wZSTDzWH/LqGKTXUWPUaFeTmioIxNh4vGA/JPtduGa0Fz34q5nXcW
         zfPZgL0526MtUGxhiF/6saD0A/Ce6362fgGEfoId8ApT8eB6FOZH1vjk4OXKV65p4axK
         y3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=poev2NLsdLHtupyejHZKkNm25xi1OhRVKq9U5bDqj4Y=;
        b=eFgErBRvHEVzH99r/HZJn0dNtW/iC3nphfHOZc+ohBJTmxpF48XNje8WF8CwWOg0NF
         BWpJRcbmqANpOOZKDRj9jPm03xZbEf1++U/vL8ug3Uk2coOviFeBj6KpG/N70+TzzknG
         uhNFfQGEXxo6uylpzl7Z3CLDigPYEx9ovHAVNTmv+MaBPt5pORG/Pg7X+2p8+6+plhwQ
         4Z+Y2wvU154p6kaIUiu87FH3oGZ1yEi29/Mr2aKKfE38O8hJ/m/Ps+JWfuuwoUJhX5XO
         meqLDcEeHGhxXotm1vZJowpBx0IMr6MkopBchgMc99fQkjBQDz11WPSG9ygfNOCEhtZt
         pzvA==
X-Gm-Message-State: AOAM532Ir60sYddDBscqEx9+U5LijxExVqhhI5sN5aHBNxlx9/a329lz
        FqV5qRXbk8i+9cuT6QDYU/NoJhbKG7o+eQiq
X-Google-Smtp-Source: ABdhPJwLo3XW1PFky/UiL6FgUhppPKomCXhZ8RcTFkrZOoCyJE0LFKn72YJmHoMyXVfQisS1eSMY5A==
X-Received: by 2002:a17:90a:94ca:: with SMTP id j10mr3897484pjw.126.1618492205922;
        Thu, 15 Apr 2021 06:10:05 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:6:8000::a31c? ([2404:f801:9000:1a:efeb::a31c])
        by smtp.gmail.com with ESMTPSA id s21sm2499994pjr.52.2021.04.15.06.09.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 06:10:05 -0700 (PDT)
Subject: Re: [Resend RFC PATCH V2 08/12] UIO/Hyper-V: Not load UIO HV driver
 in the isolation VM.
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, konrad.wilk@oracle.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
References: <20210414144945.3460554-1-ltykernel@gmail.com>
 <20210414144945.3460554-9-ltykernel@gmail.com> <YHcOL+HlEoh5jPb8@kroah.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <eec53f89-4a18-39ce-aff8-c07be2ce3971@gmail.com>
Date:   Thu, 15 Apr 2021 21:09:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YHcOL+HlEoh5jPb8@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/14/2021 11:45 PM, Greg KH wrote:
> On Wed, Apr 14, 2021 at 10:49:41AM -0400, Tianyu Lan wrote:
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>
>> UIO HV driver should not load in the isolation VM for security reason.
>> Return ENOTSUPP in the hv_uio_probe() in the isolation VM.
>>
>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>> ---
>>   drivers/uio/uio_hv_generic.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
>> index 0330ba99730e..678b021d66f8 100644
>> --- a/drivers/uio/uio_hv_generic.c
>> +++ b/drivers/uio/uio_hv_generic.c
>> @@ -29,6 +29,7 @@
>>   #include <linux/hyperv.h>
>>   #include <linux/vmalloc.h>
>>   #include <linux/slab.h>
>> +#include <asm/mshyperv.h>
>>   
>>   #include "../hv/hyperv_vmbus.h"
>>   
>> @@ -241,6 +242,10 @@ hv_uio_probe(struct hv_device *dev,
>>   	void *ring_buffer;
>>   	int ret;
>>   
>> +	/* UIO driver should not be loaded in the isolation VM.*/
>> +	if (hv_is_isolation_supported())
>> +		return -ENOTSUPP;
>> +		
>>   	/* Communicating with host has to be via shared memory not hypercall */
>>   	if (!channel->offermsg.monitor_allocated) {
>>   		dev_err(&dev->device, "vmbus channel requires hypercall\n");
>> -- 
>> 2.25.1
>>
> 
> Again you send out known-wrong patches?
> 
> :(
> 
Sorry for noise. Will fix this next version and I think we should make 
sure user space driver to check data from host. This patch will be removed.
