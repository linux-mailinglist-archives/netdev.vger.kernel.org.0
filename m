Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4A31C2C77
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 14:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgECMsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 08:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728115AbgECMsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 08:48:22 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E9CC061A0C
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 05:48:20 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id e9so9458398iok.9
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 05:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MQDD+mhPo5ohtn74Ww8z4UvE0EQ9Jh+TtXxoSmmwLS0=;
        b=V1n7Bi7i2Rc8+6XnrGuavLIL3/LMJyeVAXW6PcEnypUdN9jD8mBoWRl+MdAEC1Oanl
         zozsDnUNQOjBFOiP7QKxvjSqCnbL4QPfihMrCPnzohZua5frfmQdYQtWxUMlmjdGrIev
         RrglGccbdG2a8kLaApnP3uBc75Y94AKrmKVhPxRvGmnEpFNnze5/XLWVc5bO9Fz4U0jM
         uQDzeZoKwf/WAqUpHy+1An0EHUpb+1ZYCK6ctQZrofeP+J/LZ+azP0+pKBPv01hzp37q
         XXUoftETxRm9ocKz5dED+NJaAut5M52nfSbSxNa1bHb8R3DD+GLX4qaOJqbPdIP3mmsV
         XLWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MQDD+mhPo5ohtn74Ww8z4UvE0EQ9Jh+TtXxoSmmwLS0=;
        b=mb8FicjpmySxmBlje/lWvKdsBSkwkPe8zJmCRHNwRzoD4tF9mkqGzTSz69lMxfnpqs
         6iE7TJXVTejEuZGBAY3dEap9bTLsXJXj6OYxY8vrSe677asjkK2/NM9K5eGqTQELToyl
         IU57FXM/EdrzxDgx2n5kdinXZ5mAbN+faIyk4U/6YFjk3BmOxS43P7oZ6/tNXPC6A8vB
         0KkBX4dOi/9gjEFFi27f7rA/qag82Vo52M4h3mK6y3/4PSPrgZgo68YV1U6iYMPG/6Ec
         XkmLAoaouiNOFo7LPgJPSNLfeQFjv9z6NhtsYstN7zNXIQJpQCll3cRlAhL7sRR0v0hL
         81zQ==
X-Gm-Message-State: AGi0PuaDXi8xyavOL0EIiW91OZdxsSsYWpV0u6wLdv2vR083c2idh4D0
        1HmB7Y5qYmr2aYAltCGixw8hNA==
X-Google-Smtp-Source: APiQypJEXTM7BhiQjba5jJ8KLSri4SKUktegex5RIJIrjvJkRJ0mDxyec+xpxFv6h6mVmT9RhaFHUw==
X-Received: by 2002:a6b:8b17:: with SMTP id n23mr11324386iod.69.1588510099934;
        Sun, 03 May 2020 05:48:19 -0700 (PDT)
Received: from [10.0.0.125] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id l13sm3514119ilo.46.2020.05.03.05.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2020 05:48:19 -0700 (PDT)
Subject: Re: [Patch net v2] net_sched: fix tcm_parent in tc filter dump
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
References: <20200501035349.31244-1-xiyou.wangcong@gmail.com>
 <7b3e8f90-0e1e-ff59-2378-c6e59c9c1d9e@mojatatu.com>
 <a18c1d1a-20a1-7346-4835-6163acb4339b@mojatatu.com>
 <CAM_iQpWi9MA5DEk7933aah3yeOQ+=bHO8H2-xpqTtcXn0k=+0Q@mail.gmail.com>
 <66d03368-9b8e-b953-a3a5-1f61b71e6307@mojatatu.com>
Message-ID: <08e34ca6-3a9d-4245-317f-ae17b60e3666@mojatatu.com>
Date:   Sun, 3 May 2020 08:48:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <66d03368-9b8e-b953-a3a5-1f61b71e6307@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-03 8:02 a.m., Jamal Hadi Salim wrote:
> On 2020-05-02 10:28 p.m., Cong Wang wrote:
>> On Sat, May 2, 2020 at 2:19 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>>
>>> On 2020-05-02 4:48 a.m., Jamal Hadi Salim wrote:
> 
> [..]
>>>> Note:
>>>> tc filter show dev dummy0 root
>>>> should not show that filter. OTOH,
>>>> tc filter show dev dummy0 parent ffff:
>>>> should.
>>
>> Hmm, but we use TC_H_MAJ(tcm->tcm_parent) to do the
>> lookup, 'root' (ffff:ffff) has the same MAJ with ingress
>> (ffff:0000).
>>
> 
> I have some long analysis and theory below.
> 
>> And qdisc_lookup() started to search for ingress since 2008,
>> commit 8123b421e8ed944671d7241323ed3198cccb4041.
>>
>> So it is likely too late to change this behavior even if it is not
>> what we prefer.
>>
> 
> My gut feeling is that whatever broke (likely during block addition
> maybe even earlier during clsact addition) is in the code
> path for adding filter. Dumping may have bugs but i would
> point a finger to filter addition first.
> More below.... (sorry long email).
> 
> 
> Here's what i tried after applying your patch:
> 
> ----
> # $TC qd add dev $DEV ingress
> # $TC qd add dev $DEV root prio
> # $TC qd ls dev $DEV
> qdisc noqueue 0: dev lo root refcnt 2
> qdisc prio 8008: dev enp0s1 root refcnt 2 bands 3 priomap 1 2 2 2 1 2 0 
> 0 1 1 1 1 1 1 1 1
> qdisc ingress ffff: dev enp0s1 parent ffff:fff1 ----------------
> -----
> 
> egress i.e root is at 8008:
> ingress is at ffff:fff1
> 
> If say:
> ---
> # $TC filter add dev $DEV root protocol arp prio 10 basic action pass
> ----
> 
> i am instructing the kernel to "go and find root (which is 8008:)
> and install the filter there".

Ok, I went backwards and looked at many kernel sources.
It is true we install the filters in two different locations
i.e just specifying TC_H_ROOT does not equate to picking
the egress qdisc with that flag.
And has been broken for way too long - so we have to live
with it.
I wish we had more tdc tests and earlier.

Advise to users is not to use semantics like "root" or ingress
but rather explicitly specify the parent.

So ignore what i said above. I will ACK your patch.

cheers,
jamal
