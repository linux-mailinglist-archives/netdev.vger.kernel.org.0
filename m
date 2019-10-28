Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD79EE7973
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731643AbfJ1Tyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:54:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38821 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJ1Tyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:54:35 -0400
Received: by mail-wr1-f68.google.com with SMTP id v9so11208815wrq.5
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 12:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3RGYoXEF6mlM/drQL6nqxugBx3yuEZG52bcQxGyccHw=;
        b=jnEoD3v/oBHhmri7LbS2LiDMcp6SoYrKytRRwyVG0o4eYwxamcaYa5+klcwnyZkviQ
         2ibKKYqAtSDTylQDo8SP7714wFgDa8AnCGl/N4Jv1IYKYVhK0CMFmzZGAeaRHXohvmXg
         mOml2AuRg55x1WhHywuAp2mH5HZd9UVKDY6RCu/lfxncbowrZSio52vYcejHpDnV19ec
         dJotQAOvFUWLMoNXaAA0Qy66Mo+TgzrY6ul/IFVlae6nuCV2bkdENyM6IsOjUbo2ZNjT
         ncdyBIW+T50kS0RwM75wZmHCM8IkAx8dM0WuQNlppYOA7d54te5bPz8HOh/O7Ru5XiuR
         XiNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3RGYoXEF6mlM/drQL6nqxugBx3yuEZG52bcQxGyccHw=;
        b=qH1YPmltqN7ZOLbqv6wIuUfrXYd6dHPtV9hDgcGx6AYUTIIFyrtmzVOF/Cfgm3hK0g
         mOMt5up7OgPTWJFNfpONM61wh8fxIGvmWCv6nx4Hgl7eYMos0E5fk7v2/o9TXJ1PxyIj
         xUCT+TW4zNhgzjpNWEgy1n151b4uqY2ZqpCa4qEQ8I3t14mlI+4yu7wofgZ6TSt7zvr6
         cESUen3MH67XfWD/W6B1zi0RnJV/JpYeeJwSa0nM2V+TThrTA12iUesMpYBnMamSBEZl
         bTxdilE1s+bsegnN0/clJrsJpbe0OzxH8l35zah786v0G7y+Vs+Ei73aE15yz1NA1rQH
         O0VQ==
X-Gm-Message-State: APjAAAU8M5tECFZOB/OobdlC4leiyISIPJfJlIqrt75CXS67uxkac0uA
        NArjm/1RVf0CV31nlYzyFbE=
X-Google-Smtp-Source: APXvYqwepcxw9GAidslNHDyApt3EzHhg6iiqUS/2CwBwO6DjMqHAWmg/5TCDnjTRfvTds3HK9lu1tA==
X-Received: by 2002:a5d:630f:: with SMTP id i15mr16658569wru.226.1572292473473;
        Mon, 28 Oct 2019 12:54:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f17:6e00:9578:29b8:2cd4:8cd8? (p200300EA8F176E00957829B82CD48CD8.dip0.t-ipconnect.de. [2003:ea:8f17:6e00:9578:29b8:2cd4:8cd8])
        by smtp.googlemail.com with ESMTPSA id n11sm598328wmd.26.2019.10.28.12.54.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 12:54:33 -0700 (PDT)
Subject: [PATCH net-next 3/4] net: phy: marvell: add downshift support for
 M88E1111
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>
References: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
Message-ID: <7c5be98d-6b75-68fe-c642-568943c5c4b6@gmail.com>
Date:   Mon, 28 Oct 2019 20:53:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds downshift support for M88E1111. This PHY version uses
another register for downshift configuration, reading downshift status
is possible via the same register as for other PHY versions.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/marvell.c | 64 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 68ef84c23..aa4864c67 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -66,6 +66,9 @@
 #define MII_M1111_PHY_LED_DIRECT	0x4100
 #define MII_M1111_PHY_LED_COMBINE	0x411c
 #define MII_M1111_PHY_EXT_CR		0x14
+#define MII_M1111_PHY_EXT_CR_DOWNSHIFT_MASK	GENMASK(11, 9)
+#define MII_M1111_PHY_EXT_CR_DOWNSHIFT_MAX	8
+#define MII_M1111_PHY_EXT_CR_DOWNSHIFT_EN	BIT(8)
 #define MII_M1111_RGMII_RX_DELAY	BIT(7)
 #define MII_M1111_RGMII_TX_DELAY	BIT(1)
 #define MII_M1111_PHY_EXT_SR		0x1b
@@ -784,6 +787,64 @@ static int m88e1111_config_init(struct phy_device *phydev)
 	return genphy_soft_reset(phydev);
 }
 
+static int m88e1111_get_downshift(struct phy_device *phydev, u8 *data)
+{
+	int val, cnt, enable;
+
+	val = phy_read(phydev, MII_M1111_PHY_EXT_CR);
+	if (val < 0)
+		return val;
+
+	enable = FIELD_GET(MII_M1111_PHY_EXT_CR_DOWNSHIFT_EN, val);
+	cnt = FIELD_GET(MII_M1111_PHY_EXT_CR_DOWNSHIFT_MASK, val) + 1;
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
+	if (cnt > MII_M1111_PHY_EXT_CR_DOWNSHIFT_MAX)
+		return -E2BIG;
+
+	if (!cnt)
+		return phy_clear_bits(phydev, MII_M1111_PHY_EXT_CR,
+				      MII_M1111_PHY_EXT_CR_DOWNSHIFT_EN);
+
+	val = MII_M1111_PHY_EXT_CR_DOWNSHIFT_EN;
+	val |= FIELD_PREP(MII_M1111_PHY_EXT_CR_DOWNSHIFT_MASK, cnt - 1);
+
+	return phy_modify(phydev, MII_M1111_PHY_EXT_CR,
+			  MII_M1111_PHY_EXT_CR_DOWNSHIFT_EN |
+			  MII_M1111_PHY_EXT_CR_DOWNSHIFT_MASK,
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
 static int m88e1011_get_downshift(struct phy_device *phydev, u8 *data)
 {
 	int val, cnt, enable;
@@ -2245,6 +2306,9 @@ static struct phy_driver marvell_drivers[] = {
 		.get_sset_count = marvell_get_sset_count,
 		.get_strings = marvell_get_strings,
 		.get_stats = marvell_get_stats,
+		.get_tunable = m88e1111_get_tunable,
+		.set_tunable = m88e1111_set_tunable,
+		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1118,
-- 
2.23.0


