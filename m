Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEADC1A081E
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 09:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgDGHUl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Apr 2020 03:20:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36739 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbgDGHUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 03:20:40 -0400
Received: from mail-pg1-f198.google.com ([209.85.215.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jLiXG-0001cn-0I
        for netdev@vger.kernel.org; Tue, 07 Apr 2020 07:20:38 +0000
Received: by mail-pg1-f198.google.com with SMTP id j16so1774561pga.1
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 00:20:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=D9wpwa0NndfexX1TCjkujJJlqtFXso1cUg7215eV4lg=;
        b=Pts1Bm8FkzEVvILQTzPhUinNwRmnPMVSY22qkgYmf+uCCjuq6l7enB5w1lLWoXNAkd
         tEPeDXB4nOqIkELUYjCg/W4cIcDSzNC4oSTqYNDbLHNXVG0ehPRf4yXK4wozDNOeHNQY
         VE2Htw5U8xowmbpf/669Ezl9TtTNM7xRJy829iYLfE8dmB6X2fAkO4uf8YSsmKQX2D+q
         I8/XSNCfeEIADHWxKi/a3UCu1FkXFPt+DBVQnodHDBIYEodOSCe9US3eyjIjKtm8ND24
         hWeA3UzY3W8tDvj57fbPJ9yJJ1VGYD4Gdz/odCZDWIlvpARz52OozTDU6t9ahiLoMSgO
         Rp8g==
X-Gm-Message-State: AGi0Pua3Md+zYsvY+tqCaCCTMMWP3EeHzyOxJmR1NVm8zPEf8lDKxh2+
        wRqjmkaSqOo3/WnCIfzNfjurJtFliAzwujUyndlg1FSLOoEcwEKESOXi+uWcqbZPhz3bfoMkERR
        ItdIjx5pTsGcE5krZ9M/tAO7wgL/FmIRMkQ==
X-Received: by 2002:a63:8442:: with SMTP id k63mr728453pgd.11.1586244036553;
        Tue, 07 Apr 2020 00:20:36 -0700 (PDT)
X-Google-Smtp-Source: APiQypIvttWs2PpNx5F/azwXTq270G+WVg1/eAhpUeAmVFhMz6KQT9Cf1f83uAYabfusCXHjXis5cA==
X-Received: by 2002:a63:8442:: with SMTP id k63mr728433pgd.11.1586244036201;
        Tue, 07 Apr 2020 00:20:36 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id w138sm13528050pff.145.2020.04.07.00.20.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Apr 2020 00:20:35 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] rtw88: Add delay on polling h2c command status bit
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <87k12syanf.fsf@kamboji.qca.qualcomm.com>
Date:   Tue, 7 Apr 2020 15:20:33 +0800
Cc:     Tony Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:REALTEK WIRELESS DRIVER (rtw88)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <E3E792CF-AC1A-466E-A1B2-F1CFAE9BC673@canonical.com>
References: <20200406093623.3980-1-kai.heng.feng@canonical.com>
 <87v9mczu4h.fsf@kamboji.qca.qualcomm.com>
 <94EAAF7E-66C5-40E2-B6A9-0787CB13A3A9@canonical.com>
 <87zhboycfr.fsf@kamboji.qca.qualcomm.com>
 <83B3A3D8-833A-42BE-9EB0-59C95B349B01@canonical.com>
 <87k12syanf.fsf@kamboji.qca.qualcomm.com>
To:     Kalle Valo <kvalo@codeaurora.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 6, 2020, at 22:03, Kalle Valo <kvalo@codeaurora.org> wrote:
> 
> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
> 
>>> On Apr 6, 2020, at 21:24, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> 
>>> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>>> 
>>>>> On Apr 6, 2020, at 20:17, Kalle Valo <kvalo@codeaurora.org> wrote:
>>>>> 
>>>>> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>>>>> 
>>>>>> --- a/drivers/net/wireless/realtek/rtw88/hci.h
>>>>>> +++ b/drivers/net/wireless/realtek/rtw88/hci.h
>>>>>> @@ -253,6 +253,10 @@ rtw_write8_mask(struct rtw_dev *rtwdev, u32
>>>>>> addr, u32 mask, u8 data)
>>>>>> 	rtw_write8(rtwdev, addr, set);
>>>>>> }
>>>>>> 
>>>>>> +#define rr8(addr)      rtw_read8(rtwdev, addr)
>>>>>> +#define rr16(addr)     rtw_read16(rtwdev, addr)
>>>>>> +#define rr32(addr)     rtw_read32(rtwdev, addr)
>>>>> 
>>>>> For me these macros reduce code readability, not improve anything. They
>>>>> hide the use of rtwdev variable, which is evil, and a name like rr8() is
>>>>> just way too vague. Please keep the original function names as is.
>>>> 
>>>> The inspiration is from another driver.
>>>> readx_poll_timeout macro only takes one argument for the op.
>>>> Some other drivers have their own poll_timeout implementation,
>>>> and I guess it makes sense to make one specific for rtw88.
>>> 
>>> I'm not even understanding the problem you are tying to fix with these
>>> macros. The upstream philosopyhy is to have the source code readable and
>>> maintainable, not to use minimal number of characters. There's a reason
>>> why we don't name our functions a(), b(), c() and so on.
>> 
>> The current h2c polling doesn't have delay between each interval, so
>> the polling is too fast and the following logic considers it's a
>> timeout.
>> The readx_poll_timeout() macro provides a generic mechanism to setup
>> an interval delay and timeout which is what we need here.
>> However readx_poll_timeout only accepts one parameter which usually is
>> memory address, while we need to pass both rtwdev and address.
>> 
>> So if hiding rtwdev is evil, we can roll our own variant of
>> readx_poll_timeout() to make the polling readable.
> 
> Can't you do:
> 
> ret = read_poll_timeout(rtw_read8, box_state,
>                        !((box_state >> box) & 0x1), 100,
>                        3000, false, rtw_dev, REG_HMETFR);
> 
> No ugly macros needed and it should function the same. But I did not
> test this in any way, so no idea if it even compiles.

Yes that will do. Didn't notice the recently added macro.

Will send v2.

Kai-Heng

> 
> -- 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

