Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC41162A71
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 17:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgBRQ17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 11:27:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51830 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgBRQ17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 11:27:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QD9GNcHoJ03duxzSyGpPsXKk48h4VH3torud6JCFlAU=; b=ZV/p/Nsqle6IwLF7g4B1GYCr1l
        Z8P6AiTSGBUKU2tQiOScaIGK2dkbb7qBI9M/xcWr1oRSrvKhgTvEJpcBwNaMWI1JQ/HYyqrdb6n3i
        NuZX1gdbCWpcifCUXnKOAiwbilBjQTUVmLKacHQMzdTmbERVk+QaHgeXhhVBNaNpD2cU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j45iw-0003S4-6E; Tue, 18 Feb 2020 17:27:50 +0100
Date:   Tue, 18 Feb 2020 17:27:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: fix duplicate vlan
 warning
Message-ID: <20200218162750.GR31084@lunn.ch>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <E1j41KQ-0002uy-TQ@rmk-PC.armlinux.org.uk>
 <20200218115157.GG25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218115157.GG25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:51:57AM +0000, Russell King - ARM Linux admin wrote:
> On Tue, Feb 18, 2020 at 11:46:14AM +0000, Russell King wrote:
> > When setting VLANs on DSA switches, the VLAN is added to both the port
> > concerned as well as the CPU port by dsa_slave_vlan_add().  If multiple
> > ports are configured with the same VLAN ID, this triggers a warning on
> > the CPU port.
> > 
> > Avoid this warning for CPU ports.
> > 
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Note that there is still something not right.  On the ZII dev rev B,
> setting up a bridge across all the switch ports, I get:

Hi Russell

FYI: You need to be a little careful with VLANs on rev B. The third
switch does not have the PVT hardware. So VLANs are going to 'leak'
when they cross the DSA link to that switch.

I will look at these patches later today.

  Andrew
