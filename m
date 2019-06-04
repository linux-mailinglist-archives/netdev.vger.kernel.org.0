Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 504CA3525E
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfFDV4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:56:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56562 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfFDV4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 17:56:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ITv+4IoskTUZASZDJBNZz2MONsVlCCb9b86iQ84P2q0=; b=GmiBS6cHx8EbJGXGMngELabx2V
        ta+doqxT6JPjYWchpeLXB1U/5davwA+nkihjlsDbKi0rc8D2M978WOoEf5WTshFgam63Ne+bXd0wq
        G+nnLg5JNaw57gPDw3up8w488XFXoDhFlC4FKXzUULd8c1JvHJt/2TbhlDTbyHuYiuQY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYHPm-0000Hv-Si; Tue, 04 Jun 2019 23:56:18 +0200
Date:   Tue, 4 Jun 2019 23:56:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
Message-ID: <20190604215618.GX19627@lunn.ch>
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604200713.GV19627@lunn.ch>
 <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
 <20190604211221.GW19627@lunn.ch>
 <CA+h21hrqsH9FYtTOrCV+Bb0YANQvSnW9Uq=SoS7AJv9Wcw3A3w@mail.gmail.com>
 <31cc0e5e-810c-86ea-7766-ec37008c5f9d@gmail.com>
 <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> For a switch, there are four stages, not two:

Agreed.
 
> 1. The out-of-reset state, which from what I've seen seems to be to
>    behave like a dumb switch.

For the Marvell Switches, there is a pin you can strap to control
this, NO_CPU. If you say there is no CPU, it will power up in dumb
switch mode, and potentially bring your network down with a broadcast
storm because of loops.

So yes, you need to think about this at all four stages, and make sure
your hardware engineer is also on board.

     Andrew

