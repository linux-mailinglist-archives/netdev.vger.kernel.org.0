Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916E73FE8AB
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 07:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhIBFP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 01:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhIBFP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 01:15:58 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6875DC061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 22:15:00 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id d5so575427pjx.2
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 22:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=date:message-id:in-reply-to:references:from:to:cc:subject
         :content-transfer-encoding:mime-version;
        bh=FQcSdkwkCjzmoBdMqo8s6qmG8yRRACp+L5oekxS+zhk=;
        b=fW1z71u9Oj5bRjdO7IlYgSdc2FU5HXSRLy0dr3XIyhvF4X3D+mgHDx0wECxUpBtqjg
         uScOCpeFN4sFJJ2aGyupa98DkZblJc0pIY2VSOoCY5VIlPg6oC9EWxdeUAmDwHVysTSJ
         sVFbVkw8NxBhgnfLUdzlRuqJdScKrN/U2hKR2569qhgeKJy5M+xg/0ZS53nGgFkMNlXp
         AF0HnVOm7qybPbAQFqMfdCOkZRvkFwtED+3f70zgRr0/xG1p9oixcPZtkTHeVsRP6tcC
         lMkbJWRSKqUjrCzBmA6YGqm/EPFlObz5/K4Vx4iQ0GpFr77f4f9zpD7RZCylkmIHlfyA
         +zfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:in-reply-to:references:from:to
         :cc:subject:content-transfer-encoding:mime-version;
        bh=FQcSdkwkCjzmoBdMqo8s6qmG8yRRACp+L5oekxS+zhk=;
        b=SZWmt64NcQJ/+7QRluG7fsQN4la5UwgeLrRCz4up8BYDyA7I664fIq3C/qGsx53hVk
         QJzkQgC1xvCUP4jsFSWIHQ/VS+Y5xk01ZjCx6soN7yeaAJ99m7JyjdhH0cughs5qDo8t
         WsyRzhC4SWmR8URvHYJeZS05iyA+9+PYa971l1jSWy56pbAvt4ra0B3iFLXXObeHKfcz
         MK8pcNsiVebXgMtMc6RaDd9ysUsNJoTtcSJLZBRUBIM2Oqri9zzeu7HYzC+qzToCKtOG
         NqF3QpXCKBMxNHFrqdR1/d2FLsWnWCgFzx2mH/K4w/CR0zEZvVSmAOHJrmIg9tRMDVmj
         H4wg==
X-Gm-Message-State: AOAM533wESLq+LyvC5Skkd4v5D5rmvB4kGt8H4TIpO4HdV7bT4Z38mcH
        VG+5dNFxHbSmYwiXF3WqKvLQXA==
X-Google-Smtp-Source: ABdhPJxJbViKLnWPET7UQVUxGjwYo7+meRFxSlHUg7kB7zV3akcshCbYjtclcwwUZ/9Ptggnlg/wZw==
X-Received: by 2002:a17:90a:a0a:: with SMTP id o10mr1719013pjo.231.1630559699813;
        Wed, 01 Sep 2021 22:14:59 -0700 (PDT)
Received: from [127.0.1.1] (117-20-69-24.751445.bne.nbn.aussiebb.net. [117.20.69.24])
        by smtp.gmail.com with UTF8SMTPSA id q18sm691691pfj.46.2021.09.01.22.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 22:14:59 -0700 (PDT)
Date:   Thu, 02 Sep 2021 05:14:49 +0000
Message-Id: <20210902051449.280248-1-nathan@nathanrossi.com>
In-Reply-To: <20210826071230.11296-1-nathan@nathanrossi.com>
References: <20210826071230.11296-1-nathan@nathanrossi.com>
From:   Nathan Rossi <nathan@nathanrossi.com>
To:     netdev@vger.kernel.org
Cc:     Nathan Rossi <nathan@nathanrossi.com>,
        Nathan Rossi <nathan.rossi@digi.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2] net: phylink: Update SFP selected interface on advertising changes
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Rossi <nathan.rossi@digi.com>

Currently changes to the advertising state via ethtool do not cause any
reselection of the configured interface mode after the SFP is already
inserted and initially configured.

While it is not typical to change the advertised link modes for an
interface using an SFP in certain use cases it is desirable. In the case
of a SFP port that is capable of handling both SFP and SFP+ modules it
will automatically select between 1G and 10G modes depending on the
supported mode of the SFP. However if the SFP module is capable of
working in multiple modes (e.g. a SFP+ DAC that can operate at 1G or
10G), one end of the cable may be attached to a SFP 1000base-x port thus
the SFP+ end must be manually configured to the 1000base-x mode in order
for the link to be established.

This change causes the ethtool setting of advertised mode changes to
reselect the interface mode so that the link can be established.
Additionally when a module is inserted the advertising mode is reset to
match the supported modes of the module.

Signed-off-by: Nathan Rossi <nathan.rossi@digi.com>
---
Changes in v2:
- Revalidate the configuration after the interface mode change (as done
  in phylink_sfp_config).
- In phylink_sfp_config, update the current config advertising state
  when it differs. This makes sure that the advertising state matches
  what is applied during module insert/start.
---
 drivers/net/phy/phylink.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 2cdf9f989d..ea4bdc9cf5 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1525,6 +1525,32 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 	if (config.an_enabled && phylink_is_empty_linkmode(config.advertising))
 		return -EINVAL;
 
+	/* If this link is with an SFP, ensure that changes to advertised modes
+	 * also cause the associated interface to be selected such that the
+	 * link can be configured correctly.
+	 */
+	if (pl->sfp_port && pl->sfp_bus) {
+		config.interface = sfp_select_interface(pl->sfp_bus,
+							config.advertising);
+		if (config.interface == PHY_INTERFACE_MODE_NA) {
+			phylink_err(pl,
+				    "selection of interface failed, advertisement %*pb\n",
+				    __ETHTOOL_LINK_MODE_MASK_NBITS,
+				    config.advertising);
+			return -EINVAL;
+		}
+
+		/* Revalidate with the selected interface */
+		linkmode_copy(support, pl->supported);
+		if (phylink_validate(pl, support, &config)) {
+			phylink_err(pl, "validation of %s/%s with support %*pb failed\n",
+				    phylink_an_mode_str(pl->cur_link_an_mode),
+				    phy_modes(config.interface),
+				    __ETHTOOL_LINK_MODE_MASK_NBITS, support);
+			return -EINVAL;
+		}
+	}
+
 	mutex_lock(&pl->state_mutex);
 	pl->link_config.speed = config.speed;
 	pl->link_config.duplex = config.duplex;
@@ -2104,7 +2130,9 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 	if (phy_interface_mode_is_8023z(iface) && pl->phydev)
 		return -EINVAL;
 
-	changed = !linkmode_equal(pl->supported, support);
+	changed = !linkmode_equal(pl->supported, support) ||
+		  !linkmode_equal(pl->link_config.advertising,
+				  config.advertising);
 	if (changed) {
 		linkmode_copy(pl->supported, support);
 		linkmode_copy(pl->link_config.advertising, config.advertising);
---
2.33.0
