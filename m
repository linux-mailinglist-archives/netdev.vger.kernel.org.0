Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05BDD108356
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 14:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfKXNC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 08:02:58 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52343 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbfKXNC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 08:02:58 -0500
Received: by mail-wm1-f67.google.com with SMTP id l1so12337271wme.2
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 05:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7Iqx27byht7Vf6EzLXGWgxonH80IAunVgf3D+RaHLJ4=;
        b=QowscUkfn4Sijo41fh9jdLgvPXwagBmWgNjH5sllYnhmVV49l3V3eKTbj8NFx/Gbo6
         NN/PY7jMEVEnBWxPbykuUcXAHSVcKpSPgZz81VTkCld4mA3698tTPNmOLZJFiUzfT7CZ
         V82ndWpMLv3VLs4sDNAYQJmM90LFB8qC5u7s7Sg2QN/zH/ZZOrMzYP+Og1khSoilO0M0
         BiE82mXXpofzXqFKIPQFjczRyrIUswbyXCVH73KS2oHAh1aPAzm5oVdY8Ts6Bcn66kGX
         lIvzUYgauIbtAXqK0e4JMmQ0ZjPChheQyRvslmTRab+F5bsSgHAviSNhArPTYcGQvkyn
         QrSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Iqx27byht7Vf6EzLXGWgxonH80IAunVgf3D+RaHLJ4=;
        b=E9jT6knFp4Xdt+gGRrmH0G1wTbu4LtX/4DWsfunMgygYfcPJ0OzixxX+9b/ocG3+zn
         0G8Nea18F0l3NdISp6QD+VpXNAzWNe0i2t/qz22X4m4fL6fgm0a+R1LutEOS6cZfowC9
         uu9LaK8UBsqk6Tb4EOg5i4ZqPx6/yDSDisgcQy9PQ7tzobOwMEKMOmBkA73EAS8fViuM
         1cgrcwzNso0Z2X/AgtkHHj8pZzWfiAMHAiVMRlNzSGYWAy+Ayh3+G5kmqJKy+7ggcVVg
         pt5EmGJi8DT8IQAjPQz1vjSC6XlUItEzv1+C9z+LmOgaZFsSvC1IG40ZrEQ3yeMw6lie
         bzsw==
X-Gm-Message-State: APjAAAV+V5BLzV3Wg4HCTsGEZ8eDbTkkMw5BklurhO53OqJmSB1zoYKD
        Fem9D29qfi8vwzMdHSpkVOMHQIldfKATHA==
X-Google-Smtp-Source: APXvYqxoaJjkTtkhYmUKWhEpUBYTIXdk1h6sGxugAs3Ta58w3i82SfDV74w8W42dAGfCavqyT569ZA==
X-Received: by 2002:a05:600c:20e:: with SMTP id 14mr23869550wmi.107.1574600574133;
        Sun, 24 Nov 2019 05:02:54 -0800 (PST)
Received: from [192.168.100.103] ([185.232.103.167])
        by smtp.gmail.com with ESMTPSA id p14sm6351266wrq.72.2019.11.24.05.02.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Nov 2019 05:02:53 -0800 (PST)
Subject: Re: [PATCH] net: ip/tnl: Set iph->id only when don't fragment is not
 set
To:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org
References: <20191123145817.GA22321@fuckup>
 <fa37491f-3604-bd3b-7518-dab654b641b6@gmail.com>
From:   Oliver Herms <oliver.peter.herms@gmail.com>
Message-ID: <77eb8b03-f586-b766-1df9-af441a2df16d@gmail.com>
Date:   Sun, 24 Nov 2019 14:02:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <fa37491f-3604-bd3b-7518-dab654b641b6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.11.19 18:53, Eric Dumazet wrote:
> Official sources for this assertion please, so that we can double check if you
> implemented the proper avoidance ?
From RFC 6864 Section 4.1:
"The IPv4 ID field MUST NOT be used for purposes other than
      fragmentation and reassembly."

>>  net/ipv4/ip_tunnel_core.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
>> index 1452a97914a0..8636c1e0e7b7 100644
>> --- a/net/ipv4/ip_tunnel_core.c
>> +++ b/net/ipv4/ip_tunnel_core.c
>> @@ -73,7 +73,9 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt, struct sk_buff *skb,
>>  	iph->daddr	=	dst;
>>  	iph->saddr	=	src;
>>  	iph->ttl	=	ttl;
>> -	__ip_select_ident(net, iph, skb_shinfo(skb)->gso_segs ?: 1);
>> +
>> +	if (unlikely((iph->frag_off & htons(IP_DF)) == false))
> 
> This unlikely() seems wrong to me.
> 
> You do not know what are the odds of IP_DF being set or not.
Right. I'll send a corrected patch.

>> +		__ip_select_ident(net, iph, skb_shinfo(skb)->gso_segs ?: 1);
> So we are going to send 2 bytes with garbage if we do not call __ip_select_ident()
> 
> This would cause various security threats, since the garbage might reveal a secret.
So we should set it to zero then.
