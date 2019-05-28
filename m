Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0A3E2CB42
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfE1QLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:11:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfE1QLo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 12:11:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3qgyASsx7W4qoVncJmUSH568PLlagQ88w/6FPZ5yjrM=; b=s0qyTRqbhje3iVsXlk4wKvFU4k
        +sULZerXvC7Qp7LWHXGtv3cxu644G1gessMZjPCHa4KrP6JJm5gzmu0bMxQskzcTDAQQ7XlALL6dO
        SLcEE3vDDnV4YEdY/qxhFIQOdBC+q9hd5X3TkF0aqKmfCPCc1ZBEKzpoKpAT+FMqSZPQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVehP-0008Oq-5y; Tue, 28 May 2019 18:11:39 +0200
Date:   Tue, 28 May 2019 18:11:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: report if the PHY fails to boot
 firmware
Message-ID: <20190528161139.GQ18059@lunn.ch>
References: <E1hVYVG-0005D8-8w@rmk-PC.armlinux.org.uk>
 <20190528154238.ifudfslyofk22xoe@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528154238.ifudfslyofk22xoe@shell.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> One question: are we happy with failing the probe like this, or would it
> be better to allow the probe to suceed?
> 
> As has been pointed out in the C45 MII access patch, we need the PHY
> to bind to the network driver for the MII bus to be accessible to
> userspace, so if we're going to have userspace tools to upload the
> firmware, rather than using u-boot, we need the PHY to be present and
> bound to the network interface.

Hi Russell

It is an interesting question. Failing the probe is the simple
solution. If we don't fail the probe, we then need to allow the
attach, but fail all normal operations, with a noisy kernel log.  That
probably means adding a new state to the state machine, PHY_BROKEN.
Enter that state if phy_start_aneg() returns an error?

      Andrew
