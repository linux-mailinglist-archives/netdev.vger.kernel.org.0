Return-Path: <netdev+bounces-9451-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB69F7292EE
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:24:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 431F71C2107F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 08:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B53B5AD50;
	Fri,  9 Jun 2023 08:24:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C5C79F5
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:24:24 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB0926B2;
	Fri,  9 Jun 2023 01:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/ddh/njnY2cXtqQRzpQCozAt2Drn97mnuIEdRepzLZw=; b=heKsqyPzgKPY52cmAe4+oO/pfy
	3Ctl5VfyScPLOgIkGfIh84Wjom1i9QooaBADAirB+AVNytkcJ9aaOwy5/Iy+UVUH//grS+VpJzmkE
	SGmi1+d4wm1RtMUEEY1MEWIQX+tGMhY/EnmF7bS5C0CdBXcTu+zYzAK/C5TekSsCHx+RTGAEYL+Yu
	CVt61AvpcJy6DP55BvrnHV6jLdSkMhGKEFmNwpUwVzM/5ORVG0yxYAp80KXKLrKCj8Cza4nTiuJD/
	/nrPRxsoKJGH667SBbFGBwNPe4bEgfFECKieHzVeEEZazaL+7QHtl18uzvaojF0NXlOI3Be6ssd+d
	Gw4JCaMA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34538)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q7XPW-0001eE-DZ; Fri, 09 Jun 2023 09:23:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q7XPS-0001hR-On; Fri, 09 Jun 2023 09:23:50 +0100
Date: Fri, 9 Jun 2023 09:23:50 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	linux-arm-kernel@lists.infradead.org, Horatiu.Vultur@microchip.com,
	Allan.Nielsen@microchip.com, UNGLinuxDriver@microchip.com,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net v2 0/2] fixes for Q-USGMII speeds and autoneg
Message-ID: <ZILhllzq5SAFTgOf@shell.armlinux.org.uk>
References: <20230609080305.546028-1-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609080305.546028-1-maxime.chevallier@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 10:03:03AM +0200, Maxime Chevallier wrote:
> This is the second version of a small changeset for QUSGMII support,
> fixing inconsistencies in reported max speed and control word parsing.
> 
> As reported here [1], there are some inconsistencies for the Q-USGMII
> mode speeds and configuration. The first patch in this fixup series
> makes so that we correctly report the max speed of 1Gbps for this mode.
> 
> The second patch uses a dedicated helper to decode the control word.
> This is necessary as although USGMII control words are close to USXGMII,
> they don't support the same speeds.
> 
> Thanks,
> 
> Maxime
> 
> [1] : https://lore.kernel.org/netdev/ZHnd+6FUO77XFJvQ@shell.armlinux.org.uk/
> 
> V1->V2: Fix decoding logic for usgmii control word, as per Russell's review

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

