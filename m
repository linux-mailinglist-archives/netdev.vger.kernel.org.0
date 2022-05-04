Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9F451A23C
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 16:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351351AbiEDOfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 10:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351347AbiEDOfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 10:35:06 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7F540A39;
        Wed,  4 May 2022 07:31:31 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-e93bbb54f9so1321531fac.12;
        Wed, 04 May 2022 07:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mR7qVUfY5UjZOEcxyx4x5ViEVp0uC0ZkWAsTwVzhVD0=;
        b=M6uxTD4Ut2Gn0n+p+mO/qkPMcYQ5HveKQrHNVxJYYEzNZkCXif/8QzKLzhbGcwYMnU
         t0Oc3ar/Jtop0kxJPJi3KmQhDXLpKGlhNF1PKt7w7w4P8m6m+jfPucdUriQQdw7wi9Bl
         l34TXiMvC511gYXaYNNPzGJmfxDJblFZXvJ/ioCeulZFRwi76XNqyEMrs2wD5s3fYd4S
         6zfaEXEuK2PCvSKs4R77mqx+Z1fRyOGXd/bvXdBWVuLr47SXIK7D/5iZWLH9KRHeffXc
         tmcY50wl/7vgWTom1JBwhGhUXcAkxY0sD0/Mr81Gc1l7LJnumFS9VNOpYXCEV3oQjZYr
         s5Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mR7qVUfY5UjZOEcxyx4x5ViEVp0uC0ZkWAsTwVzhVD0=;
        b=TYtG/RohLRcx+X0IcN8yB+NQGAZLCI9KblSTLpnDxByHsS8gRKObLVbK2zyP6TDiDi
         81r4hWSDxEN1AsXaolVe/rhiO6vlgz+V3yb550uCzCxDlmQ7SKe61Zws0Cc2c0cq6jkh
         AN1W2skZsxnigW+1DG4dd4cAZGEQc7MlM2uDdbU7EaMbezd5ZI3BKsn0JfnjiSeKRT60
         IctBOO71dKzGWU6D0+DhYq9D/F3COZOuKMpXwRXHslA5bJz6QQssOvZmJX+X15yE4wS3
         0L7xQYAuryNiyP9TwiMwGwBAptkjStN+6mxU5en1jWlsyFJUCLJuswVt/lRmTtvIsdie
         ZpBA==
X-Gm-Message-State: AOAM531CySYW9s+D2zH647c7PR5gfV+c15WleOmA147XKNKyYPyVHuRo
        0reaMa1nfVC4k0C2thNJBZo=
X-Google-Smtp-Source: ABdhPJzmU6cDgEmnlcwzS0PHeU93YvCjTHg61HiF2Ay4p+5NaThOcIz6V73agA43KtkepBmLhrRO5g==
X-Received: by 2002:a05:6870:340e:b0:ec:c40f:e630 with SMTP id g14-20020a056870340e00b000ecc40fe630mr3736963oah.144.1651674690955;
        Wed, 04 May 2022 07:31:30 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:6ef3:840d:df28:4651])
        by smtp.gmail.com with ESMTPSA id m9-20020a4ad509000000b0035eb4e5a6dasm6018832oos.48.2022.05.04.07.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 07:31:30 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, claudiu.beznea@microchip.com,
        netdev@vger.kernel.org, o.rempel@pengutronix.de,
        linux@armlinux.org.uk, Fabio Estevam <festevam@denx.de>,
        stable@vger.kernel.org
Subject: [PATCH net v2 2/2] net: phy: micrel: Pass .probe for KS8737
Date:   Wed,  4 May 2022 11:31:04 -0300
Message-Id: <20220504143104.1286960-2-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220504143104.1286960-1-festevam@gmail.com>
References: <20220504143104.1286960-1-festevam@gmail.com>
MIME-Version: 1.0
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

From: Fabio Estevam <festevam@denx.de>

Since commit f1131b9c23fb ("net: phy: micrel: use
kszphy_suspend()/kszphy_resume for irq aware devices") the kszphy_suspend/
resume hooks are used.

These functions require the probe function to be called so that
priv can be allocated.

Otherwise, a NULL pointer dereference happens inside
kszphy_config_reset().

Cc: stable@vger.kernel.org
Fixes: f1131b9c23fb ("net: phy: micrel: use kszphy_suspend()/kszphy_resume for irq aware devices")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Fabio Estevam <festevam@denx.de>
---
Changes since v1:
- Newly introduced. This was noticed by Andrew.

 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 11cd073630e5..a06661c07ca8 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2896,6 +2896,7 @@ static struct phy_driver ksphy_driver[] = {
 	.name		= "Micrel KS8737",
 	/* PHY_BASIC_FEATURES */
 	.driver_data	= &ks8737_type,
+	.probe		= kszphy_probe,
 	.config_init	= kszphy_config_init,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
-- 
2.25.1

