Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645EF468339
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 08:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354792AbhLDHqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 02:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243286AbhLDHqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 02:46:14 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE7AC061751;
        Fri,  3 Dec 2021 23:42:49 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id x7so4041390pjn.0;
        Fri, 03 Dec 2021 23:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=k/XW81IzuVveDnfkiaihrgRy1fm8QRuVkAriBYUSktQ=;
        b=aeetCr9E159DG34hEjAeWGhArTHlrTQp+RvPNuwjMb9u/3PFY53wzhtHubgWJQvDgG
         Jozxdg5UENxD6v0AUKHmjx4efncr1d3uH51laaSKr9cPyQcT+BdlVcFvxfS2q7alc9M+
         IQoElcNzWMNvIxf21BBZKf234HszCsVWMj7scSChzf64nuKTXacuscJrUCAKLRq29Wrh
         e5337Xbg+LNRcQZd6EO7eqCabhSTi7bBHidYnjemVzHYg6jyVwVpnU2LRvbC5rtLuJMX
         22ZzHU6J0KwMuux99RJ5m0Zk9mxBVsGjyiM9lko2MTYAamfaDiH1DIbBhIO1ffuEquNb
         e04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=k/XW81IzuVveDnfkiaihrgRy1fm8QRuVkAriBYUSktQ=;
        b=n0/OGKrzb8Hn8Bc5pytbQDyzmvSaf40yltQNpz0TQYTsnRUzAA03RhhGTNlrinwYoN
         YPoE5utXEnLduscuTBfDJc9KImSaYi7TRK7GNJ/rK8NHDhkQlU5XdILob3H8G2PAsxFv
         1S84EtbKLCNYs02P4XVCe8zFLmIVipzSjNcR77lF781zKA/Vs80hhDaDBgPJBWb0Pe0z
         6nCMiXR7EV/K+DshpepXmAS/CDeM2YLh5g89mJJXi2BiJOIXs3T2QjFlXhgU8jz4crbe
         mlu+ShRbWndT1ya9LYDXo2ZmFURXYeOC+FY7RXfDPOm25Ck06xz70/VF4rvSMRxOURLn
         6LYg==
X-Gm-Message-State: AOAM532fIBlmmNrF65MPpZA96q2GTX578JM+4J3+E33zFJ52Rqmv0dTH
        OPaepqGanBOED9OEFFMM574=
X-Google-Smtp-Source: ABdhPJwRWGj4ETvjt39e2arm3ZwL48sLjKr/6To2ton+oBAvgGlhyx9UEyFTCkGwPmBxwIqCiR8C4Q==
X-Received: by 2002:a17:902:714f:b0:142:892d:a46 with SMTP id u15-20020a170902714f00b00142892d0a46mr28039873plm.39.1638603768758;
        Fri, 03 Dec 2021 23:42:48 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id mz7sm7286643pjb.7.2021.12.03.23.42.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 23:42:48 -0800 (PST)
Message-ID: <448de4ec-b73e-597f-16fe-623123c04d1e@gmail.com>
Date:   Sat, 4 Dec 2021 15:42:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH V3 5/5] hv_netvsc: Add Isolation VM support for netvsc
 driver
Content-Language: en-US
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20211201160257.1003912-1-ltykernel@gmail.com>
 <20211201160257.1003912-6-ltykernel@gmail.com>
 <MWHPR21MB15934DE25012A8565256336ED76A9@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <MWHPR21MB15934DE25012A8565256336ED76A9@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/2021 2:59 AM, Michael Kelley (LINUX) wrote:
>> +
>> +/*
>> + * hv_map_memory - map memory to extra space in the AMD SEV-SNP Isolation VM.
>> + */
>> +void *hv_map_memory(void *addr, unsigned long size)
>> +{
>> +	unsigned long *pfns = kcalloc(size / HV_HYP_PAGE_SIZE,
> This should be just PAGE_SIZE, as this code is unrelated to communication
> with Hyper-V.
>

Yes, agree. Will update.

