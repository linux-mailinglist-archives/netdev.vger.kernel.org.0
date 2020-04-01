Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5A9019B6AE
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 22:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732860AbgDAUAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 16:00:32 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:40604 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732385AbgDAUAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 16:00:31 -0400
Received: by mail-qv1-f68.google.com with SMTP id bp12so419447qvb.7
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 13:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8NcRHCtOSM5adY4o2+jx12O7LZxVQWgfHCad3CXRytE=;
        b=BAsRigWV8hDF9XHP74IIOXGezxspmhMqv5XAIxtP3AsaVZynMYlW5MQszuumJ9Cr2r
         UZn9C/R58JvfULwcGZU73403qN3fdROxZjryS/LeJl8OS7cT7+uLOQsMQA6BucS6OrAJ
         uUz9zfxuZhLeefX9vZ+k6DX1YOC/1RVtVNWgrsbtCBgtMyl27k1b0gHKq//4ATCdAZf1
         GkmnaPLRaAgvHamFY+zxf9HDUQxhuOxp7dCt14B+v8FMUexSxtyegssEX+EYZVPC30yJ
         /STmxpqA8UVWxjBIWyC2rLnPGKrMwCZ0AiRBfJtxvrzgspfj9S8UNFPrE5h2MPf0Uopm
         TIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8NcRHCtOSM5adY4o2+jx12O7LZxVQWgfHCad3CXRytE=;
        b=Quy5UYHsC6t0H8fPuTgAWEFIsd6sNYmTd8xZpSYBlvkrbbNAzuwluP9k5YA6KYQyRN
         kGJzZnkEn/vVuMkpxh8pTKvQOBhA8VnvXjfPzHy3KekTw999O0/UhLSvovLa1g+0u15j
         qzu4NY91Pqj8eSi7YQbYDYEjjwNjHrSvj1V20LnxFu+xQFPUkoj+EViSBRFHq3x8Yi2a
         CjEYPza//i9yVPmwDTm/9Ox+Uq868TrMjBukNdiGlDdafrkkEK5i8NC0vpbyBCdeyWTq
         NbJR6jxrvVKDAw70HdrW6nvPHB7+3dcliPsPdHynDSfbQDCX2zqTByXtMX++/It+2HI9
         ma3A==
X-Gm-Message-State: ANhLgQ1FZkvSZ8l9+KcX+YQs8wSjvHn+7Il7T1lUHh4fs6ZUhwP9lET/
        Hc77zDgVnpuySJBkvFGPZHI=
X-Google-Smtp-Source: ADFU+vvqJ+n1UAsSgoN0jG9AW0erxHLenY5HOrYrijXI8r9AfrtIvrVniL1JHDoBGmcVcFOzrtbTrA==
X-Received: by 2002:ad4:436b:: with SMTP id u11mr22436408qvt.117.1585771229291;
        Wed, 01 Apr 2020 13:00:29 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f8fc:a46d:375f:4fa2? ([2601:282:803:7700:f8fc:a46d:375f:4fa2])
        by smtp.googlemail.com with ESMTPSA id 207sm2101569qkf.69.2020.04.01.13.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 13:00:28 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 1/3] tc: p_ip6: Support pedit of IPv6
 dsfield
To:     Petr Machata <petrm@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
References: <cover.1585331173.git.petrm@mellanox.com>
 <628ade92d458e62f9471911d3cf8f3b193212eaa.1585331173.git.petrm@mellanox.com>
 <20200327175123.1930e099@hermes.lan> <87eetafdki.fsf@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0686d67a-84e8-dfab-7200-c67105420bcb@gmail.com>
Date:   Wed, 1 Apr 2020 14:00:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87eetafdki.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/20 2:32 AM, Petr Machata wrote:
> 
> Stephen Hemminger <stephen@networkplumber.org> writes:
> 
>>> diff --git a/tc/p_ip6.c b/tc/p_ip6.c
>>> index 7cc7997b..b6fe81f5 100644
>>> --- a/tc/p_ip6.c
>>> +++ b/tc/p_ip6.c
>>> @@ -56,6 +56,22 @@ parse_ip6(int *argc_p, char ***argv_p,
>>>  		res = parse_cmd(&argc, &argv, 4, TU32, 0x0007ffff, sel, tkey);
>>>  		goto done;
>>>  	}
>>> +	if (strcmp(*argv, "traffic_class") == 0 ||
>>> +	    strcmp(*argv, "tos") == 0 ||
>>> +	    strcmp(*argv, "dsfield") == 0) {
>>> +		NEXT_ARG();
>>> +		tkey->off = 1;
>>> +		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
>>> +
>>> +		/* Shift the field by 4 bits on success. */
>>> +		if (!res) {
>>> +			int nkeys = sel->sel.nkeys;
>>> +			struct tc_pedit_key *key = &sel->sel.keys[nkeys - 1];
>>> +			key->mask = htonl(ntohl(key->mask) << 4 | 0xf);
>>> +			key->val = htonl(ntohl(key->val) << 4);
>>> +		}
>>> +		goto done;
>>> +	}
>> Why in the middle of the list?
> 
> Because that's the order IPv4 code does them.

neither parse function uses matches() so the order should not matter.
> 
>> Why three aliases for the same value?
>> Since this is new code choose one and make it match what IPv6 standard
>> calls that field.
> 
> TOS because flower also calls it TOS, even if it's the IPv6 field.
> dsfield, because the IPv4 pedit also accepts this. I'm fine with just
> accepting traffic_class though.
> 

that's probably the right thing to do since this is ipv6 related
