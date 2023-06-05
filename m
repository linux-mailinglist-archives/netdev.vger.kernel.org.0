Return-Path: <netdev+bounces-8123-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6A67722D0E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D79C1C209E8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0F4AD2E;
	Mon,  5 Jun 2023 16:55:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CED6FC3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 16:55:06 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C81ED;
	Mon,  5 Jun 2023 09:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Nz2J/bwtKc0aEbaVyuCdq9HnDgrG5qLQb6/kIur5eQk=; b=ZLuS3EKRiTYOeN8DIGQ9GOdfZo
	+ddiaMO9JTPMnOxfgFfKolLOt3OoB0g7u+QUrg/LytYidE1lDL3l8K7wTjwbQXBxTnDUxaC68ytKf
	OsJCj9b943XZdCGYFwR1sRKxvQRmsyVQ/8daNMzW1KGEbew0hMcac3Sz0Ml8SQTYACOGvLUX6h0QU
	9PQtoVQnbnfQjk7qsW4NagEXxqB+lzTAJulISI7uhN3DBwgQy1vvAvfBSBe24cShn7c6pZaSd0J5u
	JKvC6lwv+UUTkbXqxNd7rFTp0UtDTgTip0cNcuZLajzX6DjEVavbI2zeyPObkBFe3xGS6uw43GfRx
	4e40KstA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54450)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q6DTr-0004Kz-Ar; Mon, 05 Jun 2023 17:54:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q6DTo-0006G9-Jk; Mon, 05 Jun 2023 17:54:52 +0100
Date: Mon, 5 Jun 2023 17:54:52 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: msmulski2@gmail.com
Cc: andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, simon.horman@corigine.com,
	kabel@kernel.org, ioana.ciornei@nxp.com,
	Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v7 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Message-ID: <ZH4TXJbjlDgYWcVJ@shell.armlinux.org.uk>
References: <20230605053954.4051-1-msmulski2@gmail.com>
 <20230605053954.4051-2-msmulski2@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605053954.4051-2-msmulski2@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 10:39:54PM -0700, msmulski2@gmail.com wrote:
> From: Michal Smulski <michal.smulski@ooma.com>
> 
> Enable USXGMII mode for mv88e6393x chips. Tested on Marvell 88E6191X.
> 
> Signed-off-by: Michal Smulski <michal.smulski@ooma.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c   |  3 +-
>  drivers/net/dsa/mv88e6xxx/port.c   |  3 ++
>  drivers/net/dsa/mv88e6xxx/serdes.c | 47 ++++++++++++++++++++++++++++--
>  drivers/net/dsa/mv88e6xxx/serdes.h |  4 +++
>  4 files changed, 53 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 2af0c1145d36..8b51756bd805 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -812,11 +812,10 @@ static void mv88e6393x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
>  			if (!is_6361) {
>  				__set_bit(PHY_INTERFACE_MODE_5GBASER, supported);
>  				__set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
> +				__set_bit(PHY_INTERFACE_MODE_USXGMII, supported);
>  				config->mac_capabilities |= MAC_5000FD |
>  					MAC_10000FD;
>  			}
> -			/* FIXME: USXGMII is not supported yet */
> -			/* __set_bit(PHY_INTERFACE_MODE_USXGMII, supported); */
>  		}
>  	}
>  
> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
> index e9b4a6ea4d09..dd66ec902d4c 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.c
> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> @@ -566,6 +566,9 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
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
> index 72faec8f44dc..a28b368ed016 100644
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
> @@ -984,7 +985,42 @@ static int mv88e6393x_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
>  			state->speed = SPEED_10000;
>  		state->duplex = DUPLEX_FULL;
>  	}
> +	return 0;
> +}
> +
> +/* USXGMII registers for Marvell switch 88e639x are undocumented and this function is based
> + * on some educated guesses. It appears that there are no status bits related to
> + * autonegotiation complete or flow control.
> + */
> +static int mv88e639x_serdes_pcs_get_state_usxgmii(struct mv88e6xxx_chip *chip,
> +						  int port, int lane,
> +						  struct phylink_link_state *state)
> +{
> +	u16 status, lp_status;
> +	int err;
> +
> +	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> +				    MV88E6390_USXGMII_PHY_STATUS, &status);
> +	if (err) {
> +		dev_err(chip->dev, "can't read Serdes USXGMII PHY status: %d\n", err);
> +		return err;
> +	}
> +	dev_dbg(chip->dev, "USXGMII PHY status: 0x%x\n", status);
> +
> +	state->link = !!(status & MDIO_USXGMII_LINK);
> +	state->an_complete = state->link;
> +
> +	if (state->link) {
> +		err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> +					    MV88E6390_USXGMII_LP_STATUS, &lp_status);
> +		if (err) {
> +			dev_err(chip->dev, "can't read Serdes USXGMII LP status: %d\n", err);
> +			return err;
> +		}
> +		dev_dbg(chip->dev, "USXGMII LP status: 0x%x\n", lp_status);
> 

Please put a comment here that lp_status appears to include the "link"
bit as per USXGMII spec.

We don't know about pcs-lynx yet, which doesn't _seem_ to with the
AR113C, and we don't know why - if we made phylink_decode_usxgmii_word()
parse this bit as well, we need to keep track of which implementations
do provide that bit and which do not (and may be buggy.)

> +		phylink_decode_usxgmii_word(state, lp_status);
> +	}
>  	return 0;
>  }
>  
> @@ -1020,6 +1056,9 @@ int mv88e6393x_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
>  	case PHY_INTERFACE_MODE_10GBASER:
>  		return mv88e6393x_serdes_pcs_get_state_10g(chip, port, lane,
>  							   state);
> +	case PHY_INTERFACE_MODE_USXGMII:
> +		return mv88e639x_serdes_pcs_get_state_usxgmii(chip, port, lane,
> +							   state);
>  
>  	default:
>  		return -EOPNOTSUPP;
> @@ -1173,6 +1212,7 @@ int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
>  		return mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
>  	case MV88E6393X_PORT_STS_CMODE_5GBASER:
>  	case MV88E6393X_PORT_STS_CMODE_10GBASER:
> +	case MV88E6393X_PORT_STS_CMODE_USXGMII:
>  		return mv88e6393x_serdes_irq_enable_10g(chip, lane, enable);
>  	}
>  
> @@ -1213,6 +1253,7 @@ irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
>  		break;
>  	case MV88E6393X_PORT_STS_CMODE_5GBASER:
>  	case MV88E6393X_PORT_STS_CMODE_10GBASER:
> +	case MV88E6393X_PORT_STS_CMODE_USXGMII:
>  		err = mv88e6393x_serdes_irq_status_10g(chip, lane, &status);
>  		if (err)
>  			return err;
> @@ -1477,7 +1518,8 @@ static int mv88e6393x_serdes_erratum_5_2(struct mv88e6xxx_chip *chip, int lane,
>  	 * to SERDES operating in 10G mode. These registers only apply to 10G
>  	 * operation and have no effect on other speeds.
>  	 */
> -	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER)
> +	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER &&
> +	    cmode != MV88E6393X_PORT_STS_CMODE_USXGMII)
>  		return 0;
>  
>  	for (i = 0; i < ARRAY_SIZE(fixes); ++i) {
> @@ -1582,6 +1624,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
>  		break;
>  	case MV88E6393X_PORT_STS_CMODE_5GBASER:
>  	case MV88E6393X_PORT_STS_CMODE_10GBASER:
> +	case MV88E6393X_PORT_STS_CMODE_USXGMII:
>  		err = mv88e6390_serdes_power_10g(chip, lane, on);
>  		break;
>  	default:
> diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
> index 29bb4e91e2f6..e245687ddb1d 100644
> --- a/drivers/net/dsa/mv88e6xxx/serdes.h
> +++ b/drivers/net/dsa/mv88e6xxx/serdes.h
> @@ -48,6 +48,10 @@
>  #define MV88E6393X_10G_INT_LINK_CHANGE	BIT(2)
>  #define MV88E6393X_10G_INT_STATUS	0x9001
>  
> +/* USXGMII */
> +#define MV88E6390_USXGMII_LP_STATUS       0xf0a2
> +#define MV88E6390_USXGMII_PHY_STATUS      0xf0a6
> +
>  /* 1000BASE-X and SGMII */
>  #define MV88E6390_SGMII_BMCR		(0x2000 + MII_BMCR)
>  #define MV88E6390_SGMII_BMSR		(0x2000 + MII_BMSR)
> -- 
> 2.34.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

