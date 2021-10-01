Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8C941EF17
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 16:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352999AbhJAOIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 10:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhJAOIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 10:08:20 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E304C061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 07:06:36 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id g62-20020a9d2dc4000000b0054752cfbc59so11649428otb.1
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 07:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3pQwF166uesR+TtadC8CsY/nHTU+OCDGKYSVAgmFooc=;
        b=RNGJWnd1ftI6IPvvvcxcPVnpqlo5xUA2Vq5ra2BrnVdtYnSBTNITGgO0KxPOc0tKYF
         e6sAlBwerGvooahgxm+TcDrFPhQYOZT6KpKqAD1DRf1DjxV9oIAKwUw6VGB4kvMCU8zf
         67XE5k9aWfyQ91Dy2tjKz1FV0VJZssyUVJoK0EBfK+5k6YgcaKEKy3ThNGInwHJPZ306
         4l7O4zETa9m9J3tiVAgi+VKJa8FS74Gd0bYNOGnrFHjeH+z2iIWvHDmtpt/EkIWUJD1M
         b5WGLXKaym42MdaHrLTfOwKMWOHknG7hl0aNGgchux05L5a0tyib1iAojRj9BRkdINYG
         NlNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3pQwF166uesR+TtadC8CsY/nHTU+OCDGKYSVAgmFooc=;
        b=mKXvQ2uEs01CGIgBEDYS0r8tQGz1KWHHck7FB1S4NTIpL6R5SwjfbBA3+Cj1hfMTA4
         XwatjmWD+yBkY+OEXDDA8tJPtc7OGpbtI6lQ17+Ay91jGm+E3kpjM02c8Lejr2YkhfrX
         b70Ci7RGyI1GQMrqd4iFObNJvh4Sy1QXW3630w6kMHaSxjSRZ+vHdzfnqwK/6n866ZfR
         0BIZQ2rsLm1h2CZb2L+LFBkI0o5f/b7fkuL68A4o54DUP2AvnJlIdlCNu5pqRnijXWO8
         7lO+IFJXhafaeAjX/Zkm79vQjKDSocD5ug9kUcxXC6xIj+nnG8BL+RrUyJnjuAJ+Ql5m
         cLNw==
X-Gm-Message-State: AOAM5335u0b9lTPeN96L7LiR6KTlUo6119Apq7sWwoQeGD0rUcgmC2tN
        2CTFSjmLk5BHRvEHDjLEFuPhLGy0NcXZTA==
X-Google-Smtp-Source: ABdhPJwzRBf/dXyrPNGooiGOaxZ9oYM/iDn+3z/tszuPGHM+mF2UYTP2Hnb/Rw4s6vu54eHUZTBarw==
X-Received: by 2002:a9d:6c52:: with SMTP id g18mr10232717otq.75.1633097195450;
        Fri, 01 Oct 2021 07:06:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id o19sm1180582otj.62.2021.10.01.07.06.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 07:06:34 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] ipv6: ioam: Add support for the ip6ip6
 encapsulation
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
References: <20210928190328.24097-1-justin.iurman@uliege.be>
 <20210928190328.24097-2-justin.iurman@uliege.be>
 <16630ce5-4c61-a16b-8125-8ec697d6c33e@gmail.com>
 <2092322692.108322349.1633015157710.JavaMail.zimbra@uliege.be>
 <0ce98a52-e9fe-9b5c-68ca-f81c88e021ab@gmail.com>
 <625451834.109328801.1633088324880.JavaMail.zimbra@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ab9e1fe3-6f50-ac64-5831-e4e748af1229@gmail.com>
Date:   Fri, 1 Oct 2021 08:06:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <625451834.109328801.1633088324880.JavaMail.zimbra@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/1/21 5:38 AM, Justin Iurman wrote:
>>>>>  static const struct nla_policy ioam6_iptunnel_policy[IOAM6_IPTUNNEL_MAX + 1] = {
>>>>> -	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct ioam6_trace_hdr)),
>>>>> +	[IOAM6_IPTUNNEL_TRACE]	= NLA_POLICY_EXACT_LEN(sizeof(struct
>>>>> ioam6_iptunnel_trace)),
>>>>
>>>> you can't do that. Once a kernel is released with a given UAPI, it can
>>>> not be changed. You could go the other way and handle
>>>>
>>>> struct ioam6_iptunnel_trace {
>>>> +	struct ioam6_trace_hdr trace;
>>>> +	__u8 mode;
>>>> +	struct in6_addr tundst;	/* unused for inline mode */
>>>> +};
>>>
>>> Makes sense. But I'm not sure what you mean by "go the other way". Should I
>>> handle ioam6_iptunnel_trace as well, in addition to ioam6_trace_hdr, so that
>>> the uapi is backward compatible?
>>
>> by "the other way" I meant let ioam6_trace_hdr be the top element in the
>> new ioam6_iptunnel_trace struct. If the IOAM6_IPTUNNEL_TRACE size ==
>> ioam6_trace_hdr then you know it is the legacy argument vs sizeof
>> ioam6_iptunnel_trace which is the new.
> 
> OK, I see. The problem is ioam6_trace_hdr must be the last entry because of its last field, which is "__u8 data[0]". But, anyway, I could still apply the same kind of logic with the size.

ok, forgot about the data field.

Why not make the new data separate attributes then? Avoids the alignment
problem.
