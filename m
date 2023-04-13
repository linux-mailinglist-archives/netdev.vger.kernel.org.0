Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08566E1265
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjDMQfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDMQf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:35:28 -0400
Received: from h2.cmg1.smtp.forpsi.com (h2.cmg1.smtp.forpsi.com [81.2.195.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D56212C
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 09:35:26 -0700 (PDT)
Received: from lenoch ([91.218.190.200])
        by cmgsmtp with ESMTPSA
        id mzuspFe6lPm6CmzuupKtzp; Thu, 13 Apr 2023 18:35:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681403725; bh=gHenQshbY0u2f0pxY6xksdItPVfGpGXcJjifEKf5Dzw=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=hdZuTF737iqibSDphsTKK3QTE0ZIiHvw/ueRmlQNoj/Vs7esWLI1ArFMxcQA4DCXY
         tKMS0I1HvEubMlRv5f+EZoLKtV69P4LIYyW2sRAc869I+CV2uBZdO5Gb7/RxY/ykCX
         lqKnWPzjM18abuhxt1TMeixaCyQFQqJVhhGqqUHkLjjSTek7yN24JAtAtYGowKAl4r
         b1JiKvhRur0JPAbmtOCDdkHKa8f8IKngp3YnLfWdbz6gcix9muBXmRQKnXmiDNpOJs
         FfRR3IlDFxpYWIQ7jh0MP/2oDIqmC8jkw+wspvxITje2AF8CQcdfEc6zofKZyM6RaN
         A09rrQiU2VkyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681403725; bh=gHenQshbY0u2f0pxY6xksdItPVfGpGXcJjifEKf5Dzw=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=hdZuTF737iqibSDphsTKK3QTE0ZIiHvw/ueRmlQNoj/Vs7esWLI1ArFMxcQA4DCXY
         tKMS0I1HvEubMlRv5f+EZoLKtV69P4LIYyW2sRAc869I+CV2uBZdO5Gb7/RxY/ykCX
         lqKnWPzjM18abuhxt1TMeixaCyQFQqJVhhGqqUHkLjjSTek7yN24JAtAtYGowKAl4r
         b1JiKvhRur0JPAbmtOCDdkHKa8f8IKngp3YnLfWdbz6gcix9muBXmRQKnXmiDNpOJs
         FfRR3IlDFxpYWIQ7jh0MP/2oDIqmC8jkw+wspvxITje2AF8CQcdfEc6zofKZyM6RaN
         A09rrQiU2VkyA==
Date:   Thu, 13 Apr 2023 18:35:22 +0200
From:   Ladislav Michl <oss-lists@triops.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH 0/3] staging: octeon: Convert to use phylink
Message-ID: <ZDgvSoT/vdJeI0FS@lenoch>
References: <ZDgNexVTEfyGo77d@lenoch>
 <b70d9361-c689-4837-bc9d-8e800cda380c@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b70d9361-c689-4837-bc9d-8e800cda380c@lunn.ch>
X-CMAE-Envelope: MS4wfHsZGoDGjiBpBIGamKWRNqQtisNQIy98z7M13vI/Jv43QfqnQ4evFOvl0Uo7XuvXGVrCqRJPdLL3S+nRri9Sbyi5rcOkmZTGmAYXvS++pmLo89vSE0Yp
 bjBQUFs7NB078hP7EYaWCwwRGmXWifeyirvkFLCD0Iiro6MS0fFT0BBMFgIzRaVX8pyDvvjioCvYb6G6uGL6cX5KOqHAyqHSqxhaotOVq7e34SO9mE+j+cm5
 UVDkXlblL0skvOTedmJ95yEia5mRJXDhziIJvaUE0kfVEsuXU5ufyssIrBC8p7AWpAO2R1/2SPdyPduBgvKp/A==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, Apr 13, 2023 at 05:45:13PM +0200, Andrew Lunn wrote:
> Hi Ladislav
> 
> For phylink questions, it is a good idea to Cc: the phylink
> Maintainer. And for general PHY problems, Cc: the phy Maintainers.
> 
> On Thu, Apr 13, 2023 at 04:11:07PM +0200, Ladislav Michl wrote:
> > The purpose of this patches is to provide support for SFP cage to
> > Octeon ethernet driver. This is tested with following DT snippet:
> > 
> > 	smi0: mdio@1180000001800 {
> > 		compatible = "cavium,octeon-3860-mdio";
> > 		#address-cells = <1>;
> > 		#size-cells = <0>;
> > 		reg = <0x11800 0x00001800 0x0 0x40>;
> > 
> > 		/* QSGMII PHY */
> > 		phy0: ethernet-phy@0 {
> > 			compatible = "marvell,88e154", "ethernet-phy-ieee802.3-c22";
> 
> Please don't use a compatible for the specific PHY. In fact,
> compatibles are only used for things which are not PHYs, like Ethernet
> switches. phylib reads the ID registers of the PHY and uses them to
> load the correct PHY driver.
> 
> Also, C22 is the default, so you don't need that either.

Thanks, it works equally well with compatible removed.

> > 			reg = <0>;
> > 			interrupt-parent = <&gpio>;
> > 			interrupts = <6 IRQ_TYPE_LEVEL_LOW>;
> > 			marvell,reg-init =
> > 			  <0xff 24 0 0x2800>, <0xff 23 0 0x2001>, /* errata 3.1.1 - PHY Initialization #1 */
> > 			  <0 29 0 3>, <0 30 0 2>, <0 29 0 0>,	  /* errata 3.1.2 - PHY Initialization #2 */
> 
> Please add C code to deal with these erratas in the marvell PHY
> driver.

I need to dig into 4.9 ventor (and custom) tree for them. Will do later.

> > 			  <4 26 0 0x2>, 			  /* prekrizeni RX a TX QSGMII sbernice */
> > 			  <4 0 0x1000 0x1000>, 			  /* Q_ANEG workaround: P4R0B12 = 1 */
> > 			  <3 16 0 0x1117>;			  /* nastavení LED: G=link+act, Y=1Gbit */
> > 		};
> 
> Comments are normally in English. The last one seems to be setting the
> LED. This is tolerated, but not ideal. It is not clear to me what the
> other two do.

I'm sorry for that. I took DT from local tree. It is not meant for upstream.

> > 	pip: pip@11800a0000000 {
> > 		compatible = "cavium,octeon-3860-pip";
> > 		#address-cells = <1>;
> > 		#size-cells = <0>;
> > 		reg = <0x11800 0xa0000000 0x0 0x2000>;
> > 
> > 		/* Interface 0 goes to SFP */
> > 		interface@0 {
> > 			compatible = "cavium,octeon-3860-pip-interface";
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 			reg = <0>; /* interface */
> > 
> > 			ethernet@0 {
> > 				compatible = "cavium,octeon-3860-pip-port";
> > 				reg = <0>; /* Port */
> > 				local-mac-address = [ 00 00 00 00 00 00 ];
> > 				managed = "in-band-status";
> > 				phy-connection-type = "1000base-x";
> > 				sfp = <&sfp>;
> > 			};
> > 		};
> 
> > 		/* Interface 1 goes to eth1-eth4 and is QSGMII */
> > 		interface@1 {
> > 			compatible = "cavium,octeon-3860-pip-interface";
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 			reg = <1>; /* interface */
> > 
> > 			ethernet@0 {
> > 				compatible = "cavium,octeon-3860-pip-port";
> > 				reg = <0>; /* Port */
> > 				local-mac-address = [ 00 00 00 00 00 00 ];
> > 				phy-handle = <&phy0>;
> 
> If this is a QSGMII link, don't you need phy-mode property?

I would normally need that, but the way how this driver works makes it
optional.

Interfaces and their types are hardwired as well as various register address.
In the ideal world they should come from DT instead of from various
OCTEON_IS_MODEL(OCTEON_CNXXXX) ifdefery.

> > However testing revealed some glitches:
> > 1. driver previously returned -EPROBE_DEFER when no phy was attached.
> > Phylink stack does not seem to do so, which end up with:
> > 
> > Marvell PHY driver as a module:
> > octeon_ethernet 11800a0000000.pip eth0: configuring for inband/1000base-x link mode
> > octeon_ethernet 11800a0000000.pip eth1: PHY [8001180000001800:00] driver [Generic PHY] (irq=POLL)
> > octeon_ethernet 11800a0000000.pip eth1: configuring for phy/sgmii link mode
> > octeon_ethernet 11800a0000000.pip eth2: PHY [8001180000001800:01] driver [Generic PHY] (irq=POLL)
> > octeon_ethernet 11800a0000000.pip eth2: configuring for phy/sgmii link mode
> > octeon_ethernet 11800a0000000.pip eth0: switched to inband/sgmii link mode
> > octeon_ethernet 11800a0000000.pip eth0: PHY [i2c:sfp:16] driver [Marvell 88E1111] (irq=POLL)
> > octeon_ethernet 11800a0000000.pip eth3: PHY [8001180000001800:02] driver [Marvell 88E1340S] (irq=25)
> > octeon_ethernet 11800a0000000.pip eth3: configuring for phy/sgmii link mode
> > octeon_ethernet 11800a0000000.pip eth4: PHY [8001180000001800:03] driver [Marvell 88E1340S] (irq=25)
> > octeon_ethernet 11800a0000000.pip eth4: configuring for phy/sgmii link mode
> > octeon_ethernet 11800a0000000.pip eth1: Link is Up - 100Mbps/Full - flow control off
> > 
> > Marvell PHY driver built-in:
> > octeon_ethernet 11800a0000000.pip eth0: configuring for inband/1000base-x link mode
> > octeon_ethernet 11800a0000000.pip eth1: PHY [8001180000001800:00] driver [Marvell 88E1340S] (irq=25)
> > octeon_ethernet 11800a0000000.pip eth1: configuring for phy/sgmii link mode
> > Error: Driver 'Marvell 88E1101' is already registered, aborting...
> > libphy: Marvell 88E1101: Error -16 in registering driver
> > Error: Driver 'Marvell 88E1101' is already registered, aborting...
> > libphy: Marvell 88E1101: Error -16 in registering driver
> 
> This is very odd. But it could be a side effect of the
> compatible. Please try with it removed.

That does not make any difference.

> > 2. It is not possible to call phylink_create from ndo_init callcack as
> > it evetually calls sfp_bus_add_upstream which calls rtnl_lock().
> > As this lock is already taken, it just deadlocks. Is this an unsupported
> > scenario?
> 
> You normally call phylink_create() in _probe().

Ok, thank you.

>     Andrew
