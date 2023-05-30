Return-Path: <netdev+bounces-6384-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1057160E6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:00:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77FD12811C3
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D005E1DDD5;
	Tue, 30 May 2023 13:00:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5448134C8
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:00:27 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0613B1BD;
	Tue, 30 May 2023 06:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=OVMv8R7f5hQRgrK5Klu+LvbmHbqhFXDKTyMQYu3+gXo=; b=uP6sKNHuvC4EfFsmFM1WMn0/2G
	gOHMbzTp4FIqDdlpZXTCNzceiEL5VM9SPK3lxxbQBnFPmDDmkc0oUjjla2WXLOzEn9RjGNzE31z6R
	wfL2cMtNZQArAIevB0HEtXUrl5UymbYIO0/70r/9f4+uV6fpT5dWmeIWpci0OcBaqd2pZxbgeDxjD
	cqX6NtIN2Y8pbY4hXQ7T/0y0xQo+4PLiohSWR5c5XpDrAbcoXDEnGx9f4KKXMkGRmzVwd8XD/gdrq
	oQ7PWOXWOTn3X9e+GzytFSP+zmMCLzEm53Hcqtoe88BrFj4HvJhwpiFiMRWVAmnvtd0+ixumzuJx4
	Be6y8uLw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42432)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q3yxC-0002iR-JM; Tue, 30 May 2023 13:59:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q3yxA-00082r-Ly; Tue, 30 May 2023 13:59:56 +0100
Date: Tue, 30 May 2023 13:59:56 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Lukasz Majewski <lukma@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Vivien Didelot <vivien.didelot@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: dsa: slave: Advertise correct EEE capabilities at
 slave PHY setup
Message-ID: <ZHXzTBOtlPKqNfLw@shell.armlinux.org.uk>
References: <20230530122621.2142192-1-lukma@denx.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530122621.2142192-1-lukma@denx.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 02:26:21PM +0200, Lukasz Majewski wrote:
> One can disable in device tree advertising of EEE capabilities of PHY
> when 'eee-broken-100tx' property is present in DTS.
> 
> With DSA switch it also may happen that one would need to disable EEE due
> to some network issues.
> 
> Corresponding switch DTS description:
> 
>  switch@0 {
> 	 ports {
> 		port@0 {
> 		reg = <0>;
> 		label = "lan1";
> 		phy-handle = <&switchphy0>;
> 		};
> 	}
> 	mdio {
> 		switchphy0: switchphy@0 {
> 		reg = <0>;
> 		eee-broken-100tx;
> 	};
> 	};
> 
> This patch adjusts the content of MDIO_AN_EEE_ADV in MDIO_MMD_AN "device"
> so the phydev->eee_broken_modes are taken into account from the start of
> the slave PHYs.

This should be handled by phylib today in recent kernels without the
need for any patch (as I describe below, because the config_aneg PHY
method should be programming it.) Are you seeing a problem with it
in 6.4-rc?

> As a result the 'ethtool --show-eee lan1' shows that EEE is not supported
> from the outset.
> 
> Questions:
> 
> - Is the genphy_config_eee_advert() appropriate to be used here?
>   As I found this issue on 5.15 kernel, it looks like mainline now uses
>   PHY features for handle EEE (but the aforementioned function is still
>   present in newest mainline - v6.4-rc1).
> 
> - I've also observed strange behaviour for EEE capability register:
>   Why the value in MDIO_MMD_PCS device; reg MDIO_PCS_EEE_ABLE is somewhat
>   "volatile" - in a sense that when I use:
>   ethtool --set-eee lan2 eee off
> 
>   It is cleared by PHY itself to 0x0 (from 0x2) and turning it on again is
>   not working.
> 
>   Is this expected? Or am I missing something?

No - this register is supposed to report the capabilities of the PHY,
and bits 1..15 should be read-only, and as they report the capabilities
they should be fixed. Writing to bit 1 of this register will therefore
be ignored. It sounds like your PHY has some odd behaviour - maybe
someone misinterpreted 802.3 45.2.3.9?

> Signed-off-by: Lukasz Majewski <lukma@denx.de>
> ---
>  net/dsa/slave.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 353d8fff3166..712923c7d4e2 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2247,6 +2247,7 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
>  		phylink_destroy(dp->pl);
>  	}
>  
> +	genphy_config_eee_advert(slave_dev->phydev);

No network driver (which includes DSA) should be calling any function
starting genphy_*. These functions are purely for phylib or phy drivers
to use, and no one else.

genphy_config_eee_advert() is a deprecated function (see commit
5827b168125d ("net: phy: c45: migrate to genphy_c45_write_eee_adv()")
and thus should not be used.

genphy_c45_write_eee_adv() is called by genphy_c45_an_config_eee_aneg()
which will in turn be called by genphy_config_aneg() for a clause 22
PHY, or by genphy_c45_an_config_aneg() for a clause 45 PHY. These will
write the EEE advertisement mask to the PHY's AN MMD.

So, EEE should be handled by phylib according to the firmware settings.
The only thing that network drivers that use phylib have to deal with
is setting their hardware for the LPI timeout and enabling/disabling
the timeout as necessary.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

