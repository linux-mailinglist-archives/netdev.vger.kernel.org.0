Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C34B5163038
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 20:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbgBRTen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 14:34:43 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:32971 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727405AbgBRTek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 14:34:40 -0500
Received: by mail-pl1-f196.google.com with SMTP id ay11so8492852plb.0
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 11:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zcouhw9a1Z5pZ6hasJWSPNw1g5IDYkXyPjjikBhA7Po=;
        b=dJgG0BJdR96AC55r33SNhO8QZwvE9QfYJTKbMaDzR/kbDFYpcIYJ1Tcfgs9SSM+WXv
         PSvdVX/DQzNhi+YU/ki6Sli1qeyxHIxHcbYUZsldzH3RdVCAais9SEDwYOvtabcq64+z
         S19aY+um7mmD6TPFoxx4qlGqjI0u93PvMDY8S9xcXqxNgbd83yknPZRt945vdNNv8GoY
         i4mVRCLp9HUBzZa/gYpUZE1lJbPJ6+LjlcDjhljdYxlaR9fFr3FChwmoeRC8xzt+ZDCY
         t+7YNS/Jo/Ax79dIYuHERUSXNzYRuwXDIONTYLZwuNgErcSogau4n6512SaDGjE2aLr3
         Mq4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Zcouhw9a1Z5pZ6hasJWSPNw1g5IDYkXyPjjikBhA7Po=;
        b=OAvpkcklD4+aDGPrNfEej9Nplub16PdW6a51vfZUQcX1qWEfXU6yi39TyFJDO89I+5
         I3T/ckPtPJ4iSgAB2If6qXn7F0tiQgbwQ++gg4nbW8zvbiet5TdVJx0x1dNoztTVRV7C
         sz+5eJ5yd8T33bDa70Ivgztf1N4WwRrFtHeIN+SNgBGtqH4EP1szqW9g4yl28CYWvry5
         TgsVhcWSZZptZaiMHnOuqym2bDCihCa2ituge//MuLyF4D3b+WEmrrCyc27UBI0mLdK/
         Ca2GfScEII5NwYIIuLwnR4hUcwpE60nA7BZ+7BQPpgggxkN7NQIiJDeh8Cf90YVgCr/5
         t4/g==
X-Gm-Message-State: APjAAAVpwD/ukLStdUFKZQ3hjVQSMmt82hg1VgMFcfeF/1vaVvns/HDU
        TD0AV+0b+k/+fpjFoW1pd4w=
X-Google-Smtp-Source: APXvYqw1ORP0QgjKCwGZQn4T5bmb5Kp7Z4SbxPWhp9ltxp/fgM0pkq+BMofJHbCYsiWBhPugSvrMhA==
X-Received: by 2002:a17:90a:ec02:: with SMTP id l2mr4714163pjy.12.1582054479866;
        Tue, 18 Feb 2020 11:34:39 -0800 (PST)
Received: from [10.67.49.41] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r3sm5255423pfg.145.2020.02.18.11.34.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 11:34:39 -0800 (PST)
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: fix vlan setup
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <E1j41KW-0002v5-2S@rmk-PC.armlinux.org.uk>
 <20200218140907.GB15095@t480s.localdomain>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <3bfda6cc-5108-427f-e225-beba0f809d73@gmail.com>
Date:   Tue, 18 Feb 2020 11:34:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218140907.GB15095@t480s.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/20 11:09 AM, Vivien Didelot wrote:
> Hi Russell,
> 
> On Tue, 18 Feb 2020 11:46:20 +0000, Russell King <rmk+kernel@armlinux.org.uk> wrote:
>> DSA assumes that a bridge which has vlan filtering disabled is not
>> vlan aware, and ignores all vlan configuration. However, the kernel
>> software bridge code allows configuration in this state.
>>
>> This causes the kernel's idea of the bridge vlan state and the
>> hardware state to disagree, so "bridge vlan show" indicates a correct
>> configuration but the hardware lacks all configuration. Even worse,
>> enabling vlan filtering on a DSA bridge immediately blocks all traffic
>> which, given the output of "bridge vlan show", is very confusing.
>>
>> Provide an option that drivers can set to indicate they want to receive
>> vlan configuration even when vlan filtering is disabled. This is safe
>> for Marvell DSA bridges, which do not look up ingress traffic in the
>> VTU if the port is in 8021Q disabled state. Whether this change is
>> suitable for all DSA bridges is not known.
>>
>> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>> ---
>>  drivers/net/dsa/mv88e6xxx/chip.c |  1 +
>>  include/net/dsa.h                |  1 +
>>  net/dsa/slave.c                  | 12 ++++++++----
>>  3 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
>> index 629eb7bbbb23..e656e571ef7d 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.c
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
>> @@ -2934,6 +2934,7 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
>>  
>>  	chip->ds = ds;
>>  	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
>> +	ds->vlan_bridge_vtu = true;
>>  
>>  	mv88e6xxx_reg_lock(chip);
>>  
>> diff --git a/include/net/dsa.h b/include/net/dsa.h
>> index 63495e3443ac..d3a826646e8e 100644
>> --- a/include/net/dsa.h
>> +++ b/include/net/dsa.h
>> @@ -273,6 +273,7 @@ struct dsa_switch {
>>  	 * settings on ports if not hardware-supported
>>  	 */
>>  	bool			vlan_filtering_is_global;
>> +	bool			vlan_bridge_vtu;
>>  
>>  	/* In case vlan_filtering_is_global is set, the VLAN awareness state
>>  	 * should be retrieved from here and not from the per-port settings.
>> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>> index 088c886e609e..534d511b349e 100644
>> --- a/net/dsa/slave.c
>> +++ b/net/dsa/slave.c
>> @@ -318,7 +318,8 @@ static int dsa_slave_vlan_add(struct net_device *dev,
>>  	if (obj->orig_dev != dev)
>>  		return -EOPNOTSUPP;
>>  
>> -	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
>> +	if (dp->bridge_dev && !dp->ds->vlan_bridge_vtu &&
>> +	    !br_vlan_enabled(dp->bridge_dev))
>>  		return 0;
>>  
>>  	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
>> @@ -385,7 +386,8 @@ static int dsa_slave_vlan_del(struct net_device *dev,
>>  	if (obj->orig_dev != dev)
>>  		return -EOPNOTSUPP;
>>  
>> -	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
>> +	if (dp->bridge_dev && !dp->ds->vlan_bridge_vtu &&
>> +	    !br_vlan_enabled(dp->bridge_dev))
>>  		return 0;
>>  
>>  	/* Do not deprogram the CPU port as it may be shared with other user
>> @@ -1106,7 +1108,8 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>>  	 * need to emulate the switchdev prepare + commit phase.
>>  	 */
>>  	if (dp->bridge_dev) {
>> -		if (!br_vlan_enabled(dp->bridge_dev))
>> +		if (!dp->ds->vlan_bridge_vtu &&
>> +		    !br_vlan_enabled(dp->bridge_dev))
>>  			return 0;
>>  
>>  		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
>> @@ -1140,7 +1143,8 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
>>  	 * need to emulate the switchdev prepare + commit phase.
>>  	 */
>>  	if (dp->bridge_dev) {
>> -		if (!br_vlan_enabled(dp->bridge_dev))
>> +		if (!dp->ds->vlan_bridge_vtu &&
>> +		    !br_vlan_enabled(dp->bridge_dev))
>>  			return 0;
>>  
>>  		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
> 
> It is confusing to add a Marvell specific term (VTU) in the generic dsa_switch
> structure to bypass the fact that VLAN configuration in hardware was already
> bypassed for some reasons until vlan filtering is turned on. As you said,
> simply offloading the VLAN configuration in hardware and only turning the
> ports' 802.1Q mode to Secure once vlan_filtering is flipped to 1 should work
> in theory for both VLAN filtering aware and unaware scenarios, but this was
> causing problems if I'm not mistaken, I'll try to dig this out.
> 
> In the meantime, does the issue you're trying to solve here happens if you
> create a vlan-filtering aware bridge in the first place, before any VLAN
> configuration? i.e.:
> 
>     # ip link add name br0 type bridge vlan_filtering 1
>     # ip link set master br0 dev lan1 up
>     # bridge vlan add ...

That will work okay because then you do get around the restrictions
added by 2ea7a679ca2abd251c1ec03f20508619707e1749 ("net: dsa: Don't add
vlans when vlan filtering is disabled") and you will get VLAN objects
programming request to flow down your DSA driver. AFAICT, mlxsw
specifically prevents to toggle vlan_filtering at runtime for that
reason, because the VLAN objects notification are not "sent again" while
you toggle vlan_filtering. I really wonder if we should not do the same
in DSA as runtime toggling is of questionable use beyond just testing.

Russell, in your tests/examples, did the tagged traffic of $VN continue
to work after you toggled vlan_filtering on? If so, that must be because
on a bridge with VLAN filtering disabled, we still ended up calling down
to the lan1..6 ndo_vlan_rx_add_vid() and so we do have VLAN entries
programmed for $VN.
-- 
Florian
