Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E88427DE1
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 00:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhJIWZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 18:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbhJIWZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 18:25:29 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4892BC061570;
        Sat,  9 Oct 2021 15:23:32 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b8so50698122edk.2;
        Sat, 09 Oct 2021 15:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sD1Un2BJTboJPBhfWgTVUUWUwkr9E/+N6diTtDohn7Y=;
        b=QHV4MAOXTLG62fTRHEOvoeCox8BJGTR749pRwn3HsOkdxhb+byTwRWABC3qAPCJ0gt
         6JhhpFYnzT/UTCdn1jU8GvbK1wLu29yiriJKt9sAmzial4k6ibzc1prcSuXjI2h4yg77
         gKty7NJj9K92IIql+WoQfNdMLcRffWmnUvwWZykbBqdG/7b+M+QXJdsl/GQZH7VjZIkr
         mfzeXTAB19PWgVwcx7mFHC2ACIAGyPwH2C2cCs24j31DZS7M6r/HDEXe4Kodbj6xWRQC
         y0AfsjuJrP1lMT3VvOYgaKxgRPF51L2/F+J1l8cekVP4TNY/nZ65ANa/ip+Kv1ATVQxl
         2KEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sD1Un2BJTboJPBhfWgTVUUWUwkr9E/+N6diTtDohn7Y=;
        b=h8hfDxXGHHqXbc/iAY6etxEexDkj232FUsN3JJ7CgH5a50byDEVmZNrF7cme2AdzsJ
         TiSGspspV9HlFQ6HNFaCYdS5Df7lZUozq3rDqv4Gm3o7pjfJS5aghJCaOZEfhfYlcMRT
         5IRMGr31Vw7dimXH1c7xLTYQshrL5B2rFNSYwT/pOFZso4ZvP9zkvFeqOhKKODAGNRso
         DhMrMOX8cJy/fRWOjZIInspJUaW/EjLWRUGk/15QPdzSkPQQrwLZGHPQ+yyFz03j5ccc
         2UEsWx1pB6hIzc4/wbRaV9hW20IKrMXV4F+A7ghivjZKWEuQFpnCm3//sRjiU89CpcAw
         bKrg==
X-Gm-Message-State: AOAM532v5Na9u8Mcs6ZgikHZ1dsrZvFRWqU3r87YHasFxVWGzfNykOSO
        99IOujH1rlgHv/BmBqFuPzw=
X-Google-Smtp-Source: ABdhPJzg9RV8pq3Z5WrITgxASR4THiFVegcEVuv8xqJWP8se4F4Q3JhXsan3YxmoeBn8ZlAqOv2hWQ==
X-Received: by 2002:a05:6402:4402:: with SMTP id y2mr18799440eda.222.1633818210661;
        Sat, 09 Oct 2021 15:23:30 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id 6sm1409056ejx.82.2021.10.09.15.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 15:23:30 -0700 (PDT)
Date:   Sun, 10 Oct 2021 00:23:27 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH v2 08/15] dt-bindings: net: dsa: qca8k: Add MAC
 swap and clock phase properties
Message-ID: <YWIWX9+MHWbH7l8z@Ansuel-xps.localdomain>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-9-ansuelsmth@gmail.com>
 <YWHMRMTSa8xP4SKK@lunn.ch>
 <YWHamNcXmxuaVgB+@Ansuel-xps.localdomain>
 <YWHx7Q9jBrws8ioN@lunn.ch>
 <YWH2P7ogyH3T0CVp@Ansuel-xps.localdomain>
 <YWILhniu2KFIGut9@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWILhniu2KFIGut9@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 11:37:10PM +0200, Andrew Lunn wrote:
> > Here is 2 configuration one from an Netgear r7800 qca8337:
> > 
> > 	switch@10 {
> > 		compatible = "qca,qca8337";
> > 		#address-cells = <1>;
> > 		#size-cells = <0>;
> > 		reg = <0x10>;
> > 
> > 		qca8k,rgmii0_1_8v;
> > 		qca8k,rgmii56_1_8v;
> > 
> > 		ports {
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 
> > 			port@0 {
> > 				reg = <0>;
> > 				label = "cpu";
> > 				ethernet = <&gmac1>;
> > 				phy-mode = "rgmii-id";
> > 
> > 				fixed-link {
> > 					speed = <1000>;
> > 					full-duplex;
> > 				};
> > 			};
> > 
> > 			port@1 {
> > 				reg = <1>;
> > 				label = "lan1";
> > 				phy-mode = "internal";
> > 				phy-handle = <&phy_port1>;
> > 			};
> > 
> > 			port@2 {
> > 				reg = <2>;
> > 				label = "lan2";
> > 				phy-mode = "internal";
> > 				phy-handle = <&phy_port2>;
> > 			};
> > 
> > 			port@3 {
> > 				reg = <3>;
> > 				label = "lan3";
> > 				phy-mode = "internal";
> > 				phy-handle = <&phy_port3>;
> > 			};
> > 
> > 			port@4 {
> > 				reg = <4>;
> > 				label = "lan4";
> > 				phy-mode = "internal";
> > 				phy-handle = <&phy_port4>;
> > 			};
> > 
> > 			port@5 {
> > 				reg = <5>;
> > 				label = "wan";
> > 				phy-mode = "internal";
> > 				phy-handle = <&phy_port5>;
> > 			};
> > 
> > 			port@6 {
> > 				reg = <6>;
> > 				label = "cpu";
> > 				ethernet = <&gmac2>;
> > 				phy-mode = "sgmii";
> > 
> > 				fixed-link {
> > 					speed = <1000>;
> > 					full-duplex;
> > 				};
> 
> So here, it is a second CPU port.  But some other board could connect
> an SGMII PHY, and call the port lan5. Or it could be connected to an
> SFP cage, and used that way. Or are you forced to use it as a CPU
> port, or not use it at all?
>

We have a bit to set the mode. So yes it can be used to different modes.
(base-x, phy and mac)

> > And here is one with mac swap Tp-Link Archer c7 v4 qca8327 
> > 
> > 	switch0@10 {
> > 		compatible = "qca,qca8337";
> > 		#address-cells = <1>;
> > 		#size-cells = <0>;
> > 
> > 		reg = <0>;
> > 		qca,sgmii-rxclk-falling-edge;
> > 		qca,mac6-exchange;
> > 
> > 		ports {
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 
> > 			port@0 {
> > 				reg = <0>;
> > 				label = "cpu";
> > 				ethernet = <&eth0>;
> > 				phy-mode = "sgmii";
> > 
> > 				fixed-link {
> > 					speed = <1000>;
> > 					full-duplex;
> > 				};
> 
> So when looking for SGMI properties, you need to look here. Where as
> in the previous example, you would look in port 6. And the reverse is
> true for RGMII delays.
> 
> > 			};
> > 
> > 			port@1 {
> > 				reg = <1>;
> > 				label = "wan";
> > 				phy-mode = "internal";
> > 				phy-handle = <&phy_port1>;
> > 			};
> > 
> > 			port@2 {
> > 				reg = <2>;
> > 				label = "lan1";
> > 				phy-mode = "internal";
> > 				phy-handle = <&phy_port2>;
> > 			};
> > 
> > 			port@3 {
> > 				reg = <3>;
> > 				label = "lan2";
> > 				phy-mode = "internal";
> > 				phy-handle = <&phy_port3>;
> > 			};
> > 
> > 			port@4 {
> > 				reg = <4>;
> > 				label = "lan3";
> > 				phy-mode = "internal";
> > 				phy-handle = <&phy_port4>;
> > 			};
> > 
> > 			port@5 {
> > 				reg = <5>;
> > 				label = "lan4";
> > 				phy-mode = "internal";
> > 				phy-handle = <&phy_port5>;
> > 			};
> > 		};
> 
> So here, port '6' is not used. But it could be connected to an RGMII
> PHY and called lan5. Would the naming work out? What does devlink
> think of it, etc. What about phy-handle? Is there an external MDIO
> bus? What address would be used if there is no phy-handle?
> 
>       Andrew

In this case port6 is not used as it's not connected at all in hardware.
From the configuration list yes, it can be used as lan5 in phy mode and
it would have address 5 (internally the address are with an offset of
-1). Anyway I honestly think that we are putting too much effort in
something that can and should be handled differently. I agree that all
this mac exchange is bs and doesn't make much sense. I tried to
implement this as we currently qca8k is hardcoded to expect
the cpu port 0 for everything and doesn't actually found a valid cpu
port (aka it doesn't expect a configuration with cpu6)
I think the driver was writtent with the concept of mac exchange from
the start. That's why it's hardoced to port0.
I actually tied for fun running the switch using only the port6 cpu
port and it worked just right. So I think I will just drop the mac
exchange and fix the code to make it dynamic.

-- 
	Ansuel
