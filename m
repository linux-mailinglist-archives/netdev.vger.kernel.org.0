Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B99A46831D
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 08:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344466AbhLDHZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 02:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbhLDHZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 02:25:29 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87C1C061751;
        Fri,  3 Dec 2021 23:22:04 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso6951352pji.0;
        Fri, 03 Dec 2021 23:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZkQEYozmB0wgYJcxDO/m983AAdy8n14FhucCaGoUzA4=;
        b=blREAYP23qBjIahcqczEuNSUq6MRbQ5UXgW1oG4ZGSSpOed90dbanN+LHvJF7N6ME0
         Y9LKoSwodHr9BOd//+DW6OvBPSh6Rf4BdMb2EzDvtQ+sVoes1f6+7VWyUKFWqiaSHHqU
         Am+FtOCVPnOAgj6oTP0k0IWgh4dooTt7QX7KQKbCT+o69WR7nP4hJQspPwFm25qXtPCW
         kBdkmADgMPc7HTKvYOavrblwjUfXQ3wlSxkW6E/shgs8QAhLWvPBZ3tVRmEVD7CWY44S
         t8LTdIFpatSjby01xMjLjf42MSd1m5DtLtC+1uS3bLpAx3vREm/i+1aUCO81LPZgXzuP
         nkWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZkQEYozmB0wgYJcxDO/m983AAdy8n14FhucCaGoUzA4=;
        b=y2p/lvt374wlKRsJOW+X3FJTKJeg5JQ5PGHiHtuMWq8vjHK8kNwOx2cXg7kFIDt6GZ
         GWpTXROfQaQGc4Sqcwf7un19o6tzvq8gTC40TkOzJgdJvrOQATV78k9J6sK0ymLtzmC6
         iyLfZDt1xtt4pCF+o3xM/8r80ZD7DFlRAKkX19MUxh2ZPm6hSzVm09ns226Fs86OwwxI
         s1csl3Ix8jApBmjaCkVXFEbLW9ASwBbPlFRWE3V8pRWaWhW8iLr6+cubVa/1Ylo+zNuG
         PTjCL7swYrzNvCV7WEWCAit5nq5UxEvKDbxc0SaemDhJMIYNAgUu3Y6qBdg/XyUfHR5O
         20LQ==
X-Gm-Message-State: AOAM533wEHgVJox09V37PvdH3GuZhMAvzI4CXCG4Eumk/NbEYzH5NMz4
        MZ/jzbFv3zbXgsgVPu/5e2k=
X-Google-Smtp-Source: ABdhPJzcZuwuxSGpXoC+LpAfScg+HY+PAZl5x85Fy3cmkRF8TnHHjxYQIiUVC9++sZKTL0nxBihlXA==
X-Received: by 2002:a17:903:1105:b0:143:a593:dc6e with SMTP id n5-20020a170903110500b00143a593dc6emr28523850plh.6.1638602524291;
        Fri, 03 Dec 2021 23:22:04 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id t10sm4331860pga.6.2021.12.03.23.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 23:22:03 -0800 (PST)
Message-ID: <59e41c28-260f-876d-c7cf-a13669ad8984@gmail.com>
Date:   Sat, 4 Dec 2021 15:21:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH V3 1/5] Swiotlb: Add Swiotlb bounce buffer remap function
 for HV IVM
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        Tianyu.Lan@microsoft.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, parri.andrea@gmail.com, dave.hansen@intel.com
References: <20211201160257.1003912-1-ltykernel@gmail.com>
 <20211201160257.1003912-2-ltykernel@gmail.com>
 <41bb0a87-9fdb-4c67-a903-9e87d092993a@amd.com>
 <e78ba239-2dad-d48f-671e-f76a943052f1@gmail.com>
 <06faf04c-dc4a-69fd-0be9-04f57f779ffe@amd.com>
 <1b7b8e20-a861-ab26-26a1-dad1eb80a461@amd.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <1b7b8e20-a861-ab26-26a1-dad1eb80a461@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/2021 4:06 AM, Tom Lendacky wrote:
>>> Hi Tom:
>>>        Thanks for your test. Could you help to test the following 
>>> patch and check whether it can fix the issue.
>>
>> The patch is mangled. Is the only difference where 
>> set_memory_decrypted() is called?
> 
> I de-mangled the patch. No more stack traces with SME active.
> 
> Thanks,
> Tom

Hi Tom:
	Thanks a lot for your rework and test. I will update in the next version.

Thanks.
