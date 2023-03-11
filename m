Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31116B5FA8
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 19:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjCKSTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 13:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjCKST1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 13:19:27 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C805CC2E;
        Sat, 11 Mar 2023 10:19:16 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id r5so9301201qtp.4;
        Sat, 11 Mar 2023 10:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678558756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mzdNsG1rNrrudv1+HkYMVo34HG6M5gxJ8aIACXWrtpI=;
        b=kRwWWNqq5zcNDMgbAXYHz9WG0t1PP3AHNvaltDwBueLvW6K/fX/vZB+c7bX0uTHT4y
         Ya2WTq1nVC8S9OL8ARt6UoddgB8BPpYdo4rCHuUkmuVZhpz3a25TFCW5gga0M6zXCbgd
         khnh1ZzjCUOgunUxiuIp3O+8XtY1Ij5UTS9XbnuOHqYQyCLXazZ2tbUid6QkrBOYKiAI
         UEbvDDazq6TYnkc+wWDG2oJFhcR7u5SIDAgAPbmh33Jgi82/l4MgZuWshTOvhr2F20Os
         FYOno78b5ARYWUOvzuG12iNvcskn3AH9p5cYO+jfqBmy2Phk4sFkzeNIRhbmUqpu1QhF
         C9uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678558756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mzdNsG1rNrrudv1+HkYMVo34HG6M5gxJ8aIACXWrtpI=;
        b=pqSUY3/artA8YaagfHsNefEBdKCS1/vJez1KjoevxBSt0kmO8l85RcxCKuvd0hTz0y
         mxPtfym0MxjVEblbIQOuGBPKLycFdUw1pvxLYafhre9woiOE78j1sHa9ypPNrX0ccFMX
         fjHb2ZUuoAgo+GsUbe34T1vd89acNjUdPx1T0guBs1j6HGP52EQWJHvwqjwVxGlBL0qg
         dX4ynmizOMLTwfaH7o/0aRNqY4pk5QcXuJt+SZJPMS4mnWrfUNfMO8ZzF9vRF+efZAs8
         P64GQS+OYoxl/dFbEvuE5ensDfzhYSk8eYb8sQiUaxfZxAjWuW9dCXrPIoh3g5z0x5Rh
         poFQ==
X-Gm-Message-State: AO0yUKXxHrHlt+hHwPLOqLeuC7BN8K2ixIHL1B/oZ44yKVRAMf1w78wH
        HFN9l2NZ1mXPBtQd2Ud0/Ec=
X-Google-Smtp-Source: AK7set/rGMbVeek9jcpmmr1JPuIuZpU4/MHKuIPa6znZGTvkvJHdiatxkpfiGNXNKTbow42sY85lRQ==
X-Received: by 2002:ac8:5a85:0:b0:3b6:35a2:bb04 with SMTP id c5-20020ac85a85000000b003b635a2bb04mr53435023qtc.7.1678558755744;
        Sat, 11 Mar 2023 10:19:15 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id i3-20020a37b803000000b007424239e4casm2162147qkf.117.2023.03.11.10.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 10:19:15 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v2 7/9] net: sunhme: Clean up mac address init
Date:   Sat, 11 Mar 2023 13:19:03 -0500
Message-Id: <20230311181905.3593904-8-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230311181905.3593904-1-seanga2@gmail.com>
References: <20230311181905.3593904-1-seanga2@gmail.com>
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

Clean up some oddities suggested during review.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

Changes in v2:
- New

 drivers/net/ethernet/sun/sunhme.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index c4280bce69d4..41b2f941c607 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2348,9 +2348,7 @@ static int find_eth_addr_in_vpd(void __iomem *rom_base, int len, int index, unsi
 		p += 6;
 
 		if (index == 0) {
-			int i;
-
-			for (i = 0; i < 6; i++)
+			for (int i = 0; i < 6; i++)
 				dev_addr[i] = readb(p + i);
 			return 1;
 		}
@@ -2362,9 +2360,10 @@ static int find_eth_addr_in_vpd(void __iomem *rom_base, int len, int index, unsi
 static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
 						unsigned char *dev_addr)
 {
+	void __iomem *p;
 	size_t size;
-	void __iomem *p = pci_map_rom(pdev, &size);
 
+	p = pci_map_rom(pdev, &size);
 	if (p) {
 		int index = 0;
 		int found;
@@ -2386,7 +2385,7 @@ static void __maybe_unused get_hme_mac_nonsparc(struct pci_dev *pdev,
 	dev_addr[2] = 0x20;
 	get_random_bytes(&dev_addr[3], 3);
 }
-#endif /* !(CONFIG_SPARC) */
+#endif
 
 static void happy_meal_addr_init(struct happy_meal *hp,
 				 struct device_node *dp, int qfe_slot)
-- 
2.37.1

