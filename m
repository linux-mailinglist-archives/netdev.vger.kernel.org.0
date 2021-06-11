Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5731F3A40AC
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhFKK7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:59:46 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:40820 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbhFKK6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:58:34 -0400
Received: by mail-ed1-f53.google.com with SMTP id t3so36609899edc.7;
        Fri, 11 Jun 2021 03:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vueqJSt6pY+lxc+Z/mKjcO5ezlG6lkT9SZq+vFZbhNY=;
        b=gdldU7R3P/NNCbrN2isq4xDsePr3vSzc1bLdQd0Pkp/+Z3tGqW28vE8Swqxhntzfex
         PR2D0mu4fCJQOeVr2skStnTqsl1Tvpm2hp7ZTALXxcvVX57SakGnPShv+1CKkiVBAt3a
         iraeQZqw0AK2uOlo9iwFZ2ioxIHFJW0wDMxIfMi+39nlWZ+ZUSbRJDBsEjw935tzhQi6
         7ZNmr0KfT8etgIO4qd7m6gwTuWSNDH340Qdunh2OHzIVQVEF+Wa6jko3gZRrhbB5grlb
         QekpyTkK5bRl9xEScckMd/Smf2oArhUu50sdVJdbuk4qY2t1wOi1h5XXcpViLvgufYhr
         haEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vueqJSt6pY+lxc+Z/mKjcO5ezlG6lkT9SZq+vFZbhNY=;
        b=G7edEduyp2QYslcjlr0qPYIZWUNuOAQbyqEBqFhFb364tdNZzz3sEyC5E6gXvNcLDp
         6UmXZrM1pte7T5ruEmf8/od6wKD8JvrbMfElI3xyFK+zwoTBPK5CtSMnxFAfGP/xCwy5
         h3rQtrfznwsx8Ob+mBhJ02A6uLrOPXz1hIK3B8ul0D8FNNhWV8YOERXXv3dUmrUseAU5
         aC/js7StCX7Tb8UVxLMG3vHN1Welu+NbkPyQxLo5ov3d+w3kyC8SZwjKkl5j6CTzwXdQ
         IxksfyjM7xfaudtcJsnqlDqPPgNr79dtfMmxSz5fNvV+JVyhGYnV3P+rxgOhXrLvKN16
         /Ztg==
X-Gm-Message-State: AOAM532wwsmuuKqYGmqLEqPZMIAxcTojm6AjvgPWsnbQE2xlWUTWtGim
        xIr4c7lQvTYS0w2qiBup4Z4=
X-Google-Smtp-Source: ABdhPJxPJuoDMAq2Wr5q2LkhRcTuAk0wiZ8V1LOGRaTDvTtL81Ro5WteEPx1PgU9H2/cfwF6RtJmKg==
X-Received: by 2002:a05:6402:101a:: with SMTP id c26mr3110087edu.19.1623408925151;
        Fri, 11 Jun 2021 03:55:25 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r19sm2492051eds.75.2021.06.11.03.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:55:24 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        calvin.johnson@oss.nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v9 14/15] net: phylink: Refactor phylink_of_phy_connect()
Date:   Fri, 11 Jun 2021 13:54:00 +0300
Message-Id: <20210611105401.270673-15-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Refactor phylink_of_phy_connect() to use phylink_fwnode_phy_connect().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Grant Likely <grant.likely@arm.com>
---

Changes in v9: None
Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/phy/phylink.c | 39 +--------------------------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9cc0f69faafe..bb9eeb74f70a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1085,44 +1085,7 @@ EXPORT_SYMBOL_GPL(phylink_connect_phy);
 int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 			   u32 flags)
 {
-	struct device_node *phy_node;
-	struct phy_device *phy_dev;
-	int ret;
-
-	/* Fixed links and 802.3z are handled without needing a PHY */
-	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
-	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
-	     phy_interface_mode_is_8023z(pl->link_interface)))
-		return 0;
-
-	phy_node = of_parse_phandle(dn, "phy-handle", 0);
-	if (!phy_node)
-		phy_node = of_parse_phandle(dn, "phy", 0);
-	if (!phy_node)
-		phy_node = of_parse_phandle(dn, "phy-device", 0);
-
-	if (!phy_node) {
-		if (pl->cfg_link_an_mode == MLO_AN_PHY)
-			return -ENODEV;
-		return 0;
-	}
-
-	phy_dev = of_phy_find_device(phy_node);
-	/* We're done with the phy_node handle */
-	of_node_put(phy_node);
-	if (!phy_dev)
-		return -ENODEV;
-
-	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
-				pl->link_interface);
-	if (ret)
-		return ret;
-
-	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
-	if (ret)
-		phy_detach(phy_dev);
-
-	return ret;
+	return phylink_fwnode_phy_connect(pl, of_fwnode_handle(dn), flags);
 }
 EXPORT_SYMBOL_GPL(phylink_of_phy_connect);
 
-- 
2.31.1

