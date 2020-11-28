Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AAB2C6E13
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 02:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731937AbgK1AlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 19:41:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53772 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731202AbgK1Aj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 19:39:27 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kioGe-009CIy-Q6; Sat, 28 Nov 2020 01:39:12 +0100
Date:   Sat, 28 Nov 2020 01:39:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201128003912.GA2191767@lunn.ch>
References: <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
 <20201126220500.av3clcxbbvogvde5@skbuf>
 <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAFSKS=MAdnR2jzmkQfTnSQZ7GY5x5KJE=oeqPCQdbZdf5n=4ZQ@mail.gmail.com>
 <20201127195057.ac56bimc6z3kpygs@skbuf>
 <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
 <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127233048.GB2073444@lunn.ch>
 <20201127233916.bmhvcep6sjs5so2e@skbuf>
 <20201128000234.hwd5zo2d4giiikjc@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201128000234.hwd5zo2d4giiikjc@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This means, as far as I understand, 2 things:
> 1. call_netdevice_notifiers_info doesn't help, since our problem is the
>    same
> 2. I think that holding the RTNL should also be a valid way to iterate
>    through the net devices in the current netns, and doing just that
>    could be the simplest way out. It certainly worked when I tried it.
>    But those could also be famous last words...

DSA makes the assumption it can block in a notifier change event.  For
example, NETDEV_CHANGEUPPER calls dsa_slave_changeupper() which calls
into the driver. We have not seen any warnings about sleeping while
atomic. So maybe see how NETDEV_CHANGEUPPER is issued.

	Andrew
