Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008EA41FC92
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 16:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbhJBOl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 10:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhJBOlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 10:41:55 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D255C0613EC;
        Sat,  2 Oct 2021 07:40:09 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y8so10591659pfa.7;
        Sat, 02 Oct 2021 07:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DhqK+ArXjOjZa+oG4Fg6CrcyqWKqBYM+cDJqPKFTj1Y=;
        b=cUP8o59dy39Y+pX5bhAu2X0gbRFVsEbbFjDm8enHO/Basfah7l18NqbwKJfVekcvkg
         X6lPclFmdEEbQxnk/fY9ZD3bDpHufvZYX8RkRfvdqG4CHRBvXVm8KacWMCBvyueXHQoH
         jhmy2mh4QCirOwRLDSQnM7g6X3Xn/ZS5tsEZkN/ELgRxOBUEKWhTsnYwYbol6VMl0Bg3
         ba+wzRyzjygCjnl1ENRuGNcPhMMQqoeUBQLMcbppGFid8lNoFhlK99rsgsa+QqMkZwP8
         SMQV8aFa1jeoAa8Xs6z8ShSMRW+tTBmAC5dXS6kQbZviwFKTDYwIc0I5QCybozObnncX
         IHGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DhqK+ArXjOjZa+oG4Fg6CrcyqWKqBYM+cDJqPKFTj1Y=;
        b=LaMuH5Hw/Ucvbk16e3Nc3vFK+UsHyesVgC+iL/SVSTOFy7DsDWHm5Sr0cBPpcWYOk7
         t0+ZU+7c19i20Ls2zUITRGN7MbPorMOsnbvqWMAtXUmI+4kG+MUtVn2GgGypB95Jj/MU
         d6fkTTLsYNQVVzIZ/vCKOIXT1Xx/8r7J8VMtoU3F115DevD0OBMaObeBt9FyFH1/WeZy
         Qf5iwT+aooZzFdsLlxyrPPAK/DT0Dku4WDf1WooDrUOVeRKAjxo0CT1sV1IchwYDFkus
         dIzUog+rVprQsrpVreu8PDLnH11M5ZtOLjxgdvgsmx2Cbwsb/iZbwc22oN7q/mQHNtfE
         1Ndw==
X-Gm-Message-State: AOAM5330RXxBtds2J9FLfajwHzNUfOgc25QrYHOhMwVgOH1ko9LUD3GC
        q3QT16HeY+v/sT+ff39kCCU=
X-Google-Smtp-Source: ABdhPJzhqKbKc4pKj0Qz4h3vYl7ZYtAq/GBEXfVoW4W3zdLAXr7eSUHeacMohQPRpXHWrj+iCtkLdw==
X-Received: by 2002:aa7:82ce:0:b0:44b:436b:b171 with SMTP id f14-20020aa782ce000000b0044b436bb171mr16952302pfn.21.1633185608861;
        Sat, 02 Oct 2021 07:40:08 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id k14sm8725564pji.45.2021.10.02.07.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Oct 2021 07:40:08 -0700 (PDT)
Subject: Re: [PATCH V6 7/8] Drivers: hv: vmbus: Add SNP support for VMbus
 channel initiate message
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
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "tj@kernel.org" <tj@kernel.org>
Cc:     "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20210930130545.1210298-1-ltykernel@gmail.com>
 <20210930130545.1210298-8-ltykernel@gmail.com>
 <MWHPR21MB15933BC87034940AB7170552D7AC9@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <1c31c18d-af76-c5af-84f1-0dafe48f8605@gmail.com>
Date:   Sat, 2 Oct 2021 22:39:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <MWHPR21MB15933BC87034940AB7170552D7AC9@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael:
      Thanks for your review.


On 10/2/2021 9:26 PM, Michael Kelley wrote:
>> @@ -303,10 +365,26 @@ void vmbus_disconnect(void)
>>   		vmbus_connection.int_page = NULL;
>>   	}
>>
>> -	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[0]);
>> -	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[1]);
>> -	vmbus_connection.monitor_pages[0] = NULL;
>> -	vmbus_connection.monitor_pages[1] = NULL;
>> +	if (hv_is_isolation_supported()) {
>> +		memunmap(vmbus_connection.monitor_pages[0]);
>> +		memunmap(vmbus_connection.monitor_pages[1]);
> The matching memremap() calls are made in vmbus_connect() only in the
> SNP case.  In the non-SNP case, monitor_pages and monitor_pages_original
> are the same, so you would be doing an unmap, and then doing the
> set_memory_encrypted() and hv_free_hyperv_page() using an address
> that is no longer mapped, which seems wrong.   Looking at memunmap(),
> it might be a no-op in this case, but even if it is, making them conditional
> on the SNP case might be a safer thing to do, and it would make the code
> more symmetrical.
>

Yes, memumap() does nothing is the non-SNP CVM and so I didn't check CVM
type here. I will add the check in the next version.

Thanks.


