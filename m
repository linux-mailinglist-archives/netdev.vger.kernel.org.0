Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF50EDC5A6
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 15:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410189AbfJRNB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 09:01:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410136AbfJRNBZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 09:01:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+4nXf3mtlnP1A3sS+8fGuCDr530KN8aD9T0KU8axv0s=; b=I7ToEvJnlxjk7p4F9kDlfGk0SU
        +idx12ETbX1AETIb73RXUgtLTClG5x1y3YdF1kYXWms+89l3cFvIf1/dPo1b5hHKrUw1tSDE3bUH8
        TitcUd/ROro7JqwgcPtnCH56eVoVSApG52+63+8J7XPM9aPml3XBj0/WglmhKAKCb9q0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iLRsf-00012A-KN; Fri, 18 Oct 2019 15:01:21 +0200
Date:   Fri, 18 Oct 2019 15:01:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Russell King <rmk+kernel@armlinux.org.uk>, cphealy@gmail.com,
        Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next 2/2] net: phy: Add ability to debug RGMII
 connections
Message-ID: <20191018130121.GK4780@lunn.ch>
References: <20191015224953.24199-1-f.fainelli@gmail.com>
 <20191015224953.24199-3-f.fainelli@gmail.com>
 <4feb3979-1d59-4ad3-b2f1-90d82cfbdf54@gmail.com>
 <c4244c9a-28cb-7e37-684d-64e6cdc89b67@gmail.com>
 <CA+h21hrLHe2n0OxJyCKTU0r7mSB1zK9ggP1-1TCednFN_0rXfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrLHe2n0OxJyCKTU0r7mSB1zK9ggP1-1TCednFN_0rXfg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Well, that's the tricky part. You're sending a frame out, with no
> guarantee you'll get the same frame back in. So I'm not sure that any
> identifiers put inside the frame will survive.
> How do the tests pan out for you? Do you actually get to trigger this
> check? As I mentioned, my NIC drops the frames with bad FCS.

My experience is, the NIC drops the frame and increments some the
counter about bad FCS. I do very occasionally see a frame delivered,
but i guess that is 1/65536 where the FCS just happens to be good by
accident. So i think some other algorithm should be used which is
unlikely to be good when the FCS is accidentally good, or just check
the contents of the packet, you know what is should contain.

Are there any NICs which don't do hardware FCS? Is that something we
realistically need to consider?

> Yes, but remember, nobody guarantees that a frame with DMAC
> ff:ff:ff:ff:ff:ff on egress will still have it on its way back. Again,
> this all depends on how you plan to manage the rx-all ethtool feature.

Humm. Never heard that before. Are you saying some NICs rewrite the
DMAN?

	Andrew
