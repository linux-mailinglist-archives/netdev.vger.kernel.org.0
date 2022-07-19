Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA0457979C
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 12:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbiGSKZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 06:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiGSKZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 06:25:39 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64EA65CB;
        Tue, 19 Jul 2022 03:25:37 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id l23so26315536ejr.5;
        Tue, 19 Jul 2022 03:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=79stGUDjiIvSTBTITvBtORp7fUzrA42I+ntSCDn7U3I=;
        b=J0L6KUAVUp+XIgoCfFQeM+RHvU73eb3vFmWlQWyZ3UBIjdN2iJdC5JpwfEo/gMru1g
         XvPcNkABUXJC1cceJgg+yKvJRtmgk8g2E051YqoaX0LRP0ecZud0Jo1ZBb6diemhSr2z
         D/yaA1k21tk09WFX2dxr2U53wf18l4UevkGInhJmqclYSdrquLRzhYv1QBgmw58H3mWS
         8ftXY26pWHIias3O46K7y4GkWJZddnlc7WPPlUJt3SHHyTADKcHK2TSiGFdFckLYp8pd
         qYytCeW4vIHzTMzUzqbkr4CS4XGshPkYhKYnMWEOv1Bu9BsvkU3D0cRP0TLPiH2GsMgE
         e4MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=79stGUDjiIvSTBTITvBtORp7fUzrA42I+ntSCDn7U3I=;
        b=WNdYfghv27Gwt/XSN6ZWkzVT5TuhdoqdQ6oC+sikSRVc/bdPDzW0Qlr1OzttImxvw2
         DV/jzZlWFoMpe3teK7s/83zLCCcJeR6JUm0RvVerGVzdK30Krze9d81miYsJVSWxsf0N
         qlLpCfpuL/n2plmCy3nTWEqlyEGu52lzs5VuwP+QL3ON/oHGPTdWpJw3z1sjSXAiAKsA
         koj8arcv289eeSD15pVMMluQa8EVubB/VVcLRQNwYyFEQseYLG47yjXtug4FIELbjkyI
         ETmblNjOH2TIphtKqiGVKEK2HIj20ZejnH2jrOkpgBHNcVOjtwlkTKK9M0mvnETARyKT
         gM9Q==
X-Gm-Message-State: AJIora8TGHbf/hVQDhgfQEhPMCIkKf1o52diEvLvzk6gtKv7xoTJvmJY
        FPtYm5lJ3CKYtksGqUXMLXY=
X-Google-Smtp-Source: AGRyM1uP/xQdXhJYPxu+bN8brQ0L7+35XCs4fnR46Y3zvI8qkrQRtiQMmKG1yxzibYCZxWQvU2C5Wg==
X-Received: by 2002:a17:907:67b0:b0:72b:7792:5e0a with SMTP id qu48-20020a17090767b000b0072b77925e0amr29758635ejc.400.1658226335588;
        Tue, 19 Jul 2022 03:25:35 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id l10-20020a1709060cca00b0070b7875aa6asm6448933ejh.166.2022.07.19.03.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 03:25:34 -0700 (PDT)
Date:   Tue, 19 Jul 2022 13:25:32 +0300
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
Subject: Re: [RFC Patch net-next 07/10] net: dsa: microchip: apply rgmii tx
 and rx delay in phylink mac config
Message-ID: <20220719102532.ndny6lrcxwwte7gw@skbuf>
References: <20220712160308.13253-1-arun.ramadoss@microchip.com>
 <20220712160308.13253-8-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712160308.13253-8-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 09:33:05PM +0530, Arun Ramadoss wrote:
> This patch apply the rgmii delay to the xmii tune adjust register based
> on the interface selected in phylink mac config. There are two rgmii
> port in LAN937x and value to be loaded in the register vary depends on
> the port selected.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/dsa/microchip/lan937x_main.c | 61 ++++++++++++++++++++++++
>  drivers/net/dsa/microchip/lan937x_reg.h  | 18 +++++++
>  2 files changed, 79 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
> index d86ffdf976b0..db88ea567ba6 100644
> --- a/drivers/net/dsa/microchip/lan937x_main.c
> +++ b/drivers/net/dsa/microchip/lan937x_main.c
> @@ -315,6 +315,45 @@ int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu)
>  	return 0;
>  }
>  
> +static void lan937x_set_tune_adj(struct ksz_device *dev, int port,
> +				 u16 reg, u8 val)
> +{
> +	u16 data16;
> +
> +	ksz_pread16(dev, port, reg, &data16);
> +
> +	/* Update tune Adjust */
> +	data16 |= FIELD_PREP(PORT_TUNE_ADJ, val);
> +	ksz_pwrite16(dev, port, reg, data16);
> +
> +	/* write DLL reset to take effect */
> +	data16 |= PORT_DLL_RESET;
> +	ksz_pwrite16(dev, port, reg, data16);
> +}
> +
> +static void lan937x_set_rgmii_tx_delay(struct ksz_device *dev, int port)
> +{
> +	u8 val;
> +
> +	/* Apply different codes based on the ports as per characterization
> +	 * results
> +	 */

What characterization result are you referring to? Individual board
designers should do their own characterization, that's why they provide
a p->rgmii_tx_val in the device tree. The value provided there seems to
be ignored and unconditionally replaced with 2 ns here.

> +	val = (port == LAN937X_RGMII_1_PORT) ? RGMII_1_TX_DELAY_2NS :
> +		RGMII_2_TX_DELAY_2NS;
> +
> +	lan937x_set_tune_adj(dev, port, REG_PORT_XMII_CTRL_5, val);
> +}
> +
> +static void lan937x_set_rgmii_rx_delay(struct ksz_device *dev, int port)
> +{
> +	u8 val;
> +
> +	val = (port == LAN937X_RGMII_1_PORT) ? RGMII_1_RX_DELAY_2NS :
> +		RGMII_2_RX_DELAY_2NS;
> +
> +	lan937x_set_tune_adj(dev, port, REG_PORT_XMII_CTRL_4, val);
> +}
> +
>  void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
>  			      struct phylink_config *config)
>  {
> @@ -331,6 +370,9 @@ void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
>  				unsigned int mode,
>  				const struct phylink_link_state *state)
>  {
> +	phy_interface_t interface = state->interface;
> +	struct ksz_port *p = &dev->ports[port];
> +
>  	/* Internal PHYs */
>  	if (dev->info->internal_phy[port])
>  		return;
> @@ -341,6 +383,25 @@ void lan937x_phylink_mac_config(struct ksz_device *dev, int port,
>  	}
>  
>  	ksz_set_xmii(dev, port, state->interface);
> +
> +	/* if the delay is 0, do not enable DLL */
> +	if (interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    interface == PHY_INTERFACE_MODE_RGMII_RXID) {

Why not all RGMII modes and only these 2? There was a discussion a long
time ago that the "_*ID" values refer to delays applied by an attached PHY.
Here you are refusing to apply RGMII TX delays in the "rgmii" and "rgmii-txid"
modes.

> +		if (p->rgmii_tx_val) {
> +			lan937x_set_rgmii_tx_delay(dev, port);
> +			dev_info(dev->dev, "Applied rgmii tx delay for the port %d\n",
> +				 port);
> +		}
> +	}
> +
> +	if (interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> +		if (p->rgmii_rx_val) {
> +			lan937x_set_rgmii_rx_delay(dev, port);
> +			dev_info(dev->dev, "Applied rgmii rx delay for the port %d\n",
> +				 port);
> +		}
> +	}
>  }
>  
