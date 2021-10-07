Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A269425655
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242374AbhJGPO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:14:26 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:8162 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbhJGPOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 11:14:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633619551; x=1665155551;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G2s/9UEan3yiJsZIpjIchAr51RYq1sHW0/A5dVVNVO8=;
  b=LOjgwr1/N22zUNiZXiPbtvMYuYBNZyGcZ3TPwUa8YvF9F3bN6aEojSV1
   Od8RHcZHfx108aU7p0UbL7ScTrHiG/v4iVX4XbGgFDIWWuhLPC22dEbJ0
   ZwqqtQpuTeeRycf48To/7UmJBj+AhAd8OJf0mAybNS/kYHV9CPzqSgp26
   5XocCu0qN+KRXK2ZX+GICS8D3Ngl95Jqpo+ZMt1lnsih2XDT1T1EaHovs
   xwxfUfa/rhi0AL2IVqZbmujxXhOIeZFYpJ+3ikTsfgob/wJQqAcdm9oSN
   MeaqVtl39cgy+3Lk2QI9Obxzw+mAdIyQ+D8yhIylfb1RmcFsMbZdU53AU
   Q==;
IronPort-SDR: BQfucq1OsnSFAZCOI/UmgBy3ChXF7wDoHJoOFy+kkcQxF63Z9L6yLscoT66Ne7MrZ74dal5Ex1
 akXV7iocSSgJMF8kMFS30wEEyEDxSfHhHgl33+dWbhW7BJIg/opBMb6fbfKym907pkW+R8pA2T
 52EcEuhwNQdSBunNPSoaN/O4ClO9Zg6LZP1aO1ztFdEU/u08K/cClldWqV3+xYcUGm+XTvns3N
 PbiygVHUgADesrm6NGGjJno7+9jPcUoTOTotxiJSZJwpq9WLZzyNwAZzHv7ETomDqAr6zaPUyu
 Z3vAIdYn73ZG7OqB2dXGiOOF
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="139412035"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2021 08:12:31 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 7 Oct 2021 08:12:25 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 7 Oct 2021 08:12:20 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v4 net-next 02/10] net: dsa: move mib->cnt_ptr reset code to ksz_common.c
Date:   Thu, 7 Oct 2021 20:41:52 +0530
Message-ID: <20211007151200.748944-3-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
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
index c5142f86a3c7..9b194e94383d 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -447,8 +447,6 @@ static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 					dropped, &mib->counters[mib->cnt_ptr]);
 		++mib->cnt_ptr;
 	}
-	mib->cnt_ptr = 0;
-	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
 }
 
 static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 854e25f43fa7..35b430d531de 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -289,9 +289,6 @@ static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 	ksz_write8(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FLUSH);
 	ksz_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT__4, 0);
 	mutex_unlock(&mib->cnt_mutex);
-
-	mib->cnt_ptr = 0;
-	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
 }
 
 static enum dsa_tag_protocol ksz9477_get_tag_protocol(struct dsa_switch *ds,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 1542bfb8b5e5..2b27d7917903 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -103,8 +103,14 @@ void ksz_init_mib_timer(struct ksz_device *dev)
 
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
2.27.0

