Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 473DA8A661
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 20:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfHLSid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 14:38:33 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42512 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfHLSid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 14:38:33 -0400
Received: by mail-wr1-f68.google.com with SMTP id b16so8748186wrq.9
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 11:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kbvx+P+TKkdICRJPZ2BMUpIonnkSB4IgvkOr0PUj3zI=;
        b=ZP4dqGIPbuLyA0aZNphxnhRlYGZu/BNZyP0nN5NzokboM26kT2VL2AZHvF1EtLJMoH
         R0z8eNDzL+QpzK3JGkQO26UfrjYc2WYLYaxzCvbXcR+o8V7/weaNU1f1y6F5moYa28ij
         yWuNKIrulkT9B/7VUu+9HwQyjlTvLF098vTvcCVD9k87ksu2mmrBPDRVsM2BFuMiunjB
         dQKmpQuTNRiWDGfwVzGu7w29pJGDx4SIVkJ9Q1/h0crmX8b/4THnS5SDuVzIT/r7dljm
         kav8s0HSbiPRD2alFE5jskbNuKC6t1v3mw5ZtYRLg5/H6h6r2fbuI1rIN3kR+4eDpbN4
         E7Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kbvx+P+TKkdICRJPZ2BMUpIonnkSB4IgvkOr0PUj3zI=;
        b=UDAUICys9G9av66vBfA/+GPV7xToZrcvBjNn7CU93frhWYOo2CpO0ttfFwdG+mMVhR
         bWicSCFN162UkvSj+jTnIG02iWzLaLgQ4GNV+K9C66q0dDTA7mg2PGHxNmBZ+WAC+Um0
         Go9y3kQjqslFAYJFK12A2bWDfb35fzAgX+wRPAy/jCGsGsv1ZWQgwMjMVrdWMc6FpIic
         W7YTEO6eZ9fhGMIDidJSMZRvEeqRyjpwBThVL0Q2a2ITkBOLgetYF4mgGrVUG5Rs1Jtf
         q/RzVxDwEiYPe9gTbveuv8bLiQEVYKWRKaw1bmY06kcuS9yMivad7y/ZVjwbOuMUlT8/
         N72w==
X-Gm-Message-State: APjAAAVojZf0HM9iUqTdYmaWnQfWezu1Bi8yxbVvduXjGtDucksmU6DF
        XuBoQjKJSM5Dc4elWg4oG/0=
X-Google-Smtp-Source: APXvYqyhBqalBbibQm2xw1+zanQ6nOnglfZTrlVJY4/qaQya1s2Kp2f/aWe7A25noMm7gal8Mg6rVA==
X-Received: by 2002:adf:c594:: with SMTP id m20mr45033072wrg.126.1565635110004;
        Mon, 12 Aug 2019 11:38:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6? (p200300EA8F2F3200E9C14D4C1CCF09D6.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6])
        by smtp.googlemail.com with ESMTPSA id z7sm100431984wrh.67.2019.08.12.11.38.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 11:38:29 -0700 (PDT)
Subject: Re: [PATCH net-next] r8169: make use of xmit_more
To:     =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sander Eikelenboom <linux@eikelenboom.it>
References: <2950b2f7-7460-cce0-d964-ad654d897295@gmail.com>
 <acd65426-0c7e-8c5f-a002-a36286f09122@applied-asynchrony.com>
 <cfb9a1c7-57c8-db04-1081-ac1cb92bb447@applied-asynchrony.com>
 <a19bb3de-a866-d342-7cca-020fef219d03@gmail.com>
 <868a1f4c-5fba-c64b-ea31-30a3770e6a2f@applied-asynchrony.com>
 <f08a3207-0930-4b71-16f1-81e352f87a9c@gmail.com>
 <eecaaf82-e6cd-2b75-5756-006a70258a9f@applied-asynchrony.com>
 <CANn89iKjPz5-EypQ9cb3LRsLJBy1Hr0vLoW6Sjd_Df082H1Yzw@mail.gmail.com>
 <72a58a6b-974c-0feb-2fa4-c8a71c7eff7e@applied-asynchrony.com>
 <06438520-1902-bc7c-7bb2-015dfcdf5457@applied-asynchrony.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <0c1afec7-604c-6621-336e-a56b7ed1c44d@gmail.com>
Date:   Mon, 12 Aug 2019 20:38:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <06438520-1902-bc7c-7bb2-015dfcdf5457@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.08.2019 11:59, Holger Hoffstätte wrote:
> On 8/9/19 10:52 AM, Holger Hoffstätte wrote:
>> On 8/9/19 10:25 AM, Eric Dumazet wrote:
>> (snip)
>>>>
>>>> So that didn't take long - got another timeout this morning during some
>>>> random light usage, despite sg/tso being disabled this time.
>>>> Again the only common element is the xmit_more patch. :(
>>>> Not sure whether you want to revert this right away or wait for 5.4-rc1
>>>> feedback. Maybe this too is chipset-specific?
>>>>
>>>>> Thanks a lot for the analysis and testing. Then I'll submit the disabling
>>>>> of SG on RTL8168evl (on your behalf), independent of whether it fixes
>>>>> the timeout issue.
>>>>
>>>> Got it, thanks!
>>>>
>>>> Holger
>>>
>>> I would try this fix maybe ?
>>>
>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c
>>> b/drivers/net/ethernet/realtek/r8169_main.c
>>> index b2a275d8504cf099cff738f2f7554efa9658fe32..e77628813daba493ad50dab9ac1e3703e38b560c
>>> 100644
>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -5691,6 +5691,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
>>>                   */
>>>                  smp_wmb();
>>>                  netif_stop_queue(dev);
>>> +               door_bell = true;
>>>          }
>>>
>>>          if (door_bell)
>>>
>>
>> Thanks Eric, I'll give that a try and see how it fares over the next few days.
>> It suspiciously looks like it could help..
> 
> Good news everyone!
> 
> After three days non-stop action between two machines and hundreds of GBs
> pushed back and forth: not a single timeout or hiccup. Nice! \o/
> Eric, please send this as a proper patch for -next. Feel free to add my
> Tested-by.
> 
Thanks for the feedback! I can submit the fix with Eric's "Suggested-by".

> cheers
> Holger
> 
Heiner
