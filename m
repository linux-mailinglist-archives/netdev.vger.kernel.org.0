Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9316F16414F
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 11:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgBSKRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 05:17:51 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:22318 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgBSKRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 05:17:51 -0500
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
IronPort-SDR: BwKLTfREsDGPQ2O8anVwbUt7AayfbgmtXbaXbyYJyveGrrIsRO4IAb41pam/FYGG39DNu6ykYN
 mBfOP1LR4SK3L7MXnnGYcNTE3LeL1JbbZc6HepWle3R16bU7N7jAzndUAYm3nug1NAklPQ6KcV
 GWeDzP7jWd/ecrIhncCwsgPxAFHuOLscfQm+ELJfDR77ZtDSQ4DSii2DpCmYpFcWQ3A/hRsyeR
 KUuTYJIGRli3hl68WsGB0f1Zx3VC41Om1G8bZZnruvlx9i+FtnXYgJBmVn7HvK/9rycnNc9bEp
 9rM=
X-IronPort-AV: E=Sophos;i="5.70,459,1574146800"; 
   d="scan'208";a="69023145"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Feb 2020 03:17:50 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 19 Feb 2020 03:17:34 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 19 Feb 2020 03:17:34 -0700
Date:   Wed, 19 Feb 2020 11:17:39 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "Joergen Andreasen" <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: Workaround to allow traffic
 to CPU in standalone mode
Message-ID: <20200219101739.65ucq6a4dmlfgfki@lx-anielsen.microsemi.net>
References: <20200217150058.5586-1-olteanv@gmail.com>
 <20200218113159.qiema7jj2b3wq5bb@lx-anielsen.microsemi.net>
 <CA+h21hpAowv50TayymgbHXY-d5GZABK_rq+Z3aw3fngLUaEFSQ@mail.gmail.com>
 <20200218140111.GB10541@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200218140111.GB10541@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.02.2020 15:01, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>On Tue, Feb 18, 2020 at 02:29:15PM +0200, Vladimir Oltean wrote:
>> Hi Allan,
>>
>> On Tue, 18 Feb 2020 at 13:32, Allan W. Nielsen
>> <allan.nielsen@microchip.com> wrote:
>> >
>> > On 17.02.2020 17:00, Vladimir Oltean wrote:
>> > >EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>> > >
>> > >From: Vladimir Oltean <vladimir.oltean@nxp.com>
>> > >
>> > >The Ocelot switches have what is, in my opinion, a design flaw: their
>> > >DSA header is in front of the Ethernet header, which means that they
>> > >subvert the DSA master's RX filter, which for all practical purposes,
>> > >either needs to be in promiscuous mode, or the OCELOT_TAG_PREFIX_LONG
>> > >needs to be used for extraction, which makes the switch add a fake DMAC
>> > >of ff:ff:ff:ff:ff:ff so that the DSA master accepts the frame.
>> > >
>> > >The issue with this design, of course, is that the CPU will be spammed
>> > >with frames that it doesn't want to respond to, and there isn't any
>> > >hardware offload in place by default to drop them.
>> > In the case of Ocelot, the NPI port is expected to be connected back to
>> > back to the CPU, meaning that it should not matter what DMAC is set.
>> >
>>
>> You are omitting the fact that the host Ethernet port has an RX filter
>> as well. By default it should drop frames that aren't broadcast or
>> aren't sent to a destination MAC equal to its configured MAC address.
>> Most DSA switches add their tag _after_ the Ethernet header. This
>> makes the DMAC and SMAC seen by the front-panel port of the switch be
>> the same as the DMAC and SMAC seen by the host port. Combined with the
>> fact that DSA sets up switch port MAC addresses to be inherited from
>> the host port, RX filtering 'just works'.
>
>It is a little bit more complex than that, but basically yes. If the
>slave interface is in promisc mode, the master interface is also made
>promisc. So as soon as you add a slave to a bridge, the master it set
>promisc. Also, if the slave has a different MAC address to the master,
>the MAC address is added to the masters RX filter.
Good to know. I assume this will mean that in the case of Felix+NXP cpu
the master interface is in promisc mode?

>If the DSA header is before the DMAC, you need promisc mode all the
>time. But i don't expect the CPU port to be spammed. The switch should
>only be forwarding frames to the CPU which the CPU is actually
>interested in.
With Ocelot we do not see this spamming - and I still do not understand
why this is seen with Felix.

It is the same core with process the frames, and decide which frames
should be copied to the CPU. The only difference is that in Ocelot the
CPU queue is connected to a frame-DMA, while in Felix it is a MAC-to-MAC
connection.

>> Be there 4 net devices: swp0, swp1, swp2, swp3.
>> At probe time, the following doesn't work on the Felix DSA driver:
>> ip addr add 192.168.1.1/24 dev swp0
>> ping 192.168.1.2
>
>That is expected to work.
>
>> But if I do this:
>> ip link add dev br0 type bridge
>> ip link set dev swp0 master br0
>> ip link set dev swp0 nomaster
>> ping 192.168.1.2
>> Then it works, because the code path from ocelot_bridge_stp_state_set
>> that puts the CPU port in the forwarding mask of the other ports gets
>> executed on the "bridge leave" action.
>
>It probably also works because when the port is added to the bridge,
>the bridge puts the port into promisc mode. That in term causes the
>master to be put into promisc mode.
>
>       Andrew

/Allan
