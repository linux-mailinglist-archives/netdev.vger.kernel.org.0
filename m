Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F24D9BFF2
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 22:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfHXUEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 16:04:09 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44465 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbfHXUEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 16:04:09 -0400
Received: by mail-pf1-f196.google.com with SMTP id c81so8942404pfc.11
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 13:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lMrNIONqBXuXO7iSiAUYJ41IfkojB+H7ZXGwgQgaJd8=;
        b=CIePRIIhJcuiN5OXaf459/hMOXxX5M9xWYcM7elesfRTEGXlh8pO7bRwdpYLejq2m1
         QgkL50K3VplUGCWyinjWMXlJ/tyYgMh57ZXvVZXjuBodMa4aj8Pmlg17M6bJ2E2T766R
         SxqINchSROjf10zMpgDUsjoj0LlgdLBuv24Yj+qMMNSvENXI7SdRZ3Y31RYXNqMsIN3n
         3IOdBK1QpsTCYArYP6XEUSb9b8U4dA20VE+0ywRr+gBY2TtWhZivubEI46WVnysiYlVh
         yA/y+E4bkEruOXqf1HVnabjipjU3bgznYSBSsZ4SoJf3gTC+wFqKBzpA4xNErYaZMhoX
         3OOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lMrNIONqBXuXO7iSiAUYJ41IfkojB+H7ZXGwgQgaJd8=;
        b=CRDkFTdBz4EECay+zzK48sw7Mf2I36BfxvvEnMq43gcyoyM1f10Z5o3Zit6SJFW+yX
         2xVOIgOA69MiLsljoD+hHsLaZMmRgqkRNUl4iUoN3XzTknGC172PP1W+ai4wlHfBDZjg
         pFt1M+Lxd+JvBRB+ZvslC5S+Idh6Ah0JJ1SCsPCIbqqoh1P2TafSoScsBS5zw/QzJyBN
         mUOYDksL8ZF8oSLsnqVLY9T55NYkr+t71LDHlH3et7KELj5/wxY+cnDBIQtoTtksb5z2
         hmVCfX34HHzLsZZ+BZMZ9daOBHExONuQxTMI5tFjZzglDQXiZOzIpni8h0eshg7yPSe8
         ypPQ==
X-Gm-Message-State: APjAAAUXG26niMURIIQdziFUnrQZTUC9GWoP/u7zIdx5DM1eZbtRNwBY
        M/f0C280ShNCSnIF9nvz4N1h3DnR
X-Google-Smtp-Source: APXvYqySJJaWP+l/e8N5KIkN+rHO1ABfK/86kZziWkMMkNBahJyILn9hywisWBjw2SIHfeqbogsyUQ==
X-Received: by 2002:a63:5823:: with SMTP id m35mr9541977pgb.329.1566677047753;
        Sat, 24 Aug 2019 13:04:07 -0700 (PDT)
Received: from [10.230.7.147] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id 195sm7281473pfu.75.2019.08.24.13.04.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 24 Aug 2019 13:04:06 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Chris Healy <cphealy@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20190824024251.4542-1-marek.behun@nic.cz>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <a7fed8ab-60f3-a30c-5634-fd89e4daf44d@gmail.com>
Date:   Sat, 24 Aug 2019 13:04:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190824024251.4542-1-marek.behun@nic.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/23/2019 7:42 PM, Marek Behún wrote:
> Hi,
> this is my attempt to solve the multi-CPU port issue for DSA.
> 
> Patch 1 adds code for handling multiple CPU ports in a DSA switch tree.
> If more than one CPU port is found in a tree, the code assigns CPU ports
> to user/DSA ports in a round robin way. So for the simplest case where
> we have one switch with N ports, 2 of them of type CPU connected to eth0
> and eth1, and the other ports labels being lan1, lan2, ..., the code
> assigns them to CPU ports this way:
>   lan1 <-> eth0
>   lan2 <-> eth1
>   lan3 <-> eth0
>   lan4 <-> eth1
>   lan5 <-> eth0
>   ...
> 
> Patch 2 adds a new operation to the net device operations structure.
> Currently we use the iflink property of a net device to report to which
> CPU port a given switch port si connected to. The ip link utility from
> iproute2 reports this as "lan1@eth0". We add a new net device operation,
> ndo_set_iflink, which can be used to set this property. We call this
> function from the netlink handlers.
> 
> Patch 3 implements this new ndo_set_iflink operation for DSA slave
> device. Thus the userspace can request a change of CPU port of a given
> port.
> 
> I am also sending patch for iproute2-next, to add support for setting
> this iflink value.

This is going to be a long email, that is broken into several parts,
feel free to skip/reply on the parts you would like.

- review/comments on your approach here
- history of multiple CPU ports within Broadcom switches
- specific use case for a device that uses upstream drivers and a
Broadcom switch (BCM7278)

1) Your approach is kind of interesting here, not sure if it is the best
but it is not outright wrong. In the past, we had been talking about
different approaches, some of which seemed too simplistic or too narrow
on the use case, and some of which that are up in the air and were not
worked on.

- John Crispin submitted a patch series for the MTK switch driver a
while back that was picked up by Frank Wunderlich more recently. This
approach uses a Device Tree based configuration in order to statically
assign ports, or groups of ports to a specific DSA master device. This
is IMHO wrong because a) DT is not to impose a policy but strictly
describe HW, and b) there was no way to change that static assignment at
runtime.

- Based on that patch series, Andrew, Vivien, Frank and myself discussed
two possible options:
	- allowing the enslaving of DSA master devices in the bridge, so as to
provide a hint that specific DSA slave network devices should be
"bound"/"linked" to a specific DSA master device. This requires
modifications in the bridge layer to avoid undoing what commit
8db0a2ee2c6302a1dcbcdb93cb731dfc6c0cdb5e ("net: bridge: reject
DSA-enabled master netdevices as bridge members"). This would also
require a bridge to be set-up

	- enhancing the iproute2 command and backing kernel code in order to
allow defining that a DSA slave device may be enslaved into a specific
DSA master, similarly to how you currently enslave a device into a
bridge, you could "enslave" a DSA slave to a DSA master with something
that could look like this:

	ip link set dev sw0p0 master eth0	# Associate port 0 with eth0
	ip link set dev sw0p1 master eth1	# Associate port 1 with eth1

To date, this may be the best way to do what we want here, rather than
use the iflink which is a bit re-purposing something that is not exactly
meant for that.

2) With Broadcom Ethernet switches there has been historically few
designs that allowed the following:

- 6 port(s) switches: port 5 was the CPU port, always and supports
tagging (EthType + 4bytes Broadcom tag). This is the 5325, 5365 class of
switches, they are nearly 20 years old now.

- 9 port(s) switches: both port 5 and port 8 could be defined as In-band
Managemement Port(s) (IMP) and port 5 is IMP1 and port 8 is IMP0 by
default, preference is to use IMP0. Tagging is only supported on those
two ports. These are the 5395, 53125 and similar switches. Port 5 is
typically meant to be connected to a WAN interface where it might be
necessary to run some specific management protocol like 802.1x and such
that would require a managed switch to assist with those tasks. Port 5
can do most of what port 8 does, except when it comes to classification
and specific remapping rules, that limitation is carried forward with
all switches described below.

- 9 port(s) switches: port 5, 7 or 8 support tagging, with port 5 and 8
being possible management ports. Tagging is permitted on port 7 to
provide in-band information about packets (e.g.: classification ID, QoS,
etc.) to an "accelerator" (whatever it is), or a MoCA interface behind
port 7. This is the BCM5301X class, the NorthStar Plus (58xxx), and the
BCM7445 switches. Tagging can be enabled on RX, or TX, or both.

- 9 port(s) switches: all ports support tagging, with RX only, TX only,
or both directions supporting tagging. Again, port 8 remains the default
and preferred management port. This is the BCM7278 class of switches.

What needs to be considered here is that while multiple CPU ports may be
defined, if say, both port 8 and port 5 are defined, it is preferable to
continue using port 8 as the default management port because it is the
most capable, therefore having a switch driver callback that allows us
to elect the most suitable CPU/management port might be a good idea. If
other switches treat all CPU ports equal, no need to provide that callback.

3) On the BCM7278 system we have 3 external ports wired, 1 internal port
to an audio/video streaming accelerator and 2 ports wired to Ethernet
MACs, on port 8 and port 5, an ascii diagram looks like this:

-------------------	-------------------
|SYSTEMPORT Lite 0|	|SYSTEMPORT Lite 1|
-------------------	-------------------
	|			|
	|			|
-------------------------------------------------
| 	Port 8			Port 5		|
|						|     ----------------
|					Port 7	|-----| A/V streaming|
|						|     ----------------
| Port 0   Port 1   Port 2			|
------------------------------------------------|
   GPHY    RGMII_1  RGMII_2

GPHY is an integrated Gigabit PHY, RGMII_1 and 2 connect to external
MII/RevMII/GMII/RGMII external PHYs.

The Device Tree for that system declares both CPU ports by providing a
phandle to the respective Ethernet MAC controllers. Now, depending on
the kernel version though, you may have different behaviors:

4.9 is our downstream production kernel ATM and on such a system you have:

DSA master:
eth0 (port 8)

DSA slaves:
gphy (port 0)
rgmii_1 (port 1)
rgmii_2 (port 2)
asp (port 7)
wifi (port 5)

Standard interface:
eth1 (port 5)

And here you should be like: hold on Florian, you have two interfaces
that each represent one side of the pipe (wifi, eth1), is not that
counter to the very DSA principles?

On an upstream kernel though, eth0 is still present, but eth1, because
it is connected to port 5 and thus has a lower number, gets chosen as
the DSA master, and then the "wifi" interface is not created at all. all
of that is expeccted.

Now, the 4.9 kernel behavior actually works just fine because eth1 is
not a special interface, so no tagging is expected, and "wifi", although
it supports DSA tagging, represents another side of the CPU/host network
stack, so you never have to inject frames into the switch, because you
can use eth1 to do that and let MAC learning do its job to forward to
the correct port of the switch.

Likewise, for a frame ingressing port 0 for a MAC address that is behind
port 5 that works too. The "wifi" interface here acts as a control
interface that allows us to have a configuration end-point for port
number 5.

The typical set-up we have involves two bridge devices:

br-lan spans port 0, port 1, port 2, port 7 and port 5 and takes care of
putting all of these ports in the same broadcast domain

br-wifi spans eth1 and another device, e.g: wlan0 and takes care of
bridging LAN to WLAN

Now, let's say your use case involves doubling the bandwidth for
routing/NAT and you have two CPU ports for that purpose. You could use
exactly that same set-up as described, and create a LAN bridge that does
not span the switch port to which your second Ethernet MAC is connected
to. Leave that WAN port as a standalone DSA device. Although you do need
a way to indicate somehow that port X connects to Ethernet MAC Y, which
Device Tree already provides.

Giving configuration control such that you can arbitrarily assign DSA
slaves to a given DSA master is fine, but what problems does it
potentially creates?
-- 
Florian
