Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AED83FEEC5
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 15:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345197AbhIBNhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 09:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbhIBNhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 09:37:02 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BABC061575;
        Thu,  2 Sep 2021 06:36:04 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id fs6so1362537pjb.4;
        Thu, 02 Sep 2021 06:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3ii/guKHn4LpF03RfgLBF/j9oSVP4qa5E4ECxRbe8hE=;
        b=SQm9Nj4ysgjXU+46HOkYd8Q+/51pgR0klYtCW81HunVSPpNqA+7K6ET2S66TXtFo5V
         dUkSrrWmLdz9TgWh/ywwICTIxatEgDnyhnQs5/AiLJGp5rcv9KvBnwyhADMsOmMIBDEE
         nzezmmPn+wpRYYcADoD+nWE8McbCwOsGC+BH28wlQdSj65Vv6aiEEaIhoTM3yHym8m8M
         uJ7pUAhfdy9O2NQ1ZT90Jct19BmiUoi4Lm8Un1aHkNzAhPQO1ioDu9bRjpEUheed7PwG
         NaFORAtAC9wGX5zQ/JUlDZFdP09/92z+FxuN3oVRGo0d4SLQnwGPjmGI7zp0OcLmFhww
         rJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ii/guKHn4LpF03RfgLBF/j9oSVP4qa5E4ECxRbe8hE=;
        b=S8iLwBaKjMJjvFqHVrJiTu1Te2YUqo61fFy2qrYxfDZkS/iz8tu70RLW8T/5zPTT3d
         qX9Z5+Jo31JeSaZTX4Uj+/7++yFUF0u7BwflXP/QrWfRwO5TAI+ZP8o+JzY0c39/rGSh
         c7KOubGwRMZMToAksbE8J97uVC/97DYZlXcqW0x1GbD18v/BhNBlbIYDq47tCnBllV9T
         IlRVkIVK7GSOLRK/iGX2eolA6nv0OKaKPo3wjjo8O7OdyDya4k1GvkayveXeMBE6W766
         EMTO761rqeMeFyiVcHyQtxUtGtz0cSvYFieXiaMlSibxUkc7AtbuyeiOi+sw7TlgFK3n
         bl9g==
X-Gm-Message-State: AOAM532Mceaf2+M9los7Y0ABX9H996UP0buL98G6fRDNpL0ARvdv2Nq/
        06VcDWZeO/b1wgexJvMxZRk=
X-Google-Smtp-Source: ABdhPJxb2ycIjPIdhzbaYk0Qkm84LE40W+f5tgz7hUwm6cNYqkebQcMmosgs/I437B2b32yx0P3oCw==
X-Received: by 2002:a17:902:c408:b0:138:e3df:e999 with SMTP id k8-20020a170902c40800b00138e3dfe999mr2981076plk.30.1630589763493;
        Thu, 02 Sep 2021 06:36:03 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id a10sm2447079pja.14.2021.09.02.06.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 06:36:03 -0700 (PDT)
Subject: Re: [PATCH V4 08/13] hyperv/vmbus: Initialize VMbus ring buffer for
 Isolation VM
To:     Michael Kelley <mikelley@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
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
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "ardb@kernel.org" <ardb@kernel.org>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
 <20210827172114.414281-9-ltykernel@gmail.com>
 <MWHPR21MB1593B416ED91CD454FC036E5D7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <e864b95d-ecb7-074b-ff0b-85cc451bad52@gmail.com>
Date:   Thu, 2 Sep 2021 21:35:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <MWHPR21MB1593B416ED91CD454FC036E5D7CE9@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/2021 8:23 AM, Michael Kelley wrote:
>> +	} else {
>> +		pages_wraparound = kcalloc(page_cnt * 2 - 1,
>> +					   sizeof(struct page *),
>> +					   GFP_KERNEL);
>> +
>> +		pages_wraparound[0] = pages;
>> +		for (i = 0; i < 2 * (page_cnt - 1); i++)
>> +			pages_wraparound[i + 1] =
>> +				&pages[i % (page_cnt - 1) + 1];
>> +
>> +		ring_info->ring_buffer = (struct hv_ring_buffer *)
>> +			vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP,
>> +				PAGE_KERNEL);
>> +
>> +		kfree(pages_wraparound);
>> +		if (!ring_info->ring_buffer)
>> +			return -ENOMEM;
>> +	}
> With this patch, the code is a big "if" statement with two halves -- one
> when SNP isolation is in effect, and the other when not.  The SNP isolation
> case does the work using PFNs with the shared_gpa_boundary added,
> while the other case does the same work but using struct page.  Perhaps
> I'm missing something, but can both halves be combined and always
> do the work using PFNs?  The only difference is whether to add the
> shared_gpa_boundary, and whether to zero the memory when done.
> So get the starting PFN, then have an "if" statement for whether to
> add the shared_gpa_boundary.  Then everything else is the same.
> At the end, use an "if" statement to decide whether to zero the
> memory.  It would really be better to have the logic in this algorithm
> coded only once.
> 

Hi Michael:
	I have tried this before. But vmap_pfn() only works for those pfns out 
of normal memory. Please see vmap_pfn_apply() for detail and
return error when the PFN is valid.


