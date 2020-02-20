Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E275D165EA8
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 14:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgBTNXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 08:23:32 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:31769 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBTNXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 08:23:32 -0500
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 7TwgoriN7My57BUVgB5+avIMCncJZwdrta0zNK4ltaNu5itWDl/gXEFyYtw+6uglAQhClciWF+
 uV8W9oY03+1vC7x6j1HCOHQfl9f2PiE80Y28ml6NbVB6vlUXV3D+u8xicD9r+cYWkyXlFJCn/q
 BD2O38CSIq0ZnkxNNtH2aco2AjvF7iafj8MjEf73/yvnwpigzOi72LlZE6HU0iRGqZ/dTRyzwD
 B7GhGDTIncX2GxMJBaB951trDBsiSY1lELDQMFISua3LLl02v90G2DDRtsDZMVwPSlFW4u10uP
 voE=
X-IronPort-AV: E=Sophos;i="5.70,464,1574146800"; 
   d="scan'208";a="66507200"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Feb 2020 06:23:31 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 20 Feb 2020 06:23:38 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 20 Feb 2020 06:23:30 -0700
Date:   Thu, 20 Feb 2020 14:23:29 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: Workaround to allow traffic
 to CPU in standalone mode
Message-ID: <20200220132329.43s6tq3xsoo7htuz@lx-anielsen.microsemi.net>
References: <20200217150058.5586-1-olteanv@gmail.com>
 <20200218113159.qiema7jj2b3wq5bb@lx-anielsen.microsemi.net>
 <CA+h21hpAowv50TayymgbHXY-d5GZABK_rq+Z3aw3fngLUaEFSQ@mail.gmail.com>
 <20200218140111.GB10541@lunn.ch>
 <20200219101739.65ucq6a4dmlfgfki@lx-anielsen.microsemi.net>
 <CA+h21hp5NQNJJ5agMPAZ+edaZ+ouSjTJ8DypYR5Htx3ZT5iSYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+h21hp5NQNJJ5agMPAZ+edaZ+ouSjTJ8DypYR5Htx3ZT5iSYA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 19.02.2020 16:05, Vladimir Oltean wrote:
>On Wed, 19 Feb 2020 at 12:17, Allan W. Nielsen
><allan.nielsen@microchip.com> wrote:
>>
>> With Ocelot we do not see this spamming - and I still do not understand
>> why this is seen with Felix.
>>
>
>I should have watched my words.
>When doing what all the other DSA switches do, which is enabling a
>bulk forwarding path between the front-panel ports and the CPU, the
>Ocelot switch core is more susceptible to doing more software
>processing work than other devices in its class, for the same end
>effect of dropping packets that the CPU is not interested in (say an
>unknown unicast MAC that is not present in the switch FDB nor in the
>DSA master's RX filter). In such a scenario, any other DSA system
>would have the host port drop these packets in hardware, by virtue of
>the unknown unicast MAC not being being present RX filter. With
>Ocelot, this mechanism that prevents software work being done for
>dropping is subverted. So to avoid this design limitation, the Ocelot
>core does not enable a bulk forwarding path between the front-panel
>ports and the CPU.
>
>Hope this is clearer.

Horatiu and I have looked further into this, done a few experiments, and
discussed with the HW engineers who have a more detailed version of how
the chips are working and how Ocelot and Felix differs.

Here are our findings:

- The most significant bit in the PGID table is "special" as it is a
   CPU-copy bit.
- This bit is not being used in the source filtering! This means that
   your original patch can be applied without breaking Ocelot (the
   uninitialized cpu field must be fixed though).
   - Still I do not think we should do this as it is not the root-casuse
- In Felix we have 2 ways to get frames to the CPU, in Ocelot we have 1
   (Ocelot also has two if it uses an NPI port, but it does not do that
   in the current driver).
   - In Felix you can get frames to the CPU by either using the CPU port
     (port 6), or by using the NPI port (which can be any in the range of
     0-5).
     - But you should only use the CPU port, and not the NPI port
       directly. Using the NPI port directly will cause the two targets
       to behave differently, and this is not what we do when testing all
       the use-cases on the switch.
   - In Ocelot you can only get frames to the CPU by using the CPU port
     (port 11).

Due to this, I very much think you need to fix this, such that Felix
always port 6 to reach the CPU (with the exception of writing
QSYS_EXT_CPU_CFG where you "connect" the CPU queue/port to the NPI
port).

If you do this change, then the Ocelot and Felix should start to work in
the same way.

Then, if you want the CPU to be part of the unicast flooding (this is
where this discussion started), then you should add the CPU port to the
PGID entry pointed at in ANA:ANA:FLOODING:FLD_UNICAST. This should be
done for Felix and not for Ocelot.

If you want the analyser (where the MAC table sits), to "learn" the CPU
MAC (which is needed if you do not want to have the CPU mac as a static
entry in the MAC-table), then you need to set the 'src-port' to 6 (if it
is Ocelot then it will be 11) in the IFH:

anielsen@lx-anielsen ~ $ ef hex ifh-oc1 help
ifh-oc1          Injection Frame Header for Ocelot1

Specify the ifh-oc1 header by using one or more of the following fields:
- Name ------------ offset:width --- Description --------------------------
   bypass              +  0:  1  Skip analyzer processing
   b1-rew-mac          +  1:  1  Replace SMAC address
   b1-rew-op           +  2:  9  Rewriter operation command
   b0-masq             +  1:  1  Enable masquerading
   b0-masq-port        +  2:  4  Masquerading port
   rew-val             + 11: 32  Receive time stamp
   res1                + 43: 17  Reserved
   dest                + 60: 12  Destination set for the frame. Dest[11] is the CPU
   res2                + 72:  9  Reserved
   src-port            + 81:  4  The port number where the frame was injected (0-12)  <------------------- THIS FIELD
   res3                + 85:  2  Reserved
   trfm-timer          + 87:  4  Timer for periodic transmissions (1..8). If zero then normal injection
   res4                + 91:  6  Reserved
   dp                  + 97:  1  Drop precedence level after policing
   pop-cnt             + 98:  2  Number of VLAN tags that must be popped
   cpuq                +100:  8  CPU extraction queue mask
   qos-class           +108:  3  Classified QoS class
   tag-type            +111:  1  Tag information's associated Tag Protocol Identifier (TPID)
   pcp                 +112:  3  Classified PCP
   dei                 +115:  1  Classified DEI
   vid                 +116: 12  Classified VID


/Allan

