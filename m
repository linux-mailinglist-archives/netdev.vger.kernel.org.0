Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3B75974CC
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240823AbiHQRKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238027AbiHQRKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:10:49 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FA55F232
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:10:48 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id s7so1213209lfp.8
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Tt3SMn9xWBxbQX4178ZI7fRYIosUYJ3XuivsaIGvKbc=;
        b=jb+aEXbf2AuyvFP8MPGcKmk0eUVQZoGvVjreKxiSfOpEt+aqrMx4dCn73O5AMRmPM8
         zJIIVa0wjw5pY3U+VEjHbflY7wkzcU4homcXoiZhLTJ0TUXR5y21GcHHU32PXo6+RiTs
         dXBRwEu9cmoelL283lxVYeSfCpjxLvetZZGvf9y+QfD4/4ZlKwYp5jGdeZ4sgQlmFn4t
         Tv8H3/QPh6jlP2WhHl1NMWJ0b7jsE8rdIj0AJo90VWTlwdSj7lTuy0Am5SCTpbutts3m
         KwurcgpgKjaMqIQht2YyAWYZJSWfDjKESMlZw7MaQ7Ej5XGT4dat+pJd6zJ6VUS7GUKz
         BEcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Tt3SMn9xWBxbQX4178ZI7fRYIosUYJ3XuivsaIGvKbc=;
        b=6nGBw6DnpdCt/Uk3AjAQSkZYVxaqFhSpMxMYAFTcQJdopIsKfiKCU42a4Y0S6a3JRf
         n3FI4Q7WiEvjYiKezBoGQMyGus5Lhq19MvOp8VOpW49s09xgNC4DZluJ5uvZ5fbtbYXB
         6pkRcQg78seYnbjIijWrVOqIn5mlTvBeW1rQ4lLfFIyNFOVVQ7idvmDCUXNrsQJlXqwt
         /mrtmeXzc7q2HsspnpNM3JAR2KU78AYfORV/3CkHsaARZrbGuAGU+rfK4qDW7WYXqURR
         tL/IAg9KgHursRnaHXqppedfC7cRNE8j5ZAQKlBtuAzUwV9h93prhYM6PV8HoO7z3Zao
         riNQ==
X-Gm-Message-State: ACgBeo2svF9lq7+BRU/WAzD91Ce/B7W3JG8c3U+EFUT6yWFbJ0eHjfd1
        dlW3apwR+Zdbzo3FENUA1C+1UkTK0Ac/ygm0
X-Google-Smtp-Source: AA6agR5UAiOk5pVpfYmVKc30LgGNnWqakZ9MZ1tkypCfX+crWd7LshzKLLKVo+A4m8aST69k3RppuQ==
X-Received: by 2002:a05:6512:3f02:b0:48d:244e:426f with SMTP id y2-20020a0565123f0200b0048d244e426fmr8621109lfa.333.1660756246519;
        Wed, 17 Aug 2022 10:10:46 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:ba73:df3b:abc6:7f1c])
        by smtp.gmail.com with ESMTPSA id s27-20020a056512203b00b0048b4690c78esm1746482lfs.288.2022.08.17.10.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 10:10:46 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sergei Antonov <saproj@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: moxa: MAC address reading, generating, validity checking
Date:   Wed, 17 Aug 2022 20:10:43 +0300
Message-Id: <20220817171043.459267-1-saproj@gmail.com>
X-Mailer: git-send-email 2.32.0
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

This device does not remember its MAC address, so add a possibility
to get it from the platform. If it fails, generate a random address.
This will provide a MAC address early during boot without user space
being involved.

Also remove extra calls to is_valid_ether_addr().

Made after suggestions by Andrew Lunn:
1) Use eth_hw_addr_random() to assign a random MAC address during probe.
2) Remove is_valid_ether_addr() from moxart_mac_open()
3) Add a call to platform_get_ethdev_address() during probe
4) Remove is_valid_ether_addr() from moxart_set_mac_address(). The core does this

Signed-off-by: Sergei Antonov <saproj@gmail.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Vladimir Oltean <olteanv@gmail.com>
CC: Yang Yingliang <yangyingliang@huawei.com>
CC: Pavel Skripkin <paskripkin@gmail.com>
CC: Yang Wei <yang.wei9@zte.com.cn>
CC: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index f11f1cb92025..7b11efe629a5 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -62,9 +62,6 @@ static int moxart_set_mac_address(struct net_device *ndev, void *addr)
 {
 	struct sockaddr *address = addr;
 
-	if (!is_valid_ether_addr(address->sa_data))
-		return -EADDRNOTAVAIL;
-
 	eth_hw_addr_set(ndev, address->sa_data);
 	moxart_update_mac_address(ndev);
 
@@ -172,9 +169,6 @@ static int moxart_mac_open(struct net_device *ndev)
 {
 	struct moxart_mac_priv_t *priv = netdev_priv(ndev);
 
-	if (!is_valid_ether_addr(ndev->dev_addr))
-		return -EADDRNOTAVAIL;
-
 	napi_enable(&priv->napi);
 
 	moxart_mac_reset(ndev);
@@ -539,6 +533,11 @@ static int moxart_mac_probe(struct platform_device *pdev)
 
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
+	ret = platform_get_ethdev_address(p_dev, ndev);
+	if (ret)
+		eth_hw_addr_random(ndev);
+	moxart_update_mac_address(ndev);
+
 	ret = register_netdev(ndev);
 	if (ret)
 		goto init_fail;
-- 
2.32.0

