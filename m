Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A40388A5D
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 11:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344845AbhESJUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 05:20:37 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.171]:23341 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238831AbhESJUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 05:20:34 -0400
X-Greylist: delayed 65925 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 May 2021 05:20:34 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1621415951; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=d8q2cM/SdFykPpqlHTcxfc7KAPvnhbZ/7n9GhXKcimSZCzspmUEZu1kn4egWQC/m8G
    Qe3qmsQcSB/EBCxc+LrzqJAviK/njRIDYTuWAeNXTPVd/a4cfIkgWP9sFRW06ehNM0P1
    mWuKHmfe4h8KuZSjSNrkfeXaxrxdxjmY93Ta2KUZwXXXCWA7XFjOjstONfaynRUB03jf
    YDnjbNH+eEM14J5f9cApTczMcQasDrr9P3nb6yk6AsaW5+RW6VKocS5KtYqeKd4oVoJW
    FLR8BOTu+5r3HXr16WHmJvYCXIn/CT2g+dk8INvnQDo8DD/yrzMlOUgmxX7yCYBMyqGo
    R2XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1621415951;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=sJxLXx5SYNVClp7C91+GrkUJKz/Io/2j3rLaghi76M4=;
    b=kZwtgMQPJbXMJX0xT9tswW6d3+73ZCHK1Q5oypmTUOHIKpEIllTGVnTiyY2CvpOIHG
    amjt1CZf8JsBdVYOWJYoEEL3+xTc/gduqBjL5PD8jKS6lEhDoTvje+MGePhpWm6plnGm
    k5ra2Mwltp4iunDm2uFtQ9xy0Hm/W83d6K0otut9LKE4eu5eBzQATXiZ7G5FWYipnC4q
    wKmSUeC7IFYKT95Dc047XVAnjGSGfKIdfeWLcsv8oYkZA0VIqbcFXbtBIqw02vOWHVBg
    vbw96Uw7fA2RhvAAvrUgv1JVi0zCmWg1STz/1ulcBIeNZnjUgk+TVgDX95F1o7SgLCXz
    gKvA==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1621415951;
    s=strato-dkim-0002; d=gerhold.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=sJxLXx5SYNVClp7C91+GrkUJKz/Io/2j3rLaghi76M4=;
    b=EKjNdfJARUCiD2/YPy8X30XZvNp/KuocTjIzI/Y33HKUh5TqWlwV5dwGE9YeGLiz17
    BICcP8lBQbdrXtj2IkG728NJgknHT6cGyAX+l8iZxh1F+7umUyrdVlgSULME/QPdkrEC
    8MoxoXGIrKCymQZap/wWXmHJjPfTmRYmGzEukeD7YlW1+FKnYxJkPPbQdTeqgi3YYUky
    xxhITwlJeFYoP4ShXOMkZ78W20hY4RVCkgQXhbot+SNiREAD0u5DZKpJ0vB5SZHHYB+w
    tagcZ1Q44SX9mf0p8LZGy6zcBHX/mcv2NUKQDdW8TuT80hThMY3sTNYEKS89DUjq7e/x
    cAig==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXS7IYBkLahKxB4G6NfHcC"
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.26.1 DYNA|AUTH)
    with ESMTPSA id z041eax4J9JB5aj
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 19 May 2021 11:19:11 +0200 (CEST)
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
Subject: [PATCH v2 2/2] nfc: s3fwrn5: i2c: Enable optional clock from device tree
Date:   Wed, 19 May 2021 11:16:13 +0200
Message-Id: <20210519091613.7343-2-stephan@gerhold.net>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519091613.7343-1-stephan@gerhold.net>
References: <20210519091613.7343-1-stephan@gerhold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

S3FWRN5 depends on a clock input ("XI" pin) to function properly.
Depending on the hardware configuration this could be an always-on
oscillator or some external clock that must be explicitly enabled.

So far we assumed that the clock is always-on.
Make the driver request an (optional) clock from the device tree
and make sure the clock is running before starting S3FWRN5.

Note: S3FWRN5 asserts "GPIO2" whenever it needs the clock input to
function correctly. On some hardware configurations, GPIO2 is
connected directly to an input pin of the external clock provider
(e.g. the main PMIC of the SoC). In that case, it can automatically
AND the clock enable bit and clock request from S3FWRN5 so that
the clock is actually only enabled when needed.

It is also conceivable that on some other hardware configuration
S3FWRN5's GPIO2 might be connected as a regular GPIO input
of the SoC. In that case, follow-up patches could extend the
driver to request the GPIO, set up an interrupt and only enable
the clock when requested by S3FWRN5.

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
This allows NFC to work properly on the Samsung Galaxy A3/A5 (2015).

Changes in v2: Rewrite commit message and comment based on discussion

  Note: I tried to explain the setup a bit better but dropped most of
        the explanations about the exact configuration on the Samsung
        Galaxy A5. I think the HW-specific details were more confusing
        than helping. :)

v1: https://lore.kernel.org/netdev/20210518133935.571298-2-stephan@gerhold.net/
---
 drivers/nfc/s3fwrn5/i2c.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index 897394167522..38b8d6cab593 100644
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
@@ -207,17 +209,40 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
+	phy->clk = devm_clk_get_optional(&client->dev, NULL);
+	if (IS_ERR(phy->clk))
+		return dev_err_probe(&client->dev, PTR_ERR(phy->clk),
+				     "failed to get clock\n");
+
+	/*
+	 * S3FWRN5 depends on a clock input ("XI" pin) to function properly.
+	 * Depending on the hardware configuration this could be an always-on
+	 * oscillator or some external clock that must be explicitly enabled.
+	 * Make sure the clock is running before starting S3FWRN5.
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
 
@@ -226,6 +251,7 @@ static int s3fwrn5_i2c_remove(struct i2c_client *client)
 	struct s3fwrn5_i2c_phy *phy = i2c_get_clientdata(client);
 
 	s3fwrn5_remove(phy->common.ndev);
+	clk_disable_unprepare(phy->clk);
 
 	return 0;
 }
-- 
2.31.1

