Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B412C1C3B6C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 15:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgEDNkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 09:40:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40068 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbgEDNkk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 09:40:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AS2kv0gpUVX7q+EU8jc6o6kLyYe4vA6m3YP11lOv2W4=; b=FKq32PO49K7052ag4nwLaAeRJi
        SCB9TH1e0Kq8y1nBOTyOs87CbK1XO03zV5+FTyBE09XdTEltwfV898Yq6HgYH/EFd9F3jUxAmgJdo
        CDEzrhTn364OKsaf6WbCE86VaEECqGwjKKYwu56w9pAEw/R2HOJpSU6j/MjzsjWUF9nc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVbKi-000nw6-Ve; Mon, 04 May 2020 15:40:32 +0200
Date:   Mon, 4 May 2020 15:40:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH] dt-bindings: net: nxp,tja11xx: add compatible support
Message-ID: <20200504134032.GB190789@lunn.ch>
References: <20200504082617.11326-1-o.rempel@pengutronix.de>
 <20200504084412.juhnxip7lg2d3ct5@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504084412.juhnxip7lg2d3ct5@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 10:44:12AM +0200, Oleksij Rempel wrote:
> Hi all,
> 
> here is first attempt to rework this binding. So far I have following
> questions and/or issues:
> - currently this PHY is identified by ID, not by compatible. Should it
>   be probed by compatible?
>   Theoretically I can use:
>   	compatible = "nxp,tja1102", "ethernet-phy-ieee802.3-c22";

Hi Oleksij

This will not work, in the current framework. PHYs probe via the ID
registers, or ethernet-phy-id0141.0e90 like compatible strings. MDIO
devices, which means devices like Ethernet switches, probe via
compatible strings. There are a few old DT blobs which do have a
compatible for the PHY, but they are white listed and ignored. See
of_mdio.c, whitelist_phys and of_mdiobus_child_is_phy().

If the DT validation code is wrongly forcing you to have a compatible,
i think your best bet is to use the ethernet-phy-id with the correct
ID values.

   Andrew
