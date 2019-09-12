Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAB7B12B9
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 18:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730233AbfILQZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 12:25:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45391 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfILQZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 12:25:17 -0400
Received: by mail-wr1-f66.google.com with SMTP id l16so29053454wrv.12
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 09:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q0esKrx2S3o2ECcF4dxyBNxjka7vbXuCzJaNWNa4qtA=;
        b=m59L9I4tiRVi75viJ2do2o6/wqhoh9K2KnlX32Ib+7ve/ZANQh/gX6pYO1I/HA1iUQ
         kYMUmc01o+Am+PU0TZ0AX3FfRAoAz3gQsFoar5y8XpZ8bqc9zBCCFkh5KOS4NxyTJlv+
         /eMRs1JzfevBjTmeZWajhRRbynwnB7loJpCNF703BdbMc5F1KD5mTxMO2w1XNhXaTb1z
         2/grJ9CGz45VaMq6ryMJhgcSAxbRmAW1WRx4nti99re/xWPH4J0bCIp+sAkPlzah5ANz
         W837OoXoBKWl9VeSbDyygU1Ale3q9YPeESC87CAYTqo0fGF7/9X6Bvjq1hjNpOzMIgAa
         LSyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=q0esKrx2S3o2ECcF4dxyBNxjka7vbXuCzJaNWNa4qtA=;
        b=YBpTYKXgey/z2umQfCMNYZVuGUIUFnqLrPw8+PkfeBLOAWLIpfSw3hPpfiQyTm14XS
         3Aq4NT+24ABNqW8A7V7W3SDdZ7KfIhj5OWmGe0Dcu8kREA2Er2kRK2BjYXxUhuRzOENe
         i5PzJE/5cw3B3BzCPX06SFs7ybnpe8wUPGaylCX2puSPyK4rTRx7f0Rru+tuhTcotZ1N
         uYFKKUb8XxwQ3UZ4t++/5IbqwYJyuFZzQMKjTnF0glv2zaP54Ew9RwW/f6rWx/M+vOZf
         phrCrbAclKFYxbjty/mKxOpf89NSUvasK6lOsNeV4GOzyP57B4hfclnS/SNi8DmIO6tv
         wrCg==
X-Gm-Message-State: APjAAAU+UDMSEPmVYu0T63cynL85IFpINSarFaiAEZJszjElOUQEJrY7
        9FT/Dz9UjYoD4S4lYbJ1z3g=
X-Google-Smtp-Source: APXvYqxZEy4ZkkbooM/ozkqMOsvSXh9B2utqCG2u3ipWxlG0ue6HJciLf7H9W1j+FkVQpXGJ6Ob9+w==
X-Received: by 2002:a5d:5402:: with SMTP id g2mr37939034wrv.291.1568305511919;
        Thu, 12 Sep 2019 09:25:11 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w8sm3720753wmc.1.2019.09.12.09.25.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 09:25:10 -0700 (PDT)
Subject: Re: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
To:     Ido Schimmel <idosch@mellanox.com>,
        Robert Beckett <bob.beckett@collabora.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <545d6473-848f-3194-02a6-011b7c89a2ca@gmail.com>
 <20190911112134.GA20574@splinter>
 <3f50ee51ec04a2d683a5338a68607824a3f45711.camel@collabora.com>
 <20190912090339.GA16311@splinter>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <68676250-17df-b0bb-521a-64877f198647@gmail.com>
Date:   Thu, 12 Sep 2019 09:25:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190912090339.GA16311@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/19 2:03 AM, Ido Schimmel wrote:
> On Wed, Sep 11, 2019 at 12:49:03PM +0100, Robert Beckett wrote:
>> On Wed, 2019-09-11 at 11:21 +0000, Ido Schimmel wrote:
>>> On Tue, Sep 10, 2019 at 09:49:46AM -0700, Florian Fainelli wrote:
>>>> +Ido, Jiri,
>>>>
>>>> On 9/10/19 8:41 AM, Robert Beckett wrote:
>>>>> This patch-set adds support for some features of the Marvell
>>>>> switch
>>>>> chips that can be used to handle packet storms.
>>>>>
>>>>> The rationale for this was a setup that requires the ability to
>>>>> receive
>>>>> traffic from one port, while a packet storm is occuring on
>>>>> another port
>>>>> (via an external switch with a deliberate loop). This is needed
>>>>> to
>>>>> ensure vital data delivery from a specific port, while mitigating
>>>>> any
>>>>> loops or DoS that a user may introduce on another port (can't
>>>>> guarantee
>>>>> sensible users).
>>>>
>>>> The use case is reasonable, but the implementation is not really.
>>>> You
>>>> are using Device Tree which is meant to describe hardware as a
>>>> policy
>>>> holder for setting up queue priorities and likewise for queue
>>>> scheduling.
>>>>
>>>> The tool that should be used for that purpose is tc and possibly an
>>>> appropriately offloaded queue scheduler in order to map the desired
>>>> scheduling class to what the hardware supports.
>>>>
>>>> Jiri, Ido, how do you guys support this with mlxsw?
>>>
>>> Hi Florian,
>>>
>>> Are you referring to policing traffic towards the CPU using a policer
>>> on
>>> the egress of the CPU port? At least that's what I understand from
>>> the
>>> description of patch 6 below.
>>>
>>> If so, mlxsw sets policers for different traffic types during its
>>> initialization sequence. These policers are not exposed to the user
>>> nor
>>> configurable. While the default settings are good for most users, we
>>> do
>>> want to allow users to change these and expose current settings.
>>>
>>> I agree that tc seems like the right choice, but the question is
>>> where
>>> are we going to install the filters?
>>>
>>
>> Before I go too far down the rabbit hole of tc traffic shaping, maybe
>> it would be good to explain in more detail the problem I am trying to
>> solve.
>>
>> We have a setup as follows:
>>
>> Marvell 88E6240 switch chip, accepting traffic from 4 ports. Port 1
>> (P1) is critical priority, no dropped packets allowed, all others can
>> be best effort.
>>
>> CPU port of swtich chip is connected via phy to phy of intel i210 (igb
>> driver).
>>
>> i210 is connected via pcie switch to imx6.
>>
>> When too many small packets attempt to be delivered to CPU port (e.g.
>> during broadcast flood) we saw dropped packets.
>>
>> The packets were being received by i210 in to rx descriptor buffer
>> fine, but the CPU could not keep up with the load. We saw
>> rx_fifo_errors increasing rapidly and ksoftirqd at ~100% CPU.
>>
>>
>> With this in mind, I am wondering whether any amount of tc traffic
>> shaping would help? Would tc shaping require that the packet reception
>> manages to keep up before it can enact its policies? Does the
>> infrastructure have accelerator offload hooks to be able to apply it
>> via HW? I dont see how it would be able to inspect the packets to apply
>> filtering if they were dropped due to rx descriptor exhaustion. (please
>> bear with me with the basic questions, I am not familiar with this part
>> of the stack).
>>
>> Assuming that tc is still the way to go, after a brief look in to the
>> man pages and the documentation at largc.org, it seems like it would
>> need to use the ingress qdisc, with some sort of system to segregate
>> and priortise based on ingress port. Is this possible?
> 
> Hi Robert,
> 
> As I see it, you have two problems here:
> 
> 1. Classification: Based on ingress port in your case
> 
> 2. Scheduling: How to schedule between the different transmission queues
> 
> Where the port from which the packets should egress is the CPU port,
> before they cross the PCI towards the imx6.
> 
> Both of these issues can be solved by tc. The main problem is that today
> we do not have a netdev to represent the CPU port and therefore can't
> use existing infra like tc. I believe we need to create one. Besides
> scheduling, we can also use it to permit/deny certain traffic from
> reaching the CPU and perform policing.

We do not necessarily have to create a CPU netdev, we can overlay netdev
operations onto the DSA master interface (fec in that case), and
whenever you configure the DSA master interface, we also call back into
the switch side for the CPU port. This is not necessarily the cleanest
way to do things, but that is how we support ethtool operations (and
some netdev operations incidentally), and it works
-- 
Florian
