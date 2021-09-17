Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F6640FE02
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 18:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhIQQkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 12:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhIQQkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 12:40:45 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FD1C061574
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 09:39:22 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n2so3942989plk.12
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 09:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KrirNFc94bDZ+DaNprmjb6rDfzZ79YbZtw2NW2kK2K0=;
        b=Xt7mmdBsGoMNXUJv8PQe6OHlGCbGx8jms6u3tk/8tAqaBqw/jo8KanzICTQDHhvcf5
         OEuwiHl1xSmz7oiGiBZh92A1X7egO8j7pjNJlrk6Ry9x1V7tMFg+LHAmEdRAK7eSx7T3
         ObmF3c9IkLXnwK42xmtEn9zIaywNvkDFwGiODJcrkpz2zi3RkFt5+RIv3yPRnCiSXOF3
         gXQmXevL6OHcnjUd6NCHgqPZ5bxBnY6FjJL+E6NjW7Xk4DQSpdjw6KzLq9EdDzb5LHJ9
         UUHGSRVx2dHw0aKudnSjU9gKE+5Z7HD44P33AXWq2GXatSIqd7qujcx3GMMEk2ArlWLc
         fVMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KrirNFc94bDZ+DaNprmjb6rDfzZ79YbZtw2NW2kK2K0=;
        b=sF7gFoE04GXnG3d/NHUYljgjZsse+gUNpaNsCIu3tQtxSqRRiGNzGZgPtgHe3d0vx9
         LJmjf3bYwVL+zl5Bllnvbpw3QKq8g1Z4pLbsroIPZMjKeOUGGlDg8kJGqzTKqf2zafH1
         lkrQpm17XTVESVJK2Qxrz9y+PKxn7eX7JrryMQLMmyu95CsCeRC2ZMJJe6MmsrnibvaR
         wDThWCCMWlRdLsjngfuennHzX8++jvYNmI89RbYSS8VtOII4I/rJOV8vdl4B/FJFnpvX
         8oOM9i32aEqt+p5WGEjUp6I6XmdmV/AtP5eyQziI0tEJz3PvurQ9/GDA4NO5Pa7CFvVA
         z2tA==
X-Gm-Message-State: AOAM530yO/OeaqRiz0gF8sXLtVJdJZKqp+TF+U5yN30c9TSP1r0NKyAj
        UEdKTgoqbF+IQl7loXHwB7w=
X-Google-Smtp-Source: ABdhPJy91XexvgP7KjmnIaeiUZ/3K6uHJVd6bpYzcoIvKKl7QPd7Sp1ivAPW3ysTtVnUaCYcU7oIXQ==
X-Received: by 2002:a17:90a:eb02:: with SMTP id j2mr22371770pjz.174.1631896762261;
        Fri, 17 Sep 2021 09:39:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ga24sm10981095pjb.41.2021.09.17.09.39.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 09:39:21 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] net: dsa: b53: Clean up CPU/IMP ports
To:     Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210916120354.20338-1-zajec5@gmail.com>
 <7c5e1cf8-2d98-91df-fc6b-f9edfa0f23c9@gmail.com>
 <a8a684ce-bede-b1f1-1f7a-31e71dca3fd3@gmail.com>
 <1568bbc3-1652-7d01-2fc7-cb4189c71ad2@gmail.com>
 <20210917100051.254mzlfxwvaromcn@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5f73aeef-d972-eb9e-7e29-07bf6eb9e6a3@gmail.com>
Date:   Fri, 17 Sep 2021 09:39:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210917100051.254mzlfxwvaromcn@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/21 3:00 AM, Vladimir Oltean wrote:
> On Fri, Sep 17, 2021 at 12:19:02AM +0200, Rafał Miłecki wrote:
>> On 16.09.2021 23:46, Florian Fainelli wrote:
>>> On 9/16/21 9:23 AM, Florian Fainelli wrote:
>>>> On 9/16/21 5:03 AM, Rafał Miłecki wrote:
>>>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>>>
>>>>> This has been tested on:
>>>>>
>>>>> 1. Luxul XBR-4500 with used CPU port 5
>>>>> [    8.361438] b53-srab-switch 18007000.ethernet-switch: found switch: BCM53012, rev 0
>>>>>
>>>>> 2. Netgear R8000 with used CPU port 8
>>>>> [    4.453858] b53-srab-switch 18007000.ethernet-switch: found switch: BCM53012, rev 5
>>>>
>>>> These look good at first glance, let me give them a try on 7445 and 7278
>>>> at least before responding with Reviewed-by/Tested-by tags, thanks!
>>>>
>>> Found some issues on 7445 and 7278 while moving to the latest net-next
>>> which I will be addressing but this worked nicely.
>>>
>>> What do you think about removing dev->enabled_ports and
>>> b53_for_each_port entirely and using a DSA helper that iterates over the
>>> switch's port list? Now that we have dev->num_ports accurately reflect
>>> the number of ports it should be equivalent.
>>
>> The limitation I see in DSA is skipping unavailable ports. E.g. BCM5301x
>> switches that don't have port 6. The closest match for such case I found
>> is DSA_PORT_TYPE_UNUSED but I'm not sure if it's enough to handle those
>> cases.
>>
>> That DSA_PORT_TYPE_UNUSED would probably require investigating DSA & b53
>> behaviour *and* discussing it with DSA maintainer to make sure we don't
>> abuse that.
> 
> How absent are these ports in hardware? For DSA_PORT_TYPE_UNUSED we do
> register a devlink port, but if those ports are really not present in
> hardware, I'm thinking maybe the easiest way would be to supply a
> ds->disabled_port_mask before dsa_register_switch(), and DSA will simply
> skip those ports when allocating the dp, the devlink_port etc. So you
> will literally have nothing for them.
> 

Port 6 on all of the newer switches where the "ideal" IMP port is 8 is
completely absent and does not exist at all as a hardware resource. The
registers are not necessarily consistent however and you typically see
two patterns:

- specifying bit 6 or port 6 as a numerical port does not nothing and no
special casing is required, this is the majority of the registers and
the maximum supported bitmask is 0x1ff and you can also set bit 8 to
address port 8 of the CPU (I would say this is intuitive)

- specifying bit 6/number 6 may alias to port 7, this is the case with
the CFP code for instance that specifically checks for port >= 7 and
subtracts one when needed (this is not intuitive)

Whether we truly consider a port being absent from a port being unused
is not probably making much difference from a semantic perspective as
long as you do not try to switch a port from unused to used (whether it
is DSA, CPU or USER). This is not an use case we support today, but if
we did in the future (say in the context of multi CPU port devices), we
would have to call back into the driver most likely and the driver could
veto changing that port from unused to used. What do you think?

NB: the enabled_port mask for the 7278 and 7445 switches is currently
incorrectly advertising the presence of port 6 (0x1ff), that needs fixing.
-- 
Florian
