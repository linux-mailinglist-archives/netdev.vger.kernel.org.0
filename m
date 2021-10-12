Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53AD42A50C
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236619AbhJLNGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbhJLNGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:06:40 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1A3C061570;
        Tue, 12 Oct 2021 06:04:38 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id d3so53215463edp.3;
        Tue, 12 Oct 2021 06:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=l3Hoe13dJbudIg5KGzsRSzJTtfXPYL9K9pjGIGdMZbs=;
        b=J4johUiGmNcBLEd+ZeGKs39Ax6a1M9HjBIdgJsF3wUc1f6d4rVpS6Sjpk/5E3Wc+x+
         j9V40IjdcNPXDDuwA4ITVBYOCK4F27c/DSJZkoMxIGApUp+CI4Q5Upv5YV8mDwfV/6b1
         YScrvwDFUmerTwA/5ABQPUSSb2Y0HqiCLUrMAtW94538Jwbbu+Dm92eJpmUASrMa6Qli
         l3Tqbpgu2VwLDN+Sdc9vO3Xnd4yVo21MOPqC5n+fMfoJ5PTL3TmWw1rFbOYpoSxQxMjK
         Ee4ZcJ0o+pkW+7zbw8el3wv9VbHLYJcRUPcqMlyF1ag9nABlaUs0yeHsKfsdCnnohfpI
         ODDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=l3Hoe13dJbudIg5KGzsRSzJTtfXPYL9K9pjGIGdMZbs=;
        b=Wj5a8NO8oSQ/6iqI4z9bgeFV4Dkfuo/A6cqCRTYBVoKrqzk3xVfwxjqLakfrtt7SC8
         jiOCFjyJc0qA8xeCskitIfpALaNzHuZHHc8Rtv6o4fbbxwbc7oR0pY9UbWJImP++5R1j
         Zf988Nx+vRcdygbaKnb9GEEBCTsVJJX9yLli4rWzkikqorwojUu/u3sdiLHXpWO7tgSg
         eoT4Tv8jK0xGLWfbv3f6WZ6hrBI99kYSYoMY808/4cuQz1YJdMH4LiX7KBckso5Vz2sC
         aUmDkPqkffMMkoomk11THzaDCeHvMBRzJ2jhpMUOliyV5FiU+cOwjebG1Vqk8lnzISRm
         qvAA==
X-Gm-Message-State: AOAM532aPcGlHM7MT8GHvJ7Zoo/QVDB8b84e8mcTLWNt6Hlqg/q2ojKN
        CHx4lskgOKmzQCPMoQgLuG0=
X-Google-Smtp-Source: ABdhPJzsKh8tMs8xjAZ4kv8fjA4j5MvRcF0OA3z3MKEwrxH/TJ/2xshKS+1vHC4hLPajinS5dFWaoQ==
X-Received: by 2002:a50:cf4d:: with SMTP id d13mr49408623edk.50.1634043871347;
        Tue, 12 Oct 2021 06:04:31 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id p8sm4912533ejo.2.2021.10.12.06.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 06:04:30 -0700 (PDT)
Date:   Tue, 12 Oct 2021 16:04:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Message-ID: <20211012130429.chiqugd57xoqf6hd@skbuf>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
 <20211012123557.3547280-6-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211012123557.3547280-6-alvin@pqrs.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 02:35:54PM +0200, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> This patch adds a realtek-smi subdriver for the RTL8365MB-VC 4+1 port
> 10/100/1000M switch controller. The driver has been developed based on a
> GPL-licensed OS-agnostic Realtek vendor driver known as rtl8367c found
> in the OpenWrt source tree.
> 
> Despite the name, the RTL8365MB-VC has an entirely different register
> layout to the already-supported RTL8366RB ASIC. Notwithstanding this,
> the structure of the rtl8365mb subdriver is based on the rtl8366rb
> subdriver and makes use of the rtl8366 helper library for setup of the
> SMI interface and handling of MIB counters. Like the 'rb, it establishes
> its own irqchip to handle cascaded PHY link status interrupts.
> 
> The RTL8365MB-VC switch is capable of offloading a large number of
> features from the software, but this patch introduces only the most
> basic DSA driver functionality. The ports always function as standalone
> ports, with bridging handled in software.
> 
> One more thing. Realtek's nomenclature for switches makes it hard to
> know exactly what other ASICs might be supported by this driver. The
> vendor driver goes by the name rtl8367c, but as far as I can tell, no
> chip actually exists under this name. As such, the subdriver is named
> rtl8365mb to emphasize the potentially limited support. But it is clear
> from the vendor sources that a number of other more advanced switches
> share a similar register layout, and further support should not be too
> hard to add given access to the relevant hardware. With this in mind,
> the subdriver has been written with as few assumptions about the
> particular chip as is reasonable. But the RTL8365MB-VC is the only
> hardware I have available, so some further work is surely needed.
> 
> Co-developed-by: Michael Rasmussen <mir@bang-olufsen.dk>
> Signed-off-by: Michael Rasmussen <mir@bang-olufsen.dk>
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Just one comment below

> +static int rtl8365mb_ext_config_rgmii(struct realtek_smi *smi, int port,
> +				      phy_interface_t interface)
> +{
> +	int tx_delay = 0;
> +	int rx_delay = 0;
> +	int ext_port;
> +	int ret;
> +
> +	if (port == smi->cpu_port) {
> +		ext_port = PORT_NUM_L2E(port);
> +	} else {
> +		dev_err(smi->dev, "only one EXT port is currently supported\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Set the RGMII TX/RX delay
> +	 *
> +	 * The Realtek vendor driver indicates the following possible
> +	 * configuration settings:
> +	 *
> +	 *   TX delay:
> +	 *     0 = no delay, 1 = 2 ns delay
> +	 *   RX delay:
> +	 *     0 = no delay, 7 = maximum delay
> +	 *     No units are specified, but there are a total of 8 steps.
> +	 *
> +	 * The vendor driver also states that this must be configured *before*
> +	 * forcing the external interface into a particular mode, which is done
> +	 * in the rtl8365mb_phylink_mac_link_{up,down} functions.
> +	 *
> +	 * NOTE: For now this is hardcoded to tx_delay = 1, rx_delay = 4.
> +	 */
> +	if (interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    interface == PHY_INTERFACE_MODE_RGMII_TXID)
> +		tx_delay = 1; /* 2 ns */
> +
> +	if (interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    interface == PHY_INTERFACE_MODE_RGMII_RXID)
> +		rx_delay = 4;

There is this ongoing discussion that we have been interpreting the
meaning of "phy-mode" incorrectly for RGMII all along. The conclusion
seems to be that for a PHY driver, it is okay to configure its internal
delay lines based on the value of the phy-mode string, but for a MAC
driver it is not. The only viable option for a MAC driver to configure
its internal delays is based on parsing some new device tree properties
called rx-internal-delay-ps and tx-internal-delay-ps.
Since you do not seem to have any baggage to support here (new driver),
could you please just accept any PHY_INTERFACE_MODE_RGMII* value and
apply delays (or not) based on those other OF properties?
https://patchwork.kernel.org/project/netdevbpf/patch/20210723173108.459770-6-prasanna.vengateshan@microchip.com/

> +
> +	ret = regmap_update_bits(
> +		smi->map, RTL8365MB_EXT_RGMXF_REG(ext_port),
> +		RTL8365MB_EXT_RGMXF_TXDELAY_MASK |
> +			RTL8365MB_EXT_RGMXF_RXDELAY_MASK,
> +		FIELD_PREP(RTL8365MB_EXT_RGMXF_TXDELAY_MASK, tx_delay) |
> +			FIELD_PREP(RTL8365MB_EXT_RGMXF_RXDELAY_MASK, rx_delay));
> +	if (ret)
> +		return ret;
> +
> +	ret = regmap_update_bits(
> +		smi->map, RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(ext_port),
> +		RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(ext_port),
> +		RTL8365MB_EXT_PORT_MODE_RGMII
> +			<< RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(
> +				   ext_port));
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}

> +static void rtl8365mb_phylink_mac_config(struct dsa_switch *ds, int port,
> +					 unsigned int mode,
> +					 const struct phylink_link_state *state)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +	int ret;
> +
> +	if (!rtl8365mb_phy_mode_supported(ds, port, state->interface)) {
> +		dev_err(smi->dev, "phy mode %s is unsupported on port %d\n",
> +			phy_modes(state->interface), port);
> +		return;
> +	}
> +
> +	/* If port MAC is connected to an internal PHY, we have nothing to do */
> +	if (dsa_is_user_port(ds, port))
> +		return;
> +
> +	if (mode != MLO_AN_PHY && mode != MLO_AN_FIXED) {
> +		dev_err(smi->dev,
> +			"port %d supports only conventional PHY or fixed-link\n",
> +			port);
> +		return;
> +	}
> +
> +	if (phy_interface_mode_is_rgmii(state->interface)) {
> +		ret = rtl8365mb_ext_config_rgmii(smi, port, state->interface);
> +		if (ret)
> +			dev_err(smi->dev,
> +				"failed to configure RGMII mode on port %d: %d\n",
> +				port, ret);
> +		return;
> +	}
> +
> +	/* TODO: Implement MII and RMII modes, which the RTL8365MB-VC also
> +	 * supports
> +	 */
> +}
> +
> +static void rtl8365mb_phylink_mac_link_down(struct dsa_switch *ds, int port,
> +					    unsigned int mode,
> +					    phy_interface_t interface)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +	int ret;
> +
> +	if (dsa_is_cpu_port(ds, port)) {

I assume the "dsa_is_cpu_port()" check here can also be replaced with
"phy_interface_mode_is_rgmii(interface)"? Can you please do that for
consistency?

> +		ret = rtl8365mb_ext_config_forcemode(smi, port, false, 0, 0,
> +						     false, false);
> +		if (ret)
> +			dev_err(smi->dev,
> +				"failed to reset forced mode on port %d: %d\n",
> +				port, ret);
> +
> +		return;
> +	}
> +}
> +
> +static void rtl8365mb_phylink_mac_link_up(struct dsa_switch *ds, int port,
> +					  unsigned int mode,
> +					  phy_interface_t interface,
> +					  struct phy_device *phydev, int speed,
> +					  int duplex, bool tx_pause,
> +					  bool rx_pause)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +	int ret;
> +
> +	if (dsa_is_cpu_port(ds, port)) {

and here

> +		ret = rtl8365mb_ext_config_forcemode(smi, port, true, speed,
> +						     duplex, tx_pause,
> +						     rx_pause);
> +		if (ret)
> +			dev_err(smi->dev,
> +				"failed to force mode on port %d: %d\n", port,
> +				ret);
> +
> +		return;
> +	}
> +}
