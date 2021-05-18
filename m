Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047F3386E58
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 02:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345011AbhERAb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 20:31:57 -0400
Received: from gateway20.websitewelcome.com ([192.185.46.107]:20301 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345000AbhERAb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 20:31:57 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 1E6B3400D501C
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 19:18:15 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id ind8lZoB2nrr4ind8lXb53; Mon, 17 May 2021 19:30:38 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=y+dJQwD7ZPxeqvrbUYA69rPRxhCVNX6+w4TXAMOsoKY=; b=pqYqeoYmEP3lEXqsqncA1uHj7I
        d+MNdVMuz9S7wR4M/4H96NfPi9qIvb5AexKAdziUNTRHV6ylAoR5UDaSqnIllgx6D1/9/CoLSfOtY
        3P4cc4IoeRVS4cI1nPvgzsI9HQMfmJmc5xy5/nxhD+sYBhz4lDKnIb/hIkNSqD/WMyxy1qwo3aHlZ
        I3CDoPWfu7DVpxdiOrBLh5kAfqlwez6/xdZQLMm5kCB0STeD5rjSmk7QQqsCU3tA9Xm+c99yIpjGZ
        G364md8hIeviEihm0XEWCOB50WlkCH+MYM/yA+Wz+Nwu8PoZ/7IkRjYwXMHZa4bHXvqA3Q4CUV7Ce
        IHuZFVsg==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:53468 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lind5-002YD8-Bm; Mon, 17 May 2021 19:30:35 -0500
Subject: Re: [PATCH RESEND][next] ipv4: Fix fall-through warnings for Clang
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210305090205.GA139036@embeddedor>
 <ef931d13-896f-0b9c-bb8c-1b710b0164af@embeddedor.com>
Message-ID: <3739dced-578f-92ae-9444-fc4fa9744b54@embeddedor.com>
Date:   Mon, 17 May 2021 19:31:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <ef931d13-896f-0b9c-bb8c-1b710b0164af@embeddedor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lind5-002YD8-Bm
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:53468
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 46
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm taking this in my -next[1] branch for v5.14.

Thanks
--
Gustavo

[1] https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/log/?h=for-next/kspp

On 4/20/21 15:05, Gustavo A. R. Silva wrote:
> Hi all,
> 
> Friendly ping: who can take this, please?
> 
> Thanks
> --
> Gustavo
> 
> On 3/5/21 03:02, Gustavo A. R. Silva wrote:
>> In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
>> warnings by explicitly adding multiple break statements instead of just
>> letting the code fall through to the next case.
>>
>> Link: https://github.com/KSPP/linux/issues/115
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>>  net/ipv4/ah4.c           | 1 +
>>  net/ipv4/esp4.c          | 1 +
>>  net/ipv4/fib_semantics.c | 1 +
>>  net/ipv4/ip_vti.c        | 1 +
>>  net/ipv4/ipcomp.c        | 1 +
>>  5 files changed, 5 insertions(+)
>>
>> diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
>> index 36ed85bf2ad5..fab0958c41be 100644
>> --- a/net/ipv4/ah4.c
>> +++ b/net/ipv4/ah4.c
>> @@ -450,6 +450,7 @@ static int ah4_err(struct sk_buff *skb, u32 info)
>>  	case ICMP_DEST_UNREACH:
>>  		if (icmp_hdr(skb)->code != ICMP_FRAG_NEEDED)
>>  			return 0;
>> +		break;
>>  	case ICMP_REDIRECT:
>>  		break;
>>  	default:
>> diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
>> index 4b834bbf95e0..6cb3ecad04b8 100644
>> --- a/net/ipv4/esp4.c
>> +++ b/net/ipv4/esp4.c
>> @@ -982,6 +982,7 @@ static int esp4_err(struct sk_buff *skb, u32 info)
>>  	case ICMP_DEST_UNREACH:
>>  		if (icmp_hdr(skb)->code != ICMP_FRAG_NEEDED)
>>  			return 0;
>> +		break;
>>  	case ICMP_REDIRECT:
>>  		break;
>>  	default:
>> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
>> index a632b66bc13a..4c0c33e4710d 100644
>> --- a/net/ipv4/fib_semantics.c
>> +++ b/net/ipv4/fib_semantics.c
>> @@ -1874,6 +1874,7 @@ static int call_fib_nh_notifiers(struct fib_nh *nh,
>>  		    (nh->fib_nh_flags & RTNH_F_DEAD))
>>  			return call_fib4_notifiers(dev_net(nh->fib_nh_dev),
>>  						   event_type, &info.info);
>> +		break;
>>  	default:
>>  		break;
>>  	}
>> diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
>> index 31c6c6d99d5e..eb560eecee08 100644
>> --- a/net/ipv4/ip_vti.c
>> +++ b/net/ipv4/ip_vti.c
>> @@ -351,6 +351,7 @@ static int vti4_err(struct sk_buff *skb, u32 info)
>>  	case ICMP_DEST_UNREACH:
>>  		if (icmp_hdr(skb)->code != ICMP_FRAG_NEEDED)
>>  			return 0;
>> +		break;
>>  	case ICMP_REDIRECT:
>>  		break;
>>  	default:
>> diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
>> index b42683212c65..bbb56f5e06dd 100644
>> --- a/net/ipv4/ipcomp.c
>> +++ b/net/ipv4/ipcomp.c
>> @@ -31,6 +31,7 @@ static int ipcomp4_err(struct sk_buff *skb, u32 info)
>>  	case ICMP_DEST_UNREACH:
>>  		if (icmp_hdr(skb)->code != ICMP_FRAG_NEEDED)
>>  			return 0;
>> +		break;
>>  	case ICMP_REDIRECT:
>>  		break;
>>  	default:
>>
