Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F2CD50F9
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 18:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbfJLQ2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 12:28:06 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43429 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbfJLQ2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 12:28:06 -0400
Received: by mail-wr1-f68.google.com with SMTP id j18so15010616wrq.10
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 09:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/UZ/mVW0xgQa9ZQDS+9E2Ri1me6o1USXQTTcDiYi6Fw=;
        b=uhrX6ov1qSUQjaFc4VXoUQfZ+kMqc88buDzRaQRv8LQIm3S4cMLVM7UtdWdTWh6XHC
         AwQ6Y/iqQjQpUbzvTxrscNx2S7kJ3M9a3CCwTXVLMxsIagIGyY2KOrKHvY48sVTtMbra
         7qlGM4gTVMDLgYOTSKNZgVXQchIpXPkgfAVyuSm/MCAkfEbU6jOusm9JcHJ8tuxTVPqP
         fl32GVwQ5hYrBTlUuSjR8OInFnTWnuj5nEPhIct8b4cY+5Urjcjq5+LAYDpZr8RbbF+x
         enipTFA9TSTll9usc2hZn3+cFw5e/b9sGaPsO6xgWRgLBZW1iWo/cbYRv4yp4G4JUjQz
         YP0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/UZ/mVW0xgQa9ZQDS+9E2Ri1me6o1USXQTTcDiYi6Fw=;
        b=pznEojcbv/v+4lwA68sn4oHQNk+rzVbdJWDUjLXqOyAn++Li9NBRjaJhOrcjkZm2bl
         wvz/W/z1iOHoRp7ZTpvuV8XlxVZSVMOQt6cguY+yOx3gVjt6+6AsJ/TAVW97F6/GHXf2
         L5GNxZHXyAm81qBp6cRJPFytraq1bQQi/NyiVPjhvyRtJpkKa9LvUSTNhcYpfebICN5y
         M68dQV0FULbvh9+TciS+/EzDn67vAvK9l9LZNcRSDdRZFhVGM9AfjQw3zy8poSECU12R
         j2IZPl8E8/8kEu6RoI0XMbcCj4gfkCZ8QV8tVDGE1/bsQPlxIzjT+XYwjOgFmnuNGFG4
         HGLQ==
X-Gm-Message-State: APjAAAWJz1v2/kOzlCOKmUj7ftsT734OWvvwE3yXWD+DFKQgZJEEFsSt
        fzsCqwKy6IHsvEISBFF7KTekDrQzDR8=
X-Google-Smtp-Source: APXvYqzErMbG4x9ye8hGQUn5J8rhXhpymkIDxkobuxYuNQWYuuVQLvll4hkjPxmJNnszYeYZBUXvlA==
X-Received: by 2002:adf:dc42:: with SMTP id m2mr3187490wrj.314.1570897681670;
        Sat, 12 Oct 2019 09:28:01 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a2sm21101484wrt.45.2019.10.12.09.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 09:28:01 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, mlxsw@mellanox.com
Subject: [patch net-next v2 2/2] mlxsw: spectrum: Add support for 400Gbps (50Gbps per lane) link modes
Date:   Sat, 12 Oct 2019 18:27:58 +0200
Message-Id: <20191012162758.32473-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191012162758.32473-1-jiri@resnulli.us>
References: <20191012162758.32473-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Extend speed support with 400Gbps

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 52 +++++++++++++++----
 2 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 7b538e698a3d..f5e39758c6ac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -4111,6 +4111,7 @@ MLXSW_ITEM32(reg, ptys, an_status, 0x04, 28, 4);
 #define MLXSW_REG_PTYS_EXT_ETH_SPEED_CAUI_4_100GBASE_CR4_KR4		BIT(9)
 #define MLXSW_REG_PTYS_EXT_ETH_SPEED_100GAUI_2_100GBASE_CR2_KR2		BIT(10)
 #define MLXSW_REG_PTYS_EXT_ETH_SPEED_200GAUI_4_200GBASE_CR4_KR4		BIT(12)
+#define MLXSW_REG_PTYS_EXT_ETH_SPEED_400GAUI_8				BIT(15)
 
 /* reg_ptys_ext_eth_proto_cap
  * Extended Ethernet port supported speeds and protocols.
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 3c5154e559b2..ae3c4da11520 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2912,9 +2912,22 @@ mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4[] = {
 #define MLXSW_SP2_MASK_ETHTOOL_200GAUI_4_200GBASE_CR4_KR4_LEN \
 	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4)
 
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_400gaui_8[] = {
+	ETHTOOL_LINK_MODE_400000baseKR8_Full_BIT,
+	ETHTOOL_LINK_MODE_400000baseSR8_Full_BIT,
+	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT,
+	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT,
+	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_400GAUI_8_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_400gaui_8)
+
 #define MLXSW_SP_PORT_MASK_WIDTH_1X	BIT(0)
 #define MLXSW_SP_PORT_MASK_WIDTH_2X	BIT(1)
 #define MLXSW_SP_PORT_MASK_WIDTH_4X	BIT(2)
+#define MLXSW_SP_PORT_MASK_WIDTH_8X	BIT(3)
 
 static u8 mlxsw_sp_port_mask_width_get(u8 width)
 {
@@ -2925,6 +2938,8 @@ static u8 mlxsw_sp_port_mask_width_get(u8 width)
 		return MLXSW_SP_PORT_MASK_WIDTH_2X;
 	case 4:
 		return MLXSW_SP_PORT_MASK_WIDTH_4X;
+	case 8:
+		return MLXSW_SP_PORT_MASK_WIDTH_8X;
 	default:
 		WARN_ON_ONCE(1);
 		return 0;
@@ -2946,7 +2961,8 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_SGMII_100M_LEN,
 		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X,
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_100,
 	},
 	{
@@ -2955,7 +2971,8 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_1000BASE_X_SGMII_LEN,
 		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X,
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_1000,
 	},
 	{
@@ -2964,7 +2981,8 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_2_5GBASE_X_2_5GMII_LEN,
 		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X,
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_2500,
 	},
 	{
@@ -2973,7 +2991,8 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_5GBASE_R_LEN,
 		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X,
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_5000,
 	},
 	{
@@ -2982,14 +3001,16 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_XFI_XAUI_1_10G_LEN,
 		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X,
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_10000,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_XLAUI_4_XLPPI_4_40G,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_xlaui_4_xlppi_4_40g,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_XLAUI_4_XLPPI_4_40G_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_40000,
 	},
 	{
@@ -2998,7 +3019,8 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_25GAUI_1_25GBASE_CR_KR_LEN,
 		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
 				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X,
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_25000,
 	},
 	{
@@ -3006,7 +3028,8 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_50gaui_2_laui_2_50gbase_cr2_kr2,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_50GAUI_2_LAUI_2_50GBASE_CR2_KR2_LEN,
 		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X,
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_50000,
 	},
 	{
@@ -3020,7 +3043,8 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_CAUI_4_100GBASE_CR4_KR4,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_caui_4_100gbase_cr4_kr4,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_CAUI_4_100GBASE_CR4_KR4_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_100000,
 	},
 	{
@@ -3034,9 +3058,17 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_200GAUI_4_200GBASE_CR4_KR4,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4,
 		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_200GAUI_4_200GBASE_CR4_KR4_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_200000,
 	},
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_400GAUI_8,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_400gaui_8,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_400GAUI_8_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.speed		= SPEED_400000,
+	},
 };
 
 #define MLXSW_SP2_PORT_LINK_MODE_LEN ARRAY_SIZE(mlxsw_sp2_port_link_mode)
-- 
2.21.0

