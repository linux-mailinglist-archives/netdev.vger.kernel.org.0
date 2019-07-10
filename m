Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8CB64BD6
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfGJSED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:04:03 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46095 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbfGJSEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 14:04:02 -0400
Received: by mail-io1-f68.google.com with SMTP id i10so6625043iol.13;
        Wed, 10 Jul 2019 11:04:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N3Rsy7kAyosb+HN3kDlLYzc6alJagrduc8/wfJeEMl4=;
        b=ZcJH7cgTR2F1AQX1hEIxy94uAs1QNVb8TpBN3w5XjOtSgq+ZB0bBJoq5RO41Vcv/Qn
         sO8nqh78wpl8GgXnhT7rZDWxFateALFr1j/ljRjZIFSAQuGcfPddTURQMWtNmuHIkliZ
         kyvdzY2XlWkpBY+l8LbnNDuzRXi1zcFm6SYuqTdaPMyazrkz+03KxPBDOfV/gF6kLGsg
         U1YqkZ08Ltkc1axzZri23r1T0wWI3NzgW9tsNoTdd8uNM2CEsh4TCdSIvcdjIaF94SBj
         ngpw5mdEoZavEgrYYHZrXbIcoaE3D1PsbZCOTQMvAHLdJ0dD+CpUOXPl9f1HInr4tH0b
         41TA==
X-Gm-Message-State: APjAAAVJM40NR+pTYIQND4u/35XKF6jPTQHsOJ6G7UDJv0fq6lGFXkve
        fdxHacrUc7f9UwVLkY2Q4EnheJM71Tw=
X-Google-Smtp-Source: APXvYqzmwoVF6DBM86qH85QKC87M29/TzezeE/UsOBO54T5p1VXzTpyDXQPiRIS7IQQ7hS2FEymNkw==
X-Received: by 2002:a6b:8b8b:: with SMTP id n133mr5035866iod.183.1562781841945;
        Wed, 10 Jul 2019 11:04:01 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id j25sm3781428ioj.67.2019.07.10.11.03.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 11:04:01 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Denis Efremov <efremov@linux.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: make exported variables non-static
Date:   Wed, 10 Jul 2019 21:03:24 +0300
Message-Id: <20190710180324.8131-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variables phy_basic_ports_array, phy_fibre_port_array and
phy_all_ports_features_array are declared static and marked
EXPORT_SYMBOL_GPL(), which is at best an odd combination.
Because the variables were decided to be a part of API, this commit
removes the static attributes and adds the declarations to the header.

Fixes: 3c1bcc8614db ("net: ethernet: Convert phydev advertize and supported from u32 to link mode")
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/phy/phy_device.c | 6 +++---
 include/linux/phy.h          | 3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index dcc93a873174..f94171e9aa45 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -56,19 +56,19 @@ EXPORT_SYMBOL_GPL(phy_10gbit_features);
 __ETHTOOL_DECLARE_LINK_MODE_MASK(phy_10gbit_fec_features) __ro_after_init;
 EXPORT_SYMBOL_GPL(phy_10gbit_fec_features);
 
-static const int phy_basic_ports_array[] = {
+const int phy_basic_ports_array[3] = {
 	ETHTOOL_LINK_MODE_Autoneg_BIT,
 	ETHTOOL_LINK_MODE_TP_BIT,
 	ETHTOOL_LINK_MODE_MII_BIT,
 };
 EXPORT_SYMBOL_GPL(phy_basic_ports_array);
 
-static const int phy_fibre_port_array[] = {
+const int phy_fibre_port_array[1] = {
 	ETHTOOL_LINK_MODE_FIBRE_BIT,
 };
 EXPORT_SYMBOL_GPL(phy_fibre_port_array);
 
-static const int phy_all_ports_features_array[] = {
+const int phy_all_ports_features_array[7] = {
 	ETHTOOL_LINK_MODE_Autoneg_BIT,
 	ETHTOOL_LINK_MODE_TP_BIT,
 	ETHTOOL_LINK_MODE_MII_BIT,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 6424586fe2d6..ec54a788fc96 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -55,6 +55,9 @@ extern __ETHTOOL_DECLARE_LINK_MODE_MASK(phy_10gbit_full_features) __ro_after_ini
 #define PHY_10GBIT_FEC_FEATURES ((unsigned long *)&phy_10gbit_fec_features)
 #define PHY_10GBIT_FULL_FEATURES ((unsigned long *)&phy_10gbit_full_features)
 
+extern const int phy_basic_ports_array[3];
+extern const int phy_fibre_port_array[1];
+extern const int phy_all_ports_features_array[7];
 extern const int phy_10_100_features_array[4];
 extern const int phy_basic_t1_features_array[2];
 extern const int phy_gbit_features_array[2];
-- 
2.21.0

