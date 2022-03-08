Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E1E4D1964
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241599AbiCHNmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbiCHNmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:42:22 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCD4496B1;
        Tue,  8 Mar 2022 05:41:25 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id b24so1888440edu.10;
        Tue, 08 Mar 2022 05:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/tgi9ifUcPYeepqwl5BUqy/CIvcNqdAoWsIoGURK/88=;
        b=pk6i5ATMZG5YOQr3BB/kq8StdjbWB9uXDjMX9WUSH8wDeVZNUefEiPyeErsXanCNZt
         o0nKdIty4YYg7xzv4B/LRsSraiaKvvBD8cddmFy9x+dFpQj8oz6zjjWsfUgcq2VXU90b
         HAO9CwC4mNVYSV25NFPQRHyD9EyYSfzmFhAblJJFfdqOx8i6IF8PkDZtF0UFe4XJ8UJY
         hIlzAQvT+SxoZQX9BEE98RDXA8/HA/RdiG8mcNT/XuLb5Ie2x7bMCSewEvebpL/gE4rZ
         ILnhcaCG/G2T2xh4FjtvMt8Rs/2xks42C7JRG0n58oFvDXJPivmMIutMYoYWxUN+UB/U
         2h4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/tgi9ifUcPYeepqwl5BUqy/CIvcNqdAoWsIoGURK/88=;
        b=SqUGDNc59sybNL4HQ2wjwnZKU2vYcJ5fSzYyF0FPbvadVz86EShyVyynx1/5pntHld
         /mMGcpYXJHDNgPx+nSElOIQBj1aXZr877oGKRx5t6Yu7ALIxuwZCw4U+Qq4HJXALMU4K
         ITByX4/aHEvuDcjSojGiuTzyywwf8TrW7LyxAptyBZO5jkcDQou6amNtrNsxldQMfRSr
         jpLdrY9L6Kmtito781zAE6vz242IsL5GV9ZsaI8awarOZqqjuamQzZYuHclMWNRo1zet
         v0mQ+QKmKVOf6AfvmFGbMgMXeihvHmhLbaBIdcEdKmra6qghdIIjHB0ERFeBPPEBxIH1
         1zLw==
X-Gm-Message-State: AOAM533oxWgIwoiY7pfD+JWXL9VwbOssBY5uE74hx8aXGCt18JLMozWI
        RBijaGZNGxmgcMVMENlr+VI=
X-Google-Smtp-Source: ABdhPJxqoR18NrerQhzsYSiz4RY55xPHVEv1YhitR8QOAixMhRl4/KZkVYbiLfzQzfCs65hgjHmv9g==
X-Received: by 2002:a05:6402:3691:b0:415:ce4f:ac5a with SMTP id ej17-20020a056402369100b00415ce4fac5amr16020839edb.231.1646746884100;
        Tue, 08 Mar 2022 05:41:24 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id sd21-20020a170906ce3500b006da97cf5a30sm5541016ejb.177.2022.03.08.05.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:41:23 -0800 (PST)
Date:   Tue, 8 Mar 2022 15:41:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/1] net: dsa: microchip: ksz9477: implement
 MTU configuration
Message-ID: <20220308134122.aa4sckpski7t2aqg@skbuf>
References: <20220308133657.1099344-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308133657.1099344-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 02:36:57PM +0100, Oleksij Rempel wrote:
> This chips supports two ways to configure max MTU size:
> - by setting SW_LEGAL_PACKET_DISABLE bit: if this bit is 0 allowed packed size
>   will be between 64 and bytes 1518. If this bit is 1, it will accept
>   packets up to 2000 bytes.
> - by setting SW_JUMBO_PACKET bit. If this bit is set, the chip will
>   ignore SW_LEGAL_PACKET_DISABLE value and use REG_SW_MTU__2 register to
>   configure MTU size.
> 
> Current driver has disabled SW_JUMBO_PACKET bit and activates
> SW_LEGAL_PACKET_DISABLE. So the switch will pass all packets up to 2000 without
> any way to configure it.
> 
> By providing port_change_mtu we are switch to SW_JUMBO_PACKET way and will
> be able to configure MTU up to ~9000.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> changes v4:
> - fix MTU for VLAN
> changes v3:
> - do more testing and fix mtu configuration
> changes v2:
> - rename max_mtu to max_frame and new_mtu to frame_size
> - use max() instead of if(>)
> ---
>  drivers/net/dsa/microchip/ksz9477.c     | 36 +++++++++++++++++++++++--
>  drivers/net/dsa/microchip/ksz9477_reg.h |  3 +++
>  drivers/net/dsa/microchip/ksz_common.h  |  1 +
>  3 files changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index 94ad6d9504f4..f9e4d5a98f8c 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -11,6 +11,7 @@
>  #include <linux/platform_data/microchip-ksz.h>
>  #include <linux/phy.h>
>  #include <linux/if_bridge.h>
> +#include <linux/if_vlan.h>
>  #include <net/dsa.h>
>  #include <net/switchdev.h>
>  
> @@ -182,6 +183,29 @@ static void ksz9477_port_cfg32(struct ksz_device *dev, int port, int offset,
>  			   bits, set ? bits : 0);
>  }
>  
> +static int ksz9477_change_mtu(struct dsa_switch *ds, int port, int mtu)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	u16 frame_size, max_frame = 0;
> +	int i;
> +
> +	frame_size = mtu + ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN;

Nitpick: ETH_HLEN + VLAN_HLEN == VLAN_ETH_HLEN.

> +
> +	/* Cache the per-port MTU setting */
> +	dev->ports[port].max_frame = frame_size;
> +
> +	for (i = 0; i < dev->port_cnt; i++)
> +		max_frame = max(max_frame, dev->ports[i].max_frame);
> +
> +	return regmap_update_bits(dev->regmap[1], REG_SW_MTU__2,
> +				  REG_SW_MTU_MASK, max_frame);
> +}
> +
> +static int ksz9477_max_mtu(struct dsa_switch *ds, int port)
> +{
> +	return KSZ9477_MAX_FRAME_SIZE - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN;
> +}
> +
>  static int ksz9477_wait_vlan_ctrl_ready(struct ksz_device *dev)
>  {
>  	unsigned int val;
> @@ -1416,8 +1440,14 @@ static int ksz9477_setup(struct dsa_switch *ds)
>  	/* Do not work correctly with tail tagging. */
>  	ksz_cfg(dev, REG_SW_MAC_CTRL_0, SW_CHECK_LENGTH, false);
>  
> -	/* accept packet up to 2000bytes */
> -	ksz_cfg(dev, REG_SW_MAC_CTRL_1, SW_LEGAL_PACKET_DISABLE, true);
> +	/* Enable REG_SW_MTU__2 reg by setting SW_JUMBO_PACKET */
> +	ksz_cfg(dev, REG_SW_MAC_CTRL_1, SW_JUMBO_PACKET, true);
> +
> +	/* Now we can configure default MTU value */
> +	ret = regmap_update_bits(dev->regmap[1], REG_SW_MTU__2, REG_SW_MTU_MASK,
> +				 VLAN_ETH_FRAME_LEN + ETH_FCS_LEN);
> +	if (ret)
> +		return ret;
>  
>  	ksz9477_config_cpu_port(ds);
>  
> @@ -1464,6 +1494,8 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
>  	.port_mirror_add	= ksz9477_port_mirror_add,
>  	.port_mirror_del	= ksz9477_port_mirror_del,
>  	.get_stats64		= ksz9477_get_stats64,
> +	.port_change_mtu	= ksz9477_change_mtu,
> +	.port_max_mtu		= ksz9477_max_mtu,
>  };
>  
>  static u32 ksz9477_get_port_addr(int port, int offset)
> diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
> index 16939f29faa5..0bd58467181f 100644
> --- a/drivers/net/dsa/microchip/ksz9477_reg.h
> +++ b/drivers/net/dsa/microchip/ksz9477_reg.h
> @@ -176,6 +176,7 @@
>  #define REG_SW_MAC_ADDR_5		0x0307
>  
>  #define REG_SW_MTU__2			0x0308
> +#define REG_SW_MTU_MASK			GENMASK(13, 0)
>  
>  #define REG_SW_ISP_TPID__2		0x030A
>  
> @@ -1662,4 +1663,6 @@
>  /* 148,800 frames * 67 ms / 100 */
>  #define BROADCAST_STORM_VALUE		9969
>  
> +#define KSZ9477_MAX_FRAME_SIZE		9000
> +
>  #endif /* KSZ9477_REGS_H */
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index 4ff0a159ce3c..fa39ee73cbd2 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -41,6 +41,7 @@ struct ksz_port {
>  
>  	struct ksz_port_mib mib;
>  	phy_interface_t interface;
> +	u16 max_frame;
>  };
>  
>  struct ksz_device {
> -- 
> 2.30.2
> 

