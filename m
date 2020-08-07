Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A9723EE39
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 15:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgHGN3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 09:29:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46492 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbgHGN3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 09:29:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k42Qy-008cGq-FF; Fri, 07 Aug 2020 15:29:20 +0200
Date:   Fri, 7 Aug 2020 15:29:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC leds + net-next v4 0/2] Add support for LEDs on
 Marvell PHYs
Message-ID: <20200807132920.GB2028541@lunn.ch>
References: <20200728150530.28827-1-marek.behun@nic.cz>
 <20200807090653.ihnt2arywqtpdzjg@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807090653.ihnt2arywqtpdzjg@duo.ucw.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > And no, I don't want phydev name there.
> 
> Ummm. Can we get little more explanation on that? I fear that LED
> device renaming will be tricky and phydev would work around that
> nicely.

Hi Pavel

The phydev name is not particularly nice:

!mdio-mux!mdio@1!switch@0!mdio:00
!mdio-mux!mdio@1!switch@0!mdio:01
!mdio-mux!mdio@1!switch@0!mdio:02
!mdio-mux!mdio@2!switch@0!mdio:00
!mdio-mux!mdio@2!switch@0!mdio:01
!mdio-mux!mdio@2!switch@0!mdio:02
!mdio-mux!mdio@4!switch@0!mdio:00
!mdio-mux!mdio@4!switch@0!mdio:01
!mdio-mux!mdio@4!switch@0!mdio:02
400d0000.ethernet-1:00
400d0000.ethernet-1:01
fixed-0:00

The interface name are:

1: lo:
2: eth0:
3: eth1:
4: lan0@eth1:
5: lan1@eth1:
6: lan2@eth1:
7: lan3@eth1:
8: lan4@eth1:
9: lan5@eth1:
10: lan6@eth1:
11: lan7@eth1:
12: lan8@eth1:
13: optical3@eth1:
14: optical4@eth1:

You could make a good guess at matching to two together, but it is
error prone. Phys are low level things which the user is not really
involved in. They interact with interface names. ethtool, ip, etc, all
use interface names. In fact, i don't know of any tool which uses
phydev names.

	 Andrew
