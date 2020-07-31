Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E61F234A40
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 19:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733217AbgGaRbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 13:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732970AbgGaRbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 13:31:25 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FAEFC061574;
        Fri, 31 Jul 2020 10:31:24 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 3so9935732wmi.1;
        Fri, 31 Jul 2020 10:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wO4f9oVxrsweCzVrPEPTiBn0n29w9yIsNMekGB68JeI=;
        b=obajWK+2pCFiEKV/2eMDwzcf7coFlPTQCpnzhLsxXlijhZ8oEvL0eeF1bczkYNKwYU
         w4N48fL1HDLI50n+/dzVLCSEmzp+sdXX6DmIOPEfoHwIZHgMR8R7bmrEhbtZjzHmYOYD
         THVj8cb1vUBrmNs9413xDV/JE3xLqw9UNZlOJ52XoEj32enO6PeLN2CogJoYZ9iA/lpO
         xrN259lT630oT20Z2V8QDzcMPLGQy2PGapeyURfyOW7w3rlUCtOcbpPiZS+SW1COX+qV
         MINBxQ/ymFo6hLbb0jpuGQ7We+UA2CKQqMw/pJ4RxT1pZj6NJ85+H4wVTLoDCAMSJbc9
         kbdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wO4f9oVxrsweCzVrPEPTiBn0n29w9yIsNMekGB68JeI=;
        b=lNEFH64dmBedByZvHrFkmlY9/XNksxoS9CC2AekNwIB0wzKd7zazyJw0BqM8vWwiPC
         boSTOztZF2mUiqefjWD4XgTLrA/kGmuVzruUWhwzGlkqK+jpv0XGsxfa28LvuxRsfc+x
         zRXlD7/HddbjbXHnjzlZWdbQJOPGjwqB65xLaRNkE8V9Dhz5gi2pREZvzSbfxo0l66Lc
         AGJLFnfwsMPy2fg6NIs8JB3PqDA0nwz8E1SASAatVXrNTcBQawGrlyvkuAQ4LrZwOovj
         eDRMrPHI9XCrp8O4jBgiDhAEgRSOnvWVKFqr6JLhVE1PWd1lVKRltuLWg64PVu/oQdQc
         j9Rg==
X-Gm-Message-State: AOAM532FkHvbO6tnLBHVyyyX03UNXyVzN89Rfw5V1p64sy03R2wFIige
        hPDO3PkVb8OqvrchopAAwZiYzPqh
X-Google-Smtp-Source: ABdhPJzHHTpsN9YodTgSjp2Xan9EQZ1qXY9klsnJ1b5gK4zP6O8x4+C+bkc5hEx2fssF9sPExQ5Ijw==
X-Received: by 2002:a1c:6007:: with SMTP id u7mr4926216wmb.32.1596216683216;
        Fri, 31 Jul 2020 10:31:23 -0700 (PDT)
Received: from [10.55.3.148] ([173.38.220.51])
        by smtp.gmail.com with ESMTPSA id h23sm12591375wmb.3.2020.07.31.10.31.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 10:31:22 -0700 (PDT)
Subject: Re: [net-next] seg6: using DSCP of inner IPv4 packets
To:     David Miller <davem@davemloft.net>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        andrea.mayer@uniroma2.it
References: <20200728122044.1900-1-ahabdels@gmail.com>
 <20200730.164424.85007408369570229.davem@davemloft.net>
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
Message-ID: <64f8d98d-3195-9bb0-858f-18a9625ccf8e@gmail.com>
Date:   Fri, 31 Jul 2020 19:31:20 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200730.164424.85007408369570229.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I will refactor the code of this function and submit a new patch.
Ahmed

On 31/07/2020 01:44, David Miller wrote:
> From: Ahmed Abdelsalam <ahabdels@gmail.com>
> Date: Tue, 28 Jul 2020 12:20:44 +0000
> 
>> This patch allows copying the DSCP from inner IPv4 header to the
>> outer IPv6 header, when doing SRv6 Encapsulation.
>>
>> This allows forwarding packet across the SRv6 fabric based on their
>> original traffic class.
>>
>> Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>
> 
> The conditionals in this function are now a mess.
> 
>> -	inner_hdr = ipv6_hdr(skb);
>> +	if (skb->protocol == htons(ETH_P_IPV6))
>> +		inner_hdr = ipv6_hdr(skb);
>> +	else
>> +		inner_ipv4_hdr = ip_hdr(skb);
>> +
> 
> You assume that if skb->protocol is not ipv6 then it is ipv4.
> 
>> @@ -138,6 +143,10 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
>>   		ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr)),
>>   			     flowlabel);
>>   		hdr->hop_limit = inner_hdr->hop_limit;
>> +	} else if (skb->protocol == htons(ETH_P_IP)) {
>> +		ip6_flow_hdr(hdr, inner_ipv4_hdr->tos, flowlabel);
>> +		hdr->hop_limit = inner_ipv4_hdr->ttl;
>> +		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
>>   	} else {
>>   		ip6_flow_hdr(hdr, 0, flowlabel);
>>   		hdr->hop_limit = ip6_dst_hoplimit(skb_dst(skb));
> 
> But this code did not make that assumption at all.
> 
> Only one of the two can be correct.
> 
> The conditional assignment is also very ugly, you have two pointers
> conditionally initialized.  The compiler is going to have a hard time
> figuring out that each pointer is only used in the code path where it
> is guaranteed to be initialiazed.
> 
> And it can't do that, as far as the compiler knows, skb->protocol can
> change between those two locations.  It MUST assume that can happen if
> there are any functions calls whatsoever between these two code points.
> 
> This function has to be sanitized, with better handling of access to
> the inner protocol header values, before I am willing to apply this.
> 
