Return-Path: <netdev+bounces-4194-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B265070B953
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:49:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 759BA1C2099E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1CDEA947;
	Mon, 22 May 2023 09:49:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FC59471
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 09:49:50 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB863A3;
	Mon, 22 May 2023 02:49:48 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f60804faf4so1497875e9.3;
        Mon, 22 May 2023 02:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684748987; x=1687340987;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EFRx9HekdB5FKRI76p9VTNC9U8soCsA58g72bEm8O/Y=;
        b=c5qc1L0p8kKDqt6qKnDxH7g5ZyfVKQhBtL+1lHKg5dNbDjDeYVjX31g9KmMoZtINP9
         /emwpqzIOG5GSmE4Y5Rq+5a2onDQ8ZRUcSkXTMcyREDuu5w6+RfAJwRck/2OQs8MxFy/
         spJoWD3VS1SVv5WVxdpnkeOZTMnqohFYZGci8O2kTalwrh2aU/pv2bqNRKUVp5QCX9d/
         aMEWoh19aaxkarw6tGnxQResZLRUsWbDQfdJwVvQ7KZAI9G1VphGklu/uo8+exzrhww/
         +LPB2Zm4p95mcxGVuJT1SPRwqOeWn2eHlG91d3uPHCieXlWzAVgLXuiXE/l3FckBI1hN
         grOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684748987; x=1687340987;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EFRx9HekdB5FKRI76p9VTNC9U8soCsA58g72bEm8O/Y=;
        b=bMmDpsreuYwxoxlNL79eLGBc/+i1O6ppJMNJS8qOQnQXtvXisvBh5274qmYpiCZQR7
         b9AKcW4hpdx+U3n1J5x1ggUlvBO2FoOu21+4eYfIL5DSY7WFtl62t9dElY2q5Q8nFoXF
         Gxxa6F9icA95r37vIhRC7fugQ8DdnwlEsr4Npkz2Lntlje46GGyfZouWt/IbMo48MuYf
         OwRqkqNuSnFoWeA+pzZWApLpo6UVN/PEOBJ6bbLJJi22D2JS5/VEi4sFrbwalSZbSJkB
         WYpBLQNMIvB0jjO4uhjcFvjL22RKuw2+mtkHZaPR6Wcqor28vS7K2/qIYh1QR5+U95nd
         tsbg==
X-Gm-Message-State: AC+VfDyCxLDypF/J7eIstR8E4WkBltXsQ9rwa26qG1udEkAF4BBh6huh
	Y6MrPkUH3rUdAdqKYl21AF4=
X-Google-Smtp-Source: ACHHUZ70BKKiQ8uL6/lkdxghsTvs0EFjjRA4jvvnC/+6W2yzryBcB8uBpeetOrDVYAqs04pZqwUQSw==
X-Received: by 2002:a1c:c903:0:b0:3eb:42fc:fb30 with SMTP id f3-20020a1cc903000000b003eb42fcfb30mr7274423wmb.32.1684748986867;
        Mon, 22 May 2023 02:49:46 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id 3-20020a05600c230300b003f6042d6da0sm3133724wmo.16.2023.05.22.02.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 02:49:46 -0700 (PDT)
Date: Mon, 22 May 2023 12:49:44 +0300
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
Message-ID: <20230522094944.uylvgoepcmwjq5yj@skbuf>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
 <20230521134356.ar3itavhdypnvasc@skbuf>
 <20230521161650.GC2208@nucnuc.mle>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230521161650.GC2208@nucnuc.mle>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 21, 2023 at 06:16:50PM +0200, David Epping wrote:
> On Sun, May 21, 2023 at 04:43:56PM +0300, Vladimir Oltean wrote:
> > Not only bit 11 is reserved for VSC8530, but it's also read-only, so it
> > should not matter what is written there.
> 
> I agree and am ok with removing the PHY ID condition.
> 
> > Since vsc85xx_rgmii_enable_rx_clk() and vsc85xx_rgmii_set_skews() write
> > to the same register, would it not make sense to combine the two into a
> > single phy_modify_paged() call, and to zeroize bit 11 as part of that?
> 
> Since we found an explanation why the current driver works in some
> setups (U-Boot), I would go with the Microchip support statement, that
> writing bit 11 to 0 is required in all modes.
> It would thus stay a separate function, called without a phy mode
> condition, and not be combined with the RGMII skew setting function.
> 
> > The other caller of vsc85xx_rgmii_set_skews(), VSC8572, unfortunately
> > does not document bit 11 at all - it doesn't say if it's read-only or not.
> > We could conditionally include the VSC8502_RGMII_RX_CLK_DISABLE bit in the
> > "mask" argument of phy_modify_paged() based on rgmii_cntl == VSC8502_RGMII_CNTL,
> > such as to exclude VSC8572.
> 
> Because of the above, I would still call from vsc85xx_default_config(),
> so not for the PHYs where bit 11 is not documented.
> 
> > What do you think?
> 
> If you agree to the above, should the function be named
> vsc85xx_enable_rx_clk() or rather vsc8502_enable_rx_clk()?
> It is called for more than just VSC8502, but not for all of the PHYs
> the driver supports.
> The same is true for the existing vsc85xx_default_config(), however.
> I don't have a real preference.

Well, to be clear, I was suggesting:

/* Set the RGMII RX and TX clock skews individually, according to the PHY
 * interface type, to:
 *  * 0.2 ns (their default, and lowest, hardware value) if delays should
 *    not be enabled
 *  * 2.0 ns (which causes the data to be sampled at exactly half way between
 *    clock transitions at 1000 Mbps) if delays should be enabled
 */
static int vsc85xx_rgmii_set_skews(struct phy_device *phydev, u32 rgmii_cntl,
				   u16 rgmii_rx_delay_mask,
				   u16 rgmii_tx_delay_mask)
{
	u16 rgmii_rx_delay_pos = ffs(rgmii_rx_delay_mask) - 1;
	u16 rgmii_tx_delay_pos = ffs(rgmii_tx_delay_mask) - 1;
	u16 mask = rgmii_rx_delay_mask | rgmii_tx_delay_mask;
	u16 reg_val = 0;
	int rc;

	/* For traffic to pass, the VSC8502 family needs the RX_CLK disable bit
	 * to be unset for all PHY modes, so do that as part of the paged
	 * register modification.
	 */
	if (rgmii_cntl == VSC8502_RGMII_CNTL)
		mask |= VSC8502_RGMII_RX_CLK_DISABLE;

	mutex_lock(&phydev->lock);

	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_rx_delay_pos;
	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_tx_delay_pos;

	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
			      rgmii_cntl, mask, reg_val);

	mutex_unlock(&phydev->lock);

	return rc;
}

static int vsc85xx_default_config(struct phy_device *phydev)
{
	int rc;

	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;

	return vsc85xx_rgmii_set_skews(phydev, VSC8502_RGMII_CNTL,
				       VSC8502_RGMII_RX_DELAY_MASK,
				       VSC8502_RGMII_TX_DELAY_MASK);
}

// no changes to the vsc85xx_rgmii_set_skews() call from vsc8584_config_init()

