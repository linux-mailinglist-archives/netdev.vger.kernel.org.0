Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578EE22D1CA
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 00:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGXW2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 18:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgGXW2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 18:28:25 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EFAC0619D3;
        Fri, 24 Jul 2020 15:28:24 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 3so2563298wmi.1;
        Fri, 24 Jul 2020 15:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HTgjU7KoYTQQaOgHMoV0nRUbxLJJs+HbtplvIvJXZj0=;
        b=MY192UPPmmAFjiiGo3bAUNMkHUq6gYYwQ5/FuUehC1s2YeWKzW1++NNZdh0iyKL/R8
         liICGtwb9Mt1kOe+1kghoMPIm0fwRJ4yv/qm02WKT02ja88I6nVOsAQ9rZgxAfO13AM0
         vxDxM34HKQeUKpC+6KHGJFNazLwJHi0EpCgPboWKLHY829gIXd3/29z1tQjEUnUDb89W
         kqQCql+vYTCZHXuwVBYCZreL08VQItEExTkuciaVwy0KXor1QqhT+9v8PC0S0o9Nkm/a
         IY3XlJgN+BCgx0tRQMEt/h9+MR34P03lLd7ejWkCAkLl/LwEszkwEbDwMIU09VWBzA/P
         Zrig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=HTgjU7KoYTQQaOgHMoV0nRUbxLJJs+HbtplvIvJXZj0=;
        b=ZDmQyfYETcKT67MbdXfronsh+TeMAlAMrqQVJyn+h+4PMvYvmiEr5/T6cpLUtKXhuZ
         w1vr8PC3Ox7EQsz9DnFPS65kLo8cqznwc0QMldmydv7A5Ffk3JteMz+S3676Z/CrjAqy
         /hNBMsmMdaYmcqBiepGXrDNq5GKGBjVum9LrUkA9dB81aoCF/qH2udd0wHJaX8aHDDwm
         Oo1u/RYCNUVITncVze87rEJuK8Tos7EwDxFgbHHiN3S04muGvr1fRIYJCVoQgqdcGBKf
         L1xfb5t1knf8uHKGRKV5KIGY2SvgCm1KbYMNm6zI03UOqStrZPTcL3B0edrdujPMuaE4
         p53A==
X-Gm-Message-State: AOAM530xAWit1XBgqdqc6RrvVC4hZpy3dOmUKEjpxHd8auAdmeXArbP/
        f2a+H4IxIJeR3UTIiSfUu8s=
X-Google-Smtp-Source: ABdhPJzcdH/KZ3bBT2UqFhdLnrsAd3GV0rMIXjkMlfSrQKySPxMQ9StZneIyEYzXE9wXUapFyoZb/A==
X-Received: by 2002:a1c:3dc3:: with SMTP id k186mr11104550wma.66.1595629703553;
        Fri, 24 Jul 2020 15:28:23 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a10sm16788489wmd.3.2020.07.24.15.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 15:28:22 -0700 (PDT)
Subject: Re: [RFC 0/7] Add support to process rx packets in thread
To:     Rakesh Pillai <pillair@codeaurora.org>,
        'Andrew Lunn' <andrew@lunn.ch>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@codeaurora.org,
        johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, dianders@chromium.org, evgreen@chromium.org
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
 <20200721172514.GT1339445@lunn.ch>
 <f6d93d76-9e59-c257-9318-31c71df28018@gmail.com>
 <002e01d6611e$0d8ac640$28a052c0$@codeaurora.org>
 <fdedf787-1bb0-601c-0959-6f1bfb38e5d7@gmail.com>
 <000201d66182$8989a3b0$9c9ceb10$@codeaurora.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <80490faa-f9e8-3bac-a645-7458b9d6aa62@gmail.com>
Date:   Fri, 24 Jul 2020 15:28:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000201d66182$8989a3b0$9c9ceb10$@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/20 11:20 PM, Rakesh Pillai wrote:
> 
> 
>> -----Original Message-----
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Sent: Friday, July 24, 2020 12:33 AM
>> To: Rakesh Pillai <pillair@codeaurora.org>; 'Andrew Lunn'
>> <andrew@lunn.ch>
>> Cc: ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
>> kernel@vger.kernel.org; kvalo@codeaurora.org; johannes@sipsolutions.net;
>> davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org;
>> dianders@chromium.org; evgreen@chromium.org
>> Subject: Re: [RFC 0/7] Add support to process rx packets in thread
>>
>> On 7/23/20 11:21 AM, Rakesh Pillai wrote:
>>>
>>>
>>>> -----Original Message-----
>>>> From: Florian Fainelli <f.fainelli@gmail.com>
>>>> Sent: Tuesday, July 21, 2020 11:35 PM
>>>> To: Andrew Lunn <andrew@lunn.ch>; Rakesh Pillai
>> <pillair@codeaurora.org>
>>>> Cc: ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
>>>> kernel@vger.kernel.org; kvalo@codeaurora.org;
>> johannes@sipsolutions.net;
>>>> davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org;
>>>> dianders@chromium.org; evgreen@chromium.org
>>>> Subject: Re: [RFC 0/7] Add support to process rx packets in thread
>>>>
>>>> On 7/21/20 10:25 AM, Andrew Lunn wrote:
>>>>> On Tue, Jul 21, 2020 at 10:44:19PM +0530, Rakesh Pillai wrote:
>>>>>> NAPI gets scheduled on the CPU core which got the
>>>>>> interrupt. The linux scheduler cannot move it to a
>>>>>> different core, even if the CPU on which NAPI is running
>>>>>> is heavily loaded. This can lead to degraded wifi
>>>>>> performance when running traffic at peak data rates.
>>>>>>
>>>>>> A thread on the other hand can be moved to different
>>>>>> CPU cores, if the one on which its running is heavily
>>>>>> loaded. During high incoming data traffic, this gives
>>>>>> better performance, since the thread can be moved to a
>>>>>> less loaded or sometimes even a more powerful CPU core
>>>>>> to account for the required CPU performance in order
>>>>>> to process the incoming packets.
>>>>>>
>>>>>> This patch series adds the support to use a high priority
>>>>>> thread to process the incoming packets, as opposed to
>>>>>> everything being done in NAPI context.
>>>>>
>>>>> I don't see why this problem is limited to the ath10k driver. I expect
>>>>> it applies to all drivers using NAPI. So shouldn't you be solving this
>>>>> in the NAPI core? Allow a driver to request the NAPI core uses a
>>>>> thread?
>>>>
>>>> What's more, you should be able to configure interrupt affinity to steer
>>>> RX processing onto a desired CPU core, is not that working for you
>>>> somehow?
>>>
>>> Hi Florian,
>>> Yes, the affinity of IRQ does work for me.
>>> But the affinity of IRQ does not happen runtime based on load.
>>
>> It can if you also run irqbalance.
> 
> 
> Hi Florian,
> 
> Is it some kernel feature ?  Sorry I am not aware of this ?
> I know it can be done in userspace.

The kernel interface is /proc/<irq>/smp_affinity and the users-space
implementation resides here:

https://github.com/Irqbalance/irqbalance
-- 
Florian
