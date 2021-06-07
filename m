Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9387939E9AE
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 00:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhFGWkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 18:40:05 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:37489 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhFGWkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 18:40:04 -0400
Received: by mail-pl1-f170.google.com with SMTP id u7so9547464plq.4;
        Mon, 07 Jun 2021 15:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CcVdtpftfYPBQf3lDD9cfEcZPPKDcRx7FVqFn1iALOo=;
        b=QAVsl2fXOJe43qSa8yv5T/F7l9hHpisaPfEJFCBWcwC3G7R9AtLRa3QVcul5No0rxq
         80kP5iXZvxatXnDXV+Z6y/k9wu9bu+ilyFV3GTMPt7BWrQxul+Cm8BoNsgt5Qq/tV2WT
         HpdbaAerrEXWbRHWvjbNCjHQNiXLqVKbimor1f/rx1wHTgYx78UGeXMMkkXqM6wyxV5R
         N9u6KU7/93o8Zk5jLj+tzheOHINWxS4FxptnwTAjk8lmYAH3NA3n2Y5fhWCdfJxkbIOY
         iw9FU+HzUvxcBody/VNomlfJbpe/4KcFuJD/5j+GN78zuu0ZNobDCXk3XIVbFlcT5BTE
         6S8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CcVdtpftfYPBQf3lDD9cfEcZPPKDcRx7FVqFn1iALOo=;
        b=NjT7YjAWq0KqzXoVr/PiBMz1hu/pEppE367y3oZTOYBxAnl4NpnsDLL6WTm8fhNufW
         F/E4LKVt/C+7y4Tok2kYelhxSLPfINKVNWERMo23ih5O30qh3bpfcnfjvavkz59PUJlL
         XEECQ2ghXMC15nEtHWfYrzAxAqbitt8KYcGmZRApVLYrTZhk/vB77PjUrISml87w/noF
         X7AdcxCL2nkaQGXiCzdSHIYQ++8myOlW+rHGx2fJjnquQfyeFDtBueKo5aOm0Ve92cu0
         MITP+ly9gBM/gBCTep4e7vLPYDZ/ml6dbIAhjtzebJmwi57iOsxDxgjxWBoVog3Aechu
         tz7g==
X-Gm-Message-State: AOAM533B1DDVCcu3AXxn2f/mpUhDRG0OhZzznnqKOkCZweKxMgwRytnr
        CQiqxZ4GREvag64yDvWdR5dN/tbbjyk=
X-Google-Smtp-Source: ABdhPJxYxkGX/Dn7wzcUuctuIZLLwvmg/gjkTYamlMPEgLT1XvoXKHxeP4T8nJT2kPtOb1bGz8CVSA==
X-Received: by 2002:a17:90a:f48c:: with SMTP id bx12mr1424062pjb.200.1623105418859;
        Mon, 07 Jun 2021 15:36:58 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f15sm9385108pgg.23.2021.06.07.15.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 15:36:58 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: dsa: b53: Do not force tagging on CPU
 port VLANs
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Matthew Hagan <mnhagan88@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210607220843.3799414-1-f.fainelli@gmail.com>
 <20210607220843.3799414-2-f.fainelli@gmail.com>
 <20210607222250.zxqnwvosqeavhqhi@skbuf>
 <7ee3b08f-c734-99fe-bd97-cddb018199c5@gmail.com>
Message-ID: <fb9481be-2344-9629-fb4a-0ea934e4b1ad@gmail.com>
Date:   Mon, 7 Jun 2021 15:36:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <7ee3b08f-c734-99fe-bd97-cddb018199c5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2021 3:31 PM, Florian Fainelli wrote:
> 
> 
> On 6/7/2021 3:22 PM, Vladimir Oltean wrote:
>> On Mon, Jun 07, 2021 at 03:08:42PM -0700, Florian Fainelli wrote:
>>> Commit ca8931948344 ("net: dsa: b53: Keep CPU port as tagged in all
>>> VLANs") forced the CPU port to be always tagged in any VLAN membership.
>>> This was necessary back then because we did not support Broadcom tags
>>> for all configurations so the only way to differentiate tagged and
>>> untagged traffic while DSA_TAG_PROTO_NONE was used was to force the CPU
>>> port into being always tagged.
>>>
>>> This is not necessary anymore since 8fab459e69ab ("net: dsa: b53: Enable
>>> Broadcom tags for 531x5/539x families") and we can simply program what
>>> we are being told now, regardless of the port being CPU or user-facing.
>>>
>>> Reported-by: Matthew Hagan <mnhagan88@gmail.com>
>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>> ---
>>>  drivers/net/dsa/b53/b53_common.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
>>> index 3ca6b394dd5f..56e3b42ec28c 100644
>>> --- a/drivers/net/dsa/b53/b53_common.c
>>> +++ b/drivers/net/dsa/b53/b53_common.c
>>> @@ -1477,7 +1477,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
>>>  		untagged = true;
>>>  
>>>  	vl->members |= BIT(port);
>>> -	if (untagged && !dsa_is_cpu_port(ds, port))
>>> +	if (untagged)
>>>  		vl->untag |= BIT(port);
>>>  	else
>>>  		vl->untag &= ~BIT(port);
>>> @@ -1514,7 +1514,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
>>>  	if (pvid == vlan->vid)
>>>  		pvid = b53_default_pvid(dev);
>>>  
>>> -	if (untagged && !dsa_is_cpu_port(ds, port))
>>> +	if (untagged)
>>>  		vl->untag &= ~(BIT(port));
>>>  
>>>  	b53_set_vlan_entry(dev, vlan->vid, vl);
>>> -- 
>>> 2.25.1
>>>
>>
>> Don't you want to keep this functionality for BCM5325 / BCM5365 and
>> such, which still use DSA_TAG_PROTO_NONE?
> 
> Humm, in premise yes, however I am debating removing support for
> 5325/5365 entirely, nobody that I know of has even been trying to get
> those devices to work with that driver.

On second thought, we just need to have those devices return
DSA_TAG_PROTO_BRCM_LEGACY which is what they use, there does appear to
be a couple of users, including myself, I had not realized that the
device I was using used a 5325 (thought it was a 53125). V2 coming.
-- 
Florian
