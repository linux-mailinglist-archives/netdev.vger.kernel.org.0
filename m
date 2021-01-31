Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F1F309C2A
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 13:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhAaM5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 07:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbhAaMVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 07:21:36 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE56FC061574
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 04:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/xPOpfwURKbyEMkvuk6AsCAvGIwcunR//u2v7vxgSw4=; b=PPo3pyTqF2JxqhVBnFTq/JdIj
        KFOPM1qM7uW5JqWNxMvUbS9tcn8n8gfjHKPRG5WIG3ed18y6Rup/OsDnA+cRUvZ8zMhyBiIaYFZgF
        9V8pTYH3DfsmV6OX9CTMoiAr6RhLBUwPfSUtluft6F23O+mEvFHN49+g/QbDVlbLD+D8DekjbxZgV
        LEjlN2vVBN3CepekX0S+EaB5tEZrM3lJKbpsK/UZOF5/scnqDmyF6MMtUJIcLMqqrsyLf19/ktBOP
        nRR92PkI2gGLmjwlI9vZudY/bVMyeKLfF9WK2/HvJNCyDOARcNxj4Y/nQrSQhPc+XihbpuKBTSFT2
        /dJ78MMvQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37324)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l6Bhn-0002P8-NK; Sun, 31 Jan 2021 12:19:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l6Bhm-00010Y-EU; Sun, 31 Jan 2021 12:19:50 +0000
Date:   Sun, 31 Jan 2021 12:19:50 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Marcin Wojtas (mw@semihalf.com)" <mw@semihalf.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>
Subject: Re: [EXT] Re: Phylink flow control support on ports with
 MLO_AN_FIXED auto negotiation
Message-ID: <20210131121950.GA1477@shell.armlinux.org.uk>
References: <CO6PR18MB38732F56EF08FA2C949326F9B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210131103549.GA1463@shell.armlinux.org.uk>
 <CO6PR18MB3873D6F519D1B4112AA77671B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210131111214.GB1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210131111214.GB1463@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 11:12:14AM +0000, Russell King - ARM Linux admin wrote:
> I discussed it with Andrew earlier last year, and his response was:
> 
>  DT configuration of pause for fixed link probably is sufficient. I don't
>  remember it ever been really discussed for DSA. It was a Melanox
>  discussion about limiting pause for the CPU. So I think it is safe to
>  not implement ethtool -A, at least until somebody has a real use case
>  for it.
> 
> So I chose not to support it - no point supporting features that people
> aren't using. If you have a "real use case" then it can be added.

This patch may be sufficient - I haven't fully considered all the
implications of changing this though.

 drivers/net/phy/phylink.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7e0fdc17c8ee..2ee0d4dcf9a5 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -673,7 +673,6 @@ static void phylink_resolve(struct work_struct *w)
 		switch (pl->cur_link_an_mode) {
 		case MLO_AN_PHY:
 			link_state = pl->phy_state;
-			phylink_apply_manual_flow(pl, &link_state);
 			mac_config = link_state.link;
 			break;
 
@@ -698,11 +697,12 @@ static void phylink_resolve(struct work_struct *w)
 				link_state.pause = pl->phy_state.pause;
 				mac_config = true;
 			}
-			phylink_apply_manual_flow(pl, &link_state);
 			break;
 		}
 	}
 
+	phylink_apply_manual_flow(pl, &link_state);
+
 	if (mac_config) {
 		if (link_state.interface != pl->link_config.interface) {
 			/* The interface has changed, force the link down and
@@ -1639,9 +1639,6 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 
 	ASSERT_RTNL();
 
-	if (pl->cur_link_an_mode == MLO_AN_FIXED)
-		return -EOPNOTSUPP;
-
 	if (!phylink_test(pl->supported, Pause) &&
 	    !phylink_test(pl->supported, Asym_Pause))
 		return -EOPNOTSUPP;
@@ -1684,7 +1681,7 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 	/* Update our in-band advertisement, triggering a renegotiation if
 	 * the advertisement changed.
 	 */
-	if (!pl->phydev)
+	if (!pl->phydev && pl->cur_link_an_mode != MLO_AN_FIXED)
 		phylink_change_inband_advert(pl);
 
 	mutex_unlock(&pl->state_mutex);

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
