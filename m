Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2586C4762D8
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 21:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbhLOUMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 15:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbhLOUMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 15:12:23 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75597C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 12:12:23 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v23so18434677pjr.5
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 12:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CT+8e7rlvOJJLzuN6UNTfUfvmlNQg0RTRzFa81JxHeU=;
        b=kDHajlcsvrT89GObQV51AgbDNNzXV/wMhGnqOro0Q2T65gAdJwcISvRzqHTk8KSYxr
         aWqGHAJeN/A9SBiH6i3+sWSjccCcg3pwOMLDiY34DfrDrCYOCvR7HMNww/RA/xaVQhju
         wAEiWMi2kM2AYtIMCHC8IqwRkB+QDyPvvKc6JEm1BGnI3vC2G1S8mxcCFuBggJMdtYw5
         0wgmWo8EBXvTGqZJb+786a3h6i/V4DiNgUdscehwMNKvtUDccJuSmC6PqHR5eWsvmIh1
         0Db/w+IKMxClNoJFgFdOA6G3Ku1r3rNMBVukDupjtssdBOoXgkexSy39+NsRsnPtVuYj
         CPNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CT+8e7rlvOJJLzuN6UNTfUfvmlNQg0RTRzFa81JxHeU=;
        b=qW4+axqxoVI/CsVceGeTPXz/Jb/MJRtDvWvoJZRV2PF7FHefcDyiPKZVVW4AF3lzT7
         JX4CGKZSYJJpevmN05Q7YF8Qrir0fmeuJ6PM175aHmq6VLwpFzLAwLKYuRm83eucvWq/
         8/6yWzmKtDHr8oLJD7e4ZItC1q59nNb05/k5sWyvPP6ONp708nJ1jGkPkCUqa8WVHCeg
         csPPqnb5X9AX6x0xtQCn+OMhKY2sB695e/x/m60081Fod3Po0z/M1MAG4mzJxqtsI3if
         Un4Q3IwygXMktuHX8SzRDsrr5wChkMMc9Xrc+1zCJmnHFqKBTysv0Bx9H8Dpgey9gy66
         uSzg==
X-Gm-Message-State: AOAM532BbsOxS/BMdGPaimO3u6lEi0rbqAYcG9oqJAvDXMYfZQaSFImp
        ptxaYuAwRTqcp2YqyxubWBU=
X-Google-Smtp-Source: ABdhPJzMf3BgNe8/MTCEGGnxwsH0/s+lVy1AcAJizD0hx94rywX9JYuajhbn6jv5j7e6jPZ+j0Z4eQ==
X-Received: by 2002:a17:902:eccb:b0:148:a2e8:2757 with SMTP id a11-20020a170902eccb00b00148a2e82757mr5974123plh.94.1639599142902;
        Wed, 15 Dec 2021 12:12:22 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r13sm3292571pga.29.2021.12.15.12.12.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 12:12:22 -0800 (PST)
Subject: Re: Port mirroring (RFC)
To:     Alex Elder <elder@linaro.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <YbjiCNRffWYEcWDt@lunn.ch> <3bd97657-7a33-71ce-b33a-e4eb02ee7e20@linaro.org>
 <YbmzAkE+5v7Mv89D@lunn.ch> <b00fb6e2-c923-39e9-f326-6ec485fcff21@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cdaf3a32-65d6-6fc0-dafc-cd07cb67fc3e@gmail.com>
Date:   Wed, 15 Dec 2021 12:12:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <b00fb6e2-c923-39e9-f326-6ec485fcff21@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/21 6:47 AM, Alex Elder wrote:
> On 12/15/21 3:18 AM, Andrew Lunn wrote:
>>> IPA is a device that sits between the main CPU and a modem,
>>> carrying WWAN network data between them.
>>>
>>> In addition, there is a small number of other entities that
>>> could be reachable through the IPA hardware, such as a WiFi
>>> device providing access to a WLAN.
>>>
>>> Packets can travel "within IPA" between any of these
>>> "connected entities."  So far only the path between the
>>> AP and the modem is supported upstream, but I'm working
>>> on enabling more capability.
>>>
>>> Technically, the replicated packets aren't visible on
>>> any one port; the only way to see that traffic is in
>>> using this special port.  To me this seemed like port
>>> mirroring, which is why I suggested that.  I'm want to
>>> use the proper model though, so I appreciate your
>>> response.
>>
>> Do you have netdevs for the modem, the wifi, and whatever other
>> interfaces the hardware might have?
> 
> Not yet, but yes I expect that's how it will work.
> 
>> To setup a mirror you would do something like:
>>
>> sudo tc filter add dev eth0 parent ffff: protocol all u32 match u32 0
>> 0 action mirred egress mirror dev tun0
> 
> OK so it sounds like the term "mirror" means mirroring using
> Linux filtering.  And then I suppose "monitoring" is collecting
> all "observed" traffic through an interface?

It is mirroring in terms of an action to perform for a given packet
having been matched, now Ethernet switches for instance support
mirroring in hardware and that specific action can be offloaded down to
your hardware. You can take a look at net/dsa/* and drivers/net/dsa/ for
an example of how this is done.

> 
> If that's the case, this seems to me more like monitoring, except
> I suggested presenting the replicated data through a separate
> netdev (rather than, for example, through the one for the modem).
> 
> If it makes more sense, I could probably inject the replicated
> packets received through this special interface into one or
> another of the existing netdevs, rather than using a separate
> one for this purpose.
> 
>> where you are mirroring eth0 to tun0. eth0 would have to be your modem
>> netdev, or your wifi netdev, and tun0 would be your monitor device.
>>
>> If you do have a netdev on the host for each of these network
>> interfaces, mirroring could work. Architecturally, it would make sense
>> to have these netdevs, so you can run wpa_supplicant on the wifi
>> interface to do authentication, etc.
>>
>> Do you have control over selecting egress and ingress packets to be
>> mirrored?
> 
> That I'm not sure about.  If it's possible, it would be controlling
> which originators have their traffic replicated.

And the originators would be represented as network devices, or would
they be another kind of object in the Linux kernel? If they are network
devices then you can use the example from Andrew above because you
basically define the source device to mirror. Else, you may have to
invent your own thing.

> 
> I don't think it will take me all that long to implement this, but
> my goal right now is to be sure that the design I implement is a good
> solution.  I'm open to recommendations.
> 
> Thanks.
> 
>                     -Alex
> 
>>     Andrew
>>
> 


-- 
Florian
