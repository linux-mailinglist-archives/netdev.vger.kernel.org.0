Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F4A326369
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 14:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhBZNcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 08:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhBZNcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 08:32:22 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E52C061756;
        Fri, 26 Feb 2021 05:31:41 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d11so8589447wrj.7;
        Fri, 26 Feb 2021 05:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uv4P+wZkM1Ynsz0Cm9jwXSe3oAHXk0msrel10FRfOrI=;
        b=Fei8U9r+e5KKC2dQFd/Ur841UE0E6jdDC1HgD2FMZbTNzQgTWkI5C4rWpRsRj1U8gA
         t9MFHDv31OcIJMJrxb6DWKhYSchb68ATdjv8Ek6TH5VDPOOrTeLZKxpEPklguPjYUGRD
         OMoxI53Yid8uNW7Jce93nazMBEONmdaf9FFZB1l/wgljYaeHALDGaoia6TpfL5DPYWWC
         3BzV2wjSlADSew+le/6gJggUK/1WWe8NymSqGOPPq7EzjihigxxAUVH+EFNYFQFA/dOG
         1sIdECVVRE8dNGvyXYxS34n9WHUXESUPLfpHmVPoDYvtUdPjKmAFe5+Js4+OtqpxiCaO
         NMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uv4P+wZkM1Ynsz0Cm9jwXSe3oAHXk0msrel10FRfOrI=;
        b=oACPcbHUIl6jKHxSiO2fn71YAY/LeDbABrE3WR/11mXNNZeutvvUXPCkKyrux5dpho
         F1SWfo/phFyP2w99hXQ/ZlU902Hs0kUScVeW1muLTfnkJ3sYNuiSmArh4z6608boljxb
         dXgVWfJf17ajG3PyvLdQrU3/JYx1ZXQpWbd4x0YvR0AWYO/mBJazgG+VJQ1I5yyUyOhV
         7TWpka4JuUxxteq1N4zC3E6ARO/15Xdkr1uVc/HgNeoNfMcHtSdjVEvPDDEcIISCRHRm
         bODI0919ojDjMcMojVbXzPoSOv4lqZHeYJ6rpeLfhfYsu/vCQqb7LTJxgGdC0sp/1AWL
         IVRQ==
X-Gm-Message-State: AOAM530a+0TW3f/T81FTmZpDlilDdBqJ86x/C96h9nLYwY+RCofRnTld
        sqy6k2u+XjKFr2KO9hAZ6ACHwvJexfqOPw==
X-Google-Smtp-Source: ABdhPJzhKLTCqatB6+aKm/67uknQiCpu7em3IBy7br7VogpmI75VF7T2jrs0Xr1u/ja114Clagv/4g==
X-Received: by 2002:adf:f303:: with SMTP id i3mr3205179wro.67.1614346299619;
        Fri, 26 Feb 2021 05:31:39 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:3483:8cf6:25ff:155b? (p200300ea8f395b0034838cf625ff155b.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:3483:8cf6:25ff:155b])
        by smtp.googlemail.com with ESMTPSA id c26sm13162014wrb.87.2021.02.26.05.31.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 05:31:39 -0800 (PST)
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
References: <20210225174041.405739-1-kai.heng.feng@canonical.com>
 <20210225174041.405739-3-kai.heng.feng@canonical.com>
 <87o8g7e20e.fsf@codeaurora.org>
 <0e8ba5a4-0029-6966-e4ab-265a538f3b3d@gmail.com>
 <CAAd53p6tWUn-QbCysL_KweREmpSNfiQa7-gHgndqGta2UWt0=Q@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 3/3] PCI: Convert rtw88 power cycle quirk to shutdown
 quirk
Message-ID: <6db9e75e-52a7-4316-bfd8-cf44b4875f44@gmail.com>
Date:   Fri, 26 Feb 2021 14:31:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CAAd53p6tWUn-QbCysL_KweREmpSNfiQa7-gHgndqGta2UWt0=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.02.2021 13:18, Kai-Heng Feng wrote:
> On Fri, Feb 26, 2021 at 8:10 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 26.02.2021 08:12, Kalle Valo wrote:
>>> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>>>
>>>> Now we have a generic D3 shutdown quirk, so convert the original
>>>> approach to a PCI quirk.
>>>>
>>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>>> ---
>>>>  drivers/net/wireless/realtek/rtw88/pci.c | 2 --
>>>>  drivers/pci/quirks.c                     | 6 ++++++
>>>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>>
>>> It would have been nice to CC linux-wireless also on patches 1-2. I only
>>> saw patch 3 and had to search the rest of patches from lkml.
>>>
>>> I assume this goes via the PCI tree so:
>>>
>>> Acked-by: Kalle Valo <kvalo@codeaurora.org>
>>>
>>
>> To me it looks odd to (mis-)use the quirk mechanism to set a device
>> to D3cold on shutdown. As I see it the quirk mechanism is used to work
>> around certain device misbehavior. And setting a device to a D3
>> state on shutdown is a normal activity, and the shutdown() callback
>> seems to be a good place for it.
>> I miss an explanation what the actual benefit of the change is.
> 
> To make putting device to D3 more generic, as there are more than one
> device need the quirk.
> 
> Here's the discussion:
> https://lore.kernel.org/linux-usb/00de6927-3fa6-a9a3-2d65-2b4d4e8f0012@linux.intel.com/
> 

Thanks for the link. For the AMD USB use case I don't have a strong opinion,
what's considered the better option may be a question of personal taste.
For rtw88 however I'd still consider it over-engineering to replace a simple
call to pci_set_power_state() with a PCI quirk.
I may be biased here because I find it sometimes bothering if I want to
look up how a device is handled and in addition to checking the respective
driver I also have to grep through quirks.c whether there's any special
handling.

> Kai-Heng
> 
Heiner
