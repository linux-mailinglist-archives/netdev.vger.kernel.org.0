Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063282B8BC4
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 07:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgKSGkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 01:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgKSGkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 01:40:46 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3844FC0613CF
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 22:40:45 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id 11so5072239ljf.2
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 22:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dKNU+afGBf1Qm/b+Fa4Q689rAWX8n69x914nbxzJNjc=;
        b=DoW9J1RkyOD/RmBNO1zQh4WPG6KeG9pzrb8wZiU9WQSMCfr+Gx0DMOFSrUhA8QH/r4
         V9IqbOuFw7OheBNw04Pgjs6sbbCpFircqjcmPPEwIEL/p7mdcTkma+8L0r3xRUDlH0ox
         ROrKfIVFtAQ/PbNQaXK+kVa+T2JFYs0fdoBH5dDLNjOqn9xq4vD1VPMHFiAl4ywhJ0pO
         jtDmGMF8+cnAJRxk43MyisRg9IN6+sZZTa7IIuJkXttke9dj0VWnyeG7SPkpRRUTmfRl
         x0S7VuaZN0NIwvq3a1WEO0rUXQPlWTTELNln7jOuOiDsdz7lC1CocGMJDlkiW7wVU7Wt
         9H4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dKNU+afGBf1Qm/b+Fa4Q689rAWX8n69x914nbxzJNjc=;
        b=YgG4mC4pP3MXaG6RmZQLJ6FKZMQFbQ8ek52aJY3aLe0Whjmpalpnk6OCkpn5O2AY2d
         8oLKLC5i4Kxx9fG11FREstBY+gx/GOJt+JT5BXBkiO/O8tPwNV+844SecJikbblFUtwd
         5C95GD63PXhVyQ9ywudY0MMzw3GxlcYbeB2xhVADcSbY45mhwRB0jm0QUZYRX/oqKsNA
         iuxwc2SxAog+iMIIHVAf0IN6d/S65uIup2QhDX0VdRyjJQEDI3VOwFa9Gh0i2afiUew5
         FhvU+BJIu2LycbtYaAg4nboF1uZZjIeEFdev1+4nwMqvFd5QvHmV26FKlDlyKgAl72p5
         /xtg==
X-Gm-Message-State: AOAM531dqJu07wuxC1I2lARC8zWcZtYFSb0R9efTEVjQxemV7f6EL9EW
        FrlDOjw8OmSKolKm5dvL7dxFnB4jvQSh+gecJVk=
X-Google-Smtp-Source: ABdhPJwhSojzWRjlVilHCyFx/LxcyoC/Tv57A5XPX/JfLwI5nTR/ffmkpFtZMO4Z45N5WbQqmlhzKw==
X-Received: by 2002:a2e:a0ca:: with SMTP id f10mr5215847ljm.204.1605768042004;
        Wed, 18 Nov 2020 22:40:42 -0800 (PST)
Received: from container-ubuntu.lan ([240e:398:25da:d530::d2c])
        by smtp.gmail.com with ESMTPSA id w11sm3672107lji.135.2020.11.18.22.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 22:40:41 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Greg Ungerer <gerg@kernel.org>,
        Alex Dewar <alex.dewar90@gmail.com>,
        Chuanhong Guo <gch981213@gmail.com>
Subject: [RFC PATCH net-next] net: dsa: mt7530: support setting ageing time
Date:   Thu, 19 Nov 2020 14:40:20 +0800
Message-Id: <20201119064020.19522-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MT7530 has a global address age control register, so use it to set
ageing time.

The applied timer is (AGE_CNT + 1) * (AGE_UNIT + 1) seconds

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 41 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.h | 13 +++++++++++++
 2 files changed, 54 insertions(+)

RFC:
1. What is the expected behaviour if the timer is too big or too small?
   - return -ERANGE or -EINVAL;
     or
   - if it is too big, apply the maximum value; if it is too small,
     disable learning;

2. Is there a better algorithm to find the closest pair?

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 6408402a44f5..99bf8fed6536 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -870,6 +870,46 @@ mt7530_get_sset_count(struct dsa_switch *ds, int port, int sset)
 	return ARRAY_SIZE(mt7530_mib);
 }
 
+static int
+mt7530_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
+{
+	struct mt7530_priv *priv = ds->priv;
+	unsigned int secs = msecs / 1000;
+	unsigned int tmp_age_count;
+	unsigned int error = -1;
+	unsigned int age_count;
+	unsigned int age_unit;
+
+	/* Applied timer is (AGE_CNT + 1) * (AGE_UNIT + 1) seconds */
+	if (secs < 1 || secs > (AGE_CNT_MAX + 1) * (AGE_UNIT_MAX + 1))
+		return -ERANGE;
+
+	/* iterate through all possible age_count to find the closest pair */
+	for (tmp_age_count = 0; tmp_age_count <= AGE_CNT_MAX; ++tmp_age_count) {
+		unsigned int tmp_age_unit = secs / (tmp_age_count + 1) - 1;
+
+		if (tmp_age_unit <= AGE_UNIT_MAX) {
+			unsigned int tmp_error = secs -
+				(tmp_age_count + 1) * (tmp_age_unit + 1);
+
+			/* found a closer pair */
+			if (error > tmp_error) {
+				error = tmp_error;
+				age_count = tmp_age_count;
+				age_unit = tmp_age_unit;
+			}
+
+			/* found the exact match, so break the loop */
+			if (!error)
+				break;
+		}
+	}
+
+	mt7530_write(priv, MT7530_AAC, AGE_CNT(age_count) | AGE_UNIT(age_unit));
+
+	return 0;
+}
+
 static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
@@ -2564,6 +2604,7 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.phy_write		= mt753x_phy_write,
 	.get_ethtool_stats	= mt7530_get_ethtool_stats,
 	.get_sset_count		= mt7530_get_sset_count,
+	.set_ageing_time	= mt7530_set_ageing_time,
 	.port_enable		= mt7530_port_enable,
 	.port_disable		= mt7530_port_disable,
 	.port_change_mtu	= mt7530_port_change_mtu,
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index ee3523a7537e..32d8969b3ace 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -161,6 +161,19 @@ enum mt7530_vlan_egress_attr {
 	MT7530_VLAN_EGRESS_STACK = 3,
 };
 
+/* Register for address age control */
+#define MT7530_AAC			0xa0
+/* Disable ageing */
+#define  AGE_DIS			BIT(20)
+/* Age count */
+#define  AGE_CNT_MASK			GENMASK(19, 12)
+#define  AGE_CNT_MAX			0xff
+#define  AGE_CNT(x)			(AGE_CNT_MASK & ((x) << 12))
+/* Age unit */
+#define  AGE_UNIT_MASK			GENMASK(11, 0)
+#define  AGE_UNIT_MAX			0xfff
+#define  AGE_UNIT(x)			(AGE_UNIT_MASK & (x))
+
 /* Register for port STP state control */
 #define MT7530_SSP_P(x)			(0x2000 + ((x) * 0x100))
 #define  FID_PST(x)			((x) & 0x3)
-- 
2.25.1

