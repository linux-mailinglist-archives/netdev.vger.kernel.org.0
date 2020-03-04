Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D51A3178E0A
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 11:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgCDKHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 05:07:42 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35664 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728767AbgCDKHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 05:07:42 -0500
Received: by mail-lj1-f194.google.com with SMTP id a12so1344448ljj.2
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 02:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zXK00pSGyDBmA2DN9Hg9j2eUDbRP1T3Fd3Ql6C0WhBE=;
        b=PizGtpZPkS60VM1+87/Ic1WTeB0aXst/q1fM4FWoWsKZ4RXEybc2Jt1RaMmTtdUW8t
         Qbyhmlv8qaURQIZeEk8yRQTJvvVoEo9qC5n5tHBfmR2KYJoAj+TCyLdq3uxpHgy8T5Vy
         b3H+eohOAuSBJWXguXd0V3SqCX+pFN5jii04jnfX1npBvhTydneCXzJKnsySrqe7qeBX
         caIUWSw6gt07BltQyEOgbCiglmDEo/ZS66knUEpo9yzh9Xx7dd79ztLdD6AG6kov+PHz
         xsA4EKINk+ta66MR2gaQ4Pv0l2p5+yDoaxknt9J9KFtveGHMx4Mv7wHvG7384qG4Mtf8
         M8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zXK00pSGyDBmA2DN9Hg9j2eUDbRP1T3Fd3Ql6C0WhBE=;
        b=mhoimWzkme9HOdUmj0uiHI7n1Tns7cMc+creN7pYiDRxbqKJJGkCNuIJOIriOsruOa
         /bRGI2non5y9Npr9hwmdVlCITX6rQEoOYLiRJ3LRcwimRk2E/5p5hf7dQovQWh3LjIPx
         XKxBN1r6MkVyjaKeFbW37rCqzWkq8jbpclOCWVICegHb38IFv09NeLX2dBklkkxuL9HW
         rjOQGM/it1qZ04LiupxgZoJh9z/dU5ooQYQCVnVri4fTZkeJa/IXEfd7baIiOsCjhfhl
         J094WaQTLnfZpUVi4iLV7EsIfuq9/ZHz9Fihc+HM6WpMVN2PN+96lxmJ1TD6Hf7N1XIi
         BI8A==
X-Gm-Message-State: ANhLgQ1TAmWM0TzeoLWUTlM+Pn3i0jqXI/PgL4v3BKieJTOkoEDI2CfP
        1I4h4M4yvuejordSSbMGHbo=
X-Google-Smtp-Source: ADFU+vsnwI41O94bARWHp/qH/G5BRBIsv5cADzjTcvQifyGkd/W9llMMJMACwarSaDc1ecYSRwkhHQ==
X-Received: by 2002:a2e:b5cc:: with SMTP id g12mr1583722ljn.58.1583316458796;
        Wed, 04 Mar 2020 02:07:38 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id o20sm15616274lfg.45.2020.03.04.02.07.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 02:07:37 -0800 (PST)
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
References: <CACna6rwD_tnYagOPs2i=1jOJhnzS5ueiQSpMf23TdTycFtwOYQ@mail.gmail.com>
 <b9d30209-7cc2-4515-f58a-f0dfe92fa0b6@gmail.com>
 <20200303090035.GV2159@dhcp-12-139.nay.redhat.com>
 <20200303091105.GW2159@dhcp-12-139.nay.redhat.com>
 <bed8542b-3dc0-50e0-4607-59bd2aed25dd@gmail.com>
 <20200304064504.GY2159@dhcp-12-139.nay.redhat.com>
 <d34a35e0-2dbe-fab8-5cf8-5c80cb5ec645@gmail.com>
 <20200304090710.GZ2159@dhcp-12-139.nay.redhat.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <b424f456-364d-d6f1-36cc-5b6fccd13b97@gmail.com>
Date:   Wed, 4 Mar 2020 11:07:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200304090710.GZ2159@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.03.2020 10:07, Hangbin Liu wrote:
> On Wed, Mar 04, 2020 at 08:44:29AM +0100, Rafał Miłecki wrote:
>>> Hi Rafał,
>>>
>>> When review the code, I got confused. On the latest net code, we only
>>> add the allrouter address to multicast list in function
>>> 1) ipv6_add_dev(), which only called when there is no idev. But link down and
>>>      up would not re-create idev.
>>> 2) dev_forward_change(), which only be called during forward change, this
>>>      function will handle add/remove allrouter address correctly.
>>
>> Sharp eye! You're right, I tracked (with just a pr_info) all usages of
>> in6addr_linklocal_allrouters and none gets triggered during my testing
>> routine. I'm wondering if I should start blaming my OpenWrt user space
>> now.
> 
> Yeah...Hope you could help dig more.

I disabled all relevant OpenWrt deamons (netifd, odhcpcd, etc.) but
issue remains.

I did some extra debugging and I believe I found the real problem!

When creating interface, ipv6_add_dev() gets executed and it calls:
ipv6_dev_mc_inc(dev, &in6addr_linklocal_allrouters);

That results in allocating "struct ifmcaddr6" with ff02::2 and adding
it to the idev->mc_list.

On "ifconfig $dev up" nothing interesting happens.

On "ifconfig $dev down" ipv6_mc_down() gets executed. It iterates over
idev->mc_list (in my case: ff02::2, ff02::1, ff01::1) and calls
igmp6_group_dropped() for each entry.

In case of ff02::2 igmp6_group_dropped() calls igmp6_leave_group() which
calls mld_add_delrec(). *That* is when another "struct ifmcaddr6" gets
allocated and gets added to the idev->mc_tomb.

BINGO.

Summary:
Every "ifconfig $dev down" results in:
ipv6_mc_down() → igmp6_group_dropped() → igmp6_leave_group() → mld_add_delrec()
& allocating & adding "struct ifmcaddr6" (ff02::2) to the idev->mc_tomb.


>>> So I still don't know how you could added the ff02::2 on same dev multi times.
>>> Does just do `ip link set $dev down; ip link set $dev up` reproduce your
>>> problem? Or did I miss something?
>>
>> A bit old-fashioned with ifconfig but basically yes, that's my test:
>>
>> iw phy phy0 interface add mon-phy0 type monitor
> 
> What does this step do? Is there a corresponding command for ip link?

A single wireless device can support multiple interfaces. That is what
lets you handle following example cases on a single radio chip:
1. Multiple AP interfaces (different SSIDs)
2. STA (client) interface + monitor interface (raw 802.11 frames)
3. STA (client) interface + AP insterface - wireless bridging

That iw command simply creates network interface for a given radio.


>> for i in $(seq 1 10); do ifconfig mon-phy0 up; ifconfig mon-phy0 down; done
>> iw dev mon-phy0 del
> 
> The other cmd looks normal. BTW, I have create a new patch. The previous one
> will leak ff01::1, ff02::1, ff01::2 as the link up will not re-add them.
> 
> The new patch will join and leave all node/route address when link up/down
> instead of store them. But I don't think it could resolve your issue as the
> code logic is not changed. If you like, you can have a try.

Should I still try it given my above debugging results?
