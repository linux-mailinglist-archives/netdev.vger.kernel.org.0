Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCC05C5B9
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 00:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfGAWmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 18:42:51 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38140 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfGAWmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 18:42:51 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so4313700wro.5;
        Mon, 01 Jul 2019 15:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TG7WWB3lc3BPx5FG8dO3TIxLT0YfJ51715wfOfLXzjQ=;
        b=T5Wxgwrms3KLGReGHlwzTm5Mul15wvFJJSk0VFFNa+Q6//0DYJiyakj5yjRNrq+W7B
         /GDpBBqrYBK8CYcCQ5oESw7BdCxDIkEs4buUoiJnDm2MRcFzLaqQktaxTCkrWhU0xgsq
         h2yUShZcPyYtQPZ+edVbFohhIp708yduOWe0eoQpVgKROAgRK8vCQv/V7zh6MD7GzqZH
         3QmudLqgVRQDR7Ux1GfqTJGWPtqDbOf91QQwUZ0BYn0GMxdPLKEQr0ZseVy5CObg6j4D
         EfkoUmjv6odiZwLzVj9GrZYbh56ptUTTL2x20RVwtT3M/REDzbebpaR2kvJIsoLTj48E
         ZvOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TG7WWB3lc3BPx5FG8dO3TIxLT0YfJ51715wfOfLXzjQ=;
        b=ugD7WEnrJhP5u6ulfdZWXw4opk9H/a8Xn7HPkfjUE84+/PpYfoGd0b7N4UbdIIA6A6
         b2MQRp4s3Fix0VXoQLYGkU0QCr5vuvYl2geFPB/ElekhE12u7ektL0g8uPXkO7ze1Y6Q
         +MpCy9G5Bhr58aGp87UL7ZjbssIhhJAfChxRzDY/xEiVQ0D1xoESYoPkmj4p0SFLk14q
         xiX7Ll/r5DmxrJ7BmvwSvlyXOXwhl8Y9hWYGiy3S8MYawVgJBmPbIJgNbzyZWcOasGnt
         dicZeG0kImaA0Zv78sX4BPWeRj13IW9WCpl/FpW8cqwbLS41ENPM0x+Q/8lHP7u1KxYJ
         Pztg==
X-Gm-Message-State: APjAAAV04jtXbQrk0BjKhqKXRCX1ns0cB2syv1RtC56ZVFmqlWcMPoGG
        e5djQtjvC86S0ExslP+enFNYkUYY
X-Google-Smtp-Source: APXvYqxqieuIsfPGN7KpgIU60C0J3+zTqMhptvL/dVoBjEqwAqMxYmd+wA9rGlO4+B//2gj75LEEmA==
X-Received: by 2002:a5d:5008:: with SMTP id e8mr588448wrt.147.1562020968754;
        Mon, 01 Jul 2019 15:42:48 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133FCEE00B45C38AFF5505594.dip0.t-ipconnect.de. [2003:f1:33fc:ee00:b45c:38af:f550:5594])
        by smtp.googlemail.com with ESMTPSA id v5sm13201632wre.50.2019.07.01.15.42.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 15:42:48 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        colin.king@canonical.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] net: stmmac: make "snps,reset-delays-us" optional again
Date:   Tue,  2 Jul 2019 00:42:25 +0200
Message-Id: <20190701224225.19701-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 760f1dc2958022 ("net: stmmac: add sanity check to
device_property_read_u32_array call") introduced error checking of the
device_property_read_u32_array() call in stmmac_mdio_reset().
This results in the following error when the "snps,reset-delays-us"
property is not defined in devicetree:
  invalid property snps,reset-delays-us

This sanity check made sense until commit 84ce4d0f9f55b4 ("net: stmmac:
initialize the reset delay array") ensured that there are fallback
values for the reset delay if the "snps,reset-delays-us" property is
absent. That was at the cost of making that property mandatory though.

Drop the sanity check for device_property_read_u32_array() and thus make
the "snps,reset-delays-us" property optional again (avoiding the error
message while loading the stmmac driver with a .dtb where the property
is absent).

Fixes: 760f1dc2958022 ("net: stmmac: add sanity check to device_property_read_u32_array call")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
This is a fix for a patch in net-next and should either go into net-next
or 5.3-rcX.


 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index f8061e34122f..18cadf0b0d66 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -242,7 +242,6 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 	if (priv->device->of_node) {
 		struct gpio_desc *reset_gpio;
 		u32 delays[3] = { 0, 0, 0 };
-		int ret;
 
 		reset_gpio = devm_gpiod_get_optional(priv->device,
 						     "snps,reset",
@@ -250,15 +249,9 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 		if (IS_ERR(reset_gpio))
 			return PTR_ERR(reset_gpio);
 
-		ret = device_property_read_u32_array(priv->device,
-						     "snps,reset-delays-us",
-						     delays,
-						     ARRAY_SIZE(delays));
-		if (ret) {
-			dev_err(ndev->dev.parent,
-				"invalid property snps,reset-delays-us\n");
-			return -EINVAL;
-		}
+		device_property_read_u32_array(priv->device,
+					       "snps,reset-delays-us",
+					       delays, ARRAY_SIZE(delays));
 
 		if (delays[0])
 			msleep(DIV_ROUND_UP(delays[0], 1000));
-- 
2.22.0

