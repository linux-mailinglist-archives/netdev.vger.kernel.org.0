Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D191331D0E9
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhBPTWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:22:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230236AbhBPTWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 14:22:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52F1C64EAE;
        Tue, 16 Feb 2021 19:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613503283;
        bh=W7fj9c0DvNZzR2btLzllGTiumDSRsIl/b4n3A/oliU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLZrcNNL5rYChEjEtQAklqYrzOAkypK8VQDiX81tpCb9cRVJJYT10xIc6ejVGfbPP
         3+bm1g3PT/Puyzj3ITh/63rphLwEbOzuZtmpqMzzAU8hKFV+BThScR4uK6cANPEUOt
         h6/BlqtyGE2tGFBADtSr2L6fm9pffQGOUu1M3c1wZAt7iifqwru/SvHASy0BPjSpVw
         qbxXmjv1sfaQjq8BfYUZil6xpjYo0jc8/zgzugIQm9rnYUdVZNhwORJ3MitqwXN/VD
         N1Umpv8GxDxNyOfwftrFUHjhbbD6kRLD+Y80GiuaYboEBSKn6V8k0vZxbLLcqJXneC
         D6fWw5OSv0R7g==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        davem@davemloft.net, kuba@kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, lkp@intel.com, ashkan.boldaji@digi.com,
        andrew@lunn.ch, Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 2/4] net: phy: Add 5GBASER interface mode
Date:   Tue, 16 Feb 2021 20:20:53 +0100
Message-Id: <20210216192055.7078-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210216192055.7078-1-kabel@kernel.org>
References: <20210216192055.7078-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavana Sharma <pavana.sharma@digi.com>

Add 5GBASE-R phy interface mode

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 Documentation/networking/phy.rst | 6 ++++++
 include/linux/phy.h              | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
index 70136cc9e25e..06adfc2afcf0 100644
--- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -267,6 +267,12 @@ Some of the interface modes are described below:
     duplex, pause or other settings.  This is dependent on the MAC and/or
     PHY behaviour.
 
+``PHY_INTERFACE_MODE_5GBASER``
+    This is the IEEE 802.3 Clause 129 defined 5GBASE-R protocol. It is
+    identical to the 10GBASE-R protocol defined in Clause 49, with the
+    exception that it operates at half the frequency. Please refer to the
+    IEEE standard for the definition.
+
 ``PHY_INTERFACE_MODE_10GBASER``
     This is the IEEE 802.3 Clause 49 defined 10GBASE-R protocol used with
     various different mediums. Please refer to the IEEE standard for a
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5d7c4084ade9..0d537f59b77f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -107,6 +107,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_100BASEX: 100 BaseX
  * @PHY_INTERFACE_MODE_1000BASEX: 1000 BaseX
  * @PHY_INTERFACE_MODE_2500BASEX: 2500 BaseX
+ * @PHY_INTERFACE_MODE_5GBASER: 5G BaseR
  * @PHY_INTERFACE_MODE_RXAUI: Reduced XAUI
  * @PHY_INTERFACE_MODE_XAUI: 10 Gigabit Attachment Unit Interface
  * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
@@ -139,6 +140,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_100BASEX,
 	PHY_INTERFACE_MODE_1000BASEX,
 	PHY_INTERFACE_MODE_2500BASEX,
+	PHY_INTERFACE_MODE_5GBASER,
 	PHY_INTERFACE_MODE_RXAUI,
 	PHY_INTERFACE_MODE_XAUI,
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
@@ -209,6 +211,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "1000base-x";
 	case PHY_INTERFACE_MODE_2500BASEX:
 		return "2500base-x";
+	case PHY_INTERFACE_MODE_5GBASER:
+		return "5gbase-r";
 	case PHY_INTERFACE_MODE_RXAUI:
 		return "rxaui";
 	case PHY_INTERFACE_MODE_XAUI:
-- 
2.26.2

