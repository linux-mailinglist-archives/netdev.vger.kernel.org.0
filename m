Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA59548383
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 11:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbiFMJSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 05:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234182AbiFMJSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 05:18:49 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EF214D04;
        Mon, 13 Jun 2022 02:18:47 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 25so6219462edw.8;
        Mon, 13 Jun 2022 02:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1k2fUp9A1ltIjuKvUKT9uCqeCoRnTxbZP1WFA5kZJWM=;
        b=UXr9cH5/mXYcijcguNeN9cOm3Ci0I9IH3ZduVvMrm0bRKN9XAPhQ8uI81iEQgAp4zX
         UIylnG0dQwMb1ifyhwrUQ/bkELAMAkYsuok9w04bpHQR/P4CErnsMV2S+jZGo0j7zvB+
         dTJlc8twkhTlAJq78Jx7C2PRzVG7LBk7zmbI5qwlB+0shNF7rduD5oWIdSerPBzCrD4k
         cA0U6+WibbltsB9x+l/3bo4ImaptxuhbyR/ZYWuJJm+lgQE+B3aAxx+ZgjpQ9K7wTYBx
         fVCJzdVhP5jZ2XcL8o4H9YKkq2zWngoQK7SWgph585T+bEFlQ5L1WELoIpSATt9JY8dZ
         wPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1k2fUp9A1ltIjuKvUKT9uCqeCoRnTxbZP1WFA5kZJWM=;
        b=bEHiDiDP/AcmoMIJ6fxrJEzTrVqOS68nUx6j3+CtSvdODZgBGm+OpSq7cfLo9iN09x
         xx4jBrn/yyCobmwcjZxxQwK45aUYZflv8BsNR/3pxVCWwPClngFrpVzvmRs8qTcxNpvw
         N9s2DGaDJXHy0jGCik9Lb0yh2oi3+/ouPtvtmzTLHhl+PUf/MApDUlSAXx5yR8zeYV79
         5A8Woyp33YMIAA7OjxvggH6yj71YRjhVx3bz7UuSRlk/mgQ6FbLfFlGC4JWAWXAS3y2f
         /XHpE+Xfh2u0EOse7H/ts1SUdedsLzMnSwbyPCILnNZoc1utJgvv5inW1ziO/gOrEKST
         yTKg==
X-Gm-Message-State: AOAM532IYpvY1bCdzBRXd5NPFbQOLhAwTSOX1uyzlq6luE6BZVCaI1O5
        HYLqmWfEY1sqCftO8Xer4Bo=
X-Google-Smtp-Source: ABdhPJwecP3QpAef5xF6I6tlLg1MdBJzM22oelHpZUmR1evD9UWuFf8vDAyYB400TvDG8sCsc6Fx3Q==
X-Received: by 2002:a05:6402:684:b0:431:503e:76e6 with SMTP id f4-20020a056402068400b00431503e76e6mr44837727edy.308.1655111925327;
        Mon, 13 Jun 2022 02:18:45 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id gl6-20020a170906e0c600b006fec63e564bsm3601493ejb.30.2022.06.13.02.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 02:18:44 -0700 (PDT)
Date:   Mon, 13 Jun 2022 12:18:43 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC Patch net-next v2 02/15] net: dsa: microchip: move switch
 chip_id detection to ksz_common
Message-ID: <20220613091843.yil3swd55w7kwr5s@skbuf>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
 <20220530104257.21485-3-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530104257.21485-3-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 04:12:44PM +0530, Arun Ramadoss wrote:
> KSZ87xx and KSZ88xx have chip_id representation at reg location 0. And
> KSZ9477 compatible switch and LAN937x switch have same chip_id detection
> at location 0x01 and 0x02. To have the common switch detect
> functionality for ksz switches, ksz_switch_detect function is
> introduced.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz8795.c     | 46 ---------------
>  drivers/net/dsa/microchip/ksz8795_reg.h | 13 -----
>  drivers/net/dsa/microchip/ksz9477.c     | 21 -------
>  drivers/net/dsa/microchip/ksz9477_reg.h |  1 -
>  drivers/net/dsa/microchip/ksz_common.c  | 78 +++++++++++++++++++++++--
>  drivers/net/dsa/microchip/ksz_common.h  | 19 +++++-
>  6 files changed, 92 insertions(+), 86 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 12a599d5e61a..927db57d02db 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -1424,51 +1424,6 @@ static u32 ksz8_get_port_addr(int port, int offset)
>  	return PORT_CTRL_ADDR(port, offset);
>  }
>  
> -static int ksz8_switch_detect(struct ksz_device *dev)
> -{
> -	u8 id1, id2;
> -	u16 id16;
> -	int ret;
> -
> -	/* read chip id */
> -	ret = ksz_read16(dev, REG_CHIP_ID0, &id16);
> -	if (ret)
> -		return ret;
> -
> -	id1 = id16 >> 8;
> -	id2 = id16 & SW_CHIP_ID_M;
> -
> -	switch (id1) {
> -	case KSZ87_FAMILY_ID:
> -		if ((id2 != CHIP_ID_94 && id2 != CHIP_ID_95))
> -			return -ENODEV;
> -
> -		if (id2 == CHIP_ID_95) {
> -			u8 val;
> -
> -			id2 = 0x95;
> -			ksz_read8(dev, REG_PORT_STATUS_0, &val);

Could you replace all remaining occurrences of REG_PORT_STATUS_0 and
PORT_FIBER_MODE with KSZ8_PORT_STATUS_0 and KSZ8_PORT_FIBER_MODE?
It would be good to not have multiple definitions for the same thing.

> -			if (val & PORT_FIBER_MODE)
> -				id2 = 0x65;
> -		} else if (id2 == CHIP_ID_94) {
> -			id2 = 0x94;
> -		}
> -		break;
> -	case KSZ88_FAMILY_ID:
> -		if (id2 != CHIP_ID_63)
> -			return -ENODEV;
> -		break;
> -	default:
> -		dev_err(dev->dev, "invalid family id: %d\n", id1);
> -		return -ENODEV;
> -	}
> -	id16 &= ~0xff;
> -	id16 |= id2;
> -	dev->chip_id = id16;
> -
> -	return 0;
> -}
> -
>  static int ksz8_switch_init(struct ksz_device *dev)
>  {
>  	struct ksz8 *ksz8 = dev->priv;
> @@ -1522,7 +1477,6 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
>  	.freeze_mib = ksz8_freeze_mib,
>  	.port_init_cnt = ksz8_port_init_cnt,
>  	.shutdown = ksz8_reset_switch,
> -	.detect = ksz8_switch_detect,
>  	.init = ksz8_switch_init,
>  	.exit = ksz8_switch_exit,
>  };
> diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
> index 4109433b6b6c..50cdc2a09f5a 100644
> --- a/drivers/net/dsa/microchip/ksz8795_reg.h
> +++ b/drivers/net/dsa/microchip/ksz8795_reg.h
> @@ -14,23 +14,10 @@
>  #define KS_PRIO_M			0x3
>  #define KS_PRIO_S			2
>  
> -#define REG_CHIP_ID0			0x00
> -
> -#define KSZ87_FAMILY_ID			0x87
> -#define KSZ88_FAMILY_ID			0x88
> -
> -#define REG_CHIP_ID1			0x01
> -
> -#define SW_CHIP_ID_M			0xF0
> -#define SW_CHIP_ID_S			4
>  #define SW_REVISION_M			0x0E
>  #define SW_REVISION_S			1
>  #define SW_START			0x01
>  
> -#define CHIP_ID_94			0x60
> -#define CHIP_ID_95			0x90
> -#define CHIP_ID_63			0x30
> -
>  #define KSZ8863_REG_SW_RESET		0x43
>  
>  #define KSZ8863_GLOBAL_SOFTWARE_RESET	BIT(4)
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index 7afc06681c02..7d3c8f6908b6 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -1360,23 +1360,6 @@ static u32 ksz9477_get_port_addr(int port, int offset)
>  	return PORT_CTRL_ADDR(port, offset);
>  }
>  
> -static int ksz9477_switch_detect(struct ksz_device *dev)
> -{
> -	u32 id32;
> -	int ret;
> -
> -	/* read chip id */
> -	ret = ksz_read32(dev, REG_CHIP_ID0__1, &id32);
> -	if (ret)
> -		return ret;
> -
> -	dev_dbg(dev->dev, "Switch detect: ID=%08x\n", id32);
> -
> -	dev->chip_id = id32 & 0x00FFFF00;
> -
> -	return 0;
> -}
> -
>  static int ksz9477_switch_init(struct ksz_device *dev)
>  {
>  	u8 data8;
> @@ -1407,8 +1390,6 @@ static int ksz9477_switch_init(struct ksz_device *dev)
>  	dev->features = GBIT_SUPPORT;
>  
>  	if (dev->chip_id == KSZ9893_CHIP_ID) {
> -		/* Chip is from KSZ9893 design. */
> -		dev_info(dev->dev, "Found KSZ9893\n");
>  		dev->features |= IS_9893;
>  
>  		/* Chip does not support gigabit. */
> @@ -1416,7 +1397,6 @@ static int ksz9477_switch_init(struct ksz_device *dev)
>  			dev->features &= ~GBIT_SUPPORT;
>  		dev->phy_port_cnt = 2;
>  	} else {
> -		dev_info(dev->dev, "Found KSZ9477 or compatible\n");
>  		/* Chip uses new XMII register definitions. */
>  		dev->features |= NEW_XMII;
>  
> @@ -1443,7 +1423,6 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
>  	.freeze_mib = ksz9477_freeze_mib,
>  	.port_init_cnt = ksz9477_port_init_cnt,
>  	.shutdown = ksz9477_reset_switch,
> -	.detect = ksz9477_switch_detect,
>  	.init = ksz9477_switch_init,
>  	.exit = ksz9477_switch_exit,
>  };
> diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
> index 7a2c8d4767af..077e35ab11b5 100644
> --- a/drivers/net/dsa/microchip/ksz9477_reg.h
> +++ b/drivers/net/dsa/microchip/ksz9477_reg.h
> @@ -25,7 +25,6 @@
>  
>  #define REG_CHIP_ID2__1			0x0002
>  
> -#define CHIP_ID_63			0x63
>  #define CHIP_ID_66			0x66
>  #define CHIP_ID_67			0x67
>  #define CHIP_ID_77			0x77
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 9ca8c8d7740f..9057cdb5971c 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -930,6 +930,72 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
>  }
>  EXPORT_SYMBOL_GPL(ksz_port_stp_state_set);
>  
> +static int ksz_switch_detect(struct ksz_device *dev)
> +{
> +	u8 id1, id2;
> +	u16 id16;
> +	u32 id32;
> +	int ret;
> +
> +	/* read chip id */
> +	ret = ksz_read16(dev, REG_CHIP_ID0, &id16);
> +	if (ret)
> +		return ret;
> +
> +	id1 = FIELD_GET(SW_FAMILY_ID_M, id16);
> +	id2 = FIELD_GET(SW_CHIP_ID_M, id16);
> +
> +	switch (id1) {
> +	case KSZ87_FAMILY_ID:
> +		if (id2 == CHIP_ID_95) {
> +			u8 val;
> +
> +			dev->chip_id = KSZ8795_CHIP_ID;
> +
> +			ksz_read8(dev, KSZ8_PORT_STATUS_0, &val);
> +			if (val & KSZ8_PORT_FIBER_MODE)
> +				dev->chip_id = KSZ8765_CHIP_ID;
> +		} else if (id2 == CHIP_ID_94) {
> +			dev->chip_id = KSZ8794_CHIP_ID;
> +		} else {
> +			return -ENODEV;
> +		}
> +		break;
> +	case KSZ88_FAMILY_ID:
> +		if (id2 == CHIP_ID_63)
> +			dev->chip_id = KSZ8830_CHIP_ID;
> +		else
> +			return -ENODEV;
> +		break;
> +	default:
> +		ret = ksz_read32(dev, REG_CHIP_ID0, &id32);
> +		if (ret)
> +			return ret;
> +
> +		dev->chip_rev = FIELD_GET(SW_REV_ID_M, id32);
> +		id32 &= ~0xFF;
> +
> +		switch (id32) {
> +		case KSZ9477_CHIP_ID:
> +		case KSZ9897_CHIP_ID:
> +		case KSZ9893_CHIP_ID:
> +		case KSZ9567_CHIP_ID:
> +		case LAN9370_CHIP_ID:
> +		case LAN9371_CHIP_ID:
> +		case LAN9372_CHIP_ID:
> +		case LAN9373_CHIP_ID:
> +		case LAN9374_CHIP_ID:
> +			dev->chip_id = id32;
> +			break;
> +		default:
> +			dev_err(dev->dev,
> +				"unsupported switch detected %x)\n", id32);
> +			return -ENODEV;
> +		}
> +	}
> +	return 0;
> +}
> +
>  struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
>  {
>  	struct dsa_switch *ds;
> @@ -986,10 +1052,9 @@ int ksz_switch_register(struct ksz_device *dev,
>  	mutex_init(&dev->alu_mutex);
>  	mutex_init(&dev->vlan_mutex);
>  
> -	dev->dev_ops = ops;
> -
> -	if (dev->dev_ops->detect(dev))
> -		return -EINVAL;
> +	ret = ksz_switch_detect(dev);
> +	if (ret)
> +		return ret;
>  
>  	info = ksz_lookup_info(dev->chip_id);
>  	if (!info)
> @@ -998,10 +1063,15 @@ int ksz_switch_register(struct ksz_device *dev,
>  	/* Update the compatible info with the probed one */
>  	dev->info = info;
>  
> +	dev_info(dev->dev, "found switch: %s, rev %i\n",
> +		 dev->info->dev_name, dev->chip_rev);
> +
>  	ret = ksz_check_device_id(dev);
>  	if (ret)
>  		return ret;
>  
> +	dev->dev_ops = ops;
> +
>  	ret = dev->dev_ops->init(dev);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index 8500eaedad67..d16c095cdefb 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -90,6 +90,7 @@ struct ksz_device {
>  
>  	/* chip specific data */
>  	u32 chip_id;
> +	u8 chip_rev;
>  	int cpu_port;			/* port connected to CPU */
>  	int phy_port_cnt;
>  	phy_interface_t compat_interface;
> @@ -182,7 +183,6 @@ struct ksz_dev_ops {
>  	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
>  	void (*port_init_cnt)(struct ksz_device *dev, int port);
>  	int (*shutdown)(struct ksz_device *dev);
> -	int (*detect)(struct ksz_device *dev);
>  	int (*init)(struct ksz_device *dev);
>  	void (*exit)(struct ksz_device *dev);
>  };
> @@ -353,6 +353,23 @@ static inline void ksz_regmap_unlock(void *__mtx)
>  #define PORT_RX_ENABLE			BIT(1)
>  #define PORT_LEARN_DISABLE		BIT(0)
>  
> +/* Switch ID Defines */
> +#define REG_CHIP_ID0			0x00
> +
> +#define SW_FAMILY_ID_M			GENMASK(15, 8)
> +#define KSZ87_FAMILY_ID			0x87
> +#define KSZ88_FAMILY_ID			0x88
> +
> +#define KSZ8_PORT_STATUS_0		0x08
> +#define KSZ8_PORT_FIBER_MODE		BIT(7)
> +
> +#define SW_CHIP_ID_M			GENMASK(7, 4)
> +#define CHIP_ID_94			0x6
> +#define CHIP_ID_95			0x9

KSZ87_CHIP_ID_xxx maybe?

> +#define CHIP_ID_63			0x3

And KSZ88_CHIP_ID_63.

> +
> +#define SW_REV_ID_M			GENMASK(7, 4)
> +
>  /* Regmap tables generation */
>  #define KSZ_SPI_OP_RD		3
>  #define KSZ_SPI_OP_WR		2
> -- 
> 2.36.1
> 

