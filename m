Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8595446F68
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 12:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfFOKJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 06:09:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38724 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfFOKJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 06:09:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id d18so4987383wrs.5;
        Sat, 15 Jun 2019 03:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TU5sPWxUXVpDKkXIHMQHJv1/QjLj/w4ResWwHswsQ9k=;
        b=q81b6gQfj2ao1vMnyoQZgvyXuRVm+nRF84Z4NPNDtAifoi/Yds9AbbXmST9oPrQNxJ
         L0ObMFgHifNglFniPaYe94xkfWZ6qQaOST9bYl1e9Ayf6gwzkYQ/hxWHkJvpH6uVfHV3
         D4p1mG0AJUyq2y12T1gCO1lCH9qfjmOT4Y/V5Ew4L+dqDF4g1OIPaWF5A3+9QnQ8vT0Q
         fHx+Uknj3PAygSVc90vpZ7SNvkxpKOQv9E3pNE+YtXjhyy7rOAxOzzEHZQjUVnTbjeD6
         BCAeqRCaDVuoVlkgpSgxMmXe/yNwCw7MFqnzQh+3ospxDwTv4XA6xBDzXQwufGJAjqxB
         Lgbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TU5sPWxUXVpDKkXIHMQHJv1/QjLj/w4ResWwHswsQ9k=;
        b=IfLAnyMKPV9nAmpPj5DuMg+jDgH9xnde5KOhNdhVipU5D2dqjy4IKha1wcknkbCwSZ
         2OoWpyF5gPSFvGQFQeEcxm0y6vFtDLzJuR+p4kLhpFOG0qLo4WnEfQY9Qose1OUy0Eb/
         0xpEhqSCpSXaAPZ0DYsh1tNnQ4d7NdTLQFrGAaLRPBCymfKWoq4ENoLuUDGBLBDwyi5Q
         0WKnzO2Xh8+gZ/dUVim+m2yAIgxrBuD3F/WFpzlN8xuUKArsQ2znRn4RLxahQfG+NsJ6
         P6ShQYxU+Vqs0QGXPWkxJahIREA5pekdxqeM0J93CFscwaIrHyE/4oaXh2hqRggR6oyt
         qUTQ==
X-Gm-Message-State: APjAAAXAADRmqsA0EFmUmbfkwTGHgP77qaD6H51TZ9vKxhIJxDvN375u
        PFjDrn0HOVvck1ThdNHsUNgDwUNryY4=
X-Google-Smtp-Source: APXvYqy2T6u5Bo9cJYCElKkMVr2UauJqohfFkH8EkNhL0wrkkh3Ih6tzMAnD1ivvjWgec4OC5yaLDA==
X-Received: by 2002:adf:e84a:: with SMTP id d10mr3190321wrn.316.1560593382566;
        Sat, 15 Jun 2019 03:09:42 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133C20E00A9A405DFDBBC0790.dip0.t-ipconnect.de. [2003:f1:33c2:e00:a9a4:5df:dbbc:790])
        by smtp.googlemail.com with ESMTPSA id f2sm9270513wrq.48.2019.06.15.03.09.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 03:09:42 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net
Cc:     linus.walleij@linaro.org, andrew@lunn.ch,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net-next v1 1/5] net: stmmac: drop redundant check in stmmac_mdio_reset
Date:   Sat, 15 Jun 2019 12:09:28 +0200
Message-Id: <20190615100932.27101-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190615100932.27101-1-martin.blumenstingl@googlemail.com>
References: <20190615100932.27101-1-martin.blumenstingl@googlemail.com>
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
index f1c39dd048e7..21bbe3ba3e8e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -256,9 +256,6 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 		if (data->reset_gpio < 0) {
 			struct device_node *np = priv->device->of_node;
 
-			if (!np)
-				return 0;
-
 			reset_gpio = devm_gpiod_get_optional(priv->device,
 							     "snps,reset",
 							     GPIOD_OUT_LOW);
-- 
2.22.0

