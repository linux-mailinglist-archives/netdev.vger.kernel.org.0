Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730A235624F
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhDGEVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhDGEVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 00:21:13 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C23BC06174A;
        Tue,  6 Apr 2021 21:21:03 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id v25so17483993oic.5;
        Tue, 06 Apr 2021 21:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/XZ12tDSYVU0U9fflHiz4qwFb4uwVQ2tMGE45b/fFLk=;
        b=uK24F8jDkvhj5FisttFco2tUz9iM3rrcWtEiR2yZhlygP1BrKnYKiVN+uciMeVyhWJ
         xaXVe4IIkiF5Ciz9wfkhNAsNNPpt0v7pj4CkyS2sF/Z1Xhf15usUYQCSoU7b9Qi6370N
         uzwiYPdIpMEpqV4Ty3i6hZGkiuVZhuF+jZmNWScaScRpeDXENhYzZ2N165g/oDO2zl1T
         ROSD+X6aDZYN2bHrQWLWbt83isQFxJjpPNmUbELBCXY24ZTxUFOEoOt6DHl64UcJv7Fa
         Zohy53yTaWlkW9mbX2mTe3TBN/JOGEO81YnIwk9QyYzFI2PiyjuvTliIdVWQ0R9+qtnR
         9gsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/XZ12tDSYVU0U9fflHiz4qwFb4uwVQ2tMGE45b/fFLk=;
        b=KDr0mj6T/9EjVnk+t5hOKHUPHPsO5DdknSjqUGPYrFTaB3TGuF9EA7Fdm4ghyqOjvZ
         a2imdbwTJS8z+9vGNDGHdaM3uOjKOFRuZ+ATdMalxl+DISpdx/3aXFeKfvmxfmHVr8oJ
         jz0D1r4PiuYzytoMJPvVat6GWiJmW+MLsV2iXZ4xYrzsOOtU+or/wwwDUc09TZA/V/YL
         rK+j1BQxsZpCCZ+rapW6B8u319mv8HJof7tk/wNhgpdJHj5VYi4sqOX0mu2V41smeVz9
         Fuy1gzRqPd7MiMXshHht58DnkO1abHBlWLt5LyIZCE38Q2hL7tyym98fiK3q4uxA7Yt8
         8CGw==
X-Gm-Message-State: AOAM533kiMO4cPFQAf8i0eqAokXQKl2+Y8BXo3a3dfW+yKiAGgMjvPu3
        yiGd6KYrXos3mI9FlU1d9jA=
X-Google-Smtp-Source: ABdhPJy1u/1r27J42hAiBoubrrkhgKQ02326AT+dQILFDkiplaDlLG0eRhrn0AU3HuvQTCq4maN3lg==
X-Received: by 2002:aca:1218:: with SMTP id 24mr935594ois.75.1617769262599;
        Tue, 06 Apr 2021 21:21:02 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o6sm5319320otj.81.2021.04.06.21.21.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 21:21:01 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: rtlwifi/rtl8192cu AP mode broken with PS STA
To:     Pkshih <pkshih@realtek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
References: <e2924d81-0e30-2dd0-292b-428fea199484@maciej.szmigiero.name>
 <846f6166-c570-01fc-6bbc-3e3b44e51327@maciej.szmigiero.name>
 <87r1jnohq6.fsf@codeaurora.org>
 <8e0434eb-d15f-065d-2ba7-b50c67877112@maciej.szmigiero.name>
 <a2003668-5108-27b9-95cd-9e1d5d1aa94d@lwfinger.net>
 <1617763692.9857.7.camel@realtek.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <1dc7e487-b97b-8584-47f7-37f3385c7bf9@lwfinger.net>
Date:   Tue, 6 Apr 2021 23:21:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1617763692.9857.7.camel@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/21 9:48 PM, Pkshih wrote:
> On Tue, 2021-04-06 at 11:25 -0500, Larry Finger wrote:
>> On 4/6/21 7:06 AM, Maciej S. Szmigiero wrote:
>>> On 06.04.2021 12:00, Kalle Valo wrote:
>>>> "Maciej S. Szmigiero" <mail@maciej.szmigiero.name> writes:
>>>>
>>>>> On 29.03.2021 00:54, Maciej S. Szmigiero wrote:
>>>>>> Hi,
>>>>>>
>>>>>> It looks like rtlwifi/rtl8192cu AP mode is broken when a STA is using PS,
>>>>>> since the driver does not update its beacon to account for TIM changes,
>>>>>> so a station that is sleeping will never learn that it has packets
>>>>>> buffered at the AP.
>>>>>>
>>>>>> Looking at the code, the rtl8192cu driver implements neither the set_tim()
>>>>>> callback, nor does it explicitly update beacon data periodically, so it
>>>>>> has no way to learn that it had changed.
>>>>>>
>>>>>> This results in the AP mode being virtually unusable with STAs that do
>>>>>> PS and don't allow for it to be disabled (IoT devices, mobile phones,
>>>>>> etc.).
>>>>>>
>>>>>> I think the easiest fix here would be to implement set_tim() for example
>>>>>> the way rt2x00 driver does: queue a work or schedule a tasklet to update
>>>>>> the beacon data on the device.
>>>>>
>>>>> Are there any plans to fix this?
>>>>> The driver is listed as maintained by Ping-Ke.
>>>>
>>>> Yeah, power save is hard and I'm not surprised that there are drivers
>>>> with broken power save mode support. If there's no fix available we
>>>> should stop supporting AP mode in the driver.
>>>>
>>>   
>>> https://wireless.wiki.kernel.org/en/developers/documentation/mac80211/api
>>> clearly documents that "For AP mode, it must (...) react to the set_tim()
>>> callback or fetch each beacon from mac80211".
>>>   
>>> The driver isn't doing either so no wonder the beacon it is sending
>>> isn't getting updated.
>>>   
>>> As I have said above, it seems to me that all that needs to be done here
>>> is to queue a work in a set_tim() callback, then call
>>> send_beacon_frame() from rtlwifi/core.c from this work.
>>>   
>>> But I don't know the exact device semantics, maybe it needs some other
>>> notification that the beacon has changed, too, or even tries to
>>> manage the TIM bitmap by itself.
>>>   
>>> It would be a shame to lose the AP mode for such minor thing, though.
>>>   
>>> I would play with this myself, but unfortunately I don't have time
>>> to work on this right now.
>>>   
>>> That's where my question to Realtek comes: are there plans to actually
>>> fix this?
>>
>> Yes, I am working on this. My only question is "if you are such an expert on the
>> problem, why do you not fix it?"
>>
>> The example in rx200 is not particularly useful, and I have not found any other
>> examples.
>>
> 
> Hi Larry,
> 
> I have a draft patch that forks a work to do send_beacon_frame(), whose
> behavior like Maciej mentioned.
> I did test on RTL8821AE; it works well. But, it seems already work well even
> I don't apply this patch, and I'm still digging why.
> 
> I don't have a rtl8192cu dongle on hand, but I'll try to find one.

Maceij,

Does this patch fix the problem?

Larry

