Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCAD62E027
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239838AbiKQPlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239851AbiKQPkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:40:42 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9FA59856
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:40:41 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id 4so1997914pli.0
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oLJYSiggvAjbp+LwFxqT7uEEbEOvnatHP5iviwJOgSs=;
        b=lPZnKuA+IGDARzqKeOlwG6wwU2I1q9d4lrhLdd8funbceoQve6kg7fXWiJCQ54p540
         lIDvCgFOml3d40gOFy/hSXCyYh1On7vq7TSLja7jPJ/Px0+Rm0T+ncrJRT+wUUQ9vcTs
         3xTyoqbkZEtEpog+F8kHMW8714XT8fvc+PCmzLcXe7YyTIES3FV3wuVqMemMenNZm+Ao
         n96n4nZ/i8vmAGtV8yGSIIKLYU6Z98LBd5pEpNEi7ZCQcZM0gKtCeEx8keTVMczr+EWY
         CTtd6pkjzLsKmzdWHutANrBZWZYtjiXpvrHbW9QT1pdQxVTHRgGlxNb24OpwVVZFcq4h
         OTnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oLJYSiggvAjbp+LwFxqT7uEEbEOvnatHP5iviwJOgSs=;
        b=kG41zgZtLIncb90jk7fmdyWVHA+Uzp79pWg0IkhZblbe55LEegjHiGd8kEPuou5fC/
         RPRritDC5lWjnv+nJuQNJazhzIzAwB1OOPkYPg97Cov7O2ZefLatQs+coTshrcVr21K5
         NSf6mMBbnEvupPEXIpfwLhW9Ojf4kzdqUDyHdd2lUGpQL+tUTaQz5+QOqPVKeCBzx54A
         nxFA28QJ/mGgfQKzRSkpwbfsF3hF7IeUryJAEtfVbwI3d8PLGYiVHQN9sagCOgC03ylH
         qX4B3U1DuXOJYmfU9Cqka0K8NX73wgEwrOwsZ39wssQ54fx8t+MfMyrds14UyvwjoERM
         nzTA==
X-Gm-Message-State: ANoB5pmzVoMzvaHwf9iQwCe6qGupi94isW/tG/jsm1Y8IAvGF/ZgWgdj
        zPHVjDiauJrVEG0O+6G+Gw3DKrub+KQL2VRd
X-Google-Smtp-Source: AA0mqf7ZyTUBzAQtqpgaTHa+DvymqUBVqN5ZEqLpVzMeKmg/cajj1yV0PppjyyD1v48AbEM2nvcxcQ==
X-Received: by 2002:a17:90b:30d0:b0:213:f1d8:eb6a with SMTP id hi16-20020a17090b30d000b00213f1d8eb6amr3237464pjb.219.1668699641135;
        Thu, 17 Nov 2022 07:40:41 -0800 (PST)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b7-20020aa79507000000b0056bcfe015c9sm1252363pfp.204.2022.11.17.07.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 07:40:40 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH v5 net-next 1/3] net: axienet: Unexport and remove unused mdio functions
Date:   Thu, 17 Nov 2022 23:40:12 +0800
Message-Id: <20221117154014.1418834-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221117154014.1418834-1-andy.chiu@sifive.com>
References: <20221117154014.1418834-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both axienet_mdio_{enable/disable} functions are no longer used in
xilinx_axienet_main.c due to 253761a0e61b7. And axienet_mdio_disable is
not even used in the mdio.c. So unexport and remove them.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |  2 --
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c | 13 +------------
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 6370c447ac5c..575ff9de8985 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -611,8 +611,6 @@ static inline void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
 #endif /* CONFIG_64BIT */
 
 /* Function prototypes visible in xilinx_axienet_mdio.c for other files */
-int axienet_mdio_enable(struct axienet_local *lp);
-void axienet_mdio_disable(struct axienet_local *lp);
 int axienet_mdio_setup(struct axienet_local *lp);
 void axienet_mdio_teardown(struct axienet_local *lp);
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 0b3b6935c558..e1f51a071888 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -153,7 +153,7 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
  * Sets up the MDIO interface by initializing the MDIO clock and enabling the
  * MDIO interface in hardware.
  **/
-int axienet_mdio_enable(struct axienet_local *lp)
+static int axienet_mdio_enable(struct axienet_local *lp)
 {
 	u32 host_clock;
 
@@ -226,17 +226,6 @@ int axienet_mdio_enable(struct axienet_local *lp)
 	return axienet_mdio_wait_until_ready(lp);
 }
 
-/**
- * axienet_mdio_disable - MDIO hardware disable function
- * @lp:		Pointer to axienet local data structure.
- *
- * Disable the MDIO interface in hardware.
- **/
-void axienet_mdio_disable(struct axienet_local *lp)
-{
-	axienet_iow(lp, XAE_MDIO_MC_OFFSET, 0);
-}
-
 /**
  * axienet_mdio_setup - MDIO setup function
  * @lp:		Pointer to axienet local data structure.
-- 
2.36.0

