Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2808846985E
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 15:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343747AbhLFORj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 09:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343688AbhLFORi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 09:17:38 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5AEC0613F8;
        Mon,  6 Dec 2021 06:14:09 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id f125so10642170pgc.0;
        Mon, 06 Dec 2021 06:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LG+zF8eXNnqFsGFKA2ZTnXSPUueJWK5YxbpbucSufXI=;
        b=mQqUkA3xIsQY4XmQYBzGNmYRws6Q0JrMJpuTq/VEAZ58elCNocHbrP8QMV+4phw9Ut
         vWKeJdfRRl2H6A3/U0ZfFrg46WCHuxCz5sAlIyGUXSN9dXWnqcoQP+R/jmprw5bfpFHj
         fKOmzAhbS2g+OM1Z5BI3nXKStQ11a7SSrQ5tFd6125uR6KPjsGJebIfx224pdX+EvGle
         FqorCYj7anmbSaX4e41EWyvuvtjfgov84k+oRDD0xrawuDr2dYvzxxLjG9dUVswmsHTE
         elai+rbP43KznXg+HMIMYpPzORZYpPi24LOHZHh8JFVSoiDVYRN7mdHXVcauIlegBAj5
         mHBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LG+zF8eXNnqFsGFKA2ZTnXSPUueJWK5YxbpbucSufXI=;
        b=a/a6H3WXUQOc4RaM7MjJoynXjSlcbcd9Yu0dTzizVhzGcmw0SE2WnNEw2ggS7rTUxz
         l6YR0WejXUMO6myj40TFebIuLWBsuobLSd6WVJJA3lKQBPsVnvfmvdodAO25s9Y+e5in
         ySDQbEb65xcUFsG641MqU5dXvLRO1hRxCAFMUnfWzISRtaVROCOjb4yFbhfUS26VNe3i
         SUtgfu0u5plvrmXU80U3G33ZWRYVfrxVrxVXEn2353eASEUwPB/7PlZQOaD/GKqtqXJr
         CNHqxg9sql30CUncmMjc7B2LR2O7d64XnvsudowfSChoUAykyz4XTlg0XjOz0v5bwl6Y
         33BQ==
X-Gm-Message-State: AOAM5329jm21pOA/9nlt5UAbFCIgkmAOyfhk71dbT2P+spgg70P4Wg1V
        hVBRaMzMEozSkWL/C4gsfdA=
X-Google-Smtp-Source: ABdhPJySAj+QT4OHzaoYLk1cSWHqCc54qgRjOngjnxP5g2RiZmDR4g0TxiHn1EhVWrwC669mfsgWOQ==
X-Received: by 2002:a62:7e4c:0:b0:4a2:678e:8793 with SMTP id z73-20020a627e4c000000b004a2678e8793mr36890086pfc.75.1638800049309;
        Mon, 06 Dec 2021 06:14:09 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id pi17sm14658528pjb.34.2021.12.06.06.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 06:14:08 -0800 (PST)
Message-ID: <4d9049eb-d3a8-3872-c4c3-4ad41d93b58c@gmail.com>
Date:   Mon, 6 Dec 2021 22:13:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH V4 2/5] x86/hyper-v: Add hyperv Isolation VM check in the
 cc_platform_has()
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, jgross@suse.com,
        sstabellini@kernel.org, boris.ostrovsky@oracle.com,
        joro@8bytes.org, will@kernel.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, parri.andrea@gmail.com,
        dave.hansen@intel.com
References: <20211205081815.129276-1-ltykernel@gmail.com>
 <20211205081815.129276-3-ltykernel@gmail.com> <20211206140651.GA5100@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <20211206140651.GA5100@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph:
	Thanks for your review.

On 12/6/2021 10:06 PM, Christoph Hellwig wrote:
> On Sun, Dec 05, 2021 at 03:18:10AM -0500, Tianyu Lan wrote:
>> +static bool hyperv_cc_platform_has(enum cc_attr attr)
>> +{
>> +#ifdef CONFIG_HYPERV
>> +	return attr == CC_ATTR_GUEST_MEM_ENCRYPT;
>> +#else
>> +	return false;
>> +#endif
>> +}
> 
> Can we even end up here without CONFIG_HYPERV?
> 

Yes, I will update in the next version.

Thanks.
