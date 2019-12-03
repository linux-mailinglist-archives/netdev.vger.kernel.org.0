Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF453110627
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 21:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfLCUuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 15:50:03 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41375 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727244AbfLCUuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 15:50:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575406200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xOdDzoBHrdXt25B1TGbYRPetJRHb3vnq/I9dv5wRbj8=;
        b=NDzfTTxn6RGbJBeKukixQ9UYJqKDy6anVSBOTTyHhKWjQQ0WQEXBzabwOa+c3Lvj5TTALb
        gRtgttqBrDSEq7i5muyOaJ/PYam15yImo2VrrUIvwSJLjzQJ+7sBUjbm+/yDc3ce4R0Ucx
        4IkC7mUa+Yv/XNviU3r6QyH36S0djvg=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-kikvV6_gPBOln9Od79_evA-1; Tue, 03 Dec 2019 15:49:57 -0500
Received: by mail-qk1-f200.google.com with SMTP id g28so3087516qkl.6
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 12:49:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xOdDzoBHrdXt25B1TGbYRPetJRHb3vnq/I9dv5wRbj8=;
        b=fdJ4ySJ2ITtqsPautr8K5hxxHOD7Xp4noP3WYlsXQDfoLoZE96CGJSYOpT+jULlAUH
         svrTDpFFewQOUXSKTXvwZozNcDuQWv0u2ulYvNRmw9i5OjJRE2sNxUSVqX6BrKyKcaIj
         roIEK6XE07APy1yxj2LVQgI3SG9Wo95wi0P0u8RYzHHycLmqUdch56osuC/0JQUfOfIO
         JEHfkItZCcON5qlR/EFvuSQ0yRQVhfxmWVJGxAe2SJ5qqDzqt0E/SZd+uuiobCh1FIf2
         jTYJ1WzwIXILv/evQUzj3l7rGHjnONII6jj3JWLdkw0dePqEenVj0NjjGkKcR8V60JKY
         UJrw==
X-Gm-Message-State: APjAAAU35nMboqA8lGWhtTIH2k1mCD4RPYGa8dECsTEsoGunfOFq5nVY
        Lc2LM+HqCRQ3KaTCxnLYdw5JOcHQToxLSmYbC0djeOiRI6Z5Mh2eugC2it++C4JiYoRPQJYIpim
        du2gxsEWGI3bvs+18
X-Received: by 2002:a37:9f57:: with SMTP id i84mr7320326qke.29.1575406196865;
        Tue, 03 Dec 2019 12:49:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqz2ZyKiDHR4+dc8jEsXnoRi77YclrtSWzxFwP5IV9PRHVu44DDdxVPdxPAro6RiwMRItglHtg==
X-Received: by 2002:a37:9f57:: with SMTP id i84mr7320296qke.29.1575406196485;
        Tue, 03 Dec 2019 12:49:56 -0800 (PST)
Received: from [192.168.1.157] (pool-96-235-39-235.pitbpa.fios.verizon.net. [96.235.39.235])
        by smtp.gmail.com with ESMTPSA id s127sm2405349qkc.44.2019.12.03.12.49.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2019 12:49:55 -0800 (PST)
Subject: Re: [PATCH] netfilter: nf_flow_table_offload: Correct memcpy size for
 flow_overload_mangle
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
References: <20191203160345.24743-1-labbott@redhat.com>
 <20191203170114.GB377782@localhost.localdomain>
From:   Laura Abbott <labbott@redhat.com>
Message-ID: <9bc4b04b-a3cc-4e58-4c73-1d77b7ed05da@redhat.com>
Date:   Tue, 3 Dec 2019 15:49:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191203170114.GB377782@localhost.localdomain>
Content-Language: en-US
X-MC-Unique: kikvV6_gPBOln9Od79_evA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/3/19 12:01 PM, Marcelo Ricardo Leitner wrote:
> On Tue, Dec 03, 2019 at 11:03:45AM -0500, Laura Abbott wrote:
>> The sizes for memcpy in flow_offload_mangle don't match
>> the source variables, leading to overflow errors on some
>> build configurations:
>>
>> In function 'memcpy',
>>      inlined from 'flow_offload_mangle' at net/netfilter/nf_flow_table_offload.c:112:2,
>>      inlined from 'flow_offload_port_dnat' at net/netfilter/nf_flow_table_offload.c:373:2,
>>      inlined from 'nf_flow_rule_route_ipv4' at net/netfilter/nf_flow_table_offload.c:424:3:
>> ./include/linux/string.h:376:4: error: call to '__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter
>>    376 |    __read_overflow2();
>>        |    ^~~~~~~~~~~~~~~~~~
>> make[2]: *** [scripts/Makefile.build:266: net/netfilter/nf_flow_table_offload.o] Error 1
>>
>> Fix this by using the corresponding type.
>>
>> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>> ---
>> Seen on a Fedora powerpc little endian build with -O3 but it looks like
>> it is correctly catching an error with doing a memcpy outside the source
>> variable.
> 
> Hi,
> 
> It is right but the fix is not. In that call trace:
> 
> flow_offload_port_dnat() {
> ...
>          u32 mask = ~htonl(0xffff);
>          __be16 port;
> ...
>          flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
> 	                            (u8 *)&port, (u8 *)&mask);
> }
> 
> port should have a 32b storage as well, and aligned with the mask.
> 
>> ---
>>   net/netfilter/nf_flow_table_offload.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
>> index c54c9a6cc981..526f894d0bdb 100644
>> --- a/net/netfilter/nf_flow_table_offload.c
>> +++ b/net/netfilter/nf_flow_table_offload.c
>> @@ -108,8 +108,8 @@ static void flow_offload_mangle(struct flow_action_entry *entry,
>>   	entry->id = FLOW_ACTION_MANGLE;
>>   	entry->mangle.htype = htype;
>>   	entry->mangle.offset = offset;
>> -	memcpy(&entry->mangle.mask, mask, sizeof(u32));
>> -	memcpy(&entry->mangle.val, value, sizeof(u32));
>                                     ^^^^^         ^^^ which is &port in the call above
>> +	memcpy(&entry->mangle.mask, mask, sizeof(u8));
>> +	memcpy(&entry->mangle.val, value, sizeof(u8));
> 
> This fix would cause it to copy only the first byte, which is not the
> intention.
>

Thanks for the review. I took another look at fixing this and I
think it might be better for the maintainer or someone who is more
familiar with the code to fix this. I ended up down a rabbit
hole trying to get the types to work and I wasn't confident about
the casting.

Thanks,
Laura
  
>>   }
>>   
>>   static inline struct flow_action_entry *
>> -- 
>> 2.21.0
>>
> 

