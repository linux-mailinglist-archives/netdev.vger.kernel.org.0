Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE994C1C8
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 21:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730196AbfFSTyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 15:54:31 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:32799 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfFSTyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 15:54:31 -0400
Received: by mail-io1-f68.google.com with SMTP id u13so541992iop.0
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 12:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x8htgMxK2rSU5JCULaCxMjOjEDAZy/LgmCvEU6T4TAI=;
        b=GCXo01BZC4xYsYoyv93KTxhyv/Da3Ckcqs6g9XraBJSvcQ5LufqqV+5qSIIAK8pdER
         8bJMaIcVCiyk0jayqM5LXeiRHArbqlTGxcmWNlEIZFH02UZJusqh+90H5g4uvfZVM9ZN
         4/GdMZK8Op6xS73cnhDkJk8QZ/tQTs6273bZdEh3lj2BnwoLFELPRv61EFQPaKHddV8o
         eecPQPZ8cAIoVUioHyGfFwx4+DNsXpwvfMIYepfZGipJkbC+S2j0HIXUp1dJAEZiktth
         MASf6D51VxHkYzdFxln/TIdA3yzNIBhLRYjAr2KopPUfnceHrdvylACWxqASa8CM3pCq
         fjrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x8htgMxK2rSU5JCULaCxMjOjEDAZy/LgmCvEU6T4TAI=;
        b=AsOCPUjmTzEWvzBg7sy9qEWGnr4h1+L43dG80Z/kMQqisWq3mHxxVkWmcvLKnY0yIu
         jAQCiK9Io0W4QGPEiSakYvXgFlLwa5bLwtvgCCpOeD2bwosML1XA0hD28pzKuKfD1XrC
         VO+wiC8BtGMMlsFh9FiGVlM6HqWwM95Nac3U7QlCLueNyq5Q7y/vA4oQIbPxWiIMSfKS
         IBDIECRYVQMfUhltJ52Y1q6g5jn1glgMx3bVmDfB2kZdtUSIkK0ydlmvgGv49oRKsBpO
         3yNdqaYD0dapeVPpZEl71Y3winCDgvYYLEG4tPh3MkldghMM5WUdns43ut1NHOE1cCQH
         ifcw==
X-Gm-Message-State: APjAAAXjzFFkf0EoAP6rqSdDon5U8SrKz1C7E/lyjB395hb2Vnb6h7/P
        Z/emvas3O6x5pHNIDtN792I=
X-Google-Smtp-Source: APXvYqzzmrmruWC+DMOSAOqVcTZjkrli16IAiRte4oHjxE5v3H2mrm5lDfiL+9uAmXP0sUH7nZKhsA==
X-Received: by 2002:a6b:c915:: with SMTP id z21mr2464011iof.182.1560974070213;
        Wed, 19 Jun 2019 12:54:30 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:60fa:7b0e:5ad7:3d30? ([2601:284:8200:5cfb:60fa:7b0e:5ad7:3d30])
        by smtp.googlemail.com with ESMTPSA id 15sm20675817ioe.46.2019.06.19.12.54.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 12:54:29 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv6: Check if route exists before notifying it
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20190619175500.7145-1-idosch@idosch.org>
 <69f3262d-e6d0-943e-20a0-c711be4d35d7@gmail.com>
 <20190619194058.GA8498@splinter>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a2e5e94e-fa52-ffbf-f6f0-3a2189d6be77@gmail.com>
Date:   Wed, 19 Jun 2019 13:54:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190619194058.GA8498@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/19 1:40 PM, Ido Schimmel wrote:
> On Wed, Jun 19, 2019 at 01:10:08PM -0600, David Ahern wrote:
>> On 6/19/19 11:55 AM, Ido Schimmel wrote:
>>> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
>>> index 1d16a01eccf5..241a0e9a07c3 100644
>>> --- a/net/ipv6/ip6_fib.c
>>> +++ b/net/ipv6/ip6_fib.c
>>> @@ -393,6 +393,8 @@ int call_fib6_multipath_entry_notifiers(struct net *net,
>>>  		.nsiblings = nsiblings,
>>>  	};
>>>  
>>> +	if (!rt)
>>> +		return -EINVAL;
>>>  	rt->fib6_table->fib_seq++;
>>>  	return call_fib6_notifiers(net, event_type, &info.info);
>>>  }
>>
>> The call to call_fib6_multipath_entry_notifiers in
>> ip6_route_multipath_add happens without rt_notif set because the MPATH
>> spec is empty? 
> 
> There is a nexthop in the syzbot reproducer, but its length is shorter
> than sizeof(struct rtnexthop).

hmmm... I would expect that to be caught by the 'while (rtnh_ok(rtnh,
remaining)) {}' loop.

For the loop 'list_for_each_entry(nh, &rt6_nh_list, next) {}' if the
list is empty then yes, rt_notif is null which should be caught and
handled with EINVAL/extack. If there is at least 1 entry in the list,
rt_notif is set (success adding to fib) or it jumps over the notifier to
add_errout.

> 
>> It seems like that check should be done in ip6_route_multipath_add
>> rather than call_fib6_multipath_entry_notifiers with an extack saying
>> the reason for the failure.
> 
> It seemed consistent with ip6_route_mpath_notify(). We can check if
> rt6_nh_list is empty and send a proper error message. I'll do that
> tomorrow morning since it's already late here.
> 

ok.

