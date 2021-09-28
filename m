Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C4141ABB0
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 11:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239807AbhI1JZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 05:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239573AbhI1JZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 05:25:26 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96B2C061575;
        Tue, 28 Sep 2021 02:23:47 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 75so4159114pga.3;
        Tue, 28 Sep 2021 02:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bNCbpKkDoRa/LEy6AE/asdoXmkV09NnhXW1RxZk9Sdg=;
        b=d7EQaIO2BrzYhwnuLWNgscYrGYoCF1llQTdP7VsnWfHPgbO7X8mwFpRL1rP0sxjRol
         /+BkBsfPxs/6kB2aGGiarfL3uCD04VsP3Qvt0ysEyyh6Gt2+3I1FWrhhioqM5RZZcaaQ
         08hitTmCaLcQBEott0EDr+wFaOq4jqZ1NJtcmmH1pPW9zZ2ctPp9TAkDzkUATz66B0OO
         APGXI2+QPUkq1LfuP1SdBGqjMyXvkbKRa4yN0N3eDg3lv3bc7gcKGRD1XvdkWanbXoPX
         wdfl6sy2mQQiSep/qjiZSaFK4BGckINkhPOtEFqjaiLg960K/wVSLQzxtSjHYSHxv/ie
         tbaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bNCbpKkDoRa/LEy6AE/asdoXmkV09NnhXW1RxZk9Sdg=;
        b=6pvsUNZ7GDN99vZaBo4jhqdk6EIpZL5QPQGzfBm/5pKcUXgxh5ieE2VESZLdKsDdxi
         AKqTvPMQV/5mvXgizF1IERFcIe61NYpY3MUb4PE2wPXxxJYA2HJW5iz7ylWyOd6uvz58
         c0zRS60Y9EiKQKYPfIYVCQ+jf5tg5EeD9rU/O8lj9AtJg3WZNY9x1NWuJIpyVq5HM/2r
         5YBiNnQmLktU3Pw+0nlnCnf+8SWSxPhubNusWIN1oi4PbREDRGFHptu8sJAqJsl0zCrP
         YnNn7kZLx5og4M4fhHhu4995ttRO2+6mZy3m8zybYWmh5imWAduN0kdNu+PGoUs6dfnx
         aAnA==
X-Gm-Message-State: AOAM532kJb344XCiUusObebg+PdxcIjUyZTvyFARpNsI+88PLTpRHn8G
        pHs+L9yLxz02aoewMiQXb0g=
X-Google-Smtp-Source: ABdhPJwGWB7Tw6GaWECCuWCSL7zfwRyp/J9yMIqD2mhp7FZqF/2KIG0FGrBjcU+pMCnt5vLHDbzqyg==
X-Received: by 2002:aa7:9f03:0:b0:447:dd09:6dda with SMTP id g3-20020aa79f03000000b00447dd096ddamr4300020pfr.36.1632821027229;
        Tue, 28 Sep 2021 02:23:47 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id mv6sm1943328pjb.16.2021.09.28.02.23.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 02:23:46 -0700 (PDT)
Subject: Re: [PATCH V5 12/12] net: netvsc: Add Isolation VM support for netvsc
 driver
To:     Christoph Hellwig <hch@lst.de>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        Michael Kelley <mikelley@microsoft.com>,
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
        "arnd@arndb.de" <arnd@arndb.de>,
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
References: <20210914133916.1440931-1-ltykernel@gmail.com>
 <20210914133916.1440931-13-ltykernel@gmail.com>
 <MWHPR21MB15939A5D74CA1DF25EE816ADD7DB9@MWHPR21MB1593.namprd21.prod.outlook.com>
 <43e22b84-7273-4099-42ea-54b06f398650@gmail.com>
 <e379a60b-4d74-9167-983f-f70c96bb279e@gmail.com>
 <20210928053911.GA29208@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <de18b708-7252-642b-c60f-59e12ac27421@gmail.com>
Date:   Tue, 28 Sep 2021 17:23:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210928053911.GA29208@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/2021 1:39 PM, Christoph Hellwig wrote:
> On Mon, Sep 27, 2021 at 10:26:43PM +0800, Tianyu Lan wrote:
>> Hi Christoph:
>>      Gentile ping. The swiotlb and shared memory mapping changes in this
>> patchset needs your reivew. Could you have a look? >
> I'm a little too busy for a review of such a huge patchset right now.
> That being said here are my comments from a very quick review:
Hi Christoph:
       Thanks for your comments. Most patches in the series are Hyper-V
change. I will split patchset and make it easy to review.


> 
>   - the bare memremap usage in swiotlb looks strange and I'd
>     definitively expect a well documented wrapper.

OK. Should the wrapper in the DMA code? How about dma_map_decrypted() 
introduced in the V4?
https://lkml.org/lkml/2021/8/27/605

>   - given that we can now hand out swiotlb memory for coherent mappings
>     we need to carefully audit what happens when this memremaped
>     memory gets mmaped or used through dma_get_sgtable

OK. I check that.

>   - the netscv changes I'm not happy with at all.  A large part of it
>     is that the driver already has a bad structure, but this series
>     is making it significantly worse.  We'll need to find a way
>     to use the proper dma mapping abstractions here.  One option
>     if you want to stick to the double vmapped buffer would be something
>     like using dma_alloc_noncontigous plus a variant of
>     dma_vmap_noncontiguous that takes the shared_gpa_boundary into
>     account.
> 

OK. I will do that.


