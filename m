Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDB15E5B69
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 08:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiIVGa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 02:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiIVGay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 02:30:54 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A9AB56E2;
        Wed, 21 Sep 2022 23:30:53 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b35so12189496edf.0;
        Wed, 21 Sep 2022 23:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=X2RSkGTaerMARbSS7PmeBhX+cBl2v+Mh6pmBgaMwj3U=;
        b=nVC4EPey67ez4p+WqaOJH46Oa6jPVPEDKgcLjYdaa1DRCoB5Bp6wUMrr/ReFtL1Osv
         T2Q8ju2FTFWGiip66MQxuyp64UwCFLNjmyxNZuZSxMYRnjuS8CwSyKb4M8pEkwWPiVyZ
         6Pse+Pjv47qPNXonxOsYbwLdbZSEC8jnUspfEm5G6IuQMqqK6Z4xdkEOImNPMBGHVoSg
         WS6dBKhHrEua/cK+hrDfXRnsmYoI+8izCMGvL4lxFDxd4yp8pyM0aEQrjGyqoPdV22QC
         XTuDRKR44lcyzTgasZdQdzZS9WnTSTXFrudykHBf8R7sb23uXcTZl/D3vwOQw3PnbEDw
         3MSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=X2RSkGTaerMARbSS7PmeBhX+cBl2v+Mh6pmBgaMwj3U=;
        b=1HsiIm2m8cReACGn6vQ9or3AI/+bRB9fftAsVzn5WgY+zfnEMyUtg02WuT+gbsqx4c
         sBryqXl++Ha5MjxKpFjm7mCVmrG+tUNRwLpDiO8m/SHR23hOOn5AUJ9I9Iu5UCh1L8bT
         4XLd/+yg5dzQp8oYszp4gf3LmgUMQdEkta1uxk1seHa/M6w+MqRQ8sabryY9ZIANKy4/
         o3tkkV+lDWzIRPhOCIxrxYsLQVaR4A2apH68VPC5U08tLvgF0tuy8H7/k9d4ciB/e/lA
         HqbyeXsMWavoybkyp9u5ZBoGUa68vGlEJh6D6c6xWOXUvrKNahJVLeAwtvM3xkDEk3eN
         ybnw==
X-Gm-Message-State: ACrzQf0QDSucfhnuEOAU5KrAV6EwoXKKHVhiCwhkMmqrAsPZmkeKniCe
        7aREGPUyhBeRBR2lB+/HKSre0XjG0kCZnXXiLBY=
X-Google-Smtp-Source: AMsMyM7vAN+WpSqfsMnwyzHG2jFYIW5pTMzeH0Gp7i7KAQ6Ev8maDaMWZTx3kfEBl5hXCndjfbBmZg==
X-Received: by 2002:a05:6402:1446:b0:44e:ec98:3e11 with SMTP id d6-20020a056402144600b0044eec983e11mr1695817edx.90.1663828251706;
        Wed, 21 Sep 2022 23:30:51 -0700 (PDT)
Received: from alexandru.andrei.tachici (89-24-97-34.customers.tmcz.cz. [89.24.97.34])
        by smtp.gmail.com with ESMTPSA id a10-20020aa7cf0a000000b00453a727376esm3053611edy.83.2022.09.21.23.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 23:30:51 -0700 (PDT)
From:   Alexandru Tachici <alexandru.andrei.tachici@gmail.com>
X-Google-Original-From: Alexandru Tachici <alexandru.tachici@analog.com>
Received: by alexandru.andrei.tachici (sSMTP sendmail emulation); Thu, 22 Sep 2022 09:30:49 +0300
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com
Subject: [net-next] net: ethernet: adi: Fix invalid parent name length
Date:   Thu, 22 Sep 2022 09:30:49 +0300
Message-Id: <20220922063049.10388-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MII_BUS_ID_SIZE is larger than MAX_PHYS_ITEM_ID_LEN
so we use the former here to set the parent port id.

Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/ethernet/adi/adin1110.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 4dacb98e7e0a..4f3c372292f3 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -1028,7 +1028,7 @@ static int adin1110_port_get_port_parent_id(struct net_device *dev,
 	struct adin1110_port_priv *port_priv = netdev_priv(dev);
 	struct adin1110_priv *priv = port_priv->priv;
 
-	ppid->id_len = strnlen(priv->mii_bus_name, MII_BUS_ID_SIZE);
+	ppid->id_len = strnlen(priv->mii_bus_name, MAX_PHYS_ITEM_ID_LEN);
 	memcpy(ppid->id, priv->mii_bus_name, ppid->id_len);
 
 	return 0;
-- 
2.34.1

