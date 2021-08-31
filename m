Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA343FC80F
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 15:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbhHaNUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 09:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235450AbhHaNTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 09:19:13 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D06DC061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 06:18:18 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id a10so2249919qka.12
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 06:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pp3RPF/vXIg+0GFzElgGHx5gYnJkzWYO+9KPoWVW4IU=;
        b=vI9hueQyJmlZfwaZbG1sfBzrQHfPb+lQsqdXA8T8EB3+w3sQFxYiApRm/3qfvwpqMQ
         vK4algPvCPByJD0fvzGH88n1zYCswC6slvb4spEEk966H7ki4/2iasIHS/vktu2aKWh5
         buB86fitdM9LANtbJHk4+B17I2SAmwSgJ07+ZMjqHvUWO7J/cTIO6h9gjNAq5V0YsV0j
         sRGvb0iCtEA+6BnzzmThchkgnGQpoQ0959Bwpl/xsBT0mW7XqYfB60GzVcJNsKi/eLwB
         5bmwr3HAWN7aronl9aU5ifdUCty8xD+Ql0k0Qjf5AWjSu4MzJBTA7nWcPB9liwfOcihc
         dKsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pp3RPF/vXIg+0GFzElgGHx5gYnJkzWYO+9KPoWVW4IU=;
        b=ZBX8Zr/5+A9mjnTas3XObWPc8Sg1fvo0q3sc0u4TOn39WN2iVQgqFxCtdxTuc4LANU
         PTyInOLRpNwApElh07oMITANQbGzXNa2Nuar666Ge+maq5BBlCaROTEhVYg5Eg9HI+rx
         lasfnrZkZnLOUZZtIAEW4lWAzqgzoyNwqOGZs7Bu6fMVOC4fr88qJiIL8ECAYKDQGf8m
         lpbGn6hlpfv9MuuHl/L9Ulbf2Dxhnrje/+COX52ivwjA8y73G7sc3bjx/Z0ey7PQNitF
         7S+JqWwQ98w9m5G7BujEwUHG2fXdLI5QDZrRUpDNKZttW90Om/nj/NkMApFM6p7OxcT7
         WuTg==
X-Gm-Message-State: AOAM530ZsgZx0OrCxTj5qbktwvsiOdc4B/Fze8kfdZCtgxBkNh45uSvj
        9XoGjRFZ/6Q+FP8RxmlEkb9dzQ==
X-Google-Smtp-Source: ABdhPJzNbpWEqdRuHhkcM5f7K9aWztcPXfPtePEN0c37mbmRFN2CNnB/mErTK1fxWyCpD1CoUH6JxA==
X-Received: by 2002:a05:620a:11af:: with SMTP id c15mr3114126qkk.82.1630415897580;
        Tue, 31 Aug 2021 06:18:17 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id n18sm14033840qkn.63.2021.08.31.06.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 06:18:17 -0700 (PDT)
Subject: Re: [PATCH net-next] net/sched: cls_flower: Add orig_ethtype
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        tom Herbert <tom@sipanda.io>,
        Felipe Magno de Almeida <felipe@expertise.dev>,
        Pedro Tammela <pctammela@mojatatu.com>
References: <20210830080800.18591-1-boris.sukholitko@broadcom.com>
 <b05f2736-fa76-4071-3d52-92ac765ca405@mojatatu.com>
 <20210831120440.GA4641@noodle>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <b400f8c6-8bd8-2617-0a4f-7c707809da7d@mojatatu.com>
Date:   Tue, 31 Aug 2021 09:18:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210831120440.GA4641@noodle>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-31 8:04 a.m., Boris Sukholitko wrote:
> Hi Jamal,
> 
> On Mon, Aug 30, 2021 at 09:48:38PM -0400, Jamal Hadi Salim wrote:
>> On 2021-08-30 4:08 a.m., Boris Sukholitko wrote:
>>> The following flower filter fails to match packets:
>>>
>>> tc filter add dev eth0 ingress protocol 0x8864 flower \
>>>       action simple sdata hi64
>>>
>>> The protocol 0x8864 (ETH_P_PPP_SES) is a tunnel protocol. As such, it is
>>> being dissected by __skb_flow_dissect and it's internal protocol is
>>> being set as key->basic.n_proto. IOW, the existence of ETH_P_PPP_SES
>>> tunnel is transparent to the callers of __skb_flow_dissect.
>>>
>>> OTOH, in the filters above, cls_flower configures its key->basic.n_proto
>>> to the ETH_P_PPP_SES value configured by the user. Matching on this key
>>> fails because of __skb_flow_dissect "transparency" mentioned above.
>>>
>>> Therefore there is no way currently to match on such packets using
>>> flower.
>>>
>>> To fix the issue add new orig_ethtype key to the flower along with the
>>> necessary changes to the flow dissector etc.
>>>
>>> To filter the ETH_P_PPP_SES packets the command becomes:
>>>
>>> tc filter add dev eth0 ingress flower orig_ethtype 0x8864 \
>>>       action simple sdata hi64
>>
>> Where's "protocol" on the above command line is. Probably a typo?
> 
> There is no need for protocol there. We intend to match on the tunnel
> protocol existence only, disregarding its contents. Therefore
> orig_ethtype key is sufficient.
> 

Hold on: The command line requires you specify the root (parse)
node with keyword "protocol". i.e something like:
tc filter add dev eth0 ingress protocol 0x8864 flower ...

You are suggesting a new syntax - which only serves this one
use case that solves your problem and is only needed for flower
but no other tc classifier.

>>
>> The main culprit is clearly the flow dissector parsing. I am not sure
>> if in general flowdisc to deal with deeper hierarchies/tunnels
>> without constantly adding a lot more hacks. Imagine if you had an
>> ethernet packet with double vlan tags and encapsulating a pppoe packet
>> (i.e 3 or more layers of ethernet) - that would be a nightmare.
> 
> Of course there is no limit to our imagination :) However I would argue
> that in the RealWorld(tm) the number of such nesting cases is
> neglectable.
>

Youd be very suprised on how some telcos use things like vlan tags
as "path metadata" and/or mpls labels and the layering involved in that.
i.e There is another world out there;-> More important: there is
nothing illegitimate in any standard about multi-layer tunnels as
such.

> The evidence is that TC and flower are being actively used. Double VLAN
> tags configurations notwithstading. IMHO, the fact that I've been
> unlucky to hit this tunnel corner case does not mean that there is a
> design problem with the flower.
> 

You have _not_ been unlucky - it is a design issue with flow dissector
and the wrapping around flower. Just waiting to happen for more
other use cases..

> AFAICS, the current meaning for the protocol field in TC is:
> 
> match the innermost layer 2 type through the tunnels that the kernel
> knows about.
> 

"protocol" describes where you start parsing and matching in
the header tree - for tc that starts with the outer ethertype.
The frame has to make sense.

> And it seems to me that this semantic is perfectly fine and does not
> require fixing. Maybe be we need to mention it in the docs...
> 

Sorry, I disagree.

>> IMO, your approach is adding yet another bandaid.
> 
> Could you please elaborate why do you see this approach as a bandaid?
> 
> The patch in question adds another key to the other ~50 that exists in the
> flower currently. Two more similar keys will be done for single and
> double VLAN case. As a result, my users will gain the ability to match
> packets that are impossible to match right now.
> 

You are changing the semantics of the tooling for your single
use case at the expense of the general syntax. No other tc classifier
needs that keyword and no other tunneling feature within flower
needs it. Note:
It was a mistake allowing the speacial casing of vlans to work
around the dissector's shortcomings. Lets not add more now
"fixed" by user space.
Hacks are already happening with flower in user space
(at some point someone removed differentiation of "protocol"
and flower's "ethertype" to accomodate some h/w offload concern).

> In difference with the TC protocol field, orig_ethtype answers the
> question:
> 
> what is the original eth type of the packet, independent of the further
> kernel processing.
> 

"protocol" points to the root of the parse/match tree i.e where
to start matching.
Tom (Cced) has a nice diagram somewhere which i cant find right now.
There are certainly issues with namespace overlap. If you have multiple
"ethertypes" encapsulated in a parse tree, giving them appropriate
names would help. Some of the flower syntax allows that nicely but
only to two levels..


> IMHO, the above definition is also quite exact and has the right to
> exist because we do not have such ability in the current kernel.
> 
>>
>> Would it make sense for the setting of the
>> skb_key.basic.n_proto  to be from tp->protocol for
>> your specific case in classify().
>>
>> Which means your original setup:
>>   tc filter add dev eth0 ingress protocol 0x8864 flower \
>>       action simple sdata hi64
>>
>> should continue to work if i am not mistaken. Vlans would
>> continue to be a speacial case.
>>
>> I dont know what that would break though...
>>
> 
> I think right off the bat, it will break the following user
> configuration (untested!):
> 
> tc filter add dev eth0 ingress protocol ipv4 flower \
>        action simple sdata hi64
>

I dont see how from the code inspection. tp->protocol compare
already happened by the time flower classify() is invoked.
i.e it is correct value specified in configuration.
Dont use your update to iproute2. Just the kernel change
is needed.
I am not worried about your use case - just other tunneling
scenarios; we are going to have to run all tdc testcases and
a few more to validate.

> Currently, the above rule matches ipv4 packets encapsulated in
> ETH_P_PPP_SES protocol. The special casing will break it.

Can you describe the rules?
I think you need something like:
tc filter add dev eth0 ingress protocol 0x8864 flower \
...
ppp_proto ip \
dst_ip ...\
src_ip ....

This will require you introduce new attributes for ppp encaped
inside pppoe; i dont think there will be namespace collision in
the case of ip src/dst because it will be tied to ppp_proto

cheers,
jamal
