Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 318BC5E0E2
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 11:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfGCJT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 05:19:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53776 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfGCJT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 05:19:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id x15so1409346wmj.3
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 02:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SgRgzBfMCM335xb+32SxDmtjQnPWCUW4qJ17ucMxUTA=;
        b=C/aqGJfLS2YcJDBdd8G/0s43thDicErCALrqKH3OyTxfKTsUnq7ipEYF35VFui41nH
         rG81+sKJZA4VBbzaeUtSytllSDrtbkqFy90NKvjtYV3rNfsqVBxO9JWs+ZvBTR1yrErn
         +qCmnoM4Wb8GhnYnHMmgRACfJGXT7u0jGN5D7xvo3Ubhc6kSRghU9e6axPDOKIU29F1+
         37DRkSM0Z/pawYLcQcgx6+u4DiJoMcOFV2numCz4WPd7aKI5m1ncAXsicnAyyqnzVXk2
         ASLyYkh38cxFhEHoBzePt8pA3GNRNwKb8v3s90MoNRRE/MoZ/kjKGj+qb9C2sqFp7IT1
         1IyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SgRgzBfMCM335xb+32SxDmtjQnPWCUW4qJ17ucMxUTA=;
        b=Bv3HLaf5gI4UjUbH7xRERhaf1OxXYB+eocGL/XzYDo1NmZN3/Y4VhbgVdlBqQXrmNs
         lV7lMefJO1Nljm4dBE8Dgu2XcPIgBK/2+2UGsdG/YcBYakV8q4/qdgGybDlA+y61DAxm
         kgOAq7wEiHsSYqJzQj5kWwJM+Av+eAm16Yj8KArcUsWnb0OxsmUnjRaeee/VrxB362Pg
         rDuyVOgNbA9yHEVhcHHKOobKawsP1l2Jo5+iTWnYKgCWs12xU4qioMfOesjdJvknA6h7
         BDMAh7JEMIPJw++ZflKjlzB8bXFFPtrUgdrOPYygl7whWMk9VfuIWUGPbPLQ0ksLwmgm
         A0wA==
X-Gm-Message-State: APjAAAV3SzSXvqOxuSYeP8eOBYJC6YVIuvyYjUxYUfdsnkp47RND/gB4
        W/lPtKydSNT21I9GcOXrH74=
X-Google-Smtp-Source: APXvYqwQRXWWXb/6oQ9JojaUv1UFw2OVtjuE85zXRZEa31Ld+q+67SPWj6CKv3KLpddQ1QHVg0Hk3g==
X-Received: by 2002:a1c:cc0d:: with SMTP id h13mr6960488wmb.119.1562145562404;
        Wed, 03 Jul 2019 02:19:22 -0700 (PDT)
Received: from [192.168.8.147] (196.166.185.81.rev.sfr.net. [81.185.166.196])
        by smtp.gmail.com with ESMTPSA id n125sm2294985wmf.6.2019.07.03.02.19.21
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 02:19:21 -0700 (PDT)
Subject: Re: [PATCH net] tcp: refine memory limit test in tcp_fragment()
To:     Tony Lu <tonylu@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <cpaasch@apple.com>,
        oliver.yang@linux.alibaba.com, xlpang@linux.alibaba.com,
        dust.li@linux.alibaba.com
References: <20190621130955.147974-1-edumazet@google.com>
 <20190703032718.GC55248@TonyMac-Alibaba>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c98b4997-d641-432f-b2bb-cdbdb9f02143@gmail.com>
Date:   Wed, 3 Jul 2019 11:19:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190703032718.GC55248@TonyMac-Alibaba>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/2/19 8:27 PM, Tony Lu wrote:
> Hello Eric,
> 
> 	We have applied that commit e358f4af19db ("tcp: tcp_fragment() should apply sane memory limits")
> 	as a hotpatch in production environment. We found that it will make
> 	tcp long connection reset during sending out packet when applying
> 	that commit. 
> 	
> 	Our applications which in A/B test have suffered that
> 	and made them retransmit large data, and then caused retransmission
> 	storm and lower the performance and increase RT.
> 
> 	Therefore we discontinued to apply this hotpatch in A/B test.
> 
> 	After invesgation, we found this patch already fix this issue in
> 	stable. Before applying this patch, we have some questions:
> 

Which stable version are you referring to exactly ?

> 	1. This commit in stable hard coded a magic number 0x20000. I am
> 	wondering this value and if there any better solution.

0x20000 is two times 64KB, please read the changelog for the rationale.

> 	2. Is there any known or unknown side effect? If any, we could test
> 	it in some suspicious scenarios before testing in prod env.

No known side effect.

Honestly, applications setting small SO_SNDBUF values can not expect good TCP performance anyway.


> 
> 	Thanks.
> 
> Cheers,
> Tony Lu
> 
> On Fri, Jun 21, 2019 at 06:09:55AM -0700, Eric Dumazet wrote:
>> tcp_fragment() might be called for skbs in the write queue.
>>
>> Memory limits might have been exceeded because tcp_sendmsg() only
>> checks limits at full skb (64KB) boundaries.
>>
>> Therefore, we need to make sure tcp_fragment() wont punish applications
>> that might have setup very low SO_SNDBUF values.
>>
>> Fixes: f070ef2ac667 ("tcp: tcp_fragment() should apply sane memory limits")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Reported-by: Christoph Paasch <cpaasch@apple.com>
>> ---
>>  net/ipv4/tcp_output.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>> index 00c01a01b547ec67c971dc25a74c9258563cf871..0ebc33d1c9e5099d163a234930e213ee35e9fbd1 100644
>> --- a/net/ipv4/tcp_output.c
>> +++ b/net/ipv4/tcp_output.c
>> @@ -1296,7 +1296,8 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
>>  	if (nsize < 0)
>>  		nsize = 0;
>>  
>> -	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
>> +	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf &&
>> +		     tcp_queue != TCP_FRAG_IN_WRITE_QUEUE)) {
>>  		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
>>  		return -ENOMEM;
>>  	}
>> -- 
>> 2.22.0.410.gd8fdbe21b5-goog
