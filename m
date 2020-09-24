Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4571277817
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 19:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgIXR4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 13:56:25 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:39510 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgIXR4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 13:56:25 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08OHuNvI005747;
        Thu, 24 Sep 2020 12:56:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600970183;
        bh=D4LcdDCreRH05bP6ia0UcCZCz4HKEVcZWzX3m8N1tDE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=T2Z/ZQ6yyZ3h2K3jbBa4mUZf1qQYlhv7GnlhaWMmlbcss6fJqF671atgTPIzpiDPx
         8NKrvNpHxWKsS54j6qtHb4HK1PMmtfgsZgCwppbJ34T2KiRsNVuYiB7ShDbYyCvE+g
         zuIvlWAjgNsFXTUDO8X73pvmfApuxaaoJw0gVh5A=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08OHuMnS055223
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 12:56:22 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 24
 Sep 2020 12:56:22 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 24 Sep 2020 12:56:22 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08OHuLgN031650;
        Thu, 24 Sep 2020 12:56:22 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH ethtool v2 2/2] Update link mode tables for fiber
Date:   Thu, 24 Sep 2020 12:56:10 -0500
Message-ID: <20200924175610.22381-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200924175610.22381-1-dmurphy@ti.com>
References: <20200924175610.22381-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the link mode tables to include 100base Fx Full and Half duplex
modes.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 ethtool.c          | 6 ++++++
 netlink/settings.c | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index ab9b4577cbce..2f71fa92bb09 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -463,6 +463,8 @@ static void init_global_link_mode_masks(void)
 		ETHTOOL_LINK_MODE_400000baseLR4_ER4_FR4_Full_BIT,
 		ETHTOOL_LINK_MODE_400000baseDR4_Full_BIT,
 		ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT,
+		ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
+		ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
 	};
 	static const enum ethtool_link_mode_bit_indices
 		additional_advertised_flags_bits[] = {
@@ -659,6 +661,10 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
 		  "200000baseDR4/Full" },
 		{ 0, ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT,
 		  "200000baseCR4/Full" },
+		{ 0, ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
+		  "100baseFx/Half" },
+		{ 1, ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
+		  "100baseFx/Full" },
 	};
 	int indent;
 	int did1, new_line_pend;
diff --git a/netlink/settings.c b/netlink/settings.c
index 3059d4d0d0b7..41a2e5af1945 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -162,6 +162,8 @@ static const struct link_mode_info link_modes[] = {
 	[ETHTOOL_LINK_MODE_400000baseLR4_ER4_FR4_Full_BIT] = __REAL(400000),
 	[ETHTOOL_LINK_MODE_400000baseDR4_Full_BIT]	= __REAL(400000),
 	[ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT]	= __REAL(400000),
+	[ETHTOOL_LINK_MODE_100baseFX_Half_BIT]		= __HALF_DUPLEX(100),
+	[ETHTOOL_LINK_MODE_100baseFX_Full_BIT]		= __REAL(100),
 };
 const unsigned int link_modes_count = ARRAY_SIZE(link_modes);
 
-- 
2.28.0.585.ge1cfff676549

