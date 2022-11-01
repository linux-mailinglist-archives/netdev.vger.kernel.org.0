Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A81F614288
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 02:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiKABCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 21:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiKABB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 21:01:58 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB5F15FF0
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 18:01:57 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s196so12148362pgs.3
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 18:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nKK8zgxJDxmHrqaFmkJ3vFtzjdbdmPcZFfepc/ywGK4=;
        b=gpQo86TGe8qxzpefyPW85RKyFkniP4RwoGFdUWmgvZ+8NRgJM7XwOWSLH1wv26pR5P
         GQSWpkt8pV0/Dp8u3QRz9CalvONObooWFOzGHKq4nFQZZRZBWFCASqfPYWHy+4ROmZE2
         isR6tX+N3kDLg8cyHAh3E0wgXmG3grxNbrCOxzFGKni6ALmcJMTNcShtpQVV/8MwUCql
         53FEfXQhp0paqnCKa0B2hNOEE0o6114Vrg+b/dmRuwoezglh9/wwRnH5kL1HNylxNJ6M
         bE0Rg6nIo48Kqu/HHj3aLZqHes7+InNAhqOt6Zn1qTAfspEZCuNiTvvfRkcROKaNmVbH
         quVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nKK8zgxJDxmHrqaFmkJ3vFtzjdbdmPcZFfepc/ywGK4=;
        b=GHWyig0tC4BNL2SWHwX8pn06PgHcRt+9T2ELt/FF/6EvXZjKEwo8PLZ2gDkANCVMpN
         XZ4q+p9YEKySWlx0e40HJUm+oFXjP3fKTMskUe82wEC17sMK6/14oDp1UjcqE9410gWr
         iPB82hoLQjCedX/BkBotmISGsokanAV/WAAzOpI5XDqePz56UZsmHOHQemb4su+QrFIP
         igoV1Em++sBOGnxnO+neITsZvHZtadZsnAlbkdddQl9XbsTBs2sVjvGfGk7AO9PHbLg+
         XqJNHQCfy1EWnse1uJeLsxWRimkJTMWgeYpx96eA51ecQkV8YJbGPDJd8K94aTMKC8BS
         RkKg==
X-Gm-Message-State: ACrzQf0sHIyQyoEL5H0pEvX4iJgty3a/BcaRMRqhO0m1OuIFV1RUjtou
        Hp7RwHTD8aZ1H8So9ntH58Hyvw==
X-Google-Smtp-Source: AMsMyM7GSQ6+in0gJC2uUlOtdOXbqJ4twCOsmuQrpv1n85ntFVH4bYGWff/v2AlyqN8VHLoN6v5s3g==
X-Received: by 2002:a63:205f:0:b0:46e:f589:6096 with SMTP id r31-20020a63205f000000b0046ef5896096mr14681144pgm.622.1667264516816;
        Mon, 31 Oct 2022 18:01:56 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id a16-20020aa794b0000000b005627d995a36sm5221920pfl.44.2022.10.31.18.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 18:01:56 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH v2 net-next 1/3] net: axienet: Unexport and remove unused mdio functions
Date:   Tue,  1 Nov 2022 09:01:45 +0800
Message-Id: <20221101010146.900008-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221101010146.900008-1-andy.chiu@sifive.com>
References: <20221101010146.900008-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both axienet_mdio_enable functions are no longer used in
xilinx_axienet_main.c due to 253761a0e61b7. And axienet_mdio_disable is
not even used in the mdio.c. So unexport and remove them.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
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

