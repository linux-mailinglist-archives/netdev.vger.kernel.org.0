Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B0A51038
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbfFXPXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:23:48 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:12728 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbfFXPXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:23:48 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.63,412,1557212400"; 
   d="scan'208";a="35622915"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jun 2019 08:23:47 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.87.152) by
 chn-vm-ex03.mchp-main.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Jun 2019 08:22:48 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 24 Jun 2019 08:22:48 -0700
Date:   Mon, 24 Jun 2019 17:23:45 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next 4/6] arm64: dts: fsl: ls1028a: Add Felix switch
 port DT node
Message-ID: <20190624152344.3bv46jjhhygo6zwl@lx-anielsen.microsemi.net>
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
 <1561131532-14860-5-git-send-email-claudiu.manoil@nxp.com>
 <20190621164940.GL31306@lunn.ch>
 <VI1PR04MB4880D8F90BBCD30BF8A69C9696E00@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <20190624115558.GA5690@piout.net>
 <20190624142625.GR31306@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190624142625.GR31306@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

The 06/24/2019 16:26, Andrew Lunn wrote:
> > > Yeah, there are 2 ethernet controller ports (managed by the enetc driver) 
> > > connected inside the SoC via SGMII links to 2 of the switch ports, one of
> > > these switch ports can be configured as CPU port (with follow-up patches).
> > > 
> > > This configuration may look prettier on DSA, but the main restriction here
> > > is that the entire functionality is provided by the ocelot driver which is a
> > > switchdev driver.  I don't think it would be a good idea to copy-paste code
> > > from ocelot to a separate dsa driver.
> > > 
> > 
> > We should probably make the ocelot driver a DSA driver then...
> An important part of DSA is being able to direct frames out specific
> ports when they ingress via the CPU port. Does the silicon support
> this? At the moment, i think it is using polled IO.

That is supported, it requires a bit of initial configuration of the Chip, but
nothing big (I believe this configuration is part of Claudiu's change-set).

But how do you envision this done?

- Let the existing SwitchDev driver and the DSA driver use a set of common
  functions.
- Convert the existing Ocelot driver from SwitchDev to DSA
- Fork (copy) the existing driver of Ocelot, and modify it as needed for the
  Felix driver

My guess is the first one, but I would like to understand what you have in mind.

BTW: The Ocelot switch does exist in an other (register compatible) version
without the MIPS CPU. That version would use a MAC-2-MAC connection to an
external CPU, and would fit the DSA model. And we have been considering how to
best represent that version in the kernel.

/Allan

