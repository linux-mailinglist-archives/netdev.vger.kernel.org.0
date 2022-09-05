Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214EC5ADC10
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 01:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiIEX47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 19:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbiIEX45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 19:56:57 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33ED167156;
        Mon,  5 Sep 2022 16:56:55 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id c24so9119500pgg.11;
        Mon, 05 Sep 2022 16:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=HxSa1nifl/BjX4IHSZwDFpkRT1uZIgkAl2NNuJKauFc=;
        b=igHu4PgNQHWwp544lo/os2ZQ09E310HyxSJoqP/7Oo8TMGEf6ZlVucL7lBaJpcT0Yd
         EpZZUZubSRzixOsaWplXxMB9pxcJeD5cf6KOqO8FREFIGdDLaPzlQDnj9Y4yDvunkv98
         62ZZ8WmcVC44VFm3ayQxZOj0dcMzU4a2ijXT20A/OreUOFgCLzkyQqGFQhJuw24RIdTF
         y5hrVuJ/byp5Uw1pf3Ouhqx2t6vE6DzliOdrlTeIpPKlMBVSiI/4lfQ6GuJvytBf/NIo
         YcrgvnJpT7j9Xmzo6eoE2Se9U6vqmbwzjBO10AEq/lwxcq5Tu2JscuYck6CG5wqEgm4h
         Q5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=HxSa1nifl/BjX4IHSZwDFpkRT1uZIgkAl2NNuJKauFc=;
        b=st2KTSH2PxKHJUcBhvqFNS+lmWLBAqYX7B17jTjGZ8fu4U5xfRgzrBjWA/cODPIZ11
         TR2XZkIyEy/VmLtxu1ENLgNzDw2Fj1BPH/N+W6H3uqHUcmE8khx+sB8T9XFJQpMCQ4xT
         mWw//d9O0B6+M5OzVff7BelaYssW2NuX15TFZbM4VjhTu0IIJwz+QHJe12b8SSyYdIRM
         /9eP9DHNDkakwjdGilbNvpCh7Kdp4SCmhhx5LAgUfEFTLsYG7BotEAfzcCAKFy3+sgjV
         yrlh/IzssngCFGN6O2SH0cN73qHix417JwrzS7Afaxsh7d+sSlga8Y/FpKLWcT3tKxZC
         iZWQ==
X-Gm-Message-State: ACgBeo1q1CaMWtcgOi5enHQif4UhEG1gw/S9XfIOjsnMdna0WVdqFJsZ
        R94YdB/ILC3za4wnmfjaqi0=
X-Google-Smtp-Source: AA6agR6AalO/X1wxUzxRBt1wOQhvPR3J3uYbqv142JppgLbGvt7zZWNTHzEuMhAdTbmTglc7fVcY4Q==
X-Received: by 2002:aa7:9e12:0:b0:53e:27d8:b71b with SMTP id y18-20020aa79e12000000b0053e27d8b71bmr238339pfq.46.1662422213841;
        Mon, 05 Sep 2022 16:56:53 -0700 (PDT)
Received: from localhost.localdomain ([76.132.249.1])
        by smtp.gmail.com with ESMTPSA id g26-20020aa79dda000000b00537f13d217bsm8405530pfq.76.2022.09.05.16.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 16:56:53 -0700 (PDT)
From:   rentao.bupt@gmail.com
To:     "David S . Miller" <davem@davemloft.net>,
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
Subject: [PATCH net-next 1/2] net: ftgmac100: support fixed link
Date:   Mon,  5 Sep 2022 16:56:33 -0700
Message-Id: <20220905235634.20957-2-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220905235634.20957-1-rentao.bupt@gmail.com>
References: <20220905235634.20957-1-rentao.bupt@gmail.com>
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
---
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
2.30.2

