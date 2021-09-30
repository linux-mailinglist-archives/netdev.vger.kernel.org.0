Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E68F41DD3E
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 17:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245587AbhI3PVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 11:21:06 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:36754 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245581AbhI3PVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 11:21:05 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id DD1AF200E7B6;
        Thu, 30 Sep 2021 17:19:17 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be DD1AF200E7B6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633015157;
        bh=sLB3OuxTE1vjPG0J/tNwW101xLMRODQKzAlDS8+xqmo=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=YpQrJmR1hKeum+B6NgVQBft+xcDpylY8tSjnNxPOrdXOmJzzifzs9qJShZ3SGC12W
         4uxg5gazT9Uuv89K9N2ul7+0W9jYs/8v7Yjllc0LQVmxILzwCvQzFaQm4ycJieG7+f
         tzzjSks9wTsI7hUmUCxenlY7Q5zEawzVMUBAC8736GOb6NKOm9f42jLN7z09wVDEtv
         U+3AIQawpWc24eGBRy80acPjQNm50WbfE2129GWsFPXBq9cYOH2pqDJH2+KPuCkqVt
         EeTmDO4/aP2rhO9j6x9axDcG3za2pT8LXuSnFv+IsRh88OOxosWGU11MYh9JNaXDNK
         W4dNiHuAPzrTw==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id D4FB660225447;
        Thu, 30 Sep 2021 17:19:17 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fFeu0ygeG1aM; Thu, 30 Sep 2021 17:19:17 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id BA85060225265;
        Thu, 30 Sep 2021 17:19:17 +0200 (CEST)
Date:   Thu, 30 Sep 2021 17:19:17 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Message-ID: <2092322692.108322349.1633015157710.JavaMail.zimbra@uliege.be>
In-Reply-To: <16630ce5-4c61-a16b-8125-8ec697d6c33e@gmail.com>
References: <20210928190328.24097-1-justin.iurman@uliege.be> <20210928190328.24097-2-justin.iurman@uliege.be> <16630ce5-4c61-a16b-8125-8ec697d6c33e@gmail.com>
Subject: Re: [PATCH net-next 1/2] ipv6: ioam: Add support for the ip6ip6
 encapsulation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF92 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Add support for the ip6ip6 encapsulation
Thread-Index: a4QBJ2gFy4PkbP1P6YVvbTkTRprqDQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>  static const struct nla_policy ioam6_iptunnel_policy[IOAM6_IPTUNNEL_MAX + 1] = {
>> -	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct ioam6_trace_hdr)),
>> +	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct
>> ioam6_iptunnel_trace)),
> 
> you can't do that. Once a kernel is released with a given UAPI, it can
> not be changed. You could go the other way and handle
> 
> struct ioam6_iptunnel_trace {
> +	struct ioam6_trace_hdr trace;
> +	__u8 mode;
> +	struct in6_addr tundst;	/* unused for inline mode */
> +};

Makes sense. But I'm not sure what you mean by "go the other way". Should I handle ioam6_iptunnel_trace as well, in addition to ioam6_trace_hdr, so that the uapi is backward compatible?

> Also, no gaps in uapi. Make sure all holes are stated; an anonymous
> entry is best.

Would something like this do the trick?

struct ioam6_iptunnel_trace {
	struct ioam6_trace_hdr trace;
	__u8 mode;
	union { /* anonymous field only used by both the encap and auto modes */
		struct in6_addr tundst;
	};
};

>>  };
>>  
>> -static int nla_put_ioam6_trace(struct sk_buff *skb, int attrtype,
>> -			       struct ioam6_trace_hdr *trace)
>> -{
>> -	struct ioam6_trace_hdr *data;
>> -	struct nlattr *nla;
>> -	int len;
>> -
>> -	len = sizeof(*trace);
>> -
>> -	nla = nla_reserve(skb, attrtype, len);
>> -	if (!nla)
>> -		return -EMSGSIZE;
>> -
>> -	data = nla_data(nla);
>> -	memcpy(data, trace, len);
>> -
>> -	return 0;
>> -}
>> -
> 
> quite a bit of the change seems like refactoring from existing feature
> to allow the new ones. Please submit refactoring changes as a
> prerequisite patch. The patch that introduces your new feature should be
> focused solely on what is needed to implement that feature.

+1, will do.
