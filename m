Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D820621236
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234402AbiKHNWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbiKHNW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:22:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926AB528AE
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 05:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ckwunT60IKu2fble6tr01iQKRJbaryVizPJxfML8oGM=; b=cgz6Lloz3WhLC7goSGFkYv8kSj
        ntPII0gmnE9k6oBWNBwtpOqUy/M2sYeQMoa9ANFWQjxwl3nueksMdHHkboaxdCAlN47M+wsaqeBcu
        SzxAhBIBaCbfafN8gLUMjyG/BK0P5RlHzPccyth45+7ltqrQKhF4/GeDZ3tofyOZLTwk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osOXa-001oxT-Om; Tue, 08 Nov 2022 14:21:22 +0100
Date:   Tue, 8 Nov 2022 14:21:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH 1/9] net: dsa: allow switch drivers to override default
 slave PHY addresses
Message-ID: <Y2pX0qrLs/OCQOFr@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
 <20221108082330.2086671-2-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108082330.2086671-2-lukma@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 09:23:22AM +0100, Lukasz Majewski wrote:
> From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> 
> Avoid having to define a PHY for every physical port when PHY addresses
> are fixed, but port index != PHY address.

Please could you expand the commit message. What i think is going on
is that for the lower device, port 0 has phy address 0, port 1 phy
address 1. But the upper switch has port 0 phy address 16, port 1 phy
addr 17?

6141 and 6341 set phy_base_addr to 0x10. Oddly, this is only used for
the interrupt. So i assume these two devices also need device tree
phy-handle descriptions?

It would be nice to fix the 6141 and the 6341 as well.

What might help with understanding is have the patch for the mv88e6xxx
op first, and then wire it up in the core afterwards. Reviews tend to
happen first to last, so either your commit message needs to explain
what is coming, or you do things in the order which helps the reviewer
the most.

   Andrew
