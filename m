Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28C0735DF4
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 15:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfFENbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 09:31:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58400 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728133AbfFENbF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 09:31:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wn6Ow9gHW9U3rLf/qEnIBeOOiBkyW78kix5JEhoKoqs=; b=gvgj2YoD4oBuopgO0GRuz30qhW
        4VnZ90nLoWUVq+AX3dF9kIkMxZ5mBK1fLm+/7z+sx6rTBCdNkDuBW/HtAWzFzC3Y7KCeGIqjokeR3
        lP26nO3LIQLw8vCoR1apGbN2pyiW8wy9DXTyEgtVNnmaeISPKQ4ylBWhVm711mvW948s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYW0M-0004qZ-Dx; Wed, 05 Jun 2019 15:31:02 +0200
Date:   Wed, 5 Jun 2019 15:31:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA with MV88E6321 and imx28
Message-ID: <20190605133102.GF19627@lunn.ch>
References: <8812014c-1105-5fb6-bc20-bad0f86d33ea@eks-engel.de>
 <20190604135000.GD16951@lunn.ch>
 <854a0d9c-17a2-c502-458d-4d02a2cd90bb@eks-engel.de>
 <20190605122404.GH16951@lunn.ch>
 <414bd616-9383-073d-b3f3-6b6138c8b163@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <414bd616-9383-073d-b3f3-6b6138c8b163@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Here is my device tree
> 
> mdio { 
>                 #address-cells = <1>;
>                 #size-cells = <0>;
> 
>                 switch0: switch0@0 {
>                         compatible = "marvell,mv88e6085";
>                         reg = <0x0>;
>                         pinctrl-0 = <&lcd_d06_pins>;
>                         reset-gpios = <&gpio1 6 GPIO_ACTIVE_LOW>;
> 
>                         dsa,member = <0 0>;
> 
>                         ports {
>                                 #address-cells = <1>;
>                                 #size-cells = <0>;
> 
>                                 port@0 {
> /* Changed reg to 0xc too, same error message */
>                                         reg = <0x0>;
>                                         label = "Serdes0";
>                                         phy-handle = <&switch0phy0>;
>                                 };
> 
>                                 port@1 {
> /* Changed reg to 0xd too, same error message */
>                                         reg = <0x1>;
>                                         label = "Serdes1";
>                                         phy-handle = <&switch0phy1>;
>                                 };
> 				
> 				port@2 {
>                                         reg = <0x2>;
>                                         label = "lan1";
>                                         phy-handle = <&switch0phy2>;
>                                 };
> 
>                                 port@3 {
>                                         reg = <0x3>;
>                                         label = "lan2";
>                                         phy-handle = <&switch0phy3>;
>                                 };
> 
>                                 port@4 {
>                                         reg = <0x4>;
>                                         label = "lan3";
>                                         phy-handle = <&switch0phy4>;
>                                 };

You don't need to list phy-handle for the internal PHYs. It should
just find them.

>                         mdio {
>                                 #address-cells = <1>;
>                                 #size-cells = <0>;
>                                 switch0phy0: switch0phy0@0 {
> /* Changed reg to 0 too, same error message */
> 					 reg = <0xc>;
>                                 };
>                                 switch0phy1: switch0phy1@1 {
> /* Changed reg to 1 too, same error message */
>                                         reg = <0xd>;
>                                 };
>                                 switch0phy3: switch0phy3@3 {
>                                         reg = <0x3>;
>                                 };
>                                 switch0phy4: switch0phy4@4 {
>                                         reg = <0x4>;
>                                 };
>                         };
> 
>                         mdio1 {
> 				compatible = "marvell,mv88e6xxx-mdio-external";
>                                 #address-cells = <1>;
>                                 #size-cells = <0>;
> 
>                                 switch0phy2: switch0phy2@2 {
>                                         reg = <0x2>;
>                                 };
>                                 switch0phy6: switch0phy6@6 {
>                                         reg = <0x6>;
>                                 };
>                         };

I doubt this second mdio bus is correct. The 6390 uses that, but i
don't think any other family does. The older generations have one MDIO
bus for both internal and external PHYs.

One other idea. Take a look at the data sheet. Can the MDIO pins also
be used for GPIO? Do they default to GPIO or MDIO? For the 6390 they
default to GPIO and there is code to reconfigure them for MDIO.

	Andrew
