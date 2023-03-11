Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EB26B5F4B
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 18:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCKRpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 12:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjCKRpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 12:45:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763F41EBF4
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=P8spk824Nhe44bQqZ1slzLgZj/JIvgjB6T3wYUPRS3s=; b=Q2
        Rl8jMYEw+EVLgpx38fBXNhGBeKJvd0CCjXb7GhC9aB8Upa/VT13o4RtR6cw47byXmPHG+ngNIVGNy
        8mqZOP8GEDvA4TyBCZuPK/drww9bhh2Z4GELfEkSqGVevT93bTDBtyfBTRr/liv41Tg72zQzM9EOm
        sLKGrWkeWAMK2h0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pb3HB-0074fP-Kp; Sat, 11 Mar 2023 18:45:01 +0100
Date:   Sat, 11 Mar 2023 18:45:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parthiban.Veerasooran@microchip.com, allan.nielsen@microchip.com
Cc:     netdev@vger.kernel.org, Jan.Huber@microchip.com,
        Thorsten.Kummermehr@microchip.com
Subject: Re: RFC: Adding Microchip's LAN865x 10BASE-T1S MAC-PHY driver
 support to Linux
Message-ID: <76afad2d-33ab-4bfa-baf9-2f7a0a4aa134@lunn.ch>
References: <076fbcec-27e9-7dc2-14cb-4b0a9331b889@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <076fbcec-27e9-7dc2-14cb-4b0a9331b889@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Allan

It has been a long time since we talked, maybe 2019 at the Linux
Plumbers conference.... And then PTP discussions etc.

It seems like Sparx5 is going well, along with felix, seville, etc.

On Fri, Mar 10, 2023 at 11:13:23AM +0000, Parthiban.Veerasooran@microchip.com wrote:
> Hi All,
> 
> I would like to add Microchip's LAN865x 10BASE-T1S MAC-PHY driver 
> support to Linux kernel.
> (Product link: https://www.microchip.com/en-us/product/LAN8650)
> 
> The LAN8650 combines a Media Access Controller (MAC) and an Ethernet PHY 
> to access 10BASE‑T1S networks. The common standard Serial Peripheral 
> Interface (SPI) is used so that the transfer of Ethernet packets and 
> LAN8650 control/status commands are performed over a single, serial 
> interface.
> 
> Ethernet packets are segmented and transferred over the serial interface
> according to the OPEN Alliance 10BASE‑T1x MAC‑PHY Serial Interface 
> specification designed by TC6.
> (link: https://www.opensig.org/Automotive-Ethernet-Specifications/)
> The serial interface protocol can simultaneously transfer both transmit 
> and receive packets between the host and the LAN8650.
> 
> Basically the driver comprises of two parts. One part is to interface 
> with networking subsystem and SPI subsystem. The other part is a TC6 
> state machine which implements the Ethernet packets segmentation 
> according to OPEN Alliance 10BASE‑T1x MAC‑PHY Serial Interface 
> specification.
> 
> The idea behind the TC6 state machine implementation is to make it as a 
> generic library and platform independent. A set of API's provided by 
> this TC6 state machine library can be used by the 10BASE-T1x MAC-PHY 
> drivers to segment the Ethernet packets according to the OPEN Alliance 
> 10BASE‑T1x MAC‑PHY Serial Interface specification.
> 
> With the above information, kindly provide your valuable feedback on my 
> below queries.
> 
> Can we keep this TC6 state machine within the LAN865x driver or as a 
> separate generic library accessible for other 10BASE-T1x MAC-PHY drivers 
> as well?
> 
> If you recommend to have that as a separate generic library then could 
> you please advice on what is the best way to do that in kernel?

Microchip is getting more and more involved in mainline. Jakub
publishes some developers statistics for netdev:

https://lwn.net/Articles/918007/

It shows Microchip are near the top for code contributions. Which is
great. However, as a reviewer, i see the quality really varies. Given
how active Microchip is within Linux, the netdev community, and to
some extent Linux as a whole, expects a company like Microchip to
build up its internal resources to offer training and Mentoring to
mainline developers, rather than expect the community to do that
work. Does such a thing exist within Microchip? Could you point
Parthiban towards a mentor who can help guide the work adding generic
support for the OPEN Alliance 10BASE-T1x MAC-PHY Serial Interface and
the LAN8650/1 specific bits? If not, could Steen Hegelund or Horatiu
Vultur make some time available to be a mentor?

Thanks
	Andrew
