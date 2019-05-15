Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD9D1F960
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 19:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfEORdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 13:33:00 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36577 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfEORdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 13:33:00 -0400
Received: by mail-pg1-f196.google.com with SMTP id a3so131533pgb.3
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 10:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AR9NJqIMmeNs55j/Mref7Xtr2XcqFLe9lLT9Z/QVWls=;
        b=uR+hG6xsZ8gMCq4H8jolmsKLhMPmkl+8cL3nK0lEt5CBJ+hbeBBYCNnGkimUIlFOAD
         UPhYssWtbHI7cR3MxV20Y+uOE7j3mIlH5bZztLhZ3STuTNrQXpSMewAHxTK7YSBWnjKU
         97NsfgmKlUmcfwoGvCx0PiyAjTU5eNBQWfG4m4SirkV7BY+5sEcu+fu5rC5UtIA8Dzub
         zDoeGVAPvejR7qcLiN1aOQ9CC35aIYRWIxGlMqNPPENJp4ZNOT9cvhu5DQFW/juwX+pw
         7rj5IVGq5qdhKthhKw7sYssHsYg9u5+d5aHSSMqYCztJPn/juBrOkQ572CECv+UQ5FPM
         nXMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AR9NJqIMmeNs55j/Mref7Xtr2XcqFLe9lLT9Z/QVWls=;
        b=YGEz/pAJMGqN24+V41Akggx0zDnGpzKMH1MClZh1UMuGC6h5yZZ9Wt6B1M01yWUKb/
         GzIZIOzcNyWik3hQEwJBGiwIMrKMt9XKOBSSrbAytvryatE8C+n6Z4JZQffHDqeMveml
         clXdVH6BvpOTVCki9UVXZULhMpjZGxRZqGjxtg/Gm2ya+OlqJEPABGbbMyvjpDPI6AzU
         Alq9DQT/TBr7LhZSbBq3VbOn+NYbVcbghFWL+/JhmRfnCvMT1HpWpx8iIUgxyA7aLpKI
         fGSNLxQfTyu9awdFh7foijCMiu4ZjBCXCc6W3p3e3jCRxECdBqtGqyPZkFk1BjljCUDw
         xF/w==
X-Gm-Message-State: APjAAAVLicFQuI2CIh78quf0DM/TgTz4bgCrjUwQIWPeG//06rGmbZn3
        bxCBLN08AGse/6dD2JdvFC0=
X-Google-Smtp-Source: APXvYqxFkuAyX3OhfmLVboobse9Fp6GJbwEsj7QvrHLtutB55GWMscypERvqjMYpqyUaQwXUXg0Q8w==
X-Received: by 2002:a63:785:: with SMTP id 127mr42917377pgh.230.1557941579445;
        Wed, 15 May 2019 10:32:59 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:81dc:8ee9:edb2:6ea? ([2601:282:800:fd80:81dc:8ee9:edb2:6ea])
        by smtp.googlemail.com with ESMTPSA id x17sm4241642pgh.47.2019.05.15.10.32.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 10:32:58 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: fix src addr routing with the exception table
To:     Wei Wang <weiwan@google.com>
Cc:     Wei Wang <tracywwnj@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        Eric Dumazet <edumazet@google.com>
References: <20190515004610.102519-1-tracywwnj@gmail.com>
 <fdded637-fd19-bcab-87aa-b71ca8158735@gmail.com>
 <95d844f2-1be2-83b9-1910-e90ad3d2b28d@gmail.com>
 <CAEA6p_B8-zBPxzcNSdpK+2U2eOU0efQBSu1dMx3sEV7r1+c8oA@mail.gmail.com>
 <CAEA6p_D0-dT4a-wqz7DMq8dSNbESRkj40ESTTxdnbPar-0N90g@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a1fa84e7-e474-9488-ddc5-e139ab1f2e05@gmail.com>
Date:   Wed, 15 May 2019 11:32:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAEA6p_D0-dT4a-wqz7DMq8dSNbESRkj40ESTTxdnbPar-0N90g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/15/19 11:28 AM, Wei Wang wrote:
> From: Wei Wang <weiwan@google.com>
> Date: Wed, May 15, 2019 at 10:25 AM
> To: David Ahern
> Cc: Wei Wang, David Miller, Linux Kernel Network Developers, Martin
> KaFai Lau, Mikael Magnusson, Eric Dumazet
> 
>>>
>>> What about rt6_remove_exception_rt?
>>>
>>> You can add a 'cache' hook to ip/iproute.c to delete the cached routes
>>> and verify that it works. I seem to have misplaced my patch to do it.
>> I don't think rt6_remove_exception_rt() needs any change.
>> It is because it gets the route cache rt6_info as the input parameter,
>> not specific saddr or daddr from a flow or a packet.
>> It is guaranteed that the hash used in the exception table is
>> generated from rt6_info->rt6i_dst and rt6_info->rt6i_src.
>>
>> For the case where user tries to delete a cache route, ip6_route_del()
>> calls rt6_find_cached_rt() to find the cached route first. And
>> rt6_find_cached_rt() is taken care of to find the cached route
>> according to both passed in src addr and f6i->fib6_src.
>> So I think we are good here.
>>
>> From: David Ahern <dsahern@gmail.com>
>> Date: Wed, May 15, 2019 at 9:38 AM
>> To: Wei Wang, David Miller, <netdev@vger.kernel.org>
>> Cc: Martin KaFai Lau, Wei Wang, Mikael Magnusson, Eric Dumazet
>>
>>> On 5/15/19 9:56 AM, David Ahern wrote:
>>>> You can add a 'cache' hook to ip/iproute.c to delete the cached routes
>>>> and verify that it works. I seem to have misplaced my patch to do it.
>>>
>>> found it.
> 
> Thanks. I patched it to iproute2 and tried it.
> The route cache is removed by doing:
> ip netns exec a ./ip -6 route del fd01::c from fd00::a cache 
> 

you have to pass in a device. The first line in ip6_del_cached_rt:

if (cfg->fc_ifindex && rt->dst.dev->ifindex != cfg->fc_ifindex)
                goto out;

'ip route get' is one way to check if it has been deleted. We really
need to add support for dumping exception routes.
