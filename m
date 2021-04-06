Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F4735591F
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 18:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244012AbhDFQZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 12:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbhDFQZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 12:25:12 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D39AC06174A;
        Tue,  6 Apr 2021 09:25:04 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id x207so15722220oif.1;
        Tue, 06 Apr 2021 09:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dU5G8PR6W8uwjypO4WoRqS/gPC9d2EbpFn+extiOH5A=;
        b=K7li2xaJli2tU6J3EoTCPkOSjcNLai2eFffxsqMT51/zC0fG+xkgj35fihSo5uKUWy
         2wyO7epnZ1qFUqpnw4I3Jst7g1ksEkZi9Sbpx+W2AFic5JGmvsN9XaOxZiNKrrdAt9rG
         stmWUc0Wd0zwJD8NLna8lRLn+X2hfZpSp0bfVKR7Zt32DdPIBye2kA/j1OEMpCr1RheK
         M9cSOy8Thom7ar8g6O9u2DbkydeOieutnadyCEBDdqNO7Qvb0uz95o3T8jgEWXR/PIcE
         FdIp4rUDvwfsnupOMkEJcT7Mree78hDxVXEVv/AvxqEVkGN2gCWwfGYURO6pucdhDxhN
         GNBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dU5G8PR6W8uwjypO4WoRqS/gPC9d2EbpFn+extiOH5A=;
        b=j0dXrhhSGHEJBbSncCZUSw1s6KP9orufMk3tZcMTyyJP/CBsALBE0Jdskzh67igYwz
         BYg++T0FSV9R8QUE4gxCpUz+bSMAyu3urjZlf+byrAv/lq2I9k7slT3gYo49/et/d+zW
         064TUwUZJpiTGa7g4UhDVgcvvRn5ninwj81sUCoYkftRaZXc5JnYIKlw73kHXJixaTFy
         5WYdOujwO+5+dqex6Ppah86E+lq0r4WXySngxcrPbsenH5c2J3jRCHJTDDIHYUXG6T67
         WWQ9lQrWUb7A0rsN021BMEfbW6k85UocPAEK7ScrCnASWT68qhM/9bkT0kfyxwRcym8g
         h1uw==
X-Gm-Message-State: AOAM532z2xm/ZIp1rihrGCDaqrIVjFHDPA606KtbbPFpRT4kI3EIlb9U
        UXlMfHTUC0KcBY2UfzDkDn/REw8UbBw=
X-Google-Smtp-Source: ABdhPJxIZcKqVl6qsfqf153ZSz4wmxMrNch0ghjvbnQr6V10BiULwl6KUSifLOtMm291fPLpcrJ20w==
X-Received: by 2002:aca:aa41:: with SMTP id t62mr3897152oie.84.1617726303398;
        Tue, 06 Apr 2021 09:25:03 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id z199sm4245543ooa.39.2021.04.06.09.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 09:25:02 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: rtlwifi/rtl8192cu AP mode broken with PS STA
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e2924d81-0e30-2dd0-292b-428fea199484@maciej.szmigiero.name>
 <846f6166-c570-01fc-6bbc-3e3b44e51327@maciej.szmigiero.name>
 <87r1jnohq6.fsf@codeaurora.org>
 <8e0434eb-d15f-065d-2ba7-b50c67877112@maciej.szmigiero.name>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a2003668-5108-27b9-95cd-9e1d5d1aa94d@lwfinger.net>
Date:   Tue, 6 Apr 2021 11:25:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <8e0434eb-d15f-065d-2ba7-b50c67877112@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/21 7:06 AM, Maciej S. Szmigiero wrote:
> On 06.04.2021 12:00, Kalle Valo wrote:
>> "Maciej S. Szmigiero" <mail@maciej.szmigiero.name> writes:
>>
>>> On 29.03.2021 00:54, Maciej S. Szmigiero wrote:
>>>> Hi,
>>>>
>>>> It looks like rtlwifi/rtl8192cu AP mode is broken when a STA is using PS,
>>>> since the driver does not update its beacon to account for TIM changes,
>>>> so a station that is sleeping will never learn that it has packets
>>>> buffered at the AP.
>>>>
>>>> Looking at the code, the rtl8192cu driver implements neither the set_tim()
>>>> callback, nor does it explicitly update beacon data periodically, so it
>>>> has no way to learn that it had changed.
>>>>
>>>> This results in the AP mode being virtually unusable with STAs that do
>>>> PS and don't allow for it to be disabled (IoT devices, mobile phones,
>>>> etc.).
>>>>
>>>> I think the easiest fix here would be to implement set_tim() for example
>>>> the way rt2x00 driver does: queue a work or schedule a tasklet to update
>>>> the beacon data on the device.
>>>
>>> Are there any plans to fix this?
>>> The driver is listed as maintained by Ping-Ke.
>>
>> Yeah, power save is hard and I'm not surprised that there are drivers
>> with broken power save mode support. If there's no fix available we
>> should stop supporting AP mode in the driver.
>>
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/mac80211/api
> clearly documents that "For AP mode, it must (...) react to the set_tim()
> callback or fetch each beacon from mac80211".
> 
> The driver isn't doing either so no wonder the beacon it is sending
> isn't getting updated.
> 
> As I have said above, it seems to me that all that needs to be done here
> is to queue a work in a set_tim() callback, then call
> send_beacon_frame() from rtlwifi/core.c from this work.
> 
> But I don't know the exact device semantics, maybe it needs some other
> notification that the beacon has changed, too, or even tries to
> manage the TIM bitmap by itself.
> 
> It would be a shame to lose the AP mode for such minor thing, though.
> 
> I would play with this myself, but unfortunately I don't have time
> to work on this right now.
> 
> That's where my question to Realtek comes: are there plans to actually
> fix this?

Yes, I am working on this. My only question is "if you are such an expert on the 
problem, why do you not fix it?"

The example in rx200 is not particularly useful, and I have not found any other 
examples.

Larry

