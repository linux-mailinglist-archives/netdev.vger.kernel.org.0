Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2984C1FF1
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245075AbiBWXjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244971AbiBWXjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:39:31 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C805A597;
        Wed, 23 Feb 2022 15:38:37 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id x5so509988edd.11;
        Wed, 23 Feb 2022 15:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=whDwH2zPitIeQOUUdx6d4kE8joYGIUm+H6ZjSRJ73C8=;
        b=fP3R1s5LlGzdldvNhELT+AzSKqVuroeCFRjURy+R5jV670SSuLQMH1hPx8hFcYAROE
         H0MVN9lOPkkscxhCeBbwuBS7nJOh4Y3WDqf92Jwm3izQMh3mLZCgK+yP8V/mSSne6WVt
         QuC82aSvQHfhA9QQjsBnA3z1YVwOOR/Y+QwrNuITg+DBuq3jygUk7Tuj30Mf42ISU5vs
         u1EC3x35bZlxPXgclUi0NZJ9um7UfnsWxwYqXyfd0tpILFEXeD8ljpou9e3vwsPRMfRD
         Fq7/sgB0z9gQjfG97fpelY388/A7f4P6S3w4kPnknTl4ZRC3+1kEG4F/P9sLZA78LeVo
         G1zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=whDwH2zPitIeQOUUdx6d4kE8joYGIUm+H6ZjSRJ73C8=;
        b=ogm7BtSKYsips2EZ5pQNLbYTNuSTLbN5Md6P/XQpT52ZPqNk6NCKFzP1VmXr459ZkC
         73iBJyDN+CUQssscitdJpQukvuILNYE6xVQ6jDnUgf9aZHK99YHyIWeNspR6pex2zLci
         FzfrENjJqoxijlv4z6fhdANuipNv9deqgK8QFItaS5SmcRnVxvmTfJkuTkzLy5RqcHDb
         fwxg6nwsO1FB1q1QoMwwFkSsaSKcWVVtr3dPhwLwawpuVAOSOm5+zQGSlCylXrGSEYND
         w0BmODtHevel01bEiOkp6nkSHoZIH3etumV9EQVv5U4uhObmzXUVdRL+hqomQQBYqHii
         ZE0w==
X-Gm-Message-State: AOAM530TbvVplIBXODaTA7BLOPxVz5raCQEBlh0SYWqpjFJYYpwQXODX
        7rw8rSgf28sJhxWeLHXVx80=
X-Google-Smtp-Source: ABdhPJw4EKDZ+eF1ilXeLE5Vko0osaUG7tolZ8skj7t+blXjsRjY4xbCjcr/AOso+e4kNjG1j+a12g==
X-Received: by 2002:a05:6402:2707:b0:410:d100:6937 with SMTP id y7-20020a056402270700b00410d1006937mr1669538edd.428.1645659515675;
        Wed, 23 Feb 2022 15:38:35 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id v16sm448322ejo.156.2022.02.23.15.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 15:38:35 -0800 (PST)
Date:   Thu, 24 Feb 2022 01:38:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/1] net: dsa: microchip: ksz9477: implement
 MTU configuration
Message-ID: <20220223233833.mjknw5ko7hpxj3go@skbuf>
References: <20220223084055.2719969-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223084055.2719969-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 09:40:55AM +0100, Oleksij Rempel wrote:
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
> changes v2:
> - rename max_mtu to max_frame and new_mtu to frame_size
> - use max() instead of if(>)
> ---
>  drivers/net/dsa/microchip/ksz9477.c     | 40 +++++++++++++++++++++++--
>  drivers/net/dsa/microchip/ksz9477_reg.h |  4 +++
>  drivers/net/dsa/microchip/ksz_common.h  |  1 +
>  3 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index 18ffc8ded7ee..5c5f78cb970e 100644
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
> @@ -182,6 +183,33 @@ static void ksz9477_port_cfg32(struct ksz_device *dev, int port, int offset,
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

Are you sure the unit of measurement is ok? My KSZ9477 documentation
says this about register 0x0308:

Maximum Frame Length (MTU)
Specifies the maximum transmission unit (MTU), which is the maximum
frame payload size. Frames which exceed this maximum are truncated. This
value can be set as high as 9000 (= 0x2328) if jumbo frame support is
required.

"frame payload" to me means what MTU should mean. And ETH_HLEN +
VLAN_HLEN + ETH_FCS_LEN isn't part of that meaning.

> +
> +	if (dsa_is_cpu_port(ds, port))
> +		frame_size += KSZ9477_INGRESS_TAG_LEN;
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
> +	return KSZ9477_MAX_FRAME_SIZE - ETH_HLEN - ETH_FCS_LEN - VLAN_HLEN -
> +		KSZ9477_INGRESS_TAG_LEN;
> +}
> +
>  static int ksz9477_wait_vlan_ctrl_ready(struct ksz_device *dev)
>  {
>  	unsigned int val;
> @@ -1412,8 +1440,14 @@ static int ksz9477_setup(struct dsa_switch *ds)
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

Why do you need this? Doesn't DSA call dsa_slave_create() ->
dsa_slave_change_mtu(ETH_DATA_LEN) on probe?

> +	if (ret)
> +		return ret;
>  
>  	ksz9477_config_cpu_port(ds);
>  
> @@ -1460,6 +1494,8 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
>  	.port_mirror_add	= ksz9477_port_mirror_add,
>  	.port_mirror_del	= ksz9477_port_mirror_del,
>  	.get_stats64		= ksz9477_get_stats64,
> +	.port_change_mtu	= ksz9477_change_mtu,
> +	.port_max_mtu		= ksz9477_max_mtu,
>  };
>  
>  static u32 ksz9477_get_port_addr(int port, int offset)
> diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
> index 16939f29faa5..2278e763ee3e 100644
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
> @@ -1662,4 +1663,7 @@
>  /* 148,800 frames * 67 ms / 100 */
>  #define BROADCAST_STORM_VALUE		9969
>  
> +#define KSZ9477_INGRESS_TAG_LEN		2
> +#define KSZ9477_MAX_FRAME_SIZE		9000
> +
>  #endif /* KSZ9477_REGS_H */
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index c6fa487fb006..739365bfceb2 100644
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

