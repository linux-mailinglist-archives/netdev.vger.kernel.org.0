Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0753C5BC08C
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 01:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiIRX0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 19:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiIRX0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 19:26:34 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E644015FEE;
        Sun, 18 Sep 2022 16:26:32 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id s13so20746099qvq.10;
        Sun, 18 Sep 2022 16:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=f+EB9tqLDfuk22q0YdPsKDLRjPXinWklcbx8HraxOVo=;
        b=I2+xccWvrZ0XXRNZEQITFL2gQNhv4pJwsGkZzOhgnZ1qNYUG+tgOoYAD6QmoRjEXs4
         U9i6/ZMQnIuLzpXXCRNt9ozzsatN7H/6bwgCr/vSR77KtS7eLCDDX6/9rV3n04GOIxxa
         g/TrLrOrW1GXyaxTexrI6gJMnGbmTganmfgYLTpqW/fqruEUXzPrBWT7i5+gHkn+Y3Fw
         HOUdWxSkAKguN1hI8cjYc+OyJpDCrq+VfPAdfbjB95sd9QgrEFxt0f2ZhTICkFescMD6
         DE/mKWRz8mQgyGMuo8yMcirzZ3GNhdJJ7TwvcV6loxmnxDtnR8Es3MaZZJ5ZFF+Ab+hx
         PwxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=f+EB9tqLDfuk22q0YdPsKDLRjPXinWklcbx8HraxOVo=;
        b=VW51kJ/yr+3636WUDEEEw0xMGhBeobcd2WcHUeGwgH/SEb2yW4P8N5XzIz3MTG/fdR
         W1S6lF6NWIre/SgdD9eawUBiCTcPHWN0q97Ty6ZIf3sfm7NbthK+uFfPynKfj3fLnTKu
         XZ5xrbXZZ/I0ZCOCKzIYN5iwqaypqYKStHe6QuymRwpbOmxeQd9zqID5LGGlQ+VpCq7V
         Ed0eY3wzmm/b6lPnwVUGjsNVmTL+gmPaORMusBmp9D2luIgLyhaDrUizRzbwNMAVTUOw
         8AZCw3OcAdp2k3yUgBe6ysZR9GsJ0ccIcn6s3GeeNtNY+NoqYgSAhvnF9zxtv6aEC0D3
         cHlA==
X-Gm-Message-State: ACrzQf3XySCWdGiJyYck6iLD7I5wdOyO7s6rgnuKSXP3BdSkZy74GIov
        AMFW92Wt3MbwyrY6x0ELHXA=
X-Google-Smtp-Source: AMsMyM6bfOdqaOW1K2DcyF3MARq9SuQrZvAU6Vaf6Cc+JBM5haTVHrhRFCvmveQQ7VKwW5RYJX+EJQ==
X-Received: by 2002:ad4:5de2:0:b0:4ac:c356:2605 with SMTP id jn2-20020ad45de2000000b004acc3562605mr12950372qvb.50.1663543592143;
        Sun, 18 Sep 2022 16:26:32 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id bs22-20020ac86f16000000b0035cdd7a42d0sm3357339qtb.22.2022.09.18.16.26.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 16:26:31 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list),
        Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next 02/13] sunhme: Remove version
Date:   Sun, 18 Sep 2022 19:26:15 -0400
Message-Id: <20220918232626.1601885-3-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220918232626.1601885-1-seanga2@gmail.com>
References: <20220918232626.1601885-1-seanga2@gmail.com>
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

