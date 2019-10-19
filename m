Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D42DD8E1
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 15:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfJSN6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 09:58:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43383 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfJSN6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 09:58:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so3828716wrr.10
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 06:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/MNWG5BnTXuBYncjBlYE5q4+6Sr1fTtTCCYRYbhbOZk=;
        b=I3is3RxfhaPCxcEVInHeTPG7N40AZ4gTJIhyB2oN50ZcXDHJ/OpOXBSAMdbyLKSY6B
         C3yFgtBrXzyLR+M0uHvEdFWNXEmNHRZGHLmTt1ZVI0BKCBjyWrqnzGcut0dw60nDZiNR
         CoCeV64DTCBJZl88B3uG0uPiGyRJ9CLUEtQtPL4wwCBki3sss8y7TIoId0hh9LJqijus
         WGHCBXmg1T0hf+MZff4WfZwatfTKlMpydf0kRIK8eKrjDCUYBa7NsHm1JKvy04ADMbiL
         xhJmHWcfG7F7wVEIj+bWKUXZwsjaYVAp1KiP2aqobq1RQjjOWcna1s6M39NUdD3mYPOm
         cfaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/MNWG5BnTXuBYncjBlYE5q4+6Sr1fTtTCCYRYbhbOZk=;
        b=a20cPRQQSNxgZn4f1IUniiBkzgCUSQUia0oJsnIE0D5SIvxX1XftWiIH1bSzbXB6Sz
         /CUdcp2ue/9ihWYSNiLN8tGsaCSiVdh3DWa/vEhR2wx07WtMLhFrZmMpfbbcaXKJVEuV
         kL4glPbXStY9nDQKqT59YaxOL6P9cUsvNK+i3JZ4EvC8Od/4vOMjF5ByfR35pTAxs+B0
         Cj1elPs8dPgkptURpmJhAFAP9IUm1Tv9sNviFfWbU8yuffVUYOfgrekTaUu276KA1IeF
         DsS59aD8rm9Y+HFwnjzkZo8TLvw0RBWkTiBsFt07hlhvOeKHLLvlbfFd/drx/Qxvsnz5
         oCOw==
X-Gm-Message-State: APjAAAWiTMvj9/nr2RTOn8lS0NdbrJ5uxGbugRlnPYX9khZg8E51EliP
        3R5BV/+jpc3gPyIWgtp0rd4BXgqS
X-Google-Smtp-Source: APXvYqzuU1bHwnpPU7EQUjPlbpYOGJyAsKvCwf263O5NJCAxqc+CJ7guUChjyWQSwYVPrsRky60KFg==
X-Received: by 2002:adf:e903:: with SMTP id f3mr11581100wrm.121.1571493510931;
        Sat, 19 Oct 2019 06:58:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:cd3d:5fcd:4de0:e061? (p200300EA8F266400CD3D5FCD4DE0E061.dip0.t-ipconnect.de. [2003:ea:8f26:6400:cd3d:5fcd:4de0:e061])
        by smtp.googlemail.com with ESMTPSA id r12sm8620398wrq.88.2019.10.19.06.58.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Oct 2019 06:58:30 -0700 (PDT)
Subject: [PATCH net-next 1/2] net: phy: marvell: support downshift as PHY
 tunable
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <85961f9a-999c-743d-3fd2-66c10e7a219e@gmail.com>
Message-ID: <816cc39a-ad25-ca38-26a5-2b7f22673d2c@gmail.com>
Date:   Sat, 19 Oct 2019 15:57:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <85961f9a-999c-743d-3fd2-66c10e7a219e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far downshift is implemented for one small use case only and can't
be controlled from userspace. So let's implement this feature properly
as a PHY tunable so that it can be controlled via ethtool.
More Marvell PHY's may support downshift, but I restricted it for now
to the ones where I have the datasheet.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/marvell.c | 88 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 87 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index a7796134e..bd9bc0b4c 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -54,11 +54,15 @@
 #define MII_M1011_PHY_SCR			0x10
 #define MII_M1011_PHY_SCR_DOWNSHIFT_EN		BIT(11)
 #define MII_M1011_PHY_SCR_DOWNSHIFT_SHIFT	12
-#define MII_M1011_PHY_SRC_DOWNSHIFT_MASK	0x7800
+#define MII_M1011_PHY_SRC_DOWNSHIFT_MASK	GENMASK(14, 12)
+#define MII_M1011_PHY_SCR_DOWNSHIFT_MAX		8
 #define MII_M1011_PHY_SCR_MDI			(0x0 << 5)
 #define MII_M1011_PHY_SCR_MDI_X			(0x1 << 5)
 #define MII_M1011_PHY_SCR_AUTO_CROSS		(0x3 << 5)
 
+#define MII_M1011_PHY_SSR			0x11
+#define MII_M1011_PHY_SSR_DOWNSHIFT		BIT(5)
+
 #define MII_M1111_PHY_LED_CONTROL	0x18
 #define MII_M1111_PHY_LED_DIRECT	0x4100
 #define MII_M1111_PHY_LED_COMBINE	0x411c
@@ -833,6 +837,79 @@ static int m88e1111_config_init(struct phy_device *phydev)
 	return genphy_soft_reset(phydev);
 }
 
+static int m88e1111_get_downshift(struct phy_device *phydev, u8 *data)
+{
+	int val, cnt, enable;
+
+	val = phy_read(phydev, MII_M1011_PHY_SCR);
+	if (val < 0)
+		return val;
+
+	enable = FIELD_GET(MII_M1011_PHY_SCR_DOWNSHIFT_EN, val);
+	cnt = FIELD_GET(MII_M1011_PHY_SRC_DOWNSHIFT_MASK, val) + 1;
+
+	*data = enable ? cnt : DOWNSHIFT_DEV_DISABLE;
+
+	return 0;
+}
+
+static int m88e1111_set_downshift(struct phy_device *phydev, u8 cnt)
+{
+	int val;
+
+	if (cnt > MII_M1011_PHY_SCR_DOWNSHIFT_MAX)
+		return -E2BIG;
+
+	if (!cnt)
+		return phy_clear_bits(phydev, MII_M1011_PHY_SCR,
+				      MII_M1011_PHY_SCR_DOWNSHIFT_EN);
+
+	val = MII_M1011_PHY_SCR_DOWNSHIFT_EN;
+	val |= FIELD_PREP(MII_M1011_PHY_SRC_DOWNSHIFT_MASK, cnt - 1);
+
+	return phy_modify(phydev, MII_M1011_PHY_SCR,
+			  MII_M1011_PHY_SCR_DOWNSHIFT_EN |
+			  MII_M1011_PHY_SRC_DOWNSHIFT_MASK,
+			  val);
+}
+
+static int m88e1111_get_tunable(struct phy_device *phydev,
+				struct ethtool_tunable *tuna, void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return m88e1111_get_downshift(phydev, data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int m88e1111_set_tunable(struct phy_device *phydev,
+				struct ethtool_tunable *tuna, const void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return m88e1111_set_downshift(phydev, *(const u8 *)data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void m88e1111_link_change_notify(struct phy_device *phydev)
+{
+	int status;
+
+	if (phydev->state != PHY_RUNNING)
+		return;
+
+	/* we may be on fiber page currently */
+	status = phy_read_paged(phydev, MII_MARVELL_COPPER_PAGE,
+				MII_M1011_PHY_SSR);
+
+	if (status > 0 && status & MII_M1011_PHY_SSR_DOWNSHIFT)
+		phydev_warn(phydev, "Downshift occurred! Cabling may be defective.\n");
+}
+
 static int m88e1318_config_init(struct phy_device *phydev)
 {
 	if (phy_interrupt_is_valid(phydev)) {
@@ -1117,6 +1194,8 @@ static int m88e1540_get_tunable(struct phy_device *phydev,
 	switch (tuna->id) {
 	case ETHTOOL_PHY_FAST_LINK_DOWN:
 		return m88e1540_get_fld(phydev, data);
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return m88e1111_get_downshift(phydev, data);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1128,6 +1207,8 @@ static int m88e1540_set_tunable(struct phy_device *phydev,
 	switch (tuna->id) {
 	case ETHTOOL_PHY_FAST_LINK_DOWN:
 		return m88e1540_set_fld(phydev, data);
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return m88e1111_set_downshift(phydev, *(const u8 *)data);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -2220,6 +2301,9 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
+		.get_tunable = m88e1111_get_tunable,
+		.set_tunable = m88e1111_set_tunable,
+		.link_change_notify = m88e1111_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1318S,
@@ -2359,6 +2443,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
+		.link_change_notify = m88e1111_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1545,
@@ -2421,6 +2506,7 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
+		.link_change_notify = m88e1111_link_change_notify,
 	},
 };
 
-- 
2.23.0


