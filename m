Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B586457FC
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiLGKgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiLGKgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:36:04 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D952EF38
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:36:00 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221207103559epoutp02088defec81464e990cbb097f341421f4~ufHZXj-wx1838018380epoutp02H
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 10:35:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221207103559epoutp02088defec81464e990cbb097f341421f4~ufHZXj-wx1838018380epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1670409359;
        bh=7OMAQpbsGocH22zsW2ocEen3evfSBiClsKxTYz2A12U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YdlQaWyPIH6jxPxwxMFaoCMrdavIWvaYIaOixfCbEPLMXApaU2UlkHtZtLj+b0Tjc
         w1R6jK3buTAuhtIDiNI68OTMvIk6yveMkk8HZaFBRQd5Z9DrB6vFbxAMjzEhfJJirP
         ukN8gxXqV/m/cr3rmTY8WkTcVMxHll4DpbZCSmF0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221207103558epcas5p1865133bf17ba0a562dddeb48ff783fc0~ufHY4f4n23078230782epcas5p1f;
        Wed,  7 Dec 2022 10:35:58 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4NRtws2bRqz4x9Pt; Wed,  7 Dec
        2022 10:35:57 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        71.67.56352.D8C60936; Wed,  7 Dec 2022 19:35:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221207100650epcas5p408d280e0e2d2d6acfb5e252e37f504b2~uet8Pv3mn2820728207epcas5p4r;
        Wed,  7 Dec 2022 10:06:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221207100650epsmtrp2f29bd6eb515116b065d19f85931bb13b~uet8OjKJl0765407654epsmtrp2p;
        Wed,  7 Dec 2022 10:06:50 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-ec-63906c8d5519
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        66.FD.14392.AB560936; Wed,  7 Dec 2022 19:06:50 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221207100647epsmtip259d17f4ea7e4adaf034f52c4ad9543c2~uet5baeyq0610006100epsmtip2b;
        Wed,  7 Dec 2022 10:06:47 +0000 (GMT)
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
Subject: [Patch v4 1/2] can: m_can: Call the RAM init directly from
 m_can_chip_config
Date:   Wed,  7 Dec 2022 15:36:31 +0530
Message-Id: <20221207100632.96200-2-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207100632.96200-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WTf0xTVxTHuX1975VukDcQuTQTyMvMAhNoZ1svWtwMDh+BTMziiDOk1vLW
        IqVt+kPUTed0ztHJD2MJSAArwjLLBFagMAVmKoGFATLdOjfc1sKWIBpBYSLiYNCn23+f873n
        nPu9594rwMI8hEiQp7ewJr1KRxNCvvtaXHxCsa5MLR4YCkW+WjeBPK3tJKq+/gkfnesdxtFf
        fWMkKpnwY2jEXYIj17gXR865cgz5J7PRzcvVBKq83sNDzXV2PupzrEaPvr8HUF37LIn8010k
        qhrpxNGJ7l4Sjd5rwtGT89f4qOH3b/A3VzNtF3/hMQ6XlXlwYxQwLmcRwdz2dhFMa/1HTOk/
        Ymaq5yeCKWlzAmbxWA3JzLiis154L1+hZVW5rCmW1asNuXl6TQqd8Y4yVSmTiyUJkmS0gY7V
        qwrYFHprZlZCWp5u+ah07H6VzrosZanMZjpps8JksFrYWK3BbEmhWWOuzig1JppVBWarXpOo
        Zy0bJWLx67LlxD352pnHh4y+lw903RzlHwUjkTYQLICUFB5vbeLbgFAQRl0BsOMPJ84FDwFc
        nG8EXPAIwHrPIGkDgkDJ7Nx+Tu8G8ErN8LPyEzzYcruHv9KXoOLheJEjsLCKauTBthl/oBVG
        VfFg/fFfA1nhVDbsG7LjK8yn1sJTczfIFQ6hNsGBrz7lcQ5jYGPLVWyFgykFfPhbKcbpPgGc
        fLyBs7QVTp15i5PD4WR/G8mxCM7c7yY4VsPOxSKcYy10nO4CHL8Br/5YzV9pg1FxsPlyEiev
        geUDTQEHGBUKixf+fOYmBHbWPudX4MRMGc45EMHi4XBOZmDN0hmCm0kpgDXzI3gZiK76fwcH
        AE4QxRrNBRrWLDOu17OF/92Z2lDgAoHHHJ/RCcZ804kewBMAD4ACjF4VMvF1sTosJFd18BBr
        MihNVh1r9gDZ8vROY6IItWH5N+gtSok0WSyVy+XS5PVyCR0Z0mD/TB1GaVQWNp9ljazpeR1P
        ECw6yiPvbPv4cFDuPofPUPG+7KzBvyfVvvvtI5vKJvt+fpdYmJIPvLgkzP+yO7NVFeWdqlSY
        jCBnx4Ht/Rs/XHvyaU6WUO1lD1dWjkVs9wSVv6QR3zrV5Nw8HmPNjMKI9C+Ofcv4TZYFUjgq
        TWHu7ijhWztsU67mS5HR63wNaODvRiZi9oIxozCuVqlM25m21/3D2YriO3t36UdDhVmzReJ9
        3vnEJMW51KFx0cm7s3T/UnuQG3vVeD8+ylipjbQ96DqS/VpnYVyOzZ62xZM+/0F6Y83FNSPu
        0vGdHamyxEFFc8wTfHfvul3fDWYP1pEL/ltesqViYkuo5lJqzOdPpw+KIuw036xVSeIxk1n1
        L9x6QfNVBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsWy7bCSvO6u1AnJBt8Wc1o8mLeNzeLQ5q3s
        FnPOt7BYzD9yjtXi6bFH7BZ9Lx4yW1zY1sdqsenxNVaLVd+nMls8fBVucXnXHDaLGef3MVms
        XzSFxeLYAjGLb6ffMFos2vqF3eLhhz3sFrMu7GC1aN17hN3i9pt1rBa/Fh5msVh6byerg5jH
        lpU3mTwWbCr1+HjpNqPHplWdbB53ru1h89i8pN6j/6+Bx/t9V9k8+rasYvT41zSX3ePzJrkA
        7igum5TUnMyy1CJ9uwSujM8/qgoeyFTsuXybpYHxgngXIweHhICJxJfvZV2MXBxCArsZJWZM
        /czYxcgJFJeSmHLmJQuELSyx8t9zdoiiZiaJ82tXgRWxCWhJPO5cwAKSEBHYzSTxtnsuWBWz
        wCImiZdXeplBVggLhEpcu2AM0sAioCrR8/0SO4jNK2AtcWpNGxPEBnmJ1RsOMIPYnAI2Ep/u
        9oPZQkA1/349Y5zAyLeAkWEVo2RqQXFuem6xYYFhXmq5XnFibnFpXrpecn7uJkZw9Ghp7mDc
        vuqD3iFGJg7GQ4wSHMxKIrwvNvYmC/GmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEk
        NTs1tSC1CCbLxMEp1cDUwc3vq/lEYPWLrydmnbjAkLJ21ZJr1Tf7t0QIx7+QFuAsLFJT8fE9
        qvzy9Yo/3XcarbsqfugVz+lpe5mvxcnk1Ktr8equ+5flv8pLdwqISQevuKduXpEtf36zsqLx
        o/nsCabvl5/Z2LKOwbTrclFnsPi+u1Nivouty58f0d6/cNbTl3Pluew1r4hpavYzTn6lwa3x
        9emW5V8OX97DdnjFwsrnl2W1tRdlcMyOZF0gds5e0+6mUlHCzrRiRodFSi6zqicsD/cyFVK5
        +MxxxfEfytuf+ntviF6Uzbh27xvNn14Pv29qUuX5eja828psxrYFk4IfPjh5fHknu7t1ho/8
        x1QeNdfu5fJ8jF5eQSuUWIozEg21mIuKEwHWtqozDQMAAA==
X-CMS-MailID: 20221207100650epcas5p408d280e0e2d2d6acfb5e252e37f504b2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221207100650epcas5p408d280e0e2d2d6acfb5e252e37f504b2
References: <20221207100632.96200-1-vivek.2311@samsung.com>
        <CGME20221207100650epcas5p408d280e0e2d2d6acfb5e252e37f504b2@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we try to access the mcan message ram addresses during the probe,
hclk is gated by any other drivers or disabled, because of that probe
gets failed.

Move the mram init functionality to mcan chip config called by
m_can_start from mcan open function, by that time clocks are
enabled.

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
---
 drivers/net/can/m_can/m_can.c          | 32 +++++++++++++++++++++-----
 drivers/net/can/m_can/m_can_platform.c |  4 ----
 drivers/net/can/m_can/tcan4x5x-core.c  |  5 ----
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index a776cab1a5a4..2261d01324f8 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1233,10 +1233,17 @@ static int m_can_set_bittiming(struct net_device *dev)
  * - setup bittiming
  * - configure timestamp generation
  */
-static void m_can_chip_config(struct net_device *dev)
+static int m_can_chip_config(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	u32 cccr, test;
+	int err;
+
+	err = m_can_init_ram(cdev);
+	if (err) {
+		dev_err(cdev->dev, "Message RAM configuration failed\n");
+		return err;
+	}
 
 	m_can_config_endisable(cdev, true);
 
@@ -1360,18 +1367,25 @@ static void m_can_chip_config(struct net_device *dev)
 
 	if (cdev->ops->init)
 		cdev->ops->init(cdev);
+
+	return 0;
 }
 
-static void m_can_start(struct net_device *dev)
+static int m_can_start(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
+	int ret;
 
 	/* basic m_can configuration */
-	m_can_chip_config(dev);
+	ret = m_can_chip_config(dev);
+	if (ret)
+		return ret;
 
 	cdev->can.state = CAN_STATE_ERROR_ACTIVE;
 
 	m_can_enable_all_interrupts(cdev);
+
+	return 0;
 }
 
 static int m_can_set_mode(struct net_device *dev, enum can_mode mode)
@@ -1799,7 +1813,9 @@ static int m_can_open(struct net_device *dev)
 	}
 
 	/* start the m_can controller */
-	m_can_start(dev);
+	err = m_can_start(dev);
+	if (err)
+		goto exit_irq_fail;
 
 	if (!cdev->is_peripheral)
 		napi_enable(&cdev->napi);
@@ -2058,9 +2074,13 @@ int m_can_class_resume(struct device *dev)
 		ret = m_can_clk_start(cdev);
 		if (ret)
 			return ret;
+		ret  = m_can_start(ndev);
+		if (ret) {
+			m_can_clk_stop(cdev);
+
+			return ret;
+		}
 
-		m_can_init_ram(cdev);
-		m_can_start(ndev);
 		netif_device_attach(ndev);
 		netif_start_queue(ndev);
 	}
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index b5a5bedb3116..9c1dcf838006 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -140,10 +140,6 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, mcan_class);
 
-	ret = m_can_init_ram(mcan_class);
-	if (ret)
-		goto probe_fail;
-
 	pm_runtime_enable(mcan_class->dev);
 	ret = m_can_class_register(mcan_class);
 	if (ret)
diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
index 41645a24384c..a3aeb83de152 100644
--- a/drivers/net/can/m_can/tcan4x5x-core.c
+++ b/drivers/net/can/m_can/tcan4x5x-core.c
@@ -234,11 +234,6 @@ static int tcan4x5x_init(struct m_can_classdev *cdev)
 	if (ret)
 		return ret;
 
-	/* Zero out the MCAN buffers */
-	ret = m_can_init_ram(cdev);
-	if (ret)
-		return ret;
-
 	ret = regmap_update_bits(tcan4x5x->regmap, TCAN4X5X_CONFIG,
 				 TCAN4X5X_MODE_SEL_MASK, TCAN4X5X_MODE_NORMAL);
 	if (ret)
-- 
2.17.1

