Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5D82F59F3
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 05:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbhANEeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 23:34:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbhANEeg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 23:34:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 310CC2395A;
        Thu, 14 Jan 2021 04:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610598835;
        bh=thPppjaKGRqZkimKC3wJusQfaPgLWBRJyebPMxpvspU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h8T8JkKVPCjVdO3hvUQIUNgPM+ICm6YyfqxX61v6Cd4fI1u3VCNqhFxcRVzi6RckK
         eAic6rJmX4XVla/YEOvQKryPYyjSDCG/gEpFwl4f+LhgeTQsHNNzoJbsefF3vaVdv1
         DlNUM9SvCQ9TmA29sVuKLEvc7Mso+dVnZasXtwqvrOqWShR94BkEt9kJaljapJz/1O
         0sPZJK8VqQlhGR/TMZ4/e+c7+Za4yJeTzOiMLmhDEJhP+FzmXBg9yNstTdTsr3uaJr
         Ym/Rpc1H9iTcvdFSQ+gwvJedcMNaSZmGpcWT2t30l+ZXX+u444n+mzlB/Wri5PB6vX
         v6sbuVnMaN3Bw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        davem@davemloft.net, ashkan.boldaji@digi.com, andrew@lunn.ch,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v16 2/6] net: phy: Add 5GBASER interface mode
Date:   Thu, 14 Jan 2021 05:33:27 +0100
Message-Id: <20210114043331.4572-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114043331.4572-1-kabel@kernel.org>
References: <20210114043331.4572-1-kabel@kernel.org>
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
index b2f7ec794bc8..d7be261b5a8d 100644
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
index 9effb511acde..548372eb253a 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -106,6 +106,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_TRGMII: Turbo RGMII
  * @PHY_INTERFACE_MODE_1000BASEX: 1000 BaseX
  * @PHY_INTERFACE_MODE_2500BASEX: 2500 BaseX
+ * @PHY_INTERFACE_MODE_5GBASER: 5G BaseR
  * @PHY_INTERFACE_MODE_RXAUI: Reduced XAUI
  * @PHY_INTERFACE_MODE_XAUI: 10 Gigabit Attachment Unit Interface
  * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
@@ -137,6 +138,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_TRGMII,
 	PHY_INTERFACE_MODE_1000BASEX,
 	PHY_INTERFACE_MODE_2500BASEX,
+	PHY_INTERFACE_MODE_5GBASER,
 	PHY_INTERFACE_MODE_RXAUI,
 	PHY_INTERFACE_MODE_XAUI,
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
@@ -207,6 +209,8 @@ static inline const char *phy_modes(phy_interface_t interface)
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

