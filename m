Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E914DCF0B
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 20:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiCQTyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 15:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiCQTyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 15:54:09 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530E3284E4A;
        Thu, 17 Mar 2022 12:52:50 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id a17so6827440edm.9;
        Thu, 17 Mar 2022 12:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bavSzS8RD+OPK6XigG8tAuoWzal+4J6X0wvgjdYgqmo=;
        b=Xauc0qPk8zQuXoOmENXet51q+jgjMjqcI56cLCoLqIqfbBAcTciWxN0Dys+kiH12ue
         en9cFrYoiCoqTla5VDHzvl1bvK1+et569hSCb+Lun8m2IQUDOey4/ceuiGJwbNTAr+k+
         PXOP4RDNsP4l42aPUlLtDj024ybdgYU1RxpXwFr1PqmM4vpzDNFk1D2MajHty0TSgFU2
         4x25j75sr/VqLyCeXxmt5pXTsQ6cfmZcNo1WHRTiGTJueT3bfC63Df2nghH7VGesrDaV
         PTbU5YeJOfp+XuIIgW6F+iTSbXtGrGo064mU0PQ9pXpzdDbd412kju84Qd5XNLzT8ENN
         jcgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bavSzS8RD+OPK6XigG8tAuoWzal+4J6X0wvgjdYgqmo=;
        b=xwGQkfoxHkHl1Ef5TB8cNSQwH09NI7ZOIHs3WiOrqPZ8mAGflh/YHRYwLwkvZDU0XH
         d3avUhfWG7bBOuWJHR+TGPn1AHy7lu9/A6A2ZNHqHeQXKQTQKRc06G7GfCtoXrb+vBH1
         vW3WOUchOJaIb9Sn3tSFdqTYXHT2hIiN1Di/ME4PyMSI1CvSZl5jAKk81bzA7JW/DvhJ
         BFRgTDJ4YTeiuKbBG9LxiMecrG4Dtd4P0wF/ZjWnkX9M6rpv9nHRhU7PdJvkLzWiCVAr
         iLREamJXHXvv1SjkrOAmUPs/BC2OB5XVPXXpRnTVrHrV0n8CJRPQNdXHGrdIa8UYSbht
         Z8Tw==
X-Gm-Message-State: AOAM532jZQQJMf/rDzGQrPwNvEkr3uhJKyMVtwRRKKFU2QitmpCrhN8L
        Nh4DnuSxdak11538qx2tQvo=
X-Google-Smtp-Source: ABdhPJzZ8GGLH73Ksk8NxvDN1R3p5zUL1G5dVEZpLwbquwD+NVrK3kO0thyk2RlH+yzuxrFQ1dPYHQ==
X-Received: by 2002:a50:d711:0:b0:410:a51a:77c5 with SMTP id t17-20020a50d711000000b00410a51a77c5mr6250033edi.154.1647546768763;
        Thu, 17 Mar 2022 12:52:48 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id l9-20020a170906078900b006dac5f336f8sm2782164ejc.124.2022.03.17.12.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 12:52:48 -0700 (PDT)
Date:   Thu, 17 Mar 2022 21:52:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8795: handle eee
 specif erratum
Message-ID: <20220317195246.jy43gwrnao4drljp@skbuf>
References: <20220316125529.1489045-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316125529.1489045-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 01:55:29PM +0100, Oleksij Rempel wrote:
> According to erratum described in DS80000687C[1]: "Module 2: Link drops with
> some EEE link partners.", we need to "Disable the EEE next page
> exchange in EEE Global Register 2"
> 
> 1 - https://ww1.microchip.com/downloads/en/DeviceDoc/KSZ87xx-Errata-DS80000687C.pdf
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

I don't possess KSZ8 switches, but there doesn't look anything wrong to
me with this patch, so:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/microchip/ksz8.h        |  1 +
>  drivers/net/dsa/microchip/ksz8795.c     | 45 ++++++++++++++++++++++++-
>  drivers/net/dsa/microchip/ksz8795_reg.h |  4 +++
>  drivers/net/dsa/microchip/ksz_common.h  |  1 +
>  4 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
> index 9d611895d3cf..03da369675c6 100644
> --- a/drivers/net/dsa/microchip/ksz8.h
> +++ b/drivers/net/dsa/microchip/ksz8.h
> @@ -16,6 +16,7 @@ enum ksz_regs {
>  	REG_IND_DATA_HI,
>  	REG_IND_DATA_LO,
>  	REG_IND_MIB_CHECK,
> +	REG_IND_BYTE,
>  	P_FORCE_CTRL,
>  	P_LINK_STATUS,
>  	P_LOCAL_CTRL,
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 5dc9899bc0a6..6f9cdd5204fb 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -33,6 +33,7 @@ static const u8 ksz8795_regs[] = {
>  	[REG_IND_DATA_HI]		= 0x71,
>  	[REG_IND_DATA_LO]		= 0x75,
>  	[REG_IND_MIB_CHECK]		= 0x74,
> +	[REG_IND_BYTE]			= 0xA0,
>  	[P_FORCE_CTRL]			= 0x0C,
>  	[P_LINK_STATUS]			= 0x0E,
>  	[P_LOCAL_CTRL]			= 0x07,
> @@ -222,6 +223,25 @@ static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
>  			   bits, set ? bits : 0);
>  }
>  
> +static int ksz8_ind_write8(struct ksz_device *dev, u8 table, u16 addr, u8 data)
> +{
> +	struct ksz8 *ksz8 = dev->priv;
> +	const u8 *regs = ksz8->regs;
> +	u16 ctrl_addr;
> +	int ret = 0;
> +
> +	mutex_lock(&dev->alu_mutex);
> +
> +	ctrl_addr = IND_ACC_TABLE(table) | addr;
> +	ret = ksz_write8(dev, regs[REG_IND_BYTE], data);
> +	if (!ret)
> +		ret = ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
> +
> +	mutex_unlock(&dev->alu_mutex);
> +
> +	return ret;
> +}
> +
>  static int ksz8_reset_switch(struct ksz_device *dev)
>  {
>  	if (ksz_is_ksz88x3(dev)) {
> @@ -1391,6 +1411,23 @@ static void ksz8_config_cpu_port(struct dsa_switch *ds)
>  	}
>  }
>  
> +static int ksz8_handle_global_errata(struct dsa_switch *ds)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	int ret = 0;
> +
> +	/* KSZ87xx Errata DS80000687C.
> +	 * Module 2: Link drops with some EEE link partners.
> +	 *   An issue with the EEE next page exchange between the
> +	 *   KSZ879x/KSZ877x/KSZ876x and some EEE link partners may result in
> +	 *   the link dropping.
> +	 */
> +	if (dev->ksz87xx_eee_link_erratum)
> +		ret = ksz8_ind_write8(dev, TABLE_EEE, REG_IND_EEE_GLOB2_HI, 0);
> +
> +	return ret;
> +}
> +
>  static int ksz8_setup(struct dsa_switch *ds)
>  {
>  	struct ksz_device *dev = ds->priv;
> @@ -1458,7 +1495,7 @@ static int ksz8_setup(struct dsa_switch *ds)
>  
>  	ds->configure_vlan_while_not_filtering = false;
>  
> -	return 0;
> +	return ksz8_handle_global_errata(ds);
>  }
>  
>  static void ksz8_get_caps(struct dsa_switch *ds, int port,
> @@ -1575,6 +1612,7 @@ struct ksz_chip_data {
>  	int num_statics;
>  	int cpu_ports;
>  	int port_cnt;
> +	bool ksz87xx_eee_link_erratum;
>  };
>  
>  static const struct ksz_chip_data ksz8_switch_chips[] = {
> @@ -1586,6 +1624,7 @@ static const struct ksz_chip_data ksz8_switch_chips[] = {
>  		.num_statics = 8,
>  		.cpu_ports = 0x10,	/* can be configured as cpu port */
>  		.port_cnt = 5,		/* total cpu and user ports */
> +		.ksz87xx_eee_link_erratum = true,
>  	},
>  	{
>  		/*
> @@ -1609,6 +1648,7 @@ static const struct ksz_chip_data ksz8_switch_chips[] = {
>  		.num_statics = 8,
>  		.cpu_ports = 0x10,	/* can be configured as cpu port */
>  		.port_cnt = 4,		/* total cpu and user ports */
> +		.ksz87xx_eee_link_erratum = true,
>  	},
>  	{
>  		.chip_id = 0x8765,
> @@ -1618,6 +1658,7 @@ static const struct ksz_chip_data ksz8_switch_chips[] = {
>  		.num_statics = 8,
>  		.cpu_ports = 0x10,	/* can be configured as cpu port */
>  		.port_cnt = 5,		/* total cpu and user ports */
> +		.ksz87xx_eee_link_erratum = true,
>  	},
>  	{
>  		.chip_id = 0x8830,
> @@ -1652,6 +1693,8 @@ static int ksz8_switch_init(struct ksz_device *dev)
>  			dev->host_mask = chip->cpu_ports;
>  			dev->port_mask = (BIT(dev->phy_port_cnt) - 1) |
>  					 chip->cpu_ports;
> +			dev->ksz87xx_eee_link_erratum =
> +				chip->ksz87xx_eee_link_erratum;
>  			break;
>  		}
>  	}
> diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
> index 6b40bc25f7ff..d74defcd86b4 100644
> --- a/drivers/net/dsa/microchip/ksz8795_reg.h
> +++ b/drivers/net/dsa/microchip/ksz8795_reg.h
> @@ -812,6 +812,10 @@
>  
>  #define IND_ACC_TABLE(table)		((table) << 8)
>  
> +/* */
> +#define REG_IND_EEE_GLOB2_LO		0x34
> +#define REG_IND_EEE_GLOB2_HI		0x35
> +
>  /* Driver set switch broadcast storm protection at 10% rate. */
>  #define BROADCAST_STORM_PROT_RATE	10
>  
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index fa39ee73cbd2..485d4a948c38 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -77,6 +77,7 @@ struct ksz_device {
>  	phy_interface_t compat_interface;
>  	u32 regs_size;
>  	bool phy_errata_9477;
> +	bool ksz87xx_eee_link_erratum;
>  	bool synclko_125;
>  	bool synclko_disable;
>  
> -- 
> 2.30.2
> 
