Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D1262D1DB
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 04:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbiKQDsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 22:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbiKQDsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 22:48:03 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B13651C26
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:48:02 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id f3so874715pgc.2
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88tOeLPsWCVekBUY0oEIMvHJFlQGAI2IcuZIBKwXMgk=;
        b=c6HN5X8ogZXBT+emdZAw+GFFddJNv3Bdvc7jKF6XT+QOtIzqFzqLIsnN5JDQf9XxX1
         s4cEB7V1dC7Er++n6rCL/wO+FP5VAYkuxhMXoE/DSggfPWrq+yFZdMXEGxp5RlSSSADC
         U98HSRF9UNqoQj2pyI6GbYZXdNggdkKQCUzzFCXs3i/ziP78YVrzCQuKAiKs9DcWTkdQ
         BkceLRaUhrjvV7HWboucr+gHPOBNeb2KrmJ1FqhkQJltvkMKulkqKdTVay5YQA2AyYrG
         wN738GdVLm3NqMDszJ4H97RLw4citnKKAuTZvF2ZLU6cr5M159+4NKnyj7DFgifjk8KY
         uQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=88tOeLPsWCVekBUY0oEIMvHJFlQGAI2IcuZIBKwXMgk=;
        b=bMer6/xXql8GW+CW+8d0MADjOoWzvVRNo5PuqSGs0x9jJArPKQ1M+JTyHQkc4d3YqY
         hQEZok4GTkHVWNzOBYdqrib5j9SpbMXkIbKZ0gJPnFlT4P8DMiymIfyT4eYTiQehy7ww
         MRXA1F6viyJF6zXyQ63tR34vo/8iwKSDc2m0gUVIt++CuII70OpDvu9GKwqhkpkS4x+B
         Ze2iGFh3D0bzhRP23XA5c564dOx1569EmZkyobl+LA9LRDeQVD8TyKkqkiUIvkKl4MNX
         Ut/kA2pUe8xGZbvvOHt5d0M2FoQMJwxzsgYWJpZmozJQWQ4XF36JPp0al+zsFcF0R4da
         d6VQ==
X-Gm-Message-State: ANoB5pk0icR+SO6eExs7lNAHhBMhAznFIXXCTkufB2uwFDXA2ioQJf9j
        IKObKBfohSF3ThIaa43FyOqYLA==
X-Google-Smtp-Source: AA0mqf6UzanrSl30TKoAACSsgPmxqQlipIvSyZ6wJu4Pv8LLSXtFL11peF/jIFHvuEviKKwkT3eMpQ==
X-Received: by 2002:a63:1345:0:b0:476:f92f:69f0 with SMTP id 5-20020a631345000000b00476f92f69f0mr371235pgt.463.1668656881797;
        Wed, 16 Nov 2022 19:48:01 -0800 (PST)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id p22-20020a1709027ed600b00187197c499asm13016723plb.164.2022.11.16.19.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 19:48:01 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH v4 net-next 1/3] net: axienet: Unexport and remove unused mdio functions
Date:   Thu, 17 Nov 2022 11:47:49 +0800
Message-Id: <20221117034751.1347105-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221117034751.1347105-1-andy.chiu@sifive.com>
References: <20221117034751.1347105-1-andy.chiu@sifive.com>
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

Both axienet_mdio_enable functions are no longer used in
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

