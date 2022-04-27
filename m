Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F739511F32
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242813AbiD0Qai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243701AbiD0Q3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:29:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F28580F7;
        Wed, 27 Apr 2022 09:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651076681; x=1682612681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fUZVTNEK+ZzSBGo/CLd/jGBkWZYuNOvhG78Dm9No89s=;
  b=RpUYWp8FoLASB0/00pIr0argib/ePYX4urp2tZQUFHZHiY3vPRfJf+hW
   YtsFUiTgzZnHUCVLlzYsJznEBLn0FUJX/vgiFJpUTb8krGJE2jEspUx8H
   4TAW/vP9WFX36cPpEPfhbBq9++wdsDq8kW7nr9sydyvG8ww+Ft/lix2xc
   40oF89wUmD3Be5+mkHbd0p01gmdrYoolxwJ+VdoLp6q76iKt+AnMv9LFx
   qhPW5ITpvV3lyBmTEJppy2EGyhIZ75ilnXYuZmPs8tcTER0TfQr1+EfPJ
   +g3hffZDxtVweVWK7wRPOa95ieh2iUH++VLQzSnfbC6X71AJfM2DqcZm+
   w==;
X-IronPort-AV: E=Sophos;i="5.90,293,1643698800"; 
   d="scan'208";a="171138160"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Apr 2022 09:24:40 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 27 Apr 2022 09:24:39 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 27 Apr 2022 09:24:30 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [RFC patch net-next 2/3] net: dsa: ksz: remove duplicate ksz_cfg and ksz_port_cfg
Date:   Wed, 27 Apr 2022 21:53:42 +0530
Message-ID: <20220427162343.18092-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220427162343.18092-1-arun.ramadoss@microchip.com>
References: <20220427162343.18092-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ksz8795.c and ksz9477.c has individual ksz_cfg and ksz_port_cfg
function, both are same. Hence moving it to ksz_common.c. And removed
the individual references.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 12 ------------
 drivers/net/dsa/microchip/ksz9477.c    | 12 ------------
 drivers/net/dsa/microchip/ksz_common.h | 13 +++++++++++++
 3 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index f91deea9368e..33453060fa71 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -211,18 +211,6 @@ static bool ksz_is_ksz88x3(struct ksz_device *dev)
 	return dev->chip_id == 0x8830;
 }
 
-static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
-{
-	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
-}
-
-static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
-			 bool set)
-{
-	regmap_update_bits(dev->regmap[0], PORT_CTRL_ADDR(port, offset),
-			   bits, set ? bits : 0);
-}
-
 static int ksz8_ind_write8(struct ksz_device *dev, u8 table, u16 addr, u8 data)
 {
 	struct ksz8 *ksz8 = dev->priv;
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 90ce789107eb..f762120ce3fd 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -159,18 +159,6 @@ static void ksz9477_get_stats64(struct dsa_switch *ds, int port,
 	spin_unlock(&mib->stats64_lock);
 }
 
-static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
-{
-	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
-}
-
-static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
-			 bool set)
-{
-	regmap_update_bits(dev->regmap[0], PORT_CTRL_ADDR(port, offset),
-			   bits, set ? bits : 0);
-}
-
 static void ksz9477_cfg32(struct ksz_device *dev, u32 addr, u32 bits, bool set)
 {
 	regmap_update_bits(dev->regmap[2], addr, bits, set ? bits : 0);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 4d978832c448..4f049e9d8952 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -246,6 +246,11 @@ static inline int ksz_write64(struct ksz_device *dev, u32 reg, u64 value)
 	return regmap_bulk_write(dev->regmap[2], reg, val, 2);
 }
 
+static inline void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
+{
+	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
+}
+
 static inline void ksz_pread8(struct ksz_device *dev, int port, int offset,
 			      u8 *data)
 {
@@ -282,6 +287,14 @@ static inline void ksz_pwrite32(struct ksz_device *dev, int port, int offset,
 	ksz_write32(dev, dev->dev_ops->get_port_addr(port, offset), data);
 }
 
+static inline void ksz_port_cfg(struct ksz_device *dev, int port, int offset,
+				u8 bits, bool set)
+{
+	regmap_update_bits(dev->regmap[0],
+			   dev->dev_ops->get_port_addr(port, offset),
+			   bits, set ? bits : 0);
+}
+
 static inline void ksz_regmap_lock(void *__mtx)
 {
 	struct mutex *mtx = __mtx;
-- 
2.33.0

