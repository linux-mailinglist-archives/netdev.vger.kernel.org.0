Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9489427B42
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 17:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbhJIPU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 11:20:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58284 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233728AbhJIPU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 11:20:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4hgYylOgEY4KRqFFClkdULm2cTRWtsYcLsbnTkI6SSw=; b=LeId56INCFhlp6q4mScdRpksat
        W+cGW4p6jpRmFhEZ/K1nMMCoKPhwRKIOXCC+9//NybfnLu0/N3vBiCJTAW9HNM0bkcwIVZMT27mX7
        u7+ASI8YyKb9JYjxhM7keFFN9L7k+nvN5KZCSGzsxh3j3CU4LqQc51+GBFf6/BlnFS/k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mZE7j-00AA0T-JR; Sat, 09 Oct 2021 17:18:55 +0200
Date:   Sat, 9 Oct 2021 17:18:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 06/15] dt-bindings: net: dsa: qca8k: document
 rgmii_1_8v bindings
Message-ID: <YWGy33inSic1PcC5@lunn.ch>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-7-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008002225.2426-7-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 02:22:16AM +0200, Ansuel Smith wrote:
> Document new qca,rgmii0_1_8v and qca,rgmii56_1_8v needed to setup
> mac_pwr_sel register for qca8337 switch. Specific the use of this binding
> that is used only in qca8337 and not in qca8327.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> index 8c73f67c43ca..9383d6bf2426 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> @@ -13,6 +13,14 @@ Required properties:
>  Optional properties:
>  
>  - reset-gpios: GPIO to be used to reset the whole device
> +- qca,rgmii0-1-8v: Set the internal regulator to supply 1.8v for MAC0 port.
> +                   This is needed for qca8337 and toggles the supply voltage
> +                   from 1.5v to 1.8v. For the specific regs it was observed
> +                   that this is needed only for ipq8064 and ipq8065 target.
> +- qca,rgmii56-1-8v: Set the internal regulator to supply 1.8v for MAC5/6 port.
> +                    This is needed for qca8337 and toggles the supply voltage
> +                    from 1.5v to 1.8v. For the specific regs it was observed
> +                    that this is needed only for ipq8065 target.

Are ipq8065 & ipq8064 SoCs which the switch is embedded into? So you
could look for the top level compatible and set these regulators based
on that. No DT property needed.

   Andrew
