Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB10113FB0
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 11:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbfLEKvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 05:51:36 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33598 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfLEKvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 05:51:36 -0500
Received: by mail-wr1-f68.google.com with SMTP id b6so2971361wrq.0
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 02:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sCEtiUz2oq/MHf/6f+Zuvfg57m5dx9MxX6NEil/9KVY=;
        b=BVKocaR3HO3mlIvXsTkbIdPD7m8RfKBt+5hHUwy00AEHOGQGrzSA1hiv5N4CLFQfnP
         x7neUAH2e4/OVDqpB4bJsS3w94qy/7ahSguuj+//qJ6zF24x9B8iw/WwO/YnVeXvCCTE
         BFaXmcy1pMZ6X45GRle00kPErPMvUPYFjuMP46D5IPBBuVMoTQUZmFRYsfQq4Mm2rcG4
         RCEm9nl3jTb3EutgOmOe5TBuO7l2DNiWXsGPnSkN4i7bgTE5MxfMsM2YXYW3p9HU8r8x
         EnBa2TMl/zgy7X14eyHi0/0irnCb5uGAxjUqzmLRWLlQ4PVFbMHoei7v0Y75clBXw1Wi
         pZRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sCEtiUz2oq/MHf/6f+Zuvfg57m5dx9MxX6NEil/9KVY=;
        b=PwU8bY1YQiS2660NhnPAurlaTCXlgxUX0s7TjzN4VDR1kG1GDcS/6m9rJu9Y5g2fQN
         Wvwvqf9pnmSC+vXMTWKo8BknvWznldqh7+vBbJaIH177Hxqcswfy2lOvNOOrzyvYKPuH
         UAaP07PIl0Sn8qGFdf0+0/Kf5YdsEZVYnwG/raVZxqd743pHTN/9XyMKDD6cZk2ANvcj
         QI2iWaWO7yb3xESJRd6rqpF5cp0wUtLUQIl3Qqdg8yYooSlwDD2FrF49u3RDehZACAQS
         bf/E/b0YWdEowuivjCbPacfasxZRnMw6DAs3GjYYUeyG4WQi9lSqRmTsqH2iqtGXXUCn
         I+HQ==
X-Gm-Message-State: APjAAAXqWNvTKd9RDUz+4ZexB6TP9YLQ4f/UXUCU9XA1uH8gsiIvljqU
        9lfCR1b/+iwD6i1JzdEf5eJo5A==
X-Google-Smtp-Source: APXvYqxDeb0Zn1bDZje30p2Pd1zmh4w4SM96bWtfo+EdrcAjff88tpzSlRqruH58X+OlCMuBuUXcZQ==
X-Received: by 2002:adf:f484:: with SMTP id l4mr9377820wro.207.1575543093668;
        Thu, 05 Dec 2019 02:51:33 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:a02d:e01e:af31:1c57? ([2a01:e0a:410:bb00:a02d:e01e:af31:1c57])
        by smtp.gmail.com with ESMTPSA id a127sm3399900wmh.43.2019.12.05.02.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 02:51:32 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec] xfrm: check DST_NOPOLICY as well as DST_NOXFRM
To:     Mark Gillott <mgillott@vyatta.att-mail.com>, netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au
References: <20191204151714.20975-1-mgillott@vyatta.att-mail.com>
 <5a033c2e-dbf3-426a-007c-e7eec85fc3a6@6wind.com>
 <9a0813f2446b0423963d871795e34b3fe99e301d.camel@vyatta.att-mail.com>
 <c050dc8c-eb17-7195-51ed-18de0a270f5b@6wind.com>
 <7ade55872e403c55453033c7122efd28504b3b19.camel@vyatta.att-mail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <dc657389-aab2-2174-7571-29ebd5972316@6wind.com>
Date:   Thu, 5 Dec 2019 11:51:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <7ade55872e403c55453033c7122efd28504b3b19.camel@vyatta.att-mail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/12/2019 à 11:05, Mark Gillott a écrit :
> On Thu, 2019-12-05 at 09:52 +0100, Nicolas Dichtel wrote:
>> Le 05/12/2019 à 09:10, Mark Gillott a écrit :
>>> On Wed, 2019-12-04 at 17:57 +0100, Nicolas Dichtel wrote:
>>>> Le 04/12/2019 à 16:17, Mark Gillott a écrit :
>>>>> Before performing a policy bundle lookup, check the
>>>>> DST_NOPOLICY
>>>>> option, as well as DST_NOXFRM. That is, skip further processing
>>>>> if
>>>>> either of the disable_policy or disable_xfrm sysctl attributes
>>>>> are
>>>>> set.
>>>>
>>>> Can you elaborate why this change is needed?
>>>
>>> We have a separate DPDK-based dataplane that is responsible for all
>>> IPsec processing - policy handing/encryption/decryption.
>>> Consequently
>>> we set the net.ipv[4|6].conf.<if>.disable_policy sysctl to 1 for
>>> all
>>> "interesting" interfaces. That is we want the kernel to ignore any
>>> IPsec policies.
>>>
>>> Despite the above & depending on configuration, we found that
>>> originating traffic was ending up deep inside XFRM where it would
>>> get
>>> dropped because of a route lookup problem.
>>
>> And why don't you set disable_xfrm to thoses interfaces also?
>> disable_policy means no xfrm policy lookup on output, disable_xfrm
>> means no xfrm
>> policy check on input.
I inverted them! :/
disable_policy => no xfrm policy check on input
disable_xfrm => no xfrm encryption on output

>>
> 
> True, setting disable_xfrm=1 would solve the issue. Except this is
> output - the test case is a ping from a peer, the corresponding ICMP
> response is discarded by the kernel. Feels like disable_policy is the
> right check (the kernel is doing XFRM output).
If you don't want to perform xfrm encryption on output, you have to set
disable_xfrm. disable_policy is for input path only.

Nicolas
