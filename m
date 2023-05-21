Return-Path: <netdev+bounces-4124-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC30270AF63
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 20:00:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8423E1C2092F
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 18:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6221C8F4F;
	Sun, 21 May 2023 18:00:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5613946AC
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 18:00:10 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C67EE1;
	Sun, 21 May 2023 11:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fM7breEkmpFcu5kMT1h3Tjd0iDA0uSr1msWJ+/s0HS0=; b=MvKPY4Fmh8yN1XdnZfnsxeUAC7
	jt872Gwx4coXAhNu0so+puhLjlDrfK3LU9LFysT/utXhXd5YDvkkHHSxDM+JDE0Y37rrtriUt61Yn
	JRPXCgfjaHPu5w3G8n+oYPXr5ZK9UiSUp3i/M5xcKvg5X+C0KUHAnxhhO18vIKsNEL93Y7yWfG/tM
	8Dc1I0ec8tilwJE4m/W5m3+1C57Tr0uV46UK24S48f9NOvd3VSTwQ8M8ZyS4wX+uhmdc7+iOv0C0v
	r3mEllywX48gj0J5ovKkEOCSTo0C47idCY32E5s1hZ0EFYeO73e4K7/GixDNM+FFSXZ6WH0hFltNL
	wXi96Igg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44292)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q0nLa-0005SQ-Ea; Sun, 21 May 2023 18:59:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q0nLV-0006ry-63; Sun, 21 May 2023 18:59:53 +0100
Date: Sun, 21 May 2023 18:59:53 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: David Epping <david.epping@missinglinkelectronics.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net 3/3] net: phy: mscc: enable VSC8501/2 RGMII RX clock
Message-ID: <ZGpcGbq47nL/rlEb@shell.armlinux.org.uk>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 20, 2023 at 06:06:03PM +0200, David Epping wrote:
> +static int vsc85xx_rgmii_enable_rx_clk(struct phy_device *phydev,
> +				       u32 rgmii_cntl)
> +{
> +	int rc, phy_id;
> +
> +	phy_id = phydev->drv->phy_id & phydev->drv->phy_id_mask;
> +	if (PHY_ID_VSC8501 != phy_id && PHY_ID_VSC8502 != phy_id)
> +		return 0;

As you are accessing the phy_id in the phy_driver struct, isn't it
already true that this will be initialised to constants such as
PHY_ID_VSC8501 or PHY_ID_VSC8502? In which case, why would you need
to mask it with drv->phy_id_mask ?

> +
> +	mutex_lock(&phydev->lock);
> +
> +	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2, rgmii_cntl,
> +			      VSC8502_RGMII_RX_CLK_DISABLE, 0);
> +
> +	mutex_unlock(&phydev->lock);

What is the purpose of taking this lock? phy_modify_paged() will do its
read-modify-write access and page accesses under the MDIO bus lock,
which should be all that's required to guarantee an atomic update.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

