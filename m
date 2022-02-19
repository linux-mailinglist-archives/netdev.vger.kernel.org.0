Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9198E4BC84A
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 12:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242141AbiBSLrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 06:47:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242147AbiBSLrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 06:47:15 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDD81DE8A7
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 03:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=G7qUsO4oqcI0w39H7qqESDTrPvoaj742F91FGgp8jNo=; b=epcE6u7ZcfFCvGNIv4FbPwPlNw
        DWlgekogYEWYsfnYC6LK9vWMm6P8aSfyG59uT0jVD1YVk2geRA0del6JMWZF3CRug8zMk+VFxhy2E
        5gif6ombD+RAyAKcklpC107F4C5/kuq68sJXckjkxX6y2HNKIOnFm+nthu0pbu8JZhsDIbtJGGXS+
        KWkaPokyT94KuCmA7X44zSq9BK4JrmXgcf1dGd1LvsiAm5vGyYh8MB2dY3WSfX7leAfTgLfigSiS0
        nHDXY5ImEwqBWe9VG0WOcKIsERRQYVI1wpipTjiy6l4hMtweaF3YxqhZpN+BKrse02AFYYFHZVl8t
        7vV8DkVA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57324)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nLOCN-00072R-FQ; Sat, 19 Feb 2022 11:46:47 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nLOCK-0004mf-Db; Sat, 19 Feb 2022 11:46:44 +0000
Date:   Sat, 19 Feb 2022 11:46:44 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/2] net: phylink: remove pcs_poll
Message-ID: <YhDYpHEBHGCVo+2z@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This small series removes the now unused pcs_poll members from DSA and
phylink. "git grep pcs_poll drivers/net/ net/" on net-next confirms that
the only places that reference this are in DSA core code and phylink
code:

drivers/net/phy/phylink.c:              if (pl->config->pcs_poll || pcs->poll)
drivers/net/phy/phylink.c:              poll |= pl->config->pcs_poll;
net/dsa/port.c: dp->pl_config.pcs_poll = ds->pcs_poll;

 drivers/net/phy/phylink.c | 3 +--
 include/linux/phylink.h   | 2 --
 include/net/dsa.h         | 5 -----
 net/dsa/port.c            | 1 -
 4 files changed, 1 insertion(+), 10 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
