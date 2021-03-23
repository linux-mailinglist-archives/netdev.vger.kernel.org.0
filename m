Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F17D3464C4
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 17:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhCWQQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 12:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbhCWQQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 12:16:10 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17ABC0613DA
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 09:16:09 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id k10so28079184ejg.0
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 09:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7ye97/kD0fB4fvidklWuf3DDeIoXfpXzkUHZntoDPd4=;
        b=tFrkzIetoIfPoqbvi0eCuvJs6t/9uLmImC1avvYnHQtapWG1eMcSJELDUmRQQHQlGi
         UY6XIT5Omfj5rcP3jJYD6rV3vRZoXTo85SWRHjFdKOq7toBA2TN2sY+F/qBglRF6f23T
         P5pmmYdPhHuJsk0bCz6PQTX34w926Y76qCjC10ii4udUaNaabU2+C4C2pWkcP1p+8BsP
         2YCcyiStf1Xs1MiDpixHJSFouqaWGnDmOeFx2CY+eH3FztJ9AvDoTMwIfkwJkZlnQSmU
         JeJGDO0ewhBAJupQSYEEvwH5YhX18C+TBLU4B+H5eDgmeJMr9W9xzM4qgBXW1kjHlTHr
         6R2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7ye97/kD0fB4fvidklWuf3DDeIoXfpXzkUHZntoDPd4=;
        b=sB8qtlLOhLY1pZVyOl+osD6m3i4z+2ZOkbjM4r6cd+aZqNbIlPUHlH83bgXhyfzwrZ
         XaRhFJ8kM2b1irgEYvd3HPcr7vfBmyuwRyctZ4135uNOAfQcCdN7XtI6KfYad2I3f64l
         ey5ocxJBCp+pu/cn5Ei/t+kiKtRoG6rVpmCQAIT7hn4CCvr7/38C+oLGr7ATCK97KrBI
         PDNnNY6AsSMiHNTfaqkrsBO5eYMAk5jA/h/Gx08t0vGZYaXKEYPbSYCrCK/uGu4/3ciA
         U+fvZ2fuLWSAwQEgdJV/GiyrRomMIXiueaujgnPYlBUzSd/Nqz8XEMKbZ/IXIHpRKCVp
         xvpA==
X-Gm-Message-State: AOAM533gKnwmMxIQiCRqg6lv8nJoolUcT97XNf7aWrBKZMJ5SXD2Fr0A
        7W9qzxWgLqswFxx7rZW1k0o=
X-Google-Smtp-Source: ABdhPJyLnhuU01Nm2H/Ub+tQDm/k1aCyeSw1DP5/kt7wDeA3U4836qMU8MhRnbzqay7fCm9yBlgAEA==
X-Received: by 2002:a17:906:1453:: with SMTP id q19mr5806192ejc.76.1616516168219;
        Tue, 23 Mar 2021 09:16:08 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z20sm13030476edd.0.2021.03.23.09.16.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 09:16:07 -0700 (PDT)
Subject: Re: [PATCH v2 net 2/3] net: dsa: don't advertise 'rx-vlan-filter' if
 VLAN filtering not global
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210320225928.2481575-1-olteanv@gmail.com>
 <20210320225928.2481575-3-olteanv@gmail.com>
 <d4bb95df-9395-168f-f6e8-33ae620fed8f@gmail.com>
 <20210323120325.5ghp43xfgg4hifpk@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6a9c0cd6-02fe-dced-dce0-410f1104e4ca@gmail.com>
Date:   Tue, 23 Mar 2021 09:16:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210323120325.5ghp43xfgg4hifpk@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/23/2021 5:03 AM, Vladimir Oltean wrote:
> On Mon, Mar 22, 2021 at 07:40:27PM -0700, Florian Fainelli wrote:
>> On 3/20/2021 3:59 PM, Vladimir Oltean wrote:
>>> Because the 'rx-vlan-filter' feature is now dynamically toggled, and our
>>> .ndo_vlan_rx_add_vid does not get called when 'rx-vlan-filter' is off,
>>> we need to avoid bugs such as the following by replaying the VLANs from
>>> 8021q uppers every time we enable VLAN filtering:
>>>
>>> ip link add link lan0 name lan0.100 type vlan id 100
>>> ip addr add 192.168.100.1/24 dev lan0.100
>>> ping 192.168.100.2 # should work
>>> ip link add br0 type bridge vlan_filtering 0
>>> ip link set lan0 master br0
>>> ping 192.168.100.2 # should still work
>>> ip link set br0 type bridge vlan_filtering 1
>>> ping 192.168.100.2 # should still work but doesn't
>>
>> That example seems to work well but see caveat below.
>>
>> # ip link add link gphy name gphy.42 type vlan id 42
>> # ip addr add 192.168.42.1/24 dev gphy.42
>> # ping -c 1 192.168.42.254
>> PING 192.168.42.254 (192.168.42.254): 56 data bytes
>> 64 bytes from 192.168.42.254: seq=0 ttl=64 time=1.473 ms
>>
>> --- 192.168.42.254 ping statistics ---
>> 1 packets transmitted, 1 packets received, 0% packet loss
>> round-trip min/avg/max = 1.473/1.473/1.473 ms
>> # ip link add br0 type bridge vlan_filtering 0
>> # ip link set br0 up
>> # ip addr flush dev gphy
>> # ip link set gphy master br0
>> [  102.184169] br0: port 1(gphy) entered blocking state
>> [  102.189533] br0: port 1(gphy) entered disabled state
>> [  102.196039] device gphy entered promiscuous mode
>> [  102.200831] device eth0 entered promiscuous mode
>> [  102.206781] brcm-sf2 8f00000.ethernet_switch: Port 0 VLAN enabled: 1, filtering: 0
>> [  102.214684] brcm-sf2 8f00000.ethernet_switch: VID: 1, members: 0x0001, untag: 0x0001
>> [  102.228912] brcm-sf2 8f00000.ethernet_switch: Port 8 VLAN enabled: 1, filtering: 0
>> [  102.236736] brcm-sf2 8f00000.ethernet_switch: VID: 1, members: 0x0101, untag: 0x0001
>> [  102.248062] br0: port 1(gphy) entered blocking state
>> [  102.253210] br0: port 1(gphy) entered forwarding state
> 
> So far so good, the call path below triggers your print for the user
> port and the CPU port:
> dsa_switch_vlan_add
> -> b53_vlan_add
>    -> b53_vlan_prepare
>       -> b53_enable_vlan
> VLAN 42 is not installed in hardware.
> 
>> # udhcpc -i br0
>> udhcpc: started, v1.32.0
>> udhcpc: sending discover
>> udhcpc: sending select for 192.168.1.10
>> udhcpc: lease of 192.168.1.10 obtained, lease time 600
>> deleting routers
>> adding dns 192.168.1.254
>> # ping 192.168.42.254
>> PING 192.168.42.254 (192.168.42.254): 56 data bytes
>> 64 bytes from 192.168.42.254: seq=0 ttl=64 time=1.294 ms
>> 64 bytes from 192.168.42.254: seq=1 ttl=64 time=0.884 ms
>> ^C
>> --- 192.168.42.254 ping statistics ---
>> 2 packets transmitted, 2 packets received, 0% packet loss
>> round-trip min/avg/max = 0.884/1.089/1.294 ms
>> # ip link set br0 type bridge vlan_filtering 1
>> [  116.072754] brcm-sf2 8f00000.ethernet_switch: Port 0 VLAN enabled: 1, filtering: 1
> 
> Again, so far so good:
> dsa_port_vlan_filtering
> -> b53_vlan_filtering
>    -> b53_enable_vlan(dev->vlan_enabled(was true), filtering(is true))
> 
>> [  116.080522] brcm-sf2 8f00000.ethernet_switch: Port 0 VLAN enabled: 1, filtering: 0
> 
> This is where it starts to go downhill. There is a time window inside
> dsa_port_vlan_filtering, after we called ds->ops->port_vlan_filtering,
> in which we have not yet committed ds->vlan_filtering, yet we still need
> to call dsa_slave_manage_vlan_filtering, which may delete or restore
> VLANs corresponding to 8021q uppers.
> 
> So this happens:
> dsa_port_vlan_filtering
> -> dsa_slave_manage_vlan_filtering
>    -> dsa_slave_restore_vlan
>       -> dsa_switch_vlan_add
>          -> b53_vlan_add
>             -> b53_vlan_prepare
>                -> b53_enable_vlan(vlan_enabled(is true), ds->vlan_filtering(is false because it hasn't been committed yet))
> 
> I did not take into account the fact that someone might look in
> ds->vlan_filtering in port_vlan_add.
> 
>> [  116.088211] brcm-sf2 8f00000.ethernet_switch: VID: 42, members: 0x0001, untag: 0x0000
>> [  116.098696] brcm-sf2 8f00000.ethernet_switch: Port 8 VLAN enabled: 1, filtering: 0
>> [  116.106474] brcm-sf2 8f00000.ethernet_switch: VID: 42, members: 0x0101, untag: 0x0000
> 
> The VLANs are at least restored as expected, it seems.
> 
>> # ping 192.168.42.254
>> PING 192.168.42.254 (192.168.42.254): 56 data bytes
>> 64 bytes from 192.168.42.254: seq=0 ttl=64 time=0.751 ms
>> 64 bytes from 192.168.42.254: seq=1 ttl=64 time=0.700 ms
>> ^C
>> --- 192.168.42.254 ping statistics ---
>> 2 packets transmitted, 2 packets received, 0% packet loss
>> round-trip min/avg/max = 0.700/0.725/0.751 ms
>> # ping 192.168.1.254
>> PING 192.168.1.254 (192.168.1.254): 56 data bytes
>> 64 bytes from 192.168.1.254: seq=0 ttl=64 time=0.713 ms
>> 64 bytes from 192.168.1.254: seq=1 ttl=64 time=0.916 ms
>> 64 bytes from 192.168.1.254: seq=2 ttl=64 time=0.631 ms
>> ^C
>> --- 192.168.1.254 ping statistics ---
>> 3 packets transmitted, 3 packets received, 0% packet loss
>> round-trip min/avg/max = 0.631/0.753/0.916 ms
>>
>> But you will notice that vlan filtering was not enabled at the switch
>> level for a reason I do not fully understand, or rather there were
>> multiple calls to port_vlan_filtering with vlan_filtering = 0 for the
>> same port.
>>
>> Now if we have a nother port that is a member of a bridge that was
>> created with vlan_filtering=1 from the get go, the standalone ports are
>> not working if they are created before the bridge is:
>>
>> # ip link add link gphy name gphy.42 type vlan id 42
> 
> VLAN filtering is not enabled, so the VLAN is not installed to hardware,
> all ok.
> 
>> # ip addr add 192.168.42.1/24 dev gphy.42
>> # ping -c 1 192.168.42.254
>> PING 192.168.42.254 (192.168.42.254): 56 data bytes
>> 64 bytes from 192.168.42.254: seq=0 ttl=64 time=1.129 ms
>>
>> --- 192.168.42.254 ping statistics ---
>> 1 packets transmitted, 1 packets received, 0% packet loss
>> round-trip min/avg/max = 1.129/1.129/1.129 ms
>> # ip link add br0 type bridge vlan_filtering 1
>> # ip link set rgmii_1 master br0
>> [   86.835014] br0: port 1(rgmii_1) entered blocking state
>> [   86.840622] br0: port 1(rgmii_1) entered disabled state
>> [   86.848084] device rgmii_1 entered promiscuous mode
>> [   86.853153] device eth0 entered promiscuous mode
>> [   86.858308] brcm-sf2 8f00000.ethernet_switch: Port 1 VLAN enabled: 1, filtering: 1
> 
> So far so good, we have this same code path again:
> 
> dsa_port_vlan_filtering
> -> b53_vlan_filtering
>    -> b53_enable_vlan(dev->vlan_enabled(was true), filtering(is true))
> 
>> [   86.866157] brcm-sf2 8f00000.ethernet_switch: Port 0 VLAN enabled: 1, filtering: 0
>> [   86.873985] brcm-sf2 8f00000.ethernet_switch: VID: 42, members: 0x0001, untag: 0x0000
>> [   86.884946] brcm-sf2 8f00000.ethernet_switch: Port 8 VLAN enabled: 1, filtering: 0
>> [   86.892879] brcm-sf2 8f00000.ethernet_switch: VID: 42, members: 0x0101, untag: 0x0000
> 
> Again, we have the same code path that calls dsa_slave_manage_vlan_filtering
> while ds->vlan_filtering is still uncommitted, and therefore false. The
> b53 driver incorrectly saves this value.
> 
>> [   86.904274] brcm-sf2 8f00000.ethernet_switch: Port 1 VLAN enabled: 1, filtering: 1
>> [   86.912097] brcm-sf2 8f00000.ethernet_switch: VID: 1, members: 0x0002, untag: 0x0002
>> [   86.925899] brcm-sf2 8f00000.ethernet_switch: Port 8 VLAN enabled: 1, filtering: 1
>> [   86.933806] brcm-sf2 8f00000.ethernet_switch: VID: 1, members: 0x0102, untag: 0x0002
> 
> And here we have the bridge pvid installed on the user port and the CPU
> port. Since ds->vlan_filtering has been committed in the meantime,
> b53_vlan_enable was called again and filtering is now enabled.
> 
>> # ip link set br0 up
>> [   89.775094] br0: port 1(rgmii_1) entered blocking state
>> [   89.780694] br0: port 1(rgmii_1) entered forwarding state
>> # ip addr add 192.168.4.10/24 dev br0
>> # ping 192.168.4.254
>> PING 192.168.4.254 (192.168.4.254): 56 data bytes
>> 64 bytes from 192.168.4.254: seq=0 ttl=64 time=1.693 ms
>> ^C
>> --- 192.168.4.254 ping statistics ---
>> 1 packets transmitted, 1 packets received, 0% packet loss
>> round-trip min/avg/max = 1.693/1.693/1.693 ms
> 
> Pinging through the VLAN-aware bridge, which uses VID 1, works, ok.
> 
>> # ping 192.168.42.254
>> PING 192.168.42.254 (192.168.42.254): 56 data bytes
>> ^C
>> --- 192.168.42.254 ping statistics ---
>> 2 packets transmitted, 0 packets received, 100% packet loss
> 
> Pinging through gphy.42 doesn't work, even though VID 42 was added both
> to port 8 and to port 0. I don't understand why. I looked at the b53
> driver and I don't see any logic that would skip installing a VLAN if
> ds->vlan_filtering is false.
> 
>> # ping 192.168.1.254
>> PING 192.168.1.254 (192.168.1.254): 56 data bytes
>> ^C
>> --- 192.168.1.254 ping statistics ---
>> 1 packets transmitted, 0 packets received, 100% packet loss
>> #
> 
> Wait a minute, what interface uses the 192.168.1.0/24 subnet in the
> second case?

In the second case it is gphy.

> 
>>
>> Both scenarios work correctly as of net/master prior to this patch series.
> 
> So I have no complete idea why it fails either. I do believe DSA does
> the right things, for the most part.
> 
> Would you be so kind to try this fixup patch on top?

That works for me, thank you! So for the whole patch when you resend,
you can add:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>

> 
> -----------------------------[ cut here ]-----------------------------
> From ddca5c56fbf74764977df70c5eba88015bb9832f Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Tue, 23 Mar 2021 13:56:24 +0200
> Subject: [PATCH] net: dsa: commit vlan_filtering before calling
>  dsa_slave_manage_vlan_filtering
> 
> Some drivers such as b53 look at ds->vlan_filtering in .port_vlan_add.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/dsa/port.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 902095f04e0a..d291e0495084 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -392,6 +392,8 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
>  	if (ds->vlan_filtering_is_global) {
>  		int port;
>  
> +		ds->vlan_filtering = vlan_filtering;
> +
>  		for (port = 0; port < ds->num_ports; port++) {
>  			struct net_device *slave;
>  
> @@ -410,15 +412,13 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
>  			if (err)
>  				goto restore;
>  		}
> -
> -		ds->vlan_filtering = vlan_filtering;
>  	} else {
> +		dp->vlan_filtering = vlan_filtering;
> +
>  		err = dsa_slave_manage_vlan_filtering(dp->slave,
>  						      vlan_filtering);
>  		if (err)
>  			goto restore;
> -
> -		dp->vlan_filtering = vlan_filtering;
>  	}
>  
>  	return 0;
> @@ -426,6 +426,11 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
>  restore:
>  	ds->ops->port_vlan_filtering(ds, dp->index, old_vlan_filtering, NULL);
>  
> +	if (ds->vlan_filtering_is_global)
> +		ds->vlan_filtering = old_vlan_filtering;
> +	else
> +		dp->vlan_filtering = old_vlan_filtering;
> +
>  	return err;
>  }
>  
> -----------------------------[ cut here ]-----------------------------
> 
> Although I am much less confident now about submitting this as a bugfix
> patch to go to stable trees. But I also kind of dislike the idea that
> Tobias' patch (which returns -EOPNOTSUPP in dsa_slave_vlan_rx_add_vid)
> only masks the problem and makes issues harder to reproduce.
> 
> Tobias, how bad is your problem? Do you mind if we tackle it in net-next?
> Also, again, any chance you could make mv88e6xxx not refuse the 8021q
> VLAN IDs?

I was thinking the same last night while sending my results, as far as I
can tell the switches that have global VLAN filtering or hellcreek are
not broken currently right?

If only mv88e6xxx seems to be requiring special treatment, how do we
feel about adding an argument to port_vlan_add() and port_vlan_del()
that tell us the context in which they are called, that is via 802.1q
upper, or via bridge and have mv88e6xxx ignore the former but not the
latter?
-- 
Florian
