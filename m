Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96AD460F12D
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 09:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbiJ0HeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 03:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbiJ0HeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 03:34:06 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAEA16654F;
        Thu, 27 Oct 2022 00:34:06 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w189so699713pfw.4;
        Thu, 27 Oct 2022 00:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LHPZrKFFoEMIG1bKh6n/2S4z4SzlB62bMfxjU34nZIw=;
        b=jBXGKPHxfXS8/aVKJTp0rf4nAX2GPQVE2TxLjqc5eLxYi/JGvp1gEM7trFtxb7Odov
         3kBa8zIQ0P2g13Oo0g50+qlm9Ox9FRlR9kTxGj+f53sZuTgpzdbp5Usn4qbPr25aGqEZ
         3MrbWBATAAp24VWpVauV1b9pxEix65Fx03nkmTRwwu8KwTRHGvymCUYXjcWh8vI+B0tC
         JpzY2/tsHss55eaLIONsNjK1OCj4TFli/64yvvOMV1qC9KaZ/Ti0fMuSoNhlHLupxcqW
         oMIizJq3hIBUlZ+fcH8JKcOdvgVF04kMIHG8zTtUgg7VzcWOL7yG9jTugWp8L9JdOGIp
         RHSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LHPZrKFFoEMIG1bKh6n/2S4z4SzlB62bMfxjU34nZIw=;
        b=la1nIBb9H98nmmqe28E9CHqTMv63FYjd8FH61eh2ae8vEaSqxssN8OILGMbKyOsGl8
         wx8hi2PHBMtaf9vgAe6g+c8eV8F2FSmkFcaKv3f4WzovXHQrQsXXgqpME/q6wUkPgE65
         xEoZmKVzpr0I8OiOxkYN8HuZnQllrLko4ET3K3Ac0u6xKsnyHN6jIW3QCd3QXtfn17x0
         ZrTaOA4yjEEw3WSVzMohXtLU38Bv9pIXfK5OWdFIK64Gjm/7fgng79vcR6HVoBapr4OB
         Y26ioPrctNDH3uM/g1JluxdVw9g7kqFz2JlwdbxghGZrH7KXGfHrEEelVohNoQMDAbz6
         zsdg==
X-Gm-Message-State: ACrzQf07sdUwo2A0dBenSeGcLJMUEWyGnmbP7XGOfu55BnOVJdGJeaJe
        MXl1tkRFePDYFfcoDPDuUsE=
X-Google-Smtp-Source: AMsMyM7Z1RovcKlgYiQZ1hlX5VWvhpw1gkfpdyHl796mmvdVCJJi5AZLlLdOR8YiCrtACvm4Tx25ew==
X-Received: by 2002:a63:c112:0:b0:443:94a1:f09 with SMTP id w18-20020a63c112000000b0044394a10f09mr41333201pgf.396.1666856045649;
        Thu, 27 Oct 2022 00:34:05 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:99d6:ae15:f9aa:1819])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902bd8500b00186c3af9644sm490098pls.273.2022.10.27.00.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 00:34:05 -0700 (PDT)
Date:   Thu, 27 Oct 2022 00:34:02 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] nfc: s3fwrn5: use
 devm_clk_get_optional_enabled() helper
Message-ID: <Y1o0ahD+AisRA+Qk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because we enable the clock immediately after acquiring it in probe,
we can combine the 2 operations and use devm_clk_get_optional_enabled()
helper.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

v2: remove calls to clk_disable_unprepare() as they are not needed anymore

 drivers/nfc/s3fwrn5/i2c.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index f824dc7099ce..ecdee838d25d 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -209,27 +209,21 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
-	phy->clk = devm_clk_get_optional(&client->dev, NULL);
-	if (IS_ERR(phy->clk))
-		return dev_err_probe(&client->dev, PTR_ERR(phy->clk),
-				     "failed to get clock\n");
-
 	/*
 	 * S3FWRN5 depends on a clock input ("XI" pin) to function properly.
 	 * Depending on the hardware configuration this could be an always-on
 	 * oscillator or some external clock that must be explicitly enabled.
 	 * Make sure the clock is running before starting S3FWRN5.
 	 */
-	ret = clk_prepare_enable(phy->clk);
-	if (ret < 0) {
-		dev_err(&client->dev, "failed to enable clock: %d\n", ret);
-		return ret;
-	}
+	phy->clk = devm_clk_get_optional_enabled(&client->dev, NULL);
+	if (IS_ERR(phy->clk))
+		return dev_err_probe(&client->dev, PTR_ERR(phy->clk),
+				     "failed to get clock\n");
 
 	ret = s3fwrn5_probe(&phy->common.ndev, phy, &phy->i2c_dev->dev,
 			    &i2c_phy_ops);
 	if (ret < 0)
-		goto disable_clk;
+		return ret;
 
 	ret = devm_request_threaded_irq(&client->dev, phy->i2c_dev->irq, NULL,
 		s3fwrn5_i2c_irq_thread_fn, IRQF_ONESHOT,
@@ -241,8 +235,6 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 
 s3fwrn5_remove:
 	s3fwrn5_remove(phy->common.ndev);
-disable_clk:
-	clk_disable_unprepare(phy->clk);
 	return ret;
 }
 
@@ -251,7 +243,6 @@ static void s3fwrn5_i2c_remove(struct i2c_client *client)
 	struct s3fwrn5_i2c_phy *phy = i2c_get_clientdata(client);
 
 	s3fwrn5_remove(phy->common.ndev);
-	clk_disable_unprepare(phy->clk);
 }
 
 static const struct i2c_device_id s3fwrn5_i2c_id_table[] = {
-- 
2.38.0.135.g90850a2211-goog


-- 
Dmitry
