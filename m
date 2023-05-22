Return-Path: <netdev+bounces-4195-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77E7670B975
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:54:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C1C71C209E2
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DEF3A94C;
	Mon, 22 May 2023 09:54:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C559466
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 09:54:07 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24B7C2;
	Mon, 22 May 2023 02:54:05 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f60410106cso6456685e9.1;
        Mon, 22 May 2023 02:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684749244; x=1687341244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MEuzhFmkjv49oIHWTSsc95Gkq+Cq33yvkFKwJTX5pLg=;
        b=jkzJW8SHQev1F2HV8NsE8ATC7sbu2GnYBYdHqirLYxDoEiiVUOMdzv/+wdF4+dbiYC
         wp+jKM4fMmIob4BM1BtEfGNuRCmEdH9jTVouCGnIF+sZPYCdXLx9DU8gLl8kF3lMULPI
         wmpJNaydSGESwb/OqRVoJ03QebvzaB7Gu5E0WW6UADgrPnQkBnRxUCgOiFtZhSAdKeR7
         zjRQwDt34QCAjwAYfQAGSxtsQyY5HQhY4eSVBstRvxxoWUfzS7yn3vwaBYkUxNvGUBjQ
         H4DrWWlxMYqenkC107wWBQ40ed6vZVnVKASBqbTW/Xuy2x7U1l6jyJPjXRXRMP3mJXvG
         0tmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684749244; x=1687341244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MEuzhFmkjv49oIHWTSsc95Gkq+Cq33yvkFKwJTX5pLg=;
        b=imzH2VM3jIElQAb+fqaoxw1X0AtrlNiv/dLaZ+oy/L30R1TLaeW0+7CsxzrvO1lsjZ
         WtECPdLGeNbV0kt9nibJJv047lCv1sBa8a0R6I+4SadKeaz8GbYYWBm3+KN8FP3QdsFi
         qRyiRnGOaNQ66w8hfsDEcIl83adgvax1xViqs1UZzWN+xW427GBSztZL0avJ5MoRl9Mg
         xA6tAifl02OYKoe0led0j+if3rq+in76N47Eno3C0NHVaOrfu8kN7HwwPDLTRm1nkd4D
         RVA0sGYBSSbMiHOHGeBP1Es44reNW2RhZd5k7a8ccB3oznQ2W6dmjfmHqcf2zB4kOz1w
         A+UQ==
X-Gm-Message-State: AC+VfDx9Pr6eCTQrbV19MtdY2yc8Pxxy1mBqo8Sj17kgbBpiwfqCErhL
	Xj/FMcjiip05Szzxfbxmi/I=
X-Google-Smtp-Source: ACHHUZ7TFbXIkUzmeQjsmyXJ+Dplh283L9u5CAaduxA6qRDS8nD958XMlQtli6CT6ul+iIN2I84LSQ==
X-Received: by 2002:a05:600c:294b:b0:3f4:2d22:536a with SMTP id n11-20020a05600c294b00b003f42d22536amr6988436wmd.19.1684749243903;
        Mon, 22 May 2023 02:54:03 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id v16-20020a1cf710000000b003f4fe09aa43sm11099141wmh.8.2023.05.22.02.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 02:54:03 -0700 (PDT)
Date: Mon, 22 May 2023 12:54:01 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: David Epping <david.epping@missinglinkelectronics.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net 3/3] net: phy: mscc: enable VSC8501/2 RGMII RX clock
Message-ID: <20230522095401.szzugrjohnwyqffk@skbuf>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
 <20230521134356.ar3itavhdypnvasc@skbuf>
 <20230521161650.GC2208@nucnuc.mle>
 <20230522094944.uylvgoepcmwjq5yj@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522094944.uylvgoepcmwjq5yj@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 12:49:44PM +0300, Vladimir Oltean wrote:
> Well, to be clear, I was suggesting:
> 
> /* Set the RGMII RX and TX clock skews individually, according to the PHY
>  * interface type, to:
>  *  * 0.2 ns (their default, and lowest, hardware value) if delays should
>  *    not be enabled
>  *  * 2.0 ns (which causes the data to be sampled at exactly half way between
>  *    clock transitions at 1000 Mbps) if delays should be enabled
>  */
> static int vsc85xx_rgmii_set_skews(struct phy_device *phydev, u32 rgmii_cntl,
> 				   u16 rgmii_rx_delay_mask,
> 				   u16 rgmii_tx_delay_mask)
> {
> 	u16 rgmii_rx_delay_pos = ffs(rgmii_rx_delay_mask) - 1;
> 	u16 rgmii_tx_delay_pos = ffs(rgmii_tx_delay_mask) - 1;
> 	u16 mask = rgmii_rx_delay_mask | rgmii_tx_delay_mask;
> 	u16 reg_val = 0;
> 	int rc;

Or rather:

	u16 mask = 0;

	if (phy_interface_is_rgmii(phydev))
		mask |= rgmii_rx_delay_mask | rgmii_tx_delay_mask;

	if (rgmii_cntl == VSC8502_RGMII_CNTL)
		mask |= VSC8502_RGMII_RX_CLK_DISABLE;

> 
> 	/* For traffic to pass, the VSC8502 family needs the RX_CLK disable bit
> 	 * to be unset for all PHY modes, so do that as part of the paged
> 	 * register modification.
> 	 */
> 	if (rgmii_cntl == VSC8502_RGMII_CNTL)
> 		mask |= VSC8502_RGMII_RX_CLK_DISABLE;
> 
> 	mutex_lock(&phydev->lock);
> 
> 	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
> 	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
> 		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_rx_delay_pos;
> 	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
> 	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
> 		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_tx_delay_pos;
> 
> 	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
> 			      rgmii_cntl, mask, reg_val);
> 
> 	mutex_unlock(&phydev->lock);
> 
> 	return rc;
> }

