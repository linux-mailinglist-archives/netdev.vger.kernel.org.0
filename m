Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680F818093
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 21:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfEHTib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 15:38:31 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46301 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbfEHTib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 15:38:31 -0400
Received: by mail-pg1-f193.google.com with SMTP id t187so6468120pgb.13
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 12:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uaPXUK0f1Bu/DpPAO1PscqhrWdLiUgmtXDMs6Qyn9Rs=;
        b=kCi0Wid7moo1laFNrC8w645je5NC15QcMF02StXu5eAOfhNOsmHtLf3w05Qs0CZXuR
         /jqS1H8pkNs/NmiH9dnUBgpp/A+SVZPOm6Vae8okz90Jwwo/CkxEIK6+47k4daVoWV+E
         kHDT/AE8Lv6htg7W4Z70ms94dUeT8zitUez5qsPTprjpcIUNKvM1PhT/0N61nKTh/wCH
         6q9ryY63NXnAKaKunUle+KQo2/9hd1Vb6aOI2GYVmu6YYzjc2bFbUzI8HrvjUlLR6tWf
         6lJASff0nyQrpU0h3BK0JXrJBo+A2BiT4SiqUwHUMQyU3+nsHKOJBDdNC89WCzyYCgat
         YrqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uaPXUK0f1Bu/DpPAO1PscqhrWdLiUgmtXDMs6Qyn9Rs=;
        b=CJHz3zgv5JTHYipKe/LPDkdm/Q0jVMGT69uGRIb0vTkBmu+ly7O6AdWmu8gL6PsOFd
         UX1eT7t0URpdhWPTyC1HgB7iQ/u7xplteQwycbiQKkLWyf8Z4t1wVrQv94rN5mTyHAro
         exiBa/fU+UCMb7WAi6De0sg2C/0uKfGYtxHKjqHe8KkN6fJOboK4YYxxGkhlVHBXg+z9
         hJ1ReI2v05CLlgHnjjyb2TkLg3hBMl6cCdDUTSUXtiWgsacM1K3EsZNEjdbnDq/uKohN
         uhxgClEU5WxhITndxn6go5SQJU8DOECxqrnxPvUFIZyOTajwlql0L9LhZ71X7IQ+xoNS
         bYFQ==
X-Gm-Message-State: APjAAAXWl6ulysyoCpcRHGbtLW18wjrgGxg4ooIQWB9uFkwhf8Ih+rH3
        KbqfK/WEceuNC4L9sj+qv8w7zGYB
X-Google-Smtp-Source: APXvYqz7JnL7bNdCqnxIL1Ul3234R/Zb5jx2ssn7wd2as9u7kUbN5z2YtIMmOwOAFj4PnX/bOT8wLw==
X-Received: by 2002:a62:d5c9:: with SMTP id d192mr49977879pfg.109.1557344309936;
        Wed, 08 May 2019 12:38:29 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:2d75:c504:f4c3:5afb? ([2601:282:800:fd80:2d75:c504:f4c3:5afb])
        by smtp.googlemail.com with ESMTPSA id n13sm10961704pgh.6.2019.05.08.12.38.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 12:38:28 -0700 (PDT)
Subject: Re: [PATCH net] selftests: fib_rule_tests: Fix icmp proto with ipv6
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net,
        netdev@vger.kernel.org
References: <20190429173009.8396-1-dsahern@kernel.org>
 <20190430023740.GJ18865@dhcp-12-139.nay.redhat.com>
 <dac5b0ed-fa7e-1723-0067-6c607825ec31@gmail.com>
 <20190507082001.GL18865@dhcp-12-139.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6516acee-4122-9dbb-946b-b4e72638ed98@gmail.com>
Date:   Wed, 8 May 2019 13:38:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190507082001.GL18865@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/7/19 2:20 AM, Hangbin Liu wrote:
> On Tue, Apr 30, 2019 at 12:00:46PM -0600, David Ahern wrote:
>> On 4/29/19 8:37 PM, Hangbin Liu wrote:
>>> An other issue is The IPv4 rule 'from iif' check test failed while IPv6
>>> passed. I haven't found out the reason yet.
>>>
>>> # ip -netns testns rule add from 192.51.100.3 iif dummy0 table 100
>>> # ip -netns testns route get 192.51.100.2 from 192.51.100.3 iif dummy0
>>> RTNETLINK answers: No route to host
>>>
>>>     TEST: rule4 check: from 192.51.100.3 iif dummy0           [FAIL]
>>>
>>> # ip -netns testns -6 rule add from 2001:db8:1::3 iif dummy0 table 100
>>> # ip -netns testns -6 route get 2001:db8:1::2 from 2001:db8:1::3 iif dummy0
>>> 2001:db8:1::2 via 2001:db8:1::2 dev dummy0 table 100 metric 1024 iif dummy0 pref medium
>>>
>>>     TEST: rule6 check: from 2001:db8:1::3 iif dummy0          [ OK ]
>>
>> use perf to look at the fib lookup parameters:
>>   perf record -e fib:* -- ip -netns testns route get 192.51.100.2 from
>> 192.51.100.3 iif dummy0
>>   perf script
> 
> Hi David, Roopa,
> 
> From the perf record the result looks good.
> fib_table_lookup could get correct route.
> 
> For IPv4:
> ip  7155 [001]  8442.915515: fib:fib_table_lookup: table 255 oif 0 iif 2 proto 0 192.51.100.3/0 -> 192.51.100.2/0 tos 0 scope 0 flags 0 ==> dev - gw 0.0.0.0 src 0.0.0.0 err -11
> ip  7155 [001]  8442.915517: fib:fib_table_lookup: table 100 oif 0 iif 2 proto 0 192.51.100.3/0 -> 192.51.100.2/0 tos 0 scope 0 flags 0 ==> dev dummy0 gw 192.51.100.2 src 198.51.100.1 err 0
> 
> For IPv6:
> ip  6950 [000]   759.328850: fib6:fib6_table_lookup: table 255 oif 0 iif 2 proto 0 2001:db8:1::3/0 -> 2001:db8:1::2/0 tos 0 scope 0 flags 0 ==> dev lo gw :: err -113
> ip  6950 [000]   759.328852: fib6:fib6_table_lookup: table 100 oif 0 iif 2 proto 0 2001:db8:1::3/0 -> 2001:db8:1::2/0 tos 0 scope 0 flags 0 ==> dev dummy0 gw 2001:db8:1::2 err 0
> 
> 
> Then I tracked the code and found in function ip_route_input_slow(),
> after fib_lookup(), we got res->type == RTN_UNICAST. So if we haven't
> enabled forwarding, it will return -EHOSTUNREACH.
> 
> But even we enabled forwarding, we still need to disable rp_filter as the
> source/dest address are in the same subnet. The ip_mkroute_input()
> -> __mkroute_input() -> fib_validate_source() -> __fib_validate_source() will
> return -EXDEV if we enabled rp_filter.
> 
> So do you think if we should enable forwarding and disble rp_filter before
> test "from $SRC_IP iif $DEV" or just diable this test directly?
> 

seems to me the test is a bit off; the source, gateway and address on
dummy are all in the same subnet. egress device == ingress device would
cause a redirect. That is right after the valiate_source check.
