Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D195E5AFBE0
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 07:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiIGFpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 01:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiIGFpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 01:45:05 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DE131378;
        Tue,  6 Sep 2022 22:45:02 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id l65so13542774pfl.8;
        Tue, 06 Sep 2022 22:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=vc+9lhZdvHGipmJiQR19DK5It5RgAjYlDgcsNDiBYQ0=;
        b=EM8MHwat55nL4Wjn4+ya6MxNTraM9ElIKbCMnpkCgyrNM7kPFcj2J4e2SlrDK5a/U2
         1AmHYLeIRJP/eopqpa6mzwjvFjOfyVd9l4zP5lPBh69ZCn6YF5zUTclM8HqcAOedibJ7
         TkLDCP1+ZzTxIH4gGugzDDozIcU5CJnqmFhfMWdIR1Wgjg/KvCtBsMjnm+Edhap8ee5a
         R5jaNIKv2Jy7yRfFFBgadZVSKI01j3aM5I7iiSRwanDfC19uG/z8P1wGRO3ST1XkTNi/
         0tLEvLiH1ZyLYOfyjtSzjkkdzPNvFozpLWVowbrxgJTHkOWiAhAFDvNsqaFDdkFLAi2r
         dnVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vc+9lhZdvHGipmJiQR19DK5It5RgAjYlDgcsNDiBYQ0=;
        b=N7QK9mrEymVwZCkaVhQk7ghvCTRx2K6B1UD0MjGtUGahiphn2uAjXk3lauW6bTduI4
         RqCNpw0AtIaJ4S7dUdF7vskvU+lVudKBuPmERS46utN5uok9hGbSC/38x21Vq6zF14+2
         tvgl/bhQJ/CZBbl+1tLkxmZLTyKI4ueaNVlhUDzF1nBhSFqz25AlyT/Xx3urSzsD1gdK
         tKkrb8q6CyTtX5fh8SsHJiVbLiAvnrwR2EWLOjk01wnYh2I9iKkNLHhtqeadgRhxEbTf
         +16IKXh46UQ8QLZ/dEIePcLP1IPfb0J0NiR8T+FpLNDZma2vhyfiYqgQPiWmk5DmERuA
         wpzw==
X-Gm-Message-State: ACgBeo0Kl/fzTdGDoutsyxT054j6qtH41QQWbu8K+P5tbUBr7QwP1g1h
        zcAUASrNy6BDfhEqs/O3fQM=
X-Google-Smtp-Source: AA6agR64WB1uKVsnb83+o3qiFDrgAfqg4TmB3M18AMQi1RgPJhea91VyXpDVcMspPl4mWCNRguOWow==
X-Received: by 2002:a63:c003:0:b0:434:dd62:18e1 with SMTP id h3-20020a63c003000000b00434dd6218e1mr2020043pgg.53.1662529502321;
        Tue, 06 Sep 2022 22:45:02 -0700 (PDT)
Received: from localhost.localdomain ([76.132.249.1])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902d50200b0016c0c82e85csm11222798plg.75.2022.09.06.22.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 22:45:01 -0700 (PDT)
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
Subject: [PATCH net-next v3 1/2] net: ftgmac100: support fixed link
Date:   Tue,  6 Sep 2022 22:44:52 -0700
Message-Id: <20220907054453.20016-2-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220907054453.20016-1-rentao.bupt@gmail.com>
References: <20220907054453.20016-1-rentao.bupt@gmail.com>
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
 Changes in v3: None
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

