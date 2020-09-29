Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A230127D718
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 21:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgI2Tlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 15:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728771AbgI2Tlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 15:41:39 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0788BC061755;
        Tue, 29 Sep 2020 12:41:39 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id j2so7703036eds.9;
        Tue, 29 Sep 2020 12:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zlMyFBmbzW5FxZuomqtfTXpo4COGWABRi6GcA0YobZY=;
        b=Cd5lM82ciKx1rQ9ZAa5+VHQDFS9b7Hr2lPGd1nCNi+hdwpVC2TzwJHrXh9SXqU0TB6
         +9NJGVGAR2AxmBzR6Wab4CDPfAruI2OaHEFX+N/zdHrGTkshhuMTKR6K7a8Os/25p/3e
         q0dusZdlgCNYwXjo40vizlTEIsERLS3KCWUpETKFK7OPtSxT079CfJvobR8r+Q4LjMx6
         XFMlyExn35/PnDRDcZ+Es5SNzsXf2bPJw+bEbEBGLDIfvC+p+l87VdtqmiavK4b+Cjva
         jvVajofBhvcM/srNfXlN7Q4OF4md/v87pTomvgd9zDOYcKojDDURG2eBvaPcxsKql3HR
         k3cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zlMyFBmbzW5FxZuomqtfTXpo4COGWABRi6GcA0YobZY=;
        b=DGks0JjXEC/24lEcQrTSOF5Wtg98k0QuEXE0ndRW1QEtuV3q1IUyYVJckTFfTx+Mk9
         fVJdKaPRqYCi43waqXaJQ0Mtn4+YEWol08Qvg2Kq0QLpGvCPlEuRwKKzvsEhymcChkY3
         aRzqwyikophhhl+LrHMDot50ZAlcxDGjFGHWnZ+dKh975BY/bDYfKMkjgWdFRUsVezKP
         lL5UxEuKngjkjZtroFvaEBi9rZWYGcvfGIRr0ytTG5MjN4FEQUiYntvM9Zdw2rRDvMT/
         S+frcGCRlQu3ZQdfRDMLzRJdKyIrNffTFzG+9hSkM47qGMsS39Q+8D4tGwF5D1ZigLqs
         NJow==
X-Gm-Message-State: AOAM530oaxBZtsK3cI0gshZvJWpV1ODPahy1kGzK7P7dkIfvjv4wONvL
        NrXdU9Ssreh8VkzWoDFepNaR+Mg4Kd0=
X-Google-Smtp-Source: ABdhPJxdVWjR59wJqVzYNb1ZZnoTGAQscivoC0mSo/iFa5jzBzOV1HbJcpA8SV3Sht9E2bdk2e97EA==
X-Received: by 2002:aa7:cb83:: with SMTP id r3mr4946860edt.35.1601408497156;
        Tue, 29 Sep 2020 12:41:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:f1df:74ef:35e5:214d? (p200300ea8f006a00f1df74ef35e5214d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:f1df:74ef:35e5:214d])
        by smtp.googlemail.com with ESMTPSA id b6sm6797989eds.46.2020.09.29.12.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 12:41:36 -0700 (PDT)
Subject: Re: RTL8402 stops working after hibernate/resume
To:     Petr Tesarik <ptesarik@suse.cz>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org, linux-clk@vger.kernel.org
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
 <aa997635-a5b5-75e3-8a30-a77acb2adf35@gmail.com>
 <20200925115241.3709caf6@ezekiel.suse.cz>
 <20200925145608.66a89e73@ezekiel.suse.cz>
 <30969885-9611-06d8-d50a-577897fcab29@gmail.com>
 <20200929210737.7f4a6da7@ezekiel.suse.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3132f91a-505d-6e56-be97-334593f8ca12@gmail.com>
Date:   Tue, 29 Sep 2020 21:41:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200929210737.7f4a6da7@ezekiel.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.09.2020 21:07, Petr Tesarik wrote:
> Hi Heiner (and now also Hans)!
> 
> @Hans: I'm adding you to this conversation, because you're the author
> of commit b1e3454d39f99, which seems to break the r8169 driver on a
> laptop of mine.
> 
> On Fri, 25 Sep 2020 16:47:54 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> On 25.09.2020 14:56, Petr Tesarik wrote:
>>> On Fri, 25 Sep 2020 11:52:41 +0200
>>> Petr Tesarik <ptesarik@suse.cz> wrote:
>>>   
>>>> On Fri, 25 Sep 2020 11:44:09 +0200
>>>> Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>  
>>>>> On 25.09.2020 10:54, Petr Tesarik wrote:    
>>>> [...]  
>>>>>> Does it make sense to bisect the change that broke the driver for me, or should I rather dispose of this waste^Wlaptop in an environmentally friendly manner? I mean, would you eventually accept a workaround for a few machines with a broken BIOS?
>>>>>>       
>>>>> If the workaround is small and there's little chance to break other stuff: then usually yes.
>>>>> If you can spend the effort to bisect the issue, this would be appreciated.    
>>>>
>>>> OK, then I'm going to give it a try.  
>>>
>>> Done. The system freezes when this commit is applied:
>>>
>>> commit 9f0b54cd167219266bd3864570ae8f4987b57520
>>> Author: Heiner Kallweit <hkallweit1@gmail.com>
>>> Date:   Wed Jun 17 22:55:40 2020 +0200
>>>
>>>     r8169: move switching optional clock on/off to pll power functions
>>>   
>> This sounds weird. On your system tp->clk should be NULL, making
>> clk_prepare_enable() et al no-ops. Please check whether tp->clk
>> is NULL after the call to rtl_get_ether_clk().
> 
> This might be part of the issue. On my system tp->clk is definitely not
> NULL:
> 
OK, interesting. The referenced patch changes driver behavior in a way
that ether_clk is disabled again in probe(), and only re-enabled
in ndo_open(). This should be helpful from a power-saving perspective
because before that we enabled the clock even if the network device
wasn't used.
It seems however that disabling ether_clk has (at least on your system)
side effects causing a system freeze. That's a best guess from my side
however, and not really something I can comment on.

> crash> *rtl8169_private.clk 0xffff9277aca58940
>   clk = 0xffff9277ac2c82a0
> 
> crash> *clk 0xffff9277ac2c82a0
> struct clk {
>   core = 0xffff9277aef65d00, 
>   dev = 0xffff9277aed000b0, 
>   dev_id = 0xffff9277aec60c00 "0000:03:00.2", 
>   con_id = 0xffff9277ad04b080 "ether_clk", 
>   min_rate = 0, 
>   max_rate = 18446744073709551615, 
>   exclusive_count = 0, 
>   clks_node = {
>     next = 0xffff9277ad2428d8, 
>     pprev = 0xffff9277aef65dc8
>   }
> }
> 
> The dev_id corresponds to the Ethernet controller:
> 
> 03:00.2 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL810xE PCI Express Fast Ethernet controller (rev 06)
> 
> Looking at clk_find(), it matches this entry in clocks:
> 
> struct clk_lookup {
>   node = {
>     next = 0xffffffffbc702f40, 
>     prev = 0xffff9277bf7190c0
>   }, 
>   dev_id = 0x0, 
>   con_id = 0xffff9277bf719524 "ether_clk", 
>   clk = 0x0, 
>   clk_hw = 0xffff9277ad2427f8
> }
> 
> That's because this kernel is built with CONFIG_PMC_ATOM=y, and looking
> at the platform initialization code, the "ether_clk" alias is created
> unconditionally. Hans already added.
> 
> Petr T
> 

