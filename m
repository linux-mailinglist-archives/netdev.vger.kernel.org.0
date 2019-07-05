Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6348660682
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 15:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbfGENT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 09:19:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55782 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbfGENT1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 09:19:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nWbKLFHL+b+hFBq0825QJ0Fh8N/yT85HADdlrJpqwCQ=; b=3GP3RPKu7ZpFV7+cfZjE+vohUc
        Bex/2CpZC7Ala0E0eG4LZVetEHQEb/pfJHowfchWGZpWrdgaXwHw7j7iVZVhdnGDzqhJtwb9f/Eeo
        KLOig8uZwjFnSMbwTDYL8WRA0Mk0Pe6SrZtuUPnX5rsJaDgQ9SE3ZqwIKhT9NdjVOm9A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hjO7O-0001Br-S6; Fri, 05 Jul 2019 15:19:14 +0200
Date:   Fri, 5 Jul 2019 15:19:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
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
Message-ID: <20190705131914.GA4428@lunn.ch>
References: <20190621164940.GL31306@lunn.ch>
 <VI1PR04MB4880D8F90BBCD30BF8A69C9696E00@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <20190624115558.GA5690@piout.net>
 <20190624142625.GR31306@lunn.ch>
 <20190624152344.3bv46jjhhygo6zwl@lx-anielsen.microsemi.net>
 <20190624162431.GX31306@lunn.ch>
 <20190624182614.GC5690@piout.net>
 <CA+h21hqGtA5ou7a3wjSuHxa_4fXk4GZohTAxnUdfLZjV3nq5Eg@mail.gmail.com>
 <20190705044945.GA30115@lunn.ch>
 <VI1PR04MB4880DEA9D7836A68E0EE141396F50@VI1PR04MB4880.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB4880DEA9D7836A68E0EE141396F50@VI1PR04MB4880.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Nice discussion, again, but there's a missing point that has not been
> brought up yet.  We actually intend to support the following hardware
> configuration: a single PCI device consisting of the Microsemi's switch core
> and our DMA rings.
> The hardware supports this configuration into a single PCI function (PF), 
> with a unique PCI function id (0xe111), so that the same driver has access to 
> both switch registers and DMA rings connected to the CPU port.  This device
> would qualify  as a  switchdev device, and we can simply reuse the existing
> ocelot code for the switch core part.  The initial patch set was the first step in
> supporting the switch core on our platform, we just need to add the support
> for the DMA rings part, to make it a complete switchdev solution.

Hi Claudiu

It sound like in the end you will have a core library and then two
drivers wrapped around it, giving a pure switchdev device with polled
IO or DMA, and a DSA driver using a CPU port.

   Andrew
