Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EE728B559
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 14:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbgJLM5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 08:57:46 -0400
Received: from mail.efficios.com ([167.114.26.124]:56968 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgJLM5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 08:57:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 6E2192E94B0;
        Mon, 12 Oct 2020 08:57:44 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id zzgRLQsjls-3; Mon, 12 Oct 2020 08:57:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 1A3C52E96B3;
        Mon, 12 Oct 2020 08:57:44 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 1A3C52E96B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1602507464;
        bh=A7Rs+UibZx15eSVRAKpSHr4WZP1M49/vcRp0vVovGQE=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=mx9tJeTXxXGIBVdYITPoojY6Y8AcD8qt0TrV7qxV5r/vARMhY3lD77wzJMBGtvn88
         gg/0jboTI8kYb+161Gu9Dj7YO0JcSQ7xYYUmbZ5wumHLS4wjjAe+Z1Pljwk9xtXz95
         3e0uUS3n6p9u/PR01xiz20KqwwhDdZyZFPeeUag+aYU4vOOLGrt3RWQ/cb4INuxY/y
         YHtFe/tvQpBdgh2OHSuYp6rVjEKyA9URsj1sNeBN20bdgKHRbwLG8WcOjMthGD4XHy
         G7BhD+QpxdEuAz/8xOxVt6NijLcEuGZgEEvVgPSSsw2D+S6TOsymrKkYGBx08KW9dq
         WS34XRsWWVkXg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id B8Oa4iypHn8U; Mon, 12 Oct 2020 08:57:44 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 0DA8B2E96B2;
        Mon, 12 Oct 2020 08:57:44 -0400 (EDT)
Date:   Mon, 12 Oct 2020 08:57:43 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Michael Jeanson <mjeanson@efficios.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <2056270363.16428.1602507463959.JavaMail.zimbra@efficios.com>
In-Reply-To: <19cf586d-4c4e-e18c-cd9e-3fde3717a9e1@gmail.com>
References: <20200925200452.2080-1-mathieu.desnoyers@efficios.com> <fd970150-f214-63a3-953c-769fa2787bc0@gmail.com> <19cf586d-4c4e-e18c-cd9e-3fde3717a9e1@gmail.com>
Subject: Re: [RFC PATCH 0/3] l3mdev icmp error route lookup fixes
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3968 (ZimbraWebClient - FF81 (Linux)/8.8.15_GA_3968)
Thread-Topic: l3mdev icmp error route lookup fixes
Thread-Index: Hsh0Bfwvay1HJAuoIUEeMWW53XzqkA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Oct 11, 2020, at 7:56 PM, David Ahern dsahern@gmail.com wrote:

> On 10/5/20 9:30 AM, David Ahern wrote:
>> On 9/25/20 1:04 PM, Mathieu Desnoyers wrote:
>>> Hi,
>>>
>>> Here is an updated series of fixes for ipv4 and ipv6 which which ensure
>>> the route lookup is performed on the right routing table in VRF
>>> configurations when sending TTL expired icmp errors (useful for
>>> traceroute).
>>>
>>> It includes tests for both ipv4 and ipv6.
>>>
>>> These fixes address specifically address the code paths involved in
>>> sending TTL expired icmp errors. As detailed in the individual commit
>>> messages, those fixes do not address similar icmp errors related to
>>> network namespaces and unreachable / fragmentation needed messages,
>>> which appear to use different code paths.
>>>
>>> The main changes since the last round are updates to the selftests.
>>>
>> 
>> This looks fine to me. I noticed the IPv6 large packet test case is
>> failing; the fib6 tracepoint is showing the loopback as the iif which is
>> wrong:
>> 
>> ping6  8488 [004]   502.015817: fib6:fib6_table_lookup: table 255 oif 0
>> iif 1 proto 58 ::/0 -> 2001:db8:16:1::1/0 tos 0 scope 0 flags 0 ==> dev
>> lo gw :: err -113
>> 
>> I will dig into it later this week.
>> 
> 
> I see the problem here -- source address selection is picking ::1. I do
> not have a solution to the problem yet, but its resolution is
> independent of the change in this set so I think this one is good to go.

OK, do you want to pick up the RFC patch series, or should I re-send it
without RFC tag ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
