Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D91A5B769
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 11:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbfGAJDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 05:03:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33627 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbfGAJDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 05:03:46 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so12920543wru.0
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 02:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=T0v6YBVYSfKUUzoiqC7GLp6d3WCumrU3XBQLQP6M9qY=;
        b=P0XOtW/75OdA6oV7QvNBw8ChtklYUUsyNOhGetRq2bQpzIikXk8KQ3MO6UmftfFnZ7
         FPrsRJOEjH5BfCGbb8tKgOTLhvJUOdBRkskYiJcsRrRWU2A9U2hAEvB9zUMZmGiiYAAD
         lIh/D+7rLkS2kV+AGk8O/zijFeqeWFM19GQwVBctwRhT1chk9Sz6gP2PN5xTkunE9DMd
         ywWlUhpwWujYPS0SMO5ULmcPfwj9j0pSUg7J5JVSy5oHYZydPTXOIJ9QMbmLiWsoPkO6
         Fr+H8tyZKqvbs5TUAbHsUghFVkrJR9ddZagVQJOasjRWbCBvJcW1ur3TbLsnoVXoyaFC
         CMdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=T0v6YBVYSfKUUzoiqC7GLp6d3WCumrU3XBQLQP6M9qY=;
        b=feLwOGbou7CWrkZxn2MsAXiAddfE2EwohyqkhsV67B4QLAt/7UFQRgFoKFD1IMchbI
         HMO49yM3BGfvpx9v36RVcMJbKcjnrAiMkfgz9IFjxmFWDelw0dq9hYrcqi0cCZmsr0Cx
         bKxzNDBXd6VxuP0gHKa2CdQTGyd96F8DNjGQDs+wCTw5dEbrBgtWtCS2mbeHu51mMTT7
         xbPrz0xzDuj+FwVjuML3lyzxYcdWDUlzb/Eyl0GszoFT/asH2zaexBOwggkD1XjnHrqb
         IfGzWNrOGQGvleF8FVpK/mtGVuXQ+Q0pSf4pnZHT2OTWYTfvpLFyhsOTpMXTSozZ+90E
         l5Fw==
X-Gm-Message-State: APjAAAXLV2SlPn4OqiSmgPwmpMLdo/5L6bi09l7ccsvdznOw7Q8RkRFq
        lG7cX6UiNY76dw==
X-Google-Smtp-Source: APXvYqzpuZi4RdqCT0J8x96wEhWncZReDqkO/p0OXXZhowYHtG9Sz4oRC85JOKSdNE3WQ4/A4t1FEw==
X-Received: by 2002:adf:f581:: with SMTP id f1mr18745336wro.179.1561971823968;
        Mon, 01 Jul 2019 02:03:43 -0700 (PDT)
Received: from x-Inspiron-15-5568.fritz.box (ip-95-223-112-76.hsi16.unitymediagroup.de. [95.223.112.76])
        by smtp.gmail.com with ESMTPSA id h11sm9593521wrx.93.2019.07.01.02.03.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 02:03:43 -0700 (PDT)
From:   Sergej Benilov <sergej.benilov@googlemail.com>
To:     venza@brownhat.org, netdev@vger.kernel.org
Cc:     Sergej Benilov <sergej.benilov@googlemail.com>
Subject: [PATCH] sis900: add ethtool tests (link, eeprom)
Date:   Mon,  1 Jul 2019 11:03:33 +0200
Message-Id: <20190701090333.25277-1-sergej.benilov@googlemail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for ethtool: link test, EEPROM read test.
Correct a few typos, too.

Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>
---
 drivers/net/ethernet/sis/sis900.c | 78 +++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index 9b036c857b1d..a781bce23ec8 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -262,7 +262,7 @@ static int sis900_get_mac_addr(struct pci_dev *pci_dev,
 	/* check to see if we have sane EEPROM */
 	signature = (u16) read_eeprom(ioaddr, EEPROMSignature);
 	if (signature == 0xffff || signature == 0x0000) {
-		printk (KERN_WARNING "%s: Error EERPOM read %x\n",
+		printk (KERN_WARNING "%s: Error EEPROM read %x\n",
 			pci_name(pci_dev), signature);
 		return 0;
 	}
@@ -359,9 +359,9 @@ static int sis635_get_mac_addr(struct pci_dev *pci_dev,
  *
  *	SiS962 or SiS963 model, use EEPROM to store MAC address. And EEPROM
  *	is shared by
- *	LAN and 1394. When access EEPROM, send EEREQ signal to hardware first
- *	and wait for EEGNT. If EEGNT is ON, EEPROM is permitted to be access
- *	by LAN, otherwise is not. After MAC address is read from EEPROM, send
+ *	LAN and 1394. When accessing EEPROM, send EEREQ signal to hardware first
+ *	and wait for EEGNT. If EEGNT is ON, EEPROM is permitted to be accessed
+ *	by LAN, otherwise it is not. After MAC address is read from EEPROM, send
  *	EEDONE signal to refuse EEPROM access by LAN.
  *	The EEPROM map of SiS962 or SiS963 is different to SiS900.
  *	The signature field in SiS962 or SiS963 spec is meaningless.
@@ -2122,6 +2122,73 @@ static void sis900_get_wol(struct net_device *net_dev, struct ethtool_wolinfo *w
 	wol->supported = (WAKE_PHY | WAKE_MAGIC);
 }
 
+static const char sis900_gstrings_test[][ETH_GSTRING_LEN] = {
+	"Link test     (on/offline)",
+	"EEPROM read test   (on/offline)",
+};
+#define SIS900_TEST_LEN	ARRAY_SIZE(sis900_gstrings_test)
+
+static int sis900_eeprom_readtest(struct net_device *net_dev)
+{
+	struct sis900_private *sis_priv = netdev_priv(net_dev);
+	void __iomem *ioaddr = sis_priv->ioaddr;
+	int wait, ret = -EAGAIN;
+	u16 signature;
+
+	if (sis_priv->chipset_rev == SIS96x_900_REV) {
+	sw32(mear, EEREQ);
+	for (wait = 0; wait < 2000; wait++) {
+		if (sr32(mear) & EEGNT) {
+		 signature = (u16) read_eeprom(ioaddr, EEPROMSignature);
+    	 ret = 0;
+		 break;
+		}
+		udelay(1);
+	  }		
+	sw32(mear, EEDONE);
+	}
+	else {		
+		signature = (u16) read_eeprom(ioaddr, EEPROMSignature);
+		if (signature != 0xffff && signature != 0x0000)
+			ret = 0;
+	}
+	return ret;
+}
+
+static void sis900_diag_test(struct net_device *netdev,
+	struct ethtool_test *test, u64 *data)
+{
+	struct sis900_private *nic = netdev_priv(netdev);
+	int i;
+
+	memset(data, 0, SIS900_TEST_LEN * sizeof(u64));
+	data[0] = !mii_link_ok(&nic->mii_info);
+    data[1] = sis900_eeprom_readtest(netdev);
+	for (i = 0; i < SIS900_TEST_LEN; i++)
+		test->flags |= data[i] ? ETH_TEST_FL_FAILED : 0;
+
+	msleep_interruptible(4 * 1000);
+}
+
+static int sis900_get_sset_count(struct net_device *netdev, int sset)
+{
+	switch (sset) {
+	case ETH_SS_TEST:
+		return SIS900_TEST_LEN;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void sis900_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
+{
+	switch (stringset) {
+	case ETH_SS_TEST:
+		memcpy(data, *sis900_gstrings_test, sizeof(sis900_gstrings_test));
+		break;
+	}
+}
+
 static const struct ethtool_ops sis900_ethtool_ops = {
 	.get_drvinfo 	= sis900_get_drvinfo,
 	.get_msglevel	= sis900_get_msglevel,
@@ -2132,6 +2199,9 @@ static const struct ethtool_ops sis900_ethtool_ops = {
 	.set_wol	= sis900_set_wol,
 	.get_link_ksettings = sis900_get_link_ksettings,
 	.set_link_ksettings = sis900_set_link_ksettings,
+	.self_test		= sis900_diag_test,
+	.get_strings	= sis900_get_strings,
+	.get_sset_count		= sis900_get_sset_count,
 };
 
 /**
-- 
2.17.1

