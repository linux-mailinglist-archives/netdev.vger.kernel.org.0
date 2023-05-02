Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23B06F3E3C
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 09:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbjEBHLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 03:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEBHLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 03:11:41 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20EF1FC2
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 00:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683011498; x=1714547498;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DJve1FIWXG0mHSXEP2qzMKssT+8J/9xfkr5oObJozfc=;
  b=pq+/WAPb2O1ojMJjjcHYtnzE1yKqVU0i+Sl6i5LQypYjL8C3zcbCv6Ar
   8LBVDlw9ZRoHlgPaCqhh5WkVtx7VnxC3mPusA1YNLRQGhi/F4TCHXJ0yE
   CtUZ8xpY7qepGMJ/zkz4NaSPgEf94D3DkZd98+XZeep5N3g5VuDqozm8n
   xnSdun3wotN4Ja28s18/wtSIMIzQwfD8irGYdQTBxyHGGtlfuCjGYiXqq
   Fnc9mh1NcZNCvVGeJeo/jPtQlhgOpz7ooiK9AksCHjO50a1kZ0KjRanm+
   L4XrOhIAx3O5tPs/ssrMUXzrvoJfFREb8uHWTpd8KP+Bddm8nAQU9p7QL
   w==;
X-IronPort-AV: E=Sophos;i="5.99,243,1677567600"; 
   d="scan'208";a="213206477"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 May 2023 00:11:36 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 2 May 2023 00:11:36 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 2 May 2023 00:11:36 -0700
Date:   Tue, 2 May 2023 09:11:35 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Ron Eggler <ron.eggler@mistywest.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: Unable to TX data on VSC8531
Message-ID: <20230502071135.bcxg5nip62m7wndb@soft-dev3-1>
References: <b0cdace8-5aa2-ce78-7cbf-4edf87dbc3a6@mistywest.com>
 <20230501064655.2ovbo3yhkym3zu57@soft-dev3-1>
 <2c2bade5-01d5-7065-13e6-56fcdbf92b5a@mistywest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <2c2bade5-01d5-7065-13e6-56fcdbf92b5a@mistywest.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 05/01/2023 13:34, Ron Eggler wrote:

Hi Ron,
> 
> Hi Horatiu,
> 
> [snip greetings]
> 
> > I've posted here previously about the bring up of two network interfaces
> > on an embedded platform that is using two the Microsemi VSC8531 PHYs.
> > (previous thread: issues to bring up two VSC8531 PHYs, Thanks to Heiner
> > Kallweit & Andrew Lunn).
> > I'm able to seemingly fully access & operate the network interfaces
> > through ifconfig (and the ip commands) and I set the ip address to match
> > my /24 network. However, while it looks like I can receive & see traffic
> > on the line with tcpdump, it appears like none of my frames can go out
> > in TX direction and hence entries in my arp table mostly remain
> > incomplete (and if there actually happens to be a complete entry,
> > sending anything to it doesn't seem to work and the TX counters in
> > ifconfig stay at 0. How can I further troubleshoot this? I have set the
> > phy-mode to rgmii-id in the device tree and have experimented with all
> > the TX_CLK delay register settings in the PHY but have failed to make
> > any progress.
> > Some of the VSC phys have this COMA mode, and then you need to pull
> > down a GPIO to take it out of this mode. I looked a little bit but I
> > didn't find anything like this for VSC8531 but maybe you can double
> > check this. But in that case both the RX and TX will not work.
> > Are there any errors seen in the registers 16 (0x10) or register 17
> > (0x11)?
> Good point rewgarding the COMA mode, I have not found anything like it.
> The RGMII connectivity should be pretty straight forward per the
> datasheet, TX0-TX4, TX_CLK, TX_CTL, RXD0-RXD4, RX_CLK & RX_CTL.
> Not sure if you've seen this in the subthread that is  ongoing with
> Andrew Lunn but as part of it, I did invoke the mii-tool and got a
> pretty printout of the PHY registers, see below:
> 
> # mii-tool -vv eth0
> Using SIOCGMIIPHY=0x8947
> eth0: negotiated 100baseTx-FD, link ok
>   registers for MII PHY 0:
>     1040 796d 0007 0572 01e1 45e1 0005 2801
>     0000 0300 4000 0000 0000 0000 0000 3000
>     9000 0000 0008 0000 0000 0000 3201 1000
>     0000 a020 0000 0000 802d 0021 0400 0000

Unfortunetly, I can't see anything obvious wrong with the registers.

>   product info: vendor 00:01:c1, model 23 rev 2
>   basic mode:   autonegotiation enabled
>   basic status: autonegotiation complete, link ok
>   capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
> 10baseT-FD 10baseT-HD
>   advertising:  100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD

Are you expecting to run at 100Mbit?

>   link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
> 10baseT-FD 10baseT-HD flow-control
> 
> Alternartively, the registers can be read with phytool also:
> 
> # phytool read eth0/0/0x10
> 0x9000
> # phytool read eth0/0/0x11
> 0000

Another thing that you can try, is to put a probe and see if you
actually see the TXCLK? And if I understand correctly that should be at
25MHz (because the link speed is 100Mbit).

> 
> --
> Ron

-- 
/Horatiu
