Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182A2386EF4
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 03:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345642AbhERBMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 21:12:23 -0400
Received: from gateway33.websitewelcome.com ([192.185.145.9]:28218 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345713AbhERBMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 21:12:18 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 47F1F44E07B
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 20:10:59 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id ioGBlaQfKnrr4ioGBlYDCV; Mon, 17 May 2021 20:10:59 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SHU+3vvN64BDQu7qZYD0FXs6TjeRwBgIv9Xx2RD6kic=; b=I10VJN4wv1oMd7EwHRtVWpEL86
        ZCAz6TOfWkfFcMq3oeUvIhR2PdziCAsXFOdWAH+uW3dj/AraVnlyg0wb6tw2JL+ruy/FqwKNpZT8e
        m+XAfBjWqe7rYDCZZD60hJXo9jmHAds0yEMxDqFqugcRGEvYqCRgQv3FfwA6H08j8t6MonvlDJB1R
        L9VWx4qRqwCkDmUnWDxl4Joe03PHvQbanjhxje1XvGEzZpeAJTwaIQDg/bGc8jJwZElsE8T/N3JCk
        37ChBdq36F0u8JexojxfmEYIadymoIEjMX9A7MaypC4/OgreakfQLmxzi72o4DVyTWFBv2+uvns40
        3CSEe7tw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:53628 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lioG7-003E5c-PS; Mon, 17 May 2021 20:10:55 -0500
Subject: Re: [PATCH RESEND][next] xfrm: Fix fall-through warnings for Clang
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210305092319.GA139967@embeddedor>
 <fbe896ed-860d-4a92-f92b-bce83ba413ee@embeddedor.com>
Message-ID: <12e41d98-5cab-d4af-424d-228c664d5be7@embeddedor.com>
Date:   Mon, 17 May 2021 20:11:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <fbe896ed-860d-4a92-f92b-bce83ba413ee@embeddedor.com>
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
X-Exim-ID: 1lioG7-003E5c-PS
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:53628
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 35
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

If you don't mind, I'm taking this in my -next[1] branch for v5.14.

Thanks
--
Gustavo

[1] https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/log/?h=for-next/kspp

On 4/20/21 15:08, Gustavo A. R. Silva wrote:
> Hi all,
> 
> Friendly ping: who can take this, please?
> 
> Thanks
> --
> Gustavo
> 
> On 3/5/21 03:23, Gustavo A. R. Silva wrote:
>> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
>> by explicitly adding a break statement instead of letting the code fall
>> through to the next case.
>>
>> Link: https://github.com/KSPP/linux/issues/115
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>>  net/xfrm/xfrm_interface.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
>> index 8831f5a9e992..41de46b5ffa9 100644
>> --- a/net/xfrm/xfrm_interface.c
>> +++ b/net/xfrm/xfrm_interface.c
>> @@ -432,6 +432,7 @@ static int xfrmi4_err(struct sk_buff *skb, u32 info)
>>  	case ICMP_DEST_UNREACH:
>>  		if (icmp_hdr(skb)->code != ICMP_FRAG_NEEDED)
>>  			return 0;
>> +		break;
>>  	case ICMP_REDIRECT:
>>  		break;
>>  	default:
>>
