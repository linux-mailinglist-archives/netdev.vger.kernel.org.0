Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9620C31B55F
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 07:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhBOGQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 01:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbhBOGQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 01:16:53 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC2BC061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 22:16:12 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id g20so3157166plo.2
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 22:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=date:message-id:from:to:cc:subject:content-transfer-encoding
         :mime-version;
        bh=F/TrszD/U5N5b93GMmzrd3U+xHMR5QarKZ0DvlLqyRw=;
        b=YoP+ZsD89NAbThuxeaTYAsBe7xpyZ5K4ESnZECqZYBJ/tGYVnpxuzf7c8kTH0aWKCo
         U3/Zgnptp5ORK8ntd0Uz37Y3P9cpOKtu/IlmwFLv+ng1cFPGXLuEiFKo2SMuAfnIzZgA
         bwkdwQ2TG5SLQFbpG5osN4ioxC6OCTCK/+V0D+MRnwcMrAmT0HNvE4tOIYef6FnM7Mbb
         XrbW3nRrlXrJwvGM/aG1i1Z/27qGiaGvURXY4Swn+r5zenq9U8YmsFkLWhpYp1NsGh3X
         uC1o8Dhj56yr5smnkI29UwZpX3M7KtQQBB5QFwk6n+ndcXPrdbX+EXvFj856HzPQJJxC
         WpMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject
         :content-transfer-encoding:mime-version;
        bh=F/TrszD/U5N5b93GMmzrd3U+xHMR5QarKZ0DvlLqyRw=;
        b=NsqWosHZHAz+wsszPbsiEZyhIMDG1p3YSAh5Mhmy4w+okEICi5tHKCsGbxRS8Tsmzs
         67+Yg3b1spP9xYXikQXSmA5bRxY1q4CYkYSmIkmf8MQInwpDys5beaV+wFRvAIdv8CQa
         XOOrBHuXATbt3GfcT0UwWBqX9iGpDc34+dMDd0rHyia59jKOo/fcQlahq0o/Df0rLZmj
         nWv9mtvK2ES4zsLViNcbF8lIMLo6oBrSAQjuli8NEtn14MLMoR9CM4xEWwVVnCuLG3oK
         u7NUyEnWIxHMtfzKwx3i87yU0m6uQkuPICsWPXrzMY+uobZrLV+C0dVKm4nmbkFk8Jm5
         5p4w==
X-Gm-Message-State: AOAM531ONb52Tu6IkH4ryTdn9SfkFaT0TZUI7KVqAmebmHPY3B0EUbuK
        m+eF3pADg4pZ1FpSuJmxOXmp2g==
X-Google-Smtp-Source: ABdhPJx9MsfRIw2uKOD8hk9WXnwqbPedOqu21t4BfXOkQoT83XZb6Pyjx4snmZ52FrU3ctOmwPJvpA==
X-Received: by 2002:a17:90a:c244:: with SMTP id d4mr2673399pjx.73.1613369772115;
        Sun, 14 Feb 2021 22:16:12 -0800 (PST)
Received: from [127.0.1.1] (117-20-70-209.751446.bne.nbn.aussiebb.net. [117.20.70.209])
        by smtp.gmail.com with UTF8SMTPSA id l1sm16881578pgt.26.2021.02.14.22.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 22:16:11 -0800 (PST)
Date:   Mon, 15 Feb 2021 06:15:59 +0000
Message-Id: <20210215061559.1187396-1-nathan@nathanrossi.com>
From:   Nathan Rossi <nathan@nathanrossi.com>
To:     netdev@vger.kernel.org
Cc:     Nathan Rossi <nathan@nathanrossi.com>,
        Nathan Rossi <nathan.rossi@digi.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH] net: dsa: mv88e6xxx: prevent 2500BASEX mode override
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Rossi <nathan.rossi@digi.com>

The mv88e6xxx devices cannot automatically select between 1000BASE-X and
2500BASE-X and rely on configuration (gpio pins Px_SMODE/S_MODE and/or
OF phy-mode) to select between the two modes.

However when configuring a cpu/dsa port as 1000BASE-X with a inband or
fixed link phy the mode is always overridden to 2500BASE-X by the call of
phylink_helper_basex_speed in phylink_validate due to the order of setup
with respect to advertised modes and auto negotiation being enabled.

During the initial setup of the phy the phy-mode property defined for
the port is configured before any calls to phylink_validate. The first
call to phylink_validate sets the advertised modes to all valid modes
and phylink_validate masks to supported modes, for the ports that
support 1000BASE-X/2500BASE-X both are advertised. At this stage the
speed is not yet configured and the phylink_helper_basex_speed function
overrides the mode to 2500BASE-X due to all modes being advertised and
auto negotiation being enabled. After the speed is configured
phylink_validate is called again, the same logic applies and the mode is
set to 2500BASE-X (due to auto negotiation).

As such it is not possible for a fixed link to be configured as
1000BASE-X, as the mode cannot be configured (e.g. via phy-mode
property) and the link cannot be automatically selected as 1000BASE-X.

This change prevents the advertising of 2500BASE-X when the port is
already configured for 1000BASE-X, which in turn prevents the
phylink_helper_basex_speed from always overriding to 2500BASE-X. This
allows for the mode to correctly propagate from the phy-mode property to
the port configuration.

Signed-off-by: Nathan Rossi <nathan.rossi@digi.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 54aa942eed..5c52906b29 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -650,6 +650,13 @@ static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
 	if (chip->info->ops->phylink_validate)
 		chip->info->ops->phylink_validate(chip, port, mask, state);
 
+	/* Advertise 2500BASEX only if 1000BASEX is not configured, this
+	 * prevents phylink_helper_basex_speed from always overriding the
+	 * 1000BASEX mode since auto negotiation is always enabled.
+	 */
+	if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
+		phylink_clear(mask, 2500baseX_Full);
+
 	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	bitmap_and(state->advertising, state->advertising, mask,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
---
2.30.0
