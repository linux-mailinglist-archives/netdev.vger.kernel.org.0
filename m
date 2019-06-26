Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9EE56B04
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfFZNph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:45:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40447 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfFZNph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 09:45:37 -0400
Received: by mail-wr1-f65.google.com with SMTP id p11so2814795wre.7
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 06:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7tUcjEIGOUMyTZAWVC2wECe2ALULgiMshtEgtZfDDDE=;
        b=JlslCBrgTZOOYBjJKLiFH+mTafl8KV9F7LEfiLvWf6CdNbdO2HasX9wFN0PpFQ/W7B
         sw7kBSfemQ/xS+GID6435mlAlTYpHhjbD1ogGjb927tfuB9WGr3laAKlgkj9/F97/EE1
         l/PCwCCSrbPcjx25jgyMCr4c024NYLt1Wp6pk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7tUcjEIGOUMyTZAWVC2wECe2ALULgiMshtEgtZfDDDE=;
        b=g5NKp3OaWqNm31PkiuVlo0HN6XEe3y7k40y3QR6T05V6GZEl7hm32lsXLTXYWNkqNQ
         V5uUtOtCKmLQ66yOzbzcK26uZjShj+RukhqOyIblUN5wUlVEmiNxagum/1dwa5r+eM4I
         InOS+Wd5u06wfVWo5j513vBFNr89LbokYTi3pYgkSKgOthY1muxrSmvI9EKLJGNjtJST
         qloLaH5PAgwOJJJUUcrqF/4JsTiUcDhjK0s9pK8MECX/bTTvv3kfoHobwN+mwRw//3gZ
         YiKPZYbi/6ctrZxEZUtsqkuDi+Qvn4q2iil4kP7KcZ/2JugavvZNTEO4QmKjMCF+BbKM
         SDVA==
X-Gm-Message-State: APjAAAVZBQAGfnkjCqzpfefTK51iQ2VELjG9FLUXcjH5BlHdIxfWOJfi
        MkSQ6nQ2u2YJQM2kHMaJfOFwjg==
X-Google-Smtp-Source: APXvYqyglw1PiKhu7aR0GO24vzL+VapzchL3TP1fNxVlf0JCVS5YfLSQHrvNjtqHyr588vcNHMFs7g==
X-Received: by 2002:adf:f544:: with SMTP id j4mr3848052wrp.150.1561556734657;
        Wed, 26 Jun 2019 06:45:34 -0700 (PDT)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id h21sm2970236wmb.47.2019.06.26.06.45.29
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 06:45:34 -0700 (PDT)
Subject: Re: [PATCH net-next 2/5] net: sched: em_ipt: set the family based on
 the protocol when matching
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        pablo@netfilter.org, xiyou.wangcong@gmail.com, davem@davemloft.net,
        jiri@resnulli.us, jhs@mojatatu.com
References: <20190626115855.13241-1-nikolay@cumulusnetworks.com>
 <20190626115855.13241-3-nikolay@cumulusnetworks.com>
 <20190626163353.6d5535cb@jimi>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <9a3be271-af15-3fef-9612-7a3232d09b32@cumulusnetworks.com>
Date:   Wed, 26 Jun 2019 16:45:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190626163353.6d5535cb@jimi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/06/2019 16:33, Eyal Birger wrote:
> Hi Nikolay,
>    
> On Wed, 26 Jun 2019 14:58:52 +0300
> Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
> 
>> Set the family based on the protocol otherwise protocol-neutral
>> matches will have wrong information (e.g. NFPROTO_UNSPEC). In
>> preparation for using NFPROTO_UNSPEC xt matches.
>>
>> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>> ---
>>  net/sched/em_ipt.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
>> index 64dbafe4e94c..23965a071177 100644
>> --- a/net/sched/em_ipt.c
>> +++ b/net/sched/em_ipt.c
>> @@ -189,10 +189,12 @@ static int em_ipt_match(struct sk_buff *skb,
>> struct tcf_ematch *em, case htons(ETH_P_IP):
>>  		if (!pskb_network_may_pull(skb, sizeof(struct
>> iphdr))) return 0;
>> +		state.pf = NFPROTO_IPV4;
>>  		break;
>>  	case htons(ETH_P_IPV6):
>>  		if (!pskb_network_may_pull(skb, sizeof(struct
>> ipv6hdr))) return 0;
>> +		state.pf = NFPROTO_IPV6;
>>  		break;
>>  	default:
>>  		return 0;
>> @@ -203,7 +205,7 @@ static int em_ipt_match(struct sk_buff *skb,
>> struct tcf_ematch *em, if (skb->skb_iif)
>>  		indev = dev_get_by_index_rcu(em->net, skb->skb_iif);
>>  
>> -	nf_hook_state_init(&state, im->hook, im->match->family,
>> +	nf_hook_state_init(&state, im->hook, state.pf,
>>  			   indev ?: skb->dev, skb->dev, NULL,
>> em->net, NULL); 
>>  	acpar.match = im->match;
> 
> I think this change is incompatible with current behavior.
> 
> Consider the 'policy' match which matches the packet's xfrm state (sec_path)
> with the provided user space parameters. The sec_path includes information
> about the encapsulating packet's parameters whereas the current skb points to
> the encapsulated packet, and the match is done on the encapsulating
> packet's info.
> 
> So if you have an IPv6 packet encapsulated within an IPv4 packet, the match
> parameters should be done using IPv4 parameters, not IPv6.
> 
> Maybe use the packet's family only if the match family is UNSPEC?
> 
> Eyal.
> 

Hi Eyal,
I see your point, I was wondering about the xfrm cases. :)
In such case I think we can simplify the set and do it only on UNSPEC matches as you suggest.

Maybe we should enforce the tc protocol based on the user-specified nfproto at least from
iproute2 otherwise people can add mismatching rules (e.g. nfproto == v6, tc proto == v4).

Thanks,
 Nik
