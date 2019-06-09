Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FED53AB04
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 20:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbfFISGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 14:06:42 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45327 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729352AbfFISGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 14:06:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so6868619wre.12;
        Sun, 09 Jun 2019 11:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v1cIgIB/50o1TbuP4h7H+LIZ4pZcg3N52gZnolC5tNY=;
        b=A3czi1Dd8xVadhyrRlkBaDwSqjW0C9T7e2gfiqTTqXBWnEx1kL4TX8qXuj3Xy3qfM0
         5iny+h6uiPG/9QeP7zkvWcBhsfeCKwy8CGTIMEvub+SmrvjgDCwUoDfQaHzyiyIDEa+k
         tWDKdLgoefImiuL1ZqWnHWTvo5c59Wq6zCHt/Vv6ZRmsU02qdpxTsPPS/lTTUNkBCGtz
         vdCrDYoSvMO9YuyBmmRGpts6a17UQjzMJAyeAXOZdnpNrhhAGAKW+FZXIi562prgpzQ+
         1QDEdy6DOYRCzaSLxU2HiUEllLqYYxBMD9Ivg3yXp8csBGAoHjwsyF5E/2bbPrtPWCnF
         +pVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v1cIgIB/50o1TbuP4h7H+LIZ4pZcg3N52gZnolC5tNY=;
        b=hrQlDiY94V2vJ3Vu/1D3asM/DIluqVYnV0bc5bmv2TiH7QWgm0FrtxhBp9wtqoG4c8
         ROxQvv5ngjikSOeiYnDKg4lfn0c52NGOeYu9xVsFeSa2lVm4RkpQKHnBXJWO8t7t++AX
         1WkoQICOHi1jeuA0hi6AXsvhA8X2t2xmLe6e/BGiE14KXuMfR/Tw/hHfC3ttPhVYT9Py
         Zb+yARcQv/zeSLqKxlqDX8c2wYXaRpZb3/lrliNwmFP4zswmI177QmjO5IRqDsgJd/mm
         bSmdW9ocxGj2lGD4YQjWiD9Fh8FvVrg8tuEqG5S/N+jxWt0rU8aYBYozXGqQRMTlxEaq
         UI0w==
X-Gm-Message-State: APjAAAU5ebvMTnBIRnx2IAYmpGNxmnboAicnj8SqPlXKhLnsqQSkOtTj
        5KixoUCZRVm3hLacg8VCll6ZbQ9p
X-Google-Smtp-Source: APXvYqy7+SScjAXQjSTLA2olnCPdQUH0aM8+Jocv0daXnj4LKMXvOjzcZLeXAUQkW+23xSiMaGdOPw==
X-Received: by 2002:a5d:4311:: with SMTP id h17mr43160091wrq.9.1560103597686;
        Sun, 09 Jun 2019 11:06:37 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA400B42D8EB9D711C35E.dip0.t-ipconnect.de. [2003:f1:33dd:a400:b42d:8eb9:d711:c35e])
        by smtp.googlemail.com with ESMTPSA id h14sm2007731wrs.66.2019.06.09.11.06.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 11:06:37 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com
Cc:     devicetree@vger.kernel.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        khilman@baylibre.com, narmstrong@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC next v1 1/5] net: stmmac: drop redundant check in stmmac_mdio_reset
Date:   Sun,  9 Jun 2019 20:06:17 +0200
Message-Id: <20190609180621.7607-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A simplified version of the existing code looks like this:
  if (priv->device->of_node) {
      struct device_node *np = priv->device->of_node;
      if (!np)
          return 0;

The second "if" never evaluates to true because the first "if" checks
for exactly the opposite.
Drop the redundant check and early return to make the code easier to
understand.

No functional changes intended.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 093a223fe408..cb9aad090cc9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -254,9 +254,6 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 		if (data->reset_gpio < 0) {
 			struct device_node *np = priv->device->of_node;
 
-			if (!np)
-				return 0;
-
 			data->reset_gpio = of_get_named_gpio(np,
 						"snps,reset-gpio", 0);
 			if (data->reset_gpio < 0)
-- 
2.21.0

