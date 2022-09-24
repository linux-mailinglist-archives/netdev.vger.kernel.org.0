Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0E65E8715
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 03:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbiIXBxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 21:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbiIXBxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 21:53:47 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E4D106529;
        Fri, 23 Sep 2022 18:53:46 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id m9so1043090qvv.7;
        Fri, 23 Sep 2022 18:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=EMSKPlPuK4q/nTKtVAaS1LoKYLaCiDbMiUAnbQLl7/w=;
        b=PhXhgakoDqjO2sh84la5qnE8A+4MUk0IFBS3y4yqnl2OkknazWfOUEI4KpJZx2TqQ0
         m5W8GDSXd2QTEQu6XqvG9hYrk9nFR4bDv0IZC+E23nqHLLhvPUBJmQ7L2C7/AC2QBOtK
         jXun7++gEeHNCASaISR/8jthkY3Wy2tZqdyV2wom9KKrexyihVTYYmv7bM9tur3feRKm
         wFf9PxVZyo0V2SjVVhkkmPLnNS8HDrNgSYIMMlI3/2pgwjagHUoxEPx84W+udEto+lPS
         TYD9Crp5Bm+qLVSj1VPW1A3ztQdQnYneCEmWyMtbQGvQE482ZM7ObrnrTq/Q9uOe2zKp
         5AZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=EMSKPlPuK4q/nTKtVAaS1LoKYLaCiDbMiUAnbQLl7/w=;
        b=zDbI6sYsulBQ0kNXnk8HqMBJk+oTzzu+NE/iM+u0qGcWFtTqymLjwLK8bTbZUwdaNQ
         IIB3OEJrKo60cdKO6MxyiqYCQnXPkxpL/kwiezbIHLRFD/U9/logE+BFQAn1IxmpgIY6
         mRggE/AMNHNhhLgvAC06btXI6jaZBFM53XooXprJ8XcqDQQgQRKJYxD/bkz8Y3tCSeMx
         TC89ijjL+oe2C9MYylSy24QXwgBlpMdDp89P+5wykHia3Rfy9SW4YzkubZvBdL2+8e0s
         oOd9OT7AKm7mCITL4tI84pLdZPglLIT5XZkXuboK/peipWnBUwYsj7c0IGEKZ5CIgIbw
         7agQ==
X-Gm-Message-State: ACrzQf0xkFfEHt+p5+dkMDP+XRU+vHPL9+DO8UD/JwZNg3dGhk3Qwaaq
        PKDj+uKKLtRNAbi7yR/1tnc=
X-Google-Smtp-Source: AMsMyM5beK1ddavxGdhZSlhTuLFdyqfh1+8n68Ek1gQtSjQpfUh3sDmOnjv1GLEhZlEvGqJoFF0g5w==
X-Received: by 2002:a0c:a950:0:b0:4aa:e2ac:922a with SMTP id z16-20020a0ca950000000b004aae2ac922amr9301111qva.119.1663984425443;
        Fri, 23 Sep 2022 18:53:45 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id y26-20020a37f61a000000b006ceb933a9fesm6961864qkj.81.2022.09.23.18.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 18:53:44 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Zheyu Ma <zheyuma97@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v2 02/13] sunhme: Remove version
Date:   Fri, 23 Sep 2022 21:53:28 -0400
Message-Id: <20220924015339.1816744-3-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220924015339.1816744-1-seanga2@gmail.com>
References: <20220924015339.1816744-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Module versions are not very useful:

> The basic problem is, the version string does not identify the sources
> with enough accuracy. It says nothing about back ported fixes in
> stable kernels. It tells you nothing about vendor patches to the
> network core, etc.

https://lore.kernel.org/all/Yf6mtvA1zO7cdzr7@lunn.ch/

While we're at it, inline the author and use the driver name a bit more.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

(no changes since v1)

 drivers/net/ethernet/sun/sunhme.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 987f4c7338f5..7340d0f2ef93 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -61,15 +61,8 @@
 #include "sunhme.h"
 
 #define DRV_NAME	"sunhme"
-#define DRV_VERSION	"3.10"
-#define DRV_RELDATE	"August 26, 2008"
-#define DRV_AUTHOR	"David S. Miller (davem@davemloft.net)"
 
-static char version[] =
-	DRV_NAME ".c:v" DRV_VERSION " " DRV_RELDATE " " DRV_AUTHOR "\n";
-
-MODULE_VERSION(DRV_VERSION);
-MODULE_AUTHOR(DRV_AUTHOR);
+MODULE_AUTHOR("David S. Miller (davem@davemloft.net)");
 MODULE_DESCRIPTION("Sun HappyMealEthernet(HME) 10/100baseT ethernet driver");
 MODULE_LICENSE("GPL");
 
@@ -2451,8 +2444,7 @@ static void hme_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 {
 	struct happy_meal *hp = netdev_priv(dev);
 
-	strscpy(info->driver, "sunhme", sizeof(info->driver));
-	strscpy(info->version, "2.02", sizeof(info->version));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
 	if (hp->happy_flags & HFLAG_PCI) {
 		struct pci_dev *pdev = hp->happy_dev;
 		strscpy(info->bus_info, pci_name(pdev), sizeof(info->bus_info));
@@ -2488,8 +2480,6 @@ static const struct ethtool_ops hme_ethtool_ops = {
 	.set_link_ksettings	= hme_set_link_ksettings,
 };
 
-static int hme_version_printed;
-
 #ifdef CONFIG_SBUS
 /* Given a happy meal sbus device, find it's quattro parent.
  * If none exist, allocate and return a new one.
@@ -2973,9 +2963,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		goto err_out;
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
-	if (hme_version_printed++ == 0)
-		printk(KERN_INFO "%s", version);
-
 	hp = netdev_priv(dev);
 
 	hp->happy_dev = pdev;
-- 
2.37.1

