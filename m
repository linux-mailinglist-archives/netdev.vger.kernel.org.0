Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF21292B6C
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 18:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbgJSQ1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 12:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729879AbgJSQ1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 12:27:50 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFFFC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 09:27:50 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id e7so224654pfn.12
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 09:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FRXMXu5oqVcUAHtiAe5ooZ2qaC5SbdJKzICITo1wDXY=;
        b=swnCZ5vWAEQv4wyrEfndj7T6o/SiiD6+QA2dQE7CDApY0eeHHN4s3/eDMBC9vXh/lj
         78OAlDJ7ZL/NQQrT1XG8XDb7eDnquOMjMJ9F2XO6XcONzWhzL9zDpy6Z4VXh90W+KLmw
         Y0+EMOTQQgay/Pmdx9Vhsk/hkQF3gev9UFKJLYzht0p5VE/QFpeX+GvywwJCPChiKJDY
         osPfc2Tw+rqU2z03L46GwqqolGuYnvua107uNWFArXyeA7ekIaDy5GpQlSkIXxqwUfGj
         t/FAuzn8N9F/IwHe6fzqZrN/b3XDc+11tues58881fDaFTdhEg7/v+nBiam1uPIotmeK
         SvnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FRXMXu5oqVcUAHtiAe5ooZ2qaC5SbdJKzICITo1wDXY=;
        b=qfnjbhBNZuUQ0zhOdUg2fhlhUdwly7oWg/h+fjbohj+++wF1t0HCqwbgH7Aa1T3Hka
         yf56YdX6apF5gHD0UGkRad9UHdb0DaGQSVK5H65N+0ZATCQDySUEQKSnjCWx8KxgExPT
         zQRtOzyPlNQsggP4rk6tS2yj0QweVeFQ2+PAtkeexZBzjT9esgJtGwcH7a0QEF6hydOs
         oA/iaMwTZC2uP8zlwwTUGHr8vFLDASqjWtYz5BBEHNW7QpMHGpkFL/ACWWwboGq4wxRK
         JNg7uBReffR2sQJTmNPZbFWld2ao3+yPgYIg5ixhvLnWZrBEhtZwMgMUkj8SDWOM7crC
         GEsw==
X-Gm-Message-State: AOAM532CF8nPNW6lFAAlb9NqkLlFjr22ZmkGu6r4TqPTnbp9jIx0vBeF
        yCzUzGc3g0+Ql3gkZQOW7CE=
X-Google-Smtp-Source: ABdhPJz0yimpJzAarzbrvG1f66DjXBllayufIlH8YqYoQ8VtKyV2VxvPKPlM2lHfOvHG2hpWH+CDuA==
X-Received: by 2002:a63:f84c:: with SMTP id v12mr401989pgj.125.1603124869650;
        Mon, 19 Oct 2020 09:27:49 -0700 (PDT)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t3sm148667pgm.42.2020.10.19.09.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 09:27:48 -0700 (PDT)
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201017213611.2557565-2-vladimir.oltean@nxp.com>
 <06538edb-65a9-c27f-2335-9213322bed3a@gmail.com>
 <20201018121640.jwzj6ivpis4gh4ki@skbuf>
 <19f10bf4-4154-2207-6554-e44ba05eed8a@gmail.com>
 <20201018134843.emustnvgyby32cm4@skbuf>
 <2ae30988-5918-3d02-87f1-e65942acc543@gmail.com>
 <20201018225820.b2vhgzyzwk7vy62j@skbuf>
 <b43ad106-9459-0ce9-0999-a6e46af36782@gmail.com>
 <20201019002123.nzi2zhfak3r3lis3@skbuf>
 <da422046-fc3e-9aba-88d1-e7a4d3a74843@gmail.com>
 <20201019120534.GL456889@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <1ac35297-683d-1042-8364-b06cc8b57a67@gmail.com>
Date:   Mon, 19 Oct 2020 09:27:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019120534.GL456889@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/20 5:05 AM, Andrew Lunn wrote:
> On Sun, Oct 18, 2020 at 08:49:31PM -0700, Florian Fainelli wrote:
>>
>>
>> On 10/18/2020 5:21 PM, Vladimir Oltean wrote:
>>> On Sun, Oct 18, 2020 at 04:11:14PM -0700, Florian Fainelli wrote:
>>>> How about when used as a netconsole? We do support netconsole over DSA
>>>> interfaces.
>>>
>>> How? Who is supposed to bring up the master interface, and when?
>>>
>>
>> You are right that this appears not to work when configured on the kernel
>> command line:
>>
>> [    6.836910] netpoll: netconsole: local port 4444
>> [    6.841553] netpoll: netconsole: local IPv4 address 192.168.1.10
>> [    6.847582] netpoll: netconsole: interface 'gphy'
>> [    6.852305] netpoll: netconsole: remote port 9353
>> [    6.857030] netpoll: netconsole: remote IPv4 address 192.168.1.254
>> [    6.863233] netpoll: netconsole: remote ethernet address
>> b8:ac:6f:80:af:7e
>> [    6.870134] netpoll: netconsole: device gphy not up yet, forcing it
>> [    6.876428] netpoll: netconsole: failed to open gphy
>> [    6.881412] netconsole: cleaning up
>>
>> looking at my test notes from 2015 when it was added, I had only tested
>> dynamic netconsole while the network devices have already been brought up
>> which is why I did not catch it. Let me see if I can fix that somehow.
> 
> Hi Florian
> 
> NFS root used to work, so there must be some code in the kernel to
> bring the master interface up. Might just need copy/pasting.

This is a tiny bit different because netconsole goes through netpoll
which is responsible for doing the interface configuration. Unlike root
over NFS, this does not utilize net/ipv4/ipconfig.c, so the existing DSA
checks in that file are not used. The same "cure" could be applied, but
I am not sure if it will be accepted, we shall see.
-- 
Florian
