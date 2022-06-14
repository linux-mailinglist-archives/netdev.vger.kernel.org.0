Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020FE54A9B3
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 08:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238714AbiFNGqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 02:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbiFNGqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 02:46:51 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189E53914B;
        Mon, 13 Jun 2022 23:46:51 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id j5-20020a05600c1c0500b0039c5dbbfa48so5662818wms.5;
        Mon, 13 Jun 2022 23:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6tcu5eAwoOyzRfW5zLo655OGJsCRzmBD09HjOYtJ02Y=;
        b=Zsdkp8SftJ+6ZISPstVg6W7XbMt8pikCWv9ykdo7e3/UbvdjegvnDe21C13EiuATqv
         Kj1SvendYDpzEsm3lVmeWeSqSmV+nSWTzppZZDp+jpx9sDuVvzswkLa1zaBoOyWKg8+S
         RZ5KUpGtSfaZWeC1ZtXGAaCwlhD4AHz8QzYZ1ugZWvkTAQTLNZWl0SBlgGF9o2ugbdky
         tXyY+de0MojejV9P6lhQC9x7GFkAyUYfyyBae6JBFJyj1Bzu7G32pFg8sCAdxLv3ljip
         LMeEwbYUjeGd5RP7qNK0Vw90gHteA3B3Pz9nN0wgyeROQcuAynQSQRLPVGyrcLXUW0AZ
         yWMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6tcu5eAwoOyzRfW5zLo655OGJsCRzmBD09HjOYtJ02Y=;
        b=QHzW69jCWAJXdq0+YEP745jXqzkPAyyGcfAkVarhGPyjMmTqEcMV3yoFAeUtMz4aWC
         OFICdTWfuVEwee16zf8BnPcGWEcfh+UB/a6MfVF6hh4bjLBK5GRfsR2TGunnerJD5I6w
         EIzVZNVkyIY9wqiYos2aSVLw+CiSw+iORgcpx+pkfioLR5HjRcRmtAcsPyqHRqZOWR2I
         OdxXVCiLXKare8KWVzXlg4J8IAKEF5cz8o8tDZAj0FusZG3xbtAgU81TB+Eoezg03q/W
         9jizm0u3VZeswYEfyjRt0uaBK7bP1CJnRHEXtaC/EFsd3fsdSp1p3Qi7G8GaFYSXzChH
         hRRw==
X-Gm-Message-State: AOAM533AIxdq3/VQYYIkGm0tlB19ayhzCScZnHWKqt9pvPuDWUfeunKQ
        iDdeqgsd+tmXG+mXP8d35nc=
X-Google-Smtp-Source: ABdhPJyK9ueeuJL7iGVp7NyZ3QeK/ETBQMghVR/ae3lle2IFQ35LU6YzakGR1belXE94IhM7t5WNVg==
X-Received: by 2002:a05:600c:4e51:b0:39c:4f18:4c29 with SMTP id e17-20020a05600c4e5100b0039c4f184c29mr2499224wmq.101.1655189209490;
        Mon, 13 Jun 2022 23:46:49 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id e16-20020adffd10000000b00210396b2eaesm12865044wrr.45.2022.06.13.23.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 23:46:48 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: axienet: Fix spelling mistake "archecture" -> "architecture"
Date:   Tue, 14 Jun 2022 07:46:47 +0100
Message-Id: <20220614064647.47598-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a dev_err message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index fa7bcd2c1892..87a620073031 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2038,7 +2038,7 @@ static int axienet_probe(struct platform_device *pdev)
 		}
 	}
 	if (!IS_ENABLED(CONFIG_64BIT) && lp->features & XAE_FEATURE_DMA_64BIT) {
-		dev_err(&pdev->dev, "64-bit addressable DMA is not compatible with 32-bit archecture\n");
+		dev_err(&pdev->dev, "64-bit addressable DMA is not compatible with 32-bit architecture\n");
 		goto cleanup_clk;
 	}
 
-- 
2.35.3

