Return-Path: <netdev+bounces-9951-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E042D72B432
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 23:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6D401C2095A
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 21:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B437B12B76;
	Sun, 11 Jun 2023 21:38:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E03101FB
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 21:38:06 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7569E41
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 14:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=looin07insiW0ALScIgfJP68Sm0rrKxa54BqB7o7p/I=; b=qDTlIPk+/mJB46rjLbJ5eighK0
	mGt483iADEyJ/M/kWYgHbQmDTOAT+XMqEEJBUSVa56IXOO8DJ9r/TBCyJKu0wF07ywxIaBNVmJXLv
	AMeQUk/EZ7rOtUY+5/v9YqFxckRVawhnkkVYjg1qOvLBoLoV+iv/rb0b6EAj9qHB0Tl3YKJmusePj
	YrkYm3Cb/oTOKOGzJ3MB5LZy6bUsVXe6XlG+4RVU65dIeckPTh/gVeVeu+TPex6yx1Gxrhs1ptim1
	YJncgmyuF28dK8OtfuZPbCySBF5GgWWuHnF+GjG+37ya6nt3YPA5AVD+2XVqFJvC9QEkPcO/DxVXv
	r9pGmJmg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33288)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q8Sl4-0004mC-1S; Sun, 11 Jun 2023 22:37:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q8Sl1-0004HI-DY; Sun, 11 Jun 2023 22:37:55 +0100
Date: Sun, 11 Jun 2023 22:37:55 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
	netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH RFC net-next 2/4] net: phylink: add EEE management
Message-ID: <ZIY+szvNDxFCn94b@shell.armlinux.org.uk>
References: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
 <E1q7Y9R-00DI8g-GF@rmk-PC.armlinux.org.uk>
 <bca7e7ec-3997-4d97-9803-16bfaf05d1f5@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bca7e7ec-3997-4d97-9803-16bfaf05d1f5@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 11, 2023 at 11:28:32PM +0200, Andrew Lunn wrote:
> On Fri, Jun 09, 2023 at 10:11:21AM +0100, Russell King (Oracle) wrote:
> > Add EEE management to phylink.
> 
> Hi Russell
> 
> I've been working on my EEE patches. I have all pure phylib drivers
> converted. I've incorporated these four patches as well, and make use
> of the first patch in phylib.
> 
> Looking at this patch, i don't see a way for the MAC to indicate it
> actually does support EEE. Am i missing it?

If a MAC doesn't support EEE, it won't have the necessary calls to
phylink_*_eee() in its ethtool ops. As can be seen from the mvpp2
patch, mvpp2_ethtool_get_eee() and mvpp2_ethtool_set_eee() are
needed to call the phylink methods.

Given that a MAC has to provide those hooks, why would we need a
capability for EEE? Are you thinking that it may be optional for
some MACs?

Thinking of the future (not having done a lot of research though) it
may be appropriate to have a bitmap of... I was going to say ethtool
modes but that doesn't really work... phy interface modes that the MAC
can support EEE. I'm thinking of devices such as mvpp2 where EEE is
supported by the GMAC (for <=2.5G) but not XLG (for >= 5G).

If we use phy interface modes, we somehow need to turn that into
ethtool link modes for the media side, which is e.g. PHY dependent.
For example, the Aquantia PHYs doing rate adaption to 10G plugged
into mvpp2 (which probably doesn't work too well due to the lack
of pause support in mvpp2 hardware) won't be able to do EEE at any
speed because it'll be only using the XLG, but a PHY that uses SGMII
connected to mvpp2 can because that will use GMAC.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

