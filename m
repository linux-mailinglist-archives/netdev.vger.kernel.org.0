Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD69545606D
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhKRQa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:30:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40866 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233257AbhKRQa7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 11:30:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=G7E8zxCwbvOwJOIKEvsPCKyEi97y3Esn7c56Bgf042U=; b=lS
        OCWdr39YTyewqW6LHU4f1eIvRno4+k1nh4oktfv9Bj310Gy0WemHftYiMLqtqiVagjtmfe/evEGOJ
        qEE0SQARdMWQGGlDKttaTa1HBj3t/RflFS5QMUWSU/p6AO7fMH3BdJUGMSi5oSAgfIiiMBdLPzgFw
        LdgQZ0Zy8pozqHQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mnkGR-00E08l-Tk; Thu, 18 Nov 2021 17:27:55 +0100
Date:   Thu, 18 Nov 2021 17:27:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/8] dt-bindings: ethernet-controller: support
 multiple PHY connection types
Message-ID: <YZZ/C2xf439/Ckmz@lunn.ch>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211117225050.18395-2-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 11:50:43PM +0100, Marek Behún wrote:
> Sometimes, an ethernet PHY may communicate with ethernet controller with
> multiple different PHY connection types, and the software should be able
> to choose between them.
> 
> Russell King says:
>   conventionally phy-mode has meant "this is the mode we want to operate
>   the PHY interface in" which was fine when PHYs didn't change their
>   mode depending on the media speed
> This is no longer the case, since we have PHYs that can change PHY mode.
> 
> Existing example is the Marvell 88X3310 PHY, which supports connecting
> the MAC with the PHY with `xaui` and `rxaui`. The MAC may also support
> both modes, but it is possible that a particular board doesn't have
> these modes wired (since they use multiple SerDes lanes).
> 
> Another example is one SerDes lane capable of `1000base-x`, `2500base-x`
> and `sgmii` when connecting Marvell switches with Marvell ethernet
> controller. Currently we mention only one of these modes in device-tree,
> and software assumes the other modes are also supported, since they use
> the same SerDes lanes. But a board may be able to support `1000base-x`
> and not support `2500base-x`, for example due to the higher frequency
> not working correctly on a particular board.
> 
> In order for the kernel to know which modes are supported on the board,
> we need to be able to specify them all in the device-tree.
> 
> Change the type of property `phy-connection-type` of an ethernet
> controller to be an array of the enumerated strings, instead of just one
> string. Require at least one item defined.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
