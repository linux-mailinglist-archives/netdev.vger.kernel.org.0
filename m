Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6E4229A47
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732633AbgGVOkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:40:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49186 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728837AbgGVOkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 10:40:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jyFuU-006LUN-0E; Wed, 22 Jul 2020 16:39:54 +0200
Date:   Wed, 22 Jul 2020 16:39:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] net: dsa: microchip: delete dead code
Message-ID: <20200722143953.GA1339445@lunn.ch>
References: <20200721083300.GA12970@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721083300.GA12970@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 10:33:01AM +0200, Helmut Grohne wrote:
> None of the removed assignments is ever read back and never influences
> logic.
> 
> Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>

Hi Helmut

This patch probably is correct. But it is not obviously correct,
because there are so many changes at once. Please could you break it
up.

> @@ -31,10 +31,7 @@ struct ksz_port {
>  	struct phy_device phydev;
>  
>  	u32 on:1;			/* port is not disabled by hardware */
> -	u32 phy:1;			/* port has a PHY */
>  	u32 fiber:1;			/* port is fiber */
> -	u32 sgmii:1;			/* port is SGMII */
> -	u32 force:1;
>  	u32 read:1;			/* read MIB counters in background */
>  	u32 freeze:1;			/* MIB counter freeze is enabled */
>  
> @@ -71,9 +68,7 @@ struct ksz_device {
>  	int reg_mib_cnt;
>  	int mib_cnt;
>  	int mib_port_cnt;
> -	int last_port;			/* ports after that not used */
>  	phy_interface_t interface;
> -	u32 regs_size;
>  	bool phy_errata_9477;
>  	bool synclko_125;
>  
> @@ -84,14 +79,9 @@ struct ksz_device {
>  	unsigned long mib_read_interval;
>  	u16 br_member;
>  	u16 member;
> -	u16 live_ports;
> -	u16 on_ports;			/* ports enabled by DSA */
> -	u16 rx_ports;
> -	u16 tx_ports;
>  	u16 mirror_rx;
>  	u16 mirror_tx;
>  	u32 features;			/* chip specific features */
> -	u32 overrides;			/* chip functions set by user */
>  	u16 host_mask;
>  	u16 port_mask;

So at minimum, break it up into 3 patches, one per structure.  I would
even go further.

Small patches are easier to review. And if something does break, a git
bisect gives you more information about what change broke it.

Thanks
	Andrew
