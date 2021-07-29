Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B7E3DA15E
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 12:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbhG2Klb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 06:41:31 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:47764
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235445AbhG2Kkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 06:40:43 -0400
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 2B7ED3F114
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 10:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627555240;
        bh=8EDO8hbetO1mnknXtDL482rftlukDehwkpBsBwJNSdE=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=D989OQww4T54EB5kWFBLYsZFUxBekBV/D+b+vnQUNg2gNz7iKBroM+Y57/ztQU1BU
         ZtH3Lc5klXg8n5vZy6Ie/yQwZQsxoQnHoMlz3Y6mJE/5kV0js4h9eJcw1Y/443JS4Q
         5XgYUyRAtVpqN0X8YtAJXUVjQngE4ovh5byoe+wCGjvfmu677rcbfVgCQe4NYw842A
         NAusMGss7+SvizG3B5fOfeQOt4qr/6GpgEP3ZjVbtgfquEXtDLduhdzbM8v51tgx0J
         H6PKSLdgTZBvGrN7cTK/0+n0g6ho3E8Ekz1nZwDg9ULQqmGJMhz0Y/CnXJMhnHM4Hd
         Rn4jBrl+FgZog==
Received: by mail-ej1-f72.google.com with SMTP id a17-20020a1709062b11b02905882d7951afso1840449ejg.4
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 03:40:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8EDO8hbetO1mnknXtDL482rftlukDehwkpBsBwJNSdE=;
        b=FwcbwiWZHt8lQPZcZt4BUUYNCtLHRFHiox9qJr939SCJokiGb6iqQOMOzdABQNUrrO
         n8z9VsRgIvd2as/SyO6RJJbd5khdBCsHaVdZ2G8sj3sSsuddBKiybfmrBA6ZOemgyQk3
         +KlXLc+InfyPYZg873bqHr5V44ntI/gce0ev12GlQ0khpxNinbm+hDnrbl0MtqiK9WEY
         9VYJvBLxDE2ySa+THz/dTqbNxQ7fBWlGpvFecKP6479v1OZSz/55YFmtdWsUovvrfnNR
         +Ie+GP+sQBhfFjZrqDYA8lQiaWjM/DMmLlyIgGtIe5vpn/fHxd5wPj4OZIblTc0rO/rZ
         V9fQ==
X-Gm-Message-State: AOAM532FRGKoI1rAmJNvoUaOWaGItJf1sza825UJEcujGr6kLB1g6FbT
        KsFPw+TU1v0EjfYCPOZC8BknwU8nq18qYJQwHMWWc4WS3WLxqIjiJm8WpUU8gmHccIl9rpc/W2y
        WRtomo7XNGFM7fF257xjNSpKSMgb7ys7Q7g==
X-Received: by 2002:a17:907:364:: with SMTP id rs4mr4101151ejb.56.1627555239868;
        Thu, 29 Jul 2021 03:40:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZOu9E6xI3XjXcxdCN71pcdo7KIqUHufVdue1M53+xuTdudckjsCWW6eu5CVaY3Tc87olLnA==
X-Received: by 2002:a17:907:364:: with SMTP id rs4mr4101068ejb.56.1627555238733;
        Thu, 29 Jul 2021 03:40:38 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id c14sm824475ejb.78.2021.07.29.03.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 03:40:38 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 04/12] nfc: trf7970a: constify several pointers
Date:   Thu, 29 Jul 2021 12:40:14 +0200
Message-Id: <20210729104022.47761-5-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
References: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several functions do not modify pointed data so arguments and local
variables can be const for correctness and safety.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/trf7970a.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 1aed44629aaa..8890fcd59c39 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -643,7 +643,7 @@ static void trf7970a_send_err_upstream(struct trf7970a *trf, int errno)
 }
 
 static int trf7970a_transmit(struct trf7970a *trf, struct sk_buff *skb,
-			     unsigned int len, u8 *prefix,
+			     unsigned int len, const u8 *prefix,
 			     unsigned int prefix_len)
 {
 	struct spi_transfer t[2];
@@ -1387,9 +1387,10 @@ static int trf7970a_is_iso15693_write_or_lock(u8 cmd)
 	}
 }
 
-static int trf7970a_per_cmd_config(struct trf7970a *trf, struct sk_buff *skb)
+static int trf7970a_per_cmd_config(struct trf7970a *trf,
+				   const struct sk_buff *skb)
 {
-	u8 *req = skb->data;
+	const u8 *req = skb->data;
 	u8 special_fcn_reg1, iso_ctrl;
 	int ret;
 
@@ -1791,7 +1792,7 @@ static int _trf7970a_tg_listen(struct nfc_digital_dev *ddev, u16 timeout,
 static int trf7970a_tg_listen(struct nfc_digital_dev *ddev, u16 timeout,
 			      nfc_digital_cmd_complete_t cb, void *arg)
 {
-	struct trf7970a *trf = nfc_digital_get_drvdata(ddev);
+	const struct trf7970a *trf = nfc_digital_get_drvdata(ddev);
 
 	dev_dbg(trf->dev, "Listen - state: %d, timeout: %d ms\n",
 		trf->state, timeout);
@@ -1803,7 +1804,7 @@ static int trf7970a_tg_listen_md(struct nfc_digital_dev *ddev,
 				 u16 timeout, nfc_digital_cmd_complete_t cb,
 				 void *arg)
 {
-	struct trf7970a *trf = nfc_digital_get_drvdata(ddev);
+	const struct trf7970a *trf = nfc_digital_get_drvdata(ddev);
 	int ret;
 
 	dev_dbg(trf->dev, "Listen MD - state: %d, timeout: %d ms\n",
@@ -1824,7 +1825,7 @@ static int trf7970a_tg_listen_md(struct nfc_digital_dev *ddev,
 
 static int trf7970a_tg_get_rf_tech(struct nfc_digital_dev *ddev, u8 *rf_tech)
 {
-	struct trf7970a *trf = nfc_digital_get_drvdata(ddev);
+	const struct trf7970a *trf = nfc_digital_get_drvdata(ddev);
 
 	dev_dbg(trf->dev, "Get RF Tech - state: %d, rf_tech: %d\n",
 		trf->state, trf->md_rf_tech);
@@ -1974,7 +1975,7 @@ static void trf7970a_shutdown(struct trf7970a *trf)
 	trf7970a_power_down(trf);
 }
 
-static int trf7970a_get_autosuspend_delay(struct device_node *np)
+static int trf7970a_get_autosuspend_delay(const struct device_node *np)
 {
 	int autosuspend_delay, ret;
 
@@ -1987,7 +1988,7 @@ static int trf7970a_get_autosuspend_delay(struct device_node *np)
 
 static int trf7970a_probe(struct spi_device *spi)
 {
-	struct device_node *np = spi->dev.of_node;
+	const struct device_node *np = spi->dev.of_node;
 	struct trf7970a *trf;
 	int uvolts, autosuspend_delay, ret;
 	u32 clk_freq = TRF7970A_13MHZ_CLOCK_FREQUENCY;
-- 
2.27.0

