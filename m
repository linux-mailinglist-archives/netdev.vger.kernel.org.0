Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBC32743BC
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 16:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgIVOAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 10:00:11 -0400
Received: from mail.efficios.com ([167.114.26.124]:56690 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbgIVOAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 10:00:07 -0400
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Sep 2020 10:00:06 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 029972D509D;
        Tue, 22 Sep 2020 09:52:11 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id AwVJoNRsyjJx; Tue, 22 Sep 2020 09:52:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 9ED9D2D509C;
        Tue, 22 Sep 2020 09:52:10 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 9ED9D2D509C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1600782730;
        bh=NYe9knDYdf+nCbdU2QXt7sFbgkE5gewFJ9aj/0JSbgE=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=nowhkNUfcgvo/yqQ9T7fsxzOz2EzfZw9cn1OjOCvWSCReypP7EQjNZmsDIblpaLFu
         iL8lV3ompwHBux9OWBxJm95c7fxKBsz/q/dRI+90tiZsE6Lu3CDvArbe5oYwP8DpVb
         3R3tl0eFCRRuNaojV90UY8nTUtsuU7csQ1NRMq9dcGzYdxK+M+w7e4AQKuWh0g0QCE
         sqXw8uSZTUBEsR+LWv2LP5ziQ7EqEIMnXuBiVb4M1PQevf8PPgQWZ6rJbUaNURknb4
         1m1XND2yhW7S3j5AbsYN9sZ+8wfZGDXuBVxetXiMshyjJ6DzxZfeliHR+o41QBR7vv
         e8WLwWEZf/NDQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id C5WBBT9oHi4x; Tue, 22 Sep 2020 09:52:10 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 9174F2D4DD2;
        Tue, 22 Sep 2020 09:52:10 -0400 (EDT)
Date:   Tue, 22 Sep 2020 09:52:10 -0400 (EDT)
From:   Michael Jeanson <mjeanson@efficios.com>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Ahern <dsahern@gmail.com>
Cc:     David <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1135414696.37989.1600782730509.JavaMail.zimbra@efficios.com>
In-Reply-To: <1383129694.37216.1600716821449.JavaMail.zimbra@efficios.com>
References: <20200918181801.2571-1-mathieu.desnoyers@efficios.com> <390b230b-629b-7f96-e7c9-b28f8b592102@gmail.com> <1453768496.36855.1600713879236.JavaMail.zimbra@efficios.com> <dd1caf15-2ef0-f557-b9a8-26c46739f20b@gmail.com> <1383129694.37216.1600716821449.JavaMail.zimbra@efficios.com>
Subject: Re: [RFC PATCH v2 0/3] l3mdev icmp error route lookup fixes
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3965 (ZimbraWebClient - GC84 (Linux)/8.8.15_GA_3963)
Thread-Topic: l3mdev icmp error route lookup fixes
Thread-Index: oGKu+N8sth3SnnZ9IlBxnz5gbNJQTgU0d63x
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On 21 Sep, 2020, at 15:33, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> ----- On Sep 21, 2020, at 3:11 PM, David Ahern dsahern@gmail.com wrote:
> 
>> On 9/21/20 12:44 PM, Mathieu Desnoyers wrote:
>>> ----- On Sep 21, 2020, at 2:36 PM, David Ahern dsahern@gmail.com wrote:
>>> 
>>>> On 9/18/20 12:17 PM, Mathieu Desnoyers wrote:
>>>>> Hi,
>>>>>
>>>>> Here is an updated series of fixes for ipv4 and ipv6 which which ensure
>>>>> the route lookup is performed on the right routing table in VRF
>>>>> configurations when sending TTL expired icmp errors (useful for
>>>>> traceroute).
>>>>>
>>>>> It includes tests for both ipv4 and ipv6.
>>>>>
>>>>> These fixes address specifically address the code paths involved in
>>>>> sending TTL expired icmp errors. As detailed in the individual commit
>>>>> messages, those fixes do not address similar issues related to network
>>>>> namespaces and unreachable / fragmentation needed messages, which appear
>>>>> to use different code paths.
>>>>>
>>>>
>>>> New selftests are failing:
>>>> TEST: Ping received ICMP frag needed                       [FAIL]
>>>>
>>>> Both IPv4 and IPv6 versions are failing.
>>> 
>>> Indeed, this situation is discussed in each patch commit message:
>>> 
>>> ipv4:
>>> 
>>> [ It has also been pointed out that a similar issue exists with
>>>   unreachable / fragmentation needed messages, which can be triggered by
>>>   changing the MTU of eth1 in r1 to 1400 and running:
>>> 
>>>   ip netns exec h1 ping -s 1450 -Mdo -c1 172.16.2.2
>>> 
>>>   Some investigation points to raw_icmp_error() and raw_err() as being
>>>   involved in this last scenario. The focus of this patch is TTL expired
>>>   ICMP messages, which go through icmp_route_lookup.
>>>   Investigation of failure modes related to raw_icmp_error() is beyond
>>>   this investigation's scope. ]
>>> 
>>> ipv6:
>>> 
>>> [ Testing shows that similar issues exist with ipv6 unreachable /
>>>   fragmentation needed messages.  However, investigation of this
>>>   additional failure mode is beyond this investigation's scope. ]
>>> 
>>> I do not have the time to investigate further unfortunately, so I
>>> thought it best to post what I have.
>>> 
>> 
>> the test setup is bad. You have r1 dropping the MTU in VRF red, but not
>> telling VRF red how to send back the ICMP. e.g., for IPv4 add:
>> 
>>    ip -netns r1 ro add vrf red 172.16.1.0/24 dev blue
>> 
>> do the same for v6.
>> 
>> Also, I do not see a reason for r2; I suggest dropping it. What you are
>> testing is icmp crossing VRF with route leaking, so there should not be
>> a need for r2 which leads to asymmetrical routing (172.16.1.0 via r1 and
>> the return via r2).

The objective of the test was to replicate a clients environment where
packets are crossing from a VRF which has a route back to the source to
one which doesn't while reaching a ttl of 0. If the route lookup for the
icmp error is done on the interface in the first VRF, it can be routed to
the source but not on the interface in the second VRF which is the
current behaviour for icmp errors generated while crossing between VRFs.

There may be a better test case that doesn't involve asymmetric routing
to test this but it's the only way I found to replicate this.
