Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2AC41EF2A
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 16:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354163AbhJAOMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 10:12:42 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:56533 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhJAOMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 10:12:42 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 725EB2012176;
        Fri,  1 Oct 2021 16:10:55 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 725EB2012176
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633097455;
        bh=Jfl9HbNaTxgNUKRSonCnug48UhWKK+oMezSso4KTp7Q=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=ETJLjt5YPqIO01YT18Adh+0af2ETA/th2dNjhHxB2iXbdR7JQBD0hcgQ6m2hAI+Ts
         t/IFKDuLNWa7hh79zEPETKUBTwWivOqJUPEKDtA17gKfOyA6tjslbf7Qod0N0+Csec
         ofnYcVK0cfS8F3Q5pKpUTY/utGE8NeUIDeRW8CKUNS/+KK0tnydwcX5n/C1BoZlq9y
         Vb9xUYh4QRXYMkmXCBxaUci7NBwI2eG3+AmXjO9EvHo1Onj5KgmmsF1u3IzOz6KEZz
         L/tAikv6xXBp7/tI0l8LF3XY7kHpHdMuXttF3cfA2LKLzP1Auy9kcba5v7lVJxgA7J
         tAeFVCqav+6mQ==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 69EE660225364;
        Fri,  1 Oct 2021 16:10:55 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id wNf4dcz-LkEP; Fri,  1 Oct 2021 16:10:55 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 5406060224675;
        Fri,  1 Oct 2021 16:10:55 +0200 (CEST)
Date:   Fri, 1 Oct 2021 16:10:55 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Message-ID: <1122696944.109609757.1633097455289.JavaMail.zimbra@uliege.be>
In-Reply-To: <ab9e1fe3-6f50-ac64-5831-e4e748af1229@gmail.com>
References: <20210928190328.24097-1-justin.iurman@uliege.be> <20210928190328.24097-2-justin.iurman@uliege.be> <16630ce5-4c61-a16b-8125-8ec697d6c33e@gmail.com> <2092322692.108322349.1633015157710.JavaMail.zimbra@uliege.be> <0ce98a52-e9fe-9b5c-68ca-f81c88e021ab@gmail.com> <625451834.109328801.1633088324880.JavaMail.zimbra@uliege.be> <ab9e1fe3-6f50-ac64-5831-e4e748af1229@gmail.com>
Subject: Re: [PATCH net-next 1/2] ipv6: ioam: Add support for the ip6ip6
 encapsulation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [139.165.223.37]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF92 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Add support for the ip6ip6 encapsulation
Thread-Index: WJzxhNzVNMq8KUt7GrsMwXtiR21XeA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>>>>>  static const struct nla_policy ioam6_iptunnel_policy[IOAM6_IPTUNNEL_MAX + 1] = {
>>>>>> -	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct ioam6_trace_hdr)),
>>>>>> +	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct
>>>>>> ioam6_iptunnel_trace)),
>>>>>
>>>>> you can't do that. Once a kernel is released with a given UAPI, it can
>>>>> not be changed. You could go the other way and handle
>>>>>
>>>>> struct ioam6_iptunnel_trace {
>>>>> +	struct ioam6_trace_hdr trace;
>>>>> +	__u8 mode;
>>>>> +	struct in6_addr tundst;	/* unused for inline mode */
>>>>> +};
>>>>
>>>> Makes sense. But I'm not sure what you mean by "go the other way". Should I
>>>> handle ioam6_iptunnel_trace as well, in addition to ioam6_trace_hdr, so that
>>>> the uapi is backward compatible?
>>>
>>> by "the other way" I meant let ioam6_trace_hdr be the top element in the
>>> new ioam6_iptunnel_trace struct. If the IOAM6_IPTUNNEL_TRACE size ==
>>> ioam6_trace_hdr then you know it is the legacy argument vs sizeof
>>> ioam6_iptunnel_trace which is the new.
>> 
>> OK, I see. The problem is ioam6_trace_hdr must be the last entry because of its
>> last field, which is "__u8 data[0]". But, anyway, I could still apply the same
>> kind of logic with the size.
> 
> ok, forgot about the data field.
> 
> Why not make the new data separate attributes then? Avoids the alignment
> problem.

Great idea, I'll do that.
