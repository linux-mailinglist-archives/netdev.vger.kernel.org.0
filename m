Return-Path: <netdev+bounces-4036-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D9C070A355
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 01:28:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09C18281C0B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 23:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0153B568B;
	Fri, 19 May 2023 23:28:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5E33D3B1
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 23:28:08 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80D4E2;
	Fri, 19 May 2023 16:28:06 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-96f5685f902so254744366b.2;
        Fri, 19 May 2023 16:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684538885; x=1687130885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FmALGiwKdo85IV/l0yKB8MZ/9Xqr37x53vqm7mgmBgM=;
        b=FSeQaWvLvlTWLX+Wh59wvsH+HF+fbvpAth0Hn6eOVSj6wIInENUntetyCxaX0m/EFR
         dtQnrSWzlFHK8vrcFJm0yoHCiL9xfaMeWPoI9ysxyY0BnAHtis7x8E8ZjGKR9Cz9g8s4
         NPjO5rNRjpkMZnt/AzasKYg5OFWYO28V+r6vIgPB38YAs8VtB42ad9Gm3c7cMO7QE+Mh
         dL7NZErttetyFbcjvWCDXfCFt+Gu9kwgCytOLfAuHY5bnZGcX8qrxCflaOk1ermJXVCS
         c/5nVRBh/ZP7YBog8jrszOiH45emtNnrSqV9hsxPvdv0lwCytuSk812LFiI+z76nE3S8
         A4PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684538885; x=1687130885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FmALGiwKdo85IV/l0yKB8MZ/9Xqr37x53vqm7mgmBgM=;
        b=iCFfsFccSgLwaFfxJdFCii1XuWRhIyImRihHFFrIkTUkGoUraNSrKcl8Z1gcp8bqV4
         N2kKrrPW7rjaSrtyktjZU63Ux+BsL9r5ll63+jMts3wXdJ4qnTkNMQGTFC0FeF4t56QD
         1rvu+ij/RF6ptvHV/i8sS6XrS6dTAMG8reqWSSVcB8FZRHOLlpbZv30FqJ9lp0m4Qo0D
         pvVTjM6g51abb+4APb5gyVjHaDGf11GlOzG0vXEgPZ3+ZE+P0AfEhNcyBJTYyf2V77VO
         jLrUmcChYoVXW9uDbaB1DpE3ODcFty1PXchECEHcJURVcvSws6lajThx3h5Kjo1/ZHbx
         kJ3g==
X-Gm-Message-State: AC+VfDwum2xs+xOhiqh7jNTJpulSk9GUUvjxqTe9R7qLd5DSNhy7gIkK
	3MdT/FFUZU3KsKeVhHcZOL4=
X-Google-Smtp-Source: ACHHUZ5lbAwc8qalxxymZAlUqnfwWjFjOOkvfigqS+2G3CMGnmkLoGZZcQ/oOmPRlw5Dvu5Ym3ljkA==
X-Received: by 2002:a17:907:72c7:b0:96f:6a91:40e3 with SMTP id du7-20020a17090772c700b0096f6a9140e3mr3663113ejc.49.1684538884652;
        Fri, 19 May 2023 16:28:04 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id w26-20020a170907271a00b0096599bf7029sm157963ejk.145.2023.05.19.16.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 16:28:04 -0700 (PDT)
Date: Sat, 20 May 2023 02:28:02 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Simon Horman <simon.horman@corigine.com>, kernel@pengutronix.de,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v4 1/2] net: dsa: microchip: ksz8: Make flow
 control, speed, and duplex on CPU port configurable
Message-ID: <20230519232802.ae34asc4zgfmv3u4@skbuf>
References: <20230519124700.635041-1-o.rempel@pengutronix.de>
 <20230519124700.635041-1-o.rempel@pengutronix.de>
 <20230519124700.635041-2-o.rempel@pengutronix.de>
 <20230519124700.635041-2-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519124700.635041-2-o.rempel@pengutronix.de>
 <20230519124700.635041-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 02:46:59PM +0200, Oleksij Rempel wrote:
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index f56fca1b1a22..9eedccbf5b7c 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -1371,6 +1371,57 @@ void ksz8_config_cpu_port(struct dsa_switch *ds)
> +/**
> + * ksz8_cpu_port_link_up - Configures the CPU port of the switch.
> + * @dev: The KSZ device instance.
> + * @speed: The desired link speed.
> + * @duplex: The desired duplex mode.
> + * @tx_pause: If true, enables transmit pause.
> + * @rx_pause: If true, enables receive pause.
> + *
> + * Description:
> + * The function configures flow control and speed settings for the CPU
> + * port of the switch based on the desired settings, current duplex mode, and
> + * speed.
> + */
> +static void ksz8_cpu_port_link_up(struct ksz_device *dev, int speed, int duplex,
> +				  bool tx_pause, bool rx_pause)
> +{
> +	u8 ctrl = 0;
> +
> +	/* SW_FLOW_CTRL, SW_HALF_DUPLEX, and SW_10_MBIT bits are bootstrappable
> +	 * at least on KSZ8873. They can have different values depending on your
> +	 * board setup.
> +	 */
> +	if (duplex) {
> +		if (tx_pause || rx_pause)
> +			ctrl |= SW_FLOW_CTRL;
> +	} else {
> +		ctrl |= SW_HALF_DUPLEX;
> +	}
> +
> +	/* This hardware only supports SPEED_10 and SPEED_100. For SPEED_10
> +	 * we need to set the SW_10_MBIT bit. Otherwise, we can leave it 0.
> +	 */
> +	if (speed == SPEED_10)
> +		ctrl |= SW_10_MBIT;
> +
> +	ksz_rmw8(dev, REG_SW_CTRL_4, SW_HALF_DUPLEX | SW_FLOW_CTRL |
> +		 SW_10_MBIT, ctrl);

REG_SW_CTRL_4 ... S_REPLACE_VID_CTRL ... dev->info->regs[P_XMII_CTRL_1] ...
at some point we will need one more consolidation effort here, since we
have at least 3 ways of reaching the same register.

> +}
> +
> +void ksz8_phylink_mac_link_up(struct ksz_device *dev, int port,
> +			      unsigned int mode, phy_interface_t interface,
> +			      struct phy_device *phydev, int speed, int duplex,
> +			      bool tx_pause, bool rx_pause)
> +{
> +	/* If the port is the CPU port, apply special handling. Only the CPU
> +	 * port is configured via global registers.
> +	 */
> +	if (dev->cpu_port == port)
> +		ksz8_cpu_port_link_up(dev, speed, duplex, tx_pause, rx_pause);
> +}
> +
>  static int ksz8_handle_global_errata(struct dsa_switch *ds)
>  {
>  	struct ksz_device *dev = ds->priv;
> @@ -1419,8 +1470,6 @@ int ksz8_setup(struct dsa_switch *ds)
>  	 */
>  	ds->vlan_filtering_is_global = true;
>  
> -	ksz_cfg(dev, S_REPLACE_VID_CTRL, SW_FLOW_CTRL, true);
> -
>  	/* Enable automatic fast aging when link changed detected. */
>  	ksz_cfg(dev, S_LINK_AGING_CTRL, SW_LINK_AUTO_AGING, true);
>  
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index a4428be5f483..6e19ad70c671 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -210,6 +210,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
>  	.mirror_add = ksz8_port_mirror_add,
>  	.mirror_del = ksz8_port_mirror_del,
>  	.get_caps = ksz8_get_caps,
> +	.phylink_mac_link_up = ksz8_phylink_mac_link_up,

Another future consolidation to consider: since all ksz_dev_ops now
provide .phylink_mac_link_up(), the "if" condition here is no longer
necessary:

static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
				    unsigned int mode,
				    phy_interface_t interface,
				    struct phy_device *phydev, int speed,
				    int duplex, bool tx_pause, bool rx_pause)
{
	struct ksz_device *dev = ds->priv;

	if (dev->dev_ops->phylink_mac_link_up)
		dev->dev_ops->phylink_mac_link_up(dev, port, mode, interface,
						  phydev, speed, duplex,
						  tx_pause, rx_pause);
}

which reminds me of the fact that I also had a patch to remove
dev->dev_ops->phylink_mac_config():
https://patchwork.kernel.org/project/netdevbpf/patch/20230316161250.3286055-5-vladimir.oltean@nxp.com/

I give up with that patch set now, since there's zero reviewer interest.
If you want and you think it's useful, you might want to adapt it for
KSZ8873.

>  	.config_cpu_port = ksz8_config_cpu_port,
>  	.enable_stp_addr = ksz8_enable_stp_addr,
>  	.reset = ksz8_reset_switch,
> -- 
> 2.39.2
> 

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

