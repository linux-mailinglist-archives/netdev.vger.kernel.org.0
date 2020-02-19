Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3596B16413C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 11:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgBSKLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 05:11:52 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:3001 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgBSKLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 05:11:52 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: bF6kP0kkxCb9FYkdTnOZYazlgoG4E86VNycJLpVOQO2eQ8U1VorAN4so/Eyjguz30XNVU+pWIm
 g1CO9a7OeyezuO5uzvxVKIwO4CjpJHbdjrrL6U4wRqyeDDRvx3BnPEyuYyjJNvzxq4LiqgJoSI
 A8nyf0tgt/IKkP8d0htYz5ntV7+DCtW2uEFKeLyZAKQnv35PqJNHBR/glZ7eyUpVKlnv6TwwML
 7lN/oyA00f0lwnKm4DmzPTzpCJ94ojL1Ce/hldoQcdfALkNl1+hpvO7bb7dQgGSpa1Aut/WN1N
 Xck=
X-IronPort-AV: E=Sophos;i="5.70,459,1574146800"; 
   d="scan'208";a="69022525"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Feb 2020 03:11:51 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 19 Feb 2020 03:11:45 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 19 Feb 2020 03:11:50 -0700
Date:   Wed, 19 Feb 2020 11:11:49 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: Workaround to allow traffic
 to CPU in standalone mode
Message-ID: <20200219101149.dq7jwhs6aypv43kf@lx-anielsen.microsemi.net>
References: <20200217150058.5586-1-olteanv@gmail.com>
 <20200218113159.qiema7jj2b3wq5bb@lx-anielsen.microsemi.net>
 <CA+h21hpAowv50TayymgbHXY-d5GZABK_rq+Z3aw3fngLUaEFSQ@mail.gmail.com>
 <20200218134850.yor4rs72b6cjfddz@lx-anielsen.microsemi.net>
 <CA+h21hpj+ARUZN5kkiponTCN_W1xaNDTpNB4u4xdiAGP5QqmfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+h21hpj+ARUZN5kkiponTCN_W1xaNDTpNB4u4xdiAGP5QqmfA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.02.2020 16:02, Vladimir Oltean wrote:
>The problem is on RX.
>
>> Is it with the broadcast ARP, or is it the following unicast packet?
>For the unicast packet.
When you have it working (in your setup, with your patch applied). Does
the ping reply packet have an IFH (DSA-tag)?

Or is it a frame on the NPI port without an IFH.

This is important as this will tell us of the frame was copied to CPU
and then redirected to the NPI port, or if it was plain forwarded.

I need to understand the problem better before trying to solve it.

>> >But if I do this:
>> >ip link add dev br0 type bridge
>> >ip link set dev swp0 master br0
>> >ip link set dev swp0 nomaster
>> >ping 192.168.1.2
>> >Then it works, because the code path from ocelot_bridge_stp_state_set
>> >that puts the CPU port in the forwarding mask of the other ports gets
>> >executed on the "bridge leave" action.
>> >The whole point is to have the same behavior at probe time as after
>> >removing the ports from the bridge.
>> This does sound like a bug, but I still do not agree in the solution.
>>
>> >The code with ocelot_mact_learn towards PGID_CPU for the MAC addresses
>> >of the switch port netdevices is all bypassed in Felix DSA. Even if it
>> >weren't, it isn't the best solution.
>> >On your switch, this test would probably work exactly because of that
>> >ocelot_mact_learn.
>> So I guess it is the reception of the unicast packet which is causing
>> problems.
>>
>> >But try to receive packets sent at any other unicast DMAC immediately
>> >after probe time, and you should see them in tcpdump but won't.
>> That is true - this is because we have no way of implementing promisc
>> mode, which still allow us to HW offload of the switching. We discussed
>> this before.
>>
>> Long story short, it sounds like you have an issue because the
>> Felix/DSA driver behave differently than the Ocelot. Could you try to do
>> your fix such that it only impact Felix and does not change the Ocelot
>> behavioral.
>
>It looks like you disagree with having BIT(ocelot->cpu) in PGID_SRC +
>p (the forwarding matrix) and just want to rely on whitelisting
>towards PGID_CPU*?
Yes.

When the port is not member of the bridge, it should act as a normal NIC
interface.

With this change frames are being forwarded even when the port is not
member of the bridge. This may be what you want in a DSA (or may not -
not sure), but it is not ideal in the Ocelot/switchdev solution as we
want to use the MAC-table to do the RX filtering.

>But you already have that logic present in your driver, it's just not
>called from a useful place for Felix.
>So it logically follows that we should remove these lines from
>ocelot_bridge_stp_state_set, no?
>
>            } else {
>                    /* Only the CPU port, this is compatible with link
>                     * aggregation.
>                     */
>                    ocelot_write_rix(ocelot,
>                                     BIT(ocelot->cpu),
>                                     ANA_PGID_PGID, PGID_SRC + p);
This should not be removed. When the port is member of the bridge this
bit must be set. When it is removed it must be cleared again.

>*I admit that I have no idea why it works for you, and why the frames
>learned towards PGID_CPU are forwarded to the CPU _despite_
>BIT(ocelot->cpu) not being present in PGID_SRC + p.
I believe this is because we have the MAC address in the MAC table.

It seems that you want to use learning to forward frames to the CPU,
also in the case when the port is not a member of the bridge. I'm not
too keen on this, mainly because I'm not sure how well it will work. If
you are certain this is what you want for Felix then lets try find a way
to make it happend for Felix without chancing the behaivural for Ocelot.

An alternative solution would be to use the MAC-table for white listing
of unicast packets. But as I understand the thread this is not so easy
to do with DSA. Sorry, I do not know DSA very well, and was not able to
fully understand why. But this is as far as I know the only way to get
the proper RX filtering.

An other solution, is to skip the RX filtering, and when a port is not
member of a beidge set the 'ANA:PORT[0-11]:CPU_FWD_CFG.CPU_SRC_COPY_ENA'
bit. This will cause all fraems to be copied to the CPU. Again, we need
to find a way to do this which does not affect Ocelot.

/Allan

