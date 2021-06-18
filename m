Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6E43AD349
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 22:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbhFRUCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 16:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhFRUCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 16:02:47 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13421C061574;
        Fri, 18 Jun 2021 13:00:37 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id u11so4599862ljh.2;
        Fri, 18 Jun 2021 13:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6QuBVdrLsWBIw9qblqNt5qVCjcnfhwQloDnEvmIwQRc=;
        b=LVAcp9971d/MurwapYAXElHTIJsaJUhXE8Mrvi4fADDmgT/V7nhnkhhYmg5DROOQaT
         fSRkbstRi28OKOSd3Y3pw5WSZ+6lVwZUGOxc571QAzYfaSqhiUZ/H3AbYyUfehG1n6tY
         u4NjaB7AM0ukbGRyJGnWSmZv3aSYRvOpBJfGDCsz5VZgwCY4ae8gNIrVhFw14uiqIgyK
         03BfBLKnlNVHrFUGrBXTXieaAT0f9z4/GOb4N2E4HzQgWopqpSr0zTVkDw5FIaH4AabM
         uLxelY6Hiv1PNSEcDwiUW4uWEDIl0J5ykvya0vG6HYs0LO+5b1KsyMPTcuzt5ncZU02H
         pFDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6QuBVdrLsWBIw9qblqNt5qVCjcnfhwQloDnEvmIwQRc=;
        b=j/ArBZLfyeahMI0QOgMRbeT+DZhM9TocprXr6/6x/vEEx1EQFAGfQX5RnmhRwGgsuR
         K5N5iyTsEgH0Q2nBQxA2cdEi4hgG2vkwiqQAVixjkiI50YQDpVQS+DUIixRyP6a527n2
         kVU/wSnCZs+hq1zZpGqtfnDoYKsCN6CchNlsz20VKVQTSD67GPvzDI8n5TEm9QHU+USf
         8ODYyjtkB4PZ4K68t3bTimJhg+ZhoAO0lulJqe3I4lkB4NM/dbzDFH39R1suhp4MEvnb
         YPmkLVzUIDggRdEQfPUGeHju4o6PHrzkrX822Nx56rwet+STreGc9T7w/7r3OA9xfRDR
         QyoQ==
X-Gm-Message-State: AOAM533tL0D43U2bUjFzv5mWr6GYOrBdmEvKCJvHiP5wljGKZbQWKwDu
        1htaLnGVZZxgU1agqpDi+/ezVfGgOpw=
X-Google-Smtp-Source: ABdhPJxa8LeyyippqBBNNh6IhRBTYAfMW24aC88Ll+ilCRLcvIjYIw0PBaM/Hv1Z7UoIP80ByFnTug==
X-Received: by 2002:a2e:a22a:: with SMTP id i10mr11075005ljm.425.1624046435318;
        Fri, 18 Jun 2021 13:00:35 -0700 (PDT)
Received: from [192.168.2.145] (94-29-29-31.dynamic.spd-mgts.ru. [94.29.29.31])
        by smtp.googlemail.com with ESMTPSA id g16sm1134194ljn.103.2021.06.18.13.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 13:00:34 -0700 (PDT)
Subject: Re: [BUG] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout (WiFi
 dies)
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <fcf95129-cba7-817d-4bfd-8efaf92f957f@gmail.com>
 <cc328771-0c1d-93e7-cec6-3f4fb7f64d02@broadcom.com>
 <fe3bf47f-7a95-8b58-1d33-c9ba1c8b1ebb@gmail.com>
Message-ID: <f84ec7d1-e4bd-874e-d8dd-296e629edb2a@gmail.com>
Date:   Fri, 18 Jun 2021 23:00:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <fe3bf47f-7a95-8b58-1d33-c9ba1c8b1ebb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

28.05.2021 01:47, Dmitry Osipenko пишет:
> 27.05.2021 19:42, Arend van Spriel пишет:
>> On 5/26/2021 5:10 PM, Dmitry Osipenko wrote:
>>> Hello,
>>>
>>> After updating to Ubuntu 21.04 I found two problems related to the
>>> BRCMF_C_GET_ASSOCLIST using an older BCM4329 SDIO WiFi.
>>>
>>> 1. The kernel is spammed with:
>>>
>>>   ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST
>>> unsupported, err=-52
>>>   ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST
>>> unsupported, err=-52
>>>   ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST
>>> unsupported, err=-52
>>>
>>> Which happens apparently due to a newer NetworkManager version that
>>> pokes dump_station() periodically. I sent [1] that fixes this noise.
>>>
>>> [1]
>>> https://patchwork.kernel.org/project/linux-wireless/list/?series=480715
>>
>> Right. I noticed this one and did not have anything to add to the
>> review/suggestion.
> 
> Please feel free to add yours r-b to the patches if they are good to you.
> 
>>> 2. The other much worse problem is that WiFi eventually dies now with
>>> these errors:
>>>
>>> ...
>>>   ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST
>>> unsupported, err=-52
>>>   brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
>>>   ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST
>>> unsupported, err=-110
>>>   ieee80211 phy0: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg
>>> failed w/status -110
>>>
>>>  From this point all firmware calls start to fail with err=-110 and
>>> WiFi doesn't work anymore. This problem is reproducible with 5.13-rc
>>> and current -next, I haven't checked older kernel versions. Somehow
>>> it's worse using a recent -next, WiFi dies quicker.
>>>
>>> What's interesting is that I see that there is always a pending signal
>>> in brcmf_sdio_dcmd_resp_wait() when timeout happens. It looks like the
>>> timeout happens when there is access to a swap partition, which stalls
>>> system for a second or two, but this is not 100%. Increasing
>>> DCMD_RESP_TIMEOUT doesn't help.
>>
>> The timeout error (-110) can have two root causes that I am aware off.
>> Either the firmware died or the SDIO layer has gone haywire. Not sure if
>> that swap partition is on eMMC device, but if so it could be related.
>> You could try generating device coredump. If that also gives -110 errors
>> we know it is the SDIO layer.
> 
> Coredump is a good idea, thank you. The swap partition is on external SD
> card, everything else is on eMMC.
> 
>>> Please let me know if you have any ideas of how to fix this trouble
>>> properly or if you need need any more info.
>>>
>>> Removing BRCMF_C_GET_ASSOCLIST firmware call entirely from the driver
>>> fixes the problem.
>>
>> My guess is that reducing interaction with firmware is what is avoiding
>> the issue and not so much this specific firmware command. As always it
>> is good to know the conditions in which the issue occurs. What is the
>> hardware platform you are running Ubuntu on? Stuff like that.
> 
> That's an older Acer A500 NVIDIA Tegra20 tablet device [1]. I may also
> try to reproduce problem on Tegra30 Nexus 7 with BCM4330.
> 
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts
> 
> Thank you very much for the suggestions. I will try to collect more info
> and come back with the report.
> 

I was testing this for the past weeks and the problem is not
reproducible anymore. Apparently something got fixed in linux-next. I
haven't tried to bisect the fix since it's a bit too painful to do.

Still there are occasional -110 errors when system stalls on a memory
swap, but WiFi keeps working now.
