Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFF02F1659
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 14:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387825AbhAKNv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 08:51:29 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:43244 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730745AbhAKNJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 08:09:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610370551; x=1641906551;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=9l1QY3cox8XuVSOW6qEto690IEm0ppYMFZW02yyo/5I=;
  b=kKhLLkBz2KLgzddsSZZiGqSXuUz7Ii4Bx6Uh0zwD/y+ME/wORcky+174
   ocFM/WHSgz7QIDTXe1/sY4qhKWoIbG0VfLN7VwkWc4gHlMytBNs2gSDW2
   L08bwV/qxtSq0BiYstJps/OK2J8V9fG7bHmUHjbWtWZFKUol1MYm/pA79
   Baxndix0P4LLj86TKewtuZThHBteqEgL7flecG7LP/Mzx6oi6F6gySyIz
   W344c50vBW5LhIHtanTby6hjREy0dPLf0+ZMIiySdHFwveV8aLn3xX1Hi
   kQjAMOJh9LoWGrVub92tJ9pZw8qou63RYLzvgGJXU7kMjSO7FDJ0CrFSM
   w==;
IronPort-SDR: JQRmB09qI+/CvZu4kvYowGl45QQZ3Dq/w6Q634FW6H2G62HNxL4uFsLa/gS9YxHhWeElqt6g2P
 Bii/lReY2+raOUBbp6IgfEs1BVJQqnDMjzfmtDoL61PRcn4ATQEL9ellLGMnvyw3KfRDXwJqmL
 WtCIjWVUnMNUvyx8BsxcrDy3StKd46Y+/4zbO7x83BeF6q4rwDxINfblsQErv766L2v7OTAqpS
 oFP1QPUBFxcp3Hluhwx3tpZR/fRfdkyohtCT/XSPHw66/XuUgqbqpjJI6Fv1H7ApKmEWvLnX+x
 tos=
X-IronPort-AV: E=Sophos;i="5.79,338,1602572400"; 
   d="scan'208";a="105520741"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Jan 2021 06:07:44 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 06:07:44 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 11 Jan 2021 06:07:42 -0700
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH v1 1/2] net: phy: Add 100 base-x mode
Date:   Mon, 11 Jan 2021 14:06:56 +0100
Message-ID: <20210111130657.10703-2-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
References: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparx-5 supports this mode and it is missing in the PHY core.

Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
---
 include/linux/phy.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 56563e5e0dc7..dce867222d58 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -111,6 +111,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
  * @PHY_INTERFACE_MODE_USXGMII:  Universal Serial 10GE MII
  * @PHY_INTERFACE_MODE_10GKR: 10GBASE-KR - with Clause 73 AN
+ * @PHY_INTERFACE_MODE_100BASEX: 100 BaseX
  * @PHY_INTERFACE_MODE_MAX: Book keeping
  *
  * Describes the interface between the MAC and PHY.
@@ -144,6 +145,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_USXGMII,
 	/* 10GBASE-KR - with Clause 73 AN */
 	PHY_INTERFACE_MODE_10GKR,
+	PHY_INTERFACE_MODE_100BASEX,
 	PHY_INTERFACE_MODE_MAX,
 } phy_interface_t;
 
@@ -217,6 +219,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "usxgmii";
 	case PHY_INTERFACE_MODE_10GKR:
 		return "10gbase-kr";
+	case PHY_INTERFACE_MODE_100BASEX:
+		return "100base-x";
 	default:
 		return "unknown";
 	}
-- 
2.17.1

