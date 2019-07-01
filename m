Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8070A5BCE5
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 15:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbfGAN3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 09:29:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45620 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbfGAN3Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 09:29:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/wH7gsNCFutjcBkNMwkLgvVyn4BWXgcGFHl/aAlbf7A=; b=5H3GX93u95qcsN7JLwzaoO9hqB
        QO6yrOAAU3gkVrw5rlwjymr7mFEHAeDi/BgGDQIVZw4ifeHjU8eVerL3m8KR1R0u1xvtv4WGLLY4q
        q5PAUZJd9ErfqUzM9poNdilibKK7H9cDdqGWHJLEPS2CpaANTFa0VLrXCGTFbPYHGcYs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hhwMw-0006yh-BC; Mon, 01 Jul 2019 15:29:18 +0200
Date:   Mon, 1 Jul 2019 15:29:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     jacmet@sunsite.dk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] net: dm9600: false link status
Message-ID: <20190701132918.GA25795@lunn.ch>
References: <20190627132137.GB29016@Red>
 <20190627144339.GG31189@lunn.ch>
 <20190701122050.GA11021@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701122050.GA11021@Red>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But thoses chips should have marking (according to some photos on
> the web), so I probably own a counterfeiting of a
> clone/counterfeiting.

> At least, now i know that have a chip not designed to work with an external PHY, so all EXTPHY registers could be ignored.
> My last ressort is to brute force all values until something happen.

Does the rest of this work? You can actually transmit/receive frames,
but it is a 10/Half? So the MAC is working, just the PHY is missing?

> My simple tries, write 0xsomeval everywhere, lead to something, phy/eeprom return now 0x000y.
> Probably, this chip doesnt have any PHY...

If you look at dm9601_mdio_write() and dm9601_mdio_read() it always
passes 1. 0 is used for the EEPROM, at least in a real device. so try
1-31 and see if you get anything interesting.

	 Andrew
