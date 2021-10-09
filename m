Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB5A427D38
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 22:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhJIUI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 16:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbhJIUIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 16:08:25 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A11C061570;
        Sat,  9 Oct 2021 13:06:28 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g10so49140368edj.1;
        Sat, 09 Oct 2021 13:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xpjcErwn54YCLH/tgP6GgXLFqK0xK5He1zZA79+iljY=;
        b=jKskd7Twa5zMs9paSq05yBkYjDIIVeDTLGVCfr5o8sdQvoeqKrkXMZyuRAl4eGmzOx
         O+2aKlt5rJepsHMt3jUHVCkuNzlJVl9xuUHyXc0bFjJa0MlpCwL/OCKylXsLH7riUlK3
         jA3JaoGtJbfjNibh7TwbO3bFyN9QZ0GC5achpPTE4JxdjXrX2xI0mLquNTKvRtermCAA
         N6y/tqKpdH77iMC3JjuPFYfdXZz12CE0t1/mViw+rvwi3ta6H6Qci6HoRW/5q3/cRUhO
         1WLu3QgX+jW+UDctuWRloAAYlsje6x1Bpv2sgM2j9bHqVyOm4As5MPqEso/GQNT0Goso
         tF5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xpjcErwn54YCLH/tgP6GgXLFqK0xK5He1zZA79+iljY=;
        b=WgAZlqkx5B33XUKMsX9aVb7pCzz8cChDLNX+kSqWavtoyGKAZWOns2Qx+didRZOzKY
         rYzU/3LBMrlNDx3UoZOsWNxft6MHZ8BCczLH5nXwrsQQzNOBfVaRDlePHRuCZWOKj25b
         EArzjFIjS8n6/WYIrVNNRznwzugNnYJGO0SNEL0/1kOqeXx7ghLFRGg/hWmUk/kh+FBE
         64B2M5xEvGn07Ge7Xe3twtN/XxF5m5mPC9rZXCyO4LGNH6+rNEfsJWuvS8sT42Q7oQyj
         oyP+H11p30vVNTQWI1o09DYG/hRPfHPWYUfSb+ElOxd2ali2Nf2Nwagy+uYGCzU3lbwq
         Km2g==
X-Gm-Message-State: AOAM530ITj9KXvXELkHifGn7f4qMVmLH93Hd3KVxh10n509cXJzMSxzK
        A5ofe1/DM0jq+s0qI5aDIO0=
X-Google-Smtp-Source: ABdhPJzSa8gZ+bs7axtm6gyKUR2rT0SM4ByLACrAEKHWB+JD/9mW54wujnbAxucAdmX1bchE/1dviQ==
X-Received: by 2002:a17:906:8cd:: with SMTP id o13mr13481017eje.341.1633809986457;
        Sat, 09 Oct 2021 13:06:26 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id l5sm1301271ejx.76.2021.10.09.13.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 13:06:26 -0700 (PDT)
Date:   Sat, 9 Oct 2021 22:06:23 +0200
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
Message-ID: <YWH2P7ogyH3T0CVp@Ansuel-xps.localdomain>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-9-ansuelsmth@gmail.com>
 <YWHMRMTSa8xP4SKK@lunn.ch>
 <YWHamNcXmxuaVgB+@Ansuel-xps.localdomain>
 <YWHx7Q9jBrws8ioN@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWHx7Q9jBrws8ioN@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 09:47:57PM +0200, Andrew Lunn wrote:
> > Problem here is that from Documentation falling edge can be set only on
> > PAD0. PAD5 and PAD6 have the related bit reserved.
> 
> Meaning in future, they could be used for this, if those ports get
> support for SGMII.
>

Ok. Then I will move all to DT port. Consider falling is set to PAD0 for
both cpu port0 and cpu port6, should I make it hardcoded or should I add
a condition and force the reg to PAD0 only for the current supported
switch? Hope you understand what I mean.
(Yes we have some config with cpu port6 set to sgmii and that require
falling edge)

> > But anyway qca8k support only single sgmii and it's not supported a
> > config with multiple sgmii.
> 
> Yet, until such hardware appears. We do see more support for SFPs. And
> more support for multi-gigi ports. Both of which use a SERDES
> interface which can support SGMII. So i would not be too surprised if
> future versions of the switch have more ports like this.
> 
> > Do we have standard binding for this?
> 
> No, there is no standard binding for this. This seems specific to
> these devices, maybe a proprietary extension to SGMII?
> 

Then we are stuck to the special qca,... naming.

> > About the mac swap. Do we really need to implement a complex thing for
> > something that is really implemented internally to the switch?
> 
> If it was truly internal to the switch, no. But i don't think it
> is. The DSA core has no idea the ports are swapped, and so i think
> will put the names on the wrong ports. Does devlink understand the
> ports are swapped? How about .ndo_get_phys_port_name? Will udev mix up
> the ports?
> 
> The way you wanted to look in the other ports DT properties suggests
> it is not internal to the switch.
> 
> I think to help my understanding, we need some examples of DTS files
> with and without the swap, where the properties are read from, what
> the interface names are, etc.
> 

Here is 2 configuration one from an Netgear r7800 qca8337:

	switch@10 {
		compatible = "qca,qca8337";
		#address-cells = <1>;
		#size-cells = <0>;
		reg = <0x10>;

		qca8k,rgmii0_1_8v;
		qca8k,rgmii56_1_8v;

		ports {
			#address-cells = <1>;
			#size-cells = <0>;

			port@0 {
				reg = <0>;
				label = "cpu";
				ethernet = <&gmac1>;
				phy-mode = "rgmii-id";

				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};

			port@1 {
				reg = <1>;
				label = "lan1";
				phy-mode = "internal";
				phy-handle = <&phy_port1>;
			};

			port@2 {
				reg = <2>;
				label = "lan2";
				phy-mode = "internal";
				phy-handle = <&phy_port2>;
			};

			port@3 {
				reg = <3>;
				label = "lan3";
				phy-mode = "internal";
				phy-handle = <&phy_port3>;
			};

			port@4 {
				reg = <4>;
				label = "lan4";
				phy-mode = "internal";
				phy-handle = <&phy_port4>;
			};

			port@5 {
				reg = <5>;
				label = "wan";
				phy-mode = "internal";
				phy-handle = <&phy_port5>;
			};

			port@6 {
				reg = <6>;
				label = "cpu";
				ethernet = <&gmac2>;
				phy-mode = "sgmii";

				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};
		};

And here is one with mac swap Tp-Link Archer c7 v4 qca8327 

	switch0@10 {
		compatible = "qca,qca8337";
		#address-cells = <1>;
		#size-cells = <0>;

		reg = <0>;
		qca,sgmii-rxclk-falling-edge;
		qca,mac6-exchange;

		ports {
			#address-cells = <1>;
			#size-cells = <0>;

			port@0 {
				reg = <0>;
				label = "cpu";
				ethernet = <&eth0>;
				phy-mode = "sgmii";

				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};

			port@1 {
				reg = <1>;
				label = "wan";
				phy-mode = "internal";
				phy-handle = <&phy_port1>;
			};

			port@2 {
				reg = <2>;
				label = "lan1";
				phy-mode = "internal";
				phy-handle = <&phy_port2>;
			};

			port@3 {
				reg = <3>;
				label = "lan2";
				phy-mode = "internal";
				phy-handle = <&phy_port3>;
			};

			port@4 {
				reg = <4>;
				label = "lan3";
				phy-mode = "internal";
				phy-handle = <&phy_port4>;
			};

			port@5 {
				reg = <5>;
				label = "lan4";
				phy-mode = "internal";
				phy-handle = <&phy_port5>;
			};
		};

As you can see we use the mac06_exchange but we declare it as port0. DSA
see it as port0 (as it should as it's internall swapped). We also don't
need to apply some special function or stuff to apply the correct port
in the ACL/regs/VLAN. The switch will treat MAC6 as MAC0 and MAC6 as
MAC0. That is what we observed.
Someone would say... Considering this switch is 2 port... and currently
we use only one port. Why not drop this and use whatever is connected to
port 0. Problem is that some device have the secondary cpu port NOT
connected and they use mac6-exchange and that would result in no
connection since cpu port 0 is not connected and cpu port 6 is never
swapped.

> > I will move the falling binding to the port DT node and move the
> > configuration to mac_config. Should I keep the
> > dedicated function to setup PAD0 swap or I can directly add the check in
> > the qca8k_setup for only the bit related to enable the swap?
> 
> That does not matter too much. DT is an ABI, we should not change it
> later, so we need to look forward. C code is not ABI, it can be
> changed if/when more SGMII ports actually arrive.
> 
> 	Andrew

-- 
	Ansuel
