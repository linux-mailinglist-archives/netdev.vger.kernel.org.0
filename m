Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971384587CC
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbhKVBmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbhKVBmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:42:02 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62266C061574;
        Sun, 21 Nov 2021 17:38:56 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id w1so69740006edc.6;
        Sun, 21 Nov 2021 17:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BxsF32t5e/G+F8fhwvgqyJ2NVcolTLUJxy5HznsKV60=;
        b=QnGGDTJgxXOzFTAov7E/4fmqrXsnntOKZR5X7Lr6FtIpvvDj7Alzu5RD591tQLzZu/
         4Eq2XcCySNbfIrYh648/0aURvdXLMFJwuj07d+TKTF2LtpnfOHdZVSIYrPwIOqlOssEY
         e8XKHDuaf+0N1AH9dNVjHyCiU8cQTsUDHO4FWn5NIIj+K533AyXCCs11tlfB8hXsHUOZ
         0n+EwxTcTDC605M1iMXUCsXApr+ukwo+68uBFkaY5QiPjbho8JUtM78BXVkxz5siOnfw
         nL6YK4OnHMd10y1sSsTTkrX5dUdF1m82xSYISx0PpWb+C7pZ+N5+jgq464PIfG4b/wUd
         aR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BxsF32t5e/G+F8fhwvgqyJ2NVcolTLUJxy5HznsKV60=;
        b=q1Fg09upN8XQ9+dOMs2vCiUVOXjTwAUCMynbvZOlAwhG6QrmsbKE3huCKXaxWjvk2x
         G8a1IWS5ChC76IxOMS1Q70hnf0A0kr6MBgLSCqeCKHqBim3VgrqFHkqBvbZuOqiyEKau
         vehXSXPWDyC7B7RbUm1SjKjl5sCzampjM+d04a1Zzi9qE72tQ1TEBubalPL3sE5xkiA8
         +65jaaD/5zgYSukdi/7GwYki01rW6dP1XkQntPRcLt/8QZ+WivVCeWPTZ2Z/Lgvr9C8K
         YOk7oN1oADXK0ZVbR/ZRpkVojnRbqCMYOofLgSvz4XTTARAcNUK5UHWwFxW5sNM8kRfb
         jskA==
X-Gm-Message-State: AOAM533oD1UoH97O3LRKJ5b9WO4mcIH1My2Sg0WJchmIUhEml8u4YAJs
        ArWSDZyfwCkcTLHK0Ea3fX0=
X-Google-Smtp-Source: ABdhPJzrZ6xs+2fAOOJhdo0c2DJYSenoRA0m6hmSZvn+UhsSGIUKDyJ0ilZmH/p2sM3StgxQLwCEkQ==
X-Received: by 2002:a05:6402:5206:: with SMTP id s6mr58775210edd.2.1637545134954;
        Sun, 21 Nov 2021 17:38:54 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id hp3sm2959887ejc.61.2021.11.21.17.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:38:54 -0800 (PST)
Date:   Mon, 22 Nov 2021 03:38:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 5/9] net: dsa: qca8k: convert qca8k to regmap
 helper
Message-ID: <20211122013853.dpprmlprm2q2f24v@skbuf>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
 <20211122010313.24944-6-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122010313.24944-6-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 02:03:09AM +0100, Ansuel Smith wrote:
> Convert any qca8k read/write/rmw/set/clear/pool to regmap helper and add
> missing config to regmap_config struct.
> Ipq40xx SoC have the internal switch based on the qca8k regmap but use
> mmio for read/write/rmw operation instead of mdio.
> In preparation for the support of this internal switch, convert the
> driver to regmap API to later split the driver to common and specific
> code. The overhead introduced by the use of regamp API is marginal as the
> internal mdio will bypass it by using its direct access and regmap will be
> used only by configuration functions or fdb access.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 289 ++++++++++++++++++----------------------
>  1 file changed, 131 insertions(+), 158 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 52fca800e6f7..159a1065e66b 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -10,6 +10,7 @@
>  #include <linux/phy.h>
>  #include <linux/netdevice.h>
>  #include <linux/bitfield.h>
> +#include <linux/regmap.h>
>  #include <net/dsa.h>
>  #include <linux/of_net.h>
>  #include <linux/of_mdio.h>
> @@ -150,8 +151,9 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
>  }
>  
>  static int
> -qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
> +qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
>  {
> +	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
>  	struct mii_bus *bus = priv->bus;
>  	u16 r1, r2, page;
>  	int ret;
> @@ -172,8 +174,9 @@ qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
>  }
>  
>  static int
> -qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
> +qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
>  {
> +	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
>  	struct mii_bus *bus = priv->bus;
>  	u16 r1, r2, page;
>  	int ret;
> @@ -194,8 +197,9 @@ qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
>  }
>  
>  static int
> -qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
> +qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_val)
>  {
> +	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
>  	struct mii_bus *bus = priv->bus;
>  	u16 r1, r2, page;
>  	u32 val;
> @@ -223,34 +227,6 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
>  	return ret;
>  }
>  
> -static int
> -qca8k_reg_set(struct qca8k_priv *priv, u32 reg, u32 val)
> -{
> -	return qca8k_rmw(priv, reg, 0, val);
> -}
> -
> -static int
> -qca8k_reg_clear(struct qca8k_priv *priv, u32 reg, u32 val)
> -{
> -	return qca8k_rmw(priv, reg, val, 0);
> -}
> -
> -static int
> -qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
> -{
> -	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
> -
> -	return qca8k_read(priv, reg, val);
> -}
> -
> -static int
> -qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
> -{
> -	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
> -
> -	return qca8k_write(priv, reg, val);
> -}
> -
>  static const struct regmap_range qca8k_readable_ranges[] = {
>  	regmap_reg_range(0x0000, 0x00e4), /* Global control */
>  	regmap_reg_range(0x0100, 0x0168), /* EEE control */
> @@ -282,26 +258,19 @@ static struct regmap_config qca8k_regmap_config = {
>  	.max_register = 0x16ac, /* end MIB - Port6 range */
>  	.reg_read = qca8k_regmap_read,
>  	.reg_write = qca8k_regmap_write,
> +	.reg_update_bits = qca8k_regmap_update_bits,
>  	.rd_table = &qca8k_readable_table,
> +	.disable_locking = true, /* Locking is handled by qca8k read/write */
> +	.cache_type = REGCACHE_NONE, /* Explicitly disable CACHE */
>  };
>  
>  static int
>  qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
>  {
> -	int ret, ret1;
>  	u32 val;
>  
> -	ret = read_poll_timeout(qca8k_read, ret1, !(val & mask),
> -				0, QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
> -				priv, reg, &val);
> -
> -	/* Check if qca8k_read has failed for a different reason
> -	 * before returning -ETIMEDOUT
> -	 */
> -	if (ret < 0 && ret1 < 0)
> -		return ret1;
> -
> -	return ret;
> +	return regmap_read_poll_timeout(priv->regmap, reg, val, !(val & mask), 0,
> +				       QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC);
>  }
>  
>  static int
> @@ -312,7 +281,7 @@ qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
>  
>  	/* load the ARL table into an array */
>  	for (i = 0; i < 4; i++) {
> -		ret = qca8k_read(priv, QCA8K_REG_ATU_DATA0 + (i * 4), &val);
> +		ret = regmap_read(priv->regmap, QCA8K_REG_ATU_DATA0 + (i * 4), &val);

Maybe you could keep qca8k_read and qca8k_write and make them return
regmap_read(priv->regmap, ...), this could reduce the patch's delta,
make future bugfix patches conflict less with this change, etc etc.
What do you think?
