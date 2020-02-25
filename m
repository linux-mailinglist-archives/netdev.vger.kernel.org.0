Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8899C16C29E
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgBYNnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:43:20 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:33014 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729142AbgBYNnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:43:20 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: o7GN1qY3nB/lh21zNf6BRiar6Y97MVzeUz1ENWmHz18qRAec6iRnMM8TEPWJE1SqRC9/rcwGpW
 D5bDUyZwIj8RYlNnEx924s6N15jjm5TLmv2O40aToE96XHP7Y+sXYEA23cO2PPp+Oz7Qf7JL4K
 zfHGCPYBFwThk3e9vvW8FWlDcVZAu47r58c517cUuYR148JaWQbDeB6XxOIPsxgkmZGTLcyP5H
 MlxGJGGlCX4nD5A+pU2H0EEV3dBoknD6hitb16j7V8v9x4YEOcWSP1OtohQHh522L5fE65+ML0
 Ptk=
X-IronPort-AV: E=Sophos;i="5.70,484,1574146800"; 
   d="scan'208";a="65268709"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Feb 2020 06:43:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 25 Feb 2020 06:43:13 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 25 Feb 2020 06:43:13 -0700
Date:   Tue, 25 Feb 2020 14:43:16 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v2 net-next 0/2] Allow unknown unicast traffic to CPU for
 Felix DSA
Message-ID: <20200225134316.yoy5hqlhkmt6ctz4@lx-anielsen.microsemi.net>
References: <20200224213458.32451-1-olteanv@gmail.com>
 <20200225130223.kb7jg7u2kgjjrlpo@lx-anielsen.microsemi.net>
 <CA+h21hp41WXXTLZ0L2rwT5b1gMeL5YFBpNpCZMh7d9eWZpmaqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+h21hp41WXXTLZ0L2rwT5b1gMeL5YFBpNpCZMh7d9eWZpmaqw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.02.2020 15:08, Vladimir Oltean wrote:
>On Tue, 25 Feb 2020 at 15:02, Allan W. Nielsen
><allan.nielsen@microchip.com> wrote:
>>
>> On 24.02.2020 23:34, Vladimir Oltean wrote:
>> >From: Vladimir Oltean <vladimir.oltean@nxp.com>
>> >
>> >This is the continuation of the previous "[PATCH net-next] net: mscc:
>> >ocelot: Workaround to allow traffic to CPU in standalone mode":
>> >
>> >https://www.spinics.net/lists/netdev/msg631067.html
>> >
>> >Following the feedback received from Allan Nielsen, the Ocelot and Felix
>> >drivers were made to use the CPU port module in the same way (patch 1),
>> >and Felix was made to additionally allow unknown unicast frames towards
>> >the CPU port module (patch 2).
>> >
>> >Vladimir Oltean (2):
>> >  net: mscc: ocelot: eliminate confusion between CPU and NPI port
>> >  net: dsa: felix: Allow unknown unicast traffic towards the CPU port
>> >    module
>> >
>> > drivers/net/dsa/ocelot/felix.c           | 16 ++++--
>> > drivers/net/ethernet/mscc/ocelot.c       | 62 +++++++++++++---------
>> > drivers/net/ethernet/mscc/ocelot.h       | 10 ----
>> > drivers/net/ethernet/mscc/ocelot_board.c |  5 +-
>> > include/soc/mscc/ocelot.h                | 67 ++++++++++++++++++++++--
>> > net/dsa/tag_ocelot.c                     |  3 +-
>> > 6 files changed, 117 insertions(+), 46 deletions(-)
>> Did this fix you original issue with the spamming of the CPU?
>No, the entire handling of unknown unicast packets still leaves a lot
>to be desired, but at least now the CPU gets those frames, which is
>better than it not getting them.
>For one thing, an unknown unicast packet received by a standalone
>Felix port will still consume CPU cycles dropping it, whereas the same
>thing cannot be said for a different DSA switch setup, say a sja1105
>switch inheriting the MAC address from the DSA master, because the DSA
>master drops that.
>Secondly, even traffic that the CPU _intends_ to terminate remains
>"unknown" from the switch's perspective, due to the
>no-learning-from-injected-traffic issue. So that traffic is still
>going to be flooded, potentially to unwanted ports as well.
Strange, it does sounds like something is not right, but it is really
hard to debug without having the HW.

If we find the time, then Horatiu and I discuss doing a DSA driver for
the VSC7511 (4 port Ocelot without the MIPS CPU). That target should
behave exactly as Felix.

/Allan

