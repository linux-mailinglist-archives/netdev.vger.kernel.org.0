Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36763F9E34
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238454AbhH0RpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbhH0RpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:45:10 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D9DC061757;
        Fri, 27 Aug 2021 10:44:20 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso9364133pjh.5;
        Fri, 27 Aug 2021 10:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LPKfuH70y/vowO9PogQlJQs9AemsPOeU5ZCyLaISG1Y=;
        b=HwSSFNicSK0d8SJfbUpGx09hgwlFzVWra5FZoqLpsFB/x+51WvKuctBr6nLXMbO6cf
         M1YA50WBdM0sWHzlp8j5U7XFU84mU13uWGJrK8+pOLzbMDCsX1Sb/xNi2BmSDxbbcXza
         R18ghXowDtCyeUc0qDEp5lcHL3m3iI8G2JsyOod/a4nBKBGxuBgrXX8PcOrPD7xp9VuO
         /+6ym70TQrPMXo7VYAa03ZCcmf5mxE8qkNCNyybf9pWzAIB3F4pHZ8tqL8sUNkUxGXH3
         q5CzVfUu6vNAAN98cQcEw1tC7x5O4qdEugSSAeEekjMP6TLGMepEq4/gpZFscPhnAz0o
         9ETQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LPKfuH70y/vowO9PogQlJQs9AemsPOeU5ZCyLaISG1Y=;
        b=pMm5EIsBr5YlgIEWKS7Q9r/u0hvDwaJmUZYHLZhHb7Fdp60WVpD17jISe4jGXwTlCM
         4duWZqjYnJoXDg8rXAluBeebHHZK2rB7yhWs/65wDsKLWp3Z1lkwmKGlHaaRo7iw6Wpn
         GkWZ3TRS9kaF91RZ7svMRC5iiEyvyH9GnrF64PdHoaNKzuq1Rh4JzFiz+gGZqxfIbPfh
         DvA8khLP62O6y81BxbbmIDTg3jbCiYhd9ueS8qjUqFz2pNP1rK7X1WOni7YvUEsStKTE
         9tpWazZoowwAjN9k9ZVYyNxOTIWmm/qvG+z1BUgSodOt9pX23je6kmettWWPsNFhJOnX
         RjcA==
X-Gm-Message-State: AOAM531D2iwZIl5AomAHA9rIiKHgxeDR8f/ZAyl9S04fZaStWNkqQhEX
        S9P2K9K2OkP39Kw+FHkv3+M=
X-Google-Smtp-Source: ABdhPJwvLuJzWOILGWQdJGs2DQihxg3sZ7HLxdKN9J7wFpGmDHFz6cyOnG8qdErrHdAKkfy0VbG6/g==
X-Received: by 2002:a17:902:c9d5:b0:138:9a20:4bd9 with SMTP id q21-20020a170902c9d500b001389a204bd9mr4222493pld.34.1630086260299;
        Fri, 27 Aug 2021 10:44:20 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id t186sm7124382pfb.53.2021.08.27.10.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 10:44:19 -0700 (PDT)
Subject: Re: [PATCH V4 04/13] hyperv: Mark vmbus ring buffer visible to host
 in Isolation VM
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, catalin.marinas@arm.com,
        will@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        brijesh.singh@amd.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, aneesh.kumar@linux.ibm.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        linux-arm-kernel@lists.infradead.org,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        ardb@kernel.org, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-5-ltykernel@gmail.com> <YSkjsapeNj+2j//o@kroah.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <5d665aff-f200-3b1d-7b9b-2f080cf59a59@gmail.com>
Date:   Sat, 28 Aug 2021 01:44:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YSkjsapeNj+2j//o@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg:
      Thanks for your review.

On 8/28/2021 1:41 AM, Greg KH wrote:
> On Fri, Aug 27, 2021 at 01:21:02PM -0400, Tianyu Lan wrote:
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>
>> Mark vmbus ring buffer visible with set_memory_decrypted() when
>> establish gpadl handle.
>>
>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>> ---
>> Change since v3:
>>         * Change vmbus_teardown_gpadl() parameter and put gpadl handle,
>>         buffer and buffer size in the struct vmbus_gpadl.
>> ---
>>   drivers/hv/channel.c            | 36 ++++++++++++++++++++++++++++-----
>>   drivers/net/hyperv/hyperv_net.h |  1 +
>>   drivers/net/hyperv/netvsc.c     | 16 +++++++++++----
>>   drivers/uio/uio_hv_generic.c    | 14 +++++++++++--
>>   include/linux/hyperv.h          |  8 +++++++-
>>   5 files changed, 63 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
>> index f3761c73b074..82650beb3af0 100644
>> --- a/drivers/hv/channel.c
>> +++ b/drivers/hv/channel.c
>> @@ -17,6 +17,7 @@
>>   #include <linux/hyperv.h>
>>   #include <linux/uio.h>
>>   #include <linux/interrupt.h>
>> +#include <linux/set_memory.h>
>>   #include <asm/page.h>
>>   #include <asm/mshyperv.h>
>>   
>> @@ -474,6 +475,13 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
>>   	if (ret)
>>   		return ret;
>>   
>> +	ret = set_memory_decrypted((unsigned long)kbuffer,
>> +				   HVPFN_UP(size));
>> +	if (ret) {
>> +		pr_warn("Failed to set host visibility for new GPADL %d.\n", ret);
> 
> dev_warn()?  You have access to a struct device, why not use it?
> 
> same for all other instances here.
> 
>

Yes, dav_warn() is better. Will update in the next version. Thanks.

