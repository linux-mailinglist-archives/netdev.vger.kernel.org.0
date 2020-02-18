Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4992D16275A
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 14:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgBRNs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 08:48:57 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:48244 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgBRNs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 08:48:57 -0500
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
IronPort-SDR: 7Y6b7oYd5NLMw/GIOQaq+3vxjz0ZUj7TlQdOBsVNhDiGQBL9vHF8yMLE6tmqtahI5cJe3aDJyI
 /XQiNLa2rYh1wQEukpAmokb0LWq1tpnubx2zSrv+X+OB8F3ZvJXmqTMXSioDtVHl0nwE6MTPv1
 LReRCwOcjoseE5d3u37kGtbeYCtAlii79X9qnCsEmp5p1RhRdtzs61wNjg3f5nbxoLA0oUabyj
 xf4UF6lBvm4jO7jitpQn7V8zAApaUaKMv5RFEeNnTSLgMU6LZf+RJYkbayIbPT/LNByYMVR3k4
 eN8=
X-IronPort-AV: E=Sophos;i="5.70,456,1574146800"; 
   d="scan'208";a="68903985"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Feb 2020 06:48:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 18 Feb 2020 06:48:46 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 18 Feb 2020 06:48:57 -0700
Date:   Tue, 18 Feb 2020 14:48:50 +0100
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
Message-ID: <20200218134850.yor4rs72b6cjfddz@lx-anielsen.microsemi.net>
References: <20200217150058.5586-1-olteanv@gmail.com>
 <20200218113159.qiema7jj2b3wq5bb@lx-anielsen.microsemi.net>
 <CA+h21hpAowv50TayymgbHXY-d5GZABK_rq+Z3aw3fngLUaEFSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+h21hpAowv50TayymgbHXY-d5GZABK_rq+Z3aw3fngLUaEFSQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.02.2020 14:29, Vladimir Oltean wrote:
>> >diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
>> >index 86d543ab1ab9..94d39ccea017 100644
>> >--- a/drivers/net/ethernet/mscc/ocelot.c
>> >+++ b/drivers/net/ethernet/mscc/ocelot.c
>> >@@ -2297,6 +2297,18 @@ void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
>> >                         enum ocelot_tag_prefix injection,
>> >                         enum ocelot_tag_prefix extraction)
>> > {
>> >+       int port;
>> >+
>> >+       for (port = 0; port < ocelot->num_phys_ports; port++) {
>> >+               /* Disable old CPU port and enable new one */
>> >+               ocelot_rmw_rix(ocelot, 0, BIT(ocelot->cpu),
>> >+                              ANA_PGID_PGID, PGID_SRC + port);
>> I do not understand why you have an "old" CPU. The ocelot->cpu field is
>> not initialized at this point (at least not in case of Ocelot).
>>
>> Are you trying to move the NPI port?
>>
>
>Yes, that's what this function does. It sets the NPI port. It should
>be able to work even if called multiple times (even though the felix
>and ocelot drivers both call it exactly one time).
>But I can (and will) remove/simplify the logic for the "old" CPU port.
>I had the patch formatted already, and I didn't want to change it
>because I was lazy to re-test after the changes.
>
>> >+               if (port == cpu)
>> >+                       continue;
>> >+               ocelot_rmw_rix(ocelot, BIT(cpu), BIT(cpu),
>> >+                              ANA_PGID_PGID, PGID_SRC + port);
>> So you want all ports to be able to forward traffic to your CPU port,
>> regardless of if these ports are member of a bridge...
>>
>
>Yes.
>
>> I have read through this several times, and I'm still not convinced I
>> understood it.
>>
>> Can you please provide a specific example of how things are being
>> forwarded (wrongly), and describe how you would like them to be
>> forwarded.
>
>Be there 4 net devices: swp0, swp1, swp2, swp3.
>At probe time, the following doesn't work on the Felix DSA driver:
>ip addr add 192.168.1.1/24 dev swp0
>ping 192.168.1.2
This does work with Ocelot, without your patch. I would like to
understand why this does not work in your case.

Is it in RX or TX you have the problem.

Is it with the broadcast ARP, or is it the following unicast packet?

>But if I do this:
>ip link add dev br0 type bridge
>ip link set dev swp0 master br0
>ip link set dev swp0 nomaster
>ping 192.168.1.2
>Then it works, because the code path from ocelot_bridge_stp_state_set
>that puts the CPU port in the forwarding mask of the other ports gets
>executed on the "bridge leave" action.
>The whole point is to have the same behavior at probe time as after
>removing the ports from the bridge.
This does sound like a bug, but I still do not agree in the solution.

>The code with ocelot_mact_learn towards PGID_CPU for the MAC addresses
>of the switch port netdevices is all bypassed in Felix DSA. Even if it
>weren't, it isn't the best solution.
>On your switch, this test would probably work exactly because of that
>ocelot_mact_learn.
So I guess it is the reception of the unicast packet which is causing
problems.

>But try to receive packets sent at any other unicast DMAC immediately
>after probe time, and you should see them in tcpdump but won't.
That is true - this is because we have no way of implementing promisc
mode, which still allow us to HW offload of the switching. We discussed
this before.

Long story short, it sounds like you have an issue because the
Felix/DSA driver behave differently than the Ocelot. Could you try to do
your fix such that it only impact Felix and does not change the Ocelot
behavioral.

/Allan

