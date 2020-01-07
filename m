Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D01F132B0C
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 17:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgAGQXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 11:23:36 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37401 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbgAGQXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 11:23:35 -0500
Received: by mail-lf1-f68.google.com with SMTP id b15so153627lfc.4;
        Tue, 07 Jan 2020 08:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O/bmJUGYaSPiqae8SdBJMnI+D+zAGfBGbWHgwMFDxAM=;
        b=Ew8tukmrLS5wGQ4OZbkjMjsfJxlwUD62IHCNMH421sapQiIkB2oJw0qwjbVNFnmTq+
         a9KbU1u5Vwo0m4+Vkocvo1iVm4ZtiDsLJDE6oIt2s969KD8Yu8ci0vHUWrNrya8xaXxa
         a7MMLBIrcNUijX7vTsidwADS01DuuNC7FumdIgC8eT2cirle/makwZWqJfyWO5MzSuO5
         9IhdHOyhSuMgMjEXUuxmRrmLtjrAhgVWn++Ui2BIhIMOCQoAGE3T/bD7OlumzssyiXvX
         FTn9qDWprappNDJ7GzrtGD954TgBaCMwy4OFdCJZX7cKGebCtQ4N8CnX9+y60bxxn8AU
         hLMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O/bmJUGYaSPiqae8SdBJMnI+D+zAGfBGbWHgwMFDxAM=;
        b=baxWpPJpLKqPCvEAP2tZx5wkrw4TeB5+pXChNN19RkXFIpq3fge1bIWyJSUYH4CsDN
         nr+N1pcH+5EMyEmaVlqK7u1+vbSvOdKYdF3sbtDzwwx5/gsbgcyoq6AwmmwIiCuVMs1t
         ZOeXZ/IDenJn+8JYf4Rahw5DkDdg4sZDnJCdBanCBbLcxFtdNvTuLgDtV51pXOw8/rGy
         bCRQZpX2WCtJM3/q9ysLqOsVThmG/9axLX9jYUvPRmodjruS9TazeD5tsjYn0rg1AhCR
         4+ghxCSOnrqyVi5uYi5MrKYQfoVP7jsUU4XPDwgwcwDk+Sl8TzdainYBJs/VBYTiDswv
         C/YA==
X-Gm-Message-State: APjAAAV06pxiBbU0vNKSohOSR/bqlFA4Zxcul0DQXPUyYdoc8oh39XJr
        /2uumSXprINh6XJaDrh/LuSOHCjO
X-Google-Smtp-Source: APXvYqwzd16CLdeHDTjCg1TkpuQJdYa209eu5WrMIGe+3aJfzsD/JpNoIONEe/yU7+uDuc8u2dqkcA==
X-Received: by 2002:a19:710a:: with SMTP id m10mr177115lfc.58.1578414213714;
        Tue, 07 Jan 2020 08:23:33 -0800 (PST)
Received: from [192.168.2.145] (79-139-233-37.dynamic.spd-mgts.ru. [79.139.233.37])
        by smtp.googlemail.com with ESMTPSA id m16sm54962ljb.47.2020.01.07.08.23.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 08:23:33 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: sdio: Fix OOB interrupt initialization on
 brcm43362
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        hdegoede@redhat.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, kvalo@codeaurora.org, davem@davemloft.net
References: <20191226092033.12600-1-jean-philippe@linaro.org>
 <16f419a7070.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <141f055a-cd1d-66cb-7052-007cda629d3a@gmail.com>
 <20200106191919.GA826263@myrica>
 <c2bb1067-9b9c-3be1-b87e-e733a668a056@gmail.com>
 <20200107072354.GA832497@myrica>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <34dbd037-0a40-bf5f-4988-6b821811ffcd@gmail.com>
Date:   Tue, 7 Jan 2020 19:23:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200107072354.GA832497@myrica>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

07.01.2020 10:23, Jean-Philippe Brucker пишет:
> On Tue, Jan 07, 2020 at 02:15:18AM +0300, Dmitry Osipenko wrote:
>> 06.01.2020 22:19, Jean-Philippe Brucker пишет:
>>> Hi Dmitry,
>>>
>>> On Thu, Dec 26, 2019 at 05:37:58PM +0300, Dmitry Osipenko wrote:
>>>> I haven't seen any driver probe failures due to OOB on NVIDIA Tegra,
>>>> only suspend-resume was problematic due to the unbalanced OOB
>>>> interrupt-wake enabling.
>>>>
>>>> But maybe checking whether OOB interrupt-wake works by invoking
>>>> enable_irq_wake() during brcmf_sdiod_intr_register() causes trouble for
>>>> the cubietruck board.
>>>>
>>>> @Jean-Philippe, could you please try this change (on top of recent
>>>> linux-next):
>>>
>>> Sorry for the delay, linux-next doesn't boot for me at the moment and I
>>> have little time to investigate why, so I might retry closer to the merge
>>> window.
>>>
>>> However, isn't the interrupt-wake issue independent from the problem
>>> (introduced in v4.17) that my patch fixes? I applied "brcmfmac: Keep OOB
>>> wake-interrupt disabled when it shouldn't be enabled" on v5.5-rc5 and it
>>> doesn't seem to cause a regression, but the wifi only works if I apply my
>>> patch as well.
>>>
>>> Thanks,
>>> Jean
>>>
>>>>
>>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
>>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
>>>> index b684a5b6d904..80d7106b10a9 100644
>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
>>>> @@ -115,13 +115,6 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev
>>>> *sdiodev)
>>>>                 }
>>>>                 sdiodev->oob_irq_requested = true;
>>>>
>>>> -               ret = enable_irq_wake(pdata->oob_irq_nr);
>>>> -               if (ret != 0) {
>>>> -                       brcmf_err("enable_irq_wake failed %d\n", ret);
>>>> -                       return ret;
>>>> -               }
>>>> -               disable_irq_wake(pdata->oob_irq_nr);
>>>> -
>>>>                 sdio_claim_host(sdiodev->func1);
>>>>
>>>>                 if (sdiodev->bus_if->chip == BRCM_CC_43362_CHIP_ID) {
>>
>> Hello Jean,
>>
>> Could you please clarify whether you applied [1] and then the above
>> snippet on top of it or you only applied [1] without the snippet?
> 
> I applied [1] without the snippet
> 
> Thanks,
> Jean
> 
>>
>> [1] brcmfmac: Keep OOB wake-interrupt disabled when it shouldn't be enabled

Will you be able to test *with* the snippet? I guess chances that it
will make any difference are not high, nevertheless will be good to know
for sure.
