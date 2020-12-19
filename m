Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67AC82DF158
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 20:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgLSTt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 14:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbgLSTtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 14:49:25 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C812AC0613CF
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 11:48:34 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id 6so8103780ejz.5
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 11:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nYIRKjTX5DlY+XJntHANQo6lAysYqlroTq1IelMOgX0=;
        b=VPSqWPZthRVRc55P45/+iXf2rbbPhBV0pbwIONIdJnfx+7pg9bE7Th2I7cc4Me8HQh
         A8I3uf43rIoLWD8HG2OBz2pxjFLuRs3aetrvYgJXL7x3ugX3W283PgSX+gw96LQnO4UF
         yFgT2eA213hmSxNHOopv+k2teBtdSYEaPGdbg2maNThUIKy/Yh/hoDOfbJQ13GyRaF8E
         ItXIZQLppma5t2rzluRgoF6m0jXzWxXchVcAgHmKc5l+ExxOUGIxP2CzM8lJN8sPeLBC
         bkNc7dtpebQdR1BRVqnRE5IxwxRfOMMbtigOD3Up2/h38Wp89ETWZFDqIOKMJ5kz7Mv+
         darA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nYIRKjTX5DlY+XJntHANQo6lAysYqlroTq1IelMOgX0=;
        b=WuFd3aDeZavRHWd3rw78v1V+SVqSBV+tsfsq9ck8JYePnXyW0oC1gF2InyprYyyFaJ
         vIJ/szehCg/WbOzm5joK0SJNEiemBwBLOfE+cK7t/H1RMl1rx8oPVkx26c1vGE1t4Krl
         7LefvGjoJY8jQX8a/PdwwKeDyCVq3faUJs/3TWw+CquHLSYo77+v47rVcLs/VxfMiTys
         gOR+Jzb9oJdyz1HIwZ4tM/38Kn4wszl8pz5PkixD5uEV28V5BpwP/pQKgjjle9WoR0g2
         ErStghKeLkAF9eBz3F76hPAubIjFiYSRb8YS8CkVTGRlEeip64ey2qBVrV4rgWWDYQ6r
         uivA==
X-Gm-Message-State: AOAM53030plcenCU//KW6BI6/pNQMU0svx5v3OLHDuIOTIUsuYdbehRt
        zpQ5Qx4LV8j1yuS+RuRT6BU=
X-Google-Smtp-Source: ABdhPJxbQaQ25oYjNeex6xoNRfUoUf05TClF4UYgxJeFvwt7khLZ4z5PZrL5zeGuZsTJEV+UNt2CFw==
X-Received: by 2002:a17:906:1f8e:: with SMTP id t14mr9671367ejr.350.1608407313375;
        Sat, 19 Dec 2020 11:48:33 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id cb14sm7242279ejb.105.2020.12.19.11.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 11:48:32 -0800 (PST)
Date:   Sat, 19 Dec 2020 21:48:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, DENG Qingfang <dqfext@gmail.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Ungerer <gerg@kernel.org>,
        Rene van Dorst <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: rename MT7621 compatible
Message-ID: <20201219194831.5mjlmjfbcpggrh45@skbuf>
References: <20201219162153.23126-1-dqfext@gmail.com>
 <20201219162601.GE3008889@lunn.ch>
 <47673b0d-1da8-d93e-8b56-995a651aa7fd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47673b0d-1da8-d93e-8b56-995a651aa7fd@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew, Florian,

On Sat, Dec 19, 2020 at 09:07:13AM -0800, Florian Fainelli wrote:
> On 12/19/2020 8:26 AM, Andrew Lunn wrote:
> >> --- a/drivers/net/dsa/mt7530.c
> >> +++ b/drivers/net/dsa/mt7530.c
> >> @@ -2688,7 +2688,7 @@ static const struct mt753x_info mt753x_table[] = {
> >>  };
> >>  
> >>  static const struct of_device_id mt7530_of_match[] = {
> >> -	{ .compatible = "mediatek,mt7621", .data = &mt753x_table[ID_MT7621], },
> >> +	{ .compatible = "mediatek,mt7621-gsw", .data = &mt753x_table[ID_MT7621], },
> >>  	{ .compatible = "mediatek,mt7530", .data = &mt753x_table[ID_MT7530], },
> >>  	{ .compatible = "mediatek,mt7531", .data = &mt753x_table[ID_MT7531], },
> >>  	{ /* sentinel */ },
> > 
> > This will break backwards compatibility with existing DT blobs. You
> > need to keep the old "mediatek,mt7621", but please add a comment that
> > it is deprecated.
> 
> Besides, adding -gsw would make it inconsistent with the existing
> matching compatible strings. While it's not ideal to have the same
> top-level SoC compatible and having another sub-node within that SoC's
> DTS have the same compatible, given this would be break backwards
> compatibility, cannot you stay with what is defined today?

The MT7621 device tree is in staging. I suppose that some amount of
breaking changes could be tolerated?

But Qingfang, I'm confused when looking at drivers/staging/mt7621-dts/mt7621.dtsi.

/ethernet@1e100000/mdio-bus {
	switch0: switch0@0 {
		compatible = "mediatek,mt7621";
		#address-cells = <1>;
		#size-cells = <0>;
		reg = <0>;
		mediatek,mcm;
		resets = <&rstctrl 2>;
		reset-names = "mcm";

		ports {
			#address-cells = <1>;
			#size-cells = <0>;
			reg = <0>;
			port@0 {
				status = "off";
				reg = <0>;
				label = "lan0";
			};
			port@1 {
				status = "off";
				reg = <1>;
				label = "lan1";
			};
			port@2 {
				status = "off";
				reg = <2>;
				label = "lan2";
			};
			port@3 {
				status = "off";
				reg = <3>;
				label = "lan3";
			};
			port@4 {
				status = "off";
				reg = <4>;
				label = "lan4";
			};
			port@6 {
				reg = <6>;
				label = "cpu";
				ethernet = <&gmac0>;
				phy-mode = "trgmii";
				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};
		};
	};
};

/ {
	gsw: gsw@1e110000 {
		compatible = "mediatek,mt7621-gsw";
		reg = <0x1e110000 0x8000>;
		interrupt-parent = <&gic>;
		interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
	};
};

What is the platform device at the memory address 1e110000?
There is no driver for it. The documentation only has me even more
confused:

Mediatek Gigabit Switch
=======================

The mediatek gigabit switch can be found on Mediatek SoCs (mt7620, mt7621).

Required properties:
- compatible: Should be "mediatek,mt7620-gsw" or "mediatek,mt7621-gsw"
- reg: Address and length of the register set for the device
- interrupts: Should contain the gigabit switches interrupt
- resets: Should contain the gigabit switches resets
- reset-names: Should contain the reset names "gsw"

Example:

gsw@10110000 {
	compatible = "ralink,mt7620-gsw";     <- notice how even the example is bad and inconsistent
	reg = <0x10110000 8000>;

	resets = <&rstctrl 23>;
	reset-names = "gsw";

	interrupt-parent = <&intc>;
	interrupts = <17>;
};

Does the MT7621 contain two Ethernet switches, one accessed over MMIO
and another over MDIO? Or is it the same switch? I don't understand.
What is the relationship between the new compatible that you're
proposing, Qingfang, and the existing device tree bindings?
