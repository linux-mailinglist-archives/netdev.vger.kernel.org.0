Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4F53938CA
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 00:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbhE0Wta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 18:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbhE0Wt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 18:49:29 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F1DC061574;
        Thu, 27 May 2021 15:47:54 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id a5so2536214lfm.0;
        Thu, 27 May 2021 15:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tuFErfKmLPSW2pDEG6U77o1tTeY9ZBhylVoP4RDt4Ss=;
        b=DSGs6n4jWVE8GR/oISRKpkTcZkRqZ1A39y5G4e1oGNApylenW3Ho1FR3x7Fh0BN12O
         0gY1BAYYDv5JlKRSpy10a9P9Q6Z3bUm04y8qPx7eK5ISGcFMlylCq+msaH80pUAgKQZB
         06ez4e3oBLxPRuL0uNWGBMiyrEQqKBMlWP64F0fR0E7y84UuNtceukRWXSaf1wu/jpBP
         jVufZZFxPCTABEqfRz8GZ94+K/3GbU7ucJrq8MRl1wS/XgIwkKMTJ/w7S2kts/zbO9J9
         C7QttwAk/dXYRTFLUsEuswkxvaq0EcX9d4IxFjUB1egSKGwECdFzp7Sd0+n6Goy2SNKy
         Werw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tuFErfKmLPSW2pDEG6U77o1tTeY9ZBhylVoP4RDt4Ss=;
        b=q6+UTj0fQJYe2vlDl8hF4XnTZzWlJMbIM1mmSUSU8bYrdENSMC4SiWjAKitkgM2S6m
         fuiiNdAAA+4M/6C+xDMdRBuCkusjci82XIeOnoD9ogPueIKvSjsStQ3bqDrragbkSkbf
         zsI05ruD55b2FpIDXcFOpudlFod9/pGlKsXxdvcBpVvjeJnM3827CFQ7O9d6S5kQSq7v
         JEjS0DX7L0k2a1fNE6EnXujYyD3AutozCwZKXcKzb/Tu301fRGi6wW98uw1LS0fSrCRH
         EGfUNY+IKPj4f0EVwI2JXDsmu2Ql5/pcLrGnFW/tdP/2ZaUlNjAv0xcZQD3DXOYyMM4q
         tOvQ==
X-Gm-Message-State: AOAM531b1j40wzGf2nK8EF3IBE8yvxlf77bWZzLEtNTqZaPCxRhtN0Me
        P9l2Ez8mkv7c2FqA8Zc+KoE9UbxUQ/I=
X-Google-Smtp-Source: ABdhPJzIsHbe6MXd6NB4bSatrOBZTgSqABnUMzpg9+rxjNeZmHMUlx22rMk7kngwZa20jFRpzdgcpg==
X-Received: by 2002:a19:6a13:: with SMTP id u19mr3715501lfu.252.1622155673149;
        Thu, 27 May 2021 15:47:53 -0700 (PDT)
Received: from [192.168.2.145] (46-138-12-55.dynamic.spd-mgts.ru. [46.138.12.55])
        by smtp.googlemail.com with ESMTPSA id h16sm258660lfc.142.2021.05.27.15.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 15:47:52 -0700 (PDT)
Subject: Re: [BUG] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout (WiFi
 dies)
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
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <fe3bf47f-7a95-8b58-1d33-c9ba1c8b1ebb@gmail.com>
Date:   Fri, 28 May 2021 01:47:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <cc328771-0c1d-93e7-cec6-3f4fb7f64d02@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

27.05.2021 19:42, Arend van Spriel пишет:
> On 5/26/2021 5:10 PM, Dmitry Osipenko wrote:
>> Hello,
>>
>> After updating to Ubuntu 21.04 I found two problems related to the
>> BRCMF_C_GET_ASSOCLIST using an older BCM4329 SDIO WiFi.
>>
>> 1. The kernel is spammed with:
>>
>>   ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST
>> unsupported, err=-52
>>   ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST
>> unsupported, err=-52
>>   ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST
>> unsupported, err=-52
>>
>> Which happens apparently due to a newer NetworkManager version that
>> pokes dump_station() periodically. I sent [1] that fixes this noise.
>>
>> [1]
>> https://patchwork.kernel.org/project/linux-wireless/list/?series=480715
> 
> Right. I noticed this one and did not have anything to add to the
> review/suggestion.

Please feel free to add yours r-b to the patches if they are good to you.

>> 2. The other much worse problem is that WiFi eventually dies now with
>> these errors:
>>
>> ...
>>   ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST
>> unsupported, err=-52
>>   brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
>>   ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST
>> unsupported, err=-110
>>   ieee80211 phy0: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg
>> failed w/status -110
>>
>>  From this point all firmware calls start to fail with err=-110 and
>> WiFi doesn't work anymore. This problem is reproducible with 5.13-rc
>> and current -next, I haven't checked older kernel versions. Somehow
>> it's worse using a recent -next, WiFi dies quicker.
>>
>> What's interesting is that I see that there is always a pending signal
>> in brcmf_sdio_dcmd_resp_wait() when timeout happens. It looks like the
>> timeout happens when there is access to a swap partition, which stalls
>> system for a second or two, but this is not 100%. Increasing
>> DCMD_RESP_TIMEOUT doesn't help.
> 
> The timeout error (-110) can have two root causes that I am aware off.
> Either the firmware died or the SDIO layer has gone haywire. Not sure if
> that swap partition is on eMMC device, but if so it could be related.
> You could try generating device coredump. If that also gives -110 errors
> we know it is the SDIO layer.

Coredump is a good idea, thank you. The swap partition is on external SD
card, everything else is on eMMC.

>> Please let me know if you have any ideas of how to fix this trouble
>> properly or if you need need any more info.
>>
>> Removing BRCMF_C_GET_ASSOCLIST firmware call entirely from the driver
>> fixes the problem.
> 
> My guess is that reducing interaction with firmware is what is avoiding
> the issue and not so much this specific firmware command. As always it
> is good to know the conditions in which the issue occurs. What is the
> hardware platform you are running Ubuntu on? Stuff like that.

That's an older Acer A500 NVIDIA Tegra20 tablet device [1]. I may also
try to reproduce problem on Tegra30 Nexus 7 with BCM4330.

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/tegra20-acer-a500-picasso.dts

Thank you very much for the suggestions. I will try to collect more info
and come back with the report.
