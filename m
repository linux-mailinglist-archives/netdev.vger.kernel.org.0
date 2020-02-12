Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E7715B2B5
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 22:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgBLV2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 16:28:32 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42567 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727420AbgBLV2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 16:28:32 -0500
Received: by mail-ed1-f66.google.com with SMTP id e10so4121917edv.9;
        Wed, 12 Feb 2020 13:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zA+YU8ReUi/0ae6CAaxfuHRSGLgBv7ovkCkn/iNPxhk=;
        b=bUqvP+q735g2EZjRvjKosa+gPsciGyFK/4/a4/uFXxYp6YZcu6lU8zAx1UDzAOmGOy
         COmV5v71fGmEWgMXtvoMBU0llOWUtqQmOX/Fu4EQYO+2X+ib05iPuS4vO21/BX8swWq0
         IEkF4tU2ml6QMjQb3YhZaHakCtRLCeE4qTCdlR/oFmxvKBExMQ0uzhsKEvSVPgfaRu3x
         umiBuovJy6SeY40a/nQgzcufmkdpb3Xy02cYdrhbiEJGl/PmS0PvJOaDW3HQbRvT640L
         p4UrHzB9rihKxWOrjVnHby0sLkdzl3dzXg4CtH/R2UdQlDdKeH73Z0zwT+LLavK52gaU
         hNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zA+YU8ReUi/0ae6CAaxfuHRSGLgBv7ovkCkn/iNPxhk=;
        b=gwZYgr/jKKF07sZsC85AughwehMfnAsUigz0tqWOwbrJZXYFemVvmoY9m/PnDvXeda
         6aBNiUd2SdusEzAGP8rX/eecUB8UhFmtRnFDTJVqRPhDWcSr7L/nVONZ8muQEj62WCx+
         xrys7PzgA3W393SCJbmMrR2Q668+yqOB+793PcBigHTfSkOwv5ZHt0BBL4pZcycEhWNM
         fbUxT9F5KTs5S5z5McpWhG13Yb5No9rG4FqPAv2WgThEav0OfEuNiuHn4/ZJlo6rHfFf
         iURJEWZNheYLZ5L8o/QfrTOIhpgGKKR5EhIw71PZSPu9Y7sYRobzXl2st8V09AbYgNDi
         8Aeg==
X-Gm-Message-State: APjAAAXICQjVtGt8nHWy9hDGY9yEEjenhzUB7y8aSuCwW6eL6jNJdDHH
        fYLzy55zK/sQbc8BSRb2QsiIALiy
X-Google-Smtp-Source: APXvYqzPmxtytWdMachkPHPV6wq0/+IYH0DiSUfy+uC8N4Xd98gzYmIfTY4cANu7SJ54NTfwlbw0ew==
X-Received: by 2002:a50:cfc1:: with SMTP id i1mr12607102edk.369.1581542909672;
        Wed, 12 Feb 2020 13:28:29 -0800 (PST)
Received: from [10.67.50.49] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l11sm33520edi.28.2020.02.12.13.28.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 13:28:29 -0800 (PST)
Subject: Re: [PATCH net] net: dsa: Treat VLAN ID 0 as PVID untagged
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, michal.vokac@ysoft.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200212200555.2393-1-f.fainelli@gmail.com>
 <CA+h21hpG5y1D2d53P7KK6X5uBFxoSQ_iCs3rRAJe61yxfWWAPA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <6ba11003-48fd-0b93-332d-3bc485bcb577@gmail.com>
Date:   Wed, 12 Feb 2020 13:28:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CA+h21hpG5y1D2d53P7KK6X5uBFxoSQ_iCs3rRAJe61yxfWWAPA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/12/20 12:47 PM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Wed, 12 Feb 2020 at 22:06, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> VLAN ID 0 is special by all kinds and is really meant to be the default
>> ingress and egress untagged VLAN. We were not configuring it that way
>> and so we would be ingress untagged but egress tagged.
>>
>> When our devices are interfaced with other link partners such as switch
>> devices, the results would be entirely equipment dependent. Some
>> switches are completely fine with accepting an egress tagged frame with
>> VLAN ID 0 and would send their responses untagged, so everything works,
>> but other devices are not so tolerant and would typically reject a VLAN
>> ID 0 tagged frame.
> 
> Are you sure that it's not in fact those devices that are not doing
> what they're supposed to? VID 0 should be sent as tagged and no port
> membership checks should be enforced on it.

Where everything works what I see is the following:

- Linux on egress sends an untagged frame (as captured by tcpdump) but
the VLAN entry for VID 0 makes it egress tagged and the machine on the
other sees it as such as well
- the response from that machine is also ingress tagged as captured from
the DSA master network device

what I do not have visibility into are systems where this does not work
but will try to request that. Breaking users is obviously bad which
prompted me for doing this specification violating frame. I am not sure
whether DSA standalone ports qualify as managed ports or not, sounds
like no given we have not added support for doing much UC/MC filtering
unlike what NICs do.

> 
>>
>> Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>> Hi all,
>>
>> After looking at all DSA drivers and how they implement port_vlan_add()
>> I think this is the right change to do, but would appreciate if you
>> could test this on your respective platforms to ensure this is not
>> problematic.
> 
> I'm pretty sure this is problematic, for the simple reason that with
> this change, DSA is insisting that the default PVID is 0, contrary to
> the bridge core which insists it is 1. And some switches, like the
> Microchip Ocelot/Felix, don't support more than 1 egress-untagged
> VLAN, so adding one of the VIDs 0 or 1 will fail (I don't know the
> exact order off-hand). See 1c44ce560b4d ("net: mscc: ocelot: fix
> vlan_filtering when enslaving to bridge before link is up") for more
> details of how that is going to work.

OK, I do wonder if we would be better off just skipping the VLAN
programming for VID = 0 and/or just defining a different
reserved/default VLAN ID for switches that have global VLAN filtering.

> 
>>
>> Thank you
>>
>>
>>  net/dsa/slave.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>> index 088c886e609e..d3a2782eb94d 100644
>> --- a/net/dsa/slave.c
>> +++ b/net/dsa/slave.c
>> @@ -1100,6 +1100,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>>  {
>>         struct dsa_port *dp = dsa_slave_to_port(dev);
>>         struct bridge_vlan_info info;
>> +       u16 flags = 0;
>>         int ret;
>>
>>         /* Check for a possible bridge VLAN entry now since there is no
>> @@ -1118,7 +1119,13 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>>                         return -EBUSY;
>>         }
>>
>> -       ret = dsa_port_vid_add(dp, vid, 0);
>> +       /* VLAN ID 0 is special and should be the default egress and ingress
>> +        * untagged VLAN, make sure it gets programmed as such.
>> +        */
>> +       if (vid == 0)
>> +               flags = BRIDGE_VLAN_INFO_PVID | BRIDGE_VLAN_INFO_UNTAGGED;
> 
> IEEE 802.1Q-2018, page 247, Table 9-2—Reserved VID values:
> 
> The null VID. Indicates that the tag header contains only priority
> information; no VID is
> present in the frame. This VID value shall not be configured as a PVID
> or a member of a VID
> Set, or configured in any FDB entry, or used in any Management operation.
> 
>> +
>> +       ret = dsa_port_vid_add(dp, vid, flags);
>>         if (ret)
>>                 return ret;
>>
>> --
>> 2.17.1
>>
> 
> Is this a test?

Of course, I am always testing you, that way you do not know if I am
incredibly smart or stupid.
-- 
Florian
