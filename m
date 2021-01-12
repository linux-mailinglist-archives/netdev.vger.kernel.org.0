Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C2F2F2DA0
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 12:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbhALLMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 06:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbhALLMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 06:12:24 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACA4C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 03:11:43 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id d17so2905511ejy.9
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 03:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rm96HKgLAajaM3LG3aeD1RwcZj9WeVs6xvAnoOotQAk=;
        b=ok91CTQFFNQBYVfuPDZrQyAJHfWpkVTezD+YQfzHjOguiDX/P/JEJU8AI+ytKXWmLD
         Bm3+sBEqkcsM9iq285vJXXru0Ik1xINXftbFVUHxkLgmijUdbcWNHPaO0cgfj+wsW6VW
         UyobEFqWpCWy6muumgZAvXPHlw2MmyunKzKwx/UCXDiF1jsgrIHHOm2CPRlmvLggGs4s
         mjF21D0aVJvx6Tgl3T85nn8g14uLKfmQ/Whz5RRA963QQppejvcqFvgr/KoRq6xrFYg0
         gzQDdt9iL7KgPVGfC0WoUIaMbeK89LyAdA2v3HLIp7TARveCTn0oqoYErwOjXwMTAbpa
         bBEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rm96HKgLAajaM3LG3aeD1RwcZj9WeVs6xvAnoOotQAk=;
        b=NWhh6pEn/smDZ68VSyT8A4GMbTxLUSVMnifeOke6AQV9dLQz3wgJEmwhIvfgSyMGZS
         Y+/X4vRiXA2PDnP1Y9oh8vnuURHED7QytWOB+VAg3AJdcud2mTTTucoEVeR7CqbpRpfm
         eTZaCWL1/ZgZrZgUZpKJ5ObvIxTKfxpSK0m5vmAGCe0VwWbbgdZMN865neNN9JqCJcH0
         yFEGXw3w8sqUxGHv6t4uoHBb/GJ79UBi9AvVmYxnTyaY1VOd40sJ/Lv9kk0v6+aiPQZv
         CAHE2ESvLpdxwYbC7fFaiTxr7b4IpyPwk8MciDpKO6JCJkMh1fp7b4IyNNHIGEEUcpoz
         b+Gw==
X-Gm-Message-State: AOAM531Wfp0U8k7DRJ4r+JOdIBMaTP7tJnslc5CkHqhnlqSG8eMT2ZCl
        b0PA4IPxLiKDSYAUEhiRAwQ=
X-Google-Smtp-Source: ABdhPJz67A6FavHeUTibrWih7dbxlhtaXRumxhR8opKVfK2DxLb+cgQLnpLY0Xx8a9mNmrAT6gyjPA==
X-Received: by 2002:a17:906:71ca:: with SMTP id i10mr2706800ejk.528.1610449901779;
        Tue, 12 Jan 2021 03:11:41 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id r16sm1249935edp.43.2021.01.12.03.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 03:11:41 -0800 (PST)
Date:   Tue, 12 Jan 2021 13:11:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v14 5/6] net: dsa: mv88e6xxx: Add support for
 mv88e6393x family of Marvell
Message-ID: <20210112111139.hp56x5nzgadqlthw@skbuf>
References: <20210111012156.27799-1-kabel@kernel.org>
 <20210111012156.27799-6-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210111012156.27799-6-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 02:21:55AM +0100, Marek Behún wrote:
> From: Pavana Sharma <pavana.sharma@digi.com>
> 
> The Marvell 88E6393X device is a single-chip integration of a 11-port
> Ethernet switch with eight integrated Gigabit Ethernet (GbE)
> transceivers and three 10-Gigabit interfaces.
> 
> This patch adds functionalities specific to mv88e6393x family (88E6393X,
> 88E6193X and 88E6191X).
> 
> The main differences between previous devices and this one are:
> - port 0 can be a SERDES port
> - all SERDESes are one-lane, eg. no XAUI nor RXAUI
> - on the other hand the SERDESes can do USXGMII, 10GBASER and 5GBASER
>   (on 6191X only one SERDES is capable of more than 1g; USXGMII is not
>   yet supported with this change)
> - Port Policy CTL register is changed to Port Policy MGMT CTL register,
>   via which serveral more registers can be accessed indirectly
              ~~~~~~~~
              several
> - egress monitor port is configured differently
> - ingress monitor/CPU/mirror ports are configured differently and can be
>   configured per port (ie. each port can have different ingress monitor
>   port, for example)
> - port speed AltBit works differently than previously
> - PHY registers can be also accessed via MDIO address 0x18 and 0x19
>   (on previous devices they could be accessed only via Global 2 offsets
>    0x18 and 0x19, which means two indirections; this feature is not yet
>    leveraged with this patch)
> 
> Co-developed-by: Ashkan Boldaji <ashkan.boldaji@digi.com>
> Signed-off-by: Ashkan Boldaji <ashkan.boldaji@digi.com>
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
> Co-developed-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
> +static void mv88e6393x_phylink_validate(struct mv88e6xxx_chip *chip, int port,
> +					unsigned long *mask,
> +					struct phylink_link_state *state)
> +{
> +	if (port == 0 || port == 9 || port == 10) {
> +		phylink_set(mask, 10000baseT_Full);
> +		phylink_set(mask, 10000baseKR_Full);

I think I understand the reason for declaring 10GBase-KR support in
phylink_validate, in case the PHY supports that link mode on the media
side, but...

> +		phylink_set(mask, 10000baseCR_Full);
> +		phylink_set(mask, 10000baseSR_Full);
> +		phylink_set(mask, 10000baseLR_Full);
> +		phylink_set(mask, 10000baseLRM_Full);
> +		phylink_set(mask, 10000baseER_Full);
> +		phylink_set(mask, 5000baseT_Full);
> +		phylink_set(mask, 2500baseX_Full);
> +		phylink_set(mask, 2500baseT_Full);
> +	}
> +
> +	phylink_set(mask, 1000baseT_Full);
> +	phylink_set(mask, 1000baseX_Full);
> +
> +	mv88e6065_phylink_validate(chip, port, mask, state);
> +}
> +
> @@ -450,6 +559,9 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
>  	case PHY_INTERFACE_MODE_2500BASEX:
>  		cmode = MV88E6XXX_PORT_STS_CMODE_2500BASEX;
>  		break;
> +	case PHY_INTERFACE_MODE_5GBASER:
> +		cmode = MV88E6393X_PORT_STS_CMODE_5GBASER;
> +		break;
>  	case PHY_INTERFACE_MODE_XGMII:
>  	case PHY_INTERFACE_MODE_XAUI:
>  		cmode = MV88E6XXX_PORT_STS_CMODE_XAUI;
> @@ -457,6 +569,10 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
>  	case PHY_INTERFACE_MODE_RXAUI:
>  		cmode = MV88E6XXX_PORT_STS_CMODE_RXAUI;
>  		break;
> +	case PHY_INTERFACE_MODE_10GBASER:
> +	case PHY_INTERFACE_MODE_10GKR:

Does the SERDES actually support 10GBase-KR (aka 10GBase-R for copper
backplanes)? It is different than plain 10GBase-R (abusingly called XFI)
by the need of a link training procedure to negotiate SERDES eye
parameters. There have been discussion in the past where it turned out
that drivers which didn't really support 10GBase-KR incorrectly reported
that they did.

> +		cmode = MV88E6393X_PORT_STS_CMODE_10GBASER;
> +		break;
>  	default:
>  		cmode = 0;
>  	}
> @@ -541,6 +657,29 @@ int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
>  	return mv88e6xxx_port_set_cmode(chip, port, mode, false);
>  }
>  
> +int mv88e6393x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
> +			      phy_interface_t mode)
> +{
> +	int err;
> +	u16 reg;
> +
> +	if (port != 0 && port != 9 && port != 10)
> +		return -EOPNOTSUPP;
> +
> +	/* mv88e6393x errata 4.5: EEE should be disabled on SERDES ports */
> +	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_MAC_CTL, &reg);
> +	if (err)
> +		return err;
> +
> +	reg &= ~MV88E6XXX_PORT_MAC_CTL_EEE;
> +	reg |= MV88E6XXX_PORT_MAC_CTL_FORCE_EEE;
> +	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_MAC_CTL, reg);
> +	if (err)
> +		return err;
> +
> +	return mv88e6xxx_port_set_cmode(chip, port, mode, false);
> +}
> +
>  static int mv88e6341_port_set_cmode_writable(struct mv88e6xxx_chip *chip,
>  					     int port)
>  {
> @@ -1164,6 +1303,135 @@ int mv88e6xxx_port_disable_pri_override(struct mv88e6xxx_chip *chip, int port)
>  	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_PRI_OVERRIDE, 0);
>  }
>  
> +/* Offset 0x0E: Policy & MGMT Control Register for FAMILY 6191X 6193X 6393X */
> +
> +static int mv88e6393x_port_policy_write(struct mv88e6xxx_chip *chip, int port,
> +					u16 pointer, u8 data)
> +{
> +	u16 reg;
> +
> +	reg = MV88E6393X_PORT_POLICY_MGMT_CTL_UPDATE | pointer | data;

I think the assignment fits on the same line as the declaration?

> +
> +	return mv88e6xxx_port_write(chip, port, MV88E6393X_PORT_POLICY_MGMT_CTL,
> +				    reg);
> +}
> +
> +int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip)
> +{
> +	int err;
> +
> +	err = mv88e6393x_serdes_port_errata(chip, MV88E6393X_PORT0_LANE);
> +	if (err)
> +		return err;
> +
> +	err = mv88e6393x_serdes_port_errata(chip, MV88E6393X_PORT9_LANE);
> +	if (err)
> +		return err;
> +
> +	return mv88e6393x_serdes_port_errata(chip, MV88E6393X_PORT10_LANE);
> +}
> +
> +static int mv88e6393x_serdes_port_config(struct mv88e6xxx_chip *chip, int lane,
> +					 bool on)
> +{
> +	u8 cmode = chip->ports[lane].cmode;
> +	u16 reg, pcs;
> +	int err;
> +
> +	if (on) {

And if "on" is false? Nothing? Why even pass it as an argument then? Why
even call mv88e6393x_serdes_port_config?

> +		switch (cmode) {
> +		case MV88E6XXX_PORT_STS_CMODE_SGMII:
> +			pcs = MV88E6393X_PCS_SELECT_SGMII_MAC;
> +			break;
> +		case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
> +			pcs = MV88E6393X_PCS_SELECT_1000BASEX;
> +			break;
> +		case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
> +			pcs = MV88E6393X_PCS_SELECT_2500BASEX;
> +			break;
> +		case MV88E6393X_PORT_STS_CMODE_5GBASER:
> +			pcs = MV88E6393X_PCS_SELECT_5GBASER;
> +			break;
> +		case MV88E6393X_PORT_STS_CMODE_10GBASER:
> +			pcs = MV88E6393X_PCS_SELECT_10GBASER;
> +			break;
> +		default:
> +			pcs = MV88E6393X_PCS_SELECT_1000BASEX;
> +			break;
> +		}
> +
> +		/* mv88e6393x family errata 3.6 :
> +		 * When changing c_mode on Port 0 from [x]MII mode to any
> +		 * SERDES mode SERDES will not be operational.
> +		 * Workaround: Set Port0 SERDES register 4.F002.5=0
> +		 */
> +		err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> +					    MV88E6393X_SERDES_POC, &reg);
> +		if (err)
> +			return err;
> +
> +		reg &= ~(MV88E6393X_SERDES_POC_PCS_MODE_MASK |
> +			 MV88E6393X_SERDES_POC_PDOWN);
> +		reg |= pcs;
> +
> +		err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +					     MV88E6393X_SERDES_POC, reg);
> +		if (err)
> +			return err;
> +
> +		reg |= MV88E6393X_SERDES_POC_RESET;
> +		err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +					     MV88E6393X_SERDES_POC, reg);
> +		if (err)
> +			return err;
> +
> +		/* mv88e6393x family errata 3.7 :
> +		 * When changing cmode on SERDES port from any other mode to
> +		 * 1000BASE-X mode the link may not come up due to invalid
> +		 * 1000BASE-X advertisement.
> +		 * Workaround: Correct advertisement and reset PHY core.
> +		 */
> +		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX) {
> +			reg = MV88E6390_SGMII_ANAR_1000BASEX_FD;
> +			err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +						     MV88E6390_SGMII_ANAR, reg);
> +			if (err)
> +				return err;
> +
> +			/* soft reset the PCS/PMA */
> +			err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> +						    MV88E6390_SGMII_CONTROL,
> +						    &reg);
> +			if (err)
> +				return err;
> +
> +			reg |= MV88E6390_SGMII_CONTROL_RESET;
> +			err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
> +						     MV88E6390_SGMII_CONTROL,
> +						     reg);
> +			if (err)
> +				return err;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
> +			    bool on)
> +{
> +	u8 cmode = chip->ports[port].cmode;
> +
> +	if (port != 0 && port != 9 && port != 10)
> +		return -EOPNOTSUPP;
> +
> +	mv88e6393x_serdes_port_config(chip, lane, on);
> +
> +	switch (cmode) {
> +	case MV88E6XXX_PORT_STS_CMODE_SGMII:
> +	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
> +	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
> +		return mv88e6390_serdes_power_sgmii(chip, lane, on);
> +	case MV88E6393X_PORT_STS_CMODE_5GBASER:
> +	case MV88E6393X_PORT_STS_CMODE_10GBASER:
> +		return mv88e6390_serdes_power_10g(chip, lane, on);
> +	}
> +
> +	return 0;
> +}
