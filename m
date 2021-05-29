Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45C0394D1B
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 18:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhE2QZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 12:25:41 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:50245 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhE2QZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 12:25:39 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 42FF42021097;
        Sat, 29 May 2021 18:24:01 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 42FF42021097
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1622305441;
        bh=RI1bjqfmqPw4hhT4X0UFTar5g9zpxwdRLQEfNrlotm4=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=s4xMrSMjggSCR9Tft9s5ziY2li+NFILiA2+Xht619rVoGjgVGcuwyliQ9yRcznABl
         IzeqkQF6CnauwOCTw/Hjfiw6pqZ/73VsqzRk4Z/X3ry6TVb6iQYkksa1rZ+Ym+OnLO
         tSnzIIAtgHeJ9PJmvR//dO66IqxvBQSWoj6YmJEiJeTIS4IZqApech8l6m3EcJbHey
         1Nh7Ra3+axgbIXhb3DxQxFZ5zYyYAv/d3T0B3x35BXoxhd6MmTb8o1AEyP7vpszjf2
         4upUsQq4AXpJ91rV8JHCMPF0VmK6cNKqYdI2cI/IyxFRoZIxh7s9q+KBaq2ShW/1Tc
         uLrVMYs1hytGQ==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 34EC66008D558;
        Sat, 29 May 2021 18:24:01 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xgh9CIzEmDw8; Sat, 29 May 2021 18:24:01 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 1BDA56008D553;
        Sat, 29 May 2021 18:24:01 +0200 (CEST)
Date:   Sat, 29 May 2021 18:24:01 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tom@herbertland.com, Iurman Justin <Justin.Iurman@uliege.be>
Message-ID: <1049853171.33683948.1622305441066.JavaMail.zimbra@uliege.be>
In-Reply-To: <85a22702-da46-30c2-46c9-66d293d510ff@gmail.com>
References: <20210527151652.16074-1-justin.iurman@uliege.be> <85a22702-da46-30c2-46c9-66d293d510ff@gmail.com>
Subject: Re: [PATCH net-next v4 0/5] Support for the IOAM Pre-allocated
 Trace with IPv6
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF88 (Linux)/8.8.15_GA_4026)
Thread-Topic: Support for the IOAM Pre-allocated Trace with IPv6
Thread-Index: ROAzpLpKa6aUHEG7qHy/X3EV25ljcQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> On 5/27/21 9:16 AM, Justin Iurman wrote:
>> v4:
>>  - Address warnings from checkpatch (ignore errors related to unnamed bitfields
>>    in the first patch)
>>  - Use of hweight32 (thanks Jakub)
>>  - Remove inline keyword from static functions in C files and let the compiler
>>    decide what to do (thanks Jakub)
>> 
>> v3:
>>  - Fix warning "unused label 'out_unregister_genl'" by adding conditional macro
>>  - Fix lwtunnel output redirect bug: dst cache useless in this case, use
>>    orig_output instead
>> 
>> v2:
>>  - Fix warning with static for __ioam6_fill_trace_data
>>  - Fix sparse warning with __force when casting __be64 to __be32
>>  - Fix unchecked dereference when removing IOAM namespaces or schemas
>>  - exthdrs.c: Don't drop by default (now: ignore) to match the act bits "00"
>>  - Add control plane support for the inline insertion (lwtunnel)
>>  - Provide uapi structures
>>  - Use __net_timestamp if skb->tstamp is empty
>>  - Add note about the temporary IANA allocation
>>  - Remove support for "removable" TLVs
>>  - Remove support for virtual/anonymous tunnel decapsulation
>> 
>> In-situ Operations, Administration, and Maintenance (IOAM) records
>> operational and telemetry information in a packet while it traverses
>> a path between two points in an IOAM domain. It is defined in
>> draft-ietf-ippm-ioam-data [1]. IOAM data fields can be encapsulated
>> into a variety of protocols. The IPv6 encapsulation is defined in
>> draft-ietf-ippm-ioam-ipv6-options [2], via extension headers. IOAM
>> can be used to complement OAM mechanisms based on e.g. ICMP or other
>> types of probe packets.
>> 
>> This patchset implements support for the Pre-allocated Trace, carried
>> by a Hop-by-Hop. Therefore, a new IPv6 Hop-by-Hop TLV option is
>> introduced, see IANA [3]. The three other IOAM options are not included
>> in this patchset (Incremental Trace, Proof-of-Transit and Edge-to-Edge).
>> The main idea behind the IOAM Pre-allocated Trace is that a node
>> pre-allocates some room in packets for IOAM data. Then, each IOAM node
>> on the path will insert its data. There exist several interesting use-
>> cases, e.g. Fast failure detection/isolation or Smart service selection.
>> Another killer use-case is what we have called Cross-Layer Telemetry,
>> see the demo video on its repository [4], that aims to make the entire
>> stack (L2/L3 -> L7) visible for distributed tracing tools (e.g. Jaeger),
>> instead of the current L5 -> L7 limited view. So, basically, this is a
>> nice feature for the Linux Kernel.
>> 
>> This patchset also provides support for the control plane part, but only for the
>> inline insertion (host-to-host use case), through lightweight tunnels. Indeed,
>> for in-transit traffic, the solution is to have an IPv6-in-IPv6 encapsulation,
>> which brings some difficulties and still requires a little bit of work and
>> discussion (ie anonymous tunnel decapsulation and multi egress resolution).
>> 
>> - Patch 1: IPv6 IOAM headers definition
>> - Patch 2: Data plane support for Pre-allocated Trace
>> - Patch 3: IOAM Generic Netlink API
>> - Patch 4: Support for IOAM injection with lwtunnels
>> - Patch 5: Documentation for new IOAM sysctls
>> 
>>   [1] https://tools.ietf.org/html/draft-ietf-ippm-ioam-data
>>   [2] https://tools.ietf.org/html/draft-ietf-ippm-ioam-ipv6-options
>>   [3]
>>   https://www.iana.org/assignments/ipv6-parameters/ipv6-parameters.xhtml#ipv6-parameters-2
>>   [4] https://github.com/iurmanj/cross-layer-telemetry
>> 
> 
> These are draft documents from February 2021. Good to have RFC patches
> for others to try the proposed feature, but is really early to be
> committing code to Linux. I think we should wait and see how that
> proposal develops.

Actually, February 2021 is the last update. The main draft (draft-ietf-ippm-ioam-data) has already come a long way (version 12) and has already been Submitted to IESG for Publication. I don't think it would hurt that much to have it in the kernel as we're talking about a stable draft (the other one is just a wrapper to define the encapsulation of IOAM with IPv6) and something useful. And, if you think about Segment Routing for IPv6, it was merged in the kernel when it was still a draft.

Justin
