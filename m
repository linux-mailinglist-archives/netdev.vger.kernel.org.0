Return-Path: <netdev+bounces-5947-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A6217138E1
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 11:31:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CA041C20990
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 09:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5A4917F1;
	Sun, 28 May 2023 09:31:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB30137A
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 09:31:43 +0000 (UTC)
X-Greylist: delayed 375 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 28 May 2023 02:31:41 PDT
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B0CB9
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 02:31:41 -0700 (PDT)
Received: from kandell (unknown [172.20.6.130])
	by mail.nic.cz (Postfix) with ESMTPS id 1DE191C137A;
	Sun, 28 May 2023 11:25:23 +0200 (CEST)
Authentication-Results: mail.nic.cz;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
	t=1685265923; bh=8QJmHZMSPk5TLooykhr7Evo9yBJlCwO92/ZwbQYku+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Reply-To:
	 Subject:To:Cc;
	b=ga/Gmg85JxTpS4YkniwrU+4RTLRfpqGQ3sf0YCVwsUXSpnOPkHNw2i1TTcdOM72K6
	 WpxdxGUc/0EoDFIilTaw2By71usdNOA1Bs0j7u6GI22U+pbBZmSxxrWxCWvILfitCo
	 OHFMCEcpVtO1J7j2YRtK35WTC5R+hjZZT6KUUmXg=
Date: Sun, 28 May 2023 11:25:22 +0200
From: Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>
To: Michal Smulski <msmulski2@gmail.com>
Cc: andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
	netdev@vger.kernel.org, Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v2] net: dsa: mv88e6xxx: implement USXGMII mode
 for mv88e6393x
Message-ID: <20230528092522.47enrnrslgflovmx@kandell>
References: <20230527172024.9154-1-michal.smulski@ooma.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230527172024.9154-1-michal.smulski@ooma.com>
X-Virus-Scanned: clamav-milter 0.103.7 at mail
X-Virus-Status: Clean
X-Spamd-Result: default: False [-0.10 / 20.00];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FROM_EQ_ENVFROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	WHITELISTED_IP(0.00)[172.20.6.130];
	MIME_TRACE(0.00)[0:+]
X-Rspamd-Action: no action
X-Rspamd-Server: mail
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Rspamd-Queue-Id: 1DE191C137A
X-Spamd-Bar: /
X-Rspamd-Pre-Result: action=no action;
	module=multimap;
	Matched map: WHITELISTED_IP
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

You need also to implement serdes_pcs_get_state for USXGMII.

Preferably by adding USXGMII relevant register constants into
include/uapi/linux/mii.h, and using them to parse state register.

Marek

On Sat, May 27, 2023 at 10:20:24AM -0700, Michal Smulski wrote:
> Enable USXGMII mode for mv88e6393x chips. Tested on Marvell 88E6191X.
> 
> Signed-off-by: Michal Smulski <michal.smulski@ooma.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c   |  3 +--
>  drivers/net/dsa/mv88e6xxx/port.c   |  3 +++
>  drivers/net/dsa/mv88e6xxx/serdes.c | 10 ++++++++--
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 5bbe95fa951c..71cee154622f 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -806,8 +806,7 @@ static void mv88e6393x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
>  			__set_bit(PHY_INTERFACE_MODE_2500BASEX, supported);
>  			__set_bit(PHY_INTERFACE_MODE_5GBASER, supported);
>  			__set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
> -			/* FIXME: USXGMII is not supported yet */
> -			/* __set_bit(PHY_INTERFACE_MODE_USXGMII, supported); */
> +			__set_bit(PHY_INTERFACE_MODE_USXGMII, supported);
>  
>  			config->mac_capabilities |= MAC_2500FD | MAC_5000FD |
>  				MAC_10000FD;
> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
> index f79cf716c541..8daeeeb66880 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.c
> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> @@ -554,6 +554,9 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
>  	case PHY_INTERFACE_MODE_10GBASER:
>  		cmode = MV88E6393X_PORT_STS_CMODE_10GBASER;
>  		break;
> +	case PHY_INTERFACE_MODE_USXGMII:
> +		cmode = MV88E6393X_PORT_STS_CMODE_USXGMII;
> +		break;
>  	default:
>  		cmode = 0;
>  	}
> diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
> index 72faec8f44dc..ae051d383c7e 100644
> --- a/drivers/net/dsa/mv88e6xxx/serdes.c
> +++ b/drivers/net/dsa/mv88e6xxx/serdes.c
> @@ -683,7 +683,8 @@ int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
>  	    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
>  	    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
>  	    cmode == MV88E6393X_PORT_STS_CMODE_5GBASER ||
> -	    cmode == MV88E6393X_PORT_STS_CMODE_10GBASER)
> +	    cmode == MV88E6393X_PORT_STS_CMODE_10GBASER ||
> +	    cmode == MV88E6393X_PORT_STS_CMODE_USXGMII)
>  		lane = port;
>  
>  	return lane;
> @@ -1018,6 +1019,7 @@ int mv88e6393x_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
>  							    state);
>  	case PHY_INTERFACE_MODE_5GBASER:
>  	case PHY_INTERFACE_MODE_10GBASER:
> +	case PHY_INTERFACE_MODE_USXGMII:
>  		return mv88e6393x_serdes_pcs_get_state_10g(chip, port, lane,
>  							   state);
>  
> @@ -1173,6 +1175,7 @@ int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
>  		return mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
>  	case MV88E6393X_PORT_STS_CMODE_5GBASER:
>  	case MV88E6393X_PORT_STS_CMODE_10GBASER:
> +	case MV88E6393X_PORT_STS_CMODE_USXGMII:
>  		return mv88e6393x_serdes_irq_enable_10g(chip, lane, enable);
>  	}
>  
> @@ -1213,6 +1216,7 @@ irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
>  		break;
>  	case MV88E6393X_PORT_STS_CMODE_5GBASER:
>  	case MV88E6393X_PORT_STS_CMODE_10GBASER:
> +	case MV88E6393X_PORT_STS_CMODE_USXGMII:
>  		err = mv88e6393x_serdes_irq_status_10g(chip, lane, &status);
>  		if (err)
>  			return err;
> @@ -1477,7 +1481,8 @@ static int mv88e6393x_serdes_erratum_5_2(struct mv88e6xxx_chip *chip, int lane,
>  	 * to SERDES operating in 10G mode. These registers only apply to 10G
>  	 * operation and have no effect on other speeds.
>  	 */
> -	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER)
> +	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER &&
> +	    cmode != MV88E6393X_PORT_STS_CMODE_USXGMII)
>  		return 0;
>  
>  	for (i = 0; i < ARRAY_SIZE(fixes); ++i) {
> @@ -1582,6 +1587,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
>  		break;
>  	case MV88E6393X_PORT_STS_CMODE_5GBASER:
>  	case MV88E6393X_PORT_STS_CMODE_10GBASER:
> +	case MV88E6393X_PORT_STS_CMODE_USXGMII:
>  		err = mv88e6390_serdes_power_10g(chip, lane, on);
>  		break;
>  	default:
> -- 
> 2.34.1
> 
> 

