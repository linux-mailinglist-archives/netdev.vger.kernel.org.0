Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFD756C552
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiGHX5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 19:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGHX5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 19:57:36 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6C664E0C
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 16:57:35 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id y18so205694ljj.6
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 16:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OFSi/uBs6fvaK9vnGi6KJaQNfAg8IioYRv9G9NO6zoo=;
        b=dwqOpDQ+p9U7LQ04UOpLa3Si2eRPblF0fpvP0oHeQC0pF357qu2S4UBXkM7xMs6l3f
         dBxzhnuFv089bKSkmiBIvdLmHMbQYr1g++qZA5WGZEJR8F4fgWLZdUgJdl318K5Krsu9
         e/SnRk2rGgNoz5qTtHwnSj3J4CzuVU5v7GVmaryp+ajmtgxovrQZ4zCCi9Z9VatLlpez
         bR1Z9DhtEUTzXuo7KBbFJBUl/lM+xEqlpwMN/iUvajw3VZXf1z5l1ASvoG34qmmhv+dC
         FT+Klmw05gzDZcM7JVCMNxVjkcS15QKxxNM/O3i6QFCojP7qc3x2U9FW3AjBJyv/1xZt
         a9eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OFSi/uBs6fvaK9vnGi6KJaQNfAg8IioYRv9G9NO6zoo=;
        b=3Bt7Qg3tAL2QDTbI2YryadBJ1F9yxsSkw7hOz+ZecZjznstn28S4CmBGQBT7optgCh
         vzQ6T8AhYTYbCwNXEb+NWiRhzzsUNO3Ii4348jrfIbgW/oR0QEEXcJsSl0rnXTRa9Ayc
         TvuiUcRPrXZ4hH9ER+QV7abAggYlK8Y/nO+qzsVBXXGMsgotWTv6420/aj0Hlfu0KpkT
         xUmM90VC+OXj7PU1pLArnHnkhwY1Os3bG0jIXzH2Wu1U6kxn3BbFiGTeujKWeITsHeUn
         h2bwluedMW6FDoRRcih4lIgpWSD52cIyjsIoOjNSQ0jSRi4ac9v0AGZ07gN1XiHQr/ZD
         ZlTA==
X-Gm-Message-State: AJIora8TVBuKNVnPsBCYPPb6HTRVlR8zQoWqXFAAl4EHvuL85st9vyER
        71xdOA5hqOeqFmMkT/pj+ySwcO4zyISlBg==
X-Google-Smtp-Source: AGRyM1ukm8iHdECyzQLSPbFeD7cvE0cT7sQN/s+WCR6oGlxRaAOncDrUr8lbZgsptV3mPl2757jyeQ==
X-Received: by 2002:a2e:9bc2:0:b0:25d:53a9:65e1 with SMTP id w2-20020a2e9bc2000000b0025d53a965e1mr3435240ljj.158.1657324653769;
        Fri, 08 Jul 2022 16:57:33 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id s25-20020a056512203900b0047f6b4a53cdsm71603lfs.172.2022.07.08.16.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 16:57:33 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 1/2] ixp4xx_eth: Fall back to random MAC address
Date:   Sat,  9 Jul 2022 01:55:29 +0200
Message-Id: <20220708235530.1099185-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the firmware does not provide a MAC address to the driver,
fall back to generating a random MAC address.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 89770c2e0ffb..a5d1d8d12064 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1487,7 +1487,10 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	port->plat = plat;
 	npe_port_tab[NPE_ID(port->id)] = port;
-	eth_hw_addr_set(ndev, plat->hwaddr);
+	if (is_valid_ether_addr(plat->hwaddr))
+		eth_hw_addr_set(ndev, plat->hwaddr);
+	else
+		eth_hw_addr_random(ndev);
 
 	platform_set_drvdata(pdev, ndev);
 
-- 
2.36.1

