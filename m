Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0CD641E23
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 18:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiLDRHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 12:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiLDRHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 12:07:03 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9A115707;
        Sun,  4 Dec 2022 09:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aje2W4ubBTbg5RKsme7Pz+uXVNf40+64ODTmeSaX8iw=; b=DLueQkQ0AA3k7VI3Ngh4LJsBQx
        7JGa6erNNcNtcs8P9HzvyAG1NyrvlHOMQJt1loSsvHsw92nmXKJ+ykxf8AGlAMUSTH1zOqMpCyRyW
        6UFO7Z3Cuw3Bgn7DD23LiRdd1nJTFOge2NH5I0m9sVMawK+Cv/nFnIERGTejSXuSelbVTy+N5F250
        WVhtMfoP7wvbzpL3B1mHBMuESXNU/YXFUz3hOM7b31PDRYFRe7AxwwzoFutRG3NLsDqsnQovqRaeP
        OhZVCGUkO+qMIHwEoWywV83jOEejKDmjUPqs+BRfCcIPNqS0dhBKRuGHFYLDtiSQXFjWMz+1i9EIb
        YDuQk2tQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35564)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p1sS4-0005vx-BN; Sun, 04 Dec 2022 17:06:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p1sS2-0006Qq-U9; Sun, 04 Dec 2022 17:06:50 +0000
Date:   Sun, 4 Dec 2022 17:06:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 4/4] driver/ncn26000: add PLCA support
Message-ID: <Y4zTqvSxLJG+G8V+@shell.armlinux.org.uk>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <38623984f6235a1521e6b0ad2ea958abc84ad708.1670119328.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38623984f6235a1521e6b0ad2ea958abc84ad708.1670119328.git.piergiorgio.beruto@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 03:32:06AM +0100, Piergiorgio Beruto wrote:
> This patch adds PLCA support to the ncn26000 driver. Also add helper
> functions to read/write standard OPEN Alliance PLCA registers to
> phylib (genphy_c45_plca_get_cfg, genphy_c45_plca_set_cfg,
> genphy_c45_plca_get_status).
> 
> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> ---
>  drivers/net/phy/ncn26000.c |  20 +++-
>  drivers/net/phy/phy-c45.c  | 187 +++++++++++++++++++++++++++++++++++++
>  include/linux/phy.h        |  10 +-
>  include/uapi/linux/mdio.h  |  31 ++++++
>  net/ethtool/plca.c         |   2 +-
>  5 files changed, 245 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/phy/ncn26000.c b/drivers/net/phy/ncn26000.c
> index 65a34edc5b20..39197823cf16 100644
> --- a/drivers/net/phy/ncn26000.c
> +++ b/drivers/net/phy/ncn26000.c
> @@ -27,14 +27,27 @@
>  #define NCN26000_IRQ_PLCAREC_BIT                ((u16)(1 << 4))
>  #define NCN26000_IRQ_PHYSCOL_BIT                ((u16)(1 << 5))
>  
> +#define TO_TMR_DEFAULT				((u16)32)
> +
>  struct ncn26000_priv {
>  	u16 enabled_irqs;
>  };
>  
>  static int ncn26000_config_init(struct phy_device *phydev)
>  {
> -	// TODO: add vendor-specific tuning (ENI, CMC, ...)
> -	return 0;
> +	int ret;
> +
> +	/* HW bug workaround: the default value of the PLCA TO_TIMER should be
> +	 * 32, where the current version of NCN26000 reports 24. This will be
> +	 * fixed in future PHY versions. For the time being, we force the right
> +	 * default here.
> +	 */
> +	ret = phy_write_mmd(phydev,
> +			    MDIO_MMD_OATC14,
> +			    MDIO_OATC14_PLCA_TOTMR,
> +			    TO_TMR_DEFAULT);

Better formatting please.

	return phy_write_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_TOTMR,
			     TO_TMR_DEFAULT);

is sufficient. No need for "ret" (and there are folk who will create a
cleanup patch to do this, so might as well get it right on submission.)

> +/**
> + * genphy_c45_plca_get_cfg - get PLCA configuration from standard registers
> + * @phydev: target phy_device struct
> + * @plca_cfg: output structure to store the PLCA configuration
> + *
> + * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
> + *   Management Registers specifications, this function can be used to retrieve
> + *   the current PLCA configuration from the standard registers in MMD 31.
> + */
> +int genphy_c45_plca_get_cfg(struct phy_device *phydev,
> +			    struct phy_plca_cfg *plca_cfg)
> +{
> +	int ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_IDVER);
> +	if (ret < 0)
> +		return ret;
> +
> +	plca_cfg->version = (u32)ret;

->version has type s32, so is signed. Clearly, from the above code, it
can't be negative (since negative integer values are an error.) So why
is ->version declared in patch 1 as signed? The cast here to u32 also
seems strange.

Also, since the register you're reading can be no more than 16 bits
wide, using s32 seems like a waste.

> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_CTRL0);
> +	if (ret < 0)
> +		return ret;
> +
> +	plca_cfg->enabled = !!(((u16)ret) & MDIO_OATC14_PLCA_EN);

->enabled has type s16, but it clearly boolean in nature. It could be
a u8 instead. No need for that u16 cast either.

> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_CTRL1);
> +	if (ret < 0)
> +		return ret;
> +
> +	plca_cfg->node_cnt = (((u16)ret) & MDIO_OATC14_PLCA_NCNT) >> 8;
> +	plca_cfg->node_id = (((u16)ret) & MDIO_OATC14_PLCA_ID);

Also declared to be signed, but clearly aren't. u16 cast is unnecessary.

> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_TOTMR);
> +	if (ret < 0)
> +		return ret;
> +
> +	plca_cfg->to_tmr = (u16)ret & MDIO_OATC14_PLCA_TOT;

Ditto.

> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_BURST);
> +	if (ret < 0)
> +		return ret;
> +
> +	plca_cfg->burst_cnt = (((u16)ret) & MDIO_OATC14_PLCA_MAXBC) >> 8;
> +	plca_cfg->burst_tmr = (((u16)ret) & MDIO_OATC14_PLCA_BTMR);

And same again.

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(genphy_c45_plca_get_cfg);
> +
> +/**
> + * genphy_c45_plca_set_cfg - set PLCA configuration using standard registers
> + * @phydev: target phy_device struct
> + * @plca_cfg: structure containing the PLCA configuration. Fields set to -1 are
> + * not to be changed.
> + *
> + * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
> + *   Management Registers specifications, this function can be used to modify
> + *   the PLCA configuration using the standard registers in MMD 31.
> + */
> +int genphy_c45_plca_set_cfg(struct phy_device *phydev,
> +			    const struct phy_plca_cfg *plca_cfg)
> +{
> +	int ret;
> +	u16 val;
> +
> +	// PLCA IDVER is read-only
> +	if (plca_cfg->version >= 0)
> +		return -EINVAL;

Given that we've established this can't be negative, this seems like
a bit of a silly check.

> +
> +	// first of all, disable PLCA if required
> +	if (plca_cfg->enabled == 0) {
> +		ret = phy_clear_bits_mmd(phydev,
> +					 MDIO_MMD_OATC14,
> +					 MDIO_OATC14_PLCA_CTRL0,
> +					 MDIO_OATC14_PLCA_EN);
> +
> +		if (ret < 0)
> +			return ret;
> +	}

Does this need to be disabled when making changes? Just wondering
why you handle this disable explicitly early.

> +
> +	if (plca_cfg->node_cnt >= 0 || plca_cfg->node_id >= 0) {
> +		if (plca_cfg->node_cnt < 0 || plca_cfg->node_id < 0) {
> +			ret = phy_read_mmd(phydev,
> +					   MDIO_MMD_OATC14,
> +					   MDIO_OATC14_PLCA_CTRL1);
> +
> +			if (ret < 0)
> +				return ret;
> +
> +			val = (u16)ret;
> +		}
> +
> +		if (plca_cfg->node_cnt >= 0)
> +			val = (val & ~MDIO_OATC14_PLCA_NCNT) |
> +			      (u16)(plca_cfg->node_cnt << 8);
> +
> +		if (plca_cfg->node_id >= 0)
> +			val = (val & ~MDIO_OATC14_PLCA_ID) |
> +			      (u16)(plca_cfg->node_id);
> +
> +		ret = phy_write_mmd(phydev,
> +				    MDIO_MMD_OATC14,
> +				    MDIO_OATC14_PLCA_CTRL1,
> +				    val);

Safer to use phy_modify_mmd() and build up the mask as necessary.

It also seems odd to have this "positive numbers mean update" thing
when every other ethtool API just programs whatever is passed. It seems
to be a different API theory to the rest of the ethtool established
principle that if one wishes to modify, one calls the _GET followed
by a _SET. This applies throughout this function.

> +
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	if (plca_cfg->to_tmr >= 0) {
> +		ret = phy_write_mmd(phydev,
> +				    MDIO_MMD_OATC14,
> +				    MDIO_OATC14_PLCA_TOTMR,
> +				    (u16)plca_cfg->to_tmr);
> +
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	if (plca_cfg->burst_cnt >= 0 || plca_cfg->burst_tmr >= 0) {
> +		if (plca_cfg->burst_cnt < 0 || plca_cfg->burst_tmr < 0) {
> +			ret = phy_read_mmd(phydev,
> +					   MDIO_MMD_OATC14,
> +					   MDIO_OATC14_PLCA_BURST);
> +
> +			if (ret < 0)
> +				return ret;
> +
> +			val = (u16)ret;
> +		}
> +
> +		if (plca_cfg->burst_cnt >= 0)
> +			val = (val & ~MDIO_OATC14_PLCA_MAXBC) |
> +			      (u16)(plca_cfg->burst_cnt << 8);
> +
> +		if (plca_cfg->burst_tmr >= 0)
> +			val = (val & ~MDIO_OATC14_PLCA_BTMR) |
> +			      (u16)(plca_cfg->burst_tmr);
> +
> +		ret = phy_write_mmd(phydev,
> +				    MDIO_MMD_OATC14,
> +				    MDIO_OATC14_PLCA_BURST,
> +				    val);
> +
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	// if we need to enable PLCA, do it at the end
> +	if (plca_cfg->enabled > 0) {
> +		ret = phy_set_bits_mmd(phydev,
> +				       MDIO_MMD_OATC14,
> +				       MDIO_OATC14_PLCA_CTRL0,
> +				       MDIO_OATC14_PLCA_EN);
> +
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(genphy_c45_plca_set_cfg);
> +
> +/**
> + * genphy_c45_plca_get_status - get PLCA status from standard registers
> + * @phydev: target phy_device struct
> + * @plca_st: output structure to store the PLCA status
> + *
> + * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
> + *   Management Registers specifications, this function can be used to retrieve
> + *   the current PLCA status information from the standard registers in MMD 31.
> + */
> +int genphy_c45_plca_get_status(struct phy_device *phydev,
> +			       struct phy_plca_status *plca_st)
> +{
> +	int ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_STATUS);
> +	if (ret < 0)
> +		return ret;
> +
> +	plca_st->pst = !!(((u16)ret) & MDIO_OATC14_PLCA_PST);

u16 cast not needed.

> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(genphy_c45_plca_get_status);
> +
>  struct phy_driver genphy_c45_driver = {
>  	.phy_id         = 0xffffffff,
>  	.phy_id_mask    = 0xffffffff,
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 2dfb85c6e596..4548c8e8f6a9 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -811,7 +811,7 @@ struct phy_plca_cfg {
>   * struct phy_plca_status - Status of the PLCA (Physical Layer Collision
>   * Avoidance) Reconciliation Sublayer.
>   *
> - * @status: The PLCA status as reported by the PST bit in the PLCA STATUS
> + * @pst: The PLCA status as reported by the PST bit in the PLCA STATUS
>   *	register(31.CA03), indicating BEACON activity.
>   *
>   * A structure containing status information of the PLCA RS configuration.
> @@ -819,7 +819,7 @@ struct phy_plca_cfg {
>   * what is actually used.
>   */
>  struct phy_plca_status {
> -	bool status;
> +	bool pst;
>  };

Shouldn't this be in patch 1?

>  
>  /**
> @@ -1745,6 +1745,12 @@ int genphy_c45_loopback(struct phy_device *phydev, bool enable);
>  int genphy_c45_pma_resume(struct phy_device *phydev);
>  int genphy_c45_pma_suspend(struct phy_device *phydev);
>  int genphy_c45_fast_retrain(struct phy_device *phydev, bool enable);
> +int genphy_c45_plca_get_cfg(struct phy_device *phydev,
> +			    struct phy_plca_cfg *plca_cfg);
> +int genphy_c45_plca_set_cfg(struct phy_device *phydev,
> +			    const struct phy_plca_cfg *plca_cfg);
> +int genphy_c45_plca_get_status(struct phy_device *phydev,
> +			       struct phy_plca_status *plca_st);
>  
>  /* Generic C45 PHY driver */
>  extern struct phy_driver genphy_c45_driver;
> diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
> index 75b7257a51e1..a9f166c511c0 100644
> --- a/include/uapi/linux/mdio.h
> +++ b/include/uapi/linux/mdio.h
> @@ -26,6 +26,7 @@
>  #define MDIO_MMD_C22EXT		29	/* Clause 22 extension */
>  #define MDIO_MMD_VEND1		30	/* Vendor specific 1 */
>  #define MDIO_MMD_VEND2		31	/* Vendor specific 2 */
> +#define MDIO_MMD_OATC14		MDIO_MMD_VEND2

If this is in the vendor 2 register set, I doubt that this is a feature
described by IEEE 802.3, since they allocated the entirety of this MMD
over to manufacturers to do whatever they please with this space.

If this is correct, then these definitions have no place being in this
generic header file, since they are likely specific to the vendors PHY.

>  
>  /* Generic MDIO registers. */
>  #define MDIO_CTRL1		MII_BMCR
> @@ -89,6 +90,14 @@
>  #define MDIO_PMA_LASI_TXSTAT	0x9004	/* TX_ALARM status */
>  #define MDIO_PMA_LASI_STAT	0x9005	/* LASI status */
>  
> +/* Open Alliance TC14 registers */
> +#define MDIO_OATC14_PLCA_IDVER	0xca00  /* PLCA ID and version */
> +#define MDIO_OATC14_PLCA_CTRL0	0xca01	/* PLCA Control register 0 */
> +#define MDIO_OATC14_PLCA_CTRL1	0xca02	/* PLCA Control register 1 */
> +#define MDIO_OATC14_PLCA_STATUS	0xca03	/* PLCA Status register */
> +#define MDIO_OATC14_PLCA_TOTMR	0xca04	/* PLCA TO Timer register */
> +#define MDIO_OATC14_PLCA_BURST	0xca05	/* PLCA BURST mode register */
> +

Same for these.

>  /* Control register 1. */
>  /* Enable extended speed selection */
>  #define MDIO_CTRL1_SPEEDSELEXT		(BMCR_SPEED1000 | BMCR_SPEED100)
> @@ -436,4 +445,26 @@ static inline __u16 mdio_phy_id_c45(int prtad, int devad)
>  #define MDIO_USXGMII_5000FULL		0x1a00	/* 5000Mbps full-duplex */
>  #define MDIO_USXGMII_LINK		0x8000	/* PHY link with copper-side partner */
>  
> +/* Open Alliance TC14 PLCA IDVER register */
> +#define MDIO_OATC14_PLCA_IDM		0xff00	/* PLCA MAP ID */
> +#define MDIO_OATC14_PLCA_VER		0x00ff	/* PLCA MAP version */
> +
> +/* Open Alliance TC14 PLCA CTRL0 register */
> +#define MDIO_OATC14_PLCA_EN		0x8000  /* PLCA enable */
> +#define MDIO_OATC14_PLCA_RST		0x4000  /* PLCA reset */
> +
> +/* Open Alliance TC14 PLCA CTRL1 register */
> +#define MDIO_OATC14_PLCA_NCNT		0xff00	/* PLCA node count */
> +#define MDIO_OATC14_PLCA_ID		0x00ff	/* PLCA local node ID */
> +
> +/* Open Alliance TC14 PLCA STATUS register */
> +#define MDIO_OATC14_PLCA_PST		0x8000	/* PLCA status indication */
> +
> +/* Open Alliance TC14 PLCA TOTMR register */
> +#define MDIO_OATC14_PLCA_TOT		0x00ff
> +
> +/* Open Alliance TC14 PLCA BURST register */
> +#define MDIO_OATC14_PLCA_MAXBC		0xff00
> +#define MDIO_OATC14_PLCA_BTMR		0x00ff

And these.

> +
>  #endif /* _UAPI__LINUX_MDIO_H__ */
> diff --git a/net/ethtool/plca.c b/net/ethtool/plca.c
> index 371d8098225e..ab50d8b48bd6 100644
> --- a/net/ethtool/plca.c
> +++ b/net/ethtool/plca.c
> @@ -269,7 +269,7 @@ static int plca_get_status_fill_reply(struct sk_buff *skb,
>  				      const struct ethnl_reply_data *reply_base)
>  {
>  	const struct plca_reply_data *data = PLCA_REPDATA(reply_base);
> -	const u8 status = data->plca_st.status;
> +	const u8 status = data->plca_st.pst;

Shouldn't this be in a different patch?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
