Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198FB40D7DF
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 12:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237104AbhIPKxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 06:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235487AbhIPKxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 06:53:47 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7187DC061574;
        Thu, 16 Sep 2021 03:52:27 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id m26so5556456pff.3;
        Thu, 16 Sep 2021 03:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VNKbu9+xQ5ZpUtGvMTcqpK8Ho+xMSyVZ8+L+t3qGVwI=;
        b=XSZj6K6WXxfevgNkMQWTVWN/pRsGZ48Hpf1aapa7yFejBTCFdA6HUCPwkA38CUvHOb
         12EGRvxxebdCNuoE+ObAyvTNwWyxDdbNnDJYQNBCpkkMDkdT2sOdFGpKg9oYBfCBDwL0
         XflKHpxQXjZ521DE/0ZBRDz1uCKiQSaIrItzbkcc7HCVprwqAzWPmTfhfdTuxhcGIkae
         17ws4naiLQWag9g0raMGIBW/7G/5E7reQPZwNkqgzzUPtdDb0IjYRvViaMPYRdxPUde6
         Bl5njgBd1GAcMu72JAentZ78PNGD3qywdjPZPtQPg3O6M2RygtB2NwLk/e/0AhwfWnul
         yMPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VNKbu9+xQ5ZpUtGvMTcqpK8Ho+xMSyVZ8+L+t3qGVwI=;
        b=L3EYCg0A4Z1ArY4xwg8/HPwxIxgjfaR3QGsYVQaksyx+FOo1Q4bf/BqQZzu/w9AIHT
         yiiGgsvny1PxeFpMRBSqJv/H+oiT5aLeBdDLeb+BRj7Z1JlPZxjy5LgHKYJwE1lHxAyU
         cFkuKXXjrWwLtMVUQas0snNCKz0pYAC/9QtghBvCs0QNj+vM0fb7G85I9QLX6TcEieLH
         hTGyE/3ZOqKQfuKq0sppMI3VDI/2MFrJSySxPPvglEqlXUlcrQTJXIAlT8Ab+RKsoR3v
         lbLFo0z5V35m2PMJCUPtY2hAzwy2OefR954lMmEUxlLup+MV59mZUpZMNlu+u2BkVG/U
         n5DA==
X-Gm-Message-State: AOAM531ugxjHSZgg7RpjliV6siJ0Gvlu39H/XEwrOTmCNRf+jXxysCPm
        pCBP/6iMa4JSb169H5GIRVZWctTCMFdb/Q==
X-Google-Smtp-Source: ABdhPJyl+TWhw4qIPd+GNTqUwBCT0hUxX1fvNVQYkrBsEjf+FvFMSf2MpaDHDZtEUEbJwfeL0pUlhg==
X-Received: by 2002:a63:4614:: with SMTP id t20mr4441488pga.372.1631789546934;
        Thu, 16 Sep 2021 03:52:26 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id 21sm2624212pfh.103.2021.09.16.03.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 03:52:26 -0700 (PDT)
Subject: Re: [PATCH V5 07/12] Drivers: hv: vmbus: Add SNP support for VMbus
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
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "rientjes@google.com" <rientjes@google.com>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20210914133916.1440931-1-ltykernel@gmail.com>
 <20210914133916.1440931-8-ltykernel@gmail.com>
 <MWHPR21MB1593D9CB27D41B128BF21DC9D7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <15d177f8-5e20-8630-2b2c-8a00a5309a61@gmail.com>
Date:   Thu, 16 Sep 2021 18:52:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <MWHPR21MB1593D9CB27D41B128BF21DC9D7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/2021 11:41 PM, Michael Kelley wrote:
>> diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
>> index 42f3d9d123a1..560cba916d1d 100644
>> --- a/drivers/hv/hyperv_vmbus.h
>> +++ b/drivers/hv/hyperv_vmbus.h
>> @@ -240,6 +240,8 @@ struct vmbus_connection {
>>   	 * is child->parent notification
>>   	 */
>>   	struct hv_monitor_page *monitor_pages[2];
>> +	void *monitor_pages_original[2];
>> +	unsigned long monitor_pages_pa[2];
> The type of this field really should be phys_addr_t.  In addition to
> just making semantic sense, then it will match the return type from
> virt_to_phys() and the input arg to memremap() since resource_size_t
> is typedef'ed as phys_addr_t.
> 

OK. Will update in the next version.

Thanks.
