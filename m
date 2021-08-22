Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85ADA3F3E42
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 09:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhHVHUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 03:20:05 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:57085 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230403AbhHVHUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 03:20:05 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 465E4580B2F;
        Sun, 22 Aug 2021 03:19:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 22 Aug 2021 03:19:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=qshXaL
        l3eCR6CTjOxib6q3IxHsv5hzHsOnRqrLEr/QY=; b=SfhZadEnW6pIE9BsRP2XK7
        vnB0nqB/Owip6Rd325QxpTJ2BOwrDnS+8lGArcjyBqoC2B/jH7vlJ9KTFkZKZnI+
        PXxzgK4ht5gpjOy6OZ/fDkruUxavRwCOx24XtXO85gVXpvIk1TvlYirEXTwPrAVc
        xS8P4qehBgSH3WJQ6B11uQeANvAmeE7TAf1m4ekxQq4KqNEvremnfiA9BLEP9dRb
        KlSKy9xjZ8kixMew+Tz884EN/oB8tDs0u+i5ULuCrUTSKXHnH6W4HkNA6k4A/PlW
        vOpdP8u4qtbUfzDzPph3/25Nikga65qoWcaQYvU6fatxAa0jchOAf/mA/ktORdmQ
        ==
X-ME-Sender: <xms:d_ohYbh-ojvknE10OsYhY-8Ys3fkcqVzKKStQk102z8eD_rwKVx3hw>
    <xme:d_ohYYBgnwtfwYzbh-jiSmvamTZaUzi6PLE9i0IODMXGvEzXXJSMMSlmoqRirFVue
    5H3rUNCaD2WhmM>
X-ME-Received: <xmr:d_ohYbFu7xCOBp_6xucpWYt3SdTaGaROkCGfccF8Yz8Dpce_hBqXbiBtps0Hnn0FWS7bda_R-kkeeX9kEA3p8ot6MKZKfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtvddgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:d_ohYYSTdCFy1YtH8S6T8qgCWW0SOjjrM6IrbwcuQpxcoIWGQPqIkw>
    <xmx:d_ohYYwrH63Ts5nfb9e1_IdmvBaavz-_2iZZD1lSmK1_t048y9cEXw>
    <xmx:d_ohYe7uW8WN4KMknhvBXdd8mZeNb-FRa6lmxoQGuAsK7fbChDEs0w>
    <xmx:fPohYeQ5duLfnp5MzWfEBuPtZ0oI2Fge9l3_GBQ8fat3pZIFE2iHKQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 22 Aug 2021 03:19:18 -0400 (EDT)
Date:   Sun, 22 Aug 2021 10:19:14 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v2 net-next 0/5] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
Message-ID: <YSH6ckM65582PB3P@shredder>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <YR9y2nwQWtGTumIS@shredder>
 <20210820104948.vcnomur33fhvcmas@skbuf>
 <YR/UI/SrR9R/8TAt@shredder>
 <20210821190914.dkrjtcbn277m67bk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210821190914.dkrjtcbn277m67bk@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 21, 2021 at 10:09:14PM +0300, Vladimir Oltean wrote:
> On Fri, Aug 20, 2021 at 07:11:15PM +0300, Ido Schimmel wrote:
> > On Fri, Aug 20, 2021 at 01:49:48PM +0300, Vladimir Oltean wrote:
> > > On Fri, Aug 20, 2021 at 12:16:10PM +0300, Ido Schimmel wrote:
> > > > On Thu, Aug 19, 2021 at 07:07:18PM +0300, Vladimir Oltean wrote:
> > > > > Problem statement:
> > > > >
> > > > > Any time a driver needs to create a private association between a bridge
> > > > > upper interface and use that association within its
> > > > > SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
> > > > > entries deleted by the bridge when the port leaves. The issue is that
> > > > > all switchdev drivers schedule a work item to have sleepable context,
> > > > > and that work item can be actually scheduled after the port has left the
> > > > > bridge, which means the association might have already been broken by
> > > > > the time the scheduled FDB work item attempts to use it.
> > > >
> > > > This is handled in mlxsw by telling the device to flush the FDB entries
> > > > pointing to the {port, FID} when the VLAN is deleted (synchronously).
> > > 
> > > If you have FDB entries pointing to bridge ports that are foreign
> > > interfaces and you offload them, do you catch the VLAN deletion on the
> > > foreign port and flush your entries towards it at that time?
> > 
> > Yes, that's how VXLAN offload works. VLAN addition is used to determine
> > the mapping between VNI and VLAN.
> 
> I was only able to follow as far as:
> 
> mlxsw_sp_switchdev_blocking_event
> -> mlxsw_sp_switchdev_handle_vxlan_obj_del
>    -> mlxsw_sp_switchdev_vxlan_vlans_del
>       -> mlxsw_sp_switchdev_vxlan_vlan_del
>          -> ??? where are the FDB entries flushed?

 mlxsw_sp_switchdev_blocking_event
 -> mlxsw_sp_switchdev_handle_vxlan_obj_del
    -> mlxsw_sp_switchdev_vxlan_vlans_del
       -> mlxsw_sp_switchdev_vxlan_vlan_del
          -> mlxsw_sp_bridge_vxlan_leave
	     -> mlxsw_sp_nve_fid_disable
	        -> mlxsw_sp_nve_fdb_flush_by_fid

> 
> I was expecting to see something along the lines of
> 
> mlxsw_sp_switchdev_blocking_event
> -> mlxsw_sp_port_vlans_del
>    -> mlxsw_sp_bridge_port_vlan_del
>       -> mlxsw_sp_port_vlan_bridge_leave
>          -> mlxsw_sp_bridge_port_fdb_flush
> 
> but that is exactly on the other branch of the "if (netif_is_vxlan(dev))"
> condition (and also, mlxsw_sp_bridge_port_fdb_flush flushes an externally-facing
> port, not really what I needed to know, see below).
> 
> Anyway, it also seems to me that we are referring to slightly different
> things by "foreign" interfaces. To me, a "foreign" interface is one
> towards which there is no hardware data path. Like for example if you
> have a mlxsw port in a plain L2 bridge with an Intel card. The data path
> is the CPU and that was my question: do you track FDB entries towards
> those interfaces (implicitly: towards the CPU)? You've answered about
> VXLAN, which is quite not "foreign" in the sense I am thinking about,
> because mlxsw does have a hardware data path towards a VXLAN interface
> (as you've mentioned, it associates a VID with each VNI).
> 
> I've been searching through the mlxsw driver and I don't see that this
> is being done, so I'm guessing you might wonder/ask why you would want
> to do that in the first place. If you bridge a mlxsw port with an Intel
> card, then (from another thread where you've said that mlxsw always
> injects control packets where hardware learning is not performed) my
> guess is that the MAC addresses learned on the Intel bridge port will
> never be learned on the mlxsw device. So every packet that ingresses the
> mlxsw and must egress the Intel card will reach the CPU through flooding
> (and will consequently be flooded in the entire broadcast domain of the
> mlxsw side of the bridge). Right?

I can see how this use case makes sense on systems where the difference
in performance between the ASIC and the CPU is not huge, but it doesn't
make much sense with Spectrum and I have yet to get requests to support
it (might change). Keep in mind that Spectrum is able to forward several
Bpps with a switching capacity of several Tbps. It is usually connected
to a weak CPU (e.g., low-end ARM, Intel Atom) through a PCI bus with a
bandwidth of several Gbps. There is usually one "Intel card" on such
systems which is connected to the management network that is separated
from the data plane network.

If we were to support it, FDB entries towards "foreign" interfaces would
be programmed to trap packets to the CPU. For now, for correctness /
rigor purposes, I would prefer simply returning an error / warning via
extack when such topologies are configured.
