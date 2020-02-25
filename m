Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3420F16C44A
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 15:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbgBYOpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 09:45:47 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:41258 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbgBYOpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 09:45:47 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: dF0KAKprYYiLXRdqhhIhFStMvsNniMQSV0GDYRTUazs1QTeqoH1SzpWvrHVmUNJGRHZ/39nNjB
 HWX0cTVm8bEecBIf0h3wy1DWfzNHfuZ2HNT7Jua0DNnkNaQyFh89Rj/FovhxilxgJiCNfGT2gm
 WQPXRi6hwK2tf0EjLjc4jZVSp1mY84iaUy57cQbRyHXSaFyV+ODzm/9mfZPXQsgEJ7LbVGA090
 NAZCwoGH60E/SR16Ru4tZ3pWMzrGIyQXrEJuEhQNlKsmQMLosHuPWlNl70Y494gtPftzdXbOcI
 qvo=
X-IronPort-AV: E=Sophos;i="5.70,484,1574146800"; 
   d="scan'208";a="66655000"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Feb 2020 07:45:47 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 25 Feb 2020 07:45:45 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 25 Feb 2020 07:45:45 -0700
Date:   Tue, 25 Feb 2020 15:45:45 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <alexandre.belloni@bootlin.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <joergen.andreasen@microchip.com>,
        <allan.nielsen@microchip.com>, <claudiu.manoil@nxp.com>,
        <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <alexandru.marginean@nxp.com>, <xiaoliang.yang_1@nxp.com>,
        <yangbo.lu@nxp.com>, <po.liu@nxp.com>, <jiri@mellanox.com>,
        <idosch@idosch.org>, <kuba@kernel.org>
Subject: Re: [PATCH net-next 00/10] Wire up Ocelot tc-flower to Felix DSA
Message-ID: <20200225144545.3lriucp2igwd3kpb@soft-dev3.microsemi.net>
References: <20200224130831.25347-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200224130831.25347-1-olteanv@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/24/2020 15:08, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series is a proposal on how to wire up the tc-flower callbacks into
> DSA. The example taken is the Microchip Felix switch, whose core
> implementation is actually located in drivers/net/ethernet/mscc/.
> 
> The proposal is largely a compromise solution. The DSA middle layer
> handles just enough to get to the interesting stuff (FLOW_CLS_REPLACE,
> FLOW_CLS_DESTROY, FLOW_CLS_STATS), but also thin enough to let drivers
> decide what filter keys and actions they support without worrying that
> the DSA middle layer will grow exponentially. I am far from being an
> expert, so I am asking reviewers to please voice your opinion if you
> think it can be done differently, with better results.
> 
> The bulk of the work was actually refactoring the ocelot driver enough
> to allow the VCAP (Versatile Content-Aware Processor) code for vsc7514
> and the vsc9959 switch cores to live together.
> 
> Flow block offloads have not been tested yet, only filters attached to a
> single port. It might be as simple as replacing ocelot_ace_rule_create
> with something smarter, it might be more complicated, I haven't tried
> yet.
> 
> I should point out that the tc-matchall filter offload is not
> implemented in the same manner in current mainline. Florian has already
> went all the way down into exposing actual per-action callbacks,
> starting with port mirroring. Because currently only mirred is supported
> by this DSA mid layer, everything else will return -EOPNOTSUPP. So even
> though ocelot supports matchall (aka port-based) policers, we don't have
> a call path to call into them.  Personally I think that this is not
> going to scale for tc-matchall (there may be policers, traps, drops,
> VLAN retagging, etc etc), and that we should consider replacing the port
> mirroring callbacks in DSA with simple accessors to
> TC_CLSMATCHALL_REPLACE and TC_CLSMATCHALL_DESTROY, just like for flower.
> That means that drivers which currently implement the port mirroring
> callbacks will need to have some extra "if" conditions now, in order for
> them to call their port mirroring implementations.
> 
> Vladimir Oltean (9):
>   net: mscc: ocelot: simplify tc-flower offload structures
>   net: mscc: ocelot: replace "rule" and "ocelot_rule" variable names
>     with "ace"
>   net: mscc: ocelot: return directly in
>     ocelot_cls_flower_{replace,destroy}
>   net: mscc: ocelot: don't rely on preprocessor for vcap key/action
>     packing
>   net: mscc: ocelot: remove port_pcs_init indirection for VSC7514
>   net: mscc: ocelot: parameterize the vcap_is2 properties
>   net: dsa: Refactor matchall mirred action to separate function
>   net: dsa: Add bypass operations for the flower classifier-action
>     filter
>   net: dsa: felix: Wire up the ocelot cls_flower methods
> 
> Yangbo Lu (1):
>   net: mscc: ocelot: make ocelot_ace_rule support multiple ports
> 
>  drivers/net/dsa/ocelot/felix.c            |  31 ++
>  drivers/net/dsa/ocelot/felix.h            |   3 +
>  drivers/net/dsa/ocelot/felix_vsc9959.c    | 126 ++++++
>  drivers/net/ethernet/mscc/ocelot.c        |  20 +-
>  drivers/net/ethernet/mscc/ocelot_ace.c    | 472 +++++++++++-----------
>  drivers/net/ethernet/mscc/ocelot_ace.h    |  26 +-
>  drivers/net/ethernet/mscc/ocelot_board.c  | 151 +++++--
>  drivers/net/ethernet/mscc/ocelot_flower.c | 256 ++++--------
>  drivers/net/ethernet/mscc/ocelot_tc.c     |  22 +-
>  drivers/net/ethernet/mscc/ocelot_vcap.h   | 403 ------------------
>  include/net/dsa.h                         |   6 +
>  include/soc/mscc/ocelot.h                 |  20 +-
>  include/soc/mscc/ocelot_vcap.h            | 205 ++++++++++
>  net/dsa/slave.c                           | 128 ++++--
>  14 files changed, 954 insertions(+), 915 deletions(-)
>  delete mode 100644 drivers/net/ethernet/mscc/ocelot_vcap.h
>  create mode 100644 include/soc/mscc/ocelot_vcap.h
> 
> --
> 2.17.1
> 

Hi Vladimir,

From my point, it looks OK the changes to Ocelot.
Also I managed to run some tests and they are passing.

-- 
/Horatiu
