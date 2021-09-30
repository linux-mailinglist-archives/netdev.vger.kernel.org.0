Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FB241E0FB
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 20:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350775AbhI3SWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 14:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350744AbhI3SWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 14:22:08 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97B1C06176A
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 11:20:23 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id n64so8453209oih.2
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 11:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lf+VoCriw5DB0o5daX4RDUCtEQx84DR82AMmLvovZHk=;
        b=JeC5VwI4nIwH8N2C5nRWUHWrhp99hVM9xRWgIq7K/JNA/mO5tn+09jvUfXwITKoN6b
         shqzmGNlrDMnsDJYN4N1+Ogv6MSIcw5EExbLvav3IIAzVSF6oQewr0+lxjerhVvlkUuS
         NLa2LLUkIrOern+Xm+U3JWg4NyDLgPmQ618/nbBJhpGc3nXA5aMUHmTV4aqaJeto9tbJ
         8eLDMUTNPJIgm4bblxp9nfgkzZOk2NHKb0N0unDn5f82Y6Kf5sGqU5gDh8b/uyp6t6NT
         +RD3jTcGtVdmQyFu5dbTiFPXJHwok4t/wqyceXpdceN5QnyFgm0/dxfpfInOQK9MLDip
         +rBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lf+VoCriw5DB0o5daX4RDUCtEQx84DR82AMmLvovZHk=;
        b=B7VCPdY+OzSzmQGkeOzedgUGKfX6Ha+t5JCJ7gdEpYS5xNa/QF5KMNYM4QWF17zYyx
         bnrVUazj+wnbJznCnO9pU8EsU5yBlFmY0PS2Fmk13Jpi/Ari1CyO9wEnX8/ZROl/N67N
         BH663IJkA87o6YQ9T0PRG1J+XmLlwFml/W7Db2owDch4nRZiIVrWNg3R5YMKd4hY39WK
         mS2L2mlJvqr90O8xUUUv/+btnUGK6VlhSi0NXFilMIhSWahrc/aUtE9ugazU+U0qLUbC
         SAd00OTeHeXPxa5V7Sj/gK6jCGTep/pIEZXioqaqTpq0snZhnFC1ypaGSGkiqi2+zbD6
         tahg==
X-Gm-Message-State: AOAM5322VlFgkwGBBM0y4a5iLBkpyybHFrgYbkUHfNYvK/gcSHh/K3ip
        ibTXW9u3s2xkHkmRZsI/EqDLXRCLm9tgAA==
X-Google-Smtp-Source: ABdhPJxOM/MGScfNs2uJ7AMJzAmO6T4F88bPrIqdarq6v1cW47r7CR+j195BeKDWE8lsTYQp8XUjaw==
X-Received: by 2002:a05:6808:30d:: with SMTP id i13mr588852oie.0.1633026023115;
        Thu, 30 Sep 2021 11:20:23 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id a9sm698244otk.3.2021.09.30.11.20.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 11:20:22 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] ipv6: ioam: Add support for the ip6ip6
 encapsulation
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
References: <20210928190328.24097-1-justin.iurman@uliege.be>
 <20210928190328.24097-2-justin.iurman@uliege.be>
 <16630ce5-4c61-a16b-8125-8ec697d6c33e@gmail.com>
 <2092322692.108322349.1633015157710.JavaMail.zimbra@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0ce98a52-e9fe-9b5c-68ca-f81c88e021ab@gmail.com>
Date:   Thu, 30 Sep 2021 12:20:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <2092322692.108322349.1633015157710.JavaMail.zimbra@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/21 9:19 AM, Justin Iurman wrote:
>>>  static const struct nla_policy ioam6_iptunnel_policy[IOAM6_IPTUNNEL_MAX + 1] = {
>>> -	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct ioam6_trace_hdr)),
>>> +	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct
>>> ioam6_iptunnel_trace)),
>>
>> you can't do that. Once a kernel is released with a given UAPI, it can
>> not be changed. You could go the other way and handle
>>
>> struct ioam6_iptunnel_trace {
>> +	struct ioam6_trace_hdr trace;
>> +	__u8 mode;
>> +	struct in6_addr tundst;	/* unused for inline mode */
>> +};
> 
> Makes sense. But I'm not sure what you mean by "go the other way". Should I handle ioam6_iptunnel_trace as well, in addition to ioam6_trace_hdr, so that the uapi is backward compatible?

by "the other way" I meant let ioam6_trace_hdr be the top element in the
new ioam6_iptunnel_trace struct. If the IOAM6_IPTUNNEL_TRACE size ==
ioam6_trace_hdr then you know it is the legacy argument vs sizeof
ioam6_iptunnel_trace which is the new.

> 
>> Also, no gaps in uapi. Make sure all holes are stated; an anonymous
>> entry is best.
> 
> Would something like this do the trick?
> 
> struct ioam6_iptunnel_trace {
> 	struct ioam6_trace_hdr trace;
> 	__u8 mode;
> 	union { /* anonymous field only used by both the encap and auto modes */
> 		struct in6_addr tundst;
> 	};
> };

By anonymous filling of the holes I meant something like:

struct ioam6_iptunnel_trace {
	struct ioam6_trace_hdr trace;
	__u8 mode;
	__u8 :8;
	__u16 :16;

	struct in6_addr tundst;
};

Use pahole to check that struct for proper alignment of the entries as
desired (4-byte or 8-byte aligned).

> 
>>>  };
>>>  
>>> -static int nla_put_ioam6_trace(struct sk_buff *skb, int attrtype,
>>> -			       struct ioam6_trace_hdr *trace)
>>> -{
>>> -	struct ioam6_trace_hdr *data;
>>> -	struct nlattr *nla;
>>> -	int len;
>>> -
>>> -	len = sizeof(*trace);
>>> -
>>> -	nla = nla_reserve(skb, attrtype, len);
>>> -	if (!nla)
>>> -		return -EMSGSIZE;
>>> -
>>> -	data = nla_data(nla);
>>> -	memcpy(data, trace, len);
>>> -
>>> -	return 0;
>>> -}
>>> -
>>
>> quite a bit of the change seems like refactoring from existing feature
>> to allow the new ones. Please submit refactoring changes as a
>> prerequisite patch. The patch that introduces your new feature should be
>> focused solely on what is needed to implement that feature.
> 
> +1, will do.
> 

