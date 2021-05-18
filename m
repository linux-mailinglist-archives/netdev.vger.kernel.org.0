Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B534E386E9E
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 02:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345230AbhERA65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 20:58:57 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.250]:48372 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239577AbhERA64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 20:58:56 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 9CCD7400C5B54
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 19:57:38 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id io3Gl2Co68ElSio3GlWLRs; Mon, 17 May 2021 19:57:38 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4qoXiH1bPb97Rx+HBNH6AfkgBR3DdCR+uaCQfEgud1k=; b=NMOGlwjSVwidQTCvP4TmTwmH5G
        BWUDznGSVUv15nt9WWemv93EcJ4CiLd3lR1+vnssruGyiYH0X8p4NZfVHIXUiICO262ufB1xzCDFs
        i+i6YbKnXPduWBtiPPxdbIECglYpYqT1O5Y96LT5cFmPJdPwaAFdyH73Bi7rRLC3XlEXlSvDuA39V
        HApyZ5XEPXLN+Zd3gEVGGTroz1nDxbsd+4ii441b7O2clQOOYciWMejj3tRO3P3pMcMMjl8LUFCSD
        7eqhJKEJHxIsDKdvq3I226cwB4lEeO5zwvV3egbB1KR65Sin+yYfkvVgBk8NwZYWybiIW2qT0XdwD
        kfBR0FLw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:53582 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lio3E-002vds-8a; Mon, 17 May 2021 19:57:36 -0500
Subject: Re: [PATCH RESEND][next] net/packet: Fix fall-through warnings for
 Clang
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210305094429.GA140795@embeddedor>
 <895bef99-a483-1d20-8b4c-2eea3c0d341f@embeddedor.com>
Message-ID: <89aa0c11-4f6a-e196-f5a1-89b886a61a4e@embeddedor.com>
Date:   Mon, 17 May 2021 19:58:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <895bef99-a483-1d20-8b4c-2eea3c0d341f@embeddedor.com>
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
X-Exim-ID: 1lio3E-002vds-8a
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:53582
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 85
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

On 4/20/21 15:10, Gustavo A. R. Silva wrote:
> Hi all,
> 
> Friendly ping: who can take this, please?
> 
> Thanks
> --
> Gustavo
> 
> On 3/5/21 03:44, Gustavo A. R. Silva wrote:
>> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
>> by explicitly adding a break statement instead of letting the code fall
>> through to the next case.
>>
>> Link: https://github.com/KSPP/linux/issues/115
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>>  net/packet/af_packet.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
>> index e24b2841c643..880a1ab9a305 100644
>> --- a/net/packet/af_packet.c
>> +++ b/net/packet/af_packet.c
>> @@ -1652,6 +1652,7 @@ static int fanout_add(struct sock *sk, struct fanout_args *args)
>>  	case PACKET_FANOUT_ROLLOVER:
>>  		if (type_flags & PACKET_FANOUT_FLAG_ROLLOVER)
>>  			return -EINVAL;
>> +		break;
>>  	case PACKET_FANOUT_HASH:
>>  	case PACKET_FANOUT_LB:
>>  	case PACKET_FANOUT_CPU:
>>
