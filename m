Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07433B073E
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 16:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhFVOUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 10:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhFVOUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 10:20:04 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E263C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 07:17:48 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id d196so39807448qkg.12
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 07:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JTI+VmMw1x2j76RTTZ/iJ5sMtzr8R2nscp+r894b6xA=;
        b=aX5dJsL3ZMyIQVpMylq29qgyw2r6Il6ePgad3ov4zzd1Db71kv3dAEHUAD+iJXZT+j
         h8AilG4D3kEe8yr3velk/go5gs+few50le5y2k0RApzLXlB7lhneujc3M0xUeI17rJ8h
         OkcUxsXCZy03vu1J9keu2E1deoMSONFwmXmnkstGOxf9WbCgipY1co38lNuqGNmxhrjF
         yvV4/+qMaMUN90bJ3A24X/j45XkLuqAuSsmtlHevuc9ALmrVq85RTCrp0f11d6nkPOtQ
         CqqxLGBIy2RVlMLDjFQfjGXinEC5lHeJoTvTdhrB9vfGPgJekKw4yMGzvX/ZiAD2DNPj
         ZdFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JTI+VmMw1x2j76RTTZ/iJ5sMtzr8R2nscp+r894b6xA=;
        b=tEZHmVRQ805cxYWZ0wBoqie78Ql4LBRJ2hJDAiiqUZNDyrTkpkEqUXFaR4j2N1Z0mw
         SHIwcimVMQXg4PDEf9bsam2o66+nVaCg0a5lJsraIrQzSBJjOlu8Ui0CnJ1rGlz3MsRn
         mhtJugAuM7qtnJbQBozq8VP3p9w534bFG5+2oPgnBGtRVh4GbddjsSfy8Lv2QAE1nkRU
         /lUBOLeqdnEnY66osktrZ35ZIfaVhVXC2GV22Z810ShFPCy1zJXefzg35oyzoF5p0qV2
         ziEgijlMw0g6K8Vsp4QbGqObI8xJHIFJV0+zxbPMtYUUttl4aJwFa8WWxcST6UswaauU
         kQHQ==
X-Gm-Message-State: AOAM532wQIgc3mr51Y/C+cE+rKyvYwcUtvEL1AKGjf9w9lhhlhEbmIp9
        7MnTatHAFKB9JTBBRy4JrCvQpw==
X-Google-Smtp-Source: ABdhPJz+EdspyO9doRY76WgLQ/Xf/UkJiteqHjecHaetQqVz6wbwtzJ0ulGEVq+2AbdKisW+DNCBBg==
X-Received: by 2002:a37:84c3:: with SMTP id g186mr4491372qkd.276.1624371467313;
        Tue, 22 Jun 2021 07:17:47 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-24-174-92-115-23.dsl.bell.ca. [174.92.115.23])
        by smtp.googlemail.com with ESMTPSA id k19sm12872492qkj.89.2021.06.22.07.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 07:17:46 -0700 (PDT)
Subject: Re: [PATCH net-next] net/sched: cls_flower: fix resetting of ether
 proto mask
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiri@resnulli.us, idosch@idosch.org, ilya.lifshits@broadcom.com
References: <20210617161435.8853-1-vadym.kochan@plvision.eu>
 <20210617164155.li3fct6ad45a6j7h@skbuf>
 <20210617195102.h3bg6khvaogc2vwh@skbuf> <20210621083037.GA9665@builder>
 <f18e6fee-8724-b246-adf9-53cc47f9520b@mojatatu.com>
 <20210622131314.GA14973@builder>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <451abd22-4c81-2821-e8d4-4f305697890c@mojatatu.com>
Date:   Tue, 22 Jun 2021 10:17:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210622131314.GA14973@builder>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Boris,

On 2021-06-22 9:13 a.m., Boris Sukholitko wrote:
> Hi Jamal,
> 
> On Mon, Jun 21, 2021 at 10:04:41AM -0400, Jamal Hadi Salim wrote:
>> On 2021-06-21 4:32 a.m., Boris Sukholitko wrote:

[..]
>>> I like this solution. To be more explicit, the plan becomes:
>>>
>>> 1. Add FLOW_DISSECTOR_KEY_ETH_TYPE and struct flow_dissector_key_eth_type.
>>> 2. Have skb flow dissector use it.
>>> 3. Userspace does not set TCA_FLOWER_KEY_ETH_TYPE automagically
>>>      anymore. cls_flower takes basic.n_proto from struct tcf_proto.
>>> 4. Add eth_type to the userspace and use it to set TCA_FLOWER_KEY_ETH_TYPE
>>> 5. Existence of TCA_FLOWER_KEY_ETH_TYPE triggers new eth_type dissector.
>>>
>>> IMHO this neatly solves non-vlan protocol match case.
>>>
>>> What should we do with the VLANs then? Should we have vlan_pure_ethtype
>>> and cvlan_pure_ethtype as additional keys?
>>>
>>
>> I didnt see the original patch you sent until after it was applied
>> and the cursory 30 second glance didnt say much to me.
>>
>> Vlans unfortunately are a speacial beast: You will have to retrieve
>> the proto differently.
> 
> Do you by any chance have some naming suggestion? Does
> vlan_pure_ethtype sound ok? What about vlan_{orig, pkt, raw, hdr}_ethtype?
> 

The distinction is in getting the inner vs outer proto, correct?

Before we go there let me push back a little since no other
classifier has this problem. IIUC:
For the hardware offload current scheme works fine. On the
non-offload side, the issue seems to be that classify() was
not getting the proper protocol?

I pointed to Toke's change since it tries to generalize the
solution.  you'd use that approach
(eg setting to true).

Would that solve the issue?

If not maybe we need a naming convention for inner vs out proto.
Should be noted that user space semantics require that the "current
protocol" be specified in the policy. i.e if you have an inner
protocol and you need both looked at then you would have two rules
like this:

1) tc filter ... protocol outer .... action-to-strip-outer-header \
action reclassify
2) tc filter ... protoco inner ... action blah

The action-to-strip-outer-header will set properly the skb->proto
after moving the data pointers so that #2 will match it.

>>
>> Q: Was this always broken? Example look at Toke's change here:
>> commit d7bf2ebebc2bd61ab95e2a8e33541ef282f303d4
>>
> 
> IMHO we've always had this problem. I did some archeology on this
> code and didn't see anything which might have caused the bug.
> 

Suprised it took this long to find out.

> Toke's change doesn't look related because in fl_classify it does:
> 
> 	skb_key.basic.n_proto = skb_protocol(skb, false);
> 
> before running the dissector. In case of a known tunnelling protocol (such
> as ETH_P_PPP_SES) the n_proto will be overriden by __skb_flow_dissect.
> 

Toke's change may have left things as they were before
but generally to get vlan protos you'd do things differently.

This is because when vlan offloading was merged it skewed
things a little and we had to live with that.

Flower is unique in its use of the dissector which other classifiers
dont. Is this resolvable by having the fix in the  dissector?

cheers,
jamal

