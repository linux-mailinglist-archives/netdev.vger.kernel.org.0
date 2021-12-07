Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744BA46B9EF
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 12:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbhLGLWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 06:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbhLGLV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 06:21:59 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08ECC061574;
        Tue,  7 Dec 2021 03:18:29 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id v19so9188638plo.7;
        Tue, 07 Dec 2021 03:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XkJS/vk/AFCAw+MrKJZ0hWbQuGoDCAYXbs59fxjYT0Q=;
        b=YiRYLAImUdwYtDAM2dV92jtzYCI7H/oTaQpaYU9J3BTdl9mZzWQvXZstH079RAnzrO
         BKa0r12fG0lYvHIKhYcvZ5/oQiXQI7/ElY7ki15eMt2zl5xnYcm+WUhDAb1iJO8dgurD
         cuaqGlcHLKSI88ln4GStddlJ6GvQmebeg4h/Yrg6MVNZwkXhYpK4afH5hKuQviglzk7h
         QJ5RXCb+/wBTk4zWrQG/4SWebKyPujunw8RrM+sPLvF7Qa94YrwyUCTnzfD7DA2yj3N+
         dHWk0mByLS+4vEFJPA9DWEigJjcwc7D8z1Wn/WgwUnxFJH90qjt09MtlBbYIgUxkIXUR
         18Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XkJS/vk/AFCAw+MrKJZ0hWbQuGoDCAYXbs59fxjYT0Q=;
        b=tsRMjajf6r++8q4A7PSwTODhfiRDxR8AgUNROWj4RmGTCucK7AQdHvz/yTFOaBD4W+
         +AbH13KN1Bg5tT8bGOlxHe+8/CfHuLHJoOg3kTXcSSa9zcRjHHD+Mf9C5MMg/rjYAxL9
         ocvie3U/Ap4VwCvkYGNXWaeRK2ExLNOQpDLpTCTzC4lKRLdRhWjDaFOI88hUG2i40xCV
         1apsVj+to+WrhxC4YMuroD2Foa6cMGj4dlPtf12RAdTWCGdMZmi2BBy0APChN5+KZVhf
         kU7sIFVfAuSUq5BXmY0vSdL6g50RaqvPNUYTYpBNw2Alm2E1lHLN2Yo8OItXeaCZRL8c
         /ihg==
X-Gm-Message-State: AOAM5306EJEU0pde7eveQ7Ylm5IX1FGov/hdEWoMkU7OJtdbZeiIL0yf
        KIOis8tv8vmcPmeAfWNUo9Y=
X-Google-Smtp-Source: ABdhPJy6JQ2U2g/j2Cyw3PWOVycj1dWgdg4/1qcexVGVfrBnGzPoAXWo/lvzcA61q4EzMlW8PtSvNA==
X-Received: by 2002:a17:902:d34d:b0:143:c927:dc48 with SMTP id l13-20020a170902d34d00b00143c927dc48mr50676636plk.71.1638875909491;
        Tue, 07 Dec 2021 03:18:29 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id m76sm8832389pfd.160.2021.12.07.03.18.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 03:18:29 -0800 (PST)
Message-ID: <1f967946-6634-9aeb-4840-1b52e30cecc5@gmail.com>
Date:   Tue, 7 Dec 2021 19:18:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH V6 2/5] x86/hyper-v: Add hyperv Isolation VM check in the
 cc_platform_has()
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, hch@lst.de, joro@8bytes.org,
        parri.andrea@gmail.com, dave.hansen@intel.com
References: <20211207075602.2452-1-ltykernel@gmail.com>
 <20211207075602.2452-3-ltykernel@gmail.com> <Ya8tlQZf7+Ec6Oyp@zn.tnic>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <Ya8tlQZf7+Ec6Oyp@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Borislav:
	Thanks for your review.

On 12/7/2021 5:47 PM, Borislav Petkov wrote:
> On Tue, Dec 07, 2021 at 02:55:58AM -0500, Tianyu Lan wrote:
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>
>> Hyper-V provides Isolation VM which has memory encrypt support. Add
>> hyperv_cc_platform_has() and return true for check of GUEST_MEM_ENCRYPT
>> attribute.
> 
> You need to refresh on how to write commit messages - never say what the
> patch is doing - that's visible in the diff itself. Rather, you should
> talk about *why* it is doing what it is doing.

Sure. Will update.

> 
>>   bool cc_platform_has(enum cc_attr attr)
>>   {
>> +	if (hv_is_isolation_supported())
>> +		return hyperv_cc_platform_has(attr);
> 
> Is there any reason for the hv_is_.. check to come before...
> 

Do you mean to check hyper-v before sev? If yes, no special reason.


>> +
>>   	if (sme_me_mask)
>>   		return amd_cc_platform_has(attr);
> 
> ... the sme_me_mask check?
> 
> What's in sme_me_mask on hyperv?

sme_me_mask is unset in this case.

