Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83AF34FA030
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 01:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240054AbiDHXn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 19:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiDHXn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 19:43:26 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57012A87AB;
        Fri,  8 Apr 2022 16:41:21 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id t19so157888edi.9;
        Fri, 08 Apr 2022 16:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JIxwWgv2/Iovzx5BhWwFfLIbXsk750A9agrA8TKxKD0=;
        b=qWN+Sns9Mk9vMooKBcK1GxVy8fnW0ip2rbcNoyH8/Sz7rK4Wqe9mROrbMsRWn8zh+l
         s+ryG9c4vrB1kRmpELYhT+xmsi464LuKZDnzvumxaHk2FCo4TUGu8VEFSRvBU0O5T8r2
         a2XHe2NEzqy6tlcF9rsVaQ3Nx0GJE+W4dCvI5Z065SZUItWp2Coi9Vf12TfYteKZ61wm
         3eGgM8xnNLnAOK8ihwXzFu/prvcfxVVuBrUuxHDIglakE2YQeTolSdm/84gCKAKyl9bi
         0kbdw7Bih5yZezxjndJz8Fbt8udnQya1Dv7fmQyHPVgB82EIcqGWXiMaMYos5DthXvUN
         oiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JIxwWgv2/Iovzx5BhWwFfLIbXsk750A9agrA8TKxKD0=;
        b=pnpsd30x14LHmvizd/hC3aSRevF+d3IX12Vhi85WST+ATrLf6ZELVD/4jk7wnRf8Wh
         oEbLHtlcQp3R5XV5jMwnG4QhHwjVL7RsLEaJQ42SjcjST8FUadYYPFDLg6BVUI6yP7yk
         zwfI/1rTX88NUTJoxAQxmQ4AB76koqY6oiwqQUIVOn+HRRfCIDJTkZUPM74Wc2PTB3DU
         /Fvc2AQNpVHplVMHR1ET+ZPtgw6G9NE/hN8IfcNFU+gTTs5bUpKCirbhJbN/aftQCXF6
         1hgB9zDPSUiPMCFCcgjBArMIzril/HFRyUil5EMwEPQeJ/GE40lnm7MMpT3KrGqyWehQ
         vNTg==
X-Gm-Message-State: AOAM5331hOBKQUIiw4mfjXCWz5UoZldHWoQYnjOC7mFk2m3URTcYWnDJ
        /7hanuHRgHDA5McV7pn6Bl8=
X-Google-Smtp-Source: ABdhPJxHl5ER/WNc99TfXscPrkjp0ycwJxUSdYpBZwZanrCmVKqOZ3S/keY/uyRvb10q4N27hGA7MQ==
X-Received: by 2002:a05:6402:9:b0:419:3c6e:b0d5 with SMTP id d9-20020a056402000900b004193c6eb0d5mr21906989edu.216.1649461280104;
        Fri, 08 Apr 2022 16:41:20 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id h7-20020a1709066d8700b006d4b4d137fbsm9207296ejt.50.2022.04.08.16.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 16:41:19 -0700 (PDT)
Date:   Sat, 9 Apr 2022 02:41:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org, pabeni@redhat.com
Subject: Re: [RFC PATCH v11 net-next 06/10] net: dsa: microchip: add support
 for phylink management
Message-ID: <20220408234118.fwmek5ikk2vpsclo@skbuf>
References: <20220325165341.791013-1-prasanna.vengateshan@microchip.com>
 <20220325165341.791013-7-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325165341.791013-7-prasanna.vengateshan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 10:23:37PM +0530, Prasanna Vengateshan wrote:
> phylink_get_caps() is implemented and reused KSZ commmon API for
> phylink_mac_link_down() operation
> 
> lan937x_phylink_mac_config configures the interface using
> lan937x_mac_config and lan937x_phylink_mac_link_up configures
> the speed/duplex/flow control.
> 
> Currently SGMII & in-band neg are not supported & it will be
> added later.

If SGMII is also an option, then what you're doing in
lan937x_parse_dt_rgmii_delay() looks wrong:

		/* skip for internal ports */
		if (lan937x_is_internal_phy_port(dev, p))
			continue;

		if (of_property_read_u32(port, "rx-internal-delay-ps", &val))
			val = 0;

		err = lan937x_set_rgmii_delay(dev, p, val, false);
		if (err)
			break;

Right now you assume that "isn't internal PHY" is the same as "is RGMII",
but this is not actually the future-proof way of doing things. Also
please consider that the driver you write now may end up booting on a DT
blob from the future. Do you do something sane when a port is configured
for a phy-mode you don't recognize? For one thing, you try to configure
RGMII delays on it, as far as I can see.

> +static void lan937x_phylink_get_caps(struct dsa_switch *ds, int port,
> +				     struct phylink_config *config)
> +{
> +	struct ksz_device *dev = ds->priv;
> +
> +	/* non legacy driver */
> +	config->legacy_pre_march2020 = false;
> +
> +	config->mac_capabilities = MAC_100FD;
> +
> +	/* internal T1 PHY */
> +	if (lan937x_is_internal_base_t1_phy_port(dev, port)) {
> +		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
> +			  config->supported_interfaces);
> +	} else if (lan937x_is_rgmii_port(dev, port)) {
> +		/* MII/RMII/RGMII ports */
> +		config->mac_capabilities |= MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
> +					    MAC_100HD | MAC_10 | MAC_1000FD;
> +		phy_interface_set_rgmii(config->supported_interfaces);
> +
> +		__set_bit(PHY_INTERFACE_MODE_MII,
> +			  config->supported_interfaces);
> +		__set_bit(PHY_INTERFACE_MODE_RMII,
> +			  config->supported_interfaces);
> +	}

No supported_interfaces for the 100base-TX internal PHY port? Does it
pass validation?

> +}
> +
>  const struct dsa_switch_ops lan937x_switch_ops = {
>  	.get_tag_protocol = lan937x_get_tag_protocol,
>  	.setup = lan937x_setup,
> @@ -307,6 +369,10 @@ const struct dsa_switch_ops lan937x_switch_ops = {
>  	.port_fast_age = ksz_port_fast_age,
>  	.port_max_mtu = lan937x_get_max_mtu,
>  	.port_change_mtu = lan937x_change_mtu,
> +	.phylink_get_caps = lan937x_phylink_get_caps,
> +	.phylink_mac_link_down = ksz_mac_link_down,
> +	.phylink_mac_config = lan937x_phylink_mac_config,
> +	.phylink_mac_link_up = lan937x_phylink_mac_link_up,
>  };
>  
>  int lan937x_switch_register(struct ksz_device *dev)
> -- 
> 2.30.2
> 
