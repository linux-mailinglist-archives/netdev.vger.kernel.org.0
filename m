Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB91278447
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 11:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgIYJoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 05:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbgIYJoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 05:44:16 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD837C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 02:44:15 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id a9so2564401wmm.2
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 02:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZepJRzFEZ7iYRbekeVSxptlgge8xWwLfBOKpjwT+Ea0=;
        b=gk3/SuP07nK2Wn+HtIi3BjM0+XQSfnbU8Z5MbTqpgvmOwqqiXmeLg8NcZguQwnqFM6
         zvFsvZ/Y5Zua+GHJf94UgpeulFzrwBX2qhRd8Sfsm37jrH6+aew5GvCT2HJchwhBwPrD
         GBNnzx223ZjZ8zfVpM4RPFKiCO36xj0fwyVaAsZ/2jMmEAEAk1Q9y79TY+gbnTgJyRrR
         NCyRQ/bucjb+AU4aKHLxhfbI+7xChA61MkwgElgSbEVqAKgk7xlMkCIJfFWD28ykWTvG
         Kmmt8cC1UCeROlJBsjKWzxvTBARHhGpHRSSce1wJ7MVBfrbXWdfOPWyKbJtvSmDumI01
         Heow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZepJRzFEZ7iYRbekeVSxptlgge8xWwLfBOKpjwT+Ea0=;
        b=DyOOPw65ILpY3Y8toxtPgMu6k7Ks+qpsBRZExxBwNxbjh7t52cGmO+s4ZAL2RkO9/C
         +BIJd6zHnugobxtIl/wA9DdXg4++WeYVGTdReGx8aqlgoiSDM8MZ+N+xpOCSx1ctFMHm
         L1Sczk0gYySNxzP1Y2izF+NMFhtUceVBkVtY9RDP/LyHF0ZMNVKPXdOKAsxGtiee01la
         R4s3a3l5CDJwDDC9V5VFiyvQzLD704OCyh3x8GlE3vXHZU0dZ3FDveeKgqOuKQ6e3zRc
         3xLneItpZqvnLrduvbBA1Sp2y0U0kzM7DzO9etVvWcZALyV/BscayBFt5fpOMpTxX0Cr
         ++hw==
X-Gm-Message-State: AOAM5302efr175Y1tpTSW9iXnpazp8KTn6QzombD9ejGHDPj+ak8LDmt
        dOKCL0a3IjJUOMBEeJ9w2Ey5OrulTas=
X-Google-Smtp-Source: ABdhPJwpjiGdClpVGxL1ZhGb4MX9oALnHb7R/yaaM2M2ifXtjMY72OtIOvJsX3t4lzT9n31yWTc6EA==
X-Received: by 2002:a1c:2e4b:: with SMTP id u72mr2193447wmu.69.1601027054254;
        Fri, 25 Sep 2020 02:44:14 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:4d7a:f898:eecc:8621? (p200300ea8f2357004d7af898eecc8621.dip0.t-ipconnect.de. [2003:ea:8f23:5700:4d7a:f898:eecc:8621])
        by smtp.googlemail.com with ESMTPSA id z13sm2202122wro.97.2020.09.25.02.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 02:44:13 -0700 (PDT)
Subject: Re: RTL8402 stops working after hibernate/resume
To:     Petr Tesarik <ptesarik@suse.cz>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
 <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
 <20200716105835.32852035@ezekiel.suse.cz>
 <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
 <20200903104122.1e90e03c@ezekiel.suse.cz>
 <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
 <20200924211444.3ba3874b@ezekiel.suse.cz>
 <a10f658b-7fdf-2789-070a-83ad5549191a@gmail.com>
 <20200925093037.0fac65b7@ezekiel.suse.cz>
 <20200925105455.50d4d1cc@ezekiel.suse.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <aa997635-a5b5-75e3-8a30-a77acb2adf35@gmail.com>
Date:   Fri, 25 Sep 2020 11:44:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200925105455.50d4d1cc@ezekiel.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.09.2020 10:54, Petr Tesarik wrote:
> On Fri, 25 Sep 2020 09:30:37 +0200
> Petr Tesarik <ptesarik@suse.cz> wrote:
> 
>> On Thu, 24 Sep 2020 22:12:24 +0200
>> Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>>> On 24.09.2020 21:14, Petr Tesarik wrote:  
>>>> On Wed, 23 Sep 2020 11:57:41 +0200
>>>> Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>   
>>>>> On 03.09.2020 10:41, Petr Tesarik wrote:  
>>>>>> Hi Heiner,
>>>>>>
>>>>>> this issue was on the back-burner for some time, but I've got some
>>>>>> interesting news now.
>>>>>>
>>>>>> On Sat, 18 Jul 2020 14:07:50 +0200
>>>>>> Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>>>     
>>>>>>> [...]
>>>>>>> Maybe the following gives us an idea:
>>>>>>> Please do "ethtool -d <if>" after boot and after resume from suspend,
>>>>>>> and check for differences.    
>>>>>>
>>>>>> The register dump did not reveal anything of interest - the only
>>>>>> differences were in the physical addresses after a device reopen.
>>>>>>
>>>>>> However, knowing that reloading the driver can fix the issue, I copied
>>>>>> the initialization sequence from init_one() to rtl8169_resume() and
>>>>>> gave it a try. That works!
>>>>>>
>>>>>> Then I started removing the initialization calls one by one. This
>>>>>> exercise left me with a call to rtl_init_rxcfg(), which simply sets the
>>>>>> RxConfig register. In other words, these is the difference between
>>>>>> 5.8.4 and my working version:
>>>>>>
>>>>>> --- linux-orig/drivers/net/ethernet/realtek/r8169_main.c	2020-09-02 22:43:09.361951750 +0200
>>>>>> +++ linux/drivers/net/ethernet/realtek/r8169_main.c	2020-09-03 10:36:23.915803703 +0200
>>>>>> @@ -4925,6 +4925,9 @@
>>>>>>  
>>>>>>  	clk_prepare_enable(tp->clk);
>>>>>>  
>>>>>> +	if (tp->mac_version == RTL_GIGA_MAC_VER_37)
>>>>>> +		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_DMA_BURST);
>>>>>> +
>>>>>>  	if (netif_running(tp->dev))
>>>>>>  		__rtl8169_resume(tp);
>>>>>>  
>>>>>> This is quite surprising, at least when the device is managed by
>>>>>> NetworkManager, because then it is closed on wakeup, and the open
>>>>>> method should call rtl_init_rxcfg() anyway. So, it might be a timing
>>>>>> issue, or incorrect order of register writes.
>>>>>>     
>>>>> Thanks for the analysis. If you manually bring down and up the
>>>>> interface, do you see the same issue?  
>>>>
>>>> I'm not quite sure what you mean, but if the interface is configured
>>>> (and NetworkManager is stopped), I can do 'ip link set eth0 down' and
>>>> then 'ip link set eth0 up', and the interface is fully functional.
>>>>   
>>>>> What is the value of RxConfig when entering the resume function?  
>>>>
>>>> I added a dev_info() to rtl8169_resume(). First with NetworkManager
>>>> active (i.e. interface down on suspend):
>>>>
>>>> [  525.956675] r8169 0000:03:00.2: RxConfig after resume: 0x0002400f
>>>>
>>>> Then I re-tried with NetworkManager stopped (i.e. interface up on
>>>> suspend). Same result:
>>>>
>>>> [  785.413887] r8169 0000:03:00.2: RxConfig after resume: 0x0002400f
>>>>
>>>> I hope that's what you were asking for...
>>>>
>>>> Petr T
>>>>   
>>>
>>> rtl8169_resume() has been changed in 5.9, therefore the patch doesn't
>>> apply cleanly on older kernel versions. Can you test the following
>>> on a 5.9-rc version or linux-next?  
>>
>> I tried installing 5.9-rc6, but it freezes hard at boot, last message is:
>>
>> [   14.916259] libphy: r8169: probed
>>

This doesn't necessarily mean that the r8169 driver crashes the system.
Other things could run in parallel. It freezes w/o any message?

>> At this point, I suspect you're right that the BIOS is seriously buggy.
>> Let me check if ASUSTek has released any update for this model.
> 
> Hm, it took me about an hour wondering why I cannot flash the 314 update, but then I finally noticed that this was for X543, while mine is an X453... *sigh*
> 
> So, I'm at BIOS version 214, released in 2015, and that's the latest version. There are some older versions available, but the BIOS Flash utility won't let me downgrade.
> 
> Does it make sense to bisect the change that broke the driver for me, or should I rather dispose of this waste^Wlaptop in an environmentally friendly manner? I mean, would you eventually accept a workaround for a few machines with a broken BIOS?
> 
If the workaround is small and there's little chance to break other stuff: then usually yes.
If you can spend the effort to bisect the issue, this would be appreciated.


> Petr T
> 
Heiner
