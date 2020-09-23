Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77B52760CC
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 21:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgIWTMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 15:12:19 -0400
Received: from mail.efficios.com ([167.114.26.124]:35242 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgIWTMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 15:12:18 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 744C62CD83A;
        Wed, 23 Sep 2020 15:12:17 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id JeUU4c6PqkBq; Wed, 23 Sep 2020 15:12:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 2D4082CD839;
        Wed, 23 Sep 2020 15:12:17 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 2D4082CD839
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1600888337;
        bh=0+vqx9GNCqAM2HTXZMZOTLmrSfcfG5yuByjThaEOjQU=;
        h=To:From:Message-ID:Date:MIME-Version;
        b=HGiiZsyVizYpqiwDbJosoWRYKfoBEFCBGmKBWr5/zoZscnBV3H2q2rOe1b4vrqgHu
         +Sa2Y8Yw4qFrj/zPv5KO6KCcQjl3YbGM+xoA1NeEIREl+28mHviwUywnnGwEUpPNSy
         Zw0BQ0jbILtrR4LL9rNaUx/SUZ6Vrw7oR1uG3rYfPUQTH29oKb1etZ4IJllPLns/ZV
         72pGTrkAgCAivYp/JsLrlTLJSU7UtP53N+RTWs9HstxOvzH8+MgimtbYRxzdZznXwa
         OJVfqVtvT4KMeYYu3wYqhaAoZLbQkXeNWU38X7rmqf82l4IWkXKxpD76bBsIsCriT5
         GKD+py2uMA8MQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id lKKjIEr5PrqH; Wed, 23 Sep 2020 15:12:17 -0400 (EDT)
Received: from [10.10.0.55] (96-127-212-112.qc.cable.ebox.net [96.127.212.112])
        by mail.efficios.com (Postfix) with ESMTPSA id 0D9E02CD6AC;
        Wed, 23 Sep 2020 15:12:17 -0400 (EDT)
Subject: Re: [RFC PATCH v2 0/3] l3mdev icmp error route lookup fixes
To:     David Ahern <dsahern@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     David <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200918181801.2571-1-mathieu.desnoyers@efficios.com>
 <390b230b-629b-7f96-e7c9-b28f8b592102@gmail.com>
 <1453768496.36855.1600713879236.JavaMail.zimbra@efficios.com>
 <dd1caf15-2ef0-f557-b9a8-26c46739f20b@gmail.com>
 <1383129694.37216.1600716821449.JavaMail.zimbra@efficios.com>
 <1135414696.37989.1600782730509.JavaMail.zimbra@efficios.com>
 <4456259a-979a-7821-ef3d-aed5d330ed2b@gmail.com>
 <730d8a09-7d3b-1033-4131-520dc42e8855@efficios.com>
 <47175ae8-e7e8-473c-5103-90bf444db16c@efficios.com>
 <cfdc41d9-cca1-7166-1a2e-778ac4bf8b73@gmail.com>
From:   Michael Jeanson <mjeanson@efficios.com>
Message-ID: <b86a635d-774e-9e9b-a8bd-7abe3eb9a26d@efficios.com>
Date:   Wed, 23 Sep 2020 15:12:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <cfdc41d9-cca1-7166-1a2e-778ac4bf8b73@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-23 14 h 46, David Ahern wrote:
> On 9/23/20 11:03 AM, Michael Jeanson wrote:
>> On 2020-09-23 12 h 04, Michael Jeanson wrote:
>>>> It should work without asymmetric routing; adding the return route to
>>>> the second vrf as I mentioned above fixes the FRAG_NEEDED problem. It
>>>> should work for TTL as well.
>>>>
>>>> Adding a second pass on the tests with the return through r2 is fine,
>>>> but add a first pass for the more typical case.
>>>
>>> Hi,
>>>
>>> Before writing new tests I just want to make sure we are trying to fix
>>> the same issue. If I add a return route to the red VRF then we don't
>>> need this patchset because whether the ICMP error are routed using the
>>> table from the source or destination interface they will reach the
>>> source host.
>>>
>>> The issue for which this patchset was sent only happens when the
>>> destination interface's VRF doesn't have a route back to the source
>>> host. I guess we might question if this is actually a bug or not.
>>>
>>> So the question really is, when a packet is forwarded between VRFs
>>> through route leaking and an icmp error is generated, which table
>>> should be used for the route lookup? And does it depend on the type of
>>> icmp error? (e.g. TTL=1 happens before forwarding, but fragmentation
>>> needed happens after when on the destination interface)
>>
>> As a side note, I don't mind reworking the tests as you requested even
>> if the patchset as a whole ends up not being needed and if you think
>> they are still useful. I just wanted to make sure we understood each other.
>>
> 
> if you are leaking from VRF 1 to VRF 2 and you do not configure VRF 2
> with how to send to errors back to source - MTU or TTL - then I will
> argue that is a configuration problem, not a bug.
> 
> Now the TTL problem is interesting. You need the FIB lookup to know that
> the packet is forwarded, and by the time of the ttl check in ip_forward
> skb->dev points to the ingress VRF and dst points to the egress VRF. So
> I think the change is warranted.
> 
> Let's do this for the tests:
> 1 pass through all of the tests (TTL and MTU, v4 and v6) with symmetric
> routing configured and make sure they all pass. ie., keep all of them
> and make sure all tests pass. No sense losing the tests and the thoughts
> behind them.
> 
> Add a second pass with the asymmetric routing per the customer setup
> since it motivated the investigation.
> 
> Rename the test to something like vrf_route_leaking.sh. It can be
> expanded with more tests related to route leaking as they come up.
> 

Just a final clarification, the asymmetric setup would have no return 
route in VRF 2 and only test the TTL case since the others would fail?
