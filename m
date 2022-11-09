Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5108622940
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 11:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiKIKyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 05:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiKIKxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 05:53:52 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3562029C8A
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:53:11 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221109105310epoutp04f06f1a7e99d7613ccb01d5216c8ba527~l5SZs7oEB0279502795epoutp04F
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:53:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221109105310epoutp04f06f1a7e99d7613ccb01d5216c8ba527~l5SZs7oEB0279502795epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667991190;
        bh=Yg7bj+1oR0s3uoN78lwOUQr34dho0dl7WMgCJv7J+58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=diHUslnDY6PbRV93sXByOSLVms/bX/N2YC4CUOLY3wXUWU2i+zfQ/0wkByx2faMhD
         qs8mEfi7XVP/VrRhnzU/m+Fci+hFFgSEoj5GRMx+SnaogFImJQG3jH6jE8ZdvipU4u
         WuzeCCufGgAhHwDaal+gtdmlnH65Gnlr/a+rYYyc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221109105309epcas5p4859d3eb3c677bf03883da2f4c8c20a20~l5SYo2V221241612416epcas5p4Y;
        Wed,  9 Nov 2022 10:53:09 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4N6hdZ6HF7z4x9Pr; Wed,  9 Nov
        2022 10:53:06 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C8.03.56352.2968B636; Wed,  9 Nov 2022 19:53:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221109100302epcas5p276282a3a320649661939dcb893765fbf~l4mov7Trg0099800998epcas5p22;
        Wed,  9 Nov 2022 10:03:02 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221109100302epsmtrp267d47c8412f496527ce804231bb00928~l4motTZSR1459514595epsmtrp2t;
        Wed,  9 Nov 2022 10:03:02 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-56-636b8692b85d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CC.E0.14392.6DA7B636; Wed,  9 Nov 2022 19:03:02 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221109100259epsmtip2eca411ad2f4291996797af9a74a2b4f9~l4mlzakIl1918919189epsmtip2C;
        Wed,  9 Nov 2022 10:02:59 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, krzysztof.kozlowski+dt@linaro.org,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com, linux-fsd@tesla.com, robh+dt@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com,
        Vivek Yadav <vivek.2311@samsung.com>
Subject: [PATCH v2 5/6] can: m_can: Add ECC functionality for message RAM
Date:   Wed,  9 Nov 2022 15:39:27 +0530
Message-Id: <20221109100928.109478-6-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221109100928.109478-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0VTf1CTdRj3u/fduwFRb4D4hc6xe40C7oBNYH0xpl6ivYUWF0R32TXXeA92
        G9tuG6LVlDbF4BKh4EScgKAlg4Am7PgpNsyK7oA07YDZOTRAREFH6FFgjBfrv8/zPJ/nx+d5
        vl8+FtBHhPKVGiOj18jVFOGLO/oiI6K/LFApRI3VInSzykEg5/k2HrIOHsJR9aUBLvrz8hgP
        FU+6MTTkKOYi+63rXGR7VI4h99R76GqnlUAVgxc4qLm2DEeXa4LR/C/TANW2zfGQe7abhyqH
        2rnocM8lHhqdbuKihdN9ODr7Rwd3azDdWj/MoWvsufSDK6OAttsKCdp1vZugz585SB9bFNEz
        F64RdHGrDdBL5lM82mMXpPq9r0rKZuSZjF7IaBTaTKUmS0qlpMm2yRIkInG0OBG9Qgk18hxG
        SiXvTI3eoVQvS6WEe+Xq3GVXqtxgoGI3J+m1uUZGmK01GKUUo8tU6+J1MQZ5jiFXkxWjYYyb
        xCLRxoRl4h5Vdkd/E6Fr2byv4Csnng9+2FgE+HxIxkNbnbQI+PIDyC4Af574HGONhwB+01hN
        sMY8gJ85rZwi4LOS4bjzD4cN9AA4V7awyjrMgb/Olq+wCDIK3iqswb2BILKBA1s9buA1MLKS
        A89YRnAvK5B8A7Z+30l4MU6Gwwb3OObF/mQSXKo+yWP7hcGGlouYd1ofUgrdp0XeOpB08eG9
        48dwVkUytPUmsvRAOPVj62pqKPTc7yFYrIDtS4VcFmfDmtJuwOIt8OJv1pUyGBkJmztjWfd6
        WN7ftKIFI5+FR/++vareH7ZXPcUvwklPCZedIBQeHQhk3TS03JjgsjspAdB81c0rAYLK/zvU
        AGADIYzOkJPFGBJ0cRom77+jKbQ5drDymqNS2sHYzdkYJ+DwgRNAPkYF+ftFqBQB/pny/R8z
        eq1Mn6tmDE6QsLy9Uix0rUK7/B00Rpk4PlEUL5FI4hPjJGJqnX9dRZQigMySGxkVw+gY/dM8
        Dt8nNJ9jFfg9o6x/LTGiV7LrnqVY4VdueuHEWvfAnjVf80xvespMxuE08ifd7+G+Yk9WNMh/
        vlb5XXLjjeMhT14fj0wJ4Nm/6KKbD7mYiZmhR7Yr1odr8P0w+EhLhebxbcXQp127hx9/WziR
        zj9XZY693/WcxTGS/4EzxfWR65RgXeC5jLnqawPvHhD0vyOd7nuV6t2wXsedGhF3HLEd9FVP
        p6cnMXszxqS7heatd1UpL+Xlvf2yURxSYimltn/iW+CMCLu7JRC48F0LD1RR5rK0v8bVk4Mz
        pn0yvGhx8cOlOOXJ5v4nbzU19J8NC28bNW2a3JG2bXJ7/azAVDcfFLPzDhlzICSDwg3ZcnEU
        pjfI/wWCSvVIVgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWy7bCSvO61quxkgxsPlCwezNvGZnFo81Z2
        iznnW1gs5h85x2rx9Ngjdou+Fw+ZLS5s62O12PT4GqvFqu9TmS0evgq3uLxrDpvFjPP7mCzW
        L5rCYnFsgZjFt9NvGC0Wbf3CbvHwwx52i1kXdrBatO49wm5x+806VotfCw+zWCy9t5PVQcxj
        y8qbTB4LNpV6fLx0m9Fj06pONo871/aweWxeUu/R/9fA4/2+q2wefVtWMXr8a5rL7vF5k1wA
        dxSXTUpqTmZZapG+XQJXxs5T69gKNthVtE0+xNLAeNSoi5GTQ0LARGLbyz9MXYxcHEICuxkl
        ZvWtZ4dISElMOfOSBcIWllj57zk7RFEzk8TEF1vYQBJsAloSjzsXsIAkRAR2M0m87Z4LVsUs
        sIhJ4uWVXmaQKmEBT4ktB3eBdbAIqEqsfvgMLM4rYCPxb/5sqHXyEqs3HACKc3BwCthKPFxo
        ABIWAip5fnsR4wRGvgWMDKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYIjSEtzB+P2
        VR/0DjEycTAeYpTgYFYS4eXWyE4W4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6Yklq
        dmpqQWoRTJaJg1OqgSnmbnHNzF0VnC37OzOb8teGz7/Rxr/j0xcOnfMZ4j9OLjISE7HnPfV4
        4qttqzYoO265Yf/dqrjoiUTJu3gPqb9KVgtObOivqPr0Ufn22j32577naLm2pXYZNRc37U6d
        U7WAT1ckx+uYDvNnRfEwbXGb0uU1LDOiEjqcJ08Lfh9y5ff7fY9klnZUrlm2Xz3K3TtnwYEL
        fw9VSgoln9t6bJFZc5h+5qbJWvmrvk5avi3YnG1fYr3S7bvV1YF5Jfe1yg5dKdvydmrp1r9r
        RSd6tezpux+jJNnwbi2Pat3MgsMcm7btmX5MXGzXIsWkhz6CTsfjVHT7JDm6BQxn7Az51qNS
        sZxN6KmUjJKrXn/3aSWW4oxEQy3mouJEAKVQEtwPAwAA
X-CMS-MailID: 20221109100302epcas5p276282a3a320649661939dcb893765fbf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221109100302epcas5p276282a3a320649661939dcb893765fbf
References: <20221109100928.109478-1-vivek.2311@samsung.com>
        <CGME20221109100302epcas5p276282a3a320649661939dcb893765fbf@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever MCAN Buffers and FIFOs are stored on message ram, there are
inherent risks of corruption known as single-bit errors.

Enable error correction code (ECC) data integrity check for Message RAM
to create valid ECC checksums.

ECC uses a respective number of bits, which are added to each word as a
parity and that will raise the error signal on the corruption in the
Interrupt Register(IR).

This indicates either bit error detected and Corrected(BEC) or No bit
error detected when reading from Message RAM.

Signed-off-by: Chandrasekar R <rcsekar@samsung.com>
Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
---
 drivers/net/can/m_can/m_can.c          | 48 +++++++++++++++-
 drivers/net/can/m_can/m_can.h          | 17 ++++++
 drivers/net/can/m_can/m_can_platform.c | 76 ++++++++++++++++++++++++--
 3 files changed, 135 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index a776cab1a5a4..ddff615ccad4 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -307,6 +307,14 @@ enum m_can_reg {
 #define TX_EVENT_MM_MASK	GENMASK(31, 24)
 #define TX_EVENT_TXTS_MASK	GENMASK(15, 0)
 
+/* ECC Config Bits */
+#define MCAN_ECC_CFG_VALID    BIT(5)
+#define MCAN_ECC_ENABLE       BIT(3)
+#define MCAN_ECC_INIT_ENABLE  BIT(1)
+#define MCAN_ECC_INIT_DONE    BIT(0)
+#define MCAN_ECC_REG_MASK     GENMASK(5, 0)
+#define MCAN_ECC_INIT_TIMEOUT 100
+
 /* The ID and DLC registers are adjacent in M_CAN FIFO memory,
  * and we can save a (potentially slow) bus round trip by combining
  * reads and writes to them.
@@ -1516,9 +1524,9 @@ static int m_can_dev_setup(struct m_can_classdev *cdev)
 	}
 
 	if (cdev->ops->init)
-		cdev->ops->init(cdev);
+		err = cdev->ops->init(cdev);
 
-	return 0;
+	return err;
 }
 
 static void m_can_stop(struct net_device *dev)
@@ -1535,6 +1543,39 @@ static void m_can_stop(struct net_device *dev)
 	cdev->can.state = CAN_STATE_STOPPED;
 }
 
+int m_can_config_mram_ecc_check(struct m_can_classdev *cdev, bool enable)
+{
+	struct  m_can_ecc_regmap *ecc_cfg = &cdev->ecc_cfg_sys;
+	int val, ret;
+
+	val = FIELD_PREP(MCAN_ECC_REG_MASK, MCAN_ECC_ENABLE |
+			 MCAN_ECC_CFG_VALID | MCAN_ECC_INIT_ENABLE);
+	regmap_clear_bits(ecc_cfg->syscon, ecc_cfg->reg, val);
+
+	if (enable) {
+		val = FIELD_PREP(MCAN_ECC_REG_MASK, MCAN_ECC_ENABLE |
+				 MCAN_ECC_INIT_ENABLE);
+		regmap_set_bits(ecc_cfg->syscon, ecc_cfg->reg, val);
+	}
+
+	/* after enable or disable, valid flag need to be set*/
+	val = FIELD_PREP(MCAN_ECC_REG_MASK, MCAN_ECC_CFG_VALID);
+	regmap_set_bits(ecc_cfg->syscon, ecc_cfg->reg, val);
+
+	if (enable) {
+		/* Poll for completion */
+		ret = regmap_read_poll_timeout(ecc_cfg->syscon, ecc_cfg->reg,
+					       val,
+					       (val & MCAN_ECC_INIT_DONE), 5,
+					       MCAN_ECC_INIT_TIMEOUT);
+
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int m_can_close(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
@@ -1557,6 +1598,9 @@ static int m_can_close(struct net_device *dev)
 	if (cdev->is_peripheral)
 		can_rx_offload_disable(&cdev->offload);
 
+	if (cdev->ops->deinit)
+		cdev->ops->deinit(cdev);
+
 	close_candev(dev);
 
 	phy_power_off(cdev->transceiver);
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 401410022823..9821b135a2be 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -19,6 +19,7 @@
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/of.h>
@@ -26,6 +27,7 @@
 #include <linux/phy/phy.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/pm_runtime.h>
+#include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
@@ -52,12 +54,23 @@ enum m_can_mram_cfg {
 	MRAM_CFG_NUM,
 };
 
+enum m_can_ecc_cfg {
+	ECC_DISABLE = 0,
+	ECC_ENABLE,
+};
+
 /* address offset and element number for each FIFO/Buffer in the Message RAM */
 struct mram_cfg {
 	u16 off;
 	u8  num;
 };
 
+struct m_can_ecc_regmap {
+	struct regmap *syscon;  /* for mram ecc ctrl. reg. access */
+	unsigned int reg;       /* register index within syscon */
+	u8 ecc_cfg_flag;
+};
+
 struct m_can_classdev;
 struct m_can_ops {
 	/* Device specific call backs */
@@ -68,6 +81,7 @@ struct m_can_ops {
 	int (*write_fifo)(struct m_can_classdev *cdev, int addr_offset,
 			  const void *val, size_t val_count);
 	int (*init)(struct m_can_classdev *cdev);
+	int (*deinit)(struct m_can_classdev *cdev);
 };
 
 struct m_can_classdev {
@@ -92,7 +106,9 @@ struct m_can_classdev {
 	int pm_clock_support;
 	int is_peripheral;
 
+	struct m_can_ecc_regmap ecc_cfg_sys; /* ecc config via syscon regmap */
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
+	u8 mram_cfg_flag;
 };
 
 struct m_can_classdev *m_can_class_allocate_dev(struct device *dev, int sizeof_priv);
@@ -104,4 +120,5 @@ int m_can_init_ram(struct m_can_classdev *priv);
 
 int m_can_class_suspend(struct device *dev);
 int m_can_class_resume(struct device *dev);
+int m_can_config_mram_ecc_check(struct m_can_classdev *cdev, bool enable);
 #endif	/* _CAN_M_H_ */
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index b5a5bedb3116..1281214a3f43 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -67,11 +67,83 @@ static int iomap_write_fifo(struct m_can_classdev *cdev, int offset,
 	return 0;
 }
 
+static int m_can_plat_init(struct m_can_classdev *cdev)
+{
+	struct  m_can_ecc_regmap *ecc_cfg = &cdev->ecc_cfg_sys;
+	struct device_node *np = cdev->dev->of_node;
+	int ret = 0;
+
+	if (cdev->mram_cfg_flag != ECC_ENABLE) {
+		/* Initialize mcan message ram */
+		ret = m_can_init_ram(cdev);
+
+		if (ret)
+			return ret;
+
+		cdev->mram_cfg_flag = ECC_ENABLE;
+	}
+
+	if (ecc_cfg->ecc_cfg_flag != ECC_ENABLE) {
+		/* configure error code check for mram */
+		if (!ecc_cfg->syscon) {
+			ecc_cfg->syscon =
+			syscon_regmap_lookup_by_phandle_args(np,
+							     "tesla,mram-ecc-cfg"
+							     , 1,
+							     &ecc_cfg->reg);
+		}
+
+		if (IS_ERR(ecc_cfg->syscon)) {
+			dev_err(cdev->dev, "couldn't get the syscon reg!\n");
+			goto ecc_failed;
+		}
+
+		if (!ecc_cfg->reg) {
+			dev_err(cdev->dev,
+				"couldn't get the ecc init reg. offset!\n");
+			goto ecc_failed;
+		}
+
+		/* Enable error code check functionality for message ram */
+		if (m_can_config_mram_ecc_check(cdev, ECC_ENABLE))
+			goto ecc_failed;
+
+		ecc_cfg->ecc_cfg_flag = ECC_ENABLE;
+	}
+
+	return 0;
+
+ecc_failed:
+	dev_err(cdev->dev, "Message ram ecc enable config failed\n");
+
+	return 0;
+}
+
+static int m_can_plat_deinit(struct m_can_classdev *cdev)
+{
+	struct  m_can_ecc_regmap *ecc_cfg = &cdev->ecc_cfg_sys;
+
+	if (ecc_cfg->ecc_cfg_flag == ECC_ENABLE) {
+		/* Disable error code check functionality for message ram */
+		if (m_can_config_mram_ecc_check(cdev, ECC_DISABLE)) {
+			dev_err(cdev->dev,
+				"Message ram ecc disable config failed\n");
+			return 0;
+		}
+
+		ecc_cfg->ecc_cfg_flag = ECC_DISABLE;
+	}
+
+	return 0;
+}
+
 static struct m_can_ops m_can_plat_ops = {
 	.read_reg = iomap_read_reg,
 	.write_reg = iomap_write_reg,
 	.write_fifo = iomap_write_fifo,
 	.read_fifo = iomap_read_fifo,
+	.init = m_can_plat_init,
+	.deinit = m_can_plat_deinit,
 };
 
 static int m_can_plat_probe(struct platform_device *pdev)
@@ -140,10 +212,6 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, mcan_class);
 
-	ret = m_can_init_ram(mcan_class);
-	if (ret)
-		goto probe_fail;
-
 	pm_runtime_enable(mcan_class->dev);
 	ret = m_can_class_register(mcan_class);
 	if (ret)
-- 
2.17.1

