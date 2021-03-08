Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9433314FF
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 18:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCHRjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 12:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhCHRid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 12:38:33 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77103C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 09:38:33 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id y67so7712166pfb.2
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 09:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wrKeVo0wD4dsu4dWfzHFK0THjd9UV7PFmoMzwPiokYU=;
        b=WEgZ9Isob1JH8MfV1iLnjxHjfI9VbEeuQQxgh87JPvdNG7ksTt3JizQUJp/9KAQx2j
         yfbJATXw4r/KiyGBDYjSgdLFB/8jEYL3xkveH8Gfob9mRRC8AUZAvZ0jdeYi+SmZZAjz
         USch7UxPYCTT0Y5/H8NDAmWoGIPiizFlBsyMMbwzN0fF3FUGJ80Y4nokoL1jbU00w9Bz
         8rlXZ15xv8sEk80EFCMEHZe1rgc8a7/SJx8/RzkyQi7WDntcNyfnYTyFxcvug3Oej1/B
         TSW2vOZsN8qPV3d0phOTMNcK6bFNg190xATugUhkNZvvuIw+rzPc6SuhHjitIvZbsRI9
         SQmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wrKeVo0wD4dsu4dWfzHFK0THjd9UV7PFmoMzwPiokYU=;
        b=M/zJEejeMHBg86gatl+YoIvTX+dtiYb68LqrG66LyrltXTMyrukS7awlUMEu3lMdxj
         XTRFYJ9HCGaQAhvTnLWXl2D7uB95b1l8p9za7i612il1ysto2YXCx7bKfQ6cTRybVhsV
         aHPchZ+e4H4yzNhNH63gJpVQ/tzXHCADybbCPAShUXdZLNxdVM4nHIsvjrq7Kxwn/ynM
         U3drC56C4H40sukW+/ijI6Ap43NzJjAJTyWKvHykTf5LzYcmJ3E2t/sCYxz17uGfNaxX
         uTp3hAJL8E6IOFOuGnsFgqAOQj+I9qIKIoTTg1pixUSUFlJm94Zj7Mf0xSHiMcLL2rUW
         D3QQ==
X-Gm-Message-State: AOAM5321Ja4hqao1UDwuWdk/ZRRQmns+eJVNxhKgM2++hC8fVUeoh0b5
        bz2q6BhFFv4D0LlET5K8bsNrMOpqlBQ=
X-Google-Smtp-Source: ABdhPJxNzX8zL0n8UxC8oXwnBOLoo5KJ+BrfEGXq/gIXs1r2HkRqxa5JKjw/OO1Nn8FmfqpiZsTCfQ==
X-Received: by 2002:a65:6a43:: with SMTP id o3mr20026036pgu.297.1615225112394;
        Mon, 08 Mar 2021 09:38:32 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d16sm10173pjd.25.2021.03.08.09.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 09:38:31 -0800 (PST)
Subject: Re: [PATCH net 1/2] net: dsa: Accept software VLANs for stacked
 interfaces
To:     Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
References: <20210308150405.3694678-1-tobias@waldekranz.com>
 <20210308150405.3694678-2-tobias@waldekranz.com>
 <20210308154446.ceqp56bh65bsarlt@skbuf>
 <20210308170027.jdehraoyntgqkjo4@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5355d426-0c52-70c1-37a0-0d87ba910ff4@gmail.com>
Date:   Mon, 8 Mar 2021 09:38:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210308170027.jdehraoyntgqkjo4@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/21 9:00 AM, Vladimir Oltean wrote:
> On Mon, Mar 08, 2021 at 05:44:46PM +0200, Vladimir Oltean wrote:
>> On Mon, Mar 08, 2021 at 04:04:04PM +0100, Tobias Waldekranz wrote:
>>> The dsa_slave_vlan_rx_{add,kill}_vid ndos are required for hardware
>>> that can not control VLAN filtering per port, rather it is a device
>>> global setting, in order to support VLAN uppers on non-bridged ports.
>>>
>>> For hardware that can control VLAN filtering per port, it is perfectly
>>> fine to fallback to software VLANs in this scenario. So, make sure
>>> that this "error" does not leave the DSA layer as vlan_add_vid does
>>> not know the meaning of it.
>>>
>>> The blamed commit removed this exemption by not advertising the
>>> feature if the driver did not implement VLAN offloading. But as we
>>> know see, the assumption that if a driver supports VLAN offloading, it
>>> will always use it, does not hold in certain edge cases.
>>>
>>> Fixes: 9b236d2a69da ("net: dsa: Advertise the VLAN offload netdev ability only if switch supports it")
>>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>>> ---
>>
>> So these NDOs exist for drivers that need the 'rx-vlan-filter: on'
>> feature in ethtool -k, which can be due to any of the following reasons:
>> 1. vlan_filtering_is_global = true, some ports are under a VLAN-aware
>>    bridge while others are standalone (this is what you described)
>> 2. Hellcreek. This driver needs it because in standalone mode, it uses
>>    unique VLANs per port to ensure separation. For separation of untagged
>>    traffic, it uses different PVIDs for each port, and for separation of
>>    VLAN-tagged traffic, it never accepts 8021q uppers with the same vid
>>    on two ports.
>> 3. the ports that are under a VLAN-aware bridge should also set this
>>    feature, for 8021q uppers having a VID not claimed by the bridge.
>>    In this case, the driver will essentially not even know that the VID
>>    is coming from the 8021q layer and not the bridge.
>>
>> If a driver does not fall under any of the above 3 categories, there is
>> no reason why it should advertise the 'rx-vlan-filter' feature, therefore
>> no reason why it should implement these NDOs, and return -EOPNOTSUPP.
>>
>> We are essentially saying the same thing, except what I propose is to
>> better manage the 'rx-vlan-filter' feature of the DSA net devices. After
>> your patches, the network stack still thinks that mv88e6xxx ports in
>> standalone mode have VLAN filtering enabled, which they don't. That
>> might be confusing. Not only that, but any other driver that is
>> VLAN-unaware in standalone mode will similarly have to ignore VLANs
>> coming from the 8021q layer, which may add uselessly add to their
>> complexity. Let me prepare an alternative patch series and let's see how
>> they compare against each other.
>>
>> As far as I see, mv88e6xxx needs to treat the VLAN NDOs in case 3 only,
>> and DSA will do that without any sort of driver-level awareness. It's
>> all the other cases (standalone ports mode) that are bothering you.
> 
> So I stopped from sending an alternative solution, because neither mine
> nor yours will fix this situation:
> 
> ip link add link lan0 name lan0.100 type vlan id 100
> ip addr add 192.168.100.1/24 dev lan0.100
> ping 192.168.100.2 # should work
> ip link add br0 type bridge vlan_filtering 0
> ip link set lan0 master br0
> ping 192.168.100.2 # should still work
> ip link set br0 type bridge vlan_filtering 1
> ping 192.168.100.2 # should still work
> 
> Basically my point is that you disregard the vlan_vid_add from the
> lan0.100 upper now because you think you don't need it, but one day will
> come when you will. We've had that problem for a very long while now
> with bridge VLANs, and it wasn't even completely solved yet (that's why
> ds->configure_vlan_while_not_filtering is still a thing). It's
> fundamentally the same with VLANs added by the 8021q layer. I think you
> should see what you can do to make mv88e6xxx stop complaining and accept
> the VLANs from the 8021q uppers even if they aren't needed right away.
> It's a lot easier that way, otherwise you will end up having to replay
> them somehow.

Agreed.
--
Florian
