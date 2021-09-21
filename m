Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68050413328
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 14:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhIUMKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 08:10:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52032 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230508AbhIUMKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 08:10:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iCImnUfXT17o0CrqUznHCtc6sRwsT4dKLhyo05K3eJQ=; b=rgkspaPwLqX7Ui/t2xa0mmRvaF
        RM/aUSUdueBzzt/emlHO9E4G7HukyH4A1tIhs7lQfNxo09fn2u1XDiQoObhRgv7WyXJkxWj7dzXCW
        OAa10mimpQQdHSLpTkD3jnGIfAL9L5+k0cfKVC6V9eYarmix7ae43tiC8CSjOnBCNfJs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSeZg-007cjQ-EC; Tue, 21 Sep 2021 14:08:36 +0200
Date:   Tue, 21 Sep 2021 14:08:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bas Vermeulen <bvermeul@blackstar.nl>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: mv88e6xxx: 88ae6321 not learning bridge mac address
Message-ID: <YUnLRDQuxUZJQQqM@lunn.ch>
References: <e58f4594-b73b-6681-cb2e-fa1ce56f22e1@blackstar.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e58f4594-b73b-6681-cb2e-fa1ce56f22e1@blackstar.nl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 11:02:43AM +0200, Bas Vermeulen wrote:
> Hi,
> 
> I am working on a custom i.MX8 board using a Marvell 88ae6321 switch. We're
> not using the latest kernel unfortunately, but 5.4.70 with patches from NXP
> and ourselves.
> 
> The switch is connected as follows:
> 
> CPU - fec ethernet -> 88ae6321 on port 5, with external PHYs on port 1, 2
> and 6, and using the internal PHY on port 3 and 4.
> 
> We set up a bridge with swp1, swp2, swp3, swp4, and swp6. Traffic from the
> various ports all learn correctly, with the exception of the bridge itself
> (and probably the CPU port?).
> 
> If I ping the bridge address from one of the clients, the switch floods the
> ping request to all ports.
> If I ping a client from the bridge address, the ping request goes to that
> client, the reply goes to all connected ports. This also happens if I use
> iperf3 to test the bandwidth, and will limit the bandwidth available when
> sending from the client to the lowest link on the switch.
> 
> Anyone have an idea how to fix this? It's possible I've misconfigured
> something, but I'm not sure what it could be. If there is a way to teach the
> 88ae6321 that a mac address is available on the CPU port, that would fix it,
> for instance. I tried adding the switch mac address with bridge fdb add, but
> that didn't work.

There has been work on this area recently. Please try a modern kernel
and see if it works. If it does, you can then decide if you want to
backport the changes, or upgrade your kernel.

	 Andrew
