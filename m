Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EB4393F9E
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 11:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbhE1JOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 05:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235179AbhE1JOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 05:14:09 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5A9C061574
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 02:12:33 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id s6so3999909edu.10
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 02:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nKY1ylftcJ/j/+G7jKe3fylPSB7dqHF4YHoPdOmhNPs=;
        b=aOiWiQzu5lpVvN8ijZsQpYh1byV8XwhMYgnGnxCFDgYd6kT4Z+xIyE6gWzrOAX4GFz
         LIYojwkpfLXEiGf639Ex6GwQT1i2PC3cZeXDOAhR4hLKtk2UlSx+soGBHqfPhfqzfb3g
         COUvSwC+xqZuNU37O0GYZYdBD+gPE4+3rkHIOlQjPqmc7+gI/F5Tix+JORPWWfH/yota
         uu5DUC/ZWhylbT3OLJ06t7OYIDno8SO/GX3pkdZ3fA20V3pO864NHTTfBU8V1O/N52d2
         tQpJMRw0KLPUjrOxJYJdo5ObI6nUIYGrF+e3q/CVnuyunJU3cMN/QxzKTy9ZD6hQa5Vp
         Az2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nKY1ylftcJ/j/+G7jKe3fylPSB7dqHF4YHoPdOmhNPs=;
        b=F4+l/UG7JTjW+nTL4gTyuQuI3EoEhnfsKTjcg9RWR0N2ctZws6+IFO+MLf9aJUJaYQ
         Q0x7yTsaBS8P6F6BbwIkSf5QX4KL8E/y0MQ8xDnb+XUn3MIK1gumjxArjKATYL80uZIs
         4wS+j7FhlHxp9cnxblRtwfbypDaQhTCW5hHrjt5M9PqzSvgTd9s4jRkWiHgZJ8B3+rXS
         XGNyob2VRheYMw4gIXJCJRikOjvPfYl0V9FAQwJFem81Efb7JPebHzgf6Xgef6EGzBLO
         RVrbr+vfbXCwirL3VPBq9VnSjgxtzHw5H9gVPCxC4ZeQZ3eaiWPIYjF+Fy4e8lCS1mh/
         WR1w==
X-Gm-Message-State: AOAM531QhnUwF6ALwt3ckGF4k1kIK8lIZPOBZzLPnFxAPpuerZKKtdaR
        aYRGQqu1SyoV8joOKDm5nFT64Q1NSUQ=
X-Google-Smtp-Source: ABdhPJxf6lBfQ8uzk+3hubrGhJ2fQYgjr0GPdoGeyKtGfqswJwrGXhidRA0jGMu6xEnO6cmLIzegLQ==
X-Received: by 2002:aa7:cf06:: with SMTP id a6mr9071855edy.138.1622193152340;
        Fri, 28 May 2021 02:12:32 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id a25sm2122711ejs.109.2021.05.28.02.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:12:32 -0700 (PDT)
Date:   Fri, 28 May 2021 12:12:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net-next 0/8] Convert xpcs to phylink_pcs_ops
Message-ID: <20210528091230.hzuzhotuna34amhj@skbuf>
References: <20210527204528.3490126-1-olteanv@gmail.com>
 <20210528021521.GA20022@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528021521.GA20022@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi VK,

On Fri, May 28, 2021 at 10:15:21AM +0800, Wong Vee Khee wrote:
> I got the following kernel panic after applying [1], and followed by
> this patch series.
> 
> [1] https://patchwork.kernel.org/project/netdevbpf/patch/20210527155959.3270478-1-olteanv@gmail.com/
> 
> [   10.742057] libphy: stmmac: probed
> [   10.750396] mdio_bus stmmac-1:01: attached PHY driver [unbound] (mii_bus:phy_addr=stmmac-1:01, irq=POLL)
> [   10.818222] intel-eth-pci 0000:00:1e.4 (unnamed net_device) (uninitialized): failed to validate link configuration for in-band status
> [   10.830348] intel-eth-pci 0000:00:1e.4 (unnamed net_device) (uninitialized): failed to setup phy (-22)

Thanks a lot for testing. Sadly I can't figure out what is the mistake.
Could you please add this debugging patch on top and let me know what it
prints?

-----------------------------[ cut here ]-----------------------------
From 1d745a51b53b38df432a33849632a1b553d3f90a Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Fri, 28 May 2021 12:00:17 +0300
Subject: [PATCH] xpcs debug

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/pcs/pcs-xpcs.c | 44 +++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 194b79da547b..4268b8bb8db0 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -675,30 +675,39 @@ static void xpcs_resolve_pma(struct mdio_xpcs_args *xpcs,
 void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state)
 {
-	bool valid_interface;
-
-	if (state->interface == PHY_INTERFACE_MODE_NA) {
-		valid_interface = true;
-	} else {
+	if (state->interface != PHY_INTERFACE_MODE_NA) {
 		struct xpcs_id *id = xpcs->id;
+		bool valid_interface = false;
 		int i;
 
-		valid_interface = false;
-
 		for (i = 0; id->interface[i] != PHY_INTERFACE_MODE_MAX; i++) {
-			if (id->interface[i] != state->interface)
+			if (id->interface[i] != state->interface) {
+				dev_err(&xpcs->mdiodev->dev,
+					"%s: provided interface %s does not match supported interface %d (%s)\n",
+					__func__, phy_modes(state->interface),
+					i, phy_modes(id->interface[i]));
 				continue;
+			}
 
 			valid_interface = true;
 			break;
 		}
-	}
 
-	if (!valid_interface) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-		return;
+		if (!valid_interface) {
+			dev_err(&xpcs->mdiodev->dev,
+				"%s: provided interface %s does not match any supported interface\n",
+				__func__, phy_modes(state->interface));
+			bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+			return;
+		}
 	}
 
+	dev_err(&xpcs->mdiodev->dev,
+		"%s: supported mask for interface %s is %*pb, received supported mask is %*pb\n",
+		__func__, phy_modes(state->interface),
+		__ETHTOOL_LINK_MODE_MASK_NBITS, xpcs->supported,
+		__ETHTOOL_LINK_MODE_MASK_NBITS, supported);
+
 	linkmode_and(supported, supported, xpcs->supported);
 	linkmode_and(state->advertising, state->advertising, xpcs->supported);
 }
@@ -987,8 +996,17 @@ struct mdio_xpcs_args *xpcs_create(struct mdio_device *mdiodev)
 		if ((xpcs_id & entry->mask) != entry->id)
 			continue;
 
-		for (i = 0; entry->supported[i] != __ETHTOOL_LINK_MODE_MASK_NBITS; i++)
+		dev_err(&mdiodev->dev, "%s: xpcs_id %x matched on entry %d\n",
+			__func__, xpcs_id, i);
+
+		for (i = 0; entry->supported[i] != __ETHTOOL_LINK_MODE_MASK_NBITS; i++) {
+			dev_err(&mdiodev->dev, "%s: setting entry->supported bit %d\n",
+				__func__, entry->supported[i]);
 			set_bit(entry->supported[i], xpcs->supported);
+		}
+
+		dev_err(&mdiodev->dev, "%s: xpcs->supported %*pb\n", __func__,
+			__ETHTOOL_LINK_MODE_MASK_NBITS, xpcs->supported);
 
 		xpcs->id = entry;
 		xpcs->an_mode = entry->an_mode;
-----------------------------[ cut here ]-----------------------------
