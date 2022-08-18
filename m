Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7DB5980C1
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237768AbiHRJXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiHRJXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:23:24 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC03A17E29
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 02:23:22 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id h5so1095798lfk.3
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 02:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=fy11hHSBfw6tbZCmF+XdaAcG07rNzd6gb9ZhcH1WlmA=;
        b=ldiGdAAiryOI+cUky1qB6f1OerYNGgnVBxIoHN2Twsx3f/9O5/Ym0btxUCu3sPbxS6
         jyLSpkuNzi3SusJw6pMHzWDmpRBH3Nb1ljAslPK1asaonrK16BHHWE+LcP0K8Qui9o1n
         bn7UgwL09eOP9zETyunsPdd9s6Y2x9DWq0tzfaiUXHj6KReq4VmnJX7AE+eezSi9Omjw
         YdFwpjVV2II/ICtpTg/truGD347UYcwL/Zntjr8JDBRxHEXDmCn6Vm0oF2NW7gR+Op3E
         sfnqFmLs2S9m74YTLbk6HaU15k8LxIdFC8hOg0FeEQ2xd175sHXACfaw7xATjJTEziYe
         mW7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=fy11hHSBfw6tbZCmF+XdaAcG07rNzd6gb9ZhcH1WlmA=;
        b=3ZiSdwjiRaAJKZAVxdwOUrvpq9epW+OGXioF8jHRGLnALR6MQTyAipaQeNhSAlNSxL
         KroHAchHD6p1TXUZMWAtBF1o2m21PhELJf7J8hzge2MHHqZLvrV9yWSvh70Q5O1H3hty
         qgPMrHPOBXUTzq+/ubDBS7RXzqXv0ppMtybvIG7+QFoXgy2brYcDSTUs5Urx9TVJOl+S
         zKBbxQF4+8u3pTohKIk/Xkavdn7FiTUKxuJ61N81SOHnQfaER6eJxL6gLM+GlTpKcOdA
         WOxgzCwlGUyplE8ztsRoSN8fsQf1BfqO5ElISmsRj4PoBn3/A/gEwSPFjKr7ZhvSmZd/
         E11A==
X-Gm-Message-State: ACgBeo0/CLZ2AEU7+er9sG7pL8ZrFwMNorTdQgPG49Yr3nYujGtQ29Az
        GyPvRel5l1iUqsvJdXd+4J6Z3j2+DmZQDsaS
X-Google-Smtp-Source: AA6agR74KQxf7MYFkW38aQvcgw3MtmNVZVV6nmB3HUj3bCKS1ycW/FADm2HdegA8/91Ai6vQ+w354A==
X-Received: by 2002:a05:6512:48d:b0:48b:1bee:6833 with SMTP id v13-20020a056512048d00b0048b1bee6833mr633919lfq.389.1660814601056;
        Thu, 18 Aug 2022 02:23:21 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:41e5:9890:65ed:5ae7])
        by smtp.gmail.com with ESMTPSA id t10-20020a056512208a00b0048aeff37812sm144472lfr.308.2022.08.18.02.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 02:23:20 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sergei Antonov <saproj@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Guobin Huang <huangguobin4@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v2] net: moxa: MAC address reading, generating, validity checking
Date:   Thu, 18 Aug 2022 12:23:17 +0300
Message-Id: <20220818092317.529557-1-saproj@gmail.com>
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

v1 -> v2:
Handle EPROBE_DEFER returned from platform_get_ethdev_address().
Move MAC reading code to the beginning of the probe function.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Vladimir Oltean <olteanv@gmail.com>
CC: Yang Yingliang <yangyingliang@huawei.com>
CC: Pavel Skripkin <paskripkin@gmail.com>
CC: Guobin Huang <huangguobin4@huawei.com>
CC: Yang Wei <yang.wei9@zte.com.cn>
CC: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index f11f1cb92025..402fea7505e6 100644
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
@@ -488,6 +482,14 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	}
 	ndev->base_addr = res->start;
 
+	// MAC address
+	ret = platform_get_ethdev_address(p_dev, ndev);
+	if (ret == -EPROBE_DEFER) // EEPROM has not probed yet?
+		goto init_fail;
+	if (ret)
+		eth_hw_addr_random(ndev);
+	moxart_update_mac_address(ndev);
+
 	spin_lock_init(&priv->txlock);
 
 	priv->tx_buf_size = TX_BUF_SIZE;
-- 
2.32.0

