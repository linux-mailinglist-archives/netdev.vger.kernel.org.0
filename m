Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF24B5ADFAC
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbiIFGUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiIFGUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:20:37 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1AA222B9;
        Mon,  5 Sep 2022 23:20:37 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso13878018pjh.5;
        Mon, 05 Sep 2022 23:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=nGBVFgXS0eqoiY86MSD6T7/S6VN4vNYiYOjgs/oE4mY=;
        b=KyXRFDauk1axtxubltzu8BL+9pcdtxnAvJKf+Xw9R/aDIRKMEHXxUXHNyFcdP60sIO
         +3AtxKFVqBcoQH27ignZ39T5f7Y9tT3ze/AAQ/thdm0vLFaNBnNxQEaX78lCtjCGwwaz
         4BmDjwFL8PNJn8vW/YpYg0s+kmvpEiLMslNQgk5G8amP8+R7qzmXF/WBkx0xpIlrWJ/c
         xID8JpzAwaYSUgFc+RYodWx8A4EBque0dhLl/U1vmCKz0OIVNWArVOW2u7PYwana5ntt
         Pc0h2VD1ncsV7y+n273AlV0CieRr8fyqOCTynk9uzk+TquvyQDwMDLb6reEGou32+UxD
         hX/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=nGBVFgXS0eqoiY86MSD6T7/S6VN4vNYiYOjgs/oE4mY=;
        b=Wq1q9uf05ZQPXgGsl8yPkiS46qkYgYFUhb6z2rZo2f4uyfWzzRqaLsFKmKuPVAw/5b
         4GCmlOQnmIpsVkjDvgPTzStmUBAngBRGQFlZmZZ7yaL/Gdr68RmKmvUtuu3RLVAirGjm
         638era5eyWwKw+wz8IzsFtq23/gEMEOefj8gMMCgF+KQKKXqdeS04OxFm0de6VEd8TbY
         mmHnCji4tnYPiZDNVpRcTLv05PnpXB9WG7F1L9sXr+piRhPgI4wokC/qn3JjejGGGrXi
         xuwEkUbjqo18j8jiVFe5kfMl10rCxBlJw+uYZw/qrXLet+RP/KbBEsDvBlkD7X+QLHgs
         gNzg==
X-Gm-Message-State: ACgBeo0qx11Imza3w+M8xmJqATLiGDmBvs1VdRst0k+tA04YtDF0NUAf
        SHTUCnN1iAZ03CXiLrusVpE=
X-Google-Smtp-Source: AA6agR53PUca4ir2leHPUVovDvemsSXgnFsYiOcmz3zQdzyDkaeSkXfx+UaVJ9p02CUgb1p2FUTNjA==
X-Received: by 2002:a17:902:7845:b0:16e:d647:a66c with SMTP id e5-20020a170902784500b0016ed647a66cmr50876749pln.64.1662445236481;
        Mon, 05 Sep 2022 23:20:36 -0700 (PDT)
Received: from localhost.localdomain ([76.132.249.1])
        by smtp.gmail.com with ESMTPSA id m16-20020a170902db1000b00172dd10f64fsm8877798plx.263.2022.09.05.23.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 23:20:35 -0700 (PDT)
From:   rentao.bupt@gmail.com
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heyi Guo <guoheyi@linux.alibaba.com>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Liang He <windhl@126.com>, Hao Chen <chenhao288@hisilicon.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, Tao Ren <taoren@fb.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc:     Tao Ren <rentao.bupt@gmail.com>
Subject: [PATCH net-next v2 1/2] net: ftgmac100: support fixed link
Date:   Mon,  5 Sep 2022 23:20:25 -0700
Message-Id: <20220906062026.57169-2-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906062026.57169-1-rentao.bupt@gmail.com>
References: <20220906062026.57169-1-rentao.bupt@gmail.com>
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

From: Tao Ren <rentao.bupt@gmail.com>

Support fixed link in ftgmac100 driver. Fixed link is used on several
Meta OpenBMC platforms, such as Elbert (AST2620) and Wedge400 (AST2520).

Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 Changes in v2: None

 drivers/net/ethernet/faraday/ftgmac100.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 9277d5fb5052..da04beee5865 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1701,10 +1701,14 @@ static int ftgmac100_setup_mdio(struct net_device *netdev)
 
 static void ftgmac100_phy_disconnect(struct net_device *netdev)
 {
+	struct ftgmac100 *priv = netdev_priv(netdev);
+
 	if (!netdev->phydev)
 		return;
 
 	phy_disconnect(netdev->phydev);
+	if (of_phy_is_fixed_link(priv->dev->of_node))
+		of_phy_deregister_fixed_link(priv->dev->of_node);
 }
 
 static void ftgmac100_destroy_mdio(struct net_device *netdev)
@@ -1867,6 +1871,26 @@ static int ftgmac100_probe(struct platform_device *pdev)
 			err = -EINVAL;
 			goto err_phy_connect;
 		}
+	} else if (np && of_phy_is_fixed_link(np)) {
+		struct phy_device *phy;
+
+		err = of_phy_register_fixed_link(np);
+		if (err) {
+			dev_err(&pdev->dev, "Failed to register fixed PHY\n");
+			goto err_phy_connect;
+		}
+
+		phy = of_phy_get_and_connect(priv->netdev, np,
+					     &ftgmac100_adjust_link);
+		if (!phy) {
+			dev_err(&pdev->dev, "Failed to connect to fixed PHY\n");
+			of_phy_deregister_fixed_link(np);
+			err = -EINVAL;
+			goto err_phy_connect;
+		}
+
+		/* Display what we found */
+		phy_attached_info(phy);
 	} else if (np && of_get_property(np, "phy-handle", NULL)) {
 		struct phy_device *phy;
 
-- 
2.37.3

