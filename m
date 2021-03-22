Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D991345058
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 20:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhCVT4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 15:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhCVT4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 15:56:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781CCC061574;
        Mon, 22 Mar 2021 12:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GazjgikYivoBy6/oU6gAviqIw+giRT+xUyeti4WbEQ4=; b=FEeMSxas4D/LJgc2If9d8pya+
        yMHofB14IaJUluUvcwMUkXVBxigOc9OSjvDQodss4s/m6fyGOZsw+pH+kXuK/aKbvpX5Qw1CTe5Op
        3aKLUCWzwJdR3JuVxkb+2jy9XjPIbTA5bg2KhPx8qPIjwt5uk5FE4BcvHpxlxzjtBkWaVo/LNnSyM
        vFC2/FgcNFnWXkU8FSOqhgf51KBjZwbXNbOJMieXnGvcV9fNBwhhYkAG2MwvTyd1rRMMjajLMX7Mm
        cLF61dZ9JkrMIQwJJfaqIxSKZ//eX1FclsYU7zKPhtX1CsCGc6eFagWsXFNyCdd+egm3cfJsPkW0P
        8W+f7Q81A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51598)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lOQek-0006u2-RZ; Mon, 22 Mar 2021 19:56:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lOQej-0003UW-EF; Mon, 22 Mar 2021 19:56:05 +0000
Date:   Mon, 22 Mar 2021 19:56:05 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [RFC net-next 2/2] dt-bindings: ethernet-phy: define
 `unsupported-mac-connection-types` property
Message-ID: <20210322195605.GA1463@shell.armlinux.org.uk>
References: <20210322195001.28036-1-kabel@kernel.org>
 <20210322195001.28036-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210322195001.28036-2-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 08:49:59PM +0100, Marek Behún wrote:
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index 2766fe45bb98..4c5b8fabbec3 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -136,6 +136,20 @@ properties:
>        used. The absence of this property indicates the muxers
>        should be configured so that the external PHY is used.
>  
> +  unsupported-mac-connection-types:
> +    $ref: "ethernet-controller.yaml#/$defs/phy-connection-type-array"
> +    description:
> +      The PHY device may support different interface types for
> +      connecting the Ethernet MAC device to the PHY device (i.e.
> +      rgmii, sgmii, xaui, ...), but not all of these interface
> +      types must necessarily be supported for a specific board
> +      (either not all of them are wired, or there is a known bug
> +      for a specific mode).
> +      This property specifies a list of interface modes are not
> +      supported on the board.

I think this needs to be clearer. "This property specifies a list
of interface modes supported by the PHY hardware but are not
supported on the board."

I would also suggest having a think about a PHY that supports some
interface types that we don't have support in the kernel for, but
which also are not part of the board. Should these be listed
somehow as well? If not, how do we deal with the kernel later gaining
support for those interface modes, potentially the PHY driver as well,
and then having a load of boards not listing this?

My feeling is that listing negative properties presents something of
a problem, and we ought to stick with boards specifying what they
support, rather than what they don't.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
