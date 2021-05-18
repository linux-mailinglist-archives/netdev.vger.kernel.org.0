Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B52B387A28
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 15:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhERNlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 09:41:24 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:14983 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbhERNlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 09:41:20 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1621345193; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=fgKrz9Dgczf75yfRRV4Y24tzhK4o2lmnbrqVwY+MMRHge5JXXgg/Av9e4/mrR6jG2J
    frl3H7/1ROZSDLan5tywtrMcN2G0wpcjClssdrcY6tgch/S6PCmVqO+5o8scWY13Ry7z
    TIjPCbF9hRSloHtJ+V4aIO3xmmuYKhUiAOM0TmiYRA7uPI49kiLY/iRPBIt6ZS3Opi6k
    3elf11TxpSYwO68zSyihUkpa1DCk4/5y3amDhXNBtJEd1w/PyhrtTN+Mc64VCHsULAej
    /oplE6nsTDeUS7PorTQdPNpWDsw8fzvM83v0kKTbhUf03cTrxmefZ3Pu2F63VfDJoIPZ
    PTtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1621345193;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=MQJ5ouXH2K6ttZ1pDkGFt0ZQFZ9Gimr8gSK75Qqkh6I=;
    b=HEjCW78qtsviWGkwMwYLiaWxD0ZuwjyB4bVJd/ygXei+1OGugUo+MC3vyY125Yruk9
    PXt1wi5zwTpEruN4xhUgTdt0Lkv7+Ef3OfXc9hwPzqQP/r26RRznegI/bJA5MEnceCph
    FAnpdHdL601WcjWbdMREIMNTxuUdkZ8vA8jCwJnv0QwC1RWyJHvqpPu7KTM48oD6OgUg
    HJNsGuNlDcERtIwwIIx3Xg07BQnXvfB6hZ4HgYrGvJ5VwrC9Zw2PIQBRnOolarrQeWju
    ZwMQjbCyYFKR4TXqUJc8K+7cJ0Yw9VGNnQlmfup8FGr3SbHjMnaaM0uZuzYGEXaVEow+
    TQ+Q==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1621345193;
    s=strato-dkim-0002; d=gerhold.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=MQJ5ouXH2K6ttZ1pDkGFt0ZQFZ9Gimr8gSK75Qqkh6I=;
    b=NITTKo7G6q6AsyGCp8GwlB4e4xmjRZDbM8y2XRyi3ptw/jY2HPFjsQSvYxHNR6sit9
    O2fHUdZEEFEpSEP/gQZEyqu4M9dcScY/F9WIYSxd79NOLeC3g5Gbw/p2Umc9qvGpzjr8
    R/JwHMl+/yX5Pm9eXnKUrRLtkv3BCmp7Zk8HHz0z7xiq2LLm6Hc8SxmgAv7pHglO/S1Q
    CfSA1cPWJgnSEs4TCV0JNsv/vc+FCMIEZOd2vnkSXNNan1xOp98QpQF8Rg2OL6dcUnyO
    aall1bKIp4zDgcG8+7S/MCWag/eXPw5kl3Srqgtw54YYtDMMV1GAMD4webrD8qeIJCiN
    ol0g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXS7IYBkLahKxB4W6NZHoD"
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.26.1 DYNA|AUTH)
    with ESMTPSA id f01503x4IDdq2oK
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 18 May 2021 15:39:52 +0200 (CEST)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Krzysztof Opasiak <k.opasiak@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        ~postmarketos/upstreaming@lists.sr.ht,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH 2/2] nfc: s3fwrn5: i2c: Enable optional clock from device tree
Date:   Tue, 18 May 2021 15:39:35 +0200
Message-Id: <20210518133935.571298-2-stephan@gerhold.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518133935.571298-1-stephan@gerhold.net>
References: <20210518133935.571298-1-stephan@gerhold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s3fwrn5 has a NFC_CLK_REQ output GPIO, which is asserted whenever
the clock is needed for the current operation. This GPIO can be either
connected directly to the clock provider, or must be monitored by
this driver.

As an example for the first case, on many Qualcomm devices the
NFC clock is provided by the main PMIC. The clock can be either
permanently enabled (clocks = <&rpmcc RPM_SMD_BB_CLK2>) or enabled
only when requested through a special input pin on the PMIC
(clocks = <&rpmcc RPM_SMD_BB_CLK2_PIN>).

On the Samsung Galaxy A3/A5 (2015, Qualcomm MSM8916) this mechanism
is used with S3FWRN5's NFC_CLK_REQ output GPIO to enable the clock
only when necessary. However, to make that work the s3fwrn5 driver
must keep the RPM_SMD_BB_CLK2_PIN clock enabled.

This commit adds support for this by requesting an optional clock
and keeping it permanently enabled. Note that the actual (physical)
clock won't be permanently enabled since this will depend on the
output of NFC_CLK_REQ from S3FWRN5.

In the future (when needed by some other device) this could be
extended to work for the second case (monitoring the NFC_CLK_REQ
GPIO and enabling the clock from the kernel when needed).

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
 drivers/nfc/s3fwrn5/i2c.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index 897394167522..d8910f97ee4a 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -6,6 +6,7 @@
  * Robert Baldyga <r.baldyga@samsung.com>
  */
 
+#include <linux/clk.h>
 #include <linux/i2c.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
@@ -22,6 +23,7 @@
 struct s3fwrn5_i2c_phy {
 	struct phy_common common;
 	struct i2c_client *i2c_dev;
+	struct clk *clk;
 
 	unsigned int irq_skip:1;
 };
@@ -207,17 +209,42 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
+	phy->clk = devm_clk_get_optional(&client->dev, NULL);
+	if (IS_ERR(phy->clk))
+		return dev_err_probe(&client->dev, PTR_ERR(phy->clk),
+				     "failed to get clock\n");
+
+	/*
+	 * s3fwrn5 has a NFC_CLK_REQ output GPIO, which is asserted whenever
+	 * the clock is needed for the current operation. This GPIO can be either
+	 * connected directly to the clock provider, or must be monitored by
+	 * this driver. For now only the first case is handled here.
+	 * We keep the clock "on" permanently so the clock provider will begin
+	 * looking at NFC_CLK_REQ and enables the clock when necessary.
+	 */
+	ret = clk_prepare_enable(phy->clk);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed to enable clock: %d\n", ret);
+		return ret;
+	}
+
 	ret = s3fwrn5_probe(&phy->common.ndev, phy, &phy->i2c_dev->dev,
 			    &i2c_phy_ops);
 	if (ret < 0)
-		return ret;
+		goto disable_clk;
 
 	ret = devm_request_threaded_irq(&client->dev, phy->i2c_dev->irq, NULL,
 		s3fwrn5_i2c_irq_thread_fn, IRQF_ONESHOT,
 		S3FWRN5_I2C_DRIVER_NAME, phy);
 	if (ret)
-		s3fwrn5_remove(phy->common.ndev);
+		goto s3fwrn5_remove;
 
+	return 0;
+
+s3fwrn5_remove:
+	s3fwrn5_remove(phy->common.ndev);
+disable_clk:
+	clk_disable_unprepare(phy->clk);
 	return ret;
 }
 
@@ -226,6 +253,7 @@ static int s3fwrn5_i2c_remove(struct i2c_client *client)
 	struct s3fwrn5_i2c_phy *phy = i2c_get_clientdata(client);
 
 	s3fwrn5_remove(phy->common.ndev);
+	clk_disable_unprepare(phy->clk);
 
 	return 0;
 }
-- 
2.31.1

