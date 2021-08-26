Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90693F82E1
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 09:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239629AbhHZHNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 03:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbhHZHN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 03:13:29 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F153C061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 00:12:43 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id a21so1979617pfh.5
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 00:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=date:message-id:from:to:cc:subject:content-transfer-encoding
         :mime-version;
        bh=N7Wu0fTst5Tg8Gior6jQw3tN/xcoTwJWRyRF0xvIvA0=;
        b=FUHPte9X/yRqAnNyqQhez7LWUnwctWArSJqjoiNHr5Dh/pDhESz4FxgPG7trNpX76t
         ga0xd0wHUZ6xo7o4lKU16WDsXJjNqtVe1VcfOXYJxonTd93uknNdY7HaMh02Vg61Ybl+
         TgdG1WiqFVWRCsogv7kdfwR+rBDiKsDjBTGBPTZ2Z8zIkvVHCkit4TL0dxB1Zmv1WMTg
         zl6sXzqGrXifRiEJx5xD3j1gjfFsQLKlBCww0YBhGoLJNju2eNzA6t52N0R5YUSqE3sG
         o3ka2jLrplws7PnIuIJzTQYB7ctM3NlbnWa9Zf6pCraRd9q5YfmLwn5E/FYh7G6kbIvg
         D4sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject
         :content-transfer-encoding:mime-version;
        bh=N7Wu0fTst5Tg8Gior6jQw3tN/xcoTwJWRyRF0xvIvA0=;
        b=dVAXTVXsnM700PAMYUqCp3LjbQWAyXTqYsavkOOmqriO5uuBNv5zvJp/v2SSnTkriz
         VgLMvxLjzrpI90fxNfZzhlt8xSsXVuSmO6Tx+btirCnoVo69z634E5vnkjRckQB/F7oN
         mdXkBOBScenCpOYeuBKp4+2nJpXQhmuT2P+agt22FV8uumPimU3bpniMDozVIRkNsWq2
         0Z4uqqRKrI4Jqu1kGCN6Uhn4r0aqck4XmsG6bq9PWHmyjxJd9qVu9GSseL3DqVsBNu/1
         9N89MPD27sAgfuvm9EvgZ87XGCCq5Wn7e0aolnclcm14cqasOTGJdm80dWF6hiwrdjRJ
         DmDQ==
X-Gm-Message-State: AOAM533R80tRpfzqeGCCctLr1f3vTZIADOB/3pvKp645MyjSwm0ukGVO
        rpBnOAXMFHlhceXayWVN6jUF/w==
X-Google-Smtp-Source: ABdhPJyQ03P0W4TG4qZxeKIb+um+uJ+D/q/YadlJEv0y7+M+3tj/KnXsM6fO//zutFjP2aAXRKnfmA==
X-Received: by 2002:a63:3c5d:: with SMTP id i29mr2113313pgn.147.1629961962413;
        Thu, 26 Aug 2021 00:12:42 -0700 (PDT)
Received: from [127.0.1.1] (117-20-69-24.751445.bne.nbn.aussiebb.net. [117.20.69.24])
        by smtp.gmail.com with UTF8SMTPSA id x14sm1788557pfa.127.2021.08.26.00.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 00:12:42 -0700 (PDT)
Date:   Thu, 26 Aug 2021 07:12:30 +0000
Message-Id: <20210826071230.11296-1-nathan@nathanrossi.com>
From:   Nathan Rossi <nathan@nathanrossi.com>
To:     netdev@vger.kernel.org
Cc:     Nathan Rossi <nathan@nathanrossi.com>,
        Nathan Rossi <nathan.rossi@digi.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: phylink: Update SFP selected interface on advertising changes
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

Signed-off-by: Nathan Rossi <nathan.rossi@digi.com>
---
 drivers/net/phy/phylink.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 2cdf9f989d..8986c7a0c5 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1525,6 +1525,22 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
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
+	}
+
 	mutex_lock(&pl->state_mutex);
 	pl->link_config.speed = config.speed;
 	pl->link_config.duplex = config.duplex;
---
2.33.0
