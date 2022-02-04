Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E1A4A9E17
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377090AbiBDRpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:45:25 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:43985 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377121AbiBDRpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 12:45:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643996722; x=1675532722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M5RUw9aInzvMr/cEGUCrZ6Um3TAA0XPSudFDktRPWxc=;
  b=FraUsa0n4mdjT6cPmUtELW61F29mnvx2YtqkO5MNqSXB7WOy6vwG4XuK
   WvbGhJr6tb88boHMXuJWCSU6SsA7hTLZqJUCQaGKExRqvCRiieatfdH4p
   KQctCTj+oX/s7nu6Yb/R8zBKn6zBFKtb4rqdVmF+EmhQ9OVNwdDUDMdof
   Q+7aMhONaR0KwKvcc+5V55h+/mJ8eecQxNdKg/b3j4nrCY8lzbetS3fwJ
   1mbV0zHaN7aZdLKJjJB2Oas+4OXHVzndUodYGVTzM+zMugAO453ZkbUPJ
   nyu6Ht0snDRGgvZiKxRIhe9rjcTmPyLxZlKYn0nkeWsj0T0DCoz0Nd3+9
   Q==;
IronPort-SDR: MHgGWhSl/fA056Bxf+cE++T50TgAUunZiKiYnMVhU++ENoVDmtQNkpJPclLaCRcoxORE7ak5gP
 5PoKLfcq7bvYRGJMnR8aGL1W8kwJpFmK7pMPKvX6/DosS2WTMnrYoTq8m/8T+lBVJKMXNR7Oqf
 LAY6nZ1LkCjl3JJo8mWo3uBZRcocVLE5aCxblguJDJfBazw/X6UK5vFbA1wkYh4z5O9k1blBGE
 b9DfcyrAy6mNtQ5xvpDNquvkWCQnBUr6yHl5e91c7kJo1VoXc29FUhG7nqI5MO6rBj0M0iTrel
 Ay/pbRASen9BB6U/BhuXkGKt
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="84716123"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Feb 2022 10:45:21 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Feb 2022 10:45:21 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Feb 2022 10:45:15 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v7 net-next 02/10] net: dsa: move mib->cnt_ptr reset code to ksz_common.c
Date:   Fri, 4 Feb 2022 23:14:52 +0530
Message-ID: <20220204174500.72814-3-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
References: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mib->cnt_ptr resetting is handled in multiple places as part of
port_init_cnt(). Hence moved mib->cnt_ptr code to ksz common layer
and removed from individual product files.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 2 --
 drivers/net/dsa/microchip/ksz9477.c    | 3 ---
 drivers/net/dsa/microchip/ksz_common.c | 8 +++++++-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 5dc9899bc0a6..2de2302b9a50 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -448,8 +448,6 @@ static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 					dropped, &mib->counters[mib->cnt_ptr]);
 		++mib->cnt_ptr;
 	}
-	mib->cnt_ptr = 0;
-	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
 }
 
 static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index a85d990896b0..21900cab96b3 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -292,9 +292,6 @@ static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 	ksz_write8(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FLUSH);
 	ksz_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT__4, 0);
 	mutex_unlock(&mib->cnt_mutex);
-
-	mib->cnt_ptr = 0;
-	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
 }
 
 static enum dsa_tag_protocol ksz9477_get_tag_protocol(struct dsa_switch *ds,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 7e33ec73f803..196aa4fc1100 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -122,8 +122,14 @@ void ksz_init_mib_timer(struct ksz_device *dev)
 
 	INIT_DELAYED_WORK(&dev->mib_read, ksz_mib_read_work);
 
-	for (i = 0; i < dev->port_cnt; i++)
+	for (i = 0; i < dev->port_cnt; i++) {
+		struct ksz_port_mib *mib = &dev->ports[i].mib;
+
 		dev->dev_ops->port_init_cnt(dev, i);
+
+		mib->cnt_ptr = 0;
+		memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
+	}
 }
 EXPORT_SYMBOL_GPL(ksz_init_mib_timer);
 
-- 
2.30.2

