Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9937B1711FE
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 09:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgB0IKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 03:10:40 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:57157 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727702AbgB0IKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 03:10:40 -0500
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
IronPort-SDR: YkRn6FLvTtEe9TBdfq/vmcjLF2UPe0ZhuTOsuSPzoPWohY5vXYBO6dCG7/FXokwS4tLqMSMHab
 JJnD1RTYl1N46PjyoRt/TuT5hCGLYhKqxRJ89MMbw44MxpEkQA6KDmiJEo1aF3edH17rrD8mXF
 hDPQpJzbG0Yhl/Vqsf9E0ggogvHYPzRTU7T8tEZDpXaLAIuBJcywzcWBZ1uu3P1+uFgWrApGBd
 AqDp40ZI9UR/kc7zYUZ3JTJCehRSeplB7Y+ItiSucFTwUHIM5Jz6rTAVE6PQJNPPYX51D/aDJj
 WiM=
X-IronPort-AV: E=Sophos;i="5.70,491,1574146800"; 
   d="scan'208";a="67213059"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Feb 2020 01:10:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Feb 2020 01:10:39 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 27 Feb 2020 01:10:39 -0700
Date:   Thu, 27 Feb 2020 09:10:38 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <horatiu.vultur@microchip.com>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <joergen.andreasen@microchip.com>, <claudiu.manoil@nxp.com>,
        <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <alexandru.marginean@nxp.com>, <xiaoliang.yang_1@nxp.com>,
        <yangbo.lu@nxp.com>, <po.liu@nxp.com>, <jiri@mellanox.com>,
        <idosch@idosch.org>, <kuba@kernel.org>
Subject: Re: [PATCH net-next 04/10] net: mscc: ocelot: return directly in
 ocelot_cls_flower_{replace,destroy}
Message-ID: <20200227081038.cqwgg4av6mucis7o@lx-anielsen.microsemi.net>
References: <20200224130831.25347-1-olteanv@gmail.com>
 <20200224130831.25347-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200224130831.25347-5-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.02.2020 15:08, Vladimir Oltean wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>There is no need to check the "ret" variable, one can just return the
>function result back to the caller.
>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>---
> drivers/net/ethernet/mscc/ocelot_flower.c | 13 ++-----------
> 1 file changed, 2 insertions(+), 11 deletions(-)
>
>diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
>index 698e9fee6b1a..8993dadf063c 100644
>--- a/drivers/net/ethernet/mscc/ocelot_flower.c
>+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
>@@ -192,11 +192,7 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
>                return ret;
>        }
>
>-       ret = ocelot_ace_rule_offload_add(ocelot, ace);
>-       if (ret)
>-               return ret;
>-
>-       return 0;
>+       return ocelot_ace_rule_offload_add(ocelot, ace);
> }
> EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
>
>@@ -204,16 +200,11 @@ int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
>                              struct flow_cls_offload *f, bool ingress)
> {
>        struct ocelot_ace_rule ace;
>-       int ret;
>
>        ace.prio = f->common.prio;
>        ace.id = f->cookie;
>
>-       ret = ocelot_ace_rule_offload_del(ocelot, &ace);
>-       if (ret)
>-               return ret;
>-
>-       return 0;
>+       return ocelot_ace_rule_offload_del(ocelot, &ace);
> }
> EXPORT_SYMBOL_GPL(ocelot_cls_flower_destroy);
>
>--
>2.17.1
>

Reviewed-by: Allan W. Nielsen <allan.nielsen@microchip.com>

