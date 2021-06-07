Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED1039E4AD
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 19:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhFGREI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 13:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbhFGRED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 13:04:03 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C580AC061766;
        Mon,  7 Jun 2021 10:01:56 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id n12so14258173pgs.13;
        Mon, 07 Jun 2021 10:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RjCxjDlrlLynEb+yw+GoLNzt+VVxFzwoaUFMjIpzrHs=;
        b=qqTDVemq1yaU8/V9qCRwZ5TYLdHXZ8V6fMWLnr6DHnlb6Vkyy205I9frO5pznWZUf9
         LsKRHjNWiYSY8VFrfz5muhZyCb+4kd0O44/WHfiQ0nal+rLLeOMbDZCvxKZzC8Ot24+m
         Ze3GXdYsBekmz6KSvfJIp42h3k1Hf48FqzOqM4ahccpiiU6WpgAwiHu2i9hfU5p28Mre
         x6gJCmwlBmGAKweuQTXBJXIOihn12AF8kgwaYH2Qxba6MbZ2ZUPUI8+jC0/FvGVVG2UL
         HRC8U+VfhfjRco5ODiqNUp5HyKquFEf4VRVRTAtIpqwz0DmlHr1YZffiUSl+xJBmlKzi
         YQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RjCxjDlrlLynEb+yw+GoLNzt+VVxFzwoaUFMjIpzrHs=;
        b=ubb1jaVY0TZoXE15aWqk3x/d4oCX6ACBsWAmqB3h//SaWBINhi3EpgRsAb/YsSd0M1
         B/fZ+2Urxi3d/07JDPOnKzasCmSw8V3HThm3HCjRWXMI13OdaK856ZQ88WxdILkgJyaQ
         iX+Is+HkQZSf6fmkqf2TnFybGAZjAHVmAW20O82p2f3kJeXvR6/i6+cO0jrtfgCLwnKG
         oSqzz21t3H9ntZsUoHQxMOXmFu7bbmiXg+NYDON22LGPNCPLMWVidd0sVYI9C+pmGzbP
         GJ/gVPRdRpTf8RPGTJh/rcvJXSbvwHcfI1xm5VXDNbFwAkCalUXxBC7NUq7FL9oGRegN
         c1vw==
X-Gm-Message-State: AOAM531Pp+cpQSjoBCBVaBnD9SFehZfHRBBJHBJLpKT6c3BK3CFBWVm/
        YareLZLB614wD+l+d0kBYPnsqUcVkOY=
X-Google-Smtp-Source: ABdhPJxqS9Ou+5Tp0fMaPdQcRa52qSvS9busmOE38h3DrgnZkS5qYtt1ilT442LTB4niDZ1JS4qiwg==
X-Received: by 2002:a62:9203:0:b029:2f1:e21a:c545 with SMTP id o3-20020a6292030000b02902f1e21ac545mr1339531pfd.60.1623085315722;
        Mon, 07 Jun 2021 10:01:55 -0700 (PDT)
Received: from [10.1.10.189] (c-69-181-195-191.hsd1.ca.comcast.net. [69.181.195.191])
        by smtp.gmail.com with ESMTPSA id s11sm36280pjz.42.2021.06.07.10.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 10:01:55 -0700 (PDT)
Subject: Re: [RFC PATCH net-next] net: dsa: tag_qca: Check for upstream VLAN
 tag
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Matthew Hagan <mnhagan88@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210605193749.730836-1-mnhagan88@gmail.com>
 <YLvgI1e3tdb+9SQC@lunn.ch> <ed3940ec-5636-63db-a36b-dc6c2220b51d@gmail.com>
 <20210606005335.iuqi4yelxr5irmqg@skbuf>
 <2556ab13-ae7f-ed68-3f09-7bf5359f7801@gmail.com>
 <20210606093810.klwyly5qqhkmfwqx@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <66a78a9e-cc33-07dd-d82b-00b04780e4da@gmail.com>
Date:   Mon, 7 Jun 2021 10:01:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210606093810.klwyly5qqhkmfwqx@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vladimir,

On 6/6/2021 2:38 AM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Sat, Jun 05, 2021 at 08:34:06PM -0700, Florian Fainelli wrote:
>> On 6/5/2021 5:53 PM, Vladimir Oltean wrote:
>>> Hi Matthew,
>>>
>>> On Sat, Jun 05, 2021 at 11:39:24PM +0100, Matthew Hagan wrote:
>>>> On 05/06/2021 21:35, Andrew Lunn wrote:
>>>>
>>>>>> The tested case is a Meraki MX65 which features two QCA8337 switches with
>>>>>> their CPU ports attached to a BCM58625 switch ports 4 and 5 respectively.
>>>>> Hi Matthew
>>>>>
>>>>> The BCM58625 switch is also running DSA? What does you device tree
>>>>> look like? I know Florian has used two broadcom switches in cascade
>>>>> and did not have problems.
>>>>>
>>>>>     Andrew
>>>>
>>>> Hi Andrew
>>>>
>>>> I did discuss this with Florian, who recommended I submit the changes. Can
>>>> confirm the b53 DSA driver is being used. The issue here is that tagging
>>>> must occur on all ports. We can't selectively disable for ports 4 and 5
>>>> where the QCA switches are attached, thus this patch is required to get
>>>> things working.
>>>>
>>>> Setup is like this:
>>>>                        sw0p2     sw0p4            sw1p2     sw1p4 
>>>>     wan1    wan2  sw0p1  +  sw0p3  +  sw0p5  sw1p1  +  sw1p3  +  sw1p5
>>>>      +       +      +    |    +    |    +      +    |    +    |    +
>>>>      |       |      |    |    |    |    |      |    |    |    |    |
>>>>      |       |    +--+----+----+----+----+-+ +--+----+----+----+----+-+
>>>>      |       |    |         QCA8337        | |        QCA8337         |
>>>>      |       |    +------------+-----------+ +-----------+------------+
>>>>      |       |             sw0 |                     sw1 |
>>>> +----+-------+-----------------+-------------------------+------------+
>>>> |    0       1    BCM58625     4                         5            |
>>>> +----+-------+-----------------+-------------------------+------------+
>>>
>>> It is a bit unconventional for the upstream Broadcom switch, which is a
>>> DSA master of its own, to insert a VLAN ID of zero out of the blue,
>>> especially if it operates in standalone mode. Supposedly sw0 and sw1 are
>>> not under a bridge net device, are they?
>>
>> This is because of the need (or desire) to always tag the CPU port
>> regardless of the untagged VLAN that one of its downstream port is being
>> added to. Despite talking with Matthew about this before, I had not
>> realized that dsa_port_is_cpu() will return true for ports 4 and 5 when
>> a VLAN is added to one of the two QCA8337 switches because from the
>> perspective of that switch, those ports have been set as DSA_PORT_TYPE_CPU.
> 
> It will not, the ports maintain the same roles regardless of whether
> there is another switch attached to them or not. For the BCM58625
> switch, ports 4 and 5 are user ports with net devices that each happen
> to be DSA masters for 2 QCA8337 switches, and port 8 is the CPU port.

Right, I was not thinking properly while submitting that counter
proposal it does not make sense and neither did my explanation, I was
just too keen on thinking that the problem would be that one of the user
facing port (even if they happen to be the "CPU" port of another switch)
would be adding the tag on egress when the problem is that the CPU port
is egress tagged to begin with. This is not a problem for normal user
ports as you say because the network stack has all smarts about dealing
with that. I would like to get a proper tcpdump capture of the DSA
master first to make sure

> 
> When a DSA user port is a DSA master for another switch, tag stacking
> takes place - first the rcv() from tag_brcm.c runs, then the rcv() from
> tag_qca.c runs - you taught me this, in fact.
> 
> My point is that the Broadcom switch should leave the packet in a state
> where tag_qca.c can work with it without being aware that it has been
> first processed by another switch. This is why I asked Matthew whether
> he configured any bridging between BCM58625 ports 4 and 5, and any
> bridge VLANs. I am not completely sure we should start modifying our DSA
> taggers under the assumption that VLANs might just pop up everywhere -
> I simply don't see a compelling use case to let that happen and justify
> the complexity.
> 
> In this case, my suspicion is that the root of the issue is the
> resolution from commit d965a5432d4c ("net: dsa: b53: Ensure the default
> VID is untagged"). It seems like it wanted to treat VID 0 as untagged if
> it's the pvid, but it only treats it as untagged in one direction.

We only have control over the egress tagging attribute on Broadcom
switches and there is no "egress unmodified" unlike Marvell switches, so
we do indeed have an asymmetrical configuration in that the following
happens:

- user port egress untagged -> egress tagged towards CPU port
- CPU port egress untagged frame -> egress untagged towards user port

The CPU port, by virtue of using Broadcom tags can override any VLAN
membership.

> 
> For the network stack, I think there are checks scattered in
> __netif_receive_skb_core that make it treat a skb with VID == 0 as if it
> was untagged, so the fact that untagged packets are sent as egress-tagged
> with VID=0 by the Broadcom CPU port (8) towards the system, and received
> as VLAN-tagged by tag_brcm.c, is not that big of a problem. The problem
> only appears when there is another DSA switch downstream of it, because
> it shifts the expected position of the DSA tag in tag_qca.c.
> 
> DSA switch drivers don't normally send all packets as egress-tagged
> towards the CPU. If they do, they ought to be more careful and not let
> VLAN tags escape their tagging driver, if there was no VLAN tag to begin
> with in the packet as seen on the wire.
> 
> We might make a justifiable exception in the case where DSA_TAG_PROTO_NONE
> is used, but in this case, my understanding is that BCM58625 uses
> DSA_TAG_PROTO_BRCM_PREPEND, so I'm not sure why sending packets towards
> the CPU with VID=0 instead of untagged makes that big of a difference.

I don't think there is any justification for doing what b53 does
anymore. Let me sleep on it for a day and submit a patch for Matthew to
try out.
-- 
Florian
